<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN StoreLocatorPopup.jsp -->
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<c:if test="${!pageloaded_storelocPopupJSPF}">
	<div id="storeLocatorPopup" role="dialog" dojoType="dijit.Dialog" style="display:none;" onkeypress="QuickInfoJS.setFocus" aria-label="<wcst:message key="QUICK_VIEW" bundle="${widgetText}"/>">
	<div id="grayOutPopup"></div>
		<div class="widget_quick_info_popup">
			<!-- Top Border Styling -->
			<div class="top">
				<div class="left_border"></div>
				<div class="middle"></div>
				<div class="right_border"></div>
			</div>
			<div class="clear_float"></div>
			<!-- Main Content Area -->
			<div class="middle">
				<div class="content_left_border">
					<div class="content_right_border">
						<%out.flush();%>
						<c:import url="/Widgets_701/Common/StoreLocatorPopup/StoreLocator.jsp">
							<c:param name="fromPage" value="ShoppingCart" />
							<c:param name="orderId" value="${WCParam.orderId}" />
						</c:import>
						<%out.flush();%>
					<!-- End content_right_border -->
					</div>
				<!-- End content_left_border -->
				</div>
			</div>
			<div class="clear_float"></div>
			<!-- Bottom Border Styling -->
			<div class="bottom">
				<div class="left_border"></div>
				<div class="middle"></div>
				<div class="right_border"></div>
			</div>
			<div class="clear_float"></div>
		</div>
	</div>
	
	<c:set var="pageloaded_storelocPopupJSPF" value="true" scope="request"/>
</c:if>

<!-- END StoreLocatorPopup.jsp -->
