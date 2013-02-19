class TeamMember < ActiveRecord::Base
  belongs_to :season
  belongs_to :user
end

# == Schema Information
#
# Table name: players
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  season_id  :integer          default(0), not null
#  updated_at :datetime         not null
#  user_id    :integer          default(0), not null
#
