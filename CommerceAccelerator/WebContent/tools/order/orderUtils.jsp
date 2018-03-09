<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2011
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>
<%@ page import="java.math.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.contract.beans.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.contract.util.*" %>
<%@ page import="com.ibm.commerce.order.utils.*" %>
<%@ page import="com.ibm.commerce.price.beans.*" %>
<%@ page import="com.ibm.commerce.price.commands.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>


<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%!

//
// Get the formatted amount for display
// @param amount	The amount to format
// @param currency	The currency
// @param langId	The language id
// @param storeId	The store id
//
public String getFormattedAmount(BigDecimal amount, String currency, Integer langId, String storeId)
{
	try {
		StoreDataBean iStoreDB = new StoreDataBean();
		iStoreDB.setStoreId(storeId);	
		
		FormattedMonetaryAmountDataBean formattedAmount =  new FormattedMonetaryAmountDataBean(
			new MonetaryAmount(amount, currency), iStoreDB, langId);
		return formattedAmount.getPrimaryFormattedPrice().getFormattedValue().toString();
	} catch (Exception exc) {
		return "";
	}
}


//
// Get the displayable contract name
// @param contractId	The contract id
// @param request	The HTTP Request
//
public String getContractName(String contractId, HttpServletRequest request) {
	try {
		if (contractId != null && !contractId.equals("")) {
			com.ibm.commerce.contract.beans.ContractDataBean contractDataBean = new com.ibm.commerce.contract.beans.ContractDataBean();
			contractDataBean.setDataBeanKeyReferenceNumber(contractId); 
			DataBeanManager.activate(contractDataBean, request);
			return contractDataBean.getName();
		} else {
			return "";
		}
	
	} catch (Exception ex) {
		return "";
	}
}
	
	
//
// Get the trading ids that can be used by the customer
// @param customerId	The customer id
// @param storeId	The store id
//
public Long[] getCustomerTradingIds(String customerId, Integer storeId) {
	try {
		TradingAgreementAccessBean tradingAB = new TradingAgreementAccessBean();
		Enumeration tradingEnum = tradingAB.findEntitledTradingAgreementForBuyerUnderStore(new Long(customerId), storeId);
		
		String[] strTradings = ContractCmdUtil.getEligibleTradingAgreements(tradingEnum, storeId);
		
		Long[] tradingIds = new Long[strTradings.length];
		for (int k=0; k<strTradings.length; k++) {
			tradingIds[k] = new Long(strTradings[k]);
		}

		return tradingIds;
	} catch (Exception ex) {
		return null;
	}
}
	

/**
 * New: Support for "customer shopping under different organizations".
 **/
