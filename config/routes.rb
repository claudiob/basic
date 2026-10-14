require 'sidekiq/web'

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  agents_only = ->(request) { Agent.find_by id: request.session[:agent_id] }
  mount Sidekiq::Web => '/sidekiq', constraints: agents_only

  scope module: :administered do
    # recourses are displayed in the admin navbar in the order they are defined here.
    recourses :contacts, only: %i[ index show edit update ]
    recourses :chats, only: %i[ index new create show destroy ] do
      resources :questions, only: :create
    end
    recourses :agents, only: %i[ index show ]

    # Named exit, which is the route recourse's sidebar looks for to draw the way out.
    resource :exit, only: :destroy, controller: 'agents/sessions'
  end

  scope module: :verified do
    root to: 'welcomes#show'
    resource :session, only: :destroy
  end

  scope module: :unauthenticated do
    resource :agent, only: :new
    # Each step is one page with one address, and what it takes is posted back to it.
    resource :code, only: %i[ new create ], path_names: { new: '' }
    resource :verification, only: %i[ new create ], path_names: { new: '' }
  end
end
