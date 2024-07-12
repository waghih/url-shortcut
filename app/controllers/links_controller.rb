class LinksController < ApplicationController
  before_action :set_link_query, only: %i[index show destroy redirect search_stats]

  def index
    @links = @query.paginate(page: params[:page], per_page: 10)
    @decorated_links = @links.map { |link| LinkDecorator.new(link) }
  end

  def show
    @link = LinkDecorator.new(@query.with_visits.by_short_url(params[:id]))
  end

  def new
    @link = Link.new
  end

  def create
    service = LinkShortenerService.new(url_params[:original_url], url_params[:title])
    @link = service.build_short_url

    respond_to do |format|
      if @link.save
        format.html { redirect_to link_path(@link.short_url) }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('link_form', partial: 'links/form',
                                                                 locals: { link: @link })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @link = LinkDecorator.new(@query.by_short_url(params[:id]))

    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url }
      format.json { head :no_content }
    end
  end

  def redirect
    @link = @query.by_short_url(params[:short_url])

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

  def statistic; end

  def search_stats
    @link = LinkDecorator.new(@query.by_short_url(params[:short_url]))

    if @link.present?
      redirect_to link_path(@link.short_url)
    else
      render file: Rails.public_path.join('404.html').to_s, status: :not_found
    end
  end

  private

  def set_link_query
    @query = LinkQuery.new
  end

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
