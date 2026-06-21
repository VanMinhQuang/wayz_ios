require 'xcodeproj'

project_path = 'wayz_ios.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.find { |t| t.name == 'wayz_ios' }

# Find or create groups
wayz_group = project.main_group.find_subpath(File.join('wayz_ios'), true)
presentation_group = wayz_group.find_subpath('Presentation', true)
theme_group = presentation_group.find_subpath('Theme', true)
theme_group.set_source_tree('<group>')
theme_group.set_path('Theme')

file_path = 'wayz_ios/Presentation/Theme/AppTheme.swift'
unless theme_group.files.any? { |f| f.path == 'AppTheme.swift' }
  file_ref = theme_group.new_file('AppTheme.swift')
  target.add_file_references([file_ref])
  puts "Added AppTheme.swift to Xcode project"
else
  puts "AppTheme.swift already in Xcode project"
end

project.save
