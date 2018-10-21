class CreateCandidates < ActiveRecord::Migration[5.1]
  def change
    create_table :candidates do |t|
      t.references :election, foreign_key: true
      t.references :user, foreign_key: true
      t.string :unique_election_key
      t.integer :candidate_number

      t.timestamps
    end
  end
end
