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
			if(MessageHelper.utf8StringByteLength(dojo.byId('approvalForm_comments').value) > 254){ 
				MessageHelper.formErrorHandleClient(dojo.byId('approvalForm_comments'), MessageHelper.messages["APP_COMMENT_ERR_TOO_LONG"]); 
				return false;
			}
			
			service = wc.service.getServiceById('AjaxApproveRequest');
			var params = {};
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;
			params.aprv_act = this.cApproveStatus;
			params.approvalStatusId = aprvstatus_id;
			params.viewtask = "BuyerApprovalDetailView";
			if (dojo.byId('approvalForm_comments') != null) {
				params.comments = dojo.byId('approvalForm_comments').value;
			}

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wc.service.invoke('AjaxApproveRequest',params);		
		},

		/**
		* Rejects a approval record
		*/
		rejectRecord: function(aprvstatus_id) {
			if(MessageHelper.utf8StringByteLength(dojo.byId('approvalForm_comments').value) > 254){ 
				MessageHelper.formErrorHandleClient(dojo.byId('approvalForm_comments'), MessageHelper.messages["APP_COMMENT_ERR_TOO_LONG"]); 
				return false;
			}
			
			service = wc.service.getServiceById('AjaxRejectRequest');
			var params = {};
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;
			params.aprv_act = this.cRejectStatus;
			params.approvalStatusId = aprvstatus_id;
			params.viewtask = "BuyerApprovalDetailView";
			if (dojo.byId('approvalForm_comments') != null) {
				params.comments = dojo.byId('approvalForm_comments').value;
			}

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wc.service.invoke('AjaxRejectRequest',params);		
		}

	}