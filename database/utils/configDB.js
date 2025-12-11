/*==================================================
/database/utils/configDB.js

Configuration for local PostgreSQL connection.
==================================================*/

// Set local database name and credentials
const dbName = 'campus_db';         // The database you just created
const dbUser = 'postgres';          // Your Postgres username
const dbPwd = 'Chris2004!';  // Replace with the password you used in psql

// Export variables
module.exports = {
  dbName,
  dbUser,
  dbPwd
};
