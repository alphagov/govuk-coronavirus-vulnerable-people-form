# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require_relative 'helpers/application_config'

rackapp = ApplicationConfig.call

run rackapp
