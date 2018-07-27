Rails.application.routes.draw do
  resources :boards, shallow: true do
    resources :columns do
      resources :tasks do
        resources :comments
      end
    end
  end
end
