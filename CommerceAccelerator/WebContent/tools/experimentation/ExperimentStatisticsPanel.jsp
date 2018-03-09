<!-- ==================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2005
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=================================================================== -->

<%@ include file="common.jsp" %>

<script language="JavaScript">
<!-- hide script from old browsers
var url;
if (experimentStatus == "<%= com.ibm.commerce.tools.experimentation.ExperimentConstants.EXPERIMENT_STATUS_COMPLETED %>") {
	url = "<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=experiment.ExperimentStatistics" + document.experimentSummaryForm.storeElementTypeName.value + "NoButtonList&cmd=ExperimentStatistics" + document.experimentSummaryForm.storeElementTypeName.value + "ListView&experimentId=" + document.experimentSummaryForm.experimentId.value;
}

else {
	url = "<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=experiment.ExperimentStatistics" + document.experimentSummaryForm.storeElementTypeName.value + "List&cmd=ExperimentStatistics" + document.experimentSummaryForm.storeElementTypeName.value + "ListView&experimentId=" + document.experimentSummaryForm.experimentId.value;
}
document.writeln('<iframe id="experimentStatisticsList" name="experimentStatisticsList" title="<%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListTitle")) %>" frameborder="0" scrolling="no" src="' + url + '" width="100%" height="400">');
document.writeln('</iframe>');
//-->
</script>
