<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN LandingPageContainer.jsp -->

<%@include file="../Common/EnvironmentSetup.jspf" %>
<%@taglib uri="http://commerce.ibm.com/pagelayout" prefix="wcpgl"%>

<div class="rowContainer" id="container_${pageDesign.layoutId}">
	<div class="row">
		<div class="col6 acol12 slot1" data-slot-id="1"><wcpgl:widgetImport slotId="1"/></div>
		<div class="col6 acol12 slot2" data-slot-id="2"><wcpgl:widgetImport slotId="2"/></div>
	</div>
	<div class="row">
		<div class="col3 acol12 slot3" data-slot-id="3"><wcpgl:widgetImport slotId="3"/></div>
		<div class="col9 acol12 slot4" data-slot-id="4"><wcpgl:widgetImport slotId="4"/></div>
	</div>
	<div class="row" id="searchLandSlot7">
		<div class="col8 acol12 slot5" data-slot-id="5"><wcpgl:widgetImport slotId="5"/></div>
		<div class="col4 acol12 slot6" data-slot-id="6"><wcpgl:widgetImport slotId="6"/></div>
	</div>
</div>

<!-- END LandingPageContainer.jsp -->
