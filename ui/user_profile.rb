require 'tk'
require 'tkextlib/tile'
require_relative "../user"
require_relative "../user_manager"

# Profile page for a logged in user.
# Shown by UserPage#open_profile_page, which hides the UserPage
# and shows it again once this page is destroyed (Back button).

class UserProfile < TkFrame
  def initialize(parent, user_manager, user_id)
    super(parent)

    @user_manager = user_manager
    @user_id = user_id
    @user = user_manager.get_user_by_id(user_id)

    user = @user
    outer_self = self

    # Back (destroying this page brings the UserPage back)
    TkButton.new(self) do
      text 'Back'
      grid(:row => 0, :column => 0)

      command do
        outer_self.destroy
      end
    end

    # =========================
    # Profile Picture
    # =========================

    @picture_label = TkLabel.new(self)
    @picture_label.grid(:row => 1, :column => 0, :rowspan => 5, :padx => 10, :pady => 10)

    update_profile_picture

    # =========================
    # User Details
    # =========================

    TkLabel.new(self) do
      text 'User ID:'
      grid(:row => 1, :column => 1, :sticky => 'w')
    end

    TkLabel.new(self) do
      text user.user_id
      grid(:row => 1, :column => 2, :sticky => 'w')
    end

    TkLabel.new(self) do
      text 'Username:'
      grid(:row => 2, :column => 1, :sticky => 'w')
    end

    TkLabel.new(self) do
      text user.username
      grid(:row => 2, :column => 2, :sticky => 'w')
    end

    TkLabel.new(self) do
      text 'Email:'
      grid(:row => 3, :column => 1, :sticky => 'w')
    end

    TkLabel.new(self) do
      text user.email
      grid(:row => 3, :column => 2, :sticky => 'w')
    end

    TkLabel.new(self) do
      text 'Address:'
      grid(:row => 4, :column => 1, :sticky => 'w')
    end

    TkLabel.new(self) do
      text user.address.getFullAddress
      grid(:row => 4, :column => 2, :sticky => 'w')
    end

    TkLabel.new(self) do
      text 'Total Posts:'
      grid(:row => 5, :column => 1, :sticky => 'w')
    end

    TkLabel.new(self) do
      text user.posts.length
      grid(:row => 5, :column => 2, :sticky => 'w')
    end

    # =========================
    # Posts
    # =========================

    create_post_frame

    # Put the whole UserProfile on the parent
    grid(:row => 0, :column => 0)
  end

  # =========================
  # Post Frame
  # =========================

  # Read-only table of the user's posts (title, content, attachment names)
  def create_post_frame
    post_frame = TkFrame.new(self)
    post_frame.grid(:row => 6, :column => 0, :columnspan => 3, :pady => 10)

    # Table headers
    TkLabel.new(post_frame) do
      text "Title"
      grid(:row => 0, :column => 0, :padx => 10)
    end

    TkLabel.new(post_frame) do
      text "Content"
      grid(:row => 0, :column => 1, :padx => 10)
    end

    TkLabel.new(post_frame) do
      text "Attachments"
      grid(:row => 0, :column => 2, :padx => 10)
    end

    # Posts
    @user.posts.each.with_index(1) do |post, index|
      TkLabel.new(post_frame) do
        text post.title
        grid(:row => index, :column => 0, :padx => 10)
      end

      TkLabel.new(post_frame) do
        text post.content
        grid(:row => index, :column => 1, :padx => 10)
      end

      attachment_names = post.attachmentsNamesArray
      TkLabel.new(post_frame) do
        text(attachment_names.empty? ? "None" : attachment_names.join(", "))
        grid(:row => index, :column => 2, :padx => 10)
      end
    end
  end

  # =========================
  # Update Profile Picture
  # =========================

  # Loads the user's profile picture into the picture label.
  # Shows text instead if there is no picture or it can't be loaded.
  def update_profile_picture
    filepath = @user.profile_picture

    if filepath.nil? || filepath.empty?
      @picture_label.configure(:text => "No profile picture")
      return
    end

    begin
      image = TkPhotoImage.new(:file => filepath)

      # shrink the picture if it is bigger than 150 pixels.
      # Tk can only shrink by whole number factors (keeps every nth pixel).
      largest_side = [image.width, image.height].max
      if largest_side > 150
        factor = (largest_side / 150.0).ceil
        small_image = TkPhotoImage.new
        small_image.copy(image, :subsample => [factor, factor])
        image = small_image
      end

      # keep a reference so the image isn't garbage collected while shown
      @profile_image = image
      @picture_label.configure(:image => @profile_image)
    rescue => e
      @picture_label.configure(:text => "Could not load picture")
    end
  end
end
