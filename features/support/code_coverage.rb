class CodeCoverage
  @app_name = 'Minion'

  @build_path = CODE_COVERAGE_BUILD_PARENT_PATH || ''
  @code_coverage_folder_path = File.join(@build_path, 'CodeCoverage/')
  @baseline_info_filename = "#{@app_name}_base.info"
  @combined_info_filename = "#{@app_name}_combined.info"
  @project_intermediates = CODE_COVERAGE_INTERMEDIATES_DIR

  # Check to see if we are set up to collect code coverage
  # @return [Boolean] True if code coverage is on (CODE_COVERAGE_BUILD_PARENT_PATH was set to something), false if not
  def self.on?
    return !@build_path.empty?
  end

  # If this is a code coverage build, we need to remove the old code coverage files between each scenario
  def self.clean_up_last_run_files
    if self.on?
      puts("[CODE COVERAGE] Deleting .gcda files from #{@project_intermediates}")
      `cd #{@project_intermediates} && find . -name "*.gcda" -print0 | xargs -0 rm`
    end
  end

  # Clean up the folder that contains old .info files and reports
  def self.clean_up_code_coverage_archive_folder
    if self.on?
      Dir.chdir(@build_path)

      puts("[CODE COVERAGE] Deleting the #{@code_coverage_folder_path} directory.")
      FileUtils.rmtree(@code_coverage_folder_path) if Dir.exists?(@code_coverage_folder_path)
    end
  end

  # Tell the app to output coverage files
  def self.flush
    # Flush the code coverage
    if self.on?
      puts('[CODE COVERAGE] Flushing code coverage.')
      Application.flush_code_coverage
    end
  end

  # Generate the baseline file (before any of the tests run)
  # @param [String] path_to_info_files The path to where the .info files will be stored
  def self.generate_lcov_baseline_info_file(path_to_info_files=@code_coverage_folder_path)
    baseline_info_file_path = File.join(path_to_info_files, @baseline_info_filename)

    if self.on?
      FileUtils.mkpath(path_to_info_files)

      puts("[CODE COVERAGE] Generating lcov baseline at #{baseline_info_file_path}.")
      `lcov --capture --initial --directory #{@project_intermediates} --output-file #{baseline_info_file_path}`
    end
  end

  # Get a sanitized filename without weird characters
  # @param [String] file_name File name you want to sanitize
  # @return [String] Sanitized file name
  def self.sanitize_filename(file_name)
    file_name = file_name.gsub(/[^\w\.\-]/, '_')
    file_name = file_name.gsub(/\.{2,}/, '.')
    return file_name
  end

  # Generate an info file for the specified scenario
  # @param [Object] scenario See https://github.com/cucumber/cucumber/wiki/Hooks
  def self.generate_lcov_info_file(scenario)
    if self.on?
      puts('[CODE COVERAGE] Deleting the ObjectiveC.gcda files because the files cause errors.')
      `cd #{@project_intermediates} && find . -name "ObjectiveC.gcda" -print0 | xargs -0 rm`

      # Craft the filename string. Use the scenario feature and scenario name,
      # but convert spaces to underscores and double-periods into single periods.
      info_filename_string = "#{@app_name}_#{scenario.feature.name}__#{scenario.name}.info"
      info_filename_string=self.sanitize_filename(info_filename_string)
      info_file_path = File.join(@code_coverage_folder_path, info_filename_string)

      puts("[CODE COVERAGE] Generating lcov info file at #{info_file_path}.")
      `lcov --capture --directory #{@project_intermediates} --output-file #{info_file_path}`
    end
  end

  # Combine the lcov info files into a single file for reporting
  # @param [String] path_to_info_files The path to where the .info files are stored
  def self.combine_lcov_info_files(path_to_info_files=@code_coverage_folder_path)
    combined_info_file_path = File.join(path_to_info_files, @combined_info_filename)

    if self.on?
      info_files = Dir["#{path_to_info_files}/*.info"]

      index_of_existing_combined_info_file = info_files.index{|s| s.include?(@combined_info_filename)}

      unless index_of_existing_combined_info_file.nil?
        log_warning("[CODE COVERAGE] combine_lcov_info_files found an existing #{@combined_info_filename} in #{path_to_info_files}. We will ignore it from the set to combine and override it.")
        info_files.delete_at(index_of_existing_combined_info_file)
      end

      if info_files.empty?
        raise '[CODE COVERAGE] combine_lcov_info_files could not find any coverage files to combine.'
      else
        puts("[CODE COVERAGE] Combining #{info_files.count} info files into a single file at #{path_to_info_files}.")

        info_files_str = '--add-tracefile '
        info_files_str+= info_files.join(' --add-tracefile ')
        `lcov #{info_files_str} --output-file #{combined_info_file_path}`
      end
    end
  end

  # Generate a nice html report from the specified info file
  # @param [String] info_file (Optional) The specified info file is used to generate reports
  # @param [String] dest_dir (Optional) The destination directory to save the files to
  def self.generate_lcov_reports_from_info_file(info_file=nil, dest_dir="#{@code_coverage_folder_path}")
    report_folder_path = File.join(dest_dir, 'reports')
    info_file = File.join(@code_coverage_folder_path, @combined_info_filename) if info_file.nil?

    if self.on?
      unless File.exists?(info_file)
        raise "[CODE COVERAGE] generate_lcov_reports expected to find #{info_file} at #{dest_dir} but it was not there."
      end

      if Dir.exists?(report_folder_path)
        puts("[CODE COVERAGE] Deleting the #{report_folder_path} directory which was there from a previous run.")
        FileUtils.rmtree(report_folder_path)
      end

      puts("[CODE COVERAGE] Generating code coverage report at #{report_folder_path}.")

      `cd #{dest_dir} && genhtml --ignore-errors source #{info_file} --legend --title "#{@app_name} Code Coverage Report" --output-directory=#{report_folder_path}`
    end
  end

  # Generate a .fail file so we know which test cases to rerun
  # @param [Object] scenario See https://github.com/cucumber/cucumber/wiki/Hooks
  def self.generate_failed_coverage_file(scenario)
    if self.on?
      # Craft the filename string. Use the scenario feature and scenario name,
      # but convert spaces to underscores and double-periods into single periods.
      info_filename_string = "#{@app_name}_#{scenario.feature.name}__#{scenario.name}.failed"
      info_filename_string=self.sanitize_filename(info_filename_string)
      info_file_path = File.join(@code_coverage_folder_path, info_filename_string)

      `touch "#{info_file_path}"`
    end
  end
end