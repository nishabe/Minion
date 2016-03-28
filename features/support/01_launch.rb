require 'calabash-cucumber/launcher'
module Calabash::Launcher
    @@launcher = nil
    
    def self.launcher
        @@launcher ||= Calabash::Cucumber::Launcher.new
    end

    def self.launcher=(launcher)
        @@launcher = launcher
    end
end


Before do |scenario|
    launcher = Calabash::Launcher.launcher
    options = {
        # Add launch options here.
    }
    
    launcher.relaunch(options)
    launcher.calabash_notify(self)
end


AfterConfiguration do |config|
  CodeCoverage.clean_up_code_coverage_archive_folder
  CodeCoverage.generate_lcov_baseline_info_file
end
 
Before do |scenario|
  $calabash_launcher = Calabash::Cucumber::Launcher.launcher
 
  CodeCoverage.clean_up_last_run_files
 
#... snip ...
end
 
After do |scenario|
  begin
    CodeCoverage.flush
  rescue Errno::ECONNREFUSED
    CodeCoverage.generate_failed_coverage_file(scenario)
    raise
  end
 
  unless $calabash_launcher.calabash_no_stop?
    calabash_exit
    if $calabash_launcher.active?
      $calabash_launcher.stop
    end
  end
 
  if scenario.passed?
    CodeCoverage.generate_lcov_info_file(scenario)
  else
    CodeCoverage.generate_failed_coverage_file(scenario)
  end
end
 
at_exit do
  $calabash_launcher = Calabash::Cucumber::Launcher.launcher
 
  if $calabash_launcher.simulator_target?
    $calabash_launcher.simulator_launcher.stop unless $calabash_launcher.calabash_no_stop?
  else
    #unmount_device
  end
 
  CodeCoverage.combine_lcov_info_files
  CodeCoverage.generate_lcov_reports_from_info_file
end