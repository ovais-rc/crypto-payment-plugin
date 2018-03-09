<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <html xmlns="http://www.w3.org/1999/xhtml">
 <head>


<!-- Generic JSP for all components -->

<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utils.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.*" %>

<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="com.ibm.commerce.tools.epromotion.databeans.PromotionListBean" %>

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@include file="epromotionCommon.jsp" %>

<!-- Get user bean -->
<%
	StringBuffer checkBoxNamesDet = new StringBuffer("");
    try{
         CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
         Locale jLocale = cmdContext.getLocale();
         String dupMsg = request.getParameter("DuplicateMsg");
	   if (dupMsg != null)
	   {	
		if (dupMsg.trim().equals("rlPromotionDuplicateName"))
		{
%>
		<script language="JavaScript"> 
		if(top.get("clickedDuplicate", false))
		{
			top.remove("clickedDuplicate");			
			parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rlPromotionDuplicateName"))%>');
		}	
		
</script>
<%
		}
		else
		if (dupMsg.trim().equals("rlPromotionDeletedDuplicateName"))
		{
%>
		<script language="JavaScript"> 
		if(top.get("clickedDuplicate", false))
		{
			top.remove("clickedDuplicate");			
			parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rlPromotionDeletedDuplicateName"))%>');
		}	
		
</script>
<%
		}
	   }
         int startIndex = Integer.parseInt(request.getParameter("startindex"));
         int listSize = Integer.parseInt(request.getParameter("listsize"));
         int endIndex = startIndex + listSize;
         
         String xmlfile = request.getParameter("ActionXMLFile");
         Hashtable actionXML = (Hashtable)ResourceDirectory.lookup(xmlfile); 
	   	 Hashtable action = (Hashtable)actionXML.get("action");
	   	 String state = request.getParameter("state");
	   	 String resourcefile = (String)action.get("resourceBundle");
         String beanClass;
         beanClass = RLConstants.RLPROMOTION_LIST_ALL;
         Class clazz = Class.forName(beanClass);
	  	 
	  	 PromotionListBean simpleList = new PromotionListBean();
         
         Hashtable NLSfile = (Hashtable) ResourceDirectory.lookup(resourcefile, jLocale); 
         String jStoreID = cmdContext.getStoreId().toString();
         String jLanguageID = cmdContext.getLanguageId().toString();

		 if(state.equals("ProductLevel"))
		  	 {
			 	simpleList.setParm("groupName",RLConstants.RLPROMOTION_PRODUCT_GROUP);
		  	 }
		 else if(state.equals("OrderLevel"))
		  	 {
			 	simpleList.setParm("groupName",RLConstants.RLPROMOTION_ORDER_GROUP);
			 }		  	 
		 else if(state.equals("ShippingLevel"))
		  	 {
			 	simpleList.setParm("groupName",RLConstants.RLPROMOTION_SHIPPING_GROUP);
			 }
		 else if(state.equals("AllList"))
		  	 {
			 	simpleList.setParm("groupName","allList");
			 }

         simpleList.setParm("storeID",jStoreID);
         simpleList.setParm("languageID",jLanguageID);
         simpleList.setParm("filterCMCPromotions","true");

         Hashtable parms = (Hashtable)action.get("parameter");
         for (Enumeration p=parms.keys(); p.hasMoreElements();) {
             String para = (String)p.nextElement();
             String tmpValue = request.getParameter(para);
             if(tmpValue !=null )
             {
                simpleList.setParm(para,tmpValue);
             }
         }
	 
         simpleList.setParm("startindex", ""+ startIndex);         
         simpleList.setParm("endindex", ""+ endIndex);
         
         com.ibm.commerce.beans.DataBeanManager.activate(simpleList, request);
%>
         <!-- user javascript function include here -->
<%
         Vector jsFiles = Util.convertToVector(action.get("jsFile"));
         if (jsFiles != null)
	   {
		// loop over all jsFiles
		for (Enumeration jsFile = jsFiles.elements(); jsFile.hasMoreElements();)
		{
			Hashtable javaScriptFile = (Hashtable) jsFile.nextElement();

			// get src for jsFile
			String jsSRC = (String) javaScriptFile.get("src");
			if (jsSRC != null)
			{
%>
           <script src="<%= jsSRC %>">
</script>
<script language="JavaScript"> 
	var PromotionStoreTypeMap = top.get("promoStoreTypeMap");
	function getPromotionStoreTypeFromTop() {
		if (PromotionStoreTypeMap != null) {
			return PromotionStoreTypeMap;
		} else {
			return new Object();
		}
	}
	function setPromotionStoreTypeToTop(id){
		if (PromotionStoreTypeMap == null) {
			PromotionStoreTypeMap = new Object();
		}
		var formName= '<%=(String)action.get("formName")%>';
		PromotionStoreTypeMap["ST"+id]=eval(formName + ".ST" + id +".value");
		PromotionStoreTypeMap["PN"+id]=eval(formName + ".PN" + id +".value");
 	        top.put("promoStoreTypeMap", PromotionStoreTypeMap);
 	}
			
</script>
<%
			}
		}
         }
%>
           <%= fHeader %>
           <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
<%
         Hashtable scrollcontrol = (Hashtable) action.get("scrollcontrol");
	   if (scrollcontrol != null){
	       String title = (String) scrollcontrol.get("title");
%>
           <title><%= UIUtil.toHTML((String)NLSfile.get(title)) %></title>
<%
	   }
%>
           <script language="JavaScript">

			function promotionModify()
			{
				if (arguments.length > 0)
				{
					var selectedPromo = arguments[0];
					var formName= '<%=(String)action.get("formName")%>';
					var storeTypeField = "ST"+selectedPromo;
					var storeTypeVal = eval(formName + "." + 	storeTypeField+".value");
					if(storeTypeVal == 1)
					{
						parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDenyModification"))%>');
					}
					else
					{
						var promoCode = -1;
						if (arguments.length > 0)
						{
						promoCode = arguments[0];
						}
						if (promoCode != -1)
						{
							var url = "<%= UIUtil.getWebappPath(request) %>NotebookView?XMLFile=RLPromotion.RLPromotionNotebook&calcodeId=" + promoCode;
							top.setContent("<%= UIUtil.toJavaScript((String)NLSfile.get("modifyDiscount")) %>", url, true);
						}
					}
				}
			}
			
			function showPreview ()
			{
				var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=preview.PreviewDialog";
				top.setContent("<%= UIUtil.toJavaScript((String)RLPromotionNLS.get("preview")) %>", url, true);
			}

			function getListTitle () {
				return "<%= UIUtil.toJavaScript((String)RLPromotionNLS.get("RLPromotionListTitle")) %>";
			}
           
           function create() {
			top.remove("chosenBranch");
			top.remove("lastCatentType");
           	top.setContent('<%= UIUtil.toJavaScript((String)NLSfile.get("createDiscount")) %>','/webapp/wcs/tools/servlet/WizardView?XMLFile=RLPromotion.RLPromotionWizard',true);
           }

           function modify()
		   {
			var relatedPromoNames = getRelatedStorePromos();
			var originalCalcIDs = getOriginalCalcIDs();
			if(relatedPromoNames != '')
			{
				parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDenyModification"))%>');
			}
	        if(originalCalcIDs != '')
			{
				top.setContent('<%= UIUtil.toJavaScript((String)NLSfile.get("modifyDiscount")) %>','/webapp/wcs/tools/servlet/NotebookView?XMLFile=RLPromotion.RLPromotionNotebook&amp;calcodeId=' + originalCalcIDs,true); 
			}
           }
           function publish()
		   {
			var relatedPromoNames = getRelatedStorePromos();
			var originalCalcIDs = getOriginalCalcIDs();
			if(relatedPromoNames != '')
			{
				parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDenyPublication"))%>'+relatedPromoNames);
			}
	        if(originalCalcIDs != '')
			{
				top.showContent('/webapp/wcs/tools/servlet/RLPromotionPublish?calcodeId=' + originalCalcIDs + '&amp;RLPromotionDisplayLevel=2' + '&amp;status=1&amp;state=<%=UIUtil.toJavaScript(state)%>');
			}
           }
           function unpublish()
		   {
			var relatedPromoNames = getRelatedStorePromos();
			var originalCalcIDs = getOriginalCalcIDs();
			if(relatedPromoNames != '')
			{
				parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDenyUnPublication"))%>'+relatedPromoNames);
			}           
	        if(originalCalcIDs != '')
			{
				top.showContent('/webapp/wcs/tools/servlet/RLPromotionPublish?calcodeId=' + originalCalcIDs + '&amp;RLPromotionDisplayLevel=2' + '&amp;status=0&amp;state=<%=UIUtil.toJavaScript(state)%>');
			}
           }

           function detail() {
              top.setContent('<%= UIUtil.toJavaScript((String)NLSfile.get("RLDiscountDetailsDialog_title")) %>','/webapp/wcs/tools/servlet/DialogView?XMLFile=RLPromotion.RLDiscountDetails&amp;calcodeId=' + parent.getSelected(),true);
           }
           
		   function getRelatedStorePromos()
           {
			var selectedPromos = parent.getChecked();
			var formName= '<%=(String)action.get("formName")%>';
			var relatedPromoNames = '';
			for(var i = 0; i < selectedPromos.length; i++)
			{
				var storeTypeField = "ST"+selectedPromos[i];
				// var storeTypeVal = eval(formName + "." + 	storeTypeField+".value");
				var storeTypeVal = getPromotionStoreTypeFromTop()[storeTypeField];
				if(storeTypeVal == 1)
				{
					var promoNameField = "PN"+selectedPromos[i];
					// var promoName=eval(formName + "." + 	promoNameField+".value");
					var promoName=getPromotionStoreTypeFromTop()[promoNameField];
					if(relatedPromoNames != '')
					{
						relatedPromoNames = relatedPromoNames + "," + promoName;
					}
					else
					{
						relatedPromoNames = promoName;
					}
				}
			 }
			 return relatedPromoNames;
           }

		   function getOriginalCalcIDs()
           {
			var selectedPromos = parent.getChecked();
			var formName= '<%=(String)action.get("formName")%>';
			var originalCalcIDs = '';
			for(var i = 0; i < selectedPromos.length; i++)
			{
				var storeTypeField = "ST"+selectedPromos[i];
				// var storeTypeVal = eval(formName + "." + 	storeTypeField+".value");
				var storeTypeVal = getPromotionStoreTypeFromTop()[storeTypeField];
				if(storeTypeVal == 0)
				{
					var calcID = selectedPromos[i];
					if(originalCalcIDs != '')
					{
						originalCalcIDs = originalCalcIDs + "," + calcID;
					}
					else
					{
						originalCalcIDs = calcID;
					}
				}
			 }
			 return originalCalcIDs;
           }

          function remove()
		  {
				var relatedPromoNames = getRelatedStorePromos();
				var originalCalcIDs = getOriginalCalcIDs();
				if(relatedPromoNames != '')
				{
					parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDenyDeletion"))%>'+relatedPromoNames);
				}

		        if(originalCalcIDs != '')
			    {
				  if (parent.confirmDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("DiscountDeleteMsg")) %>'))
                	top.showContent('/webapp/wcs/tools/servlet/RLPromotionDelete?calcodeId=' + originalCalcIDs + '&amp;RLPromotionDisplayLevel=2&amp;state=<%=UIUtil.toJavaScript(state)%>');
				}
	      }

	     function duplicate() {
		    var newDiscountName = "";
               newDiscountName = promptDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("EnterNewDiscountNameMsg")) %>','<%= UIUtil.toJavaScript((String)NLSfile.get("duplicateNewName")) %>',30, false);
               if(newDiscountName != null)
               {
	               	if(trim(newDiscountName) == '')
	                {
						parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("nameBlankMsg"))%>');
		    	    }
			        // else if (isNaN(newDiscountName.charAt(0)) == false)
				//	{
				//		parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rlDiscountNameNonNumeric").toString())%>');
				//	}	
			    	else if ( (numOfOccur(newDiscountName, "$") >0)  || (numOfOccur(newDiscountName, "!") >0)  || (numOfOccur(newDiscountName, "@") >0) || (numOfOccur(newDiscountName, "%") >0) || (numOfOccur(newDiscountName, "^") >0) || (numOfOccur(newDiscountName, "&") >0) || (numOfOccur(newDiscountName, "~") >0) || (numOfOccur(newDiscountName, ">") >0) || (numOfOccur(newDiscountName, "<") >0) || (numOfOccur(newDiscountName, "?") >0) || (numOfOccur(newDiscountName, ",") >0) || (numOfOccur(newDiscountName, ".") >0)  || (numOfOccur(newDiscountName, "/") >0) || (numOfOccur(newDiscountName, "-") >0) || (numOfOccur(newDiscountName, "'") >0)|| (numOfOccur(newDiscountName, "_") >0) || (numOfOccur(newDiscountName, '"') >0) || (numOfOccur(newDiscountName, "#") >0) || (numOfOccur(newDiscountName, "=") >0) || (numOfOccur(newDiscountName, "{") >0) || (numOfOccur(newDiscountName, "}") >0) || (numOfOccur(newDiscountName, "\\") >0) || (numOfOccur(newDiscountName, "/") >0))  	    
			      	{
						parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rlDiscountInvalidName").toString())%>');
					}	
			        else
 			        {
			        	top.put("clickedDuplicate", true);
			        	var params = new Object();
			           	params.calcodeId = parent.getSelected();
			           	//params.RLPromotionDisplayLevel = 2;
			           	params.discountName = newDiscountName;
			           	params.state = '<%=UIUtil.toJavaScript(state)%>';
			           	top.showContent('/webapp/wcs/tools/servlet/RLPromotionDuplicate', params);
					}    
		       }    	
	     }
	     
	     function report() {
		      var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=RLPromotion.RuleBasedDiscountReportDialog&amp;calcodeId=" + parent.getSelected();
		      if (top.setContent)
		      {
		   		top.setContent('<%= UIUtil.toJavaScript((String)NLSfile.get("report")) %>',url,true);
		      }
		      else
		      {
				parent.location.replace(url);
		      }
		}

