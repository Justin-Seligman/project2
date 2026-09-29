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

    # adds attachment to post, returns true/false based on success
    def add_attachment(attachment)
        if @attachments.length < 5
            @attachments << attachment
            return true
        else
            # throw error, too many attachments
            return false
        end
    end
    
    def removeAttachment(attachmentId)
        @attachments = @attachments.reject{|x| x.attachmentId == attachmentId}
    end

    def attachmentsNamesArray
        return Array(@attachments.map(&:fileName))
    end

end