//
// Get the trading ids that can be used by the customer under the particular organization.
// @param customerId	The customer id
// @param storeId	The store id
// @param request	The HTTP Request
// @param activeOrgId	The organization id that the customer is shopping under
//
public Long[] getCustomerTradingIds(String customerId, Integer storeId, HttpServletRequest request, Long activeOrgId) {
	try {
		if (activeOrgId == null) {
			//we can assume the customer to be shopping under its parent organization.
			//Find the parent organization of the customer.
			UserRegistrationDataBean userDataBean = new UserRegistrationDataBean();
			try {
				userDataBean.setUserId(customerId);
				com.ibm.commerce.beans.DataBeanManager.activate(userDataBean, request);
				activeOrgId = new Long(userDataBean.getParentMemberId());
			} catch (Exception ex) {
			
			}
		}
	
		TradingAgreementAccessBean tradingAB = new TradingAgreementAccessBean();
		Enumeration tradingEnum = tradingAB.findEntitledTradingAgreementForBuyerUnderStore(new Long(customerId), storeId, activeOrgId);
		
		String[] strTradings = ContractCmdUtil.getEligibleTradingAgreements(tradingEnum, storeId);
		
		Long[] tradingIds = new Long[strTradings.length];
		for (int k=0; k<strTradings.length; k++) {
			tradingIds[k] = new Long(strTradings[k]);
		}

		return tradingIds;
	} catch (Exception ex) {
		return null;
	}
}
//
// Get the HTML string for the contract price (i.e. returns a display string or a radio selection)
//
public String getContractPriceB2B(String catentryId, String currency, String customerId, Integer storeId, Long[] tradingIds, Long selectedTradingId, Integer langId, int counter, CommandContext cmdContext, HttpServletRequest request) {
	StringBuffer contractPriceChoice = new StringBuffer();
	StringBuffer currencyStr = new StringBuffer();
	if ( currency != null || currency.equals("") ) {
		currencyStr.append("[");
		currencyStr.append(currency);
		currencyStr.append("]");
	}
		
	try {
		GetContractUnitPriceCmd contractPrice = (GetContractUnitPriceCmd) CommandFactory.createCommand(GetContractUnitPriceCmd.NAME, storeId);
		if (contractPrice != null)
		{
			// get all contract prices
			contractPrice.setCurrency(currency);
			//Commented for (Support for "customer shopping under different organizations)
			//contractPrice.setMemberId(new Long(customerId));
			contractPrice.setStoreId(storeId);
			contractPrice.setCatEntryId(new Long(catentryId));
			contractPrice.setTradingIds(tradingIds);
			contractPrice.setCommandContext(cmdContext);
			contractPrice.execute();
			MonetaryAmount[] tradingUnitPrices = contractPrice.getApplicableTradingUnitPrices();
			
			//
			// create the HTML string for the contract prices
			// For example: [CAD] 100 Default Contract Price
			//    
			if (tradingIds != null) {
			 if (tradingIds.length > 1) {
				for (int j=0; j<tradingIds.length; j++) {
					String checkedPrice = "";
					if (selectedTradingId == null) {
						if (j==0) {
							checkedPrice = "CHECKED";
						}
					} else if (tradingIds[j].compareTo(selectedTradingId) == 0) {
						checkedPrice = "CHECKED";
					}
					
				if (tradingUnitPrices[j] != null)	{
					if (counter != 0) {
						contractPriceChoice.append("<INPUT TYPE='RADIO' NAME='");
						contractPriceChoice.append(OrderConstants.EC_CONTRACT_ID);
						contractPriceChoice.append("_");
						contractPriceChoice.append(counter);
					} else {
						contractPriceChoice.append("<INPUT TYPE='RADIO' NAME='");
						contractPriceChoice.append(OrderConstants.EC_CONTRACT_ID);
					}
					contractPriceChoice.append("' ID='contract");
					contractPriceChoice.append(j);
					contractPriceChoice.append("' VALUE='");
					contractPriceChoice.append(tradingIds[j]);
					contractPriceChoice.append("' ");
					contractPriceChoice.append(checkedPrice);
					contractPriceChoice.append(">");
					contractPriceChoice.append("<label for='contract");
					contractPriceChoice.append(j);
					contractPriceChoice.append("'>");
					contractPriceChoice.append(currencyStr.toString());
					contractPriceChoice.append(" ");
					contractPriceChoice.append(getFormattedAmount(tradingUnitPrices[j].getValue(), currency, langId, storeId.toString()));
					contractPriceChoice.append(" ");
					contractPriceChoice.append(getContractName(tradingIds[j].toString(), request));
					contractPriceChoice.append("</label>");
					contractPriceChoice.append("<BR>");
				  }
				}
			} else if (tradingIds.length == 1) {
				if (tradingUnitPrices[0] != null) {
				 if (counter != 0) {
					contractPriceChoice.append("<INPUT TYPE='hidden' NAME='");
					contractPriceChoice.append(OrderConstants.EC_CONTRACT_ID);
					contractPriceChoice.append("_");
					contractPriceChoice.append(counter);
					contractPriceChoice.append("' VALUE='");
					contractPriceChoice.append(tradingIds[0]);
					contractPriceChoice.append("'>");
					contractPriceChoice.append(currencyStr.toString());
					contractPriceChoice.append(" ");
					contractPriceChoice.append(getFormattedAmount(tradingUnitPrices[0].getValue(), currency, langId, storeId.toString()));
					contractPriceChoice.append(" ");
					contractPriceChoice.append(getContractName(tradingIds[0].toString(), request));
					contractPriceChoice.append("<BR>");
				} else {
					contractPriceChoice.append("<INPUT TYPE='hidden' NAME='");
					contractPriceChoice.append(OrderConstants.EC_CONTRACT_ID);
					contractPriceChoice.append("' VALUE='");
					contractPriceChoice.append(tradingIds[0]);
					contractPriceChoice.append("'>");
					contractPriceChoice.append(currencyStr.toString());
					contractPriceChoice.append(" ");
					contractPriceChoice.append(getFormattedAmount(tradingUnitPrices[0].getValue(), currency, langId, storeId.toString()));
					contractPriceChoice.append(" ");
					contractPriceChoice.append(getContractName(tradingIds[0].toString(), request));
					contractPriceChoice.append("<BR>");
				}
			  }
		    }
		  }
		}
	} catch (Exception ex) {
		return contractPriceChoice.toString();
	}
	return contractPriceChoice.toString();
}
	
