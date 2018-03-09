//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by requisition list detail widget
 */

	ReqListInfoJS = {
			
		/** 
		 * This variable stores the ID of the language that the store currently uses. Its default value is set to -1, which corresponds to United States English.
		 * @private
		 */
		langId: "-1",
		
		/** 
		 * This variable stores the ID of the current store. Its default value is empty.
		 * @private
		 */
		storeId: "",
		
		/** 
		 * This variable stores the ID of the catalog. Its default value is empty.
		 * @private
		 */
		catalogId: "",

		/**			
		* This variable keeps track of the requisition list type. The choice can be private ('Y') or shared ('Z')
		*/
		status: "",

		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 */
		setCommonParameters: function(langId,storeId,catalogId,status){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
			this.status = status;
		},

		/**
		* Sets the status of the requisition list and update the dropdown to display the current status.
		*
		* @param {String} status The status to set for the requisition list
		* @param {String} statusDisplay The text to show for the requisition list type dropdown (private or shared)
		* @param {String} selectDropdown id of the HTML div that represents the dropdown
		*/		
		setListStatus: function(status, statusDisplay, selectDropdown) {
			this.status = status;
			dojo.byId("reqListInfo_curStatus").innerHTML = statusDisplay;
			this.toggleSelectDropdown(selectDropdown);
		},
		
		/**
		 * Updates the name or type or both of a requisition list.
		 * @param (object) formName The form that contains the new requisition list data.
		 */
		updateReqList: function(formName) {
			MessageHelper.hideAndClearMessage();
			var form = document.forms[formName];
			if (form.reqListInfo_name!=null && this.isEmpty(form.reqListInfo_name.value)) {
				MessageHelper.formErrorHandleClient(form.reqListInfo_name.id,MessageHelper.messages["ERROR_REQUISITION_LIST_NAME_EMPTY"]); return;
			}

			form.reqListInfo_name.value = trim(form.reqListInfo_name.value);
			form.reqListInfo_type.value = this.status;
			
			//Need to give the service declaration the form with all info about all req list info
			service = wc.service.getServiceById("requisitionListUpdate");
			service.formId=formName;
			
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			
			//This only updates the name and type for req list since another command updates items separately
			//After successful name/type update, success handler will trigger quantity update service call		
			wc.service.invoke('requisitionListUpdate');
		},

		/**
		* Toggles the edit area of requisition list info section
		*/
		toggleEditInfo: function() {
			if (dojo.byId("requisitionListCurrentInfo").style.display=="none") {
				dojo.byId("toolbarButton1").className = "button_primary";
				dojo.byId("requisitionListCurrentInfo").style.display="block";
				dojo.byId("editRequisitionListInfo").style.display="none";
			} else {
				dojo.byId("toolbarButton1").className = "button_secondary";
				dojo.byId("requisitionListCurrentInfo").style.display="none";				
				dojo.byId("editRequisitionListInfo").style.display="block";	
			}
		},

		/**
		* Toggles the requisition list type dropdown
		* @param {String} selectDropdown id of the HTML div that represents the dropdown
		*/		
		toggleSelectDropdown: function(selectDropdown) {
			if (dojo.byId(selectDropdown).style.display == "none") {
				dojo.byId(selectDropdown).style.display = "block"
			}	else {
				dojo.byId(selectDropdown).style.display = "none";
			}
		},

		/**
		 * Checks if a string is null or empty.
		 * @param (string) str The string to check.
		 * @return (boolean) Indicates whether the string is empty.
		 */
		isEmpty: function(str) {
			var reWhiteSpace = new RegExp(/^\s+$/);
			if (str == null || str =='' || reWhiteSpace.test(str) ) {
				return true;
			}
			return false;
		},

	}