module ResqueMonitor
  NAGIOS_STATE_OK       = 0;
  NAGIOS_STATE_WARNING  = 1;
  NAGIOS_STATE_CRITICAL = 2;

  def self.nagios_resque_email
    options  = {
      redis_host: 'localhost',
      redis_port: '6379',
      queue:      'PupeEmail',
      critical:   100,
      warning:    50
    }

    check_queue options
  end

  def self.nagios_resque_failed
    options  = {
      redis_host: 'localhost',
      redis_port: '6379',
      critical:   10,
      warning:    5
    }

    check_failed options
  end

  private

    def self.check_queue(options)
      queuename = "Resque queue #{options[:queue]}"

      redis = Redis.new(:host => options[:redis_host], :port => options[:redis_port])
      Resque.redis = redis

      begin
        queue_size = Resque.size(options[:queue])
      rescue
        status = "CRITICAL - #{queuename} not found #{NAGIOS_STATE_CRITICAL}"
        return status
      end

      status = "OK - #{queuename} ok #{NAGIOS_STATE_OK}"

      if queue_size >= options[:critical]
        status = "CRITICAL - #{queuename} size #{queue_size} #{NAGIOS_STATE_CRITICAL}"
      elsif queue_size >= options[:warning]
        status = "WARNING - #{queuename} size #{queue_size} #{NAGIOS_STATE_WARNING}"
      end

      status
    end

    def self.check_failed(options)
      redis = Redis.new(:host => options[:redis_host], :port => options[:redis_port])
      Resque.redis = redis

      begin
        failed_count = Resque::Failure.count
      rescue
        status = "CRITICAL - Cannot get Resque failed count #{NAGIOS_STATE_CRITICAL}"
        return status
      end

      status = "OK - Resque failed count is ok #{NAGIOS_STATE_OK}"

      if failed_count >= options[:critical]
        status = "CRITICAL - Resque failed count is #{failed_count} #{NAGIOS_STATE_CRITICAL}"
      elsif failed_count >= options[:warning]
        status = "WARNING - Resque failed count is #{failed_count} #{NAGIOS_STATE_WARNING}"
      end

      status
    end
end
