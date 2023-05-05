module Api
  module V1
    class BaseController < ActionController::API
      def not_found
        render json: { error: 'not_found' }
      end

      def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JWTHelper.decode(header)
          @current_user = User.find(@decoded[:user_id])
        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError
          render json: { errors: 'Invalid token.' }, status: :unauthorized
        end
      end

      def error(message, status, error_type = nil)
        if error_type.present?
          render json: { "code": status, "message": message, "error_type": error_type }
        else
          render json: { "code": status, "message": message }
        end
      end
    end
  end
end
