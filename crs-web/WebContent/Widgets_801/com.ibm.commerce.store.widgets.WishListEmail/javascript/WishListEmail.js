//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file contains all the global variables and JavaScript functions needed for wish list email widget used in My Account section.
 * This JavaScript file defines all the functions used by the WishListEmail.jsp file.
 * @version 1.0
 */

/* Declare the namespace if it does not already exist. */
if (WishListEmailJS == null || typeof(WishListEmailJS) != "object") {
	/**
	 * @class This WishListEmailJS class defines all the variables and functions for the wish list email widget used in the My account section.
	 *
	 */
	var WishListEmailJS = {
		/**
		* This function is used to clear some of the fields in the email form in wish list page after InterestItemListMessage is invoked.
		* @param {string} formId  the id of the email form in WishList page.
		*/	
		clearWishListEmailForm:function(formId){
			var form = document.getElementById(formId);
			form.recipient.value = "";
			form.sender_name.value = "";
			form.sender_email.value = "";
			form.wishlist_message.value="";
		}
	}
}




