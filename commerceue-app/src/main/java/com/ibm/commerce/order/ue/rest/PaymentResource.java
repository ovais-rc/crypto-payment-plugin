package com.ibm.commerce.order.ue.rest;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2015, 2016
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.Extension;
import io.swagger.annotations.ExtensionProperty;
import io.swagger.annotations.SwaggerDefinition;
import io.swagger.annotations.Tag;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.ibm.commerce.foundation.entities.ErrorUEResponse;
import com.ibm.commerce.foundation.entities.ExceptionData;

import com.ibm.commerce.payment.applepay.objects.PKPaymentToken;
import com.ibm.commerce.payment.applepay.util.ApplePayUtils;
import com.ibm.commerce.payment.entities.FinancialTransaction;
import com.ibm.commerce.payment.entities.PaymentInstruction;
import com.ibm.commerce.payment.ue.entities.CreatePaymentTokenCmdUEInput;
import com.ibm.commerce.payment.ue.entities.CreatePaymentTokenCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.FetchPaymentTokenCmdUEInput;
import com.ibm.commerce.payment.ue.entities.FetchPaymentTokenCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.GetPunchoutURLCmdUEInput;
import com.ibm.commerce.payment.ue.entities.GetPunchoutURLCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.PaymentApproveAndDepositCmdUEInput;
import com.ibm.commerce.payment.ue.entities.PaymentApproveAndDepositCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.PaymentApproveCmdUEInput;
import com.ibm.commerce.payment.ue.entities.PaymentApproveCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.PaymentCreditCmdUEInput;
import com.ibm.commerce.payment.ue.entities.PaymentCreditCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.PaymentDepositCmdUEInput;
import com.ibm.commerce.payment.ue.entities.PaymentDepositCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.PaymentReverseApprovalCmdUEInput;
import com.ibm.commerce.payment.ue.entities.PaymentReverseApprovalCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.PaymentReverseDepositCmdUEInput;
import com.ibm.commerce.payment.ue.entities.PaymentReverseDepositCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.ProcessPunchoutResponseCmdUEInput;
import com.ibm.commerce.payment.ue.entities.ProcessPunchoutResponseCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.RemovePaymentTokenCmdUEInput;
import com.ibm.commerce.payment.ue.entities.RemovePaymentTokenCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.SessionCleanCmdUEInput;
import com.ibm.commerce.payment.ue.entities.SessionCleanCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.UpdatePaymentTokenCmdUEInput;
import com.ibm.commerce.payment.ue.entities.UpdatePaymentTokenCmdUEOutput;
import com.ibm.commerce.payment.ue.entities.VerifyPaymentAccountCmdUEInput;
import com.ibm.commerce.payment.ue.entities.VerifyPaymentAccountCmdUEOutput;
import com.ibm.commerce.ue.rest.BaseResource;
import com.ibm.commerce.ue.rest.MessageKey;

@Path("/payment")
@SwaggerDefinition(
        tags = {
                @Tag(name = "payment", description = "API Extensions for payment customization.")
        }
)
@Api(value = "/payment", tags = "payment")
public class PaymentResource extends BaseResource {
	
	private static final Logger LOGGER = Logger.getLogger(PaymentResource.class.getName());
	private static final String CLASS_NAME = PaymentResource.class.getName();
	
	private static Locale locale = new Locale(
			MessageKey.getConfig("_CONFIG_LANGUAGE"),
			MessageKey.getConfig("_CONFIG_LOCALE"));
	
	private static final String RESULT_DONE = MessageKey.getConfig("_PSP_STRING_DONE");
	private static final String CONFIRMATION_SUCCESS = MessageKey.getConfig("_PSP_STRING_YES");
	private static final String CONFIRMATION_FAIL = MessageKey.getConfig("_PSP_STRING_NO");
	
	// final confirmation request parameters to SimplePunchout
	private static final String FINISH_SUCCESS = MessageKey.getConfig("_PSP_STRING_DONE");
	
	// callback parameters from SimplePunchout
	private static final String RESULT = MessageKey.getConfig("_PSP_STRING_RESULT");
	
	/** The value standing for payment is done successfully. */
	public static final String PAYMENT_SUCCESSFUL = MessageKey.getConfig("_PSP_STRING_SUCCESSFUL");

	/** The value standing for payment is failed. */
	public static final String PAYMENT_FAILED = MessageKey.getConfig("_PSP_STRING_FAILED");

	/** The value standing for payment is invalid. */
	public static final String PAYMENT_INVALID = MessageKey.getConfig("_PSP_STRING_INVALID");
	
