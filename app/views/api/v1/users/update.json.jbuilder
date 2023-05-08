json.partial! 'api/v1/partials/base.jbuilder', message: @message

json.set! :data do
  json.set! :user do
    json.partial! 'api/v1/partials/user.jbuilder', user: @user
  end
end
