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
 *@fileOverview This javascript file defines all the javascript functions used by order approval widget
 */

	OrderApprovalListJS = {
			
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
		* These variables refers to Ids of startSubmitDate and endSubmitDate element in OrderApprovalList_ToolBar_UI.jspf.
		*/
		formStartDateId: "",
		formEndDateId: "",
		
		/**
		 * Search tool bar Id
		 */
		toolbarId: "",
		
		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 */
		setCommonParameters: function(langId,storeId,catalogId,requisitionListId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
		},
		
		/**
		 * Sets the common parameters for the current page. 
		 *
		 * @param {String} formStartDateId The ID of the startDate element.
		 * @param {String} formEndDateId The ID of the endDate element.
		 * @param {String} toolbarId The ID of the tool bar element.
		 */
		setToolbarCommonParameters: function(formStartDateId,formEndDateId, toolbarId){
			this.formStartDateId = formStartDateId;
			this.formEndDateId = formEndDateId;
			this.toolbarId = toolbarId;
		},
		
		/**
		* Approves a order record
		* @param {Long} aprvstatus_id The id of the request to be approved
		*/
		approveOrder: function(aprvstatus_id) {
			service = wcService.getServiceById('AjaxApproveOrderRequest');

			var params = {
                storeId : this.storeId,
                catalogId : this.catalogId,
                langId : this.langId,
                aprv_act : this.cApproveStatus,
                approvalStatusId : aprvstatus_id,
                viewtask : "OrderApprovalView"
            };

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('AjaxApproveOrderRequest',params);		
		},

		/**
		* Rejects a order record
		* @param {Long} aprvstatus_id The id of the request to be approved
		*/
		rejectOrder: function(aprvstatus_id) {
			service = wcService.getServiceById('AjaxRejectOrderRequest');

			var params = {
			    storeId: this.storeId,
			    catalogId: this.catalogId,
			    langId: this.langId,
			    aprv_act: this.cRejectStatus,
			    approvalStatusId: aprvstatus_id,
			    viewtask: "OrderApprovalView"
			};

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('AjaxRejectOrderRequest',params);
		},
		
		/**
		* This function is called when user selects a different page from the current page
		* @param (Object) data The object that contains data used by pagination control 
		*/
		showResultsPage:function(data){
			var pageNumber = data[0]['pageNumber'],
                pageSize = data[0]['pageSize'];
			pageNumber = parseInt(pageNumber);
			pageSize = parseInt(pageSize);

			setCurrentId(data[0]["linkId"]);

			if(!submitRequest()){
				return;
			}

			var beginIndex = pageSize * ( pageNumber - 1 );
			cursor_wait();

			wcRenderContext.updateRenderContext('OrderApprovalTable_Context', {"beginIndex": beginIndex});
			MessageHelper.hideAndClearMessage();
		},
		
		
		/**
		 * Clear the context search term value set by search form
		 */
		reset:function(){
			this.updateContext({"beginIndex":"0", "orderId": "", "firstName": "", "lastName":"","startDate":"","endDate":""});
		},
		
		/**
		 * Search for buyer approval requests use the search terms specified in the toolbar search form.
		 * 
		 * @param (String) formId	The id of toolbar search form element.
		 */
		doSearch:function(formId){
			var form = $("#" + formId)[0],
                startDateValue = "",
                endDateValue = "",
                startDateWidgetValue = $("#" + this.formStartDateId + "_datepicker").datepicker("getDate");
			if (Utils.varExists(startDateWidgetValue)){
				startDateValue = startDateWidgetValue.toISOString().replace(/\.\d\d\dZ/, '+0000');
			}
			var endDateWidgetValue = $("#" + this.formEndDateId + "_datepicker").datepicker("getDate");
			if (Utils.varExists(endDateWidgetValue)){
				//add one day to the picked endDate.We pick a date the value for the date object
				//is yyyy-MM-dd 00:00:00(beginning of a day, we need it to be end of the a day)
				endDateWidgetValue = Utils.addDays(endDateWidgetValue, 1);
				//deduct one millisecond from the added date
				endDateWidgetValue = Utils.addMilliseconds(endDateWidgetValue, -1);
				endDateValue = endDateWidgetValue.toISOString().replace(/\.\d\d\dZ/, '+0000');
			}
			this.updateContext({
			    "beginIndex": "0",
			    "orderId": form.orderId.value.replace(/^\s+|\s+$/g, ''),
			    "firstName": form.submitterFirstName.value.replace(/^\s+|\s+$/g, ''),
			    "lastName": form.submitterLastName.value.replace(/^\s+|\s+$/g, ''),
			    "startDate": startDateValue,
			    "endDate": endDateValue
			});
		},
		
		/**
		 * Filter the buyer Approval list by status
		 * 
		 * @param (String) status The id of toolbar search form element.
		 */
		doFilter:function(status){
			this.updateContext({"beginIndex":"0", "approvalStatus": status});
		},
		
		/**
		 * Update the OrderApprovalTable_Context context with given context object.
		 * 
		 * @param (Object)context The context object to update
		 */
		updateContext:function(context){
			this.saveToolbarStatus();
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcRenderContext.updateRenderContext("OrderApprovalTable_Context", context);
			MessageHelper.hideAndClearMessage();
		},
		
		/**
		 * Save the toolbar aria-expanded attribute value
		 */
		saveToolbarStatus:function(){
            Utils.ifSelectorExists("#" + this.toolbarId, function($toolbar) {
                this.toolbarExpanded = $toolbar.attr("aria-expanded");
            }, this);
		},
		
		/**
		 * Restore the toolbar aria-expanded attribute, called by post-refresh handler
		 */
		restoreToolbarStatus:function(){
			if (Utils.varExists(this.toolbarExpanded)){
				$("#" + this.toolbarId).attr("aria-expanded", this.toolbarExpanded);
			}
		}
	}