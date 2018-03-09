<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 

<%@ page import="java.text.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.ras.*"%>
<%@ page import="com.ibm.commerce.rfq.beans.*"%>
<%@ page import="com.ibm.commerce.rfq.objects.*"%>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.utf.objects.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.server.*"%>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.PriceTCMasterCatalogWithFilteringDataBean" %>
<%@ page import="com.ibm.commerce.contract.helper.ECContractConstants" %>
<%@ include file="../common/common.jsp" %>

<jsp:useBean id="responseList" class="com.ibm.commerce.rfq.beans.RFQResponseListBean" ></jsp:useBean>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
    String ErrorMessage = request.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);

    Locale aLocale = cmdContext.getLocale();
    if (aLocale==null) {
		aLocale= new Locale("en","US");
    }
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", aLocale);
    Integer lang = cmdContext.getLanguageId();
    String StoreId = cmdContext.getStoreId().toString();    
    JSPHelper jsphp=new JSPHelper(request);
    String rfqId = jsphp.getParameter("rfqId"); 
       
    //String hasPP = jsphp.getParameter("haspp");   //pass this value to "new" button 
    String hasPP = "pp";   
    String createResponseWithPP = hasPP;
	//String showSummaryWithPP = hasPP;
	
    RFQDataBean rfq=new RFQDataBean();
    rfq.setRfqId(rfqId);    
    String rfqName;
    String rfqState;
    rfqName=rfq.getName();
    rfqState=rfq.getState();
    String msgResponseListHeading= (String)rfqNLS.get("rfqbuyerresponselistheading");
    Object[] parms = new Object[1];
    parms[0] = rfqName;
    msgResponseListHeading = ECMessageHelper.doubleTheApostrophy(msgResponseListHeading);
    msgResponseListHeading = MessageFormat.format(msgResponseListHeading, parms);    
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title><%= rfqNLS.get("rfqlisttitle") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<%
    if (ErrorMessage != null) 
    { 
%>
<script type="text/javascript">
	alertDialog("<%= UIUtil.toJavaScript(ErrorMessage) %>");
</script>
<%
    }   
%>

