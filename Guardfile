# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'coffeescript', :output => '.' do
  watch(%r{(^.+\.coffee)})
end

guard 'compass' do
  watch(%r{(^.+\.s[ac]ss)})
end

guard 'livereload' do
  watch(%r{(^.+\.coffee)})
  watch(%r{(^.+\.s[ac]ss)})
  watch(%r{(^.+\.js)})
end
