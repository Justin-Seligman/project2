require "digest"
require_relative "post"

class User
	attr_accessor :first_name, :last_name, :email, :posts
	attr_reader :id  # ID needs to be read by user_manager
	@@next_id = 1

	def initialize(username, email, password)
		@username = username
		@user_id = @@next_id
		@@next_id += 1
		@email = email
		@password = Digest::SHA256.hexdigest(password)
		@logged_in = 0
		@posts = []
	end 

	def login(email, password)
		return false if email != @email || Digest::SHA256.hexdigest(password) != @password

		@logged_in = 1
		@current_users += 1
		return true
	end

	def logout()
		@logged_in = 0
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

end


  



  