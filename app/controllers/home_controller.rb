class HomeController < ApplicationController
  def index
    @elections = Election.all
  end

  def vote
    @election = Election.includes(:candidates).find(params[:election_id].to_i)
    @mapping = ElectionVoterMapping.where(election_id: @election.id, user_id: current_user.id).last
  end

  def create_vote
    @election = Election.find(params[:election_id].to_i)
    @election.generate_vote_for(params[:candidate_id].to_i, current_user.id)
    return redirect_to "/election/"+"#{@election.id}"
  end
end
