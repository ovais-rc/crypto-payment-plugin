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

<%@ page import="java.sql.Timestamp" %>
<%@ page import="com.ibm.commerce.contract.registry.TCMappingRegistry" %>
<%@ page import="com.ibm.commerce.contract.helper.TermConditionMappingData" %>
<%@ page import="com.ibm.commerce.contract.helper.TermConditionPropertyMappingData" %>
<%@ page import="com.ibm.commerce.contract.helper.TCConfigUtil" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.contract.beans.ExtendedTermConditionDataBean" %>
<%@ page import="com.ibm.commerce.contract.objects.ExtendedTermConditionAccessBean" %>
<%@ page import="com.ibm.commerce.contract.beans.ContractDataBean" %>
<%@ page import="com.ibm.commerce.price.facade.datatypes.PriceRuleType" %>
<%@ page import="com.ibm.commerce.contract.catalogfilter.beans.*" %> 


<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<jsp:useBean id="priceRuleListDB" scope="request" class="com.ibm.commerce.price.beans.PriceRuleListDataBean">
</jsp:useBean>
<jsp:useBean id="catalogFilterListDB" scope="request" class="com.ibm.commerce.contract.catalogfilter.beans.CatalogFilterListDataBean">
</jsp:useBean>

<% 
  	CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  	Integer langId = cmdContext.getLanguageId();
	String usage=request.getParameter("usage");
	String tradingId=null;
	String contractLastUpdate = null;
	boolean isUpdate=false;
	String isFromUpdatePanel = request.getParameter("isFromUpdatePanel");
	if(usage==null || usage.equals("")){
		usage="contract";
	}
	TCMappingRegistry registry=TCMappingRegistry.getInstance();
	Map unchangeMap=null;
	Map tcMap=new HashMap();
	if(usage.equals("contract")){
		unchangeMap=registry.getContractNonExistingMap();
	}
	else if(usage.equals("account")){
		unchangeMap=registry.getAccountNonExistingMap();
	}
	
	List priceRuleList = null;
	List catalogFilterList = null;
	CatalogFilter defaultFilter = null;
	
	Object[] tcMappingData=unchangeMap.values().toArray();
	tcMap.clear();
	Map rbMap = new HashMap();
	for(int i=0;i<tcMappingData.length;i++)
	{
		TermConditionMappingData mappingData=(TermConditionMappingData)tcMappingData[i];
		if(mappingData.isDisplay())
		{
			String tcSubType = mappingData.getTcSubType();
			tcMap.put(tcSubType,mappingData);
			if (rbMap.get(tcSubType) == null)
			{
				String tcRBName=mappingData.getResourceBundleName();
				Hashtable tcRB=(Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup(tcRBName, fLocale);
				rbMap.put(tcSubType, tcRB);
				
			}
			if (tcSubType.startsWith("PriceRuleTC") && priceRuleList==null){				
				DataBeanManager.activate(priceRuleListDB, request,response);
				priceRuleList = priceRuleListDB.getPriceRuleList();
			} else if ("CatalogFilterTC".equals(tcSubType) && catalogFilterList == null){
				if(contractId != null && contractId.length()>0){
					catalogFilterListDB.setContractId(new Long(contractId));
				    DataBeanManager.activate(catalogFilterListDB, request,response);	
				    catalogFilterList = catalogFilterListDB.getCatalogFilters();
				    if(catalogFilterList!=null && catalogFilterList.size()>0){
				    	defaultFilter = (CatalogFilter)catalogFilterList.get(0);
				    }
				}
			  catalogFilterListDB.setContractId(null);
			  catalogFilterListDB.setStoreId(new Long(fStoreId));			
				DataBeanManager.activate(catalogFilterListDB, request,response);
				catalogFilterList = catalogFilterListDB.getCatalogFilters();
			}
		}
	}
	
	int totalTabs=tcMap.size();
	int tableCells = 2*totalTabs+1;
	
	//begin to load property value if current action is update
	if(foundContractId && usage.equals("contract")){
		isUpdate=true;
		tradingId=contractId;
	    ContractDataBean contractDB = new ContractDataBean();	  
	    contractDB.setInitKey_referenceNumber(contractId);
	    DataBeanManager.activate(contractDB,cmdContext);
	    contractLastUpdate = contractDB.getTimeUpdated();
	}
	else if(foundAccountId && usage.equals("account")){
		isUpdate=true;
		tradingId=accountId;
	}
	
	HashMap extDataBeanMap=new HashMap();
	HashMap updateTCMap=new HashMap();
	
	ExtendedTermConditionDataBean tcDataBean=new ExtendedTermConditionDataBean();
	
	if(isUpdate){
		Map extendedTCDef = null;
		if(usage.equals("contract")){
			extendedTCDef = registry.getContractNonExistingMap();
		}else if(usage.equals("account")){
			extendedTCDef = registry.getAccountNonExistingMap();
		}
		Iterator itrExtendedTCDef = extendedTCDef.keySet().iterator();
		extDataBeanMap=new HashMap();
		while(itrExtendedTCDef.hasNext()){
			String tcSubType = (String)itrExtendedTCDef.next();
			Enumeration en=tcDataBean.findByTradingAndTCSubType(new Long(tradingId),tcSubType);
			while(en.hasMoreElements()){
				ExtendedTermConditionAccessBean tcAb=(ExtendedTermConditionAccessBean)en.nextElement();
				ExtendedTermConditionDataBean extDataBean=new ExtendedTermConditionDataBean();
				extDataBean.setDataBeanKeyReferenceNumber(tcAb.getReferenceNumber());
				DataBeanManager.activate(extDataBean,cmdContext);
				extDataBeanMap.put(extDataBean.getTcSubType(),extDataBean);
				updateTCMap.put(extDataBean.getTcSubType(),extDataBean.getReferenceNumber());
			}
		}
	}
	
	
%>


<html:html>
<HEAD>
<link rel=stylesheet href="<%= com.ibm.commerce.tools.util.UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>


<TITLE></TITLE>
</HEAD>

<script language="JavaScript">

var savedTab=0;
var currentTab=0;


function validatePanelData() {
    if (parent.validateExtendedTC) {
     if (parent.validateExtendedTC() == false) {
   				return false;
     	}
     }  
  return true; 
} 

	function onload(){
		if(<%=totalTabs%>!=0){
			updateContentView();
			loadPanelData();
		}
		parent.setContentFrameLoaded(true);
	}

	function selectTab(value)
	{
		updateTabView(value);
		updateContentView();
	}

	function updateTabView(value)
	{
		var index = value*2;

		if (savedTab == index) return;

		// make active
		var cell = table1.rows[1].cells[index+1];
		cell.style.backgroundColor="WHITE";

		table1.rows[1].cells[index+1].style.backgroundImage = 'url("/wcs/images/tools/catalog/tabbgactive.bmp")';
		table1.rows[1].cells[savedTab+1].style.backgroundImage = 'url("/wcs/images/tools/catalog/tabbg.bmp")';

		// before image
		if (index != 0) {
		   cell = table1.rows[1].cells[index];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoa.bmp' HEIGHT=23>";
		}

		// after image
		if (index != <%=tableCells-3%>) {
		   cell = table1.rows[1].cells[index+2];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/atoina.bmp' HEIGHT=23>";
		} else {
		   cell = table1.rows[1].cells[index+2];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/atoend.bmp' HEIGHT=23>";
		}

		// make inactive
		cell = table1.rows[1].cells[savedTab+1];
		cell.style.backgroundColor="#91B3DE";

		// before image
		if (savedTab != 0 && savedTab != (index+2)) {
		   cell = table1.rows[1].cells[savedTab];
		   cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoina.bmp' HEIGHT=23>";
		}

		// after image
		if (savedTab != (index-2)) {
		   if (savedTab != <%=tableCells-3%>) {
		      cell = table1.rows[1].cells[savedTab+2];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoina.bmp' HEIGHT=23>";
		   } else {
		      cell = table1.rows[1].cells[savedTab+2];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/inatoend.bmp' HEIGHT=23>";
		   }
		}
		
		// make first tab image shows correctly
		if (value != 0) {
		      cell = table1.rows[1].cells[0];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/lefttabunselected.bmp' HEIGHT=23>";
		} else {
		      cell = table1.rows[1].cells[0];
		      cell.innerHTML = "<IMG alt='' SRC='/wcs/images/tools/catalog/lefttabselected.bmp' HEIGHT=23>";
		}
		
		savedTab = index;
		currentTab=value;
	}
	
	function updateContentView(){
		
		for(var j=0;j<<%=totalTabs%>;j++){
			content.rows[0].cells[j].style.display = "none";
		}
		content.rows[0].cells[currentTab].style.display = "";		

	}
	
	function loadPanelData(){
		var tcs=new Array();
		if (parent.get){
			var o = parent.get("ContractCustomerTCModel", null);
			if (o != null) {
				tcs=o.tcs;
			}
			else{
				var tcmapping=new Object();
				tcmapping.tcs=new Array();
				parent.put("ContractCustomerTCModel", tcmapping);
			}
		}
		if(tcs==null){
			return;
		}
		else{
			var count=0;
			for(var i=0;i<tcs.length;i++){
				var properties=tcs[i].properties;
				for(var j=0;j<properties.length;j++){
					document.contentForm.elements[count].value=properties[j].value;
					count++;
				}
			}
		}
		// handle error messages back from the validate page
		if(parent.get("requiredProperyEmpty", false)){
			parent.remove("requiredProperyEmpty");
			var errorTCName=parent.get("errorTCName","");
			var errorPropertyName=parent.get("errorPropertyName","");
			parent.remove("errorTCName");
			parent.remove("errorPropertyName");
			var message='<%= (String)contractsRB.get("ETC_MsgValidEmpty") %>';
			message=message.replace(/%1/, errorPropertyName);
			message=message.replace(/%2/, errorTCName);
			alertDialog(message);
		}
	<%
	if(isUpdate){
	%>
		if (parent.get("nothing_changed", false)){
			parent.remove("nothing_changed");
			var message='<%= UIUtil.toJavaScript((String)contractsRB.get("errNoChangesOnCatalogFilterPriceRuleTC")) %>';
			alertDialog(message);
		}
	<%
	}
	%>

		
	}
	
	function savePanelData()
	 {
	 	//get the value from input table
		var tcs=new Array();
		var count=0;
		<%
		Object[] tcs=tcMap.values().toArray();
		String action=null;
		String tcId=null;
		for (int i=0;i<tcs.length;i++){
			action=null;
			tcId=null;
			TermConditionMappingData tcData = (TermConditionMappingData)tcs[i];
			if(updateTCMap.containsKey(tcData.getTcSubType())){
				action="update";
				tcId=(String)updateTCMap.get(tcData.getTcSubType());
			}
			Hashtable tcRB = (Hashtable)rbMap.get(tcData.getTcSubType());
			if (tcRB == null)
			{
				tcRB = contractsRB;
			}			
			
		%>
			var tc=new Object();
			tc.name='<%=tcData.getTcName()%>';
			tc.type='<%=tcData.getTcSubType()%>';
			tc.action='<%=action%>';
			tc.referenceNumber='<%=tcId%>';
			tc.displayName='<%=(String)tcRB.get(tcData.getTcName())%>';
			var property=new Array();
			var isEmpty=true;
			<%
			Object[] properties=tcData.getVisibleTcProperties().values().toArray();
			for(int j=0;j<properties.length;j++){
				TermConditionPropertyMappingData property=(TermConditionPropertyMappingData)properties[j];
			%>
				var aProperty=new Object();
				aProperty.name='<%=UIUtil.toJavaScript(property.getPropertyName())%>'
				aProperty.displayName='<%= UIUtil.toJavaScript((String)tcRB.get(property.getDisplayName()))%>';
				aProperty.value=document.contentForm.propertyValue_<%=""+i+j%>.value;
				aProperty.required='<%=property.isRequired()%>';
				property[<%=j%>]=aProperty;
				if(isEmpty && aProperty.value!=null && aProperty.value!="" ){
					isEmpty=false;
				}
			<%	
			}
			%>
			tc.properties=property;
			if(!isEmpty || tc.action=='update'){
				tc.save=true;
			}
			tcs[count++]=tc;
		<%
		}
		%>

	    if (parent.get)
	     {
	        var o = parent.get("ContractCustomerTCModel", null);
	        if (o != null) {
	        	o.tcs=tcs;
	        	o.contractId = '<%=UIUtil.toJavaScript(tradingId)%>';
	        	o.contractLastUpdate = "<%= UIUtil.toJavaScript(contractLastUpdate)%>";
	        }
	     }
	 }
	 function checkInputValue(inputbox, dataType){
	 	var value=inputbox.value;
	 	if(value==null || value==""){
	 		return true;
	 	}
	 	if(dataType=='DATATYPE_DOUBLE' || dataType=='DATATYPE_BIGDECIMAL' ){
	 		if(isValidNumber(value,"<%=langId%>",true)){
	 			return true;
	 		}
	 		else{
	 			alertDialog("<%= (String)contractsRB.get("ETC_MsgValidNumber") %>");
				return false;
	 		}
	 	}
	 	else if(dataType=='DATATYPE_LONG'){
	 		if(!isValidInteger(value,"<%=langId%>",true)){
	 			alertDialog("<%= (String)contractsRB.get("ETC_MsgValidLong") %>");
	 			return false;
	 		}
	 		else if(value>2147483647 || value<-2147483648){
	 			alertDialog("<%= (String)contractsRB.get("ETC_MsgValidLong") %>");
	 			return false
	 		}
	 		else{
	 			return true;
	 		}
	 	}
	 	else if(dataType=='DATATYPE_INTEGER'){
	 		if(!isValidInteger(value,"<%=langId%>",true)){
	 			alertDialog("<%= (String)contractsRB.get("ETC_MsgValidInteger") %>");
	 			return false;
	 		}
	 		else if(value>2147483647 || value<-2147483648){
	 			alertDialog("<%= (String)contractsRB.get("ETC_MsgValidInteger") %>");
	 			return false
	 		}
	 		else{
	 			return true;
	 		}
	 	}
	 	else if(dataType=='DATATYPE_TIMESTAMP'){
	 		if(validateDate(value)){
	 			return true;
	 		}
	 		else{
	 			alertDialog("<%= (String)contractsRB.get("ETC_MsgValidDate") %>");
				return false;
	 		}
	 	}
	 	else{
	 		return true;
	 	}
	 }
//////////////////////////////////////////////////////////
// This function will check whether or not the time has
// a valid format. hh:mm:ss
//
// Input: time
// Return code = "true", time has a right format
// Return code = "false", time format is wrong
//
//////////////////////////////////////////////////////////
function validateTime(timeStr) {
    
   if (timeStr == null)
       return false;
        
   var delimiter = ":";
   var hh, mm , ss;
   var timeStrLength;
   var hhlength;
   var mmlength;
   var sslength;

   timeStrLength = timeStr.length;

   if (timeStr == "" || timeStr.indexOf(delimiter) == -1 ||  timeStrLength > 8 ) return false;

   hh = timeStr.substring(0,2);
   mm = timeStr.substring(3,5);
   ss = timeStr.substring(6);
   

   hhlength = hh.length;
   mmlength = mm.length;
   sslength = ss.length;

   if (hhlength <1 || hhlength >2 || mmlength <1 || mmlength >2 || sslength <1 || sslength >2) return false;
   if (hh=="" || mm == "" || ss == "" ) return false;
   if (isNaN(hh) || isNaN(mm) || isNaN(ss) ) return false;

   if ( parseInt(hh) > 23 || parseInt(hh) < 0 ) return false;
   if ( parseInt(mm) > 59 || parseInt(mm) < 0 ) return false;
   if ( parseInt(ss) > 59 || parseInt(ss) < 0 ) return false;

   return true;
}	 


	 function validateDate(date){
	 	if(date.length!=10 && date.length!=19){
	 		return false
	 	}
	 	if(date.substring(4,5)!='-' || date.substring(7,8)!='-'){
	 		return false;
	 	}
	 	var year=date.substring(0,4);
	 	var month=date.substring(5,7);
	 	var day=date.substring(8,10);
	 	
	 	var dateValidated = validDate(year,month,day);
	 	var timeValidated = true;
	 	if (date.length == 19){
	 		timeValidated = validateTime(date.substring(11,20));
	 	}

	 	return dateValidated && timeValidated;
	 }

	function pressKey(value){
		var keycode = event.keyCode;
		if(keycode==13){
			selectTab(value);
		}
	}	 

</script>
<BODY onload="onload()" class="content">
<%@include file="../common/NumberFormat.jsp" %>
<%if (totalTabs!=0){%>
<form name="contentForm">
<h1><%= UIUtil.toHTML((String)contractsRB.get("extenedTC"))%></h1>

	<TABLE ID=table1 WIDTH="100%" MARGIN=0 BORDER=0 BGCOLOR=#EFEFEF CELLSPACING=0 CELLPADDING=0>
		<TR HEIGHT=10px><TD COLSPAN=14></TD></TR>
		<TR CLASS=tab STYLE="height: 23px;">
			<TD STYLE="border-width: 0 0 0 0;"><IMG alt='' SRC="/wcs/images/tools/catalog/lefttabselected.bmp" HEIGHT=23></TD>
<%
	for (int iTab=0; iTab<tcMap.size(); iTab++)
	{
		TermConditionMappingData tcData = (TermConditionMappingData)tcs[iTab];
		Hashtable tcRB = (Hashtable)rbMap.get(tcData.getTcSubType());
		if (tcRB == null)
		{
			tcRB = contractsRB;
		}
		
		String strTitle = UIUtil.toHTML((String)tcRB.get(tcData.getTcName()));
		
		if (iTab == 0) {
%>
			<TD CLASS=activetab onClick=selectTab(<%=iTab%>) onkeypress=pressKey(<%=iTab%>) NOWRAP STYLE='cursor:hand; height: 23px; background-image: url("/wcs/images/tools/catalog/tabbgactive.bmp");'>&nbsp;<a STYLE='color:#000000;' href="javascript:selectTab(<%=iTab%>)"><%=strTitle%></a>&nbsp;</TD>
			<%if (tcMap.size()==1) {%>
				<TD CLASS=tabend STYLE="border-width: 0 0 0 0;"><IMG alt='' SRC="/wcs/images/tools/catalog/atoend.bmp" HEIGHT=23></TD>
			<% } else {%>
				<TD CLASS=tabend STYLE="border-width: 0 0 0 0;"><IMG alt='' SRC="/wcs/images/tools/catalog/atoina.bmp" HEIGHT=23></TD>                                            
			<%} %>
<%
		} else if (iTab == tcMap.size()-1) {
%>
			<TD CLASS=inactivetab onClick=selectTab(<%=iTab%>) onkeypress=pressKey(<%=iTab%>) NOWRAP STYLE='cursor:hand; height: 23px; background-image: url("/wcs/images/tools/catalog/tabbg.bmp");'>&nbsp;<a STYLE='color:#000000;' href="javascript:selectTab(<%=iTab%>)"><%=strTitle%></a>&nbsp;</TD>
			<TD CLASS=tabend STYLE="border-width: 0 0 0 0;"><IMG alt='' SRC="/wcs/images/tools/catalog/inatoend.bmp" HEIGHT=23></TD>
<%
		} else {
%>
			<TD CLASS=inactivetab onClick=selectTab(<%=iTab%>) onkeypress=pressKey(<%=iTab%>) NOWRAP STYLE='cursor:hand; height: 23px; background-image: url("/wcs/images/tools/catalog/tabbg.bmp");'>&nbsp;<a STYLE='color:#00000;' href="javascript:selectTab(<%=iTab%>)"><%=strTitle%></a>&nbsp;</TD>
			<TD CLASS=tabend STYLE="border-width: 0 0 0 0;"><IMG alt='' SRC="/wcs/images/tools/catalog/inatoina.bmp" HEIGHT=23></TD>
<%
		}
	}
%>
			<TD WIDTH=100% STYLE='height: 23px;  background-image: url("/wcs/images/tools/catalog/bottom.bmp");'>&nbsp;</TD>
		</TR>
	</TABLE>
	
	<table id=content width="100%">
		
		
		<tr>
		
			<br/>
			<% 
			int rowselect=1;
			for (int i=0;i<tcMap.size();i++){
				TermConditionMappingData tcData = (TermConditionMappingData)tcs[i];
				Hashtable tcRB = (Hashtable)rbMap.get(tcData.getTcSubType());
				if (tcRB == null)
				{
					tcRB = contractsRB;
				}
			%>
			<td>
				<%=UIUtil.toHTML((String)tcRB.get(tcData.getTcDescription()))%>
				<p/>			
				<%= comm.startDlistTable(tcData.getTcName()) %>
				<%= comm.startDlistRowHeading() %>
				<%= comm.addDlistColumnHeading((String)contractsRB.get("propertyName"),null, false) %>
				<%= comm.addDlistColumnHeading((String)contractsRB.get("propertyValue"),null, false) %>
				<%= comm.addDlistColumnHeading((String)contractsRB.get("propertyDataType"),null, false) %>
				<%= comm.addDlistColumnHeading((String)contractsRB.get("propertyDescription"),null, false) %>
				<%= comm.endDlistRow() %>
				
				<%
				String tcSubType = tcData.getTcSubType();				
				HashMap propertyMap=tcData.getVisibleTcProperties();
				Object[] properties=propertyMap.values().toArray();
				String value=null;
				ExtendedTermConditionDataBean extDataBean=null;
				Integer tcChangable = null;
				
				if(extDataBeanMap.containsKey(tcData.getTcSubType())){
					extDataBean=(ExtendedTermConditionDataBean)extDataBeanMap.get(tcData.getTcSubType());
					tcChangable = extDataBean.getChangeableFlagInEntityType();
				}
				
				
				for(int j=0;j<properties.length;j++){
					TermConditionPropertyMappingData property=(TermConditionPropertyMappingData)properties[j];
					boolean propertyChangable = property.isChangable();
					
					if(extDataBean!=null){
						
						String propertyName=property.getPropertyName();
						Object obj=extDataBean.getProperty(propertyName);
						if(obj!=null){							
							if (obj instanceof Timestamp){
							  	value = TCConfigUtil.timestampToString((Timestamp)obj);
							}else if(obj instanceof Double){
								value=com.ibm.commerce.base.objects.WCSStringConverter.DoubleToString((Double)obj);
							}
							else{
								value=obj.toString();
							}
							value = UIUtil.toHTML(value);
						}
						else{
							value="";
						}
					}
					else{
						value="";
					}
					String disableString = "";
					if  ( isFromUpdatePanel != null && isFromUpdatePanel.equals("true") && ( (tcChangable != null && tcChangable.intValue()==0) || propertyChangable == false) ){
						disableString = "disabled";
					}
					String inputStr = "";
					String dataType = property.getDataType();
					if (tcSubType.startsWith("PriceRuleTC")&& property.getPropertyName().equalsIgnoreCase("priceRuleId") ) {
						
						inputStr="<select name=\"propertyValue_" + i + j+ "\" id=\"propertyValue_" + i + j + 
						"\" value=\"" + value + "\"" + ">"
						+ "<option value=\"\">"+tcRB.get("noPriceRuleForPriceTC")+"</option>";
						if (priceRuleList != null && priceRuleList.size() > 0){
							boolean selected=false;
							for (int k = 0; k < priceRuleList.size(); k++){
								PriceRuleType priceRule = (PriceRuleType) priceRuleList.get(k);
								String uniqueId = priceRule.getPriceRuleIdentifier().getUniqueID();
								String identifier = priceRule.getPriceRuleIdentifier().getExternalIdentifier().getName();
								
								String priceruleRelatedStoreId = priceRule.getPriceRuleIdentifier().getExternalIdentifier().getStoreIdentifier().getUniqueID();
								StoreEntityAccessBean abStoreEnt = new StoreEntityAccessBean();
								abStoreEnt.setInitKey_storeEntityId(priceruleRelatedStoreId);
								String storeIdentifier = abStoreEnt.getIdentifier();
								
								if (value.equalsIgnoreCase(uniqueId) && !selected){
									inputStr = inputStr+"<option value=\"" + uniqueId + "\" selected>" + UIUtil.toHTML(identifier + "(" + storeIdentifier + ")") + "</option>";
									selected=true;
								}
								else{
									inputStr = inputStr+"<option value=\"" + uniqueId + "\" >" + UIUtil.toHTML(identifier + "(" + storeIdentifier + ")") + "</option>";
								}
							}
						}
							
						inputStr = inputStr + "</select>";
				}else if (tcSubType.startsWith("PriceRuleTC")&& 
					(property.getPropertyName().equalsIgnoreCase("priceRuleBeginDate") || property.getPropertyName().equalsIgnoreCase("priceRuleExpiryDate"))){
				%>
					<input type="hidden" name="propertyValue_<%=i %><%=j %>" value="" />
				<%
					
					continue;
				} else if (tcSubType.startsWith("CatalogFilterTC")&& property.getPropertyName().equalsIgnoreCase("catalogFilterId") ) {
						inputStr="<select name=\"propertyValue_" + i + j+ "\" id=\"propertyValue_" + i + j + 
						"\" value=\"" + value + "\"" + ">";
						if(defaultFilter == null){
						  inputStr = inputStr + "<option value=\"\">"+UIUtil.toHTML((String)contractsRB.get("chooseACatalogFilter"))+"</option>";
						} else {
							inputStr = inputStr + "<option value=\"\">"+UIUtil.toHTML((String)contractsRB.get("removeCatalogFilter"))+"</option>";
						}
						if (catalogFilterList != null && catalogFilterList.size() > 0){
							boolean selected=false;
							for (int k = 0; k < catalogFilterList.size(); k++){
								CatalogFilter catalogFilter = (CatalogFilter) catalogFilterList.get(k);
								Long ctfId = catalogFilter.getFilterId();
								String filterName = catalogFilter.getFilterName();
								if(defaultFilter != null && defaultFilter.getFilterId().compareTo(ctfId)==0){
								    inputStr = inputStr + "<option value=\"" + ctfId+"\" selected=\"selected\">" + filterName + "</option>";
								} else {
									inputStr = inputStr + "<option value=\"" + ctfId+"\">" + filterName + "</option>";
								}
							}
						}
							
						inputStr = inputStr + "</select>";

					} else {
						if( dataType.equals("DATATYPE_INTEGER")){
					 		inputStr="<input type=\"text\" name=\"propertyValue_"+i+j+"\" id=\"propertyValue_"+i+j+"\" size=32 maxlength=10 onChange=\"return checkInputValue(this,'"+property.getDataType()+"' )\" value=\""+value;
					 	}else if (dataType.equals("DATATYPE_LONG")){
					 		inputStr="<input type=\"text\" name=\"propertyValue_"+i+j+"\" id=\"propertyValue_"+i+j+"\" size=32 maxlength=10 onChange=\"return checkInputValue(this,'"+property.getDataType()+"' )\" value=\""+value;
					 	}
					 	else if (dataType.equals("DATATYPE_DOUBLE") || dataType.equals("DATATYPE_BIGDECIMAL")){
					 		inputStr="<input type=\"text\" name=\"propertyValue_"+i+j+"\" id=\"propertyValue_"+i+j+"\" size=32 maxlength=15 onChange=\"return checkInputValue(this,'"+property.getDataType()+"' )\" value=\""+value;
					 	
					 	}else if (dataType.equals("DATATYPE_STRING")){
					 		inputStr="<input type=\"text\" name=\"propertyValue_"+i+j+"\" id=\"propertyValue_"+i+j+"\" size=32 maxlength=127 onChange=\"return checkInputValue(this,'"+property.getDataType()+"' )\" value=\""+value;
					 	
					 	}else if (property.getDataType().equals("DATATYPE_TIMESTAMP")){
					 		inputStr="<input type=\"text\" name=\"propertyValue_"+i+j+"\" id=\"propertyValue_"+i+j+"\" size=32 maxlength=19 onChange=\"return checkInputValue(this,'"+property.getDataType()+"' )\" value=\""+value;
					 	}else{
					 		inputStr="<input type=\"text\" name=\"propertyValue_"+i+j+"\"  id=\"propertyValue_"+i+j+"\" size=32 onChange=\"return checkInputValue(this,'"+property.getDataType()+"' )\" value=\""+value;
					 	}
					 	
					 	inputStr += "\" " + disableString + ">";
				 	}
				%>
					<%= comm.startDlistRow(rowselect) %>
					 <%= comm.addDlistColumn( "<label for=propertyValue_"+ i+ j+ ">" + (String)tcRB.get(property.getDisplayName()) + "</label>", "none" ) %> 
				      <%= comm.addDlistColumn( inputStr, "none" ) %>
				      <%= comm.addDlistColumn( (String)contractsRB.get(property.getDataType()), "none" ) %>
				      <%= comm.addDlistColumn( (String)tcRB.get(property.getDescription()), "none" ) %>
				      <%= comm.endDlistRow() %>
				<%
					if(rowselect==1) rowselect=2;
					if(rowselect==2) rowselect=1;
				}
				%>
				<%= comm.endDlistTable() %>
				</td>
			<%
			}
			%>
		
		</tr>
		
	</table>

</form>
<%}else{
%>
<h1><%=UIUtil.toHTML((String)contractsRB.get("noExtendedTC")) %></h1>

<%} %>

</BODY>
</html:html>
 
 
 
 
 
