class Keyword::WooCheckpoint < Keyword
  def self.sti_name
    :WOO_CHECKPOINT
  end

  def self.update_timestamp(run_type)
    checkpoint = last || new
    timestamps = checkpoint.selite.present? ? JSON.parse(checkpoint.selite, symbolize_names: true) : {}
    timestamps[run_type.to_sym] = Time.current
    checkpoint.selite = timestamps.to_json
    checkpoint.save!
  end

  def self.last_run_at(run_type)
    Time.zone.parse(JSON.parse(last.selite, symbolize_names: true)[run_type.to_sym])
  end
end
