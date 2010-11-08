class AddUserIdAndViewsToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :user_id, :integer
    add_column :articles, :views, :integer
  end

  def self.down
    remove_column :articles, :user_id
    remove_column :articles, :views
  end
end
