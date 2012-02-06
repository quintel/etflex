class UsersController < Devise::RegistrationsController
  def create
    remote_ip = request.remote_ip
    params[:user][:ip] = remote_ip

    request = HTTParty.get("http://api.ipinfodb.com/v3/ip-city/?key=1d0a3bc50d937dc0d04baa2af8bf4e6e6f594a1c27d0003d3634be881d5459ed&ip=#{remote_ip}&format=json")
    params[:user][:city] = request.parsed_response[:countryName]
    params[:user][:country] = request.parsed_response[:cityName]
    params[:user][:latitude] = request.parsed_response[:latitude].to_f
    params[:user][:longitude] = request.parsed_response[:longitude].to_f

    super
  end
end