<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.exception.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page isThreadSafe="false" %>

<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>

<%!
   public final static String sortoffImage="/wcs/images/tools/list/up_arrow.gif";
   public final static String sortonImage="/wcs/images/tools/list/up_arrow3.gif";

   String selectedParm = null;
   String orderByParm = null;
   String actionXMLFileParm = null;
   String startindexParm = null;
   String listsizeParm = null;
   String refnumParm = null;

   Hashtable action=null;
   Vector singleSelection = null;
   Vector multipleSelection = null;
   Vector menus = null;
   Hashtable listNLS = null;
   CommandContext commandContext = null;

   public CommandContext getCommandContext()
   {
     return commandContext;
   }

   public Locale getLocale()
   {
     return getCommandContext().getLocale();
   }

   public int getStartIndex() {
     int startindex = 0;
     if ((startindexParm == null) || (startindexParm.equals("")))
       startindex = 0;
     else
       startindex = new Integer(startindexParm).intValue();
     return startindex;
   }

   public int getListSize() {
     int listsize = 0;
     if ((listsizeParm == null) || (listsizeParm.equals("")))
       listsize = 5;
     else
       listsize = new Integer(listsizeParm).intValue();
     return listsize;
   }

   public int getRefNum() {
     int refnum = 0;
     if ((refnumParm != null) && (! refnumParm.equals("")))
       refnum = new Integer(refnumParm).intValue();
     return refnum;
   }

   public String addHiddenVars()
   {
        StringBuffer sb = new StringBuffer(1000);

        sb.append("<INPUT TYPE=\"hidden\" NAME=\"selected\" VALUE=\"" + UIUtil.toHTML(selectedParm) + "\">\n");
        sb.append("<INPUT TYPE=\"hidden\" NAME=\"orderby\" VALUE=\"" + UIUtil.toHTML(orderByParm) + "\">\n");
        sb.append("<INPUT TYPE=\"hidden\" NAME=\"ob\" VALUE=\"" + UIUtil.toHTML(orderByParm) + "\">\n");
        sb.append("<INPUT TYPE=\"hidden\" NAME=\"CTS\" VALUE=\""+ System.currentTimeMillis()+"\">\n");
        sb.append("<INPUT TYPE=\"hidden\" NAME=\"startindex\" VALUE=\"\">\n");
        sb.append("<INPUT TYPE=\"hidden\" NAME=\"listsize\" VALUE=\"" + UIUtil.toHTML(listsizeParm) + "\">\n");
        sb.append("<INPUT TYPE=\"hidden\" NAME=\"refnum\" VALUE=\"" + UIUtil.toHTML(refnumParm) + "\">\n");
        sb.append("<INPUT TYPE=\"hidden\" NAME=\"ActionXMLFile\" VALUE=\"" + UIUtil.toHTML(actionXMLFileParm) + "\">\n");
        return sb.toString();
   }

   public String selectAll_deselectAll()
   {
     return "<input name=\"select_deselect\" type=\"checkbox\" value=\"Select Deselect All\" onClick=\"selectDeselectAll();\">";
   }

   public String sortGif(String fieldName) {
     String result = "<IMG BORDER=0 SRC='";
     if (fieldName.equals("SETCABC"))
	
	result += sortonImage;

     else if (fieldName.equals(orderByParm))

       result += sortonImage;

     else
       result += sortoffImage;


     result += "' alt='" + UIUtil.toJavaScript((String)listNLS.get("sort"))+ "'>";
     return result;
   }

   public String orderBy(String formName, String fieldName) {
     String result = "<a href=\"\"; onClick=\"document." + formName + ".orderby.value='" + fieldName + "';getURL();return false;\">";
     result += sortGif(fieldName) + "</a>";
     return result;
   }

   public String getURL(String formName) throws ECSystemException
   {
     String a = (String) action.get("default");

     if (a.trim().length() == 0) { 
        // use hidden form to submit data, instead of directly url calling, where double-type characters have problem
        a = "document." + formName + ".submit();";
     } else {      
        String orderB="'+document."+formName+".orderby.value+'";
        a = Util.replace(a, "orderby", "ob");
        a = Util.replace(a, "SELECTED", "'+getChecked()+'&orderby="+orderB);
        a = Util.replace(a, "DISPLAY", "CTS"+System.currentTimeMillis()+"&ActionXMLFile="+actionXMLFileParm+"&DISPLAY");
     }
     return "function getURL() { \n  " + a + "\n  return;\n" + "}\n";
   }

   public String disableButton(Vector bttn) {
     StringBuffer result = new StringBuffer(1000);
     for (Enumeration b=bttn.elements(); b.hasMoreElements();)
       result.append(disableButton((String) b.nextElement()));
     return result.toString();
   }

   public String disableButton(String bttn) {
     StringBuffer result = new StringBuffer(1000);
     result.append("if (parent.buttons.buttonForm."+bttn+"Button) {\n");
     result.append("  parent.buttons.buttonForm."+bttn+"Button.disabled=false;\n");
     result.append("  parent.buttons.buttonForm."+bttn+"Button.className='disabled';\n");
     result.append("  parent.buttons.buttonForm."+bttn+"Button.id='disabled';\n");
     result.append(bttn+"Button=true;\n");
     result.append("}\n");
     return result.toString();
   }

   public String enableButton(Vector bttn) {
     String result = "";
     for (Enumeration b=bttn.elements(); b.hasMoreElements();)
       result += enableButton((String) b.nextElement());
     return result;
   }

   public String enableButton(String bttn) {
        StringBuffer result = new StringBuffer(1000);

        result.append("if (parent.buttons.buttonForm."+bttn+"Button) {\n");
        result.append("  parent.buttons.buttonForm."+bttn+"Button.disabled=false;\n");
        result.append("  parent.buttons.buttonForm."+bttn+"Button.className='enabled';\n");
        result.append("  parent.buttons.buttonForm."+bttn+"Button.id='enabled';\n");
        result.append(bttn+"Button=false;\n");
        result.append("}\n");
        return result.toString();
   }

   public String getChecked(String form) {
     return getChecked(form, null);
   }

   public String getChecked(String form, String startWith)
   {
     StringBuffer result = new StringBuffer(1000);
     String[] currSelected = null;
     if (selectedParm != null)
     {
         currSelected = Util.tokenize(selectedParm,",");
     }

     result.append("function getChecked() {\n");
     result.append("  var checkeds = new Vector;\n");

     // Add these items to the checked javascript array
     if (currSelected != null && currSelected.length >= 1 && !currSelected[0].equals("SELECTED"))
     {
        for (int i=0;i < currSelected.length;i++)
        {
            result.append("    checkeds.addElement(\"" + currSelected[i] +"\");\n");
        }
     }

     // Check rows which have been selected on previous visits to this page and select if they
     // have been selected
     // This depends on the scroll control frame calling the getChecked function when it loads so the
     // pre-population can happen.
     result.append("  if (!isFrameLoaded()) {\n");
     result.append("    for (var i=0; i<document."+form+".elements.length; i++) {\n");
     result.append("      var e = document."+form+".elements[i];\n");
     result.append("      if (e.type == 'checkbox') {\n");
  	 result.append("        if (e.name != 'select_deselect' && checkeds.contains(e.name)) {\n");
     result.append("          e.checked = true;\n");
     result.append("        }\n");
     result.append("      }\n");
     result.append("    }\n");

     result.append("    setFrameLoaded(true);\n");
     result.append("    return checkeds.container;\n");
     result.append("  }\n");


     // add the new items that have just been selected
     result.append("  for (var i=0; i<document."+form+".elements.length; i++) {\n");
     result.append("    var e = document."+form+".elements[i];\n");
     if (startWith == null) {
       result.append("    if (e.type == 'checkbox') {\n");
     }
     else {
       result.append("    if (e.type == 'checkbox' && e.name.indexOf('"+startWith+"') != -1) {\n");
     }

     // If the row hasn't allready been added to the list (it ihas been newly selected)
     // add it to the list otherwise delete it from the list
     result.append("      if (e.name != 'select_deselect' && e.checked && !checkeds.contains(e.name)) {\n");
     result.append("        checkeds.addElement(e.name);\n");
     result.append("      }\n");
     result.append("      if (e.name != 'select_deselect' && !e.checked && checkeds.contains(e.name)) {\n");
     result.append("        checkeds.removeElement(e.name);\n");
     result.append("      }\n");
     result.append("    }\n");
     result.append("  }\n");
     result.append("  return checkeds.container;\n");
     result.append("}\n");
     return result.toString();
   }


   public String selectDeselectAll(String form) {
     StringBuffer result = new StringBuffer(1000);

     result.append("function selectDeselectAll() {\n");
     result.append("  for (var i=0; i<document."+form+".elements.length; i++) {\n");
     result.append("     var e = document."+form+".elements[i];\n");
     result.append("     if (e.name != 'select_deselect') {\n");
     result.append("       e.checked = document."+form+".select_deselect.checked;\n");
     result.append("     }\n");
     result.append("  }\n");
     result.append("  refreshButtons();\n");
     result.append("}\n");
     return result.toString();
   }

   /*
   ** getHelp()
   */
   public String getHelp() {
     StringBuffer result = new StringBuffer(1000);

     result.append("function getHelp() {\n");
     result.append("    return '" +action.get("helpKey")+ "';\n");
     result.append("}\n");
     return result.toString();
   }

   /**
   * generate javascript functions to refresh the buttons
   * The string length is now obselete with the new selectall/deselectall button
   */
   public String refreshButtons()
   {
        return generateRefreshFunctions(null);
   }


   /**
   * generate javascript functions to refresh the buttons
   *
   * @param total A javascript string which at runtime will evaluate to the total number of elements
   *              in the list
   * @deprecated
   */
   public String refreshButtons(String total)
   {
        return generateRefreshFunctions(total);
   }

   /**
   * generate javascript functions to refresh the buttons
   *
   * @param total The total number of elements in the list
   * @deprecated
   */
   public String refreshButtons(int total)
   {
        return generateRefreshFunctions(String.valueOf(total));
   }

   public String generateRefreshFunctions(String resultsSize)
   {
     StringBuffer sb = new StringBuffer(100);

     // currently this is the only function which is called when a checkbox is selected/deselected
     // In the future, we should have a onCheckBoxSelection() function which does this refresh of the
     // buttons as well as refreshes the checked list and anthing else that needs to happen
     sb.append("function refreshButtons() {\n");
     sb.append("  var numberOfSelected = getChecked().length;\n");
     sb.append("  if (numberOfSelected == 1) {\n");
     sb.append(        enableButton(singleSelection));
     sb.append("  }\n");
     sb.append("  else {\n");
     sb.append(        disableButton(singleSelection));
     sb.append("  }\n");
     sb.append("  if (numberOfSelected >= 1) {\n");
     sb.append(        enableButton(multipleSelection));
     sb.append("  }\n");
     sb.append("  else {\n");
     sb.append(        disableButton(multipleSelection));
     sb.append("  }\n");
     sb.append("}\n");

     return sb.toString();
   }


   public String loadFrames()  throws ECSystemException
   {
     String title = action.get("title").toString();
     String xmlSelected = null;
     if (selectedParm != null)
     {
        xmlSelected = actionXMLFileParm + "&selected=" + selectedParm;
     }
     else
     {
        xmlSelected = actionXMLFileParm;
     }
     String buttons = null ;
     if (action.get("buttons") != null)
     {
     	buttons = Util.replace(action.get("buttons").toString(),"THIS",xmlSelected);
     }

     String scrollControl = (String) action.get("scrollcontrol");
     if (scrollControl == null)
       scrollControl = "UNDEFINED";

     StringBuffer result = new StringBuffer(5000);
     result.append("var frameLoaded;\n");
     result.append("function setFrameLoaded(state) {\n");
     result.append("  frameLoaded = state;\n");
     result.append("}\n");

     result.append("function isFrameLoaded() {\n");
     result.append("  return frameLoaded;\n");
     result.append("}\n");

     result.append("function loadFrames() {\n");
     //      result.append("  " + title +";\n");
     result.append("    if (defined(parent.scrollcontrol)) { \n");
     result.append("        setFrameLoaded(false);\n");
     result.append("    } else {\n");
     result.append("      setFrameLoaded(true);\n");
     result.append("    }\n");
     result.append("    " + buttons + ";\n");
     result.append("    if (\""+scrollControl+"\" != \"UNDEFINED\"){\n");
     result.append("      " + scrollControl +"\n");
     result.append("    }\n");
     result.append("    else {\n");
     result.append("        if (defined(parent.scrollcontrol)) { \n");
     result.append("            parent.scrollcontrol.location.replace('/wcs/tools/common/blank.html');\n");
     result.append("        }\n");
     result.append("    }\n");

     result.append("}\n");
     return result.toString();
   }

   public String addActions()  throws ECSystemException
   {
     StringBuffer result = new StringBuffer(50000);
     if (menus != null) {
      for (Enumeration m=menus.elements(); m.hasMoreElements();) {
       Hashtable menu = (Hashtable)m.nextElement();
       String itemSelection = "";
       if (menu.get("selection")!= null)
         itemSelection=menu.get("selection").toString().trim();
       String itemName = menu.get("name").toString().trim();
       String itemAction = menu.get("action").toString().trim();
       itemAction = Util.replace(itemAction, "DISPLAY", "CTS="+System.currentTimeMillis()+"&DISPLAY");
       if (itemSelection.equals("multiple")) {
         if (!multipleSelection.contains(itemName))
         {
             multipleSelection.addElement(itemName);
         }
         result.append("function "+itemName+"Action() {\n");
         result.append("  var checked = getChecked();\n");
         result.append("  if (checked.length == 0) {\n");
         //result.append("    alert('" + UIUtil.toJavaScript((String)listNLS.get("selectOne")) + "');\n");
         result.append("    return;\n");
         result.append("  }\n");
         itemAction = Util.replace(itemAction, "getRefNum()", "checked.join(',')");
         result.append("  " + itemAction + "\n");
         result.append("}\n");
       } else if (itemSelection.equals("single")) {
         if (!singleSelection.contains(itemName))
         {
             singleSelection.addElement(itemName);
         }
         result.append("function "+itemName+"Action(code) {\n");
         result.append("  if (arguments.length != 0) {\n");
         String ia = Util.replace(itemAction, "getRefNum()", "code");
         result.append("    "+ia+";\n");
         result.append("    return;\n");
         result.append("  }\n");
         result.append("  var checked = getChecked();\n");
         result.append("  if (checked.length == 0) {\n");
         //result.append("    alert('" + UIUtil.toJavaScript((String)listNLS.get("selectOne")) + "');\n");
         result.append("    return;\n");
         result.append("  }\n");
         result.append("  if (checked.length > 1) {\n");
         //result.append("    alert('" + UIUtil.toJavaScript((String)listNLS.get("selectJustOne")) + "');\n");
         result.append("    return;\n");
         result.append("  }\n");
         ia = Util.replace(itemAction, "getRefNum()", "checked.join(',')");
         result.append("  "+ia+"\n");
         result.append("}\n");
       } else {
         result.append("function "+itemName+"Action() {\n");
         result.append("  "+itemAction+";\n");
         result.append("}\n");
       }
      }  // end for(menu)
     } // end for (menus !=null)
     return result.toString();
   }

   /**
   * generate javascript functions to perform the scroll controll functions on the list
   *
   * @param formName    The name of the html form containing the list
   * @param resultssize The total number of elements in the list
   */
   String addScrolling(String formName, int resultssize)
   {
        return getScrollControlFunctions(formName,String.valueOf(resultssize));
   }

   /**
   * generate javascript functions to perform the scroll controll functions on the list
   *
   * @param formName    The name of the html form containing the list
   * @param resultssize A javascript string which at runtime will evaluate to the total number of elements
   *                    in the list
   */
   String addScrolling(String formName, String resultssize)
   {
        return getScrollControlFunctions(formName,resultssize);
   }

   String getScrollControlFunctions(String formName, String resultssize) {

     // -- used for scalability issues (next, prev, parent, bottom)

     StringBuffer result = new StringBuffer(400);  // with initial size of 400 chars

     result
       .append("//submits the form, and browses to the next, prev, parent or bottom of the list, depending on the value of type\n")
       .append("  function gotoindex(type){ \n")
       .append("    var startindex = " + getStartIndex() +";\n")
       .append("    var listsize = " + getListSize() +";\n")
       .append("    if (type == 'next') {\n")
       .append("      startindex = startindex+listsize;\n")
       .append("      if (startindex >= "+resultssize+") return;\n")
       .append("    }\n")
       .append("    if (type == 'prev') {\n")
       .append("      if (startindex == 0) return;\n")
       .append("      else {\n")
       .append("            startindex -= listsize;\n")
       .append("            if (startindex < 1) startindex =0;\n")
       .append("      }\n")
       .append("    }\n")
       .append("    if (type == 'top') {\n")
       .append("            if (startindex == 0) return;\n")
       .append("            startindex = 0;\n")
       .append("    }\n")
       .append("    if (type == 'bottom') {\n")
       .append("            startindex = "+resultssize+" - listsize;\n")
       .append("            if (startindex < 1) startindex = 1;\n")
       .append("    }\n")
       .append("    document."+formName+".startindex.value = startindex;\n")
       .append("    document."+formName+".selected.value = getChecked().join(\",\");\n")
       .append("    document."+formName+".submit();\n")
       .append("  }\n\n")

       .append("  //returns the total number of elements in the resultset\n")
       .append("  function getResultsSize() {\n")
       .append("    return "+resultssize+";\n")
       .append("  }\n")

       .append("  //returns the maximum number of elements to be displayed on one page\n")
       .append("  function getListSize() {\n")
       .append("    return "+getListSize()+";\n")
       .append("  }\n")
       .append("  //returns the starting index of the subset\n")
       .append("  function getStartIndex() {\n")
       .append("    return "+getStartIndex()+";\n")
       .append("  }\n\n")

       .append("  //returns the refnum passed from the URL\n")
       .append("  function getRefNum() {\n")
       .append("         return "+getRefNum()+";\n")
       .append("  }\n\n")

       .append("  //returns the total number of selected elements\n")
       .append("  function getCheckedSize() {\n")
       .append("         return getChecked().length;\n")
       .append("  }\n\n");

    return result.toString();
   }


   /**
    * getShrinkStr(<string>) -- Shrinks the passed in string to a smaller size if necessary.
    * MPG-XML Parameters:
    *                                       1. strSize              -- Shrunk string size (optional, default=30)
    *                                       2. charOnRight -- Number of characters to the right of the separator
    *                                               (optional, default=0)
    *
    * Returns:              shrunk string
    ****************************************************************************************/
   String getShrinkString(String menuName)
   {
     StringBuffer result = new StringBuffer(200);

     result
       .append("  function shrinkStr(initialStr)\n")
       .append("  {\n")
       .append("    var strSize = 30, charOnRight = 0, strSeparator = \"...\"\n");

     if (menuName == null)
     {
        if ( action.get("strSize") != null)
        {
          result.append("  strSize = "+(String)action.get("strSize")+"\n");
        }
        if ( action.get("charOnRight") != "null")
        {
          result.append("  charOnRight = "+(String)action.get("charOnRight")+"\n");
        }
     }
     else
     {
       Enumeration m=menus.elements();
       while ( m.hasMoreElements()) {
         Hashtable menu = (Hashtable)m.nextElement();
         String mName = (String) menu.get("name");
         if (mName.equals(menuName))
         {
           if ( menu.get("strSize") != null)
           {
             result.append("  strSize = "+(String)menu.get("strSize")+"\n");
           }
           if ( menu.get("charOnRight") != "null")
           {
             result.append("  charOnRight = "+(String)menu.get("charOnRight")+"\n");
           }
         }
       }
     }

     result
       .append(" // alert (\"values 1.\"+initialStr+\"(2.)\"+strSize+\"(3.)\"+charOnRight+\"(4.)\"+strSeparator)\n")
       .append("     if (initialStr == null)\n")
       .append("             return initialStr\n")
       .append("     if (isNaN(strSize) || strSize < 0)\n")
       .append("             return initialStr\n")
       .append("     if (strSize < strSeparator.length+2)\n")
       .append("             return initialStr\n")
       .append("     if (isNaN(charOnRight) || charOnRight >strSize-3 || charOnRight <0)\n")
       .append("             charOnRight = 0\n\n")
       .append("     if (initialStr.length <= strSize)\n")
       .append("             return initialStr\n")
       .append("     var modifiedStr = initialStr.substr(0,strSize-strSeparator.length-charOnRight) + strSeparator\n")
       .append("     modifiedStr += initialStr.substr(initialStr.length-charOnRight,initialStr.length)\n")
       .append("     return modifiedStr\n")
       .append("   }\n");

     return result.toString();
   }



