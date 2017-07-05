class OrdersController < ApplicationController

  require 'paypal-sdk-rest'
  include PayPal::SDK::REST
  include PayPal::SDK::Core::Logging

  before_action :validate_cart, only: [:checkout_credit_card_paypal, :checkout_paypal]

  protect_from_forgery except: [:checkout_paypal]
  def checkout_paypal
       # abort(params.to_json)

        if @success == 1
            price               = params[:data][:final_price].to_f
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
                    item_name: 'purchase_product',
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
      redirect_to  root_path
  end

  def paypal_subscription_success
      flash[:notice] = "Your have successfully upgraded to Pro"
      redirect_to  upgrade_account_path
  end

  protect_from_forgery except: [:hook]
     def hook
        params.permit!
        if params['item_name'] == 'purchase_product'
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

                        if value1['type'] == 'download'

                            download_data    =  Download.where('product_id = ?', value1['sku']).first
                            PurchasedProduct.create(user_id:  value['user_id'].to_i, download_id: download_data.id, transaction_history_id: transaction_data.id, price: value1['mrp'].to_f)

                            number_of_sold = 1
                            if !download_data.number_of_sold.nil?
                              number_of_sold = download_data.number_of_sold.to_i + 1
                            end
                            download_data.update(number_of_sold: number_of_sold)

                        elsif value1['type'] == 'tutorial'

                            tutorial_data    =  Tutorial.where('tutorial_id = ?', value1['sku']).first
                            PurchasedTutorial.create(user_id:  value['user_id'].to_i, tutorial_id: tutorial_data.id, transaction_history_id: transaction_data.id, price: value1['mrp'].to_f)

                            number_of_sold = 1
                            if !tutorial_data.number_of_sold.nil?
                              number_of_sold = tutorial_data.number_of_sold.to_i + 1
                            end
                            tutorial_data.update(number_of_sold: number_of_sold)

                        end

                    end
                  tempdata.destroy
                end

        elsif params['item_name'] == 'upgrade_account'

            if params['payment_status'] == 'Completed'
                tempdata              =   Temp.where("id = ?", params['custom'].to_i).first
                value                 =   tempdata.value

                first_name       = value['first_name'].present? ? value['first_name'] : ''
                last_name        = value['last_name'].present? ? value['last_name'] : ''
                company_name     = value['company_name'].present? ? value['company_name'] : ''
                email            = value['email'].present? ? value['email'] : ''
                city             = value['city'].present? ? value['city'] : ''
                countrty         = value['countrty'].present? ? value['countrty'] : ''
                state            = value['state'].present? ? value['state'] : ''
                zip_code         = value['zip_code'].present? ? value['zip_code'] : ''
                address1         = value['address1'].present? ? value['address1'] : ''
                address2         = value['address2'].present? ? value['address2'] : ''


                SubscriptionTransactions.create(user_id: value['user_id'].to_i, payment_method: 'Paypal', txn_id: params['txn_id'].to_s, payer_id: params['payer_id'].to_s, net_amount: value['net_amount'].to_f, first_name: first_name, last_name: last_name, company_name: company_name, email: email, city: city, countrty: countrty, state: state, zip_code: zip_code, address1: address1, address2: address2, response: params)

              ######################################
              update_subscription_detail value['user_id'].to_i
              #######################################



              tempdata.destroy

            end

        end

        render json: {message: 'ok',status: '200',message: 'Successfully Payment'}
    end

