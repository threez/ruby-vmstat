# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :shell do
  watch(%r{^ext/.*$}) { `rake compile` }
end

guard :rspec, cmd: "bundle exec rspec"  do
  watch('spec/spec_helper.rb')    { "spec" }
  watch(%r{^spec/.+_spec\.rb$})   { |m| m[0] }
  watch(%r{^lib/(.+)\.rb$})       { "spec" }
end
