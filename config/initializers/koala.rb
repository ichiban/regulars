module Koala
  module Facebook
    module OAuthWithEnvVars
      def initialize(*args)
        raise 'application id and/or secret are not specified in the environment' unless ENV['FB_APP_ID'] && ENV['FB_SECRET_KEY']
        super(ENV['FB_APP_ID'].to_s, ENV['FB_SECRET_KEY'].to_s, args.first)
      end
    end

    class OAuth
      prepend OAuthWithEnvVars
    end
  end
end

Koala.config.api_version = 'v2.6'

Koala::Utils.level = Logger::DEBUG
