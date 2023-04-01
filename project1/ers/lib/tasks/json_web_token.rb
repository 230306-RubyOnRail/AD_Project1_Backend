# frozen_string_literal: true

class JsonWebToken
  def self.encode(payload)
    exp = 1.hour.from_now.to_i
    JWT.encode(payload, Rails.application.credentials.jwt_token_secret, 'HS256', exp: exp)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.jwt_token_secret, true, {algorithm: 'HS256'})[0]
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    raise ExceptionHandler::ExpiredSignature, e.message
  rescue JWT::DecodeError, JWT::VerificationError => e
    raise ExceptionHandler::DecodeError, e.message
  end
end
