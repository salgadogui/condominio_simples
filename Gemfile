source "https://rubygems.org"

gem "rails", "~> 8.0.1"
gem "propshaft"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[ mri windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "tailwindcss-rails", "~> 3.0"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop", require: false
  gem "rubocop-rails-omakase"
end

group :development do
  gem "hotwire-spark"
  gem "web-console"
  gem "ruby-lsp"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
