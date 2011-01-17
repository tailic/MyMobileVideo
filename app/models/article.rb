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
  attr_writer :tag_names
  after_save :assign_tags
  
  has_many :comments
  has_many :votes
  belongs_to :user
  has_and_belongs_to_many :tags

  has_attached_file :asset,
                    :url => "/system/:attachment/videos/:id/:style/:basename.:extension",  
                    :path => ":rails_root/public/system/:attachment/videos/:id/:style/:basename.:extension"

  validates_attachment_presence :asset
  validates_attachment_content_type :asset, :content_type => [ 'video/quicktime', 'video/x-flv', 'video/mp4', 'video/mpeg']

  
  define_index do
    # fields
    indexes title, :sortable => true
    indexes body
    indexes tags.name, :as => :tags
    
    # attributes
    has user_id, created_at, updated_at, views
  end
  

  def show_up_votes
    self.votes.find_all{|vote| vote.value == "up"}.size
  end
    
  def duration 
    command = "ffmpeg -i " +  self.asset.path + " 2>&1 | grep 'Duration'| cut -d ' ' -f 4 | sed s/,//"
		output = `#{command}`
		if output =~ /([\d][\d]):([\d][\d]):([\d][\d]).([\d]+)/
		  duration = (($1.to_i * 60 + $2.to_i) * 60 + $3.to_i) * 10 + $4.to_i
	  end
    "#{$2}:#{$3} Min."
  end
    
  def show_down_votes
    self.votes.find_all{|vote| vote.value == "down"}.size
  end      
  
  def tag_names
    @tag_names || tags.map(&:name).join(' ')
  end
  
  def path_mp4 
    self.asset.url.split("?").first + ".mp4"
  end
  
  def path_flv 
    self.asset.url.split("?").first + ".flv"
  end
  
  def vote_up 
    self.votes.find_all{|vote| vote.value == "up"}.size
  end
  
  def vote_down 
    self.votes.find_all{|vote| vote.value == "down"}.size
  end
  
  private
  
  def assign_tags
    if @tag_names
      self.tags = @tag_names.gsub(',', ' ').split(/\s+/).map do |name|
        tag = Tag.find_or_create_by_name(name)
      end
    end
    self.tags += self.title.split(" ").map! do |word|
      tag = Tag.find_or_create_by_name(word)
    end
  end
  

  def process_video
    logger.debug "Test current file #{self.asset_file_name} #{self.asset_content_type} #{self.asset_file_name} #{self.asset_file_name}"
      convert("640x480", "mpeg4", "libfaac", 8, "mp4")
      convert("640x480", "flv", "libmp3lame", 8, "flv")
      grab_screenshot("136x100")
      grab_screenshot("290x200")
      grab_screenshot("600x380")
  end


def convert(size, vcodec, acodec, qscale, vformat)
  outfile = File.join(File.dirname(asset.path), "#{self.asset_file_name + "." + vformat}")
  File.open(outfile, 'w')
  system "ffmpeg -i #{ asset.path } -s #{ size } -vcodec #{ vcodec } -acodec #{ acodec } -r 29.97 -qscale #{ qscale } -f #{ vformat } -y #{ outfile }"
end
 
  private

  def grab_screenshot(size)
    logger.debug "Trying to grab a screenshot from #{asset.path} size#{size}"
    flv = File.join(File.dirname(asset.path), "thumb#{ size }.jpg")
    File.open(flv, 'w')
    system "ffmpeg -i #{ asset.path } -s #{ size } -vframes 1 -ss 3 -f image2 -an #{flv}"
  end

end
