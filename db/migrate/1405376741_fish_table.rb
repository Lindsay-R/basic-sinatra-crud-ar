class FishTable < ActiveRecord::Migration
  def up
    create_table :fish do |t|
      t.string :fish_name
      t.integer :user_id
      t.string :fish_wiki
    end
  end

  def down
    # add reverse migration code here
  end
end
