require 'tk'
require 'tkextlib/tile'
require_relative 'user'
require_relative 'ui/user_page'
require_relative 'user_manager'
require_relative 'ui/login_page'
require_relative 'ui/signup_page'
require_relative 'ui/admin_panel'

if __FILE__ == $0
  root = TkRoot.new { title "UserHub app" }
  root.geometry("1000x300")
  nb = Tk::Tile::Notebook.new(root) do
    place('x' => 0, 'y' => 0)
  end

  page1 = TkFrame.new(nb)
  page2 = TkFrame.new(nb)
  page3 = TkFrame.new(nb)

  user_manager = UserManager.new  

  login_page_frame = LoginPageFrame.new(page1, user_manager)
  signup_page_frame = SignupPageFrame.new(page2, user_manager)
  admin_frame = AdminPanel.new(page3, user_manager)

  nb.add page1, :text => 'log in'
  nb.add page2, :text => 'sign up'
  nb.add page3, :text => 'admin'

  Tk.mainloop


end