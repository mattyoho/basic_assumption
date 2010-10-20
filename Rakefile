begin
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'

  task :default => [:spec, :cucumber]

  desc "Run specs"
  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = %w(--format=progress --color)
  end

  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = %w{--format progress}
  end
rescue LoadError
  puts "Warning: RSpec or Cucumber is not installed"
end

namespace :generate do
  desc 'Generate Rails app for integration testing'
  task :app do
    unless File.directory? './tmp/example_app'
      if `rails -v` =~ /\ARails 3/
        system 'rails new ./tmp/example_app'
      else
        system 'rails ./tmp/example_app'
        Dir.chdir("./tmp/example_app/") do
          system 'script/generate cucumber'
          system 'cp ../../templates/environment.rb ./config/'
          system 'cp ../../templates/test.rb ./config/environments/test.rb'
          system 'cp ../../templates/custom_steps.rb ./features/step_definitions/'
        end
      end
    end
  end

  desc 'Generate scaffolds, etc'
  task :custom => ['generate:app'] do
    Dir.chdir("./tmp/example_app/") do
      system "rake rails:template LOCATION='../../templates/generate_custom.rb'"
    end
  end
end

namespace :gem do
  desc 'Builds the gem from the current gemspec'
  task :build do
    system 'mkdir -p ./pkg'
    system 'gem build ./basic_assumption.gemspec'
    system 'mv ./basic_assumption-*.gem ./pkg/basic_assumption-EDGE.gem'
  end
  desc 'Installs the built gem'
  task :install => :build do
    system 'gem install ./pkg/basic_assumption-EDGE.gem'
  end
end

namespace :bundle do
  desc "Installs the dependencies listed in Gemfile"
  task :install => "gem:install" do
    if RUBY_VERSION =~ /^1\.8/
      system 'bundle install --without onenine'
    elsif RUBY_VERSION =~ /^1\.9/
      system 'bundle install --without oneeight'
    end
  end
end

desc 'Sets up the test environment for cukes'
task :setup => ['bundle:install', 'generate:custom']

desc 'Sets up and runs the spec and cuke suites'
task :init => [:clobber, :setup]

namespace :clobber do
  desc 'Remove generated Rails app'
  task :app do
    rm_rf './tmp/example_app'
  end
end

desc 'Remove generated code'
task :clobber do
  rm_rf './tmp'
  rm_rf './pkg'
end