	/** The name of transaction result of punch-out payment. It was used as key. */
	public static final String PUNCHOUT_TRAN_RESULT = MessageKey.getConfig("_PSP_STRING_PUNCHOUTTRANRESULT");

	/** The name of callback response of punch-out payment. It was used as key. */
	public static final String PUNCHOUT_CALLBACK_RESPONSE = MessageKey.getConfig("_PSP_STRING_PUNCHOUTCALLBACKRESPONSE");

	/** The response code when the operation is successful. */
	public static final String RESPONSECODE_SUCCESS = "0";

	/** The reason code when the operation is successful. */
	public static final String REASONCODE_NONE = "0";
	
	/** The response code when the opreation failed. */
	public static final String RESPONSECODE_FAIL = "1";
	
	/**
	 * The state of the financial transaction to allow the plugin has chance to control the state transition. 
	 * Just before Plugin Controller passes the current financial transaction to plugins, it set 
	 * the transaction state to TRANSACTION_STATE_NEW. If the plugin wants to control the state transition 
	 * of the transaction, the plugin can set any other valid state: TRANSACTION_STATE_PENDING, TRANSACTION_STATE_SUCCESS, TRANSACTION_STATE_FAILED
	 * or TRANSACTION_STATE_CANCELED. 
	 */
	public static final short TRANSACTION_STATE_NEW = 0;

	/**
	 * The state for the payment or credit transaction when the transaction has not finished yet.
	 * It might mean that the plug-in implements an offline protocol that requires
	 * external intervention to move the payment or credit transaction into another state.
	 */
	public static final short TRANSACTION_STATE_PENDING = 1;

	/**
	 * The state for the payment or credit transaction on a successful execution.
	 */
	public static final short TRANSACTION_STATE_SUCCESS = 2;

	/**
	 * The state for the payment or credit transaction when the transaction has failed.
	 */
	public static final short TRANSACTION_STATE_FAILED = 3;

	/**
	 * The state for the payment or credit transaction when the transaction has been canceled.
	 */
	public static final short TRANSACTION_STATE_CANCELED = 4;	

	
	/** The name of popup URL of punch-out payment. It was used as key. */
	public static final String PUNCHOUT_POPUP_URL = "punchoutPopupURL";

	/** The name of payment method of punch-out payment. It was used as key. */
	public static final String PUNCHOUT_PAYMENT_METHOD = "punchoutPaymentMethod";
	
	/** The name of payment token. */
	public static final String PAYMENT_TOKEN = "payment_token";
	
	/** The account number. */
	public static final String PAYMENT_ACCOUNT = "account";
	
	/**
	 * The payment account verification result
	 */
	public static final String ACCOUNT_VERIFY_RESULT = "verifyResult";
	
	/**
	 * The payment account verification result of success
	 */
	public static final String ACCOUNT_VERIFY_RESULT_SUCCESS = "success";
	/**
	 * The payment account verification result of success
	 */
	public static final String ACCOUNT_VERIFY_RESULT_FAILED = "failed";
	private static final String ERROR_MESSAGE = "errorMessage";
	/**
	 * Default constructor.
	 */
	public PaymentResource() {
	}
	
