class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      # t.integer :user_id, null: false
      t.integer :amount, null: false
      t.string :tag, null: false
      t.datetime :paid_at, null: false
      t.datetime :deleted_at
      t.timestamps      
    end
  end
end
