# == Schema Information
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer(4)      default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  name                 :string(255)
#  role                 :string(255)
#  asset_file_name      :string(255)
#  asset_content_type   :string(255)
#  asset_file_size      :integer(4)
#  asset_updated_at     :datetime
#

class User < ActiveRecord::Base
  require 'paperclip' 
  has_many :articles
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable,:registerable,:recoverable, :rememberable, :trackable, :validatable, :http_authenticatable#, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me, :role, :asset
  
  has_attached_file :asset, 
                    :url => "/system/:attachment/user/:id/:style/:basename.:extension",  
                    :path => ":rails_root/public/system/:attachment/user/:id/:style/:basename.:extension",
                    :default_url => "/system/:attachment/missing_:style.png",
                    :styles => { 
                      :large => "600>",
                      :medium => "290>", 
                      :thumb  => "135>"
                    }                         

  
  def role?(role)
    if self.role.nil?
      return false
    else
      return self.role == role.to_s
    end
  end
  
  
end
