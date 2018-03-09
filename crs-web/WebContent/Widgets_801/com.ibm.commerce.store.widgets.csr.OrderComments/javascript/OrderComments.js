//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


var OrderComments = function(){

    this.editIconId = "editIcon";
    this.widgetId = ''; //Id of the InlineEditBox widget
    this.mainDivId = 'orderComment'; // enclosing div which contains the InlineEditBox widget.
    this.maxCommentLength = 3000;
    this.commentsLoadStatus = new Object();

    /**
        Called after successfully loading the order comments with ajax call and
        displaying the InLineEdit widget (before displaying edit box/save/cancel buttons)
    */
    this.startUp = function(){

        //Comments are successfully loaded. Make a note of it.
        this.commentsLoadStatus[this.widgetId] = 1;
        //Update order comments section heading.
        var commentsPaginationInfo =$("#orderCommentHeading").val();
        if($("#orderCommentHeadingPaginationInfo").val() !== null){
            commentsPaginationInfo = commentsPaginationInfo +"&nbsp;"+$("#orderCommentHeadingPaginationInfo").val();
        }
        $("#orderCommentToggleLabel").html(commentsPaginationInfo);
    };

    /**
        Called after successfully saving new order comment with ajax call.
    */

    this.resetWidget = function(resetEditText){

        if($("#comment").val() != ''){
            $("#comment").val('');
        }

          // Update orderComments heading with new pagination info.
        var commentsPaginationInfo = $("#orderCommentHeading").val();
        if($("#orderCommentHeadingPaginationInfo").val() !== null){
            commentsPaginationInfo = commentsPaginationInfo +"&nbsp;"+$("#orderCommentHeadingPaginationInfo").val();
        }
        $("#orderCommentToggleLabel").html(commentsPaginationInfo);

        // Display addCommentWidget
         $("#commentWidget").remove();
         $('#addCommentWidget').show();
    }

    this.cancelEdit = function(){
        this.resetWidget();
    };

    this.showHide = function(nodeId, hiddenClassName, activeClassName){
        var node = $('#'+nodeId);
        node.toggleClass(hiddenClassName);
        node.toggleClass(activeClassName);
    };

    this.expandCollapseArea = function(){
        this.showHide('orderCommentContainer_plusImage_link', 'collapsed', 'displayInline');
        this.showHide('orderCommentContainer_minusImage_link', 'collapsed', 'displayInline');
        this.showHide('orderCommentContent', 'collapsed', 'expanded');

        if($("#orderCommentContainer_plusImage_link").hasClass('displayInline')){
            document.getElementById("orderCommentContainer_plusImage_link").focus();
        } else if($("#orderCommentContainer_minusImage_link").hasClass('displayInline')){
            document.getElementById("orderCommentContainer_minusImage_link").focus();
        }
    };

    this.loadComments = function(orderId,widgetId){
        if(this.commentsLoadStatus[widgetId] == 1){
            //Comments already loaded.
            return false;
        }

        // Fetch comments from server by making an Ajax call.
        this.widgetId = widgetId;
        wcRenderContext.updateRenderContext('orderCommentsContext', {"orderId": orderId});
    };

    this.saveComments = function(orderId, widgetId, mode){
        var orderComment = $.trim($("#comment").val());
        if(orderComment === null || orderComment.length === 0){
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('EMPTY_COMMENT'));
            this.resetWidget(false);
            return false;
        }

        if(!MessageHelper.isValidUTF8length(orderComment, this.maxCommentLength)){
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('COMMENT_LENGTH_OUT_OF_RANGE'));
            // Let the comment text be available to CSR. So that they can reduce the char count, instead of keying in again
            this.resetWidget(false);
            return false;
        }

        var params = [];
        params["mode"] = mode;
        params["orderComment"] = orderComment;
        params["orderId"] = orderId;
        cursor_wait();
        wcService.invoke("AjaxRESTAddOrderComment", params);
    };


    this.showHideorderCommentsSliderContent = function(){
        $( document ).ready(function() {
                $('#orderCommentsSlider_content').toggleClass('orderCommentsSlider_content_closed');
                $('#orderCommentsSlider_trigger').toggleClass('orderCommentsSlider_trigger_closed');
        });
    };
}
$(document).ready(function() {
    orderCommentsJS = new OrderComments();
});
    var declareOrderCommentListRefreshArea = function() {
        // ============================================
        // div: orderCommentListRefreshArea refresh area
        // Declares a new refresh controller for the fetching order level comments.
        
        /**
         * Declares a new render context for managing orderComments customers list - To display registered customers based on search criteria.
         */
        wcRenderContext.declare("orderCommentsContext", ["orderCommentListRefreshArea"], {});

        var myWidgetObj = $("#orderCommentListRefreshArea");
        var myRCProperties = wcRenderContext.getRenderContextProperties("orderCommentsContext");
        var baseURL = getAbsoluteURL()+'OrderCommentsListViewV2';

        var renderContextChangedHandler = function() {
            console.debug("renderContextChangedHandler of orderCommentListRefreshArea");
            myWidgetObj.refreshWidget("updateUrl", baseURL+"?"+getCommonParametersQueryString());
            myWidgetObj.attr("role", "region");
            myWidgetObj.attr("tabIndex", 0);
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        };

        wcTopic.subscribe("AjaxRESTAddOrderComment", function() {
            console.debug("modelChangedHandler of orderCommentListRefreshArea");
            myWidgetObj.refreshWidget("updateUrl", baseURL+"?"+getCommonParametersQueryString());
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        });
        
        var postRefreshHandler = function() {
             console.debug("Post refresh handler of orderCommentListRefreshArea");
             cursor_clear();
             orderCommentsJS.startUp();
        };
       
        // initialize widget
        myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
    };



// when user clicks on edit link and the InlineEditor is displayed.

$.fn.inlineEdit = function (replaceWith) {

    $(this).keypress(function (event) {

        if (event.keyCode == 13) { // Checks for the enter key
            $(this).click();
            event.preventDefault();
        }
    });

    $(this).click(function () {

        var self = $(this);
        self.hide();
        self.after(replaceWith);
        $("#comment").focus();
        $("#saveButton").addClass("button_primary saveButton");
        $("#cancelButton").addClass("button_secondary cancelButton");
        $("#comment").addClass("expandingTextArea");

    });
} 





// Service to add Order Level Comments
wcService.declare({
    id: "AjaxRESTAddOrderComment",
    actionId: "AjaxRESTAddOrderComment",
    url: getAbsoluteURL() + "AjaxRESTAddOrderComment"+"?"+getCommonParametersQueryString(),
    formId: ""

    /**
     * Clear messages on the page.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
     */
    ,successHandler: function(serviceResponse) {
        //After saving the comments, reset the widget to initial state.
        //Remove the saved comment from textArea.
        orderCommentsJS.resetWidget(true);
        cursor_clear();
    }

    /**
     * Displays an error message on the page if the request failed.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
     */
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


