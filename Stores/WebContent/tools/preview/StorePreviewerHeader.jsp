<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@include file="BrowserCacheControl.jsp" %>

<%@page import="java.net.URL"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.ibm.icu.util.TimeZone"%>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.tools.segmentation.SegmentDataBean"%>
<%@page import="com.ibm.commerce.foundation.internal.server.services.search.metadata.solr.SolrSearchServiceConstants"%>
<%@page import="com.ibm.commerce.foundation.server.services.businesscontext.ContextService"%>
<%@page import="com.ibm.commerce.foundation.server.services.businesscontext.ContextServiceFactory"%>
<%@page import="com.ibm.commerce.catalog.facade.server.helpers.SearchUpdateHelper"%>
<%@page import="com.ibm.commerce.catalog.facade.server.helpers.CatalogComponentHelper"%>
<%@page import="com.ibm.commerce.foundation.internal.server.services.search.util.SolrSearchWorkspaceHelper"%>
<%@page import="com.ibm.commerce.context.content.ContentContext"%>
<%@page import="com.ibm.commerce.context.content.events.WorkspaceData"%>
<%@page import="com.ibm.commerce.context.preview.PreviewContext"%>
<%@page import="com.ibm.commerce.foundation.internal.server.services.search.config.solr.SolrSearchConfigurationRegistry"%>
<%@page import="com.ibm.commerce.foundation.internal.server.services.dataaccess.workspace.util.PhysicalDataHelperProvider"%>
<%@page import="com.ibm.commerce.foundation.internal.server.services.dataaccess.logging.SearchServiceSystemMessageKeys"%>
<%@page import="com.ibm.commerce.foundation.internal.server.services.dataaccess.workspace.util.PhysicalDataHelperFactory"%>
<%@page import="com.ibm.commerce.contentmanagement.objects.WorkspaceAccessBean" %>
<%@page import="com.ibm.commerce.server.WcsApp" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="flow.tld" prefix="flow" %>

<c:if test="${CommandContext.storeId != 0}">

<fmt:setLocale value="${param.locale}" />
<fmt:setBundle basename="com.ibm.commerce.stores.preview.properties.StorePreviewer" var="resources" />
<fmt:setBundle basename="com.ibm.commerce.catalog.logging.properties.WcCatalogMessages" var="catalogMsgs" />

<%
	com.ibm.icu.text.SimpleDateFormat dateFormat = new com.ibm.icu.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	String timeZoneId = request.getParameter("timeZoneId");
	String previewStartTime = request.getParameter("start");
	String timeZoneDisplayName = "";
	String clientDateFormat = request.getParameter("dateFormat");
	String clientTimeFormat = request.getParameter("timeFormat");

	String localeStr = request.getParameter("locale");
	Locale locale = null;
	if (localeStr == null) {
		locale = Locale.getDefault();
	}
	else {
		String[] localeInfo = localeStr.split("_");
		if (localeInfo.length == 1) {
			locale = new Locale(localeInfo[0]);
		}
		else{
			locale = new Locale(localeInfo[0], localeInfo[1]);
		}
	}

	if (previewStartTime == null) {
	 	long currentMillis = System.currentTimeMillis();
		java.sql.Timestamp previewTime = new java.sql.Timestamp(currentMillis);
		if (timeZoneId !=null && !timeZoneId.equals("")) {
			TimeZone preferredTz = TimeZone.getTimeZone(timeZoneId);
			TimeZone serverTz = TimeZone.getTimeZone(TimeZone.getDefault().getID());
			int offset = preferredTz.getOffset(previewTime.getTime()) - serverTz.getOffset(previewTime.getTime());
			previewTime.setTime(previewTime.getTime() + offset);
		}
		previewStartTime = dateFormat.format(new java.util.Date(previewTime.getTime()));
	}

	if (timeZoneId !=null && !timeZoneId.equals("")) {
		timeZoneDisplayName = TimeZone.getTimeZone(timeZoneId).getDisplayName(locale);
	}

	String includedMemberGroupIds = request.getParameter("includedMemberGroupIds");
	/* determine member group names */
	String mbrGroupIncludedNames = "";
	CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");

	if (includedMemberGroupIds != null && !includedMemberGroupIds.equals("")) {
		int mbGrpIncludedCounter = 0;
		try {
			java.util.StringTokenizer st = new java.util.StringTokenizer(includedMemberGroupIds, ",");
			while (st.hasMoreElements()) {

					SegmentDataBean segmentDataBean = new SegmentDataBean();
					segmentDataBean.setCommandContext(aCommandContext);
					segmentDataBean.setId(st.nextToken());
					segmentDataBean.populate();

					if (mbGrpIncludedCounter > 0) {
							mbrGroupIncludedNames += ", ";
					}
					String mbrGrpName = segmentDataBean.getSegmentDisplayName();
					if (mbrGrpName == null || mbrGrpName.equals("")) {
							mbrGrpName = segmentDataBean.getSegmentName();
					}
					mbrGroupIncludedNames += mbrGrpName;
					mbGrpIncludedCounter++;

			} // end while
		}catch(Exception e) {}
	}

	PreviewContext previewContext = (PreviewContext) aCommandContext.getContext(PreviewContext.CONTEXT_NAME);
	String previewTimestamp = (previewContext == null ? previewStartTime : dateFormat.format(previewContext.getTimestamp()));

	WorkspaceData workspaceData = ((ContentContext)aCommandContext.getContext(ContentContext.NAME)).getWorkspaceData();
	if (workspaceData != null) {
		WorkspaceAccessBean abWorkspace = new WorkspaceAccessBean().findByIdentifier(workspaceData.getWorkspaceName());
		pageContext.setAttribute("workspaceId", abWorkspace.getWorkspaceId());
	}

	SolrSearchConfigurationRegistry searchRegistry =
			SolrSearchConfigurationRegistry.getInstance();
	Integer storeId = aCommandContext.getStoreId();
	Long userId = aCommandContext.getUserId();

	if(searchRegistry.isSearchEnabled(storeId)) {
		ResourceBundle resourceBundle = ResourceBundle.getBundle(
				SolrSearchServiceConstants.FOUNDATION_RESOURCE_BUNDLE,
				locale);
		Long masterCatalogId = searchRegistry.getMasterCatalog(storeId);
		String message = null;
		if (masterCatalogId != null) {
			boolean isIndexing = false;
			// Check workspace schema if working with non-approved content;
			// otherwise, this request will be performed against the base
			// schema
			ContentContext contentContext = SolrSearchWorkspaceHelper
				.getWorkspaceContext();
			if (contentContext != null && contentContext.getWorkspaceData() != null) {
				String schemaName = contentContext.getWorkspaceData().getWriteSchema();
				boolean usingWorkspaceQueuingFeature = searchRegistry.isWorkspaceUsingPreviewIndexQueuing(schemaName);
				if (SearchUpdateHelper.isPerformingSearchIndexing(
						SolrSearchServiceConstants.INDEX_NAME_CATALOG_ENTRY,
						masterCatalogId.toString(), schemaName)) {
					if (usingWorkspaceQueuingFeature &&
					   !SearchUpdateHelper.isIndexingReady(SolrSearchServiceConstants.INDEX_NAME_CATALOG_ENTRY,
						masterCatalogId.toString(), schemaName, userId)) {
						isIndexing = true;
					} else {
						isIndexing = true;
					}
				}
				if (SearchUpdateHelper.isPerformingSearchIndexing(
						SolrSearchServiceConstants.INDEX_NAME_CATALOG_GROUP,
						masterCatalogId.toString(), schemaName)) {
					if (usingWorkspaceQueuingFeature &&
					   !SearchUpdateHelper.isIndexingReady(SolrSearchServiceConstants.INDEX_NAME_CATALOG_GROUP,
						masterCatalogId.toString(), schemaName, userId)) {
						isIndexing = true;
					} else {
						isIndexing = true;
					}
				}
			}
			if (SearchUpdateHelper.isPerformingSearchIndexing(
					SolrSearchServiceConstants.INDEX_NAME_CATALOG_ENTRY,
					masterCatalogId.toString())) {
				isIndexing = true;
			}
			if (SearchUpdateHelper.isPerformingSearchIndexing(
					SolrSearchServiceConstants.INDEX_NAME_CATALOG_GROUP,
					masterCatalogId.toString())) {
				isIndexing = true;
			}
			if (isIndexing) {
				String indexingWarningThreshold = searchRegistry.getExtendedConfigurationPropertyValue(
						SolrSearchServiceConstants.PROPERTY_NAME_INDEXING_WARNING_THRESHOLD);
				int count = SearchUpdateHelper.countAnyIndexing(
						SolrSearchServiceConstants.INDEX_NAME_CATALOG_ENTRY,
						masterCatalogId.toString());
				int threshold = 1000;
				if (indexingWarningThreshold != null
						&& indexingWarningThreshold.length() > 0) {
					threshold = Integer.valueOf(indexingWarningThreshold);
				}
				if (threshold < count) {
					message = "CWXFS3302I: A large amount of pending changes have been detected in your workspace. Indexing might take an above average amount of time to complete.";
					if (resourceBundle != null) {
						message = resourceBundle
								.getString(SearchServiceSystemMessageKeys.INDEXING_STATUS_LONG_WAIT);
					}
				} else {
					message = "CWXFS3301I: Pending changes in your workspace are being indexed. Updates should be available soon.";
					if (resourceBundle != null) {
						message = resourceBundle
								.getString(SearchServiceSystemMessageKeys.INDEXING_STATUS_PENDING);
					}
				}
			} else {
				message = "The search index is up to date.";
				if (resourceBundle != null) {
					message = resourceBundle
							.getString(SearchServiceSystemMessageKeys.INDEXING_STATUS_IDLE);
				}
			}
		}
		if (message != null && message.startsWith("CWXFS330")) {
			message = message.substring(12);
		}
		pageContext.setAttribute("indexMsg", message);
	}

	pageContext.setAttribute("previewStartTime", previewStartTime);
	pageContext.setAttribute("previewTimestamp", previewTimestamp);
	pageContext.setAttribute("clientDateFormat", clientDateFormat);
	pageContext.setAttribute("clientTimeFormat", clientTimeFormat);
	pageContext.setAttribute("toolsPort", (com.ibm.commerce.server.ConfigProperties.singleton().getValue("WebServer/ToolsPort")));
	pageContext.setAttribute("toolsWebAppPath", WcsApp.configProperties.getWebModule("CommerceAccelerator").getContextPath() + WcsApp.configProperties.getWebModule("CommerceAccelerator").getUrlMappingPath());
	pageContext.setAttribute("wcsstorePath", WcsApp.configProperties.getWebModule("Stores").getWebAlias());

