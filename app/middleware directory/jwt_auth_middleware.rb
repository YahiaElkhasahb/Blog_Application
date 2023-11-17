class JwtAuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    token = env['HTTP_AUTHORIZATION']&.split&.last
    if token
      begin
        decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)
        user_id = decoded_token[0]['sub']
        env['user_id'] = user_id
      rescue JWT::DecodeError, JWT::ExpiredSignature
        # Handle invalid or expired token
        return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Invalid token' }.to_json]]
      end
    end
    @app.call(env)
  end
end
