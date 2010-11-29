class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :articles
  
  
  def count 
    self.articles.size
  end
  
  
end
