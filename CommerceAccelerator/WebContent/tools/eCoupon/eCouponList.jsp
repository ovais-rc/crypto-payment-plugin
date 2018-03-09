<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

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
<%@ page import="java.math.*" %>
<%@ page import="java.lang.reflect.*" %>

<%@include file="eCouponCommon.jsp" %>

<!-- Get user bean -->
<%
         CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
         Locale jLocale = cmdContext.getLocale();

         String xmlfile = request.getParameter("ActionXMLFile");
	// System.out.println(" XML FIle ="+xmlfile);
         Hashtable actionXML = (Hashtable)ResourceDirectory.lookup(xmlfile); 
	 //System.out.println(" ActionXML ="+actionXML);
	 Hashtable action = (Hashtable)actionXML.get("action");
	 //System.out.println(" Action ="+action);
	 String beanClass = (String)action.get("beanClass");
	 //System.out.println(" BeanClass ="+beanClass);
         String resourcefile = (String)action.get("resourceBundle");
	 //System.out.println(" Resource File ="+resourcefile);

         Class clazz = Class.forName(beanClass);
         SimpleDynamicListBean simpleList = (SimpleDynamicListBean)clazz.newInstance();

         Hashtable NLSfile = (Hashtable) ResourceDirectory.lookup(resourcefile, jLocale); 

	// adding code for deactivate error message
	String deacErrMsg = request.getParameter("CannotDeactivate");
	if (deacErrMsg  != null)
	{
		//System.out.println("cannotdeac");
%>
	<script>
		parent.alertDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("eCouponDeactivateErrorMsg")) %>');
	
</script>
<%
	}
	String respMsg = request.getParameter("AlreadyActive");
	if (respMsg != null)
	{
		System.out.println("already active");
%>
	<script>
		parent.alertDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("eCouponAlreadyActiveMsg")) %>');
	
</script>
<%
	}

	respMsg = request.getParameter("AlreadyInactive");
	if (respMsg != null)
	{
		System.out.println("already inactive");
%>
	<script>
		parent.alertDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("eCouponAlreadyInactiveMsg")) %>');
	
</script>
<%
	}

	respMsg = request.getParameter("CannotDelete");
	if (respMsg != null)
	{
		System.out.println("cannot delete");
%>
	<script>
		parent.alertDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("eCouponDeleteErrorMsg")) %>');
	
