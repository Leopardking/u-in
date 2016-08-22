class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(provider, uid)
    identity = Identity.find_by(provider: provider, uid: uid)
    identity = create(uid: uid, provider: provider) if identity.nil?
    identity
  end
end
