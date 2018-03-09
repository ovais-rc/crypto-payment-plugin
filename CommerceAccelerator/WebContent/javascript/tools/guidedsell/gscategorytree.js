//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------

// @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.



//function for checking the existence of Sales Assisstance for a category
function isGuidedSellExists(param) {
	var value = false;
	if(param != null || param != ''){
		var params = param.split('&');
		var plength = params.length;
		for(var i=0;i<plength;i++){
			var tparam = params[i];
			var key = tparam.split('=');
			var tkey = key[0];
			if(tkey == 'guidedSellExists'){
				value = (key[1] == 'true');
				return value;
			}
		}
	} else {
		return value;
	}

}

// Function for getting the Guided Sell Category
function getGuidedSellCategory(param) {
	var category = "";
	if(param != null || param != ''){
		var params = param.split('&');
		var plength = params.length;
		for(var i=0;i<plength;i++){
			var tparam = params[i];
			var key = tparam.split('=');
			var tkey = key[0];
			if(tkey == 'categoryId'){
				category = key[1];
				return category;
			}
		}
	} else {
		return category;
	}

}

// Function for getting the wheather guided sell can be created added for defect 40138
function getCanCreateGS(param) {
	var canCreateGS = false;
	if(param != null || param != ''){
		var params = param.split('&');
		var plength = params.length;
		for(var i=0;i<plength;i++){
			var tparam = params[i];
			var key = tparam.split('=');
			var tkey = key[0];
			if(tkey == 'canCreateGS'){
				canCreateGS = (key[1] == 'true');
				return canCreateGS;
			}
		}
	} else {
		return canCreateGS;
	}

}