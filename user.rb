require "digest"
require_relative "post"
require_relative "address"

class User
	attr_accessor :username, :email, :posts, :address
	attr_reader :user_id  # ID needs to be read by user_manager
	@@next_id = 1
	@@current_users = 0

	def initialize(username, email, password)
		@username = username
		@user_id = @@next_id
		@@next_id += 1
		@email = email
		@password = Digest::SHA256.hexdigest(password)
		@logged_in = 0
		@posts = []
		@address = Address.new("", "", "", "")
	end 

	def login(email, password)
		return false if email != @email || Digest::SHA256.hexdigest(password) != @password

		@logged_in = 1
		@@current_users += 1
		return true
	end

	def logout()
		@logged_in = 0
		@@current_users -= 1
	end

  	def create_post(post)
    	@posts << post
  	end

  	def update_post(post)
    	if idx = @posts.find_index { |x| x.post_id == post.post_id }
      		@posts[idx] = post
    	end
  	end

 	def delete_post(post_id)
		@posts = @posts.reject{|x| x.post_id == post_id}
  	end


	# check if user details are valid, if argument is nil then don't check it
	# each argument is a string
	# returns true/false if details are valid or invalid
	def self.valid_user_details?(username, email, password)

		valid_input = true

		if username && username !~ /\A.{3}.*\z/ # Username must be 3 or more characters
			puts "username not long enough"
			valid_input = false
		end

		if email && email !~ /\A.+@.+\..+\z/ #Email format is [1..inf chars]@[1..inf chars].[1..inf chars]
			puts "email not valid format"
			valid_input = false
		end

		if password && password !~ /\A.{6}.*\z/ # Password must be 6 or more characters
			puts "password not long enough"
			valid_input = false
		end


		return valid_input
	end
end


  



  