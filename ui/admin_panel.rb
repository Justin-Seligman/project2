require "tk"
require_relative "../user_manager"
require_relative "master_report"
require_relative "post_report"
require_relative "user_report"


# TODO: Validate input when managing users - check with Nolan to see if login functions can be reused
# TODO: implement recent post/user created
# TODO: Update dashboard look
# TODO: Confirm all parameters are valid when merging with backend
# TODO: need to know the admin that's "logged in" for the master report?


class AdminPanel < TkFrame
    include CustomReports
    
    class TextBox < TkLabel
        def initialize(parent, custom_text)
            super(parent)

            configure(
                'text' => custom_text,
                'font' => ['Helvetica', 16],
                'justify' => 'left',
                'borderwidth' => 4,
                'relief' => 'ridge',
                'background' => '#FF746C',
                'foreground' => 'black'
            )
        end
    end


    def initialize(parent)
        super(parent)

        @user_manager = UserManager.new
        admin = "Eric"

        # Title
        TkLabel.new(
            self,
            text: "Admin Panel",
            font: ['Helvetica', 16, 'bold']
        ).grid(
            'row' => 0,
            'column' => 0,
            'padx' => 20,
            'pady' => 20
        )


        # Manage Users
        TkButton.new(
            self,
            text: "Manage Users",
            command: proc { open_user_manager_window }
        ).grid(
            'row' => 1,
            'column' => 0,
            'padx' => 20,
            'pady' => 10,
            'sticky' => 'ew'
        )


        # View All Posts
        TkButton.new(
            self,
            text: "View All Posts",
            command: proc { open_posts_window }
        ).grid(
            'row' => 2,
            'column' => 0,
            'padx' => 20,
            'pady' => 10,
            'sticky' => 'ew'
        )


        # Search Users
        TkButton.new(
            self,
            text: "Search Users",
            command: proc { open_search_window }
        ).grid(
            'row' => 3,
            'column' => 0,
            'padx' => 20,
            'pady' => 10,
            'sticky' => 'ew'
        )


        # Dashboard
        TkButton.new(
            self,
            text: "View Statistics",
            command: proc { open_dashboard }
        ).grid(
            'row' => 4,
            'column' => 0,
            'padx' => 20,
            'pady' => 10,
            'sticky' => 'ew'
        )

        TkButton.new(
            self,
            text: "Generate Master Report",
            command: proc { CustomReports::generate_master_report(@user_manager.get_all_users, admin)}
        ).grid(
            'row' => 5,
            'column' => 0,
            'padx' => 20,
            'pady' => 10,
            'sticky' => 'ew'
        )


        TkButton.new(
            self,
            text: "Generate Post Report",
            command: proc { CustomReports::generate_post_report(@user_manager.get_all_users)}
        ).grid(
            'row' => 6,
            'column' => 0,
            'padx' => 20,
            'pady' => 10,
            'sticky' => 'ew'
        )

        # Allow buttons to expand horizontally
        grid_columnconfigure(0, 'weight' => 1)
    end


    def open_user_manager_window
        window = TkToplevel.new(self)
        window.title = "Manage Users"
        window.geometry("520x420")


        username_field = TkEntry.new(window)
        email_field = TkEntry.new(window)
        password_field = TkEntry.new(window, 'show' => '*')

        status = TkLabel.new(
            window,
            text: "Ready",
            anchor: 'w',
            relief: 'sunken'
        )

        user_list = TkListbox.new(
            window,
            width: 55,
            height: 12
        )


        # Username
        TkLabel.new(
            window,
            text: "Username"
        ).grid(
            row: 0,
            column: 0,
            sticky: 'w',
            padx: 10,
            pady: 5
        )

        username_field.grid(
            row: 0,
            column: 1,
            padx: 10,
            pady: 5
        )

        # Email
        TkLabel.new(
            window,
            text: "Email"
        ).grid(
            row: 2,
            column: 0,
            sticky: 'w',
            padx: 10,
            pady: 5
        )

        email_field.grid(
            row: 2,
            column: 1,
            padx: 10,
            pady: 5
        )


        # Password
        TkLabel.new(
            window,
            text: "Password"
        ).grid(
            row: 3,
            column: 0,
            sticky: 'w',
            padx: 10,
            pady: 5
        )

        password_field.grid(
            row: 3,
            column: 1,
            padx: 10,
            pady: 5
        )


        # Add User
        TkButton.new(
            window,
            text: "Add User",
            command: proc {

                username_value = username_field.get.to_s.strip
                email_value = email_field.get.to_s.strip
                password_value = password_field.get.to_s


                # Validation
                if username_value.empty? ||
                   email_value.empty? ||
                   password_value.empty?

                    status.configure(
                        text: "Please complete all fields."
                    )

                    return
                end


                # Duplicate email check
                if @user_manager.get_user_by_email(email_value)

                    status.configure(
                        text: "User already exists."
                    )

                    return
                end


                # Create user
                user = User.new(
                    username_value,
                    email_value,
                    password_value
                )

                @user_manager.create_user(user)


                status.configure(
                    text: "Created user #{user.id}: #{user.email}"
                )


                # Clear fields
                username_field.delete(0, 'end')
                email_field.delete(0, 'end')
                password_field.delete(0, 'end')


                # Refresh list
                refresh_user_list(user_list)
            }
        ).grid(
            row: 4,
            column: 0,
            columnspan: 2,
            pady: 10
        )


        # Delete Selected User
        TkButton.new(
            window,
            text: "Delete Selected User",
            command: proc {

                selected = user_list.curselection


                if selected.empty?

                    status.configure(
                        text: "Select a user to delete."
                    )

                    return
                end


                selected_value = user_list.get(selected[0])

                user_id = selected_value.split('|').first.to_i

                deleted = @user_manager.delete_user(user_id)


                status.configure(
                    text: deleted ?
                        "Deleted user #{user_id}" :
                        "Delete failed."
                )


                refresh_user_list(user_list)
            }
        ).grid(
            row: 5,
            column: 0,
            columnspan: 2,
            pady: 5
        )


        # Users label
        TkLabel.new(
            window,
            text: "Users"
        ).grid(
            row: 6,
            column: 0,
            columnspan: 2,
            sticky: 'w',
            padx: 10,
            pady: 5
        )


        # User list
        user_list.grid(
            row: 7,
            column: 0,
            columnspan: 2,
            padx: 10,
            pady: 5
        )


        # Status
        status.grid(
            row: 8,
            column: 0,
            columnspan: 2,
            sticky: 'ew',
            padx: 10,
            pady: 5
        )


        refresh_user_list(user_list)
    end


    def open_posts_window
        window = TkToplevel.new(self)
        window.title = "All Posts"
        window.geometry("500x300")


        posts = TkListbox.new(
            window,
            width: 60,
            height: 12
        )


        posts.grid(
            row: 0,
            column: 0,
            padx: 10,
            pady: 10,
            sticky: 'nsew'
        )


        @user_manager.get_all_users.each do |user|

            user.posts.each do |post|

                posts.insert(
                    'end',
                    "#{user.email} -> #{post[:title]}"
                )

            end

        end


        window.grid_rowconfigure(
            0,
            'weight' => 1
        )

        window.grid_columnconfigure(
            0,
            'weight' => 1
        )
    end


    def open_search_window
        window = TkToplevel.new(self)
        window.title = "Search Users"
        window.geometry("420x400")


        query = TkEntry.new(
            window,
            width: 30
        )

        results = TkListbox.new(
            window,
            width: 50,
            height: 8
        )

        status = TkLabel.new(
            window,
            text: "Search by email or name",
            anchor: 'w'
        )


        # Search box
        query.grid(
            row: 0,
            column: 0,
            padx: 10,
            pady: 10
        )

        TkButton.new(
            window,
            text: "Generate Report for Selected User",
            anchor: "w",
            command: proc { 
                selected = results.curselection


                if selected.empty?

                    status.configure(
                        text: "Select a user to generate a report for."
                    )

                    return
                end


                selected_value = results.get(selected[0])

                user_id = selected_value.split('|').first.to_i

                selected_user = @user_manager.get_user_by_id(user_id)
                
                report = CustomReports::generate_user_detail_report(selected_user)

                status.configure(
                    text: report ?
                        "Generated Report for #{user_id}" :
                        "Report Failed."
                )
            }
        ).grid(
            row: 1,
            column: 0,
            padx: 10,
            pady: 10
        )

        # Search button
        TkButton.new(
            window,
            text: "Search",
            command: proc {

                results.delete(0, 'end')

                search_value =
                    query.get.to_s.strip.downcase


                matches =
                    @user_manager.get_all_users.select do |user|

                        search_value.empty? ||
                        user.email.downcase.include?(search_value) ||
                        user.username.to_s.downcase.include?(search_value)

                    end


                matches.each do |user|

                    results.insert(
                        'end',
                        "#{user.id} | #{user.username} | #{user.email}"
                    )

                end


                status.configure(
                    text:
                        search_value.empty? ?
                        "Showing all users" :
                        "Found #{matches.length} user(s)"
                )
            }
        ).grid(
            row: 0,
            column: 1,
            padx: 10,
            pady: 10
        )


        # Results
        results.grid(
            row: 2,
            column: 0,
            columnspan: 2,
            padx: 10,
            pady: 5,
            sticky: 'nsew'
        )


        # Status
        status.grid(
            row: 3,
            column: 0,
            columnspan: 2,
            sticky: 'ew',
            padx: 10,
            pady: 5
        )


        window.grid_rowconfigure(
            2,
            'weight' => 1
        )

        window.grid_columnconfigure(
            0,
            'weight' => 1
        )
    end


    def refresh_user_list(listbox)

        listbox.delete(
            0,
            'end'
        )


        @user_manager.get_all_users.each do |user|

            listbox.insert(
                'end',
                "#{user.id} | #{user.username} | #{user.email}"
            )

        end
    end


    def open_dashboard

        window = TkToplevel.new(self)

        window.title = "Dashboard"
        window.geometry("600x600")


        # -------------------------
        # Left column
        # -------------------------

        total_users = TextBox.new(
            window,
            "Total Users: #{@user_manager.get_all_users.size}"
        )

        total_users.grid(
            "row" => 0,
            "column" => 0,
            "padx" => 15,
            "pady" => 5,
            "sticky" => "nsew"
        )


        total_posts = TextBox.new(
            window,
            "Total Posts: #{@user_manager.post_count}"
        )

        total_posts.grid(
            "row" => 1,
            "column" => 0,
            "padx" => 15,
            "pady" => 5,
            "sticky" => "nsew"
        )


        total_attachments = TextBox.new(
            window,
            "Total Attachments: #{@user_manager.attachment_count}"
        )

        total_attachments.grid(
            "row" => 2,
            "column" => 0,
            "padx" => 15,
            "pady" => 5,
            "sticky" => "nsew"
        )


        # -------------------------
        # Right column
        # -------------------------

        recent_registered_user = TextBox.new(
            window,
            "Recently Registered User: #{3}"
        )

        recent_registered_user.grid(
            "row" => 0,
            "column" => 1,
            "padx" => 15,
            "pady" => 5,
            "sticky" => "nsew"
        )


        recent_created_post = TextBox.new(
            window,
            "Recently Created Post: #{3}"
        )

        recent_created_post.grid(
            "row" => 1,
            "column" => 1,
            "padx" => 15,
            "pady" => 5,
            "sticky" => "nsew"
        )


        total_del_accts = TextBox.new(
            window,
            "Total Deleted Accounts: #{@user_manager.deleted_user_count}"
        )

        total_del_accts.grid(
            "row" => 2,
            "column" => 1,
            "padx" => 15,
            "pady" => 5,
            "sticky" => "nsew"
        )


        # -------------------------
        # Grid configuration
        # -------------------------

        window.grid_columnconfigure(
            0,
            "weight" => 1
        )

        window.grid_columnconfigure(
            1,
            "weight" => 1
        )


        window.grid_rowconfigure(
            0,
            "weight" => 1
        )

        window.grid_rowconfigure(
            1,
            "weight" => 1
        )

        window.grid_rowconfigure(
            2,
            "weight" => 1
        )
    end
end


# -------------------------
# Main Application
# -------------------------

root = TkRoot.new {
    title "Admin Panel"
}

root.geometry("300x400")


panel = AdminPanel.new(root)

panel.grid(
    "row" => 0,
    "column" => 0,
    "sticky" => "nsew"
)


root.grid_rowconfigure(
    0,
    'weight' => 1
)

root.grid_columnconfigure(
    0,
    'weight' => 1
)


Tk.mainloop