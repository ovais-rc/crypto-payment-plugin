<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@page import="java.math.BigDecimal" %>
<%@page import="com.ibm.commerce.payments.plugincontroller.PaymentInstruction" %>
<%@page import="com.ibm.commerce.payments.plugincontroller.Payment" %>
<%@page import="com.ibm.commerce.payments.plugincontroller.Credit" %>
<%@ page import="com.ibm.commerce.price.beans.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%!
	String converterStateOfPI(int state){
	
		if(state==PaymentInstruction.STATE_NEW){
			return "new";
		}else if(state==PaymentInstruction.STATE_VALID){
			return "valid";
		}else if(state==PaymentInstruction.STATE_INVALID){
			return "invalid";
		}else if(state==PaymentInstruction.STATE_CLOSED){
			return "close";
		}
		return "unknow";
	}
	
	String converterStateOfPayment(int state){
		if(state==Payment.STATE_APPROVED){
			return "approved";
		}else if(state==Payment.STATE_EXPIRED){
			return "expired";
		}else if(state==Payment.STATE_CANCELED){
			return "canceled";
		}else if(state==Payment.STATE_FAILED){
			return "failed";
		}else if(state==Payment.STATE_NEW){
			return "new";
		}else if(state==Payment.STATE_APPROVING){
			return "approving";
		}
		return "unknow";
	}
	String converterStateOfCredit(int state){
		if(state==Credit.STATE_NEW){
			return "new"; 
		}else if(state==Credit.STATE_CREDITING){
			return "crediting";
		}else if(state==Credit.STATE_CREDITED){
			return "credited";
		}else if(state==Credit.STATE_FAILED){
			return "failed";
		}else if(state==Credit.STATE_CANCELED){
			return "canceled";
		}
		return "unknow";
	}
	String converterAVSCode(int code){
		if(code==Payment.AVS_COMPLETE_MATCH){
			return "avs_complete_match";
		}else if(code==Payment.AVS_STREET_ADDRES_MATCH){
			return "avs_street_address_match";
		}else if(code==Payment.AVS_POSTALCODE_MATCH){
			return "avs_postal_code_match";
		}else if(code==Payment.AVS_NO_MATCH){
			return "avs_no_match";
		}else if(code==Payment.AVS_OTHER_RESPONSE){
			return "avs_other_response";
		}   
		return "";
	}
	public String getFormattedAmount(BigDecimal amount, String currency, Integer langId, String storeId) {
		try {
			com.ibm.commerce.common.beans.StoreDataBean iStoreDB = new com.ibm.commerce.common.beans.StoreDataBean();
			iStoreDB.setStoreId(storeId);	
	
			FormattedMonetaryAmountDataBean formattedAmount =  new FormattedMonetaryAmountDataBean(
					new MonetaryAmount(amount, currency),
					iStoreDB, langId);
		
			return formattedAmount.getPrimaryFormattedPrice().getFormattedValue().toString();
		} catch (Exception exc) {
			return "";
		}
	}
	
	public String getTypeStr(short i){
		if(i==0){
			return "Boolean";
		}else if(i==1){	
			return "Integer";
		}else if(i==2){
			return "Long";
		}else if(i==3){
			return "BigDecimal";
		}else if(i==4){
			return "String";
		}else if(i==5){
			return "StringBuffer";
		}
		
		return "String";
	}
%>