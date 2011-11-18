Projects::Application.routes.draw do
                                                
  resources :events, :only => [:index,:show] do 
    resources :projects, :except => [:index,:destroy], :path => ''
  end
  
  root :to => 'events#index'
  
end