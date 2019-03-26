# frozen_string_literal: true
begin
  DatabaseCleaner.start
  FactoryBot.lint(traits: true)
ensure
  DatabaseCleaner.clean
end

