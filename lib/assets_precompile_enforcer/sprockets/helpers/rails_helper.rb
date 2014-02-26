require 'sprockets/helpers/rails_helper'

module Sprockets
  module Helpers
    module RailsHelper
      include Sprockets::CommonMethods

      private

      def ensure_asset_will_be_precompiled!(source, ext)
        source = source.to_s
        return if asset_paths.is_uri?(source)
        asset_file = asset_environment.resolve(asset_paths.rewrite_extension(source, nil, ext))
        unless asset_environment.send(:logical_path_for_filename, asset_file, asset_list)

          # Allow user to define a custom error message
          error_message_proc = Rails.application.config.assets.precompile_error_message_proc

          error_message = if error_message_proc
            error_message_proc.call(asset_file)
          else
            "#{File.basename(asset_file)} must be added to config.assets.precompile, otherwise it won't be precompiled for production!"
          end

          raise AssetPaths::AssetNotPrecompiledError.new(error_message)
        end
      end
    end
  end
end
