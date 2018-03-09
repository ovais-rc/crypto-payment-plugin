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
 * @fileOverview This javascript provides the variables and methods used on the PromotionChoiceOfFreeGiftsPopup.jspf
 * to allow the user to select a free gift of their choice when this promotion applies to the order.
 * @version 1.5
 */

PromotionChoiceOfFreeGiftsJS={

	/* Global variable declarations */

	/**
	 * This variable is used to keep track of the enable or disable status of the Apply button in the pop-up.
	 * @private
	 */
	disableApplyButton:false,

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
   * This function is used to update the free gift choices for a promotion, made by the user, during order check-out.
   * The <code>AjaxUpdateRewardOption</code> service is invoked.
   *
   * @param {String} formName: The name of the reward choices form.
   * @param {Integer} maximumNumberOfItems: The maximum number of gift selections that the user can make.
   * @param {Integer} rewardOptionId: The ID of the RewardOption object used to add the reward choices data to.
   */
   updateRewardChoices:function(formName, maximumNumberOfItems, rewardOptionId, orderId){

		if(this.disableApplyButton){
			return false;
		}

		var params = [];
		var catEntryId = [];
		var quantity = [];
		var j = 0;

		params.storeId = this.storeId;
		params.orderId = orderId;
		params["rewardOptionId"] = rewardOptionId;
		if(CheckoutHelperJS.shoppingCartPage){
			params["calculationUsage"] = "-1,-2,-5,-6,-7";
		}else{
			params["calculationUsage"] = "-1,-2,-3,-4,-5,-6,-7";
		}
		//params["allocate"] = "***";
		//params["backorder"] = "***";

		//add the catalog entry ID and quantity of each gift item selection.
		for(var i = 0; i < maximumNumberOfItems; i++){
			if(!document.getElementById("no_gifts").checked){
				if(document.getElementById("SelectFreeGift_" + (i+1)).checked){
					catEntryId[j] = document.getElementById("CatalogEntryID_" + (i+1)).value;
					quantity[j] = document.getElementById("GiftItemQuantity_" + (i+1)).value;
					j++;
				}
			}
		}
		params["catEntryId"] = catEntryId;
		params["quantity"] = quantity;

		//For handling multiple clicks
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		wcService.invoke("AjaxUpdateRewardOption", params);
		//hide the pop-up after the service has been invoked after some delay.
		setTimeout($.proxy(this,"hidePopup",'free_gifts_popup'),200);
        $('#free_gifts_popup').data("wc-WCDialog").close();
	},

	/**
	 * This function is used to display a message of the total number of gift
	 * item selections made by the shopper. It also displays an error message
	 * when the user selects more gift items than the maximum number of gift
	 * items that are allowed for the promotion.
	 *
	 * @param {Integer}
	 *            maximumNumberOfItems The maximum number of gift items that are
	 *            allowed as part of the promotion.
	 */
	checkNumberOfAllowedItems:function(maximumNumberOfItems){
		var i = 1;
		var numberOfSelectionsMade = 0;
		this.disableApplyButton = false;

		while(document.getElementById("SelectFreeGift_" + i)){
			if(document.getElementById("SelectFreeGift_" + i).checked){
				numberOfSelectionsMade++;
			}
			i++;
		}
		if(numberOfSelectionsMade > maximumNumberOfItems){
			//display an error message warning the shopper about exceeding the maximum number of gift item selections
			if(document.getElementById('message')!= null){
				document.getElementById('message').className = "error";
				document.getElementById('message').innerHTML = MessageHelper.messages["PROMOTION_FREE_GIFTS_POPUP_ERROR_EXCEED_GIFT_QUANTITY"];
			}
			this.disableApplyButton = true;
		} else if(numberOfSelectionsMade > 0){
			//display a message indicating the number of gift item selections made by the shopper
			if(numberOfSelectionsMade == 1){
				var selectionsMadeMsg = MessageHelper.messages["PROMOTION_FREE_GIFTS_POPUP_NUMBER_OF_SELECTIONS_ONE"];
			} else {
				var selectionsMadeMsg = MessageHelper.messages["PROMOTION_FREE_GIFTS_POPUP_NUMBER_OF_SELECTIONS"];
				selectionsMadeMsg = selectionsMadeMsg.replace(/%0/, numberOfSelectionsMade);
			}
			if(document.getElementById('message')!= null){
				document.getElementById('message').className = "status_message";
				document.getElementById('message').innerHTML = selectionsMadeMsg;
			}
		} else if(numberOfSelectionsMade == 0){
			//checking that the element exists because when the promotion is inactive,
			//this element does not exist in the jsp.
			if(document.getElementById('message')!= null){
				document.getElementById('message').innerHTML = "&nbsp;"
			}
			this.disableApplyButton = true;
		}
	},

	/**
	 * If the user has selected the option to not receive any free gifts as part
	 * of the promotion, then the gift item choices are cleared and disabled for
	 * selection.
	 */
	rewardChoicesEnabledStatus:function(){
		var i = 1;

		if(document.getElementById("no_gifts").checked){
			this.disableApplyButton = false;
			if(document.getElementById('message')!= null){
				document.getElementById('message').innerHTML = "&nbsp;";
			}
			while(document.getElementById("SelectFreeGift_" + i)){
				document.getElementById("SelectFreeGift_" + i).checked = false;
				document.getElementById("SelectFreeGift_" + i).disabled = true;
				i++;
			}
		} else {
			while(document.getElementById("SelectFreeGift_" + i)){
				document.getElementById("SelectFreeGift_" + i).disabled = false;
				i++;
			}
			this.checkNumberOfAllowedItems();
			this.checkFreeGiftsAvailability();
		}
	},

	/**
	 * This function is used to make the free gift choices pop-up visible to the user.
	 */
	showFreeGiftsDialog: function(){
		this.checkNumberOfAllowedItems();
        $('#free_gifts_popup').data("wc-WCDialog").open();

		this.checkFreeGiftsAvailability();
	},

	/**
	 * This function is used to disable any free gifts that are not available.
	 */
	checkFreeGiftsAvailability: function(){
		var i = 1;
		var numberOfAvailableGifts = 0;

		while(document.getElementById("OnlineAvailability_" + i)){
			if(document.getElementById("OnlineAvailability_" + i).value != "Available" && document.getElementById("OnlineAvailability_" + i).value != "Backorderable"){
				document.getElementById("SelectFreeGift_" + i).checked = false;
				document.getElementById("SelectFreeGift_" + i).disabled = true;
			} else {
				numberOfAvailableGifts++;
			}
			i++;
		}

		if(numberOfAvailableGifts == 0){
			this.disableApplyButton = true;
		}

	},

	/**
	 * Hide the pop-up identified by the passed id parameter.
	 *
	 * @param {String} id: The id of the pop-up to hide.
	 * @param {Object} event: The event object.
	 */
	hideFreeGiftsPopup:function(id,event){
		if(event!=null && event.type=="keypress" && event.keyCode!=KeyCodes.ESCAPE){
			return;
		} else {
			var popUp =  $("#" + id).data("wc-WCDialog");
			if(popUp){
                popUp.close();
			}
		}
	}

}