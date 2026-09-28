require 'tk'
require 'tkextlib/tile'
# require_relative "user"


class UserPage < TkFrame

  def initialize(parent, user_manager, user_id)
    super(parent)
    @user = user_manager.getUser(user_id)

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


    # manage posts
      # add, remove, update, add/remove attachments
      # view total posts

    
    # export posts?
    # create top level that looks


    # Pack the frame itself
    grid(:row => 0, :column=> 0)
  end
end
