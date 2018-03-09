//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript provides all the functions needed for the B2B store logon and registration.
 * @version 1.9
 */

dojo.require("wc.service.common");
dojo.require("wc.widget.Tooltip");
dojo.require("dijit.form.Select");

B2BLogonForm ={
	prepareSubmitOrgReg:function (form){
      /////////////////////////////////////////////////////////////////////////////
      // This javascript function is for 'Submit' button in the organization registration page.
      /////////////////////////////////////////////////////////////////////////////
      reWhiteSpace = new RegExp(/^\s+$/);
      if (form.org_orgEntityName !=null && (reWhiteSpace.test(form.org_orgEntityName.value) || form.org_orgEntityName.value=="")) {
         MessageHelper.formErrorHandleClient(form.org_orgEntityName.id,MessageHelper.messages["ERROR_OrgNameEmpty"]); return;
      }
      if(!AddressHelper.validateAddressForm(form,'org_')){
          return;
      }      

      if (form.usr_logonId !=null && (reWhiteSpace.test(form.usr_logonId.value) || form.usr_logonId.value=="")){
         MessageHelper.formErrorHandleClient(form.usr_logonId.id,MessageHelper.messages["ERROR_LogonIdEmpty"]); return;
      }
      if (form.usr_logonPassword !=null && (reWhiteSpace.test(form.usr_logonPassword.value) || form.usr_logonPassword.value=="")){
         MessageHelper.formErrorHandleClient(form.usr_logonPassword.id,MessageHelper.messages["ERROR_PasswordEmpty"]); return;
      }else if  (form.usr_logonPasswordVerify !=null && (reWhiteSpace.test(form.usr_logonPasswordVerify.value) || form.usr_logonPasswordVerify.value=="")) {
         MessageHelper.formErrorHandleClient(form.usr_logonPasswordVerify.id,MessageHelper.messages["ERROR_PasswordEmpty"]); return;
      }else if (form.usr_logonPasswordVerify !=null && form.usr_logonPasswordVerify.value!= form.usr_logonPassword.value) {
         MessageHelper.formErrorHandleClient(form.usr_logonPasswordVerify.id,MessageHelper.messages["PWDREENTER_DO_NOT_MATCH"]); return;
      }
      if(!AddressHelper.validateAddressForm(form,'usr_')){
         return;
      }

      if (form.usr_email1 !=null && (reWhiteSpace.test(form.usr_email1.value) || form.usr_email1.value=="")){
         MessageHelper.formErrorHandleClient(form.usr_email1.id,MessageHelper.messages["ERROR_EmailEmpty"]); return;
      }else if(!MessageHelper.isValidEmail(form.usr_email1.value)){
         MessageHelper.formErrorHandleClient(form.usr_email1.id,MessageHelper.messages["WISHLIST_INVALIDEMAILFORMAT"]);return ;
      }
      if (!MessageHelper.IsValidPhone(form.usr_phone1.value)) {
         MessageHelper.formErrorHandleClient(form.usr_phone1.id,MessageHelper.messages["ERROR_INVALIDPHONE"]);
         return ;
      }

      if(form.mobileDeviceEnabled != null && form.mobileDeviceEnabled.value == "true"){
         if(!MyAccountDisplay.validateMobileDevice(form)){
            return;
         }
      }
      if(form.birthdayEnabled != null && form.birthdayEnabled.value == "true"){
         if(!MyAccountDisplay.validateBirthday(form)){
            return;
         }
      }
      this.setSMSCheckBoxes(form);

      form.submit();
   },
   
	constructParentOrgDN: function (ancestorOrgs) {
      var parentOrgDN = ancestorOrgs;
      while(true) {
         var n = parentOrgDN.indexOf("/");
         if(n == -1) {
            break;
         }
         parentOrgDN = parentOrgDN.substring(0, n) + "," + orgPrefix + parentOrgDN.substring(n + 1, parentOrgDN.length);
      }
      parentOrgDN = orgPrefix + parentOrgDN;
      return parentOrgDN;
   },
   
   setParentMemberValue: function (){
      document.Register.parentMember.value = this.constructParentOrgDN(document.Register.ancestorOrgs.value);
   },

   fillAdminAddress: function(form, jspStoreImgDir, checkbox){
		if (dojo.hasClass(checkbox, "active")){			
			dojo.removeClass(checkbox, "active");
			dojo.attr(checkbox, "aria-checked", "false");
			dojo.attr(checkbox, "src", jspStoreImgDir + "images/checkbox.png");
		} else {
			dojo.addClass(checkbox, "active");
			dojo.attr(checkbox, "src", jspStoreImgDir + "images/checkbox_checked.png");
			dojo.attr(checkbox, "aria-checked", "true");
			
			form.usr_address1.value = this.getFieldValue(form.org_address1);
			form.usr_address2.value = this.getFieldValue(form.org_address2);
			form.usr_zipCode.value = this.getFieldValue(form.org_zipCode);
			
			var orgCountry = dijit.byId('WC_OrganizationRegistrationAddForm_AddressEntryForm_FormInput_org_country_1');
			var usrCountry = dijit.byId('WC_OrganizationRegistrationAddForm_AddressEntryForm_FormInput_usr_country_1');
			//proper way to prevent onChange happen, pass false to "priorityChange" parameter.
			usrCountry.set('value', orgCountry.get('value'), false);
	
			//see AddressHelper.loadAddressFormStatesUI
			AddressHelper.loadAddressFormStatesUI(form.name,'usr_','usr_stateDiv','WC_OrganizationRegistrationAddForm_AddressEntryForm_FormInput_usr_state_1',false,this.getFieldValue(form.org_state));
			form.usr_city.value = this.getFieldValue(form.org_city);
		}
   },

   getFieldValue: function (field){
      //returns the field value iff the the field value is not null or empty.
      return (field==null || field=='')?'':field.value;
   },
   
   setSMSCheckBoxes: function (form) {
	   /* 
	    * In AddressForm.jsp, setSMSCheckBoxes and sendMeSMSPreference are used as the name of the checkboxes.
	    * But for the command BuyerRegistrationAdd to save the data, the name of the checkboxes must be 
	    * converted to receiveSMSNotification and receiveSMSPreference
	    * */
	   if (form.sendMeSMSNotification != null) {
		   var sendMeSMSNotification = dojo.byId(form.sendMeSMSNotification.id);
		   if (sendMeSMSNotification != null && sendMeSMSNotification.checked) {
			   form.receiveSMSNotification.value = true;
		   } else {
			   form.receiveSMSNotification.value = false;
		   }
	   } else {
		   form.receiveSMSNotification.value = false;
	   }
	   
	   
	   if (form.sendMeSMSPreference != null) {
		   var sendMeSMSPreference = dojo.byId(form.sendMeSMSPreference.id);
		   if (sendMeSMSPreference != null && sendMeSMSPreference.checked) {
			   form.receiveSMS.value = true;
		   } else {
			   form.receiveSMS.value = false;
		   }
	   } else {
		   form.receiveSMS.value = false;
	   }
   },
   
   changeFormAction: function () {
		if (document.getElementById('Register').action.indexOf('UserRegistrationAdd') != -1) {
	    	document.getElementById('Register').action = 'BuyerRegistrationAdd';
	    } else {
	    	document.getElementById('Register').action = 'UserRegistrationAdd';
	    }

		var tempURL = document.Register.URL.value;
		document.Register.URL.value = document.Register.URLOrg.value;
		document.Register.URLOrg.value = tempURL;
	},
	
	toggleOrgRegistration: function () {
		dojo.toggleClass('WC_UserRegistrationAddForm_DivForm_1', 'nodisplay');
		this.toggleInputs(dojo.byId('WC_UserRegistrationAddForm_DivForm_1'));
		dojo.toggleClass('WC_OrganizationRegistration_DivForm_1', 'nodisplay');
		dojo.toggleClass('WC_OrganizationRegistration_DivForm_2', 'nodisplay');
		this.disableOrgInputs();
		dojo.toggleClass('WC_UserRegistrationAddForm_Buttons_1', 'nodisplay');
		dojo.toggleClass('WC_OrganizationRegistration_Buttons_1', 'nodisplay');
		this.changeFormAction();
	},
	
	toggleInputs: function (form) {
		dojo.query('input, select', form).forEach(
			function (inputElem) {
			    if (dojo.hasAttr(inputElem, 'disabled')) {
			    	dojo.removeAttr(inputElem, 'disabled');
			    } else {
			    	dojo.setAttr(inputElem, 'disabled', 'disabled');
			    }
			}
		)
	},
	
	disableOrgInputs: function () {
		this.toggleInputs(dojo.byId('WC_OrganizationRegistration_DivForm_1'));
		this.toggleInputs(dojo.byId('WC_OrganizationRegistration_DivForm_2'));
	},
	
	checkRegisterOrg: function (checked) {
		if (checked) {
			this.switchRegistration();
		}
	},
	
	submitForm: function (form) {
		//check to make sure Buyer Organization is set. 	 
		var reWhiteSpace = new RegExp(/^\s+$/);
		if (form.ancestorOrgs !=null && reWhiteSpace.test(form.ancestorOrgs.value) || form.ancestorOrgs.value=="") {
			MessageHelper.formErrorHandleClient(form.ancestorOrgs.id,MessageHelper.messages["ERROR_OrgNameEmpty"]); return;
		}
	
		//set the value of buyer organization
		B2BLogonForm.setParentMemberValue(form);
     
		//set the SMS values
		B2BLogonForm.setSMSCheckBoxes(form);
     
		//now submit the form
		LogonForm.prepareSubmit(form);
		return false;
	},
	
	switchRegistration: function (id) {
		dojo.toggleClass('registration_arrow', 'right');
		dojo.toggleClass('individual_link', 'nodisplay');
		dojo.toggleClass('individual_image_on', 'nodisplay');
		dojo.toggleClass('organization_link', 'nodisplay');
		dojo.toggleClass('organization_image_on', 'nodisplay');
		dojo.toggleClass('organizationDescription', 'nodisplay');
		dojo.toggleClass('individualDescription', 'nodisplay');
		if (id == 'individual_link') {
			dojo.byId('organization_link').focus();
		} else {
			dojo.byId('individual_link').focus();
		}
		this.toggleOrgRegistration();
	},
}

