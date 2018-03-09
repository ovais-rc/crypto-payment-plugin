<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2000, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================
--%><%@ page import="javax.servlet.*,
java.util.*,
com.ibm.commerce.server.*,
com.ibm.commerce.beans.*,
com.ibm.commerce.messaging.util.*,
com.ibm.commerce.order.beans.*,
com.ibm.commerce.order.objects.*,
com.ibm.commerce.user.beans.*,
com.ibm.commerce.user.objects.*,
com.ibm.commerce.common.objects.*,
com.ibm.commerce.common.beans.*,
com.ibm.commerce.catalog.beans.*,
com.ibm.commerce.catalog.objects.*,
com.ibm.commerce.fulfillment.beans.*,
com.ibm.commerce.fulfillment.objects.*,
com.ibm.commerce.user.helpers.*,
com.ibm.commerce.edp.beans.EDPPaymentInstructionsDataBean,
com.ibm.commerce.edp.api.EDPPaymentInstruction,
com.ibm.commerce.edp.utils.Constants,
com.ibm.commerce.registry.BusinessPolicyRegistryEntry,
com.ibm.commerce.registry.BusinessPolicyRegistry,
com.ibm.commerce.payment.ppc.beans.PPCListPIsForOrderDataBean,
com.ibm.commerce.payments.plugincontroller.PaymentInstruction,
com.ibm.commerce.server.ECConstants,
com.ibm.commerce.payments.plugincontroller.beans.ObjectModuleFacadeFactory,
com.ibm.commerce.payments.plugincontroller.Payment,
com.ibm.commerce.payments.plugincontroller.beans.PPCPayTranData,
com.ibm.commerce.contract.objects.BusinessPolicyAccessBean,
com.ibm.commerce.payments.plugin.ExtendedData,
com.ibm.commerce.payment.ppc.beans.PPCPIExtendedDataDataBean,
com.ibm.commerce.payment.ppc.beans.PPCListPaymentsForPIDataBean,
java.text.DateFormat,
java.util.Calendar"%><%
try
{
   // NOTE TO NLV TRANSLATOR: THIS JSP DOES NOT NEED ANY TRANSLATION
   // ALL THE XML TAGS SHOULD BE FIXED IN ENGLISH
   response.setContentType("text/xml;charset=UTF-8");
   // Get the Order Reference Number passed in by SendXMLOrderMsg task command.
   JSPHelper JSPHelp = new JSPHelper(request);
   String orderId = JSPHelp.getParameter(OrderCreateConstants.ORDER_REF_NUMBER);
   String languageId = JSPHelp.getParameter(OrderCreateConstants.LANGUAGE_ID);

   String tempString = null;

   String storeId = null;
   String requisitionerId = null;
   String billToId = null;
   String currString = null;

   String orderCustomerField1 = null;
   String orderCustomerField2 = null;
   String orderCustomerField3 = null;

   String shipModeId = null;

   OrderDataBean odb=new OrderDataBean();
   odb.setOrderId(orderId);
   com.ibm.commerce.beans.DataBeanManager.activate(odb, request);

   OrderItemAccessBean [] itemBean = odb.getOrderItems();

   // Get all information from Order table that may be needed later

   // First check if store / merchant id is available for use in MerchantInfo
   if (odb.getStoreEntityIdInEntityType() != null)
	  storeId=odb.getStoreEntityId();
   else
	  storeId=OrderCreateConstants.NOT_AVAILABLE;

   // Check if shopper / requisitioner id is available for use in RequisitionerInfo
   if (odb.getMemberIdInEntityType() != null)
	  requisitionerId=odb.getMemberId();
   else
	  requisitionerId=OrderCreateConstants.NOT_AVAILABLE;

   // Check if bill to id is available for use in BillToInfo
   if (odb.getAddressIdInEntityType() != null)
	  billToId=odb.getAddressId();
   else
	  billToId=OrderCreateConstants.NOT_AVAILABLE;

   currString			=odb.getCurrency();
   orderCustomerField1	=odb.getField1();
   orderCustomerField2	=odb.getField2();
   orderCustomerField3	=odb.getField3();

   // Generate Order Create Message Header Information
   out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
   out.println("<!DOCTYPE Report_NC_PurchaseOrder SYSTEM \"Report_NC_PO_10.dtd\">");
   out.println("<Report_NC_PurchaseOrder version=\"1.0\">");
   out.println("<ControlArea>");
   out.println("<Verb value=\"Report\"> </Verb>");
   out.println("<Noun value=\"NC_PurchaseOrder\"> </Noun>");
   out.println("</ControlArea>");
   out.println("<DataArea>");
   out.println("<ReportPO>");
   out.println("<ReportPOHeader>");

   if ((tempString=odb.getMerchantOrderId()) != null)
	  out.println("<OrderNumberByMerchant>"+tempString+"</OrderNumberByMerchant>");

   out.println("<OrderNumberByNC>"+orderId+"</OrderNumberByNC>");

   if (odb.getPlaceOrderTimeInEntityType() != null)
   {
	  tempString=odb.getPlaceOrderTime();
	  tempString=tempString.trim();
	  String tempDate=null;
	  String tempTime=null;

	  tempDate=tempString.substring(0,4);
	  tempDate +=tempString.substring(5,7);
	  tempDate +=tempString.substring(8,10);

	  tempTime=tempString.substring(11,13);
	  tempTime +=tempString.substring(14,16);
	  tempTime +=tempString.substring(17,19);

	  out.println("<DateTimeReference>");
	  out.println("<PlacedDate>"+tempDate+"</PlacedDate>");
	  out.println("<PlacedTime>"+tempTime+"</PlacedTime>");
	  out.println("</DateTimeReference>");
   }

   if (currString != null)
      out.println("<TotalPriceInfo currency=\""+currString+"\">");
   else
	  out.println("<TotalPriceInfo>");

   if ((tempString=odb.getTotalProductPrice()) != null)
	  out.println("<TotalNetPrice>"+tempString+"</TotalNetPrice>");

   out.println("<TaxInfo>");
   if ((tempString=odb.getTotalTax()) != null)
   {
      if (currString != null)
	     out.println("<MonetaryAmount currency=\""+currString+"\">"+tempString+"</MonetaryAmount>");
	  else
	     out.println("<MonetaryAmount>"+tempString+"</MonetaryAmount>");
   }
   out.println("</TaxInfo>");

   if ((tempString=odb.getTotalShippingCharge()) != null)
      out.println("<TotalShippingPrice>"+tempString+"</TotalShippingPrice>");

   if ((tempString=odb.getTotalShippingTax()) != null)
      out.println("<TotalTaxOnShippingPrice>"+tempString+"</TotalTaxOnShippingPrice>");

   out.println("</TotalPriceInfo>");

   if ((tempString=odb.getStatus()) != null)
      out.println("<ShipStatus>"+tempString+"</ShipStatus>");

   // Bill to Info, Check if the Bill To Address Id is stored in Order
   if (billToId != OrderCreateConstants.NOT_AVAILABLE)
   {
      AddressDataBean adb=new AddressDataBean();
      adb.setAddressId(billToId);
	  com.ibm.commerce.beans.DataBeanManager.activate(adb, request);

	  String BillToLastName = null;

	  // BillToInfo is not empty if Bill To Last Name is not empty
	  if ((BillToLastName=adb.getLastName()) != null)
	  {
         out.println("<BillToInfo>");

		 out.println("<Address>");
		 if ((tempString=adb.getAddress1()) != null)
		    out.println("<AddressLine>"+tempString+"</AddressLine>");
		 if ((tempString=adb.getAddress2()) != null)
		    out.println("<AddressLine>"+tempString+"</AddressLine>");
		 if ((tempString=adb.getAddress3()) != null)
		    out.println("<AddressLine>"+tempString+"</AddressLine>");
		 if ((tempString=adb.getCity()) != null)
			out.println("<City>"+tempString+"</City>");
		 if ((tempString=adb.getState()) != null)
			out.println("<State>"+tempString+"</State>");
		 if ((tempString=adb.getZipCode()) != null)
		    out.println("<Zip>"+tempString+"</Zip>");
		 if ((tempString=adb.getCountry()) != null)
			out.println("<Country>"+tempString+"</Country>");
		 out.println("</Address>");

  		 out.println("<ContactPersonName>");
		 out.println("<LastName>"+BillToLastName+"</LastName>");
		 if ((tempString=adb.getFirstName()) != null)
			out.println("<FirstName>"+tempString+"</FirstName>");
		 if ((tempString=adb.getMiddleName()) != null)
			out.println("<MiddleName>"+tempString+"</MiddleName>");
		 if ((tempString=adb.getNickName()) != null)
			out.println("<AlternateName>"+tempString+"</AlternateName>");
		 out.println("</ContactPersonName>");

 		 String BillToInfoPhone1=null;
		 String BillToInfoPhone2=null;
		 String BillToInfoEmail1=null;
		 String BillToInfoEmail2=null;
		 String BillToInfoFax=null;

		 BillToInfoPhone1=adb.getPhone1();
		 BillToInfoPhone2=adb.getPhone2();
		 BillToInfoEmail1=adb.getEmail1();
		 BillToInfoEmail2=adb.getEmail2();

		 if ((BillToInfoFax=adb.getFax1()) == null)
		    BillToInfoFax=adb.getFax2();

		 if ((BillToInfoPhone1 != null) || (BillToInfoPhone2 != null) ||
		    (BillToInfoEmail1 != null) || (BillToInfoEmail2 != null) ||
			(BillToInfoFax != null))
		 {
		    out.println("<ContactInfo>");

			if (BillToInfoPhone1 != null)
			{
		       out.println("<Telephone type=\"primary\">"+BillToInfoPhone1+"</Telephone>");
			   if (BillToInfoPhone2 != null)
			      out.println("<Telephone type=\"secondary\">"+BillToInfoPhone2+"</Telephone>");
			}
			else if (BillToInfoPhone2 != null)
			   out.println("<Telephone type=\"primary\">"+BillToInfoPhone2+"</Telephone>");

			if (BillToInfoEmail1 != null)
			{
			   out.println("<Email type=\"primary\">"+BillToInfoEmail1+"</Email>");
			   if (BillToInfoEmail2 != null)
			      out.println("<Email type=\"secondary\">"+BillToInfoEmail2+"</Email>");
			}
			else if (BillToInfoEmail2 != null)
			   out.println("<Email type=\"primary\">"+BillToInfoEmail2+"</Email>");

			if (BillToInfoFax != null)
			   out.println("<Fax>"+BillToInfoFax+"</Fax>");

			out.println("</ContactInfo>");
		 }
		 out.println("</BillToInfo>");
      }
   }

   // Merchant Info
   if (storeId != OrderCreateConstants.NOT_AVAILABLE)
   {
	  StoreDefaultDataBean sddb=new StoreDefaultDataBean();
	  sddb.setDataBeanKeyStoreId(storeId);
	  com.ibm.commerce.beans.DataBeanManager.activate(sddb, request);

      if (sddb.getShipModeIdInEntityType() != null)
	    shipModeId = sddb.getShipModeId();

	  StoreEntityDescriptionDataBean seddb=new StoreEntityDescriptionDataBean();
	  seddb.setDataBeanKeyStoreEntityId(storeId);
	  seddb.setDataBeanKeyLanguageId(languageId);
	  com.ibm.commerce.beans.DataBeanManager.activate(seddb, request);

	  //MerchantInfo is not empty if its addressId is not empty
      if ((seddb.getContactAddressIdInEntityType()) != null)
	  {
	     out.println("<MerchantInfo>");

		 if ((tempString=seddb.getDisplayName()) != null)
		    out.println("<OrgName>"+tempString+"</OrgName>");

		 out.println("<OrgID type=\"NCInternal\">"+storeId+"</OrgID>");

		 StoreAddressDataBean sadb=new StoreAddressDataBean();
		 sadb.setDataBeanKeyStoreAddressId(seddb.getContactAddressId());
		 com.ibm.commerce.beans.DataBeanManager.activate(sadb, request);
		 
		 out.println("<Address>");
		 if ((tempString=sadb.getAddress1()) != null)
		    out.println("<AddressLine>"+tempString+"</AddressLine>");
	  	 if ((tempString=sadb.getAddress2()) != null)
		    out.println("<AddressLine>"+tempString+"</AddressLine>");
		 if ((tempString=sadb.getAddress3()) != null)
		    out.println("<AddressLine>"+tempString+"</AddressLine>");

		 if ((tempString=sadb.getCity()) != null)
		    out.println("<City>"+tempString+"</City>");
		 if ((tempString=sadb.getState()) != null)
		    out.println("<State>"+tempString+"</State>");
		 if ((tempString=sadb.getZipCode()) != null)
		    out.println("<Zip>"+tempString+"</Zip>");
		 if ((tempString=sadb.getCountry()) != null)
			out.println("<Country>"+tempString+"</Country>");
		 out.println("</Address>");

		 String MerchantContactLastName = null;
		 if ((MerchantContactLastName=sadb.getLastName()) != null)
		 {
		    out.println("<ContactPersonName>");
		    if ((tempString=sadb.getPersonTitle()) != null)
			   out.println("<Title>"+tempString+"</Title>");
			   out.println("<LastName>"+MerchantContactLastName+"</LastName>");
			if ((tempString=sadb.getFirstName()) != null)
			   out.println("<FirstName>"+tempString+"</FirstName>");
			if ((tempString=sadb.getMiddleName()) != null)
			   out.println("<MiddleName>"+tempString+"</MiddleName>");
			out.println("</ContactPersonName>");
         }

		 String ContactInfoPhone1=null;
		 String ContactInfoPhone2=null;
		 String ContactInfoEmail1=null;
		 String ContactInfoEmail2=null;
		 String ContactInfoFax=null;

		 ContactInfoPhone1=sadb.getPhone1();
		 ContactInfoPhone2=sadb.getPhone2();
		 ContactInfoEmail1=sadb.getEmail1();
		 ContactInfoEmail2=sadb.getEmail2();
		 if ((ContactInfoFax=sadb.getFax1()) == null)
  		    ContactInfoFax=sadb.getFax2();

		 if ((ContactInfoPhone1 != null) || (ContactInfoPhone2 != null) ||
			(ContactInfoEmail1 != null) || (ContactInfoEmail2 != null) ||
			(ContactInfoFax != null))
		 {
		    out.println("<ContactInfo>");

            if (ContactInfoPhone1 != null)
			{
			   out.println("<Telephone type=\"primary\">"+ContactInfoPhone1+"</Telephone>");
			   if (ContactInfoPhone2 != null)
			      out.println("<Telephone type=\"secondary\">"+ContactInfoPhone2+"</Telephone>");
			}
			else if (ContactInfoPhone2 != null)
			   out.println("<Telephone type=\"primary\">"+ContactInfoPhone2+"</Telephone>");

			if (ContactInfoEmail1 != null)
			{
			   out.println("<Email type=\"primary\">"+ContactInfoEmail1+"</Email>");
			   if (ContactInfoEmail2 != null)
			      out.println("<Email type=\"secondary\">"+ContactInfoEmail2+"</Email>");
			}
			else if (ContactInfoEmail2 != null)
			   out.println("<Email type=\"primary\">"+ContactInfoEmail2+"</Email>");

			if (ContactInfoFax != null)
			   out.println("<Fax>"+ContactInfoFax+"</Fax>");

			out.println("</ContactInfo>");
         }
	  	 out.println("</MerchantInfo>");
      }
   }

   // Requisitioner Info
   if (requisitionerId != OrderCreateConstants.NOT_AVAILABLE)
   {
	  UserRegistrationDataBean urdb=new UserRegistrationDataBean();
	  urdb.setUserId(requisitionerId);
	  com.ibm.commerce.beans.DataBeanManager.activate(urdb, request);

	  String registerType = urdb.getRegisterType();
	  if (!registerType.equalsIgnoreCase(ECUserConstants.EC_USER_GUEST_SHOPPER)){
	
		 String logonId = urdb.getLogonId();
		 tempString = urdb.getOrganizationName();
		 if (tempString.length() != 0)
		 {
		    out.println("<BuyOrgInfo>");
			out.println("<OrgName>"+tempString+"</OrgName>");
		    out.println("</BuyOrgInfo>");
		 }
	
		 String RequisitionerCity = urdb.getCity();

		 // Requisitioner Info is not empty if Requisitioner City is not empty
		 if (RequisitionerCity.length() != 0)
		 {
			out.println("<RequisitionerInfo>");
			out.println("<RequisitionerID type=\"NCInternal\">"+requisitionerId+"</RequisitionerID>");
			out.println("<RequisitionerID type=\"logon\">"+logonId+"</RequisitionerID>");

		    out.println("<Address>");
			tempString=urdb.getAddress1();
			if (tempString.length() != 0)
			   out.println("<AddressLine>"+tempString+"</AddressLine>");
			tempString=urdb.getAddress2();
			if (tempString.length() != 0)
			   out.println("<AddressLine>"+tempString+"</AddressLine>");
			tempString=urdb.getAddress3();
			if (tempString.length() != 0)
			   out.println("<AddressLine>"+tempString+"</AddressLine>");

			out.println("<City>"+RequisitionerCity+"</City>");
	
			tempString=urdb.getState();
			if (tempString.length() != 0)
			   out.println("<State>"+tempString+"</State>");
			tempString=urdb.getZipCode();
			if (tempString.length() != 0)
			   out.println("<Zip>"+tempString+"</Zip>");
			tempString=urdb.getCountry();
			if (tempString.length() != 0)
			   out.println("<Country>"+tempString+"</Country>");
			out.println("</Address>");

			String RequisitionerLastName = urdb.getLastName();
			if (RequisitionerLastName.length() != 0)
			{
			   out.println("<ContactPersonName>");
			   tempString=urdb.getPersonTitle();
			   if (tempString.length() != 0)
			      out.println("<Title>"+tempString+"</Title>");
			   out.println("<LastName>"+RequisitionerLastName+"</LastName>");
			   tempString=urdb.getFirstName();
			   if (tempString.length() != 0)
			      out.println("<FirstName>"+tempString+"</FirstName>");
			   tempString=urdb.getMiddleName();
			   if (tempString.length() != 0)
			      out.println("<MiddleName>"+tempString+"</MiddleName>");
			   out.println("</ContactPersonName>");
			}

			String RequisitionerInfoPhone1=null;
			String RequisitionerInfoPhone2=null;
			String RequisitionerInfoEmail1=null;
			String RequisitionerInfoEmail2=null;
			String RequisitionerInfoFax=null;

			RequisitionerInfoPhone1=urdb.getPhone1();
			RequisitionerInfoPhone2=urdb.getPhone2();
			RequisitionerInfoEmail1=urdb.getEmail1();
			RequisitionerInfoEmail2=urdb.getEmail2();
			RequisitionerInfoFax=urdb.getFax1();

			if (RequisitionerInfoFax.length() == 0)
			   RequisitionerInfoFax=urdb.getFax2();

			if ((RequisitionerInfoPhone1.length() != 0) || 
			    (RequisitionerInfoPhone2.length() != 0) ||
			    (RequisitionerInfoEmail1.length() != 0) ||
			    (RequisitionerInfoEmail2.length() != 0) ||
			    (RequisitionerInfoFax.length() != 0))
			{
			   out.println("<ContactInfo>");

			   if (RequisitionerInfoPhone1.length() != 0)
			   {
			      out.println("<Telephone type=\"primary\">"+RequisitionerInfoPhone1+"</Telephone>");
			      if (RequisitionerInfoPhone2.length() != 0)
				     out.println("<Telephone type=\"secondary\">"+RequisitionerInfoPhone2+"</Telephone>");
			   }
			   else if (RequisitionerInfoPhone2.length() != 0)
			      out.println("<Telephone type=\"primary\">"+RequisitionerInfoPhone2+"</Telephone>");

			   if (RequisitionerInfoEmail1.length() != 0)
			   {
			      out.println("<Email type=\"primary\">"+RequisitionerInfoEmail1+"</Email>");
			      if (RequisitionerInfoEmail2.length() != 0)
				     out.println("<Email type=\"secondary\">"+RequisitionerInfoEmail2+"</Email>");
			   }
			   else if (RequisitionerInfoEmail2.length() != 0)
			      out.println("<Email type=\"primary\">"+RequisitionerInfoEmail2+"</Email>");

			   if (RequisitionerInfoFax.length() != 0)
			      out.println("<Fax>"+RequisitionerInfoFax+"</Fax>");

			   out.println("</ContactInfo>");
			}
			out.println("</RequisitionerInfo>");
		 }
	  } else {
	 	  out.println("<RequisitionerInfo>");
		  out.println("<RequisitionerID type=\"NCInternal\">"+requisitionerId+"</RequisitionerID>");
	 	  out.println("</RequisitionerInfo>");
	 }
		 
   }

   // PCardInfo
   //for d173736
   boolean compatibleMode = true;
   EDPPaymentInstructionsDataBean edpPIDataBean = new EDPPaymentInstructionsDataBean();
   edpPIDataBean.setOrderId(new Long(orderId));
   com.ibm.commerce.beans.DataBeanManager.activate(edpPIDataBean, request, response);
   ArrayList pis = edpPIDataBean.getPaymentInstructions();
   Iterator iteForPI = pis.iterator();
   //Get compatibleMode from EDPPaymentInstruction data
   if(iteForPI.hasNext()){
       EDPPaymentInstruction aPI = (EDPPaymentInstruction) iteForPI.next();
       Long policyId = aPI.getPolicyId();
       BusinessPolicyRegistryEntry paymentPolicyRegEntry = BusinessPolicyRegistry.singleton().getPolicyRegistryEntry(String.valueOf(policyId));
	   BusinessPolicyAccessBean paymentPolicyAB = paymentPolicyRegEntry.getBean();
	   String properties = paymentPolicyAB.getProperties();
	   if (properties.indexOf(Constants.COMPATIBLE_MODE) < 0) {
		  compatibleMode = false;
	   }
   }
   if(compatibleMode){
       java.util.Enumeration set = null;
	   OrderPaymentMethodAccessBean curr_opmab = null;
	   OrderPaymentMethodAccessBean opmab = new OrderPaymentMethodAccessBean();
	   set = opmab.findByOrder(Long.valueOf(orderId.toString()));
	  
	   if (set.hasMoreElements()) {
	      curr_opmab = (OrderPaymentMethodAccessBean)set.nextElement();
	
	      String cardNumber = null;
	
	      if ((cardNumber=curr_opmab.getPaymentDevice()) != null)
	      {
	         out.println("<PCardInfo>");
	         if ((tempString=curr_opmab.getMaximumAuthorizationAmount()) != null)
	         {
	           if (currString != null)
	             out.println("<MonetaryAmount currency=\""+currString+"\">"+tempString+"</MonetaryAmount>");
	           else
	             out.println("<MonetaryAmount>"+tempString+"</MonetaryAmount>");
	         }
		     if ((tempString=curr_opmab.getPaymentMethodID()) != null)
	           out.println("<CardType>"+tempString+"</CardType>");
	
	         out.println("<CardNumber>"+cardNumber+"</CardNumber>");
	
	         if (curr_opmab.getEndDateInEntityType() != null) {
	           out.println("<ExpirationDate>"+curr_opmab.getEndDate()+"</ExpirationDate>");
	         } else {
	           out.println("<ExpirationDate></ExpirationDate>");
	         }
	         if (curr_opmab.getStartDateInEntityType() != null)
                  out.println("<IssueDate>"+curr_opmab.getStartDate()+"</IssueDate>");
	         out.println("</PCardInfo>");
	      }
	   }
   }else{
       
       //Support new payment exetension data.
       PPCListPIsForOrderDataBean orderPIList = new PPCListPIsForOrderDataBean();
       orderPIList.setOrderId(orderId);
       orderPIList.setStoreId(storeId);
       com.ibm.commerce.beans.DataBeanManager.activate(orderPIList, request);
       List piList = orderPIList.getPaymentInstructionList();
       //output multiple payment methods for an order when compatible mode is false.
       for(int count =0; count < piList.size();count++) {
          
           String account = null;
           String cardType = null;
           List referenceNumbers = new ArrayList();
           String expiredData = null;
           PaymentInstruction pi = (PaymentInstruction) piList.get(count);
           String currency = pi.getCurrency();
           String piAmount = pi.getAmount().toString();
           PPCPIExtendedDataDataBean piExtDataBean = new PPCPIExtendedDataDataBean();
           piExtDataBean.setPIId(pi.getId());
           com.ibm.commerce.beans.DataBeanManager.activate(piExtDataBean, request);
           ExtendedData extData = piExtDataBean.getExtendedData();
           HashMap extDatas = extData.getExtendedDataAsHashMap();
           if(extDatas != null){
              if(extDatas.get(ECConstants.EC_CC_BRAND) != null){
                  cardType = extDatas.get(ECConstants.EC_CC_BRAND).toString();
              }
              if(extDatas.get(ECConstants.EC_CC_ACCOUNT) != null){
                  account = extDatas.get(ECConstants.EC_CC_ACCOUNT).toString();
              }
              if(extDatas.get(ECConstants.EC_CD_YEAR) != null && extDatas.get(ECConstants.EC_CD_MONTH) != null){
                  String year = extDatas.get(ECConstants.EC_CD_YEAR).toString();
                  String month = extDatas.get(ECConstants.EC_CD_MONTH).toString();
                  DateFormat df = DateFormat.getDateTimeInstance();
                  Calendar date = Calendar.getInstance();
                  date.set(new Integer(year).intValue(),new Integer(month).intValue()-1,1,0,0,0);
                  expiredData = df.format(date.getTime());
              }
           }
           //Get reference number list from transacrion data
           PPCListPaymentsForPIDataBean PaymentListBean	= new PPCListPaymentsForPIDataBean();	
	       PaymentListBean.setPIId(pi.getId());
	       com.ibm.commerce.beans.DataBeanManager.activate(PaymentListBean, request);	
           List payments = PaymentListBean.getPaymentsList();
           if(payments != null){
              for(int i=0;i< payments.size();i++){
                 Payment payment = (Payment)payments.get(i);
                 Collection trans = ObjectModuleFacadeFactory.getObjectModuleFacade().getAllTransactionsforPayment(payment.getId());
                 Iterator iter = trans.iterator();
                 while(iter.hasNext()){
                     PPCPayTranData tran = (PPCPayTranData)iter.next();
                     if(tran.getReferenceNumber() != null && !tran.getReferenceNumber().equals("")){
                         if(!referenceNumbers.contains(tran.getReferenceNumber())){
                             referenceNumbers.add(tran.getReferenceNumber());
                         }
                     }
                 }
              }
           }
           //Create xml segement
	       if (account != null){
	         out.println("<PCardInfo>");
	         if (piAmount != null){
	           if (currency != null){
	               out.println("<MonetaryAmount currency=\""+currency+"\">"+piAmount+"</MonetaryAmount>");
	           }else{
	               out.println("<MonetaryAmount>"+piAmount+"</MonetaryAmount>");
	           }
	         }
		     if (cardType != null){
		        out.println("<CardType>"+cardType+"</CardType>");
		     }
	         out.println("<CardNumber>"+account+"</CardNumber>");
	
	         if (expiredData != null) {
	           out.println("<ExpirationDate>"+expiredData+"</ExpirationDate>");
	         } else {
	           out.println("<ExpirationDate></ExpirationDate>");
	         }
	         for(int i=0; i < referenceNumbers.size();i++){
	            out.println("<CreditAuthorizationNumber>"+referenceNumbers.get(i)+"</CreditAuthorizationNumber>");
	         }
	         out.println("</PCardInfo>");
		   }
       }
   }

   if (orderCustomerField1 != null)
	  out.println("<OrderCustomerField>"+orderCustomerField1+"</OrderCustomerField>");
   if (orderCustomerField2 != null)
	  out.println("<OrderCustomerField>"+orderCustomerField2+"</OrderCustomerField>");
   if (orderCustomerField3 != null)
	  out.println("<OrderCustomerField>"+orderCustomerField3+"</OrderCustomerField>");

   out.println("</ReportPOHeader>");


   String itemCurrString;

   for(int i = 0; i < itemBean.length; i++)
   {
	  itemCurrString = null;

	  out.println("<ReportPOItem>");

	  out.println("<ItemLineNumber>" + Integer.toString(i) + "</ItemLineNumber>");
	  out.println("<ItemNumberByNC>" + itemBean[i].getOrderItemId() + "</ItemNumberByNC>");

	  String catentry_id;
	  if ((catentry_id=itemBean[i].getCatalogEntryId()) != null)
	  {
	     CatalogEntryDataBean cedb=new CatalogEntryDataBean();
	     cedb.setCatalogEntryID(catentry_id);
	     com.ibm.commerce.beans.DataBeanManager.activate(cedb, request);

	     if ((tempString=cedb.getPartNumber()) != null)
	        out.println("<ProductNumberByMerchant>" + tempString + "</ProductNumberByMerchant>");
	  }

	  itemCurrString = itemBean[i].getCurrency();

	  // If no currency set at item level, use the one from header/order level.
	  if (itemCurrString == null)
		itemCurrString = currString;

	  if (itemCurrString != null)
		out.println("<ItemUnitPrice currency=\""+ itemCurrString +"\">"+ itemBean[i].getPrice() + "</ItemUnitPrice>");
	  else
		out.println("<ItemUnitPrice>" + itemBean[i].getPrice() + "</ItemUnitPrice>");

	  out.println("<ItemProductQuantity>" + itemBean[i].getQuantity() + "</ItemProductQuantity>");

	  CatalogEntryDescriptionDataBean ceddb=new CatalogEntryDescriptionDataBean();
	  ceddb.setDataBeanKeyLanguage_id(languageId);
	  ceddb.setDataBeanKeyCatalogEntryReferenceNumber(catentry_id);
	  com.ibm.commerce.beans.DataBeanManager.activate(ceddb, request);

	  if ((tempString=ceddb.getShortDescription()) != null)
	     out.println("<ItemProductDescription>" + tempString + "</ItemProductDescription>");

	  // Ship To Info, Check if the Ship To Address Id is stored in OrderItems
	  if (itemBean[i].getAddressIdInEntityType() != null)
	  {
         AddressDataBean adb=new AddressDataBean();
	     adb.setAddressId(itemBean[i].getAddressId());
	     com.ibm.commerce.beans.DataBeanManager.activate(adb, request);

		 String ShipToLastName = null;

		 // ShipToInfo is not empty if ShipToLastName is not empty
		 if ((ShipToLastName=adb.getLastName()) != null)
		 {
		    out.println("<ShipToInfo>");

	        out.println("<ContactPersonName>");
			out.println("<LastName>"+ShipToLastName+"</LastName>");
			if ((tempString=adb.getFirstName()) != null)
				out.println("<FirstName>"+tempString+"</FirstName>");
			if ((tempString=adb.getMiddleName()) != null)
				out.println("<MiddleName>"+tempString+"</MiddleName>");
			if ((tempString=adb.getNickName()) != null)
				out.println("<AlternateName>"+tempString+"</AlternateName>");
	        out.println("</ContactPersonName>");

			out.println("<Address>");
			if ((tempString=adb.getAddress1()) != null)
				out.println("<AddressLine>"+tempString+"</AddressLine>");
			if ((tempString=adb.getAddress2()) != null)
				out.println("<AddressLine>"+tempString+"</AddressLine>");
			if ((tempString=adb.getAddress3()) != null)
				out.println("<AddressLine>"+tempString+"</AddressLine>");
		    if ((tempString=adb.getCity()) != null)
				out.println("<City>"+tempString+"</City>");
			if ((tempString=adb.getState()) != null)
				out.println("<State>"+tempString+"</State>");
			if ((tempString=adb.getZipCode()) != null)
				out.println("<Zip>"+tempString+"</Zip>");
			if ((tempString=adb.getCountry()) != null)
				out.println("<Country>"+tempString+"</Country>");
			out.println("</Address>");

			String ShipToInfoPhone1=null;
			String ShipToInfoPhone2=null;
			String ShipToInfoEmail1=null;
			String ShipToInfoEmail2=null;
			String ShipToInfoFax=null;

			ShipToInfoPhone1=adb.getPhone1();
			ShipToInfoPhone2=adb.getPhone2();
			ShipToInfoEmail1=adb.getEmail1();
			ShipToInfoEmail2=adb.getEmail2();

			if ((ShipToInfoFax=adb.getFax1()) == null)
				ShipToInfoFax=adb.getFax2();

			if ((ShipToInfoPhone1 != null) || (ShipToInfoPhone2 != null) ||
				(ShipToInfoEmail1 != null) || (ShipToInfoEmail2 != null) ||
				(ShipToInfoFax != null))
			{
				out.println("<ContactInfo>");

				if (ShipToInfoPhone1 != null)
				{
					out.println("<Telephone type=\"primary\">"+ShipToInfoPhone1+"</Telephone>");
					if (ShipToInfoPhone2 != null)
						out.println("<Telephone type=\"secondary\">"+ShipToInfoPhone2+"</Telephone>");
				}
				else if (ShipToInfoPhone2 != null)
					out.println("<Telephone type=\"primary\">"+ShipToInfoPhone2+"</Telephone>");

				if (ShipToInfoEmail1 != null)
				{
					out.println("<Email type=\"primary\">"+ShipToInfoEmail1+"</Email>");
					if (ShipToInfoEmail2 != null)
						out.println("<Email type=\"secondary\">"+ShipToInfoEmail2+"</Email>");
				}
				else if (ShipToInfoEmail2 != null)
					out.println("<Email type=\"primary\">"+ShipToInfoEmail2+"</Email>");

				if (ShipToInfoFax != null)
					out.println("<Fax>"+ShipToInfoFax+"</Fax>");

				out.println("</ContactInfo>");
			}
			if ((tempString=itemBean[i].getComment()) != null)
				out.println("<Comment>"+tempString+"</Comment>");

	        out.println("</ShipToInfo>");
		 }
      }

    if (itemBean[i].getShippingModeIdInEntityType() != null)
	     shipModeId = itemBean[i].getShippingModeId();

	  // Check if ship mode is set (at either item level or store level earlier).
      if (shipModeId != null)
  	  {
         ShippingModeDataBean smdb=new ShippingModeDataBean();
	     smdb.setDataBeanKeyShippingModeId(shipModeId);
	     com.ibm.commerce.beans.DataBeanManager.activate(smdb, request);

	     out.println("<ShippingCarrierInfo>");
		 if ((tempString=smdb.getCarrier()) != null)
		    out.println("<Carrier>"+tempString+"</Carrier>");
		 if ((tempString=smdb.getCode()) != null)
		    out.println("<Method>"+tempString+"</Method>");
	     out.println("</ShippingCarrierInfo>");
	  }

      if ((tempString=itemBean[i].getStatus()) != null)
	     out.println("<ShipStatus>"+tempString+"</ShipStatus>");

      if (itemBean[i].getTimeCreatedInEntityType() != null)
	  {
	     tempString=itemBean[i].getTimeCreated();
	     tempString=tempString.trim();
		 String tempDate=null;
		 String tempTime=null;

		 tempDate=tempString.substring(0,4);
		 tempDate +=tempString.substring(5,7);
		 tempDate +=tempString.substring(8,10);

		 tempTime=tempString.substring(11,13);
		 tempTime +=tempString.substring(14,16);
		 tempTime +=tempString.substring(17,19);

		 out.println("<DateTimeReference>");
		 out.println("<PlacedDate>"+tempDate+"</PlacedDate>");
		 out.println("<PlacedTime>"+tempTime+"</PlacedTime>");

		 if (itemBean[i].getLastUpdateInEntityType() != null)
		 {
 		    tempString=itemBean[i].getLastUpdate();
		    tempString=tempString.trim();

		    tempDate=tempString.substring(0,4);
		    tempDate +=tempString.substring(5,7);
		    tempDate +=tempString.substring(8,10);

		    tempTime=tempString.substring(11,13);
		    tempTime +=tempString.substring(14,16);
		    tempTime +=tempString.substring(17,19);

		    out.println("<LastUpdateDate>"+tempDate+"</LastUpdateDate>");
		    out.println("<LastUpdateTime>"+tempTime+"</LastUpdateTime>");

		    out.println("</DateTimeReference>");
         }
      }

	  if (itemBean[i].getField1InEntityType() != null)
	     out.println("<ItemCustomerField>"+itemBean[i].getField1()+"</ItemCustomerField>");
	  if ((tempString=itemBean[i].getField2()) != null)
	     out.println("<ItemCustomerField>"+tempString+"</ItemCustomerField>");

      out.println("</ReportPOItem>");
   }

   out.println("</ReportPO>");
   out.println("</DataArea>");
   out.print("</Report_NC_PurchaseOrder>");
}
catch (Exception e) { out.print( "Exception =>" + e); }
%>
