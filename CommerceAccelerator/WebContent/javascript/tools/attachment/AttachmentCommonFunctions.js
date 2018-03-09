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

/**
*  global Variables
*/
	var toolTipXOffSet = 13;
	var toolTipYOffSet = -13;
	var previewPath = '/webapp/wcs/preview';
	var urlParser = null;
	var port = '';
	var urlForPreview = '';

/**
*	submitFunction
*
*	@param	action 	- action type (update, create, or delete)
*	@param	obj 	- object
*/
function submitFunction(action, obj, formName)
{

	eval(formName + '.action = action;');
	eval(formName + '.XML.value = convertToXML(obj, "XML");');
	eval(formName + '.submit();');
}

/**
*	Construct the preview path for attachment.  This method assume the port variable is set in the jsp
*/
function getPreviewPath() 
{
	if (urlParser != null) {
		return urlParser.getProtocol() + "://" + urlParser.getServerName() + ":" + port + previewPath;
	}
	
	return '';
}

/**
*	Set the port for the preview webapp
*/
function setPort(port) {
	this.port = port;
}

/**
*	AttachnmentTargetObj
*
*	@param	atchTgtId 	- Attachment Target Id
*	@param	identifier 	- Identifier
*	@param	storeId 	- Store Id
*	@param	memberId 	- Member Id
*	@param	description 	- Descriptions
*/
function AttachmentTargetObj(atchTgtId, identifier, storeId, memberId)
{
	this.atchTgtId		= atchTgtId;
	this.identifier		= identifier;
	this.storeId		= storeId;
	this.memberId		= memberId;
	this.description	= new Array();
	
	this.editable = true;
}

AttachmentTargetObj.prototype.addDesc = addAttachmentTargetDesc;
AttachmentTargetObj.prototype.getDesc = getAttachmentTargetDesc;

	function addAttachmentTargetDesc(langId, name, shortDesc, longDesc) {

		var index = -1;
		
		for (var i = 0; i < this.description.length; i++) {
			if (this.description[i].languageId == langId) {
				index = i;
				break;
			}
		}
		
		if (index == -1) index = this.description.length;
		
		this.description[index] 		= new Object();
		this.description[index].languageId	= langId;
		this.description[index].name 		= name;
		this.description[index].shortDesc 	= shortDesc;
		this.description[index].longDesc 	= longDesc;
	}
	
	function getAttachmentTargetDesc(langId) {
	
		var index = 0;
		
		for (var i = 0; i < this.description.length; i++) {
			if (this.description[i].languageId == langId) return this.description[i];
		}
		
		return null;
	}

/**
*	AttachmentRelationObj
*
*	@param	atchRelId 	- Attachment Relation Id
*	@param	objectId 	- Object Id
*	@param	targetId 	- Attachment Target Id
*	@param	usageId 	- Usage Id
*	@param	seq	 	- Sequence
*	@param	description 	- Descriptions
*	@param	objectType 	- Object Type
*/
function AttachmentRelationObj(atchRelId, objectId, targetId, usageId, seq, objectType) {

	this.atchrelId		= atchRelId;
	this.objectId		= objectId;
	this.atchobjtyp 	= objectType;
	this.targetId		= targetId;
	this.usageId		= usageId;
	this.seq		= seq;
	this.description	= new Array();
}

AttachmentRelationObj.prototype.updateDesc = updateAttachmentTargetDesc;
AttachmentRelationObj.prototype.getDesc = getAttachmentTargetDesc;

	function updateAttachmentTargetDesc(langId, name, shortDesc, longDesc) {

		var index = -1;
		
		for (var i = 0; i < this.description.length; i++) {
			if (this.description[i].languageId == langId) {
				index = i;
				break;
			}
		}
		
		if (index == -1) index = this.description.length;
		
		this.description[index] 		= new Object();
		this.description[index].languageId	= langId;
		this.description[index].name 		= name;
		this.description[index].shortDesc 	= shortDesc;
		this.description[index].longDesc 	= longDesc;
	}

	function getAttachmentRelationDesc(langId) {
	
		var index = 0;
		
		for (var i = 0; i < this.description.length; i++) {
			if (this.description[i].languageId == langId) return this.description[i];
		}
		
		return null;
	}

