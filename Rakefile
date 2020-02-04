# frozen_string_literal: true

task default: %w[lint test]

desc "Lint and auto-correct by Rubocop"
task :lint do
  system "bundle exec rubocop --auto-correct"
end

desc "Run all tests by rspec"
task :test do
  system "bundle exec rspec"
end
