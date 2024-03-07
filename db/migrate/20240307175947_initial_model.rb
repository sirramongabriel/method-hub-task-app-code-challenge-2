class InitialModel < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      
      t.timestamps
    end
    
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.date :date_due
      t.date :date_completed
      t.string :status
      t.integer :progress
      t.string :priority_level

      t.timestamps
    end
  end
end
