class CreateConnectionWorker
  include Sidekiq::Worker

  def perform(user_id, ip_address)
    user = User.find(user_id)
    Connection.find_or_create_by(user: user, ip_address: ip_address)
  end
end
