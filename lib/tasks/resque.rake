#lib/tasks/resque.rake

require 'resque/tasks'

namespace :resque do
  task setup: :environment do
    require 'resque'
  end

  desc "Stop all Resque workers"
  task stop_workers: :environment do
    pids = []

    Resque.workers.each do |worker|
      pids.concat worker.worker_pids
    end

    if pids.empty?
      puts "No Resque workers to kill"
    else
      puts "Killing Resque worker(s): #{pids.join(', ')}"

      system "kill -s QUIT #{pids.join(' ')}"
    end
  end
end
