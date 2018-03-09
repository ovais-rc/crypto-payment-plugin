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

var isApply = false;

// submitErrorHandler() is Called on failure of the completion of the finish controller command.
function submitErrorHandler(errorMessage)
{
	alertDialog(errorMessage);
}

// submitFinishHandler() is Called on successful completion of the finish controller command.
function submitFinishHandler(finishMessage)
{	
	if (!isApply) {   
		// Close if the Finish button was clicked
	 	self.submitCancelHandler();
	}
	else {
		
		var selections = self.get("flexflowInfo")["selections"];
		
		if (selections["CustomBannerPanelOptions"] == "SelectBanner")
		{
			var optionGroups = self.get("optionGroups");
			
			var optionId = selections["BannerPanelOptions"];
			var fileName = optionGroups["BannerPanelOptions"].options[optionId].src;
			
			self.put("currentSelectedBannerName",fileName); // Set new selected banner file name
			self.put("currentBannerCustom",null);  // Set current banner is not a custom one
		}else {
			var uploadedBannerName = self.get("uploadedBannerName");
			var upLength = uploadedBannerName.length;
			var extension = uploadedBannerName.substring(upLength-3,upLength);
			self.put("uploadedBannerName", "images/banner." + extension);
			self.put("currentCustomBannerName", self.get("uploadedBannerName"));
			self.put("currentBannerCustom", "true");
			
		}
				
		// Call ApplyHandler funciton on individual wizard page.
		self.frames.CONTENTS.submitApplyHandler(finishMessage);
		
		self.put("newBanner",null);
	}
	
	isApply = false;
}

// preSubmitHandler() is Called after validateAllPanels() but before finish controller command.
function preSubmitHandler()
{	
	
	/* Before we submit, we must check the Banner page to see if the user selected
	 * the 'Use your own banner' (CustomBanner) option.  If so, we check to make sure 
	 * either the user has previously uploaded a banner.  If not, default to a 
	 * one of the banner selections.  If so, we set newBanner to the uploadedFileName.
	 */
	var selections = self.get("flexflowInfo")["selections"];
	var defaultSection = selections["CustomBannerPanelOptions"];
	var uploadedBanner = self.get("uploadedBanner");

	if (defaultSection == "CustomBanner")
	{
		if (uploadedBanner != null) {
			self.put("newBanner",self.get("uploadedBannerName"));
		}else {
			selections["CustomBannerPanelOptions"] = "SelectBanner";
		}
	}
}

// submitCancelHandler() is called to close the wizard.
function submitCancelHandler()
{
	top.setHome();
}


// applyButton() called when the Apply button is pressed on the wizard.
function applyButton()
{
	if (self.isContentFrameLoaded() == false) 
	{
		return;
	}
	
	var rval = true;
	if (self.get("alreadyWarned","") == "") 
	{	//  Only display Apply warning once if the user selected 'yes' already in this wizard
		if (self.get("AlertWarning") == null) { return; }
		rval = confirmDialog(self.get("AlertWarning"));
	}
	if (rval) {
		self.put("alreadyWarned", "true"); 
		isApply = true;
		self.finish();
	}
}

// viewStoreButton() called when the View Store button is pressed on the wizard.
function viewStoreButton()
{
	loc = "http://";
	loc += self.location.hostname;
	loc += self.get("StoresWebPath");
	loc += "/";
	loc += "StoreView?storeId=";
	loc += encodeURI(self.get("StoreId"));
	
	window.open(loc,'');	
}
