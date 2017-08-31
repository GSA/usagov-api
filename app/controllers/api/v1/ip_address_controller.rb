class Api::V1::IpAddressController < Api::V1::ApiController

  # if you are looking at this on your local development, it will be wrong. 
  # it is looking at headers that only really exist in production (especially when behind web servers)
  # it has worked in our testing environments and production, so consider testing it where you are running it
  # before modifying it
  def show
    @ip = request.remote_ip
    render "show"
  end
end