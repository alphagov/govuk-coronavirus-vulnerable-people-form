# frozen_string_literal: true

desc "Lint files"
task "lint" => :environment do
  sh "rubocop --format clang"
  # TODO: Figure out what Sass linting is failing on CI
  # sh "scss-lint app/assets/stylesheets"
end
