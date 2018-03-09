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
<%@ page import="com.ibm.commerce.price.utils.MonetaryAmount" %>
<%@page import="javax.servlet.http.*"%>


<%!
   com.ibm.commerce.common.objects.StoreAccessBean aStoreAccessBean = null;
   ReportDataBean aReportDataBean = new ReportDataBean();
   CommandContext cmdContext = null;
   Hashtable parameterObject =  new Hashtable();
   Vector columnAttributes = new Vector();
   Hashtable currentColumnAttributes = null;
   private final static boolean DEBUG_ON = false;
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Retrieve a single entry of data
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private void setColumnAttributes()
   {
      Hashtable columnDefaultAttributes = (Hashtable) parameterObject.get("columnDefaultAttributes");

      Vector columns = (Vector) parameterObject.get("columns");

      if (columnAttributes != null) 
      {
      	columnAttributes.removeAllElements();
      }
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
      if (getDisplayInReport().equalsIgnoreCase("false")){
       return;
      }

      result.append("<td " + getColumnOptions() + ">");
      result.append(formatColumnEntry(iRowNumber, currentColumnAttributes, reportsRB, rowColumnEntry, locale));
      result.append("</td><td>&nbsp;</td>" + System.getProperty("line.separator"));
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Retrieve a single row of data
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String retrieveRowString(Hashtable reportsRB, int iRowNumber, Locale locale, boolean isEvenRow)
   {
      StringBuffer result = new StringBuffer();
      String rowColorClass = (isEvenRow)? "list_row1" : "list_row2";
      result.append("<tr class=" + rowColorClass + ">" + System.getProperty("line.separator"));
      for (int i=0; i<columnAttributes.size(); i++) {
         currentColumnAttributes = (Hashtable) columnAttributes.elementAt(i);
         retrieveColumnEntryString(result, reportsRB, iRowNumber, i, locale);
      }
      result.append("</tr>" + System.getProperty("line.separator"));
      return result.toString();
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Retrieve the table heading row
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String retrieveHeadingRowString(Hashtable reportsRB)
   {
      StringBuffer result = new StringBuffer();

      result.append("<tr class=list_header>" + System.getProperty("line.separator"));
      for (int i=0; i<columnAttributes.size(); i++) {
         currentColumnAttributes = (Hashtable) columnAttributes.elementAt(i);
         if (getDisplayInReport().equalsIgnoreCase("false")){
          continue;
         }
         result.append("<th " + getHeadingAlignmentOption(getColumnType()) + "><u>");
         result.append((String)reportsRB.get(getColumnName()));
         result.append("</u></th><th width=" + (String) parameterObject.get("spaceBetweenColumns") + " NOWRAP>&nbsp;</th>"+ System.getProperty("line.separator") );
      }
      result.append("</tr>" + System.getProperty("line.separator"));
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
       buff.append("   <script>" + System.getProperty("line.separator"));
       buff.append("      function printButton()" + System.getProperty("line.separator"));
       buff.append("      {" + System.getProperty("line.separator"));
       buff.append("         parent.CONTENTS.window.focus();"+ System.getProperty("line.separator"));
       buff.append("         parent.CONTENTS.window.print();" + System.getProperty("line.separator"));
       buff.append("      }" + System.getProperty("line.separator"));
       buff.append("      function cancelButton()" + System.getProperty("line.separator"));
       buff.append("      {" + System.getProperty("line.separator"));
       buff.append("         top.goBack();" + System.getProperty("line.separator"));
       buff.append("      }" +System.getProperty("line.separator"));
       buff.append("      function okButton()" + System.getProperty("line.separator"));
       buff.append("      {" + System.getProperty("line.separator"));
       buff.append("         top.goBack();" + System.getProperty("line.separator"));
       buff.append("      }" + System.getProperty("line.separator"));
       buff.append("   </script>" + System.getProperty("line.separator"));
   }
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Generates the output heading and description
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String generateOutputHeading(String reportPrefix, Hashtable reportsRB)
   {
      Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
      String reportType = (String) aReportDataBeanEnv.get("reportType");
      String reportTitle = "";
      if (reportType != null)      
      {
        if (reportType.equals("Revenue"))
        {
          reportTitle = (String)reportsRB.get(reportPrefix + "ReportRevenueDescription");
        }
        else
        {
          reportTitle = (String)reportsRB.get(reportPrefix + "ReportVolumeDescription");
        }
      }

      StringBuffer buff = new StringBuffer();
      buff.append("   <h1>" + reportsRB.get(reportPrefix + "ReportOutputViewTitle") + "</h1>" + System.getProperty("line.separator"));    
	  buff.append("   " +  reportTitle + System.getProperty("line.separator"));
      buff.append("   <p>"+System.getProperty("line.separator"));
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
      if (FulfillmentCenterNames != null) {
      	FulfillmentCenterNames = UIUtil.toHTML(FulfillmentCenterNames);
      }
      String InventoryAdjustmentCodeNames = (String) aReportDataBeanEnv.get("InventoryAdjustmentCodeNames");
      if (InventoryAdjustmentCodeNames != null) {
      	InventoryAdjustmentCodeNames = UIUtil.toHTML(InventoryAdjustmentCodeNames);
      }
      String VendorNames                  = (String) aReportDataBeanEnv.get("VendorNames");
      if(VendorNames != null) {
      	VendorNames = UIUtil.toHTML(VendorNames);
      }
      String ItemsSelected                = (String) aReportDataBeanEnv.get("ItemsSelected");
      if(ItemsSelected != null){
          ItemsSelected = UIUtil.toHTML(ItemsSelected);
      }
      String DaysWaited                   = (String) aReportDataBeanEnv.get("DaysWaited");
      String StartDate                    = (String) aReportDataBeanEnv.get("StartDate");
      String EndDate                      = (String) aReportDataBeanEnv.get("EndDate");
      String Days                         = (String) aReportDataBeanEnv.get("Days");
      String Percentage                   = (String) aReportDataBeanEnv.get("Percentage");
      String accountListNames             = (String) aReportDataBeanEnv.get("accountListNames");
      if(accountListNames != null) {
      	accountListNames = UIUtil.toHTML(accountListNames);
      }
      String ContractListNames            = (String) aReportDataBeanEnv.get("ContractListNames");
      if(ContractListNames != null) {
      	ContractListNames = UIUtil.toHTML(ContractListNames);
      }
      Timestamp currentTime = TimestampHelper.getCurrentTime();

      buff.append("   <div id=pageBody style=\"display: block; margin-left: 20\">" + System.getProperty("line.separator"));

      if (accountListNames != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaAccountListNamesTitle") + "</b> ");
         buff.append(accountListNames + "<br>");
      }
      if (ContractListNames != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaContractListNamesTitle") + "</b> ");
         buff.append(ContractListNames + "<br>");
      }

      if (FulfillmentCenterNames != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaFFCTitle") + "</b> ");
         buff.append(FulfillmentCenterNames + "<br>");
      }

      if (InventoryAdjustmentCodeNames != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaIACTitle") + "</b> ");
         buff.append(InventoryAdjustmentCodeNames + "<br>");
      }

      if (VendorNames != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaVendorTitle") + "</b> ");
         buff.append(VendorNames + "<br>");
      }

      if (ItemsSelected != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaItemTitle") + "</b> ");
         buff.append(ItemsSelected + "<br>");
      }

      if (DaysWaited != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaDaysTitle") + "</b> ");
         buff.append(NumberFormat.getNumberInstance(locale).format(Long.valueOf(DaysWaited)) + "<br>");
      }

      if (Days != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaDayTitle") + "</b> ");
         buff.append(NumberFormat.getNumberInstance(locale).format(Long.valueOf(Days)) + " " +
                      reportsRB.get("ReportDays")  + "<br>");
      }
      if (Percentage != null) {
         buff.append("<b>" + reportsRB.get(reportPrefix + "ReportInputCriteriaPercentageTitle") + "</b> ");
         buff.append(NumberFormat.getNumberInstance(locale).format(Long.valueOf(Percentage))  + "%"+"<br>");
      }

      if (StartDate != null) {
         buff.append("<b>" + reportsRB.get("RBDReportRevenueColumnTitle1") + "</b> : ");
         buff.append(getFormattedDate(StartDate,locale) + "<br>");
         buff.append("<b>" + reportsRB.get("RBDReportRevenueColumnTitle2") + "</b> : ");
         buff.append(getFormattedDate(EndDate,locale) + "<br><br>");
      }

      buff.append("<b>" + reportsRB.get(reportPrefix + "ReportOutputViewRunDateTitle") + "</b> ");
      buff.append((String) TimestampHelper.getDateFromTimestamp(currentTime, locale) + " ");
      buff.append((String) TimestampHelper.getTimeFromTimestamp(currentTime) + "<br>");
      buff.append("   </div>" +System.getProperty("line.separator") + "  <br><br>" + System.getProperty("line.separator"));

      return buff.toString();
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // Display the report data in table format
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String generateOutputTable(String reportPrefix, Hashtable reportsRB, Locale locale)
   {
      StringBuffer buff = new StringBuffer("");
      int count = aReportDataBean.getNumberOfRows();

      buff.append("<table cellspacing=0 cellpadding=0>" + System.getProperty("line.separator"));
      buff.append(retrieveHeadingRowString(reportsRB));

      boolean evenRow = true;
      for (int i=0; i<count; i++) {
         buff.append(retrieveRowString(reportsRB, i, locale, evenRow));
         evenRow = !evenRow;
      };

      buff.append("</table>" + System.getProperty("line.separator"));
      if(count == 0) {
         buff.append("<p alian=center><b>");
         buff.append((String) reportsRB.get("ReportOutputViewNoDataRetrieved"));
         buff.append("</b></p>");
      }
    return buff.toString();
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // This function generates html elements that appear between the <head> and </head> tags
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
       if (DEBUG_ON) {
            System.out.println("Can't get store... unable to continue.");
          }
		return "";
       }
       ///////////////////////////////////////////////////////////////////////////////////////////////////////
       // Generate the reporting data bean
       ///////////////////////////////////////////////////////////////////////////////////////////////////////
       try {
       	aReportDataBean.setRequestProperties(null);
       } catch (Exception ex) {
          if (DEBUG_ON) {
	          System.out.println("Cannot set requestProperties to null ...");
	      }
       }

       DataBeanManager.activate(aReportDataBean, request);

       //Hashtable aReportDataBeanEnv = aReportDataBean.getEnv();
       parameterObject = (Hashtable) aReportDataBean.getUserDefinedParameters();

       if (parameterObject.isEmpty()) {
         if (DEBUG_ON) {
          	System.out.println("Parameter Object is empty... unable to continue.");
          }
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
       buff.append("<style type='text/css'>");
       buff.append((String) parameterObject.get("THStyle"));
       buff.append((String) parameterObject.get("TDStyle"));
       buff.append("</style>");

       // generate title
       buff.append("   <title>" + reportsRB.get(reportPrefix + "ReportOutputViewTitle") + "</title>" + System.getProperty("line.separator"));

       // generate print and cancel button handle javascript functions
       generatePrintCancelButtonHandlers(buff);
       return buff.toString();
    }



   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // format the column entry string based on its data type
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   private String formatColumnEntry(int rowIndex, Hashtable tmpcurrentColumnAttributes, Hashtable reportsRB, String value, Locale locale)
   {
      if (value == null) {
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
      String mappedKey =  getColumnAttribute(value);
      if(mappedKey == null) {
      	return (String) reportsRB.get("ReportOutputViewEnumerationValueUndefined");
      }
      else return (String) reportsRB.get(mappedKey);
   }

   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // returns the formatted currency value
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   public String getFormattedAmount(String value, int rowIndex)
   {
      if (value == null || value == ""){
       return "";
      }

      BigDecimal amount = new BigDecimal(value);
      try {
   // get currency symbol
      String currencySymbolColumn = getColumnAttribute("currency");
      if (DEBUG_ON) System.out.println("Got column for currency: " + currencySymbolColumn);
      String currencySymbol = null;
      if (currencySymbolColumn == null) {
         currencySymbol  = cmdContext.getCurrency();
      } else {
         int columnIndex = Integer.parseInt(currencySymbolColumn.substring(1));  // ignore first char which is 'C'
         currencySymbol = aReportDataBean.getValue(rowIndex, columnIndex);
         if (DEBUG_ON) System.out.println("Got currency symbol for value "+ value + " is " + currencySymbol);
      }

   // formartting
         MonetaryAmount monetaryAmount = new MonetaryAmount(amount, currencySymbol);
         FormattedMonetaryAmountDataBean formattedAmount = new FormattedMonetaryAmountDataBean(monetaryAmount, aStoreAccessBean, cmdContext.getLanguageId());
	 return formattedAmount.toString();
      } catch (Exception exc) {
         return "";
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
            if (setMinimumIntegerDigits != null){
              nf.setMinimumIntegerDigits(Integer.parseInt(setMinimumIntegerDigits));
            }
            if (setMaximumIntegerDigits != null){
              nf.setMaximumIntegerDigits(Integer.parseInt(setMaximumIntegerDigits));
            }
            return nf.format(Long.valueOf(value));
         } else {
            nf.setParseIntegerOnly(false);
            if (setMinimumIntegerDigits != null) {
              nf.setMinimumIntegerDigits(Integer.parseInt(setMinimumIntegerDigits));
             }
            if (setMaximumIntegerDigits != null) {
             nf.setMaximumIntegerDigits(Integer.parseInt(setMaximumIntegerDigits));
            }
            if (setMinimumFractionDigits != null) {
            	nf.setMinimumFractionDigits(Integer.parseInt(setMinimumFractionDigits));
            }
            if (setMaximumFractionDigits != null) {
            	nf.setMaximumFractionDigits(Integer.parseInt(setMaximumFractionDigits));
            }
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
     String dateValue = value.trim();
     String timestampValueString = " 00:00:01.000000000";
     int timeIndex = dateValue.indexOf(' ');
     if( timeIndex < 0) {  // non java time stamp format
        timeIndex = dateValue.indexOf('.');
        if (timeIndex < 0) {
           timeIndex = dateValue.length();			// no time part
        } else {
           timeIndex = dateValue.lastIndexOf('-'); // day-hour
        }
        dateValue = dateValue.substring(0, timeIndex) + timestampValueString; // convert to java timestamp string
     }
     return TimestampHelper.getDateFromTimestamp(ECStringConverter.StringToTimestamp(dateValue), locale);
   }


   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   // returns the formatted month
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   public String getFormattedMonth(Hashtable reportsRB, String value)
   {
      int iValue = Integer.parseInt(value);
      if (iValue < 1 || iValue > 12){
      	return "";
      }
      Vector months = new Vector();
      StringTokenizer st = new StringTokenizer((String) reportsRB.get("ReportOutputViewMonthList"));
      while (st.hasMoreTokens()) {
         months.addElement(st.nextToken());
      }
      return (String) months.elementAt(iValue-1);
   }

%>


