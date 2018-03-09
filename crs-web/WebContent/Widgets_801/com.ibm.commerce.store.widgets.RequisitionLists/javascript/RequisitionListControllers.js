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
 * Declares a new render context for creating a new list.
 */


/**
 * Declares a new refresh controller for creating a new List.
 */
function declareRequisitionListTableRefreshArea() {
    var myWidgetObj = $("#RequisitionListTable_Widget");
    wcRenderContext.declare("RequisitionListTable_Context", ["RequisitionListTable_Widget"], {
        "beginIndex": "0",
        "orderBy": ""
    }, "");




    var myRCProperties = wcRenderContext.getRenderContextProperties("RequisitionListTable_Context");


    var renderContextChangedHandler = function () {
        myWidgetObj.refreshWidget("refresh", myRCProperties);
    };
	   
    wcTopic.subscribe(['requisitionListCreate', 'AjaxRequisitionListDelete', 'requisitionListCopy'], function () {
        myWidgetObj.refreshWidget("refresh", myRCProperties);

    });

	/** 
     * Clears the progress bar*/

     var postRefreshHandler = function() {
		 cursor_clear();
		 
		 toggleMobileView();
	}
        // initialize widget
    myWidgetObj.refreshWidget({
        renderContextChangedHandler: renderContextChangedHandler,
        postRefreshHandler: postRefreshHandler
});
};
