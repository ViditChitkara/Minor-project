class AdminController < ApplicationController
  before_action :authorize_admin

  def new_election
  end

  def create_elections
    Election.create_election(name: params[:name], voters_count: User.where(is_admin: false).count, candidates_count: params[:candidates_count].to_i)
    return redirect_to 'admin/elections'
  end

  def generate_result
    @election = Election.find(params[:election_id])
    @results = @election.generate_results
  end

  def elections
    @elections = Election.all
  end

  def election
    @election = Election.find(params[:election_id].to_i)
  end
end
