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
end