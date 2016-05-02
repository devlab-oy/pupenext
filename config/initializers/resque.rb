Resque.redis = Redis.new(host: 'localhost', port: 6379)
Resque.redis.namespace = Rails.application.root.basename.to_s
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
# Resque.logger.formatter = Resque::VerboseFormatter.new
