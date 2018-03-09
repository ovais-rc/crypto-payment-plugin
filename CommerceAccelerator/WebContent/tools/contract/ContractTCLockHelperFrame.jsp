<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
--%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>

<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@ page import="com.ibm.commerce.contract.util.ContractTCLockHelper" %>

<%@page import="com.ibm.commerce.contract.helper.ECContractConstants,
   com.ibm.commerce.contract.content.resources.ContractContainer,
   com.ibm.commerce.context.content.resources.ManagedResourceKey,
   com.ibm.commerce.context.content.resources.ResourceManager,
   com.ibm.commerce.context.content.locking.LockData" %>


<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>


<%--
//---------------------------------------------------------------------------
//
// Name       : ContractTCLockHelperFrame.jsp
//
// Description: This is a helper dataframe for performing some contract
//              terms and conditions locking management operations.
//
// Parameters : The parameters for using this JSP are described below:
//
//              contractid - specify the contract ID
//
//              tctype - specify the terms and condition type, valid
//                       options are listed below:
//                             0 - TC type will be specified in separate
//                                 parameters as: pricingtc, shippingtc,
//                                 paymenttc, returnstc, orderapprovaltc,
//                                 otherpages, along with the service is
//                                 set to '2'. For service is set to '4',
//                                 this tctype should be also set to '0'.
//                             1 - Pricing TC
//                             2 - Shipping TC
//                             3 - Payment TC
//                             4 - Returns TC
//                             5 - Order Approval TC
//                             6 - General, Participants, Attachment,
//                                 and Remarks Pages
//
//                             *DEVELOPER'S NOTE* To support a new terms &
//                              conditions type, add a new integer number here.
//
//
//              service - specify the action for this helper to
//                        perform, valid options are listed below:
//                             1 - unlock and lock the resource
//                             2 - unlock the resource if the lock is
//                                 still existed and the logon user is
//                                 the lock's owner
//                             3 - unlock the resource regardless who's
//                                 the lock's owner
//                             4 - check the specified contract is currently
//                                 locked
//
//              callbackid - optional, specify the ID for callback invoker
//
//              pricingtc - optional, specify the service apply on the pricing
//                          terms and condition type if the value is '1'
//                          and tctype parameter is set to '0'
//
//              shippingtc - optional, specify the service apply on the shipping
//                           terms and condition type if the value is '1'
//                           and tctype parameter is set to '0'
//
//              paymenttc - optional, specify the service apply on the payment
//                          terms and condition type if the value is '1'
//                          and tctype parameter is set to '0'
//
//              returnstc - optional, specify the service apply on the returns
//                          terms and condition type if the value is '1'
//                          and tctype parameter is set to '0'
//
//              orderapprovaltc - optional, specify the service apply on the order
//                                approval terms and condition type if the value
//                                is '1' and tctype parameter is set to '0'
//
//              otherpages - optional, specify the service apply on the general,
//                           attachment, remarks, and participants pages if the
//                           value is '1' and tctype parameter is set to '0'
//
//              *DEVELOPER'S NOTE* To support a new terms & conditions type,
//               please add a new parameter here, such as 'mynewtc'.
//
//
//
// Output     : A javascript function "getResultCode()" will be generated
//              after this JSP being executed. The caller programs can
//              invoke this javascript function to access the result code.
//              The possible valid result codes are listed below:
//                   1 : RC_SERVICE_SUCCESSFUL           - service performs successful
//                  -1 : RC_INVALID_GIVEN_PARMS          - invalid given parameters
//                  -2 : RC_INVALID_CONTRACT_ID          - invalid contract Id
//                  -3 : RC_INVALID_TC_TYPE              - invalid terms and conditions type
//                  -7 : RC_INVALID_SERVICE_PARM         - invalid service parameter
//                 -17 : RC_INVALID_TC_PARMS             - tctype is 0, but could not find the valid tc paramaters
//                 -11 : RC_ONE_OR_MORE_EXECUTION_FAILED - tctype is 0, but 1 or more executions failed
//                 -12 : RC_UNLOCK_EXECUTION_FAILED      - unlock executions failed
//
//---------------------------------------------------------------------------
--%>



