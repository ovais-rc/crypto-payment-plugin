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

//
//

/**
* @fileOverview This file holds methods to perform client side operations in relation to catalog browsing, usually at the category level.<b> 
* 			For example, this file holds methods to add items to the shopping cart, wish list and compare zone and to resolve SKUs.<b> 
*			This file is referenced in a collection of JSPs including all of the catalog entry display JSPs such as
*			CachedBundleDisplay.jsp, CachedItemDisplay.jsp , CachedPackageDisplay.jsp, CachedProductOnlyDisplay.jsp.
*			As well this file is included in CategoryOnlyResultsDisplay.jsp and in none catalog browsing pages such as 
*			CatalogSearchDisplay.jsp and MyAccountDisplay.jsp.
*
* @version 1.0
**/

/**
* @class categoryDisplayJS This class defines all the variables and functions used by the CategoryDisplay.js. Any page that will use a function in this file
*		can access that function thru this class. Pages that use categoryDisplayJS include CachedProductOnlyDisplay.jsp which is responsible for
*		displaying product details. As well CategoryOnlyResultsDisplay.jsp uses this page to facilitate the category browsing functionality such as add to cart, 
*		wish list and compare zone.
*
**/
categoryDisplayJS={
	
	/** An array of entitled items which is used in various methods throughout CategoryDisplay.js **/
	entitledItems:[],
	
	/** An map which holds the attributes of a set of products **/
	selectedProducts:{},
	
	/** A map of attribute name value pairs for the currently selected attribute values **/
	selectedAttributes:{},
	
	/** Can be used to hold a map of error messages **/
	errorMessages: {},
	
	/** The language ID currently in use **/
	langId: "-1",
	
	/** The store ID currently in use **/
	storeId: "",
	
	/** The catalog ID currently in use **/
	catalogId: "",
	
	/** The order ID currently in use if being called from the pending order details page.**/
	orderId: "",
	
	/** Can be used to indicate whether or not there has been a context change event **/
	contextChanged:false, 
	
	/** Set to true in the goBack and goForward methods **/
	isHistory:false,
	
	/** Holds an array of  JSON objects representing properties of merchandising associations **/
	merchandisingAssociationItems:[],
	
	/** Holds an array of JSON objects holding information about the parent catalog entries of merchandising associations **/
	baseCatalogEntryDetails:[],
	
	/** Used to determine the index of the next association to display and is used as a global storage variable to share data between methods. **/
	associationThumbnailIndex:1,
	
	/** A count of the number of merchandising associations available. **/
	totalAssociationCount:0,
	
	/** A boolean used in a variety of the add to cart methods to tell whether or not the base item was added to the cart. **/
	baseItemAddedToCart:false,
	
	/** A boolean used to determine whether or not to add merchandising associations to the cart **/
	merchandisingProductAssociationAddToCart:false,
	
	/** The form which holds information about merchandising associations to be added to the cart **/
	merchandisingProductAssociationForm:"",
	
	/** A boolean used to determine whether or not the parent catalog entry is a bundle bean. **/
	isParentBundleBean:false,
	
	/** Holds the current user type such as guest or registered user. Allowed values are 'G' for guest and 'R' for registered.**/
	userType:"",
	
	/** A variable used to form the url dynamically for the more info link in the Quickinfo popup */
	moreInfoUrl :"",
	/** The text to display as an alt to the image used on the MerchandisingAssociationDisplay.jsp to show the previous assoication **/
	displayPrevAssociation:"",
	
	/** The text to display as an alt to the image used on the MerchandisingAssociationDisplay.jsp to show the next assoication **/
	displayNextAssociation:"",
	
	/** A map holding a mapping between product IDs as its key and the first entitled item ID of that product as its value **/
	defaultItemArray:[],

	/** The type of the catalog page that the user is currently viewing **/
	currentPageType:"",

	/** The identifier of the catalog entry that the current page is displaying **/
	currentCatalogEntryId:"",
	
    /** a JSON object that holds attributes of an entitled item **/
    entitledItemJsonObject: null,

	/**
	* A boolean used to to determine is it from a Qick info popup or not. 
	**/
	isPopup : false,

	/**
	* A boolean used to to determine whether or not to diplay the price range when the catEntry is selected. 
	**/
	displayPriceRange : true,

	/**
	* This array holds the json object retured from the service, holding the price information of the catEntry.
	**/
	itemPriceJsonOject : [],
	
	/** 
	* stores all name and value of all swatches 
	* this is a 2 dimension array and each record i contains the following information:
	* allSwatchesArray[i][0] - attribute name of the swatch
	* allSwatchesArray[i][1] - attribute value of the swatch
	* allSwatchesArray[i][2] - image1 of swatch (image to use for enabled state)
	* allSwatchesArray[i][4] - onclick action of the swatch when enabled
	**/
	allSwatchesArray : [],
	
	/**
	* setCommonParameters This function initializes storeId, catalogId, and langId.
	*
	* @param {String} langId The language id to use.
	* @param {String} storeId The store id to use.
	* @param {String} catalogId The catalog id to use.
	* @param {String} userType The type of user. G for Guest user.
	* 
	**/
	setCommonParameters:function(langId,storeId,catalogId,userType){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;
		this.userType = userType;
	},
	
	/**
	* setEntitledItems Sets an array of entitled items for a product. The array that is generated is used later in {@link this.resolveSKU}.
	* 
	* @param {Object} entitledItemArray An object which holds both the catalog entry ID as well as an array of attributes for the entitled items of a product.
	*
	**/
	setEntitledItems : function(entitledItemArray){
		this.entitledItems = entitledItemArray;
	},

	/**
	* setSelectedAttribute Sets the selected attribute value for a particular attribute not in reference to any catalog entry.
	*					   One place this function is used is on CachedProductOnlyDisplay.jsp where there is a drop down box of attributes.
	*					   When an attribute is selected from that drop down this method is called to update the selected value for that attribute.
	*
	* @param {String} selectedAttributeName The name of the attribute.
	* @param {String} selectedAttributeValue The value of the selected attribute.
	*
	**/
	setSelectedAttribute : function(selectedAttributeName , selectedAttributeValue){ 
		console.debug(selectedAttributeName +" : "+ selectedAttributeValue);
		this.selectedAttributes[selectedAttributeName] = selectedAttributeValue;
		this.moreInfoUrl=this.moreInfoUrl+'&'+selectedAttributeName+'='+selectedAttributeValue;
	},

	/**
	* setSelectedAttributeJS Sets the selected attribute value for a particular attribute not in reference to any catalog entry.
	*					   One place this function is used is on the quick info pop up where there is a drop down box of attributes.
	*					   When an attribute is selected from that drop down this method is called to update the selected value for that attribute.
	*
	* @param {String} selectedAttributeName The name of the attribute.
	* @param {String} selectedAttributeValue The value of the selected attribute.
	*
	**/
	setSelectedAttributeJS : function(selectedAttributeName , selectedAttributeValue){ 
		console.debug(selectedAttributeName.replace(/'/g,"&#039;") +" : "+ selectedAttributeValue.replace(/'/g,"&#039;"));
		this.selectedAttributes[selectedAttributeName.replace(/'/g,"&#039;")] = selectedAttributeValue.replace(/'/g,"&#039;");
		this.moreInfoUrl=this.moreInfoUrl+'&'+selectedAttributeName.replace(/'/g,"&#039;") +'='+selectedAttributeValue.replace(/'/g,"&#039;");
	},

	/** 
	 * Displays price of the catEntry selected with the JSON objrct returned from the server.
	 * 
	 * @param {object} serviceRepsonse The JSON response from the service.
	 * @param {object} ioArgs The arguments from the service call.
	 */	
	 displayPriceServiceResponse : function(serviceResponse, ioArgs){
		
		//stores the json object, so that the service is not called when same catEntry is selected.
		categoryDisplayJS.itemPriceJsonOject[serviceResponse.catalogEntry.catalogEntryIdentifier.uniqueID] = serviceResponse;

		categoryDisplayJS.displayPrice(serviceResponse.catalogEntry);
	 },

	/** 
	 * Displays price of the attribute selected with the JSON oject.
	 * 
	 * @param {object} catEntry The JSON object with catalog entry details.
	 */	
	 displayPrice : function(catEntry){

		var tempString;
		var popup = categoryDisplayJS.isPopup;

		if(popup == true){
			$("#productPrice").html(catEntry.offerPrice);
			$("#productName").html(catEntry.description[0].name);
			$("#productSKUValue").html(catEntry.catalogEntryIdentifier.externalIdentifier.partNumber);
		}
		
		if(popup == false){
			var innerHTML = "";
			if(!catEntry.listPriced ||  catEntry.listPrice <= catEntry.offerPrice){
				innerHTML = "<span class='price bold'>"+MessageHelper.messages['PRICE']+" </span>" +
							"<span class='price bold'>" + catEntry.offerPrice + "</span>";
			}
			else{
				innerHTML = "<span class='price bold'>"+MessageHelper.messages['PRICE']+" </span>" +
							"<span class='price listPrice bold'>" + catEntry.listPrice + "</span>"+
							"<div class='price offerprice bold'>" + catEntry.offerPrice + "</div>";
			}

			innerHTML = innerHTML +	"<br />";
			
			if(categoryDisplayJS.displayPriceRange == true){
				for(var i in catEntry.priceRange){
					if(catEntry.priceRange[i].endingNumberOfUnits != 'null'){
						tempString = MessageHelper.messages['TieredPricingDisp'];
						tempString = tempString.replace('{0}',catEntry.priceRange[i].startingNumberOfUnits);
						tempString = tempString.replace('{1}',catEntry.priceRange[i].endingNumberOfUnits);
						tempString = tempString.replace('{2}',catEntry.priceRange[i].localizedPrice);
						innerHTML = innerHTML + "<span class='price bold'>" + tempString + "</span>";;
					}
					else{
						tempString = MessageHelper.messages['TieredPricingDispLast'];
						tempString = tempString.replace('{0}',catEntry.priceRange[i].startingNumberOfUnits);
						tempString = tempString.replace('{1}',catEntry.priceRange[i].localizedPrice);
						innerHTML = innerHTML + "<span class='price bold'>" + tempString + "</span>";;
					}
					innerHTML = innerHTML + "<br />";
				}
			}
			$("#WC_CachedProductOnlyDisplay_div_4").html(innerHTML);
			$("#catalog_link").html(catEntry.description[0].name);
		}
	 },	
	
	/**
	* setSelectedAttributeOfProduct Sets the selected attribute value for an attribute of a specified product.
	*								This function is used to set the assigned value of defining attributes to specific 
	*								products which will be stored in the selectedProducts map.
	*
	* @param {String} productId The catalog entry ID of the catalog entry to use.
	* @param {String} selectedAttributeName The name of the attribute.
	* @param {String} selectedAttributeValue The value of the selected attribute.
	*
	**/
	setSelectedAttributeOfProduct : function(productId,selectedAttributeName,selectedAttributeValue){
		
		selectedAttributesForProduct = {};

		if(this.selectedProducts[productId]) selectedAttributesForProduct = this.selectedProducts[productId];
		
		selectedAttributesForProduct[selectedAttributeName] = selectedAttributeValue;
		this.selectedProducts[productId] = selectedAttributesForProduct;
		
	},
	
	/**
	* getCatalogEntryId Returns the catalog entry ID of the catalog entry with the selected attributes as specified in the {@link this.selectedAttributes} value.
	*					This method uses {@link this.resolveSKU} to find the SKU with the selected attributes values.
	*
	* @see this.resolveSKU
	*
	* @return {String} catalog entry ID.
	*
	**/
	getCatalogEntryId : function(){
		var attributeArray = [];
		for(attribute in this.selectedAttributes){
			attributeArray.push(attribute + "_|_" + this.selectedAttributes[attribute]);
		}
		return this.resolveSKU(attributeArray);
	},
	
	/**
	* getImageForSKU Returns the full image of the catalog entry with the selected attributes as specified in the {@link this.selectedAttributes} value.
	*					This method uses resolveImageForSKU to find the SKU image with the selected attributes values.
	*
	* @return {String} path to the SKU image.
	*
	**/
	getImageForSKU : function(){
		var attributeArray = [];
		for(attribute in this.selectedAttributes){
			attributeArray.push(attribute + "_|_" + this.selectedAttributes[attribute]);
		}
		return this.resolveImageForSKU(attributeArray);
	},
	
	/**
	* getCatalogEntryIdforProduct Returns the catalog entry ID for a catalog entry that has the same attribute values as a specified product's selected attributes as passed in via the selectedAttributes parameter.
	*
	* @param {String[]} selectedAttributes The array of selected attributes upon which to resolve the SKU.
	*
	* @return {String} catalog entry ID of the SKU.
	*
	**/
	getCatalogEntryIdforProduct : function(selectedAttributes){
		var attributeArray = [];
		for(attribute in selectedAttributes){
			attributeArray.push(attribute + "_|_" + selectedAttributes[attribute]);
		}
		return this.resolveSKU(attributeArray);
	},


	/**
	* resolveSKU Resolves a SKU using an array of defining attributes.
	*
	* @param {String[]} attributeArray An array of defining attributes upon which to resolve a SKU.
	*
	* @return {String} catentry_id The catalog entry ID of the SKU.
	*
	**/
	resolveSKU : function(attributeArray){
	
		console.debug("Resolving SKU >> " + attributeArray +">>"+ this.entitledItems);
		var catentry_id = "";
		var attributeArrayCount = attributeArray.length;
		
		for(x in this.entitledItems){
			var catentry_id = this.entitledItems[x].catentry_id;
			var Attributes = this.entitledItems[x].Attributes;
			var attributeCount = 0;
			for(index in Attributes){
				attributeCount ++;
			}

			// Handle special case where a catalog entry has one sku with no attributes
			if (attributeArrayCount == 0 && attributeCount == 0){
				return catentry_id;
			}
			if(attributeCount != 0 && attributeArrayCount >= attributeCount){
				var matchedAttributeCount = 0;

				for(attributeName in attributeArray){
					var attributeValue = attributeArray[attributeName];
					if(attributeValue in Attributes){
						matchedAttributeCount ++;
					}
				}
				
				if(attributeCount == matchedAttributeCount){
					console.debug("CatEntryId:" + catentry_id + " for Attribute: " + attributeArray);
					return catentry_id;
				}
			}
		}
		return null;
	},

	/**
	* resolveImageForSKU Resolves image of a SKU using an array of defining attributes.
	*
	* @param {String[]} attributeArray An array of defining attributes upon which to resolve a SKU.
	*
	* @return {String} imagePath The location of SKU image.
	*
	**/
	resolveImageForSKU : function(attributeArray){
	
		console.debug("Resolving SKU >> " + attributeArray +">>"+ this.entitledItems);
		var imagePath = "";
		var attributeArrayCount = attributeArray.length;
		
		for(x in this.entitledItems){
			var imagePath = this.entitledItems[x].ItemImage;
			var Attributes = this.entitledItems[x].Attributes;
			var attributeCount = 0;
			for(index in Attributes){
				attributeCount ++;
			}

			// Handle special case where a catalog entry has one sku with no attributes
			if (attributeArrayCount == 0 && attributeCount == 0){
				return imagePath;
			}
			if(attributeCount != 0 && attributeArrayCount >= attributeCount){
				var matchedAttributeCount = 0;

				for(attributeName in attributeArray){
					var attributeValue = attributeArray[attributeName];
					if(attributeValue in Attributes){
						matchedAttributeCount ++;
					}
				}
				
				if(attributeCount == matchedAttributeCount){
					console.debug("ItemImage:" + imagePath + " for Attribute: " + attributeArray);
					return imagePath;
				}
			}
		}
		return null;
	},
	
	/**
	* updates the product image from the PDP page to use the selected SKU image
	* @param String entitledItemId the ID of the SKU
	**/
    /*
	changeProdImage: function(entitledItemId){
		if ($("#" + entitledItemId).length) {
			//the json object for entitled items are already in the HTML. 
			 entitledItemJSON = eval('('+ $("#" + entitledItemId).html() +')');
		}
		this.setEntitledItems(entitledItemJSON);
		var skuImage = categoryDisplayJS.getImageForSKU();
		if(skuImage != null){
			document.getElementById('productMainImage').src = skuImage;
		}
	}, */
		
	/**
	* Handles the case when a swatch is selected. Set the border of the selected swatch.
	* @param {String} selectedAttributeName The name of the selected swatch attribute.
	* @param {String} selectedAttributeValue The value of the selected swatch attribute.
	* @param {String} entitledItemId The ID of the SKU
	* @param {String} doNotDisable The name of the swatch attribute that should never be disabled.
	* @return boolean Whether the swatch is available for selection
	**/
    /*
	selectSwatch: function(selectedAttributeName, selectedAttributeValue, entitledItemId, doNotDisable) {
		for (attribute in this.selectedAttributes) {
			if (attribute == selectedAttributeName) {
				// case when the selected swatch is already selected with a value, if the value is different than
				// what's being selected, reset other swatches and deselect the previous value and update selection
				if (this.selectedAttributes[attribute] != selectedAttributeValue) {
					// deselect previous value and update swatch selection
					document.getElementById("swatch_" + this.selectedAttributes[attribute]).className = "swatch_normal";
				}
			}
		}
		this.makeSwatchSelection(selectedAttributeName, selectedAttributeValue, entitledItemId, doNotDisable);
	}, */

	/**
	* Make swatch selection - add to selectedAttribute, select image, and update other swatches and SKU image based on current selection.
	* @param {String} swatchAttrName The name of the selected swatch attribute.
	* @param {String} swatchAttrValue The value of the selected swatch attribute.
	* @param {String} entitledItemId The ID of the SKU.
	* @param {String} doNotDisable The name of the swatch attribute that should never be disabled.	
	**/
    /*
	makeSwatchSelection: function(swatchAttrName, swatchAttrValue, entitledItemId, doNotDisable) {
		this.setSelectedAttribute(swatchAttrName, swatchAttrValue);
		document.getElementById("swatch_" + swatchAttrValue).className = "swatch_selected";
		this.updateSwatchImages(swatchAttrName, entitledItemId, doNotDisable);
		this.changeProdImage(entitledItemId);
	},*/
		
	/**
	* Constructs record and add to this.allSwatchesArray.
	* @param {String} swatchName The name of the swatch attribute.
	* @param {String} swatchValue The value of the swatch attribute.	
	* @param {String} swatchImg1 The path to the swatch image.
	**/
	addToAllSwatchsArray: function(swatchName, swatchValue, swatchImg1) {
		if (!this.existInAllSwatchsArray(swatchName, swatchValue)) {
			var swatchRecord = [];
			swatchRecord[0] = swatchName;
			swatchRecord[1] = swatchValue;
			swatchRecord[2] = swatchImg1;
			swatchRecord[4] = document.getElementById("swatch_" + swatchValue).onclick;
			this.allSwatchesArray.push(swatchRecord);
		}
	},

	/**
	* Checks if a swatch is already exist in this.allSwatchesArray.
	* @param {String} swatchName The name of the swatch attribute.
	* @param {String} swatchValue The value of the swatch attribute.		
	* @return boolean Value indicating whether or not the specified swatch name and value exists in the allSwatchesArray.
	*/
	existInAllSwatchsArray: function(swatchName, swatchValue) {
		for(var i=0; i<this.allSwatchesArray.length; i++) {
			var attrName = this.allSwatchesArray[i][0];
			var attrValue = this.allSwatchesArray[i][1];
			if (attrName == swatchName && attrValue == swatchValue) {
				return true;
			}
		}
		return false;
	},
	
	/**
	* Check the entitledItems array and pre-select the first entited SKU as the default swatch selection.
	* @param {String} entitledItemId The ID of the SKU.
	* @param {String} doNotDisable The name of the swatch attribute that should never be disabled.		
	**/
    /*
	makeDefaultSwatchSelection: function(entitledItemId, doNotDisable) {
		if (this.entitledItems.length == 0) {
			if ($("#" + entitledItemId).length) {
				 entitledItemJSON = eval('('+ $("#" + entitledItemId).html() +')');
			}
			this.setEntitledItems(entitledItemJSON);
		}
		
		// need to make selection for every single swatch
		for(x in this.entitledItems){
			var Attributes = this.entitledItems[x].Attributes;
			for(y in Attributes){
				var index = y.indexOf("_|_");
				var swatchName = y.substring(0, index);
				var swatchValue = y.substring(index+3);
				this.makeSwatchSelection(swatchName, swatchValue, entitledItemId, doNotDisable);
			}
			break;
		}
	}, */
	
	/**
	* Update swatch images - this is called after selection of a swatch is made, and this function checks for
	* entitlement and disable swatches that are not available
	* @param selectedAttrName The attribute that is selected
	* @param {String} entitledItemId The ID of the SKU.
	* @param {String} doNotDisable The name of the swatch attribute that should never be disabled.	
	**/
    /*
	updateSwatchImages: function(selectedAttrName, entitledItemId, doNotDisable) {
		var swatchToUpdate = [];
		var selectedAttrValue = this.selectedAttributes[selectedAttrName];
		
		// finds out which swatch needs to be updated, add to swatchToUpdate array
		for(var i=0; i<this.allSwatchesArray.length; i++) {
			var attrName = this.allSwatchesArray[i][0];
			var attrValue = this.allSwatchesArray[i][1];
			var attrImg1 = this.allSwatchesArray[i][2];
			var attrImg2 = this.allSwatchesArray[i][3];
			var attrOnclick = this.allSwatchesArray[i][4];
			
			if (attrName != doNotDisable && attrName != selectedAttrName) {
				var swatchRecord = [];
				swatchRecord[0] = attrName;
				swatchRecord[1] = attrValue;
				swatchRecord[2] = attrImg1;
				swatchRecord[4] = attrOnclick;
				swatchRecord[5] = false;
				swatchToUpdate.push(swatchRecord);
			}
		}
		
		// finds out which swatch is entitled, if it is, image should be set to enabled
		// go through entitledItems array and find out swatches that are entitled 
		for (x in this.entitledItems) {
			var Attributes = this.entitledItems[x].Attributes;

			for(y in Attributes){
				var index = y.indexOf("_|_");
				var entitledSwatchName = y.substring(0, index);
				var entitledSwatchValue = y.substring(index+3);	
				
				//the current entitled item has the selected attribute value
				if (entitledSwatchName == selectedAttrName && entitledSwatchValue == selectedAttrValue) {
					//go through the other attributes that are available to the selected attribute
					//exclude the one that is selected
					for (z in Attributes) {
						var index2 = z.indexOf("_|_");
						var entitledSwatchName2 = z.substring(0, index2);
						var entitledSwatchValue2 = z.substring(index2+3);
						
						if(y != z){ //only check the attributes that are not the one selected
							for (i in swatchToUpdate) {
								var swatchToUpdateName = swatchToUpdate[i][0];
								var swatchToUpdateValue = swatchToUpdate[i][1];
								
								if (entitledSwatchName2 == swatchToUpdateName && entitledSwatchValue2 == swatchToUpdateValue) {
									swatchToUpdate[i][5] = true;
								}
							}
						}
					}
				}
			}
		}

		// Now go through swatchToUpdate array, and update swatch images
		var disabledAttributes = [];
		for (i in swatchToUpdate) {
			var swatchToUpdateName = swatchToUpdate[i][0];
			var swatchToUpdateValue = swatchToUpdate[i][1];
			var swatchToUpdateImg1 = swatchToUpdate[i][2];
			var swatchToUpdateImg2 = swatchToUpdate[i][3];
			var swatchToUpdateOnclick = swatchToUpdate[i][4];
			var swatchToUpdateEnabled = swatchToUpdate[i][5];		
			
			if (swatchToUpdateEnabled) {
				document.getElementById("swatch_" + swatchToUpdateValue).style.opacity = 1;
				document.getElementById("swatch_" + swatchToUpdateValue).style.filter = "";
				document.getElementById("swatch_" + swatchToUpdateValue).onclick = swatchToUpdateOnclick;
			} else {
				if(swatchToUpdateName != doNotDisable){
					document.getElementById("swatch_" + swatchToUpdateValue).style.opacity = 0.3;
					document.getElementById("swatch_" + swatchToUpdateValue).style.filter = 'alpha(opacity=30)';
					document.getElementById("swatch_" + swatchToUpdateValue).onclick = null;
					
					//The previously selected attribute is now unavailable for the new selection
					//Need to switch the selection to an available value
					if(this.selectedAttributes[swatchToUpdateName] == swatchToUpdateValue){
						disabledAttributes.push(swatchToUpdate[i]);
					}
				}
			}
		}
		
		//If there were any previously selected attributes that are now unavailable
		//Find another available value for that attribute and update other attributes according to the new selection
		for(i in disabledAttributes){
			var disabledAttributeName = disabledAttributes[i][0];
			var disabledAttributeValue = disabledAttributes[i][1];

			for (i in swatchToUpdate) {
				var swatchToUpdateName = swatchToUpdate[i][0];
				var swatchToUpdateValue = swatchToUpdate[i][1];
				var swatchToUpdateEnabled = swatchToUpdate[i][5];	
				
				if(swatchToUpdateName == disabledAttributeName && swatchToUpdateValue != disabledAttributeValue && swatchToUpdateEnabled){
						document.getElementById("swatch_" + disabledAttributeValue).className = "swatch_normal";
						this.makeSwatchSelection(swatchToUpdateName, swatchToUpdateValue, entitledItemId, doNotDisable);
					break;
				}
			}
		}
	},*/

	/**
	* updateParamObject This function updates the given params object with a key to value pair mapping.
	*				    If the toArray value is true, It creates an Array for duplicate entries otherwise it overwrites the old value.
	*			        This is useful while making a service call which accepts a few parameters of type array.
	*					This function is used to prepare a a map of parameters which can be passed to XMLHttpRequests. 
	* 					The keys in this parameter map will be the name of the parameter to send and the value is the corresponding value for each parameter key.
	* @param {Object} params The parameters object to add name value pairs to.
	* @param {String} key The new key to add.
	* @param {String} value The new value to add to the specified key.
	* @param {Boolean} toArray Set to true to turn duplicate keys into an array, or false to override previous values for a specified key.
	* @param {int} index The index in an array of values for a specified key in which to place a new value.
	*
	* @return {Object} params A parameters object holding name value pairs.
	*
	**/
	updateParamObject:function(params, key, value, toArray, index){
	
	   if(params == null){
		   params = [];
	   }

	   if(params[key] != null && toArray)
	   {
			if($.isArray(params[key]))
			{
				//3rd time onwards
			    if(index != null && index !== "")
				{
					//overwrite the old value at specified index
				     params[key][index] = value;
				}
				else
				{
				    params[key].push(value);
			     }
		    }
			else
			{
			     //2nd time
			     var tmpValue = params[key];
			     params[key] = [];
			     params[key].push(tmpValue);
			     params[key].push(value);
		    }
	   }
	   else
	   {
			//1st time
		   if(index != null && index !== "" && index != -1)
		   {
		      //overwrite the old value at specified index
		      params[key+"_"+index] = value;
		   }
		   else if(index == -1)
		   {
		      var i = 1;
		      while(params[key + "_" + i] != null)
			  {
			       i++;
		      }
		      params[key + "_" + i] = value;
		   }
		   else
		   {
		      params[key] = value;
		    }
	   }
	   return params;
	 },
	 
	 /**
	  *  This function associates the product id with its first entitledItemId.
	  *  @param {String} productId The id of the product.
	  *  @param {String} entitledItemId The id of the first entitledItem of the product.
	  */
	 setDefaultItem : function(productId,entitledItemId){
		this.defaultItemArray[productId] = entitledItemId;
		
},
	/*
     *	This function retrieves the first entitledItemId of the product.
	 *  @param {String} productId The id of the product.
	 *  
	 *  @return {String} The id of the first entitledItem of the product.
	 */
getDefaultItem : function(productId){
		return this.defaultItemArray[productId];
},


	/**
	* AddBundle2ShopCartAjax This function is used to add a bundle to the shopping cart. This is for the ajax flow which will take a form as input and retrieves all the items catentry IDs and adds them to the form.
	*						 
	* @param {form} form The form which contains all the inputs for the bundle.
	*					 The form is expected to have the following values: 
	*						numberOfProducts The number of products in the bundle.
	*						catEntryId_<index> where index is between 1 and numberOfProduct.
	*						quantity_<index> where index is between 1 and numberOfProduct.
	**/
	AddBundle2ShopCartAjax : function(form){
		
		if (browseOnly){
			MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ADD2CART_BROWSE_ONLY_ERROR')); 
			return;
		}
		var params = [];

		params.storeId		= this.storeId;
		params.catalogId	= this.catalogId;
		params.langId		= this.langId;
		params.orderId		= ".";
		// Remove calculations for performance
		// params.calculationUsage = "-1,-2,-5,-6,-7";
		params.calculateOrder="0";
		params.inventoryValidation = "true";
			
		var productCount = form["numberOfProduct"].value;
		for(var i = 1; i <= productCount; i++){
			var catEntryId = form["catEntryId_" + i].value;
			if(this.selectedProducts[catEntryId])
				catEntryId = this.getCatalogEntryIdforProduct(this.selectedProducts[catEntryId]);
			var qty = form["quantity_" + i].value;
			if(qty == null || qty === "" || qty<=0){ MessageHelper.displayErrorMessage(MessageHelper.messages['QUANTITY_INPUT_ERROR']); return;}
			if(qty!=null && qty !== '' && catEntryId!=null){
				this.updateParamObject(params,"catEntryId",catEntryId,false,-1);
				this.updateParamObject(params,"quantity",qty,false,-1);
				this.baseItemAddedToCart=true;
			}
			else{
				MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
				return;
			}
			var contractIdElements = document.getElementsByName('contractSelectForm_contractId_' + catEntryId);
			if (contractIdElements != null && contractIdElements != "undefined") {
				for (j=0; j<contractIdElements.length; j++) {
					if (contractIdElements[j].checked) {
						form["contractId_" + i].value = contractIdElements[j].value;
						break;
					}
				}
			}
			var contractId = form["contractId_" + i].value;
			if (contractId != null && contractId !== '') {
				this.updateParamObject(params,"contractId",contractId,false,-1);
			}
		}
		//For Handling multiple clicks
		if(!submitRequest()){
			return;
		}   		
		cursor_wait();		
		wcService.invoke("AjaxAddOrderItem", params);

	},


	/**
	* AddBundle2ShopCart This function is used to add a bundle to the shopping cart. This is for the non ajax flow which  will take a form as input and submits the form.
	*
	* @param {form} form The form which contains all the inputs for the bundle.
	*					 The form is expected to have the following values:
	*						numberOfProducts The number of products in the bundle.
	*						catEntryId_<index> where index is between 1 and numberOfProduct.
	*						quantity_<index> where index is between 1 and numberOfProduct. 
	*
	**/
	AddBundle2ShopCart : function(form){
		
		if (browseOnly){
			MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ADD2CART_BROWSE_ONLY_ERROR')); 
			return;
		}
		form.URL.value = "AjaxOrderItemDisplayView";
		var productCount = form["numberOfProduct"].value;
		for(var i = 1; i <= productCount; i++){
			var catEntryId = form["catEntryId_" + i].value;
			if(this.selectedProducts[catEntryId]){
				catEntryId = this.getCatalogEntryIdforProduct(this.selectedProducts[catEntryId]);
				if(catEntryId != null)
				form["catEntryId_" + i].value = catEntryId;
				else{
					MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
					return;
				}
			}
			var qty = form["quantity_" + i].value;
			if(qty == null || qty === "" || qty<=0){ MessageHelper.displayErrorMessage(MessageHelper.messages['QUANTITY_INPUT_ERROR']); return;}
			var contractIdElements = document.getElementsByName('contractSelectForm_contractId_' + catEntryId);
			if (contractIdElements != null && contractIdElements != "undefined") {
				for (j=0; j<contractIdElements.length; j++) {
					if (contractIdElements[j].checked) {
						form["contractId_" + i].value = contractIdElements[j].value;
						break;
					}
				}
			}
		}

		//For Handling multiple clicks
		if(!submitRequest()){
			return;
		}
		
		processAndSubmitForm(form);
	},
	
	
	/**
	* Add2ShopCart This function is used to add to a catalog entry to the shopping cart. This will resolve the catentryId using entitledItemId and adds the item to the cart.
	*			   This function will call AddItem2ShopCart after resolving the entitledItemId to a SKU.
	*
	* @param {String} entitledItemId A DIV containing a JSON object which holds information about a catalog entry. You can reference CachedProductOnlyDisplay.jsp to see how that div is constructed.
	* @param {form} form The form which contains all the inputs for the item. The catEntryId and productId values of the form you pass in
	*					 will be set to the catalog entry Id of the SKU resolved from the list of skus whos defining attributes match those in the {@link this.selectedAttributes} array.
	* @param {int} quantity quantity of the item.
	* @param {String} isPopup If the value is true, then this implies that the function was called from a quick info pop-up.				
	*
	**/
	Add2ShopCart : function(entitledItemId,form,quantity,isPopup){
		
		if (browseOnly){
			MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ADD2CART_BROWSE_ONLY_ERROR')); 
			return;
		}
		var entitledItemJSON;

		if ($("#" + entitledItemId).length) {
			//the json object for entitled items are already in the HTML. 
			 entitledItemJSON = eval('('+ $("#" + entitledItemId).html() +')');
		}else{
			//if $("#" + entitledItemId).length is 0, that means there's no <div> in the HTML that contains the JSON object. 
			//in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
			entitledItemJSON = this.getEntitledItemJsonObject(); 
		}
		
		this.setEntitledItems(entitledItemJSON);
		var catalogEntryId = this.getCatalogEntryId();
		if(catalogEntryId!=null){
			if(this.merchandisingProductAssociationAddToCart){
				this.AddAssociation2ShopCart(catalogEntryId,quantity);
				return;
			}
			form.catEntryId.value = catalogEntryId;
			form.productId.value = catalogEntryId;
			this.AddItem2ShopCart(form,quantity);
			hidePopup('second_level_category_popup');
		} else if (isPopup == true){
			$('#second_level_category_popup').css('zIndex', '1');
			MessageHelper.formErrorHandleClient('addToCartLink', MessageHelper.messages['ERR_RESOLVING_SKU']);		
		} else{
			MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
		}

	},
	
	
	
	/**
	* AddItem2ShopCart This function is used to add a SKU to the shopping cart.
	*
	* @param {form} form The form which contains all the inputs for the item.
    * 					The form must have the following values:
    *						quantity The quantity of the item that you want to add to the cart.
	* @param {int} quantity The quantity of the item to add to the shopping cart.
	*
	**/
	AddItem2ShopCart : function(form,quantity){
		if (browseOnly){
			MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ADD2CART_BROWSE_ONLY_ERROR')); 
			return;
		}
		if(!isPositiveInteger(quantity)){
			MessageHelper.displayErrorMessage(MessageHelper.messages['QUANTITY_INPUT_ERROR']);
			return;
		}
		
		form.quantity.value = quantity;
		
		var contractIdElements = document.getElementsByName('contractSelectForm_contractId');
		if (contractIdElements != null && contractIdElements != "undefined") {
			for (i=0; i<contractIdElements.length; i++) {
				if (contractIdElements[i].checked) {
					form.contractId.value = contractIdElements[i].value;
					break;
				}
			}
		}
		//For Handling multiple clicks
		if(!submitRequest()){
			return;
		}
		processAndSubmitForm(form);
	},


	/**
	* Add2ShopCartAjax This function is used to add a catalog entry to the shopping cart using an AJAX call. This will resolve the catentryId using entitledItemId and adds the item to the cart.
	*				This function will resolve the SKU based on the entitledItemId passed in and call {@link this.AddItem2ShopCartAjax}.
	* @param {String} entitledItemId A DIV containing a JSON object which holds information about a catalog entry. You can reference CachedProductOnlyDisplay.jsp to see how that div is constructed.
	* @param {int} quantity The quantity of the item to add to the cart.
	* @param {String} isPopup If the value is true, then this implies that the function was called from a quick info pop-up. 	
	* @param {Object} customParams - Any additional parameters that needs to be passed during service invocation.
	*
	**/
	Add2ShopCartAjax : function(entitledItemId,quantity,isPopup,customParams){	
		if (browseOnly){
			MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ADD2CART_BROWSE_ONLY_ERROR')); 
			return;
		}
		var entitledItemJSON;

		if ($("#" + entitledItemId).length) {
			//the json object for entitled items are already in the HTML. 
			 entitledItemJSON = eval('('+ $("#" + entitledItemId).html() +')');
		}else{
			//if $("#" + entitledItemId).length is 0, that means there's no <div> in the HTML that contains the JSON object. 
			//in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
			entitledItemJSON = this.getEntitledItemJsonObject(); 
		}
		
		this.setEntitledItems(entitledItemJSON);
		var catalogEntryId = this.getCatalogEntryId();
		if(catalogEntryId!=null){
			this.AddItem2ShopCartAjax(catalogEntryId , quantity,customParams);
			this.baseItemAddedToCart=true;
			hidePopup('second_level_category_popup');
		}
		else if (isPopup == true){
			$('#second_level_category_popup').css('zIndex', '1');
			MessageHelper.formErrorHandleClient('addToCartLinkAjax', MessageHelper.messages['ERR_RESOLVING_SKU']);			
		} else{
			MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
			this.baseItemAddedToCart=false;
		}
	},
    
	/**
	 * sets the entitledItemJsonObject
	 * @param (object) jsonObject the entitled item JSON objects
	 */
    setEntitledItemJsonObject: function(jsonObject) {
        this.entitledItemJsonObject = jsonObject;
    },
    
    /**
     * retrieves the entitledItemJsonObject
     */
    getEntitledItemJsonObject: function () {
    	return this.entitledItemJsonObject;
    },

	/**
	* ReplaceItemAjax This function is used to replace an item in the shopping cart when the AJAX Checkout flow is enabled. This will be called from the shopping cart and checkout pages.
	*
	* @param {String} entitledItemId A DIV containing a JSON object which holds information about a catalog entry. You can reference CachedProductOnlyDisplay.jsp to see how that div is constructed.
	* @param {int} quantity The quantity of the item to add to the shopping cart.
	*
	**/
	ReplaceItemAjax : function(entitledItemId,quantity){
	
		var entitledItemJSON;

		if ($("#" + entitledItemId).length) {
			//the json object for entitled items are already in the HTML. 
			 entitledItemJSON = eval('('+ $("#" + entitledItemId).html() +')');
		}else{
			//if $("#" + entitledItemId).length is 0, that means there's no <div> in the HTML that contains the JSON object. 
			//in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
			entitledItemJSON = this.getEntitledItemJsonObject(); 
		}
		this.setEntitledItems(entitledItemJSON);
		var catalogEntryId = this.getCatalogEntryId();
		var removeOrderItemId = "";
		//if(entitledItemJSON[0] != null){
		//	removeOrderItemId = entitledItemJSON[0].orderItemId_remove;
		//}
		var removeOrderItemId = replaceOrderItemId;
		var typeId = document.getElementById("shipmentTypeId");
		var addressId = "";
		var shipModeId = "";
		if(typeId != null && typeId !== ""){
			if(typeId.value == "2"){
				//Multiple shipment..each orderItem will have its own addressId and shipModeId..
				addressId = document.getElementById("MS_ShipmentAddress_"+removeOrderItemId).value;
				shipModeId = document.getElementById("MS_ShippingMode_"+removeOrderItemId).value;
			}
			else {
				//Single Shipment..get the common addressId and shipModeId..
				addressId = $("#addressId_all").val();;
				shipModeId = $("#shipModeId_all").val();
			}
		}
		if(catalogEntryId!=null){
			if(removeOrderItemId !== ""){
				//Remove existing catEntryId and then add new one...
				this.ReplaceItemAjaxHelper(catalogEntryId,quantity,removeOrderItemId,addressId,shipModeId);
			}
		}else{
				MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
		}
	},

	/**
	* ReplaceItemNonAjax This function is used to replace an item in the shopping cart when the Non Ajax checkout flow is enabled. This will be called from shopcart and checkout pages.
	* 
	* @param {String} entitledItemId A DIV containing a JSON object which holds information about a catalog entry. You can reference CachedProductOnlyDisplay.jsp to see how that div is constructed.
	* @param {int} quantity The quantity of the item to replace in the shopping cart.
	* @param {form} form The form which contains all the inputs for the item.
	*
	**/ 
	ReplaceItemNonAjax : function(entitledItemId,quantity,form){
	
		var entitledItemJSON;

		if ($("#" + entitledItemId).length) {
			//the json object for entitled items are already in the HTML. 
			 entitledItemJSON = eval('('+ $("#" + entitledItemId).html() +')');
		}else{
			//if $("#" + entitledItemId).length is 0, that means there's no <div> in the HTML that contains the JSON object. 
			//in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
			entitledItemJSON = this.getEntitledItemJsonObject(); 
		}
		this.setEntitledItems(entitledItemJSON);
		var catalogEntryId = this.getCatalogEntryId();
		var removeOrderItemId = "";
		//if(entitledItemJSON[0] != null){
		//	removeOrderItemId = entitledItemJSON[0].orderItemId_remove;
		//}
		var removeOrderItemId = replaceOrderItemId;
		if(catalogEntryId!=null){
			if(removeOrderItemId === ""){
				//Prepare form to just add this item.. This code will never be executed...
				//Needed only when we plan to show add to cart link also in the quick info..
				//form.action = "orderChangeServiceItemAdd";
				//form.submit();
			}
			else{
				//Else remove existing catEntryId and then add new one...
				form.orderItemId.value = removeOrderItemId;
				var addressId, shipModeId;
				if(quantity == 0){
					console.debug("An invalid quantity was selected");

				}
				if(form.shipmentTypeId != null && form.shipmenTypeId !== ""){
					if(form.shipmentTypeId.value == "2"){
						//Multiple shipment..each orderItem will have its own addressId and shipModeId..
						addressId = document.getElementById("MS_ShipmentAddress_"+removeOrderItemId).value;;
						shipModeId = document.getElementById("MS_ShippingMode_"+removeOrderItemId).value;;
					}
					else {
						//Single Shipment..get the common addressId and shipModeId..
						addressId = $("#addressId_all").val();;
						shipModeId = $("#shipModeId_all").val();
					}
					form.URL.value = "RESTOrderItemAdd?calculationUsage=-1,-2,-3,-4,-5,-6,-7&catEntryId="+catalogEntryId+"&quantity="+quantity+"&addressId="+addressId+"&shipModeId="+shipModeId+"&URL=RESTOrderShipInfoUpdate?URL="+form.URL.value;
			    }
				else{
					form.URL.value = "RESTOrderItemAdd?calculationUsage=-1,-2,-3,-4,-5,-6,-7&catEntryId="+catalogEntryId+"&quantity="+quantity+"&URL="+form.URL.value;
				}

				//For Handling multiple clicks
				if(!submitRequest()){
					return;
				}
				processAndSubmitForm(form);
			}
		}
		else{
			MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
		}
	},

	/**
	* AddItem2ShopCartAjax This function is used to add a single or multiple items to the shopping cart using an ajax call.
							If an array is passed for catEntryIdentifier and quantity parramters, then multiple items can be added.	In this case, catEntryIdentifier[i] corresponds to quantity[i]
							Else, catEntryIdentifier  and quantity parramters represent a single catalog entry.
	*
	* @param {Array|String} catEntryIdentifier An array of catalog entry identifiers or a single catalog entry ID of the item to add to the cart.
	* @param {Array|int} quantity An array of quantities corresponding to the catEntryIdentifier array or a single quantity of the item to add to the cart.
	* @param {Object} customParams - Any additional parameters that needs to be passed during service invocation.
	*
	**/
	AddItem2ShopCartAjax : function(catEntryIdentifier, quantity, customParams) {
		if (browseOnly){
			MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ADD2CART_BROWSE_ONLY_ERROR')); 
			return;
		}
		var params = {
			storeId: this.storeId,
			catalogId: this.catalogId,
			langId: this.langId,
			orderId: "."
		};
		// Remove calculations for performance
		// params.calculationUsage = "-1,-2,-5,-6,-7";
		params.calculateOrder="0";
		params.inventoryValidation = "true";
		var ajaxShopCartService = "AjaxAddOrderItem";
		var nonAjaxShopCartService = "AjaxAddOrderItem_shopCart";
		
		if($.isArray(catEntryIdentifier) && $.isArray(quantity)){
			for(var i=0; i<catEntryIdentifier.length; i++){
				if(!isPositiveInteger(quantity[i])){
					MessageHelper.displayErrorMessage(MessageHelper.messages['QUANTITY_INPUT_ERROR']);
					return;
				}
				params["catEntryId_" + (i+1)] = catEntryIdentifier[i];
				params["quantity_" + (i+1)]	= quantity[i];
			}
		}
		else{
			if(!isPositiveInteger(quantity)){
				MessageHelper.displayErrorMessage(MessageHelper.messages['QUANTITY_INPUT_ERROR']);
				return;
			}
			params.catEntryId	= catEntryIdentifier;
			params.quantity		= quantity;
		}		

		//Pass any other customParams set by other add on features
		if(customParams != null && customParams != 'undefined'){
			for(i in customParams){
				params[i] = customParams[i];
			}
			if(customParams['catalogEntryType'] == 'dynamicKit' ){
				ajaxShopCartService = "AjaxAddPreConfigurationToCart";
				nonAjaxShopCartService = "AjaxAddPreConfigurationToCart_shopCart";
			}
		}

		var contractIdElements = document.getElementsByName('contractSelectForm_contractId');
		if (contractIdElements != null && contractIdElements != "undefined") {
			for (i=0; i<contractIdElements.length; i++) {
				if (contractIdElements[i].checked) {
					params.contractId = contractIdElements[i].value;
					break;
				}
			}
		}
		
		//For Handling multiple clicks
		if(!submitRequest()){
			return;
		}   
		cursor_wait();
		wcService.invoke(ajaxShopCartService, params);
		this.baseItemAddedToCart=true;

		if(document.getElementById("headerShopCartLink")&&document.getElementById("headerShopCartLink").style.display != "none")
		{
			$("#headerShopCart").focus();
		}
		else
		{
			$("#headerShopCart1").focus();
		}
	},
	
	/**
	* ConfigureDynamicKit This function is used to call the configurator page for a dynamic kit.
	* @param {String} catEntryIdentifier A catalog entry ID of the item to add to the cart.
	* @param {int} quantity A quantity of the item to add to the cart.
	* @param {Object} customParams - Any additional parameters that needs to be passed to the configurator page.
	*
	**/
	ConfigureDynamicKit : function(catEntryIdentifier, quantity, customParams)
	{
		var params = {storeId: this.storeId,
catalogId: this.catalogId,
langId: this.langId,
catEntryId: catEntryIdentifier,
quantity: quantity};
		
		if(!isPositiveInteger(quantity)){
			MessageHelper.displayErrorMessage(MessageHelper.messages['QUANTITY_INPUT_ERROR']);
			return;
		}

		var contractIdElements = document.getElementsByName('contractSelectForm_contractId');
		if (contractIdElements != null && contractIdElements != "undefined") {
			for (i=0; i<contractIdElements.length; i++) {
				if (contractIdElements[i].checked) {
					params.contractId = contractIdElements[i].value;
					break;
				}
			}
		}
		
		//Pass any other customParams set by other add on features
		if(customParams != null && customParams != 'undefined'){
			for(i in customParams){
				params[i] = customParams[i];
			}
		}

		//For Handling multiple clicks
		if(!submitRequest()){
			return;
		}   
		cursor_wait();
		
		var configureURL = "ConfigureView";
		var i =0;
		for(param in params){
			configureURL += ((i++ == 0)? "?" : "&") + param + "=" + params[param];
		}
		document.location.href = getAbsoluteURL() + appendWcCommonRequestParameters(configureURL);
	},
	
	/**
	* ReplaceItemAjaxHelper This function is used to replace an item in the cart. This will be called from the {@link this.ReplaceItemAjax} method.
	*
	* @param {String} catalogEntryId The catalog entry of the item to replace to the cart.
	* @param {int} qty The quantity of the item to add.
	* @param {String} removeOrderItemId The order item ID of the catalog entry to remove from the cart.
	* @param {String} addressId The address ID of the order item.
	* @param {String} shipModeId The shipModeId of the order item.
	*
	**/
	ReplaceItemAjaxHelper : function(catalogEntryId,qty,removeOrderItemId,addressId,shipModeId){
		
		var params = {
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            orderItemId: removeOrderItemId,
            orderId: (this.orderId != null && this.orderId != 'undefined' && this.orderId !== '') ?this.orderId:"."
        };
		if(CheckoutHelperJS.shoppingCartPage){	
			params.calculationUsage = "-1,-2,-5,-6,-7";
		}else{
			params.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
		}

		var params2 = {
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            catEntryId: catalogEntryId,
            quantity: qty,
            orderId: (this.orderId != null && this.orderId != 'undefined' && this.orderId !== '')?this.orderId:"."
        };
		if(CheckoutHelperJS.shoppingCartPage){	
			params2.calculationUsage = "-1,-2,-5,-6,-7";
		}else{
			params2.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
		}

		var params3 = {
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            orderId: (this.orderId != null && this.orderId != 'undefined' && this.orderId !== '')?this.orderId:"."
        };
		if(CheckoutHelperJS.shoppingCartPage){	
			params3.calculationUsage = "-1,-2,-5,-6,-7";
		}else{
			params3.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
		}
		params3.allocate="***";
		params3.backorder="***";
		params3.remerge="***";
		params3.check="*n";
		
		var shipInfoUpdateNeeded = false;
		if(addressId != null && addressId !== "" && shipModeId != null && shipModeId !== ""){
			params3.addressId = addressId;
			params3.shipModeId = shipModeId;
			shipInfoUpdateNeeded = true;
		}

		//Delcare service for deleting item...
		wcService.declare({
			id: "AjaxReplaceItem",
			actionId: "AjaxReplaceItem",
			url: "AjaxRESTOrderItemDelete",
			formId: ""

			,successHandler: function(serviceResponse) {
				//Now add the new item to cart..
				if(!shipInfoUpdateNeeded){
					//We dont plan to update addressId and shipMOdeId..so call AjaxAddOrderItem..
					wcService.invoke("AjaxAddOrderItem", params2);
				}
				else{
					//We need to update the adderessId and shipModeId..so call our temp service to add..
					wcService.invoke("AjaxAddOrderItemTemp", params2);
				}
			}

			,failureHandler: function(serviceResponse) {
				if (serviceResponse.errorMessage) {
							 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
					  } else {
							 if (serviceResponse.errorMessageKey) {
									MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
							 }
					  }
					  cursor_clear();
			}

		});

		//Delcare service for adding item..
		wcService.declare({
			id: "AjaxAddOrderItemTemp",
			actionId: "AjaxAddOrderItemTemp",
			url: "AjaxRESTOrderItemAdd",
			formId: ""

			,successHandler: function(serviceResponse) {
				//Now item is added.. call update to set addressId and shipModeId...
				wcService.invoke("OrderItemAddressShipMethodUpdate", params3);
			}

			,failureHandler: function(serviceResponse) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			}
		});

		//For Handling multiple clicks
		if(!submitRequest()){
			return;
		}   
		cursor_wait();
		wcService.invoke("AjaxReplaceItem",params);
	},
		
	/**
	* AddBundle2WishList This function is used to add a bundle to the wish list and it can be called by the product/bundle/package details pages.
	*
	* @param {form} form The form which contains all the inputs for the bundle.
	*
	**/	
	AddBundle2WishList : function(form){
		if (!isAuthenticated) { 
			setWarningMessageCookie('WISHLIST_GUEST_ADDITEM');
		}
		var productCount = form["numberOfProduct"].value; 
		for(var i = 1; i <= productCount; i++){
			var catEntryId = form["catEntryId_" + i].value;
			if(this.selectedProducts[catEntryId]){
				catEntryId = this.getCatalogEntryIdforProduct(this.selectedProducts[catEntryId]);
				if(catEntryId != null)
				form["catEntryId_" + i].value = catEntryId;
				else{
					MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
					return;
				}
			}
		}
		form.action="InterestItemAdd";
		form.page.value="customerlinkwishlist";

		if(this.userType=='G'){
			form.URL.value='InterestItemDisplay';
		}else {
			form.URL.value='AjaxLogonForm';
		}
			
		//For Handling multiple clicks
		if(!submitRequest()){
			return;
		}
		
		processAndSubmitForm(form);
	},
	
	/**
	* AddBundle2WishListAjax This fuction is used to add a bundle to the wish list using the ajax flow and it is called by the product/bundle/package details pages.
	*
	* @param {form} form The form which contains all the inputs for the bundle.
	*
	**/
	AddBundle2WishListAjax : function(form){
		if (!isAuthenticated) { 
			setWarningMessageCookie('WISHLIST_GUEST_ADDITEM');
		}
		var params = [];

		params.storeId		= this.storeId;
		params.catalogId	= this.catalogId;
		params.langId		= this.langId;
		params.updateable	= 0;
		params.orderId		= ".";
			
		var catEntryArray = [];
		catEntryArray = form.catEntryIDS.value.toString().split(",");
		
		for(var i = 0; i < catEntryArray.length; i++){
			var qty = document.getElementById("quantity_" + catEntryArray[i]).value;
			var catEntryId = catEntryArray[i];
			if(this.selectedProducts[catEntryArray[i]])
				catEntryId = this.getCatalogEntryIdforProduct(this.selectedProducts[catEntryArray[i]]);
			if(qty==0 || qty == null) qty = 1;
			if(qty!=null && qty !== '' && catEntryId!=null){
				this.updateParamObject(params,"catEntryId",catEntryId,false,-1);
				this.updateParamObject(params,"quantity",qty,false,-1);
			}
			else{
				MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
				return;
			}
		}
		//For Handling multiple clicks
		if(!submitRequest()){
			return;
		}   		
		cursor_wait();		
		wcService.invoke("AjaxInterestItemAdd", params);

	},
	
	/**
	* Add2WishListAjaxByID. This function is used to add a catalog entry to the wish list using ajax by passing in a catalog entry ID.
	*
	* @param {int} catalogEntryId The catalog entry ID of the catalog entry.
	*
	**/
	Add2WishListAjaxByID:function(catalogEntryId)
	{
		if(catalogEntryId!=null){
			if (!isAuthenticated) { 
				setWarningMessageCookie('WISHLIST_GUEST_ADDITEM');
			}
			var params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                catEntryId: catalogEntryId,
                updateable: 0,
                URL: "SuccessfulAJAXRequest"
            };
			if($("#controllerURLWishlist").length)
                $("#WishlistDisplay_Widget").refreshWidget("updateUrl", $("#controllerURLWishlist").val());

			//For Handling multiple clicks
			if(!submitRequest()){
				return;
			}   
			cursor_wait();
			wcService.invoke("AjaxInterestItemAdd", params);
		}
		else MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
	},
	
	/**
	* Add2WishListAjax This function is used to add an item to the wishlist using ajax by passing in the id of an HTML element containing a JSON object representing a catalog entry.
	*				   This fuction is called by product/bundle/package detail pages.
	* 
	* @param {HTMLDivElement} entitledItemId A DIV containing a JSON object which holds information about a catalog entry. You can reference CachedProductOnlyDisplay.jsp to see how that div is constructed.
	*
	**/
	Add2WishListAjax:function(entitledItemId)
	{
		if (!isAuthenticated) { 
			setWarningMessageCookie('WISHLIST_GUEST_ADDITEM');
		}
		var entitledItemJSON;

		if ($("#" + entitledItemId).length) {
			//the json object for entitled items are already in the HTML. 
			 entitledItemJSON = eval('('+ $("#" + entitledItemId).html() +')');
		}else{
			//if $("#" + entitledItemId).length is 0, that means there's no <div> in the HTML that contains the JSON object. 
			//in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
			entitledItemJSON = this.getEntitledItemJsonObject(); 
		}
		this.setEntitledItems(entitledItemJSON);
		
		
		
		var catalogEntryId = this.getCatalogEntryId();
		
		this.Add2WishListAjaxByID(catalogEntryId);
		
	},
	
	/**
	* AddItem2WishListAjax. This function is used to add an item to the wishlist using AJAX by passing in its catentryId. 
	* 						This function can be called by item detail page.
	*
	* @param {String} itemId The catalog entry ID of the catalog entry to add to the wish list.
	*
	**/
	AddItem2WishListAjax:function(itemId)
	{
		if (!isAuthenticated) { 
			setWarningMessageCookie('WISHLIST_GUEST_ADDITEM');
		}
		var params = {
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            catEntryId: itemId,
            updateable: 0,
            URL: "SuccessfulAJAXRequest"
        };
		if ($("#controllerURLWishlist").length)
            $("#WishlistDisplay_Widget").refreshWidget("updateUrl", $("#controllerURLWishlist").val());

		//For Handling multiple clicks
		if(!submitRequest()){
			return;
		}   		
		cursor_wait();
		wcService.invoke("AjaxInterestItemAdd", params);
	},

	/**
	* Add2WishList This function is used to add a catalog entry to the wish list using the non ajax flow by passing in the ID of an HTML element containing a JSON which represents a catalog entry 
	*			   This fuction is called by the product/bundle/package detail pages.
	*
	* @param {String} entitledItemId A DIV containing a JSON object which holds information about a catalog entry. You can reference CachedProductOnlyDisplay.jsp to see how that div is constructed.
	* @param {form} form form to submit the request.
	*
	**/
	Add2WishList:function(entitledItemId,form)
	{
		if (!isAuthenticated) { 
			setWarningMessageCookie('WISHLIST_GUEST_ADDITEM');
		}
		var entitledItemJSON;

		if ($("#" + entitledItemId).length) {
			//the json object for entitled items are already in the HTML. 
			 entitledItemJSON = eval('('+ $("#" + entitledItemId).html() +')');
		}else{
			//if $("#" + entitledItemId).length is 0, that means there's no <div> in the HTML that contains the JSON object. 
			//in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
			entitledItemJSON = this.getEntitledItemJsonObject(); 
		}
		this.setEntitledItems(entitledItemJSON);
		var catalogEntryId = this.getCatalogEntryId();
		this.Add2WishListByID(catalogEntryId,form);
	},


	/**
	* Add2WishListByID Add a catalog entry to the wish list using the non-AJAX flow. This fuction is called by the product/bundle/package detail pages.
	*
	* @param {String} catalogEntryId The catalog entry ID of the catalog entry to be added.
	* @param {form} form  form to submit the request.
	*
	**/
	Add2WishListByID:function(catalogEntryId,form)
	{
		if (!isAuthenticated) { 
			setWarningMessageCookie('WISHLIST_GUEST_ADDITEM');
		}
		if(catalogEntryId!=null){
			form.productId.value = catalogEntryId;
			form.catEntryId.value = catalogEntryId;
			form.action="InterestItemAdd";
			form.page.value="customerlinkwishlist";

			if(this.userType=='G'){
				form.URL.value='InterestItemDisplay';
			}else {
				form.URL.value='AjaxLogonForm';
			}

			form.quantity.value = "1";

			//For Handling multiple clicks
			if(!submitRequest()){
				return;
			}
			
			processAndSubmitForm(form);
		}
		else MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
	},
	
	
	/** 
	* AddItem2WishList Add a SKU to the wish list using the non-AJAX flow. This function is called by the item detail page.
	*
	* @param {form} form The form to submit the request.
	*
	**/
	AddItem2WishList:function(form)
	{
		if (!isAuthenticated) { 
			setWarningMessageCookie('WISHLIST_GUEST_ADDITEM');
		}
		form.action="InterestItemAdd";
		form.quantity.value = "1";
		form.page.value="customerlinkwishlist";

		if(this.userType=='G'){
			form.URL.value='InterestItemDisplay';
		}else {
			form.URL.value='AjaxLogonForm';
		}

		//For Handling multiple clicks
		if(!submitRequest()){
			return;
		}
			
		processAndSubmitForm(form);
	},
	
	/**
	* initializeMerchandisingAssociation Since the merchandising associations are only displayed one at a time with a scrolling widget this method
	*									 will initialize that widget with a specified starting index represented by thumbnailIndex so that the correct 
	*									 merchandising association is displayed first.
	*									 This function is called on MerchandisingAssociationsDisplay.jsp.s
	* 
	* @param {String} thumbnailIndex The index of the association that needs to be displayed.
	*
	**/
	initializeMerchandisingAssociation:function(thumbnailIndex){
	
	var associationDisplay = document.getElementById("marchandisingAssociationDisplay");
	var totalPriceMsg = $("#totalPriceMsg").val();
	var baseCatEntryJSON = eval('('+ $("#baseCatEntryDetails").html() +')');
	this.baseCatalogEntryDetails = baseCatEntryJSON;
	var basePrice=this.baseCatalogEntryDetails[0].baseCatEntry_Price;
	this.totalAssociationCount= this.baseCatalogEntryDetails[0].totalAssociations;
	var identifierJSON = "associatedCatEntries_"+thumbnailIndex;
	var associationEntryJSON = eval('('+ $("#" + identifierJSON).html() +')');
	this.merchandisingAssociationItems = associationEntryJSON;
	var totalPrice = parseFloat(basePrice)+ parseFloat(this.merchandisingAssociationItems[0].catEntry_Price);
	var dragType = "";
		
	if(this.merchandisingAssociationItems[0].catEntry_Type =='ProductBean'){
		dragType = "product";
	}else if (this.merchandisingAssociationItems[0].catEntry_Type =='ItemBean'){
		dragType = "item";
	}else if (this.merchandisingAssociationItems[0].catEntry_Type =='PackageBean'){
		dragType = "package";
	}else if (this.merchandisingAssociationItems[0].catEntry_Type =='BundleBean'){
		dragType = "bundle";
	}
//Creates the inner HTML of the associated item determined by the thumbnailIndex which needs to be displayed in the page.
var widgetHTML = "";
if ($("#addToCartLink").length){
var url = "AjaxOrderItemDisplayView?storeId="+this.storeId+"&catalogId="+this.catalogId+"&langId="+this.langId;
						widgetHTML = widgetHTML
						+"<form name='OrderItemAddForm_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"' action='RESTOrderItemAdd' method='post' id='OrderItemAddForm_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'>\n"
						+"<input type='hidden' name='storeId' value='"+this.storeId+"' id='OrderItemAddForm_storeId_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"<input type='hidden' name='orderId' value='.' id='OrderItemAddForm_orderId_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"<input type='hidden' name='catalogId' value='"+this.catalogId+"' id='OrderItemAddForm_orderId_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"<input type='hidden' name='URL' value='"+ url + "' id='OrderItemAddForm_url_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"<input type='hidden' name='errorViewName' value='InvalidInputErrorView' id='OrderItemAddForm_errorViewName_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"<input type='hidden' name='catEntryId' value='"+this.merchandisingAssociationItems[0].catEntry_Identifier+"' id='OrderItemAddForm_catEntryId_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"<input type='hidden' name='productId' value='"+this.merchandisingAssociationItems[0].catEntry_Identifier+"' id='OrderItemAddForm_productId_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"<input type='hidden' value='1' name='quantity' id='OrderItemAddForm_quantity_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"<input type='hidden' value='' name='page' id='OrderItemAddForm_page_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"<input type='hidden' value='-1,-2,-3,-4,-5,-6,-7' name='calculationUsage' id='OrderItemAddForm_calcUsage_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"<input type='hidden' value='0' name='updateable' id='OrderItemAddForm_updateable_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"<input type='hidden' value='' name='giftListId' id='OrderItemAddForm_giftListId_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'/>\n"
						+"</form>\n";
						}
widgetHTML = widgetHTML					
			+"<div class='scroller' id='WC_CategoryDisplayJS_div_1'>";
			if(this.totalAssociationCount > 1){
				if(this.associationThumbnailIndex < this.totalAssociationCount){
					widgetHTML = widgetHTML
					+"		<a href='Javascript:categoryDisplayJS.showNextAssociation()'  id='WC_ProductAssociation_UpArrow_Link_1'>";
				}
				widgetHTML = widgetHTML
				+"		<img src='"+this.baseCatalogEntryDetails[0].storeImage_Path+"i_up_arrow.png' alt='"+this.displayNextAssociation+"'/></a>";
			}
			widgetHTML = widgetHTML +" <br />"
			+"<div id='baseContent_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"'";
			if(this.merchandisingAssociationItems[0].showProductQuickView == 'true'){
				widgetHTML = widgetHTML
				+" onmouseover='showPopupButton("+this.merchandisingAssociationItems[0].catEntry_Identifier+");' onmouseout='hidePopupButton("+this.merchandisingAssociationItems[0].catEntry_Identifier+");'>";
			}else{
				widgetHTML = widgetHTML
				+" >";
			}
			widgetHTML = widgetHTML
			+"	<a href='"+this.merchandisingAssociationItems[0].catEntry_ProductLink+"'  id='img"+this.merchandisingAssociationItems[0].catEntry_Identifier+"' onfocus='showPopupButton("+this.merchandisingAssociationItems[0].catEntry_Identifier+");'>";
			widgetHTML = widgetHTML
			+"		<img src='"+this.merchandisingAssociationItems[0].catEntry_Thumbnail+"' alt='"+this.merchandisingAssociationItems[0].catEntry_ShortDescription+"' class='img' width='70' height='70'/>"
			+"	</a><br />";
			if(this.merchandisingAssociationItems[0].showProductQuickView == 'true'){
				widgetHTML = widgetHTML
				+" <div id='popupButton_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"' class='main_quickinfo_button'>"
					+"<span class='secondary_button' >\n"
						+"<span class='button_container' >\n"
							+"<span class='button_bg' >\n"
								+"<span class='button_top'>\n"
									+"<span class='button_bottom'>\n"
										+"<a id='QuickInfoButton_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"' href='#' onclick='javaScript:var actionListImageAcct = new popupActionProperties(); actionListImageAcct.showWishList="+this.merchandisingAssociationItems[0].associationProductBuyable+"; actionListImageAcct.showAddToCart="+this.merchandisingAssociationItems[0].associationProductBuyable+"; showPopup("+this.merchandisingAssociationItems[0].catEntry_Identifier+",event,null,null,actionListImageAcct);' onkeypress='javaScript:var actionListImageAcct = new popupActionProperties(); actionListImageAcct.showWishList="+this.merchandisingAssociationItems[0].associationProductBuyable+"; actionListImageAcct.showAddToCart="+this.merchandisingAssociationItems[0].associationProductBuyable+"; showPopup("+this.merchandisingAssociationItems[0].catEntry_Identifier+",event,null,null,actionListImageAcct);' onblur='hidePopupButton("+this.merchandisingAssociationItems[0].catEntry_Identifier+");' role='wairole:button' waistate:haspopup='true'>"+this.merchandisingAssociationItems[0].showProductQuickViewLable+"</a></span>\n"
								+"</span>\n"
							+"</span>\n"
						+"</span>\n"
					+"</span>\n"										
				+"</div>\n";
			}
			widgetHTML = widgetHTML
			+"</div>";	
		
			if(this.totalAssociationCount > 1){
				if(this.associationThumbnailIndex > 1 ){
					widgetHTML = widgetHTML
					+"		<a href='Javascript:categoryDisplayJS.showPreviousAssociation()'  id='WC_ProductAssociation_DownArrow_Link_1'>";
				}
				widgetHTML = widgetHTML
				+"		<img src='"+this.baseCatalogEntryDetails[0].storeImage_Path+"i_down_arrow.png' alt='"+this.displayPrevAssociation+"'/></a>";
			}
			
			var comboText = this.baseCatalogEntryDetails[0].associatedProductsName.replace(/%0/, this.baseCatalogEntryDetails[0].baseCatEntry_Name);
			comboText = comboText.replace(/%1/, this.merchandisingAssociationItems[0].catEntry_Name);
			
			widgetHTML = widgetHTML
			+"</div>"
			+"<div class='combo_text' id='WC_CategoryDisplayJS_div_2'>\n"
			+"	<h1 id='maHeader' class='status_msg'>"+ comboText +"</h1>\n"
			+"	<span id='maPrice' class='grey'>"+totalPriceMsg+Utils.formatCurrency(totalPrice.toFixed(2), {currency: this.baseCatalogEntryDetails[0].currency})+"</span>\n"+"</div>\n";
			widgetHTML = widgetHTML
			+"<input type='hidden' id='compareImgPath_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"' value='"+this.merchandisingAssociationItems[0].catEntry_Thumbnail_compare+"'/>"
			+"<input type='hidden' id='compareProductDetailsPath_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"' value='"+this.merchandisingAssociationItems[0].catEntry_ProductLink+"'/>"
			+"<input type='hidden' id='compareImgDescription_"+this.merchandisingAssociationItems[0].catEntry_Identifier+"' value='"+this.merchandisingAssociationItems[0].catEntry_ShortDescription+"'/>";
			associationDisplay.innerHTML=null;
			associationDisplay.innerHTML=widgetHTML;
            WCWidgetParser.parse(associationDisplay);
            WCWidgetParser.parseRefreshArea(associationDisplay);
},


	/**
	* showNextAssociation Displays the next association in the association array. No action is performed if it is already at the last item.
	*				      This function is used with the merchandising association widget on the MerchandisingAssociationDisplay.jsp to display the next
	*					  association available.
	**/
	showNextAssociation : function(){
		
		if(this.associationThumbnailIndex < this.totalAssociationCount){
			this.associationThumbnailIndex = this.associationThumbnailIndex+1;
			this.initializeMerchandisingAssociation(this.associationThumbnailIndex);
		}
	},

	/**
	* showPreviousAssociation Displays the previous association in the association array. No action is performed if it is already the first item.
	*				      This function is used with the merchandising association widget on the MerchandisingAssociationDisplay.jsp to display the previous
	*					  association available.
	**/
	showPreviousAssociation : function(){
		
	if(this.associationThumbnailIndex > 1 ){
			this.associationThumbnailIndex = this.associationThumbnailIndex-1;
			this.initializeMerchandisingAssociation(this.associationThumbnailIndex);
		}
	},

	/**
	* AddAssociation2ShopCartAjax Adds the associated product to the shopping cart.
	*
	* @param {String} baseProductId The catalog entry ID of the parent product.
	* @param {int} baseProductQuantity The quantity of the parent product to add.
	*
	**/
	AddAssociation2ShopCartAjax:function(baseProductId,baseProductQuantity){
	
		if (browseOnly){
			MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ADD2CART_BROWSE_ONLY_ERROR')); 
			return;
		}
		var identifierJSON = "associatedCatEntries_"+this.associationThumbnailIndex;
		//Get the associated item from the JSON object.
		var associationEntryJSON = eval('('+ $("#" + identifierJSON).html() +')');
		this.merchandisingAssociationItems = associationEntryJSON;
		this.baseItemAddedToCart = false;
		//Add the parent product to the cart.
		if(this.merchandisingAssociationItems[0].catEntry_Type=='ProductBean'){
			this.Add2ShopCartAjax(baseProductId,baseProductQuantity);
			if(this.baseItemAddedToCart){
				//Show the pop-up to select the attributes of the associated product.
				showPopup(this.merchandisingAssociationItems[0].catEntry_Identifier,function(e){return e;},'marchandisingAssociationDisplay');
			}
		}else if (["ItemBean", "PackageBean", "BundleBean"].indexOf(this.merchandisingAssociationItems[0].catEntry_Type) > -1){
			//Get the associated item from the JSON object.
			var entitledItemJSON = eval('('+ $("#" + baseProductId).html() +')');
			this.setEntitledItems(entitledItemJSON);
			var catalogEntryId = this.getCatalogEntryId();
			var params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                orderId: "."
            };
				// Remove calculations for performance
				// params.calculationUsage = "-1,-2,-5,-6,-7";
				params.calculateOrder="0";
			if(catalogEntryId!=null){
				this.updateParamObject(params,"catEntryId",catalogEntryId,false,-1);
				this.updateParamObject(params,"quantity",baseProductQuantity,false,-1);
				if(this.merchandisingAssociationItems[0].catEntry_Type=='BundleBean'){
					var form = document.getElementById(this.merchandisingAssociationItems[0].catEntry_BundleFormId);
					var catEntryArray = [];
					// add the individual bundle items to the request.
					catEntryArray = form.catEntryIDS.value.toString().split(",");
					for(var i = 0; i < catEntryArray.length; i++){
						var qty = document.getElementById("quantity_" + catEntryArray[i]).value;
						var catEntryId = catEntryArray[i];
						if(this.getDefaultItem(catEntryArray[i]))
							catEntryId = this.getDefaultItem(catEntryArray[i]);
						if(qty==0 || qty == null) qty = 1;
						if(qty!=null && qty !== '' && catEntryId!=null){
							this.updateParamObject(params,"catEntryId",catEntryId,false,-1);
							this.updateParamObject(params,"quantity",qty,false,-1);
						}else{
							MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
							return;
						}
					}
				}else{
					this.updateParamObject(params,"catEntryId",this.merchandisingAssociationItems[0].catEntry_Identifier,false,-1);
					this.updateParamObject(params,"quantity",1,false,-1);
				}
			}else{
				MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
				return;
			}
			//For Handling multiple clicks
			if(!submitRequest()){
				return;
			}   		
			cursor_wait();				
			//Invoke service to add to the cart.
			wcService.invoke("AjaxAddOrderItem", params);
		}
	},

	/** 
	* AddAssociation2ShopCart Adds an associated product to the shopping cart. This function is called by other functions in the FastFinderDisplay.js such as Add2ShopCart().
	* 
	* @param {String} associatedItemId The catalog entry ID of the associated item.
	* @param {int} quantity The quantity of the associated item to add.
	*
	**/
	AddAssociation2ShopCart:function(associatedItemId,quantity){
	
	if (browseOnly){
		MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ADD2CART_BROWSE_ONLY_ERROR')); 
		return;
	}
	var form = this.merchandisingProductAssociationForm;
	this.merchandisingProductAssociationAddToCart = false;
	if(this.isParentBundleBean){
		// add the individual bundle items to the request.
		var catEntryArray = [];
		catEntryArray = form.catEntryIDS.value.toString().split(",");
		var bundleItemsCount = 1;
		for(var i = 0; i < catEntryArray.length; i++){
			var qty = document.getElementById("quantity_" + catEntryArray[i]).value;
			var catEntryId = catEntryArray[i];
			if(this.selectedProducts[catEntryArray[i]])
				catEntryId = this.getCatalogEntryIdforProduct(this.selectedProducts[catEntryArray[i]]);
			if(qty==0 || qty == null) qty = 1;
			if(qty!=null && qty !== '' && catEntryId!=null){
				var input1 = document.createElement("input");
				$(input1).attr("id", "OrderItemAddForm_catEntryId_"+catEntryId);
				$(input1).attr("type", "hidden");
				$(input1).attr("name", "catEntryId_"+bundleItemsCount);
				$(input1).attr("value", catEntryId);
				bundleItemsCount = bundleItemsCount + 1;
				form.appendChild(input1);
			}else{
				MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU']);
				return;
			}
		}
		var input2 = document.createElement("input");
		$(input2).attr("id", "OrderItemAddForm_catEntryId_"+associatedItemId);
		$(input2).attr("type", "hidden");
		$(input2).attr("name", "catEntryId_"+bundleItemsCount);
		$(input2).attr("value", associatedItemId);
		form.appendChild(input2);
		var quantity1 = document.createElement("input");
		$(quantity1).attr("id", "OrderItemAddForm_quantity_"+associatedItemId);
		$(quantity1).attr("type", "hidden");
		$(quantity1).attr("name", "quantity_"+bundleItemsCount);
		$(quantity1).attr("value", quantity);
		form.appendChild(quantity1);
		form.URL.value = "AjaxOrderItemDisplayView";
		this.isParentBundleBean = false;
	}else{
		form.catEntryId_2.value = associatedItemId;
		form.productId_2.value = associatedItemId;
		form.quantity_2.value = quantity;
	}

	//For Handling multiple clicks
	if(!submitRequest()){
		return;
	}
	
	// submit the form to add the items to the shop cart.
	processAndSubmitForm(form);
	this.merchandisingProductAssociationForm = "";
	},

	/** 
	* Sets the orderID if it is not already set on the Current Order page. 
	* The order ID is used to determine which order to act upon such as in the case of replacing an order item in an order.
	* 
	* @param {String} orderId The orderID to use.
	*/
	setOrderId : function(orderId) {
		this.orderId = orderId;
	},

	/**
	 * Resolves the SKU and adds the item to a new requisition list.
	 *  
	 * @param {String} entitledItemId The catalog entry ID of the item to add to the requisition list.
	 * @param {String} quantityElemId The ID of the Quantity field.
	 * @param {String} currentPage The URL of the current page. When a customer clicks Cancel on the requisition list creation page, they are redirected to the current page.
	 */
	addToNewListFromProductDetail:function (entitledItemId,quantityElemId,currentPage) {
		MessageHelper.hideAndClearMessage();
		var entitledItemJSON;

		if ($("#" + entitledItemId).length) {
			//the json object for entitled items are already in the HTML. 
			 entitledItemJSON = eval('('+ $("#" + entitledItemId).html() +')');
		}else{
			//if $("#" + entitledItemId).length is 0, that means there's no <div> in the HTML that contains the JSON object. 
			//in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
			entitledItemJSON = this.getEntitledItemJsonObject(); 
		}
		this.setEntitledItems(entitledItemJSON);
		var catalogEntryId = this.getCatalogEntryId();
		if(catalogEntryId!=null){
			this.addItemToNewListFromProductDetail(catalogEntryId, quantityElemId, currentPage);
		}
		else{
			MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU_REQ_LIST']);
			//Close the quick info pop-up if it exists
			if($('#second_level_category_popup').length){
				hidePopup('second_level_category_popup');
			}
			return;
		}
	},
	
	/**
	 * Adds the item to a new requisition list.
	 *  
	 * @param {String} catalogEntryId The resolved catalog entry ID of the item to add to the requisition list.
	 * @param {String} quantityElemId The ID of the Quantity field.
	 * @param {String} currentPage The URL of the current page. When a customer clicks Cancel on the requisition list creation page, they are redirected to the current page.
	 */
	addItemToNewListFromProductDetail:function (catalogEntryId,quantityElemId,currentPage) {
		MessageHelper.hideAndClearMessage();
		if(catalogEntryId!=null){
			var quantity = $("#" + quantityElemId).val()
			if (quantity == null || quantity === "" || quantity<=0 || !RequisitionList.isNumber(quantity)) {
				MessageHelper.displayErrorMessage(MessageHelper.messages['QUANTITY_INPUT_ERROR']);
				//Close the quick info pop-up if it exists
				if($('#second_level_category_popup').length){
					hidePopup('second_level_category_popup');
				}
				return;
			}

			var URL = "AjaxLogonForm?page=createrequisitionlist";
			
			//using the form because the previousPage url can be very long
			var formObj = document.createElement("form");
			$(formObj).attr("method", "POST");
			
			var input = document.createElement("input");
			$(input).attr("type", "hidden");
			$(input).attr("value", currentPage);
			$(input).attr("name", "previousPage");
			formObj.appendChild(input);
			
			formObj.action = URL + "&catEntryId="+catalogEntryId +"&quantity="+quantity+ "&storeId=" + this.storeId +"&catalogId=" + this.catalogId + "&langId=" + this.langId;
			
			document.body.appendChild(formObj); // have to add this form to the body node before submitting.
			processAndSubmitForm(formObj);
		}
		else{
			MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU_REQ_LIST']);
		}
	},
	
	/**
	 * Adds the bundle to a new requisition list.
	 *  
	 * @param {form} form The form that contains all of the inputs for the bundle.
	 * @param {String} currentPage The URL of the current page. When a customer clicks Cancel on the requisition list creation page, they are redirected to the current page.
	 */
	addBundleToNewListFromProductDetail:function (form,currentPage) {
		var productCount = form["numberOfProduct"].value;
		var URL = "AjaxLogonForm?page=createrequisitionlist";
		
		for(var i = 1; i <= productCount; i++){
			var catEntryId = form["catEntryId_" + i].value;
			if(this.selectedProducts[catEntryId]) {
				catEntryId = this.getCatalogEntryIdforProduct(this.selectedProducts[catEntryId]);
			}
			
			var qty = form["quantity_" + i].value;
			if(qty == null || qty === "" || qty<=0 || !RequisitionList.isNumber(qty)){ 
				MessageHelper.displayErrorMessage(MessageHelper.messages['QUANTITY_INPUT_ERROR']); 
				return;
			} else if(catEntryId!=null){
				URL = URL + "&catEntryId=" + catEntryId + "&quantity=" + qty;
			} else{
				MessageHelper.displayErrorMessage(MessageHelper.messages['ERR_RESOLVING_SKU_REQ_LIST']);
				return;
			}
		}
		
		var input = document.createElement("input");
		$(input).attr("type", "hidden");
		$(input).attr("value", currentPage);
		$(input).attr("name", "previousPage");
		form.appendChild(input);
		
		URL = URL +"&numberOfProduct="+form.numberOfProduct.value+ "&storeId=" + this.storeId +"&catalogId=" + this.catalogId + "&langId=" + this.langId; 
		form.action=URL;
		processAndSubmitForm(form);
	},
	
	/**
	* Sets the currentPageType variable. 
	* This variable determines the type of catalog pages that are being viewed, such as product or item pages.
	*
	* @param {Boolean} pageType Indicates the type of catalog page viewed by the customer.
	*
	**/
	setCurrentPageType:function(pageType){
		this.currentPageType = pageType;
	},
	
	/**
	* Sets the currentCatalogEntryId variable. 
	* This variable stores the catalogEntryId of the catalog item being viewed.
	*
	* @param {Boolean} catalogEntryId The ID of the new catalog item viewed by the customer.
	*
	**/
	setCurrentCatalogEntryId:function(catalogEntryId){
		this.currentCatalogEntryId = catalogEntryId;
	},
	
	/**
	 * Submits a category subscription request by invoking the AjaxCategorySubscribe service.
	 * 
	 * @param {String} formId The form Id.
	 */
	handleCategorySubscription:function(formId){
		var form = document.forms[formId];
		var params = {
			DM_ReqCmd: form.DM_ReqCmd.value,
			storeId: form.storeId.value,
			catalogId: form.catalogId.value,
			langId: form.langId.value,
			categoryId: form.categoryId.value
		};
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		wcService.invoke("AjaxCategorySubscribe", params);
	}
}
		
		
	
