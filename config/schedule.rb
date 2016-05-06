set :output, "#{path}/log/cron.log"

every 5.minutes do
  runner 'IncomingMailJob.perform_later'
end
