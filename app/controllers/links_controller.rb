class LinksController < ApplicationController
  def show
    query = LinkQuery.new
    @link = LinkDecorator.new(query.by_short_url(params[:id]))
    # binding.pry
  end

  def new
    @link = Link.new
  end

  def create
    service = LinkShortenerService.new(url_params[:original_url])
    @link = service.build_short_url

    respond_to do |format|
      if @link.save
        format.html { redirect_to link_path(@link.short_url), notice: 'Link was successfully created.' }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('link', partial: 'links/form', locals: { link: @link }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def redirect
    query = LinkQuery.new
    @link = query.by_short_url(params[:short_url])

    if @link
      record_visit(@link)
      redirect_to @link.original_url, allow_other_host: true
    else
      render plain: 'URL not found', status: :not_found
    end
  end

  private

  def url_params
    params.require(:link).permit(:original_url, :title)
  end

  def record_visit(link)
    Visit.create(
      link_id: link.id,
      geolocation: request.location.to_s,
      timestamp: Time.now
    )
  end
end