	@POST
	@Path("/get_punchout_url")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for GetPunchoutURLCmd task command.",
			notes = "| Command: com.ibm.commerce.payment.task.commands.GetPunchoutURLCmd |\n|----------|\n| GetPunchoutURLCmd is a task command which is used to compose the payment punchout url.|", 
	response = GetPunchoutURLCmdUEOutput.class,
	extensions = { 
       @Extension( name = "data-command", properties = {
           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.payment.task.commands.GetPunchoutURLCmd")
           })
    })
    @ApiResponses(value = {
      @ApiResponse(code = 400, message = "Application error"),
      @ApiResponse(code = 500, message = "System error") })
	public Response getPunchoutURL(@ApiParam(name="GetPunchoutURLCmdUEInput", value = "GetPunchoutURLCmd UE Input Parameter", required = true)GetPunchoutURLCmdUEInput ueRequest) {
	
		final String METHOD_NAME = "getPunchoutURL()";

		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		PaymentInstruction paymentInstruction = ueRequest.getPaymentInstruction();
		
		GetPunchoutURLCmdUEOutput ueResponse = new GetPunchoutURLCmdUEOutput();
		String punchURL = MessageKey.getConfig("_PSP_PUNCHOUT_URL");
		punchURL = punchURL.replace(MessageKey.getConfig("_PSP_PUNCHOUT_URL_PI_ID"), paymentInstruction.getId());
		ueResponse.setPunchoutURL(punchURL);
		Map extData = paymentInstruction.getExtendedData();
		extData.put(MessageKey.getConfig("_PSP_EXTENDED_DATA_TESTDATA_ID"), MessageKey.getConfig("_PSP_EXTENDED_DATA_TESTDATA_VALUE"));
		ueResponse.setPaymentInstruction(paymentInstruction);
		LOGGER.info("punchoutURL is " + punchURL);
		Response response = Response.ok(ueResponse).build();
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}
	
	
	@POST
	@Path("/process_punchout_response")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for ProcessPunchoutResponseCmd task command.", 
			notes = "| Command: com.ibm.commerce.payment.task.commands.ProcessPunchoutResponseCmd |\n|----------|\n| ProcessPunchoutResponseCmd is a task command which is used to process the provider response data.|", 
	response = ProcessPunchoutResponseCmdUEOutput.class,
	extensions = { 
       @Extension( name = "data-command", properties = {
           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.payment.task.commands.ProcessPunchoutResponseCmd")
           })
    })
	@ApiResponses(value = {
			@ApiResponse(code = 400, message = "Application error"),
			@ApiResponse(code = 500, message = "System error")
	})
	
	public Response processPunchoutResponse(@ApiParam(name="ProcessPunchoutResponseCmdUEInput",value = "ProcessPunchoutResponseCmd UE Input Parameter",
			required = true)ProcessPunchoutResponseCmdUEInput ueRequest) {

		final String METHOD_NAME = "processPunchoutResponse()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		PaymentInstruction paymentInstruction = ueRequest.getPaymentInstruction();
		
		ProcessPunchoutResponseCmdUEOutput ueResponse = new ProcessPunchoutResponseCmdUEOutput();
		Map responseParams = new HashMap();
		String externalResult = (String) ueRequest.getCallBackParams().get(RESULT);
		String result = null;
		if (!RESULT_DONE.equalsIgnoreCase(externalResult)) {
			result = PAYMENT_INVALID;
		} else {
			String confirmResult = "yes";
			if (CONFIRMATION_SUCCESS.equalsIgnoreCase(confirmResult)) {
				result =PAYMENT_SUCCESSFUL;
			} else {
				result = PAYMENT_INVALID;
			}
		}
		responseParams.put(PUNCHOUT_TRAN_RESULT, result);
		responseParams.put(PUNCHOUT_CALLBACK_RESPONSE, FINISH_SUCCESS);
		ueResponse.setResponseParams(responseParams);
		
		Map extData = paymentInstruction.getExtendedData();
		extData.put(MessageKey.getConfig("_PSP_EXTENDED_DATA_TRANSACTION_ID"), "1001");
		LOGGER.info("transactionId is " + extData.get("transactionId"));
		ueResponse.setPaymentInstruction(paymentInstruction);
		
		Response response = Response.ok(ueResponse).build();
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}
	
	@POST
	@Path("/approve_payment")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for PaymentApproveCmd task command.",
			notes = "| Command: com.ibm.commerce.payment.task.commands.PaymentApproveCmd |\n|----------|\n| PaymentApproveCmd is a task command which is used to authorize the payment.|", 
	response = PaymentApproveCmdUEOutput.class,
	extensions = { 
       @Extension( name = "data-command", properties = {
           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.payment.task.commands.ProcessPunchoutResponseCmd")
           })
    })
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response approvePayment(@ApiParam(name="PaymentApproveCmdUEInput",value = "PaymentApproveCmd UE Input Parameter",
			required = true)PaymentApproveCmdUEInput ueRequest) {

		final String METHOD_NAME = "approvePayment()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}

		FinancialTransaction financialTransaction = ueRequest.getFinancialTransaction();
		PaymentInstruction paymentInstruction = ueRequest.getFinancialTransaction().getPayment().getPaymentInstruction();
		
		LOGGER.info("The amount to be authorized is " + paymentInstruction.getAmount());
		
		PaymentApproveCmdUEOutput ueResponse = new PaymentApproveCmdUEOutput();
		Map extData = paymentInstruction.getExtendedData();
		Map tranExtData = financialTransaction.getExtendedData();
		
		//test add extdata
		extData.put("testdata", "datatotestinApprove-PI");
		tranExtData.put("testdata", "datatotestinApprove-Transaction");
		
		//test remove extdata
		extData.remove("langId");
		
		//test update transaction property
		financialTransaction.setResponseCode(RESPONSECODE_SUCCESS);
		financialTransaction.setReasonCode(REASONCODE_NONE);
		financialTransaction.setState(TRANSACTION_STATE_SUCCESS);
		financialTransaction.setTrackingId("1");
		
		ueResponse.setFinancialTransaction(financialTransaction);
		Response response = Response.ok(ueResponse).build();
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}
	
	
	@POST
	@Path("/deposit_payment")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for PaymentDepositCmd task command.",
			notes = "| Command: com.ibm.commerce.payment.task.commands.PaymentDepositCmd |\n|----------|\n| PaymentDepositCmd is a task command which is used to authorize the payment.|", 
	response = PaymentDepositCmdUEOutput.class,
	extensions = { 
       @Extension( name = "data-command", properties = {
           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.payment.task.commands.PaymentDepositCmd")
           })
    })
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response depositPayment(@ApiParam(name="PaymentDepositCmdUEInput",value = "PaymentDepositCmd UE Input Parameter",
			required = true)PaymentDepositCmdUEInput ueRequest) {

		final String METHOD_NAME = "depositPayment()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		FinancialTransaction financialTransaction = ueRequest.getFinancialTransaction();
		PaymentInstruction paymentInstruction = ueRequest.getFinancialTransaction().getPayment().getPaymentInstruction();		

		LOGGER.info("The amount to be deposited is " + paymentInstruction.getAmount());
		PaymentDepositCmdUEOutput ueResponse = new PaymentDepositCmdUEOutput();
		Map extData = paymentInstruction.getExtendedData();
		extData.put("testdata", "datatotestindepositPayment");
		ueResponse.setFinancialTransaction(financialTransaction);
		Response response = Response.ok(ueResponse).build();
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}
	
	@POST
	@Path("/approve_and_deposit_payment")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for PaymentApproveAndDepositCmd task command.",
			notes = "| Command: com.ibm.commerce.payment.task.commands.PaymentApproveAndDepositCmd |\n|----------|\n| PaymentApproveAndDepositCmd is a task command which is used to authorize the payment.|", 
	response = PaymentApproveAndDepositCmdUEOutput.class,
	extensions = { 
       @Extension( name = "data-command", properties = {
           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.payment.task.commands.PaymentApproveAndDepositCmd")
           })
    })
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response approveAndDepositPayment(@ApiParam(name="PaymentApproveAndDepositCmdUEInput",value = "PaymentApproveAndDepositCmd UE Input Parameter",
			required = true)PaymentApproveAndDepositCmdUEInput ueRequest) {

		final String METHOD_NAME = "approveAndDepositPayment()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}

		FinancialTransaction financialTransaction = ueRequest.getFinancialTransaction();
		PaymentInstruction paymentInstruction = ueRequest.getFinancialTransaction().getPayment().getPaymentInstruction();
		
		LOGGER.info("The amount to be processed is " + paymentInstruction.getAmount());
		PaymentApproveAndDepositCmdUEOutput ueResponse = new PaymentApproveAndDepositCmdUEOutput();
		Map extData = paymentInstruction.getExtendedData();
		extData.put("testdata", "datatotestinapproveAndDepositPayment");
		ueResponse.setFinancialTransaction(financialTransaction);
		Response response = Response.ok(ueResponse).build();
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}
	
	@POST
	@Path("/reverse_approval")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for PaymentReverseApprovalCmd task command.",
			notes = "| Command: com.ibm.commerce.payment.task.commands.PaymentReverseApprovalCmd |\n|----------|\n| PaymentReverseApprovalCmd is a task command which is used to authorize the payment.|", 
	response = PaymentReverseApprovalCmdUEOutput.class,
	extensions = { 
       @Extension( name = "data-command", properties = {
           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.payment.task.commands.PaymentReverseApprovalCmd")
           })
    })
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response reverseApproval(@ApiParam(name="PaymentReverseApprovalCmdUEInput",value = "PaymentReverseApprovalCmd UE Input Parameter",
			required = true)PaymentReverseApprovalCmdUEInput ueRequest) {

		final String METHOD_NAME = "reverseApproval()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		FinancialTransaction financialTransaction = ueRequest.getFinancialTransaction();
		PaymentInstruction paymentInstruction = ueRequest.getFinancialTransaction().getPayment().getPaymentInstruction();		

		LOGGER.info("The amount to be reversed is " + paymentInstruction.getAmount());
		PaymentReverseApprovalCmdUEOutput ueResponse = new PaymentReverseApprovalCmdUEOutput();
		Map extData = paymentInstruction.getExtendedData();
		extData.put("testdata", "datatotestinreverseApproval");
		ueResponse.setFinancialTransaction(financialTransaction);
		Response response = Response.ok(ueResponse).build();
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}
	
	@POST
	@Path("/reverse_deposit")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for PaymentReverseDepositCmd task command.",
			notes = "| Command: com.ibm.commerce.payment.task.commands.PaymentReverseDepositCmd |\n|----------|\n| PaymentReverseDepositCmd is a task command which is used to authorize the payment.|", 
	response = PaymentReverseDepositCmdUEOutput.class,
	extensions = { 
       @Extension( name = "data-command", properties = {
           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.payment.task.commands.PaymentReverseDepositCmd")
           })
    })
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response reverseDeposit(@ApiParam(name="PaymentReverseDepositCmdUEInput",value = "PaymentReverseDepositCmd UE Input Parameter",
			required = true)PaymentReverseDepositCmdUEInput ueRequest) {

		final String METHOD_NAME = "reverseDeposit()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		FinancialTransaction financialTransaction = ueRequest.getFinancialTransaction();
		PaymentInstruction paymentInstruction = ueRequest.getFinancialTransaction().getPayment().getPaymentInstruction();		

		LOGGER.info("The amount to be reversed is " + paymentInstruction.getAmount());
		PaymentReverseDepositCmdUEOutput ueResponse = new PaymentReverseDepositCmdUEOutput();
		Map extData = paymentInstruction.getExtendedData();
		extData.put("testdata", "datatotestinreverseDeposit");
		ueResponse.setFinancialTransaction(financialTransaction);
		Response response = Response.ok(ueResponse).build();
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}
	
	@POST
	@Path("/credit_payment")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for PaymentCreditCmd task command.",
			notes = "| Command: com.ibm.commerce.payment.task.commands.PaymentCreditCmd |\n|----------|\n| PaymentCreditCmd is a task command which is used to authorize the payment.|", 
	response = PaymentCreditCmdUEOutput.class,
	extensions = { 
       @Extension( name = "data-command", properties = {
           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.payment.task.commands.PaymentCreditCmd")
           })
    })
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response creditPayment(@ApiParam(name="PaymentCreditCmdUEInput",value = "PaymentCreditCmd UE Input Parameter",
			required = true)PaymentCreditCmdUEInput ueRequest) {

		final String METHOD_NAME = "creditPayment()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		FinancialTransaction financialTransaction = ueRequest.getFinancialTransaction();
		PaymentInstruction paymentInstruction = ueRequest.getFinancialTransaction().getCredit().getPaymentInstruction();		

		LOGGER.info("The amount to be credited is " + paymentInstruction.getAmount());
		PaymentCreditCmdUEOutput ueResponse = new PaymentCreditCmdUEOutput();
		Map extData = paymentInstruction.getExtendedData();
		extData.put("testdata", "datatotestincreditPayment");
		ueResponse.setFinancialTransaction(financialTransaction);
		Response response = Response.ok(ueResponse).build();
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}	
	
	@POST
	@Path("/clean_session")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for SessionCleanCmd task command.",
			notes = "| Command: com.ibm.commerce.payment.task.commands.SessionCleanCmd |\n|----------|\n| SessionCleanCmd is a task command which is used to clean the pending and expired payments.|", 
	response = SessionCleanCmdUEOutput.class,
	extensions = { 
       @Extension( name = "data-command", properties = {
           @ExtensionProperty(name = "Command", value = "com.ibm.commerce.payment.task.commands.SessionCleanCmd")
           })
    })
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response cleanSession(@ApiParam(name="SessionCleanCmdUEInput",value = "SessionCleanCmd UE Input Parameter",
			required = true)SessionCleanCmdUEInput ueRequest) {

		final String METHOD_NAME = "cleanSession()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		
		List<PaymentInstruction> paymentInstructions = ueRequest.getPaymentInstructions();		

		LOGGER.info("The amount to be clean is " + paymentInstructions.get(0).getAmount());
		SessionCleanCmdUEOutput ueResponse = new SessionCleanCmdUEOutput();
		for(int i=0; i<paymentInstructions.size(); i++)
		{
			Map extData = paymentInstructions.get(i).getExtendedData();
			extData.put("testdata", "datatotestincleanSession");
			extData.put("action", "reverse");
			
		}
		
		ueResponse.setPaymentInstructions(paymentInstructions);
		
		
		
		Response response = Response.ok(ueResponse).build();
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}	
	
	
	@POST
	@Path("/approve_payment_applepay")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for PaymentApproveCmd task command.",
			notes = "| Command: com.ibm.commerce.payment.task.commands.PaymentApproveCmd |\n|----------|\n| PaymentApproveCmd is a task command which is used to authorize the payment.|", 
	response = PaymentApproveCmdUEOutput.class)
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response approvePaymentApplePay(@ApiParam(name="PaymentApproveCmdUEInput",value = "PaymentApproveCmd UE Input Parameter",
			required = true)PaymentApproveCmdUEInput ueRequest) {

		final String METHOD_NAME = "approvePaymentApplePay()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}

		FinancialTransaction financialTransaction = ueRequest.getFinancialTransaction();
		PaymentInstruction paymentInstruction = ueRequest.getFinancialTransaction().getPayment().getPaymentInstruction();
		
		LOGGER.info("The amount to be authorized is " + paymentInstruction.getAmount());
		
		PaymentApproveCmdUEOutput ueResponse = new PaymentApproveCmdUEOutput();
		Map extData = paymentInstruction.getExtendedData();
		Map tranExtData = financialTransaction.getExtendedData();
		
		//compose PKPaymentToken for ApplePay payment request
		PKPaymentToken token = ApplePayUtils.composePaymentToken(extData);
		
		//send PKPaymentToken and necessary order info to Payment Gateway
		//analyze the result from Gateway, then set back to UE response.
		
		//test add extdata
		extData.put("testdata", "datatotestinApprove-PI");
		tranExtData.put("testdata", "datatotestinApprove-Transaction");
		
		//test remove extdata
		extData.remove("langId");
		
		//test update transaction property
		financialTransaction.setResponseCode(RESPONSECODE_SUCCESS);
		financialTransaction.setReasonCode(REASONCODE_NONE);
		financialTransaction.setState(TRANSACTION_STATE_SUCCESS);
		financialTransaction.setTrackingId("1");
		
		ueResponse.setFinancialTransaction(financialTransaction);
		Response response = Response.ok(ueResponse).build();
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}
	
		@POST
	@Path("/create_payment_token")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for CreatePaymentTokenCmd task command.",
	notes = "| Command: com.ibm.commerce.payment.task.commands.CreatePaymentTokenCmd |\n|----------|\n| CreatePaymentTokenCmd is a task command which is used to create the payment token.|", 
