<!--
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
//*--------------------------------------------------------------------->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@include file="common.jsp" %>


<%
   CommandContext cmdContext = null;  
   Locale locale = null;
   Hashtable commonNLS = null;
   
   try
   {	
   	cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   	
    	// use server default locale if no command context is found
   	if (cmdContext != null)
   	{
       		locale = cmdContext.getLocale();
   	}
   	else
   	{
       		locale = Locale.getDefault();
   	}
   	 // obtain the resource bundle for display
   	commonNLS = (Hashtable)ResourceDirectory.lookup("common.listNLS", locale);
   }
   catch (Exception e)
   {
	throw e;
   }
%> 

<%

   int selectedIndex = 0;
   int startIndex = 0;
   int endIndex = 0;
   int listSize = 0;
   int resultsSize = 0;

   String xmlFileParm = request.getParameter("XMLFile");

   Hashtable xmlfile = (Hashtable)ResourceDirectory.lookup(xmlFileParm);
   Hashtable action = null;

   action = (Hashtable)xmlfile.get("action");

    // obtain the resource bundle for display
   Hashtable customNLS = (Hashtable)ResourceDirectory.lookup((String)action.get("resourceBundle"), locale);

   String startIndexParm = request.getParameter("startindex");

   if ((startIndexParm != null) && (!startIndexParm.equals("")))
      startIndex = new Integer(startIndexParm).intValue();

   String listSizeParm = request.getParameter("listsize");

   if ((listSizeParm != null) && (!listSizeParm.equals("")))
      listSize = new Integer(listSizeParm).intValue();

   String resultsSizeParm = request.getParameter("resultssize");

   if ((resultsSizeParm != null) && (!resultsSizeParm.equals("")))
      resultsSize = new Integer(resultsSizeParm).intValue();
   else
     resultsSize = 0;

   endIndex = startIndex + listSize;
 
   if (endIndex > resultsSize)

      endIndex = resultsSize;

%>

<html>

<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title>Scroll Control</title>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css" />

<SCRIPT>
var views = null;

<%
   // get view info
   Vector viewParmsVector = Util.convertToVector(action.get("view"));
   if (viewParmsVector != null)
   {
%>
      views = new Array();
<%
      int counter = 0;
      String actionString = "",name="",actionfile="";
      Hashtable v = null,viewXMLFile = null,viewAction = null;
      Enumeration vParms = viewParmsVector.elements();
      while (vParms.hasMoreElements())
      {
         v = (Hashtable) vParms.nextElement();
         name = (String)v.get("name");
         actionfile = (String)v.get("actionFile");

         if (actionfile.equals(xmlFileParm))
         {
            selectedIndex = counter;
            viewAction = action;
         }
         else
         {
            viewXMLFile = (Hashtable)ResourceDirectory.lookup(actionfile);

            if (viewXMLFile !=null )
            {
               viewAction = (Hashtable)viewXMLFile.get("action");
            }
            else
            {
               // throw exception
            }
         }

         actionString = (String)viewAction.get("default");
%>
         views[<%=counter%>] = "<%=actionString%>";

<%
         counter = counter + 1;
      }
   }
%>



function changeView(){
   if (views != null)
   {
      eval(views[document.scrollcontrol.bucket.selectedIndex]);
   }
}

function getRefNum(){
        return parent.basefrm.getRefNum();
}

function visibleList(s){
   if (this.scrollcontrol.bucket)
   {
      this.scrollcontrol.bucket.style.visibility = s;
   }
}

</SCRIPT>

</HEAD>

<BODY LINK = Black VLINK = Black  ALINK = Black onLoad="if (document.scrollcontrol.selectedSize) {document.scrollcontrol.selectedSize.value = parent.basefrm.getChecked().length;}">
<FORM Name="scrollcontrol">
<TABLE class=list5>
	
		<H1><tr><%= customNLS.get(action.get("title")) %></tr></H1>
    
<%
if (viewParmsVector != null || ((resultsSize > 0) && (resultsSize > listSize))) {
%>
<TR>
	<%
   	if (viewParmsVector != null) {
	%>

     	<td class="list_filter2" rowspan=2 >
     		<label for="viewSelect"><%=(String)commonNLS.get("view")%></label>
     	</td>
     	<td class="list_filter" rowspan=2 align="left" valign="middle">
     		<SELECT name="bucket" ONCHANGE="changeView();" id="viewSelect">
		<%
     		String taskName = "";
     		int count2 = 0;
     		Enumeration vElems = viewParmsVector.elements();
     		Hashtable vv = null;
     		while (vElems.hasMoreElements()) {
         		vv = (Hashtable) vElems.nextElement();
         		taskName = (String)vv.get("name");
		%>
       			<OPTION
			<%
       			if (selectedIndex == count2) {
			%>
         		SELECTED
			<%
       			}
			%>
     		> <%=(String)customNLS.get(taskName)%>
		<%
       		count2 = count2 + 1;
     		}
		%>

 		</SELECT>
	<%
   	}

	// -- make sure there is at least one result and that the resultssize is larger than the subset (listsize)
   	if ((resultsSize > 0) && (resultsSize > listSize)) {

	%>

     		</td>


     		<td class="list_location" align=right >
       			&nbsp;&nbsp;&nbsp;<A class="list_location" HREF="" onClick="javascript: parent.basefrm.gotoindex('top'); return false;"><IMG BORDER=0 SRC="/wcs/images/tools/list/sm_up.gif" width="5" height="5" border="0" alt=''">&nbsp;<%=(String)commonNLS.get("top")%></A>
       			&nbsp;&nbsp;&nbsp;<A class="list_location" HREF="" onClick="javascript: parent.basefrm.gotoindex('bottom'); return false;"><IMG BORDER=0 SRC="/wcs/images/tools/list/sm_dwn.gif" width="5" height="5" border="0" alt=''">&nbsp;<%=(String)commonNLS.get("bottom")%></A>

			<%
   			if (startIndex >0) {
			%>

    			&nbsp;&nbsp;&nbsp;<A class="list_location" HREF="" onClick="javascript: parent.basefrm.gotoindex('prev'); return false;"><IMG BORDER=0 SRC="/wcs/images/tools/list/sm_prev.gif" width="5" height="5" border="0" alt=''">&nbsp;<%=(String)commonNLS.get("prev")%></A>
			<%
   			}
   			if (((startIndex + listSize - 1) < resultsSize) && (endIndex<resultsSize)){
			%>
    			&nbsp;&nbsp;&nbsp;<A class="list_location" HREF="" onClick="javascript: parent.basefrm.gotoindex('next'); return false;"><IMG BORDER=0 SRC="/wcs/images/tools/list/sm_next.gif" width="5" height="5" border="0" alt=''">&nbsp;<%=(String)commonNLS.get("next")%></A>&nbsp;&nbsp;
			<%
   			}
   			String pageCount = startIndex + 1+ " " + (String)commonNLS.get("to") + "  " + endIndex + " " +  (String)commonNLS.get("of") + " " + resultsSize;
			%>
    		</td>
</TR>
	<TR ALIGN="right">
    		<td class="list_location" COLSPAN=4  align=right valign="top"><%=pageCount%>&nbsp;&nbsp; </td>
	</TR>
	<%
   	}
	%>
	
	
	
</td><td></td>
</tr>
	

<%
}
%>


</TABLE>
<INPUT TYPE="hidden" NAME="selectedSize" VALUE="">
</FORM>
</BODY>
</HTML>

