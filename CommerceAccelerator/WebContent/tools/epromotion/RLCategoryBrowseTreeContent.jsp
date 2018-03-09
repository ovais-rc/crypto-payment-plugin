<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="epromotionCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fPromoHeader%>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(commContext.getLocale()) %>" type="text/css" />

<style type='text/css'>
.selectWidth {width: 200px;}

</style>

<title><%= RLPromotionNLS.get("CategoryBrowseContentPanelTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript">
<!---- hide script from old browsers
var allowMultipleObject = top.getData("allowMultiple", 1);
var allowMultiple = true;

// Needed if we have to enable/disable multiple category selection
if (allowMultipleObject != null) {
	allowMultiple = allowMultipleObject;
}

function loadPanelData () {
	if (parent.parent.setContentFrameLoaded) {
		parent.parent.setContentFrameLoaded(true);
	}
}

function finderChangeSpecialText (rawDisplayText, textOne, textTwo, textThree, textFour) {
	var displayText = rawDisplayText.replace(/%1/, textOne);
	if (textTwo != null)
		displayText = displayText.replace(/%2/, textTwo);
	if (textThree != null)
		displayText = displayText.replace(/%3/, textThree);
	if (textFour != null)
		displayText = displayText.replace(/%4/, textFour);
	return displayText;
}

function performAdd () {
	var rlPromo = top.getData("RLPromotion", 1);
	var catIdentifier = new Array();
	var duplicateCgryList = new Array();
	
	var localSelectionArray = new Array();
	var treeValue = "";
	var categoryNode = 0;
	

	if (parent.tree.getHighlightedNodes == undefined) {
		// fatal error!  getHighlightedNodes does not exist in the base frame.
		return;
	}
    
	// count number of selected catentry nodes in the tree
	for (var i=0; i<parent.tree.getHighlightedNodes().length; i++) {
		treeValue = parent.tree.getHighlightedNodes()[i].value;
		
		
		if ((treeValue == "") || (treeValue == null)) {
			// catalog  node, do nothing
		}
		else {
			categoryNode++;
		}
	}
   
	// if there is no selected category nodes in the tree, warn user and stop here
	if (categoryNode == 0) {
		alertDialog("<%= UIUtil.toJavaScript((String)RLPromotionNLS.get("CategoryBrowseItemNotSpecified")) %>");
		return;
	}
	// if there are more than 1 selected category nodes in the tree and multiple selection is not
	// allowed, warn user and stop here
	else if (categoryNode > 1) {
		if (!allowMultiple) {
			// alert that multiple categories cannot be selected 
			return;
		}
	}

	var catGpCatEntMapArray = top.getData("RLCatGrpCatEntMapList", 1);
	if (catGpCatEntMapArray == null || catGpCatEntMapArray == undefined) {
		catGpCatEntMapArray = new Array();
	}
	// loop through each selected nodes, and save category data
	for (var i=0; i<parent.tree.getHighlightedNodes().length; i++) {
		treeValue = parent.tree.getHighlightedNodes()[i].value;
		if ((treeValue == "") || (treeValue == null)) {
			// catalog node, do nothing
		}
		else {
			var sep1Index = treeValue.indexOf("|");
			var sep2Index = treeValue.substring(sep1Index+1, treeValue.length).indexOf("|") + sep1Index + 1;
			var sep3Index = treeValue.substring(sep2Index+1, treeValue.length).indexOf("|") + sep2Index + 1;
			var selectType = treeValue.substring(0, sep1Index);
			var refnum = trim(treeValue.substring(sep1Index+1, sep2Index));
			var catGrpCatEntMap = refnum + "|" + trim(treeValue.substring(sep3Index+1, treeValue.length));
			var refName = trim(treeValue.substring(sep2Index+1, treeValue.length));
			var displayText = refName + " (" + refnum + ")";

			// add new category to local category array
			var localIndex = localSelectionArray.length;
			localSelectionArray[localIndex] = new Object();
			localSelectionArray[localIndex].selectType = selectType;
			localSelectionArray[localIndex].refnum = refnum;
			localSelectionArray[localIndex].refName = refName;
			localSelectionArray[localIndex].displayText = displayText; // not required
			catIdentifier[localIndex] = refnum;			

			var duplicate = false;
			
			for (var j = 0;j < catGpCatEntMapArray.length; j++) {
				var sep1Index = catGpCatEntMapArray[j].indexOf("|");
				var sep2Index = catGpCatEntMapArray[j].substring(sep1Index+1, catGpCatEntMapArray[j].length).indexOf("|") + sep1Index + 1;
				var catGpName = trim(catGpCatEntMapArray[j].substring(0, sep1Index));
				var catGpId = trim(catGpCatEntMapArray[j].substring(sep1Index+1, catGpCatEntMapArray[j].length));
				if (catGpName == refnum) {
				   catGpCatEntMapArray[j] = catGrpCatEntMap;
					duplicate = true;
					break;
				}
			}
			if (duplicate == false) {
				catGpCatEntMapArray[catGpCatEntMapArray.length] = catGrpCatEntMap;
			}
		}
	}				
			
	var catlist = new Array();
	var noIdentifierList = new Array();
	var noIdentifierListIndex = 0;
	var catListToAdd = null;
	var catListIndex = 0;	
	if (rlPromo != null)  
	{			
		catListToAdd = rlPromo.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %>;
		if (catListToAdd != null) 
		{
			catListIndex = catListToAdd.length;					
		}
		
		for (var a=0; a<catIdentifier.length; a++) // check for selected categories with no identifiers
		{  
		   	if(catIdentifier[a] == null || trim(catIdentifier[a]) == "") 
		   	{
		     	noIdentifierList[noIdentifierListIndex++] = localSelectionArray[a].refName;				
		   	}
		} 
		if(noIdentifierList.length >0) //If category with no identifier is selected alert the user and do nothing
		{		
			alertDialog('<p>' +'<%=UIUtil.toJavaScript(RLPromotionNLS.get("emptyCategoryIdentifier").toString())%>' + ' </p> <p>&nbsp;&nbsp;'+ noIdentifierList +'</p>' );
			return;
		}
		else
		{
			if ( catListIndex > 0) // Append categories to the already existing category list
			{
				var counter = 0;
				for (var a=0; a<catIdentifier.length; a++)
				{  
					var isDuplicateCgry = false;
					
					for (var b=0; b<catListIndex; b++)
					{ 
						if (catListToAdd[b] != null)
						{
							if (trim(catIdentifier[a]) == trim(catListToAdd[b]))											
							{ 
									duplicateCgryList[counter] = catIdentifier[a];
									counter++;
									isDuplicateCgry = true;
									break;
							}
						}
					}
					if (!isDuplicateCgry)
					{
						catListToAdd[catListIndex] = catIdentifier[a];
						catListIndex++;
					}
				}	
				
				rlPromo.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %> = catListToAdd;	
			}
			else
			{
				rlPromo.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %> = catIdentifier;
			}					
			
			var tempCatList = rlPromo.<%= RLConstants.RLPROMOTION_CATGROUP_CODE %>;
			top.sendBackData(rlPromo, "RLPromotion");
			top.sendBackData(tempCatList, "RLCategoryList");
			top.sendBackData(catGpCatEntMapArray, "RLCatGrpCatEntMapList");
			//top.saveData(rlPromo,"RLPromotion");
			//top.saveData(tempCatList, "RLCategoryList");
		}
	}  // end of if rlPromo !=null
	else 
	{				
					
		catListToAdd = top.getData("RLCategoryList", 1);
		if (catListToAdd != null)
		{
			catListIndex = catListToAdd.length;					
		}
					
		if ( catListIndex > 0)
		{
			var counter = 0;
			for (var a=0; a<catIdentifier.length; a++)
			{  
				var isDuplicateCgry = false;
				for (var b=0; b<catListIndex; b++)
				{ 
					if (catListToAdd[b] != null)
					{
						if (trim(catIdentifier[a]) == trim(catListToAdd[b]))											
						{ 
							duplicateCgryList[counter] = catName[a];
							counter++;
							isDuplicateCgry = true;
							break;
						}
					}
				}
				if (!isDuplicateCgry)
				{
					catListToAdd[catListIndex] = catIdentifier[a];
					catListIndex++;
				}
			}	
			top.sendBackData(catListToAdd, "RLCategoryList");
			//top.saveData(catListToAdd,"RLCategoryList");				
		}
		else
		{
			top.sendBackData(catIdentifier, "RLCategoryList");
			//top.saveData(catIdentifier,"RLCategoryList");										
		}			
	}

	// go back to the browser's caller!
	top.sendBackData(localSelectionArray, "browserSelection");
	top.goBack();
}

function performCancel () {
	// take the user back to the previous entry in the model...	
	top.goBack();
}
//-->

</script>
</head>

<body onload="loadPanelData();" class="content">

<h1><%= RLPromotionNLS.get("CategoryBrowsePrompt") %></h1>
<p><%= RLPromotionNLS.get("multipleCgrySelectMsg") %></p>
</body>

</html>