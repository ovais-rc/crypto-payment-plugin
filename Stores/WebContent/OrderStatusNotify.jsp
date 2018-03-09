<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 1997, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%><%--
============================================================================

   The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions. IBM, therefore, cannot guarantee
reliability, serviceability or function of these programs. All programs
contained herein are provided to you "AS IS".

   The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible. All of these are names are ficticious and any similarity to the
names and addresses used by actual persons or business enterprises is entirely
coincidental.

==============================================================================
--%><%@ page import="javax.servlet.*,
java.io.*,
java.util.*,
com.ibm.commerce.server.*,
com.ibm.commerce.command.*,
com.ibm.commerce.beans.*,
com.ibm.commerce.datatype.*,
com.ibm.commerce.messaging.beans.*,
com.ibm.commerce.orderstatus.objimpl.*" %><%

try {
	JSPHelper jsphelper=new JSPHelper(request);

	String str_orderStatusID=jsphelper.getParameter(OrderFulfillmentStatusConstants.ORDER_STATUS_ID);
	Long orderStatusId = new Long(str_orderStatusID);
  if (orderStatusId == null)
  {
    out.println("orderStatusId is null");
    return;
  }

  JSPResourceBundle myResourceBundle = null;
  try
  {
    CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale jLocale = commandContext.getLocale();
	
    myResourceBundle = new JSPResourceBundle(java.util.ResourceBundle.getBundle("orderstatustext",jLocale));
  }
  catch (java.util.MissingResourceException mre)
  {
    myResourceBundle = new JSPResourceBundle();
  }
  Properties orderstatustext = new Properties();
  Enumeration rb_keys=myResourceBundle.getKeys();
  if(rb_keys==null)
  {
    out.println("No data in resource bundle");
    return;
  }
  else
  {
    String key,value;
    while(rb_keys.hasMoreElements())
    {
      key=null;
      value=null;
      key=(String)rb_keys.nextElement();
      if(key!=null)value=myResourceBundle.getString(key);
      if(value!=null)orderstatustext.setProperty(key,value);
    }
  }

  //response.setContentType(orderstatustext.getProperty("ENCODESTATEMENT"));
  response.setContentType("text/html; charset=UTF-8");
        OrderStatusDataBean osdb=new OrderStatusDataBean();
        osdb.setOrderStatusID(orderStatusId);
  //com.ibm.commerce.beans.DataBeanManager.activate(osdb, request);
  osdb.populate();
	out.println(orderstatustext.getProperty("OSN_OS_TITLE")+" : "+osdb.getMerchantOrderNumber());
	out.println("");


      // do some readings from OrderStatusDataBean here
 	out.println(orderstatustext.getProperty("OSN_OS_ASD")+" : "+osdb.getActualShipDateTime());
 	out.println(orderstatustext.getProperty("OSN_OS_CMT")+" : "+osdb.getComment());
 	out.println(orderstatustext.getProperty("OSN_OS_CURR")+" : "+osdb.getCurrency());
 	out.println(orderstatustext.getProperty("OSN_OS_INVD")+" : "+osdb.getInvoiceDateTime());
 	out.println(orderstatustext.getProperty("OSN_OS_INVV")+" : "+osdb.getInvoiceValue());
 	out.println(orderstatustext.getProperty("OSN_OS_LUPD")+" : "+osdb.getLastUpdateTime());
 	out.println(orderstatustext.getProperty("OSN_OS_MORDN")+" : "+osdb.getMerchantOrderNumber());
 	out.println(orderstatustext.getProperty("OSN_OS_ORDID")+" : "+osdb.getOrderId());
 	out.println(orderstatustext.getProperty("OSN_OS_ORDST")+" : "+osdb.getOrderStatus());
 	out.println(orderstatustext.getProperty("OSN_OS_ORDSTID")+" : "+osdb.getOrderStatusId());
 	out.println(orderstatustext.getProperty("OSN_OS_PLCDT")+" : "+osdb.getPlaceDateTime());
 	out.println(orderstatustext.getProperty("OSN_OS_TTLPRC")+" : "+osdb.getPriceTotal());
 	out.println(orderstatustext.getProperty("OSN_OS_SHPDT")+" : "+osdb.getRequestShipDateTime());
 	out.println(orderstatustext.getProperty("OSN_OS_SCHSHP")+" : "+osdb.getScheduleShipDateTime());
 	out.println(orderstatustext.getProperty("OSN_OS_SEQN")+" : "+osdb.getSequenceNumber());
 	out.println(orderstatustext.getProperty("OSN_OS_SHPCND")+" : "+osdb.getShipCondition());
 	out.println(orderstatustext.getProperty("OSN_OS_SHPMDF")+" : "+osdb.getShippingModeFlag());
 	out.println(orderstatustext.getProperty("OSN_OS_SHPTXTTL")+" : "+osdb.getShippingTaxTotal());
 	out.println(orderstatustext.getProperty("OSN_OS_SHPTTL")+" : "+osdb.getShippingTotal());
 	out.println(orderstatustext.getProperty("OSN_OS_TXTTL")+" : "+osdb.getTaxTotal());
	out.println("");
	out.println(orderstatustext.getProperty("OSN_OIS_TITLE")+" : ");


	String orderItemsIDs=jsphelper.getParameter(OrderFulfillmentStatusConstants.ITEMS_VECTOR);

if(orderItemsIDs!=null)
{
	StringTokenizer st=new StringTokenizer(orderItemsIDs,",");
	int t=st.countTokens();
	if(t>0)
	{
		OrderStatusItemDataBean osidb=new OrderStatusItemDataBean();

		for(int i=0;i<t;++i)
		{
			Long orderStatusItemId= new Long(st.nextToken());
      osidb.setOrderItemStatusID(orderStatusItemId);
      //com.ibm.commerce.beans.DataBeanManager.activate(osidb, request);
      osidb.populate();
			// do some readings from OrderStatusDataBean here
			out.println("   "+"---------------------------------------");
			out.println("   "+orderstatustext.getProperty("OSN_OIS_ACTSHPDT")+" : "+osidb.getActualShipDateTime());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_CURR")+" : "+osidb.getCurrency());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_INVDT")+" : "+osidb.getInvoiceDateTime());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_INVV")+" : "+osidb.getInvoiceValue());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_CMMNT")+" : "+osidb.getItemComment());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_MIN")+" : "+osidb.getMerchantItemNumber());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_MON")+" : "+osidb.getMerchantOrderNumber());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_ORDID")+" : "+osidb.getOrderId());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_ORDITMID")+" : "+osidb.getOrderItemId());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_ORDITMST")+" : "+osidb.getOrderItemStatus());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_ORDITMSTID")+" : "+osidb.getOrderItemStatusId());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_PRTNMBR")+" : "+osidb.getPartNumber());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_PLDT")+" : "+osidb.getPlaceDateTime());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_PRTOT")+" : "+osidb.getPriceTotal());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_QNTCONFR")+" : "+osidb.getQuantityConfirmed());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_QNTREQST")+" : "+osidb.getQuantityRequested());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_QNTSHPD")+" : "+osidb.getQuantityShipped());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_REQSHPDT")+" : "+osidb.getRequestShipDateTime());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_SCHSHPDT")+" : "+osidb.getScheduleShipDateTime());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_SHPCOND")+" : "+osidb.getShipCondition());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_SHPTXTOT")+" : "+osidb.getShippingTaxTotal());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_SHPTOT")+" : "+osidb.getShippingTotal());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_TXTOT")+" : "+osidb.getTaxTotal());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_MSRUNT")+" : "+osidb.getUnitOfMeasure());
			out.println("   "+orderstatustext.getProperty("OSN_OIS_UNTPRC")+" : "+osidb.getUnitPrice());
			out.println("   "+"---------------------------------------");


		}
	}
}

    }
catch (Exception e)
{ out.print( "Exception " + e); }
%>
