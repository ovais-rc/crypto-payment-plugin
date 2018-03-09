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

/**
 *@fileOverview This javascript file defines all the javascript functions used by approval comment widget
 */

	ApprovalCommentJS = {
			
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
		* These variables define approve or reject status in the APRVSTATUS table. 1 for approved or 2 for rejected.
		*/
		cApproveStatus: 1,
		cRejectStatus: 2,
		
		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 */
		setCommonParameters: function(langId,storeId,catalogId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
		},
		
		/**
		* Approves a approval record
		*/
		approveRecord: function(aprvstatus_id) {
			if(MessageHelper.utf8StringByteLength($('#approvalForm_comments').val()) > 254){ 
				MessageHelper.formErrorHandleClient($('#approvalForm_comments')[0], MessageHelper.messages["APP_COMMENT_ERR_TOO_LONG"]); 
				return false;
			}
			
			service = wcService.getServiceById('AjaxApproveRequest');
			var params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                aprv_act: this.cApproveStatus,
                approvalStatusId: aprvstatus_id,
                viewtask: "BuyerApprovalDetailView"
            };
			if ($("#approvalForm_comments").length) {
				params.comments = $("#approvalForm_comments").val();
			}

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('AjaxApproveRequest',params);		
		},

		/**
		* Rejects a approval record
		*/
		rejectRecord: function(aprvstatus_id) {
			if(MessageHelper.utf8StringByteLength($('#approvalForm_comments').val()) > 254){ 
				MessageHelper.formErrorHandleClient($('#approvalForm_comments')[0], MessageHelper.messages["APP_COMMENT_ERR_TOO_LONG"]); 
				return false;
			}
			
			service = wcService.getServiceById('AjaxRejectRequest');
			var params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                aprv_act: this.cRejectStatus,
                approvalStatusId: aprvstatus_id,
                viewtask: "BuyerApprovalDetailView"
            };
			if ($("#approvalForm_comments").length) {
				params.comments = $("#approvalForm_comments").val();
			}

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('AjaxRejectRequest',params);		
		}

	}