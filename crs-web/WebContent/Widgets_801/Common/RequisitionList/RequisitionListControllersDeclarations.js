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
 * @fileOverview This javascript is used by the Requisition List pages to control the refresh areas.
 * @version 1.2
 */

if (typeof (RequistionListControllerDeclarationJS) == "undefined" || RequistionListControllerDeclarationJS == null || !RequistionListControllerDeclarationJS) {

    RequistionListControllerDeclarationJS = {
        suffix: "",
        /**
         * Declares a new refresh controller for creating a new Requisition List.
         */
        declareRequisitionListItemTableRefreshArea: function () {
            var myWidgetObj = $("#RequisitionListItemTable_Widget"),


                myRCProperties = wcRenderContext.getRenderContextProperties("RequisitionListItemTable_Context");



            wcTopic.subscribe(["requisitionListAddItem", "requisitionListDeleteItem"], function (returnAction) {
                myRCProperties["requisitionListId"] = returnAction.data.requisitionListId[0];
                myWidgetObj.refreshWidget("refresh", myRCProperties);
            });


            var renderContextChangedHandler = function () {
                myWidgetObj.refreshWidget("refresh", myRCProperties);
            };

            /** 
             * Clears the progress bar
             * 
             * @param {object} widget The registered refresh area
             */
            var postRefreshHandler = function () {
                cursor_clear();
                //After adding/deleting/updating an item
                AutoSKUSuggestJS.autoSKUSuggest_controller_initProperties(RequistionListControllerDeclarationJS.suffix);
            };
            // initialize widget
            myWidgetObj.refreshWidget({
                renderContextChangedHandler: renderContextChangedHandler,
                postRefreshHandler: postRefreshHandler
            });
        }
    }
};
