//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2008, 2009 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

//
//

Subscription = {
	
	stateDivName : "stateDiv",
	stateClass   : null,
	 

	setStateDivName:function(stateDivName){
		this.stateDivName = stateDivName; 
	 },

	setStateClass:function(stateClass){
		this.stateClass = stateClass;
	},
	
	prepareSubmit:function(formName1,formName2,errorView){
		
		///////////////////////////////////////////////////////////////////
		// summary: This function will update the user information.
		// Description: This function will takes "Registrationform" , 
		//////////////////////////////////////////////////////////////////
		
		var emailForm = document.forms[formName1];
		var mobileForm = document.forms[formName2];

		if(emailForm.sendMeEmail.checked ){
		    mobileForm.receiveEmail.value = "true";
		}
		else {
			mobileForm.receiveEmail.value = "false";
		}
		
		mobileForm.receiveSMSNotification.value = "false";
		mobileForm.receiveSMS.value = "false";
		
		if(mobileForm.mobilePhone1.value == "" &&
			(mobileForm.sendMeSMSNotification.checked || mobileForm.sendMeSMSPreference.checked)) {
			mobileForm.URL.value = errorView;	
		}
		else {		
			if( mobileForm.sendMeSMSNotification.checked){			
				mobileForm.receiveSMSNotification.value = "true";
			}
		
			if( mobileForm.sendMeSMSPreference.checked){
				mobileForm.receiveSMS.value = "true";
			}
		}
	},

	

	// summary: Populates the country code to mobile phone.
	// description: This method populates the country code to mobile phone based on the selected country.
	// parameters:
	//			countryDropDownId: Identifier of the mobile country drop down list
	//			countryCallingCodeId : Identifier of the mobile country calling code text box.
	// return: void
	loadCountryCode:function(countryDropDownId,countryCallingCodeId){
	var countryCode = document.getElementById(countryDropDownId).value;
	document.getElementById(countryCallingCodeId).value = countries[countryCode].countryCallingCode;
	}
}
