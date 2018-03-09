//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2007, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

//
//

/**
* @fileOverview This file holds methods to perform display logic in History Order Details page when the order info is retrieved from Sterling Selling And Fulfillment Suite.<b>  
*			This file is referenced in SBSOrderDetails.jsp, SBSOrderDetailSummary.jsp and SBSMSOrderItemDetailSummary.jsp.
*
* @version 1.0
**/

/**
* @class sterlingIntegrationJS This class defines all the variables and functions used by the SterlingIntegration.js. Any page that will use a function in this file
*		can access that function thru this class. Pages that use sterlingIntegrationJS include SBSOrderDetails.jsp, SBSOrderDetailSummary.jsp and SBSMSOrderItemDetailSummary.jsp.
*
**/

sterlingIntegrationJS={
	
			/** The language ID currently in use **/
			langId: "-1",
			
			/** The store ID currently in use **/
			storeId: "",
			
			/** The catalog ID currently in use **/
			catalogId: "",
			
			/** The locale currently in use **/
			locale: "",
			
			/** The image files directory in current store **/ 
			jspStoreImgDir: "",
			
			orderBeingCanceled: "",
				/**
				* setCommonParameters This function initializes storeId, catalogId, langId, locale and store image directory.
				*
				* @param {String} langId The language id to use.
				* @param {String} storeId The store id to use.
				* @param {String} catalogId The catalog id to use.
				* @param {String} locale The locale to use.
				* @param (String) jspStoreImgDir the store image files directory to use.
				* 
				**/
				setCommonParameters:function(langId,storeId,catalogId,locale,jspStoreImgDir){
					this.langId = langId;
					this.storeId = storeId;
					alert('-1 '+this.storeId);
					this.catalogId = catalogId;
					this.locale = locale;
					this.jspStoreImgDir = jspStoreImgDir;
				},
				
				/**
				* populateOrderLevelInfo This function populates the order level information for the order retrieved from Sterling * in history order details page.
				*
				* @param {String} orderStr The json string for complete order information.
				* 
				**/
				populateOrderLevelInfo:function(orderStr){
					//alert('0 '+this.storeId);
					//orderStr = orderStr.replace("'", '&quot;');
					var jsonOrder = eval("("+orderStr+")");
					var locale = document.getElementById('Locale_String').innerHTML;
					var shipmentType = 2;
					if(!this.isNullObj(jsonOrder.Root.Order.shipmentTypeId)){
						shipmentType = jsonOrder.Root.Order.shipmentTypeId;
					}
					var pmTotalNumber = 0;
					if(!this.isNullObj(jsonOrder.Root.Order.countOfPaymentMethods)){
						pmTotalNumber = jsonOrder.Root.Order.countOfPaymentMethods;
					}
					var oiTotalNumber = 1;
					if(!this.isNullObj(jsonOrder.Root.Order.countOfOrderLines)){
						oiTotalNumber = jsonOrder.Root.Order.countOfOrderLines;
					}
					
					//Order Number field
					if(!this.isNullObj(jsonOrder.Root.Order.OrderNo)){
						var orderNo = jsonOrder.Root.Order.OrderNo;	
						if(!this.isNullObj(jsonOrder.Root.Order.EntryType)){
							var entryType = jsonOrder.Root.Order.EntryType;
							if(entryType == 'WCS'){
								document.getElementById('OrderNo').innerHTML = orderNo.substring(3);
							}else{
								document.getElementById('OrderNo').innerHTML = orderNo;
							}
						}else{
							document.getElementById('OrderNo').innerHTML = orderNo;
						}
					}
					
					//Order Date field
					if(!this.isNullObj(jsonOrder.Root.Order.OrderDate)){
						var orderDate = jsonOrder.Root.Order.OrderDate;
						var parsedOrderDate = new Date(orderDate);
						document.getElementById('OrderDate').innerHTML = Globalize.formatDate(parsedOrderDate, {date: "long"});
					}
					
					//Single Shipment
					if(shipmentType == 1){
						
						//Shipping Address
						var shippingAddress = null;				
						var orderLinePersonInfoShipTo = null;
						
						if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine)){							
							if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine.PersonInfoShipTo)){								
								orderLinePersonInfoShipTo = jsonOrder.Root.Order.OrderLines.OrderLine.PersonInfoShipTo;
							}else if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine[0])){								
								if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine[0].PersonInfoShipTo)){
									orderLinePersonInfoShipTo = jsonOrder.Root.Order.OrderLines.OrderLine[0].PersonInfoShipTo;							
								}
							}				
						}
						if(!this.isNullObj(orderLinePersonInfoShipTo)){
							this.populateAddress(orderLinePersonInfoShipTo, 'Single_Shipping_Address', locale);
						}else if(!this.isNullObj(jsonOrder.Root.Order.PersonInfoShipTo)){
							this.populateAddress(jsonOrder.Root.Order.PersonInfoShipTo, 'Single_Shipping_Address', locale);
						}
								
						//Shipping Method
						var shippingMethod = null;		
						if(!this.isNullObj(jsonOrder.Root.Order.Shipments)){
						if(!this.isNullObj(jsonOrder.Root.Order.Shipments.Shipment)){			
						 	if(!this.isNullObj(jsonOrder.Root.Order.Shipments.Shipment.shipModeDescription)){
								shippingMethod = jsonOrder.Root.Order.Shipments.Shipment.shipModeDescription;
							}else if(!this.isNullObj(jsonOrder.Root.Order.Shipments.Shipment[0])){
								if(!this.isNullObj(jsonOrder.Root.Order.Shipments.Shipment[0].shipModeDescription)){
									shippingMethod = jsonOrder.Root.Order.Shipments.Shipment[0].shipModeDescription;
								}
							}
						}
						}
						if(this.isNullObj(shippingMethod)){
							if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine)){							
								if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine.shipModeDescription)){								
									shippingMethod = jsonOrder.Root.Order.OrderLines.OrderLine.shipModeDescription;
								}else if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine[0])){								
									if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine[0].shipModeDescription)){
										shippingMethod = jsonOrder.Root.Order.OrderLines.OrderLine[0].shipModeDescription;									
									}
								}				
							}
						}
						if(this.isNullObj(shippingMethod)){
							if(!this.isNullObj(jsonOrder.Root.Order.CarrierServiceCode)){
								shippingMethod = jsonOrder.Root.Order.shipModeDescription;			
							}	
						}								
						if(!this.isNullObj(shippingMethod)){
							document.getElementById('Single_Shipping_Method').innerHTML = shippingMethod;
						}
						
						//Shipping Instruction
						if(!this.isNullObj(document.getElementById('Single_Shipping_Instruction'))){
							var instructions = null;
							if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine)){							
								if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine.Instructions)){								
									instructions = jsonOrder.Root.Order.OrderLines.OrderLine.Instructions;
								}else if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine[0])){								
									if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine[0].Instructions)){
										instructions = jsonOrder.Root.Order.OrderLines.OrderLine[0].Instructions;
									}
								}				
							}
							if(!this.isNullObj(instructions)){
								if(!this.isNullObj(instructions.Instruction)){					
									var instruction = instructions.Instruction;
									if(!this.isNullObj(instruction.InstructionType)){				
										if(instruction.InstructionType=='SHIP'){								
											if(!this.isNullObj(instruction.InstructionText)){
												document.getElementById('Single_Shipping_Instruction_Label').style.display = 'inline';
												document.getElementById('Single_Shipping_Instruction').innerHTML = instruction.InstructionText;
											}
										}
									}else if(!this.isNullObj(instructions.Instruction[0])){
										//more than one instruction
										for(var k in instructions.Instruction){						
											if(!this.isNullObj(instructions.Instruction[k].InstructionType)){
												if(instructions.Instruction[k].InstructionType=='SHIP'){									
													if(!this.isNullObj(instructions.Instruction[k].InstructionText)){
														document.getElementById('Single_Shipping_Instruction_Label').style.display = 'inline';
														document.getElementById('Single_Shipping_Instruction').innerHTML = document.getElementById('Single_Shipping_Instruction').innerHTML + instructions.Instruction[k].InstructionText+'<br/>';
													}
												}
											}
										}
									}				
								}else{
									//no instruction
								}
							}//no instructions
							
						}
					}
					
					//Ship As Complete
					if(!this.isNullObj(document.getElementById('Shipping_As_Complete_Y'))){
						if(!this.isNullObj(jsonOrder.Root.Order.IsShipComplete)){
							var shipAsComplete = jsonOrder.Root.Order.IsShipComplete;
							if(shipAsComplete == 'Y'){
								document.getElementById('Shipping_As_Complete_Y').style.display = 'inline';
								document.getElementById('Shipping_As_Complete_N').style.display = 'none';
							}else{
								document.getElementById('Shipping_As_Complete_Y').style.display = 'none';
								document.getElementById('Shipping_As_Complete_N').style.display = 'inline';
							}
						}
					}
					
					var currencyCode = 'USD';
					if(!this.isNullObj(jsonOrder.Root.Order.PriceInfo.Currency)){
						currencyCode = jsonOrder.Root.Order.PriceInfo.Currency;
					}
					var currencyDecimals = 2;
					if(!this.isNullObj(jsonOrder.Root.Order.PriceInfo.currencyDecimal)){
						currencyDecimals = jsonOrder.Root.Order.PriceInfo.currencyDecimal;
					}
					var currencySymbol = '$'
					if(!this.isNullObj(jsonOrder.Root.Order.PriceInfo.currencySymbol)){
						currencySymbol = jsonOrder.Root.Order.PriceInfo.currencySymbol;
					}
					//Line SubTotal
					if(!this.isNullObj(jsonOrder.Root.Order.OverallTotals.LineSubTotal)){
						document.getElementById('Order_SubTotal').innerHTML = this.formatCurrency(jsonOrder.Root.Order.OverallTotals.LineSubTotal, currencyDecimals, currencySymbol, currencyCode, locale);
					}	
					
					//Grand Discount
					var grandDiscount = jsonOrder.Root.Order.OverallTotals.GrandDiscount;
					if(!this.isNullObj(grandDiscount)){
						if(grandDiscount > 0){
							grandDiscount = (0 - grandDiscount) + "";
						}
						document.getElementById('Order_Discount').innerHTML = this.formatCurrency(grandDiscount, currencyDecimals, currencySymbol, currencyCode, locale);
					}
					
					//Grand Shipping Base Charge
					if(!this.isNullObj(jsonOrder.Root.Order.OverallTotals.GrandShippingBaseCharge)){
						document.getElementById('Order_Shipping').innerHTML = this.formatCurrency(jsonOrder.Root.Order.OverallTotals.GrandShippingBaseCharge, currencyDecimals, currencySymbol, currencyCode, locale);
					}
					
					//Total Tax
					if(!this.isNullObj(jsonOrder.Root.Order.OverallTotals.salesTax)){
						document.getElementById('Order_Tax').innerHTML = this.formatCurrency(jsonOrder.Root.Order.OverallTotals.salesTax, currencyDecimals, currencySymbol, currencyCode, locale);
					}
					
					//Shipping Tax
					if(!this.isNullObj(jsonOrder.Root.Order.OverallTotals.shippingTax)){
						document.getElementById('Order_ShippingTax').innerHTML = this.formatCurrency(jsonOrder.Root.Order.OverallTotals.shippingTax, currencyDecimals, currencySymbol, currencyCode, locale);
					}
					
					//Grand Total
					if(!this.isNullObj(jsonOrder.Root.Order.OverallTotals.GrandTotal)){
						document.getElementById('Order_Totals').innerHTML = this.formatCurrency(jsonOrder.Root.Order.OverallTotals.GrandTotal, currencyDecimals, currencySymbol, currencyCode, locale);
					}
					
					//Billing Address When No Payment Method
					if(pmTotalNumber == 0){
						if(!this.isNullObj(jsonOrder.Root.Order.PersonInfoBillTo)){			
							this.populateAddress(jsonOrder.Root.Order.PersonInfoBillTo, 'Billing_Address_With_No_Payment_Method', locale);			
						}
					}
					
					//Payment section
						for(var i=0; i<pmTotalNumber; i++ ){	
							var paymentMethod = null;
							if(pmTotalNumber == 1){
								paymentMethod = jsonOrder.Root.Order.PaymentMethods.PaymentMethod;
							}else{		
								paymentMethod = jsonOrder.Root.Order.PaymentMethods.PaymentMethod[i];
							}			
							
							//Payment Method Billing Address
							if(!this.isNullObj(paymentMethod.PersonInfoBillTo)){
								this.populateAddress(paymentMethod.PersonInfoBillTo, 'Billing_Address_'+i, locale);
							}else if(!this.isNullObj(jsonOrder.Root.Order.PersonInfoBillTo)){
								this.populateAddress(jsonOrder.Root.Order.PersonInfoBillTo, 'Billing_Address_'+i, locale);
							}
							
							//Payment Method Name
							if(!this.isNullObj(paymentMethod.paymentMethodName)){
								document.getElementById('Payment_Method_Name_'+i).innerHTML = paymentMethod.paymentMethodName;
							}
							//for CAAS
							/*if(!this.isNullObj(paymentMethod.PaymentType)){
								if(paymentMethod.PaymentType == 'CREDIT_CARD'){
									if(!this.isNullObj(paymentMethod.CreditCardType)){
										document.getElementById('Payment_Method_Name_'+i).innerHTML = paymentMethod.CreditCardType;
									}
								}else{
									document.getElementById('Payment_Method_Name_'+i).innerHTML = paymentMethod.PaymentType;
								}
							}*/
							
							if(!this.isNullObj(paymentMethod.PaymentType)){
								if(paymentMethod.PaymentType == 'CREDIT_CARD'){
									document.getElementById('Div_CreditCard_'+i).style.display = 'inline';
									document.getElementById('Div_Check_'+i).style.display = 'none';
									document.getElementById('Div_LineOfCredit_'+i).style.display = 'none';
									
									if(!this.isNullObj(paymentMethod.DisplayCreditCardNo)){
										document.getElementById('CreditCard_Account_'+i).innerHTML = '************'+ paymentMethod.DisplayCreditCardNo;
									}
									if(!this.isNullObj(paymentMethod.CreditCardExpDate)){
										document.getElementById('CreditCard_Expiration_Month_'+i).innerHTML = paymentMethod.CreditCardExpDate.substring(0,2);
										document.getElementById('CreditCard_Expiration_Year_'+i).innerHTML = paymentMethod.CreditCardExpDate.substring(3,7);
										//document.getElementById('CreditCard_Expiration_Year_'+i).innerHTML = paymentMethod.CreditCardExpDate.substring(2,6);
									}					
								}
								if(paymentMethod.PaymentType == 'Check'){
									document.getElementById('Div_CreditCard_'+i).style.display = 'none';
									document.getElementById('Div_Check_'+i).style.display = 'inline';
									document.getElementById('Div_LineOfCredit_'+i).style.display = 'none';
									
									if(!this.isNullObj(paymentMethod.DisplayPaymentReference1)){
										document.getElementById('Check_Account_'+i).innerHTML = '************'+ paymentMethod.DisplayPaymentReference1;
									}
								}
								
								if(paymentMethod.PaymentType == 'LineOfCreidt'){
									document.getElementById('Div_CreditCard_'+i).style.display = 'none';
									document.getElementById('Div_Check_'+i).style.display = 'none';
									document.getElementById('Div_LineOfCredit_'+i).style.display = 'inline';
									
									if(!this.isNullObj(paymentMethod.DisplayCustomerAccountNo)){
										document.getElementById('LineOfCredit_Account_'+i).innerHTML = '************'+ paymentMethod.DisplayCustomerAccountNo;
									}
								}
								
								if(!this.isNullObj(paymentMethod.MaxChargeLimit)){
									document.getElementById('Payment_Method_Amount_'+i).innerHTML = this.formatCurrency(paymentMethod.MaxChargeLimit, currencyDecimals, currencySymbol, currencyCode, locale);
								}
							}	
										
						}
				},
				
				populateAddress: function(address, addrDiv, locale){					
					var addressId = '';
					if(!this.isNullObj(address.AddressID)){addressId = address.AddressID;}
					var firstName = '';
					if(!this.isNullObj(address.FirstName)){firstName = address.FirstName;}
					var middleName = '';
					if(!this.isNullObj(address.MiddleName)){middleName = address.MiddleName;}
					var lastName = '';
					if(!this.isNullObj(address.LastName)){lastName = address.LastName;}
					var addressLine1 = '';
					if(!this.isNullObj(address.AddressLine1)){addressLine1 = address.AddressLine1;}
					var addressLine2 = '';
					if(!this.isNullObj(address.AddressLine2)){addressLine2 = address.AddressLine2;}
					var city = '';
					if(!this.isNullObj(address.City)){city = address.City;}
					var state = '';
					if(!this.isNullObj(address.stateDisplayName)){state = address.stateDisplayName;}	
					var country = '';
					if(!this.isNullObj(address.countryDisplayName)){country = address.countryDisplayName;}					
					var zipCode = '';
					if(!this.isNullObj(address.ZipCode)){zipCode = address.ZipCode;}	
					var telephone = '';
					if(!this.isNullObj(address.DayPhone)){telephone = address.DayPhone;}	
					var email = '';
					if(!this.isNullObj(address.EMailID)){email = address.EMailID;}	
							
					var addressContent = '<p>'+addressId+'</p>';
					if(locale == 'ar_EG'){
						
						if(firstName.length > 0 || middleName.length > 0 || lastName.length > 0){
							addressContent = addressContent + firstName + '&nbsp;' + middleName + '&nbsp;' + lastName + '<br />';
						}
						if(addressLine1.length > 0 || addressLine2.length > 0){
							addressContent = addressContent + addressLine1 + '&nbsp;'+ addressLine2 + '<br />';
						}
						if(city.length > 0){
							addressContent = addressContent + city +'<br />';
						}
						if(state.length > 0){
							addressContent = addressContent + state +'<br />';
						}
						if(country.length > 0){
							addressContent = addressContent + country +'<br />';
						}
						if(telephone.length > 0){
							addressContent = addressContent + telephone +'<br />';
						}
						
					}else if(locale == 'ja_JP' || locale == 'ko_KR' || locale == 'zh_CN' || locale == 'zh_TW'){
						
						if(lastName.length > 0 || firstName.length > 0){
							addressContent = addressContent + lastName + '&nbsp;' + firstName + '<br />';
						}
						if(country.length > 0 || zipCode.length > 0){
							addressContent = addressContent + country +'&nbsp;'+ zipCode +'&nbsp;<br />';
						}
						if(state.length > 0 || city.length > 0){
							addressContent = addressContent + state +'&nbsp;'+ city +'&nbsp;<br />';
						}
						if(addressLine1.length > 0 || addressLine2.length > 0){
							addressContent = addressContent + addressLine1 + '&nbsp;'+ addressLine2 + '<br />';
						}
						if(telephone.length > 0){
							addressContent = addressContent + telephone +'<br />';
						}
						
					}else if(locale == 'de_DE' || locale == 'es_ES' || locale == 'fr_FR' || locale == 'it_IT' || locale == 'pl_PL' || locale == 'ro_RO' || locale == 'ru_RU'){
						
						if(firstName.length > 0 || middleName.length > 0 || lastName.length > 0){
							addressContent = addressContent + firstName + '&nbsp;' + middleName + '&nbsp;' + lastName + '<br />';
						}
						if(addressLine1.length > 0 || addressLine2.length > 0){
							addressContent = addressContent + addressLine1 + '&nbsp;'+ addressLine2 + '<br />';
						}
						if(zipCode.length > 0 || city.length > 0){
							addressContent = addressContent + zipCode +'&nbsp;'+ city +'&nbsp;<br />';
						}
						if(state.length > 0){
							addressContent = addressContent + state +'<br />';
						}
						if(country.length > 0){
							addressContent = addressContent + country +'<br />';
						}
						if(telephone.length > 0){
							addressContent = addressContent + telephone +'<br />';
						}
						
					}else{
						
						if(firstName.length > 0 || lastName.length > 0){
							addressContent = addressContent + firstName + '&nbsp;' + lastName + '<br />';
						}
						if(addressLine1.length > 0 || addressLine2.length > 0){
							addressContent = addressContent + addressLine1 + '&nbsp;'+ addressLine2 + '<br />';
						}
						if(city.length > 0 || state.length > 0){
							addressContent = addressContent + city +'&nbsp;'+ state +'&nbsp;<br />';
						}
						if(country.length > 0 || zipCode.length > 0){
							addressContent = addressContent + country +'&nbsp;'+ zipCode +'&nbsp;<br />';
						}
						if(telephone.length > 0){
							addressContent = addressContent + telephone +'<br />';
						}
						if(email.length > 0){
							addressContent = addressContent + email +'<br />';
						}
						
					}
					document.getElementById(addrDiv).innerHTML = addressContent;
				},
				
				isNullObj: function(obj){
					if(obj != null && typeof(obj) != undefined){
						return false;
					}else{
						return true;
					}
				},
				
				formatCurrency: function(amount, decimals, symbol, currency, locale){
					return Utils.formatCurrency(amount, {
						minimumFractionDigits: parseInt(decimals),
						maximumFractionDigits: parseInt(decimals),
						currency: currency,
						locale: locale
					});
				},
				
				/**
				 * This function replace the special chars back for the path related string.
				 * 
				 * @param {String} str The string relates to path.
				 * @return (String) The replaced String.
				 */
				revertAllSpecialChars: function (str) {
					if(!this.isNullObj(str)){
						return str.replace(/&#62;/g, ">").replace(/&#60;/g, "<").replace(/&#39;/g, "'").replace(/&#34;/g, "\"").replace(/&#92;/g, "\\").replace(/&#38;/g, "&");
					} else {
						return str;
					}
				},
				
				/**
				* populateOrderLineInfoForSingleShipment This function populates the order line level information for the order 
				* retrieved from Sterling in history order details page with single shipment layout.
				*
				* @param {String} orderStr The json string for complete order information.
				* @param {Integer} beginIndex The begin index of the current order items page.
				* @param {Integer} pageSize The page size of the current order items page.
				*
				**/
				populateOrderLineInfoForSingleShipment: function(orderStr, beginIndex, pageSize){
					//alert('1 '+this.storeId);
					if(orderStr == null || orderStr === "") return;
					
					orderStr = orderStr.replace("'", "27%");
					var jsonOrder = eval("("+orderStr+")");
					var imgDir = document.getElementById('Image_Dir').innerHTML;
					var endIndex = document.getElementById('endIndex').innerHTML;
					var locale = document.getElementById('Locale_String_S').innerHTML;
					
					var orderLineNum = 1;
					if(!this.isNullObj(jsonOrder.Root.Order.countOfOrderLines)){
						orderLineNum = jsonOrder.Root.Order.countOfOrderLines;
					}
					//alert(document.getElementById('order_details').childNodes[1]);
					//alert(document.getElementById('order_details').childNodes[1].tagName);
					if(document.getElementById('order_details').childNodes[0].tagName == 'TBODY'){
						var parentTable = document.getElementById('order_details').childNodes[0];
					}else if(document.getElementById('order_details').childNodes[1].tagName == 'TBODY'){
						var parentTable = document.getElementById('order_details').childNodes[1];
					}
					
					
					for(var i=beginIndex; i<endIndex; i++){
						var orderLine = null;
						if(orderLineNum == 1){
							if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine[0])){
							    orderLine = jsonOrder.Root.Order.OrderLines.OrderLine[0];
							} else {
							    orderLine = jsonOrder.Root.Order.OrderLines.OrderLine;
							}
						}else{
							orderLine = jsonOrder.Root.Order.OrderLines.OrderLine[i];
						}
						var nobottom = null;
						if(!this.isNullObj(orderLine.CalculationCodes)){
							if(!this.isNullObj(orderLine.CalculationCodes.CalculationCode)){
								nobottom = 'th_align_left_no_bottom';							
							}
						}
						if(!this.isNullObj(nobottom)){
							document.getElementById('SingleShipment_rowHeader_product'+i).setAttribute('class', document.getElementById('SingleShipment_rowHeader_product'+i).getAttribute('class')+nobottom);
							document.getElementById('SingleShipment_rowHeader_product'+i).setAttribute('className', document.getElementById('SingleShipment_rowHeader_product'+i).getAttribute('className')+nobottom);
							if(!this.isNullObj(document.getElementById('WC_OrderItemDetailsSummaryf_td_requestedShippingDate_'+i))){
								document.getElementById('WC_OrderItemDetailsSummaryf_td_requestedShippingDate_'+i).setAttribute('class', document.getElementById('WC_OrderItemDetailsSummaryf_td_requestedShippingDate_'+i).getAttribute('class')+nobottom);
								document.getElementById('WC_OrderItemDetailsSummaryf_td_requestedShippingDate_'+i).setAttribute('className', document.getElementById('WC_OrderItemDetailsSummaryf_td_requestedShippingDate_'+i).getAttribute('className')+nobottom);
							}
							document.getElementById('WC_OrderItemDetailsSummaryf_td_1_'+i).setAttribute('class', document.getElementById('WC_OrderItemDetailsSummaryf_td_1_'+i).getAttribute('class')+nobottom);
							document.getElementById('WC_OrderItemDetailsSummaryf_td_1_'+i).setAttribute('className', document.getElementById('WC_OrderItemDetailsSummaryf_td_1_'+i).getAttribute('className')+nobottom);
							document.getElementById('WC_OrderItemDetailsSummaryf_td_2_'+i).setAttribute('class', document.getElementById('WC_OrderItemDetailsSummaryf_td_2_'+i).getAttribute('class')+nobottom);
							document.getElementById('WC_OrderItemDetailsSummaryf_td_2_'+i).setAttribute('className', document.getElementById('WC_OrderItemDetailsSummaryf_td_2_'+i).getAttribute('className')+nobottom);
							document.getElementById('WC_OrderItemDetailsSummaryf_td_3_'+i).setAttribute('class', document.getElementById('WC_OrderItemDetailsSummaryf_td_3_'+i).getAttribute('class')+nobottom);
							document.getElementById('WC_OrderItemDetailsSummaryf_td_3_'+i).setAttribute('className', document.getElementById('WC_OrderItemDetailsSummaryf_td_3_'+i).getAttribute('className')+nobottom);
							document.getElementById('WC_OrderItemDetailsSummaryf_td_4_'+i).setAttribute('class', document.getElementById('WC_OrderItemDetailsSummaryf_td_4_'+i).getAttribute('class')+nobottom);
							document.getElementById('WC_OrderItemDetailsSummaryf_td_4_'+i).setAttribute('className', document.getElementById('WC_OrderItemDetailsSummaryf_td_4_'+i).getAttribute('className')+nobottom);
						}
						//catalog entry info	
						var catEntryName = null;
						var thumbNail = null;
						var objectPath = null;
						var itemID = null;
						if(!this.isNullObj(orderLine.Item.CatalogEntry)){
							if(!this.isNullObj(orderLine.Item.CatalogEntry.objectPath)){
								objectPath = orderLine.Item.CatalogEntry.objectPath;
							}
							if(!this.isNullObj(orderLine.Item.CatalogEntry.CatalogEntryDescription)){
								if(!this.isNullObj(orderLine.Item.CatalogEntry.CatalogEntryDescription.catalogEntryName)){
									catEntryName = orderLine.Item.CatalogEntry.CatalogEntryDescription.catalogEntryName;
								}
								if(!this.isNullObj(orderLine.Item.CatalogEntry.CatalogEntryDescription.thumbNail)){
									thumbNail = orderLine.Item.CatalogEntry.CatalogEntryDescription.thumbNail;
								}
							}			
						}
						if(!this.isNullObj(orderLine.Item.ItemID)){
							itemID = orderLine.Item.ItemID;
						}
						
						if(!this.isNullObj(thumbNail)){
							thumbNail = this.revertAllSpecialChars(thumbNail);
							if(!this.isNullObj(objectPath)){
								objectPath = this.revertAllSpecialChars(objectPath);
								document.getElementById('Product_Thumbnail_'+i).setAttribute('src', objectPath+thumbNail);			
							}else {
								document.getElementById('Product_Thumbnail_'+i).setAttribute('src', thumbNail);			
							}
							
						}else{
							document.getElementById('Product_Thumbnail_'+i).setAttribute('src', imgDir+'images/NoImageIcon_sm.jpg');
						}		
						if(!this.isNullObj(catEntryName)){
							document.getElementById('SingleShipment_rowHeader_product'+i).setAttribute('abbr', document.getElementById('SingleShipment_rowHeader_product'+i).getAttribute('abbr')+catEntryName);
							document.getElementById('Product_Thumbnail_'+i).setAttribute('alt',	catEntryName);
							document.getElementById('Catalog_Entry_Name_'+i).innerHTML = catEntryName;
						}
						if(!this.isNullObj(itemID)){
							document.getElementById('Catalog_Entry_SKU_'+i).innerHTML = itemID;
						}
						
						//Defining attributes
						if(!this.isNullObj(orderLine.Item.CatalogEntry)){
							if(!this.isNullObj(orderLine.Item.CatalogEntry.catalogEntryAttributes)){
								document.getElementById('Catalog_Entry_Defining_Attributes_'+i).style.display = 'inline';
								for(var dAttr in orderLine.Item.CatalogEntry.catalogEntryAttributes.catalogEntryAttribute){
									document.getElementById('Catalog_Entry_Defining_Attributes_'+i).innerHTML = document.getElementById('Catalog_Entry_Defining_Attributes_'+i).innerHTML + orderLine.Item.CatalogEntry.catalogEntryAttributes.catalogEntryAttribute[dAttr].catalogEntryAttrName + ':'+ orderLine.Item.CatalogEntry.catalogEntryAttributes.catalogEntryAttribute[dAttr].catalogEntryAttrValue + '<br/>';
								}
							}
						}
						
						//Component names for DK
						if(!this.isNullObj(orderLine.componentNames)){
							var dkLabel = document.getElementById('Dynamic_Kit_Components_Label_'+i);
							if(!this.isNullObj(dkLabel)){
								document.getElementById('Dynamic_Kit_Components_Label_'+i).style.display = 'inline';
							}
							
							var ulForDK = document.getElementById('Dynamic_Kit_Components_'+i);
							if(!this.isNullObj(ulForDK)){
								var compNames = orderLine.componentNames.split(',');
								for(var j in compNames){
									var li = document.createElement('li');
									li.innerHTML = compNames[j];
									ulForDK.appendChild(li);
								}
							}
						} 
						
						//request ship date
						if(!this.isNullObj(document.getElementById('Order_Item_Requested_Ship_Date_'+i))){
							if(!this.isNullObj(orderLine.ReqShipDate)){
								var parsedReqShipDate = new Date(orderLine.ReqShipDate);
								document.getElementById('Order_Item_Requested_Ship_Date_'+i).innerHTML = Globalize.formatDate(parsedReqShipDate, {date: "long"});
							}
						}
						
						//order line status
						if(!this.isNullObj(orderLine.MaxLineStatus)){							
							document.getElementById('Order_Item_Status_'+i).innerHTML = Utils.getLocalizationMessage("ORDER_LINE_STATUS_"+orderLine.MaxLineStatus);
						}
						
						//quantity
						if(!this.isNullObj(orderLine.OrderedQty)){							
							document.getElementById('Order_Item_Quantity_'+i).innerHTML = Utils.formatNumber(orderLine.OrderedQty,{
								minimumFractionDigits:0,
								maximumFractionDigits:0
							});
						}
						
						var currencyCode = 'USD';
						if(!this.isNullObj(jsonOrder.Root.Order.PriceInfo.Currency)){
							currencyCode = jsonOrder.Root.Order.PriceInfo.Currency;
						}
						
						var currencyDecimals = 2;
						if(!this.isNullObj(jsonOrder.Root.Order.PriceInfo.currencyDecimal)){
							currencyDecimals = jsonOrder.Root.Order.PriceInfo.currencyDecimal;
						}
						
						var currencySymbol = '$'
						if(!this.isNullObj(jsonOrder.Root.Order.PriceInfo.currencySymbol)){
							currencySymbol = jsonOrder.Root.Order.PriceInfo.currencySymbol;
						}
						
						//unit price	
						if(!this.isNullObj(orderLine.LinePriceInfo.UnitPrice)){
							document.getElementById('Order_Item_Unit_Price_'+i).innerHTML = this.formatCurrency(orderLine.LinePriceInfo.UnitPrice, currencyDecimals, currencySymbol, currencyCode, locale);
						}
								
						//total price
						var isFree = false;
						if(!this.isNullObj(orderLine.Awards)){
							if(!this.isNullObj(orderLine.Awards.Award)){
								if(!this.isNullObj(orderLine.Awards.Award.AwardType)){
									if(orderLine.Awards.Award.AwardType == 'FreeGift'){
										isFree = true;
									}
								}else if(!this.isNullObj(orderLine.Awards.Award[0])){
									for(var award in orderLine.Awards.Award){
										if(orderLine.Awards.Award[award].AwardType == 'FreeGift'){
											isFree = true;
											break;
										}
									}
								}
							}
						}
						if(isFree == true){
							document.getElementById('Order_Item_Total_Price_Free_'+i).style.display = 'inline';
							document.getElementById('Order_Item_Total_Price_'+i).style.display = 'none';
						}else{
							document.getElementById('Order_Item_Total_Price_Free_'+i).style.display = 'none';
							document.getElementById('Order_Item_Total_Price_'+i).style.display = 'inline';
							if(!this.isNullObj(orderLine.ComputedPrice.ExtendedPrice)){
								document.getElementById('Order_Item_Total_Price_'+i).innerHTML = this.formatCurrency(orderLine.ComputedPrice.ExtendedPrice, currencyDecimals, currencySymbol, currencyCode, locale);
							}
						}
						
						//promotion info
						if(!this.isNullObj(orderLine.CalculationCodes)){
							
							var counter = 0;
							for(var j in orderLine.CalculationCodes.CalculationCode){
								//if(calCode.displayLevel == 0){
									var calCode = orderLine.CalculationCodes.CalculationCode[j];
									var code = calCode.code;
									code = this.revertAllSpecialChars(code);
									var tr = document.createElement('tr');
														
									parentTable.insertBefore(tr, document.getElementById('Product_Line_'+(parseInt(i)+1)));
																				
									var th = document.createElement('th');
									th.setAttribute('colSpan', '4');
									//For firefox and other browsers
									th.setAttribute('class', 'th_align_left_dotted_top_solid_bottom');
									//For IE
									th.setAttribute('className', 'th_align_left_dotted_top_solid_bottom');
									var abbrText = document.getElementById('Product_Discount_Text').innerHTML;
									th.setAttribute('abbr', abbrText+catEntryName);
									th.setAttribute('id', 'SingleShipment_rowHeader_discount'+i+'_'+counter);
									tr.appendChild(th);
									
									var div = document.createElement('div');
									div.setAttribute('id', 'WC_OrderItemDetailsSummaryf_div_3_'+i+'_'+counter);
									div.setAttribute('class', 'itemspecs');
									div.setAttribute('className', 'itemspecs');
									th.appendChild(div);
									
									var a = document.createElement('a');
									a.setAttribute('class', 'discount hover_underline');
									a.setAttribute('className', 'discount hover_underline');
									a.setAttribute('id', 'WC_OrderItemDetails_Link_ItemDiscount_1_'+i+'_'+counter);
									
									var url_innerHTML = document.getElementById('Promotion_Url').innerHTML;
									if(!this.isNullObj(url_innerHTML)){
										url_innerHTML = url_innerHTML.replace(/&amp;/g, "&");
									}
									var promotionUrl = url_innerHTML + '&code='+ encodeURIComponent(code);
									a.setAttribute('href', promotionUrl);
									div.appendChild(a);
									
									var img = document.createElement('img');
									img.setAttribute('src', imgDir+'images/empty.gif');
									img.setAttribute('alt', abbrText+catEntryName);
									a.appendChild(img);
									if(!this.isNullObj(calCode.calculationCodeDescription)){
										var calCodeDesc = this.revertAllSpecialChars(calCode.calculationCodeDescription);
										a.appendChild(document.createTextNode(calCodeDesc));
									}
														
									var td = document.createElement('td');
									td.setAttribute('class', 'th_align_left_dotted_top_solid_bottom total');
									td.setAttribute('className', 'th_align_left_dotted_top_solid_bottom total');
									td.appendChild(document.createTextNode(' '))
									tr.appendChild(td);
									
									var td1 = document.createElement('td');
									td1.setAttribute('class', 'th_align_left_dotted_top_solid_bottom total');
									td1.setAttribute('className', 'th_align_left_dotted_top_solid_bottom total');
									td1.setAttribute('id', 'WC_OrderItemDetailsSummaryf_td_5_'+i+'_'+counter);
									td1.setAttribute('headers', 'SingleShipment_rowHeader_discount'+i+'_'+counter);
									td1.appendChild(document.createTextNode(this.formatCurrency(calCode.TotalAmount, currencyDecimals, currencySymbol, currencyCode, locale)));					
									tr.appendChild(td1);
									
									counter++;
								//}
							}
						}
						
					}
				},
				
				/**
				* populateOrderLineInfoForMultipleShipment This function populates the order line level information for the order 
				* retrieved from Sterling in history order details page with multiple shipment layout.
				*
				* @param {String} orderStr The json string for complete order information.
				* @param {Integer} beginIndex The begin index of the current order items page.
				* @param {Integer} pageSize The page size of the current order items page.
				*
				**/
				populateOrderLineInfoForMultipleShipment: function(orderStr, beginIndex, pageSize){
					//orderStr = escape(orderStr);
					var jsonOrder = eval("("+orderStr+")");
					var imgDir = document.getElementById('Image_Dir').innerHTML;
					var locale = document.getElementById('Locale_String_M').innerHTML;
					var endIndex = document.getElementById('endIndex').innerHTML;
					var orderLineNum = 1;
					if(!this.isNullObj(jsonOrder.Root.Order.countOfOrderLines)){
						orderLineNum = jsonOrder.Root.Order.countOfOrderLines;
					}
					
					if(document.getElementById('order_details').childNodes[0].tagName == 'TBODY'){
						var parentTable = document.getElementById('order_details').childNodes[0];
					}else if(document.getElementById('order_details').childNodes[1].tagName == 'TBODY'){
						var parentTable = document.getElementById('order_details').childNodes[1];
					}
					for(var i=beginIndex; i<endIndex; i++){
						var orderLine = null;
						if(orderLineNum == 1){
							if(!this.isNullObj(jsonOrder.Root.Order.OrderLines.OrderLine[0])){
							    orderLine = jsonOrder.Root.Order.OrderLines.OrderLine[0];
							} else {
							    orderLine = jsonOrder.Root.Order.OrderLines.OrderLine;
							}
						}else{
							orderLine = jsonOrder.Root.Order.OrderLines.OrderLine[i];
						}
						
						var nobottom = null;
						if(!this.isNullObj(orderLine.CalculationCodes)){
							if(!this.isNullObj(orderLine.CalculationCodes.CalculationCode)){
								nobottom = 'th_align_left_no_bottom';							
							}
						}
						if(!this.isNullObj(nobottom)){
							document.getElementById('MultipleShipping_rowHeader_product'+i).setAttribute('class', nobottom+document.getElementById('MultipleShipping_rowHeader_product'+i).getAttribute('class'));
							document.getElementById('MultipleShipping_rowHeader_product'+i).setAttribute('className', nobottom+document.getElementById('MultipleShipping_rowHeader_product'+i).getAttribute('className'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_1_'+i).setAttribute('class', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_1_'+i).getAttribute('class'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_1_'+i).setAttribute('className', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_1_'+i).getAttribute('className'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_2_'+i).setAttribute('class', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_2_'+i).getAttribute('class'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_2_'+i).setAttribute('className', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_2_'+i).getAttribute('className'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_3_'+i).setAttribute('class', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_3_'+i).getAttribute('class'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_3_'+i).setAttribute('className', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_3_'+i).getAttribute('className'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_4_'+i).setAttribute('class', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_4_'+i).getAttribute('class'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_4_'+i).setAttribute('className', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_4_'+i).getAttribute('className'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_5_'+i).setAttribute('class', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_5_'+i).getAttribute('class'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_5_'+i).setAttribute('className', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_5_'+i).getAttribute('className'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_6_'+i).setAttribute('class', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_6_'+i).getAttribute('class'));
							document.getElementById('WC_MSOrderItemDetailsSummaryf_td_6_'+i).setAttribute('className', nobottom+document.getElementById('WC_MSOrderItemDetailsSummaryf_td_6_'+i).getAttribute('className'));
						}
						//catalog entry info	
						var catEntryName = null;
						var thumbNail = null;
						var objectPath = null;
						var itemID = null;
						if(!this.isNullObj(orderLine.Item.CatalogEntry)){
							if(!this.isNullObj(orderLine.Item.CatalogEntry.objectPath)){
								objectPath = orderLine.Item.CatalogEntry.objectPath;
							}
							if(!this.isNullObj(orderLine.Item.CatalogEntry.CatalogEntryDescription)){
								if(!this.isNullObj(orderLine.Item.CatalogEntry.CatalogEntryDescription.catalogEntryName)){
									catEntryName = orderLine.Item.CatalogEntry.CatalogEntryDescription.catalogEntryName;
								}
								if(!this.isNullObj(orderLine.Item.CatalogEntry.CatalogEntryDescription.thumbNail)){
									thumbNail = orderLine.Item.CatalogEntry.CatalogEntryDescription.thumbNail;
								}
							}			
						}		
						if(!this.isNullObj(orderLine.Item.ItemID)){
							itemID = orderLine.Item.ItemID;
						}
						if(!this.isNullObj(thumbNail)){
							thumbNail = this.revertAllSpecialChars(thumbNail);
							if(!this.isNullObj(objectPath)){
								objectPath = this.revertAllSpecialChars(objectPath);
								document.getElementById('Product_Thumbnail_'+i).setAttribute('src', objectPath+thumbNail);			
							}else {
								document.getElementById('Product_Thumbnail_'+i).setAttribute('src', thumbNail);			
							}
							
						}else{
							document.getElementById('Product_Thumbnail_'+i).setAttribute('src', imgDir+'images/NoImageIcon_sm.jpg');
						}
						if(!this.isNullObj(catEntryName)){
							document.getElementById('MultipleShipping_rowHeader_product'+i).setAttribute('abbr', document.getElementById('MultipleShipping_rowHeader_product'+i).getAttribute('abbr')+catEntryName);
							document.getElementById('Product_Thumbnail_'+i).setAttribute('alt',	catEntryName);
							document.getElementById('Catalog_Entry_Name_'+i).innerHTML = catEntryName;
						}
						if(!this.isNullObj(itemID)){
							document.getElementById('Catalog_Entry_SKU_'+i).innerHTML = itemID;
						}	
						
						//Defining attributes				
						if(!this.isNullObj(orderLine.Item.CatalogEntry)){
							if(!this.isNullObj(orderLine.Item.CatalogEntry.catalogEntryAttributes)){
								document.getElementById('Catalog_Entry_Defining_Attributes_'+i).style.display = 'inline';
								for(var dAttr in orderLine.Item.CatalogEntry.catalogEntryAttributes.catalogEntryAttribute){
									document.getElementById('Catalog_Entry_Defining_Attributes_'+i).innerHTML = document.getElementById('Catalog_Entry_Defining_Attributes_'+i).innerHTML + orderLine.Item.CatalogEntry.catalogEntryAttributes.catalogEntryAttribute[dAttr].catalogEntryAttrName + ':'+ orderLine.Item.CatalogEntry.catalogEntryAttributes.catalogEntryAttribute[dAttr].catalogEntryAttrValue + '<br/>';
								}
							}
						}
						
						//Component names for DK
						if(!this.isNullObj(orderLine.componentNames)){
							var dkLabel = document.getElementById('Dynamic_Kit_Components_Label_'+i);
							if(!this.isNullObj(dkLabel)){
								document.getElementById('Dynamic_Kit_Components_Label_'+i).style.display = 'inline';
							}
							
							var ulForDK = document.getElementById('Dynamic_Kit_Components_'+i);
							if(!this.isNullObj(ulForDK)){
								var compNames = orderLine.componentNames.split(',');
								for(var j in compNames){
									var li = document.createElement('li');
									li.innerHTML = compNames[j];
									ulForDK.appendChild(li);
								}
							}
						} 
						
						//Shipping address		
						if(!this.isNullObj(orderLine.PersonInfoShipTo)){			
							this.populateAddress(orderLine.PersonInfoShipTo, 'WC_MSOrderItemDetailsSummaryf_div_3_'+i, locale);
						}else if(!this.isNullObj(jsonOrder.Root.Order.PersonInfoShipTo)){			
							this.populateAddress(jsonOrder.Root.Order.PersonInfoShipTo, 'WC_MSOrderItemDetailsSummaryf_div_3_'+i, locale);
						}
								
						//Shipping method
						var shippingMethod = null;		
						if(!this.isNullObj(orderLine.ShipmentLines.ShipmentLine)){
							var shipmentKey = null;
							if(!this.isNullObj(orderLine.ShipmentLines.ShipmentLine.ShipmentKey)){
								shipmentKey = orderLine.ShipmentLines.ShipmentLine.ShipmentKey;				
							}else if(!this.isNullObj(orderLine.ShipmentLines.ShipmentLine[0].ShipmentKey)){
								shipmentKey = orderLine.ShipmentLines.ShipmentLine[0].ShipmentKey;
							}
							if(!this.isNullObj(shipmentKey)){
							if(!this.isNullObj(jsonOrder.Root.Order.Shipments)){
								if(!this.isNullObj(jsonOrder.Root.Order.Shipments.Shipment)){
									if(!this.isNullObj(jsonOrder.Root.Order.Shipments.Shipment.ShipmentKey)){
										if(jsonOrder.Root.Order.Shipments.Shipment.ShipmentKey == shipmentKey){
											if(!this.isNullObj(jsonOrder.Root.Order.Shipments.Shipment.shipModeDescription)){
												shippingMethod = jsonOrder.Root.Order.Shipments.Shipment.shipModeDescription;
											}				
										}
									}else if(!this.isNullObj(jsonOrder.Root.Order.Shipments.Shipment[0])){
										for(var s in jsonOrder.Root.Order.Shipments.Shipment){
											if(jsonOrder.Root.Order.Shipments.Shipment[s].ShipmentKey == shipmentKey){
												if(!this.isNullObj(jsonOrder.Root.Order.Shipments.Shipment[s].shipModeDescription)){
													shippingMethod = jsonOrder.Root.Order.Shipments.Shipment[s].shipModeDescription;
												}
												break;
											}
										}
									}
								}
							  }
							}					
						}		
						if(this.isNullObj(shippingMethod)){
							if(!this.isNullObj(orderLine.shipModeDescription)){
								shippingMethod = orderLine.shipModeDescription;			
							}else if(!this.isNullObj(jsonOrder.Root.Order.shipModeDescription)){
								shippingMethod = jsonOrder.Root.Order.shipModeDescription;			
							}
						}
						if(!this.isNullObj(shippingMethod)){
							document.getElementById('Shipping_Mode_Description_'+i).innerHTML = shippingMethod;
						}
								
						var isFree = false;
						if(!this.isNullObj(orderLine.Awards)){
							if(!this.isNullObj(orderLine.Awards.Award)){
								if(!this.isNullObj(orderLine.Awards.Award.AwardType)){
									if(orderLine.Awards.Award.AwardType == 'FreeGift'){
										isFree = true;
									}
								}else if(!this.isNullObj(orderLine.Awards.Award[0])){
									for(var award in orderLine.Awards.Award){
										if(orderLine.Awards.Award[award].AwardType == 'FreeGift'){
											isFree = true;
											break;
										}
									}
								}
							}
						}
						
						if(isFree == false){
							if(!this.isNullObj(document.getElementById('Shipping_Instruction_'+i))){
								//shipping instruction
								if(!this.isNullObj(orderLine.Instructions)){
									var instructions = orderLine.Instructions;
									if(!this.isNullObj(instructions.Instruction)){					
										var instruction = instructions.Instruction;
										if(!this.isNullObj(instruction.InstructionType)){				
											if(instruction.InstructionType=='SHIP'){								
												if(!this.isNullObj(instruction.InstructionText)){
													document.getElementById('Shipping_Instruction_Label_'+i).style.display = 'inline';					
													document.getElementById('Shipping_Instruction_'+i).innerHTML = instruction.InstructionText;
												}
											}
										}else if(!this.isNullObj(instructions.Instruction[0])){
											//more than one instruction
											for(var k in instructions.Instruction){						
												if(!this.isNullObj(instructions.Instruction[k].InstructionType)){
													if(instructions.Instruction[k].InstructionType=='SHIP'){									
														if(!this.isNullObj(instructions.Instruction[k].InstructionText)){
															document.getElementById('Shipping_Instruction_Label_'+i).style.display = 'inline';
															document.getElementById('Shipping_Instruction_'+i).innerHTML = document.getElementById('Shipping_Instruction_'+i).innerHTML + instructions.Instruction[k].InstructionText+'<br/>';
														}
													}
												}
											}
										}				
									}else{
										//no instruction
									}
								}//no instructions
							}
							
							if(!this.isNullObj(document.getElementById('Order_Item_Requested_Ship_Date_'+i))){
								//request ship date
								if(!this.isNullObj(orderLine.ReqShipDate)){
									document.getElementById('Requested_Shipping_Date_Label_'+i).style.display = 'inline';
									var parsedReqShipDate = new Date(orderLine.ReqShipDate);
									document.getElementById('Order_Item_Requested_Ship_Date_'+i).innerHTML = Globalize.formatDate(parsedReqShipDate, {date: "long"});
								}
							}
						}
						
						//order line status
						if(!this.isNullObj(orderLine.MaxLineStatus)){			
							//document.getElementById('Order_Item_Status_'+i).innerHTML = orderLine.Status;							
							document.getElementById('Order_Item_Status_'+i).innerHTML = Utils.getLocalizationMessage('ORDER_LINE_STATUS_'+orderLine.MaxLineStatus);
						}
						
						//quantity
						if(!this.isNullObj(orderLine.OrderedQty)){
							document.getElementById('Order_Item_Quantity_'+i).innerHTML = Utils.formatNumber(orderLine.OrderedQty,{
								minimumFractionDigits:0,
								maximumFractionDigits:0
							});
						}
						
						var currencyCode = 'USD';
						if(!this.isNullObj(jsonOrder.Root.Order.PriceInfo.Currency)){
							currencyCode = jsonOrder.Root.Order.PriceInfo.Currency;
						}
						
						var currencyDecimals = 2;
						if(!this.isNullObj(jsonOrder.Root.Order.PriceInfo.currencyDecimal)){
							currencyDecimals = jsonOrder.Root.Order.PriceInfo.currencyDecimal;
						}
						
						var currencySymbol = '$'
						if(!this.isNullObj(jsonOrder.Root.Order.PriceInfo.currencySymbol)){
							currencySymbol = jsonOrder.Root.Order.PriceInfo.currencySymbol;
						}
						
						//unit price
						if(!this.isNullObj(orderLine.LinePriceInfo.UnitPrice)){
							document.getElementById('Order_Item_Unit_Price_'+i).innerHTML = this.formatCurrency(orderLine.LinePriceInfo.UnitPrice, currencyDecimals, currencySymbol, currencyCode, locale);
						}
								
						//total price		
						if(isFree == true){
							document.getElementById('Order_Item_Total_Price_Free_'+i).style.display = 'inline';
							document.getElementById('Order_Item_Total_Price_'+i).style.display = 'none';
						}else{			
							document.getElementById('Order_Item_Total_Price_Free_'+i).style.display = 'none';
							document.getElementById('Order_Item_Total_Price_'+i).style.display = 'inline';
							if(!this.isNullObj(orderLine.ComputedPrice.ExtendedPrice)){
								document.getElementById('Order_Item_Total_Price_'+i).innerHTML = this.formatCurrency(orderLine.ComputedPrice.ExtendedPrice, currencyDecimals, currencySymbol, currencyCode, locale);
							}
						}
						
						//promotion info
						if(!this.isNullObj(orderLine.CalculationCodes)){
							
							var counter = 0;
							for(var j in orderLine.CalculationCodes.CalculationCode){
									var calCode = orderLine.CalculationCodes.CalculationCode[j];			
									var code = calCode.code;
									code = this.revertAllSpecialChars(code);
									var tr = document.createElement('tr');												
									parentTable.insertBefore(tr, document.getElementById('Product_Line_'+(parseInt(i)+1)));
									
									var th = document.createElement('th');
									th.setAttribute('colSpan', '5');
									th.setAttribute('class', 'th_align_left_dotted_top_solid_bottom');
									th.setAttribute('className', 'th_align_left_dotted_top_solid_bottom');
									var abbrText = document.getElementById('Product_Discount_Text').innerHTML;
									th.setAttribute('abbr', abbrText+catEntryName);
									th.setAttribute('id', 'MultipleShipment_rowHeader_discount'+i+'_'+counter);
									tr.appendChild(th);
									
									var div = document.createElement('div');
									div.setAttribute('id', 'WC_MSOrderItemDetailsSummaryf_div_5_'+i+'_'+counter);
									div.setAttribute('class', 'itemspecs');
									div.setAttribute('className', 'itemspecs');
									th.appendChild(div);
									
									var a = document.createElement('a');
									a.setAttribute('class', 'discount');
									a.setAttribute('className', 'discount');
									a.setAttribute('id', 'WC_OrderItemDetails_Link_ItemDiscount_1_'+i+'_'+counter);
									
									var url_innerHTML = document.getElementById('Promotion_Url').innerHTML;
									if(!this.isNullObj(url_innerHTML)){
										url_innerHTML = url_innerHTML.replace(/&amp;/g, "&");
									}
									var promotionUrl =  url_innerHTML + '&code='+ encodeURIComponent(code);
									
									a.setAttribute('href', promotionUrl);
									div.appendChild(a);
									
									var img = document.createElement('img');
									img.setAttribute('src', imgDir+'images/empty.gif');
									img.setAttribute('alt', abbrText+catEntryName);
									a.appendChild(img);
									if(!this.isNullObj(calCode.calculationCodeDescription)){
										var calCodeDesc = this.revertAllSpecialChars(calCode.calculationCodeDescription);
										a.appendChild(document.createTextNode(calCodeDesc));	
									}
									
									var td = document.createElement('td');
									td.setAttribute('class', 'th_align_left_dotted_top_solid_bottom total');
									td.setAttribute('className', 'th_align_left_dotted_top_solid_bottom total');
									td.appendChild(document.createTextNode(' '))
									tr.appendChild(td);
																																
									var td1 = document.createElement('td');
									td1.setAttribute('class', 'th_align_left_dotted_top_solid_bottom total');
									td1.setAttribute('className', 'th_align_left_dotted_top_solid_bottom total');
									td1.setAttribute('id', 'WC_MSOrderItemDetailsSummaryf_td_7_'+i+'_'+counter);
									td1.setAttribute('headers', 'MultipleShipment_rowHeader_discount'+i+'_'+counter);
									td1.appendChild(document.createTextNode(this.formatCurrency(calCode.TotalAmount, currencyDecimals, currencySymbol, currencyCode, locale)));					
									tr.appendChild(td1);
									
									counter++;				
							}
						}
						
					}
				},
				
				/**
				 * This function sets the url for ssfs order copy service and then it invokes the service to copy the old order.
				 * @param {string} OrderCancelURL The url for the ssfs order copy service.
				 * @param {string} orderHeaderKeyBeingCanceled The order header key of the order being canceled.
				 */
				cancelOrder:function(OrderCancelURL, orderHeaderKeyBeingCanceled){

					/*For Handling multiple clicks. */
					if(!submitRequest()){
						return;
					}
					cursor_wait();
					this.orderBeingCanceled = orderHeaderKeyBeingCanceled;
					wcService.getServiceById("CancelExternalOrder").setUrl(OrderCancelURL);
					wcService.invoke("CancelExternalOrder");
				}
				
}

/**
 *  This service enables customer to Cancel an existing order on the external system.
 *  @constructor
 */
wcService.declare({
	id: "CancelExternalOrder",
	actionId: "CancelExternalOrder",
	url: "AJAXProcessExternalOrder",
	formId: ""

	 /**
	  *  This method updates the order table with the 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		for (var prop in serviceResponse) {
			console.debug(prop + "=" + serviceResponse[prop]);			
		}
		//change the status to canceled.
		var idToLookFor = "OrderDetails_status_span_" + sterlingIntegrationJS.orderBeingCanceled;
		var $element = $("#" + idToLookFor);
		if($element.length){
			$element.html(MessageHelper.messages["MO_OrderStatus_X"]);
		}
		
		//Hide the cancel button
		idToLookFor = "OrderDetails_cancelButton_" + sterlingIntegrationJS.orderBeingCanceled;
		var $element = $("#" + idToLookFor);
		if($element.length){
			$element.css('display', 'none');
			$element.css('visibility', 'hidden');
		}
				
		//Show canceled message.
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MO_ORDER_CANCELED_MSG"]);
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		for (var prop in serviceResponse) {
			console.debug(prop + "=" + serviceResponse[prop]);			
		}
	
		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}

})
