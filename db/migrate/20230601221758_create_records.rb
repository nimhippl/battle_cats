class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|

      t.integer :winner
      t.string :left_cat
      t.string :right_cat
      t.integer :number

      t.timestamps
    end
  end
end
