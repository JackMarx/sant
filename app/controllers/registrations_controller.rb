class RegistrationsController < Devise::RegistrationsController

  def new
    if params[:callback].present?
      @callback = params[:callback]
    end
    super
  end
  
end