<%--
   Define Return Code Constants to ease readability
--%>
<%! final int RC_SERVICE_SUCCESSFUL           =  1;  %>
<%! final int RC_INVALID_GIVEN_PARMS          = -1;  %>
<%! final int RC_INVALID_CONTRACT_ID          = -2;  %>
<%! final int RC_INVALID_TC_TYPE              = -3;  %>
<%! final int RC_INVALID_SERVICE_PARM         = -7;  %>
<%! final int RC_INVALID_TC_PARMS             = -17; %>
<%! final int RC_ONE_OR_MORE_EXECUTION_FAILED = -11; %>
<%! final int RC_UNLOCK_EXECUTION_FAILED      = -12; %>


<%
try
{

   ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                    "tools/contract/ContractTCLockHelperFrame.jsp",
                    "service",
                    "ContractTCLockHelperFrame.jsp entry");

   // Parameters may be encrypted. Use JSPHelper to get URL parameter
   // instead of request.getParameter().
   JSPHelper jhelper = new JSPHelper(request);

   // Declare all wiring variables
   int serviceType = 0;
   int tcType      = 0;
   int overallResultCode = RC_SERVICE_SUCCESSFUL;

   //=========================================================
   // *DEVELOPER'S NOTE*
   // If you add a new TC, please increment the numeric value
   // of NUMOF_TC_SUPPORTED by 1.
   //
   // For example,
   //
   //    int NUMOF_TC_SUPPORTED = 7;
   //
   //=========================================================
   int NUMOF_TC_SUPPORTED = 6; // currently support 6 TC types


   NUMOF_TC_SUPPORTED++; // add 1 due to unused index '0'
   int resultCodes[] = new int[NUMOF_TC_SUPPORTED];

   String contractIdStr = jhelper.getParameter("contractid");
   String callBackID = jhelper.getParameter("callbackid");

   StringBuffer traceMsg = new StringBuffer("Given parameters: ");
   traceMsg.append("contractid=").append(contractIdStr).append(",");
   traceMsg.append("tctype=").append(jhelper.getParameter("tctype")).append(",");
   traceMsg.append("service=").append(jhelper.getParameter("service")).append(",");
   traceMsg.append("callbackid=").append(jhelper.getParameter("callbackid")).append(",");

   traceMsg.append( (jhelper.getParameter("pricingtc")==null ? "" : "pricingtc=" + jhelper.getParameter("pricingtc") + ",") );
   traceMsg.append( (jhelper.getParameter("shippingtc")==null ? "" : "shippingtc=" + jhelper.getParameter("shippingtc") + ",") );
   traceMsg.append( (jhelper.getParameter("paymenttc")==null ? "" : "paymenttc=" + jhelper.getParameter("paymenttc") + ",") );
   traceMsg.append( (jhelper.getParameter("returnstc")==null ? "" : "returnstc=" + jhelper.getParameter("returnstc") + ",") );
   traceMsg.append( (jhelper.getParameter("orderapprovaltc")==null ? "" : "orderapprovaltc=" + jhelper.getParameter("orderapprovaltc") + ",") );
   traceMsg.append( (jhelper.getParameter("otherpages")==null ? "" : "otherpages=" + jhelper.getParameter("otherpages") + ",") );

   //=====================================================================
   // *DEVELOPER'S NOTE*
   // If you add a new TC, please add a similar statement here.
   //
   // For example,
   //
   //    traceMsg.append( (jhelper.getParameter("mynewtc")==null
   //       ? "" : "mynewtc=" + jhelper.getParameter("mynewtc") + ",") );
   //
   //=====================================================================



   ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                 "tools/contract/ContractTCLockHelperFrame.jsp",
                 "service", traceMsg.toString());


   // Prepare the wiring variables
   try
   {
      serviceType = Integer.parseInt(jhelper.getParameter("service"));
      tcType      = Integer.parseInt(jhelper.getParameter("tctype"));

      if (contractIdStr==null)
      {
         overallResultCode = RC_INVALID_CONTRACT_ID;
      }
      else
      {
         int termCondType = 0;
         int validGivenTcType = 1;

         switch (tcType)
         {
            case 0: validGivenTcType = 2; break;
            case 1: termCondType = ContractTCLockHelper.TCTYPE_PRICING; break;
            case 2: termCondType = ContractTCLockHelper.TCTYPE_SHIPPING; break;
            case 3: termCondType = ContractTCLockHelper.TCTYPE_PAYMENT; break;
            case 4: termCondType = ContractTCLockHelper.TCTYPE_RETURNS; break;
            case 5: termCondType = ContractTCLockHelper.TCTYPE_ORDER_APPROVAL; break;
            case 6: termCondType = ContractTCLockHelper.TCTYPE_GENERAL_OTHERS_PAGES; break;

            //===============================================================
            // *DEVELOPER'S NOTE*
            // To support a new TC type, please add a similar case statement
            // here. The termCondType variable should assign the new terms
            // and conditions type unique identifier in integer value.
            //
            // For example,
            //
            //    case 7: termCondType = "MyNewTC".hashCode(); break;
            //
            //===============================================================


            default: // Invalid terms and conditions type
                     overallResultCode = RC_INVALID_TC_TYPE;
                     validGivenTcType  = 0;
                     ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                       "tools/contract/ContractTCLockHelperFrame.jsp",
                       "service",
                       "Invalid tctype=" + jhelper.getParameter("tctype"));
                     break;

         }//end-switch(tcType)


         if (tcType==0 && serviceType==4)
         {
            // I just want to check the contract is currently locked or not

            int lockHelperRC = 0;
            overallResultCode = RC_SERVICE_SUCCESSFUL;

               //-------------------------------------------------------------
               // The following code segment performs the job of checking
               // all terms and conditions locks for a given contract ID.
               //-------------------------------------------------------------

               Long lockKeyForPriceTC[]
                  = { new Long(contractIdStr),
                      new Long(ECContractConstants.EC_ELE_PRICE_TC.hashCode()) };
               Long lockKeyForShippingTC[]
                  = { new Long(contractIdStr),
                      new Long(ECContractConstants.EC_ELE_SHIPPING_TC.hashCode()) };
               Long lockKeyForPaymentTC[]
                  = { new Long(contractIdStr),
                      new Long(ECContractConstants.EC_ELE_PAYMENT_TC.hashCode()) };
               Long lockKeyForReturnTC[]
                  = { new Long(contractIdStr),
                      new Long(ECContractConstants.EC_ELE_RETURN_TC.hashCode()) };
               Long lockKeyForOrderApprovalTC[]
                  = { new Long(contractIdStr),
                      new Long(ECContractConstants.EC_ELE_ORDERAPPROVAL_TC.hashCode()) };
               Long lockKeyForGeneralPages[]
                  = { new Long(contractIdStr),
                      new Long(ECContractConstants.EC_ELE_CONTRACT.hashCode()) };

               //===============================================================
               // *DEVELOPER'S NOTE*
               // To support a new TC type, please add a similar declaration
               // statement here to define a lock key pair for the new TC.
               //
               // For example,
               //
               //    Long lockKeyForMyNewTC[]
               //       = { new Long(contractIdStr),
               //           new Long("MyNewTC".hashCode()) };
               //
               //===============================================================



               //=========================================================
               // *DEVELOPER'S NOTE*
               // If you add a new TC, please increment the numeric value
               // of the variable numOfKeys by 1.
               //
               // For example,
               //   int numOfKeys = 7;
               //
               //=========================================================
               int numOfKeys = 6; // currently support 6 TCs


               // Create the managed resource key to identify the managed resource
               ManagedResourceKey[] myManagedRescKeys = new ManagedResourceKey[numOfKeys];
               for (int k1=0; k1<numOfKeys; k1++)
               {
                  myManagedRescKeys[k1] = new ManagedResourceKey();
               }
               myManagedRescKeys[0].setInternalKeys(lockKeyForPriceTC);
               myManagedRescKeys[1].setInternalKeys(lockKeyForShippingTC);
               myManagedRescKeys[2].setInternalKeys(lockKeyForPaymentTC);
               myManagedRescKeys[3].setInternalKeys(lockKeyForReturnTC);
               myManagedRescKeys[4].setInternalKeys(lockKeyForOrderApprovalTC);
               myManagedRescKeys[5].setInternalKeys(lockKeyForGeneralPages);

               //===============================================================
               // *DEVELOPER'S NOTE*
               // To support a new TC type, please add a similar assignment
               // statement here to set the new lock key for the new TC.
               //
               // For example,
               //
               //   myManagedRescKeys[6].setInternalKeys(lockKeyForMyNewTC);
               //
               //===============================================================



               // Obtain the resource manager that will manage the resource TERMCOND
               ResourceManager myRescManager
                  = ContractContainer.singleton().getResourceManager(ContractContainer.RESOURCE_TERMCOND);

               // Check any lock exists for the contract
               boolean contractHasLocks = false;
               LockData[] lockInfo = myRescManager.getLockData(myManagedRescKeys);
               for (int k3=0; k3<lockInfo.length; k3++)
               {
                  if (lockInfo[k3]!=null)
                  {
                     contractHasLocks = true;
                     break;
                  }

               }//end-for-k3

               if (contractHasLocks)
               {
                  lockHelperRC = 1; // the contract is currently locked
               }
               else
               {
                  lockHelperRC = 0; // the contract is not currently locked
               }

               // Result will be stored at the resultCodes[1]
               resultCodes[1] = lockHelperRC;

         }//end-if (tcType==0 && serviceType==4)

         else if (validGivenTcType==1)
         {
            int lockHelperRC = 0;
            ContractTCLockHelper myLockHelper = null;
            overallResultCode = RC_SERVICE_SUCCESSFUL;

            switch (serviceType)
            {
               case 1: myLockHelper = new ContractTCLockHelper(contractCommandContext,
                                                               new Long(contractIdStr),
                                                               termCondType);
                       lockHelperRC = myLockHelper.forceUnlockTCAndAcquireNewLock();
                       //resultCodes.addElement(new Integer(lockHelperRC));
                       resultCodes[tcType] = lockHelperRC;

                       if (   (lockHelperRC==ContractTCLockHelper.RC_FAIL_TO_LOCK)
                           || (lockHelperRC==ContractTCLockHelper.RC_EXECUTION_EXCEPTION) )
                           { overallResultCode = RC_UNLOCK_EXECUTION_FAILED; }

                       ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                          "tools/contract/ContractTCLockHelperFrame.jsp",
                          "service",
                          "forceUnlockTCAndAcquireNewLock() returns " + lockHelperRC);
                       break;

               case 2: myLockHelper = new ContractTCLockHelper(contractCommandContext,
                                                               new Long(contractIdStr),
                                                               termCondType);
                       lockHelperRC = myLockHelper.verifyAndUnlockTC();
                       //resultCodes.addElement(new Integer(lockHelperRC));
                       resultCodes[tcType] = lockHelperRC;

                       if (   (lockHelperRC==ContractTCLockHelper.RC_INVALID_LOCK)
                           || (lockHelperRC==ContractTCLockHelper.RC_EXECUTION_EXCEPTION) )
                           { overallResultCode = RC_UNLOCK_EXECUTION_FAILED; }

                       ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                          "tools/contract/ContractTCLockHelperFrame.jsp",
                          "service",
                          "verifyAndUnlockTC() returns " + lockHelperRC);
                       break;

               case 3: myLockHelper = new ContractTCLockHelper(contractCommandContext,
                                                               new Long(contractIdStr),
                                                               termCondType);
                       lockHelperRC = myLockHelper.forceUnlockTC();
                       //resultCodes.addElement(new Integer(lockHelperRC));
                       resultCodes[tcType] = lockHelperRC;

                       if (   (lockHelperRC==ContractTCLockHelper.RC_FAIL_TO_UNLOCK)
                           || (lockHelperRC==ContractTCLockHelper.RC_EXECUTION_EXCEPTION) )
                           { overallResultCode = RC_UNLOCK_EXECUTION_FAILED; }

                       ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                          "tools/contract/ContractTCLockHelperFrame.jsp",
                          "service",
                          "forceUnlockTC() returns " + lockHelperRC);
                       break;

               default: // Invalid service type
                        overallResultCode = RC_INVALID_SERVICE_PARM;
                        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                           "tools/contract/ContractTCLockHelperFrame.jsp",
                           "service",
                           "Invalid service=" + jhelper.getParameter("service"));
                        break;

            }//end-switch(serviceType)

         }//end-if (validGivenTcType==1)

         else if (validGivenTcType==2)
         {
            int lockHelperRC = 0;
            ContractTCLockHelper myLockHelper = null;
            overallResultCode = RC_SERVICE_SUCCESSFUL;
            boolean hasTriedToUnlock = false;

            if ("1".equalsIgnoreCase(jhelper.getParameter("pricingtc")))
            {
               //----------------------------
               // Verify & unlock Pricing TC
               //----------------------------
               myLockHelper = new ContractTCLockHelper(contractCommandContext,
                                                       new Long(contractIdStr),
                                                       ContractTCLockHelper.TCTYPE_PRICING);
               lockHelperRC = myLockHelper.verifyAndUnlockTC();
               //resultCodes.addElement(new Integer(lockHelperRC));
               resultCodes[1] = lockHelperRC;
               hasTriedToUnlock = true;

               if (  (lockHelperRC==ContractTCLockHelper.RC_INVALID_LOCK)
                  || (lockHelperRC==ContractTCLockHelper.RC_EXECUTION_EXCEPTION) )
                  { overallResultCode = RC_INVALID_GIVEN_PARMS; }
               ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, "tools/contract/ContractTCLockHelperFrame.jsp",
                             "service", "verifyAndUnlockTC() pricingtc returns " + lockHelperRC);
            }

            if ("1".equalsIgnoreCase(jhelper.getParameter("shippingtc")))
            {
               //----------------------------
               // Verify & unlock Shipping TC
               //----------------------------
               myLockHelper = new ContractTCLockHelper(contractCommandContext,
                                                       new Long(contractIdStr),
                                                       ContractTCLockHelper.TCTYPE_SHIPPING);
               lockHelperRC = myLockHelper.verifyAndUnlockTC();
               //resultCodes.addElement(new Integer(lockHelperRC));
               resultCodes[2] = lockHelperRC;
               hasTriedToUnlock = true;

               if (  (lockHelperRC==ContractTCLockHelper.RC_INVALID_LOCK)
                  || (lockHelperRC==ContractTCLockHelper.RC_EXECUTION_EXCEPTION) )
                  { overallResultCode = RC_ONE_OR_MORE_EXECUTION_FAILED; }
               ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, "tools/contract/ContractTCLockHelperFrame.jsp",
                             "service", "verifyAndUnlockTC() shippingtc returns " + lockHelperRC);
            }

            if ("1".equalsIgnoreCase(jhelper.getParameter("paymenttc")))
            {
               //----------------------------
               // Verify & unlock Payment TC
               //----------------------------
               myLockHelper = new ContractTCLockHelper(contractCommandContext,
                                                       new Long(contractIdStr),
                                                       ContractTCLockHelper.TCTYPE_PAYMENT);
               lockHelperRC = myLockHelper.verifyAndUnlockTC();
               //resultCodes.addElement(new Integer(lockHelperRC));
               resultCodes[3] = lockHelperRC;
               hasTriedToUnlock = true;

               if (  (lockHelperRC==ContractTCLockHelper.RC_INVALID_LOCK)
                  || (lockHelperRC==ContractTCLockHelper.RC_EXECUTION_EXCEPTION) )
                  { overallResultCode = RC_ONE_OR_MORE_EXECUTION_FAILED; }
               ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, "tools/contract/ContractTCLockHelperFrame.jsp",
                             "service", "verifyAndUnlockTC() paymenttc returns " + lockHelperRC);
            }

            if ("1".equalsIgnoreCase(jhelper.getParameter("returnstc")))
            {
               //----------------------------
               // Verify & unlock Returns TC
               //----------------------------
               myLockHelper = new ContractTCLockHelper(contractCommandContext,
                                                       new Long(contractIdStr),
                                                       ContractTCLockHelper.TCTYPE_RETURNS);
               lockHelperRC = myLockHelper.verifyAndUnlockTC();
               //resultCodes.addElement(new Integer(lockHelperRC));
               resultCodes[4] = lockHelperRC;
               hasTriedToUnlock = true;

               if (  (lockHelperRC==ContractTCLockHelper.RC_INVALID_LOCK)
                  || (lockHelperRC==ContractTCLockHelper.RC_EXECUTION_EXCEPTION) )
                  { overallResultCode = RC_ONE_OR_MORE_EXECUTION_FAILED; }
               ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, "tools/contract/ContractTCLockHelperFrame.jsp",
                             "service", "verifyAndUnlockTC() returnstc returns " + lockHelperRC);
            }

            if ("1".equalsIgnoreCase(jhelper.getParameter("orderapprovaltc")))
            {
               //----------------------------------
               // Verify & unlock Order Approval TC
               //----------------------------------
               myLockHelper = new ContractTCLockHelper(contractCommandContext,
                                                       new Long(contractIdStr),
                                                       ContractTCLockHelper.TCTYPE_ORDER_APPROVAL);
               lockHelperRC = myLockHelper.verifyAndUnlockTC();
               //resultCodes.addElement(new Integer(lockHelperRC));
               resultCodes[5] = lockHelperRC;
               hasTriedToUnlock = true;

               if (  (lockHelperRC==ContractTCLockHelper.RC_INVALID_LOCK)
                  || (lockHelperRC==ContractTCLockHelper.RC_EXECUTION_EXCEPTION) )
                  { overallResultCode = RC_ONE_OR_MORE_EXECUTION_FAILED; }
               ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, "tools/contract/ContractTCLockHelperFrame.jsp",
                             "service", "verifyAndUnlockTC() orderapprovaltc returns " + lockHelperRC);
            }

            if ("1".equalsIgnoreCase(jhelper.getParameter("otherpages")))
            {
               //--------------------------------------
               // Verify & unlock General & Other Pages
               //--------------------------------------
               myLockHelper = new ContractTCLockHelper(contractCommandContext,
                                                       new Long(contractIdStr),
                                                       ContractTCLockHelper.TCTYPE_GENERAL_OTHERS_PAGES);
               lockHelperRC = myLockHelper.verifyAndUnlockTC();
               //resultCodes.addElement(new Integer(lockHelperRC));
               resultCodes[6] = lockHelperRC;
               hasTriedToUnlock = true;

               if (  (lockHelperRC==ContractTCLockHelper.RC_INVALID_LOCK)
                  || (lockHelperRC==ContractTCLockHelper.RC_EXECUTION_EXCEPTION) )
                  { overallResultCode = RC_ONE_OR_MORE_EXECUTION_FAILED; }
               ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT, "tools/contract/ContractTCLockHelperFrame.jsp",
                             "service", "verifyAndUnlockTC() otherpages returns " + lockHelperRC);
            }

            //===========================================================================
            // *DEVELOPER'S NOTE*
            // To support a new TC type, please add a similar block of code as
            // above, and change the parameter name, the TC type unique
            // identifier, the resultCodes index, and the trace message accordingly.
            //
            // For example,
            //
            //   if ("1".equalsIgnoreCase(jhelper.getParameter("mynewtc")))
            //   {
            //      //--------------------------------------
            //      // Verify & unlock My New TC
            //      //--------------------------------------
            //      myLockHelper = new ContractTCLockHelper(contractCommandContext,
            //                                              new Long(contractIdStr),
            //                                              "MyNewTC".hashCode());
            //      lockHelperRC = myLockHelper.verifyAndUnlockTC();
            //      resultCodes[7] = lockHelperRC;
            //      hasTriedToUnlock = true;
            //
            //      if (  (lockHelperRC==ContractTCLockHelper.RC_INVALID_LOCK)
            //         || (lockHelperRC==ContractTCLockHelper.RC_EXECUTION_EXCEPTION) )
            //      {
            //         overallResultCode = RC_ONE_OR_MORE_EXECUTION_FAILED;
            //      }
            //
            //      ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
            //                    "tools/contract/ContractTCLockHelperFrame.jsp",
            //                    "service", "verifyAndUnlockTC() mynewtc returns "
            //                    + lockHelperRC);
            //   }
            //
            //===========================================================================



            // Check any TC unlock have been executed, if not, then something wrong
            if (!hasTriedToUnlock)
            {
               // Invalid service type
               overallResultCode = RC_INVALID_TC_PARMS;
               ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                             "tools/contract/ContractTCLockHelperFrame.jsp",
                             "service",
                             "tctype is 0, but could not find the valid tc paramater(s).");
            }


         }//end-else-if (termCondType==2)

      }//end-if

   }
   catch (NumberFormatException ne)
   {
      overallResultCode = RC_INVALID_GIVEN_PARMS;
      ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                    "tools/contract/ContractTCLockHelperFrame.jsp",
                    "service",
                    "Invalid parameter: tctype=" + jhelper.getParameter("tctype") + ", service=" + jhelper.getParameter("service"));
   }


   ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                 "tools/contract/ContractTCLockHelperFrame.jsp",
                 "service",
                 "overallResultCode = " + overallResultCode);