%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="${pageContext.request.locale.language}" lang="${pageContext.request.locale.language}">
	<head>

        <script type="text/javascript" src="<c:out value='${staticIBMAssetContextRoot}/JQuery/vendor.js'/>"></script>

		<script src="${env_imageContextPath}/qrcode/js/qrcode.js"></script>
		<script src="${env_imageContextPath}/tools/preview/javascript/StorePreviewerHeader.js"></script>
		<script type="text/javascript">
			var dateTimeFormat = "yyyy/MM/dd HH:mm:ss";
			var UI_TIME_FORMAT_SEPARATOR = ":";
			var YEAR_DEFAULT_FOR_YY = "20";
			var clientTime = new Date();

			function format(date, fmt) {
				if (date && fmt) {
					var resultstr = fmt;
					if(resultstr.indexOf('yyyy') !== -1){
						resultstr = replace(resultstr, "yyyy", padleft(date.getFullYear(), "0", 4));
					}else{
						resultstr = replace(resultstr, "yy", padleft(date.getFullYear().toString().slice(2), "0", 2));
					}
					if(resultstr.indexOf('MM') !== -1){
						resultstr = replace(resultstr, "MM", padleft((date.getMonth()+1),"0",2));
					}else{
						resultstr = replace(resultstr, "M", date.getMonth()+1);
					}
					if(resultstr.indexOf('dd') !== -1){
						resultstr = replace(resultstr, "dd", padleft(date.getDate(),"0",2));
					}else{
						resultstr = replace(resultstr, "d", date.getDate());
					}

					resultstr = replace(resultstr, "HH", padleft(date.getHours(),"0",2));
					resultstr = replace(resultstr, "mm", padleft(date.getMinutes(),"0",2));
					resultstr = replace(resultstr, "ss", padleft(date.getSeconds(),"0",2));
					resultstr = replace(resultstr, "SSS", padleft(date.getMilliseconds(),"0",3));
					resultstr = replace(resultstr, "AM", padleft(date.getMilliseconds(),"0",3));


					return resultstr;
				}
				else {
					return "";
				}
			}

			function parse (str, fmt) {
				if (str) {
					//if (str.indexOf(" ") >= 0) return null;

					str = trim(str);
					var currentDate = new Date();

					var year = currentDate.getFullYear();
					var month = currentDate.getMonth();
					var day = currentDate.getDate();
					var hours = 0;
					var minutes = 0;
					var seconds = 0;
					var milliseconds = 0;
					var t;
					if(fmt.indexOf("dd") < 0){
						t = fmt.indexOf("d");
						if (t >= 0) {
							fmt = insertStringAt(fmt,'d',t);
							if(!isInteger(str.substr(t+1,1))){
								str = insertStringAt(str,'0',t);
							}
						}
					}
					if(fmt.indexOf("MM") < 0){
						t = fmt.indexOf("M");
						if (t >= 0) {
							fmt = insertStringAt(fmt,'M',t);
							if(!isInteger(str.substr(t+1,1))){
								str = insertStringAt(str,'0',t);
							}
						}
					}
					if(fmt.indexOf("yyyy") < 0){
						t = fmt.indexOf("yy");
						if (t >= 0) {
							fmt = insertStringAt(fmt,'yy',t);
							str = insertStringAt(str,YEAR_DEFAULT_FOR_YY,t); //always assume year 2000 plus
						}
					}


					var i;
					i = fmt.indexOf("yyyy");
					if (i >= 0) {
						year = Number(str.substr(i,4));
					}

					i = fmt.indexOf("MM");
					if (i >= 0) {
						month = Number(str.substr(i,2)) - 1;
					}

					i = fmt.indexOf("dd");
					if (i >= 0) {
						day = Number(str.substr(i,2));
					}

					i = fmt.indexOf("HH");
					if (i >= 0 && str.length > i) {
						hours = Number(str.substr(i,2));
					}

					i = fmt.indexOf("mm");
					if (i >= 0 && str.length > i) {
						minutes = Number(str.substr(i,2));
					}

					i = fmt.indexOf("ss");
					if (i >= 0 && str.length > i) {
						seconds = Number(str.substr(i,2));
					}

					i = fmt.indexOf("SSS");
					if (i >= 0 && str.length > i) {
						milliseconds = Number(str.substr(i,3));
					}


					// set year under 100 with Date's constructor will be added with 1900.
					// use setFullYear to avoid, also use set methods for others for consistency.
					var resultdate = new Date();
					resultdate.setDate(1);
					resultdate.setFullYear(year);
					resultdate.setMonth(month);
					resultdate.setDate(day);
					resultdate.setHours(hours);
					resultdate.setMinutes(minutes);
					resultdate.setSeconds(seconds);
					resultdate.setMilliseconds(milliseconds);
					// to ensure the original str is same as the result str
					if (resultdate.getTime()) {
						if (resultdate.getFullYear() != year || resultdate.getMonth() !=  month || resultdate.getDate() != day) {
							return null;
						}
						return resultdate;
					}
					else {
						return null;
					}
				}
				else {
					return null;
				}
			}

			function isInteger (s) {
				// s is an integer string if it is a number string that does not contain decimal point
				return s && s.indexOf('.') < 0 && isNumber(s);
			}

			function trim (s) {
				if (typeof(s) == "undefined" || s == null) {
					return s;
				}
				s = s.toString();
				while (s.length > 0 && s.substring(0, 1) == ' ') {
					s = s.substring(1, s.length);
				}

				while (s.length > 0 && s.substring(s.length - 1, s.length) == ' ') {
					s = s.substring(0, s.length - 1);
				}

				return s;
			}

			function insertStringAt (str, insertStr, index) {
				var str1 = str.slice(0,index);
				var str2 = str.slice(index,str.length);
				return str1 + insertStr + str2;
			}

			function getFormattedTime (date, sec, fmt) {
				if(date){
					if (!fmt) {
						fmt = "12HR";
					}
					if(fmt=="12HR"){
						return get12HourFormattedTime(date,sec);
					}else if(fmt=="24HR"){
						return get24HourFormattedTime(date,sec);
					}
				}
				return null;
			}

			function get24HourFormattedTime (date, sec) {
				if(sec){
					return [date.getHours(),
							UI_TIME_FORMAT_SEPARATOR,
							getFormattedMinutes(date.getMinutes()),
							UI_TIME_FORMAT_SEPARATOR,
							getFormattedMinutes(date.getSeconds())
						   ].join("");
				}else{
					return [date.getHours(),
							UI_TIME_FORMAT_SEPARATOR,
							getFormattedMinutes(date.getMinutes())
						   ].join("");
				}
			}

			function get12HourFormattedTime (date, sec) {
				if(sec){
					return [get12HourFormattedHours(date.getHours()),
							UI_TIME_FORMAT_SEPARATOR,
							getFormattedMinutes(date.getMinutes()),
							UI_TIME_FORMAT_SEPARATOR,
							getFormattedMinutes(date.getSeconds()),
							" ",
							get12HourFormattedAppendix(date.getHours())
						   ].join("");
				}else{
					return [get12HourFormattedHours(date.getHours()),
							UI_TIME_FORMAT_SEPARATOR,
							getFormattedMinutes(date.getMinutes()),
							" ",
							get12HourFormattedAppendix(date.getHours())
						   ].join("");
				}
			}

			function get12HourFormattedHours(hours) {
				var fHours = hours % 12;
				if(fHours == 0){
					fHours = 12;
				}
				var result = fHours < 10? [0, fHours].join("") : String(fHours);
				return result;
			}

			function getFormattedMinutes (minutes) {
				return minutes < 10 ? [0, minutes].join("") : String(minutes);
			}

			function get12HourFormattedAppendix (hours) {
				return hours > 11 ? "PM" : "AM";
			}

			function replace (s, r, n) {
				return s.split(r).join(n);
			}

			function padleft (s, c, stringlength) {
				var n = stringlength - s.toString().length;
				var padstr = "";
				for (var i = 0; i < n; i++) {
					padstr += c;
				}
				return padstr + s;
			}


			function setInnerText(obj, text){
				if(obj.innerText != undefined){
					obj.innerText = text;
				}else if(obj.textContent != undefined){
					obj.textContent = text;
				}
			}

			function displayTimeInfo() {
				var start = "<c:out value='${previewStartTime}'/>";
				var startTime = parse(start, dateTimeFormat);
				var clientDateFormat = "<c:out value='${clientDateFormat}'/>";
				var clientTimeFormat = "<c:out value='${clientTimeFormat}'/>";
				var formattedDate = format(startTime, clientDateFormat);
				var formattedTime = getFormattedTime(startTime, true, clientTimeFormat);
				setInnerText(document.getElementById("previewStartTime"), formattedDate + " " + formattedTime + " <%= timeZoneDisplayName %>");
			<c:if test="${param.status == false}">
				funClock();
			</c:if>
			}

			function funClock() {
				var start = "<c:out value='${previewTimestamp}'/>";
				var startTime = parse(start, dateTimeFormat);
				var elapsedTime = new Date();
				var clientDateFormat = "<c:out value='${clientDateFormat}'/>";
				var clientTimeFormat = "<c:out value='${clientTimeFormat}'/>";
				elapsedTime.setTime(startTime.getTime() + elapsedTime.getTime() - clientTime.getTime());
				var formattedDate = format(elapsedTime, clientDateFormat);
				var formattedTime = getFormattedTime(elapsedTime, true, clientTimeFormat);
				setInnerText(document.getElementById("previewTime"), formattedDate + " " + formattedTime + " <%= timeZoneDisplayName %>");
				setTimeout("funClock()", 1000)
			}



			/*
				START - KEY PRESS FUNCTION
			*/
			var clickedOnce = false;
			var spotsShown = false;
			var store=parent.frames[1];

			function isSpotsShown(){
				return spotsShown;
			}

			// outlines all the e-spots and content spots on the page
			function outlineSpots() {
				if (store != null) {
					with (store) {
						if($.isFunction(store['outlineSpots'])){
							store.outlineSpots();
						}else{
							$('.caption,.ESpotInfo').css('display','block');
							$('.genericESpot').css('border','2px dashed red');
							$('.genericCSpot').css('border','2px dashed blue');
							$('.searchResultSpot').css('border','2px dashed limegreen');
						}
					}
				}
			}

			function hideSpots() {
				if (store != null) {
					with (store) {
						if($.isFunction(store['hideSpots'])){
							store.hideSpots();
						}else{
							$('.caption,.ESpotInfo').css('display','none');
							$('.genericESpot,genericCSpot,searchResultSpot').css('border','0px solid white');
						}
					}
				}
			}


			function onUnLoadClearButton() {
				spotsShown = false;
				clickedOnce = false;
				setInnerText(document.getElementById('showSpots'), "<fmt:message key="storePreviewShowESpotsBtnText" bundle="${resources}" />");
				return true;
			}

			function showESpots() {
				if (clickedOnce == false) {
					// add an onunload function to the body frame to make sure the 'show marketing spots' button
					// is in sync with the page.
					clickedOnce = true;
					if (parent.frames[1] != null) {
						var obj2=parent.frames[1].document.getElementsByTagName('body')[0];
						obj2.onunload=onUnLoadClearButton;
					}
				}

				if (spotsShown == false) {
					setInnerText(document.getElementById('showSpots'), "<fmt:message key="storePreviewHideESpotsBtnText" bundle="${resources}" />");
					spotsShown = true;
					outlineSpots();
				} else {
					spotsShown = false;
					setInnerText(document.getElementById('showSpots'), "<fmt:message key="storePreviewShowESpotsBtnText" bundle="${resources}" />");
					hideSpots();
				}
			}

			function showLayoutInfoPopup() {
				if (store != null) {
					with (store) {
						if(!parent.checkPopupAllowed()){
							return;
						}
						if($.isFunction(store['showESpotInfoPopup'])){
							var quickInfo = $('#LayoutInfo_popup_Layout').data("wc-WCDialog");
							if (quickInfo) {
								store.showESpotInfoPopup('LayoutInfo_popup_Layout');
							} else {
								var storeFrame = parent.frames[1];
								if (storeFrame != null) {
									if (storeFrame.document.getElementById("pageNotLayoutManaged") != null) {
										storeFrame.document.getElementById("pageNotLayoutManaged").style.display = 'block';
									} else {
										var css = storeFrame.document.createElement("link");
										css.setAttribute("rel", "stylesheet");
										css.setAttribute("type", "text/css");
										css.setAttribute("href", "${env_imageContextPath}/tools/preview/css/store_preview.css");

										var node = storeFrame.document.createElement("div");
										node.id = "pageNotLayoutManaged";
										/* setAttribute('class'...) does not work in IE7 */
										node.className = "store_preview_dialog_window";
										node.innerHTML =
											"<div class='sp_header_top' style='width: 550px;'>" +
												"<div class='sp_header'>" +
													"<fmt:message key='layoutInfoDialogPageTitle' bundle='${resources}' />" +
													"<a id='closePageNotLayoutManaged' href='javascript:parent.frames[0].hideElementById(&#39pageNotLayoutManaged&#39)'>" +
													"<div class='sp_close'></div>" +
													"</a>" +
												"</div>" +
												"<div class='sp_whitespace_background' style='width: 532px;'>" +
													"<div class='sp_content_container'>" +
														"<div id='sp_summary' class='generateURLcontent'>" +
															"<fmt:message key='LayoutPageNotManagedByPageComposer' bundle='${resources}' /> " +
															"<div class='clear_float'></div>" +
														"</div>" +
														"<div class='clear_float'></div>" +
													"</div>" +
													"<div class='sp_optionsContainer'>" +
														"<div class='sp_rightContainer'>" +
															"<a id='sp_cancelPageNotLayoutManaged' class='sp_light_button'" +
															"onmouseup='parent.frames[0].buttonActiveOff(&#39cancelPageNotLayoutManagedLeft&#39,&#39cancelPageNotLayoutManagedRight&#39, 1)'" +
															"onmousedown='parent.frames[0].buttonActive(&#39cancelPageNotLayoutManagedLeft&#39,&#39cancelPageNotLayoutManagedRight&#39, 1)'" +
															"onmouseout='parent.frames[0].buttonHoverOff(&#39cancelPageNotLayoutManagedLeft&#39,&#39cancelPageNotLayoutManagedRight&#39, 1)'" +
															"onmouseover='parent.frames[0].buttonHover(&#39cancelPageNotLayoutManagedLeft&#39,&#39cancelPageNotLayoutManagedRight&#39, 1)'" +
												 			"href='javascript:parent.frames[0].hideElementById(&#39pageNotLayoutManaged&#39)'>" +
															"<div id='cancelPageNotLayoutManagedLeft' style='background-position: 0px 0px;' class='sp_button_text'><fmt:message key='storePreviewCancelBtnText' bundle='${resources}' /></div>" +
															"<div id='cancelPageNotLayoutManagedRight' style='background-position: 0px 0px;' class='sp_button_right'></div>" +
															"</a>" +
														"</div>" +
														"<div class='clear_float'></div>" +
													"</div>" +
													"<div class='clear_float'></div>" +
												"</div>" +
												"<div class='clear_float'></div>" +
											"</div>";
										storeFrame.document.getElementsByTagName('head')[0].appendChild(css);
										storeFrame.document.getElementsByTagName('body')[0].appendChild(node);
									}
									storeFrame.$("#closePageNotLayoutManaged").focus();
									storeFrame.scrollTo(0,0);
								}
							}
						}
					}
				}
			}

			/*
				END - KEY PRESS FUNCTION
			*/

			function hideDetails() {
				// If refresh button was clicked that caused the frame reloaded, do not hide details since details were shown when refresh was clicked
				if (!parent.refreshAction) {
					$("#detailsSection").css("display", "none");
					$(parent.document.body).removeClass("showDetails");
					setInnerText(document.getElementById('showHideButton'), "<fmt:message key="storePreviewShowDetailsBtnText" bundle="${resources}" />");
					document.getElementById('showHideLink').href="javascript:showDetails()";
					$("#showRefreshLink").css("visibility", "hidden");
				}
				else {
					parent.refreshAction = false;
				}
			}

			function showDetails() {
				$("#detailsSection").css("display", "block");
				$(parent.document.body).addClass("showDetails");
				setInnerText(document.getElementById('showHideButton'), "<fmt:message key="storePreviewHideDetailsBtnText" bundle="${resources}" />");
				document.getElementById('showHideLink').href="javascript:hideDetails()";
				$("#showRefreshLink").css("visibility", "visible");
			}

			function resetGenerateURLPopup() {
				var storeFrame = parent.frames[1];
				storeFrame.document.getElementById('genUrl_pword_value').value = '';
				storeFrame.document.getElementById('genUrl_lifespan_specify_days').value = '';
				storeFrame.document.getElementById('genUrl_lifespan_specify_hours').value = '1';
				storeFrame.document.getElementById('genUrl_pword_yes').checked = false;
				storeFrame.document.getElementById('genUrl_pword_value').disabled = true;
			}

			function hideGenerateURLResult(){
				var storeFrame = parent.frames[1];
				storeFrame.$('#generatedURLDialog').addClass('displayNone');
			}

			function displayGenerateURLResult(){
				var storeFrame = parent.frames[1];
				storeFrame.$('#generatedURLDialog').removeClass('displayNone');
			}

			function hideGenerateURLPopup(){
				var storeFrame = parent.frames[1];
				storeFrame.$('#generateURL').addClass('displayNone');
			}

			function displayGenerateURLPopup(){
				var storeFrame = parent.frames[1];
				storeFrame.$('#generateURL').removeClass('displayNone');
			}

			function showGenerateURLPopup() {
				var storeFrame = parent.frames[1];
				if (storeFrame != null) {
					if(!parent.checkPopupAllowed()){
						return;
					}
					if (storeFrame.document.getElementById("generateURL") != null) {
						if (storeFrame.document.getElementById("generatedURLDialog") != null) {
							if (storeFrame.$("#generatedURLDialog").css('display') === ('none')) {
								displayGenerateURLPopup();
								resetGenerateURLPopup();
							}
						}
						else {
							displayGenerateURLPopup();
							resetGenerateURLPopup();
						}
					}
					else {
						var css = storeFrame.document.createElement("link");
						css.setAttribute("rel", "stylesheet");
						css.setAttribute("type", "text/css");
						css.setAttribute("href", "${env_imageContextPath}/tools/preview/css/store_preview.css");

						var node = storeFrame.document.createElement("div");
						node.id = "generateURL";
						/* setAttribute('class'...) does not work in IE7 */
						node.className = "store_preview_dialog_window";
						node.innerHTML =
								"<div class='sp_header_top' style='width: 550px;'>" +
									"<div id='generateURL_SP_Header' class='sp_header'>" +
										"<fmt:message key='storePreviewGenerateURLDialogTitle' bundle='${resources}' />" +
										"<a id='closeGenerateURL' onkeypress='parent.frames[0].shiftTabToPopupClose(event)' href='javascript:parent.frames[0].hideGenerateURLPopup();'>" +
											"<div class='sp_close'>"+
											"<img src='${env_imageContextPath}/images/preview/storepreview_window_close_icon.png' alt=''/>" +
											"</div>" +
										"</a>" +
									"</div>" +
									"<div class='sp_whitespace_background' style='width: 532px;'>" +
										"<div class='sp_content_container'>" +
											"<div id='sp_summary' class='generateURLcontent'>" +
												"<fmt:message key='storePreviewDescription' bundle='${resources}' /> " +
												"<a href='http://pic.dhe.ibm.com/infocenter/wchelp/v7r0m0/index.jsp?topic=/com.ibm.commerce.management-center.doc/tasks/tpvgenerate.htm' target='_blank'><fmt:message key='storePreviewLearnMoreLink' bundle='${resources}' /></a>" +
												"<div class='clear_float'></div>" +
											"</div>" +
											"<div id='sp_timeLimit' class='generateURLcontent'>" +
												"<img src='<c:out value='${wcsstorePath}'/>/images/preview/extended_help.png' title=\"<fmt:message key='storePreviewGenerateURLActiveTimeTooltip' bundle='${resources}'/>\"/>" +
												"<div class='sp_timeLimitContainer'>" +
													"<fmt:message key='storePreviewGenerateURLActiveTimePrompt' bundle='${resources}' />" +
													"<br>" +
													"<div class='sp_days'>" +
														"<input type='text' id='genUrl_lifespan_specify_days' size='4'/>" +
														"<label for='genUrl_lifespan_specify_days'><fmt:message key='storePreviewDays' bundle='${resources}' /></label>" +
													"</div>" +
													"<div class='sp_hours'>" +
														"<input type='text' id='genUrl_lifespan_specify_hours' size='4' value='1'/>" +
														"<label for='genUrl_lifespan_specify_hours'><fmt:message key='storePreviewHours' bundle='${resources}' /></label>" +
													"</div>" +
													"<div class='clear_float'></div>" +
													"<div class='sp_errorMessageContainer' id='sp_errorLifespan_container' style='display:none;'>" +
														"<img src='<c:out value='${wcsstorePath}'/>/images/preview/error.png'/>" +
														"<span id='sp_errorLifespan' class='sp_red'></span>" +
													"</div>" +
													"<div class='clear_float'></div>" +
												"</div>" +
											"</div>" +
											"<div class='clear_float'></div>" +
											"<div id='sp_passwordURL' class='generateURLcontent'>" +
												"<img src='<c:out value='${wcsstorePath}'/>/images/preview/extended_help.png' title=\"<fmt:message key='storePreviewPasswordTooltip' bundle='${resources}'/>\"/>" +
												"<fmt:message key='storePreviewPasswordPrompt' bundle='${resources}' />" +
												"<br>" +
												"<div class='sp_passwordURLContainer'/>" +
													"<input type='checkbox' class='sp_checkbox' id='genUrl_pword_yes' value='pword_yes'></input>" +
													"<label for='genUrl_pword_yes'><fmt:message key='storePreviewPasswordYesText' bundle='${resources}' /><br><fmt:message key='storePreviewPasswordYesSubText' bundle='${resources}' /></label>" +
													"<br></br>" +
													"<div class='sp_password'>" +
														"<label for='genUrl_pword_value'><fmt:message key='storePreviewPassword' bundle='${resources}' /></label>" +
														"<br>" +
														"<input type='text' id='genUrl_pword_value' disabled/>" +
													"</div>" +
													"<div class='sp_errorMessageContainer' id='sp_errorPassword_container' style='display:none;'>" +
														"<img src='<c:out value='${wcsstorePath}'/>/images/preview/error.png'/>" +
														"<span id='sp_errorPassword' class='sp_red'></span>" +
													"</div>" +
												"</div>" +
											"</div>" +
										"</div>" +
										"<div class='sp_optionsContainer'>" +
											"<div class='sp_rightContainer'>" +
												"<a id='sp_confirmGenerateURL' class='sp_light_button'" +
													"onmouseup='parent.frames[0].buttonActiveOff(&#39confirmGenerateURLLeft&#39,&#39confirmGenerateURLRight&#39, 1)'" +
													"onmousedown='parent.frames[0].buttonActive(&#39confirmGenerateURLLeft&#39,&#39confirmGenerateURLRight&#39, 1)'" +
													"onmouseout='parent.frames[0].buttonHoverOff(&#39confirmGenerateURLLeft&#39,&#39confirmGenerateURLRight&#39, 1)'" +
													"onmouseover='parent.frames[0].buttonHover(&#39confirmGenerateURLLeft&#39,&#39confirmGenerateURLRight&#39, 1)'" +
													"href='javascript:parent.frames[0].generateURL()'>" +
													"<div id='confirmGenerateURLLeft' style='background-position: 0px 0px;' class='sp_button_text'><fmt:message key='storePreviewGenerateURLBtnText' bundle='${resources}' /></div>" +
													"<div id='confirmGenerateURLRight' style='background-position: 0px 0px;' class='sp_button_right'></div>" +
												"</a>" +
												"<a id='sp_cancelGenerateURL' class='sp_light_button'" +
													"onmouseup='parent.frames[0].buttonActiveOff(&#39cancelGeneratedURLLeft&#39,&#39cancelGeneratedURLRight&#39, 1)'" +
													"onmousedown='parent.frames[0].buttonActive(&#39cancelGeneratedURLLeft&#39,&#39cancelGeneratedURLRight&#39, 1)'" +
													"onmouseout='parent.frames[0].buttonHoverOff(&#39cancelGeneratedURLLeft&#39,&#39cancelGeneratedURLRight&#39, 1)'" +
													"onmouseover='parent.frames[0].buttonHover(&#39cancelGeneratedURLLeft&#39,&#39cancelGeneratedURLRight&#39, 1)'" +
													"onkeypress='parent.frames[0].tabToPopupClose(event)'" +
												 	"href='javascript:parent.frames[0].hideGenerateURLPopup()'>" +
													"<div id='cancelGeneratedURLLeft' style='background-position: 0px 0px;' class='sp_button_text'><fmt:message key='storePreviewCancelBtnText' bundle='${resources}' /></div>" +
													"<div id='cancelGeneratedURLRight' style='background-position: 0px 0px;' class='sp_button_right'></div>" +
												"</a>" +
											"</div>" +
											"<div class='clear_float'></div>" +
										"</div>" +
										"<div class='clear_float'></div>" +
									"</div>" +
									"<div class='clear_float'></div>" +
								"</div>";
						storeFrame.document.getElementsByTagName('head')[0].appendChild(css);
						storeFrame.document.getElementsByTagName('body')[0].appendChild(node);
						/* Assigning the method to onclick in the HTML does not work on IE7 */
						storeFrame.document.getElementById("genUrl_pword_yes").onclick = function() {parent.frames[0].toggleInputField("genUrl_pword_value");};
					}
					storeFrame.document.getElementById('closeGenerateURL').focus();
					storeFrame.scrollTo(0,0);
				}
			}

			function resetStackOrder(topItem, bottomItem){
				var storeFrame = parent.frames[1];
				var topItemWindow = storeFrame.document.getElementById(topItem);
				var bottomItemWindow = storeFrame.document.getElementById(bottomItem);
				if (storeFrame != null && topItemWindow != null && bottomItemWindow != null){

					bottomItemWindow.style.zIndex = 1000;
					topItemWindow.style.zIndex = 1001;

				}
			}

			function showGeneratedURLPopup(generatedURLData) {
				var storeFrame = parent.frames[1];
				if (storeFrame != null) {
					if (storeFrame.document.getElementById("generatedURLDialog") != null) {
						displayGenerateURLResult();
						var currentURL = parent.frames[1].location;
						var generatedURL = currentURL.protocol + "//" + currentURL.host + currentURL.pathname + currentURL.search + (currentURL.search == "" ? "?" : "&") + "newPreviewSession=true&previewToken=" + encodeURIComponent(generatedURLData.previewToken) + currentURL.hash;
						var qrImg = null;
						try {
							var qr = qrcode(10, "L");
							qr.addData(generatedURL);
							qr.make();
							qrImg = qr.createImgTag();
						}
						catch (e) {
							qrImg = null;
						}
						storeFrame.document.getElementById("generatedURL").value = generatedURL;
						storeFrame.document.getElementById("qrImg").innerHTML = qrImg;
					}
					else {
						var currentURL = parent.frames[1].location;
						var generatedURL = currentURL.protocol + "//" + currentURL.host + currentURL.pathname + currentURL.search + (currentURL.search == "" ? "?" : "&") + "newPreviewSession=true&previewToken=" + encodeURIComponent(generatedURLData.previewToken) + currentURL.hash;
						var qrImg = null;
						try {
							var qr = qrcode(10, "L");
							qr.addData(generatedURL);
							qr.make();
							qrImg = qr.createImgTag();
						}
						catch (e) {
							qrImg = null;
						}

						var node = storeFrame.document.createElement("div");
						node.id = "generatedURLDialog";
						node.className = "store_preview_dialog_window";
						node.innerHTML =
								"<div class='sp_header_top' style='width: 550px;'>" +
									"<div class='sp_header'>" +
										"<fmt:message key='storePreviewGenerateURLDialogTitle' bundle='${resources}' />" +
										"<a id='closeGeneratedURL' href='javascript:parent.frames[0].displayGenerateURLResult();'>" +
											"<div class='sp_close'></div>" +
										"</a>" +
									"</div>" +
									"<div class='sp_whitespace_background' style='width:532px;'>" +
										"<div class='sp_content_container'>" +
											"<fmt:message key='storePreviewGeneratedURLPrompt' bundle='${resources}' />" +
											"<br>" +
											"<input type='text' id='generatedURL' readonly value='" + generatedURL + "' style='width:500px;'></input>" +
											"<br>" +
											(qrImg ? "<br><fmt:message key='storePreviewQRCodePrompt' bundle='${resources}' /><br><div id='qrImg'>" + qrImg + "</div><br>" : "") +
											"<div class='sp_errorMessageContainer' id='sp_error_url_container' style='display:none;'>" +
												"<img src='<c:out value='${wcsstorePath}'/>/images/preview/error.png'/>" +
												"<span id='sp_error_url' class='sp_red'></span>" +
											"</div>" +
										"</div>" +
										"<div class='sp_optionsContainer'>" +
											"<div class='sp_rightContainer'>" +
												"<a id='closeGeneratedURL2' class='sp_light_button'" +
													"onmouseup='parent.frames[0].buttonActiveOff(&#39closeGeneratedURLButtonLeft&#39,&#39closeGeneratedURLButtonRight&#39, 1)'" +
													"onmousedown='parent.frames[0].buttonActive(&#39closeGeneratedURLButtonLeft&#39,&#39closeGeneratedURLButtonRight&#39, 1)'" +
													"onmouseout='parent.frames[0].buttonHoverOff(&#39closeGeneratedURLButtonLeft&#39,&#39closeGeneratedURLButtonRight&#39, 1)'" +
													"onmouseover='parent.frames[0].buttonHover(&#39closeGeneratedURLButtonLeft&#39,&#39closeGeneratedURLButtonRight&#39, 1)'" +
													"href='javascript:parent.frames[0].hideGenerateURLResult()'>" +
													"<div id='closeGeneratedURLButtonLeft' style='background-position: 0px 0px;' class='sp_button_text'><fmt:message key='storePreviewCloseBtnText' bundle='${resources}' /></div>" +
													"<div id='closeGeneratedURLButtonRight' style='background-position: 0px 0px;' class='sp_button_right'></div>" +
												"</a>" +
											"</div>" +
											"<div class='clear_float'></div>" +
										"</div>" +
										"<div class='clear_float'></div>" +
									"</div>" +
									"<div class='clear_float'></div>" +
								"</div>";
						storeFrame.document.getElementsByTagName('body')[0].appendChild(node);
						if (encodeURIComponent(generatedURLData.previewToken) == 'undefined') {
							storeFrame.document.getElementById('generatedURL').value = "";
							storeFrame.document.getElementById('sp_error_url_container').style.display = 'block';
							if (generatedURLData.systemMessage) {
								storeFrame.document.getElementById('sp_error_url').innerHTML = generatedURLData.systemMessage;
							}
							else {
								storeFrame.document.getElementById('sp_error_url').innerHTML = generatedURLData.errorMessage;
							}
						}

					}
					storeFrame.document.getElementById('generatedURL').focus();
					storeFrame.document.getElementById("generatedURL").select();
				}
			}

			function clearErrors() {
				var storeFrame = parent.frames[1];
				storeFrame.document.getElementById('sp_errorLifespan_container').style.display='none';
				storeFrame.document.getElementById('sp_errorPassword_container').style.display='none';
				storeFrame.document.getElementById('sp_errorLifespan').innerHTML = '';
				storeFrame.document.getElementById('sp_errorPassword').innerHTML = '';
			}

			/**
			* This function will check if the number of bytes of the string
			* is within the maxlength specified.
			*
			* Copied from MessageHelper.js
			*
			* @param (string) UTF16String the UTF-16 string
			* @param (int) maxlength the maximum number of bytes allowed in your input
			*
			* @return (boolean) false is this input string is larger than maxlength
			*/
			function isValidUTF8length(UTF16String, maxlength) {
				if (this.utf8StringByteLength(UTF16String) > maxlength) return false;
				else return true;
			}

			/**
			* This function will count the number of bytes represented in a UTF-8
			* string.
			*
			* Copied from MessageHelper.js
			*
			* @param (string) UTF16String the UTF-16 string you want a byte count of
			* @return (int) the integer number of bytes represented in a UTF-8 string
			*/
			function utf8StringByteLength(UTF16String) {

				if (UTF16String === null) return 0;

				var str = String(UTF16String);
				var oneByteMax = 0x007F;
				var twoByteMax = 0x07FF;
				var byteSize = str.length;

				for (i = 0; i < str.length; i++) {
					chr = str.charCodeAt(i);
					if (chr > oneByteMax) byteSize = byteSize + 1;
					if (chr > twoByteMax) byteSize = byteSize + 1;
				}
				return byteSize;
			}

			function validate() {
				var storeFrame = parent.frames[1];
				var pword = storeFrame.document.getElementById('genUrl_pword_value').value;
				var days = storeFrame.document.getElementById('genUrl_lifespan_specify_days').value;
				var hours = storeFrame.document.getElementById('genUrl_lifespan_specify_hours').value;
				var lifespan_result = false;
				var password_result = false;

				clearErrors();

				days = (days == '' ? 0 : days);
				hours = (hours == '' ? 0 : hours);
				lifespan_result = !(isNaN(days) || isNaN(hours)) && (days >= 0 && parseInt(days) == days) && (hours >= 0 && parseInt(hours) == hours);

				if (lifespan_result == false) {
					storeFrame.document.getElementById('sp_errorLifespan_container').style.display = 'block';
					storeFrame.document.getElementById('sp_errorLifespan').innerHTML = "<fmt:message key='storePreviewSpecifyDurationError' bundle='${resources}' />";
				}
				if (storeFrame.document.getElementById('genUrl_pword_yes').checked) {
					if (pword == '') {
						storeFrame.document.getElementById('sp_errorPassword_container').style.display = 'block';
						storeFrame.document.getElementById('sp_errorPassword').innerHTML = "<fmt:message key='storePreviewPasswordMissingError' bundle='${resources}' />";
					}
					else if (!isValidUTF8length(pword, 256)) {
						storeFrame.document.getElementById('sp_errorPassword_container').style.display = 'block';
						storeFrame.document.getElementById('sp_errorPassword').innerHTML = "<fmt:message key='storePreviewPasswordLongError' bundle='${resources}' />";
					}
					else {
						password_result = true;
					}
				}
				else {
					password_result = true;
				}
				return lifespan_result && password_result;
			}



			function generateURL() {
				var storeFrame = parent.frames[1];
				var days = storeFrame.document.getElementById('genUrl_lifespan_specify_days').value;
				var hours = storeFrame.document.getElementById('genUrl_lifespan_specify_hours').value;
				days = (days == '' ? 0 : days);
				hours = (hours == '' ? 0 : hours);
				var pword = storeFrame.document.getElementById('genUrl_pword_value').value;
				var token_life = ((((Number(days) * 24) + Number(hours)) * 60) > 0) ? ((Number(days) * 24) + Number(hours)) * 60 : null;

				var forms = storeFrame.document.getElementsByTagName('form');
				var storeIdFound = false;
				var storeFrameStoreId = null;
				for (var i = 0; i < forms.length && !storeIdFound; i++) {
					var elements = forms[i].elements;
					for (var j = 0; j < elements.length && !storeIdFound; j++) {
						if (elements[j].type == 'hidden' && elements[j].name == 'storeId') {
							storeFrameStoreId = elements[j].value;
							storeIdFound = true;
						}
					}
				}
				if (true == validate()) {
					$.ajax({
						url: "RedirectView",
                        			method:"POST",
						data: {
							storeId: storeFrameStoreId != null ? storeFrameStoreId : "<%= storeId %>",
							<c:if test="${!empty param.start}">start: "<c:out value='${param.start}'/>",</c:if>
							timeZoneId: "<c:out value='${param.timeZoneId}'/>",
							status: "<c:out value='${param.status}'/>",
							invstatus: "<c:out value='${param.invstatus}'/>",
							<c:if test="${!empty param.includedMemberGroupIds}">includedMemberGroupIds: "<c:out value='${param.includedMemberGroupIds}'/>",</c:if>
							<c:if test="${workspaceId != null && !empty workspaceId}">workspaceId: "<c:out value='${workspaceId}'/>",</c:if>
							tokenLife: token_life,
							password: pword,
							URL: "PreviewTokenCreateURLView"
						},
						success: function(url) {
							$.ajax({
								url: url,
								crossDomain : true,
                                				dataType: 'jsonp',
								success: function(data) {
									hideGenerateURLPopup();
									showGeneratedURLPopup(data);
								}
							});
						}
					});
				}
			}

			function toggleInputField(fieldID) {
				var storeFrame = parent.frames[1];
				if (storeFrame.document.getElementById(fieldID).disabled) {
					storeFrame.document.getElementById(fieldID).disabled = false;
				}
				else {
					storeFrame.document.getElementById(fieldID).value = '';
					storeFrame.document.getElementById(fieldID).disabled = true;
				}
			}

			function hideElementById(elementId){
				var storeFrame = parent.frames[1];
				storeFrame.document.getElementById(elementId).style.display = "none";
			}

			// Below is from MDS
			function buttonHover(ele, ele2, frame) {
				var srcElement = parent.frames[frame].document.getElementById(ele);
				var srcElement2 = parent.frames[frame].document.getElementById(ele2);
				srcElement.style.backgroundPosition = '0 -21px';
				srcElement2.style.backgroundPosition = '-7px 0';
			}
			function buttonHoverOff(ele, ele2, frame) {
				var srcElement = parent.frames[frame].document.getElementById(ele);
				var srcElement2 = parent.frames[frame].document.getElementById(ele2);
				srcElement.style.backgroundPosition = '0 0';
				srcElement2.style.backgroundPosition = '0 0';
			}
			function buttonActive(ele, ele2, frame) {
				var srcElement = parent.frames[frame].document.getElementById(ele);
				var srcElement2 = parent.frames[frame].document.getElementById(ele2);
				srcElement.style.backgroundPosition = '0 -42px';
				srcElement2.style.backgroundPosition = '-14px 0';
			}
			function buttonActiveOff(ele, ele2, frame) {
				var srcElement = parent.frames[frame].document.getElementById(ele);
				var srcElement2 = parent.frames[frame].document.getElementById(ele2);
				srcElement.style.backgroundPosition = '0 0';
				srcElement2.style.backgroundPosition = '0 0';
			}
			function tabToPopupClose(e) {
				var srcElementHeader = parent.frames[1].document.getElementById("generateURL_SP_Header");
				var srcElementGenerate = parent.frames[1].document.getElementById("confirmGenerateURLRight");
				var keyCode = e.keyCode;
				if (e.shiftKey && keyCode == 9) {
					srcElementGenerate.tabIndex = "0";
					srcElementGenerate.focus();
					srcElementGenerate.tabIndex = "-1";
				}else if(keyCode == 9) {
					srcElementHeader.tabIndex = "0";
					srcElementHeader.focus();
					srcElementHeader.tabIndex = "-1";
				}
			}
			function shiftTabToPopupClose(e) {
				var srcElement = parent.frames[1].document.getElementById("cancelGeneratedURLRight");
				var keyCode = e.keyCode;
				if (e.shiftKey && keyCode == 9) {
					srcElement.tabIndex = "0";
					srcElement.focus();
					srcElement.tabIndex = "-1";
				}
			}

		</script>

		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><fmt:message key="storePreviewHeaderFrameTitle" bundle="${resources}" /></title>
		<style type="text/css">
			body {
				padding: 0px;
				margin: 0px;
				background: none repeat scroll 0 0 #EEEEEE;
				color: #4D4D4D;
				height: 100%;
				line-height: 1.4em;
				width: 100%;
			}
			a {
				text-decoration:none;
			}
			.store_preview {
				color: #2C2C2C;
				font-family: Verdana, Arial, Helvetica, sans-serif;
				font-size: 11px;
				width:100%;
				position:relative;
			}

			.store_preview > .header {
				background: url("${env_imageContextPath}/images/preview/header_background_tile.png") repeat-x;
				height: 28px;
				padding-top: 3px;
				width: 100%;
			}

			.store_preview  .title {
				float: left;
				font-size: 14px;
				padding: 4px 11px 0 10px;
			}

			.store_preview > .details {
				padding: 4px 8px;
				background-color: #FFFFFF;
			}

			.store_preview > .details > .line {
				background-color: #FFFFFF;
				border-top: 1px solid #e6e6e6;
			}

			.store_preview .content {
				padding-left: 3px;
				font-size: 12px;
				color: #666666;
				border-bottom: 1px solid #e6e6e6;
				height:100px;
			}

			.store_preview .highlight {
				color: #343434;
			}

			a.light_button {
				color: #27629C;
				cursor: pointer;
				display: -moz-inline-box;
				display: inline-block;
				height: 17px;
				padding: 2px;
			}

			a.light_button  div.button_text{
				background: url("${env_imageContextPath}/images/preview/b_main_bg.png") repeat-x scroll left top transparent;
				float: left;
				height: 17px;
				padding: 1px 2px 2px 9px;
				line-height: 17px;
				font-size: 11px;
			}

			a.light_button div.button_right {
				background: url("${env_imageContextPath}/images/preview/b_right.png") no-repeat scroll 0 0 transparent;
				float: left;
				height: 20px;
				width: 6px;
			}

			#showRefreshLink {
				margin-left: -3px;
			}

			.store_preview > .buttonSection {
				padding: 4px 8px;
				background-color: #FFF;
				height: 24px;
			}
			#sizeDropdown {
				vertical-align: 4px;
			}
		</style>
	</head>

	<body onload="displayTimeInfo(); hideDetails()">
		<div class="store_preview">
		     <div class="header"> <span class="title"><fmt:message key="storePreviewHeading" bundle="${resources}" /></span></div>
		     <div class="details">
		     	<div class="line"></div>
				<div class="content" id="detailsSection">
               		<span class="highlight"><fmt:message key="storePreviewStartTimeMsg" bundle="${resources}" /></span> <span id="previewStartTime"></span>
               		<br/>
               		<c:choose>
						<c:when test="${param.status == true}">
							<span class="highlight"><fmt:message key="storePreviewTimeStatus" bundle="${resources}" /></span> <fmt:message key="storePreviewTimeStatusStatic" bundle="${resources}" />
						</c:when>
						<c:otherwise>
               				<span class="highlight"><fmt:message key="storePreviewTimeStatus" bundle="${resources}" /></span> <fmt:message key="storePreviewTimeStatusRolling" bundle="${resources}" />&nbsp;-&nbsp;<span id="previewTime"></span>
						</c:otherwise>
					</c:choose>
                    <br/>
                    <c:if test="${!empty param.includedMemberGroupIds}">
                    	<span class="highlight"><fmt:message key="storePreviewCustomerSegments" bundle="${resources}" /></span>&nbsp;<%= mbrGroupIncludedNames %>
		    		</c:if>
		    		<c:if test="${!empty indexMsg}">
			    		<span class="highlight">
				    			<c:out value="${indexMsg}"/>
			    		</span>
		    		</c:if>
					<br/>
					<a class="light_button" href="#" onclick="parent.refreshAction = true;window.location.reload();" id="showRefreshLink"
						onmouseup="buttonActiveOff('showRefreshButton','showRefreshButtonRight', 0)"
						onmousedown="buttonActive('showRefreshButton','showRefreshButtonRight', 0)"
						onmouseout="buttonHoverOff('showRefreshButton','showRefreshButtonRight', 0)"
						onmouseover="buttonHover('showRefreshButton','showRefreshButtonRight', 0)">
						<div id="showRefreshButton" style='background-position: 0px 0px;' class="button_text"><fmt:message key="storePreviewRefreshStatusBtnText" bundle="${resources}" /></div>
						<div id="showRefreshButtonRight" style='background-position: 0px 0px;' class="button_right"></div>
					</a>
				</div>
			</div>
		    <div class="buttonSection" id="buttonSection">
				<a class="light_button" href="javascript:hideDetails();" id="showHideLink"
					onmouseup="buttonActiveOff('showHideButton','showHideButtonRight', 0)"
					onmousedown="buttonActive('showHideButton','showHideButtonRight', 0)"
					onmouseout="buttonHoverOff('showHideButton','showHideButtonRight', 0)"
					onmouseover="buttonHover('showHideButton','showHideButtonRight', 0)">
						<div id="showHideButton" style='background-position: 0px 0px;' class="button_text"><fmt:message key="storePreviewHideDetailsBtnText" bundle="${resources}" /></div>
						<div id="showHideButtonRight" style='background-position: 0px 0px;' class="button_right"></div>
				</a>
				<a class="light_button" href="javascript:showESpots();"
					onmouseup="buttonActiveOff('showSpots','showSpotsRight', 0)"
					onmousedown="buttonActive('showSpots','showSpotsRight', 0)"
					onmouseout="buttonHoverOff('showSpots','showSpotsRight', 0)"
					onmouseover="buttonHover('showSpots','showSpotsRight', 0)">
           				<div id="showSpots" style='background-position: 0px 0px;' class="button_text"><fmt:message key="storePreviewShowESpotsBtnText" bundle="${resources}" /></div>
           				<div id="showSpotsRight" style='background-position: 0px 0px;' class="button_right"></div>
				</a>
				<a class="light_button" href="javaScript:showGenerateURLPopup();"
					onmouseup="buttonActiveOff('showGenerateURL','showGenerateURLRight', 0)"
					onmousedown="buttonActive('showGenerateURL','showGenerateURLRight', 0)"
					onmouseout="buttonHoverOff('showGenerateURL','showGenerateURLRight', 0)"
					onmouseover="buttonHover('showGenerateURL','showGenerateURLRight', 0)">
           				<div id="showGenerateURL" style='background-position: 0px 0px;' class="button_text"><fmt:message key="storePreviewGenerateURLBtnText" bundle="${resources}" /></div>
           				<div id="showGenerateURLRight" style='background-position: 0px 0px;' class="button_right"></div>
				</a>
				<flow:ifEnabled feature="UseCommerceComposer">
					<a class="light_button" href="javaScript:showLayoutInfoPopup();"
						onmouseup="buttonActiveOff('showLayoutInfo','showLayoutInfoRight', 0)"
						onmousedown="buttonActive('showLayoutInfo','showLayoutInfoRight', 0)"
						onmouseout="buttonHoverOff('showLayoutInfo','showLayoutInfoRight', 0)"
						onmouseover="buttonHover('showLayoutInfo','showLayoutInfoRight', 0)">
	           				<div id="showLayoutInfo" style='background-position: 0px 0px;' class="button_text"><fmt:message key="storePreviewShowLayoutInformationBtnText" bundle="${resources}" /></div>
	           				<div id="showLayoutInfoRight" style='background-position: 0px 0px;' class="button_right"></div>
					</a>
				</flow:ifEnabled>

				<select id="sizeDropdown">
					<option value="fit" selected="selected"><fmt:message key="storePreviewStretchToFitOptionText" bundle="${resources}"/></option>
					<option value="320x480">320x480</option>
					<option value="320x568">320x568</option>
					<option value="360x640">360x640</option>
					<option value="384x640">384x640</option>
					<option value="600x960">600x960</option>
					<option value="600x1024">600x1024</option>
					<option value="768x1024">768x1024</option>
					<option value="800x1280">800x1280</option>
					<option value="1920x1080">1920x1080</option>
				</select>
				<a id="rotateButton" class="light_button" href="#"
					onmouseup="buttonActiveOff('rotate','rotateRight',0)"
					onmousedown="buttonActive('rotate','rotateRight',0)"
					onmouseout="buttonHoverOff('rotate','rotateRight',0)"
					onmouseover="buttonHover('rotate','rotateRight',0)">
					<div id="rotate" style="background-position:0 0" class="button_text"><fmt:message key="storePreviewRotateButtonText" bundle="${resources}"/></div>
					<div id="rotateRight" style="background-position:0 0" class="button_right"></div>
				</a>
		     </div>
		</div>
	</body>
</html>

</c:if>
