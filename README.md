# Campus-back
<!-- [Link to deployed page](https://belovedemperor.github.io/Bank-of-React/) -->

Team Members: Cheng Yue (username: CY343), Christopher Altamirano (username: caltam600), and Jason Huang (username: belovedEmperor)

## Documentation
### Feature Requirements
Database Schema & Models
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

API Endpoints (RESTful Routes)
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

### Application Architecture Description and Diagram

### Epics, User Stories, and Acceptance Criteria
#### **Epic: Campus Management**
1.  **View All Campuses**
    *   *User Story:* As a user, I want to see all campuses so I can browse the university network.
    *   *Backend Task:* Create `GET /api/campuses` to return an array of all campus objects.
2.  **View Single Campus**
    *   *User Story:* As a user, I want to see details about a specific campus and who goes there.
    *   *Backend Task:* Create `GET /api/campuses/:id` that returns the campus metadata AND an array of associated `students`.
3.  **Add Campus**
    *   *User Story:* As an user, I want to add a new campus to the system.
    *   *Backend Task:* Create `POST /api/campuses` that accepts `name`, `address`, etc., validates they aren't empty, and saves to DB.
4.  **Edit Campus**
    *   *User Story:* As an user, I want to update campus details (like address or description).
    *   *Backend Task:* Create `PUT /api/campuses/:id` to update the attributes of a specific campus.
5.  **Delete Campus**
    *   *User Story:* As an user, I want to remove a campus that no longer exists.
    *   *Backend Task:* Create `DELETE /api/campuses/:id`. Ensure associated students become "unascribed" (campusId = null) rather than being deleted.

#### **Epic: Student Management**
6.  **View All Students**
    *   *User Story:* As a user, I want to see a list of all students registered in the system.
    *   *Backend Task:* Create `GET /api/students` to return an array of all student objects.
7.  **View Single Student**
    *   *User Story:* As a user, I want to view a student's profile, including their GPA and which campus they attend.
    *   *Backend Task:* Create `GET /api/students/:id` that returns student info AND the associated `campus` object.
8.  **Add Student**
    *   *User Story:* As an user, I want to enroll a new student.
    *   *Backend Task:* Create `POST /api/students` that accepts student details. It should strictly validate that `gpa` is between 0.0 and 4.0.
9.  **Edit Student**
    *   *User Story:* As an user, I want to update a student's information or transfer them to a different campus.
    *   *Backend Task:* Create `PUT /api/students/:id`. This endpoint must handle updating standard fields (email, gpa) AND foreign keys (`campusId`).
10. **Delete Student**
    *   *User Story:* As an user, I want to remove a student who has left the university.
    *   *Backend Task:* Create `DELETE /api/students/:id` to remove the student record permanently.

### Project Schedule
<!-- [Github Project/Gantt Chart Link](https://github.com/users/belovedEmperor/projects/4) -->
<!---->
<!-- ![[CSci 395 - Project 3 - Bank of React-1762211427111.webp]] -->

***

# server-starter-code

This repository is the server (back-end) starter code for Final Project - Full-Stack CRUD Application.

**Prerequisites**
- Install PostgreSQL (Postgres) [[link](https://www.postgresql.org/download/)] - required to run the database
- Install Postman [[link](https://www.postman.com/downloads/)] - optional tool for API testing 

----------
### 1. Use the following process to ***import*** the Final Project server starter code repository to your GitHub account as the starter codebase
1.	Log on to GitHub
2.	Click on the + sign in the top right corner (next to the user icon)
3.	In the dropdown menu, select "Import repository"
4.	A new page will open
5.	In "Your old repository’s clone URL" field, enter: `https://github.com/johnnylaicode/server-starter-code`
6.	In "Your new repository details" field, enter your own repository name (e.g., "final-project-server")
7.	Click on the "Begin import" button to start the process
8.	After the process completed, your new "final-project-server" repository is created – as a completely independent codebase
9.	From this point on, you can clone your new repository, make changes, create feature branches, and create/merge pull requests

----------
### 2. Use the information below to ***clone*** the starter codebase to your local machine
After creating the starter codebase "final-project-server" repository on GitHub (see above), you can clone it to your local machine. The instructions on how to clone a GitHub repository are available at this [link](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository).

----------
### 3. Set up and run the server (back-end) application on your local machine
1.	Start a terminal (e.g., Git Bash) on your local machine.
2.  Go to the "final-project-server" folder, enter the command to install dependencies: `npm install` 
3.	Start the server application by entering the command: `npm start` 
4.	After the server application is successfully started, its access address is at: `http://localhost:5001` 

<br/>

## Common Errors You May Encounter
### Error: password authentication failed for user "postgres"
This error is related to the user password you set for your own local Postgres database. 
#### Solution:
In the `server-starter-code/database/utils/configDB.js` file, replace the `dBpwd` value with your password for Postgres database.

```
  const dbName = 'starter-server';
  const dbUser = 'postgres';
  const dbPwd = '<your password>';
```