%>



<html>
<head>

<script>

/////////////////////////////////////////////////////////////////////////////
// Function: getOverallResultCode
// Desc.   : Return the overall result code after the execution
// Input   : void
// Output  : Possible returning values are listed below:
//                   1 - service performs successful
//                  -1 - invalid given parameters
//                  -2 - invalid contract Id
//                  -3 - invalid terms and conditions type
//                  -7 - invalid service parameter
//                 -17 - tctype is 0, but could not find the valid tc paramaters
//                 -11 - tctype is 0, but 1 or more executions failed
//                 -12 - unlock executions failed
//
/////////////////////////////////////////////////////////////////////////////
function getOverallResultCode()
{
   return <%= overallResultCode %>;
}



// Call back to invoker when it's done
if (parent.contractTCLockHelperFrameDone)
{
   var results = new Array();
<%
   for (int i=1; i<NUMOF_TC_SUPPORTED; i++)
   {
      %>
      results[<%=i%>] = "<%= resultCodes[i] %>";
      <%
   }//end-for
%>

   parent.contractTCLockHelperFrameDone("<%= UIUtil.toJavaScript(callBackID) %>",
                                        "<%= overallResultCode %>",
                                        results);

}

</script>


</head>
<body>
</body>
</html>


<%

   ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                    "tools/contract/ContractTCLockHelperFrame.jsp",
                    "service",
                    "ContractTCLockHelperFrame.jsp exit");

}
catch (Exception e)
{
   e.printStackTrace();
   ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                 "tools/contract/ContractTCLockHelperFrame.jsp",
                 "service",
                 "Exception: " + e.toString());
}
%>

