<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.rfq.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>
<%
	Locale aLocale = null;
	Integer langId = null;
	boolean wrap = true;   
	RFQResponseDataBean RFQres = new RFQResponseDataBean();
	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");  
	JSPHelper jsphelper = new JSPHelper(request);       
	if( aCommandContext!= null ) {
		aLocale = aCommandContext.getLocale();
		langId = aCommandContext.getLanguageId();
	}
	if (aLocale == null) {
		aLocale = new Locale("en","US");
	}	
	String ResponseId = jsphelper.getParameter("offerId" );
	RFQres.setInitKey_rfqResponseId(Long.valueOf(ResponseId));
	String RequestId =RFQres.getRfqId();
	// obtain the resource bundle for display
	Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",aLocale);
	//no wrapping for the asian languages
	if(langId.intValue() <= -7 && langId.intValue() >= -10) { wrap = false; }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfq_skippage.js"></script>

<script type="text/javascript">
function CommentsTC(mandatory,changeable,req_tc_id,req_comments,res_tc_id,res_comments,req_display,res_display){
	this.<%= RFQConstants.EC_ATTR_MANDATORY %>=mandatory;
	this.<%= RFQConstants.EC_ATTR_CHANGEABLE %>=changeable;
	this.<%= RFQConstants.EC_REQUEST_TC_ID %> = req_tc_id;
	this.<%= RFQConstants.EC_ATTR_REQ_COMMENTS_VALUE %> = req_comments;
	this.req_display = req_display;
	this.<%= RFQConstants.EC_ATTR_RES_COMMENTS_VALUE %>=res_comments;
	this.res_display = res_display;
	this.<%= RFQConstants.EC_RESPONSE_TC_ID %>=res_tc_id;
	this.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> ="<%= RFQConstants.EC_RFQ_CHANGE_FALSE %>";
}
//SECOND STEP, GET RFQ-RES LEVEL COMMENTS
//if the first time come in, read data from database
//otherwise, using the data in javascript.
var rfqCommentsArrary = new Array() ;
function initData() {
	rfqCommentsArrary = new Array();
<%
	RFQResCommentsPair[] commentsPair = RFQResProdHelper.getRFQLevelCommentsPair(RequestId,ResponseId,null);
	for (int index=0; commentsPair  != null && index <commentsPair.length; index++) {
%>
		rfqCommentsArrary[<%= index %>] = new CommentsTC("<%= commentsPair[index].getMandatory() %>","<%= commentsPair[index].getChangeable()%>",<%= commentsPair[index].getRFQ_TC_ID() %>," <%= UIUtil.toJavaScript((String)commentsPair[index].getRFQ_value())%>",<%= commentsPair[index].getRes_TC_ID() %>,"<%= UIUtil.toJavaScript((String)commentsPair[index].getRes_value())%>"," <%= UIUtil.toHTML(UIUtil.toJavaScript((String)commentsPair[index].getRFQ_value()))%>","<%= UIUtil.toHTML(UIUtil.toJavaScript((String)commentsPair[index].getRes_value()))%>");
<%	
	}
%>
	parent.parent.put("<%= RFQConstants.EC_TC_RFQ_LEVEL_COMMENTS %>",rfqCommentsArrary);
}
rfqCommentsArrary = parent.parent.get("<%= RFQConstants.EC_TC_RFQ_LEVEL_COMMENTS %>");
if (rfqCommentsArrary == undefined || rfqCommentsArrary == null) {
	initData();
}	
function onLoad() { 
        skipPages(parent.parent.pageArray);
        parent.parent.reloadFrames();
   	parent.loadFrames();
	parent.parent.setContentFrameLoaded(true);
}
function savePanelData() {
	parent.parent.put("<%= RFQConstants.EC_TC_RFQ_LEVEL_COMMENTS %>",rfqCommentsArrary);
}
function modifyEntry() {
	if(isButtonDisabled(parent.buttons.buttonForm.changeButton))
		return;
	var index= new Array();
	var checkindex;
	index = getCheckedTCs();	
	var i = index[0].Id;
	top.saveData(rfqCommentsArrary[i],"<%= RFQConstants.EC_TC_RFQ_LEVEL_COMMENT %>");
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqresponseattributerespondmodify";
	top.saveModel(parent.parent.model);
	top.setReturningPanel("rfqterms_panel");
	top.setContent("<%= UIUtil.toJavaScript(rfqNLS.get("resTCs")) %>", url, true);		
}
function getNewBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("res_restc")) %>";
}
function isButtonDisabled(b) {
	if (b.className =='disabled' ) 
		return true;
	return false;
}       

