//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

// Declare refresh controller which are used in pagination controls of SearchBasedNavigationDisplay -- both products and articles+videos

// Search for this "prodRecommendationRefresh_controller" it is never defined in any refresh areas, maybe no longer in use?
/*
wc.render.declareRefreshController({
    id: "prodRecommendationRefresh_controller",
    renderContext: wcRenderContext.getRenderContextProperties("searchBasedNavigation_context"),
    url: "",
    formId: ""

    ,renderContextChangedHandler: function(message, widget) {
        var controller = this;
        var renderContext = this.renderContext;
        var resultType = renderContext.properties["resultType"];
        if (["products", "both"].indexOf(resultType) > -1){
            widget.refresh(renderContext.properties);
            console.log("espot refreshing");
        }
    }

    ,postRefreshHandler: function(widget) {
        var controller = this;
        var renderContext = this.renderContext;
        cursor_clear();

        var refreshUrl = controller.url;
        var emsName = "";
        var indexOfEMSName = refreshUrl.indexOf("emsName=", 0);
        if(indexOfEMSName >= 0){
            emsName = refreshUrl.substring(indexOfEMSName+8);
            if (emsName.indexOf("&") >= 0) {
                emsName = emsName.substring(0, emsName.indexOf("&"));
                emsName = "script_" + emsName;
            }
        }

        if (emsName !== "") {
            var espot = $('.genericESpot', $("#" + emsName).parent()).first();
            if (espot.length) {
                espot.addClass('emptyESpot');
            }
        }
        wcTopic.publish("CMPageRefreshEvent");
    }
}); */
