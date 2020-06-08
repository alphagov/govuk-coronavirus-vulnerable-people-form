# frozen_string_literal: true

desc "Run static analysis using brakeman gem"
task brakeman: :environment do
  sh "brakeman -q"
end
