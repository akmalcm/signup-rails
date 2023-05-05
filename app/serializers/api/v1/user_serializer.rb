module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes(*User.attribute_names.map(&:to_sym))
    end
  end
end
