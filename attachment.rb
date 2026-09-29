class Attachment
    @@nextAttachmentId = 1
    attr_accessor :fileName
    
    def initialize(fileName, fileType, fileSize, filePath)
        @attachmentId = @@nextAttachmentId
        @@nextAttachmentId += 1
        @fileName = fileName
        @fileType = fileType
        @fileSize = fileSize
        @filePath = filePath
        @uploadedAt = Time.now
    end
end