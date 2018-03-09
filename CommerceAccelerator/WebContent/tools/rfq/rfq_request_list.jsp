


<%@ page import="java.text.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.utf.objects.*" %>
<%@ page import="com.ibm.commerce.utf.helper.*" %>
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.user.beans.UserRegistrationDataBean" %>

<%@ include file="../common/common.jsp" %>

<jsp:useBean id="rfqList" class="com.ibm.commerce.utf.beans.RFQListBean" ></jsp:useBean>

<%
	String StoreId = null;
	Locale locale = null;   
	Integer lang = null;
	boolean wrap = true;
	boolean useQuickSearch=true;
	//***Get storeId from CommandContext
	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
	String ErrorMessage = request.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);

	if( aCommandContext!= null ) {
		StoreId = aCommandContext.getStoreId().toString();
        locale = aCommandContext.getLocale();
		lang = aCommandContext.getLanguageId();
    }
    if (locale == null)	locale = new Locale("en","US");
    if (lang == null) lang= new Integer("-1");
	JSPHelper jsphp=new JSPHelper(request);
	String name = jsphp.getParameter("name");	
	String states = jsphp.getParameter("state");
	String createday = jsphp.getParameter("createday");
	String activeday = jsphp.getParameter("activeday");
	String casesensitive =  jsphp.getParameter("casesensitive");

	// obtain the resource bundle for display
	Hashtable rfqNLS=null;
	rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", locale); 
	
    //no wrapping for the asian languages
    if(lang.intValue() <= -7 && lang.intValue() >= -10) { 
    	wrap = false; 
    }    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
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
function isButtonDisabled(b) {
	if (b.className =='disabled' ) return true;
	return false;
} 
function createResponse() {
	if(isButtonDisabled(parent.buttons.buttonForm.rfqresponseButton)) return;
	if (parent.scrollcontrol.document.ControlPanelForm) {
		var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
		top.put(parent.view_select_name,op.selectedIndex);
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var rfqId = parms[0];
	var haspp = parms[4];
	top.setContent(getRespondBCT(), '/webapp/wcs/tools/servlet/NotebookView?XMLFile=rfq.rfqResponseCreateNotebook&amp;requestId='+rfqId, true);
}
function getRespondBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqresponsenew")) %>";
}
function findRFQ() {	
	if (parent.scrollcontrol.document.ControlPanelForm) {
		var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
		top.put(parent.view_select_name, op.selectedIndex);
	}
	top.setContent(getFindBCT(), '/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqfind', true);
}
function getFindBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_find")) %>";
}
function summaryRequest() {
	if (parent.scrollcontrol.document.ControlPanelForm) {
		var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
		top.put(parent.view_select_name,op.selectedIndex);
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var rfqId = parms[0];	
	var temp_status = parms[1];
	var active="<%= UIUtil.toJavaScript(rfqNLS.get("active")) %>";    
	if ( temp_status != active ) {
		top.setContent(getSummRFQBCT(), '/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.requestSummary&amp;rfqid='+rfqId, true);
	} else {
		top.setContent(getSummRFQBCT(), '/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.requestSummary_active&amp;rfqid='+rfqId, true);
	}
}
function showPrevRoundRfq() {
	if(isButtonDisabled(parent.buttons.buttonForm.prevroundrfqButton)) return;
	if (parent.scrollcontrol.document.ControlPanelForm) {
		var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
		top.put(parent.view_select_name,op.selectedIndex);
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var rfqId = parms[2];
	top.setContent(getSummRFQBCT(), '/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.requestSummary&amp;rfqid='+ rfqId, true);
}
function getSummRFQBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("summary")) %>";
}
function linkCustomerSummary() {
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var rfqId = parms[0];
	var url = '/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqRequestCustomerSummary&amp;rfqId='+rfqId;	
	if (top.setContent) {
	    top.setContent(getCustomerSummaryBCT(), url, true);
	} else {
	    parent.parent.location.replace(url);
	}
}
function customerSummary(rfqId) {
	var url = "DialogView?XMLFile=rfq.rfqRequestCustomerSummary&amp;rfqId="+rfqId;
	if (top.setContent) {
	    top.setContent(getCustomerSummaryBCT(), url, true);
	} else {
	    parent.parent.location.replace(url);
	} 
}
function getCustomerSummaryBCT() {
  	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_CustomerSumm")) %>";
}
function showNextRoundRfq() {
	if(isButtonDisabled(parent.buttons.buttonForm.nextroundrfqButton)) return;
	if (parent.scrollcontrol.document.ControlPanelForm) {
		var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
		top.put(parent.view_select_name,op.selectedIndex);
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var rfqId = parms[3];
	top.setContent(getSummRFQBCT(), '/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.requestSummary&amp;rfqid='+ rfqId, true);
}	
function listResponses() {
	if(isButtonDisabled(parent.buttons.buttonForm.responsesButton)) return;
	if (parent.scrollcontrol.document.ControlPanelForm)	{
		var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
		top.put(parent.view_select_name,op.selectedIndex);
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var rfqId = parms[0];
	var haspp = parms[4];
	top.setContent(getResponsesBCT(),'/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=rfq.rfqresponselist&amp;haspp='+haspp+'&amp;cmd=RFQResponseList&rfqId='+rfqId,true);
}
function getResponsesBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_responses")) %>";
}
function listPrevRoundResponses() {
	if(isButtonDisabled(parent.buttons.buttonForm.prevroundrfqresponseButton)) return;
	if (parent.scrollcontrol.document.ControlPanelForm) {
		var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
		top.put(parent.view_select_name,op.selectedIndex);
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var rfqId = parms[2];
	top.setContent(getResponsesBCT(),'/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=rfq.rfqresponselist&amp;cmd=RFQResponseList&rfqId='+rfqId,true);
}
function listNextRoundResponses() {
	if(isButtonDisabled(parent.buttons.buttonForm.nextroundrfqresponseButton)) return;
	if (parent.scrollcontrol.document.ControlPanelForm)	{
		var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
		top.put(parent.view_select_name,op.selectedIndex);
	}
	var checkedEntries = parent.getChecked().toString();
	var parms = checkedEntries.split(';');
	var rfqId = parms[3];
	top.setContent(getResponsesBCT(),'/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=rfq.rfqresponselist&amp;cmd=RFQResponseList&rfqId='+rfqId,true);
}
function myRefreshButtons() {
    var temp_status;
    var checkedEntries = parent.getChecked().toString();
    var parms = checkedEntries.split(';');
    var temp_status = parms[1];
    var temp_prevOffId = parms[2];
    var temp_nextOffId = parms[3];
    var temp_hasPrevRoundRfq = parms[4];
    var temp_hasNextRoundRfq = parms[5];

    var active="<%= UIUtil.toJavaScript(rfqNLS.get("active")) %>";    
    if ( temp_status != active ) {
	if (defined(parent.buttons.buttonForm.rfqresponseButton)) {
      	   parent.buttons.buttonForm.rfqresponseButton.className='disabled';
      	   parent.buttons.buttonForm.rfqresponseButton.disabled=true;
        }         
    } else {
        if (defined(parent.buttons.buttonForm.rfqresponseButton)) {
      	   parent.buttons.buttonForm.rfqresponseButton.className='enabled';
      	   parent.buttons.buttonForm.rfqresponseButton.disabled=false;
        }    
    }         
    if ( temp_prevOffId == null || isEmpty(temp_prevOffId) || temp_hasPrevRoundRfq != 'true') 
    {
	if (defined(parent.buttons.buttonForm.prevroundrfqButton)) {
     	   parent.buttons.buttonForm.prevroundrfqButton.className='disabled';
      	   parent.buttons.buttonForm.prevroundrfqButton.disabled=true;
	}
        if (defined(parent.buttons.buttonForm.prevroundrfqresponseButton)) {
      	   parent.buttons.buttonForm.prevroundrfqresponseButton.className='disabled';
      	   parent.buttons.buttonForm.prevroundrfqresponseButton.disabled=true;
        }
    }     
    if ( temp_nextOffId == null || isEmpty(temp_nextOffId) || temp_hasNextRoundRfq != 'true' ) 
    {
	if (defined(parent.buttons.buttonForm.nextroundrfqButton)) {
     	   parent.buttons.buttonForm.nextroundrfqButton.className='disabled';
      	   parent.buttons.buttonForm.nextroundrfqButton.disabled=true;
	}
	if (defined(parent.buttons.buttonForm.nextroundrfqresponseButton)) {
      	   parent.buttons.buttonForm.nextroundrfqresponseButton.className='disabled';
      	   parent.buttons.buttonForm.nextroundrfqresponseButton.disabled=true;
	}
    } 
}	
function userInitialButtons() {
    var temp_status;
    var checkedEntries = parent.getChecked().toString();
    var parms = checkedEntries.split(';');
    var temp_status = parms[1];
    var temp_prevOffId = parms[2];
    var temp_nextOffId = parms[3];
    var active="<%= UIUtil.toJavaScript(rfqNLS.get("active")) %>";   
    if ( temp_status != active ) {
        if (defined(parent.buttons.buttonForm.rfqresponseButton)) {
      	   parent.buttons.buttonForm.rfqresponseButton.className='disabled';
      	   parent.buttons.buttonForm.rfqresponseButton.disabled=true;
        }        
    } else {
        if (defined(parent.buttons.buttonForm.rfqresponseButton)) {
      	   parent.buttons.buttonForm.rfqresponseButton.className='enabled';
      	   parent.buttons.buttonForm.rfqresponseButton.disabled=false;
        }    
    }         
    if ( temp_prevOffId == null || isEmpty(temp_prevOffId) ) {
	if (defined(parent.buttons.buttonForm.prevroundrfqButton)) {
      	   parent.buttons.buttonForm.prevroundrfqButton.className='disabled';
      	   parent.buttons.buttonForm.prevroundrfqButton.disabled=true;
	}
	if (defined(parent.buttons.buttonForm.prevroundrfqresponseButton)) {
      	   parent.buttons.buttonForm.prevroundrfqresponseButton.className='disabled';
      	   parent.buttons.buttonForm.prevroundrfqresponseButton.disabled=true;
	}
    }     
    if ( temp_nextOffId == null || isEmpty(temp_nextOffId) ) {
	if (defined(parent.buttons.buttonForm.nextroundrfqButton)) {
      	   parent.buttons.buttonForm.nextroundrfqButton.className='disabled';
      	   parent.buttons.buttonForm.nextroundrfqButton.disabled=true;
	}
	if (defined(parent.buttons.buttonForm.nextroundrfqresponseButton)) {
      	   parent.buttons.buttonForm.nextroundrfqresponseButton.className='disabled';
      	   parent.buttons.buttonForm.nextroundrfqresponseButton.disabled=true;
	}
    } 
}	
function getNewBCT() {
    var op = parent.scrollcontrol.document.ControlPanelForm.viewname.options;
	if (op.selectedIndex ==0){
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqlisttitle")) %>";	
		}
	if (op.selectedIndex ==1){
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqlisttitle")) %>" + "-" + "<%= UIUtil.toJavaScript(rfqNLS.get("active")) %>";	
		}
	if (op.selectedIndex ==2){
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqlisttitle")) %>" + "-" + "<%= UIUtil.toJavaScript(rfqNLS.get("closed")) %>";	
		}
	if (op.selectedIndex ==3){
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqlisttitle")) %>" + "-" + "<%= UIUtil.toJavaScript(rfqNLS.get("complete")) %>";	
		}
	if (op.selectedIndex ==4){
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqlisttitle")) %>" + "-" + "<%= UIUtil.toJavaScript(rfqNLS.get("nextround")) %>";	
		}	
   }

</script>
</head>

<body class="content_list">
<form name="rfqListForm" action="">

<%
	int startIndex = Integer.parseInt(jsphp.getParameter("startindex"));
	int listSize = Integer.parseInt(jsphp.getParameter("listsize"));
	String orderby = jsphp.getParameter("orderby");
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	String classId="list_row1";
	String check_name;
	String check_value;
	String disp_idnum;
	String disp_name;
	String disp_createtime="";	
	String state;
	String disp_state;
	String disp_desc;
	String end_date;
	String prevOffId;
	String nextOffId;
	String rfq_round;
	String vw="";
	String viewset="";
	int viewindex=0;	
	String forfind=jsphp.getParameter("forfind");
	if ((forfind!=null) && (forfind.equals("yes"))) {		
	//use this part to do get find parameter       -----------
		
		if ((name != null) && (!name.equals("")) ){
			if("true".equals(casesensitive)){
				rfqList.setMatchNameForCaseInsensitiveSearch(name);
			}else{
				rfqList.setMatchName(name);
			}
		}		
		else if (states != null && !states.equals("")) {
			if (states.equals("1")){
				states=com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_ACTIVE.toString();
				viewset="active";
				viewindex=1;
			}				
			else if (states.equals("2")){
				states=	com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_CLOSED.toString();			
				viewset="closed";
				viewindex=2;
			}				
			else if (states.equals("3")){				
				states=com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_COMPLETED.toString();
				viewset="complete";
				viewindex=3;
			}				
			else if (states.equals("4")){
				states=	com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_NEXT_ROUND.toString();			
				viewset="nextround";
				viewindex=4;
			}				
	       		rfqList.setState(states);
	       		
		}else if (createday != null && !createday.equals("")) {
	       		rfqList.setCreateTime(createday);
		}else if (activeday != null && !activeday.equals("")) {
	       		rfqList.setActivateTime(activeday);
		}       		
	//-----------------------------	
	} else {
       		vw = jsphp.getParameter("view");
       		viewset=vw;
       		if (!vw.equals("all")){
              		if (vw.equals("active")){
                     		vw = com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_ACTIVE.toString();
              		} else if (vw.equals("closed")){
                     		vw = com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_CLOSED.toString();
              		} else if (vw.equals("completed")){
                     		vw = com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_COMPLETED.toString();
              		} else if (vw.equals("nextround")){
                     		vw = com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_NEXT_ROUND.toString();
              		}
              		rfqList.setState(vw);
       		}
       		else {
        		Integer[] multiStates = new Integer[4];
        		multiStates[0] = com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_ACTIVE;
        		multiStates[1] = com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_CLOSED;
        		multiStates[2] = com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_COMPLETED;
        		multiStates[3] = com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_NEXT_ROUND;
       			rfqList.setMultiStates(multiStates);
       		}
	       /* SORTING */
	       if (orderby ==null || orderby.equals("none")) 
	       	  orderby=com.ibm.commerce.utf.helper.RFQTable.CREATETIME;
	
	       com.ibm.commerce.utf.helper.RFQSortingAttribute sort = new com.ibm.commerce.utf.helper.RFQSortingAttribute();
	       if (orderby.equals( com.ibm.commerce.utf.helper.RFQTable.NAME) || orderby.equals(com.ibm.commerce.utf.helper.RFQTable.STATE))
	       {
	         sort.addSorting(orderby, true);
	       }else
	       {
	         sort.addSorting(orderby, false);
	       }
	       rfqList.setSortAtt(sort);
	}       

	rfqList.setStoreId(StoreId);
	//add this line to populate all record using one sql	
	if(useQuickSearch){
		rfqList.setQuickSearch();
	}
	com.ibm.commerce.beans.DataBeanManager.activate(rfqList, request);
	
	RFQDataLight[] rfqtemp = rfqList.getRFQLights();	
	RFQDataLight[] rfqs= new RFQDataLight[rfqtemp.length];

	String statetmp;
	int actualLength=0;
	
	for (int j=0; j<rfqtemp.length; j++){
		statetmp= rfqtemp[j].getState();		 			
		if ((com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_ACTIVE.toString().equals(statetmp))||
            (com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_CLOSED.toString().equals(statetmp))||
            (com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_COMPLETED.toString().equals(statetmp))||
            (com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_NEXT_ROUND.toString().equals(statetmp))) {
			rfqs[j]=rfqtemp[j];
		}
	}
		
	actualLength=rfqtemp.length;
	int totalsize = rfqList.getTotalSize();
	int totalpage = totalsize/listSize;
	
%>	
<%= comm.addControlPanel("rfq.rfqrequestlist", totalpage, totalsize, locale) %>	
<%= comm.startDlistTable((String)rfqNLS.get("rfqlisttitle")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(false) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqname"), com.ibm.commerce.utf.helper.RFQTable.NAME, new String(com.ibm.commerce.utf.helper.RFQTable.NAME).equals(orderby), "13%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqcustomerlogonid"), "null", false, "13%", wrap) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"null",false,"14%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("status"),com.ibm.commerce.utf.helper.RFQTable.STATE,new String(com.ibm.commerce.utf.helper.RFQTable.STATE).equals(orderby),"10%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("creationtime"),com.ibm.commerce.utf.helper.RFQTable.CREATETIME,new String(com.ibm.commerce.utf.helper.RFQTable.CREATETIME).equals(orderby),"15%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("submission"),com.ibm.commerce.utf.helper.RFQTable.ACTIVATETIME,new String(com.ibm.commerce.utf.helper.RFQTable.ACTIVATETIME).equals(orderby),"15%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("enddate"),"null",false,"15%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqClosedDate"),com.ibm.commerce.utf.helper.RFQTable.CLOSETIME,new String(com.ibm.commerce.utf.helper.RFQTable.CLOSETIME).equals(orderby),"15%", wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("round"),"null",false,"5%", wrap ) %>
<%= comm.endDlistRow() %>
	
<%
if (actualLength > 0) {
  	for ( int i=0; i<actualLength; i++) {
		
		RFQDataLight aRfq = rfqs[i];
		
		//d174372
		if(aRfq!=null){
		
		disp_idnum = aRfq.getRfqId();
		prevOffId = aRfq.getPrevOffId();
				
				
		String logonId = "";
		if(useQuickSearch){
			logonId=aRfq.getLogonId();
		}
		else{
			String memberId = aRfq.getMemberId();	
			UserRegistrationDataBean urdb = new UserRegistrationDataBean();	
			urdb.setDataBeanKeyMemberId(memberId);
			urdb.setCommandContext(aCommandContext);
			urdb.populate();		
			logonId = urdb.getLogonId();								
		}
		boolean hasNextRoundRfq = false;
		boolean hasPrevRoundRfq = false;  
        	if (prevOffId == null) {
		    prevOffId = "";
		}
		else
		{
		    if (prevOffId.length() > 0)
		    {
		    	hasPrevRoundRfq = aRfq.hasPreviousRoundRfqForSeller();  
		    }
		}
		nextOffId = aRfq.getNextOffId();
        	if (nextOffId == null) {
		    nextOffId = "";
		}
		else
		{
		    if (nextOffId.length() > 0)
		    {
		    	hasNextRoundRfq = aRfq.hasNextRoundRfqForSeller();  
		    }
		}
		rfq_round = aRfq.getRound();

		disp_name = UIUtil.toHTML(aRfq.getName());
		try{
			disp_desc =UIUtil.toHTML(aRfq.getDescription());
		}catch(Exception e) {
			disp_desc ="";
		}
		state = aRfq.getState();
		if (com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_ACTIVE.toString().equals(state)) disp_state = rfqNLS.get("active").toString();
        else if (com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_CLOSED.toString().equals(state)) disp_state = rfqNLS.get("closed").toString();
        else if (com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_COMPLETED.toString().equals(state)) disp_state =rfqNLS.get( "complete").toString();
        else if (com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_NEXT_ROUND.toString().equals(state)) disp_state =rfqNLS.get( "nextround").toString();
	    else disp_state =rfqNLS.get("illegalstate").toString();
		DateFormat df_d = DateFormat.getDateInstance(DateFormat.SHORT,locale);
		DateFormat df_t = DateFormat.getTimeInstance(DateFormat.SHORT,locale);
		Date dt= aRfq.getCreateTimeInEntityType();
		if (dt!=null) {
			disp_createtime =df_d.format(dt) +" " + df_t.format(dt);
		}
		String rfq_startTime;
		if ("".equals(aRfq.getActivateTime()) || aRfq.getActivateTime() == null){
			rfq_startTime = "";
        } else {
        	rfq_startTime = df_d.format(aRfq.getActivateTimeInEntityType()) + " " + df_t.format(aRfq.getActivateTimeInEntityType());
        } 
        
        String rfq_endDate;
        
		if ("".equals(aRfq.getEndTime()) || aRfq.getEndTime() == null){
			rfq_endDate = "";
        } else {
        	rfq_endDate = df_d.format(aRfq.getEndTimeInEntityType()) + " " + df_t.format(aRfq.getEndTimeInEntityType());
        }         
        
                     
        String rfq_closeTime;
        if (aRfq.getCloseTime() == null || "".equals(aRfq.getCloseTime())){
        	rfq_closeTime = "";
        } else {
			rfq_closeTime = df_d.format(aRfq.getCloseTimeInEntityType()) + " " + df_t.format(aRfq.getCloseTimeInEntityType());
        }
%>

<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(disp_idnum+";"+disp_state+";"+prevOffId+";"+nextOffId+";"+hasPrevRoundRfq+";"+hasNextRoundRfq,"parent.setChecked();myRefreshButtons();") %>
<%= comm.addDlistColumn(disp_name, "none") %>
<%= comm.addDlistColumn(logonId,"javascript:customerSummary('"+disp_idnum+"')") %>
<%= comm.addDlistColumn(disp_desc, "none") %>
<%= comm.addDlistColumn(disp_state, "none") %>
<%= comm.addDlistColumn(disp_createtime, "none") %>
<%= comm.addDlistColumn(rfq_startTime, "none") %>
<%= comm.addDlistColumn(rfq_endDate, "none") %>
<%= comm.addDlistColumn(rfq_closeTime, "none") %>
<%= comm.addDlistColumn(rfq_round, "none") %>
<%= comm.endDlistRow() %>

<%		
		if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
		
		}//endif
				
	}//end of for
		
}//endif
%>

	<%= comm.endDlistTable() %>

</form>

<script type="text/javascript">
<!--
parent.afterLoads();       
parent.setResultssize(<%= totalsize %>); // total
<% if (viewindex !=0) { %>
	parent.setoption(<%=viewindex %>);
<% } %>
//-->
</script>



</body>
</html>
