Given(/^use_numbered_parts_on_index is set to true$/) do
  ActsAsMultipartForm.config.use_numbered_parts_on_index = true
end

Given(/^use_numbered_parts_on_index is set to false$/) do
  ActsAsMultipartForm.config.use_numbered_parts_on_index = false
end

Given /^show_previous_next_links is set to true$/ do
  ActsAsMultipartForm.config.show_previous_next_links = true
end

Given /^show_previous_next_links is set to false$/ do
  ActsAsMultipartForm.config.show_previous_next_links = false
end

Given /^show_incomplete_parts is set to true$/ do
  ActsAsMultipartForm.config.show_incomplete_parts = true
end

Given /^show_incomplete_parts is set to false$/ do
  ActsAsMultipartForm.config.show_incomplete_parts = false
end
