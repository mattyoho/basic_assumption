lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'basic_assumption/version'

Gem::Specification.new do |s|
  s.name = %q{basic_assumption}
  s.version = BasicAssumption::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Yoho"]
  s.date = %q{2010-05-25}
  s.description = %q{
    Allows a simple declarative idiom for accessing resources in controllers and views
    }
  s.email = %q{mby@mattyoho.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
     "README.rdoc",
     "lib/basic_assumption.rb",
     "lib/basic_assumption/configuration.rb",
     "lib/basic_assumption/default_assumption.rb",
     "lib/basic_assumption/default_assumption/base.rb",
     "lib/basic_assumption/default_assumption/class_resolver.rb",
     "lib/basic_assumption/default_assumption/rails.rb",
     "lib/basic_assumption/default_assumption/simple_rails.rb",
     "lib/basic_assumption/rails.rb",
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
    "spec/lib/basic_assumption_spec.rb",
    "spec/lib/basic_assumption/configuration_spec.rb",
    "spec/lib/basic_assumption/default_assumption_spec.rb",
    "spec/lib/basic_assumption/default_assumption/base_spec.rb",
    "spec/lib/basic_assumption/default_assumption/class_resolver_spec.rb",
    "spec/lib/basic_assumption/default_assumption/simple_rails_spec.rb",
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_development_dependency(%q<actionpack>, [">= 2.3.5"])
      s.add_development_dependency(%q<activesupport>, [">= 2.3.5"])
    else
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_dependency(%q<actionpack>, [">= 2.3.5"])
      s.add_dependency(%q<activesupport>, [">= 2.3.5"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
    s.add_dependency(%q<actionpack>, [">= 2.3.5"])
    s.add_dependency(%q<activesupport>, [">= 2.3.5"])
  end
end

