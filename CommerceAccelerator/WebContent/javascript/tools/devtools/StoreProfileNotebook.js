//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2006
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

/******************************************************************************
*
*	Tools Framework Hooks
*
******************************************************************************/
function submitErrorHandler(errorMessage)
{
	alertDialog(errorMessage);
}

function submitFinishHandler(finishMessage)
{
	top.setHome();
}

function submitCancelHandler()
{
	top.goBack();
}

/******************************************************************************
*
*	Data id constants
*
******************************************************************************/
var STORE_DATA_ID = "STORE_DATA";
var CONTACT_DATA_ID = "CONTACT_DATA";
var LOCATION_DATA_ID = "LOCATION_DATA";

/******************************************************************************
*
*	Error code constants
*
******************************************************************************/
var ERROR_CODE = "ERROR_CODE";
var ERR_DETAILS_NAME = "ERR_DETAILS_NAME";
var ERR_DETAILS_DESCRIPTION = "ERR_DETAILS_DESCRIPTION";
var ERR_ADDRESS1 = "ERR_ADDRESS1";
var ERR_ADDRESS2 = "ERR_ADDRESS2";
var ERR_CITY = "ERR_CITY";
var ERR_STATE = "ERR_STATE";
var ERR_COUNTRY = "ERR_COUNTRY";
var ERR_ZIPCODE = "ERR_ZIPCODE";
var ERR_PHONE = "ERR_PHONE";
var ERR_FAX = "ERR_FAX";
var ERR_EMAIL = "ERR_EMAIL";

/******************************************************************************
*
*	Panel id constants - from notebook.xml
*
******************************************************************************/
var GENERAL_PANEL = "GeneralPanel";
var CONTACT_PANEL = "ContactPanel";
var LOCATION_PANEL = "LocationPanel";
var LANGUAGE_PANEL = "LanguagePanel";

// return true for valid, false otherwise
function validateAllPanels()
{
	if (!validateGeneralPanel())
	{
		gotoPanel(GENERAL_PANEL);
		return false;
	}


//	if (!validateAddress(get(CONTACT_DATA_ID)))
//	{
//		gotoPanel(CONTACT_PANEL);
//		return false;
//	}

	return true;
}

function validateGeneralPanel()
{
	var details = get(STORE_DATA_ID);

	if (details == null)
		return true;
		
	if (!isValidUTF8length(details.name, 80))
		put(ERROR_CODE, ERR_DETAILS_NAME);
	else if (!isValidUTF8length(details.description, 32700))
		put(ERROR_CODE, ERR_DETAILS_DESCRIPTION);
	
	if (get(ERROR_CODE) != null)
		return false;

	return true;
}

function validateAddress(address)
{
	if (address == null)
		return true;
	
	if (!isValidUTF8length(address.address1, 50))
		put(ERROR_CODE, ERR_ADDRESS1);
	else if (!isValidUTF8length(address.address2, 50))
		put(ERROR_CODE, ERR_ADDRESS2);
	else if (!isValidUTF8length(address.city, 128))
		put(ERROR_CODE, ERR_CITY);
	else if (!isValidUTF8length(address.state, 128))
		put(ERROR_CODE, ERR_STATE);
	else if (!isValidUTF8length(address.country, 128))
		put(ERROR_CODE, ERR_COUNTRY);
	else if (!isValidUTF8length(address.zipcode, 40))
		put(ERROR_CODE, ERR_ZIPCODE);
	else if (!isValidUTF8length(address.phone, 32))
		put(ERROR_CODE, ERR_PHONE);
	else if (!isValidUTF8length(address.fax, 32))
		put(ERROR_CODE, ERR_FAX);
	else if (!isValidUTF8length(address.email, 254))
		put(ERROR_CODE, ERR_EMAIL);
	
	if (get(ERROR_CODE) != null)
		return false;
		
	return true;
}
