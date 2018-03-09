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
<%-- 
  *****
  * This JSP displays the store locator content.
  * 
	* Parameters
	*
	* -fromUrl (optional)
	* If provided, clicking the Continue Shopping button will redirect back to the url specified
	*
	* -fromPage (optional)
	* It can be one of these options: "ProductDetails", "StoreLocator", or "ShoppingCart". If coming from the product details
	* page this page shows a short summary of the product at the top of the page. If coming from the shopping cart page then
	* the page will show the inventory information in the physical store list section. Otherwise, fromPage defaults to "StoreLocator"
	* and it will just show a default store locator page with search results and physical store list management.
	* 
	* -productId (optional)
	* The product id for the product that the shopper is checking inventory for.
	* 
	* -type (optional)
	* The type of product that the shopper is checking inventory for. This type parameter maybe "item", "product", "package" or "bundle".
  *****
--%>

<!-- BEGIN StoreLocator.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="/Widgets_701/Common/EnvironmentSetup.jspf" %>

<c:set var="fromPage" value="StoreLocator" />
<c:if test="${!empty WCParam.fromPage}">
	<c:set var="fromPage" value="${fn:escapeXml(WCParam.fromPage)}" />
</c:if>
<c:if test="${!empty param.fromPage}">
	<c:set var="fromPage" value="${fn:escapeXml(param.fromPage)}" />
</c:if>

<c:if test="${!empty WCParam.fromUrl}">
	<c:set var="fromUrl" value="${WCParam.fromUrl}" />
</c:if>
<c:if test="${!empty param.fromUrl}">
	<c:set var="fromUrl" value="${param.fromUrl}" />
</c:if>

<wcf:url var="AjaxProvinceSelectionDisplayURL" value="SLProvinceSelectionDisplayView" type="Ajax">
	<wcf:param name="storeId" value="${param.storeId}" />
	<wcf:param name="catalogId" value="${param.catalogId}" />
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
</wcf:url>
<wcf:url var="AjaxCitySelectionDisplayURL" value="SLCitySelectionDisplayView" type="Ajax">
	<wcf:param name="storeId" value="${param.storeId}" />
	<wcf:param name="catalogId" value="${param.catalogId}" />
	<wcf:param name="langId" value="${langId}" />
<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />	
</wcf:url>
<wcf:url var="AjaxStoreLocatorResultsURL" value="SLResultsView" type="Ajax">
	<wcf:param name="storeId" value="${param.storeId}" />
	<wcf:param name="catalogId" value="${param.catalogId}" />
	<wcf:param name="orderId" value="${param.orderId}" />
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
</wcf:url>
<wcf:url var="AjaxSelectedStoreListURL" value="SLSelectedStoreListView" type="Ajax">
	<wcf:param name="storeId" value="${param.storeId}" />
	<wcf:param name="catalogId" value="${param.catalogId}" />
	<wcf:param name="orderId" value="${param.orderId}" />
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="fromPage" value="${fromPage}" />
	<wcf:param name="ajaxStoreImageDir" value="${jspStoreImgDir}" />
</wcf:url>

<c:catch var="topGeoNodeException">
	<wcf:rest var="topGeoNodes" url="store/{storeId}/geonode/byTopGeoNode">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="siteLevelSearch" value="false"/>
	</wcf:rest>
</c:catch>

