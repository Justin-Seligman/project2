class User

require_relative Post
attr_accessor :first_name, :last_name, :email, :phone, :posts
@@next_id = 1

def initialize(username, email, password)
  @username = username
  @userId = @@next_id
  @@next_id += 1
  @email = email
  @password = password
  @flag = 0
  @posts = []
  end 

  def login(email, password)
    
    if email != @email && password == @password
      return False
    else
      @flag = 1
      @currentUsers += 1
      return True
    end
  end

  def logout()
    @flag = 0
  end

  def createPost(post)
    @posts << post
  end

  def updatePost(post)
    if idx = @posts.index { |x| x.postId == post.postId }
      @posts[idx] = post
    end
  end

  def deletePost(postId)
    @posts = @posts.reject{|x| x.postId == postId}
  end

end


  



  