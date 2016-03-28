require "calabash-cucumber/cucumber"

# This should be set to the parent directory containing the build folders
CODE_COVERAGE_BUILD_PARENT_PATH = ENV['CODE_COVERAGE_BUILD_PARENT_PATH']
if CODE_COVERAGE_BUILD_PARENT_PATH
  # NOTE: The following lines will get you the path to your intermediates dir as of XCode 7.2 if you are using a workspace. 
  # If you are using projects instead, you will want to modify this section.

  schema='Minion-cal'  
  # NOTE: If you are using a workspace
  #xc_workspace_path=Dir["#{CODE_COVERAGE_BUILD_PARENT_PATH}/*.xcworkspace"].first
  #intermediates_dir=`xcodebuild -showBuildSettings -workspace #{xc_workspace_path} -scheme #{schema} | grep -m 1 'PROJECT_TEMP_ROOT' | sed -n -e 's/^.*PROJECT_TEMP_ROOT = //p'`

  # NOTE: If you are using a project
  xcodeproj_path=Dir["#{CODE_COVERAGE_BUILD_PARENT_PATH}/*.xcodeproj"].first
  intermediates_dir=`xcodebuild -showBuildSettings -project #{xcodeproj_path} -scheme #{schema} | grep -m 1 'PROJECT_TEMP_ROOT' | sed -n -e 's/^.*PROJECT_TEMP_ROOT = //p'`


  CODE_COVERAGE_INTERMEDIATES_DIR=intermediates_dir.strip
end



