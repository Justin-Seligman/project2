class Post

	attr_accessor :post_id, :title, :content, :createdAt, :updatedAt, :attachments

    # Static (attached to class object instance)
    @@nextPostId = 1

    def initialize(title, content)
        @post_id = @@nextPostId
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
            puts "ERROR: too many attachments (attempted to addAttachment to post with more than 5 attachments)"
        end
    end
    
    def removeAttachment(attachmentId)
        @attachments.reject{|x| x.attachmentId = attachmentId}
    end

end