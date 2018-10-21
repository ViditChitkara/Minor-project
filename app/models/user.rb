class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :election_voter_mappings

  def has_voted_for(election)
    return election_voter_mappings.where(election_id: election.id).count>0
  end
end
