lib = File.expand_path(File.dirname(__FILE__) + '/lib')
$:.unshift lib unless $:.include?(lib)

require 'basic_assumption/version'

Gem::Specification.new do |s|
  s.name = %q{basic_assumption}
  s.version = BasicAssumption::Version::STRING

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Yoho"]
  s.description = %q{
    Allows a simple declarative idiom for accessing resources in controllers and views
    via a well-defined interface that increases testability and reduces shared state.
    }
  s.email = %q{mby@mattyoho.com}
  s.extra_rdoc_files = [
    "HISTORY.rdoc",
    "MIT-LICENSE",
    "README.rdoc"
  ]
  s.files = [
     "HISTORY.rdoc",
     "MIT-LICENSE",
     "README.rdoc",
     "lib/basic_assumption.rb",
     "lib/basic_assumption/configuration.rb",
     "lib/basic_assumption/configuration/active_record.rb",
     "lib/basic_assumption/default_assumption.rb",
     "lib/basic_assumption/default_assumption/action.rb",
     "lib/basic_assumption/default_assumption/base.rb",
     "lib/basic_assumption/default_assumption/class_resolver.rb",
     "lib/basic_assumption/default_assumption/name.rb",
     "lib/basic_assumption/default_assumption/owner_attributes.rb",
     "lib/basic_assumption/default_assumption/rails.rb",
     "lib/basic_assumption/rails.rb",
     "lib/basic_assumption/rspec.rb",
     "lib/basic_assumption/version.rb",
     "rails/init.rb"
  ]
  s.homepage = %q{http://github.com/mattyoho/basic_assumption}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = ">= 1.3.5"
  s.summary = %q{Allows a simple declarative idiom for accessing resources in controllers and views, cleaning up controller code and removing the need to explicitly reference instance variables inside views. Custom default behavior can be defined in a pluggable manner.}
  s.test_files = [
    "spec/spec_helper.rb",
    "spec/basic_assumption_spec.rb",
    "spec/basic_assumption/configuration_spec.rb",
    "spec/basic_assumption/default_assumption_spec.rb",
    "spec/basic_assumption/default_assumption/base_spec.rb",
    "spec/basic_assumption/default_assumption/class_resolver_spec.rb",
    "spec/basic_assumption/default_assumption/rails_spec.rb"
  ]
  s.specification_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION

  s.add_dependency('activesupport', '> 3.0.0')
end

