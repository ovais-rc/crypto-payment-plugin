//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

require([
			 "dojo/html",
			 "dojo/on", 
			 "dojo/query", 
			 "dojo/topic", 
			 "dojo/dom",
			 "dojo/dom-style",
			 "dojo/dom-class",
			 "dojo/_base/event",
			 "dojo/_base/array",
 			 "dijit/_BidiSupport",
		 	 "dojo/dom-attr", // domAttr.set domAttr.get
			 "dojo/domReady!"], function(html,on, query, topic, dom, domStyle, domClass, event, array, bidi, domAttr) {

OrderComments = function(){
				
	
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
		// Connect editIcon to InlineEditBox editor.
		dojo.connect(dojo.byId(this.editIconId), 'onclick', dijit.byId(this.widgetId), '_onClick'); // For Mouse click
		/*
			Instead of handling 'Enter' key indirectly via invokeWidgetClickAction, the easiest way was to use below piece of code.
			But this piece of code triggers _onClick function even on 'tab' key press. To avoid this and connect only to 'Enter' key
			we are using invokeWidgetClickAction function.
			dojo.connect(dojo.byId(this.editIconId), 'onkeypress', dijit.byId(this.widgetId), '_onClick')
		*/
		dojo.connect(dojo.byId(this.editIconId), 'onkeypress', dojo.hitch(this,"invokeWidgetClickAction")); // For Enter key

		// SaveButton needs additional CSS class 'buttonPrimary' to display properly in IE11. This saveButton gets created dynamically
		// when user clicks on edit link and the InlineEditor widget is displayed. This creation and display of InlineEditor widget happens
		// in 'edit' function of widget. So wait for this function to trigger and then add the style to saveButton.
		dojo.connect(dijit.byId(this.widgetId), 'edit', dojo.hitch(this,"updateStyles"));
		
		// Update the text direction		
		dijit.byId(this.widgetId).set('textDir', getBaseTextDir());
		enforceTextDirectionOnPage();

		//Comments are successfully loaded. Make a note of it.
		this.commentsLoadStatus[this.widgetId] = 1;

		//Update order comments section heading.
		var commentsPaginationInfo = dojo.byId("orderCommentHeading").value;
		if(dojo.byId("orderCommentHeadingPaginationInfo").value != null){
			commentsPaginationInfo = commentsPaginationInfo +"&nbsp;"+dojo.byId("orderCommentHeadingPaginationInfo").value;
		}
		dojo.byId("orderCommentToggleLabel").innerHTML = commentsPaginationInfo;
	};

	this.invokeWidgetClickAction = function(event){
		if(event.keyCode == 13){
			dijit.byId(this.widgetId)._onClick(event);
		}
	};

	/**
		Called after successfully saving new order comment with ajax call.
	*/
	this.resetWidget = function(resetEditText){
		if(this.widgetId != ''){
			var widget = dijit.byId(this.widgetId);
			//Don't use setValue. It will trigger onChange events and try to save the comment.
			//Directly set innerHTML and value attribute
			widget.displayNode.innerHTML = storeNLS['ADD_COMMENT_MESSAGE']; // Display node value.
			if(resetEditText != null && resetEditText != false){
				widget.value = ""; //Text area value.
			}
		}
		
		// Update orderComments heading with new pagination info.
		var commentsPaginationInfo = dojo.byId("orderCommentHeading").value;
		if(dojo.byId("orderCommentHeadingPaginationInfo").value != null){
			commentsPaginationInfo = commentsPaginationInfo +"&nbsp;"+dojo.byId("orderCommentHeadingPaginationInfo").value;
		}
		dojo.byId("orderCommentToggleLabel").innerHTML = commentsPaginationInfo;



		// Display editIcon
		dojo.style(this.editIconId, "display", "block");
	}

	this.cancelEdit = function(){
		this.resetWidget();
	};

	this.updateStyles = function(){
		// get nodes under div#orderComment, buttonContainer with widgetId = widget.wrapperWidget.saveButton.id
		var widget = dijit.byId(this.widgetId);
		
		var textAreaNode = dojo.query("div#"+this.mainDivId+" textarea:nth-child(1)");
		textAreaNode[0].setAttribute("aria-label", storeNLS['EMPTY_COMMENT']);
		
		var saveButtonNodes = dojo.query("div#"+this.mainDivId+" [widgetId="+widget.wrapperWidget.saveButton.id+"]");
		if(saveButtonNodes == null){
			// Find button in entire document
			saveButtonNodes = dojo.query("[widgetId="+widget.wrapperWidget.saveButton.id+"]");
		}
		var saveButtonNode = saveButtonNodes[0];
		
		// Get containerNode within saveButton - This is the inner most <span> of saveButton.
		var node1 = dojo.query("[data-dojo-attach-point=containerNode]",saveButtonNode);
		var saveButtonInnerNode =  node1[0];

		// This change is needed since, onTab, only inner most <span> gets focused. Which means, only saveButtonText gets focused
		// With this change, the inner most <span> will contain all the styling information and extends upto outerMost <span>
		// So onTab, even when inner most <span> gets the focus, for end user, it looks like entire button is focused.
		dojo.removeClass(saveButtonNode, "saveButton"); //Remove saveButton class from outer most <span> of saveButton.
		dojo.addClass(saveButtonNode, "saveButtonOuterSpan"); 
		dojo.addClass(saveButtonInnerNode, "saveButtonInnerSpan"); // Add styling to inner most <span> of saveButton.
		dojo.addClass(saveButtonInnerNode,"button_primary"); // Add styling to inner most <span> of saveButton.


		// Similar changes for Cancel Button.
		var cancelButtonNodes = dojo.query("div#"+this.mainDivId+" [widgetId="+widget.wrapperWidget.cancelButton.id+"]");
		if(cancelButtonNodes == null){
			// Find button in entire document
			cancelButtonNodes = dojo.query("[widgetId="+widget.wrapperWidget.cancelButton.id+"]");
		}
		var cancelButtonNode = cancelButtonNodes[0];
	
		var node2 = dojo.query("[data-dojo-attach-point=containerNode]",cancelButtonNode);
		var cancelButtonInnerNode =  node2[0];
		dojo.removeClass(cancelButtonNode, "cancelButton"); 
		dojo.addClass(cancelButtonNode, "cancelButtonOuterSpan"); 
		dojo.addClass(cancelButtonInnerNode, "cancelButtonInnerSpan"); 
		dojo.addClass(cancelButtonInnerNode,"button_secondary"); 

		// Hide editIcon.
		dojo.style(this.editIconId, "display", "none");

		
	};

	this.showHide = function(nodeId, hiddenClassName, activeClassName){
		var node = query('#'+nodeId);
		node.toggleClass(hiddenClassName);
		node.toggleClass(activeClassName);
	};

	this.expandCollapseArea = function(){
		this.showHide('orderCommentContainer_plusImage_link', 'collapsed', 'displayInline');
		this.showHide('orderCommentContainer_minusImage_link', 'collapsed', 'displayInline');
		this.showHide('orderCommentContent', 'collapsed', 'expanded');

		if(dojo.hasClass("orderCommentContainer_plusImage_link", 'displayInline')){
			dojo.byId("orderCommentContainer_plusImage_link").focus();
		} else if(dojo.hasClass("orderCommentContainer_minusImage_link", 'displayInline')){
			dojo.byId("orderCommentContainer_minusImage_link").focus();
		}
	};

	this.loadComments = function(orderId,widgetId){
		if(this.commentsLoadStatus[widgetId] == 1){
			//Comments already loaded. 
			return false;
		}
		
		// Fetch comments from server by making an Ajax call.
		this.widgetId = widgetId;
		wc.render.updateContext('orderCommentsContext', {"orderId": orderId});
	};

	this.saveComments = function(orderId, widgetId, mode){
		this.widgetId = widgetId;
		var widget = dijit.byId(widgetId);
		var orderComment = widget.get("value");

		if(orderComment === null || orderComment.length === 0){ 
			MessageHelper.displayErrorMessage(storeNLS['EMPTY_COMMENT']);
			this.resetWidget(false);
			return false;
		}

		if(!MessageHelper.isValidUTF8length(orderComment, this.maxCommentLength)){ 
//			widget._onClick();
			MessageHelper.displayErrorMessage(storeNLS['COMMENT_LENGTH_OUT_OF_RANGE']);
			// Let the comment text be available to CSR. So that they can reduce the char count, instead of keying in again
			this.resetWidget(false);
			return false;
		}

		var params = [];
		params["mode"] = mode;
		params["orderComment"] = orderComment;
		params["orderId"] = orderId;
		cursor_wait();
		wc.service.invoke("AjaxRESTAddOrderComment", params);
	};

	
	this.showHideorderCommentsSliderContent = function(){
		require(["dojo/query", "dojo/domReady!"], function(query) {
				query('#orderCommentsSlider_content').toggleClass('orderCommentsSlider_content_closed');
				query('#orderCommentsSlider_trigger').toggleClass('orderCommentsSlider_trigger_closed');
		});
	};

}

});


