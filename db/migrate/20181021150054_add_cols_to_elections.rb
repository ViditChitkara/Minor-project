class AddColsToElections < ActiveRecord::Migration[5.1]
  def change
    add_column :elections, :g, :string
    add_column :elections, :n, :string
    add_column :elections, :nsquare, :string
    add_column :elections, :lambda, :string
    add_column :elections, :bit_length, :string
  end
end
