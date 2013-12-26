class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string "token"
      t.datetime "expires"
      t.timestamps
    end
  end
end
