require 'tk'
require 'tkextlib/tile'
# require_relative "user"
# require_relative "post"


class UserPage < TkFrame

  def initialize(parent, user_manager, user_id)
    super(parent)
    # @user = user_manager.getUser(user_id)

    outer_self = self


    # log out
    logout_btn = TkButton.new(self) do
      text 'log out'
      grid(:row => 0, :column=> 0)
      command do
        outer_self.destroy
      end
    end

    street_label = TkLabel.new(self){text 'Street:'}.grid(:row => 1, :column => 0)
    # street_entry = TkEntry.new(self).insert(0,@user.address.street).grid(:row => 1, :column => 1)
    street_entry = TkEntry.new(self).insert(0, 'placeholder street').grid(:row => 1, :column => 1)

    city_label = TkLabel.new(self){text 'City:'}.grid(:row => 1, :column => 2)
    # city_entry = TkEntry.new(self).insert(0,@user.address.city).grid(:row => 1, :column => 3)
    city_entry = TkEntry.new(self).insert(0, "placeholder city").grid(:row => 1, :column => 3)

    state_label = TkLabel.new(self){text 'State:'}.grid(:row => 1, :column => 4)
    # street_entry = TkEntry.new(self).insert(0, @user.address.state).grid(:row => 1, :column => 5)
    state_entry = TkEntry.new(self).insert(0, 'placeholder state').grid(:row => 1, :column => 5)

    zipcode_label = TkLabel.new(self){text 'Zip Code:'}.grid(:row => 1, :column => 6)
    # TODO: Check why this is camel case in the uml diagram and not snake case
    # street_entry = TkEntry.new(self).insert(0, @user.address.zipCode).grid(:row => 1, :column => 7)
    zipcode_entry = TkEntry.new(self).insert(0,'placeholder zipcode').grid(:row => 1, :column => 7)

    # TODO: Validate addres
    save_address_btn = TkButton.new(self) do
      text 'Save Address'
      grid(:row => 2, :column=> 0)
      command do
        puts "saving street as #{street_entry.value}"
        # @user.address.street = street_entry.value

        puts "saving city as #{city_entry.value}"
        # @user.address.city = city_entry.value

        puts "saving state as #{state_entry.value}"
        # @user.address.state = state_entry.value

        puts "saving zip code as #{zipcode_entry.value}"
        # @user.address.zipCode = zipcode_entry.value
      end
    end

    # delete account
    delete_account_btn = TkButton.new(self) do
      text 'Delete Account'
      grid(:row => 3, :column=> 0)
      command do
        user_manager.deleteUser(user_id)
        outer_self.destroy

      end
    end

    # create post
    create_post_btn = TkButton.new(self) do
      text 'Create Post'
      grid(:row => 4, :column=> 0)
      command do
        popup = TkToplevel.new(root) { title "Enter Post Details" }
        popup.geometry("250x150")

        # Name label and entry
        TkLabel.new(popup) { text "Title:"; pack('anchor' => 'w', 'padx' => 10, 'pady' => 5) }
        title_entry = TkEntry.new(popup, 'textvariable' => name_var)
        title_entry.pack('padx' => 10, 'pady' => 2)

        # Age label and entry
        TkLabel.new(popup) { text "Content:"; pack('anchor' => 'w', 'padx' => 10, 'pady' => 5) }
        content_entry = TkEntry.new(popup, 'textvariable' => age_var)
        content_entry.pack('padx' => 10, 'pady' => 2)

        # Submit button
        TkButton.new(popup) do
          text "Submit"
          pack('pady' => 10)
          command do
            post = Post.new(title_entry.value, content_entry.value)
            @user.createPost(post)
            popup.destroy # Close the pop-up
          end
        end

        # Need to update the post list. update post list should probbaly be a function
      end
    end

    post_frame = TkFrame.new(outer_self)
    TkLabel.new(post_frame){text "Title"}.grid(:row => 0, :column => 0)
    TkLabel.new(post_frame){text "Content"}.grid(:row => 0, :column => 1)

    @user.posts.each_with_index(1) do |post, index|
      TkLabel.new(post_frame){text post.title}.grid(:row => index, :column => 0)
      TkLabel.new(post_frame){text post.content}.grid(:row => index, :column => 1)
      # TkButton.new(post_frame){text "Delete", command {@user.deletePost(post.postID)}}.grid(:row => index, :column => 0)
      TkButton.new(post_frame){text "Delete", command {puts "Deleting post"}}.grid(:row => index, :column => 0)
      TkButton.new(post_frame){text "edit", command {puts "Editing post"}}.grid(:row => index, :column => 0)

    end

    post_frame.grid(:row => 5, :column => 0)

    # export posts?
    # create top level that looks


    # Pack the frame itself
    grid(:row => 0, :column=> 0)
  end
end
