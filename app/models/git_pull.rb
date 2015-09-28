class GitPull < ActiveRecord::Base
  self.table_name  = :git_paivitykset
  self.primary_key = :id

  def self.update_pupenext_hash
    lastid = get_pupenext_hash
    lastid.update(hash_pupenext: get_current_git_hash) if lastid
  end

  def self.get_pupenext_hash
    where.not(hash_pupesoft: 'github_api_request').order(id: :desc).limit(1).last
  end

  def self.get_current_git_hash
    `git rev-parse HEAD`.strip
  end
end
