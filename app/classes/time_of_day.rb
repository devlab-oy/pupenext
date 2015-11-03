class TimeOfDay

  attr_accessor :hour, :min, :sec

  def initialize(time: '00:00:00')
    parse_time time
  end

  def to_s
    "#{hour}:#{min}:#{sec}"
  end

  def ==(obj)
    self.to_s == obj.to_s
  end

  private

    def parse_time(time)
      # Assume the time format for string is hh:mm:ss
      if time.is_a? String
        @hour, @min, @sec = time.split ":"
      elsif time.respond_to? :strftime
        @hour = time.strftime '%H'
        @min = time.strftime '%M'
        @sec = time.strftime '%S'
      else
        raise ArgumentError, "pass time as string or datetime or time"
      end
    end
end
