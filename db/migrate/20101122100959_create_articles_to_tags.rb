class CreateArticlesToTags < ActiveRecord::Migration
  def self.up
    create_table :articles_tags, :id => false do |t|
      t.integer :article_id
      t.integer :tag_id
    end
  end

  def self.down
    drop_table :articles_tags
  end
end
