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
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ include file="../common/common.jsp" %>

<%
	String StoreId = null;
	Locale aLocale = null;
	Integer langId = null;
	boolean wrap = true;   
	JSPHelper jspHelper = new JSPHelper(request);
	//***Get storeId from CommandContext
	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	String ErrorMessage = jspHelper.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
	if (ErrorMessage == null)
		ErrorMessage = "";
	if( aCommandContext!= null ) {
		StoreId = aCommandContext.getStoreId().toString();
        aLocale = aCommandContext.getLocale();
        langId = aCommandContext.getLanguageId();
	}
	String rfqId = jspHelper.getParameter("requestId");   
	//no wrapping for the asian languages
	if(langId.intValue() <= -7 && langId.intValue() >= -10) { wrap = false; }   
	// obtain the resource bundle for display    
	Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",aLocale);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title><%= rfqNLS.get("resprdatrrespnd") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfq_skippage.js"></script>
<script type="text/javascript">
var isFirstTimeLogonPanel2;
isFirstTimeLogonPanel2=top.getData("isFirstTimeLogonPanel2");
if (isFirstTimeLogonPanel2 != "0") {
    isFirstTimeLogonPanel2="1";//"1" means first time logon Panel2.
    top.saveData("0","isFirstTimeLogonPanel2");
} 
var rfqCommentsArrary  = new Array();
function setPD() {
	if (isFirstTimeLogonPanel2 == "0") {  //NOT first time log on panel2
		rfqCommentsArrary = top.getData("allTC");
	} else {  //first time log on panel2
<%   
		TermConditionAccessBean tcAb = new TermConditionAccessBean();
     	java.util.Enumeration enu = tcAb.findByTradingAndTCSubType(new Long((String)jspHelper.getParameter("requestId")),"OrderTCOrderComment");
     	int i=0;
     	TermConditionAccessBean aTcAb = null;
     	while (enu != null && enu.hasMoreElements()) {
			aTcAb = (TermConditionAccessBean)enu.nextElement();
			OrderTCOrderCommentAccessBean a = new OrderTCOrderCommentAccessBean();
			a.setInitKey_referenceNumber(aTcAb.getReferenceNumber());
%> 
			rfqCommentsArrary[<%=i%>] = new Object();
			rfqCommentsArrary[<%=i%>].<%=RFQConstants.EC_REQUEST_TC_ID%>=<%=aTcAb.getReferenceNumber()%>;
			rfqCommentsArrary[<%=i%>].<%=RFQConstants.EC_TC_RFQ_LEVEL_COMMENTS%>="<%= UIUtil.toJavaScript(a.getComments()) %>";
			rfqCommentsArrary[<%=i%>].display_rfq="<%= UIUtil.toHTML(UIUtil.toJavaScript(a.getComments())) %>";
			rfqCommentsArrary[<%=i%>].<%=RFQConstants.EC_ATTR_MANDATORY%>= "<%=aTcAb.getMandatoryFlag()%>";
			rfqCommentsArrary[<%=i%>].<%=RFQConstants.EC_ATTR_CHANGEABLE%>= "<%=aTcAb.getChangeableFlag()%>";
			if(rfqCommentsArrary[<%=i%>].<%=RFQConstants.EC_ATTR_MANDATORY%> == 1) {
				rfqCommentsArrary[<%=i%>].<%=RFQConstants.EC_ATTR_RES_CMMENTS_VALUE%>=rfqCommentsArrary[<%=i%>].<%=RFQConstants.EC_TC_RFQ_LEVEL_COMMENTS%>;
				rfqCommentsArrary[<%=i%>].display=rfqCommentsArrary[<%=i%>].display_rfq;
            } else {
            	rfqCommentsArrary[<%=i%>].<%=RFQConstants.EC_ATTR_RES_CMMENTS_VALUE%>="";
            	rfqCommentsArrary[<%=i%>].display="";
            }
<%	  		i++;
        }
%>
		top.saveData(rfqCommentsArrary,"allTC");
	}
}
setPD();
<%
int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
int endIndex = startIndex + listSize;
%>
listSize = <%= listSize %>;
startIndex = <%= startIndex %>;
endIndex   = <%= endIndex %>;
if ((rfqCommentsArrary!=null)&&( rfqCommentsArrary.length > 0) ){
	if (endIndex > rfqCommentsArrary.length){
		endIndex = rfqCommentsArrary.length;
	}
}		
if (startIndex < 0) startIndex=0;
if (rfqCommentsArrary==null || rfqCommentsArrary.length < 1 ){
	endIndex = 0;
	parent.set_t_item(0);
	parent.set_t_page(1);
} else {
	numpage  = Math.ceil(rfqCommentsArrary.length / listSize);
	parent.set_t_item(rfqCommentsArrary.length);
	parent.set_t_page(numpage);
}
function myRefreshButtons() {
    parent.setChecked();
    var aList=new Array();
    aList = parent.getChecked();
    if (aList.length == 0)
       return;       
    var tmp;
    var tmpArray=new Array();    
    var changeable = true;
    for (var i = 0;i<aList.length;i++) {
		tmp = aList[i];
		tmpArray=aList[i].split(',');	
		if(tmpArray[1] == 0) {
	  		changeable = false;
	  		break;
		}
    }   
    var mandatory = false;
    for (var i=0;i<aList.length;i++) {
		tmp = aList[i];
		tmpArray=aList[i].split(',');	    
		if(tmpArray[2] == 1) {
	  		mandatory = true;
	  		break;
		}
    }
    var respondBtn = true;
    var clearBtn =true;
    if(!changeable) respondBtn=clearBtn=false;
    if(mandatory) clearBtn= false; 
    if (parent.buttons.buttonForm.rfqresponseButton && !respondBtn) {
	parent.buttons.buttonForm.rfqresponseButton.className='disabled';
	parent.buttons.buttonForm.rfqresponseButton.disabled=true;
	parent.buttons.buttonForm.rfqresponseButton.id='disabled';
    }
    if (parent.buttons.buttonForm.rfqclearButton && !clearBtn) {
  	parent.buttons.buttonForm.rfqclearButton.className='disabled';
  	parent.buttons.buttonForm.rfqclearButton.disabled=true;
  	parent.buttons.buttonForm.rfqclearButton.id='disabled';
    }    
	return;
} //end function 
function selectDeselectAll() {
	for (var i=0; i<document.rspAttrListForm.elements.length; i++) {
		var e = document.rspAttrListForm.elements[i];
		if (e.name != 'select_deselect') {
			e.checked = document.rspAttrListForm.select_deselect.checked;
		}
	}
	myRefreshButtons();
}
function setSelectDeselectFalse() {
    document.rspAttrListForm.select_deselect.checked = false;
}
function getTCbyID(tcID) {
  	var anTC = new Object();
  	for (var i=0; i < rfqCommentsArrary.length; i++) {
    	if(rfqCommentsArrary[i].<%=RFQConstants.EC_REQUEST_TC_ID%> == tcID) {
      		anTC = rfqCommentsArrary[i];
      		break;
    	}
	}
  	return anTC;
}
function getCheckedTcId() {
    var checkedEntries = parent.getChecked().toString();
    var parms = checkedEntries.split(',');
    var Ids = parms[0];
	return Ids;
}
function getAnTC() { 
	var anTC = new Object();
	var tcID=getCheckedTcId();
	anTC = getTCbyID(tcID);  
	return anTC;
}
function newEntry() {
	if(isButtonDisabled(parent.buttons.buttonForm.rfqresponseButton))
		return;      	   
	var anTC = new Object();
    anTC = getAnTC();
    top.saveData(anTC,"anTC");
    top.saveData(rfqCommentsArrary,"allTC");
    top.saveModel(parent.parent.model);
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqresponseattributerespond";
	if (top.setReturningPanel) 
	 	top.setReturningPanel("rfqterms_panel");
	if (top.setContent) {
		top.setContent(getNewBCT(),url,true);
	} else {
		parent.parent.location.replace(url);
	} 
}
function getNewBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("resTCs")) %>";
}
function retrievePanelData() {
    if (top.getData("anTC") != undefined && top.getData("anTC") != null) {
		parent.parent.model=top.getModel();
    }
}
function savePanelData(){ 
	parent.parent.put("rfq_tc_comments",rfqCommentsArrary );
	return true;
}
function validatePanelData(){
	return true;
}
function isButtonDisabled(b) {
	if (b.className =='disabled' )
		return true;
	return false;
}  
function deleteEntry() { 
	if(isButtonDisabled(parent.buttons.buttonForm.rfqclearButton))
		return;
	var aList = parent.getChecked();
	for(var i = 0;i < rfqCommentsArrary.length;i++) {
		for(var j = 0;j < aList.length;j++)
		if (rfqCommentsArrary[i].<%=RFQConstants.EC_REQUEST_TC_ID%> == aList[j].split(',')[0]) {
			rfqCommentsArrary[i].<%=RFQConstants.EC_ATTR_RES_CMMENTS_VALUE%> = ""; 
            rfqCommentsArrary[i].display = ""; 
		}
	}
	top.saveData(rfqCommentsArrary,"allTC");
	top.saveModel(parent.parent.model);
	parent.document.forms[0].submit();
}	
function onLoad() {
    	skipPages(parent.parent.pageArray);
    	parent.parent.reloadFrames();
	parent.loadFrames();
	parent.loadPanelData();
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
    if (rfqCommentsArrary!=null && rfqCommentsArrary.length > 0)
    {
        document.writeln('<%= rfqNLS.get("instruction_TC") %>');
    }
</script>

<form name="rspAttrListForm" action="">

<%= comm.startDlistTable((String)rfqNLS.get("rfqterms")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"selectDeselectAll()") %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("mandatory"),"null",false,"10%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqchangeable"),"null",false,"10%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("requesttc"),"null",false,"40%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("responsetc"),"null",false,"40%",wrap ) %>
<%= comm.endDlistRow() %>