</script>
<%
	}

      // end of adding new code

         String jStoreID = cmdContext.getStoreId().toString();
	 System.out.println(" Store Id ="+jStoreID);
         String jLanguageID = cmdContext.getLanguageId().toString();
	 System.out.println(" Language Id ="+jLanguageID);

         simpleList.setParm("storeID",jStoreID);
         simpleList.setParm("languageID",jLanguageID);

         Hashtable parms = (Hashtable)action.get("parameter");
         for (Enumeration p=parms.keys(); p.hasMoreElements();) {
             String para = (String)p.nextElement();
             String tmpValue = request.getParameter(para);
             if(tmpValue !=null )
                simpleList.setParm(para,tmpValue);
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
		Enumeration jsFile = jsFiles.elements();
		while(jsFile.hasMoreElements())
		{
			Hashtable javaScriptFile = (Hashtable) jsFile.nextElement();

			// get src for jsFile
			String jsSRC = UIUtil.getWebPrefix(request) + (String) javaScriptFile.get("src");
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



           <%= feCouponHeader %>
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
		// define for gettign params in functions to check
	var resultArray = new Array();
	var resultArrayIndex = 0;

      function create() {
	   top.setContent('<%=UIUtil.toJavaScript((String)NLSfile.get("createECoupon"))%>',"<%=UIUtil.getWebappPath(request)%>" + "WizardView?XMLFile=eCoupon.eCouponWizard",true)
           }

<!-- Start RajS -->
          function summary() 
	   {
		var checkedId = new Array();
	   	// U might have to make this as parent.getChecked.. check it. IMPORTANT
	   	checkedId = parent.getChecked();
	   	var aPromo_Id = checkedId[0];
	   	//alertDialog(" Promo Id= " + aPromo_Id);

              top.setContent('<%= UIUtil.toJavaScript((String)NLSfile.get("eCouponSummary")) %>', "<%=UIUtil.getWebappPath(request)%>" + "DialogView?XMLFile=eCoupon.eCouponSummary" + "&<%=ECECouponConstant.EC_Promo_Id%>=" + aPromo_Id, true);
           }
<!-- End RajS -->




          function publish(s)
	  {
	   var checkedId = new Array();
	   // U might have to make this as parent.getChecked.. check it. IMPORTANT
	   checkedId = parent.getChecked();
	   var aPromo_Id = checkedId[0];
	   //alertDialog(" Promo Id= " + aPromo_Id);

	   if (s == 2)
	   {
	     if (!parent.confirmDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("eCouponDeleteMsg")) %>'))
	     {
	        return;
	    }
	  }
	parent.removeEntry(aPromo_Id);
	top.showContent("<%=UIUtil.getWebappPath(request)%>" + "eCouponPublish?"+"<%=ECECouponConstant.EC_Promo_Id%>="+aPromo_Id+"&amp;<%=ECECouponConstant.EC_Status%>="+s);
	//parent.basefrm.location.href= "/webapp/wcs/tools/servlet/eCouponPublish?selected=SELECTED&ActionXMLFile=eCoupon.eCouponList&cmd=eCouponView"+"&<%=ECECouponConstant.EC_Promo_Id%>="+aPromo_Id+"&<%=ECECouponConstant.EC_Status%>="+s;

  	}
		
	// added function to activate/deactivate
	function activate()
	{
		var checkedId = new Array();
		// U might have to make this as parent.getChecked.. check it. IMPORTANT
	  	checkedId = parent.getChecked();
	   	var aPromo_Id = checkedId[0];
	   	//alertDialog(" Promo Id= " + aPromo_Id);
	   	
	   	var promoStatus;
		for (var j = 0; j < resultArray.length; j++)
		{
			if (aPromo_Id == resultArray[j].promoId)
			promoStatus = resultArray[j].status;
		}
//		alertDialog("promo status is " + promoStatus);
				
		if (promoStatus == "Active")
			parent.alertDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("eCouponAlreadyActiveMsg")) %>');
		else if (!parent.confirmDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("eCouponActivateMsg")) %>'))
	   	{
	        	return;
	    }
	    else
			top.showContent("<%=UIUtil.getWebappPath(request)%>" + "eCouponPublish?"+"<%=ECECouponConstant.EC_Promo_Id%>="+aPromo_Id+"&amp;<%=ECECouponConstant.EC_Status%>=<%=ECECouponConstant.EC_Activate%>");
	}
	function deactivate()
	{
		var checkedId = new Array();
		// U might have to make this as parent.getChecked.. check it. IMPORTANT
	  	checkedId = parent.getChecked();
	   	var aPromo_Id = checkedId[0];
	   	//alertDialog(" Promo Id= " + aPromo_Id);
	   	
	   	var promoStatus;
		for (var j = 0; j < resultArray.length; j++)
		{
			if (aPromo_Id == resultArray[j].promoId)
			promoStatus = resultArray[j].status;
		}
		//alertDialog("promo status is " + promoStatus);
				
		if (promoStatus == "Inactive")
			parent.alertDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("eCouponAlreadyInactiveMsg")) %>');
	    else if (!parent.confirmDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("eCouponDeactivateMsg")) %>'))
	   	{
	        	return;
	    }
	    else
			top.showContent("<%=UIUtil.getWebappPath(request)%>" + "eCouponPublish?"+"<%=ECECouponConstant.EC_Promo_Id%>="+aPromo_Id+"&amp;<%=ECECouponConstant.EC_Status%>=<%=ECECouponConstant.EC_Deactivate%>");
	}

           // added function for modify eCoupon promotion
           function modify() 
           { 
		   		//alertDialog("in modify");
		   		//alertDialog(" resultArray is " + resultArray.length);
		   		
            	var checkedId = new Array();
	         	checkedId = parent.getChecked();
	         	var aPromo_Id = checkedId[0];
	         	//alertDialog(" Promo Id= " + aPromo_Id);
	         	
		   		var promoStatus;
		   		for (var j = 0; j < resultArray.length; j++)
		   		{
			 		if (aPromo_Id == resultArray[j].promoId)
						promoStatus = resultArray[j].status;
		   		}
				//alertDialog("promo status is " + promoStatus);
				
		   		if (promoStatus == "Active")
					parent.alertDialog('<%= UIUtil.toJavaScript((String)NLSfile.get("eCouponCannotModifyAsActiveMsg")) %>');
		   		else
               		top.setContent('<%=UIUtil.toJavaScript((String)NLSfile.get("modifyECoupon"))%>',"<%=UIUtil.getWebappPath(request)%>" + "NotebookView?XMLFile=eCoupon.eCouponNotebook&" +"<%=ECECouponConstant.EC_Promo_Id%>="+ aPromo_Id + "&<%=ECECouponConstant.EC_NEW_PROMOTION%>=false", true)
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
              <%= comm.startDlistTable((String)NLSfile.get("eCouponListTblMsg")) %>
              <%= comm.startDlistRowHeading() %>
		<%= comm.addDlistColumnHeading("",null,false) %>

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
				<script> 
           			resultArray[resultArrayIndex] = new Object();
           			resultArray[resultArrayIndex].status = "<%= tmpcol[1] %>" ; 
           			resultArray[resultArrayIndex++].promoId = "<%= tmpcol[5] %>";
           			 
           		
</script>
                 <%= comm.addDlistColumn( tmpcol[0], simpleList.getDefaultAction(i),(String)NLSfile.get(tmp[0][0]) ) %>
                 <%= comm.addDlistColumn( (String)NLSfile.get(tmpcol[1]), "none") %>
                 <%= comm.addDlistColumn( TimestampHelper.getDateTimeFromTimestamp(Timestamp.valueOf(tmpcol[2]),jLocale), "none") %>
           <%
                 if (tmpcol[3]==null || tmpcol[3].equals("")) {
           %>
                 <%= comm.addDlistColumn( (String)NLSfile.get("neverExpire"), "none") %>                 
           <%
                 } else {
           %>
                 <%= comm.addDlistColumn( TimestampHelper.getDateTimeFromTimestamp(Timestamp.valueOf(tmpcol[3]),jLocale), "none") %>
           <%
                 }
           %>
                 <%= comm.addDlistColumn( tmpcol[4], "none", (String)NLSfile.get(tmp[4][0])) %>
                 <%= comm.endDlistRow() %>
           <%
                 if(rowselect==1){
                    rowselect = 2;
                 }else{
                    rowselect = 1;
                 }
              } // end of  for
           %>
<%= comm.endDlistTable() %>
<% if (totalsize == 0) { %>
<p></p><p>
<%=(String)NLSfile.get("eCouponNoECoupons")%> 
<% } %>
</p></form>
<script>
parent.loadFrames();
parent.afterLoads();
parent.setResultssize(getResultsSize());

</script>
</body>
</html>
