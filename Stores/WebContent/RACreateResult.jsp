<%--============================================================================

(c) Copyright IBM Corp. 1997, 2016

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp


==============================================================================--%><%@
page import="javax.servlet.*,java.io.*,java.util.*,com.ibm.commerce.server.*,
com.ibm.commerce.command.*,com.ibm.commerce.beans.*,
com.ibm.commerce.datatype.*,com.ibm.commerce.messaging.beans.*,com.ibm.commerce.messaging.util.*,
com.ibm.commerce.inventory.objects.*,
com.ibm.commerce.inventory.commands.*" %><%!

public Vector ConvertToVectorOfHashtables(String s)
{
	int startidx = s.indexOf('[');
	int endidx = s.lastIndexOf(']');
	String arr = s.substring(startidx+1, endidx -1);
	StringTokenizer stkn = new StringTokenizer(arr, ",");
	Vector vec = new Vector();

	int n = stkn.countTokens();
	
	String parmVal=null;
	String parmName=null;
	
	for (int i = 0; i < n; i++)
	{
		Hashtable h = new Hashtable();
		String hstr = stkn.nextToken();

		StringTokenizer htkn = new StringTokenizer(hstr, "\n");
		int m = htkn.countTokens();

		for (int k = 0; k < m; k++)
		{
			String tmp = htkn.nextToken();
			int l = tmp.indexOf("=");
			if (l > 0)
			{
				StringTokenizer ttkn = new StringTokenizer(tmp.substring(0, l));
				parmName = ttkn.nextToken();			
				ttkn = new StringTokenizer(tmp.substring(l + 1));
		  
				if (ttkn.hasMoreElements()) {
					parmVal = ttkn.nextToken();
				}
				else
				{
					parmVal = "";
				}
				  h.put(parmName, parmVal);
			}
		}	

	  	vec.addElement(h);
	 }
   return vec;				
}      
%><%

try {
	JSPHelper jsphelper = new JSPHelper(request);


      boolean success = true;
      String storeId = jsphelper.getParameter(InventoryConstants.STORE_ID);
      String vendorId = jsphelper.getParameter(InventoryConstants.VENDOR_ID);
      String orderDate = jsphelper.getParameter(InventoryConstants.ORDERDATE);
      String raId  = jsphelper.getParameter(InventoryConstants.RA_ID);


      String raBackendId  = null;
      try {
          raBackendId = jsphelper.getParameter("backendRaId");
      }
      catch (Exception e)
      {
      }

      String vectorStr = jsphelper.getParameter("VECTOR");
      Vector vec = ConvertToVectorOfHashtables(vectorStr);
	
   out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
   out.println("<!DOCTYPE Response_WCS_ExpectedInvRecord SYSTEM \"Response_WCS_ExpectedInvRecord_10.dtd\">");
   out.println("<Response_WCS_ExpectedInvRecord version=\"1.0\">");
   out.println("<ControlArea>");
   out.println("	<Verb value=\"Response\"> </Verb>");
   out.println("	<Noun value=\"WCS_ExpectedInventoryRecord\"> </Noun>");
   out.println("</ControlArea>");
   out.println("<DataArea>");
   out.println("<ExpectedInventoryRecord>");
   out.println("	<ResponseStatus status=\"OK\" />");
   
   if (success) {

      //put RA information
      out.println("	<RA>");
      if (raBackendId != null)
      {
           out.println("		<BackendRaID>" + raBackendId + "</BackendRaID>");
      }
      out.println("		<StoreID>" + storeId + "</StoreID>");

      out.println("		<VendorID>" + vendorId + "</VendorID>");

      out.println("		<OrderDate>" + orderDate + "</OrderDate>");

      out.println("		<WCSRaID>" + raId + "</WCSRaID>");
      out.println("	</RA>");

     
      // output RADETAIL line item information

      RaDetailAccessBean radBean = new RaDetailAccessBean();
      Enumeration e  = radBean.findByRaId(Long.valueOf(raId) );
      Enumeration ine = vec.elements();
   
      int maxItems = vec.size();
   
      long raDetails[] = new long[maxItems];

      int i = 0;

      while ( e.hasMoreElements() )
      {
        if ( i < maxItems)
        {
	  	RaDetailAccessBean aBean = (RaDetailAccessBean) e.nextElement();
        	raDetails[i] = aBean.getRaDetailIdInEntityType().longValue();
        	i++;
        }
      }

      java.util.Arrays.sort(raDetails, 0, i);
         	
      for (int j=0; (j < i) && ine.hasMoreElements(); j++)
      {
          Hashtable rad = (Hashtable)ine.nextElement();
          out.println("	<RADetail>");
           
          String bRaDId  = (String)rad.get("backendRADetailID");
          if (bRaDId != null)
          {
   	       out.println("		<BackendRaDetailID>" + bRaDId + "</BackendRaDetailID>");
	    }
          out.println("		<WCSRaDetailID>" + raDetails[j] + "</WCSRaDetailID>");
          out.println("	</RADetail>");
      }
  }
  out.println("</ExpectedInventoryRecord>");

  out.println("</DataArea>");

  out.println("</Response_WCS_ExpectedInvRecord>");

  }
  catch (Exception e)
  { 
	out.print( "Exception =>" + e);
  }
%>


