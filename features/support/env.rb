lib = File.expand_path('../../../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler'
Bundler.setup
require 'aruba'

def aruba_path(file_or_dir)
  File.expand_path("../../../#{file_or_dir.sub('example_app','aruba')}", __FILE__)
end

def example_app_path(file_or_dir)
  File.expand_path("../../../#{file_or_dir}", __FILE__)
end

def write_symlink(file_or_dir)
  source = example_app_path(file_or_dir)
  target = aruba_path(file_or_dir)
  system "ln -s #{source} #{target}"
end

Before do
  steps %Q{
    Given a directory named "touch"
  }

  Dir['tmp/example_app/*'].each do |file_or_dir|
    write_symlink(file_or_dir)
  end
end