public String addCommonMessages()
{
    StringBuffer result = new StringBuffer(1000);
    result.append("function getDeleteAllMessages() {\n");
    result.append("    return \"" + UIUtil.toJavaScript((String)listNLS.get("deleteAll")) +"\";\n");
    result.append("}\n");

    result.append("function getDeleteOneMessage() {\n");
    result.append("    return \"" + UIUtil.toJavaScript((String)listNLS.get("deleteOne")) +"\";\n");
    result.append("}\n");

    result.append("function getCreateMessages() {\n");
    result.append("    return \"" + UIUtil.toJavaScript((String)listNLS.get("createItem")) +"\";\n");
    result.append("}\n");

    result.append("function getEmptyListMessage() {\n");
    result.append("    return \"" + UIUtil.toJavaScript((String)listNLS.get("emptyList")) +"\";\n");
    result.append("}\n");
    return result.toString();
}

%>

<%
   singleSelection = new Vector();
   multipleSelection = new Vector();

  	com.ibm.commerce.server.JSPHelper jspHelper = new JSPHelper(request);

   orderByParm = jspHelper.getParameter("orderby");
   selectedParm = jspHelper.getParameter("selected");
   startindexParm = jspHelper.getParameter("startindex");
   listsizeParm = jspHelper.getParameter("listsize");
   actionXMLFileParm = jspHelper.getParameter("ActionXMLFile");
   refnumParm = jspHelper.getParameter("refnum");
   
   //227736
   if (selectedParm!=null && (selectedParm.indexOf("<")!=-1 || selectedParm.indexOf(">")!=-1)){
      selectedParm = null;
   }
   if (refnumParm!=null && (refnumParm.indexOf("<")!=-1 || refnumParm.indexOf(">")!=-1)){
      refnumParm = null;
   }   

   commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);

   // framework needs to initialize the XMLFileDirectory first
   Hashtable actionXML = (Hashtable)ResourceDirectory.lookup(actionXMLFileParm);

   action = (Hashtable) actionXML.get("action");
   menus = Util.convertToVector(action.get("menu"));
   listNLS = (Hashtable)ResourceDirectory.lookup("common.listNLS",getLocale());
%>

