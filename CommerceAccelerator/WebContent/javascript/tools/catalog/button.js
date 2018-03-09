//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2006, 2009 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

//
//

/////////////////////////////////////////////////////////////////////////////////////
// beginButtonTable()
//
// - begin the button table 
/////////////////////////////////////////////////////////////////////////////////////
function beginButtonTable()
{
	document.writeln("<TABLE BORDER=0 CELLPADDING=1 CELLSPACING=0>");
}	

/////////////////////////////////////////////////////////////////////////////////////
// endButtonTable()
//
// - end the button table 
/////////////////////////////////////////////////////////////////////////////////////
function endButtonTable()
{
	document.writeln("</TABLE>");
}

/////////////////////////////////////////////////////////////////////////////////////
// drawButton(strBtnName, strBtnValue, strOnClick, strBtnClass )
//
// - draw a button
/////////////////////////////////////////////////////////////////////////////////////
function drawButton(strBtnName, strBtnValue, strOnClick, strBtnClass )
{
    var strButton;
    
    if(strBtnClass==null)
    	strBtnClass="disabled";

	strButton = "<TR id=\"" + strBtnName+ "_tr_id\" ";
	strButton += ">";
	
	strButton += "<td class=button1>";
	
	strButton += "<BUTTON type=\"BUTTON\"  value=\"";
	strButton += strBtnValue;
	strButton += "\" name=\"" + strBtnName + "\" ";
	strButton += "CLASS=" + strBtnClass;
	strButton += " onclick=\"";
	strButton += strOnClick + "\" > ";

	strButton += "<span class='buttonText'>"
	strButton += strBtnValue;
	strButton += "</span>";

	strButton += "</BUTTON>";

	strButton += "</td>";
        
	//strButton += "<td class=button_image>";
	//strButton += "<img alt= src=\"/wcs/images/tools/list/but_curve2.gif\" width=\"9\" height=\"100%\">";
	//strButton += "</td>";
	strButton += "</TR>";
	strButton += "<TR style=\"height:1px\">";
	strButton += "<TD></TD>";
	strButton += "</TR>";
	
    document.writeln(strButton);
}

/////////////////////////////////////////////////////////////////////////////////////
// drawInputBox(strName, strLength, strValue, strTitle, strClass)
//
// - draw an input box
/////////////////////////////////////////////////////////////////////////////////////
function drawInputBox(strName, strLength, strValue, strTitle, strClass, strCode)
{
	if (strClass == null) strClass = "dtable";

	var strButton = "";
	var inputWidth = "";
	if (strTitle != null)
	{
		strButton += "<TR><TD COLSPAN=2>"+strTitle+"</TD></TR>";
	}
	
	if (strLength != null) {
		inputWidth = " width=" + strLength + " ";
	}
	
	strButton += "<TR>";
	strButton += "<TD" + inputWidth + ">";
	strButton += "<INPUT NAME=\""+strName+"\" CLASS="+strClass;
	strButton += inputWidth;
	strButton += " VALUE=\""+strValue+"\"" + strCode + " STYLE='background-color:#FFFFFF;'>";
	strButton += "</TD><TD></TD></TR>";
	strButton += "<TR style=\"height:1px\">";
	strButton += "<TD COLSPAN=2></TD>";
	strButton += "</TR>";
	document.writeln(strButton);
}

/////////////////////////////////////////////////////////////////////////////////////
// AdjustRefreshButton(btn)
//
// - adjust the size of the button
/////////////////////////////////////////////////////////////////////////////////////
/**
function AdjustRefreshButton(btn)
{
    var textObj;
    var textHeight = 0;
    var buttonHeight = 0;
    var buttonPadding = 7;

	if(btn)
	{
	   btn.style.wordWrap='break-word';
	   textObj = btn.firstChild;
	   textHeight = textObj.clientHeight;
	   buttonHeight = textHeight + buttonPadding;
	   btn.style.height = buttonHeight;
	}
}
**/

/* Adjust the button height for mult-language and different font */

function AdjustRefreshButton(butName) {
	var buttonWidth = "125px";

	if(butName) {	
		if (butName.className.toLowerCase() == "disabled") {
			butName.disabled = true;
		} 
		else if (butName.className.toLowerCase() == "enabled") {
			butName.disabled = false;
		} 
		
		butName.style.width = buttonWidth;		
	}
}


function AdjustRefreshButtonWithWidth(butName, width) {
	
	var buttonWidth = "125px";
	
	if(width != null && width != 'undefined')
	{
		buttonWidth = width;
	}

	if(butName) {	
		if (butName.className.toLowerCase() == "disabled") {
			butName.disabled = true;
		} 
		else if (butName.className.toLowerCase() == "enabled") {
			butName.disabled = false;
		} 
		
		butName.style.width = buttonWidth;		
	}
}


/////////////////////////////////////////////////////////////////////////////////////
// enableButton(btn, bEnable)
//
// - enable or disable a button
/////////////////////////////////////////////////////////////////////////////////////
function enableButton(btn, bEnable)
{
	if(bEnable) {
		btn.className= 'ENABLED';
		btn.disabled = false;
	}
	else {
		btn.className= 'DISABLED';
		btn.disabled = true;
	}
}

/////////////////////////////////////////////////////////////////////////////////////
// isButtonEnabled(btn)
//
// - check if a button is enable or disable
/////////////////////////////////////////////////////////////////////////////////////
function isButtonEnabled( btn)
{
	return (btn.className.toUpperCase()=='ENABLED');
}

/////////////////////////////////////////////////////////////////////////////////////
// drawEmptyButton()
//
// - draw an empty row 
/////////////////////////////////////////////////////////////////////////////////////
function drawEmptyButton()
{
	var strButton = "";
	strButton += "<TR style=\"height:20px\">";
	strButton += "<TD></TD>";
	strButton += "<TD></TD>";
	strButton += "</TR>";
	document.writeln(strButton);
}

/////////////////////////////////////////////////////////////////////////////////////
// hideButton(btn, value)
//
// @param btn - the button to be affected
// @param value - the value to be assigned to the style.display of the row
//                containing the button
//
// - hide or display the button
/////////////////////////////////////////////////////////////////////////////////////
function hideButton(btn, value)
{
	var rowIndex = btn.parentNode.parentNode.rowIndex;
	var tableElement = btn.parentNode;
	while (tableElement.tagName != "TABLE") { tableElement = tableElement.parentNode; }
	tableElement.rows(rowIndex).style.display = value;
	tableElement.rows(rowIndex+1).style.display = value;
}
