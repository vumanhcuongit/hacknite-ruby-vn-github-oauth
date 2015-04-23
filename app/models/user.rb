# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  provider         :string
#  uid              :string
#  name             :string
#  oauth_token      :string
#  oauth_expires_at :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    user = self.find_or_create_by(
      provider: auth.provider,
      uid: auth.uid
    )
    user.tap do |u|
      u.name = auth.info.name
      u.oauth_token = auth.credentials.token
      u.oauth_expires_at = Time.at(30.days.from_now)
      u.save!
    end
  end
end
