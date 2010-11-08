# == Schema Information
#
# Table name: articles
#
#  id                 :integer(4)      not null, primary key
#  title              :string(255)
#  body               :text
#  exclusive          :boolean(1)
#  created_at         :datetime
#  updated_at         :datetime
#  asset_file_name    :string(255)
#  asset_content_type :string(255)
#  asset_file_size    :integer(4)
#  asset_updated_at   :datetime
#
require 'paperclip' 

class Article < ActiveRecord::Base
  validates_presence_of :title, :body
  
  belongs_to :user
  
  has_attached_file :asset

  validates_attachment_presence :asset
  validates_attachment_content_type :asset, :content_type => [ 'video/quicktime', 'video/x-flv', 'video/mp4', 'video/mpeg']

  # This method creates the ffmpeg command that we'll be using
  def convert
    logger.debug "testing the status of the current file #{self.asset_file_name} #{self.asset_content_type} #{self.asset_file_name} #{self.asset_file_name}"
    if self.asset_file_name.include? ".flv"
      mp4 = File.join(File.dirname(asset.path), "#{self.asset_file_name.gsub(".flv",'').gsub(".FLV",'')}.mp4")
      File.open(mp4, 'w')
      system "ffmpeg -i #{ asset.path } -ar 44100 -ab 128000 -s 640x480 -vcodec mpeg4 -aspect 16:9 -r 25 -qscale 8 -f mp4 -y #{ mp4 }"
      grab_screenshot_from_video
    elsif self.asset_file_name.include? ".mp4"
      flv = File.join(File.dirname(asset.path), "#{self.asset_file_name.gsub(".mp4",'').gsub(".MP4",'')}.flv")
      File.open(flv, 'w')
      system "ffmpeg -i #{ asset.path }  -ar 22050 -ab 192000 -s 480x360 -vcodec flv -r 25 -qscale 8 -f flv -y #{ flv }"
      grab_screenshot_from_video
    else
      flv = File.join(File.dirname(asset.path), "#{self.asset_file_name.gsub(".mov",'').gsub(".mp4",'').gsub(".MOV",'').gsub(".MP4",'').gsub(".avi",'').gsub(".AVI",'')}.flv")
      File.open(flv, 'w')
      system "ffmpeg -i #{ asset.path }  -ar 22050 -ab 192000 -s 480x360 -vcodec flv -r 25 -qscale 8 -f flv -y #{ flv }"
      mp4 = File.join(File.dirname(asset.path), "#{self.asset_file_name.gsub(".mov",'').gsub(".flv",'').gsub(".MOV",'').gsub(".FLV",'').gsub(".avi",'').gsub(".AVI",'')}.mp4")
      File.open(mp4, 'w')
      system "ffmpeg -i #{ asset.path } -ar 44100 -ab 128000 -s 640x480 -vcodec mpeg4 -aspect 16:9 -r 25 -qscale 8 -f mp4 -y #{ mp4 }"
      grab_screenshot_from_video
    end
  end
 
  private

  def grab_screenshot_from_video
    logger.debug "Trying to grab a screenshot from #{asset.path}"
    flv = File.join(File.dirname(asset.path), "thumb135x100.jpg")
    File.open(flv, 'w')
    system "ffmpeg -i #{ asset.path } -s 135x100 -vframes 1 -f image2 -an #{flv}"
    flv = File.join(File.dirname(asset.path), "thumb290x200.jpg")
    File.open(flv, 'w')
    system "ffmpeg -i #{ asset.path } -s 290x200 -vframes 1 -f image2 -an #{flv}"

  end

end
