folders = 'config,lib,models,policies,services,controllers'
Dir.glob("./{#{folders}}/init.rb").each do |file|
  require file
end
