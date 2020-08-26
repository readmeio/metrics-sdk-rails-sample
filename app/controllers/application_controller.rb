class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
end