########################################## PAYPAL USER SUBSCRIPTION CODE ########################################################

  protect_from_forgery except: [:checkout_paypal_for_subscription]
  def checkout_paypal_for_subscription
    #abort(params.to_json)

            price               = params[:data][:net_amount].to_f
            if price.to_f > 0

                tempdata        =  Temp.create('value': params[:data])
                paypal_id       =  "#{Rails.application.secrets.business_paypal_id}"
                invoice         = "subsription-#{Time.now.to_i}"

                values = {
                    business: paypal_id,
                    cmd: "_xclick",
                    upload: 1,
                    return: "#{Rails.application.secrets.app_host}paypal-subscription-success",
                    invoice: invoice,
                    amount: price,
                    item_name: 'upgrade_account',
                    quantity: 1,
                    custom: tempdata.id,
                    rm: 0,
                    notify_url: "#{Rails.application.secrets.app_host}hook"
                   }

                render json: {'url' => "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query,'success' => 1, 'message'=> @message }, status: 200

            else
                @message = "Invalid Amount"
                render json: {'message' => @message ,'success' => 2 , 'url' => ''}, status: 200
            end


  end


  def checkout_subscription_credit_card_paypal

             price           = number_with_precision(params[:data][:net_amount].to_f, :precision => 2)
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

                        save_transaction_subscription params, 'Credit Card', @payment.id.to_s, '', @payment
                        @message = "Your payment is successfully completed"
                        render json: {'url' => '','success' => 1, 'message'=> @message }, status: 200
                    else
                      #abort(@payment.error.to_json)
                        render json: {'message' => 'Unable to process' ,'success' => 0 , 'url' => ''}, status: 200
                    end
          else

                @message = "Invalid Amount"
                render json: {'message' => @message ,'success' => 1 , 'url' => ''}, status: 200
          end

  end





   private

   def save_transaction_subscription data = [], payment_method = '', txn_id = '', payer_id = '', response_data = ''
            first_name      = data[:data][:first_name].present? ? data[:data][:first_name] : ''
            last_name       = data[:data][:last_name].present? ? data[:data][:last_name] : ''
            company_name    = data[:data][:company_name].present? ? data[:data][:company_name] : ''
            email           = data[:data][:email].present? ? data[:data][:email] : ''
            city            = data[:data][:city].present? ? data[:data][:city] : ''
            country         = data[:data][:country].present? ? data[:data][:country] : ''
            state           = data[:data][:state].present? ? data[:data][:state] : false
            zip_code        = data[:data][:zip_code].present? ? data[:data][:zip_code] : false
            net_amount      = data[:data][:net_amount].present? ? data[:data][:net_amount] : false
            address1        = data[:data][:address1].present? ? data[:data][:address1] : false
            address2        = data[:data][:address2].present? ? data[:data][:address2] : false


          SubscriptionTransactions.create(user_id: data[:data][:user_id].to_i, payment_method: payment_method, txn_id: txn_id.to_s, payer_id: payer_id.to_s, net_amount: net_amount.to_f, first_name: first_name, last_name: last_name, company_name: company_name, email: email, city: city, country: country, state: state, zip_code: zip_code, address1: address1, address2: address2, response: response_data)


          #######################################################
          update_subscription_detail data[:data][:user_id].to_i


          #######################################################

            return true
   end

   def save_transaction data = [], payment_method = '', txn_id = '', payer_id = '', response_data = ''

        #abort(data.to_json)

            company_name    = data[:data][:company_name].present? ? data[:data][:company_name] : ''
            company_code    = data[:data][:company_code].present? ? data[:data][:company_code] : ''
            company_vat     = data[:data][:company_vat].present? ? data[:data][:company_vat] : ''
            company_country = data[:data][:company_country].present? ? data[:data][:company_country] : ''
            company_city    = data[:data][:company_city].present? ? data[:data][:company_city] : ''
            company_address = data[:data][:company_address].present? ? data[:data][:company_address] : ''
            is_company      = data[:data][:is_company].present? ? data[:data][:is_company] : false



          transaction_data      =   TransactionHistory.create(user_id: data[:data][:user_id].to_i, payment_method: payment_method, txn_id: txn_id.to_s, payer_id: payer_id.to_s, gross_amount: data[:data][:price_before_discount].to_f, discount_amount: data[:data][:discount].to_f, net_amount: data[:data][:final_price].to_f, coupon_code: data[:data][:applied_coupon_code].to_s, is_company: is_company, company_name: company_name, company_code: company_code, company_vat: company_vat, company_country: company_country, company_city: company_city, company_address: company_address, response: response_data)
            data[:data][:cart_data][:items].each_with_index do |value1, index|

                if value1[:type] == 'download'

                  download_data    =  Download.where('product_id = ?', value1['sku']).first
                  PurchasedProduct.create(user_id:  data[:data][:user_id].to_i, download_id: download_data.id, transaction_history_id: transaction_data.id, price: value1['mrp'].to_f)

                  number_of_sold = 1
                  if !download_data.number_of_sold.nil?
                    number_of_sold = download_data.number_of_sold.to_i + 1
                  end
                  download_data.update(number_of_sold: number_of_sold)

                elsif value1[:type] == 'tutorial'

                  tutorial_data    =  Tutorial.where('tutorial_id = ?', value1['sku']).first
                  PurchasedTutorial.create(user_id:  data[:data][:user_id].to_i, tutorial_id: tutorial_data.id, transaction_history_id: transaction_data.id, price: value1['mrp'].to_f)

                  number_of_sold = 1
                  if !tutorial_data.number_of_sold.nil?
                    number_of_sold = tutorial_data.number_of_sold.to_i + 1
                  end
                  tutorial_data.update(number_of_sold: number_of_sold)

                end

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

  def update_subscription_detail user_id
    user = User.find(user_id)
    user.update(is_subscribed: true, subscription_end_date: Time.now + 1.year)
  end

end
