//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the wish list pages to handle CRUD operations.
 * @version 1.0
 */

/**
 * This REST service allows customers to create a new shopping list
 * @constructor
 */
wcService.declare({
        id: "ShoppingListServiceCreate",
        actionId: "ShoppingListServiceCreate",
        url: getAbsoluteURL() + "AjaxRestWishListCreate",
        formId: ""

        /**
         * Hides all the messages and the progress bar.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
        ,
        successHandler: function (serviceResponse) {
            cursor_clear();
            closeAllDialogs(); //close the create popup

            wcTopic.publish("ShoppingList_Changed", {
                listId: serviceResponse.uniqueID,
                listName: serviceResponse.descriptionName,
                action: 'add'
            });




        }

        /**
         * display an error message.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
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
    }),

    /**
     * This REST service allows customers to update the name of a shopping list
     * @constructor
     */
    wcService.declare({
        id: "ShoppingListServiceUpdate",
        actionId: "ShoppingListServiceUpdate",
        url: getAbsoluteURL() + "AjaxRestWishListUpdate",
        formId: ""

        /**
         * Hides all the messages and the progress bar.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
        ,
        successHandler: function (serviceResponse) {
            cursor_clear();
            closeAllDialogs();
            shoppingListJS.showMessageDialog(Utils.getLocalizationMessage('LIST_EDITED'));

            wcTopic.publish("ShoppingList_Changed", {
                listId: serviceResponse.uniqueID,
                listName: serviceResponse.descriptionName,
                action: 'edit'
            });

        }

        /**
         * display an error message.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
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
    }),

    /**
     * This REST service allows customers to delete a selected shopping list
     * @constructor
     */
    wcService.declare({
        id: "ShoppingListServiceDelete",
        actionId: "ShoppingListServiceDelete",
        url: getAbsoluteURL() + "AjaxRestWishListDelete",
        formId: ""

        /**
         * Hides all the messages and the progress bar.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
        ,
        successHandler: function (serviceResponse) {
            cursor_clear();
            closeAllDialogs();
            shoppingListJS.showMessageDialog(Utils.getLocalizationMessage('LIST_DELETED'));

            wcTopic.publish("ShoppingList_Changed", {
                listId: serviceResponse.uniqueID,
                listName: '',
                action: 'delete'
            });

        }

        /**
         * display an error message.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
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
    }),

    /**
     * This REST service allows customers to add an item to a shopping list
     * @constructor
     */
    wcService.declare({
        id: "ShoppingListServiceAddItem",
        actionId: "ShoppingListServiceAddItem",
        url: getAbsoluteURL() + "AjaxRestWishListAddItem",
        formId: ""

        /**
         * Hides all the messages and the progress bar.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
        ,
        successHandler: function (serviceResponse) {
            cursor_clear();
            wcTopic.publish("ShoppingListItem_Added");
        }

        /**
         * display an error message.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
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
    }),

    /**
     * This REST service allows customers to remove an item from a shopping list
     * @constructor
     */
    wcService.declare({
        id: "ShoppingListServiceRemoveItem",
        actionId: "ShoppingListServiceRemoveItem",
        url: getAbsoluteURL() + "AjaxRestWishListRemoveItem",
        formId: ""

        /**
         * Hides all the messages and the progress bar.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
        ,
        successHandler: function (serviceResponse) {
            cursor_clear();
            MessageHelper.hideAndClearMessage();
            shoppingListJS.showMessageDialog(Utils.getLocalizationMessage('ITEM_REMOVED'));
        }

        /**
         * display an error message.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
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
    }),

    /**
     * This REST service allows customers to add an item to a shopping list and remove from the shopping cart
     * @constructor
     */
    wcService.declare({
        id: "ShoppingListServiceAddItemAndRemoveFromCart",
        actionId: "ShoppingListServiceAddItemAndRemoveFromCart",
        url: getAbsoluteURL() + "AjaxRestWishListAddItem",
        formId: ""

        /**
         * Hides all the messages and the progress bar.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
        ,
        successHandler: function (serviceResponse) {
            cursor_clear();
            wcTopic.publish("ShoppingListItem_Added");
        }

        /**
         * display an error message.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
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
    }),

    /**
     * This REST service allows customers to set a wish list as the default list
     * @constructor
     * 
     **/
    wcService.declare({
        id: "AjaxGiftListServiceChangeGiftListStatus",
        actionId: "AjaxGiftListServiceChangeGiftListStatus",
        url: getAbsoluteURL() + "AjaxRestWishListChangeState",
        formId: ""

        /**
         * Hides all the messages and the progress bar.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
        ,
        successHandler: function (serviceResponse) {
            cursor_clear();
            MessageHelper.hideAndClearMessage();

            //	MultipleWishLists.updateDefaultListName('multipleWishListButton',serviceResponse.descriptionName);		
            //	MultipleWishLists.updateDefaultListName('addToMultipleWishListLink',serviceResponse.descriptionName);
            MultipleWishLists.setDefaultListId(serviceResponse.uniqueID);
            MultipleWishLists.updateContextPostSwitch(serviceResponse.uniqueID);
        }

        /**
         * display an error message.
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation.
         */
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
    }),

    /**
     * This REST service sends the wish list to a specified email address.
     */
    wcService.declare({
        id: "AjaxGiftListAnnouncement",
        actionId: "AjaxGiftListAnnouncement",
        url: getAbsoluteURL() + "AjaxRESTWishListAnnounce",
        formId: ""

        /**
         * hides all the messages and the progress bar
         * @param (object) serviceResponse The service response object, which is the
         * JSON object returned by the service invocation
         */
        ,
        successHandler: function (serviceResponse) {
                cursor_clear();
                MessageHelper.hideAndClearMessage();
                shoppingListJS.showMessageDialog(Utils.getLocalizationMessage('WISHLIST_EMAIL_SENT'));
                $("#WishListEmailSucMsg_Div").css("display","block");
                //limit the recipient number of characters in To: email address of email success message to 25 characters 
                $("#recipientEmail_wishListDisplay").html(serviceResponse.recipient[0].substring(0, 25));
            }
            /**
             * display an error message
             * @param (object) serviceResponse The service response object, which is the
             * JSON object returned by the service invocation
             */
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

    })
