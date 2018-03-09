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

<!-- BEGIN StaticContentContainer.jsp -->

<%@include file="../Common/EnvironmentSetup.jspf"%>
<%@taglib uri="http://commerce.ibm.com/pagelayout" prefix="wcpgl"%>

<div class="rowContainer" id="container_${pageDesign.layoutId}">
	<div class="row margin-true">
		<div class="col12" data-slot-id="1"><wcpgl:widgetImport slotId="1"/></div>
	</div>
	<div class="row">
		<div class="col6 acol12" data-slot-id="2"><wcpgl:widgetImport slotId="2"/></div>
		<div class="col6 acol12" data-slot-id="3"><wcpgl:widgetImport slotId="3"/></div>
	</div>
	<div class="row margin-true">
		<div class="col8 acol12 ccol9" data-slot-id="4"><wcpgl:widgetImport slotId="4"/></div>
		<div class="col4 acol12 ccol3" data-slot-id="5"><wcpgl:widgetImport slotId="5"/></div>
	</div>
</div>

<!-- END StaticContentContainer.jsp -->
