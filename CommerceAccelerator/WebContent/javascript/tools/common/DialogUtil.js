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

function removeScrolling()
{
	resizeWindow(getHiddenWindowWidth(), getHiddenWindowHeight() + 18);
}

function resizeWindow(x, y)
{
	window.dialogWidth = getWindowWidth() + x + "px";
	window.dialogHeight = getWindowHeight() + y + "px";
}

function getHiddenWindowWidth()
{
	return document.body.scrollWidth - document.body.clientWidth;
}

function getHiddenWindowHeight()
{
	return document.body.scrollHeight - document.body.clientHeight;
}

function getWindowWidth()
{
	return pxToNumber(window.dialogWidth);
}

function getWindowHeight()
{
	return pxToNumber(window.dialogHeight);
}

//parseInt()
function pxToNumber(px)
{
	return toNumber(stripPX(px));
}

function toNumber(str)
{
	return Math.abs(str);	
}

function stripPX(px)
{
	return px.slice(0, -2);	
}
