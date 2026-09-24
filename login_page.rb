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
    user_label = TkLabel.new(self) { text 'Username'}.grid(:row => 0, :column=> 0, :columnspan => 2)
    user_entry = TkEntry.new(self).grid(:row => 1, :column=> 0, :columnspan => 2)

    # Password Label and Entry Field
    pass_label = TkLabel.new(self) { text 'Password'}.grid(:row => 2, :column=> 0,:columnspan => 2)
    pass_entry = TkEntry.new(self) { show '*'}.grid(:row => 3, :column=> 0,:columnspan => 2)

    # TODO: Check if username/password is empty before allowing sign in/up

    login_btn = TkButton.new(self) do
      text 'log in'
      grid(:row => 4, :column=> 0)
      command do
        username = user_entry.value
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

    signup_btn = TkButton.new(self) do
      text 'sign up'
      grid(:row => 4, :column=> 1)
      command do
        username = user_entry.value
        password = pass_entry.value
        puts "signing up with username: #{username} password: #{password}"

        outer_self.grid_forget()
        # TODO: Make it pass the actual user id
        user_page = UserPage.new(parent, user_manager, parent.hash).grid(:row => 0, :column=> 0)
        user_page.bind('Destroy', proc{ |w|
          if w == user_page
            outer_self.grid(:row => 0, :column => 0)
          end
        }, "%W")
      end
    end
    # Pack the frame itself
    grid(:row => 0, :column=> 0)
  end
end

if __FILE__ == $0
  root = TkRoot.new { title "Modular Ruby/Tk App" }
  root.geometry("1000x300")
  nb = Tk::Tile::Notebook.new(root) do
    place('x' => 0, 'y' => 0)
  end

  page1 = TkFrame.new(nb)
  page2 = TkFrame.new(nb)

  custom_frame = LoginPageFrame.new(page1, UserManager.new)
  TkLabel.new(page2) { text "Welcome to Page One!"; grid { row 0; column 0 } }

  nb.add page1, :text => 'Tab One'
  nb.add page2, :text => 'Tab Two'

  Tk.mainloop


end