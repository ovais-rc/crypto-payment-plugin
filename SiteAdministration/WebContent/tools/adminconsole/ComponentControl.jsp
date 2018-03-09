<!--********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------
*-->
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.exception.ECSystemException" %>
<%@page import="com.ibm.commerce.exception.ExceptionHandler" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.ras.*" %>


<%@include file="../common/common.jsp" %>

<jsp:useBean id="componentList" scope="request" class="com.ibm.commerce.ras.databeans.ComponentControlBean">
</jsp:useBean>

<%! Hashtable componentListNLS = null; %> 
<%! int numberOfComponentEntries = 0; %>
<%! Vector components = null; %>
<%! Vector componentsKey = null; %>

<%

   CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   String webalias = UIUtil.getWebPrefix(request);

  try {
        // obtain the resource bundle for display
        componentListNLS = (Hashtable)ResourceDirectory.lookup("adminconsole.DynamicLoggingNLS", cmdContext.getLocale());
       
       DataBeanManager.activate(componentList, request);
  
     } catch (ECSystemException ecSysEx) {
            ExceptionHandler.displayJspException(request, response, ecSysEx);
     } catch (Exception exc) {
      //ECSystemException ecSysEx = new ECSystemException(null,exc.getMessage(),null);
      ExceptionHandler.displayJspException(request, response, exc);
     }

 if (componentList != null)
   {
	components = componentList.getComponentName();
	componentsKey = componentList.getComponentNameKey();
	
   }

%>


  <%!
	   
  static final int	 numOfVisibleItemsInList= 14;
  static final int	 widthOfTheList         = 10;
  %>


<HTML>
<HEAD>
<%= fHeader%>
<LINK rel=stylesheet href="<%=webalias%>tools/common/centre.css" type="text/css">
<style type='text/css'>
.selectWidth {width: 430px;}
</style>

<TITLE><%=componentListNLS.get("componentTitle")%></TITLE>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>

<script>
<!---- hide script from old browsers


function loadPanelData()
 { 
 
 <%
	String name;
	String nameKey;
	String translateName;
	int numberOfComponent=components.size();
	int numberEnable=0;
	int numberDisable=0;
	
	for (int i=0;i<numberOfComponent;i++)
	{
	 
	  translateName = (String) components.elementAt(i);
	  nameKey = (String) componentsKey.elementAt(i);
	  
	  
    
	     
	  if (componentList.getCompStatus(nameKey))
	  {
	    
	    out.println( "document.componentForm.includedApps.options[" + numberEnable + "] = new Option(\""
	         + translateName + "\", \""
	         + nameKey
	         + "\", false, false);" );
	    ++numberEnable;     
	  }
	  else 
	  {
	   out.println( "document.componentForm.excludedApps.options[" + numberDisable + "] = new Option(\""
	   	 + translateName + "\", \""
	   	 + nameKey
	         + "\", false, false);" );
	   ++numberDisable;
	  }          
	              
     }
         
 %>
   
    initializeSloshBuckets(document.componentForm.excludedApps, document.componentForm.addButton, document.componentForm.includedApps,document.componentForm.removeButton);
 
    updateAllButtons();

    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }
  
 }

function savePanelData()
{
 
  var enableComponent = new Array();
  var disableComponent = new Array();
  
  var enableSize = document.componentForm.includedApps.options.length;
  var disableSize = document.componentForm.excludedApps.options.length;
  
  if (document.componentForm.includedApps.options.length > 0) {
   for (var i=0;i<document.componentForm.includedApps.options.length; i++) {
     
     enableComponent[i] = document.componentForm.includedApps.options[i].value;  
     }
   }
  
   if (document.componentForm.excludedApps.options.length > 0) {
    for (var i=0;i<document.componentForm.excludedApps.options.length; i++) {
     
     disableComponent[i] = document.componentForm.excludedApps.options[i].value;
       
     }
   }  
   
   parent.put("enableComponent", enableComponent);
   parent.put("enableSize", enableSize);
   parent.put("disableComponent", disableComponent);
   parent.put("disableSize", disableSize);
   parent.addURLParameter("authToken", "${authToken}");
  
 return true;


}

/////////////////////////////////////////////////////////////////////////////
// This function will return true if the given item is in the list
/////////////////////////////////////////////////////////////////////////////

function isInList(v, list)
{
	
   var n = list.length;
   for (var i = 0; i < n; i++) {
	
     if (v == list[i]) {
	
	return true;
      }
   }

   return false;
}






////////////////////////////////////////////////////////////////
// This function is used to add one or more member groups to 
// defined member group list                
////////////////////////////////////////////////////////////////
function addToIncludedGroup() {

   move(document.componentForm.excludedApps, document.componentForm.includedApps);
  updateSloshBuckets(document.componentForm.excludedApps, document.componentForm.addButton, document.componentForm.includedApps, document.componentForm.removeButton);
   updateAllButtons();

}


////////////////////////////////////////////////////////////////
// This function is used to add ALL member groups to 
// defined member group list                
////////////////////////////////////////////////////////////////
function addAllToIncludedGroup() {

   setItemsSelected(document.componentForm.excludedApps);

   move(document.componentForm.excludedApps, document.componentForm.includedApps);

  updateSloshBuckets(document.componentForm.excludedApps, document.componentForm.addButton, document.componentForm.includedApps, document.componentForm.removeButton);

   updateAllButtons();

}




