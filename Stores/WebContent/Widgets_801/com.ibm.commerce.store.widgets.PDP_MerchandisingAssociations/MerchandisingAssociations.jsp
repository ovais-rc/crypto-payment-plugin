<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

    <!-- BEGIN MerchandisingAssociations.jsp -->

    <%@ include file="/Widgets_801/Common/EnvironmentSetup.jspf" %>

        <c:import url="/Widgets_801/Common/QuickInfo/QuickInfoPopup.jsp" />

        <%@ include file="ext/MerchandisingAssociations_Data.jspf" %>
            <c:if test="${param.custom_data ne 'true'}">
                <%@ include file="MerchandisingAssociations_Data.jspf" %>
            </c:if>

            <%@ include file="/Widgets_801/Common/StorePreviewShowInfo_Start.jspf" %>

                <%@ include file="ext/MerchandisingAssociations_UI.jspf" %>
                    <c:if test="${param.custom_view ne 'true'}">
                        <%@ include file="MerchandisingAssociations_UI.jspf" %>
                    </c:if>

                    <%@ include file="/Widgets_801/Common/StorePreviewShowInfo_End.jspf" %>
                        <jsp:useBean id="MerchandisingAssociations_TimeStamp" class="java.util.Date" scope="request" />

                        <script type="text/javascript">
                            $(document).ready(function() {
                                if (typeof productDisplayJS != 'undefined') {
			productDisplayJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${storeId}" />','<c:out value="${catalogId}" />','<c:out value="${userType}" />','<c:out value="${env_CurrencySymbolToFormat}" />');
			<c:if test="${hasAssociations}">
                                        wcTopic.subscribe("ShopperActions_Changed", MerchandisingAssociationJS.setBaseItemQuantity);
                                    wcTopic.subscribe("DefiningAttributes_Resolved", MerchandisingAssociationJS.setBaseItemAttributesFromProduct);
				     < /c:if>			
                                }
                            });

                        </script>
                        <wcpgl:pageLayoutWidgetCache/>
                        <!-- END MerchandisingAssociations.jsp -->
