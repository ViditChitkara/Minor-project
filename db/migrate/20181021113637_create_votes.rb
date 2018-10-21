class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.string :encrypted_vote
      t.string :string
      t.references :election, foreign_key: true

      t.timestamps
    end
  end
end
