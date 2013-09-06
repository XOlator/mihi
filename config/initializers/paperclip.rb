module Paperclip
  class Rotator < Thumbnail
    def transformation_command
      if rotate_command
        super + rotate_command
      else
        super
      end
    end
    
    def rotate_command
      [convert_options = "-rotate #{@attachment.instance.rotate_degrees}"] unless @attachment.instance.rotate_degrees.blank?
    end
  end
end