<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->

<%@ include file="SegmentCommon.jsp" %>

<p><%= segmentsRB.get("includeCustomerPanelTitle") %><br>

<script language="JavaScript">
<!-- hide script from old browsers
var segmentId;

if (parent.get) {
	var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
	if (o != null) {
		segmentId = o.<%= SegmentConstants.ELEMENT_ID %>;
	}
}

document.writeln('<iframe id="includeCustomerList" title="<%= UIUtil.toHTML((String)segmentsRB.get("includeCustomerPanelTitle")) %>" frameborder="0" scrolling="no" src="NewDynamicListView?ActionXMLFile=segmentation.ExplicitlyIncludedCustomerList&cmd=SegmentNotebookCustomersInclusionPanelView&segmentId=' + segmentId + '" width="750" height="200">');
document.writeln('</iframe>');
//-->
</script>