function deleteEntry() { 
	if(isButtonDisabled(parent.buttons.buttonForm.rfqclearButton))
		return;
	var index= new Array();
	var form = document.rfqCommentsTcForm;
	index = getCheckedTCs();
	for ( var i =0;i<index.length;i++) {
		rfqCommentsArrary[index[i].Id].<%= RFQConstants.EC_ATTR_RES_COMMENTS_VALUE %>="";
		rfqCommentsArrary[index[i].Id].res_display="";
		rfqCommentsArrary[index[i].Id].<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_TRUE %>";
		savePanelData();
	}
	parent.document.forms[0].submit();	
}
function getCheckedTCs() {
	var temp;
	var theArray = new Array();
	var objArray = new Array();
	var form = document.rfqCommentsTcForm;
	for (var i=0;i< form.elements.length;i++) {
    	if (form.elements[i].type == 'checkbox' && form.elements[i].checked && form.elements[i].name != "select_deselect") {		
      		theArray[theArray.length] = form.elements[i].name;
      	}
  	}
  	if (theArray.length != null && theArray.length > 0) {
    for (var j=0;j<theArray.length;j++) {
      	temp = theArray[j].split(",");
      	objArray[j] = new Object;
      	objArray[j].Id = temp[0];
      	objArray[j].changeable = temp[1];
      	objArray[j].mandatory = temp[2]; }
  	}
	return objArray;
}
function selectDeselectAll() {
	for (var i=0; i<document.rfqCommentsTcForm.elements.length; i++) {
		var e = document.rfqCommentsTcForm.elements[i];
		if (e.name != 'select_deselect') {
			e.checked = document.rfqCommentsTcForm.select_deselect.checked;
		}
	}
	myRefreshButtons();
}
function setSelectDeselectFalse() {
	document.rfqCommentsTcForm.select_deselect.checked = false;
}
function myRefreshButtons() {
	parent.setChecked();
	var objArray = new Array();
	objArray = parent.getChecked();
	if (objArray.length == 0)
		return;
	var tmp;
	var tmpArray=new Array();    
	var changeable = true;
	for (var i = 0; i<objArray.length; i++) {
		tmp = objArray[i];
		tmpArray=objArray[i].split(',');
		if(tmpArray[1] == 0) {
	  		changeable = false;
	  		break;
		}
	}  
    var mandatory = false;
    for (var i=0;i<objArray.length;i++) {
		tmp = objArray[i];
		tmpArray=objArray[i].split(',');
		if(tmpArray[2] == 1) {
	  		mandatory = true;
	  		break;
		}
    }
    var respondBtn = true;
    var clearBtn =true;
    if(!changeable) respondBtn=clearBtn=false;
    if(mandatory) clearBtn= false; 
    if (parent.buttons.buttonForm.changeButton && !respondBtn) {
		parent.buttons.buttonForm.changeButton.className='disabled';
		parent.buttons.buttonForm.changeButton.disabled=true;
		parent.buttons.buttonForm.changeButton.id='disabled';
    }
    if (parent.buttons.buttonForm.rfqclearButton && !clearBtn) {
  		parent.buttons.buttonForm.rfqclearButton.className='disabled';
  		parent.buttons.buttonForm.rfqclearButton.disabled=true;
  		parent.buttons.buttonForm.rfqclearButton.id='disabled';
    }    
	return;
}
function userInitialButtons() {
	parent.setChecked();

	var objArray = new Array();
	objArray = parent.getChecked();
	if (objArray.length == 0)
    	return;

	var tmp;
	var tmpArray=new Array();
    
	var changeable = true;
    for (var i = 0;i<objArray.length;i++) {
		tmp = objArray[i];
		tmpArray=objArray[i].split(',');
		if(tmpArray[1] == 0) {
	  		changeable = false;
	  		break;
		}
    }    
    var mandatory = false;
    for (var i=0;i<objArray.length;i++) {
		tmp = objArray[i];
		tmpArray=objArray[i].split(',');
		if(tmpArray[2] == 1) {
	  		mandatory = true;
	  		break;
		}
    }
    var respondBtn = true;
    var clearBtn =true;
    if(!changeable) respondBtn=clearBtn=false;
    if(mandatory) clearBtn= false; 
    if (parent.buttons.buttonForm.changeButton && !respondBtn) {
		parent.buttons.buttonForm.changeButton.className='disabled';
		parent.buttons.buttonForm.changeButton.disabled=true;
		parent.buttons.buttonForm.changeButton.id='disabled';
    }
    if (parent.buttons.buttonForm.rfqclearButton && !clearBtn) {
  		parent.buttons.buttonForm.rfqclearButton.className='disabled';
  		parent.buttons.buttonForm.rfqclearButton.disabled=true;
  		parent.buttons.buttonForm.rfqclearButton.id='disabled';
    }    
	return;
}
</script>
</head>
<body class="content_list">
<script type="text/javascript">
<!--
//For IE
if (document.all) { onLoad(); }
//-->
</script>