<script type="text/javascript"> 
function getChangeBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_res_change")) %>";
}
function getRfqId() {
	return "<%=jsphp.getParameter("rfqId")%>";
}
function getUserNLSTitle() {
	return '<%= UIUtil.toJavaScript(msgResponseListHeading) %>';
}
function createResponse() {
	if (parent.scrollcontrol.document.ControlPanelForm) {
		var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
		top.put(parent.view_select_name, op.selectedIndex);
	}
	var requestId;
	requestId = "<%=jsphp.getParameter("rfqId")%>";	
	top.setContent(getRespondBCT(), '/webapp/wcs/tools/servlet/NotebookView?XMLFile=rfq.rfqResponseCreateNotebook&amp;requestId='+requestId,true);
}
function getRespondBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqresponsenew")) %>";
}
function ChangeResponse() {
	if(isButtonDisabled(parent.buttons.buttonForm.changeButton)) {
		return;
	}
	if (parent.scrollcontrol.document.ControlPanelForm) {
	    var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
	    top.put(parent.view_select_name,op.selectedIndex);
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var resId = parms[0];	
	top.setContent(getChangeBCT(),'/webapp/wcs/tools/servlet/NotebookView?XMLFile=rfq.rfqResponseModifyNotebook&amp;offerId='+resId,true);
}
function isButtonDisabled(b) {
	if (b.className =='disabled' ) {
		return true;
	}
	return false;
} 
function DisableNewButton() {
	var reqState;
	var active=<%= com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_ACTIVE %>;
	reqState="<%=rfqState%>";
	if (reqState !=active) {
	    parent.hideButton('new');
	}
}	 
function submitres()  {
    if(isButtonDisabled(parent.buttons.buttonForm.submitButton)) {
    	return;
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var resId = parms[0];
	var rfqId = "<%=jsphp.getParameter("rfqId")%>";
	var eventid="<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_SUBMIT_RFQ_RESPONSE_EVENT_IDENTIFIER %>";
	if (!confirmDialog("<%= UIUtil.toJavaScript(rfqNLS.get("submitRsp")) %>")) {
	    return;
	}
	parent.location.replace("/webapp/wcs/tools/servlet/RFQResponseSubmit?redirecturl=NewDynamicListView&ActionXMLFile=rfq.rfqresponselist&cmd=RFQResponseList&selected=SELECTED&listsize=15&startindex=0&rfqId="+rfqId+"&<%=BusinessFlowConstants.EC_ENTITY_ID%>=" + resId + "&flowType=RFQResponse&event="+eventid);
}
function cancelres() {
	if(isButtonDisabled(parent.buttons.buttonForm.cancelButton)) {
		return;
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var resId = parms[0];
	var rfqId = "<%=jsphp.getParameter("rfqId")%>";
	var eventid="<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_CANCEL_RFQ_RESPONSE_EVENT_IDENTIFIER %>";
	if (!confirmDialog("<%= UIUtil.toJavaScript(rfqNLS.get("cancelRsp")) %>")) {
	    return;
	}
	parent.location.replace("/webapp/wcs/tools/servlet/RFQResponseRetractToCancel?redirecturl=NewDynamicListView&ActionXMLFile=rfq.rfqresponselist&cmd=RFQResponseList&selected=SELECTED&listsize=15&startindex=0&rfqId="+rfqId+"&<%=BusinessFlowConstants.EC_ENTITY_ID%>=" + resId + "&flowType=RFQResponse&event="+eventid);
}
function retractres() {
	if(isButtonDisabled(parent.buttons.buttonForm.retractButton)) {
            return;
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var resId = parms[0];
	var rfqId = "<%=jsphp.getParameter("rfqId")%>";
	var eventid="<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_RETRACT_RFQ_RESPONSE_EVENT_IDENTIFIER %>";
	if (!confirmDialog("<%= UIUtil.toJavaScript(rfqNLS.get("retractRsp")) %>")) {
	    return;
	}
	parent.location.replace("/webapp/wcs/tools/servlet/RFQResponseRetract?redirecturl=NewDynamicListView&ActionXMLFile=rfq.rfqresponselist&cmd=RFQResponseList&selected=SELECTED&listsize=15&startindex=0&rfqId="+rfqId+"&<%=BusinessFlowConstants.EC_ENTITY_ID%>=" + resId + "&flowType=RFQResponse&event=" +eventid);
}
function changetodraft()  {
	if(isButtonDisabled(parent.buttons.buttonForm.changetodraftButton)) {
		return;
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var resId = parms[0];
	var rfqId = "<%=jsphp.getParameter("rfqId")%>";
	var eventid="<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_CHANGEDRAFT_RFQ_RESPONSE_EVENT_IDENTIFIER %>";
	if (!confirmDialog("<%= UIUtil.toJavaScript(rfqNLS.get("convertRsp")) %>")) {
	    return;
	}
	parent.location.replace("/webapp/wcs/tools/servlet/RFQResponseRetractToDraft?redirecturl=NewDynamicListView&ActionXMLFile=rfq.rfqresponselist&cmd=RFQResponseList&selected=SELECTED&listsize=15&startindex=0&rfqId="+rfqId+"&<%=BusinessFlowConstants.EC_ENTITY_ID%>=" + resId + "&flowType=RFQResponse&event="+eventid);
}
function getNewSummaryBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("ressummary")) %>";
}
function summaryResponse() {
	if (parent.scrollcontrol.document.ControlPanelForm) {
	    var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
	    top.put(parent.view_select_name,op.selectedIndex);
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');	 
	var resId = parms[0];	
    if(isButtonDisabled(parent.buttons.buttonForm.submitButton)) {
	    top.setContent(getNewSummaryBCT(),'/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.responseSummary&amp;resId='+resId, true);
	} else {	    
		top.setContent(getNewSummaryBCT(),'/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.responseSummaryShowAllProducts_draft&amp;resId='+resId, true);
	}
}
function myRefreshButtons() {
	var temp_status;
    var checkedEntries = parent.getChecked().toString();
    var parms = checkedEntries.split(';');
    var temp_status = parms[1];
    var draft = "<%= UIUtil.toJavaScript(rfqNLS.get("draft"))%>";
    var pend = "<%= UIUtil.toJavaScript(rfqNLS.get("pendingapproval"))%>";
    var active="<%= UIUtil.toJavaScript(rfqNLS.get("active"))%>";
    var ine = "<%= UIUtil.toJavaScript(rfqNLS.get("inevaluation"))%>";
    var won = "<%= UIUtil.toJavaScript(rfqNLS.get("won"))%>";
    var nores= "<%= UIUtil.toJavaScript(rfqNLS.get("noresponse"))%>";
    var cancel= "<%= UIUtil.toJavaScript(rfqNLS.get("canceled"))%>";
    var reject="<%= UIUtil.toJavaScript(rfqNLS.get("rejected"))%>";
    var woncomplete="<%= UIUtil.toJavaScript(rfqNLS.get("woncomplete"))%>";
    var retract="<%= UIUtil.toJavaScript(rfqNLS.get("retracted"))%>" ;
    var lost="<%= UIUtil.toJavaScript(rfqNLS.get("lost"))%>";
    var lostcomplete="<%= UIUtil.toJavaScript(rfqNLS.get("lostcomplete"))%>";
    var wonnextround="<%= UIUtil.toJavaScript(rfqNLS.get("wonnextround"))%>";
    var lostnextround="<%= UIUtil.toJavaScript(rfqNLS.get("lostnextround"))%>";    
    if ( temp_status == active ) {
        if (defined(parent.buttons.buttonForm.submitButton)) {
      	   	parent.buttons.buttonForm.submitButton.className='disabled';
           	parent.buttons.buttonForm.submitButton.disabled=true;
      	   	parent.buttons.buttonForm.submitButton.id='disabled';
        }
	    if (defined(parent.buttons.buttonForm.changeButton)) {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
 	    }
	    if (defined(parent.buttons.buttonForm.changetodraftButton)) {
      	   	parent.buttons.buttonForm.changetodraftButton.className='disabled';
	   	parent.buttons.buttonForm.changetodraftButton.disabled=true;
      	   	parent.buttons.buttonForm.changetodraftButton.id='disabled';
 	    }
	    if (defined(parent.buttons.buttonForm.cancelButton)) {
      	   	parent.buttons.buttonForm.cancelButton.className='disabled';
	   	parent.buttons.buttonForm.cancelButton.disabled=true;
      	   	parent.buttons.buttonForm.cancelButton.id='disabled';
 	    }
    } else if (temp_status == draft) {
	    if (defined(parent.buttons.buttonForm.changetodraftButton)) {
      	   	parent.buttons.buttonForm.changetodraftButton.className='disabled';
	   	parent.buttons.buttonForm.changetodraftButton.disabled=true;
      	   	parent.buttons.buttonForm.changetodraftButton.id='disabled';
      	   	changetodraftButton=true;
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	   	parent.buttons.buttonForm.retractButton.className='disabled';
	   	parent.buttons.buttonForm.retractButton.disabled=true;
      	   	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
    } else if (temp_status == ine) {
	    if (defined(parent.buttons.buttonForm.submitButton))  {
      	   	parent.buttons.buttonForm.submitButton.className='disabled';
	   	parent.buttons.buttonForm.submitButton.disabled=true;
      	   	parent.buttons.buttonForm.submitButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changeButton)) {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changetodraftButton)) {
      	   	parent.buttons.buttonForm.changetodraftButton.className='disabled';
	   	parent.buttons.buttonForm.changetodraftButton.disabled=true;
      	   	parent.buttons.buttonForm.changetodraftButton.id='disabled';
	    }
		if (defined(parent.buttons.buttonForm.cancelButton)) {
      	   	parent.buttons.buttonForm.cancelButton.className='disabled';
	   	parent.buttons.buttonForm.cancelButton.disabled=true;
      	   	parent.buttons.buttonForm.cancelButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	   	parent.buttons.buttonForm.retractButton.className='disabled';
	   	parent.buttons.buttonForm.retractButton.disabled=true;
      	   	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
    } else if (temp_status == pend) {
	    if (defined(parent.buttons.buttonForm.submitButton)) {
      	   	parent.buttons.buttonForm.submitButton.className='disabled';
	   	parent.buttons.buttonForm.submitButton.disabled=true;
      	   	parent.buttons.buttonForm.submitButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changeButton)) {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changetodraftButton)) {
      	   	parent.buttons.buttonForm.changetodraftButton.className='disabled';
	   	parent.buttons.buttonForm.changetodraftButton.disabled=true;
      	   	parent.buttons.buttonForm.changetodraftButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.cancelButton)) {
      	   	parent.buttons.buttonForm.cancelButton.className='disabled';
	   	parent.buttons.buttonForm.cancelButton.disabled=true;
      	   	parent.buttons.buttonForm.cancelButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	  	parent.buttons.buttonForm.retractButton.className='disabled';
	  	parent.buttons.buttonForm.retractButton.disabled=true;
      	  	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
    } else if ((temp_status == won ) || (temp_status == lost)|| (temp_status == nores )	|| (temp_status == cancel )
              || (temp_status == woncomplete) || (temp_status == lostcomplete)|| (temp_status == wonnextround)
	      || (temp_status == lostnextround)) {
        if (defined(parent.buttons.buttonForm.submitButton)) {
      	   	parent.buttons.buttonForm.submitButton.className='disabled';
	   	parent.buttons.buttonForm.submitButton.disabled=true;
      	   	parent.buttons.buttonForm.submitButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changeButton)) {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changetodraftButton)) {
      	   	parent.buttons.buttonForm.changetodraftButton.className='disabled';
	   	parent.buttons.buttonForm.changetodraftButton.disabled=true;
      	   	parent.buttons.buttonForm.changetodraftButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.cancelButton)) {
      	   	parent.buttons.buttonForm.cancelButton.className='disabled';
	   	parent.buttons.buttonForm.cancelButton.disabled=true;
      	   	parent.buttons.buttonForm.cancelButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	   	parent.buttons.buttonForm.retractButton.className='disabled';
	   	parent.buttons.buttonForm.retractButton.disabled=true;
      	   	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
	} else if (temp_status ==reject ) {
        if (defined(parent.buttons.buttonForm.submitButton)) {
      	   	parent.buttons.buttonForm.submitButton.className='disabled';
	   	parent.buttons.buttonForm.submitButton.disabled=true;
      	   	parent.buttons.buttonForm.submitButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changeButton)) {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	   	parent.buttons.buttonForm.retractButton.className='disabled';
	   	parent.buttons.buttonForm.retractButton.disabled=true;
      	   	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
	} else if ( temp_status == retract) {
	    if (defined(parent.buttons.buttonForm.submitButton)) {
	   	parent.buttons.buttonForm.submitButton.className='disabled';
	   	parent.buttons.buttonForm.submitButton.disabled=true;
	   	parent.buttons.buttonForm.submitButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changeButton))  {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	   	parent.buttons.buttonForm.retractButton.className='disabled';
	   	parent.buttons.buttonForm.retractButton.disabled=true;
      	   	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
	}//end if ( temp_status == "*" )  
} //end function 
function userInitialButtons() {
	var temp_status;
    var checkedEntries = parent.getChecked().toString();
    var parms = checkedEntries.split(';');
    var temp_status = parms[1];
    var draft = "<%= UIUtil.toJavaScript(rfqNLS.get("draft"))%>";
    var pend = "<%= UIUtil.toJavaScript(rfqNLS.get("pendingapproval"))%>";
    var active="<%= UIUtil.toJavaScript(rfqNLS.get("active"))%>";
    var ine = "<%= UIUtil.toJavaScript(rfqNLS.get("inevaluation"))%>";
    var won = "<%= UIUtil.toJavaScript(rfqNLS.get("won"))%>";
    var nores= "<%= UIUtil.toJavaScript(rfqNLS.get("noresponse"))%>";
    var cancel= "<%= UIUtil.toJavaScript(rfqNLS.get("canceled"))%>";
    var reject="<%= UIUtil.toJavaScript(rfqNLS.get("rejected"))%>"; 
    var woncomplete="<%= UIUtil.toJavaScript(rfqNLS.get("woncomplete"))%>";
    var retract="<%= UIUtil.toJavaScript(rfqNLS.get("retracted"))%>" ;
    var lost="<%= UIUtil.toJavaScript(rfqNLS.get("lost"))%>";
    var lostcomplete="<%= UIUtil.toJavaScript(rfqNLS.get("lostcomplete"))%>";
    var wonnextround="<%= UIUtil.toJavaScript(rfqNLS.get("wonnextround"))%>";
    var lostnextround="<%= UIUtil.toJavaScript(rfqNLS.get("lostnextround"))%>";
    if ( temp_status == active ) {
    	if (defined(parent.buttons.buttonForm.submitButton)) {
      	   	parent.buttons.buttonForm.submitButton.className='disabled';
           	parent.buttons.buttonForm.submitButton.disabled=true;
      	   	parent.buttons.buttonForm.submitButton.id='disabled';
        }
	    if (defined(parent.buttons.buttonForm.changeButton)) {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
 	    }
	    if (defined(parent.buttons.buttonForm.changetodraftButton)) {
      	   	parent.buttons.buttonForm.changetodraftButton.className='disabled';
	   	parent.buttons.buttonForm.changetodraftButton.disabled=true;
      	   	parent.buttons.buttonForm.changetodraftButton.id='disabled';
 	    }
	    if (defined(parent.buttons.buttonForm.cancelButton)) {
      	   	parent.buttons.buttonForm.cancelButton.className='disabled';
	   	parent.buttons.buttonForm.cancelButton.disabled=true;
      	   	parent.buttons.buttonForm.cancelButton.id='disabled';
	    }
    } else if (temp_status == draft) {
	    if (defined(parent.buttons.buttonForm.changetodraftButton)) {
      	   	parent.buttons.buttonForm.changetodraftButton.className='disabled';
	   	parent.buttons.buttonForm.changetodraftButton.disabled=true;
      	   	parent.buttons.buttonForm.changetodraftButton.id='disabled';
      	   	changetodraftButton=true;
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	   	parent.buttons.buttonForm.retractButton.className='disabled';
	   	parent.buttons.buttonForm.retractButton.disabled=true;
      	   	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
    } else if (temp_status ==ine) {
	    if (defined(parent.buttons.buttonForm.submitButton)) {
      	   	parent.buttons.buttonForm.submitButton.className='disabled';
	   	parent.buttons.buttonForm.submitButton.disabled=true;
      	   	parent.buttons.buttonForm.submitButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changeButton)) {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changetodraftButton)) {
      	   	parent.buttons.buttonForm.changetodraftButton.className='disabled';
	   	parent.buttons.buttonForm.changetodraftButton.disabled=true;
      	  	parent.buttons.buttonForm.changetodraftButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.cancelButton)) {
      	   	parent.buttons.buttonForm.cancelButton.className='disabled';
	   	parent.buttons.buttonForm.cancelButton.disabled=true;
      	   	parent.buttons.buttonForm.cancelButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	   	parent.buttons.buttonForm.retractButton.className='disabled';
	   	parent.buttons.buttonForm.retractButton.disabled=true;
      	   	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
    } else if (temp_status ==pend) {
	    if (defined(parent.buttons.buttonForm.submitButton)) {
      	   	parent.buttons.buttonForm.submitButton.className='disabled';
	   	parent.buttons.buttonForm.submitButton.disabled=true;
      	   	parent.buttons.buttonForm.submitButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changeButton)) {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changetodraftButton)) {
      	   	parent.buttons.buttonForm.changetodraftButton.className='disabled';
	   	parent.buttons.buttonForm.changetodraftButton.disabled=true;
      	   	parent.buttons.buttonForm.changetodraftButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.cancelButton)) {
      	   	parent.buttons.buttonForm.cancelButton.className='disabled';
	   	parent.buttons.buttonForm.cancelButton.disabled=true;
      	   	parent.buttons.buttonForm.cancelButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	   	parent.buttons.buttonForm.retractButton.className='disabled';
	   	parent.buttons.buttonForm.retractButton.disabled=true;
      	   	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
    } else if ((temp_status == won ) || (temp_status == lost) || (temp_status == nores )
	      || (temp_status == cancel ) || (temp_status == woncomplete) || (temp_status == lostcomplete)
	      || (temp_status == wonnextround) || (temp_status == lostnextround)) {
        if (defined(parent.buttons.buttonForm.submitButton)) {
      	   	parent.buttons.buttonForm.submitButton.className='disabled';
	   	parent.buttons.buttonForm.submitButton.disabled=true;
      	   	parent.buttons.buttonForm.submitButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changeButton)) {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changetodraftButton)) {
      	   	parent.buttons.buttonForm.changetodraftButton.className='disabled';
	   	parent.buttons.buttonForm.changetodraftButton.disabled=true;
      	   	parent.buttons.buttonForm.changetodraftButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.cancelButton)) {
      	   	parent.buttons.buttonForm.cancelButton.className='disabled';
	   	parent.buttons.buttonForm.cancelButton.disabled=true;
      	   	parent.buttons.buttonForm.cancelButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	   	parent.buttons.buttonForm.retractButton.className='disabled';
	   	parent.buttons.buttonForm.retractButton.disabled=true;
      	   	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
     } else if (temp_status ==reject ) {
        if (defined(parent.buttons.buttonForm.submitButton)) {
      	   	parent.buttons.buttonForm.submitButton.className='disabled';
	   	parent.buttons.buttonForm.submitButton.disabled=true;
      	   	parent.buttons.buttonForm.submitButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changeButton)) {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	   	parent.buttons.buttonForm.retractButton.className='disabled';
	   	parent.buttons.buttonForm.retractButton.disabled=true;
      	   	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
    }  else if ( temp_status == retract) {
	    if (defined(parent.buttons.buttonForm.submitButton)) {
	   	parent.buttons.buttonForm.submitButton.className='disabled';
	   	parent.buttons.buttonForm.submitButton.disabled=true;
	   	parent.buttons.buttonForm.submitButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.changeButton)) {
      	   	parent.buttons.buttonForm.changeButton.className='disabled';
	   	parent.buttons.buttonForm.changeButton.disabled=true;
      	   	parent.buttons.buttonForm.changeButton.id='disabled';
	    }
	    if (defined(parent.buttons.buttonForm.retractButton)) {
      	   	parent.buttons.buttonForm.retractButton.className='disabled';
	   	parent.buttons.buttonForm.retractButton.disabled=true;
      	   	parent.buttons.buttonForm.retractButton.id='disabled';
	    }
    }//end if ( temp_status == "*" )  
} //end function 
function getPageTitle()  {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_responses")) %>";
}
function onLoad() {
	parent.setoption(top.get(parent.view_select_name,0));
	parent.loadFrames();
}
function getNewBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_new")) %>";
}
function getSummRFQBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("summary")) %>";
}
function getDuplicateBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_duplicate")) %>";
}
function getResponsesBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_responses")) %>";
}
</script>
</head>

