# Project 2 | CSE 3901 | Group 6
### Contributors: Kevin Zhang, Justin Seligman, Nolan Si, Divij Sasidhar

## Introduction
This is the repository for CSE 3901 Project 2 for group 6. This is a Ruby application that utilizes the Tk GUI library for GUI features. 

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

### Admin Panel


