<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%
String snippetCaller = (String)request.getAttribute("snippetCaller");
Hashtable resourceBundle = (Hashtable)request.getAttribute("resourceBundle");
	java.math.BigDecimal edp_PayMethodAmount = (java.math.BigDecimal)request.getAttribute("edp_PayMethodAmount");
	String account = "";
	String  forPIUPdate =(String) request.getAttribute("forPIUPdate");
	String parentOrgId = "";
	String WCAccountId = "";
	String BuyerOrgName = "";
	String BuyerOrgDN = "";
	String paymentTCId = "";
	String edp_PIInfo_Form = "";
	String orderId = "";
	boolean valueFromPaymentTC = false;
		if((snippetCaller!= null)&&(forPIUPdate != null) && (forPIUPdate.equalsIgnoreCase("Y"))){
		    JSPHelper urlParameters = new JSPHelper(request);
		    paymentTCId = urlParameters.getParameter("paymentTCId");
		    edp_PIInfo_Form = urlParameters.getParameter("edp_PIInfo_Form");
		    orderId =  urlParameters.getParameter("orderId");
		    java.util.HashMap edp_ProtocolData = (java.util.HashMap)request.getAttribute("protocolData");
		    valueFromPaymentTC = false;
		    if(paymentTCId != null && paymentTCId.trim().length()>0){
		    com.ibm.commerce.contract.beans.PaymentTCDataBean paymentTCbean= new com.ibm.commerce.contract.beans.PaymentTCDataBean();
		    paymentTCbean.setDataBeanKeyReferenceNumber(paymentTCId);
		    com.ibm.commerce.beans.DataBeanManager.activate(paymentTCbean, request);
		    com.ibm.commerce.utf.objects.PAttrValueAccessBean[] pAttrValues=paymentTCbean.getPAttrValues();
			for(int i =0;i<pAttrValues.length;i++){
			    com.ibm.commerce.utf.objects.PAttrValueAccessBean pAttrValue = pAttrValues[i];
			    com.ibm.commerce.utf.beans.PAttributeDataBean	attribute = new com.ibm.commerce.utf.beans.PAttributeDataBean();
			    attribute.setPAttributeId(pAttrValue.getAttributeId());
			    com.ibm.commerce.beans.DataBeanManager.activate(attribute, request);
			    if("account".equalsIgnoreCase(attribute.getName())){		
				if(pAttrValue.getPAttrValue()!=null){
			  	    valueFromPaymentTC = true;
				    com.ibm.commerce.edp.beans.EDPSensitiveDataMaskHelperDataBean  edpMaskBean = new com.ibm.commerce.edp.beans.EDPSensitiveDataMaskHelperDataBean();
				    edpMaskBean.setPlainString(pAttrValue.getPAttrValue().toString());
				    com.ibm.commerce.beans.DataBeanManager.activate(edpMaskBean, request);
			  	    account = edpMaskBean.getMaskedString();
		   	        }else{
			            account = "";
			        } 
			     } 
		  	}//end for
		  	WCAccountId = (String) paymentTCbean.getTradingId();
		    CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
		    parentOrgId = commandContext.getParentOrg();
			com.ibm.commerce.user.beans.OrganizationDataBean  orgDataBean = new com.ibm.commerce.user.beans.OrganizationDataBean();
			orgDataBean.setDataBeanKeyMemberId(parentOrgId);
			com.ibm.commerce.beans.DataBeanManager.activate(orgDataBean , request);
			BuyerOrgName = (String) orgDataBean.getOrganizationName();
			BuyerOrgDN =(String) orgDataBean.getDistinguishedName();
		    }//end the outer if
		    else if(edp_ProtocolData != null && !edp_ProtocolData.isEmpty()){
			     //If the paymentTCId parameter is not passed in, the protocol data will be retrieved from the edp_ProtocolData	
		         paymentTCId =(String) edp_ProtocolData.get("paymentTCId");
			     account=(String) edp_ProtocolData.get("account");
			     WCAccountId=(String) edp_ProtocolData.get("WCAccountId");
		         BuyerOrgName =(String) edp_ProtocolData.get("BuyerOrgName");
		         BuyerOrgDN = (String) edp_ProtocolData.get("BuyerOrgDN");
		    }

		}
		if(paymentTCId == null ){paymentTCId ="";}
		if(account == null ){account ="";}
		if(WCAccountId == null ){WCAccountId ="";}
		if(BuyerOrgName == null ){BuyerOrgName ="";}
		if(BuyerOrgDN == null ){BuyerOrgDN ="";}
		
%>
<%if ((snippetCaller!= null)&&(snippetCaller.equals("OrderPaymentSelection"))){%>

<TABLE>
    <TR><TD COLSPAN=2></TD></TR>
    
    <tr>
        <td colspan="4" valign="left" id="StandardLOC_TableCell_1">
	   <label for="StandardLOC_InputText_1"><span class="required">*</span>
		<%= UIUtil.toHTML( (String)resourceBundle.get("paymentInstructionAmount"))%></label>
        </td>
	<td colspan="4" valign="left" id="StandardLOC_TableCell_2">
	    <input type=hidden name="account" value ="<%=account%>" />
	    <input type="text" name = "piAmount" value="<%=edp_PayMethodAmount%>" id="StandardLOC_InputText_1" />
	    <%if (valueFromPaymentTC == true) {%>
		<input type=hidden name="valueFromPaymentTC" value="true" />
            <%}%>
            <input type=hidden name="paymentTCId" value="<%=paymentTCId%>"/>
            <input type=hidden name="BuyerOrgName" value="<%=BuyerOrgName%>" />
	    <input type=hidden name="BuyerOrgDN" value="<%=BuyerOrgDN%>" />
	    <input type=hidden name="WCAccountId" value="<%=WCAccountId%>" />
	</td> 
    </tr>
</TABLE>
<%}else{%>
<TABLE>
    <TR><TD COLSPAN=2></TD></TR>
    <TR>
      <TD ALIGN="left"><label for="account1"><%= UIUtil.toHTML( (String)resourceBundle.get("accountNumber")) %></label></TD> 
    </TR>
    <TR>
      <TD>
        <INPUT TYPE=text SIZE=30 id="account1" MAXLENGTH=256 NAME="<%= ECConstants.EC_CC_ACCOUNT %>" VALUE="" onchange="snipJSPOnChange(this.name)" >
      </TD>
    </TR>
</TABLE>
<%}%>