<body class="content_list">

<script type="text/javascript">
<!--
// For IE
if (document.all) { onLoad(); }
//-->
</script>

<form name="rfqrspListForm" action="">
<%
    String classId="list_row1";
    String check_value ="";
    String res_state="";
    String l_state="";
    String disp_idnum=""; 
    String disp_name = "";
    String disp_remark="";
    String disp_createtime="";
    Date   dt;
    String resState = jsphp.getParameter("view");
   
    String msg = jsphp.getParameter("SubmitFinishMessage");
   
    int totalsize=0;
    String sortby = jsphp.getParameter("orderby");
    com.ibm.commerce.rfq.helpers.RFQSortingAttribute sortAttr=new com.ibm.commerce.rfq.helpers.RFQSortingAttribute();
    if(sortby!=null && !sortby.equals("")) {
   		sortAttr.addSorting(sortby, true);
    } else {
   		sortby = RFQResponseTable.CREATETIME;
		sortAttr.addSorting(sortby, false);
    }
    responseList.setSortingAttribute(sortAttr);   
    responseList.setRfqId(rfqId);
    responseList.setState(resState);
    com.ibm.commerce.beans.DataBeanManager.activate(responseList, request);
    RFQResponseDataBean[] responses = responseList.getResponses();
  
    int startIndex = Integer.parseInt(jsphp.getParameter("startindex"));
    int listSize = Integer.parseInt(jsphp.getParameter("listsize"));
    int endIndex = startIndex + listSize;
    int rowselect = 1;
	
    if ( (responses!=null) && (responses.length > 0) ) {
		totalsize = responses.length;
		if (endIndex > responses.length) {
	    	endIndex = responses.length;
		}
    }		
    int totalpage =totalsize/listSize;
