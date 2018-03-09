<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@include file="common.jsp" %>

<%
   CommandContext cmdContext = null;
   Hashtable commonNLS = null;
   Locale locale = null;
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
   	commonNLS = (Hashtable)ResourceDirectory.lookup("common.listNLS", locale);
   }
   catch (Exception e)
   {
	throw e;
   }
%>

<%!

   public final static String NONE     = "NONE";
   public final static String SINGLE   = "SINGLE";
   public final static String MULTIPLE = "MULTIPLE";

   public String checkSelections(String buttonName,
                                 String currDisable,
                                 String currSelectedType,
                                 Hashtable buttonParms)
   {
        String result1 = "CLASS=disabled";

        String result2 = "class=enabled";

      // check to see if the user is manually disabling the current button
      if (currDisable != null && currDisable.indexOf(buttonName) != -1 )
      {
         return result1;
      }

      Hashtable menu = (Hashtable)buttonParms.get(buttonName);
      String selection = (String)menu.get("selection");
      if (selection == null ||
         (selection.trim().equals("single") && currSelectedType.equals(SINGLE)) ||
         (selection.trim().equals("multiple") && (currSelectedType.equals(MULTIPLE) || currSelectedType.equals(SINGLE))))
      {
          return result2;
      }
      else
      {
          return result1;
      }
   }

    public String createButton(String button,
                               boolean isIE,
                               String currDisable,
                               Hashtable customNLS,
                               Hashtable commonNLS,
                               String currSelectedType,
                               Hashtable buttonParms,
                               Locale locale)
    {
        String buttonName = (String)customNLS.get(button);
        if (buttonName == null || buttonName.equals(""))
        {
            buttonName = (String)commonNLS.get(button);
        }

        StringBuffer result = new StringBuffer();
        String abutton = checkSelections(button,currDisable,currSelectedType,buttonParms);

       if (isIE)
        	{
         	result.append("<BUTTON type='BUTTON'  value='");
         	result.append(buttonName);
         	result.append("' name='");
         	result.append(button);
         	result.append("Button' ");
         	result.append( abutton );
         	result.append(" style='width:135px' onClick='javascript:parent.basefrm.");
         	result.append(button);
         	result.append("Action();'> ");
         	result.append("<font size=");
            result.append(Util.isDoubleByteLocale(locale)? "2" : "1");
            result.append(" style='float:left; padding-top:2px; cursor: default'>");
         	result.append(buttonName);
         	result.append("</font>");
         	result.append("</BUTTON>");
        	}
        	else
        	{
         	result.append("<input type='BUTTON' value='");
         	result.append(buttonName);
         	result.append("' name='");
         	result.append(button);
         	result.append("Button' ");
         	result.append( abutton);
         	result.append(" style='width:135px' onClick='javascript:parent.basefrm.");
         	result.append(button);
         	result.append("Action();'>");
        	}
        	return result.toString();
   }
%>

<html>

<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css" />
</head>

<body onload="this.focus()">

