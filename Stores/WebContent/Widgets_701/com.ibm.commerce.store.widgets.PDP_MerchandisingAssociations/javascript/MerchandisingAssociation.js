//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

if(typeof(MerchandisingAssociationJS) == "undefined" || MerchandisingAssociationJS == null || !MerchandisingAssociationJS) {
	
	MerchandisingAssociationJS = {
		storeParams: {},
		baseItemParams: {},
		merchandisingAssociations: [],
		associationIndex: 0,
	
		/**
		* Method to set values
		*
		* @param {Object} storeParams params specific to a store
		* @param {Object} baseItemParams params specific to base Item
		* @param {Array} merchandisingAssociations items associated with the base item
		* 
		**/
		setValues: function (storeParams, baseItemParams, merchandisingAssociations) {
			this.storeParams = storeParams;
			this.baseItemParams = baseItemParams;
			this.baseItemParams.quantity = 1;
			this.merchandisingAssociations = merchandisingAssociations;
		},
	
		/**
		 * Setter for baseItemQuantity
		 * 
		 * @param Integer baseItemQuantity
		 */
		setBaseItemQuantity: function(baseItemQuantity){
			var baseItemQuantity = dojo.fromJson(baseItemQuantity);
			// If the quantity is an object with multiple quantities
			if(baseItemQuantity.length){
				for(idx=0;idx<baseItemQuantity.length;idx++){
					for(idx2=0;idx2<MerchandisingAssociationJS.baseItemParams.components.length;idx2++){
						if(MerchandisingAssociationJS.baseItemParams.components[idx2].skus){
							for(idx3=0;idx3<MerchandisingAssociationJS.baseItemParams.components[idx2].skus.length;idx3++){
								if(MerchandisingAssociationJS.baseItemParams.components[idx2].skus[idx3].id == baseItemQuantity[idx].id){
									MerchandisingAssociationJS.baseItemParams.components[idx2].id = baseItemQuantity[idx].id;
									break;
								}
							}
						}
						if(MerchandisingAssociationJS.baseItemParams.components[idx2].id == baseItemQuantity[idx].id){
							MerchandisingAssociationJS.baseItemParams.components[idx2].quantity = baseItemQuantity[idx].quantity;
							break;
						}
					}
				}
			// If the quantity is a single value
			} else {
				MerchandisingAssociationJS.baseItemParams.quantity = baseItemQuantity;
			}
		},
		
		/**
		 * Setter for baseItemAttributes
		 * 
		 * @param Integer baseItemQuantity
		 */
		setBaseItemAttributes: function(baseItemAttributes){
			this.baseItemParams.attributes = dojo.fromJson(baseItemAttributes);
		},
		
		/**
		 * Setter for baseItemAttributes. Retrieve product attributes from catentry object. 
		 * 
		 * @param Integer baseItemQuantity
		 */
		setBaseItemAttributesFromProduct: function(catEntryId, productId){
			var selectedAttributes = productDisplayJS.selectedAttributesList["entitledItem_" + productId];
			MerchandisingAssociationJS.setBaseItemAttributes(dojo.toJson(selectedAttributes));
		},
		
		/**
		* changeItem scrolls the associated catEntries up and down
		*
		* @param {int} direction +1, scrolls up and -1, scrolls down
		*
		**/
		changeItem: function(direction){
			if((this.associationIndex + direction) >= 0 && (this.associationIndex + direction) < this.merchandisingAssociations.length) {
				this.associationIndex = this.associationIndex + direction;
				// sets the associated item name
				dojo.byId("association_item_name").innerHTML = this.merchandisingAssociations[this.associationIndex].name;
				if(document.getElementById("ProductInfoName_"+this.merchandisingAssociations[this.associationIndex-direction].productId) != null){
					document.getElementById("ProductInfoName_"+this.merchandisingAssociations[this.associationIndex-direction].productId).value = this.merchandisingAssociations[this.associationIndex].name;
					document.getElementById("ProductInfoName_"+this.merchandisingAssociations[this.associationIndex-direction].productId).id = "ProductInfoName_" + this.merchandisingAssociations[this.associationIndex].productId;
				}
				// sets the associated thumbnail image of the item
				dojo.byId("association_thumbnail").src = this.merchandisingAssociations[this.associationIndex].thumbnail;
				if(document.getElementById("ProductInfoImage_"+this.merchandisingAssociations[this.associationIndex-direction].productId) != null){
					document.getElementById("ProductInfoImage_"+this.merchandisingAssociations[this.associationIndex-direction].productId).value = this.merchandisingAssociations[this.associationIndex].thumbnail;
					document.getElementById("ProductInfoImage_"+this.merchandisingAssociations[this.associationIndex-direction].productId).id = "ProductInfoImage_" + this.merchandisingAssociations[this.associationIndex].productId;
				}				
				// sets the associated item name to alt text
				dojo.byId("association_thumbnail").alt = this.merchandisingAssociations[this.associationIndex].name;
				// sets the total offered price
				dojo.byId("combined_total").innerHTML = this.merchandisingAssociations[this.associationIndex].offeredCombinedPrice;
				if(document.getElementById("ProductInfoPrice_"+this.merchandisingAssociations[this.associationIndex-direction].productId) != null){
					document.getElementById("ProductInfoPrice_"+this.merchandisingAssociations[this.associationIndex-direction].productId).value = this.merchandisingAssociations[this.associationIndex].skuOfferPrice;
					document.getElementById("ProductInfoPrice_"+this.merchandisingAssociations[this.associationIndex-direction].productId).id = "ProductInfoPrice_" + this.merchandisingAssociations[this.associationIndex].productId;
				}				
				// sets the total list price
				dojo.byId("list_total").innerHTML = this.merchandisingAssociations[this.associationIndex].listedCombinedPrice;
				if(dojo.byId("association_url").ontouchend == undefined){
					// sets the product url href
					dojo.byId("association_url").href = this.merchandisingAssociations[this.associationIndex].url;
				}
				// sets the product url title
				dojo.byId("association_url").title = this.merchandisingAssociations[this.associationIndex].shortDesc;
				if(dojo.byId("association_url").ontouchend != undefined){
					currentPopup = "";
					dojo.byId("association_url").setAttribute("ontouchend", "handlePopup('"+this.merchandisingAssociations[this.associationIndex].url+"','merchandisingAssociation_QuickInfoDiv"+this.merchandisingAssociations[this.associationIndex].id+"')");
				}
				// sets the href for quick info
				dojo.byId("merchandisingAssociation_QuickInfo").href = "javascript:QuickInfoJS.showDetails("+this.merchandisingAssociations[this.associationIndex].id+");";
				if(0 == this.associationIndex){
					// changing the up arrow to disabled style
					dojo.query("#up_arrow").removeClass("up_active");
					dojo.query("#down_arrow").addClass("down_active");
					dojo.byId("down_arrow").focus();
				}else if((this.merchandisingAssociations.length-1) == this.associationIndex){
					// changing the down arrow to disabled style
					dojo.query("#down_arrow").removeClass("down_active");
					dojo.query("#up_arrow").addClass("up_active");
					dojo.byId("up_arrow").focus();
				} else {
					// changing the arrows to enabled style
					dojo.query("#up_arrow").addClass("up_active");
					dojo.query("#down_arrow").addClass("down_active");
				}
			}
		},
		
		setCommonParams: function(){
			var params = new Object();
			params.storeId		= this.storeParams.storeId;
			params.catalogId	= this.storeParams.catalogId;
			params.langId		= this.storeParams.langId;
			params.orderId		= ".";
			// Remove calculations for performance
			// params.calculationUsage = "-1,-2,-5,-6,-7";
			params.calculateOrder="0";
			params.inventoryValidation = "true";
			return params;
		},
		
		validate: function(){
			if(this.baseItemParams.type =='BundleBean'){
				for(idx=0;idx<this.baseItemParams.components.length;idx++){
					if(!isPositiveInteger(this.baseItemParams.components[idx].quantity)){
						MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUT_ERROR']);
						return;
					}
				}
			} else if(this.baseItemParams.type =='ProductBean' && 
					(null == this.baseItemParams.attributes || "undefined" == this.baseItemParams.attributes)) {
				MessageHelper.displayErrorMessage(storeNLS['ERR_RESOLVING_SKU']);
				return;
			} else if(!isPositiveInteger(this.baseItemParams.quantity)){
				MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUT_ERROR']);
				return;
			} 
		},
		
		/**
		* addBoth2ShopCart Adds both base product and the associated product to the shopping cart
		*
		*
		**/
		addBoth2ShopCart: function(catEntryID_baseItem,catEntryID_MA, catEntryID_MA_quantity, associationIndex){
			this.associationIndex = associationIndex;
			this.validate();
			if(!isPositiveInteger(catEntryID_MA_quantity)){
				MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUT_ERROR']);
				return;
			}
			var params = this.setCommonParams();
			
			shoppingActionsJS.productAddedList = new Object();
			//Add the parent product to the cart.
			if(this.baseItemParams.type == 'ItemBean'
				|| this.baseItemParams.type == 'PackageBean'
				||this.baseItemParams.type == 'DynamicKitBean'){
				updateParamObject(params,"catEntryId",this.baseItemParams.id,false,-1);
				updateParamObject(params,"quantity",this.baseItemParams.quantity,false,-1);
				if(this.baseItemParams.type == 'DynamicKitBean'){
					updateParamObject(params,"catalogEntryType","dynamicKit",-1);
				}
				if(this.baseItemParams.type == 'ItemBean'){
					shoppingActionsJS.saveAddedProductInfo(Math.abs(this.baseItemParams.quantity), this.baseItemParams.productId, this.baseItemParams.id, this.baseItemParams.attributes);
				} else {
					shoppingActionsJS.saveAddedProductInfo(Math.abs(this.baseItemParams.quantity), this.baseItemParams.productId, this.baseItemParams.id, shoppingActionsJS.selectedAttributesList['entitledItem_'+this.baseItemParams.id]);
				}
			} else if(this.baseItemParams.type=='BundleBean'){
				// Add items in the bundle
				for(idx=0;idx<this.baseItemParams.components.length;idx++){
					updateParamObject(params,"catEntryId",this.baseItemParams.components[idx].id,false,-1);
					updateParamObject(params,"quantity",this.baseItemParams.components[idx].quantity,false,-1);
					
					if(this.baseItemParams.components[idx].productId != undefined){
						var selectedAttrList = new Object();
						for(attr in shoppingActionsJS.selectedProducts[this.baseItemParams.components[idx].productId]){
							selectedAttrList[attr] = shoppingActionsJS.selectedProducts[this.baseItemParams.components[idx].productId][attr];
						}
						shoppingActionsJS.saveAddedProductInfo(Math.abs(this.baseItemParams.components[idx].quantity), this.baseItemParams.components[idx].productId, this.baseItemParams.components[idx].id, selectedAttrList);
					} else {
						shoppingActionsJS.saveAddedProductInfo(Math.abs(this.baseItemParams.components[idx].quantity), this.baseItemParams.components[idx].id, this.baseItemParams.components[idx].id, shoppingActionsJS.selectedProducts[this.baseItemParams.components[idx].id]);
					}
				}
			} else {
				// Resolve ProductBean to an ItemBean based on the attributes in the main page
				var sku = this.resolveSKU();
				if(-1 == sku){
					MessageHelper.displayErrorMessage(storeNLS['ERR_RESOLVING_SKU']);
					return;
				} else {
					updateParamObject(params,"catEntryId",sku,false,-1);
					updateParamObject(params,"quantity",this.baseItemParams.quantity,false,-1);
					shoppingActionsJS.saveAddedProductInfo(Math.abs(this.baseItemParams.quantity), this.baseItemParams.id, sku,  this.baseItemParams.attributes);
				}
			}
			if (this.merchandisingAssociations[this.associationIndex].type=='ItemBean'
				|| this.merchandisingAssociations[this.associationIndex].type=='PackageBean'
				|| this.merchandisingAssociations[this.associationIndex].type=='DynamicKitBean'){
				updateParamObject(params,"catEntryId",this.merchandisingAssociations[this.associationIndex].id,false,-1);				
				updateParamObject(params,"quantity",catEntryID_MA_quantity,false,-1);
				if(this.merchandisingAssociations[this.associationIndex].productId != undefined){
					shoppingActionsJS.saveAddedProductInfo(Math.abs(catEntryID_MA_quantity), this.merchandisingAssociations[this.associationIndex].productId, this.merchandisingAssociations[this.associationIndex].id, shoppingActionsJS.selectedAttributesList['entitledItem_'+this.merchandisingAssociations[this.associationIndex].id]);
				} else {
					shoppingActionsJS.saveAddedProductInfo(Math.abs(catEntryID_MA_quantity), this.merchandisingAssociations[this.associationIndex].id, this.merchandisingAssociations[this.associationIndex].id, shoppingActionsJS.selectedAttributesList['entitledItem_'+this.merchandisingAssociations[this.associationIndex].id]);
				}
				this.addItems2ShopCart(params);
			} else if(this.merchandisingAssociations[this.associationIndex].type=='BundleBean'){
				// Add items in the bundle
				for(idx=0;idx<this.merchandisingAssociations[this.associationIndex].components.length;idx++){
					updateParamObject(params,"catEntryId",this.merchandisingAssociations[this.associationIndex].components[idx].id,false,-1);
					updateParamObject(params,"quantity",catEntryID_MA_quantity,false,-1);
					shoppingActionsJS.saveAddedProductInfo(Math.abs(catEntryID_MA_quantity), this.merchandisingAssociations[this.associationIndex].components[idx].id, this.merchandisingAssociations[this.associationIndex].components[idx].id, shoppingActionsJS.selectedProducts[this.merchandisingAssociations[this.associationIndex].components[idx].id]);
				}
				this.addItems2ShopCart(params);
			} else {
				// Resolve ProductBean to an ItemBean based on the attributes selected
				var entitledItemJSON = null;
				if (dojo.byId(catEntryID_MA)!=null) {
					//the json object for entitled items are already in the HTML. 
					 entitledItemJSON = eval('('+ dojo.byId(catEntryID_MA).innerHTML +')');
				}else{
					//if dojo.byId(entitledItemId) is null, that means there's no <div> in the HTML that contains the JSON object. 
					//in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
					entitledItemJSON = shoppingActionsJS.getEntitledItemJsonObject(); 
				}
				shoppingActionsJS.setEntitledItems(entitledItemJSON);
				var catEntryID_MA_SKU = shoppingActionsJS.getCatalogEntryId(catEntryID_MA);
				if(null == catEntryID_MA_SKU){
					MessageHelper.displayErrorMessage(storeNLS['ERR_RESOLVING_SKU']);
					return;
				} else {
					updateParamObject(params,"catEntryId",catEntryID_MA_SKU,false,-1);
					updateParamObject(params,"quantity",catEntryID_MA_quantity,false,-1);
					shoppingActionsJS.saveAddedProductInfo(catEntryID_MA_quantity, catEntryID_MA.split("_")[1], catEntryID_MA_SKU, shoppingActionsJS.selectedAttributesList['entitledItem_'+this.merchandisingAssociations[this.associationIndex].id]);
					this.addItems2ShopCart(params);
				}
			}
		},
		
		resolveSKU: function() {
			for(idx=0;idx<this.baseItemParams.skus.length;idx++){
				var matches = 0;
				var attributeCount = 0;
				for(attribute in this.baseItemParams.skus[idx].attributes){
					attributeCount++;
					if(this.baseItemParams.attributes && this.baseItemParams.skus[idx].attributes[attribute] == this.baseItemParams.attributes[attribute]){
						matches++;
					} else {
						break;
					}
				}
				if(matches == attributeCount){
					return this.baseItemParams.skus[idx].id;
				}
			}
			return -1;
		},
		
		/**
		* AddItem2ShopCartAjax This function is used to add a single or multiple items to the shopping cart using an ajax call.
		*
		* @param {Object} params, parameters that needs to be passed during service invocation.
		*
		**/
		addItems2ShopCart : function(params){
			var shopCartService = "AddOrderItem";
			if(params['catalogEntryType'] == 'dynamicKit' ){
				shopCartService = "AddPreConfigurationToCart";
			}
			//For Handling multiple clicks
			if(!submitRequest()){
				return;
			}   
			cursor_wait();		
			wc.service.invoke(shopCartService, params);
		},
		
		/**
		* This function is used to subscribe to dojo events that indicate quantity change and attribute changes.
		*
		* @param {Object} params, parameters that needs to be passed during service invocation.
		*
		**/
		subscribeToEvents : function(baseCatalogEntryId){
			dojo.topic.subscribe("Quantity_Changed", MerchandisingAssociationJS, MerchandisingAssociationJS.setBaseItemQuantity);
			dojo.topic.subscribe("DefiningAttributes_Resolved_" + baseCatalogEntryId, MerchandisingAssociationJS.setBaseItemAttributesFromProduct);
		}
	}

}