class Admin::ApplicationController < ApplicationController
  protect_from_forgery

  before_filter :authorize

  layout 'admin'

end
