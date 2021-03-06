
module Carto
  module Admin
    class UserPublicMapAdapter
      extend Forwardable

      delegate [ :id, :name, :username, :disqus_shortname, :avatar, :avatar_url, :remove_logo?, :has_organization?, 
                :organization, :organization_id, :twitter_username, :public_url, :subdomain, :organization_username, 
                :sql_safe_database_schema, :account_type, :google_maps_api_key, :basemaps, :default_basemap ] => :user

      attr_reader :user

      def initialize(user)
        @user = user
      end

      def public_table_count
        @public_table_count ||= Carto::VisualizationQueryBuilder.user_public_tables(@user).build.count
      end

      def public_visualization_count
        @public_visualization_count ||= Carto::VisualizationQueryBuilder.user_public_visualizations(@user).build.count
      end

    end
  end
end
