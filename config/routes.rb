Rails.application.routes.draw do
  get 'api/index'
  post 'api/csv_actions'
  get 'api/export_csv'
  get 'api/test'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
