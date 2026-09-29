# Project 2 | CSE 3901 | Group 6
### Contributors: Kevin Zhang, Justin Seligman, Nolan Si, Divij Sasidhar

## Introduction
This is the repository for CSE 3901 Project 2 for group 6. This is a Ruby application that utilizes the Tk GUI library for GUI features. The program data is stored entirely in-memory, so any changes are lost when the program exits. The administrator is hard-coded into the program and there is no special access requirement for the admin panel. You can access the admin panel at any time.

## Setup
To run the application you need to [install the latest version of Ruby](https://www.ruby-lang.org/en/documentation/installation/). You will also need to install the Tk Gem as it is used for the GUI. Install Tk by running the command
`gem install tk`

You can test the Tk Gem installation by saving the file
``` test_tk.rb
require 'tk'
root = TkRoot.new
root.title = "Button Example"
root.geometry('500x500')
button = TkButton.new(root) do
  text 'Click Me'
  command proc { puts 'Button Clicked!' }
  pack
end
Tk.mainloop
```
and running it with
`ruby test_tk.rb`

## Usage
Run the application by cloning the repository or downloading it as a .zip file and extracting it. Then navigate to the root and run the command
`ruby main.rb`

The main window will appear. There are three tabs: a user login tab, a user sign-up tab, and an admin-panel tab. 

### Sign-up
New users can sign-up in the sign-up tab by entering a username, email, and password. The username must have 3 or more characters, the email must have format [?]@[?].[?], and the password must have 6 or more characters. After filling in the username, email, and password, click the "sign up" button to sign-up with the entered information. If the user already exists or any field doesn't match the requirements, an error will appear and the sign-up will be unsuccessful.

### Login
Go to the login tab to login to an existing account. Enter the email and password associated with the account. If the email/password are valid, then the login page will change into the user's home page.

### User Page
After logging in, you will see the user page instead of the login tab. The User page has several functions. You can **Log Out** to return to the login page. You can input an address for the logged-in account by inputting the street, city, state, and zip code, with street and city being nonempty, state consisting of 1 or more alphabetical characters, and zip code being in the XXXXX or XXXXX-XXXX format, and click **Save Address** to save the entered address to the logged-in account. You can **Delete Account** to delete the account from the app entirely. You can click **Create Post** to create a new post for the logged-in user. A dialog will pop up with a title and content which must be nonempty to post. You can click **View Profile** to see your profile, and you can click **Set Profile Picture** to upload a valid image for the profile picture for your logged-in account. The User Page will also display any posts made by the logged-in account. The displayed posts have the option to Delete, Edit, Add Attachment, and Remove Attachment.

### User Profile
A user's profile page contains their ID, username, email, address, and post information. You can click the Back button to go back to the previous page.

### Admin Panel
The Admin Panel has 6 menus: **Manage Users**, **View All Posts**, **Search Users**, **View Statistics**, **Generate Master Report**, and **Generate Post Report**. The **Manage Users** button opens a dialog where you can add a new user by inputting the new user's information, you can delete a user by selecting an existing user, and you can update a user's information by selecting them, changing the information and clicking "Update Selected User." The **View All Posts** contains a list of all the posts created, including username, Post ID, title/content, created/updated times, and attachments. **Search Users** allows you to search for selected users by typing a string that will match by substring to the username or email of any user stored in the program. You can generate a user report or view the profile for a selected user in the search results. **View Statistics** is a dashboard containing statistics for the total amount of users, posts, attachments, and deleted accounts, as well as displaying the 5 most recently created posts and 5 most recently created accounts. **Generate Master Report** creates an HTML file in the root directory that lists all users and their details including number of posts. **Generate Post Report** creates an HTML file in the root directory that lists all posts in the application including title/content and attachments.


