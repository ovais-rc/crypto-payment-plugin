<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->
<%@page import="java.util.*"%>
<%@page import="java.math.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.text.NumberFormat" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.reporting.reports.*" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.utils.TimestampHelper"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>
<%@page import="com.ibm.commerce.tools.util.*"%>
<%@page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@page import="com.ibm.commerce.price.beans.FormattedMonetaryAmountDataBean" %>
<%@page import="com.ibm.commerce.price.utils.*" %>
<%@page import="javax.servlet.http.*"%>

<%!
   com.ibm.commerce.common.objects.StoreAccessBean aStoreAccessBean = null;
   ReportDataBean aReportDataBean = new ReportDataBean();
   CommandContext cmdContext = null;
   Hashtable parameterObject =  new Hashtable();
   Hashtable totals =  new Hashtable(10);
   Vector columnAttributes = new Vector();
   Hashtable currentColumnAttributes = null;
  // boolean headerDisplayed = false;
   boolean summaryRow = false;
   String headerValue = null;

   // Retrieve a single entry of data
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private void setColumnAttributes()
   {
      Hashtable columnDefaultAttributes = (Hashtable) parameterObject.get("columnDefaultAttributes");
      Vector columns = (Vector) parameterObject.get("columns");

      if (columnAttributes != null) columnAttributes.removeAllElements();
      for (int i=0; i<columns.size(); i++) {

         Hashtable attributesHashtable = new Hashtable();
         Hashtable currentColumnHashtable = (Hashtable) columns.elementAt(i);

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Add the default column attributes from the xml file
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         for (Enumeration e=columnDefaultAttributes.keys(); e.hasMoreElements();) {
            String key = (String) e.nextElement();
            attributesHashtable.put(key, columnDefaultAttributes.get(key));
         }

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Add/overwrite the attributes with the specific column attributes from the xml file
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         for (Enumeration e=currentColumnHashtable.keys(); e.hasMoreElements();) {
            String key = (String) e.nextElement();
            attributesHashtable.put(key, currentColumnHashtable.get(key));
         }

         ////////////////////////////////////////////////////////////////////////////////////////////////////
         // Add this hashtable to the global columnAttributes Vector
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         columnAttributes.addElement(attributesHashtable);
      }
   }
 ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Retrieve a single entry of data
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private void retrieveColumnEntryString(StringBuffer result, Hashtable reportsRB, int iRowNumber, int iColumnNumber, Locale locale)
   {
      String rowColumnEntry = aReportDataBean.getValue(iRowNumber, getColumnKey());
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      // If we are not supposed to display this column then return
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      if (getDisplayInReport().equalsIgnoreCase("false")) return;
      result.append("<TD headers=\"COL"+iColumnNumber+"\" " + getColumnOptions() + ">");
	  if(summaryRow == true)
	   {
		  if(getDisplayTotal() != null && getDisplayTotal().equalsIgnoreCase("TRUE"))
		   {
			  Double key = (Double)totals.get(new Integer(iColumnNumber));
			  if(key != null)
			   {
			  rowColumnEntry = new String(key.doubleValue()+"");
			   }
			   else
			   {
				   rowColumnEntry = "";
			   }
			 }
		  result.append("<B>");
	   }
      /* for feature 38714 support dynamic report */

      if (currentColumnAttributes.containsKey("columnLink")){
          Hashtable columnlink = (Hashtable)currentColumnAttributes.get("columnLink");
          if (columnlink != null){
              result.append("<a href=\"javascript:top.setContent('");
              result.append(UIUtil.toJavaScript((String)reportsRB.get((String)columnlink.get("title"))));
              result.append("','");
              result.append((String)columnlink.get("url"));

              Vector parameterS = Util.convertToVector(columnlink.get("parameters"));
              if (parameterS !=null){
                  result.append("?");
                  String columnkey = "$" + currentColumnAttributes.get("columnKey") + "$";
                  Enumeration enum1 = parameterS.elements();
                  Hashtable aParameter = null;
			      while(enum1.hasMoreElements())
			      {
			          aParameter = (Hashtable)enum1.nextElement();
			          if(aParameter != null){
			             String name = (String)aParameter.get("name");
			             String value = (String)aParameter.get("value");
			             if(name==null || value==null){
			                //do nothing
			             }else if (value.equals("")){
			                Hashtable aReportEnv = aReportDataBean.getEnv();
			                result.append(name + "=");
			                result.append(UIUtil.toHTML((String)aReportEnv.get(name)));
			             }else if (value.equals(columnkey)){
			                 result.append(name + "=");
			                 result.append(Util.replace(value,columnkey,rowColumnEntry));
			             }else if (value.length() >0){
			                 result.append(name + "=");
			                 // result.append(value);
			                 result.append(getLinkParamterValue(iRowNumber,value));
			             }
			             result.append('&');
			          }
			      }
              }

              result.append("',true);\">");
          }
      }
      result.append(formatColumnEntry(iRowNumber, currentColumnAttributes, reportsRB, rowColumnEntry, locale));
	  if(summaryRow == true)
	   {
		  result.append("</B>");
	   }
      result.append("</TD>\n");
   }
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Resolve a parameter value for ColumnLink
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String getLinkParamterValue(int iRowNumber, String value)
   {
   		String bReturn = null;
    	if (value.length()>"$$".length() && value.indexOf("$")==0 && value.lastIndexOf("$")==(value.length()-1)){
	    	String newKey=value.substring("$".length(),value.length()-"$".length());
	    	bReturn=aReportDataBean.getValue(iRowNumber, newKey);
    	}
    	else {
	    	bReturn=value;
    	}
    	return bReturn;
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Retrieve a single row of data
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String retrieveRowString(Hashtable reportsRB, int iRowNumber, Locale locale, boolean isEvenRow)
   {
      StringBuffer result = new StringBuffer();
	  //Display Header...
  	 if(isHeaderLine(iRowNumber)== true)
     {
	   displayHeader(result,reportsRB,iRowNumber,locale);
	 }

	 //Display Details..
	 displayDetails(result,reportsRB,iRowNumber,locale);

     //Summary line..
	 if(isSummaryLine(iRowNumber) == true)
	  {
		 displaySummary(result,reportsRB, iRowNumber, locale);
	  }
      return result.toString();
   }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Retrieve the table heading row
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String retrieveHeadingRowString(Hashtable reportsRB)
   {
      StringBuffer result = new StringBuffer();

      result.append("<TR CLASS=list_header>\n");
      for (int i=0; i<columnAttributes.size(); i++) {
         currentColumnAttributes = (Hashtable) columnAttributes.elementAt(i);
         if (getDisplayInReport().equalsIgnoreCase("false")) continue;
         result.append("<TH id=\"COL"+i+"\" " + getHeadingAlignmentOption(getColumnType()) + "><u>");
         result.append((String)reportsRB.get(getColumnName()));
         result.append("</u></TH>\n");
      }
      result.append("</TR>\n");
      return result.toString();
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // get Heading Alignment Option:
   // VALIGN=BOTTOM
   // ALIGN based on column type:
   // String, enueration: LEFT
   // null or empty LEFT
   // any other type RIGHT (date, time, integer, decimal, currency)
   //
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String getHeadingAlignmentOption(String columnType){
      String alignOption = "LEFT";
      if(columnType != null) {
         if(columnType.equalsIgnoreCase("String")){
            alignOption = "LEFT";
         } else if (columnType.equalsIgnoreCase("enumeration")){
            alignOption = "LEFT";
         } else { // date, time, integer, decimal, currency
            alignOption = "RIGHT";
         }
      }
      return "NOWRAP VALIGN=BOTTOM ALIGN=" + alignOption;
   }



   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // retreive the requested attribute's value
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String getColumnAttribute(String key)
   {
      return (String) currentColumnAttributes.get(key);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // get the column name of the current column
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String getColumnName()
   {
      return (String) currentColumnAttributes.get("columnName");
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // get the column width of the current column
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String getColumnWidth()
   {
      return (String) currentColumnAttributes.get("columnWidth");
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // get the column displayinreport flag of the current column
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String getDisplayInReport()
   {
      return (String) currentColumnAttributes.get("displayInReport");
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // get the column max entry length of the current column
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String getMaxEntryLength()
   {
      return (String) currentColumnAttributes.get("maxEntryLength");
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // get the column type of the current column
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String getColumnType()
   {
      return (String) currentColumnAttributes.get("columnType");
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // get the number number of decimals
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private int getDecimal()
   {
      String decimalString = (String) currentColumnAttributes.get("decimal");
      try {
        return (new Integer(decimalString)).intValue();
      } catch (Exception ex) {
        return 0;
      }
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // get the column key of the current column
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String getColumnKey()
   {
      return (String) currentColumnAttributes.get("columnKey");
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // get the column options of the current column
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String getColumnOptions()
   {
      return (String) currentColumnAttributes.get("columnOptions");
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Generates the Print and Cancel button handlers
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private void generatePrintCancelButtonHandlers (StringBuffer buff)
   {
       buff.append("   <SCRIPT>\n");
       buff.append("      function printButton()\n");
       buff.append("      {\n");
       buff.append("         parent.CONTENTS.window.focus();\n");
       buff.append("         parent.CONTENTS.window.print();\n");
       buff.append("      }\n");
       buff.append("      function cancelButton()\n");
       buff.append("      {\n");
       buff.append("         top.goBack();\n");
       buff.append("      }\n");
       buff.append("      function okButton()\n");
       buff.append("      {\n");
       buff.append("         top.goBack();\n");
       buff.append("      }\n");
       buff.append("   </SCRIPT>\n");
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Generates the output heading and description
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String generateOutputHeading(String reportPrefix, Hashtable reportsRB)
   {
      StringBuffer buff = new StringBuffer();
      buff.append("   <H1>" + reportsRB.get(reportPrefix + "ReportOutputViewTitle") + "</H1>\n");
      buff.append("   " +  reportsRB.get(reportPrefix + "ReportDescription") + "\n");
      buff.append("   <p>\n");
      return buff.toString();
   }


   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Display the report input criteria
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String generateOutputInputCriteria(String reportPrefix, Hashtable reportsRB, Locale locale)
   {
      StringBuffer buff = new StringBuffer("");
      Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();

 // defect #27068 - toHTML

      String FulfillmentCenterNames       = (String) aReportDataBeanEnv.get("FulfillmentCenterNames");
      if (FulfillmentCenterNames != null) FulfillmentCenterNames = UIUtil.toHTML(FulfillmentCenterNames);
      String InventoryAdjustmentCodeNames = (String) aReportDataBeanEnv.get("InventoryAdjustmentCodeNames");
      if (InventoryAdjustmentCodeNames != null) InventoryAdjustmentCodeNames = UIUtil.toHTML(InventoryAdjustmentCodeNames);
      String VendorNames                  = (String) aReportDataBeanEnv.get("VendorNames");
      if(VendorNames != null)             VendorNames = UIUtil.toHTML(VendorNames);
      String ItemsSelected                = (String) aReportDataBeanEnv.get("ItemsSelected");
      if(ItemsSelected != null)           ItemsSelected = UIUtil.toHTML(ItemsSelected);
      String DaysWaited                   = (String) aReportDataBeanEnv.get("DaysWaited");
      String StartDate                    = (String) aReportDataBeanEnv.get("StartDate");
      String EndDate                      = (String) aReportDataBeanEnv.get("EndDate");
      String Days                         = (String) aReportDataBeanEnv.get("Days");
      String Percentage                   = (String) aReportDataBeanEnv.get("Percentage");
      String accountListNames             = (String) aReportDataBeanEnv.get("accountListNames");
      if(accountListNames != null)        accountListNames = UIUtil.toHTML(accountListNames);
      String ContractListNames            = (String) aReportDataBeanEnv.get("ContractListNames");
      if(ContractListNames != null)       ContractListNames = UIUtil.toHTML(ContractListNames);
      Timestamp currentTime = TimestampHelper.getCurrentTime();

      buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");

      if (accountListNames != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaAccountListNamesTitle") + "</b> ");
         buff.append(accountListNames + "<BR>");
      }
      if (ContractListNames != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaContractListNamesTitle") + "</b> ");
         buff.append(ContractListNames + "<BR>");
      }

      if (FulfillmentCenterNames != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaFFCTitle") + "</b> ");
         buff.append(FulfillmentCenterNames + "<BR>");
      }

      if (InventoryAdjustmentCodeNames != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaIACTitle") + "</b> ");
         buff.append(InventoryAdjustmentCodeNames + "<BR>");
      }

      if (VendorNames != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaVendorTitle") + "</b> ");
         buff.append(VendorNames + "<BR>");
      }

      if (ItemsSelected != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaItemTitle") + "</b> ");
         buff.append(ItemsSelected + "<BR>");
      }

      if (DaysWaited != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaDaysTitle") + "</b> ");
         buff.append(NumberFormat.getNumberInstance(locale).format(Long.valueOf(DaysWaited)) + "<BR>");
      }

      if (Days != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaDayTitle") + "</b> ");
         buff.append(NumberFormat.getNumberInstance(locale).format(Long.valueOf(Days)) + " " +
                      reportsRB.get("ReportDays")  + "<BR>");
      }
      if (Percentage != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaPercentageTitle") + "</b> ");
         buff.append(NumberFormat.getNumberInstance(locale).format(Long.valueOf(Percentage))  + "%"+"<BR>");
      }

      if (StartDate != null) {
         buff.append("<b>" + reportsRB.get("ReportOutputViewReturnSelectedDateRange") + "</b> ");
         buff.append(getFormattedDate(StartDate,locale) + " ");
         buff.append("<b>" + reportsRB.get("ReportOutputViewReturnSelectedDateRangeTo") + "</b> ");
         buff.append(getFormattedDate(EndDate,locale) + "<BR>");
      }
      buff.append("<b>" + reportsRB.get(reportPrefix + "ReportOutputViewRunDateTitle") + "</b> ");
      buff.append((String) TimestampHelper.getDateFromTimestamp(currentTime, locale) + " ");
      buff.append((String) TimestampHelper.getTimeFromTimestamp(currentTime) + "<BR>");
      buff.append("   </DIV>\n   <BR><BR>\n");

      return buff.toString();
   }

     private String generateSpecificOutputInputCriteria(String reportPrefix, Hashtable reportsRB, Locale locale)
   {
      StringBuffer buff = new StringBuffer("");
      Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();

      String StartDate                    = (String) aReportDataBeanEnv.get("StartDate");
      String EndDate                      = (String) aReportDataBeanEnv.get("EndDate");
	  String ReportType					  = (String) aReportDataBeanEnv.get("ReportType");
      Timestamp currentTime = TimestampHelper.getCurrentTime();

      buff.append("   <DIV ID=pageBody STYLE=\"display: block; margin-left: 20\">\n");
	  if (ReportType != null && ReportType.equals("UserInput"))
      {
		  if (StartDate != null)
		  {
		     buff.append("<b>" + reportsRB.get("ReportOutputViewReturnSelectedDateRange") + "</b> ");
	         buff.append(getFormattedDate(StartDate,locale) + " ");
		     buff.append("<b>" + reportsRB.get("ReportOutputViewReturnSelectedDateRangeTo") + "</b> ");
	         buff.append(getFormattedDate(EndDate,locale) + "<BR>");
		  }
	  }
	  else if(ReportType != null && ReportType.equals("Predefined"))
	   {
		  String timePeriod = (String) aReportDataBeanEnv.get("Time");
		  buff.append("<b>" + reportsRB.get("Report") + ":</b>  " + timePeriod + "<br>\n");
	   }
	  buff.append("<b>" + reportsRB.get(reportPrefix + "ReportOutputViewRunDateTitle") + "</b> ");
	  buff.append((String) TimestampHelper.getDateFromTimestamp(currentTime, locale) + " ");
	  buff.append((String) TimestampHelper.getTimeFromTimestamp(currentTime) + "<BR>");
	  buff.append("   </DIV>\n   <BR><BR>\n");
      return buff.toString();
   } ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Display the report data in table format
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String generateOutputTable(String reportPrefix, Hashtable reportsRB, Locale locale)
   {
	  StringBuffer buff = new StringBuffer("");
      int count = aReportDataBean.getNumberOfRows();
      buff.append("<TABLE border = 1 frame = all CELLSPACING=0 CELLPADDING=3>\n");
      buff.append(retrieveHeadingRowString(reportsRB));
      boolean evenRow = true;
      for (int i=0; i<count; i++) {
         buff.append(retrieveRowString(reportsRB, i, locale, evenRow));
         evenRow = !evenRow;
      };
      buff.append("</TABLE>\n");
      headerValue = null;
      if(count == 0) {
         buff.append("<P alian=center><B>");
         buff.append((String) reportsRB.get("ReportOutputViewNoDataRetrieved"));
         buff.append("</B></P>");
      }
	return buff.toString();
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // This function generates html elements that appear between the <HEAD> and </HEAD> tags
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String generateHeaderInformation(String reportPrefix, Hashtable reportsRB, HttpServletRequest request) throws ServletException
   {

       ///////////////////////////////////////////////////////////////////////////////////////////////////////
       // Generate the store data bean
       ///////////////////////////////////////////////////////////////////////////////////////////////////////
       cmdContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
       try {
          aStoreAccessBean = cmdContext.getStore();
       } catch (Exception ex) {
          System.out.println("Can't get store... unable to continue.");
          return "";
       }
       ///////////////////////////////////////////////////////////////////////////////////////////////////////
       // Generate the reporting data bean
       ///////////////////////////////////////////////////////////////////////////////////////////////////////
       try {
       	  aReportDataBean.setRequestProperties(null);

          // d96171 - Reset ViewCommandContext, so that DataBeanManager will set the latest ViewCommandContext from the request.
          aReportDataBean.setViewCommandContext(null);
       } catch (Exception ex) {
          System.out.println("Cannot set requestProperties to null ...");
       }

       DataBeanManager.activate(aReportDataBean, request);
       Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
       parameterObject = (Hashtable) aReportDataBean.getUserDefinedParameters();
       if (parameterObject.isEmpty()) {
          System.out.println("Parameter Object is empty... unable to continue.");
          return "";
       }

       ///////////////////////////////////////////////////////////////////////////////////////////////////////
       // set the column attributes from the xml file
       ///////////////////////////////////////////////////////////////////////////////////////////////////////
       setColumnAttributes();

       ///////////////////////////////////////////////////////////////////////////////////////////////////////
       // use string buffer to compose output.
       ///////////////////////////////////////////////////////////////////////////////////////////////////////
       StringBuffer buff = new StringBuffer();

       // generate style sheet information
       buff.append("<STYLE type='text/css'>");
       buff.append((String) parameterObject.get("THStyle"));
       buff.append((String) parameterObject.get("TDStyle"));
       buff.append("</STYLE>");
       // generate title
       buff.append("   <TITLE>" + reportsRB.get(reportPrefix + "ReportOutputViewTitle") + "</TITLE>\n");

       // generate print and cancel button handle javascript functions
       generatePrintCancelButtonHandlers(buff);
       return buff.toString();
    }



   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // format the column entry string based on its data type
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String formatColumnEntry(int rowIndex, Hashtable currentColumnAttributes, Hashtable reportsRB, String value, Locale locale)
   {
      if (value == null || value.length() == 0) {
         // Get display string from resource bundle
         String displayIfNullKey = getColumnAttribute("columnDisplayIfNull");
         String displayIfNullStr = null;
         
         if (displayIfNullKey != null) {
             displayIfNullStr = (String) reportsRB.get(displayIfNullKey);
         }
         
         if (displayIfNullStr != null) {
             return displayIfNullStr;
         } else {
           if ( getColumnType().equalsIgnoreCase("currency") ) {
             value = "0";
           } else {
             return "";
           }
         }
      }

      value = value.trim();
      if (getColumnType().equalsIgnoreCase("date")) {
         return getFormattedDate(value, locale);
      } else if (getColumnType().equalsIgnoreCase("month")) {
         return getFormattedMonth(reportsRB, value);
      } else if (getColumnType().equalsIgnoreCase("currency")) {
         return getFormattedAmount(value, rowIndex);
      } else if(getColumnType().equalsIgnoreCase("integer")) {
         return getFormattedNumber(reportsRB, value, true, locale);
      } else if(getColumnType().equalsIgnoreCase("decimal")) {
         return getFormattedNumber(reportsRB, value, false, locale);
      } else if (getColumnType().equalsIgnoreCase("enumeration")) {
         return getMappedValue(reportsRB, value, locale);
      } else {
         /////////////////////////////////////////////////////////////////////////////////////////////////
         // If the entry is a string then truncate to the selected maximum length
       /////////////////////////////////////////////////////////////////////////////////////////////////
         int imaxEntryLength = Math.min(Integer.parseInt(getMaxEntryLength()),value.length());
         return UIUtil.toHTML(value.substring(0,imaxEntryLength));  // defect #27068 - toHtml
      }
   }

   private String getMappedValue(Hashtable reportsRB, String value, Locale locale) {

      // if the first character is digit, prefix it with "X_"
      if ( Character.isDigit(value.charAt(0)) ) {
          value = "X_" + value;
      }

      String mappedKey = (String) getColumnAttribute(value);
      if(mappedKey == null) return (String) reportsRB.get("ReportOutputViewEnumerationValueUndefined");
      else return (String) reportsRB.get(mappedKey);
   }
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // returns the formatted currency value
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   public String getFormattedAmount(String value, int rowIndex)
   {
      if (value == null || value == "") return "";

      BigDecimal amount = new BigDecimal(value);

      try {
       // get currency symbol
      String currencySymbolColumn = getColumnAttribute("currencySymbolColumn");
      String currencySymbol = null;
      Hashtable aReportEnv = aReportDataBean.getEnv();

      if (currencySymbolColumn == null) {
         if (aReportEnv != null)
            currencySymbol = (String) aReportEnv.get("Currency"); // get "Currency" from input first
         if (currencySymbol == null)
            currencySymbol  = cmdContext.getCurrency();
      } else {
         int columnIndex = Integer.parseInt(currencySymbolColumn.substring(1));  // ignore first char which is 'C'
         currencySymbol = aReportDataBean.getValue(rowIndex, columnIndex);
      }

      if (currencySymbol == null) { // if no currency can be found, don't format
         return value;
         // System.out.println("WC Reporting Framework: no currency can be found for store " + cmdContext.getStoreId());
      }

        // formartting
         MonetaryAmount monetaryAmount = new MonetaryAmount(amount, currencySymbol);
         FormattedMonetaryAmountDataBean formattedAmount = new FormattedMonetaryAmountDataBean(monetaryAmount, aStoreAccessBean, cmdContext.getLanguageId());

      return formattedAmount.toString();
      } catch (Exception exc) {
         exc.printStackTrace();
         return "-error-";
      }
   }


   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // returns the formatted number value
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   public String getFormattedNumber(Hashtable reportsRB, String value, boolean isInteger, Locale locale)
   {

      NumberFormat nf = NumberFormat.getNumberInstance(locale);

      String setMinimumFractionDigits = (String) currentColumnAttributes.get("setMinimumFractionDigits");
      String setMaximumFractionDigits = (String) currentColumnAttributes.get("setMaximumFractionDigits");
      String setMinimumIntegerDigits  = (String) currentColumnAttributes.get("setMinimumIntegerDigits");
      String setMaximumIntegerDigits  = (String) currentColumnAttributes.get("setMaximumIntegerDigits");

      try {
         if (isInteger) {
            nf.setParseIntegerOnly(true);
            if (setMinimumIntegerDigits != null)  nf.setMinimumIntegerDigits(Integer.parseInt(setMinimumIntegerDigits));
            if (setMaximumIntegerDigits != null)  nf.setMaximumIntegerDigits(Integer.parseInt(setMaximumIntegerDigits));
            return nf.format(Long.valueOf(value));
         } else {
            nf.setParseIntegerOnly(false);
            if (setMinimumIntegerDigits != null)  nf.setMinimumIntegerDigits(Integer.parseInt(setMinimumIntegerDigits));
            if (setMaximumIntegerDigits != null)  nf.setMaximumIntegerDigits(Integer.parseInt(setMaximumIntegerDigits));
            if (setMinimumFractionDigits != null) nf.setMinimumFractionDigits(Integer.parseInt(setMinimumFractionDigits));
            if (setMaximumFractionDigits != null) nf.setMaximumFractionDigits(Integer.parseInt(setMaximumFractionDigits));
            return nf.format(Double.valueOf(value));
         }
      } catch (Exception e) {
         return (String) reportsRB.get("ReportOutputViewRunInvalidNumberOrFormat");
      }
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // returns the formatted date
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   public String getFormattedDate(String value, Locale locale)
   {
	 String dateValue = new String(value).trim();
     int timeIndex = dateValue.indexOf(' ');
     if( timeIndex < 0) {  // non java time stamp format
        timeIndex = dateValue.indexOf('.');
        if (timeIndex < 0) {
           timeIndex = dateValue.length();			// no time part
        } else {
           timeIndex = dateValue.lastIndexOf('-'); // day-hour
        }
        dateValue = dateValue.substring(0, timeIndex) + " 00:00:01.000000000"; // convert to java timestamp string
     }
     return (String) TimestampHelper.getDateFromTimestamp(ECStringConverter.StringToTimestamp(dateValue), locale);
   }


   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // returns the formatted month
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   public String getFormattedMonth(Hashtable reportsRB, String value)
   {
      int iValue = Integer.parseInt(value);
      if (iValue < 1 || iValue > 12) return "";

      Vector months = new Vector();
      StringTokenizer st = new StringTokenizer((String) reportsRB.get("ReportOutputViewMonthList"));
      while (st.hasMoreTokens()) {
         months.addElement(st.nextToken());
      }
      return (String) months.elementAt(iValue-1);
   }

   /////
   //checks whether it should be displayed as header or not..
   /////
   private String getDisplayInHeader()
   {
	  return (String) currentColumnAttributes.get("displayInHeader");
   }

   private String getDisplayTotal()
   {
	  return (String) currentColumnAttributes.get("displayTotal");
   }

   /////
   //checks whether it should be displayed as summary or not..
   /////
   private String getDisplayInSummary()
   {
	  return (String) currentColumnAttributes.get("displayInSummary");
   }


  	   ////////////////////////////
      private boolean isSummaryLine(int iRowNumber)
      {
			//if this is the last row then return true;
			int count = aReportDataBean.getNumberOfRows() - 1;
			if(iRowNumber == count)
				return true;
	      for (int i=0; i<columnAttributes.size(); i++)
		  {
			 currentColumnAttributes = (Hashtable) columnAttributes.elementAt(i);
			 if(getDisplayInHeader() != null && getDisplayInHeader().equalsIgnoreCase("TRUE"))
			  {
				//if next row starts with a new header...
				String nextValue =
				aReportDataBean.getValue(iRowNumber+1, getColumnKey());
				String currValue =
				aReportDataBean.getValue(iRowNumber, getColumnKey());
				   if(!nextValue.equalsIgnoreCase(currValue))
					   return true;
				   else
					   return false;
			 }
		 }
		   return false;
	   }

	private void displaySummary(StringBuffer result,Hashtable reportsRB, int iRowNumber, Locale locale)
   {
	  summaryRow = true;
	  String rowColorClass =  "list_row4";
      result.append("<TR CLASS=" + rowColorClass + ">\n");
      for (int i=0; i<columnAttributes.size(); i++)
	  {
         currentColumnAttributes = (Hashtable) columnAttributes.elementAt(i);
		 if((getDisplayInSummary() != null && getDisplayInSummary().equalsIgnoreCase("TRUE")) ||
			 (getDisplayTotal() != null && getDisplayTotal().equalsIgnoreCase("TRUE")))
		  {
	         retrieveColumnEntryString(result, reportsRB, iRowNumber, i, locale);
			 //reset the totals hash map..
			 totals.put(new Integer(i), new Double(0.0));
		  }
		  else
		  {
			   result.append("<TD headers=\"COL"+i+"\" " + getColumnOptions() + ">");
			   result.append("<BR>");
			   result.append("</TD>");
		  }
      }
      result.append("</TR>\n");
	  summaryRow = false;
      return;
   }

   private boolean isHeaderLine(int iRowNumber)
   {
          for (int i=0; i<columnAttributes.size(); i++)
		  {
			 currentColumnAttributes = (Hashtable) columnAttributes.elementAt(i);
		   	String rowColumnEntry = aReportDataBean.getValue(iRowNumber, getColumnKey());
			if (getDisplayInHeader() != null && getDisplayInHeader().equalsIgnoreCase("TRUE"))
		   {
			   if(!rowColumnEntry.equalsIgnoreCase(headerValue))
			   {
    			   headerValue = new String(rowColumnEntry);
					return true;
			   }
			   else
			   {
				   return false;
			   }
		   }
		  }
		   return false;
	}

   //display header
   private void displayHeader(StringBuffer result, Hashtable reportsRB, int iRowNumber,Locale locale)
  {
		String rowColumnEntry = aReportDataBean.getValue(iRowNumber, getColumnKey());
		 result.append("<TR CLASS=" + "list_row2" + ">\n");
	      for (int i=0; i<columnAttributes.size(); i++)
		  {
			 currentColumnAttributes = (Hashtable) columnAttributes.elementAt(i);
  			result.append("<TD headers=\"COL"+i+"\" " + getColumnOptions() + ">");
			if (getDisplayInHeader() != null && getDisplayInHeader().equalsIgnoreCase("TRUE"))
    	   {
                result.append("<B>");
   				result.append(formatColumnEntry(iRowNumber, currentColumnAttributes, reportsRB, rowColumnEntry, locale));
				result.append("</B>");
  				 result.append("</TD>\n");
    			 return;
		   }
  		   else
           {
			  result.append("<BR>");
			  result.append("</TD>\n");
	 		  return;
	       }
        }
		result.append("</TR>\n");
	   return;
	   }

   private void displayDetails(StringBuffer result, Hashtable reportsRB, int iRowNumber,Locale locale)
{
      result.append("<TR CLASS=" + "list_row1" + ">\n");
     //Display Details...
      for (int i=0; i<columnAttributes.size(); i++)
	  {
         currentColumnAttributes = (Hashtable) columnAttributes.elementAt(i);
		 //total...
		 if(getDisplayTotal() != null && getDisplayTotal().equalsIgnoreCase("TRUE"))
		  {
			Double temp = (Double)totals.get(new Integer(i));
			double total = 0;
			String value = aReportDataBean.getValue(iRowNumber, getColumnKey());
			if(temp != null)
			  {
				total = temp.doubleValue() + Double.parseDouble(value);
			  }
			  else
			  {
				  total = Double.parseDouble(value);
			  }
		    totals.put(new Integer(i),new Double(total));
		  }

          if((getDisplayInSummary() != null && getDisplayInSummary().equalsIgnoreCase("TRUE"))||
			  (getDisplayInHeader() != null && getDisplayInHeader().equalsIgnoreCase("TRUE")))
		  {
			 //just skip..
			 result.append("<TD headers=\"COL"+i+"\" " + getColumnOptions() + ">");
             result.append("<BR>");
			 result.append("</TD>\n");
		  }
		  else
		  {
  			 retrieveColumnEntryString(result, reportsRB, iRowNumber, i, locale);
		  }
      }
      result.append("</TR>\n");
	  return;
}
	   /////////////////////////////
%>