%>
<%= comm.addControlPanel("rfq.rfqresponselist", totalpage, totalsize, aLocale) %>
					
<!-- THIS IS THE HEADER ROW OF THE TABLE -->
    <%= comm.startDlistTable((String)rfqNLS.get("rfqlisttitle")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistCheckHeading(false) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("res_resname"),RFQResponseTable.NAME,new String(RFQResponseTable.NAME).equals(sortby),"25%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("remark"),"null",false,"25%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("status"),"null",false,"25%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("creationtime"),RFQResponseTable.CREATETIME,new String(RFQResponseTable.CREATETIME).equals(sortby),"25%" ) %>
    <%= comm.endDlistRow() %>
<%   
if ((responses!=null)&&( responses.length > 0) ) {
	for(int i=startIndex; i<endIndex; i++) {
		RFQResponseDataBean aRes = responses[i];
 	    disp_name =  UIUtil.toHTML(aRes.getName());
  	    disp_idnum = UIUtil.toHTML(aRes.getRfqResponseId());
  	    disp_remark= UIUtil.toHTML(aRes.getRemarks());   	     	    
	    l_state=aRes.getState().toString().trim();
	    if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_DRAFT.toString())) {
			res_state=rfqNLS.get("draft").toString();
  	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_ACTIVE.toString())) {
			res_state=rfqNLS.get("active").toString();
	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_CANCELLED.toString())) {
			res_state=rfqNLS.get("canceled").toString();
	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_IN_EVALUATION.toString())) {
			res_state=rfqNLS.get("inevaluation").toString();
	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_PENDING_APPROVAL.toString())) {
			res_state=rfqNLS.get("pendingapproval").toString();
	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_REJECTED.toString())) {
			res_state=rfqNLS.get("rejected").toString();
	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_RETRACTED.toString())) {
			res_state=rfqNLS.get("retracted").toString();
	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_WON.toString())) {
 			res_state=rfqNLS.get("won").toString();
	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_LOST.toString())) {
			res_state=rfqNLS.get("lost").toString();
	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_WON_COMPLETED.toString())) {
			res_state=rfqNLS.get("woncomplete").toString();
	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_LOST_COMPLETED.toString())) {
			res_state=rfqNLS.get("lostcomplete").toString();
	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_WON_NEXTROUND.toString())) {
			res_state=rfqNLS.get("wonnextround").toString();
	    } else if (l_state != null && l_state.equals(RFQConstants.EC_RESPONSE_STATE_LOST_NEXTROUND.toString())) {   
			res_state=rfqNLS.get("lostnextround").toString();
	    } else {
			res_state=rfqNLS.get("illegalstate").toString();
	    }
	    DateFormat df_d = DateFormat.getDateInstance(DateFormat.SHORT,aLocale);
	    DateFormat df_t = DateFormat.getTimeInstance(DateFormat.SHORT,aLocale);
	    dt=aRes.getCreateTimeInEntityType();
	    if (dt!=null) {
	  		disp_createtime = df_d.format(dt) +" " + df_t.format(dt);
	    }	

		//String hasPP=""; 
	    
