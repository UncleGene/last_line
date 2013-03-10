require 'active_support/concern'

module LastLine
  module Controller
    extend ActiveSupport::Concern

    module ClassMethods
      ##
      # When added on
      def protect_from_gets
        append_before_filter :block_gets
      end

      def protected_get action
        skip_before_filter :block_gets, :only => action
        prepend_before_filter :protect_get, :only => action
      end

      def allow_get action
        skip_before_filter :block_gets, :only => action
      end

      def allow_gets *args
        skip_before_filter :block_gets, *args
      end
    end

    protected

    def protect_get
      unless token_verified?
        logger.warn "WARNING: Can't verify CSRF token authenticity" if logger
        handle_unverified_request
      end
    end

    def block_gets
      return unless request.get?
      head :status => :forbidden
    end

    def token_verified?
      !protect_against_forgery? ||
          form_authenticity_token == params[request_forgery_protection_token] ||
          form_authenticity_token == request.headers['X-CSRF-Token']
    end
  end
end