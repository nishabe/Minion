class Application
  extend Calabash::Cucumber::Operations
  
  # Flush the code coverage
  def self.flush_code_coverage
    backdoor('flushGCov:', '')
  end
end