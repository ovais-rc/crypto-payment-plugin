//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the AjaxRecommendation pages to control the refresh areas.
 * @version 1.0
 */

//Declare refresh controller function used by the Ajax recommendation refresh area
var declareAjaxRecommendationRefresh_controller = function(emsName) {
    var myWidgetObj = $("#AjaxRecommendation_Widget_" + emsName);

    wcRenderContext.declare("AjaxRecommendationRefresh_Context_" + emsName, ["AjaxRecommendation_Widget_" + emsName], {});
    var myRCProperties = wcRenderContext.getRenderContextProperties("AjaxRecommendationRefresh_Context_" + emsName);
    
    // initialize widget
    myWidgetObj.refreshWidget({
        renderContextChangedHandler: function() {
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        },

        /**
         * Clears the progress bar after a successful refresh.
         */
        postRefreshHandler: function() {
            cursor_clear();
            wcTopic.publish("CMPageRefreshEvent");
        }
    });
};