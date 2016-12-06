class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      t.integer :amount, null: false
      t.datetime :deleted_at
      t.boolean :is_credit_card, null: false

      t.timestamps
    end
  end
end
