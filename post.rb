class Post

    # Static (attached to class object instance)
    @@nextPostId = 1

    def initialize(title, content)
        @postId = @@nextPostId
        @@nextPostId += 1
        @title = title
        @content = content
        @createdAt = Time.now
        @updatedAt = Time.now
        @attachments = Array.new()
    end

    def edit(title, content)
        @title = title
        @content = content
        @updatedAt = Time.now
    end

    def addAttachment(attachment)
        if @attachments.length <= 5
            @attachments << attachment
        else
            #throw error, too many attachments
    end
    
    def removeAttachment(attachmentId)
        @attachments.reject{|x| x.attachmentId = attachmentId}
    end

end