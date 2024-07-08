class LinksController < ApplicationController
  def new
    @link = Link.new
  end

  def create
    service = LinkShortenerService.new(url_params[:original_url])
    @link = service.build_short_url

    if @link.save
      redirect_to link_path(@link.short_url)
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('form', partial: 'links/form', locals: { link: @link })
        end
        format.html { render :new }
      end
    end
  end

  def show
    query = LinkQuery.new
    @link = LinkDecorator.new(query.by_short_url(params[:id]))
  end

  def redirect
    query = LinkQuery.new
    @link = query.by_short_url(params[:short_url])

    if @link
      redirect_to @link.original_url, allow_other_host: true
    else
      render plain: "URL not found", status: :not_found
    end
  end

  private

  def url_params
    params.require(:link).permit(:original_url, :title)
  end
end
