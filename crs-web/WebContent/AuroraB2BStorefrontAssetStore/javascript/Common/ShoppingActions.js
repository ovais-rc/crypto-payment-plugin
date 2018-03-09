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

shoppingActionsJS = {

    /** The language ID currently in use **/
    langId: "-1",

    /** The store ID currently in use **/
    storeId: "",

    /** The catalog ID currently in use **/
    catalogId: "",

    /** Holds the current user type such as guest or registered user. Allowed values are 'G' for guest and 'R' for registered.**/
    userType: "",

    /** A boolean used in a variety of the add to cart methods to tell whether or not the base item was added to the cart. **/
    baseItemAddedToCart: false,

    /** An array of entitled items which is used in various methods throughout ShoppingActions.js **/
    entitledItems: [],

    /** a JSON object that holds attributes of an entitled item **/
    entitledItemJsonObject: null,

    /** A map of attribute name value pairs for the currently selected attribute values **/
    selectedAttributesList: {},

    /** A variable used to form the url dynamically for the more info link in the Quickinfo popup */
    moreInfoUrl: "",

    /**
     * A boolean used to to determine is it from a Qick info popup or not. 
     **/
    isPopup: false,

    /**
     * A boolean used to to determine whether or not to diplay the price range when the catEntry is selected. 
     **/
    displayPriceRange: true,

    /**
     * This array holds the json object retured from the service, holding the price information of the catEntry.
     **/
    itemPriceJsonOject: [],

    /** 
     * stores all name and value of all swatches 
     * this is a 2 dimension array and each record i contains the following information:
     * allSwatchesArray[i][0] - attribute name of the swatch
     * allSwatchesArray[i][1] - attribute value of the swatch
     * allSwatchesArray[i][2] - image1 of swatch (image to use for enabled state)
     * allSwatchesArray[i][3] - image2 of swatch (image to use for disabled state)
     * allSwatchesArray[i][4] - onclick action of the swatch when enabled
     **/
    allSwatchesArrayList: {},

    /**
     * Holds the ID of the image used for swatch
     **/
    skuImageId: "",

    /**
     * The prefix of the cookie key that is used to store item Ids. 
     */
    cookieKeyPrefix: "CompareItems_",

    /**
     * The delimiter used to separate item Ids in the cookie.
     */
    cookieDelimiter: ";",

    /**
     * The maximum number of items allowed in the compare zone. 
     */
    maxNumberProductsAllowedToCompare: 4,

    /**
     * The minimum number of items allowed in the compare zone. 
     */
    minNumberProductsAllowedToCompare: 2,

    /**
     * Id of the base catalog entry. 
     */
    baseCatalogEntryId: 0,

    /**
     * An map which holds the attributes of a set of products
     */
    selectedProducts: {},

    /**
     * An array to keep the quantity of the products in a list (bundle)
     */
    productList: {},

    /**
     * stores the currency symbol
     */
    currencySymbol: "",

    /**
     * stores the compare return page name
     */
    compareReturnName: "",
    /**
     * stores the search term
     */
    searchTerm: "",

    search01: "'",

    search02: '"',

    replaceStr01: /\\\'/g,

    replaceStr02: /\\\"/g,

    ampersandChar: /&/g,

    ampersandEntityName: "&amp;",

    /**
     * An array to keep the details of the newly added products.
     */
    productAddedList: {},

    setCompareReturnName: function (compareReturnName) {
        this.compareReturnName = compareReturnName;
    },

    setSearchTerm: function (searchTerm) {
        this.searchTerm = searchTerm;
    },

    setCommonParameters: function (langId, storeId, catalogId, userType, currencySymbol) {
        this.langId = langId;
        this.storeId = storeId;
        this.catalogId = catalogId;
        this.userType = userType;
        this.currencySymbol = currencySymbol;
    },

    setEntitledItems: function (entitledItemArray) {
        this.entitledItems = entitledItemArray;
    },

    getCatalogEntryId: function (entitledItemId) {
        var attributeArray = [];
        var selectedAttributes = this.selectedAttributesList[entitledItemId];
        for (attribute in selectedAttributes) {
            attributeArray.push(attribute + "_|_" + selectedAttributes[attribute]);
        }
        return this.resolveSKU(attributeArray);
    },

    /**
     * getCatalogEntryIdforProduct Returns the catalog entry ID for a catalog entry that has the same attribute values as a specified product's selected attributes as passed in via the selectedAttributes parameter.
     *
     * @param {String[]} selectedAttributes The array of selected attributes upon which to resolve the SKU.
     *
     * @return {String} catalog entry ID of the SKU.
     *
     **/
    getCatalogEntryIdforProduct: function (selectedAttributes) {
        var attributeArray = [];
        for (attribute in selectedAttributes) {
            attributeArray.push(attribute + "_|_" + selectedAttributes[attribute]);
        }
        return this.resolveSKU(attributeArray);
    },

    /**
     * retrieves the entitledItemJsonObject
     */
    getEntitledItemJsonObject: function () {
        return this.entitledItemJsonObject;
    },

    /**
     * resolveSKU Resolves a SKU using an array of defining attributes.
     *
     * @param {String[]} attributeArray An array of defining attributes upon which to resolve a SKU.
     *
     * @return {String} catentry_id The catalog entry ID of the SKU.
     *
     **/
    resolveSKU: function (attributeArray) {

        console.debug("Resolving SKU >> " + attributeArray + ">>" + this.entitledItems);
        var catentry_id = "";
        var attributeArrayCount = attributeArray.length;

        // if there is only one item, no need to check the attributes to resolve the sku
        if (this.entitledItems.length == 1) {
            return this.entitledItems[0].catentry_id;
        }
        for (x in this.entitledItems) {
            var catentry_id = this.entitledItems[x].catentry_id;
            var Attributes = this.entitledItems[x].Attributes;
            var attributeCount = 0;
            for (index in Attributes) {
                attributeCount++;
            }

            // Handle special case where a catalog entry has one sku with no attributes
            if (attributeArrayCount == 0 && attributeCount == 0) {
                return catentry_id;
            }
            if (attributeCount != 0 && attributeArrayCount >= attributeCount) {
                var matchedAttributeCount = 0;

                for (attributeName in attributeArray) {
                    var attributeValue = attributeArray[attributeName];
                    var attributeValue2 = attributeValue.replace(this.search02, this.search01);
                    if (attributeValue in Attributes || attributeValue2 in Attributes) {
                        matchedAttributeCount++;
                    }
                }

                if (attributeCount == matchedAttributeCount) {
                    console.debug("CatEntryId:" + catentry_id + " for Attribute: " + attributeArray);
                    this.disableBuyButtonforUnbuyable(x);
                    return catentry_id;
                }
            }
        }
        return null;
    },

    /**
     * setSelectedAttribute Sets the selected attribute value for a particular attribute not in reference to any catalog entry.
     *					   One place this function is used is on CachedProductOnlyDisplay.jsp where there is a drop down box of attributes.
     *					   When an attribute is selected from that drop down this method is called to update the selected value for that attribute.
     *
     * @param {String} selectedAttributeName The name of the attribute.
     * @param {String} selectedAttributeValue The value of the selected attribute.
     * @param {String} entitledItemId The element id where the json object of the sku is stored
     * @param {String} skuImageId This is optional. The element id of the product image - image element id is different in product page and category list view. Product page need not pass it because it is set separately
     * @param {String} imageField This is optional. The json field from which image should be picked. Pass value if a different size image need to be picked
     *
     **/
    setSelectedAttribute: function (selectedAttributeName, selectedAttributeValue, entitledItemId, skuImageId, imageField) {
        console.debug(selectedAttributeName + " : " + selectedAttributeValue);
        var selectedAttributes = this.selectedAttributesList[entitledItemId];
        if (selectedAttributes == null) {
            selectedAttributes = {};
        }
        selectedAttributeValue = selectedAttributeValue.replace(this.replaceStr01, this.search01);
        selectedAttributeValue = selectedAttributeValue.replace(this.replaceStr02, this.search02);
        selectedAttributeValue = selectedAttributeValue.replace(this.ampersandChar, this.ampersandEntityName);
        selectedAttributes[selectedAttributeName] = selectedAttributeValue;
        this.moreInfoUrl = this.moreInfoUrl + '&' + selectedAttributeName + '=' + selectedAttributeValue;
        this.selectedAttributesList[entitledItemId] = selectedAttributes;
        this.changeProdImage(entitledItemId, selectedAttributeName, selectedAttributeValue, skuImageId, imageField);
    },

    /**
     * setSelectedAttributeOfProduct Sets the selected attribute value for an attribute of a specified product.
     *								This function is used to set the assigned value of defining attributes to specific 
     *								products which will be stored in the selectedProducts map.
     *
     * @param {String} productId The catalog entry ID of the catalog entry to use.
     * @param {String} selectedAttributeName The name of the attribute.
     * @param {String} selectedAttributeValue The value of the selected attribute.
     * @param {boolean} true, if it is single SKU
     *
     **/
    setSelectedAttributeOfProduct: function (productId, selectedAttributeName, selectedAttributeValue, isSingleSKU) {

        var selectedAttributesForProduct = null;

        if (this.selectedProducts[productId]) {
            selectedAttributesForProduct = this.selectedProducts[productId];
        } else {
            selectedAttributesForProduct = {};
        }

        // add only if attribute has some name. value can be empty
        if (null != selectedAttributeName && '' != selectedAttributeName) {
            selectedAttributesForProduct[selectedAttributeName] = selectedAttributeValue;
        }
        this.selectedProducts[productId] = selectedAttributesForProduct;

        //the json object for entitled items are already in the HTML. 
        var entitledItemJSON = eval('(' + $("#entitledItem_" + productId).html() + ')');

        this.setEntitledItems(entitledItemJSON);

        var catalogEntryId = this.getCatalogEntryIdforProduct(selectedAttributesForProduct);

        if (catalogEntryId == null) {
            catalogEntryId = 0;
        } else {
            // pass true to display price range
            this.changePrice("entitledItem_" + productId, false, true, productId);

            //Update selected sku in merchandising association array
            if (typeof MerchandisingAssociationJS != 'undefined') {
                if (MerchandisingAssociationJS.baseItemParams != null) {
                    if (MerchandisingAssociationJS.baseItemParams.type == 'BundleBean') {
                        // Update items in the bundle
                        for (idx = 0; idx < MerchandisingAssociationJS.baseItemParams.components.length; idx++) {
                            if (productId == MerchandisingAssociationJS.baseItemParams.components[idx].productId) {
                                MerchandisingAssociationJS.baseItemParams.components[idx].id = catalogEntryId;
                            }
                        }
                    }
                }
            }
        }
        var productDetails = null;
        if (this.productList[productId]) {
            productDetails = this.productList[productId];
        } else {
            productDetails = {};
            this.productList[productId] = productDetails;
            productDetails.baseItemId = productId;
        }

        productDetails.id = catalogEntryId;
        if (productDetails.quantity) {
            wcTopic.publish("Quantity_Changed", JSON.stringify(productDetails));
        }

        if (!isSingleSKU) {
            // publish the attribute change event
            if (catalogEntryId != 0) {
                wcTopic.publish('DefiningAttributes_Resolved_' + productId, catalogEntryId, productId);
            } else {
                wcTopic.publish('DefiningAttributes_Changed_' + productId, catalogEntryId, productId);
            }
        }
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
    Add2ShopCartAjax: function (entitledItemId, quantity, isPopup, customParams) {
        var dialog = $('#quick_cart_container').data("wc-WCDialog");
        if (dialog) {
            dialog.close();
        }
        if (browseOnly) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_ADD2CART_BROWSE_ONLY'));
            return;
        }
        var entitledItemJSON;

        if ($("#" + entitledItemId).length) {
            //the json object for entitled items are already in the HTML. 
            entitledItemJSON = eval('(' + $("#" + entitledItemId).html() + ')');
        } else {
            //if $("#" +entitledItemId).length is 0, that means there's no <div> in the HTML that contains the JSON object. 
            //in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
            entitledItemJSON = this.getEntitledItemJsonObject();
        }

        this.setEntitledItems(entitledItemJSON);
        var catalogEntryId = this.getCatalogEntryId(entitledItemId);

        if (catalogEntryId != null) {
            var productId = entitledItemId.substring(entitledItemId.indexOf("_") + 1);
            this.AddItem2ShopCartAjax(catalogEntryId, quantity, customParams, productId);
            this.baseItemAddedToCart = true;
        } else if (isPopup == true) {
            $('#second_level_category_popup').css("zIndex", '1');
            MessageHelper.formErrorHandleClient('addToCartLinkAjax', Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
        } else {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
            this.baseItemAddedToCart = false;
        }
    },

    AddItem2ShopCartAjax: function (catEntryIdentifier, quantity, customParams, productId) {
        if (browseOnly) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_ADD2CART_BROWSE_ONLY'));
            return;
        }
        var params = {storeId: this.storeId,
catalogId: this.catalogId,
langId: this.langId,
orderId: "."};
        // Remove calculations for performance
        // params.calculationUsage = "-1,-2,-5,-6,-7";
        params.inventoryValidation = "true";
        params.calculateOrder = "0";
        var ajaxShopCartService = "AddOrderItem";

        this.productAddedList = {};
        if (Array.isArray(catEntryIdentifier) && Array.isArray(quantity)) {
            for (var i = 0; i < catEntryIdentifier.length; i++) {
                if (!isPositiveInteger(quantity[i])) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                    return;
                }
                params["catEntryId_" + (i + 1)] = catEntryIdentifier[i];
                params["quantity_" + (i + 1)] = quantity[i];
            }
        } else {
            if (!isPositiveInteger(quantity)) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                return;
            }
            params.catEntryId = catEntryIdentifier;
            params.quantity = quantity;

            var selectedAttrList = {};
            for (attr in this.selectedAttributesList['entitledItem_' + productId]) {
                selectedAttrList[attr] = this.selectedAttributesList['entitledItem_' + productId][attr];
            }

            if (productId == undefined) {
                this.saveAddedProductInfo(quantity, catEntryIdentifier, catEntryIdentifier, selectedAttrList);
            } else {
                this.saveAddedProductInfo(quantity, productId, catEntryIdentifier, selectedAttrList);
            }
        }

        //Pass any other customParams set by other add on features
        if (customParams != null && customParams != 'undefined') {
            for (i in customParams) {
                params[i] = customParams[i];
            }
            if (customParams['catalogEntryType'] == 'dynamicKit') {
                ajaxShopCartService = "AddPreConfigurationToCart";
            }
        }

        var contractIdElements = document.getElementsByName('contractSelectForm_contractId');
        if (contractIdElements != null && contractIdElements != "undefined") {
            for (i = 0; i < contractIdElements.length; i++) {
                if (contractIdElements[i].checked) {
                    params.contractId = contractIdElements[i].value;
                    break;
                }
            }
        }

        //For Handling multiple clicks
        if (!submitRequest()) {
            return;
        }
        cursor_wait();

        wcService.invoke(ajaxShopCartService, params);
        this.baseItemAddedToCart = true;

        if (document.getElementById("headerShopCartLink") && document.getElementById("headerShopCartLink").style.display != "none") {
            $("#headerShopCart").focus();
        } else {
            $("#headerShopCart1").focus();
        }
    },

    /**
     * AddBundle2ShopCartAjax This function is used to add a bundle to the shopping cart.
     **/
    AddBundle2ShopCartAjax: function () {
        if (browseOnly) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_ADD2CART_BROWSE_ONLY'));
            return;
        }
        var ajaxShopCartService = "AddOrderItem";
        var params = {
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            orderId: ".",
            inventoryValidation: "true",
            calculateOrder: "0"
        };
        // Remove calculations for performance
        // params.calculationUsage = "-1,-2,-5,-6,-7";
        
        var idx = 1;
        this.productAddedList = {};

        for (productId in this.productList) {
            var productDetails = this.productList[productId];
            var quantity = Utils.parseNumber(productDetails.quantity);

            if (quantity == 0) {
                continue;
            }
            if (productDetails.id == 0) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
                return;
            }
            if (isNaN(quantity) || quantity < 0) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                return;
            }

            params["catEntryId_" + idx] = productDetails.id;
            params["quantity_" + idx++] = quantity;
            this.baseItemAddedToCart = true;

            this.saveAddedProductInfo(quantity, productId, productDetails.id, this.selectedProducts[productId]);
        }

        //For Handling multiple clicks
        if (!submitRequest()) {
            return;
        }
        cursor_wait();
        wcService.invoke(ajaxShopCartService, params);

    },

    resetProductAddedList: function () {
        shoppingActionsJS.productAddedList = {};
    },
    /**
     * Save the product information of the newly added product(s) to be used for the mini cart product added popup
     *
     * @param {String} quantity The quantity of the product being purchased.
     * @param {String} productId The id of the product.
     * @param {String} skuId The id of the sku.
     * @param {String} attrList The list of selected attributes for the product, if any.
     **/
    saveAddedProductInfo: function (quantity, productId, skuId, attrList) {

        var productName = "";
        if ($("#ProductInfoName_" + productId).length) {
            productName = document.getElementById("ProductInfoName_" + productId).value;
        } else if ($("#ProductInfoName_" + skuId).length) {
            productName = document.getElementById("ProductInfoName_" + skuId).value;
        }

        var productThumbnail = "";
        if ($("#ProductInfoImage_" + productId).length) {
            productThumbnail = document.getElementById("ProductInfoImage_" + productId).value;
        } else if ($("#ProductInfoImage_" + skuId).length) {
            productThumbnail = document.getElementById("ProductInfoImage_" + skuId).value;
        }

        var productPrice = "";
        if ($("#ProductInfoPrice_" + productId).length) {
            productPrice = document.getElementById('ProductInfoPrice_' + productId).value;
        } else if ($("#ProductInfoPrice_" + skuId).length) {
            productPrice = document.getElementById('ProductInfoPrice_' + skuId).value;
        }

        var productAdded = [productName, productThumbnail, productPrice, quantity, attrList];
        if (productId != skuId) {
            this.productAddedList[skuId] = productAdded;
        } else {
            this.productAddedList[productId] = productAdded;
        }

        wcTopic.publish("ProductInfo_Added", this.productAddedList);
    },

    /* SwatchCode start */

    /**
     *setSKUImageId Sets the ID of the image to use for swatch.
     **/
    setSKUImageId: function (skuImageId) {
        this.skuImageId = skuImageId;
    },

    /**
     * getImageForSKU Returns the full image of the catalog entry with the selected attributes as specified in the {@link this.selectedAttributes} value.
     *					This method uses resolveImageForSKU to find the SKU image with the selected attributes values.
     *
     * @param {String} imageField, the field name from which the image should be picked
     * @return {String} path to the SKU image.
     * 
     *
     **/
    getImageForSKU: function (entitledItemId, imageField) {
        var attributeArray = [];
        var selectedAttributes = this.selectedAttributesList[entitledItemId];
        for (attribute in selectedAttributes) {
            attributeArray.push(attribute + "_|_" + selectedAttributes[attribute]);
        }
        return this.resolveImageForSKU(attributeArray, imageField);
    },

    /**
     * resolveImageForSKU Resolves image of a SKU using an array of defining attributes.
     *
     * @param {String[]} attributeArray An array of defining attributes upon which to resolve a SKU.
     * @param {String} imageField, the field name from which the image should be picked
     *
     * @return {String} imagePath The location of SKU image.
     *
     **/
    resolveImageForSKU: function (attributeArray, imageField) {

        console.debug("Resolving SKU >> " + attributeArray + ">>" + this.entitledItems);
        var imagePath = "";
        var attributeArrayCount = attributeArray.length;

        for (x in this.entitledItems) {
            if (null != imageField) {
                var imagePath = this.entitledItems[x][imageField];
            } else {
                var imagePath = this.entitledItems[x].ItemImage467;
            }

            var Attributes = this.entitledItems[x].Attributes;
            var attributeCount = 0;
            for (index in Attributes) {
                attributeCount++;
            }

            // Handle special case where a catalog entry has one sku with no attributes
            if (attributeArrayCount == 0 && attributeCount == 0) {
                return imagePath;
            }
            if (attributeCount != 0 && attributeArrayCount >= attributeCount) {
                var matchedAttributeCount = 0;

                for (attributeName in attributeArray) {
                    var attributeValue = attributeArray[attributeName];
                    if (attributeValue in Attributes) {
                        matchedAttributeCount++;
                    }
                }

                if (attributeCount == matchedAttributeCount) {
                    console.debug("ItemImage:" + imagePath + " for Attribute: " + attributeArray);
                    this.disableBuyButtonforUnbuyable(x);
                    var imageArray = [];
                    imageArray.push(imagePath);
                    imageArray.push(this.entitledItems[x].ItemThumbnailImage);
                    if (this.entitledItems[x].ItemAngleThumbnail != null && this.entitledItems[x].ItemAngleThumbnail != undefined) {
                        imageArray.push(this.entitledItems[x].ItemAngleThumbnail);
                        imageArray.push(this.entitledItems[x].ItemAngleFullImage);
                    }
                    return imageArray;
                }
            }
        }
        return null;
    },

    disableBuyButtonforUnbuyable: function (entitledItemIndex) {
        var buyableFlag = this.entitledItems[entitledItemIndex].buyable;
        //				disable the add to cart button
        var btn = document.getElementById("listViewAdd2Cart_" + this.entitledItems[entitledItemIndex].productId);
        if (buyableFlag != null && btn != null) {
            if (buyableFlag == 'false') {
                btn.className += " add2CartButtonDisabled";
            } else {
                btn.className = btn.className.replace(" add2CartButtonDisabled", "");
            }
        }
    },

    /**
     * changeViewImages Updates the angle views of the SKU.
     *
     * @param {String[]} itemAngleThumbnail An array of SKU view thumbnails.
     * @param {String[]} itemAngleFullImage An array of SKU view full images.
     **/
    changeViewImages: function (itemAngleThumbnail, itemAngleFullImage) {
        var imageCount = 0;
        for (x in itemAngleThumbnail) {
            var prodAngleCount = imageCount;
            imageCount++;
            $("#WC_CachedProductOnlyDisplay_images_1_" + imageCount).attr('src', itemAngleThumbnail[x]);
            if ($("#WC_CachedProductOnlyDisplay_links_1_" + imageCount).length) {
                $("#WC_CachedProductOnlyDisplay_links_1_" + imageCount).attr('href',
                    "JavaScript:changeThumbNail('productAngleLi" + prodAngleCount + "','" + itemAngleFullImage[x] + "');");
            }

            if ($("#productAngleLi" + prodAngleCount).length && $("#productAngleLi" + prodAngleCount).attr('className') === ('selected')) {
                changeThumbNail("productAngleLi" + prodAngleCount, itemAngleFullImage[x]);
            }
        }
    },


    /**
     * updates the product image from the PDP page to use the selected SKU image
     * @param String swatchAttrName the newly selection attribute name
     * @param String swatchAttrValue the newly selection attribute value
     * @param {String} imageField, the field name from which the image should be picked
     **/
    changeProdImage: function (entitledItemId, swatchAttrName, swatchAttrValue, skuImageId, imageField) {
        if ($("#" + entitledItemId).length) {
            //the json object for entitled items are already in the HTML. 
            entitledItemJSON = eval('(' + $("#" + entitledItemId).html() + ')');
        }

        this.setEntitledItems(entitledItemJSON);
        var productId = entitledItemId.substring(entitledItemId.indexOf("_") + 1);

        var skuImage = null;
        var imageArr = shoppingActionsJS.getImageForSKU(entitledItemId, imageField);
        if (imageArr != null) {
            skuImage = imageArr[0];
        }

        if (skuImageId != undefined) {
            this.setSKUImageId(skuImageId);
        }

        if (skuImage != null) {
            if ($("#" + this.skuImageId).length) {
                document.getElementById(this.skuImageId).src = skuImage;
                if ($("#ProductInfoImage_" + productId).length) {
                    document.getElementById("ProductInfoImage_" + productId).value = skuImage;
                }

                var itemAngleThumbnail = imageArr[2];
                var itemAngleFullImage = imageArr[3];
                if (itemAngleThumbnail != null && itemAngleThumbnail != undefined) {
                    shoppingActionsJS.changeViewImages(itemAngleThumbnail, itemAngleFullImage);
                }
            }
        } else {
            var imageFound = false;
            for (x in this.entitledItems) {
                var Attributes = this.entitledItems[x].Attributes;
                if (null != imageField) {
                    var itemImage = this.entitledItems[x][imageField];
                } else {
                    var itemImage = this.entitledItems[x].ItemImage467;
                }


                var itemAngleThumbnail = this.entitledItems[x].ItemAngleThumbnail;
                var itemAngleFullImage = this.entitledItems[x].ItemAngleFullImage;

                for (y in Attributes) {
                    var index = y.indexOf("_|_");
                    var entitledSwatchName = y.substring(0, index);
                    var entitledSwatchValue = y.substring(index + 3);

                    if (entitledSwatchName == swatchAttrName && entitledSwatchValue == swatchAttrValue) {
                        // set sku image only if the img element is present
                        if ($("#" + this.skuImageId).length) {
                            $("#" + this.skuImageId).attr('src', itemImage);
                            if (document.getElementById("ProductInfoImage_" + productId) != null) {
                                document.getElementById("ProductInfoImage_" + productId).value = itemImage;
                            }
                        }
                        if (itemAngleThumbnail != null && itemAngleThumbnail != undefined) {
                            shoppingActionsJS.changeViewImages(itemAngleThumbnail, itemAngleFullImage);
                        }
                        imageFound = true;
                        break;
                    }
                }

                if (imageFound) {
                    break;
                }
            }
        }
    },

    /**
     * Updates the swatches selections on list view.
     * Sets up the swatches array and sku images, then selects a default swatch value.
     **/
    updateSwatchListView: function () {
        var swatchArray = $("a[id^='swatch_array_']");
        for (var i = 0; i < swatchArray.length; i++) {
            var swatchArrayElement = swatchArray[i];
            eval($(swatchArrayElement).attr("href"));
        }

        var swatchSkuImage = $("a[id^='swatch_setSkuImage_']");
        for (var i = 0; i < swatchSkuImage.length; i++) {
            var swatchSkuImageElement = swatchSkuImage[i];
            eval($(swatchSkuImageElement).attr("href"));
        }

        var swatchDefault = $("a[id^='swatch_selectDefault_']");
        for (var i = 0; i < swatchDefault.length; i++) {
            var swatchDefaultElement = swatchDefault[i];
            eval($(swatchDefaultElement).attr("href"));
        }
    },

    /**
     * Handles the case when a swatch is selected. Set the border of the selected swatch.
     * @param {String} selectedAttributeName The name of the selected swatch attribute.
     * @param {String} selectedAttributeValue The value of the selected swatch attribute.
     * @param {String} entitledItemId The ID of the SKU
     * @param {String} doNotDisable The name of the swatch attribute that should never be disabled.
     * @param {String} imageField, the field name from which the image should be picked
     * @return boolean Whether the swatch is available for selection
     **/
    selectSwatch: function (selectedAttributeName, selectedAttributeValue, entitledItemId, doNotDisable, selectedAttributeDisplayValue, skuImageId, imageField) {
        if ($("#swatch_" + entitledItemId + "_" + selectedAttributeValue).hasClass("color_swatch_disabled")) {
            return;
        }
        var selectedAttributes = this.selectedAttributesList[entitledItemId];
        for (attribute in selectedAttributes) {
            if (attribute == selectedAttributeName) {
                // case when the selected swatch is already selected with a value, if the value is different than
                // what's being selected, reset other swatches and deselect the previous value and update selection
                if (selectedAttributes[attribute] != selectedAttributeValue) {
                    // deselect previous value and update swatch selection
                    var swatchElement = document.getElementById("swatch_" + entitledItemId + "_" + selectedAttributes[attribute]);
                    swatchElement.className = "color_swatch";
                    swatchElement.src = swatchElement.src.replace("_disabled.png", "_enabled.png");

                    //change the title text of the swatch link
                    document.getElementById("swatch_link_" + entitledItemId + "_" + selectedAttributes[attribute]).title = swatchElement.alt;
                }
            }
            if (document.getElementById("swatch_link_" + entitledItemId + "_" + selectedAttributes[attribute]) != null) {
                document.getElementById("swatch_link_" + entitledItemId + "_" + selectedAttributes[attribute]).setAttribute("aria-checked", "false");
            }
        }
        this.makeSwatchSelection(selectedAttributeName, selectedAttributeValue, entitledItemId, doNotDisable, selectedAttributeDisplayValue, skuImageId, imageField);
    },

    /**
     * Make swatch selection - add to selectedAttribute, select image, and update other swatches and SKU image based on current selection.
     * @param {String} swatchAttrName The name of the selected swatch attribute.
     * @param {String} swatchAttrValue The value of the selected swatch attribute.
     * @param {String} entitledItemId The ID of the SKU.
     * @param {String} doNotDisable The name of the swatch attribute that should never be disabled.	
     * @param {String} skuImageId This is optional. The element id of the product image - image element id is different in product page and category list view. Product page need not pass it because it is set separately
     * @param {String} imageField This is optional. The json field from which image should be picked. Pass value if a different size image need to be picked
     **/
    makeSwatchSelection: function (swatchAttrName, swatchAttrValue, entitledItemId, doNotDisable, selectedAttributeDisplayValue, skuImageId, imageField) {
        // setSelectedAttribute internally calls changeProdImage method to change product image.
        this.setSelectedAttribute(swatchAttrName, swatchAttrValue, entitledItemId, skuImageId, imageField);
        document.getElementById("swatch_" + entitledItemId + "_" + swatchAttrValue).className = "color_swatch_selected";
        document.getElementById("swatch_link_" + entitledItemId + "_" + swatchAttrValue).setAttribute("aria-checked", "true");
        document.getElementById("swatch_selection_label_" + entitledItemId + "_" + swatchAttrName).className = "header color_swatch_label";
        if (document.getElementById("swatch_selection_" + entitledItemId + "_" + swatchAttrName).style.display == "none") {
            document.getElementById("swatch_selection_" + entitledItemId + "_" + swatchAttrName).style.display = "inline";
        }
        if (selectedAttributeDisplayValue != null) {
            document.getElementById("swatch_selection_" + entitledItemId + "_" + swatchAttrName).innerHTML = selectedAttributeDisplayValue;
        } else {
            document.getElementById("swatch_selection_" + entitledItemId + "_" + swatchAttrName).innerHTML = swatchAttrValue;
        }

        this.updateSwatchImages(swatchAttrName, entitledItemId, doNotDisable, imageField);
    },

    /**
     * Constructs record and add to this.allSwatchesArray.
     * @param {String} swatchName The name of the swatch attribute.
     * @param {String} swatchValue The value of the swatch attribute.	
     * @param {String} swatchImg1 The path to the swatch image.
     **/
    addToAllSwatchsArray: function (swatchName, swatchValue, swatchImg1, entitledItemId, swatchDisplayValue) {
        var swatchList = this.allSwatchesArrayList[entitledItemId];
        if (swatchList == null) {
            swatchList = [];;
        }
        if (!this.existInAllSwatchsArray(swatchName, swatchValue, swatchList)) {
            var swatchRecord = [];
            swatchRecord[0] = swatchName;
            swatchRecord[1] = swatchValue;
            swatchRecord[2] = swatchImg1;
            swatchRecord[4] = document.getElementById("swatch_link_" + entitledItemId + "_" + swatchValue).onclick;
            swatchRecord[5] = null;
            swatchRecord[6] = swatchDisplayValue;
            swatchList.push(swatchRecord);
            this.allSwatchesArrayList[entitledItemId] = swatchList;
        }
    },

    /**
     * Checks if a swatch is already exist in this.allSwatchesArray.
     * @param {String} swatchName The name of the swatch attribute.
     * @param {String} swatchValue The value of the swatch attribute.		
     * @return boolean Value indicating whether or not the specified swatch name and value exists in the allSwatchesArray.
     */
    existInAllSwatchsArray: function (swatchName, swatchValue, swatchList) {
        for (var i = 0; i < swatchList.length; i++) {
            var attrName = swatchList[i][0];
            var attrValue = swatchList[i][1];
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
    makeDefaultSwatchSelection: function (entitledItemId, doNotDisable) {
        if (this.entitledItems.length == 0) {
            if ($("#" + entitledItemId).length) {
                entitledItemJSON = eval('(' + $("#" + entitledItemId).html() + ')');
            }
            this.setEntitledItems(entitledItemJSON);
        }

        // need to make selection for every single swatch
        for (x in this.entitledItems) {
            var Attributes = this.entitledItems[x].Attributes;
            for (y in Attributes) {
                var index = y.indexOf("_|_");
                var swatchName = y.substring(0, index);
                var swatchValue = y.substring(index + 3);
                this.makeSwatchSelection(swatchName, swatchValue, entitledItemId, doNotDisable, null, imageField);
            }
            break;
        }
    },

    /**
     * Update swatch images - this is called after selection of a swatch is made, and this function checks for
     * entitlement and disable swatches that are not available
     * @param selectedAttrName The attribute that is selected
     * @param {String} entitledItemId The ID of the SKU.
     * @param {String} doNotDisable The name of the swatch attribute that should never be disabled.	
     **/
    updateSwatchImages: function (selectedAttrName, entitledItemId, doNotDisable, imageField) {
        var swatchToUpdate = [];
        var selectedAttributes = this.selectedAttributesList[entitledItemId];
        var selectedAttrValue = selectedAttributes[selectedAttrName];
        var swatchList = this.allSwatchesArrayList[entitledItemId];

        // finds out which swatch needs to be updated, add to swatchToUpdate array
        for (var i = 0; i < swatchList.length; i++) {
            var attrName = swatchList[i][0];
            var attrValue = swatchList[i][1];
            var attrImg1 = swatchList[i][2];
            var attrImg2 = swatchList[i][3];
            var attrOnclick = swatchList[i][4];
            var attrDisplayValue = swatchList[i][6];

            if (attrName != doNotDisable && attrName != selectedAttrName) {
                var swatchRecord = [];
                swatchRecord[0] = attrName;
                swatchRecord[1] = attrValue;
                swatchRecord[2] = attrImg1;
                swatchRecord[4] = attrOnclick;
                swatchRecord[5] = false;
                swatchRecord[6] = attrDisplayValue;
                swatchToUpdate.push(swatchRecord);
            }
        }

        // finds out which swatch is entitled, if it is, image should be set to enabled
        // go through entitledItems array and find out swatches that are entitled 
        for (x in this.entitledItems) {
            var Attributes = this.entitledItems[x].Attributes;

            for (y in Attributes) {
                var index = y.indexOf("_|_");
                var entitledSwatchName = y.substring(0, index);
                var entitledSwatchValue = y.substring(index + 3);

                //the current entitled item has the selected attribute value
                if (entitledSwatchName == selectedAttrName && entitledSwatchValue == selectedAttrValue) {
                    //go through the other attributes that are available to the selected attribute
                    //exclude the one that is selected
                    for (z in Attributes) {
                        var index2 = z.indexOf("_|_");
                        var entitledSwatchName2 = z.substring(0, index2);
                        var entitledSwatchValue2 = z.substring(index2 + 3);

                        if (y != z) { //only check the attributes that are not the one selected
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
                if (document.getElementById("swatch_" + entitledItemId + "_" + swatchToUpdateValue).className != "color_swatch_selected") {
                    var swatchElement = document.getElementById("swatch_" + entitledItemId + "_" + swatchToUpdateValue);
                    swatchElement.className = "color_swatch";
                    swatchElement.src = swatchElement.src.replace("_disabled.png", "_enabled.png");

                    //change the title text of the swatch link
                    document.getElementById("swatch_link_" + entitledItemId + "_" + swatchToUpdateValue).title = swatchElement.alt;
                }
                document.getElementById("swatch_link_" + entitledItemId + "_" + swatchToUpdateValue).setAttribute("aria-disabled", "false");
                document.getElementById("swatch_link_" + entitledItemId + "_" + swatchToUpdateValue).onclick = swatchToUpdateOnclick;
            } else {
                if (swatchToUpdateName != doNotDisable) {
                    var swatchElement = document.getElementById("swatch_" + entitledItemId + "_" + swatchToUpdateValue);
                    var swatchLinkElement = document.getElementById("swatch_link_" + entitledItemId + "_" + swatchToUpdateValue);
                    swatchElement.className = "color_swatch_disabled";
                    swatchLinkElement.onclick = null;
                    swatchElement.src = swatchElement.src.replace("_enabled.png", "_disabled.png");

                    //change the title text of the swatch link

                    var titleText = Utils.getLocalizationMessage("INV_ATTR_UNAVAILABLE", [swatchElement.alt]);

                    document.getElementById("swatch_link_" + entitledItemId + "_" + swatchToUpdateValue).setAttribute("aria-disabled", "true");

                    //The previously selected attribute is now unavailable for the new selection
                    //Need to switch the selection to an available value
                    if (selectedAttributes[swatchToUpdateName] == swatchToUpdateValue) {
                        disabledAttributes.push(swatchToUpdate[i]);
                    }
                }
            }
        }

        //If there were any previously selected attributes that are now unavailable
        //Find another available value for that attribute and update other attributes according to the new selection
        for (i in disabledAttributes) {
            var disabledAttributeName = disabledAttributes[i][0];
            var disabledAttributeValue = disabledAttributes[i][1];

            for (i in swatchToUpdate) {
                var swatchToUpdateName = swatchToUpdate[i][0];
                var swatchToUpdateValue = swatchToUpdate[i][1];
                var swatchToUpdateDisplayValue = swatchToUpdate[i][6];
                var swatchToUpdateEnabled = swatchToUpdate[i][5];

                if (swatchToUpdateName == disabledAttributeName && swatchToUpdateValue != disabledAttributeValue && swatchToUpdateEnabled) {
                    this.makeSwatchSelection(swatchToUpdateName, swatchToUpdateValue, entitledItemId, doNotDisable, swatchToUpdateDisplayValue, imageField);
                    break;
                }
            }
        }
    },
    /* SwatchCode end */

    /**
     * This function is used to change the price displayed in the Product Display Page on change of  a attribute of the product using an AJAX call. 
     * This function will resolve the catentryId using entitledItemId and displays the price of the catentryId.
     *				
     * @param {Object} entitledItemId A DIV containing a JSON object which holds information about a catalog entry. You can reference CachedProductOnlyDisplay.jsp to see how that div is constructed.
     * @param {Boolean} isPopup If the value is true, then this implies that the function was called from a quick info pop-up.
     * @param {Boolean} displayPriceRange If the value is true, then display the price range. If it is false then donot display the price range.
     *
     **/
    changePrice: function (entitledItemId, isPopup, displayPriceRange, productId) {
        this.displayPriceRange = displayPriceRange;
        this.isPopup = isPopup;
        var entitledItemJSON;

        if ($("#" + entitledItemId).length && !this.isPopup) {
            //the json object for entitled items are already in the HTML. 
            entitledItemJSON = eval('(' + $("#" + entitledItemId).html() + ')');
        } else {
            //if $("#"+ entitledItemId).length is 0, that means there's no <div> in the HTML that contains the JSON object. 
            //in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
            entitledItemJSON = this.getEntitledItemJsonObject();
        }
        var catalogEntryId = null;
        this.setEntitledItems(entitledItemJSON);

        if (this.selectedProducts[productId]) {
            var catalogEntryId = this.getCatalogEntryIdforProduct(this.selectedProducts[productId]);
        } else {
            var catalogEntryId = this.getCatalogEntryId(entitledItemId);
        }

        if (catalogEntryId != null) {
            //check if the json object is already present for the catEntry.
            if (this.itemPriceJsonOject[catalogEntryId] != null && this.itemPriceJsonOject[catalogEntryId] != 'undefined') {
                this.displayPrice(this.itemPriceJsonOject[catalogEntryId].catalogEntry, productId);
                console.debug("ShoppingActions.changePrice: using stored json object.");
            }
            //if json object is not present, call the service to get the details.
            else {
                var parameters = {
                    storeId: this.storeId,
                    langId: this.langId,
                    catalogId: this.catalogId,
                    catalogEntryId: catalogEntryId,
                    productId: productId
                };

                //Declare a service for retrieving catalog entry detailed information for an item...
                wcService.declare({
                    id: "getCatalogEntryDetailsSA",
                    actionId: "getCatalogEntryDetailsSA",
                    url: getAbsoluteURL() + appendWcCommonRequestParameters("GetCatalogEntryDetailsByIDView"),
                    formId: ""

                    ,
                    successHandler: function (serviceResponse, ioArgs) {
                        shoppingActionsJS.displayPriceServiceResponse(serviceResponse, ioArgs);
                    }

                    ,
                    failureHandler: function (serviceResponse, ioArgs) {
                        console.debug("ShoppingActions.changePrice: Unexpected error occurred during an xhrPost request.");
                    }

                });
                wcService.invoke("getCatalogEntryDetailsSA", parameters);
            }
        } else {
            console.debug("ShoppingActions.changePrice: all attributes are not selected.");
        }

    },

    /** 
     * Displays price of the catEntry selected with the JSON objrct returned from the server.
     * 
     * @param {object} serviceRepsonse The JSON response from the service.
     * @param {object} ioArgs The arguments from the service call.
     */
    displayPriceServiceResponse: function (serviceResponse, ioArgs) {
        var productId = ioArgs.productId;
        //stores the json object, so that the service is not called when same catEntry is selected.
        shoppingActionsJS.itemPriceJsonOject[serviceResponse.catalogEntry.catalogEntryIdentifier.uniqueID] = serviceResponse;

        shoppingActionsJS.displayPrice(serviceResponse.catalogEntry, productId);
    },

    /** 
     * Displays price of the attribute selected with the JSON oject.
     * 
     * @param {object} catEntry The JSON object with catalog entry details.
     */
    displayPrice: function (catEntry, productId) {

        var tempString;
        var popup = shoppingActionsJS.isPopup;

        if (popup == true) {
            $("#productPrice").html(catEntry.offerPrice);
            document.getElementById('productName').innerHTML = catEntry.description[0].name;
            document.getElementById('productSKUValue').innerHTML = catEntry.catalogEntryIdentifier.externalIdentifier.partNumber;
        }

        if (popup == false) {
            var innerHTML = "";
            var listPrice = Utils.parseNumber(catEntry.listPrice);
            var offerPrice = Utils.parseNumber(catEntry.offerPrice);

            this.setPriceInProductList(productId, offerPrice);

            if (!catEntry.listPriced || listPrice <= offerPrice) {
                innerHTML = "<span id='offerPrice_" + catEntry.catalogEntryIdentifier.uniqueID + "' class='price'>" + catEntry.offerPrice + "</span>";
            } else {
                innerHTML = "<span id='listPrice_" + catEntry.catalogEntryIdentifier.uniqueID + "' class='old_price'>" + catEntry.listPrice + "</span>" +
                    "<span id='offerPrice_" + catEntry.catalogEntryIdentifier.uniqueID + "' class='price'>" + catEntry.offerPrice + "</span>";
            }
            document.getElementById('price_display_' + productId).innerHTML = innerHTML + "<input type='hidden' id='ProductInfoPrice_" + catEntry.catalogEntryIdentifier.uniqueID + "' value='" + catEntry.offerPrice + "'/>";

            innerHTML = "";
            if (shoppingActionsJS.displayPriceRange == true) {
                for (var i in catEntry.priceRange) {
                    if (catEntry.priceRange[i].endingNumberOfUnits == catEntry.priceRange[i].startingNumberOfUnits) {
                        tempString = Utils.getLocalizationMessage('PQ_PRICE_X', {
                            0: catEntry.priceRange[i].startingNumberOfUnits
                        });
                        innerHTML = innerHTML + "<p>" + tempString;
                    } else if (catEntry.priceRange[i].endingNumberOfUnits != 'null') {
                        tempString = Utils.getLocalizationMessage('PQ_PRICE_X_TO_Y', {
                            0: catEntry.priceRange[i].startingNumberOfUnits,
                            1: catEntry.priceRange[i].endingNumberOfUnits
                        });
                        innerHTML = innerHTML + "<p>" + tempString;
                    } else {
                        tempString = Utils.getLocalizationMessage('PQ_PRICE_X_OR_MORE', {
                            0: catEntry.priceRange[i].startingNumberOfUnits
                        });
                        innerHTML = innerHTML + "<p>" + tempString;
                    }
                    innerHTML = innerHTML + " <span class='price'>" + catEntry.priceRange[i].localizedPrice + "</span></p>";
                }
            }
            // Append productId so that element is unique in bundle page, where there can be multiple components
            var quantityDiscount = document.getElementById("productLevelPriceRange_" + productId);
            var itemQuantityDiscount = document.getElementById("itemLevelPriceRange_" + productId);

            // if product level price exists and no section to update item level price
            if (null != quantityDiscount && null == itemQuantityDiscount) {
                quantityDiscount.style.display = ""; //display product level price range
            }
            // if item level price range is present
            else if ("" != innerHTML && null != itemQuantityDiscount) {
                innerHTML = Utils.getLocalizationMessage('PQ_PURCHASE') + innerHTML;
                itemQuantityDiscount.innerHTML = innerHTML;
                itemQuantityDiscount.style.display = "";
                // hide the product level price range
                if (null != quantityDiscount) {
                    quantityDiscount.style.display = "none";
                }
            }
            // if item level price range is not present
            else if ("" == innerHTML) {
                if (null != itemQuantityDiscount) {
                    itemQuantityDiscount.style.display = "none"; //hide item level price range
                }
                if (null != quantityDiscount) {
                    quantityDiscount.style.display = ""; //display product level price range
                }
            }

            /*
             * If the product name is a link, do not replace the link only replace the text in the link.
             * Otherwise, replace the whole text
             */
            var productNameLink = $('#product_name_' + productId + ' > a');
            if (productNameLink.length == 1) {
                $(productNameLink[0]).html(catEntry.description[0].name);
            } else if ($('#product_name_' + productId)) {
                $('#product_name_' + productId).html(catEntry.description[0].name);
            }

            if ($("#widget_product_info_viewer > div[id^='PageHeading_']").length) {
                $("#widget_product_info_viewer > div[id^='PageHeading_']").each(function (i, node) {
                    if (node.childNodes != null && node.childNodes.length == 3) {
                        node.childNodes[1].innerHTML = catEntry.description[0].name;
                    }
                });
            }
            if (document.getElementById("ProductInfoName_" + productId) != null) {
                document.getElementById("ProductInfoName_" + productId).value = catEntry.description[0].name;
            }
            if (document.getElementById('product_shortdescription_' + productId)) {
                document.getElementById('product_shortdescription_' + productId).innerHTML = catEntry.description[0].shortDescription;
            }
            if (document.getElementById('product_SKU_' + productId)) {
                document.getElementById('product_SKU_' + productId).innerHTML = Utils.getLocalizationMessage('SKU') + " " + catEntry.catalogEntryIdentifier.externalIdentifier.partNumber;
            }
        }
    },

    /**
     *This method will show the WC Dialog popup
     *@param{String} widgetId The ID of the WC Dialog which should be shown
     */
    showWCDialogPopup: function (widgetId) {
        var dialog = $("#" + widgetId).data("wc-WCDialog");
        if (dialog) {
            dialog.open();
            $("#" + widgetId).css("display", "block");
        } else {
            console.debug(widgetId + " does not exist");
        }
    },

    /**
     * To notify the change in attribute to other components that is subscribed to DefiningAttributes_Resolved_[productId] event.
     */
    notifyAttributeChange: function (catalogEntryID) {
        this.baseCatalogEntryId = catalogEntryID;
        var selectedAttributes = this.selectedAttributesList["entitledItem_" + catalogEntryID];
        wcTopic.publish('DefiningAttributes_Resolved_' + catalogEntryID, catalogEntryID, -1);
    },

    /**
     * To notify the change in quantity to other components that is subscribed to Quantity_Changed event.
     */
    notifyQuantityChange: function (quantity) {
        wcTopic.publish("Quantity_Changed", quantity);
    },

    /**
     * Initializes the compare check box for all the products added to compare.
     */
    initCompare: function (fromPage) {
        if (fromPage == 'compare' || fromPage == 'catalogEntryList') {
            this.checkForCompare();
        } else {
            var cookieKey = this.cookieKeyPrefix + this.storeId;
            var newCookieValue = "";
            setCookie(cookieKey, newCookieValue, {
                path: '/',
                domain: cookieDomain
            });
        }

    },

    /**
     * Change the compare box status to checked or unchecked
     * @param{String} cbox The ID of the compare check box of the given catentry identifier.
     * @param{String} catEntryIdentifier The catalog entry identifer to current product.
     */
    changeCompareBox: function (cbox, catEntryIdentifier) {
        box = document.getElementById(cbox);
        box.checked = !box.checked;
        this.addOrRemoveFromCompare(catEntryIdentifier, box.checked);
    },

    /**
     * Adds or removes the product from the compare depending on the compare box checked or unchecked.
     * @param{String} catEntryIdentifier The catalog entry identifer to current product.
     * @param{boolean} checked True if the checkbox is checked or False
     */
    addOrRemoveFromCompare: function (catEntryIdentifier, checked) {
        //box = eval(cbox);
        if (checked) {
            this.addToCompare(catEntryIdentifier);
        } else {
            this.removeFromCompare(catEntryIdentifier);
        }
    },

    /**
     * Adds the product to the compare cookie.
     * @param{String} catEntryIdentifier The catalog entry identifer to current product.
     */
    addToCompare: function (catEntryIdentifier) {

        var cookieKey = this.cookieKeyPrefix + this.storeId;
        var cookieValue = getCookie(cookieKey);

        if (cookieValue != null) {
            if (cookieValue.indexOf(catEntryIdentifier) != -1 || catEntryIdentifier == null) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage("COMPARE_ITEM_EXISTS"));
                return;
            }
        }

        var currentNumberOfItemsInCompare = 0;
        if (cookieValue != null && cookieValue !== "") {
            currentNumberOfItemsInCompare = cookieValue.split(this.cookieDelimiter).length;
        }

        if (currentNumberOfItemsInCompare < parseInt(this.maxNumberProductsAllowedToCompare)) {
            var newCookieValue = "";
            if (cookieValue == null || cookieValue === "") {
                newCookieValue = catEntryIdentifier;
            } else {
                newCookieValue = cookieValue + this.cookieDelimiter + catEntryIdentifier;
            }
            setCookie(cookieKey, newCookieValue, {
                path: '/',
                domain: cookieDomain
            });
            shoppingActionsJS.checkForCompare();
        } else {
            this.showWCDialogPopup('widget_product_comparison_popup');
            document.getElementById("comparebox_" + catEntryIdentifier).checked = false;
            console.debug("You can only compare up to 4 products");
        }
    },

    /**
     * Removes the product from the compare cookie.
     * @param{String} catEntryIdentifier The catalog entry identifer to current product.
     */
    removeFromCompare: function (catEntryIdentifier) {
        var cookieKey = this.cookieKeyPrefix + this.storeId;
        var cookieValue = getCookie(cookieKey);
        var currentNumberOfItemsInCompare = 0;
        if (cookieValue != null) {
            if (cookieValue.trim() == "") {
                setCookie(cookieKey, null, {
                    expires: -1
                });
            } else {
                var cookieArray = cookieValue.split(this.cookieDelimiter);
                var newCookieValue = "";
                for (index in cookieArray) {
                    if (cookieArray[index] != catEntryIdentifier) {
                        if (newCookieValue === "") {
                            newCookieValue = cookieArray[index];
                        } else {
                            newCookieValue = newCookieValue + this.cookieDelimiter + cookieArray[index];
                        }
                    }
                }
                setCookie(cookieKey, newCookieValue, {
                    path: '/',
                    domain: cookieDomain
                });
                currentNumberOfItemsInCompare = newCookieValue.split(this.cookieDelimiter).length;
            }
            shoppingActionsJS.checkForCompare();
        }
    },

    /**
     * Re-directs the browser to the CompareProductsDisplay page to compare products side-by-side.
     */
    compareProducts: function (categoryIds, manufacturer) {
        var url = appendWcCommonRequestParameters("CompareProductsDisplayView?storeId=" + this.storeId + "&catalogId=" + this.catalogId + "&langId=" + this.langId + "&compareReturnName=" + encodeURIComponent(this.compareReturnName) + "&searchTerm=" + this.searchTerm);
        if ('' != categoryIds.top_category) {
            url = url + "&top_category=" + categoryIds.top_category;
        }
        if ('' != categoryIds.parent_category_rn) {
            url = url + "&parent_category_rn=" + categoryIds.parent_category_rn;
        }
        if ('' != categoryIds.categoryId) {
            url = url + "&categoryId=" + categoryIds.categoryId;
        }
		if (manufacturer != undefined && '' != manufacturer) {
			url = url + "&manufacturer=" + manufacturer;
		}
		
        var cookieKey = this.cookieKeyPrefix + this.storeId;
        var cookieValue = getCookie(cookieKey);
        if (cookieValue != null && cookieValue.trim() != "") {
            url = url + "&catentryId=" + cookieValue;
        }
        var returnUrl = appendWcCommonRequestParameters(location.href);
        if (returnUrl.indexOf("?") === -1) {
            returnUrl = returnUrl + "?fromPage=compare";
        } else if (returnUrl.indexOf("fromPage=compare") === -1) {
            returnUrl = returnUrl + "&fromPage=compare";
        }
        url = url + "&returnUrl=" + encodeURIComponent(returnUrl);
        location.href = getAbsoluteURL() + url;
    },

    /**
     * Sets the quantity of a product in the list (bundle)
     * 
     * @param {String} catalogEntryType, type of catalogEntry (item/product/bundle/package)
     * @param {int} catalogEntryId The catalog entry identifer to current product.
     * @param {int} quantity The quantity of current product.
     * @param {float} price The price of current product.
     */
    setProductQuantity: function (catalogEntryType, catalogEntryId, quantity, price) {
        var productDetails = null;
        if (this.productList[catalogEntryId]) {
            productDetails = this.productList[catalogEntryId];
        } else {
            productDetails = {};
            this.productList[catalogEntryId] = productDetails;
            productDetails.baseItemId = catalogEntryId;
            if ("item" == catalogEntryType) {
                productDetails.id = catalogEntryId;
            } else {
                productDetails.id = 0;
            }
        }
        productDetails.quantity = quantity;
        wcTopic.publish("Quantity_Changed", JSON.stringify(productDetails));
        productDetails.price = Utils.parseNumber(price);
    },

    /**
     * Sets the quantity of a product in the list (bundle)
     * 
     * @param {int} catalogEntryId The catalog entry identifer to current product.
     * @param {int} quantity The quantity of current product.
     */
    quantityChanged: function (catalogEntryId, quantity) {
        if (this.productList[catalogEntryId]) {
            var productDetails = this.productList[catalogEntryId];
            productDetails.quantity = quantity.trim();
            wcTopic.publish("Quantity_Changed", JSON.stringify(productDetails));

            //Update quantity for catentries in the merchandising association array
            if (MerchandisingAssociationJS != null) {
                if (MerchandisingAssociationJS.baseItemParams != null) {
                    if (MerchandisingAssociationJS.baseItemParams.type == 'BundleBean') {
                        // Update items in the bundle
                        for (idx = 0; idx < MerchandisingAssociationJS.baseItemParams.components.length; idx++) {
                            if (catalogEntryId == MerchandisingAssociationJS.baseItemParams.components[idx].productId || catalogEntryId == MerchandisingAssociationJS.baseItemParams.components[idx].id) {
                                MerchandisingAssociationJS.baseItemParams.components[idx].quantity = productDetails.quantity;
                            }
                        }
                    }
                }
            }
        }
    },

    /**
     * Sets the price of a product in the list (bundle)
     * 
     * @param {int} catalogEntryId The catalog entry identifer to current product.
     * @param {int} price The price of current product.
     */
    setPriceInProductList: function (catalogEntryId, price) {
        var productDetails = this.productList[catalogEntryId];
        if (productDetails) {
            productDetails.price = price;
        }
    },

    /**
     * Select bundle item swatch
     * 
     * @param {int} catalogEntryId The catalog entry identifer to current product.
     * @param {String} swatchName
     * @param {String} swatchValue
     * @param {String} doNotDisable, the first swatch, that should not be disabled
     */
    selectBundleItemSwatch: function (catalogEntryId, swatchName, swatchValue, doNotDisable) {
        if ($("#swatch_" + catalogEntryId + "_" + swatchName + "_" + swatchValue).hasClass("color_swatch_disabled")) {
            return;
        }
        if ($("#entitledItem_" + catalogEntryId).length) {
            var entitledItemJSON;
            var currentSwatchkey = swatchName + "_" + swatchValue;
            //the json object for entitled items are already in the HTML. 
            entitledItemJSON = JSON.stringify($("#entitledItem_" + catalogEntryId).html());
            var validSwatchArr = [];
            for (idx in entitledItemJSON) {
                var validItem = false;
                var entitledItem = entitledItemJSON[idx];
                for (attribute in entitledItem.Attributes) {

                    if (currentSwatchkey == attribute) {
                        validItem = true;
                        break;
                    }
                }
                if (validItem) {
                    for (attribute in entitledItem.Attributes) {
                        var currentSwatch = attribute.substring(0, attribute.lastIndexOf("_|_"));
                        if (currentSwatch != doNotDisable && currentSwatch != swatchName) {
                            validSwatchArr.push(attribute);
                        }
                    }
                }
            }

            var swatchesDisabled = [];
            var selectedSwatches = [];
            for (idx in entitledItemJSON) {
                var entitledItem = entitledItemJSON[idx];
                for (attribute in entitledItem.Attributes) {
                    var currentSwatch = attribute.substring(0, attribute.lastIndexOf("_|_"));
                    if (currentSwatch != doNotDisable && currentSwatch != swatchName) {
                        var swatchId = "swatch_" + catalogEntryId + "_" + attribute;
                        var swatchLinkId = swatchId.replace("swatch_", "swatch_link_");
                        if (validSwatchArr.indexOf(attribute) > -1) {
                            if (!$("#" + swatchId).hasClass("color_swatch_selected")) {
                                document.getElementById(swatchId).className = "color_swatch";
                                document.getElementById(swatchId).src = document.getElementById(swatchId).src.replace("_disabled.png", "_enabled.png");

                                //change the title text of the swatch link
                                document.getElementById(swatchLinkId).title = document.getElementById(swatchId).alt;
                                document.getElementById(swatchLinkId).setAttribute("aria-disabled", "false");
                            }
                        } else if (swatchesDisabled.indexOf(attribute) === -1) {
                            swatchesDisabled.push(attribute);
                            if ($("#" + swatchId).hasClass("color_swatch_selected")) {
                                selectedSwatches.push(swatchId);
                            }
                            document.getElementById(swatchId).className = "color_swatch_disabled";
                            document.getElementById(swatchId).src = document.getElementById(swatchId).src.replace("_enabled.png", "_disabled.png");

                            //change the title text of the swatch link
			    
			    var altText = document.getElementById(swatchId).alt;
                            var titleText = Utils.getLocalizationMessage("INV_ATTR_UNAVAILABLE", [altText]);
                            

                           
                            $("#" + swatchLinkId).attr("aria-disabled", "true");
                        }
                    }
                    if (document.getElementById("swatch_link_" + catalogEntryId + "_" + attribute) != null) {
                        document.getElementById("swatch_link_" + catalogEntryId + "_" + attribute).setAttribute("aria-checked", "false");
                    }
                }
            }

            for (idx in selectedSwatches) {
                var selectedSwatch = selectedSwatches[idx];
                var idSelector = selectedSwatch.substring(0, selectedSwatch.lastIndexOf("_|_"));
                var swatchSelected = false;
                $("[id^='" + idSelector + "']").each(function (index, node, arr) {
                    if (!swatchSelected && $(node).hasClass("color_swatch")) {
                        var values = node.id.split("_");
                        shoppingActionsJS.selectBundleItemSwatch(values[1], values[2], values[3], doNotDisable);
                        shoppingActionsJS.setSelectedAttributeOfProduct(values[1], values[2], values[3], false);
                        swatchSelected = true;
                    }
                });
            }
        }

        if ($("#swatch_selection_" + catalogEntryId + "_" + swatchName).css("display") == ("none")) {
            $("#swatch_selection_" + catalogEntryId + "_" + swatchName).css("display", "inline");
        }
        $("#swatch_selection_" + catalogEntryId + "_" + swatchName).html(swatchValue);

        var swatchItem = "swatch_" + catalogEntryId + "_" + swatchName + "_";
        var swatchItemLink = "swatch_link_" + catalogEntryId + "_" + swatchName + "_";

        $("img[id^='" + swatchItem + "']").each(function (index, node, arr) {
            if ($(node).hasClass("color_swatch_disabled")) {
                $(node).removeClass("color_swatch")
            } else {
                $(node).addClass("color_swatch");
            }
            $(node).removeClass("color_swatch_selected");
        });

        $("#" + swatchItem + swatchValue).attr("className", "color_swatch_selected");
        document.getElementById(swatchItemLink + swatchValue).setAttribute("aria-checked", "true");

        this.setSelectedAttributeOfProduct(catalogEntryId, swatchName, swatchValue, false);
        // select image
        this.changeBundleItemImage(catalogEntryId, swatchName, swatchValue, "productThumbNailImage_" + catalogEntryId);

    },

    changeBundleItemImage: function (catalogEntryId, swatchAttrName, swatchAttrValue, skuImageId) {
        var entitledItemId = "entitledItem_" + catalogEntryId;
        if ($("#" + entitledItemId).length) {
            //the json object for entitled items are already in the HTML. 
            entitledItemJSON = eval('(' + $("#" + entitledItemId).html() + ')');
        }

        this.setEntitledItems(entitledItemJSON);

        var skuImage = null;
        var imageArr = shoppingActionsJS.getImageForBundleItem(catalogEntryId);
        if (imageArr != null) {
            skuImage = imageArr[1];
        }

        if (skuImageId != undefined) {
            this.setSKUImageId(skuImageId);
        }

        if (skuImage != null) {
            if ($("#" + this.skuImageId) != null) {
                document.getElementById(this.skuImageId).src = skuImage;
                if (document.getElementById("ProductInfoImage_" + catalogEntryId) != null) {
                    document.getElementById("ProductInfoImage_" + catalogEntryId).value = skuImage;
                }
            }
        } else {
            var imageFound = false;
            for (x in this.entitledItems) {
                var Attributes = this.entitledItems[x].Attributes;
                var itemImage = this.entitledItems[x].ItemThumbnailImage;

                for (y in Attributes) {
                    var index = y.indexOf("_|_");
                    var entitledSwatchName = y.substring(0, index);
                    var entitledSwatchValue = y.substring(index + 3);

                    if (entitledSwatchName == swatchAttrName && entitledSwatchValue == swatchAttrValue) {
                        document.getElementById(this.skuImageId).src = itemImage;
                        if (document.getElementById("ProductInfoImage_" + catalogEntryId) != null) {
                            document.getElementById("ProductInfoImage_" + catalogEntryId).value = itemImage;
                        }
                        imageFound = true;
                        break;
                    }
                }

                if (imageFound) {
                    break;
                }
            }
        }
    },

    getImageForBundleItem: function (entitledItemId) {
        var attributeArray = [];
        var selectedAttributes = this.selectedProducts[entitledItemId];
        for (attribute in selectedAttributes) {
            attributeArray.push(attribute + "_|_" + selectedAttributes[attribute]);
        }
        return this.resolveImageForSKU(attributeArray);
    },

    /**
     * Check if any product is already selected for compare in other pages and select them
     */
    checkForCompare: function () {
        var cookieValues = getCookie(shoppingActionsJS.cookieKeyPrefix + shoppingActionsJS.storeId);
        cookieValues = (cookieValues ? cookieValues.split(shoppingActionsJS.cookieDelimiter) : []);
        var labels = $(".compareCheckboxLabels > label");
        $(".compare_target").each(function (i, div) {
            var checkbox = $("input[type=\"checkbox\"]", div)[0];
            checkbox.checked = (cookieValues.indexOf(checkbox.value) !== -1);
            var state = (checkbox.checked ? (cookieValues.length > 1 ? 2 : 1) : 0);
            div.setAttribute("data-state", state.toString());
            var label = $("label[for=\"" + checkbox.id + "\"]", div)[0];
            $(label).html($(labels[state]).html());
        });
    },

    /**
     * replaceItemAjaxHelper This function is used to replace an item in the cart. This will be called from the {@link this.ReplaceItemAjax} method.
     *
     * @param {String} catalogEntryId The catalog entry of the item to replace to the cart.
     * @param {int} qty The quantity of the item to add.
     * @param {String} removeOrderItemId The order item ID of the catalog entry to remove from the cart.
     * @param {String} addressId The address ID of the order item.
     * @param {String} shipModeId The shipModeId of the order item.
     * @param {String} physicalStoreId The physicalStoreId of the order item.
     *
     **/
    replaceItemAjaxHelper: function (catalogEntryId, qty, removeOrderItemId, addressId, shipModeId, physicalStoreId) {

        var params = {
            storeId: WCParamJS.storeId,
            catalogId: WCParamJS.catalogId,
            langId: WCParamJS.langId,
            orderItemId: removeOrderItemId,
            orderId: "."
        };
        if (CheckoutHelperJS.shoppingCartPage) {
            params.calculationUsage = "-1,-2,-5,-6,-7";
        } else {
            params.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
        }

        var params2 = {
            storeId: WCParamJS.storeId,
            catalogId: WCParamJS.catalogId,
            langId: WCParamJS.langId,
            catEntryId: catalogEntryId,
            quantity: qty,
            orderId: ".",
	    calculateOrder: "1"
        };
        if (CheckoutHelperJS.shoppingCartPage) {
            params2.calculationUsage = "-1,-2,-5,-6,-7";
        } else {
            params2.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
        }

        var params3 = {
            storeId: WCParamJS.storeId,
            catalogId: WCParamJS.catalogId,
            langId: WCParamJS.langId,
            orderId: "."
        };
        if (CheckoutHelperJS.shoppingCartPage) {
            params3.calculationUsage = "-1,-2,-5,-6,-7";
        } else {
            params3.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
        }

        var shipInfoUpdateNeeded = false;
        var orderItemReqd = true;
        if (addressId != null && addressId !== "") {
            params3.addressId = addressId;
        }
        if (shipModeId != null && shipModeId !== "") {
            params3.shipModeId = shipModeId;
        }
        if (physicalStoreId != null && physicalStoreId !== "") {
            params3.physicalStoreId = physicalStoreId;
            orderItemReqd = false;
        }
        if (params3.shipModeId != null && (params3.addressId != null || params3.physicalStoreId != null)) {
            shipInfoUpdateNeeded = true;
        }

        if (orderItemReqd) {
            params3.allocate = "***";
            params3.backorder = "***";
            params3.remerge = "***";
            params3.check = "*n";
        }

        //Delcare service for deleting item...
        wcService.declare({
            id: "AjaxReplaceItem",
            actionId: "AjaxReplaceItem",
            url: "AjaxRESTOrderItemDelete",
            formId: ""

            ,
            successHandler: function (serviceResponse) {
                //Now add the new item to cart..
                if (!shipInfoUpdateNeeded) {
                    //We dont plan to update addressId and shipMOdeId..so call AjaxAddOrderItem..
                    wcService.invoke("AjaxAddOrderItem", params2);
                } else {
                    //We need to update the adderessId and shipModeId..so call our temp service to add..
                    wcService.invoke("AjaxAddOrderItemTemp", params2);
                }
            }

            ,
            failureHandler: function (serviceResponse) {
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

            ,
            successHandler: function (serviceResponse) {
                // setting the newly created orderItemId
                params3.orderItemId = (serviceResponse.orderItem != null && serviceResponse.orderItem[0].orderItemId != null) ? serviceResponse.orderItem[0].orderItemId : serviceResponse.orderItemId;

                MessageHelper.displayStatusMessage(MessageHelper.messages["SHOPCART_ADDED"]);

                //Now item is added.. call update to set addressId and shipModeId...
                wcService.invoke("OrderItemAddressShipMethodUpdate", params3);
            }

            ,
            failureHandler: function (serviceResponse) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
            }
        });

        //For Handling multiple clicks
        if (!submitRequest()) {
            return;
        }
        cursor_wait();
        wcService.invoke("AjaxReplaceItem", params);
    },

    /**
     * customizeDynamicKit This function is used to call the configurator page for a dynamic kit.
     * @param {String} catEntryIdentifier A catalog entry ID of the item to add to the cart.
     * @param {int} quantity A quantity of the item to add to the cart.
     * @param {Object} customParams - Any additional parameters that needs to be passed to the configurator page.
     *
     **/
    customizeDynamicKit: function (catEntryIdentifier, quantity, customParams) {
        var params = {
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            catEntryId: catEntryIdentifier,
            quantity: quantity
        };

        if (!isPositiveInteger(quantity)) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
            return;
        }

        var contractIdElements = document.getElementsByName('contractSelectForm_contractId');
        if (contractIdElements != null && contractIdElements != "undefined") {
            for (i = 0; i < contractIdElements.length; i++) {
                if (contractIdElements[i].checked) {
                    params.contractId = contractIdElements[i].value;
                    break;
                }
            }
        }

        //Pass any other customParams set by other add on features
        if (customParams != null && customParams != 'undefined') {
            for (i in customParams) {
                params[i] = customParams[i];
            }
        }

        //For Handling multiple clicks
        if (!submitRequest()) {
            return;
        }
        cursor_wait();

        var configureURL = "ConfigureView";
        var i = 0;
        for (param in params) {
            configureURL += ((i++ == 0) ? "?" : "&") + param + "=" + params[param];
        }
        document.location.href = getAbsoluteURL() + appendWcCommonRequestParameters(configureURL);
    }

}

wcTopic.subscribe("ProductInfo_Reset", shoppingActionsJS.resetProductAddedList);

$(document).ready(function () {
    var ie_version = Utils.get_IE_version();
    if (ie_version < 9) {
        $(document).on("click", ".compare_target > input[type=\"checkbox\"]:click", function (event) {
            this.blur();
            this.focus();
        });
    }
});