response = CreatePaymentTokenCmdUEOutput.class)
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response createPaymentToken(@ApiParam(name="CreatePaymentTokenCmdUEInput",value = "CreatePaymentTokenCmd UE Input Parameter",
			required = true)CreatePaymentTokenCmdUEInput ueRequest) {

		final String METHOD_NAME = "createPaymentToken()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		Map tokenData = new HashMap();
		String token_id = null;
		String display_value = null;
		Response response;
		
		Map protocolData = ueRequest.getProtocolData();	
		Object accountNumber = protocolData.get("account");
		if(accountNumber != null){
			token_id = accountNumber + "9";
			display_value = accountNumber.toString().substring(5) + "8";
			if (LOGGER.isLoggable(Level.FINER)){
				LOGGER.finer("tokenId to be returned in create is " + token_id);
				LOGGER.finer("display_vaue to be returned in create is " + display_value);
			}
		    tokenData.put(PAYMENT_TOKEN, token_id);
		    //tokenData.put("display_value", display_value);
		    CreatePaymentTokenCmdUEOutput ueResponse = new CreatePaymentTokenCmdUEOutput();
			ueResponse.setPaymentToken(tokenData);
		    response = Response.ok(ueResponse).build();
		} else{
			//throw exception
			ErrorUEResponse ueResponse = new ErrorUEResponse();
			List<ExceptionData> errors = new ArrayList<ExceptionData>();
			ExceptionData error = new ExceptionData();
			error.setCode("400");
			error.setMessageKey("_ERR_INVALID_PARAMETER_VALUE");
			error.setMessage(MessageKey.getMessage(locale, "_ERR_INVALID_PARAMETER_VALUE",
					new Object[] { "account", accountNumber }));
			errors.add(error);
			ueResponse.setErrors(errors);
			response = Response.status(400).type(MediaType.APPLICATION_JSON).entity(ueResponse).build();

		}

		
		
		
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}	
	
	@POST
	@Path("/fetch_payment_token")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for FetchPaymentTokenCmd task command.",
	notes = "| Command: com.ibm.commerce.payment.task.commands.FetchPaymentTokenCmd |\n|----------|\n| FetchPaymentTokenCmd is a task command which is used to fetch the payment token.|", 
    response = FetchPaymentTokenCmdUEOutput.class)
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response fetchPaymentToken(@ApiParam(name="FetchPaymentTokenCmdUEInput",value = "FetchPaymentTokenCmd UE Input Parameter",
			required = true)FetchPaymentTokenCmdUEInput ueRequest) {

		final String METHOD_NAME = "fetchPaymentToken()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		String display_value = null;
		Response response;
		
		Map token = ueRequest.getProtocolData();
		Object tokenId = token.get(PAYMENT_TOKEN);
		if(tokenId != null){
			display_value = tokenId.toString().substring(4);
			
			if (LOGGER.isLoggable(Level.FINER)){
				LOGGER.finer("tokenId to be returned in fetch is " + tokenId);
				LOGGER.finer("display value to be returned in fetch is " + display_value);
			}
		   
		    FetchPaymentTokenCmdUEOutput ueResponse = new FetchPaymentTokenCmdUEOutput();
			Map tokenData = new HashMap();
			tokenData.put(PAYMENT_TOKEN, tokenId);
			tokenData.put("display_value", display_value);
			ueResponse.setPaymentToken(tokenData);
			
			
			
			response = Response.ok(ueResponse).build();
		}else{
			//throw exception
			ErrorUEResponse ueResponse = new ErrorUEResponse();
			List<ExceptionData> errors = new ArrayList<ExceptionData>();
			ExceptionData error = new ExceptionData();
			error.setCode("400");
			error.setMessageKey("_ERR_INVALID_PARAMETER_VALUE");
			error.setMessage(MessageKey.getMessage(locale, "_ERR_INVALID_PARAMETER_VALUE",
					new Object[] { PAYMENT_TOKEN, tokenId }));
			errors.add(error);
			ueResponse.setErrors(errors);
			response = Response.status(400).type(MediaType.APPLICATION_JSON).entity(ueResponse).build();

		}
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}	
	
	@POST
	@Path("/remove_payment_token")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for RemovePaymentTokenCmd task command.",
	notes = "| Command: com.ibm.commerce.payment.task.commands.RemovePaymentTokenCmd |\n|----------|\n| RemovePaymentTokenCmd is a task command which is used to remove the payment token.|", 
    response = RemovePaymentTokenCmdUEOutput.class)
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response removePaymentToken(@ApiParam(name="RemovePaymentTokenCmdUEInput",value = "RemovePaymentTokenCmd UE Input Parameter",
			required = true)RemovePaymentTokenCmdUEInput ueRequest) {

		final String METHOD_NAME = "fetchPaymentToken()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		String display_value = null;
		Response response;
		
		Map token = ueRequest.getProtocolData();
		Object tokenId = token.get(PAYMENT_TOKEN);
		if(tokenId != null){
			display_value = tokenId.toString().substring(4);
			if (LOGGER.isLoggable(Level.FINER)){
				LOGGER.finer("tokenId to be remove is " + tokenId);
				LOGGER.finer("display value to be remove is " + display_value);
			}		    	
		    RemovePaymentTokenCmdUEOutput ueResponse = new RemovePaymentTokenCmdUEOutput();
			Map tokenData = new HashMap();
			tokenData.put(PAYMENT_TOKEN, tokenId);
			tokenData.put("display_value", display_value);
			ueResponse.setPaymentToken(tokenData);
			
			
			
			response = Response.ok(ueResponse).build();
		}else{
			//throw exception
			ErrorUEResponse ueResponse = new ErrorUEResponse();
			List<ExceptionData> errors = new ArrayList<ExceptionData>();
			ExceptionData error = new ExceptionData();
			error.setCode("400");
			error.setMessageKey("_ERR_INVALID_PARAMETER_VALUE");
			error.setMessage(MessageKey.getMessage(locale, "_ERR_INVALID_PARAMETER_VALUE",
					new Object[] { PAYMENT_TOKEN, tokenId }));
			errors.add(error);
			ueResponse.setErrors(errors);
			response = Response.status(400).type(MediaType.APPLICATION_JSON).entity(ueResponse).build();

		}
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}	
	
	@POST
	@Path("/update_payment_token")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for UpdatePaymentTokenCmd task command.",
	notes = "| Command: com.ibm.commerce.payment.task.commands.UpdatePaymentTokenCmd |\n|----------|\n| UpdatePaymentTokenCmd is a task command which is used to update the payment token.|", 
    response = UpdatePaymentTokenCmdUEOutput.class)
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })

	public Response updatePaymentToken(@ApiParam(name="UpdatePaymentTokenCmdUEInput",value = "UpdatePaymentTokenCmd UE Input Parameter",
			required = true)UpdatePaymentTokenCmdUEInput ueRequest) {

		final String METHOD_NAME = "updatePaymentToken()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		
		String display_value = null;
		Response response;
		
		Map token = ueRequest.getProtocolData();
		Object tokenId = token.get(PAYMENT_TOKEN);
		Object account = token.get(PAYMENT_ACCOUNT);
		Object removeToken = token.get("canRemoveToken");
		if (LOGGER.isLoggable(Level.FINER)){
			LOGGER.finer("can remove " + removeToken);
		}
		
		if(tokenId != null){
			if (LOGGER.isLoggable(Level.FINER)){
				LOGGER.finer("tokenId to be update is " + tokenId);
			}
			
		    UpdatePaymentTokenCmdUEOutput ueResponse = new UpdatePaymentTokenCmdUEOutput();
			Map tokenData = new HashMap();
			
			tokenData.put("display_value", display_value);
			String oldAccount = tokenId.toString().substring(0, tokenId.toString().length()-1);
			if (LOGGER.isLoggable(Level.FINER)){
				LOGGER.finer("oldAccount is " + oldAccount);
			}
			
			if(account != null && account.equals(oldAccount)){
				tokenData.put(PAYMENT_TOKEN, tokenId);
				display_value = tokenId.toString().substring(4);
				if (LOGGER.isLoggable(Level.FINER)){
					LOGGER.finer("token to return in update is " + tokenId + " display value to be update is " + display_value);
				}
				
				
			}else{
				tokenData.put(PAYMENT_TOKEN, account + "9");
				display_value = tokenData.get(PAYMENT_TOKEN).toString().substring(4);		
				if (LOGGER.isLoggable(Level.FINER)){
					LOGGER.finer("token to be updated to " + account+ "9" + " display value to be update is " + display_value);
				}
			}
			
			ueResponse.setPaymentToken(tokenData);			
			response = Response.ok(ueResponse).build();
		}else{
			//throw exception
			ErrorUEResponse ueResponse = new ErrorUEResponse();
			List<ExceptionData> errors = new ArrayList<ExceptionData>();
			ExceptionData error = new ExceptionData();
			error.setCode("400");
			error.setMessageKey("_ERR_INVALID_PARAMETER_VALUE");
			error.setMessage(MessageKey.getMessage(locale, "_ERR_INVALID_PARAMETER_VALUE",
					new Object[] { PAYMENT_TOKEN, tokenId }));
			errors.add(error);
			ueResponse.setErrors(errors);
			response = Response.status(400).type(MediaType.APPLICATION_JSON).entity(ueResponse).build();

		}
		
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;

	}	
	@POST
	@Path("/verify_payment_account")
	@Consumes({ MediaType.APPLICATION_JSON })
	@Produces({ MediaType.APPLICATION_JSON })
	@ApiOperation(value = "The API extension for VerifyPaymentAccountCmd task command.",
	notes = "| Command: com.ibm.commerce.payment.task.commands.VerifyPaymentAccountCmd |\n|----------|\n| VerifyPaymentAccountCmd is a task command which is used to verify the payment account.|", 
    response = VerifyPaymentAccountCmdUEOutput.class)
	@ApiResponses(value = {
    @ApiResponse(code = 400, message = "Application error"),
    @ApiResponse(code = 500, message = "System error") })
	public Response verifyPaymentAccount(@ApiParam(name="VerifyPaymentAccountCmdUEInput",value = "VerifyPaymentAccountCmdUEInput UE Input Parameter",
			required = true)VerifyPaymentAccountCmdUEInput ueRequest) {

		final String METHOD_NAME = "verifyPaymentAccount()";
		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.entering(CLASS_NAME, METHOD_NAME, new Object[] {});
		}

		String display_value = null;
		Response response;

		Map token = ueRequest.getProtocolData();
		VerifyPaymentAccountCmdUEOutput ueResponse = new VerifyPaymentAccountCmdUEOutput();

		Map results = new HashMap();

		//---Start to Connect to payment service provider to validate the account---
		//---End to Connect to payment service provider to validate the account---

		//This is the sample result which need return to WC when account is valid
		//results.put(ACCOUNT_VERIFY_RESULT, ACCOUNT_VERIFY_RESULT_SUCCESS);

		//This is the sample result which need return to WC when account is not valid
		results.put(ERROR_MESSAGE, "account number is wrong.");
		results.put(ACCOUNT_VERIFY_RESULT, ACCOUNT_VERIFY_RESULT_FAILED);

		//set the verifaction result into UE response
		ueResponse.setVerificationResult(results);
		if (LOGGER.isLoggable(Level.FINER)){
			LOGGER.finer("verify result is " + results.get(ACCOUNT_VERIFY_RESULT));
		}

		response = Response.ok(ueResponse).build();

		if (LOGGER.isLoggable(Level.FINER)) {
			LOGGER.exiting(CLASS_NAME, METHOD_NAME, new Object[] {});
		}
		return response;
	} 
}