/**
*	AttachmentAsset
*
*	@param	atchAstId 	- Attachment Asset Id
*	@param	storeId 	- Store Id
*	@param	atchTgtId 	- Attachment Target Id
*	@param	atchAstPath 	- Attachment Asset Path
*	@param	directoryPath 	- Directory Path
*	@param	mimeType 	- Mime Type
*	@param	image1 		- Icon URL
*/
function AttachmentAsset(atchastId, storeId, atchtgtId, assetPath, directoryPath, mimeType, image1, storeDir) {

	this.atchastId 		= atchastId;
	this.storeId 		= storeId;
	this.atchtgtId 		= atchtgtId;
	this.assetPath 		= assetPath;
	this.directoryPath 	= directoryPath;
	this.mimeType 		= mimeType;
	this.image1 		= image1;
	this.language		= new Array();
	this.remove		= false;
	this.storeDir		= storeDir;
	this.action		= "update";
}

AttachmentAsset.prototype.setLang = setAttachmentAssetLang;
AttachmentAsset.prototype.getAssetPath = getAssetPath;
AttachmentAsset.prototype.getImagePath = getImagePath;
AttachmentAsset.prototype.getCMFilePath = getCMFilePath;

	function setAttachmentAssetLang(language) {
	
		this.language = language;
	}
	
	function getAssetPath() {
	
		var path = "";
		
		// url
		if (this.mimeType == '') {
		
			path = this.assetPath;
			
		} else {
		
			path = getPreviewPath() + '/' + this.storeDir + '/' + this.assetPath;
		}
		
		return path;
	
	}
	
	function getImagePath(previewMimeType) {
	
		var path = "";
		
		if (this.mimeType == '') {
		
			path = '/wcs/images/tools/attachment/generic_file.jpg';
			
		} else if (isPreviewMimeType(this.mimeType, previewMimeType)) {
		
			path = getPreviewPath() + '/' + this.storeDir + '/' + this.assetPath;
		
		} else {
			path = '/wcs/images/tools/attachment/generic_file.jpg';
		}
		
		return path;
	}
	
	function getCMFilePath() {
	
		if (this.mimeType != '') {
			return '/' + this.storeDir + '/' + this.assetPath;
		}
		
		return this.assetPath;
	}
	
	
/**
*	AttachmentFileSet
*/
function AttachmentFileSet() {

	this.fileset = new Array();
}

