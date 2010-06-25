Given /^a widget named (.+)$/ do |widget_name|
  @widget = Widget.create!(:name => widget_name)
end

When /^I view the widget$/ do
  visit widget_path(@widget)
end

