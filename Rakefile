require 'bundler'
Bundler.setup

begin
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'

  desc "Run specs"
  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = %w(--format=progress --color)
  end

  Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = %w{--format progress}
  end
rescue LoadError
  puts "Warning: RSpec or Cucumber is not installed"
end

module BasicAssumptionRakeUtils
  TEMPLATE_DIR = 'templates/rails/'
end

task :default => [:spec, :cucumber]

directory "tmp/example_app"

file "tmp/example_app/Gemfile" => "tmp/example_app" do
  open("tmp/example_app/Gemfile", "w") do |gemfile|
    open("#{BasicAssumptionRakeUtils::TEMPLATE_DIR}Gemfile") do |template|
      gemfile << template.read
    end
  end
end

namespace :example_app do
  task :bundle => "tmp/example_app/Gemfile" do
    Bundler.with_clean_env do
      system 'cd ./tmp/example_app/ && bundle'
    end
  end

  task :generate => "example_app:bundle" do
    Bundler.with_clean_env do
      Dir.chdir("./tmp/example_app/") do
        system 'bundle exec rails new ./ -JSGT --skip-gemfile --skip-bundle'
        system 'bundle exec rails generate cucumber:install --capybara'
        system 'bundle exec rails generate cucumber_rails_training_wheels:install'
      end
    end
  end

  task :customize => 'example_app:generate' do
    Bundler.with_clean_env do
      Dir.chdir("./tmp/example_app/") do
        system "bundle exec rake rails:template LOCATION='../../templates/generate_custom.rb'"
      end

      custom_steps = 'features/step_definitions/custom_steps.rb'
      system "cp #{BasicAssumptionRakeUtils::TEMPLATE_DIR}#{custom_steps} tmp/example_app/#{custom_steps}"
    end
  end
end

desc 'Generate customized Rails 3 app for integration testing'
task :init => [:clobber, 'example_app:customize']

desc 'Remove all generated test files'
task :clobber do
  rm_rf './tmp'
  rm_rf './pkg'
end

namespace :gem do
  desc 'Builds the gem from the current gemspec'
  task :build do
    system 'mkdir -p ./pkg'
    system 'gem build ./basic_assumption.gemspec'
    system 'mv ./basic_assumption-*.gem ./pkg/'
  end
end

namespace :rvm do
  desc "Creates a gemset and outputs the command to use it"
  task :gemset  => "tmp/example_app" do
    if `which rvm` =~ /\w+/

      system "rvm gemset create basic_assumption"

      puts "Run the following command to use an RVM gemset:"
      puts ""
      puts "  rvm gemset use basic_assumption"
      puts ""
    else
      puts "You don't appear to have RVM installed!"
    end
  end
end

