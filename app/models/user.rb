class User < ApplicationRecord
  has_many :page_managements
  has_many :pages, through: :page_managements, autosave: true

  def pull
    self.access_token = oauth.exchange_access_token(access_token)
    self.name = me['name']
    self.pages = accounts.map do |account|
      page = Page.where(facebook_id: account['id']).first_or_initialize
      page.name = account['name']
      page.access_token = account['access_token']
      logger.debug "page.access_token: #{page.access_token}"
      page.pull
      page
    end
  end

  private

  def me
    graph.get_object('me')
  end

  def accounts
    graph.get_connection('me', 'accounts')
  end

  def graph
    Koala::Facebook::API.new(access_token)
  end

  def oauth
    @oauth ||= Koala::Facebook::OAuth.new
  end
end
