class CreateShortenedUrlsTable < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      # the real url that we will redirect to
      t.string :url, :null => false

      # the unique key
      t.string :unique_key, :limit => 10, :null => false

      # how many times the link has been clicked
      t.integer :use_count, :null => false, :default => 0

      # urls may optionally have an expiration date
      t.datetime :expires_at

      t.timestamps
    end

    add_index :shortened_urls, :unique_key, :unique => true
    add_index :shortened_urls, :url
  end
end