AttachmentFileSet.prototype.updateFile = updateAttachmentFileSet;
AttachmentFileSet.prototype.getFile = getAttachmentFileSet;
AttachmentFileSet.prototype.getSelectedFiles = getSelectedAttachmentFileSet;
AttachmentFileSet.prototype.checkAll = checkAllAttachmentFileSet;
AttachmentFileSet.prototype.checkFile = checkFileAttachmentFileSet;



	function updateAttachmentFileSet(filename, cmFilePath, atchtgtId, checked, mimeType) {
	
		var index = -1;
		
		for (var i = 0; i < this.fileset.length; i++) {
			if (this.fileset[i].filename == filename) {
				index = i;
				break;
			}
		}
		
		if (index == -1) index = this.fileset.length;
		
		this.fileset[index] 		= new Object();
		this.fileset[index].filename	= filename;
		this.fileset[index].cmFilePath 	= cmFilePath;
		this.fileset[index].atchtgtId 	= atchtgtId;
		this.fileset[index].mimeType 	= mimeType;
		this.fileset[index].checked 	= checked;

		if (mimeType != "") {
			this.fileset[index].assetPath = getStoreRelativePath(cmFilePath);
		} else {
			this.fileset[index].assetPath = cmFilePath;
		}
	}
	
	function getAttachmentFileSet(filename) {
	
		var index = 0;
		
		for (var i = 0; i < this.fileset.length; i++) {
			if (this.fileset[i].filename == filename) return this.fileset[i];
		}
		
		return null;
	}

	function checkFileAttachmentFileSet(cmFilePath, check) {
	
		for (var i = 0; i < this.fileset.length; i++) {
			if (this.fileset[i].cmFilePath == cmFilePath) {
				this.fileset[i].checked = check;
				return;
			}
		}
		
		return;
	}

	function getSelectedAttachmentFileSet() {
	
		var selectedFileSet = new Array();
		var index = 0;
	
		for (var i = 0; i < this.fileset.length; i++) {
			if (this.fileset[i].checked) {
			
				index = selectedFileSet.length;
				
				selectedFileSet[index] 			= new Object();
				selectedFileSet[index].filename 	= this.fileset[i].filename;
				selectedFileSet[index].assetPath 	= this.fileset[i].assetPath;
				selectedFileSet[index].atchtgtId 	= this.fileset[i].atchtgtId;
				selectedFileSet[index].mimeType 	= this.fileset[i].mimeType;
				selectedFileSet[index].checked 		= this.fileset[i].checked;
				selectedFileSet[index].cmFilePath 	= this.fileset[i].cmFilePath;
			}
		}
		
		return selectedFileSet;
	}
	
	function checkAllAttachmentFileSet(checked) {
		
		for (var i = 0; i < this.fileset.length; i++) {
			this.fileset[i].checked = checked;
		}
	}




/**
*	inspect
*/
function inspect(obj) {
	var output = "";

	if (obj == null) {
		return null;
	}
	else {
		for (var i in obj) {
			output += i + " : " + obj[i] + "\n";
		}
		return output;
	}
}

/**
*	return path without the store directory
*/
function getStoreRelativePath(path) {

	var index = path.indexOf("/", 1) + 1;
	
	return path.substr(path.indexOf("/", 1) + 1);
}

/**
*	return true if the mimeType is in mimeTypes array, false otherwise
*/
function isPreviewMimeType(mimeType, mimeTypes) {

	for (var i = 0; i < mimeTypes.length; i++) {
		if (mimeType == mimeTypes[i]) return true;
	}
	return false;
}

/**
*	clone an array
*/	
function cloneArray(a1) {

	var a2 = new Array();

	for (var i = 0; i < a1.length; i++) {
		a2[a2.length] = a1[i];
	}

	return a2;
}

/**
*	set the mouse event for the tooltip
*
*  @param e the tooltip event
*/
function setMousePosition(e) {

	var x = event.x + document.body.scrollLeft;
	var y = event.y + document.body.scrollTop;

	tooltipDiv.style.left = x + toolTipXOffSet;
	tooltipDiv.style.top = y + toolTipYOffSet;
}

/**
*	show tooltip
*/
function toolTipOn(str) {

	var tooltip = "<table class=attachmentToolTip border=0 cellpadding=1 cellspacing=1><tr><td><font class=attachmentToolTipFont>" + str + "</font></td></tr></table>";

	tooltipDiv.innerHTML = tooltip;
	tooltipDiv.style.visibility = "visible";

}

/**
*	hide tooltip
*/
function toolTipOff() {

	tooltipDiv.innerHTML = "";
	tooltipDiv.style.visibility = "hidden";
}

/**
*	put the parameters to the previous page
*/
function putBackPara(key, value) {

	if (top.mccbanner.trail[top.mccbanner.counter-1].parameters != null) {
		top.mccbanner.trail[top.mccbanner.counter-1].parameters[key] = value;
	} else {
	
		var location = top.mccbanner.trail[top.mccbanner.counter-1].location;
		var token = "?";
		var para;
		
		if (location.indexOf('?', 0) > 0) {
			token = "&";
		}
		
		para = token + key + "=" + value;
		top.mccbanner.trail[top.mccbanner.counter-1].location += para;
	}
}