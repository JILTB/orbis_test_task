Development Task: Create a Small Flutter App with Login, Infinite User
Listing, and Logout
Objective
Create a small Flutter application with two screens: a login screen and a user listing screen. The
app should authenticate users using the ReqRes API and display a list of users retrieved from
the API with infinite scrolling after a successful login. Additionally, implement a logout
functionality to return to the login screen.
Requirements
1. Login Screen:
○ Fields: Email and Password
○ Button: Login
○ Validation: Ensure that both email and password fields are not empty.
○ API Endpoint: Use the ReqRes API endpoint POST
https://reqres.in/api/login for authentication. Use this credential for a
valid login {"email": "eve.holt@reqres.in", "password": "cityslicka"} as
described in the API endpoint.
○ Success: On successful login, navigate to the user listing screen and store the
returned token locally on the device.
○ Failure: Display an error message if login fails.
2. User Listing Screen:
○ Header: Display a logout button in the app bar.
○ Content: List all users retrieved from the ReqRes API with infinite scrolling.
○ API Endpoint: Use the ReqRes API endpoint GET
https://reqres.in/api/users?page=1 to retrieve users.
○ Display: Show user details such as avatar, first name, last name, and email.
○ Infinite Scrolling: Implement pagination to load more users as the user scrolls
down.
3. Logout Functionality:
○ Button: Implement a logout button in the user listing screen.
○ Action: On clicking the logout button, navigate back to the login screen and clear
any stored authentication data.

Technical Details
● State Management: Use a state management solution suitable for Flutter, which is
convenient for you.
● Error Handling: Proper error handling for API calls, including displaying error messages
to users.
● Design: Use widgets you are familiar with; design is your choice.

● Platforms: The app should support Android and iOS.
● Bonus: Add support for desktop. If you have a Mac, test the app there as well; if you
have a Windows machine, test the app there too.
