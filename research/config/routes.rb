TechReviewSite::Application.routes.draw do
  get 'top/show'
  get 'events/index'
  
  root 'top#show'

end
