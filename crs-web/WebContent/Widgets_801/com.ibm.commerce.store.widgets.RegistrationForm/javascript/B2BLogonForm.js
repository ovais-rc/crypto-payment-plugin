//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * @fileOverview This javascript provides all the functions needed for the B2B store logon and registration.
 * @version 1.9
 */

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
        if ($('#'+checkbox).hasClass("active")){
            $('#'+checkbox).removeClass("active");
            $('#'+checkbox).attr("aria-checked", "false");
            $('#'+checkbox).attr("src", jspStoreImgDir + "images/checkbox.png");
        } else {
            $('#'+checkbox).addClass("active");
            $('#'+checkbox).attr("src", jspStoreImgDir + "images/checkbox_checked.png");
            $('#'+checkbox).attr("aria-checked", "true");

            form.usr_address1.value = this.getFieldValue(form.org_address1);
            form.usr_address2.value = this.getFieldValue(form.org_address2);
            form.usr_zipCode.value = this.getFieldValue(form.org_zipCode);

            var $orgCountry = $('#WC_OrganizationRegistrationAddForm_AddressEntryForm_FormInput_org_country_1');
            var $usrCountry = $('#WC_OrganizationRegistrationAddForm_AddressEntryForm_FormInput_usr_country_1');

            $usrCountry.val($orgCountry.val());
            $usrCountry.Select("refresh");

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
           var sendMeSMSNotification = $("#"+ form.sendMeSMSNotification.id);
           if (sendMeSMSNotification != null && sendMeSMSNotification.checked) {
               form.receiveSMSNotification.value = true;
           } else {
               form.receiveSMSNotification.value = false;
           }
       } else {
           form.receiveSMSNotification.value = false;
       }


       if (form.sendMeSMSPreference != null) {
           var sendMeSMSPreference =  $("#"+ form.sendMeSMSPreference.id);
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
        $('#WC_UserRegistrationAddForm_DivForm_1').toggleClass('nodisplay');
        this.toggleInputs($('#WC_UserRegistrationAddForm_DivForm_1'));
        $('#WC_OrganizationRegistration_DivForm_1').toggleClass('nodisplay');
        $('#WC_OrganizationRegistration_DivForm_2').toggleClass('nodisplay');
        this.disableOrgInputs();
        $('#WC_UserRegistrationAddForm_Buttons_1').toggleClass('nodisplay');
        $('#WC_OrganizationRegistration_Buttons_1').toggleClass('nodisplay');
        this.changeFormAction();
    },

    toggleInputs: function (form) {
                if ($('input, select', form).attr('disabled')) {
                        $('input, select', form).removeAttr('disabled');
                } else {
                        $('input, select', form).attr('disabled', 'disabled');
                }

    },

    disableOrgInputs: function () {
        this.toggleInputs($('#WC_OrganizationRegistration_DivForm_1'));
        this.toggleInputs($('#WC_OrganizationRegistration_DivForm_2'));
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
        $('#registration_arrow').toggleClass('right');
        $('#individual_link').toggleClass('nodisplay');
        $('#individual_image_on').toggleClass('nodisplay');
        $('#organization_link').toggleClass('nodisplay');
        $('#organization_image_on').toggleClass('nodisplay');
        $('#organizationDescription').toggleClass('nodisplay');
        $('#individualDescription').toggleClass('nodisplay');

        if (id == 'individual_link') {
            $('#organization_link').focus();
        } else {
            $('#individual_link').focus();
        }
        this.toggleOrgRegistration();
    },
}
