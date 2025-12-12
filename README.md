[GitHub - belovedEmperor/Campus-front](https://github.com/belovedEmperor/Campus-front)
[GitHub - belovedEmperor/Campus-back](https://github.com/belovedEmperor/Campus-back)

Team Members: Cheng Yue (username: CY343), Christopher Altamirano (username: caltam600), and Jason Huang (username: belovedEmperor)

## Documentation
### Feature Requirements
#### Database Schema & Models
*   **Campus Model**
    *   **`name`**: String, Not Null, Not Empty.
    *   **`imageUrl`**: String, Default value required (use a placeholder URL).
    *   **`address`**: String, Not Null, Not Empty.
    *   **`description`**: Text (Large String), Description can be large.
*   **Student Model**
    *   **`firstName`**: String, Not Null, Not Empty.
    *   **`lastName`**: String, Not Null, Not Empty.
    *   **`email`**: String, Not Null, Not Empty.
    *   **`imageUrl`**: String, Default value required.
    *   **`gpa`**: Decimal, Range: 0.0 - 4.0.
*   **Associations**
    *   **One-to-Many**: A Campus can have many Students.
    *   **Belongs-To**: A Student belongs to at most one Campus.
    *   *Constraint:* If a Campus is deleted, its students should **not** be deleted (their `campusId` should become `null`).
#### API Endpoints (RESTful Routes)
- **Campuses (`/api/campuses`)**
    *   `GET /` : Fetch all campuses.
    *   `GET /:id` : Fetch a single campus **including** its list of enrolled students.
    *   `POST /` : Create a new campus.
    *   `PUT /:id` : Update an existing campus.
    *   `DELETE /:id` : Delete a campus.
- **Students (`/api/students`)**
    *   `GET /` : Fetch all students.
    *   `GET /:id` : Fetch a single student **including** their associated campus.
    *   `POST /` : Create a new student.
    *   `PUT /:id` : Update an existing student.
    *   `DELETE /:id` : Delete a student.
#### Pages & Views
*   **Home Page**: A landing page with links to "All Campuses" and "All Students".
*   **All Campuses View**:
    *   Display all campuses (Name + Image).
    *   If no campuses exist, display a clear message ("No campuses registered").
    *   "X" button on each campus card to delete it.
    *   "Add Campus" button to navigate to the form.
*   **Single Campus View**:
    *   Display full details: Name, Image, Address, Description.
    *   List all students enrolled at this campus.
    *   If no students are enrolled, display "No students enrolled".
    *   Buttons to **Edit** or **Delete** the campus.
*   **All Students View**:
    *   Display all students (Name + Image).
    *   If no students exist, display "No students registered".
    *   "X" button on each student card to delete them.
    *   "Add Student" button.
*   **Single Student View**:
    *   Display full details: Name, Email, GPA, Image.
    *   Display the **Name of the Campus** they attend (clickable link to that Campus).
    *   If not enrolled, display "Not enrolled in any campus".
    *   Buttons to **Edit** or **Delete** the student.
#### Forms & Interactivity
*   **Add/Edit Campus Form**:
    *   Fields: Name, Address, Description, Image URL.
    *   **Validation**: Prevent submission if Name or Address is empty.
*   **Add/Edit Student Form**:
    *   Fields: First Name, Last Name, Email, GPA, Image URL, Campus ID (Select/Dropdown).
    *   **Validation**: Prevent submission if required fields are empty. Ensure GPA is numeric (0.0 - 4.0).
*   **Real-time Updates**: When an item is deleted or added, the view should update immediately (via state change) without requiring a manual page refresh.

### Application Architecture Description and Diagram
The frontend uses React Router to navigate between pages:
- `HomePage` - Root page with links to all other sections
- `AllCampuses` - Displays all campuses with delete functionality
- `Campus` - Shows individual campus details
- `AllStudents` - Displays all students with delete functionality  
- `Student` - Shows individual student details
- `NewCampus` - Form to add a new campus
- `EditCampus` - Form to edit existing campus
- `NewStudent` - Form to add a new student
- `EditStudent` - Form to edit existing student
All pages include a Header component with navigation links.

Uses Redux with Redux Thunk for async operations.
The store manages four slices:
- `allCampuses` - List of all campuses
- `campus` - Single campus data
- `allStudents` - List of all students  
- `student` - Single student data

Each page uses a `Container` component for logic/data fetching and a `View` component for presentation.
Containers connect to Redux via `mapState` and `mapDispatch`, fetching data on mount using thunks.

The backend provides RESTful API routes at `/api/students` and `/api/campuses` with full CRUD operations.
Uses Sequelize ORM with PostgreSQL for database management.

Containers dispatch thunks → Thunks call backend API via Axios → Actions update Redux store → View components re-render with new props.

<img width="1287" height="611" alt="image" src="https://github.com/user-attachments/assets/276ee597-49a7-4981-9a24-04707c461946" />

### Epics, User Stories, and Acceptance Criteria
#### **Epic: Navigation & Home**
1.  **Navigation Bar**
    *   *User Story:* As a user, I want a permanent navigation bar so I can easily switch between Home, Campuses, and Students at any time.
2.  **Home Page**
    *   *User Story:* As a user, I want a welcoming landing page that directs me where to go.
#### **Epic: Campus Management**
3.  **View All Campuses**
    *   *User Story:* As a user, I want to see all campuses so I can browse the university network.
    *   *Acceptance Criteria:*
        *   Displays Name and Image.
        *   Clicking a campus navigates to the Single Campus View.
        *   Shows "No campuses" if the database is empty.
    *   *Backend:* `GET /api/campuses` returns an array of all campus objects.
4.  **View Single Campus**
    *   *User Story:* As a user, I want to see detailed information about a campus and who goes there.
    *   *Acceptance Criteria:*
        *   Shows Address and Description.
        *   Lists students enrolled (clickable links to Student Profiles).
        *   If no students are enrolled, display "No students enrolled".
    *   *Backend:* `GET /api/campuses/:id` returns campus metadata AND an array of associated students.
5.  **Add Campus**
    *   *User Story:* As a user, I want to add a new campus to the system.
    *   *Acceptance Criteria:*
        *   Form validates that Name and Address are present.
        *   On submit, redirects to the new Campus's page or the All Campuses view.
    *   *Backend:* `POST /api/campuses` accepts `name`, `address`, etc., validates they aren't empty, and saves to DB.
6.  **Edit Campus**
    *   *User Story:* As a user, I want to update campus details (like address or description).
    *   *Acceptance Criteria:*
        *   Form pre-fills with existing data.
        *   Changes are reflected immediately after saving.
    *   *Backend:* `PUT /api/campuses/:id` updates the attributes of a specific campus.
7.  **Delete Campus**
    *   *User Story:* As a user, I want to remove a campus that no longer exists.
    *   *Acceptance Criteria:*
        *   Each campus in the "All Campuses" view has a delete button (e.g., an 'X' icon).
        *   Clicking it removes the campus from the screen and database.
    *   *Backend:* `DELETE /api/campuses/:id` ensures associated students become "unassigned" (campusId = null) rather than being deleted.
#### **Epic: Student Management**
8.  **View All Students**
    *   *User Story:* As a user, I want to see a list of all students registered in the system.
    *   *Acceptance Criteria:*
        *   Displays Name and Image.
        *   Clicking a student navigates to the Single Student View.
        *   Shows "No students" if the database is empty.
    *   *Backend:* `GET /api/students` returns an array of all student objects.
9.  **View Single Student**
    *   *User Story:* As a user, I want to view a student's profile, including their GPA and which campus they attend.
    *   *Acceptance Criteria:*
        *   Shows GPA and Email.
        *   Shows a link to their Campus. If they don't have one, it says so clearly.
    *   *Backend:* `GET /api/students/:id` returns student info AND the associated campus object.
10. **Add Student**
    *   *User Story:* As a user, I want to enroll a new student.
    *   *Acceptance Criteria:*
        *   Includes a dropdown or input to select a Campus.
        *   Validates GPA is between 0.0 and 4.0.
        *   On submit, redirects to the new Student's page or the All Students view.
    *   *Backend:* `POST /api/students` accepts student details and validates that `gpa` is between 0.0 and 4.0.
11. **Edit Student**
    *   *User Story:* As a user, I want to update a student's information or transfer them to a different campus.
    *   *Acceptance Criteria:*
        *   Form pre-fills with existing data.
        *   Changes are reflected immediately after saving.
    *   *Backend:* `PUT /api/students/:id` handles updating standard fields (email, gpa) AND foreign keys (`campusId`).
12. **Delete Student**
    *   *User Story:* As a user, I want to remove a student who has left the university.
    *   *Acceptance Criteria:*
        *   Each student in the "All Students" view has a delete button (e.g., an 'X' icon).
        *   Clicking it removes the student from the screen and database.
    *   *Backend:* `DELETE /api/students/:id` removes the student record permanently.

### Project Schedule
[Github Project/Gantt Chart Link](https://github.com/users/belovedEmperor/projects/6)

<img width="1238" height="590" alt="image" src="https://github.com/user-attachments/assets/cdd741bd-eb84-4c42-86ce-bb2f4303b618" />
