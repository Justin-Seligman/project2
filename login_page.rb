require 'tk'
require 'tkextlib/tile'
require_relative 'user_page'
require_relative 'user_manager'

class LoginPageFrame < TkFrame

  def initialize(parent, user_manager)
    super(parent)

    outer_self = self
    
    # Configure frame appearance
    # configure(relief: 'sunken', borderwidth: 2, padx: 10, pady: 10)

    
    # Username Label and Entry Field
    email_label = TkLabel.new(self) { text 'Email'}.grid(:row => 0, :column=> 0, :columnspan => 2)
    email_entry = TkEntry.new(self).grid(:row => 1, :column=> 0, :columnspan => 2)

    # Password Label and Entry Field
    pass_label = TkLabel.new(self) { text 'Password'}.grid(:row => 2, :column=> 0,:columnspan => 2)
    pass_entry = TkEntry.new(self) { show '*'}.grid(:row => 3, :column=> 0,:columnspan => 2)

    # TODO: Check if username/password is empty before allowing sign in/up

    login_btn = TkButton.new(self) do
      text 'log in'
      grid(:row => 4, :column=> 0)
      command do
        email = email_entry.value
        password = pass_entry.value
        # Add authentication logic here
        # if credentials are correct
        # self.grid_forget()
        # user_page = UserPage.new(parent, username).grid(:row => 0, :column=> 0)
        # user_page.bind('Destroy') do |e|
        #   if e.target == user_page
        #     self.grid(:row => 0, :column => 0)
        #   end
        # end
        puts "Logging in with username: #{username} password: #{password}"
      end
    end

    # Pack the frame itself
    grid(:row => 0, :column=> 0)
  end
end

