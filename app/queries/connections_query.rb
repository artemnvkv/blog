class ConnectionsQuery
  attr_reader :relation, :limit, :offset

  def initialize(limit = 10, relation: Connection.joins(:user))
    @relation = relation
    @limit = limit || 10
  end

  def ip_list
    @relation
      .group(:ip_address)
      .having('COUNT(*) > 1')
      .limit(@limit)
      .pluck('ip_address, json_agg(users.login)')
  end
end