%>
	    <%= comm.startDlistRow(rowselect) %>	    
	    <%= comm.addDlistCheck(disp_idnum+";"+res_state,"parent.setChecked();myRefreshButtons()" ) %>
	    <%= comm.addDlistColumn(disp_name,"none") %>
	    <%= comm.addDlistColumn(disp_remark,"none") %>
	    <%= comm.addDlistColumn(res_state,"none") %>
	    <%= comm.addDlistColumn(disp_createtime,"none") %>
	    <%= comm.endDlistRow() %>
<%		
		if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
	}//end for
}//endif	
%>					
	<!-- THIS ENDS THE TABLE -->
    <%= comm.endDlistTable() %>
</form>


<script type="text/javascript">
<!--
    parent.afterLoads();
    parent.setResultssize(<%= totalsize %>); // total
<%
    if(com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_DRAFT.toString().equals(resState)) {
%>     
	parent.hideButton('retract');
	parent.hideButton('changetodraft');   
<%
    }
    if(com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_ACTIVE.toString().equals(resState)) {
%>     
	parent.hideButton('change');
	parent.hideButton('submit');   
	parent.hideButton('cancel');
	parent.hideButton('changetodraft');   
<%
    }
    if(com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_CANCELLED.toString().equals(resState)
    || com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_WON.toString().equals(resState)
    || com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_LOST.toString().equals(resState)
    || com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_IN_EVALUATION.toString().equals(resState)
    || com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_PENDING_APPROVAL.toString().equals(resState)
    || com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_WON_COMPLETED.toString().equals(resState)
    || com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_LOST_COMPLETED.toString().equals(resState)
    || com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_WON_NEXTROUND.toString().equals(resState)
    || com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_LOST_NEXTROUND.toString().equals(resState)
      )  {
%>     
	parent.hideButton('change');
	parent.hideButton('submit');   
	parent.hideButton('cancel');
	parent.hideButton('changetodraft');   
	parent.hideButton('retract');   
<%
    }
    if(com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_REJECTED.toString().equals(resState)) {
%>     
	parent.hideButton('change');
	parent.hideButton('submit');   
	parent.hideButton('retract');   
<%
    }       
    if(com.ibm.commerce.rfq.utils.RFQConstants.EC_RESPONSE_STATE_RETRACTED.toString().equals(resState)) {
%>     
	parent.hideButton('change');
	parent.hideButton('submit');   
	parent.hideButton('retract');   
<%
    }
%>       
    DisableNewButton();
//-->
</script>

</body>
</html>





<!--
function doNothing() { 
	; 
}
--> 
	<!--
	var haspp;
	haspp = "<%= createResponseWithPP %>";   
	-->
<!--
	top.setContent(getAnotherBCT(), '/webapp/wcs/tools/servlet/WizardView?XMLFile=rfq.rfqresponsewizard'+haspp+'&amp;requestId='+requestId,true);
-->
<!--
function getAnotherBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_another")) %>";
}  
--!>
<!--	var haspp = parms[2];		-->
<!--	var haspp = "<%= createResponseWithPP %>";  -->
