dojo.addOnLoad(function(){
	orderCommentsJS = new OrderComments();
});


/**
 * Declares a new render context for managing orderComments customers list - To display registered customers based on search criteria.
 */
wc.render.declareContext("orderCommentsContext",{},"");

// Service to add Order Level Comments
wc.service.declare({
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


/** 
 * Declares a new refresh controller for the fetching order level comments.
 */
wc.render.declareRefreshController({
	   id: "orderComment_Controller",
	   renderContext: wc.render.getContextById("orderCommentsContext"),
	   url: "",
	   baseURL:getAbsoluteURL()+'OrderCommentsListView',
	   formId: ""
	   
	   ,modelChangedHandler: function(message, widget) {
			console.debug("modelChangedHandler of orderComment_Controller",widget);
			var controller = this;
			var renderContext = this.renderContext;
			controller.url = controller.baseURL +"?"+getCommonParametersQueryString();
			if(message.actionId == 'AjaxRESTAddOrderComment'){
				widget.refresh(renderContext.properties);
			}
	   }

	   ,renderContextChangedHandler: function(message, widget) {
			console.debug("renderContextChangedHandler of orderComment_Controller",widget);
			var controller = this;
			var renderContext = this.renderContext;
			controller.url = controller.baseURL +"?"+getCommonParametersQueryString();
			var refreshNode = dojo.byId(widget.id);
			refreshNode.setAttribute("role", "region");
			refreshNode.setAttribute("tabIndex", 0);

			widget.refresh(renderContext.properties);
	   }       	   

	   ,postRefreshHandler: function(widget) {
			console.debug("Post refresh handler of orderComment_Controller",widget);
			cursor_clear();
			orderCommentsJS.startUp();
	   }
});