<script type="text/javascript">
	var checkvalue;
	var s, changeable, mandatory;
	var rowselect = 1;
	s ="";
	changeable="";
	mandatory ="";

  	for (var i=startIndex; i<endIndex; i++) { 
    	checkvalue = rfqCommentsArrary[i].<%=RFQConstants.EC_REQUEST_TC_ID%> + "," +rfqCommentsArrary[i].<%=RFQConstants.EC_ATTR_CHANGEABLE%> + "," + rfqCommentsArrary[i].<%=RFQConstants.EC_ATTR_MANDATORY%>;
		if(rfqCommentsArrary[i].<%=RFQConstants.EC_ATTR_MANDATORY%> == 1) {
			mandatoy = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
		} else {
			mandatoy = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
		}
    	if(rfqCommentsArrary[i].<%=RFQConstants.EC_ATTR_CHANGEABLE%> == 1) {
			changeable = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
		} else {
			changeable = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
		}	
	  	startDlistRow(rowselect);
	  	addDlistCheck(checkvalue, "setSelectDeselectFalse();myRefreshButtons()", null);
	  	addDlistColumn(mandatoy);
	  	addDlistColumn(changeable);
	  	addDlistColumn(rfqCommentsArrary[i].display_rfq);
//	  addDlistColumn(rfqCommentsArrary[i].<%=RFQConstants.EC_TC_RFQ_LEVEL_COMMENTS%>);
//	  addDlistColumn(rfqCommentsArrary[i].<%=RFQConstants.EC_ATTR_RES_CMMENTS_VALUE%>);
	  	addDlistColumn(rfqCommentsArrary[i].display);
	    endDlistRow();
        if ( rowselect == 1 ) rowselect = 2; else rowselect = 1;
	}

</script>

<%= comm.endDlistTable() %>

</form>

<script type="text/javascript">
    if (rfqCommentsArrary == null || rfqCommentsArrary.length == 0)
    {
        document.writeln('<%= rfqNLS.get("msgnotcs") %>');
    }
</script>

<script type="text/javascript">
	retrievePanelData();
</script>
	
<script type="text/javascript">
<!--
parent.afterLoads();
if (rfqCommentsArrary != null) parent.setResultssize(rfqCommentsArrary.length);
else parent.setResultssize(0);
//-->
</script>

</body>
</html>