<script type="text/javascript" src='<c:out value="${staticIBMAssetAliasRoot}/Widgets_701/Common/StoreLocatorPopup/javascript/PhysicalStoreCookie.js"/>'></script>
<script type="text/javascript" src='<c:out value="${staticIBMAssetAliasRoot}/Widgets_701/Common/StoreLocatorPopup/javascript/StoreLocator.js"/>'></script>
<script type="text/javascript" src='<c:out value="${staticIBMAssetAliasRoot}/Widgets_701/Common/StoreLocatorPopup/javascript/StoreLocatorContextsDeclarations.js"/>'></script>
<script type="text/javascript" src='<c:out value="${staticIBMAssetAliasRoot}/Widgets_701/Common/StoreLocatorPopup/javascript/StoreLocatorControllersDeclaration.js" />'></script>
<script type="text/javascript">
	function openStoreLocatorPopup() {
		//the quick info dialog is hidden by default. We have to display it after the area is refreshed.
		var storeLocatorPopup = dijit.byId("storeLocatorPopup");
		if (storeLocatorPopup !=null) {			
			storeLocatorPopup.closeButtonNode.style.display='none';//hide the close button inherited from dijit.dialog		
			closeAllDialogs(); //close other dialogs(quickinfo dialog, etc) before opening this.
			
			storeLocatorPopup.show();
			// disable dialog re-position for ios and android right after the dialog is opened, this is to avoid virtual keyboard conflict
			if (ios || android) {
				storeLocatorPopup._relativePosition = new Object();
			}
			if(typeof TealeafWCJS != "undefined"){
				TealeafWCJS.rebind("storeLocatorPopup"); 
			}
		}else {
			console.debug("storeLocatorPopup does not exist");
		}
	}
	
	function closeStoreLocatorPopup() {
		var storeLocatorPopup = dijit.byId('storeLocatorPopup'); 
		if (storeLocatorPopup != null) { 
			storeLocatorPopup.hide(); 
		}
	}
		
	StoreLocatorControllersDeclarationJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>','<c:out value="${WCParam.orderId}"/>','<c:out value="${WCParam.fromPage}"/>');
	StoreLocatorControllersDeclarationJS.setControllerURL('provinceSelectionsController','<c:out value="${AjaxProvinceSelectionDisplayURL}"/>');
	StoreLocatorControllersDeclarationJS.setControllerURL('citySelectionsController','<c:out value="${AjaxCitySelectionDisplayURL}"/>');
	StoreLocatorControllersDeclarationJS.setControllerURL('storeLocatorResultsController','<c:out value="${AjaxStoreLocatorResultsURL}"/>');
	StoreLocatorControllersDeclarationJS.setControllerURL('selectedStoreListController','<c:out value="${AjaxSelectedStoreListURL}"/>');
	StoreLocatorContextsJS.setCommonParameters('<c:out value="${langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>','<c:out value="${WCParam.orderId}"/>','<c:out value="${WCParam.fromPage}"/>');
	
	<wcst:message bundle="${widgetText}" key='MISSING_CITY' var="MISSING_CITY"/>
	<wcst:message bundle="${widgetText}" key='EXCEED_PHYSICAL_STORE_SIZE' var="EXCEED_PHYSICAL_STORE_SIZE"/>
	
	MessageHelper.setMessage("MISSING_CITY", <wcf:json object="${MISSING_CITY}"/>);
	MessageHelper.setMessage("EXCEED_PHYSICAL_STORE_SIZE", <wcf:json object="${EXCEED_PHYSICAL_STORE_SIZE}"/>);

	dojo.addOnLoad(function() { parseWidget("selectedStoreList"); } );
	dojo.addOnLoad(function() { parseWidget("provinceSelections"); } );
	dojo.addOnLoad(function() { parseWidget("citySelections"); } );
	dojo.addOnLoad(function() { parseWidget("storeLocatorResults"); } );
	dojo.addOnLoad(storeLocatorJS.initProvinceSelections);
</script>

<div id="gift_registry_box">

		<div class="gift_header"><span aria-level="1" role="heading"><wcst:message bundle="${widgetText}" key="STORE_LIST_TITLE"/></span>
			<div id="closeStoreListHeader" class="checkout_show_icon checkout_top_location" style="display:block">
				<div id="WC_StoreLocator_div_14" class="hide"><a role="button" class="tlignore" id="WC_StoreLocator_links_5" href="Javascript: closeStoreLocatorPopup();"><wcst:message key="CLOSE" bundle="${widgetText}"/></a></div>
			</div>
		</div>

<!-- your store list -->
<span id="selectedStoreList_ACCE_Label" class="spanacce"><wcst:message bundle="${widgetText}" key="ACCE_Region_Your_Store_List"/></span>
<div dojoType="wc.widget.RefreshArea" id="selectedStoreList" widgetId="selectedStoreList" controllerId="selectedStoreListController" style="display:block;" ariaMessage="<wcst:message bundle="${widgetText}" key="ACCE_Status_Your_Store_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="selectedStoreList_ACCE_Label">
	<% out.flush(); %>
	<c:import url="/Widgets_701/Common/StoreLocatorPopup/SelectedStoreList.jsp">
		<c:param name="storeId" value="${param.storeId}" />
		<c:param name="catalogId" value="${param.catalogId}" />
		<c:param name="langId" value="${langId}" />
	</c:import>	
	<% out.flush(); %>
</div>
<form id="physicalStoreForm">
	<input type="hidden" id="BOPIS_physicalstore_id" name="BOPIS_physicalstore_id" value=""/>
</form>
<!-- your store list -->

<!-- store locator -->
<h1 class="gift_header"><wcst:message bundle="${widgetText}" key="STORELOCATOR_TITLE1"/></h1>

<div class="gift_content">
	<script type="text/javascript" src='<c:out value="${staticIBMAssetAliasRoot}/Widgets_701/Common/StoreLocatorPopup/javascript/Geolocation.js"/>'></script>
	<a href="#" role="button" class="button_primary" id="findNearest" onclick="javascript:GeolocationJS.launch();">
		<div class="left_border"></div>
		<div class="button_text"><wcst:message bundle="${widgetText}" key="MSTLOC_FIND_NEAREST" /></div>
		<div class="right_border"></div>
	</a>
