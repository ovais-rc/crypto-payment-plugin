//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2006, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by AddressBookForm.jsp and UnregisteredCheckout.jsp.
 * @version 1.0
 */

/**
 *  The functions defined in this class enable the customer to maintain an address book. 
 *	@class The AddressBookFormJS class defines all the functions and variables to update an address book. The customer can add or
 *  remove an address form the address book. The fields that can be entered while creating an address are first name, last name, 
 *  street address, city, country/region, state/province, ZIP/postal code, phone number, e-mail address.
 */

AddressBookFormJS = {
	/* The common parameters used in service calls. */
		langId: "-1",
		storeId: "",
		catalogId: "",
	/* flag set on address delete which is used to display the success message. */ 
		addressDeleted: "false",
	/* flag set on creation of new address which is used to display the success message. */ 
		addressNew: "false",
	/* variable set on address update which is used to display the success message. */  
		pageVar: "",
	
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
	 * This function returns the handler for the refresh controller corresponding to the action.
	 * @param {string} handlerKey The key of the handler.
	 * @param {string} actionName The name of the action to be performed.
	 * 
	 * @return function handler.
	 */
	getControllerActionHandler: function(handlerKey, actionName){
		console.debug("entering getControllerActionHandler(controller, handlerKey, actionName): "+actionName);
		var handler = AddressBookFormJS[actionName+'s'][handlerKey];
		if(handler){
			return function(message, widget, controller){
				handler(message, widget, controller);	
				
			}
		}else{
			return function(message, widget, controller){
				console.debug("empty handler. This is a no-op");
			}
		}
	},
	
	/**
	 *  This defines function registries for handling address forms. We register functions that handle different operations
	 *	on address forms. The key of each function will be the value of the property "addressFormAreaAction" in render context. 
	 *  Each function takes three parameters: message, widget, and controller. The parameters message and widget are the same as those for
	 *	a controller's renderContextChangedHandler(). The parameter controller is the controller that will call this function.
	 */
	addressFormAreaActions: { 
		/* The function that loads an empty address for for creating new address. */
		create: function(message, widget, controller){
			widget.refresh(controller.renderContext.properties);
			controller.renderContext.properties['addressFormAreaState'] = 'create';
		}, 	
		
		/* The function that loads an address form that contains the information of currently displayed address, so that the
		 * address can be edited.
		 */
		edit: function(message, widget, controller){
			console.debug("starting to getting editing area");
			widget.refresh(controller.renderContext.properties);
			controller.renderContext.properties['addressFormAreaState'] = 'edit';
		}, 

		/* Destroy the address forms that are handled by this controller. */
		clean: function(message, widget, controller){
			widget.setInnerHTML("");	
			controller.renderContext.properties['addressFormAreaState'] = 'clean';
		},

		/* This function behaves same as {@link clean} function. */ 
		handleModelChange: function(message, widget, controller){
			widget.setInnerHTML("");
			controller.renderContext.properties['addressFormAreaState'] = 'clean';
		}
			
	}, 
	
	/*
	 * This defines function registries handling address display.The registered functions handle operations on 
     * the refresh area that displays user addresses.Each function takes three parameters: message, widget, and controller.
	 *
	 * @see AddressBookFormJS.addressFormAreaActions
	 */
	addressDisplayAreaActions: {
		
		/* This function reloads the refresh areas that display user addresses. */
		reload: function(message, widget, controller){
			console.debug("reloading "+widget);
			widget.refresh(controller.renderContext.properties);
		},
		
		/* This function behaves similar to {@link reload} function. */
		handleModelChange: function(message, widget, controller){
			console.debug("reloading "+widget);
			widget.refresh(controller.renderContext.properties);
		}
	}, 
	
	/*
	 * This defines function registries for handling the display of states and province. The registered functions displays states upon changes made 
	 * in address country. Each function takes three parameters: message, widget, and controller.
	 */
	statesDisplayAreaActions: {
		 
		/* This function  refreshes the area that displays states/provinces corresponding to the updated country */
		countryUpdated: function(message, widget, controller){
			console.debug("IN countryUpdated handler: message = "+message);
			
			var paramPrefix = controller.renderContext.properties['paramPrefix'];
			if(widget.widgetId.match(paramPrefix)){
				console.debug("matchin paramPrefix: "+paramPrefix+" refreshing "+widget.widgetId);
				
				widget.refresh(controller.renderContext.properties);	
			}else{
				console.debug("no maching paramPrefix "+paramPrefix);
			}
			
		}
		
	}, 
	
	/**
	 *  This function displays the address that has the selected address Id, and hides all the other addresses.
	 *  This function is supposed to be called when an addressId is selected from an HTML form selection control. 
	 *	This function makes a few assumptions. It assumes each ddress is displayed in the same way. Each chunk 
	 *	of address information has the same class, tableClass. It also assumes the area that displays
	 *	an address has an ID in the form of <tableIdPrefix><addressId>.
	 *  @param {DomNode} selection The DomNode of a form selection. This node contains selected addressId.
	 *  @param {string} tableClass The class of the table that contains an address.
	 *  @param {string} tableIdPrefix The prefix of the Id of each address table.
	 */
	toggleAddressDisplay: function(selection, tableClass, tableIdPrefix){
		console.debug('toggle address display');
		var selectedAddressId = selection.options[selection.selectedIndex].value;
			$("."+tableClass).each(function(i, div){
			var tableId = tableIdPrefix+selectedAddressId;
			if(div.id == tableId && selectedAddressId != "MyBillingAddress"){
				$(div).css("display", "block");	
			}else{
				$(div).css("display", "none");
			}
		});
	}, 

	/*
	 * This function is used to load the details corresponding to an address selection. When the customer
	 * selects an address from the dropdown, this function displays the stored address details 
	 * corresponding to the selection.
	 * @param {string} selection The id of the address dropdown box.
	 * @param {array} addresses Array of address objects.
	 * @param {object} form The actual HTML form object containing address information.
	 */
	populateTextFields: function(selection, addresses, form){

		if(document.getElementById("adding").style.display=='block')
		{
			var hidediv = document.getElementById("adding");
			hideElementById(hidediv);
			var div = document.getElementById("normal");
			div.style.display = "block";
		}
		var selectedAddressId = selection.options[selection.selectedIndex].value;
		
		var radioButton = form.sbAddress;
		for (var i=0; i<radioButton.length; i++)  
		{
			if (radioButton[i].value == addresses[selectedAddressId].addressType)  
			{
				radioButton[i].checked = "checked";
			} 
		}
		form.nickName.value = addresses[selectedAddressId].nickName;	
		form.firstName.value = addresses[selectedAddressId].firstName;	
		form.lastName.value = addresses[selectedAddressId].lastName;	
		form.address1.value = addresses[selectedAddressId].address1;
		form.address2.value = addresses[selectedAddressId].address2;		
		form.country.value = addresses[selectedAddressId].country;	
		form.zipCode.value = addresses[selectedAddressId].zipCode;	
		form.email1.value = addresses[selectedAddressId].email1;	
		form.phone1.value = addresses[selectedAddressId].phone1;	
		form.city.value = addresses[selectedAddressId].city;	
		AddressHelper.loadStatesUI('AddressForm','','stateDiv','state');
		form.state.value = addresses[selectedAddressId].state;
		if(form.middleName)
			form.middleName.value = addresses[selectedAddressId].middleName;
		document.getElementById("addr_title").innerHTML="<h2 class='status_msg'>"+addresses[selectedAddressId].nickName+"</h2>";
	},
	
	/*
	 * This function displays the default customer address on load of the address book page.
	 * @param {string} selection The id of the address dropdown box.
	 * @param {array} addresses Array of address objects.
	 * @param {object} form The actual HTML form object containing address information.
	 */

	populateTextFieldsOnLoad: function(selection, addresses, form){

		var selectedAddressId = selection.options[selection.selectedIndex].value;
		
		var radioButton = form.sbAddress;
		for (var i=0; i<radioButton.length; i++)  
		{
			if (radioButton[i].value == addresses[selectedAddressId].addressType)  
			{
				radioButton[i].checked = "checked";
			} 
		}
		form.nickName.value = addresses[selectedAddressId].nickName;	
		form.firstName.value = addresses[selectedAddressId].firstName;	
		form.lastName.value = addresses[selectedAddressId].lastName;	
		form.address1.value = addresses[selectedAddressId].address1;
		form.address2.value = addresses[selectedAddressId].address2;	
		form.state.value = addresses[selectedAddressId].state;	
		form.country.value = addresses[selectedAddressId].country;	
		form.zipCode.value = addresses[selectedAddressId].zipCode;	
		form.email1.value = addresses[selectedAddressId].email1;	
		form.phone1.value = addresses[selectedAddressId].phone1;	
		form.city.value = addresses[selectedAddressId].city;	
		if(form.middleName)
			form.middleName.value = addresses[selectedAddressId].middleName;
		AddressHelper.loadStatesUI('AddressForm','','stateDiv','state', true);
		document.getElementById("addr_title").innerHTML="<h2 class='status_msg'>"+addresses[selectedAddressId].nickName+"</h2>";
	},
	
	/**
	 *  This function is used to clear the values of all the form input fields in the address book.
	 *  The function obtains each form field by id and clears its value. This is usually done after form submit.
	 */

	clearTextFields: function(form){
		form.nickName.value="";
		form.firstName.value="";
		form.lastName.value="";
		form.address1.value="";
		form.address2.value="";
		form.city.value="";
		form.state.value="";
		form.country.value="";
		form.zipCode.value="";
		form.email1.value="";
		form.phone1.value="";
		if(form.middleName) {
			form.middleName.value="";
		}
	},

	/**
	 *  This function loads the address form when addnew button is clicked. This loads the form with all the input fields cleared. 
	 */
	showAdd: function(){
		
		var hidediv = document.getElementById("normal");
		hideElementById(hidediv);
		var div = document.getElementById("adding");
		div.style.display = "block";
	},

	
	/**
	 * This function is used during Unregistered checkout and makes the Shipping address same as the Billing address.
	 * This function takes shipping and billing forms as input and copies the billing address information to the shipping address.
	 * @param {string} fromName The name of the Billing address form.
	 * @param {string} toName The name of the Shipping address form.
	 */
	copyBillingFormNew: function(fromName,toName){
		
			var form = document.forms[fromName];
			var to = document.forms[toName];
			var sameaddress = document.getElementById("SameShippingAndBillingAddress");
			if (sameaddress.checked){
				hideElementById("shippingAddressCreateEditFormDiv_1");
			
				to.firstName.value = form.firstName.value;
				to.lastName.value = form.lastName.value;
				to.address1.value = form.address1.value;
				to.address2.value = form.address2.value;
				to.city.value = form.city.value;
				if(isIE){(document.getElementById("stateDiv2").firstChild).value = (document.getElementById("stateDiv1").firstChild).value;}
				else {to.state.value = form.state.value;}
				to.zipCode.value = form.zipCode.value;
				to.country.value = form.country.value;
				to.phone1.value = form.phone1.value;
				to.email1.value = form.email1.value;
				if(form.middleName)
					to.middleName.value = form.middleName.value;
			}

			if (!sameaddress.checked){
				showElementById("shippingAddressCreateEditFormDiv_1");
				to.firstName.value = "";
				to.lastName.value = "";
				to.address1.value = "";
				to.address2.value = "";
				to.city.value = "";
				if(isIE){(document.getElementById("stateDiv2").firstChild).value= "";}
				else{to.state.value = "";}
				to.zipCode.value = "";
				to.phone1.value = "";
				to.email1.value = "";
				if(to.middleName)
					to.middleName.value = "";
			}	
		}

};
