Rails.application.routes.draw do
  get 'admin/new_election' => 'admin#new_election'

  post 'admin/create_elections'

  get 'admin/elections'

  get 'admin/election/:election_id/generate_result' => 'admin#generate_result'

  get 'admin/election/:election_id' => 'admin#election'

  get 'election/:election_id' => 'home#vote'

  post 'create_vote' => 'home#create_vote'

  root to: 'home#index'
  get 'home/index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
