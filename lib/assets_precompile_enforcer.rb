require 'assets_precompile_enforcer/version'
require 'assets_precompile_enforcer/sprockets/common_methods'

# Needs to be disabled for Konacha
unless defined?(Konacha)
  if ::Rails::VERSION::MAJOR >= 4
    require 'assets_precompile_enforcer/sprockets/rails/helper'
  else
    require 'assets_precompile_enforcer/sprockets/helpers/rails_helper'
  end
end