<table border="0" cellpadding="0" cellspacing="0">
<form name="buttonForm">
<%
  	com.ibm.commerce.server.JSPHelper jspHelper = new JSPHelper(request);

   Hashtable xmlfile = (Hashtable)ResourceDirectory.lookup(jspHelper.getParameter("XMLFile"));
   Hashtable action = (Hashtable)xmlfile.get("action");

   // obtain the resource bundle for display
   Hashtable customNLS = (Hashtable)ResourceDirectory.lookup((String)action.get("resourceBundle"), locale);

   // Create order of buttons on page.  User defined button will go in the other spot.
   String[] buttonOrders = { "new", "properties", "summary", "other", "delete", "filter" };

   Hashtable buttonOrderTable = new Hashtable();
   for (int i = 0; i < buttonOrders.length; i++)
   {
      buttonOrderTable.put(buttonOrders[i],new Boolean(true));
   }

   boolean isIE    = Util.isIE(request);
   String currDisable = jspHelper.getParameter("DISABLE");

   // set the current type of selection by the user (none,single or multiple rows checked)
   String selected = jspHelper.getParameter("selected");
   String currSelectedType = null;
   if (selected == null || selected.equals("") || selected.equals("SELECTED"))
   {
      currSelectedType = NONE;
   }
   else if (selected.indexOf(",") != -1)
   {
      currSelectedType = MULTIPLE;
   }
   else
   {
      currSelectedType = SINGLE;
   }


   Vector menus = (Vector)Util.convertToVector(action.get("menu"));
   Enumeration enumList = menus.elements();

   // create a buttonParms hashtable where an entry consists of a name as a key and the entry as the value
   Hashtable  buttonParms = new Hashtable();
   Hashtable temp = null;
   while(enumList.hasMoreElements())
   {
      temp = (Hashtable)enumList.nextElement();
      buttonParms.put(temp.get("name"),temp);
   }

   String    name,component;
   // loop over all buttons and output them in a formatted table in the correct order (which is in
   // the buttonOrders array)
   for (int i = 0; i < buttonOrders.length; i++)
   {
	 boolean buttonDisplay = false;
       // check to see if the action xml file contains the current pre-defined button
       // in the button orders list
       // If it does display it
       if (buttonParms.containsKey(buttonOrders[i]))
       {
           temp = (Hashtable)buttonParms.get(buttonOrders[i]);
           component = (String)temp.get("component");

            // check to see if the button is associated with a component which is enabled and only then
            // output it to the screen
            if (component == null || (component != null && ToolsConfiguration.isComponentEnabled(component)))
            {
			buttonDisplay = true;
%>
	<script type="text/javascript">
		document.writeln('<tr>');
		document.writeln('    <table cellpadding="0" cellspacing="0" border="0">');
		document.writeln('        <tr>');
		document.writeln('            <td>&nbsp;</td>');
		document.writeln('            <td bgcolor="#1B436F">');
		document.writeln('<%= UIUtil.toJavaScript(createButton(buttonOrders[i], isIE, currDisable,customNLS,commonNLS, currSelectedType, buttonParms, locale)) %>');
		document.writeln('</td>');
		document.writeln('<td height="100%"><img alt="" src="/wcs/images/tools/list/but_curve2.gif" name = "<%= buttonOrders[i] + "Image"%>" width="9" height="100%"></td>');
		document.writeln('</tr>');
		document.writeln('          <tr><td></td></tr><tr><td></td></tr>');
		document.writeln('    </table>');
		document.writeln('</tr>');
	</script>
<%
            }
%>
	<script type="text/javascript">
		var ht = document.all.item('<%= buttonOrders[i] + "Button"%>').clientHeight;
		if (ht > 24) {
			document.<%= buttonOrders[i] + "Image"%>.src = "/wcs/images/tools/list/but_curve3.gif";
		}
	</script>
<%
        }
        else if (buttonOrders[i].equals("other"))
        {
            // create other buttons (non pre-defined buttons created by user) in the order
            // in which they are specified in the xml file
            Hashtable bttn = null;
            String currName;
            Enumeration buttonKeys = menus.elements();
            while (buttonKeys.hasMoreElements())
            {
                bttn = (Hashtable)buttonKeys.nextElement();
                currName = (String)bttn.get("name");

                // display the button if it isn't predefined (those ones are handled above)
                if (buttonOrderTable.get(currName) == null)
                {
                    component = (String)bttn.get("component");

                    // only display the button if it is associated with a component which is enabled
                    if (component == null || (component != null && ToolsConfiguration.isComponentEnabled(component)))
                    {
				buttonDisplay = true;
%>
	<script type="text/javascript">
		document.writeln('<tr>');
		document.writeln('    <table cellpadding="0" cellspacing="0" border="0">');
		document.writeln('        <tr>');
		document.writeln('            <td>&nbsp;</td>');
		document.writeln('            <td bgcolor="#1B436F">');
		document.writeln('<%= UIUtil.toJavaScript(createButton(currName, isIE, currDisable,customNLS,commonNLS, currSelectedType, buttonParms, locale)) %>');
		document.writeln('</td>');
		document.writeln('<td height="100%"><img alt="" src="/wcs/images/tools/list/but_curve2.gif" name = "<%= currName + "Image"%>" width="9" height="100%"></td>');
		document.writeln('</tr>');
		document.writeln('          <tr><td></td></tr><tr><td></td></tr>');
		document.writeln('    </table>');
		document.writeln('</tr>');

		var ht = document.all.item('<%= currName + "Button"%>').clientHeight;
		if (ht > 24) {
			document.<%= currName + "Image"%>.src = "/wcs/images/tools/list/but_curve3.gif";
		}
	</script>
<%
                    }
                }
            }
        }
    }
%>
</form>
</table>

</body>

</html>
