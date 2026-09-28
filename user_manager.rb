require_relative "user"

class UserManager
	def initialize
		@users = { }  # ID | User
	end
	
	def create_user(user)
		@users[user.id] = user
	end

	def get_user(user_id)
		user = @users[user_id]
		return false unless user	
	end

	def update_user(user)
		@users[user.id] = user
	end

	def delete_user(user_id)
		!!@users.delete(user_id)
	end

	def get_all_users
		return @users.values
	end
end