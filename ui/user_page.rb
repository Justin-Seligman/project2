require 'tk'
require 'tkextlib/tile'
require_relative "../user"
require_relative "../post"
require_relative "../attachment"
require_relative "user_profile"


class UserPage < TkFrame
  def initialize(parent, user_manager, user_id)
    super(parent)

    @user_manager = user_manager
    @user_id = user_id
    @user = user_manager.get_user_by_id(user_id)

    user_manager = @user_manager
    user_id = @user_id
    user = @user

    outer_self = self

    # Log out
    TkButton.new(self) do
      text 'Log Out'
      grid(:row => 0, :column => 0)

      command do
        outer_self.destroy
      end
    end

    # =========================
    # Profile
    # =========================

    # View profile page
    TkButton.new(self) do
      text 'View Profile'
      grid(:row => 0, :column => 1)

      command do
        outer_self.open_profile_page
      end
    end

    # Set profile picture
    TkButton.new(self) do
      text 'Set Profile Picture'
      grid(:row => 0, :column => 2)

      command do
        outer_self.set_profile_picture
      end
    end

    # =========================
    # Address
    # =========================

    TkLabel.new(self) do
      text 'Street:'
      grid(:row => 1, :column => 0)
    end

    street_entry = TkEntry.new(self)
    street_entry.insert(0, @user.address.street)
    street_entry.grid(:row => 1, :column => 1)

    TkLabel.new(self) do
      text 'City:'
      grid(:row => 1, :column => 2)
    end

    city_entry = TkEntry.new(self)
    city_entry.insert(0, @user.address.city)
    city_entry.grid(:row => 1, :column => 3)

    TkLabel.new(self) do
      text 'State:'
      grid(:row => 1, :column => 4)
    end

    state_entry = TkEntry.new(self)
    state_entry.insert(0, @user.address.state)
    state_entry.grid(:row => 1, :column => 5)

    TkLabel.new(self) do
      text 'Zip Code:'
      grid(:row => 1, :column => 6)
    end

    zipcode_entry = TkEntry.new(self)
    zipcode_entry.insert(0, @user.address.zipCode)
    zipcode_entry.grid(:row => 1, :column => 7)

    # Save address
    TkButton.new(self) do
      text 'Save Address'
      grid(:row => 2, :column => 0)

      command do

        # input validation for address fields (each field should have 1 or more characters)
        if street_entry.value =~ /\A.*\z/ && # 1 or more characters in street name
          city_entry.value =~ /\A.*\z/ && # 1 or more characters in city name
          state_entry.value =~ /\A[[:alpha:]]*\z/ && # 1 or more letters in state name
          zipcode_entry.value =~ /\A([0-9]{5}|[0-9]{5}\-[0-9]{4})\z/ # zip code either 5 number or 5+4 number format
          

          user.address.street = street_entry.value
          user.address.city = city_entry.value
          user.address.state = state_entry.value
          user.address.zipCode = zipcode_entry.value

          
        else
          # otherwise address input is not valid, display error popup
          popup = TkToplevel.new(root) { title "invalid address" }
          label = TkLabel.new(popup) do
            text "ERROR: invalid address field(s)!"
            pack padx: 20, pady: 20
          end
        end
      end
    end

    # Delete account
    TkButton.new(self) do
      text 'Delete Account'
      grid(:row => 3, :column => 0)

      command do
        user_manager.delete_user(user_id)
        outer_self.destroy
      end
    end

    # =========================
    # Posts
    # =========================

    # Create post
    TkButton.new(self) do
      text 'Create Post'
      grid(:row => 4, :column => 0)

      command do
        outer_self.create_post_popup
      end
    end

    # Post frame
    create_post_frame

    # Put the whole UserPage on the parent
    grid(:row => 0, :column => 0)
  end

  # =========================
  # Open Profile Page
  # =========================

  # Hides this page and shows the UserProfile page in its place.
  # When the profile page is destroyed (back button) this page is shown again.
  def open_profile_page
    outer_self = self
    parent = TkWinfo.parent(self)

    grid_forget()
    profile_page = UserProfile.new(parent, @user_manager, @user_id).grid(:row => 0, :column => 0)
    profile_page.bind('Destroy') do |e|
      if e.widget == profile_page
        outer_self.grid(:row => 0, :column => 0)
      end
    end
  end

  # =========================
  # Set Profile Picture
  # return true/false based on success
  # =========================

  def set_profile_picture
    # open file dialog, only png and gif can be displayed by Tk
    filepath = Tk::getOpenFile(
      'title' => 'Choose Profile Picture',
      'filetypes' => "{{Image Files} {.png .gif}} {{All Files} *}"
    )

    # user cancelled the dialog
    return false if filepath.nil? || filepath.empty?

    # input validation, must be an existing png or gif file
    if File.file?(filepath) && filepath =~ /\.(png|gif)\z/i
      @user.profile_picture = filepath
      return true
    else
      popup = TkToplevel.new(root) { title "invalid profile picture" }
      label = TkLabel.new(popup) do
        text "ERROR: profile picture must be a .png or .gif file!"
        pack padx: 20, pady: 20
      end
      return false
    end
  end

  # =========================
  # Create Post Popup
  # =========================

  def create_post_popup
    popup = TkToplevel.new(root)
    popup.title("Create Post")
    popup.geometry("450x350")

    TkLabel.new(popup) do
      text "Title:"
      pack(
        'anchor' => 'w',
        'padx' => 10,
        'pady' => 5
      )
    end

    title_entry = TkEntry.new(popup)
    title_entry.pack(
      'fill' => 'x',
      'padx' => 10,
      'pady' => 2
    )

    TkLabel.new(popup) do
      text "Content:"
      pack(
        'anchor' => 'w',
        'padx' => 10,
        'pady' => 5
      )
    end

    content_entry = TkEntry.new(popup)
    content_entry.pack(
      'fill' => 'x',
      'padx' => 10,
      'pady' => 2
    )

  

    outer_self = self


    TkButton.new(popup) do
      text "Submit"
      pack('pady' => 10)

      command do
        if title_entry.value ~= /\A.+\z/ &&
          content_entry.value ~= /\A.+\z/
          post = Post.new(
            title_entry.value,
            content_entry.value
          )

          outer_self.instance_variable_get(:@user).create_post(post)

          popup.destroy
          outer_self.update_posts
        else
          popup = TkToplevel.new(root) { title "invalid post" }
          label = TkLabel.new(popup) do
            text "ERROR: title and content must not be empty!"
            pack padx: 20, pady: 20
          end
        end
      end
    end
  end

  # =========================
  # Post Frame
  # =========================

  def create_post_frame
    @post_frame = TkFrame.new(self)
    @post_frame.grid(:row => 5, :column => 0)

    # Total post count label
    @post_count_label = TkLabel.new(@post_frame)
    @post_count_label.text "Total Posts:"
    @post_count_label.grid(:row => 0, :column => 0)

    # Total post count text box
    @post_count_entry = TkEntry.new(@post_frame)
    @post_count_entry.configure(:state => 'readonly')
    @post_count_entry.grid(:row => 0, :column => 1)

    update_posts
  end

  # =========================
  # Update Posts
  # =========================

  def update_posts
    # Remove old post widgets, but keep
    # the post count label and entry.
    @post_frame.winfo_children.each do |child|
      next if child == @post_count_label
      next if child == @post_count_entry

      child.destroy
    end

    # Update total post count.
    #
    # Because the Entry is readonly, temporarily
    # enable it before changing its value.
    @post_count_entry.configure(:state => 'normal')
    @post_count_entry.delete(0, 'end')
    @post_count_entry.insert(0, @user.posts.length)
    @post_count_entry.configure(:state => 'readonly')

    # Table headers
    TkLabel.new(@post_frame) do
      text "Title"
      grid(:row => 1, :column => 0)
    end

    TkLabel.new(@post_frame) do
      text "Content"
      grid(:row => 1, :column => 1)
    end

    TkLabel.new(@post_frame) do
      text "Attachments"
      grid(:row => 1, :column => 2)
    end

    # Posts
    @user.posts.each.with_index(2) do |post, index|
      create_post_row(post, index)
    end
  end

  # =========================
  # Create Post Row
  # =========================

  def create_post_row(post, index)
    outer_self = self

    # Title
    TkLabel.new(@post_frame) do
      text post.title
      grid(:row => index, :column => 0)
    end

    # Content
    TkLabel.new(@post_frame) do
      text post.content
      grid(:row => index, :column => 1)
    end

    # Attachments (file names, or "None")
    attachment_names = post.attachmentsNamesArray
    TkLabel.new(@post_frame) do
      text(attachment_names.empty? ? "None" : attachment_names.join(", "))
      grid(:row => index, :column => 2)
    end

    # Delete
    TkButton.new(@post_frame) do
      text "Delete"
      grid(:row => index, :column => 3)

      command do
        outer_self.instance_variable_get(:@user).delete_post(post.post_id)
        outer_self.update_posts
      end
    end

    # Edit
    TkButton.new(@post_frame) do
      text "Edit"
      grid(:row => index, :column => 4)

      command do
        outer_self.edit_post_popup(post)
      end
    end

    # Add attachment
    TkButton.new(@post_frame) do
      text "Add Attachment"
      grid(:row => index, :column => 5)

      command do
        outer_self.add_attachment(post)
      end
    end

    # Remove attachment
    TkButton.new(@post_frame) do
      text "Remove Attachment"
      grid(:row => index, :column => 6)

      command do
        outer_self.remove_attachment_popup(post)
      end
    end
  end

  # =========================
  # Add Attachment
  # return true/false based on success
  # =========================

  def add_attachment(post)
    filepath = Tk::getOpenFile('title' => 'Choose Attachment') # open file dialog

    # user cancelled the dialog
    return false if filepath.nil? || filepath.empty?

    # input validation, must be an existing file
    if !File.file?(filepath)
      popup = TkToplevel.new(root) { title "invalid attachment" }
      label = TkLabel.new(popup) do
        text "ERROR: attachment file does not exist!"
        pack padx: 20, pady: 20
      end
      return false
    end

    attachment = Attachment.new(
      File.basename(filepath),                  # fileName
      File.extname(filepath).delete_prefix("."), # fileType (extension without the dot)
      File.size(filepath),                      # fileSize in bytes
      filepath                                  # filePath
    )

    # Post#add_attachment enforces the 5 attachment limit
    if post.add_attachment(attachment)
      update_posts
      return true
    else
      popup = TkToplevel.new(root) { title "too many attachments" }
      label = TkLabel.new(popup) do
        text "ERROR: a post can have at most 5 attachments!"
        pack padx: 20, pady: 20
      end
      return false
    end
  end

  # =========================
  # Remove Attachment Popup
  # =========================

  def remove_attachment_popup(post)
    popup = TkToplevel.new(root)
    popup.title("Remove Attachment")
    popup.geometry("300x250")

    TkLabel.new(popup) do
      text "Select an attachment to remove:"
      pack(
        'anchor' => 'w',
        'padx' => 10,
        'pady' => 5
      )
    end

    attachment_list = TkListbox.new(popup)
    attachment_list.pack(
      'fill' => 'both',
      'expand' => true,
      'padx' => 10,
      'pady' => 2
    )

    post.attachments.each do |attachment|
      attachment_list.insert('end', "#{attachment.attachmentId} | #{attachment.fileName}")
    end

    outer_self = self

    TkButton.new(popup) do
      text "Remove"
      pack('pady' => 10)

      command do
        selected = attachment_list.curselection

        if !selected.empty?
          # each row is "attachmentId | fileName", so the id is before the "|"
          attachment_id = attachment_list.get(selected[0]).split('|').first.to_i
          post.removeAttachment(attachment_id)

          popup.destroy
          outer_self.update_posts
        end
      end
    end
  end

  # =========================
  # Edit Post Popup
  # =========================

  def edit_post_popup(post)
    popup = TkToplevel.new(root)
    popup.title("Edit Post")
    popup.geometry("300x180")

    TkLabel.new(popup) do
      text "Title:"
      pack(
        'anchor' => 'w',
        'padx' => 10,
        'pady' => 5
      )
    end

    title_entry = TkEntry.new(popup)
    title_entry.insert(0, post.title)
    title_entry.pack(
      'fill' => 'x',
      'padx' => 10,
      'pady' => 2
    )

    TkLabel.new(popup) do
      text "Content:"
      pack(
        'anchor' => 'w',
        'padx' => 10,
        'pady' => 5
      )
    end

    content_entry = TkEntry.new(popup)
    content_entry.insert(0, post.content)
    content_entry.pack(
      'fill' => 'x',
      'padx' => 10,
      'pady' => 2
    )

    outer_self = self

    TkButton.new(popup) do
      text "Submit"
      pack('pady' => 10)

      command do
        post.edit(
          title_entry.value,
          content_entry.value
        )

        popup.destroy
        outer_self.update_posts
      end
    end
  end
end
