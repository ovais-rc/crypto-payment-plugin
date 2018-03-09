<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*"%>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.reporting.reports.*" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.command.CommandContext"%>
<%@page import="com.ibm.commerce.utils.TimestampHelper"%>
<%@page import="com.ibm.commerce.server.ECConstants"%>
<%@page import="com.ibm.commerce.tools.util.*"%>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.price.beans.FormattedMonetaryAmountDataBean" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@page import="javax.servlet.http.*"%>


<%!
   com.ibm.commerce.common.objects.StoreAccessBean aStoreAccessBean = null;
   ReportDataBean aReportDataBean = new ReportDataBean();
   CommandContext cmdContext = null;
   Hashtable parameterObject =  new Hashtable();
   Vector columnAttributes = new Vector();
   Hashtable currentColumnAttributes = null;

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
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
   	 //  System.out.println("columnKey = " + currentColumnAttributes.get("columnKey"));

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

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Display the report data in table format
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String generateOutputTable(String reportPrefix, Hashtable reportsRB, Locale locale)
   {
      StringBuffer buff = new StringBuffer("");
      
      int rowsInResult = aReportDataBean.getNumberOfRows();
      int firstRow = 0;
	  int numOfColumns = columnAttributes.size();
	  String rowColumnEntry = null;

	  // Begin constructing the summary table.
      buff.append("<TABLE CELLSPACING=0 CELLPADDING=0>\n");
  
      if(rowsInResult == 0) {
         buff.append("<P alian=center><B>");
         buff.append((String) reportsRB.get("ReportOutputViewNoDataRetrieved"));
         buff.append("</B></P>");
         // In this case it indicates a failure of the SQL rather than a lack of records
         buff.append("</TABLE>");
         return buff.toString();
      }
      if(rowsInResult > 1){
      	// This report is only designed for one row to be returned from the database - this is an error condition.
      }
      else{
      	  for (int a=0; a<numOfColumns; a++){

		  buff.append("<TR>\n");
		  buff.append("<TH WIDTH=" + (String) parameterObject.get("spaceBetweenColumns") + ">&nbsp;</TH>\n");
		  buff.append("<TH NOWRAP VALIGN=BOTTOM ALIGN=LEFT><u>");
		  
		  currentColumnAttributes = (Hashtable) columnAttributes.elementAt(a);		  		  
	  	  rowColumnEntry = aReportDataBean.getValue(firstRow, getColumnKey());
 		  buff.append((String)reportsRB.get(getColumnName()));
 		  
		  buff.append("</u></TH><TH WIDTH=" + (String) parameterObject.get("spaceBetweenColumns") + " NOWRAP>&nbsp;</TH>\n");
		  buff.append("<TH WIDTH=" + (String) parameterObject.get("spaceBetweenColumns") + ">&nbsp;</TH>\n");
		  buff.append("<TD>\n"); 
		  
          buff.append(formatColumnEntry(firstRow, currentColumnAttributes, reportsRB, rowColumnEntry, locale));
		  buff.append("</TD>\n"); 
		    	  
		  buff.append("</TR>\n");
	 	 }
	   }
	  
      buff.append("</TABLE>\n");

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
         if ( getColumnType().equalsIgnoreCase("currency") ) {
            value = "0";
         } else 
            return "";
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

%>


<HTML>
<HEAD>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
</HTML>
