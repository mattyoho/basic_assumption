require 'aruba/api'

When /^I run `([^`]*)` with a clean Bundler environment$/ do |cmd|
  Bundler.with_clean_env { run_simple(unescape(cmd), false) }
end

