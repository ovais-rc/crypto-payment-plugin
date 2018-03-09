<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@page
	import="java.util.*,com.ibm.commerce.tools.common.*,
	com.ibm.commerce.command.*,
	com.ibm.commerce.server.*,
	com.ibm.commerce.tools.util.*,
	com.ibm.commerce.tools.xml.*,
	com.ibm.commerce.datatype.*,
	com.ibm.commerce.beans.*"%>
<%@ page language="java"
	import="com.ibm.commerce.tools.common.ui.taglibs.*,
			com.ibm.commerce.utils.TimestampHelper" %>
	
<%@page import="com.ibm.commerce.tools.resourcebundle.*"%>

<%@include file="../common/common.jsp"%>
<%	java.sql.Timestamp currentTime = new java.sql.Timestamp(new java.util.Date().getTime()); %>
<%
	CommandContext cmdContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	Integer langId = cmdContext.getLanguageId();
	ResourceBundleProperties taxNLS = (ResourceBundleProperties) ResourceDirectory.lookup("taxation.taxationNLS", locale);
	//String orderByParm = request.getParameter("orderby");
	//String taxCategoryId = request.getParameter("taxCategoryId");
%>
<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%=UIUtil.getCSSFile(locale)%>"
	TYPE="text/css">
<STYLE TYPE='text/css'>
	.selectWidth {width: 230px;}
	.selectWidth2 {width: 260px;}
	.selectWidth3 {width: 260px;}
	</STYLE>
</HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT src="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT src="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>	
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<%@include file="../common/NumberFormat.jsp" %>

<script language="javascript">

	var taxcgryId = top.getData("taxCategoryId");
	var datas = top.getData("TaxRatesList");
	var numberOfTaxRatesInList = 0;
	var taxRatesDatas = new Array();
	
	if (datas != null){
		taxRatesDatas = getRatesListGroupByJurst(taxcgryId, datas);
		numberOfTaxRatesInList = taxRatesDatas.length;
	}
	// remCalRule4 is container of all the calrules will be removed when customer remove them from dynamic list.
	var	remCalRule4 = parent.parent.parent.parent.get("remCalRule4");  
	if(remCalRule4 == null){
		remCalRule4 = new Vector();
	} 
	
	
	<%--
		- This method is used to get the tax rates list group by jurisdiction.
	--%>
	function getRatesListGroupByJurst(taxcgryId,datas){
		if (datas == null){
			return null;
		}else{
			var jursts = top.getData("jurstlist");
			var result = new Array();
			var index=0;
			if (jursts != null){
				for (var i=0 ;i<jursts.length; i++){
					var jurstId = jursts[i].jurisdictionId;
					for (var j=0; j<datas.length ; j++){
						var inputid = taxcgryId;
						var compareTaxcgryId = datas[j].taxcgryId
						var compareJurstId = datas[j].jurstId;
						if ((inputid == compareTaxcgryId)&& (jurstId==compareJurstId)){
							result[index]=datas[j];
							index++;
						}
					}
				}
			}
			return result;
		}	
	}
	
	<%--
		- When customer click the add button, this method is invoked.
	--%>
	function addTaxRates(){
		// check jurst/tax code/tax categories
		var parameterIsEnough = top.getData("parameterIsEnough");
		if (! parameterIsEnough){
			var errorMessage = top.getData("errorMessage");
			alertDialog(errorMessage);
		}else{
			var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=taxation.taxRatesDialog&amp;operation=Add";
			top.setReturningPanel(parent.parent.parent.parent.getCurrentPanelAttribute("name"));
			top.saveData(null,"calculationRuleId");
			var op= "Add";
			top.saveData(op,"operation");
			top.saveModel(parent.parent.parent.parent.model);
			
			top.setContent("<%= UIUtil.toJavaScript((String)taxNLS.get("CreateTaxRates")) %>", url, true);
			
		}
		
	}
	
	<%--
		- When customer click change button, this method is invoked.
	--%>
	function changeTaxRates(){
		var rowIndex = -1;

		if (arguments.length > 0) {
			rowIndex = arguments[0];
		}
		else {
			var checked = parent.getChecked();
			if (checked.length > 0) {
				rowIndex = checked[0];
			}
		}
		top.saveData(rowIndex,"calculationRuleId");
		var o="Change";
		top.saveData(o,"operation");
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=taxation.taxRatesDialog";
		top.setReturningPanel(parent.parent.parent.parent.getCurrentPanelAttribute("name"));
		top.saveModel(parent.parent.parent.parent.model);
		
		top.setContent("<%= UIUtil.toJavaScript((String)taxNLS.get("ChangeTaxRates")) %>", url, true);
	}
	
	<%--
		- When customer click remove button, this method is invoked.
		- Remove the records from the list and reload it.
	--%>
	function deleteTaxRates(){
	
		// add confirm dialog
		if (parent.confirmDialog('<%= UIUtil.toJavaScript((String)taxNLS.get("TaxRatesDeleteMsg")) %>')){
			var taxes = parent.parent.parent.parent.get("TaxInfoBean1");
			var calrule = taxes.calrule;
			var taxFulfillmentInfoBean =parent.parent.parent.parent.get("TaxFulfillmentInfoBean1");
			var taxjcrule = taxFulfillmentInfoBean.taxjcrule;
			var ffmcntr =parent.parent.parent.parent.get("ffmcntr");
			
			var checkedIds = -1;
			
			if (arguments.length > 0) {
				checkedIds = arguments[0];
			}
			else {
				var checked = parent.getChecked();
				if (checked.length > 0) {
					checkedIds = checked;
				}
			}
			
			var taxRulesPairList = top.getData("TaxRulesPairList");
			
			
			for (var l=0; l<checkedIds.length; l++){
				var checkedId = checkedIds[l];
				
				//get the related ids
				var relatedIds = new Array();
				if (taxRulesPairList!= null){
					for (var i=0; i<taxRulesPairList.length; i++ ){
						var taxRulesPair = taxRulesPairList[i];
						if (taxRulesPair.calculationRuleId == checkedId){
							relatedIds = taxRulesPair.ruleList;
						}
					}
				}
				
				if (datas != null){
					for (var i=0; i<datas.length ; i++){
						var tempData = datas[i];
						if (checkedId == tempData.calculationRuleId){
							//delete this record from the list directly
							for (var j=i; j<datas.length; j++){
								datas[j]=datas[j+1];
							}
							datas.length = datas.length-1;
							//remove record from calrule
							// loop through the related ids and remove them
							for (var x=0; x<relatedIds.length; x++){
								var id = relatedIds[x];
								for (var j=0; j<size(calrule);j++){
									if (id == elementAt(j,calrule).calculationRuleId){
										removeElementAt(j,calrule);
										if (id.substring(0,1) != "@"){
											addElement(id,remCalRule4);
										}
									}
								}
							}
							
						}
					}
				}

			}
			
			//save to top
			top.saveData(datas,"TaxRatesList");
			parent.parent.parent.parent.put("remCalRule4", remCalRule4);
			//reload
			//window.location.href=window.location.href;
			parent.location.reload();
			
		}
		
	}
	
	
