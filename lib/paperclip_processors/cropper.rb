module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      command = crop_command
      if command
        super.join(' ').sub(/ -crop \S+/, '') + command
      else
        super
      end
    end
    def crop_command
      target = @attachment.instance
      if target.cropping?
        command = " -crop '#{target.crop_w.to_i}x#{target.crop_h.to_i}+#{target.crop_x.to_i}+#{target.crop_y.to_i}'"
        # target.crop_x = target.crop_y = target.crop_h = target.crop_w = nil
        command
      end
    end
  end
end
