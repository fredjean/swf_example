task "simpler_workflow:setup" => :environment do
  SimplerWorkflow.after_fork do
    ActiveRecord::Base.establish_connection
  end
end

namespace :swf do
  desc "Fire off the sample workflow"
  task :fire => :environment do
    SimplerWorkflow::Domain["my-test-domain"].start_workflow("hello-world", "1.0.0", "AWS")
  end
end