</div>
<div class="gift_content">
	<span class="instruction"><wcst:message bundle="${widgetText}" key="SELECT_ENTER_OPTIONS"/></span>
	
	<div id="location">
		<c:set var="formName" value="searchByGeoNodeForm" />
		<form id='<c:out value="${formName}" />' name='<c:out value="${formName}" />'>

			<div id="WC_StoreLocator_div_29" class="location_select">
				<div id="WC_StoreLocator_div_30" class="location_select_label"><label for="selectCountry"><wcst:message bundle="${widgetText}" key="SELECT_COUNTRY" /></label></div>
				<div id="WC_StoreLocator_div_31" class="location_select_form">
					<select name="selectCountry" id="selectCountry" title="<wcst:message bundle="${widgetText}" key='ACCE_COUNTRY_CHANGE'/>" class="drop_down_country" onchange="JavaScript:storeLocatorJS.changeCountrySelection(this.options[this.selectedIndex].value);">
						<c:if test="${empty topGeoNodeException}">
							<c:set var="resultNum" value="${fn:length(topGeoNodes.GeoNode)}" />
							<c:if test="${resultNum > 0}">
								<c:forEach var="i" begin="0" end="${resultNum-1}">
									<option value='<c:out value="${topGeoNodes.GeoNode[i].uniqueID}" />'><c:out value="${topGeoNodes.GeoNode[i].Description[0].shortDescription}" /></option>
								</c:forEach>
							</c:if>
							<c:if test="${resultNum == 0 && !empty topGeoNodes.uniqueID}">
						    	<option value='<c:out value="${topGeoNodes.uniqueID}" />'><c:out value="${topGeoNodes.Description[0].shortDescription}" /></option>
						    </c:if>
						</c:if>
					</select>
				</div>
			</div>
			<div id="WC_StoreLocator_div_32" class="location_select">
				<div id="WC_StoreLocator_div_33" class="location_select_label"><label for="selectState"><wcst:message bundle="${widgetText}" key="SELECT_STATEPROVINCE" /></label></div>
				<div id="WC_StoreLocator_div_34" class="location_select_form">
					<div dojoType="wc.widget.RefreshArea" id="provinceSelections" widgetId="provinceSelections" controllerId="provinceSelectionsController">
						<% out.flush(); %>
						<c:import url="/Widgets_701/Common/StoreLocatorPopup/ProvinceSelectionDisplay.jsp">
							<c:param name="storeId" value="${param.storeId}" />
							<c:param name="catalogId" value="${param.catalogId}" />
							<c:param name="langId" value="${langId}" />
						</c:import>	
						<% out.flush(); %>
					</div>						
				</div>
			</div>
			<div id="WC_StoreLocator_div_35" class="location_select">
				<div id="WC_StoreLocator_div_36" class="location_select_label"><label for="selectCity"><wcst:message bundle="${widgetText}" key="SELECT_CITY" /></label></div>
				<div id="WC_StoreLocator_div_37" class="location_select_form">
					<div dojoType="wc.widget.RefreshArea" id="citySelections" widgetId="citySelections" controllerId="citySelectionsController">
						<% out.flush(); %>
						<c:import url="/Widgets_701/Common/StoreLocatorPopup/CitySelectionDisplay.jsp">
							<c:param name="storeId" value="${param.storeId}" />
							<c:param name="catalogId" value="${param.catalogId}" />
							<c:param name="langId" value="${langId}" />
						</c:import>	
						<% out.flush(); %>
					</div>

				</div>
			</div>
			<div id="WC_StoreLocator_div_38" class="location_select">
				<div id="WC_StoreLocator_div_39" class="location_select_button">
					<a href="#" role="button" class="button_primary" id="cityGo" onclick="Javascript:setCurrentId('cityGo'); storeLocatorJS.refreshResultsFromCity(document.${formName}, '<c:out value='${fromPage}'/>');">
						<div class="left_border"></div>
						<div class="button_text"><wcst:message bundle="${widgetText}" key="GO_BUTTON_LABEL" /></div>
						<div class="right_border"></div>
					</a>
				</div>
			</div>
		</form>
		<br clear="all"/>
	</div>
</div>

<span id="storeLocatorResults_ACCE_Label" class="spanacce"><wcst:message bundle="${widgetText}" key="ACCE_Region_Store_Result_List"/></span>
<div dojoType="wc.widget.RefreshArea" id="storeLocatorResults" widgetId="storeLocatorResults" ariaMessage="<wcst:message bundle="${widgetText}" key="ACCE_Status_Store_Result_List_Updated"/>" ariaLiveId="${ariaMessageNode}" controllerId="storeLocatorResultsController" role="region" aria-labelledby="storeLocatorResults_ACCE_Label">
	<% out.flush(); %>
	<c:import url="/Widgets_701/Common/StoreLocatorPopup/StoreLocatorResults.jsp">
		<c:param name="storeId" value="${param.storeId}" />
		<c:param name="catalogId" value="${param.catalogId}" />
		<c:param name="langId" value="${langId}" />
	</c:import>	
	<% out.flush(); %>
</div>

</div>
<!-- END StoreLocator.jsp -->
