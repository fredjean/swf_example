domain = SimplerWorkflow::Domain.domains("my-test-domain") do

  # Register hello activity.
  hello = register_activity(:hello, '1.0.0') do
    on_fail :abort
    next_activity :record, "1.0.0"

    perform_activity do |task|
      greeting = task.input
      task.results = {"message" => "Hello, #{greeting}" }
    end
  end

  # And start it's activity loop.
  hello.start_activity_loop

  # Register the record activity
  record = register_activity(:record, '1.0.0') do
    on_fail :abort

    perform_activity do |task|
      message = task.input
      puts message
    end
  end

  # And start it's activity loop
  record.start_activity_loop


  decision = register_workflow(:hello_world, "1.0.0") do
    initial_activity :hello, "1.0.0"

    on_activity_completed do |task, event|
      completed_event = scheduled_event(task, event)
      case conpleted_event.attributes.activity_type.name
      when "hello"
        task.schedule_activity_task record.to_activity_type, :input => completed_event.results
      when "record"
        task.complete_workflow :result => 'success'
      end
    end
  end

  decision.decision_loop
end
