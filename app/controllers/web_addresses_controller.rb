class WebAddressesController < ApplicationController
  def new
    @web_address = WebAddress.new
  end

  def create
    service = UrlShortenerService.new(url_params[:original_url])
    @web_address = service.generate_short_url

    if @web_address.persisted?
      redirect_to @web_address
    else
      render :new
    end
  end

  def show
    query = WebAddressQuery.new
    @web_address = WebAddressDecorator.new(query.by_id(params[:id]))
  end

  def redirect
    query = WebAddressQuery.new
    @web_address = query.by_short_url(params[:short_url])

    if @web_address
      redirect_to @web_address.original_url, allow_other_host: true
    else
      render plain: "URL not found", status: :not_found
    end
  end

  private

  def url_params
    params.require(:web_address).permit(:original_url)
  end
end
