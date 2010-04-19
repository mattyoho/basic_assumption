Gem::Specification.new do |s|
  s.name = %q{basic_assumption}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Yoho"]
  s.date = %q{2010-04-17}
  s.description = %q{
    Allows a simple declarative idiom for resources in controllers and views
    }
  s.email = %q{mby@mattyoho.com}
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
     "README.md",
     "VERSION",
     "lib/basic_assumption.rb"
  ]
  s.homepage = %q{http://github.com/mattyoho/basic_assumption}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Allows a simple declarative idiom for resources in controllers and views}
  s.test_files = [
    "spec/spec_helper.rb",
    "spec/lib/basic_assumption_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
  end
end