///////////////////////////////////////////////////////////////
// This function is used to remove one or more defined member
// groups from defined member group list
///////////////////////////////////////////////////////////////
function removeFromIncludedGroup() {      
   move(document.componentForm.includedApps, document.componentForm.excludedApps);
 updateSloshBuckets(document.componentForm.excludedApps, document.componentForm.addButton, document.componentForm.includedApps, document.componentForm.removeButton);
   updateAllButtons();
}


///////////////////////////////////////////////////////////////
// This function is used to remove ALL defined member
// groups from defined member group list
///////////////////////////////////////////////////////////////
function removeAllFromIncludedGroup() {      

   setItemsSelected(document.componentForm.includedApps); 

   move(document.componentForm.includedApps, document.componentForm.excludedApps);

 updateSloshBuckets(document.componentForm.excludedApps, document.componentForm.addButton, document.componentForm.includedApps, document.componentForm.removeButton);

   updateAllButtons();

}



////////////////////////////////////////////////////////////////
// Enable/Disable the Add All and Remove All Buttons
////////////////////////////////////////////////////////////////
function updateAllButtons() {
	
	// if excludedApps list is empty, disable the "Add All" Button
	if (isListBoxEmpty(document.componentForm.excludedApps)) {
		 
        	document.componentForm.addAllButton.disabled=false;
       		document.componentForm.addAllButton.className='disabled';  
        	document.componentForm.addAllButton.id='disabled';    
	}
	else {
		document.componentForm.addAllButton.disabled=false;
        	document.componentForm.addAllButton.className='enabled';  
                document.componentForm.addAllButton.id='enabled';  
	}
	// if includedApps list is empty, disable the "Remove All" Button
	if (isListBoxEmpty(document.componentForm.includedApps)) {

		document.componentForm.removeAllButton.disabled=false;	
		document.componentForm.removeAllButton.className='disabled';
        	document.componentForm.removeAllButton.id='disabled'; 
	}
	else {
		document.componentForm.removeAllButton.disabled=false;
        	document.componentForm.removeAllButton.className='enabled'; 
                document.componentForm.removeAllButton.id='enabled';  
	}


}



// -->
</script>


</HEAD>
<BODY ONLOAD="loadPanelData()" class="content">

<H1><%=UIUtil.toHTML((String)componentListNLS.get("componentTitle"))%></H1>
<LINE3><%=UIUtil.toHTML((String)componentListNLS.get("componentSelectionMsg"))%></LINE3><BR>

<FORM NAME="componentForm">
     
       <TABLE BORDER='0'>     
         <TR>
        <TD>
        <LABEL for="includedApps1"><%=UIUtil.toHTML((String)componentListNLS.get("componentEnableList"))%></LABEL>
        </TD>
   	<TD WIDTH='20'>&nbsp;</TD>
   	<TD>
        <LABEL for="excludedApps1"><%=UIUtil.toHTML((String)componentListNLS.get("componentDisableList"))%></LABEL>
        </TD>
         </TR>
   
   	  <!-- all member groups -->
          <TR>
           <TD>
   	     <SELECT NAME='includedApps' id="includedApps1" CLASS='selectWidth' MULTIPLE SIZE='<%=numOfVisibleItemsInList%>' onChange="javascript:updateSloshBuckets(this, document.componentForm.removeButton, document.componentForm.excludedApps, document.componentForm.addButton);">
             
         	   </SELECT>
     	   </TD>
   
   	   <TD WIDTH='20' VALIGN='CENTER'><BR>

   	      <INPUT TYPE='button' NAME='addButton' VALUE='<%=UIUtil.toHTML((String)componentListNLS.get("componentButtonAdd"))%>' onClick="addToIncludedGroup();"><BR>

   	      <INPUT TYPE='button' NAME='removeButton' VALUE='<%=UIUtil.toHTML((String)componentListNLS.get("componentButtonRemove"))%>' onClick="removeFromIncludedGroup();"><BR>

   	      <INPUT TYPE='button' NAME='addAllButton' VALUE='<%=UIUtil.toHTML((String)componentListNLS.get("componentButtonAddAll"))%>' onClick="addAllToIncludedGroup();"><BR>

   	      <INPUT TYPE='button' NAME='removeAllButton' VALUE='<%=UIUtil.toHTML((String)componentListNLS.get("componentButtonRemoveAll"))%>' onClick="removeAllFromIncludedGroup();"><BR>
	
   	   </TD>
           <TD>
             <SELECT NAME='excludedApps' id="excludedApps1" CLASS='selectWidth' MULTIPLE SIZE='<%=numOfVisibleItemsInList%>' onChange="javascript:updateSloshBuckets(this, document.componentForm.addButton, document.componentForm.includedApps, document.componentForm.removeButton);">
   	     <!-- all available member groups for merchant -->
   	    
   	     </SELECT>
   	   </TD>
          </TR>
      </TABLE> 


</FORM>
</BODY>
</HTML>
