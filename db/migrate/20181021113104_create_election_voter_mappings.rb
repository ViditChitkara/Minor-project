class CreateElectionVoterMappings < ActiveRecord::Migration[5.1]
  def change
    create_table :election_voter_mappings do |t|
      t.references :election, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :voted

      t.timestamps
    end
  end
end
