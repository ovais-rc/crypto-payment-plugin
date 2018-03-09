/****************************************************************************
 *
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright IBM Corp. 2002
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 ***************************************************************************/

/*************************************************************
 * Debugging
 *************************************************************/
function isDefined(variable){
	if (variable == null)  return false;
	if (typeof(variable) != "undefined"){
	 	return (true);
	}
	return (false);
}


/**************************************************************
 * List Functions
 **************************************************************/

/*
 * getFirstRowChecked
 * Returns the first checked checkbox or null if none checked
 */
function getFirstRowChecked(){
	var theForm = basefrm.list;
	for (var i = 0; i < theForm.length; i++)
	{
		if (theForm.elements[i].checked == true){	
			return (theForm.elements[i]);
		}
	}
	return null;
}

/*
 * uncheckAll
 * Unchecks all checkboxes
 */	
function uncheckAll(){
	for (var i = 0; i < basefrm.list.length; i++)
	{
		basefrm.list.elements[i].checked = false;
	}
}

/*
 * check
 * currentRow is a checkbox
 * Ensures that currentRow is checked
 */
function check(currentRow)
{
	if (currentRow == null) return;
	uncheckAll();
	currentRow.checked = true;
}

/*
 * getRow
 * sarFilename is the name of the store archive
 * Returns the checkbox associated with sarFilename
 *	or null if sarFilename is not found
 */
function getRow(sarFilename){
	var theForm = basefrm.list;
	for (var i = 0; i < theForm.length; i++)
	{
		if (theForm.elements[i].value == sarFilename){
			return (theForm.elements[i]);
		}
	}
	return null;
}


/**************
 * initListSelected
 * Checks to see if a value exists in the model for storeArchiveFilename.
 * If it exists then show that list item as selected.  Otherwise,
 * make sure no item is selected.
 * Call this function each time the page containing the list is loaded
 */
function initListSelected(){
	var sar = null;
	sar = parent.get("storeArchiveFilename");
	if (isDefined(sar)){
		check(getRow(sar));
	}		
}

// called by the wizard before calling validatePanelData
function savePanelData()
{
	// get the selected checkbox
	var cbox = getFirstRowChecked();

	// place its value in the model	
	if (cbox != null){
	
		// check if this is a new selection
		var prevSar = parent.get("storeArchiveFilename");
		if (isDefined(prevSar) && (prevSar != cbox.value)){
			var pInfos = parent.get("paramInfos");
			if (isDefined(pInfos)){
				// clear previously saved parameters
				for (var i=0; i < pInfos.length; i++){
					parent.remove(pInfos[i].name);	// remove parameter from model 
				}
				parent.remove("paramInfos"); 	// remove old parameter info array
			
			}
			var hiddenParams = parent.get("hiddenParams");
			if(isDefined(hiddenParams)){
				// clear previously saved hidden input parameters 
				for (var i=0; i < hiddenParams.length; i++){
					parent.remove(hiddenParams[i]);	// remove parameter from model 
				}
				parent.remove("hiddenParams"); 	// remove old array containing hidden input parameter names
			}
		} 
		
		parent.put("storeArchiveFilename", cbox.value);
		
		var viewName = null;
		var action = basefrm.location.toString();

		if(action != null){
			var viewIndex = action.indexOf("?view=");
			if(viewIndex != '-1'){
				 viewName = action.substring(viewIndex+6);
			}
		}
		// add as a parameter to Next URL (should this be encoded?)
		
		// get the URL
		var nextURL = parent.pageArray['StorePublishWizardParameters'].url;
		//alertDialog(nextURL);
		var changedURL = null;
		if (nextURL != null) {
			changedURL = addReplaceParam(nextURL, "sar", cbox.value); 
		}
		//alertDialog(changedURL);
		parent.pageArray['StorePublishWizardParameters'].url = changedURL;
		
		if(viewName != null){
			var nextURL = parent.pageArray['StorePublishWizardArchiveList'].url;
			var changedURL = null;
			if (nextURL != null) {
				if(nextURL.indexOf("&view") != '-1'){
					changedURL = addReplaceParam(nextURL,"view",viewName);
				}
				else{
					changedURL = nextURL + "&view=" + viewName; 
				}
			}
			parent.pageArray['StorePublishWizardArchiveList'].url = changedURL;
		}
		
		// clear any parameters that may have been saved to 
		
	}

}

function addReplaceParam(theURL, paramName, paramValue){
	// create regular expression (need to find out what is valid URL)
	re = new RegExp(("(.+)(" + paramName + "=)(.+)(&?.*)"));
	pos = theURL.search(re);
	//alertDialog(pos);
	if (pos == -1){
		// the paramName does not exist, so add
		return (theURL + "?" + paramName + "=" + paramValue);
	} else {
		// the paramName does exist, so replace
		return (theURL.replace(re, ("$1$2" + paramValue + "$4")));
	}
}


