# frozen_string_literal: true

module JsonWebToken
  def self.encode(payload)
    Rails.logger.info('JSON Web Token: Encoding token')
    exp = 1.hour.from_now.to_i
    JWT.encode(payload, Rails.application.credentials.jwt_token_secret, 'HS256', exp:)
  end

  def self.decode(token)
    expiredToken = 'Expired Token'
    decodeError = 'Invalid Token'
    Rails.logger.info('JSON Web Token: Decoding token')
    JWT.decode(token, Rails.application.credentials.jwt_token_secret, true, { algorithm: 'HS256' })[0]
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    expiredToken
    # raise JWT::ExpiredSignature, e.message
  rescue JWT::DecodeError, JWT::VerificationError => e
    decodeError
    # raise JWT::DecodeError, e.message
  end
end