B2BOrgTooltip ={

   // formattedRequestDate:"",
   langId: "-1",
   storeId: "",
   catalogId: "",   
   errorMessages:{},
       
   /***********************************************************************
	 * The following functions are used to set/reset Dijit tooltip on a page
	 ***********************************************************************/
	
   // summary	: Reset the tooltip template
   // description	: Reset the master template - tooltip will use default master template from dojo
   // assumptions	: Dojo, Dijit installed
   // dojo API	: Dijit
   // returns	: void
   resetTooltip: function() {
      dijit._masterTT = new dijit._MasterTooltip();
   },
	
   // summary	: Set the tooltip template
   // description	: Set master template to use Madisons style template (no bubbles)
   // assumptions	: Dojo, Dijit installed
   // dojo API	: Dijit
   // returns	: void
   setTooltip: function() {
      dijit._masterTT = new dijit._MasterTooltip({
         templateString:"<div class=\"dijitTooltip dijitTooltipLeft\" id=\"dojoTooltip\">\n\t<div dojoAttachPoint=\"containerNode\" waiRole='alert'></div></div>\n",
         duration:10
      });
   },
	
   // summary	: Map tooltip handling to events for an element
   // description	: When onFocus or onMouseOver event occurs on the tooltip, set the tooltip template to Madisons style template (no bubble).
   //			When onBlur or onMouseOut event occurs on the tooltip, set the tooltip template to default dojo style template (with bubble)
   // parameters	: elementName -> the name of the element that will be associated with tooltip handling
   // assumptions	: Dojo installed
   // dojo API	: dojo.byId, dojo.connect
   // returns	: void
   tooltipInit: function(elementName) {
      tooltip = dojo.byId(elementName);
      dojo.connect(tooltip, 'onfocus', this.setTooltip);
      dojo.connect(tooltip, 'onmouseover', this.setTooltip);
      dojo.connect(tooltip, 'onblur', this.resetTooltip);
      dojo.connect(tooltip, 'onmouseout', this.resetTooltip);
   }
}
