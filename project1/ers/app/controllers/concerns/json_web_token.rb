module JsonWebToken

  def self.encode(payload)
    exp = 1.hour.from_now.to_i
    JWT.encode(payload, Rails.application.credentials.jwt_token_secret, 'HS256', exp: exp)
  end

  def self.decode(token)
    expiredToken = 'Expired Token'
    decodeError = 'Invalid Token'
    JWT.decode(token, Rails.application.credentials.jwt_token_secret, true, {algorithm: 'HS256'})[0]
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    return expiredToken
    # raise JWT::ExpiredSignature, e.message
  rescue JWT::DecodeError, JWT::VerificationError => e
    return decodeError
    # raise JWT::DecodeError, e.message
  end
end