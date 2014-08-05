Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :courses_students

  resources :students

resources :users do
	resources :courses
end

resources :courses do
  member do
    post :answer
    post :absent
    post :pass
  end
end

  root 'welcome#index'
end
