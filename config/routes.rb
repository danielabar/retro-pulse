Rails.application.routes.draw do
  mount Api => "/"
  root "welcome#index"
end
