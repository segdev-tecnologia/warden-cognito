module Warden
  module Cognito
    module HasUserPoolIdentifier
      def self.included(base)
        base.extend ClassMethods
        base.class_eval do
          attr_reader :user_pool
        end
      end

      def user_pool=(pool_identifier)
        @user_pool = user_pools.detect(self.class.invalid_issuer_error) { |pool| pool.identifier == pool_identifier }
      end

      def pool_identifier
        user_pool.identifier
      end

      module ClassMethods
        def pool_iterator
          PoolRelatedIterator.new do |pool|
            new.tap do |pool_related|
              pool_related.user_pool = pool.identifier
            end
          end
        end

        def invalid_issuer_error
          -> { raise ::JWT::InvalidIssuerError, 'The token was not generated by any of the configured User Pools' }
        end
      end
    end
  end
end