//
// Get the HTML string for the contract price (i.e. returns a display string)
//
public String getContractPriceB2C(String catentryId, String currency, String customerId, Integer storeId, Long[] tradingIds, Integer langId, int counter, CommandContext cmdContext) {
	// Get applicable contract prices
	StringBuffer contractPriceChoice = new StringBuffer();
	StringBuffer currencyStr = new StringBuffer();
	if ( currency != null || currency.equals("") ) {
		currencyStr.append("[");
		currencyStr.append(currency);
		currencyStr.append("]");
	}
			
	try {
		GetContractUnitPriceCmd contractPrice = (GetContractUnitPriceCmd) CommandFactory.createCommand(GetContractUnitPriceCmd.NAME, storeId);
		if (contractPrice != null)
		{
			// get all contract prices
			contractPrice.setCurrency(currency);
			contractPrice.setMemberId(new Long(customerId));
			contractPrice.setStoreId(storeId);
			contractPrice.setCatEntryId(new Long(catentryId));
			contractPrice.setTradingIds(tradingIds);
			contractPrice.setCommandContext(cmdContext);
			contractPrice.execute();
			MonetaryAmount[] tradingUnitPrices = contractPrice.getApplicableTradingUnitPrices();

			//
			// create the HTML string for the contract prices
			// For example: [CAD] 100 Default Contract Price
			//
			for (int j=0; j<tradingIds.length; j++) {
				if (counter != 0) {
					contractPriceChoice.append("<INPUT TYPE='hidden' NAME='");
					contractPriceChoice.append(OrderConstants.EC_CONTRACT_ID);
					contractPriceChoice.append("_");
					contractPriceChoice.append(counter);
					contractPriceChoice.append("' VALUE='");
					contractPriceChoice.append(tradingIds[j]);
					contractPriceChoice.append("'>");
					contractPriceChoice.append(currencyStr.toString());
					contractPriceChoice.append(" ");
					contractPriceChoice.append(getFormattedAmount(tradingUnitPrices[j].getValue(), currency, langId, storeId.toString()));
					contractPriceChoice.append("<BR>");
				} else {
					contractPriceChoice.append("<INPUT TYPE='hidden' NAME='");
					contractPriceChoice.append(OrderConstants.EC_CONTRACT_ID);
					contractPriceChoice.append("' VALUE='");
					contractPriceChoice.append(tradingIds[j]);
					contractPriceChoice.append("'>");
					contractPriceChoice.append(currencyStr.toString());
					contractPriceChoice.append(" ");
					contractPriceChoice.append(getFormattedAmount(tradingUnitPrices[j].getValue(), currency, langId, storeId.toString()));
					contractPriceChoice.append("<BR>");
				}
			}
		}
	} catch (Exception ex) {
		return contractPriceChoice.toString();
	}
	return contractPriceChoice.toString();
}

//
// Get the user logon
// @param customerId	The customer reference number
// @param request	The HTTP Request
//
public String getUserLogon(String customerId, HttpServletRequest request) {
	try {
		if (customerId != null && !customerId.equals("")) {
			UserRegistrationDataBean userBean = new UserRegistrationDataBean();
			userBean.setUserId(customerId);
			DataBeanManager.activate(userBean, request);
	
			if (userBean.getLogonId() != null) {
				return userBean.getLogonId();
			}
		}
	} catch (Exception ex) {
		return "";
	}
	return "";
}

%>
