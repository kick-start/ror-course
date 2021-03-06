class ApplicationController < ActionController::Base
  protect_from_forgery
  protected
  # check_authorization
  def authorize_user!
    if user_signed_in? && current_user.is_admin
      return
    elsif user_signed_in?
      flash[:notice] = 'You must be an authorized user to do that'
      redirect_to :root
    else
      flash[:notice] = 'You need to sign in first'
      redirect_to new_user_session_path
    end
  end

  # rescue_from CanCan::AccessDenied do |exception|
  #   redirect_to root_url, :alert => exception.message
  # end
  def ajax_no_layout
    if request.xhr?
      render :layout => false
    end
  end
  
end
