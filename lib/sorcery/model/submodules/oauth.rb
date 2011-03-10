module Sorcery
  module Model
    module Submodules
      # This submodule helps you login users from OAuth providers such as Twitter.
      # This is the model part which handles finding the user using access tokens.
      # For the controller options see Sorcery::Controller::Oauth.
      #
      # Socery assumes you will create new users in the same table where you keep your regular users,
      # but that you might have a separate table for keeping their external data,
      # and that maybe that separate table has a few rows for each user (facebook and twitter).
      #
      # External users will have a null crypted_password field, since we do not hold their password.
      # They will not be sent activation emails on creation.
      module Oauth
        def self.included(base)
          base.sorcery_config.class_eval do
            attr_accessor :authentications_class,
                          :authentications_user_id_attribute_name,
                          :provider_attribute_name,
                          :provider_uid_attribute_name

          end
          
          base.sorcery_config.instance_eval do
            @defaults.merge!(:@authentications_class                  => Sorcery::Controller::Config.user_class,
                             :@authentications_user_id_attribute_name => :user_id,
                             :@provider_attribute_name                => :provider,
                             :@provider_uid_attribute_name            => :uid)

            reset!
          end
          
          base.send(:include, InstanceMethods)
          base.extend(ClassMethods)
        end
        
        module ClassMethods
          def load_from_provider(provider,uid)
            config = sorcery_config
            authentication = config.authentications_class.find_by_provider_and_uid(provider, uid)
            user = find(authentication.send(config.authentications_user_id_attribute_name)) if authentication
          end
        end
        
        module InstanceMethods

        end
      
      end
    end
  end
end