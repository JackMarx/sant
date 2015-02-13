class CartsController < InheritedResources::Base
  
  def show
    if user_signed_in?
      @customer = current_user.customer
      if session[:cart_id].present? && Cart.where(id: session[:cart_id]).present?
  		  @cart = Cart.find(session[:cart_id])
        if @customer.cart.present? && @customer.cart != @cart
          cart = Cart.find(@customer.cart)
          cart.destroy
        end
        @cart.customer_id = @customer.id
        @cart.save
        session.delete(:cart_id)
      else
        @cart = Cart.where(customer_id: @customer.id).first
      end
    elsif session[:cart_id].present?
      @cart = Cart.find(session[:cart_id])
    else
      redirect_to products_url
    end
  end
  
  def increase_quantity
    selection = CartSelection.find(params[:cart_selection_id])
    selection.quantity = selection.quantity + 1
    selection.save
    page = params[:page]
    if page == "cart"
      redirect_to customer_cart_url
    else
      redirect_to products_url
    end
  end
  
  def decrease_quantity
    selection = CartSelection.find(params[:cart_selection_id])
    if selection.quantity > 1
      selection.quantity = selection.quantity - 1
      selection.save
    else
      selection.destroy
    end
    page = params[:page]
    if page == "cart"
      redirect_to customer_cart_url
    else
      redirect_to products_url
    end
  end
  
  def checkout
    if user_signed_in?
      redirect_to address_step_path
    else
      redirect_to controller: 'registrations', action: 'new', callback: 'checkout', notice: "Please create a Sant account before continuing."
    end
  end
  
  def address_step
    if user_signed_in?
      @customer = current_user.customer
      if @customer.cart.present? && @customer.cart.cart_selections.present?
        @address = Address.new
      elsif !@customer.present?
        redirect_to "/products", notice: "Please select a purchase option from the menu below."
      end
    else
      redirect_to controller: 'registrations', action: 'new', notice: "Please sign-in to your Sant account."      
    end
  end
  
  def billing_step
    if user_signed_in?
      @payment_method = PaymentMethod.new
    else
      redirect_to controller: 'registrations', action: 'new', notice: "Please sign-in to your Sant account."      
    end
  end
  
  def review_step
    if user_signed_in?
      @order = Order.new
      @customer = current_user.customer
      @cart = @customer.cart
      @payment_method = @customer.payment_methods.first
    else
      redirect_to controller: 'registrations', action: 'new', notice: "Please sign-in to your Sant account."      
    end
  end
  
end
