require 'rake/testtask'

if ::Rails.version.to_f >= 3.2
  require 'rails/test_unit/sub_test_task'
else
  module Rails
    # Silence the default description to cut down on `rake -T` noise.
    class SubTestTask < Rake::TestTask
      def desc(string)
        # Ignore the description.
      end
    end
  end
end

TASKS = %w(models controllers helpers mailers acceptance) #views
MINITEST_TASKS = TASKS.map { |sub| "minitest:#{sub}" }

desc "Runs minitest"
task :test do
  Rake::Task['minitest'].invoke
end

desc "Runs #{MINITEST_TASKS.join(", ")} together"
task :minitest do
  Rake::Task['minitest:run'].invoke
end

namespace 'minitest' do

  task :prepare do
    # Placeholder task for other Railtie and plugins to enhance. See Active Record for an example.
  end

  task :run do
    errors = MINITEST_TASKS.collect do |task|
      begin
        Rake::Task[task].invoke
        nil
      rescue => e
        { :task => task, :exception => e }
      end
    end.compact

    if errors.any?
      puts errors.map { |e| "Errors running #{e[:task]}! #{e[:exception].inspect}" }.join("\n")
      abort
    end
  end

  TASKS.each do |sub|
    Rails::SubTestTask.new(sub => 'minitest:prepare') do |t|
      t.libs.push 'test'
      t.pattern = "test/#{sub}/**/*_test.rb"
    end
  end

end