<script type="text/javascript">
    if (rfqCommentsArrary != null && rfqCommentsArrary.length > 0) 
    {
        document.writeln('<%= rfqNLS.get("instruction_TC_modify") %>');
    }
</script>

<form name="rfqCommentsTcForm" id="rfqCommentsTcForm" action="">
<script type="text/javascript">
<%
int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
int endIndex = startIndex + listSize;
%>
listSize = <%= listSize %>;
startIndex = <%= startIndex %>;
endIndex = <%= endIndex %>;
if ((rfqCommentsArrary!=null)&&( rfqCommentsArrary.length > 0) ) {
	if (endIndex > rfqCommentsArrary.length){
		endIndex = rfqCommentsArrary.length;
	}
}		
if (startIndex < 0) startIndex=0;
if (rfqCommentsArrary == null || rfqCommentsArrary.length < 1 ) {
	endIndex = 0;
	parent.set_t_item(0);
	parent.set_t_page(1);
} else {
	numpage  = Math.ceil(rfqCommentsArrary.length / listSize);
	parent.set_t_item(rfqCommentsArrary.length);
	parent.set_t_page(numpage);
}
</script>

	<%= comm.startDlistTable((String)rfqNLS.get("rfqlisttitle")) %>
	<%= comm.startDlistRowHeading() %>
	<%= comm.addDlistCheckHeading(true,"selectDeselectAll()") %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("mandatory"),"null",false,"10%",wrap ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqchangeable"),"null",false,"10%",wrap ) %>	
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("requesttc"),"null",false,"40%",wrap ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("responsetc"),"null",false,"40%",wrap ) %>
	<%= comm.endDlistRow() %>
<script type="text/javascript">
function output() {
  	var checkvalue;
  	var rowselect = 1;
	if (rfqCommentsArrary == null && rfqCommentsArrary.length == 0) return;
	for (var i = startIndex ;i <endIndex;i++) { 
    	checkvalue = i + "," +rfqCommentsArrary[i].<%=RFQConstants.EC_ATTR_CHANGEABLE%> + "," +rfqCommentsArrary[i].<%=RFQConstants.EC_ATTR_MANDATORY%>;
   	 	startDlistRow(rowselect);
    	addDlistCheck(checkvalue, "setSelectDeselectFalse();myRefreshButtons();",null);
    	if(rfqCommentsArrary[i].<%=RFQConstants.EC_ATTR_MANDATORY%> == 1) {
			mandatoy = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
		} else {
			mandatoy = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
		}
    	addDlistColumn(mandatoy);
    	if(rfqCommentsArrary[i].<%=RFQConstants.EC_ATTR_CHANGEABLE%> == 1) {
			changeable = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
		} else {
			changeable = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
		}
    	addDlistColumn(changeable);
//    	addDlistColumn(rfqCommentsArrary[i].<%= RFQConstants.EC_ATTR_REQ_COMMENTS_VALUE %>);
//    	addDlistColumn(rfqCommentsArrary[i].<%= RFQConstants.EC_ATTR_RES_COMMENTS_VALUE %>);
    	addDlistColumn(rfqCommentsArrary[i].req_display);
    	addDlistColumn(rfqCommentsArrary[i].res_display);
    	endDlistRow();
		if ( rowselect == 1 ) rowselect = 2; else rowselect = 1;
	}
	endDlistTable();
	return;
}
output();
</script>
</form>
<br />
<script type="text/javascript">
    if (rfqCommentsArrary == null || rfqCommentsArrary.length == 0)
    {
        document.writeln('<%= rfqNLS.get("msgnotcs") %>');
    }
</script>

<script type="text/javascript">
parent.afterLoads();
if (rfqCommentsArrary!= null)
	parent.setResultssize(rfqCommentsArrary.length);
else
	parent.setResultssize(0);
</script>
</body>
</html>