</script>
           <script src="/wcs/javascript/tools/common/dynamiclist.js">
</script>
           <meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

           <body class="content_list">

           <script> parent.loadFrames();
<%
    // this is only used when user click the menu bar from other filter's perspective.
    if(state.equals("AllList")) {
%>
    top.put('ListFormfor_view',0);
<%  
    }
%>
</script>
           <script>
                   var storeID = "<%= jStoreID %>";
                   var languageID = "<%= jLanguageID %>";

                   function getLang() {
                       return languageID;
                   }
        
                   function getStore() {
                       return storeID;
                   }

                   function getResultsSize(){
                       return <%=simpleList.getResultSetSize()%>;
                   }

                   <%=simpleList.getUserJSfnc(NLSfile)%>

           
</script>

           <%
              int rowselect = 1;
              int totalsize = simpleList.getResultSetSize();
              int totalpage = totalsize/listSize;
              int dataSize = simpleList.getDataSize();

           %>
           <%=comm.addControlPanel(xmlfile,totalpage,totalsize,jLocale)%>
           <form name='<%=(String)action.get("formName")%>'>
              <%= comm.startDlistTable((String)NLSfile.get("accessProducts")) %>
              <%= comm.startDlistRowHeading() %>
              <%= comm.addDlistCheckHeading() %>
           <%
              String[][] tmp = simpleList.getHeadings();
              String orderByParm = request.getParameter("orderby");
              for(int i=0; i<tmp.length; i++){
           %>
                  <%= comm.addDlistColumnHeading((String)NLSfile.get(tmp[i][0]),tmp[i][1],orderByParm.equals(tmp[i][1])) %>
           <%
              }
           %>
              <%= comm.endDlistRow() %>

           <%
              for (int i = 0; i < dataSize; i++)
              {
           %>
		 <%= comm.startDlistRow(rowselect) %>
                 <%= comm.addDlistCheck(simpleList.getCheckBoxName(i),"javascript:setPromotionStoreTypeToTop('"+ simpleList.getCheckBoxName(i)+"');parent.setChecked()") %>
                 <% checkBoxNamesDet.append(simpleList.getCheckBoxName(i)+"|");%>
           <%
                 String[] tmpcol = simpleList.getColumns(i);
           %>
                 <%= comm.addDlistColumn( tmpcol[0], "javascript:promotionModify(" + simpleList.getCheckBoxName(i) + ")",(String)NLSfile.get(tmp[0][0]) ) %>

                 <%= comm.addDlistColumn( UIUtil.toHTML(tmpcol[1]), "none", (String)NLSfile.get(tmp[1][0])) %>
           <%
           		String priority ="";
           		if(tmpcol[2] != null && tmpcol[2].trim().equals("300"))
           		{
           			priority = (String)RLPromotionNLS.get("highest");
           		}
           		else if(tmpcol[2] != null && tmpcol[2].trim().equals("250"))
           		{
           			priority = (String)RLPromotionNLS.get("high");
           		}
           		else if(tmpcol[2] != null && tmpcol[2].trim().equals("200"))
           		{
           			priority = (String)RLPromotionNLS.get("moderate");
           		}
           		else if(tmpcol[2] != null && tmpcol[2].trim().equals("150"))
           		{
           			priority = (String)RLPromotionNLS.get("low");
           		}
           		else if(tmpcol[2] != null && tmpcol[2].trim().equals("100"))
           		{
           			priority = (String)RLPromotionNLS.get("lowest");
           		}
           %>
                 <%= comm.addDlistColumn( priority, "none") %>

                 <%= comm.addDlistColumn( TimestampHelper.getDateFromTimestamp(Timestamp.valueOf(tmpcol[3]),jLocale), "none") %>
           <%
                 String endDate = EproUtil.timestampToString(EproUtil.stringToTimestamp(tmpcol[4]), XmlHelper.EFFECTIVE_DATE_FORMAT);
                 if (tmpcol[4]==null || tmpcol[4].equals("")|| endDate.trim().equals(XmlHelper.MAX_EFFECTIVE_DATE_VALUE) ) {
           %>
                 <%= comm.addDlistColumn( (String)NLSfile.get("neverExpire"), "none") %>                 
           <%
                 } else {
           %>
                 <%= comm.addDlistColumn( TimestampHelper.getDateFromTimestamp(Timestamp.valueOf(tmpcol[4]),jLocale), "none") %>
           <%
                 }
           %>
                 <%= comm.addDlistColumn( (String)NLSfile.get(tmpcol[5]), "none") %>
                 <%= comm.endDlistRow() %>
<%
			   String storeType = "ST"+simpleList.getCheckBoxName(i);
			   String promoName = "PN"+simpleList.getCheckBoxName(i);
%>
 	         <INPUT TYPE = hidden name = '<%=storeType%>' value='<%=tmpcol[6]%>'>  
 	         <INPUT TYPE = hidden name = '<%=promoName%>' value='<%=tmpcol[0]%>'>
			   <%
                 if(rowselect==1){
                    rowselect = 2;
                 }else{
                    rowselect = 1;
                 }
              }
           %>
   <%= comm.endDlistTable() %>  
<%
	if(totalsize == 0)
	{ 

%>
		<p></p><p>
			<%= RLPromotionNLS.get("RLEmptyDiscountList") %>
<%
	}
%>

<%
    } catch (Exception e)	{
         com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
    }
%>
           </p>
           
           </form>
           	<script>
				function populateCheckBoxDetails(){		
					if(document.promoForm !=null){
						//alert(document.promoForm.checkBoxDetails.value);
						var checkBoxNamesDetails = document.promoForm.checkBoxDetails.value;
						var checkBoxNameArray = new Array();
						checkBoxNameArray = checkBoxNamesDetails.split('|');
						for(index=0;index<checkBoxNameArray.length-1;index++){
							setPromotionStoreTypeToTop(checkBoxNameArray[index]);
						}
					}
				}
	</script>
           <script>

             parent.afterLoads();
             parent.setResultssize(getResultsSize());
          
           
</script>
<form name="promoForm">
	<input type="hidden" name="checkBoxDetails" value='<%=checkBoxNamesDet.toString()%>'>

</form>
         </body>
         </html>
