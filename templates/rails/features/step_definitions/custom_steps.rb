Given /^a (?:|derived )widget named "(.+)"$/ do |widget_name|
  @widget = Widget.create!(:name => widget_name)
end

Given /^I own a widget named "(.+)"$/ do |widget_name|
  @widget = Widget.create!(:name => widget_name, :user_id => 42)
end

Given /^the following widgets:$/ do |table|
  table.hashes.each do |widget_hash|
    Widget.create!(widget_hash)
  end
end

When /^I view the (derived )?widget$/ do |derived|
  if derived
    visit derived_widget_path(@widget)
  else
    visit widget_path(@widget)
  end
end

When /^I edit the widget$/ do
  visit edit_widget_path(@widget)
end

When /^I view all widgets$/ do
  visit widgets_path
end

When /^I view all widgets and there is an id in params$/ do
  visit widgets_path(:id => @widget.id)
end

When /^I view page (\d+) of all widgets(?: with (\d+) per page)?$/ do |page, per_page|
  visit widgets_path(:page => page, :per_page => per_page)
end
