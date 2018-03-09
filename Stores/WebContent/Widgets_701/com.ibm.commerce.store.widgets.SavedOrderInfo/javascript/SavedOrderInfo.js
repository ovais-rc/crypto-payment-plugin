//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by saved order detail widget
 */

	SavedOrderInfoJS = {

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
			 * This variable stores the order ID of the saved order. Its default value is empty.
			 */
			orderId : "",
			
			/**
			 * Sets the common parameters for the current page. 
			 * For example, the language ID, store ID, and catalog ID.
			 *
			 * @param {Integer} langId The ID of the language that the store currently uses.
			 * @param {Integer} storeId The ID of the current store.
			 * @param {Integer} catalogId The ID of the catalog.
			 */
			setCommonParameters:function(langId,storeId,catalogId){
				this.langId = langId;
				this.storeId = storeId;
				this.catalogId = catalogId;
			},
	
			/**
			 * Updates the name/description of a saved order.
			 * @param (object) formName The form that contains the saved order name.
			 * 
			 */
			updateDescription: function(formName) {
				MessageHelper.hideAndClearMessage();
				var form = document.forms[formName];
				
				form.savedOrderInfo_name.value = trim(form.savedOrderInfo_name.value);
				form.oldSavedOrderInfo_name.value = trim(form.oldSavedOrderInfo_name.value);
				
				var desc = form.savedOrderInfo_name;
				var oldDesc = form.oldSavedOrderInfo_name;

				// Check to see if the order description has really changed by comparing it to the original value.
				if (desc != oldDesc) {
					//Need to give the service declaration the form with all info about saved order name info
					service = wc.service.getServiceById("savedOrderUpdateDescription");
					service.formId = formName;
					
					if(!submitRequest()){
						return;
					}
					cursor_wait();
					
					//This updates the name/description of the saved order		
					wc.service.invoke('savedOrderUpdateDescription');
				}

			},

			/**
			* Toggles the edit area of saved order info section
			*/
			toggleEditInfo:function() {
				if (dojo.byId("savedOrderCurrentInfo").style.display=="none") {
					dojo.byId("savedOrderCurrentInfo").style.display="block";
					dojo.byId("editSavedOrderInfo").style.display="none";
				} else {
					dojo.byId("savedOrderCurrentInfo").style.display="none";				
					dojo.byId("editSavedOrderInfo").style.display="block";	
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
      
                        /**
                         *This method toggles the lock set on the order. It submits the 'savedOrderToggleLockForm' form declared.
                         *Based on the action defined in the form, the order is either locked or unlocked.                         
                         */                                                       
                        toggleOrderLock: function(){
                                document.forms['savedOrderToggleLockForm'].URL.value = document.location.href;
                                document.forms['savedOrderToggleLockForm'].submit();
                                return true;
                        }
	}
  
