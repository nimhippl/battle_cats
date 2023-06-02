class UserGameRef < ActiveRecord::Migration[7.0]
  def change
    change_table :records do |t|
      t.references :user
    end
  end
end
