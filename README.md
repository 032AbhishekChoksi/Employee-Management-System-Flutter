# Employee Management System in Flutter Application

Develop a Flutter application for an Employee Management System that accommodates two types of users: Admin and Employee. Employees can register themselves in the system using a registration form. The form requires information such as employee number, name, contact number, gender, email, password, city, date of birth, designation, and offered salary.

Upon successful registration, employees will be automatically directed to the login page. Once logged in, an employee's session state will persist, eliminating the need for repeated logins. The dashboard provides employees with access to a list of their submitted leave applications and enables them to apply for new leave.

Admin users can log into the system as well. The admin dashboard offers functions like approving/rejecting employee registrations, handling leave requests, and granting salary increments. After an employee registers, they cannot log in until the admin approves their registration. The admin dashboard displays a list of leave applications from employees, granting the admin the capability to approve or reject them. Moreover, the admin can initiate salary increments for employees by predefined criteria.
<table>
  <tr>
    <th>Designation</th>
    <th>Increment (%)</th>
  </tr>
  <tr>
    <td>Project Manager</td>
    <td>25</td>
  </tr>
  <tr>
    <td>Assistant Manager</td>
    <td>20</td>
  </tr>
  <tr>
    <td>Sr. Developer</td>
    <td>15</td>
  </tr>
  <tr>
    <td>Jr. Developer</td>
    <td>10</td>
  </tr>
</table>

**Note:**
<ul>
<li>Make use of appropriate widgets.</li>
<li>Do the proper validaꢁons.</li>
<li>Make use of ﬁre store and shared preferences.</li>
</ul>
