class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :payer
      t.integer :points_initial
      t.integer :points_available
      t.datetime :timestamp

    end
  end
end
