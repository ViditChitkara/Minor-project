class Election < ApplicationRecord
  has_many :candidates
  has_many :votes
  has_many :election_voter_mappings
  has_many :users, through: :election_voter_mappings, foreign_key: :election_id

  after_create :set_keys

  def create_voters_mapping
    User.where(is_admin: false).each do |u|
      u.election_voter_mappings.create(election_id: self.id, voted: false)
    end
  end

  def generate_results
    fetch_results
  end

  def self.create_election(name: nil, voters_count: nil, candidates_count: nil)
    e = Election.create(name: name)
    e.create_candidates(voters_count, candidates_count)
    e.create_voters_mapping
  end

  def create_candidates(total_number_of_voters, candidates_count)
    digits = Math.log10(total_number_of_voters).to_i+1
    for i in 1..candidates_count
      c = Candidate.new
      c.election_id = self.id
      c.candidate_number = i
      c.unique_election_key = 10**(digits*(i-1))
      c.save(validate: false)
    end
  end

  def generate_vote_for(candidate_id, user_id)
    candidate = Candidate.find(candidate_id)
    str = Encryption::Paillier.encrypt(candidate.unique_election_key.to_i, self)
    Vote.create(election_id: candidate.election_id, encrypted_vote: str.to_s)
    evm = ElectionVoterMapping.where(user_id: user_id, election_id: candidate.election_id)
    if evm.count > 0
      evm.update(voted: true)
    else
      ElectionVoterMapping.create(user_id: user_id, election_id: candidate.election_id, voted: true)
    end
  end

  def set_keys
    self.update(Encryption::Paillier.key_generation(512))
  end

  private
  def fetch_results
    result = Encryption::Paillier.encrypt(0, self)
    votes.each do |v|
      result = Encryption::Paillier.add_encrypted_vote(result.to_s, v.encrypted_vote, self)
    end
    result_key = Encryption::Paillier.decrypt(result, self).to_s
    digits = Math.log10(users.count).to_i+1

    left_over = ""
    (digits*candidates.count - result_key.length).times do
      left_over = "0" + left_over
    end

    result_key = left_over + result_key

    result_hash = Hash.new

    i = result_key.length-1
    candidates.order('candidate_number ASC').each do |c|
      result_hash[c.candidate_number] = result_key[i-digits+1..i].to_i
      i-=digits
    end

    result_hash
  end
end
