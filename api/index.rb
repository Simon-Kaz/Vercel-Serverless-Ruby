require 'jwt'
require 'json'

Handler = Proc.new do |request, response|
    hmac_secret = 'Fk1C2WNIpOHrcWiFKhrCjNFsvKHmEqYSlnmL80N1pSFWJvok'
    
    iat = Time.now.to_i
    
    jti_raw = [hmac_secret, iat].join(':').to_s
    jti = Digest::MD5.hexdigest(jti_raw)

    payload = { name: 'Szymon', email: 'simonkaz@simonkaz.com', jti: jti, iat: iat}
    
    token = JWT.encode payload, hmac_secret, 'HS256'

    # eyJhbGciOiJub25lIn0.eyJkYXRhIjoidGVzdCJ9.
    puts token

    # Set password to nil and validation to false otherwise this won't work
    decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }

    # Array
    # [
    #   {"data"=>"test"}, # payload
    #   {"alg"=>"HS256"} # header
    # ]
    puts decoded_token

    response.status = 200
    response['Content-Type'] = 'application/json'
    response.body = {:jwt => token }.to_json
end
