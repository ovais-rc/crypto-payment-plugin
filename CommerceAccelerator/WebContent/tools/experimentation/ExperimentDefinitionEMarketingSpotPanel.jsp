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

<iframe id="experimentalElementList" name="experimentalElementList" title="<%= UIUtil.toHTML((String)experimentRB.get("experimentDialogElementPrompt")) %>" frameborder="0" scrolling="no" src="<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=experiment.ExperimentEMarketingSpotElementList&cmd=ExperimentEMarketingSpotElementListView" width="100%" height="150">
</iframe>
