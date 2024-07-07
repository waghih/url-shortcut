class WebAddressQuery
  def initialize(relation = WebAddress.all)
    @relation = relation
  end

  def by_short_url(short_url)
    @relation.find_by(short_url: short_url)
  end

  def by_id(id)
    @relation.find(id)
  end
end