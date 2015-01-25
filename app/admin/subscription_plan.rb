ActiveAdmin.register SubscriptionPlan do
  menu :priority => 6
  
  permit_params :product_id, :interval_weeks, :price
  
  index do
    column "Product" do |subscription_plan|
      Product.find(subscription_plan.product_id).name
    end
    column :price
    column :interval_weeks
    actions
  end
  
  form do |f|
      f.inputs "Subscription Plan" do
          f.input :product
          f.input :password
          f.input :password_confirmation
          f.input :role, as: :radio, collection: {Editor: "editor", Administrator: "administrator"}
      end
      f.actions
  end

  form partial: 'form'
end