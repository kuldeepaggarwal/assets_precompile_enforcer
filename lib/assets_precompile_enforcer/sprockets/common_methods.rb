require 'active_support/concern'

module Sprockets
  module CommonMethods
    extend ActiveSupport::Concern

    included do
      def javascript_include_tag_with_enforced_precompile(*sources)
        if enforce_precompile?
          sources_without_options(sources).each do |source|
            ensure_asset_will_be_precompiled!(source, 'js')
          end
        end
        javascript_include_tag_without_enforced_precompile(*sources)
      end
      alias_method_chain :javascript_include_tag, :enforced_precompile

      def stylesheet_link_tag_with_enforced_precompile(*sources)
        if enforce_precompile?
          sources_without_options(sources).each do |source|
            ensure_asset_will_be_precompiled!(source, 'css')
          end
        end
        stylesheet_link_tag_without_enforced_precompile(*sources)
      end
      alias_method_chain :stylesheet_link_tag, :enforced_precompile

      private

      def sources_without_options(sources)
        sources.last.is_a?(Hash) && sources.last.extractable_options? ? sources[0..-2] : sources
      end

      def enforce_precompile?
        ::Rails.application.config.assets.enforce_precompile
      end

      def asset_list
        ignored = ::Rails.application.config.assets.ignore_for_precompile || []
        precompile = ::Rails.application.config.assets.precompile || []
        precompile + ignored
      end
    end
  end  
end
