require 'tk'
require 'tkextlib/tile'
require_relative "../user"
require_relative "../post"

# TODO: Profile pictures
# TODO: address needs to all be there if it wants to be saved
# Add ability to add/remove attachments to posts.
# Validate post attachments. (Should be done in post class?)



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
        user.address.street = street_entry.value
        user.address.city = city_entry.value
        user.address.state = state_entry.value
        user.address.zipCode = zipcode_entry.value
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
  # Create Post Popup
  # =========================

  def create_post_popup
    popup = TkToplevel.new(root)
    popup.title("Create Post")
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
        post = Post.new(
          title_entry.value,
          content_entry.value
        )

        outer_self.instance_variable_get(:@user).create_post(post)

        popup.destroy
        outer_self.update_posts
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

    # Delete
    TkButton.new(@post_frame) do
      text "Delete"
      grid(:row => index, :column => 2)

      command do
        outer_self.instance_variable_get(:@user).delete_post(post.post_id)
        outer_self.update_posts
      end
    end

    # Edit
    TkButton.new(@post_frame) do
      text "Edit"
      grid(:row => index, :column => 3)

      command do
        outer_self.edit_post_popup(post)
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
