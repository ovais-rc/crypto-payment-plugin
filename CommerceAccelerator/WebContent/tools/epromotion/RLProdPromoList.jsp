<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->

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

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@include file="epromotionCommon.jsp" %>

<script language="JavaScript">
	top.help['MC.discount.prodPromoList2.Help'] = top.help['MC.discount.prodPromoList2CEP.Help'];

</script>

<!-- Get user bean -->
<%
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
		// End defect# 37681
         String xmlfile = request.getParameter("ActionXMLFile");
         Hashtable actionXML = (Hashtable)ResourceDirectory.lookup(xmlfile); 
	   	 Hashtable action = (Hashtable)actionXML.get("action");
	   	 String beanClass = (String)action.get("beanClass");
         String resourcefile = (String)action.get("resourceBundle");
	  	 Class clazz = Class.forName(beanClass);
	  	 SimpleDynamicListBean simpleList = (SimpleDynamicListBean)clazz.newInstance();

         Hashtable NLSfile = (Hashtable) ResourceDirectory.lookup(resourcefile, jLocale); 
         String jStoreID = cmdContext.getStoreId().toString();
         String jLanguageID = cmdContext.getLanguageId().toString();

         simpleList.setParm("storeID",jStoreID);
         simpleList.setParm("languageID",jLanguageID);

         Hashtable parms = (Hashtable)action.get("parameter");
         for (Enumeration p=parms.keys(); p.hasMoreElements();) {
             String para = (String)p.nextElement();
             String tmpValue = request.getParameter(para);
             if(tmpValue !=null )
             {
                simpleList.setParm(para,tmpValue);
             }
         }
         simpleList.setParm("startindex","0");
         simpleList.setParm("endindex","0");

         com.ibm.commerce.beans.DataBeanManager.activate((com.ibm.commerce.beans.DataBean)simpleList, request);
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
           function create() {
			top.remove("chosenBranch");
			top.remove("lastCatentType");
            top.setContent('<%= UIUtil.toJavaScript((String)NLSfile.get("createDiscount")) %>','/webapp/wcs/tools/servlet/WizardView?XMLFile=RLPromotion.RLProdPromoWizard',true);
           }

           function modify() {
              top.setContent('<%= UIUtil.toJavaScript((String)NLSfile.get("modifyDiscount")) %>','/webapp/wcs/tools/servlet/NotebookView?XMLFile=RLPromotion.RLProdPromoNotebook&amp;calcodeId=' + parent.getSelected(),true);
           }

           function detail() {
              top.setContent('<%= UIUtil.toJavaScript((String)NLSfile.get("RLDiscountDetailsDialog_title")) %>','/webapp/wcs/tools/servlet/DialogView?XMLFile=RLPromotion.RLDiscountDetails&amp;calcodeId=' + parent.getSelected(),true);
           }
           
           function remove() {
              if (parent.confirmDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("DiscountDeleteMsg")) %>'))
                top.showContent('/webapp/wcs/tools/servlet/RLPromotionDelete?calcodeId=' + parent.getSelected() + '&amp;RLPromotionDisplayLevel=2')
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
	        else if (isNaN(newDiscountName.charAt(0)) == false)
		{
			parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rlDiscountNameNonNumeric").toString())%>');
		}	
	    	else if ( (numOfOccur(newDiscountName, "$") >0)  || (numOfOccur(newDiscountName, "!") >0)  || (numOfOccur(newDiscountName, "@") >0) || (numOfOccur(newDiscountName, "%") >0) || (numOfOccur(newDiscountName, "^") >0) || (numOfOccur(newDiscountName, "&") >0) || (numOfOccur(newDiscountName, "~") >0) || (numOfOccur(newDiscountName, ">") >0) || (numOfOccur(newDiscountName, "<") >0) || (numOfOccur(newDiscountName, "?") >0) || (numOfOccur(newDiscountName, ",") >0) || (numOfOccur(newDiscountName, ".") >0)  || (numOfOccur(newDiscountName, "/") >0) || (numOfOccur(newDiscountName, "-") >0) || (numOfOccur(newDiscountName, "'") >0)|| (numOfOccur(newDiscountName, "_") >0) || (numOfOccur(newDiscountName, '"') >0) || (numOfOccur(newDiscountName, "#") >0) || (numOfOccur(newDiscountName, "=") >0) || (numOfOccur(newDiscountName, "{") >0) || (numOfOccur(newDiscountName, "}") >0) || (numOfOccur(newDiscountName, "\\") >0) || (numOfOccur(newDiscountName, "/") >0))  	    
	      	{
			parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rlDiscountInvalidName").toString())%>');
		}	
	        else
 	        {
	        	top.put("clickedDuplicate", true);
	        	var params = new Object();
	           	params.calcodeId = parent.getSelected();
	           	params.RLPromotionDisplayLevel = 2;
	           	params.discountName = newDiscountName;
	           	top.showContent('/webapp/wcs/tools/servlet/RLPromotionDuplicate', params);
		//    top.showContent('/webapp/wcs/tools/servlet/RLPromotionDuplicate?calcodeId=' + parent.getSelected() + '&amp;RLPromotionDisplayLevel=2' + '&amp;discountName=' + newDiscountName);
		}    
	       }    	
	     }
	     
	     function report() {
		      var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=RLPromotion.RuleBasedDiscountReportDialog&amp;pageName=RLProdPromoList&calcodeId=" + parent.getSelected();
		      if (top.setContent)
		      {
		   		top.setContent('<%= UIUtil.toJavaScript((String)NLSfile.get("report")) %>',url,true);
		      }
		      else
		      {
				parent.location.replace(url);
		      }
		}

	    function brbRule() {
		      var url = "/webapp/wcs/tools/servlet/RLPromotionBRBRule"; 
		      if (top.setContent)
		      {
		   		top.setContent('<%= UIUtil.toJavaScript((String)NLSfile.get("brbrule")) %>',url,true);
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

           <script> parent.loadFrames()
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
                       return <%=simpleList.getListSize()%>;
                   }

                   <%=simpleList.getUserJSfnc(NLSfile)%>

           
</script>

           <%
              int startIndex = Integer.parseInt(request.getParameter("startindex"));
              int listSize = Integer.parseInt(request.getParameter("listsize"));
              int endIndex = startIndex + listSize;
              int rowselect = 1;
              int totalsize = simpleList.getListSize();
              int totalpage = totalsize/listSize;
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
              if (endIndex > simpleList.getListSize()) {
                  endIndex = simpleList.getListSize();
              }

              int indexFrom = startIndex;
              for (int i = indexFrom; i < endIndex; i++)
              {
           %>
                 <%= comm.startDlistRow(rowselect) %>
                 <%= comm.addDlistCheck(simpleList.getCheckBoxName(i),"none") %>
           <%
                 String[] tmpcol = simpleList.getColumns(i);
           %>
                 <%= comm.addDlistColumn( tmpcol[0], simpleList.getDefaultAction(i),(String)NLSfile.get(tmp[0][0]) ) %>
                 <%= comm.addDlistColumn( (String)NLSfile.get(tmpcol[1]), "none") %>
                 <%= comm.addDlistColumn( TimestampHelper.getDateFromTimestamp(Timestamp.valueOf(tmpcol[2]),jLocale), "none") %>
           <%
                 String endDate = EproUtil.timestampToString(EproUtil.stringToTimestamp(tmpcol[3]), XmlHelper.EFFECTIVE_DATE_FORMAT);
                 if (tmpcol[3]==null || tmpcol[3].equals("")|| endDate.trim().equals(XmlHelper.MAX_EFFECTIVE_DATE_VALUE) ) {
           %>
                 <%= comm.addDlistColumn( (String)NLSfile.get("neverExpire"), "none") %>                 
           <%
                 } else {
           %>
                 <%= comm.addDlistColumn( TimestampHelper.getDateFromTimestamp(Timestamp.valueOf(tmpcol[3]),jLocale), "none") %>
           <%
                 }
           %>
           <%
           		String priority ="";
           		if(tmpcol[4] != null && tmpcol[4].trim().equals("300"))
           		{
           			priority = (String)RLPromotionNLS.get("highest");
           		}
           		else if(tmpcol[4] != null && tmpcol[4].trim().equals("250"))
           		{
           			priority = (String)RLPromotionNLS.get("high");
           		}
           		else if(tmpcol[4] != null && tmpcol[4].trim().equals("200"))
           		{
           			priority = (String)RLPromotionNLS.get("moderate");
           		}
           		else if(tmpcol[4] != null && tmpcol[4].trim().equals("150"))
           		{
           			priority = (String)RLPromotionNLS.get("low");
           		}
           		else if(tmpcol[4] != null && tmpcol[4].trim().equals("100"))
           		{
           			priority = (String)RLPromotionNLS.get("lowest");
           		}
           %>
                 <%= comm.addDlistColumn( priority, "none") %>
                 <%= comm.addDlistColumn( tmpcol[5], "none", (String)NLSfile.get(tmp[5][0])) %>
                 <%= comm.endDlistRow() %>
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
           </p></form>
           <script>
           <!--
             parent.afterLoads();
             parent.setResultssize(getResultsSize());
           //-->
           
</script>

         </body>
         </html>


