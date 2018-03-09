<!-- ========================================================================
  Licensed Materials - Property of IBM

  5724-A18

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>
<%@page import = "com.ibm.commerce.user.objects.MemberGroupAccessBean" %>
<%@page import="com.ibm.commerce.exception.ExceptionHandler" %>


<%!

private String generateProfileSelection(HttpServletRequest request, String container, String title)
{
   CommandContext profileHelperCC = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Hashtable profileHelperRB = new Hashtable();
   Integer storeId=profileHelperCC.getStoreId();
   Integer memberGroupTypeId = new Integer(-1);
   String result = null;
         
   try {
      profileHelperRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", profileHelperCC.getLocale());
	
	  MemberGroupAccessBean aMemberGroupList=new MemberGroupAccessBean();  
	  Enumeration en=aMemberGroupList.findByStoreAndMemberGroupUsage(memberGroupTypeId,storeId);
   if (profileHelperRB == null) System.out.println("!!!! Reports resouces bundle is null");

   String resulttitle = "";
   
   if (en == null) {
       System.out.println("Reporting Framework: No profile available for selection.");
      return "";
   }
    
   if (title != null)  resulttitle =
                                     "    <TR>\n" +
                                     "       <TD COLSPAN=9 ALIGN=LEFT VALIGN=CENTER HEIGHT=32>" + profileHelperRB.get(title) + "</TD>\n" +
                                     "    </TR>\n";

	result = resulttitle + "<FORM NAME=" + container + ">\n <SELECT NAME=ProfileSelection ID=profileSelection width=100> \n";
	String profileName = null;
   while (en.hasMoreElements()) {
	  MemberGroupAccessBean aMemberGroup=(MemberGroupAccessBean)en.nextElement();
	  profileName=aMemberGroup.getMbrGrpName();
	  result = result + "   <OPTION value='" + profileName + "'>" + profileName + "</OPTION> \n";
   }
   if(profileName == null)
	  	result = result + "   <OPTION value='" + "noprofile" + "'>" + "--None--" + "</OPTION> \n";
   result += " </SELECT> \n</FORM>";
  } catch (Exception e) {
  e.printStackTrace();
  return "";
}
 return result;

}

%>
 
<SCRIPT>

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // save function for profile
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function saveProfile(container)
   {
	   with (document.forms[container]) {
         parent.put(container, ProfileSelection.selectedIndex);
      }
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // initialize function for Profile
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function onLoadProfile(container)
   {
	  var curIndex = parent.get(container, null);
	  	  
      if (curIndex != null) {
		  with (document.forms[container]) {
            ProfileSelection.selectedIndex  = curIndex;
         }
      }
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // This function returns the Profile Name
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   function returnProfileName(container)
   {
	  with (document.forms[container]) {
		 return ProfileSelection[ProfileSelection.selectedIndex].value;
      }
   }

</SCRIPT>
