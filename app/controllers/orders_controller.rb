class OrdersController < ApplicationController
  
  require 'paypal-sdk-rest'
  include PayPal::SDK::REST
  include PayPal::SDK::Core::Logging

  before_action :validate_cart, only: [:checkout_credit_card_paypal, :checkout_paypal]
  
  protect_from_forgery except: [:checkout_paypal]
  def checkout_paypal
       # abort(params.to_json)
       
        if @success == 1
            price           = params[:data][:final_price].to_f
            if price.to_f > 0 

                tempdata        =  Temp.create('value': params[:data])
                paypal_id       =  "#{Rails.application.secrets.business_paypal_id}"
                invoice         = "Product-#{Time.now.to_i}" 

                values = {   
                    business: paypal_id,
                    cmd: "_xclick",
                    upload: 1, 
                    return: "#{Rails.application.secrets.app_host}paypal-success",
                    invoice: invoice,
                    amount: price,
                    item_name: 'Purchase Product',
                    quantity: 1,
                    custom: tempdata.id,
                    rm: 0,
                    notify_url: "#{Rails.application.secrets.app_host}hook"
                   }
              
                render json: {'url' => "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query,'success' => 1, 'message'=> @message }, status: 200 
        
            else

                save_transaction params, 'FREE BY DISCOUNT', '', '', ''
                @message = "Your payment is successfully completed"
                render json: {'message' => @message ,'success' => 2 , 'url' => ''}, status: 200 
            end  

        else
            render json: {'message' => @message ,'success' => 0 , 'url' => ''}, status: 200       
        end  

  end  

  def checkout_credit_card_paypal

         if @success == 1
             price           = number_with_precision(params[:data][:final_price].to_f, :precision => 2)
             #abort(price.to_s)
            if price.to_f > 0 
                    @payment = Payment.new({
                        :intent => "sale",
                        :payer => {
                          :payment_method => "credit_card",
                          :funding_instruments => [{
                          :credit_card => {
                                              :type => params[:data][:type].downcase,
                                              :number => params[:data][:number],
                                              :expire_month => params[:data][:expire_month],
                                              :expire_year => params[:data][:expire_year],
                                              :cvv2 => params[:data][:cvv2],
                                              :first_name => '',
                                              :last_name => "",
                                              :billing_address => {
                                                  :line1 => "",
                                                  :city => "",
                                                  :state => "",
                                                  :postal_code => "",
                                                  :country_code => "" 
                                              }
                                          }
                                    }]
                            },
                            :transactions => [{
                                                :item_list => {
                                                                 :items => [{
                                                                    :name => "Download Product",
                                                                    :sku => "",
                                                                    :price => price,
                                                                    :currency => "USD",
                                                                    :quantity => 1 
                                                                  }]
                                                              },
                                                :amount => {
                                                        :total => price,
                                                        :currency => "USD" 
                                                      },
                                                :description => "This is the payment transaction description." 
                                             }]
                        })

#abort(@payment.inspect)
                    if @payment.create

                        save_transaction params, 'Credit Card', @payment.id.to_s, '', @payment
                        @message = "Your payment is successfully completed"
                        render json: {'url' => '','success' => 1, 'message'=> @message }, status: 200 
                    else
                      #abort(@payment.error.to_json)
                        render json: {'message' => 'Unable to process' ,'success' => 0 , 'url' => ''}, status: 200      
                    end
          else

                save_transaction params, 'FREE BY DISCOUNT', '', '', ''
                  @message = "Your payment is successfully completed"
                render json: {'message' => @message ,'success' => 1 , 'url' => ''}, status: 200 
          end

        else
            render json: {'message' => @message ,'success' => 0 , 'url' => ''}, status: 200       
        end  

  end  

  def paypal_success
      flash[:notice] = "Your payment is successfully completed"
      redirect_to  downloads_path
  end  

  protect_from_forgery except: [:hook]
     def hook 
        params.permit!    
        if params['item_name'] == 'Purchase Product'       
                if params['payment_status'] == 'Completed'

                  tempdata              =   Temp.where("id = ?", params['custom'].to_i).first  
                  value                 =   tempdata.value  
                 # abort(value['company_name'].to_json)

                  company_name    = value['company_name'].present? ? value['company_name'] : ''
                  company_code    = value['company_code'].present? ? value['company_code'] : ''
                  company_vat     = value['company_vat'].present? ? value['company_vat'] : ''
                  company_country = value['company_country'].present? ? value['company_country'] : ''
                  company_city    = value['company_city'].present? ? value['company_city'] : ''
                  company_address = value['company_address'].present? ? value['company_address'] : ''
                  is_company      = value['is_company'].present? ? value['is_company'] : false



                  transaction_data      =   TransactionHistory.create(user_id: value['user_id'].to_i, payment_method: 'Paypal', txn_id: params['txn_id'].to_s, payer_id: params['payer_id'].to_s, gross_amount: value['price_before_discount'].to_f, discount_amount: value['discount'].to_f, net_amount: value['final_price'].to_f, coupon_code: value['applied_coupon_code'].to_s, is_company: is_company, company_name: company_name, company_code: company_code, company_vat: company_vat, company_country: company_country, company_city: company_city, company_address: company_address, response: params)   

                    value['cart_data']['items'].each_with_index do |value1, index|
                        download_data    =  Download.where('product_id = ?', value1['sku']).first
                        PurchasedProduct.create(user_id:  value['user_id'].to_i, download_id: download_data.id, transaction_history_id: transaction_data.id, price: value1['mrp'].to_f)   
                    end   
                  tempdata.destroy
                end    
           

        end 

        render json: {message: 'ok',status: '200',message: 'Successfully Payment'}
    end
 

   private

   def save_transaction data = [], payment_method = '', txn_id = '', payer_id = '', response_data = ''

        #abort(response_data.to_json)

            company_name    = data[:data][:company_name].present? ? data[:data][:company_name] : ''
            company_code    = data[:data][:company_code].present? ? data[:data][:company_code] : ''
            company_vat     = data[:data][:company_vat].present? ? data[:data][:company_vat] : ''
            company_country = data[:data][:company_country].present? ? data[:data][:company_country] : ''
            company_city    = data[:data][:company_city].present? ? data[:data][:company_city] : ''
            company_address = data[:data][:company_address].present? ? data[:data][:company_address] : ''
            is_company      = data[:data][:is_company].present? ? data[:data][:is_company] : false



          transaction_data      =   TransactionHistory.create(user_id: data[:data][:user_id].to_i, payment_method: payment_method, txn_id: txn_id.to_s, payer_id: payer_id.to_s, gross_amount: data[:data][:price_before_discount].to_f, discount_amount: data[:data][:discount].to_f, net_amount: data[:data][:final_price].to_f, coupon_code: data[:data][:applied_coupon_code].to_s, is_company: is_company, company_name: company_name, company_code: company_code, company_vat: company_vat, company_country: company_country, company_city: company_city, company_address: company_address, response: response_data)   
            data[:data][:cart_data][:items].each_with_index do |value1, index|
                  download_data    =  Download.where('product_id = ?', value1['sku']).first
                  PurchasedProduct.create(user_id:  data[:data][:user_id].to_i, download_id: download_data.id, transaction_history_id: transaction_data.id, price: value1['mrp'].to_f)   
            end  

         return true     
   end  

    def validate_cart

        @message = ''
        @success = 1

        if params[:data][:cart_data][:items].present? && !params[:data][:cart_data][:items].nil?

	        if params[:data][:applied_coupon_code].present? && params[:data][:applied_coupon_code] != ''
	            is_code_exist           =   Coupon.where("coupon_code = ?", params[:data][:applied_coupon_code]).first
	            if is_code_exist.present?
	                  is_applied  =  TransactionHistory.where("coupon_code = ? AND user_id = ?", params[:data][:applied_coupon_code], params[:data][:user_id]).count
	                if  is_applied >= is_code_exist.no_of_use
	                  @success = 0
	                  @message = 'Coupon has already used'
	                end  
	            else
	                @success = 0
	                @message = 'Invalid Coupon Code'
	            end 
	      
	        end
	    else
	    	@success = 0
	        @message = 'No Item In Cart'
	    end  

    end  

end
