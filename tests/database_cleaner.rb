require "database_cleaner"

class Minitest::Test
  @@first_run = true

  def setup
    if @@first_run
      DatabaseCleaner.clean_with(:truncation)
      @@first_run = false

      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end