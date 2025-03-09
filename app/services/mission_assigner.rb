class MissionAssigner
  def self.assign_missions
    User.with_few_missions.each do |user|
      available_mission_ids = (1..5).to_a - user.assigned_mission_ids
      next if available_mission_ids.empty?

      user.assign_new_mission(available_mission_ids.sample)
    end
  end
end
