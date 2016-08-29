class CreateCollection < ActiveRecord::Migration

  def change
    create_table :collections do |t|
      t.integer :user_id
      t.string :name
    end
  end

end
