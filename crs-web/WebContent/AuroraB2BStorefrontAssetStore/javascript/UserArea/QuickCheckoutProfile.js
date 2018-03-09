//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2007, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------
//

/** 
 * @fileOverview This javascript is used by AjaxMyAccountQuickCheckoutProfileForm.jsp and MyAccountQuickCheckoutProfileForm.jsp.
 * @version 1.0
 */

/**
 * The functions defined in this class enable the customer to update an existing quickcheckout profile.
 * @class This QuickCheckoutProfile class defines all the functions and variables to manage a quickcheckout profile.
 * A quick address profile can be used to identify shipping addresses, billing addresses, or both shipping and billing addresses when completing the quick checkout process. 
 * The fields that can be entered into the quick checkout profile are first name, last name, street address, city, country/region, state/province, ZIP/postal code, 
 * phone number, e-mail address, payment method, and shipping method.
 */
QuickCheckoutProfile = {
		/* The common parameters used in service calls. */
		langId: "-1",
		storeId: "",
		catalogId: "",
		/* variable set on quickcheckout profile update which is used to display the success message. */   
		pageVar: "aa",
		/** flag to indicate whether the credit card field is updated or not. The value is automatically populated
		 *  by the jsp using the {@link valueChanged} function.
		 *
		 *  @private
		 */
		changed: "false",		
				
	/**
	 * This function initializes common parameters used in all service calls.
	 * @param {int} langId The language id to use.
	 * @param {int} storeId The store id to use.
	 * @param {int} catalogId The catalog id to use.
	 */

	setCommonParameters:function(langId,storeId,catalogId){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;
		
	},
    
	/**
	 * This function will declare a refreshArea controller if no controller with the same controller ID exits yet. The
	 * declared controller is designed to handle address specific tasks. If user passes a "url" parameter when updating context, it will 
     * replace the value of its own "url" parameter to the one given by the user.
	 * @param {string} controllerId The ID of the controller that is going to be declared.
	 * @param {string} defaultURL The url this controller used for getting data from server. It will be set to controller.url.
	 */
/*
	declareRefreshAreaController: function(controllerId, defaultURL){
		if(wc.render.getRefreshControllerById(controllerId)){
			console.debug("controller with id = "+controllerId+" already exists. No declaration will be done");
			return;
		}
		wc.render.declareRefreshController({
			id: controllerId, 
			renderContext: wc.render.getContextById("default"),
			url: defaultURL,
			renderContextChangedHandler: function(message, widget) {
				console.debug("entering renderContextChangedHandler for "+controllerId);
			
				var controller = this;
				var renderContext = this.renderContext;
				
				if(typeof actionName == "undefined" || !Common.getRenderContextProperty(renderContext, actionName)){
					console.debug("no actionName is specified. This handler will not be called. Exiting...");
					return;	
				}
				
				if(Common.getRenderContextProperty(renderContext, "url")){
					controller.url = Common.getRenderContextProperty(renderContext, "url");
				}
				
				widget.refresh(controller.renderContext.properties);
				
				// Make sure this handler will always know whether a user gives an addressDisplayAreaAction in the future.
				delete renderContext.properties[actionName];  
				delete renderContext.properties["url"];
			}, 
			
			modelChangedHandler: function(message, widget){
				console.debug(message);
				widget.refresh(this.renderContext.properties);
				
				cursor_clear();
			}
		});
		
	}, */

	/**
	 * This function is used when the creditcard field is updated by the user.
	 * @param {boolean} value The value assigned to the {@ link changed} variable of the QuickCheckoutProfile class.   
	 */
	valueChanged:function(value){
		QuickCheckoutProfile.changed = value;
	},
	
	/**
	 * This function is used to validate all the quickcheckout profile form input fields.
	 * @param {string} formName The name of the form containing all the information required to create a quick address profile. 
	 * 
	 * @private
	 *
	 * @return {boolean} The validation is successful or not.
	 */
	validateForm:function(formName){
		reWhiteSpace = new RegExp(/^\s+$/);
		var form = document.forms[formName];
		var expiry = null;
		if (form.pay_expire_year != null) {
			expiry = new Date(form.pay_expire_year.value,form.pay_expire_month.value - 1,1);
		}
		var currMonth = form.curr_month.value;
		if (currMonth.length == 1) {
			currMonth = "0" + currMonth;
		} else {
			currMonth = form.curr_month.value;
		}
		
		/** Uses the common validation function defined in AddressHelper class for validating first name, 
		 *  last name, street address, city, country/region, state/province, ZIP/postal code, e-mail address and phone number. 
		 */
		if(!AddressHelper.validateAddressForm(form,"billing_")){return false;}
		if(!AddressHelper.validateAddressForm(form,"shipping_")){return false;}

		var payMethodId = $('#payMethodId');
		if (payMethodId.find(":selected").val() != null) {
			if (form.pay_temp_account != null && reWhiteSpace.test(form.pay_temp_account.value) || form.pay_temp_account.value == "") {
				  MessageHelper.formErrorHandleClient(form.pay_temp_account.id,MessageHelper.messages["REQUIRED_FIELD_ENTER"]); return false;
			}
			if(QuickCheckoutProfile.changed == 'true')
			{
				form.pay_temp_account.name = 'pay_account';
			}
			else
				QuickCheckoutProfile.changed = 'false';
			/* Checks for a valid credit card expiry date. */
			 if (form.pay_expire_year != null && form.pay_expire_year.value < form.curr_year.value) {
				  MessageHelper.formErrorHandleClient(form.pay_expire_year.id,MessageHelper.messages["INVALID_EXPIRY_DATE"]); return false;
			 }
			 else if ( (form.pay_expire_year != null) && (form.pay_expire_year.value == form.curr_year.value) && (currMonth > form.pay_expire_month.value)) {
				 MessageHelper.formErrorHandleClient(form.pay_expire_month.id,MessageHelper.messages["INVALID_EXPIRY_DATE"]); return false;
			 }
		}
		return true;
	},
	
	/** 
	 * This function loads the current quickcheckout profile.
	 * @param {array} addresses This is a shippingProfile or billingProfile address object.
	 * @param {string} prefix The value is set to shipping or billing.
 	 */
	getCurrentProfile: function(addresses, prefix){
		var firstname = $("input[name=" + prefix + "_firstName]")[0];
		var lastname = $("input[name=" + prefix + "_lastName]")[0];
		var address1 = $("input[name=" + prefix + "_address1]")[0];
		var address2 = $("input[name=" + prefix + "_address2]")[0];
		var zipCode = $("input[name=" + prefix + "_zipCode]")[0];
		var email1 = $("input[name=" + prefix + "_email1]")[0];
		var phone1 = $("input[name=" + prefix + "_phone1]")[0];
		var city = $("input[name=" + prefix + "_city]")[0];
		var middleName = "";
		if($("input[name=" + prefix + "_middleName]")[0]) 
			middleName = $("input[name=" + prefix + "_middleName]")[0];
			
		firstname.value = addresses.firstName;	
		lastname.value = addresses.lastName;	
		address1.value = addresses.address1;
		address2.value = addresses.address2;
		zipCode.value = addresses.zipCode;	
		email1.value = addresses.email1;	
		phone1.value = addresses.phone1;	
		city.value = addresses.city;	
		if(middleName)
		{
			middleName.value = addresses.middleName;
		}
		
		var stateId = prefix+'_WC_QuickCheckoutAddressForm_AddressEntryForm_FormInput_'+prefix+'_state_1';
		var state = $('#' + stateId);
		if(addresses.state != ''){
			if (state !== undefined && state !== null){
				state.val(addresses.state);
				state.Select("refresh_noResizeButton");
			} else {
				state = $("input[name=" + prefix + "_state]")[0].val();
				state.val(addresses.state);
			}
		}

		if(addresses.country != '') {
			var country = $('#' + 'WC_QuickCheckoutAddressForm_AddressEntryForm_FormInput_'+prefix+'_country_1');
			country.val(addresses.country);
			country.Select("refresh_noResizeButton");
			AddressHelper.loadAddressFormStatesUI('QuickCheckout',prefix + "_", prefix+'_stateDiv','WC_QuickCheckoutAddressForm_AddressEntryForm_FormInput_'+ prefix + '_state_1', false, addresses.state);
		}
	},
	
	/**
	 * This function is used to show/hide the shipping address div if the 'same as my billing address' checkbox is unchecked/checked.
	 * @param {string} form The name of the form containing all the information required to create a quick address profile.
	 */

	showHide:function(form){
		var sameaddress = document.getElementById("SameShippingAndBillingAddress");
		if (sameaddress.checked){
				hideElementById("shipAddr");
				this.copyBillingAddress(form);
		}
		else{
			showElementById("shipAddr");
			$("input[name=shipping_firstName]")[0].value = "";
			$("input[name=shipping_lastName]")[0].value = "";
			$("input[name=shipping_address1]")[0].value = "";
			$("input[name=shipping_address2]")[0].value = "";
			$("input[name=shipping_city]")[0].value = "";
			$("input[name=shipping_zipCode]")[0].value = "";
			$("input[name=shipping_phone1]")[0].value = "";
			$("input[name=shipping_email1]")[0].value = "";
			$("select,input[name=shipping_state]")[0].value = "";
			if($("input[name=shipping_middleName]")[0]) 
				$("input[name=shipping_middleName]")[0].value = "";
		}
	},
	
	/**
	 * This function makes the shipping same as the billing address.
	 * @param {string} form The name of the quickcheckout profile form.
	 */
	copyBillingAddress:function(form){
		$("input[name=shipping_firstName]")[0].value = form.billing_firstName.value;
		$("input[name=shipping_lastName]")[0].value = form.billing_lastName.value;
		$("input[name=shipping_address1]")[0].value = form.billing_address1.value;
		$("input[name=shipping_address2]")[0].value = form.billing_address2.value;
		$("input[name=shipping_city]")[0].value = form.billing_city.value;
		$("input[name=shipping_zipCode]")[0].value = form.billing_zipCode.value;
		$("input[name=shipping_phone1]")[0].value = form.billing_phone1.value;
		$("input[name=shipping_email1]")[0].value = form.billing_email1.value;
		if ($("input[name=shipping_middleName]")[0]) 
			$("input[name=shipping_middleName]")[0].value = form.billing_middleName.value;
			
		var country = $('#WC_QuickCheckoutAddressForm_AddressEntryForm_FormInput_shipping_country_1');
		country.val(form.billing_country.value);
		country.Select("refresh_noResizeButton");

		AddressHelper.loadAddressFormStatesUI('QuickCheckout','shipping_','shipping_stateDiv','WC_QuickCheckoutAddressForm_AddressEntryForm_FormInput_shipping_state_1', false, form.billing_state.value);
	},
	
	/**
	 * This function updates the quickCheckout profile.
	 * @param {string} form The name of the form containing all the information required to create a quick address profile.
	 */
	UpdateProfile: function(form){
		var sameaddress = document.getElementById("SameShippingAndBillingAddress");
		if (sameaddress.checked){
			this.copyBillingAddress(form);
		}
		/* validates the form input fields. */
		if(this.validateForm(form.name))
		{
			var paymentMethodWidget = $("#payMethodId");
			var paymentMethod;
			if (paymentMethodWidget.length !== 0) {
					paymentMethod = paymentMethodWidget.val();
			}

			form.pay_payment_method.value = paymentMethod;
			form.pay_cc_brand.value = paymentMethod;
			form.pay_payMethodId.value = paymentMethod;
			
			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}
			
			processAndSubmitForm(form);
		}
	}
}