</script>

<body onload="" class="content_list" style="margin-left: 0px; margin-top: 10px">

<FORM name="taxRateContentForm" id="taxRateContentForm">

<script language="JavaScript" for="document" event="onclick()">
<!-- hide script from old browsers
document.all.CalFrame.style.display = "none";
//-->
</script>

<script language="JavaScript">
<!-- hide script from old browsers
document.writeln('<iframe id="CalFrame" title="' + top.calendarTitle + '" marginheight="0" marginwidth="0" frameborder="0" scrolling="no" src="Calendar" style="display: none; position: absolute; width: 198; height: 230"></iframe>');
//-->
</script>

<%= comm.startDlistTable(taxNLS.getProperty("taxRateList")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>

<%= comm.addDlistColumnHeading(taxNLS.getProperty("taxRatesList_Jurisdiction"), null, false) %>
<%= comm.addDlistColumnHeading(taxNLS.getProperty("taxRatesList_Rate"), null, false) %>
<%= comm.addDlistColumnHeading(taxNLS.getProperty("taxRatesList_StartDate"), null, false, null, false) %>
<%= comm.addDlistColumnHeading(taxNLS.getProperty("taxRatesList_EndDate"), null, false, null, false) %>
<%= comm.addDlistColumnHeading(taxNLS.getProperty("taxRatesList_Priority"), null, false, null, false) %>
<%= comm.endDlistRow() %>
<div id="generateDiv">
<script>
	if (numberOfTaxRatesInList > 0){
		for (var i=0; i<numberOfTaxRatesInList; i++){
			var rowselect =1;
			startDlistRow(rowselect);
			addDlistCheck(taxRatesDatas[i].calculationRuleId,"none");
			addDlistColumn(taxRatesDatas[i].jurisdiction,"none");
			addDlistColumn(numberToStr(taxRatesDatas[i].rate,"<%=langId%>", 4),"none");
			// start date:
			var startD = taxRatesDatas[i].startDate;
			if (startD == null){
				startD = "";
			}else{
				if (startD.indexOf(".0")>-1){
					startD = startD.substring(0,startD.indexOf(".0"));
				}
			}
			addDlistColumn(startD,"none");
			// end date:
			var endD = taxRatesDatas[i].endDate;
			if (endD == null){
				endD = "";
			}else{
				if (endD.indexOf(".0")>-1){
					endD = endD.substring(0,endD.indexOf(".0"));
				}
			}
			addDlistColumn(endD,"none");
			if (taxRatesDatas[i].precedence == null ||taxRatesDatas[i].precedence==""){
				taxRatesDatas[i].precedence=0.0;
			}
			
		
			addDlistColumn(numberToStr(taxRatesDatas[i].precedence, "<%=langId%>", 1),"none");
			if (rowselect == 1) {
				rowselect = 2;
			}
			else {
				rowselect = 1;
			}
		}
	}
</script>

<%= comm.endDlistTable() %>

<script language="JavaScript">
<!-- hide script from old browsers
if (numberOfTaxRatesInList == 0) {
	document.writeln('<br />');
	document.writeln('No Records');
}
//-->
</script>

</div>
</FORM>

<script language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(numberOfTaxRatesInList);
parent.setButtonPos("0px", "-10px");
//-->
</script>

</BODY>
</HTML>

