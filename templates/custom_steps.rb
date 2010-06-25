Given /^a (?:|derived )widget named (.+)$/ do |widget_name|
  @widget = Widget.create!(:name => widget_name)
end

When /^I view the (derived )?widget$/ do |derived|
  if derived
    visit derived_widget_path(@widget)
  else
    visit widget_path(@widget)
  end
end

