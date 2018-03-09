//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------
if(typeof(QuickInfoJS) == "undefined" || QuickInfoJS == null || !QuickInfoJS) {
	
	QuickInfoJS = {
		productImgDimensions: "1000x1000",
		quickInfoImgDimensions: "330x330",
		catEntryParams: {},
		selectedAttributes: new Object(),
		catEntryQuantity: 1,
		itemDetailsArr: new Object(),
		params: null,
		replaceOrderItemId: '', // the orderItemId to be replaced after changing the attributes
		itemId: '', // the current item in the cart to be replaced
		selectedSkuIndex: null, // selected sku index
		selectedThumbnailIndex: null, // selected thumbnail index
		
		/**
		 * Sets the replaceOrderItemId
		 */
		setReplaceOrderItemId: function(replaceOrderItemId){
			this.replaceOrderItemId = replaceOrderItemId;
		},
		
		/**
		 * Sets other values
		 */
		setValues: function(){
			if ($("#catEntryParamsForJS").length){
				this.catEntryParams = $.parseJSON($("#catEntryParamsForJS").val());
			}
			
			this.catEntryParams.attributes = this.selectedAttributes;
		},
		
		/**
		 * Setter for catEntryQuantity
		 * 
		 * @param Integer catEntryQuantity
		 */
		setCatEntryQuantity: function(catEntryQuantity){
			this.catEntryQuantity = catEntryQuantity;
		},
		
		/**
		 * To display quick info details
		 * 
		 * @param {String} productId
		 * @param {Object} params
		 * @param {String} itemId
		 * @param {String} quantity
		 */
		showDetails: function(productId, params, itemId, quantity, parentPage){
			/*
			 * If showDetails is called from merchandising association,
			 * params will be filled with cat entry of the first product to be added to shopping cart
			 */ 
			if(params){
				this.params = params;
			} else {
				// resetting to null, if no params passed
				this.params = null;
			}
			// Clearing the selected attributes
			this.selectedAttributes = new Object();
			this.selectedSkuIndex = null; // clearing selected sku index
			this.selectedThumbnailIndex = null; // clearing selected thumbnail index
			
			// For Handling multiple clicks.
			if(!submitRequest()){
				return;
			}
			this.close();
			cursor_wait();

			var contextValues = this.setCommonParams();
			if(itemId){
				this.itemId = itemId;
				contextValues.updateAttributes = "true";
			} else {
				this.itemId = '';
				contextValues.updateAttributes = "false";
			}
			if (parentPage) {
				contextValues.parentPage = parentPage;
			}
			
			if(quantity){
				this.catEntryQuantity = quantity;
			}
			
			contextValues.productId = productId;
			wcRenderContext.updateRenderContext('QuickInfoContext', contextValues);
		},
		
		/**
		 * To display quick info details - to change attribute values
		 * 
		 * @param {String} orderItemId
		 * @param {String} productId
		 * @param {String} itemId
		 * @param {String} quantity
		 */
		changeAttributes: function(orderItemId, productId, itemId, quantity){
			this.setReplaceOrderItemId(orderItemId);
			this.showDetails(productId, null, itemId, quantity);
		},
		
		/**
		 * Change the main image based on the angle thumbnail clicked
		 * 
		 */
		changeImage: function(elementId, imgSrc){
			this.selectedThumbnailIndex = elementId-1;
			$("#quickInfoMainImage").attr("src", this.getQuickInfoImage(this.catEntryParams.skus[this.selectedSkuIndex].thumbnailAttachments[this.selectedThumbnailIndex].path))
			$(".widget_quick_info_popup .other_views li").removeClass("selected");
			if (isProduct === 'true') {
				$("#quickInfoProductThumbnail" + elementId).addClass("selected");
			} else {
				$("#quickInfoThumbnail" + elementId).addClass("selected");
			}
		},
		
		/**
		* setSelectedAttribute Sets the selected attribute value for a particular attribute not in reference to any catalog entry.
		*					   When an attribute is selected from that drop down this method is called to update the selected value for that attribute.
		*
		* @param {String} selectedAttributeName The name of the attribute.
		* @param {String} selectedAttributeValue The value of the selected attribute.
		*
		*/
		setSelectedAttribute : function(selectedAttributeName , selectedAttributeValue){ 
			this.selectedAttributes[selectedAttributeName] = selectedAttributeValue;
		},
		
		/**
		 * To notify the change in attribute to other components that is subscribed to attributesChanged event.
		 */
		notifyAttributeChange: function(){
			wcTopic.publish('QuickInfo_attributesChanged', [JSON.stringify(this.selectedAttributes)]);
			this.setValues();
			var catEntryId = this.resolveSKU();
			if (catEntryId != -1) {
				wcTopic.publish('DefiningAttributes_Resolved', catEntryId, this.catEntryParams.id);
				QuickInfoJS.selectItem(true);
			}
			else {
				wcTopic.publish('DefiningAttributes_Resolved', null, null);
				var attrSelected = false;
				for (var attribute in this.selectedAttributes) {
					if (this.selectedAttributes[attribute] !== null && this.selectedAttributes[attribute] !== '') {
						attrSelected = true;
					}
				}
				
				if (!attrSelected) {
					$("div[id^='quickinfoAngleImagesArea']").css("display", 'none');
					$("div[id^='quickinfoProductAngleImagesArea']").css("display", 'block');
					
					this.showDetails(this.catEntryParams.id, null, null, null, '');
				}
			}
		},
		
		/**
		 * Selects the sku and updates the item name and price.
		 * 
		 * @param {Boolean} displayPriceRange If the value is true, then display the price range. If it is false then do not display the price range.
		 * @param {Boolean} updateItemImageOnly If the value is true, then only change the item image. If it is false then update all product details.
		 */
		selectItem: function(displayPriceRange, updateItemImageOnly){
			this.displayPriceRange = displayPriceRange;
			this.setValues();
			var catEntryId = this.resolveSKU();

			if(catEntryId == -1 && updateItemImageOnly){
				var skuId = -1;
				for(idx=0;idx<this.catEntryParams.skus.length;idx++){
					for(attribute in this.catEntryParams.skus[idx].attributes){
						if(this.catEntryParams.attributes && this.catEntryParams.skus[idx].attributes[attribute] == this.catEntryParams.attributes[attribute]){
							skuId = this.catEntryParams.skus[idx].id;
							break;
						}
					}
				}
				if(skuId != -1){
					catEntryId = skuId;
					this.updateItemImageOnly = updateItemImageOnly;
				}		
			}
			
			if(catEntryId!=-1){
				//check if the object is already present for the catEntryId.
				if(this.itemDetailsArr[catEntryId] != null && this.itemDetailsArr[catEntryId] != 'undefined'){
					this.displayItemDetails(this.itemDetailsArr[catEntryId]);
				}
				//if json object is not present, call the service to get the details.
				else{
					var params = this.setCommonParams();
					params.catalogEntryId = catEntryId;

					//Declare a service for retrieving catalog entry detailed information for an item...
					wcService.declare({
						id: "getCatalogEntryDetailsQI",
						actionId: "getCatalogEntryDetailsQI",
						url: getAbsoluteURL() + appendWcCommonRequestParameters("GetCatalogEntryDetailsByIDView"),
						formId: ""

						,successHandler: function(serviceResponse, ioArgs) {
							QuickInfoJS.setItemDetails(serviceResponse, ioArgs);
						}

						,failureHandler: function(serviceResponse, ioArgs) {
							console.debug("QuickInfoJS.selectItem: Unexpected error occurred during an xhrPost request.");
						}

					});
					wcService.invoke("getCatalogEntryDetailsQI", params);
				}
			}
		},
		
		/**
		* Handles the case when a swatch is selected. Set the border of the selected swatch.
		* @param {String} selectedAttributeName The name of the selected swatch attribute.
		* @param {String} selectedAttributeValue The value of the selected swatch attribute.
		* @param {String} swatchId id of the swatch element
		* @param {String} swatchGrp starting pattern of id of the swatch element group
		* 
		**/
		selectSwatch: function(selectedAttributeName, selectedAttributeValue, swatchId, swatchGrp) {
			if($("[id='quickInfoSwatch_" + selectedAttributeName + "_" + selectedAttributeValue + "']").hasClass("color_swatch_disabled")){
				return false;
			}
			// sets the store parameters and catalog details from the hidden fields
			this.setValues();
			// picks all the swatch names
			var swatchNames = $("#WC_QuickInfo_SwatchNames").val().split("_");
			// identifies the position of the current swatch
			var currentSwatchPos = -1;
			for(var i=0; i<swatchNames.length;i++){
				if(swatchNames[i] == selectedAttributeName){
					currentSwatchPos = i;
					break;
				}
			}
			var currentSwatchkey = "quickInfoSwatch_" + selectedAttributeName + "_" +selectedAttributeValue;
			var currentSwatchkeyLink = "WC_QuickInfo_Swatch_" + selectedAttributeName + "_" +selectedAttributeValue;
			var validSwatchArr = new Array();
			// iterates through each sku and its attributes to identify valid attribute combination
			for(idx in this.catEntryParams.skus){
				var validItem = false;
				var entitledItem = this.catEntryParams.skus[idx];
				for(attribute in entitledItem.attributes){
					
					if(selectedAttributeName == attribute && selectedAttributeValue == entitledItem.attributes[attribute] && entitledItem.buyable){
						validItem = true;
						break;
					}
				}
				if(validItem){
					for(attribute in entitledItem.attributes){
						var attributePos = -1;
						for(var i=0; i<swatchNames.length;i++){
							if(swatchNames[i] == attribute){
								attributePos = i;
								break;
							}
						}						
						if(attributePos > currentSwatchPos){
							// picks the valid swatch attributes for the current swatch selection
							validSwatchArr.push(attribute + "_" + entitledItem.attributes[attribute]);
						}
					}
				}
			}
			
			var swatchesDisabled = new Array();
			var selectedSwatches = new Array();
			for(idx in this.catEntryParams.skus){
				var entitledItem = this.catEntryParams.skus[idx];
				for(attribute in entitledItem.attributes){
					var attributePos = -1;
					for(var i=0; i<swatchNames.length;i++){
						if(swatchNames[i] == attribute){
							attributePos = i;
							break;
						}
					}											
					if(attributePos > currentSwatchPos){
						var swatchSelection = attribute + "_" + entitledItem.attributes[attribute];
						var swatchId = "quickInfoSwatch_" + swatchSelection;
						var swatchLinkId = "WC_QuickInfo_Swatch_" + swatchSelection;
						var validSwatchArrPos = -1;
						for(var i=0; i<validSwatchArr.length;i++){
							if(validSwatchArr[i] == swatchSelection){
								validSwatchArrPos = i;
								break;
							}
						}								
						var swatchesDisabledPos = -1;
						for(var i=0; i<swatchesDisabled.length;i++){
							if(swatchesDisabled[i] == swatchSelection){
								swatchesDisabledPos = i;
								break;
							}
						}								
						// enable valid swatches
						if(validSwatchArrPos > -1){
							if(!$("[id='" + swatchId + "']").hasClass("color_swatch_selected")){
								$("[id='" + swatchId + "']").attr("class", "color_swatch");
								$("[id='" + swatchId + "']").attr("src", $("[id='" + swatchId + "']").attr("src").replace("_disabled.png","_enabled.png"))
								$("[id='" + swatchLinkId + "']").attr("aria-disabled", "false");
							}
						} 
						// disable invalid swatches
						else if(swatchesDisabledPos == -1){
							swatchesDisabled.push(swatchSelection);
							if($("[id='" + swatchId + "']").hasClass("color_swatch_selected")){
								selectedSwatches.push(swatchId);
							}
							$("[id='" + swatchId + "']").attr("class", "color_swatch_disabled");
							$("[id='" + swatchId + "']").attr("src", $("[id='" + swatchId + "']").attr("src").replace("_enabled.png","_disabled.png"))
							$("[id='" + swatchLinkId + "']").attr("aria-disabled", "true");
						}
					}
					$("[id='WC_QuickInfo_Swatch_" + attribute + "_" + entitledItem.attributes[attribute] + "']").attr("aria-checked", "false");
				}
			}
			
			// if any of the disabled swatches were previously selected, change the selection to the first valid value
			for(idx in selectedSwatches){
				var selectedSwatch = selectedSwatches[idx];
				var idSelector = "img[id^='" + selectedSwatch.substring(0, selectedSwatch.lastIndexOf("_")) + "']";
				var swatchSelected = false;
				$(idSelector).each(function(index, node, arr){
					if(!swatchSelected && $(node).hasClass("color_swatch")){
						var values = node.id.split("_");
						QuickInfoJS.selectSwatch(values[1],values[2], "quickInfoSwatch_" + values[1] + "_" + values[2],"quickInfoSwatch_"+values[1]+"_");
						QuickInfoJS.selectItem(true);
						swatchSelected = true;
					}
				});
			}
			
			selector = "img[id^='"+swatchGrp+"']";
			
			$(selector).each(function(index, node, arr){
			    if(!$(node).hasClass("color_swatch_disabled")){
			    	$(node).addClass("color_swatch");
			    	if($(node).hasClass("color_swatch_selected")){
				    	$(node).removeClass("color_swatch_selected");
				    }
			    }
			});
			
			$("[id='" + currentSwatchkey + "']").attr("class", "color_swatch_selected");
			$("[id='quickinfo_swatch_selection_"+selectedAttributeName + "']").html(selectedAttributeValue)
			$("[id='" + currentSwatchkeyLink + "']").attr("aria-checked", "true");
			this.setSelectedAttribute(selectedAttributeName, selectedAttributeValue);
		},
		
		/**
		 * Sets the store specific values such as storeId, catalogId and langId in a Object and returns it.
		 * 
		 * @return {Object} params with store specific values
		 */
		setCommonParams: function(){
			var params = new Object();
			params.storeId		= WCParamJS.storeId;
			params.catalogId	= WCParamJS.catalogId;
			params.langId		= WCParamJS.langId;
			return params;
		},
		
		/** 
		 * Displays price of the catEntry selected with the JSON objrct returned from the server.
		 * 
		 * @param {object} serviceRepsonse The JSON response from the service.
		 * @param {object} ioArgs The arguments from the service call.
		 */
		setItemDetails: function(serviceResponse, ioArgs) {
			QuickInfoJS.itemDetailsArr[serviceResponse.catalogEntry.catalogEntryIdentifier.uniqueID] = serviceResponse.catalogEntry;
			QuickInfoJS.displayItemDetails(serviceResponse.catalogEntry);
		},
		
		displayItemDetails: function(catalogEntry) {
			if(null != this.catEntryParams){
				for(idx in this.catEntryParams.skus){
					if(null != this.catEntryParams.skus[idx] && (this.catEntryParams.skus[idx].id == catalogEntry.catalogEntryIdentifier.uniqueID)){
						var angleImageAreaList = $("div[id^='quickinfoAngleImagesArea']");
						var prodAngleImageAreaList = $("div[id^='quickinfoProductAngleImagesArea']");
						
						if(angleImageAreaList.length){
							var angleImageArea = angleImageAreaList[0];
						}
						if(this.catEntryParams.skus[idx].thumbnailAttachments != null && this.catEntryParams.skus[idx].thumbnailAttachments.length > 0){
							prodAngleImageAreaList.css("display", 'none');
                            
							var thumbnailAreaList = $("ul[id^='quickInfoAngleImagesAreaList']");
							if(thumbnailAreaList.length){
								var thumbnailArea = thumbnailAreaList[0];
								if(angleImageArea != null){
									$(angleImageArea).css("display", "block");
								}
								for(idx2 = 1; idx2 <= this.catEntryParams.skus[idx].thumbnailAttachments.length; idx2++){
									var angleThumbnail = document.createElement("li");						
									var angleThumbnailLink = document.createElement("a");
									var angleThumbnailImg = document.createElement("img");
									
									angleThumbnail.id = "quickInfoThumbnail" + idx2;
									
									angleThumbnailLink.href = "javaScript:QuickInfoJS.changeImage(" + idx2 + ",'" + this.catEntryParams.skus[idx].fullImageAttachments[idx2-1].path + "');";
									angleThumbnailLink.id = "WC_QuickInfo_Link_thumbnail_" + idx2;
									angleThumbnailLink.className = "tlignore";
									if(this.catEntryParams.skus[idx].thumbnailAttachments[idx2-1].shortDesc != 'undefined' && this.catEntryParams.skus[idx].thumbnailAttachments[idx2-1].shortDesc != null){
										angleThumbnailLink.title = this.catEntryParams.skus[idx].thumbnailAttachments[idx2-1].shortDesc;
									}
									
									angleThumbnailImg.src = this.catEntryParams.skus[idx].thumbnailAttachments[idx2-1].path;
									if(this.catEntryParams.skus[idx].thumbnailAttachments[idx2-1].shortDesc != 'undefined' && this.catEntryParams.skus[idx].thumbnailAttachments[idx2-1].shortDesc != null){
										angleThumbnailImg.alt = this.catEntryParams.skus[idx].thumbnailAttachments[idx2-1].shortDesc;
									}
									if(idx2 == 1){
										$(thumbnailArea).empty();							
									}						
									angleThumbnailLink.appendChild(angleThumbnailImg);
									angleThumbnail.appendChild(angleThumbnailLink);
									thumbnailArea.appendChild(angleThumbnail);
								}
							}
						} else {
							var prodDisplayClass = 'block';
							for (attribute in this.selectedAttributes){
								if(null != this.selectedAttributes[attribute] && '' != this.selectedAttributes[attribute]){
									prodDisplayClass = 'none';
								}
							}

							if(prodAngleImageAreaList != null){
								for(var i = 0; i < prodAngleImageAreaList.length; i++){			
									if(null != prodAngleImageAreaList[i]){
										$(prodAngleImageAreaList[i]).css("display", prodDisplayClass);
									}
								}
							}

							if (angleImageArea != null){
								$(angleImageArea).css("display", "none");
							}
						}
						if(null == this.selectedThumbnailIndex){
							this.selectedThumbnailIndex = 0;
						}
						this.selectedSkuIndex = idx;
						var imagePath = catalogEntry.description[0].thumbnail;
						if (null != imagePath && imagePath.length != 0){
							$("#quickInfoMainImage").attr("src", imagePath)
						}
						if ($("#ProductInfoImage_"+this.catEntryParams.id).length){
							document.getElementById("ProductInfoImage_"+this.catEntryParams.id).value = imagePath;
						}
					}
				}
			}
			
			if(this.updateItemImageOnly){	
				this.updateItemImageOnly = false;
				return;
			}
			
			$(".widget_quick_info_popup .main_header").first().html(catalogEntry.description[0].name);
			if ($("#ProductInfoName_"+this.catEntryParams.id).length){
				document.getElementById("ProductInfoName_"+this.catEntryParams.id).value = catalogEntry.description[0].name;
			}
			
			if(catalogEntry.listPriced && catalogEntry.listPrice > catalogEntry.offerPrice){
				if(null != $(".widget_quick_info_popup .old_price")[0]){
					$(".widget_quick_info_popup .old_price").first().html(catalogEntry.listPrice);
				} else {
					var oldPriceTag = "<span class='old_price'>" + catalogEntry.listPrice + "</span>";
					var priceTag = $(".widget_quick_info_popup .price")[0];
					$(oldPriceTag).before(priceTag);
				}
			} else if(null != $(".widget_quick_info_popup .old_price")[0]){
				$(".widget_quick_info_popup .old_price").remove();
			}
			$(".widget_quick_info_popup .price").first().html(catalogEntry.offerPrice);
			
			$(".widget_quick_info_popup .sku").first().html(Utils.getLocalizationMessage('SKU') + " " + catalogEntry.catalogEntryIdentifier.externalIdentifier.partNumber);

			if ($("#ProductInfoPrice_"+this.catEntryParams.id).length){
				document.getElementById("ProductInfoPrice_"+this.catEntryParams.id).value = catalogEntry.offerPrice;
			}
		},
		
		validate: function(){
			if(this.catEntryParams.type =='ProductBean' && 
					(null == this.catEntryParams.attributes || "undefined" == this.catEntryParams.attributes)) {
				MessageHelper.displayErrorMessage(Utils.getLocalizationMessage['ERR_RESOLVING_SKU']);
				return false;
			} else if(!isPositiveInteger(this.catEntryQuantity)){
				MessageHelper.displayErrorMessage(Utils.getLocalizationMessage['QUANTITY_INPUT_ERROR']);
				return false;
			}
			return true;
		},
		
		/**
		* add2ShopCart Adds displayed product to the shopping cart
		*
		*
		**/
		add2ShopCart: function(customParams){
			
			if (browseOnly){
				MessageHelper.displayErrorMessage(Utils.getLocalizationMessage['ERROR_ADD2CART_BROWSE_ONLY']); 
				return;
			}
			this.setValues();
			if(!this.validate()){
				return;
			}
			/* 
			 * params is null means, no product is waiting to be added to shopping cart.
			 * params will not be null if the call originated from merchandising association
			 */ 
			if(null == this.params){
				this.params = this.setCommonParams();
				this.params.orderId		= ".";
				// Remove calculations for performance
				// this.params.calculationUsage = "-1,-2,-5,-6,-7";
				this.params.inventoryValidation = "true";
				this.params.calculateOrder="0";
			}

			var productId = '';
			//Add the catalog entry to the cart.
			if(this.catEntryParams.type.toLowerCase() == 'itembean'
				|| this.catEntryParams.type.toLowerCase() == 'packagebean'
				|| this.catEntryParams.type.toLowerCase() == 'dynamickitbean'){
				updateParamObject(this.params,"catEntryId",this.catEntryParams.id,false,-1);
				updateParamObject(this.params,"quantity",this.catEntryQuantity,false,-1);
				productId = this.catEntryParams.id;
			} else {
				// Resolve ProductBean to an ItemBean based on the attributes in the main page
				var sku = this.resolveSKU();
				if(-1 == sku){
					MessageHelper.displayErrorMessage(Utils.getLocalizationMessage['ERR_RESOLVING_SKU']);
					return;
				} else {
					updateParamObject(this.params,"catEntryId",sku,false,-1);
					updateParamObject(this.params,"quantity",this.catEntryQuantity,false,-1);
				}
				productId = sku;
			}
			
			var shopCartService = "AddOrderItem";
			
			//Pass any other customParams set by other add on features
			if(customParams != null && customParams != 'undefined'){
				for(i in customParams){
					this.params[i] = customParams[i];
				}
				if(customParams['catalogEntryType'] == 'dynamicKit' ){
					shopCartService = "AddPreConfigurationToCart";
				}
			}
			if(this.params['catalogEntryType'] == 'dynamicKit' ){
				shopCartService = "AddPreConfigurationToCart";
			}
			
			shoppingActionsJS.saveAddedProductInfo(this.catEntryQuantity, this.catEntryParams.id, productId, this.selectedAttributes);

			this.close();
			
			//For Handling multiple clicks
			if(!submitRequest()){
				return;
			}   
			cursor_wait();		
			wcService.invoke(shopCartService, this.params);
		},
		
		/**
		 * This resolves the product SKUs to a single item by comparing the attributes selected by the user
		 * 
		 * @return {Integer} uniqueId, of the selected SKU.
		 * 					 -1, if no match found
		 */
		resolveSKU: function() {
			// if there is only one sku, no need to resolve.
			if(this.catEntryParams.skus.length == 1){
				return this.catEntryParams.skus[0].id;
			}
			for(idx=0;idx<this.catEntryParams.skus.length;idx++){
				var matches = 0;
				var attributeCount = 0;
				for(attribute in this.catEntryParams.skus[idx].attributes){
					attributeCount++;
					if(this.catEntryParams.attributes && this.catEntryParams.skus[idx].attributes[attribute] == this.catEntryParams.attributes[attribute]){
						matches++;
					} else {
						break;
					}
				}
				// if there are multiple skus for a product, there should be atleast one attribute for that product
				if(0 != matches && matches == attributeCount){
					return this.catEntryParams.skus[idx].id;
				}
			}
			return -1;
		},
		
		/** 
		 * Displays the Product Quick Info button.
		 * 
		 * @param {string} id The id of the div area to show.
		 */
		showQuickInfoButton: function(id){
            $("#" + id).css("visibility", "visible");
		},

		/** 
		 * Hides the Product Quick Info button.
		 * 
		 * @param {string} id The id of the div area to hide. 
		 */	
		hideQuickInfoButton: function(id){
            $("#" + id).css("visibility", "");
		},
		 
		/** 
		 * Overrides the hidePopupButton function above by also checking to see if the user clicks shift+tab.
		 * 
		 * @param {string} id The id of the div area to hide. 
		 * @param {event} event The keystroke event entered by the user. 
		 */	
		shiftTabHideQuickInfoButton: function(id, event){
			if ((event.shiftKey) && (event.keyCode === KeyCodes.TAB)){
				this.hideQuickInfoButton(id);
			} 
		},
		
		/**
		 * Close the quick info popup
		 */
		close: function(focusElement){
			$('#quickInfoPopup').WCDialog("close");
			if(focusElement !=null && focusElement !='undefined' && document.getElementById(focusElement)){
				document.getElementById(focusElement).focus();
			}
		},
		

		/**
		 * Sets the focus back to the product image after quick info is closed.
		 */
		setFocus: function(event){
			if(event.keyCode === KeyCodes.ESCAPE && $('#catEntryParamsForJS').length){
				var catEntryParams = $("#catEntryParamsForJS").val();
				var catEntryId = $.parseJSON(catEntryParams).id;
				if(document.getElementById('catalogEntry_img' + catEntryId)){
					document.getElementById('catalogEntry_img' + catEntryId).focus();
				}
			}
		},


		/**
		 * Selects first swatch element
		 */
		selectDefaultSwatch: function(){
			var swatchElement = $("a[id^='WC_QuickInfo_Swatch_']")[0];
			if(swatchElement){
				eval($(swatchElement).attr("href"));
			}
		},
		
		/**
		* replaceCartItem This function is used to replace an item in the shopping cart. This will be called from the shopping cart and checkout pages.
		*
		**/
		replaceCartItem : function(){
			this.setValues();
			if(!this.validate()){
				return;
			}

			var catalogEntryId = this.resolveSKU();
			if(-1 == catalogEntryId){
				MessageHelper.displayErrorMessage(Utils.getLocalizationMessage['ERR_RESOLVING_SKU']);
				return;
			}
			this.close();
			
			var addressId = "";
			var shipModeId = "";
			var physicalStoreId = "";
			var typeId = $("#shipmentTypeId");
			
			if($("#addressId_all").length && $("#shipModeId_all").length){
				//Single Shipment..get the common addressId and shipModeId..
				if(typeId.length === 0 || typeId.val() != "1"){
					addressId = $("#addressId_all").val();
				} else if($("#physicalStoreId").length){
					physicalStoreId = $("#physicalStoreId").val();
				}
				shipModeId = $("#shipModeId_all").val();
			} else if ($("#MS_ShipmentAddress_" + this.replaceOrderItemId).length && $("#MS_ShippingMode_" + this.replaceOrderItemId).length){
				//Multiple shipment..each orderItem will have its own addressId and shipModeId..
				addressId = $("#MS_ShipmentAddress_" + this.replaceOrderItemId).val();
				shipModeId = $("#MS_ShippingMode_" + this.replaceOrderItemId).val();
			}
					
			if(this.replaceOrderItemId != "" && categoryDisplayJS){
				//Else remove existing catEntryId and then add new one...
				shoppingActionsJS.replaceItemAjaxHelper(catalogEntryId,this.catEntryQuantity,this.replaceOrderItemId,addressId,shipModeId,physicalStoreId);
			} else {
				console.error("categoryDisplayJS not defined");
			}
		},
		
		/**
		 * select the attributes of an sku
		 */
		selectCurrentAttributes: function(){
			for(idx=0;idx<this.catEntryParams.skus.length;idx++){
				var selectedSKU = this.catEntryParams.skus[idx];
				if(selectedSKU.id == this.itemId){
					for(attribute in selectedSKU.attributes){
						var selectNode = $("select[alt='" + attribute + "']")[0];
						if(selectNode){
							selectNode.value = selectedSKU.attributes[attribute];
							this.setSelectedAttribute(attribute,selectNode.value);
						} else {
							var attrValue = selectedSKU.attributes[attribute];
							if ($("[id='quickInfoSwatch_" + attribute + "_" + attrValue + "']").length){													
								this.selectSwatch(attribute, attrValue, "quickInfoSwatch_" + attribute + "_" + attrValue, "quickInfoSwatch_" + attribute + "_");
							}
						}
					}
					
					this.notifyAttributeChange();
					this.selectItem(true);
				  	
					return;
				}
			}
			
		}
		
	}

}