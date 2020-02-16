class PostHandler
  include ActiveModel::Validations

  validates :title, presence: true
  validates :body, presence: true
  validates :ip_address, presence: true, ip: true
  validates :login, presence: true

  attr_reader :login, :title, :body, :ip_address, :post

  def self.execute(params)
    new(params).tap(&:create_post)
  end

  def initialize(params)
    @login = params[:login]
    @title = params[:title]
    @body = params[:body]
    @ip_address = params[:ip_address]
  end

  def create_post
    return self unless valid?

    user = User.find_by(login: @login)

    ActiveRecord::Base.transaction do
      user ||= User.create!(login: @login)

      @post = Post.create!(
        user: user,
        ip_address: @ip_address,
        title: @title,
        body: @body
      )
    end

    CreateConnectionWorker.perform_async(user.id, @ip_address)

    self
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end
