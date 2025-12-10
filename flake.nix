{
  description = "Campus-back development environment with PostgreSQL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # PostgreSQL configuration
        pgData = ".pgdata";
        pgPort = "5432";
        
        # Startup script for PostgreSQL
        startPostgres = pkgs.writeShellScriptBin "start-postgres" ''
          set -e
          
          # Socket directory in project
          SOCKET_DIR="$(pwd)/.pgdata/sockets"
          
          # Check if database is initialized
          if [ ! -f "${pgData}/PG_VERSION" ]; then
            echo "Initializing PostgreSQL database..."
            initdb -D ${pgData} --no-locale --encoding=UTF8
            mkdir -p "$SOCKET_DIR"
            echo "host all all 127.0.0.1/32 md5" >> ${pgData}/pg_hba.conf
            echo "listen_addresses = 'localhost'" >> ${pgData}/postgresql.conf
            echo "port = ${pgPort}" >> ${pgData}/postgresql.conf
            echo "unix_socket_directories = '$SOCKET_DIR'" >> ${pgData}/postgresql.conf
          fi
          
          # Ensure socket directory exists
          mkdir -p "$SOCKET_DIR"
          
          if pg_ctl -D ${pgData} status > /dev/null 2>&1; then
            echo "PostgreSQL is already running"
          else
            echo "Starting PostgreSQL..."
            pg_ctl -D ${pgData} -l ${pgData}/logfile -o "-k $SOCKET_DIR" start
            sleep 2
            
            # Create postgres superuser if it doesn't exist
            if ! psql -h localhost -U $USER -d postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='postgres'" 2>/dev/null | grep -q 1; then
              echo "Creating postgres user..."
              createuser -h localhost -s postgres
              psql -h localhost -U $USER postgres -c "ALTER USER postgres PASSWORD 'postgres';"
            fi
            
            echo "PostgreSQL is running on port ${pgPort}"
            echo "Socket directory: $SOCKET_DIR"
          fi
        '';
        
        # Stop script for PostgreSQL
        stopPostgres = pkgs.writeShellScriptBin "stop-postgres" ''
          if [ -d "${pgData}" ]; then
            echo "Stopping PostgreSQL..."
            pg_ctl -D ${pgData} stop
          else
            echo "PostgreSQL data directory not found"
          fi
        '';
        
        # Status script for PostgreSQL
        statusPostgres = pkgs.writeShellScriptBin "status-postgres" ''
          if [ -d "${pgData}" ]; then
            pg_ctl -D ${pgData} status
          else
            echo "PostgreSQL not initialized. Run 'start-postgres' first."
          fi
        '';
        
        # Reset script for PostgreSQL
        resetPostgres = pkgs.writeShellScriptBin "reset-postgres" ''
          echo "Stopping PostgreSQL..."
          pg_ctl -D ${pgData} stop 2>/dev/null || true
          echo "Removing PostgreSQL data directory..."
          rm -rf ${pgData}
          echo "PostgreSQL has been reset. Run 'start-postgres' to reinitialize."
        '';
        
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_20
            postgresql
            startPostgres
            stopPostgres
            statusPostgres
            resetPostgres
          ];
          
          shellHook = ''
            echo "======================================"
            echo "Campus-back Development Environment"
            echo "======================================"
            echo ""
            echo "Available commands:"
            echo "  start-postgres   - Initialize and start PostgreSQL"
            echo "  stop-postgres    - Stop PostgreSQL"
            echo "  status-postgres  - Check PostgreSQL status"
            echo "  reset-postgres   - Reset PostgreSQL (deletes all data)"
            echo ""
            echo "  npm install      - Install Node.js dependencies"
            echo "  npm run dev      - Start development server"
            echo "  npm start        - Start production server"
            echo ""
            echo "PostgreSQL configuration:"
            echo "  Database: starter-server"
            echo "  User: postgres"
            echo "  Password: postgres"
            echo "  Host: localhost"
            echo "  Port: ${pgPort}"
            echo ""
            echo "To get started:"
            echo "  1. start-postgres"
            echo "  2. npm install"
            echo "  3. npm run dev"
            echo "======================================"
          '';
          
          # Environment variables
          PGDATA = pgData;
          PGPORT = pgPort;
        };
      }
    );
}
