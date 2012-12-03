task "simpler_workflow:setup" => :environment do
  SimplerWorkflow.after_fork do
    ActiveRecord::Base.establish_connection
  end
end
