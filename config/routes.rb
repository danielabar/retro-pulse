Rails.application.routes.draw do
  mount Api => "/"
  resources :retrospectives
  root "welcome#index"
end
