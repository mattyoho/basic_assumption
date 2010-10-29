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
  namespace :rails3 do
    desc 'Generate Rails 3 app for integration testing'
    task :app do
      unless File.directory? './tmp/example_app'
        template_dir = '../../templates/rails3/'

        system 'rails new ./tmp/example_app --skip-gemfile'

        Dir.chdir("./tmp/example_app/") do
          system 'rails generate cucumber:install --capybara'

          ['Gemfile',
           'features/step_definitions/custom_steps.rb'].each do |file|
            system "cp #{template_dir + file} ./#{file}"
          end

          system "bundle install"
        end
      end
    end

    desc 'Generate scaffolds, etc'
    task :custom => ['generate:rails3:app'] do
      Dir.chdir("./tmp/example_app/") do
        system "rake rails:template LOCATION='../../templates/generate_custom.rb'"
      end
    end
  end

  namespace :rails2 do
    desc 'Generate Rails 2.3 app for integration testing'
    task :app do
      unless File.directory? './tmp/example_app'
        template_dir = '../../templates/rails2/'

        system 'rails ./tmp/example_app'

        Dir.chdir("./tmp/example_app/") do
          system 'script/generate cucumber'

          ['Gemfile',
           'config/boot.rb',
           'config/preinitializer.rb',
           'features/step_definitions/custom_steps.rb'].each do |file|
            system "cp #{template_dir + file} ./#{file}"
          end

          system "bundle install"
        end
      end
    end

    desc 'Generate scaffolds, etc'
    task :custom => ['generate:rails2:app'] do
      Dir.chdir("./tmp/example_app/") do
        system "rake rails:template LOCATION='../../templates/generate_custom.rb'"
      end
    end
  end
end

namespace :gem do
  desc 'Builds the gem from the current gemspec'
  task :build do
    system 'mkdir -p ./pkg'
    system 'gem build ./basic_assumption.gemspec'
    system 'mv ./basic_assumption-*.gem ./pkg/'
  end
end

namespace :bundle do
  namespace :install do
    desc "Installs the dependencies listed in Gemfile.rails2"
    task :rails2 do
      system 'cp Gemfile.rails2 Gemfile && bundle install'
    end

    desc "Installs the dependencies listed in Gemfile.rails3"
    task :rails3 do
      system 'cp Gemfile.rails3 Gemfile && bundle install'
    end
  end
end

namespace :rvm do
  desc "Creates a gemset and outputs the command to use it"
  task :gemset do
    if `which rvm` =~ /\w+/
      gemset_name = "basic_assumption-#{RUBY_VERSION.gsub(/\./, '')}"

      system "rvm gemset create #{gemset_name}"

      puts "Run the following command to use an RVM gemset:"
      puts ""
      puts "  rvm gemset use #{gemset_name}"
      puts ""
    end
  end
end

namespace :setup do
  desc 'Sets up the test environment for Rails 2.3'
  task :rails2 => ['bundle:install:rails2', 'generate:rails2:custom']

  desc 'Sets up the test environment for Rails 3'
  task :rails3 => ['bundle:install:rails3', 'generate:rails3:custom']
end

namespace :init do
  desc 'Sets up and runs the spec and cuke suites using Rails 2.3'
  task :rails2 => [:clobber, 'setup:rails2']

  desc 'Sets up and runs the spec and cuke suites using Rails 3'
  task :rails3 => [:clobber, 'setup:rails3']
end

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
