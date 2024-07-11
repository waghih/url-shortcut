class LinksController < ApplicationController
  def index
    query = LinkQuery.new
    @links = query.paginate(page: params[:page], per_page: 10)
    @decorated_links = @links.map do |link|
      LinkDecorator.new(link)
    end
  end

  def show
    query = LinkQuery.new
    @link = LinkDecorator.new(query.with_visits.by_short_url(params[:id]))
  end

  def new
    @link = Link.new
  end

  def create
    service = LinkShortenerService.new(url_params[:original_url], url_params[:title])
    @link = service.build_short_url

    respond_to do |format|
      if @link.save
        format.html do
          redirect_to link_path(@link.short_url)
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('link_form', partial: 'links/form',
                                                                 locals: { link: @link })
        end
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

  def fetch_title
    service = LinkShortenerService.new(params[:original_url])
    title = service.fetch_title
    render json: { title: title }
  end

  private

  def url_params
    params.require(:link).permit(:original_url, :title)
  end

  def record_visit(link)
    Visit.create(
      link_id: link.id,
      geolocation: request.location.data,
      timestamp: Time.zone.now
    )
  end
end
