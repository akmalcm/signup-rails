json.set! :users do
  json.array! @users.each do |user|
    json.partial! 'api/v1/partials/user.jbuilder', user: user
  end
end
