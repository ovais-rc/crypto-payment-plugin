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

/** 
 * Declares a new refresh controller for the Organization Summary widget
 */
var declareOrgSearchResultsController = function() {
	var myWidgetObj = $("#orgSearchResultsRefreshArea");
	
	wcRenderContext.declare("orgSearchResultsContext",["orgSearchResultsRefreshArea"],{"orgListDisplayType":"search","searchTerm":"", "startIndex":"0"});

	var myRCProperties = wcRenderContext.getRenderContextProperties("orgSearchResultsContext");
    
	var baseURL = getAbsoluteURL() + 'OrgListDisplayViewV2';
    
	myWidgetObj.refreshWidget({
    	renderContextChangedHandler: function() {
    		myWidgetObj.refreshWidget("updateUrl", baseURL + "?" + getCommonParametersQueryString());
    		myWidgetObj.html("");
    		console.debug(myRCProperties);
    		myWidgetObj.refreshWidget("refresh", myRCProperties);
       },

    	postRefreshHandler: function() {
    		cursor_clear();
    	}
	});
};

// onChange function for organization list select button
function OrganizationOnChange(id, displayName) {
	var data = {"newOrgId":id, "newOrgName":displayName};
	organizationListJS.updateSelectedOrgDetails(data);

	// Publish the event
	wcTopic.publish(organizationListJS.ORG_CHANGED_TOPIC,data);
}
$(document).ready(function() {

organizationListJS = {

	/** HashMap structure to manage parent - child organization relationship
	 *  Key - Parent Org Id
	 *  Value - List of child organizations under Parent Org Id.
	 *  Each object in the list contains complete details about the child organization like orgId, orgName, parentOrgId
	*/
	parentChildOrgDetails : new Object(),

	/**
	* HashMap structure.
	* Key - orgId
	* Value - orgName
	*/
	orgIdToNameMap: new Object(),

	/**
	* Array of top level parent orgIds
	*/
	parentOrgIdsArray : new Array(),

	// UniCode value for &nbps; 
	//HTML Select Option element will treat &nbps; as normal string when options element is created dynamically using script. So as a workaround use unicode format
	//indentation : "\xA0\xA0\xA0", 
	indentation : 27, // padding by 27 px for every child node

	/*
	* Topic name which gets published when the selection in organization drop down box changes.
	*/
	ORG_CHANGED_TOPIC : "organizationChanged",

	/*
	* Topic name to which this widget subscribes. Any widget can publish this topic to receive the current orgId selected in the drop down box.
	*/
	CURRENT_ORG_ID_REQUEST : "currentOrgIdRequest",

	/**
	* Topic name used to publish the current orgId.
	*/
	CURRENT_ORG_ID : "currentOrgId",

	/**
	* Current Organization selected
	*/
	CURRENT_DATA : {"newOrgId":"","newOrgName":""},
	
	/**
	* Set the indentation which can be used while displaying the tree structure
	*/
	setIndentation:function(indent){
		this.iindentation = indent;
	},

	orgSearchListData : {"searchInputFieldId":"orgNameInputField", "clearFilterButtonId":"clearFilter", "progressBarId":"searchOrgListButton", "searchParameterName":"orgName", "searchResultsDivId":"orgSearchResultsRefreshArea"},

	/**
	* This method converts the flat structure of organizaiton list into tree structure and displays the tree structure in the drop down box
	* flatStructure - List of organizations
	* selectBox - Id of the drop down box where the tree structure will be displayed
	*/
	createAndDisplayOrgTree:function(flatStructure,selectBox,selectedOrgEntityId){

		var parentOrgIdsSet = new Object();
		var seenParentOrgIds = new Object();

		//Keep track of id to Name mapping. Needed to get parentOrg Name. For Accessibility label.
		for(var i = 0; i < flatStructure.organizationDataBeans.length; i++){
			var orgDetails = flatStructure.organizationDataBeans[i];
			var orgId = orgDetails.organizationId;
			var orgName = orgDetails.displayName;
			this.orgIdToNameMap[orgId] = orgName; 
		}

		for(var i = 0; i < flatStructure.organizationDataBeans.length; i++){

			var orgDetails = flatStructure.organizationDataBeans[i];
			var orgId = orgDetails.organizationId;
			var parentOrgId = orgDetails.parentMemberId;
			var orgName = orgDetails.displayName;

			var childOrgList = this.parentChildOrgDetails[parentOrgId];
			if(childOrgList === undefined){
				childOrgList = new Array();
				this.parentChildOrgDetails[parentOrgId] = childOrgList;
			} 
			var child = new Object();
			child["orgId"] = orgId;
			child["parentOrgId"] = parentOrgId;
			child["orgName"] = orgName;
			child["parentOrgName"] = this.orgIdToNameMap[parentOrgId]; // This is for aria-label. To call out parent org Name.
			childOrgList[childOrgList.length] = child;

			// Identify the parentOrgIds
			if(!Object.prototype.hasOwnProperty.call(seenParentOrgIds, parentOrgId)){
				parentOrgIdsSet[parentOrgId] = "true";
			} 
			seenParentOrgIds[orgId] = "true";
			seenParentOrgIds[parentOrgId] = "true";
			if(Object.prototype.hasOwnProperty.call(parentOrgIdsSet, orgId)){
				delete parentOrgIdsSet[orgId];
			}
		}
		for(var i in parentOrgIdsSet){
			this.parentOrgIdsArray[this.parentOrgIdsArray.length] = i;
		}

		console.debug("Parent to Child Org Details = ", this.parentChildOrgDetails);
		console.debug("Top Level Parent Org Ids = ",this.parentOrgIdsArray);
		console.debug("Org Id to Name Map ", this.orgIdToNameMap);
		this.displayOrgTree(this.parentChildOrgDetails, this.parentOrgIdsArray, selectBox,selectedOrgEntityId);
	},

	/**
	* Displays organization structure in Tree form.
	* parentChildDetailsMap - Object containing parent to child org relationship.
	* parentIdsList - List of top level ( root ) OrgIds.
	* selectBox - id of the drop down box used to display the tree structure.
	*/
	displayOrgTree:function(parentChildDetailsMap, parentIdsList, selectBox,selectedOrgEntityId){
		var selectBoxObj = $("#" + selectBox);

		for(var i = 0; i < parentIdsList.length; i++){
			var childId = parentIdsList[i];
			this.buildOrgTreeRecursively(parentChildDetailsMap,childId, selectBoxObj, 8);
		}
		console.debug(selectBoxObj);
		// Set the selected orgEntityId in the selectBox object.
		$("#" + selectBox).Select("refresh");
	},

	/**
	* Recursively builds the tree structure mark-up.
	* parentChildDetailsMap - Object containing parent to child org relationship.
	* childId - Child Organization id
	* selectBoxObj - Drop down object where tree structure is built
	* indentation - Used to indent child orgs from parent orgs
	*/
	buildOrgTreeRecursively:function(parentChildDetailsMap,childId,parentNode,indentation){

		var childDetails = parentChildDetailsMap[childId];
		var scope = this;
		if(childDetails != null){
			for(var j = 0; j < childDetails.length; j++){
				var child = childDetails[j];
				var id1 = child['orgId'];
				var name = child['orgName'];
				var parentOrgName = child["parentOrgName"];
				var style = "padding-left:"+indentation+"px;";

				// Generate ARIA LABEL
				var ariaLevel = (indentation / this.indentation) + 1;
				//var tempString = storeNLS['ORG_TO_PARENT_ORG']; - 	// ORG_TO_PARENT_ORG : "${0} created under parent organization - ${1}",
				var stringPattern = "{0} - {1}";
				var tempString;
				if(parentOrgName != null){
					tempString = Utils.substituteStringWithMap(stringPattern, {
						0: name,
						1: parentOrgName
					});
				} else {
					// tempString = storeNLS['TOP_LEVEL_ORG']; - // TOP_LEVEL_ORG : "${0}. This is the top level organization"
					stringPattern = "{0}";
					tempString = Utils.substituteStringWithMap(stringPattern, {0: name});
				}
			
				var text = "<option aria-label = '"+ tempString +"' aria-level = '"+ariaLevel+"' style = '"+style+"'" +
						"value = '" + id1 + "'>"+name+"</option>";
				var option = {id:id1, label:text, displayName:name};
				parentNode.append(option.label);
				if(parentChildDetailsMap[id1] != null){
					this.buildOrgTreeRecursively(parentChildDetailsMap,id1, parentNode,indentation + this.indentation);
				} 
			}
		}
	},

	/**
	* For the given eventName and domNodeId, this function sets up the event with topicName = ORG_CHANGED_TOPIC
	* The data contains the orgId currently selected, with key set to "newOrgId"
	* 
	* This method also subscribes to CURRENT_ORG_ID_REQUEST topic and in response publishes CURRENT_ORG_ID with data object containing the current orgId.
	*/
	setUpEvents:function(eventName, selectBoxDivId){
		var scope = this;
		$(document).ready(function() {
			wcTopic.subscribe(scope.CURRENT_ORG_ID_REQUEST, function(data){
				console.debug("pulbish "+scope.CURRENT_ORG_ID, scope.CURRENT_DATA);
				// Add CURRENT_DATA to the data supplied by the publisher of this event.. and then publish a new event
				$.extend(data, scope.CURRENT_DATA);
				wcTopic.publish(scope.CURRENT_ORG_ID, data);
			});
		});
	},

	cancelEvent: function(e) {
		if (e.stopPropagation) {
			e.stopPropagation();
		}
		if (e.preventDefault) {
			e.preventDefault();
		}
		e.cancelBubble = true;
		e.cancel = true;
		e.returnValue = false;
	},

	updateSelectedOrgDetails:function(data,publishEvent){
		this.CURRENT_DATA["newOrgId"] = data["newOrgId"];
		this.CURRENT_DATA["newOrgName"] = data["newOrgName"];
		console.debug("Current Organization selected", this.CURRENT_DATA);
		if(publishEvent != 'undefined' && publishEvent == 'true'){
			wcTopic.publish(this.ORG_CHANGED_TOPIC,data);
		}
	},

	updateSelectedOrgName:function(elementId,name){
		$("#" + elementId).html(name);
		var scope = this;
		$(document).ready(function() {
			wcTopic.subscribe(scope.ORG_CHANGED_TOPIC, function(data){
				$("#" + elementId).html(data.newOrgName);
			});
		});
	},
	
	getCurrentData:function(){
		return this.CURRENT_DATA;
	},

	showResultsPage:function(data){

		var pageNumber = data['pageNumber'];
		var pageSize = data['pageSize'];
		pageNumber = parseInt(pageNumber);
		pageSize = parseInt(pageSize);
		var startIndex = (pageNumber - 1) * pageSize;

		setCurrentId(data["linkId"]);

		if(!submitRequest()){
			return;
		}

		console.debug(wcRenderContext.getRenderContextProperties('orgSearchResultsContext').properties);
		var beginIndex = pageSize * ( pageNumber - 1 );
		cursor_wait();

		wcRenderContext.updateRenderContext('orgSearchResultsContext', {"startIndex": startIndex});
		MessageHelper.hideAndClearMessage();
	},

	toggleSelection:function(nodeCSS,nodeId,parentNode,cssClassName){
		// Get list of all active nodes with cssClass = nodeCSS under parentNode.
		var activeNodes = $("#" + parentNode).find('.'+cssClassName);

		// Toggle the css class for the node with id = nodeId
		$("#" + parentNode).find('#'+nodeId).toggleClass(cssClassName);

		// Remove the css class for all the active nodes.
		activeNodes.removeClass(cssClassName);
	},

	closeActionButtons:function(nodeCSS,parentNode,cssClassName,hiddenClassName,activeClassName){
		$("#" + parentNode).find('.'+nodeCSS).removeClass(cssClassName);
	},

	resetActionButtonStyle:function(nodeCSS,parentNode,hiddenClassName,activeClassName){
		$("#" + parentNode).find('.'+nodeCSS).addClass(hiddenClassName);
		$("#" + parentNode).find('.'+nodeCSS).removeClass(activeClassName);
	},

	toggleCSSClass:function(nodeCSS,nodeId,parentNode,hiddenClassName,activeClassName){
		// Get the list of current nodes
		var activeNodes = $("#" + parentNode).find('.'+activeClassName); 

		// For the clicked node, toggle the CSS Class. If hidden then display / If displayed then hide.
		$("#"+parentNode).find('#'+nodeId).toggleClass(hiddenClassName);
		$("#"+parentNode).find('#'+nodeId).toggleClass(activeClassName);

		// For all activeNodes, remove the activeCSS and add the hiddenCSS
		activeNodes.removeClass(activeClassName);
		activeNodes.addClass(hiddenClassName);
	},

	doSearch:function(){
		searchTerm = $("#" + this.orgSearchListData.searchInputFieldId).val();
		if(searchTerm == 'undefined' || searchTerm.length == 0){
			searchTerm = "*";
		}
		setCurrentId(this.orgSearchListData.progressBarId);
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		var params = {};
		params[this.orgSearchListData.searchParameterName] = searchTerm;
		params["startIndex"] = "0"; // Reset start index..This is a new search..
		wcRenderContext.updateRenderContext("orgSearchResultsContext", params);	
		$("#" + this.orgSearchListData.clearFilterButtonId).css("display","block"); // Display clearFilter button
	},

	handleSearchInput:function(event,doSearch){
		var searchTerm = $("#" + this.orgSearchListData.searchInputFieldId).val();
		if(searchTerm != 'undefined' && searchTerm.length > 0){
			$("#" + this.orgSearchListData.clearFilterButtonId).css("display","block");
		} else {
			$("#" + this.orgSearchListData.clearFilterButtonId).css("display","none");
		}
		$("#" + this.orgSearchListData.searchResultsDivId).html(""); // Clear previous search results..
		if(doSearch == 'true' && event != null && event.keyCode == KeyCodes.ENTER){
			this.doSearch();
		}
		return false;
	}

};

});