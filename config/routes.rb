Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}

  resources :courses_students do
    member do
      post :update_note
    end
  end

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
