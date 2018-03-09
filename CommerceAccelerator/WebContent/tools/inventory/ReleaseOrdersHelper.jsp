<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2003, 2017
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 020815	    KNG		Initial Create
// 020928    43004  KNG		Use renamed method from FulfillmentCenterAccessBean.
////////////////////////////////////////////////////////////////////////////////
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.ras.*" %>

<%!
/**
 * Retrieves some information from the "special" fulfillment center(i.e. with FFMStore_id not null).
 *
 * @param aStoreId	The store id
 * @param aLangId	The language id 
 * @param mode		0 - for Fulfillment Center Display Name
 *			1 - for FFMStore_id
 *
 * @return	The vector of strings depending on the mode 
 **/
public Vector getSpecialFFMCsInformation(String aStoreId, String aLangId, int mode) {
	final String methodName = "getSpecialFFMCsInformation";
	ECTrace.entry( ECTraceIdentifiers.COMPONENT_INVENTORY, "ReleaseOrdersHelper.jsp", methodName);

	Vector ffmcDisplayNames = new Vector();
	Vector ffmcFFMStoreIds = new Vector();
	
	try {
		FulfillmentJDBCHelperBean fulfillmentJDBC = SessionBeanHelper.lookupSessionBean(FulfillmentJDBCHelperBean.class);
		Vector rs = fulfillmentJDBC.findFfmcenterIdAndDisplayName(new Integer(aStoreId));
	
		for (int i=0; i<rs.size(); i++) {
			String displayName = null;
			String ffmStoreId = null;
		
			Vector row = (Vector)rs.elementAt(i);
			FulfillmentCenterAccessBean ffmcAB = new FulfillmentCenterAccessBean();
			ffmcAB.setInitKey_fulfillmentCenterId( ((Integer)row.elementAt(0)).toString() );
		
			ffmStoreId = ffmcAB.getExternalFulfillmentStoreNumber();	
		
			if (ffmStoreId != null && !ffmStoreId.equals("") ) {
				ffmcFFMStoreIds.addElement(ffmStoreId);
		
				// special, need to get display name
				try {
					FulfillmentCenterDescriptionAccessBean ffmcDescAB = new FulfillmentCenterDescriptionAccessBean();
					ffmcDescAB.setInitKey_fulfillmentCenterId( ((Integer)row.elementAt(0)).toString() );
					ffmcDescAB.setInitKey_languageId( aLangId );
					displayName = ffmcDescAB.getDisplayName();
			
					if ( displayName == null || displayName.equals("") ) {
						displayName = ffmcAB.getName();
					}
				} catch (Exception ex) {
					displayName = ffmcAB.getName();
				}
				ffmcDisplayNames.addElement(displayName);
			}
		}

		if (mode == 0) {
			return ffmcDisplayNames;
		} else if (mode == 1) {
			return ffmcFFMStoreIds;
		} else {
			return null;
		}

	} catch (Exception ex) {
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_INVENTORY, "ReleaseOrdersHelper.jsp", methodName, "Exception when getting FFMStore_id...");
		return null;
	}
}

/**
 * Gets the displayable formatted quantiy.
 * 
 * @param inQuantity	The quantity that needs to be displayed
 * @param locale	The locale
 * @return 	The formatted quantity.
 */
public String getFormattedQuantity(String inQuantity, Locale locale) {
	double quantity = (new Double(inQuantity)).doubleValue();
	NumberFormat numberFormat = NumberFormat.getNumberInstance(locale);
	return numberFormat.format(quantity);
}
%>
