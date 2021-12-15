Rails.application.routes.draw do
  resources :blogposts
  root to: "blogposts#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
