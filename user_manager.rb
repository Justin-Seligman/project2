require_relative "user"

class UserManager
	@@deleted_users = 0

	def initialize
		@users = {}  # ID | User
	end

	def create_user(user)
		@users[user.id] = user
	end

	def get_user_by_id(user_id)
		@users[user_id] || false
	end

	def get_user_by_email(email)
		@users.values.find { |user| user.email == email }
	end

	def update_user(user)
		@users[user.id] = user
	end

	def delete_user(user_id)
		deleted = @users.delete(user_id)
		@@deleted_users += 1 if deleted
		deleted
	end

	def get_all_users
		return @users.values
	end

	def user_count
		@users.length
	end

	def deleted_user_count
		@@deleted_users
	end
end