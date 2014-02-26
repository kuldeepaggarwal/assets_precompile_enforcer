require 'sprockets/rails/helper'

module Sprockets
  module Rails
    module Helper
      include Sprockets::CommonMethods

      module AssetPaths
        class AssetNotPrecompiledError < StandardError; end
      end

      private

      def asset_environment
        ::Rails.application.assets
      end

      def ensure_asset_will_be_precompiled!(source, ext)
        source = source.to_s

        asset_file = asset_environment.resolve(rewrite_extension(source, nil, ext))
        unless asset_environment.send(:logical_path_for_filename, asset_file, asset_list)

          # Allow user to define a custom error message
          error_message_proc = ::Rails.application.config.assets.precompile_error_message_proc

          error_message = if error_message_proc
            error_message_proc.call(asset_file)
          else
            "#{File.basename(asset_file)} must be added to config.assets.precompile, otherwise it won't be precompiled for production!"
          end

          raise AssetPaths::AssetNotPrecompiledError.new(error_message)
        end
      end

      def rewrite_extension(source, dir, ext)
        source_ext = File.extname(source)[1..-1]

        if !ext || ext == source_ext
          source
        elsif source_ext.blank?
          "#{source}.#{ext}"
        elsif exact_match_present?(source)
          source
        else
          "#{source}.#{ext}"
        end
      end
    end
  end
end
