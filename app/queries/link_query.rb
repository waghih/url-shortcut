class LinkQuery
  def initialize(relation = Link.all)
    @relation = relation
  end

  def by_short_url(short_url)
    @relation.find_by(short_url: short_url)
  end

  def by_id(id)
    @relation.find(id)
  end

  def with_visits
    LinkQuery.new(@relation.includes(:visits))
  end

  def paginate(page: 1, per_page: 10)
    @relation.paginate(page: page, per_page: per_page)
  end
end
