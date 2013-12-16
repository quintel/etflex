class UsersController < Devise::RegistrationsController
  def create
    params[:user][:ip] = request.remote_ip
    params[:user].merge request_location(request)

    super
  end

  #######
  private
  #######

  # Location information about the given request.
  #
  # request - The request whose location is to be determined.
  #
  # Returns a hash of location information, or an empty hash if no location
  # could be determined.
  def request_location(req)
    return {} if ETFlex.config.ipinfodb_key.nil?

    location_response = RestClient.get(
      'http://api.ipinfodb.com/v3/ip-city/', params: {
        key:     ETFlex.config.ipinfodb_key,
        ip:      req.remote_ip,
        format: 'json' })

    parsed = JSON.parse(location_response)

    { country:   parsed['countryName'].titleize,
      city:      parsed['cityName'].titleize,
      latitude:  parsed['latitude'].to_f,
      longitude: parsed['longitude'].to_f }

  rescue SocketError, JSON::ParserError
    Hash.new
  end
end
