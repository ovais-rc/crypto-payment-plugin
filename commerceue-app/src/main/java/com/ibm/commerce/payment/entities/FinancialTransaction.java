package com.ibm.commerce.payment.entities;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2016
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */

import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;


public class FinancialTransaction {
	
    /** Amount representing $0.00000 */
    public static final BigDecimal ZERO_AMOUNT = new BigDecimal("0.00000");	
    
	/**
	 * The state of the financial transaction to allow the plugin has chance to control the state transition. 
	 * Just before Plugin Controller passes the current financial transaction to plugins, it set 
	 * the transaction state to STATE_NEW. If the plugin wants to control the state transition 
	 * of the transaction, the plugin can set any other valid state: STATE_PENDING, STATE_SUCCESS, STATE_FAILED
	 * or STATE_CANCELED. 
	 */
	public static final short STATE_NEW = 0;

	/**
	 * The state for the payment or credit transaction when the transaction has not finished yet.
	 * It might mean that the plug-in implements an offline protocol that requires
	 * external intervention to move the payment or credit transaction into another state.
	 */
	public static final short STATE_PENDING = 1;

	/**
	 * The state for the payment or credit transaction on a successful execution.
	 */
	public static final short STATE_SUCCESS = 2;

	/**
	 * The state for the payment or credit transaction when the transaction has failed.
	 */
	public static final short STATE_FAILED = 3;

	/**
	 * The state for the payment or credit transaction when the transaction has been canceled.
	 */
	public static final short STATE_CANCELED = 4;

	/**
	 * Indicates the transaction is an approval (authorization).
	 */
	public static final short TRANSACTION_TYPE_APPROVE = 0;

	/**
	 * Indicates the transaction is a deposit (capture).
	 */
	public static final short TRANSACTION_TYPE_DEPOSIT = 1;

	/**
	 * Indicates that the transaction is an approval (authorization) and deposit (capture) at the same time.
	 * Some refer to this as a sale transaction.
	 */
	public static final short TRANSACTION_TYPE_APPROVE_AND_DEPOSIT = 2;

	/**
	 * Indicates that the transaction is a credit transaction.
	 */
	public static final short TRANSACTION_TYPE_CREDIT = 3;

	/**
	 * Indicates that the transaction is an approval (authorization) reversal.
	 */
	public static final short TRANSACTION_TYPE_REVERSE_APPROVAL = 4;

	/**
	 * Indicates that the transaction is a deposit (capture) reversal.
	 */
	public static final short TRANSACTION_TYPE_REVERSE_DEPOSIT = 5;

	/**
	 * Indicates that the transaction is a credit reversal transaction.
	 */
	public static final short TRANSACTION_TYPE_REVERSE_CREDIT = 6;    

	/**
	 * The unique identifier of the financial transaction.
	 */
	private String id = null;

	/**
	 * The state of the financial transaction.
	 */
	private short state = 0;

	/**
	 * The tracking ID associated with this transaction.
	 */
	private String trackingId = null;

	/**
	 * DOCUMENT ME!
	 */
	private String referenceNumber = null;

	/**
	 * DOCUMENT ME!
	 */
	private String responseCode = null;

	/**
	 * DOCUMENT ME!
	 */
	private String reasonCode = null;

	/**
	 * The target amount for the transaction
	 */
	private BigDecimal requestedAmount = ZERO_AMOUNT;

	/**
	 * The amount actually processed in the transaction
	 */
	private BigDecimal processedAmount = ZERO_AMOUNT;

	/**
	 * The time the transaction was created
	 */
	private Date timeCreated = null;

	/**
	 * The last time the transaction was updated
	 */
	private Date timeUpdated = null;

	/**
	 * The extended protocol data
	 */
	private Map extendedData = null;

	/**
	 * The type of the financial transaction
	 */
	private short transactionType = -1;

	/**
	 * The payment container associated with this transaction, if any
	 */
	private Payment payment = null;

	/**
	 * The credit container associated with this transaction, if any
	 */
	private Credit credit = null;



	/**
	 * <p>
	 * This method sets the <code>Credit</code> container this <code>FinancialTransaction</code> is associated with.
	 * </p>
	 *
	 * <p> This method is used for <code>FinancialTransaction</code>s with the types
	 * {@link #TRANSACTION_TYPE_CREDIT} and {@link #TRANSACTION_TYPE_REVERSE_CREDIT}.
	 * </p>
	 *
	 * @param credit The <code>Credit</code> container associated with this
	 *        <code>FinancialTransaction</code>
	 * @see #getCredit()
	 */
	public void setCredit(Credit credit) {
		this.credit = credit;
	}

	/**
	 * <p>
	 * This method gets the <code>Credit</code> container that is associated with the financial transaction.
	 * <p>
	 *
	 * <p> The <code>Credit</code> container will be present only for transactions of the types
	 * {@link #TRANSACTION_TYPE_CREDIT} and {@link #TRANSACTION_TYPE_REVERSE_CREDIT}.
	 * </p>
	 *
	 * @return The <code>Credit</code> container associated with this <code>FinancialTransaction</code>
	 * @see #setCredit(CreditImpl)
	 */
	public Credit getCredit() {
		return credit;
	}

	/**
	 * <p>
	 * This method adds extended data to the <code>FinancialTransaction</code> container.
     * </p>
     * 
     * <p>
	 * The information passed here will be added to the existing extended data associated
     * to the financial transaction. If any mapped value already exists it will be
	 * replaced with the new value.  
	 * </p>
     * 
     * <p>
     * The plug-in invokes this method when additional information needs to be added to
     * The <code>FinancialTransaction</code> container during the processing of a financial
     * transaction. The information might be required in subsequent financial transactions.
     * </p>
     * 
	 * @param extendedData The map of name-value pairs representing extended payment
	 *        information
	 * @see #getExtendedData()
	 */
	public void setExtendedData(Map extendedData) {
		this.extendedData = extendedData;
	}

	/**
	 * <p>
	 * This method gets the extra data associated with the financial transaction.
	 * </p>
	 *
	 * @return The extended data associated with the financial transaction
	 * @see #setExtendedData(ExtendedData)
	 */
	public Map getExtendedData() {
		return extendedData;
	}

	/**
	 * <p>
	 * This method sets the reference number of the financial transaction.
	 * </p>
	 *
     * <p>
     * The plug-in needs to invoke this method during the processing of a financial transaction
     * to update the reference number from the payment back-end system. This field is 
     * the unique identifier of the financial transaction from the payment back-end system 
     * perspective. For more details, please refer to the introduction of this <samp>Javadoc</samp>.
     * </p>
     *
	 * @param referenceNumber The unique identifier of the financial transaction from
     *        the payment backend system perspective.
	 * @see #getReferenceNumber().
	 */
	public void setReferenceNumber(String referenceNumber) {
		this.referenceNumber = referenceNumber;
	}

	/**
	 * <p>
	 * This method gets the reference number of the financial transaction.
     * </p>
     * 
     * <p>
     * This field is the unique identifier of the financial transaction from the payment
     * back-end system perspective. For more details, please refer to the introduction of this
     * <samp>Javadoc</samp>.
     * </p>
     *
	 * @return The unique identifier of the financial transaction from the payment <samp>back-end</samp>
     *         system perspective.
	 * @see #setReferenceNumber(String).
	 */
	public String getReferenceNumber() {
		return referenceNumber;
	}

	/**
	 * <p>
	 * This method gets the unique identifier of the <code>FinancialTransaction</code> container.
     * </p>
     * 
     * <p>
	 * This ID is guaranteed to be unique by the Payment Plug-in Controller.
	 * </p>
	 *
	 * @return A numeric unique identifier of the 
     *         <code>FinancialTransaction</code> container.
	 */
	public String getId() {
		return id;
	}
	
	/**
	 * This method sets the unique identifier of the <code>FinancialTransaction</code> container.
	 * @param id
	 */
	public void setId(String id){
		this.id = id;
	}	

	/**
	 * <p>
	 * This method sets the <code>Payment</code> container that is associated with the
	 * <code>FinancialTransaction</code> container.  This is only set for
	 * financial transactions with these types:
	 * {@link #TRANSACTION_TYPE_APPROVE}, {@link #TRANSACTION_TYPE_DEPOSIT},
	 * {@link #TRANSACTION_TYPE_REVERSE_APPROVAL}, {@link #TRANSACTION_TYPE_REVERSE_DEPOSIT}.
	 * </p>
	 *
	 * @param payment The <code>Payment</code> container to which this
	 *        financial transaction is associated with.
	 * @see #getPayment().
	 */
	public void setPayment(Payment payment) {
		this.payment = payment;
	}

	/**
	 * <p>
	 * This method gets the <code>Payment</code> container that is associated with the financial transaction.  
     * The <code>Payment container is only present in financial transactions with these types:
     * {@link #TRANSACTION_TYPE_APPROVE}, {@link #TRANSACTION_TYPE_DEPOSIT},
     * {@link #TRANSACTION_TYPE_REVERSE_APPROVAL}, {@link #TRANSACTION_TYPE_REVERSE_DEPOSIT}.
	 * </p>
	 *
	 * @return The <code>Payment</code> container to which this <code>FinancialTransaction</code>
	 *         is associated with.
	 * @see #setPayment(PaymentImpl)
	 */
	public Payment getPayment() {
		return payment;
	}

	/**
	 * <p>
	 * This method sets the amount actually processed in the financial transaction.
     * </p>
     * 
     * <p>
     * This is the amount that was actually processed by the back-end system on the 
     * <code>FinancialTransaction</code>. This value will typically be the same as the requested 
     * amount. Unless the payment protocol used by the backend system supports a different amount to
     * be processed.
     * </p>
     * 
     * <p> The Plugin is responsible for setting this amount during the processing of a financial
     * transaction. It is set when the amount processed by the backend system is different from the requested 
     * amount. If this amount is not set, the Payment Plugin Controller will assume that the 
     * requested amount was completely processed.
     * </p>
	 *
	 * @param processedAmount The processed amount.
	 * @see #getProcessedAmount().
	 */
	public void setProcessedAmount(BigDecimal processedAmount) {
		this.processedAmount = processedAmount;
	}

	/**
	 * <p>
	 * This method gets the actual processed amount.
     * </p>
     * 
	 * @return The amount actually processed by the payment back-end system.
	 * @see #setProcessedAmount(BigDecimal).
	 */
	public BigDecimal getProcessedAmount() {
		return processedAmount;
	}

	/**
	 * <p>
	 * This method sets the reason for a failed transaction.
	 * </p>
	 *
     * <p>
     * The Plugin needs to invoke this method during the processing of a financial transaction
     * to update the failure reason from the payment back-end system. For more 
     * details on this field, please refer to the introduction of this <samp>Javadoc</samp>.
     * </p>
     * 
	 * @param reasonCode The backend system specific reason for a failed transaction.
	 * @see #getReasonCode().
	 */
	public void setReasonCode(String reasonCode) {
		this.reasonCode = reasonCode;
	}

	/**
	 * <p>
	 * This method gets the reason for a failed financial transaction.
     * </p>
     *
     * <p>
     * For more details on this field, please refer to the introduction of this <samp>Javadoc</samp>.
     * </p>
     * 
	 * @return The back-end system specific reason for a failed transaction .
	 * @see #setReasonCode(String).
	 */
	public String getReasonCode() {
		return reasonCode;
	}

	/**
	 * <p>
	 * This method sets the amount to be processed in a financial transaction.
     * </p>
     * 
     * <p>
     * This amount represents the amount that the system needs to process on any given transaction. 
     * The actual processed amount might be different from the requested amount.
	 * </p>
	 *
     * <p>
     * This method is invoked by the Payment Plugin Controller before the financial transaction
     * starts. 
     * </p>
     * 
	 * @param requestedAmount The requested amount to be set.
	 * @see #getRequestedAmount().
     * @see #getProcessedAmount().
     * @see #setProcessedAmount(BigDecimal).
	 */
	public void setRequestedAmount(BigDecimal requestedAmount) {
		this.requestedAmount = requestedAmount;
	}

	/**
	 * <p>
	 * This method gets the amount to be processed in a financial transaction.
     * </p>
     * 
     * <p>
     * This amount represents the amount that the system needs to process on any given transaction. 
     * The actual processed amount might be different from the requested amount.
     * </p>
     *
	 * @return The amount to be processed in a financial transaction.
	 * @see #setRequestedAmount(BigDecimal).
     * @see #getProcessedAmount().
     * @see #setProcessedAmount(BigDecimal).
	 */
	public BigDecimal getRequestedAmount() {
		return requestedAmount;
	}

	/**
	 * <p>
	 * This method sets the back-end system specific result of the financial transaction.
	 * </p>
	 *
     * <p>
     * The Plugin needs to invoke this method during the processing of financial transactions
     * to update the result coming from the payment back-end system. For more details on this field,
     * please refer to the introduction of this <samp>Javadoc</samp>.
     * </p>
     * 
	 * @param responseCode The back-end system specific result of the financial transaction.
	 * @see #getResponseCode().
	 */
	public void setResponseCode(String responseCode) {
		this.responseCode = responseCode;
	}

	/**
	 * <p>
	 * This method gets the back-end system specific result of the financial transaction.
     * </p>
	 *
	 * @return The back-end system specific result of the financial transaction.
	 * @see #setResponseCode(String).
	 */
	public String getResponseCode() {
		return responseCode;
	}

	/**
	 * <p>
	 * This method sets the state of the <code>FinancialTransaction</code>. 
     * </p>
     * 
     * <p>
     * Valid values are:
     * </p>
     * 
     * <ul>
     * <li>{@link FinancialTransaction#STATE_CANCELED  STATE_CANCELED} </li>
     * <li>{@link FinancialTransaction#STATE_FAILED    STATE_FAILED} </li>
     * <li>{@link FinancialTransaction#STATE_PENDING   STATE_PENDING} </li>
     * <li>{@link FinancialTransaction#STATE_SUCCESS   STATE_SUCCESS} </li>
     * </ul>
	 *
     * <p>
     * Usually the Payment Plugin Controller will invoke this method to update a
     * financial transaction during its lifetime. However, if the Plugin needs to force the
     * financial transaction into a different state, the Plugin can call this method directly.
     * </p>
     * 
	 * @param state The state of the <code>FinancialTransaction</code>.
	 * @exception InvalidDataException If an invalid state is passed in.
	 * @see #getState().
	 */
	public void setState(short state){

		this.state = state;
	}

	/**
	 * <p>
	 * This method gets the state of the financial transaction.
	 * </p>
     * 
     * <p>
     * Valid values are:
     * </p>
     * 
     * <ul>
     * <li>{@link FinancialTransaction#STATE_CANCELED  STATE_CANCELED} </li>
     * <li>{@link FinancialTransaction#STATE_FAILED    STATE_FAILED} </li>
     * <li>{@link FinancialTransaction#STATE_PENDING   STATE_PENDING} </li>
     * <li>{@link FinancialTransaction#STATE_SUCCESS   STATE_SUCCESS} </li>
     * </ul>
     *
	 * @return The state of the financial transaction.
	 * @see #setState(short).
	 */
	public short getState() {
		return state;
	}

	/**
	 * <p>
	 * This method sets the time the <code>FinancialTransaction</code> was created.
	 * </p>
	 *
	 * <p>
	 * The Payment Plugin Controller sets this field when the <code>FinancialTransaction</code> is 
     * created.
	 * </p>
	 *
	 * @param timeCreated The time the <code>FinancialTransaction</code> was created.
	 * @see #getTimeCreated().
	 */
	public void setTimeCreated(Date timeCreated) {
		this.timeCreated = timeCreated;
	}

	/**
	 * <p>
	 * This method gets the time the <code>FinancialTransaction</code> was created.
	 * </p>
	 *
	 * @return The time the <code>FinancialTransaction</code> was created.
	 * @see #setTimeCreated(Date).
	 */
	public Date getTimeCreated() {
		return timeCreated;
	}

	/**
	 * <p>
	 * This method sets the time the <code>FinancialTransaction</code> was last updated.
	 * </p>
     * 
     * <p>
     * The Payment Plugin Controller updates this field <samp>everytime</samp> the 
     * <code>FinancialTransaction</code> changes.
     * </p>
	 *
	 * @param timeUpdated The timeUpdate to set.
	 * @see #getTimeUpdated().
	 */
	public void setTimeUpdated(Date timeUpdated) {
		this.timeUpdated = timeUpdated;
	}

	/**
	 * <p>
	 * This method gets the most recent time that the <code>FinancialTransaction</code> was updated.
	 * </p>
	 *
	 * @return The last time the <code>FinancialTransaction</code> was updated.
	 * @see #setTimeUpdated(Date).
	 */
	public Date getTimeUpdated() {
		return timeUpdated;
	}

	/**
	 * <p>
	 * This method sets the <code>FinancialTransaction</code> tracking identifier.
	 * </p>
	 *
     * <p>
     * The Plugin needs to invoke this method when processing a financial transaction to
     * update the tracking ID. This field is the unique identifier of the financial transaction 
     * from the Plugin perspective. For more details, please refer to the introduction of this 
     * <samp>Javadoc</samp>.
     * </p>
     *
	 * @param trackingId The unique identifier of the financial transaction from the Plugin
     *        perspective.
	 * @see #getTrackingId().
	 */
	public void setTrackingId(String trackingId) {
		this.trackingId = trackingId;
	}

	/**
	 * <p>
	 * This method gets the <code>FinancialTransaction</code> tracking ID.
	 * </p>
	 *
     * <p>
     * This field is the unique identifier of the financial transaction from the Plugin
     * perspective. For more details, please refer to the introduction of this <samp>Javadoc</samp>.
     * </p>
     *
	 * @return The unique identifier of the financial transaction from the Plugin perspective.
     * 
	 * @see #setTrackingId(String).
	 */
	public String getTrackingId() {
		return trackingId;
	}

	/**
	 * <p>
	 * This method sets the type of the <code>FinancialTransaction</code>.
     * 
     * <p>
     * Valid transaction types are:
     * </p>
     * 
     * <ul>
     * <li>{@link #TRANSACTION_TYPE_APPROVE TRANSACTION_TYPE_APPROVE}</li>
     * <li>{@link #TRANSACTION_TYPE_DEPOSIT TRANSACTION_TYPE_DEPOSIT}</li>
     * <li>{@link #TRANSACTION_TYPE_APPROVE_AND_DEPOSIT TRANSACTION_TYPE_APPROVE_AND_DEPOSIT}</li>
     * <li>{@link #TRANSACTION_TYPE_CREDIT TRANSACTION_TYPE_CREDIT}</li>
     * <li>{@link #TRANSACTION_TYPE_REVERSE_APPROVAL TRANSACTION_TYPE_REVERSE_APPROVAL}</li>
     * <li>{@link #TRANSACTION_TYPE_REVERSE_DEPOSIT TRANSACTION_TYPE_REVERSE_DEPOSIT}</li>
     * <li>{@link #TRANSACTION_TYPE_REVERSE_CREDIT TRANSACTION_TYPE_REVERSE_CREDIT}</li>
     * </ul>
     * 
     * <p>
     * The Payment Plugin Controller sets the type of the transaction during its creation.
     * </p>
     * 
	 * @param transactionType The type of the financial transaction.
	 * @exception InvalidDataException Thrown when an invalid transaction type is specified.
     * @see #getTransactionType().
	 */
	public void setTransactionType(short transactionType){
		this.transactionType = transactionType;
	}

	/**
	 * <p>
	 * This method gets the type of the <code>FinancialTransaction</code>.
     * </p>
     * 
     * <p>
     * Valid transaction types are:
     * </p>
     * 
     * <ul>
     * <li>{@link #TRANSACTION_TYPE_APPROVE TRANSACTION_TYPE_APPROVE}</li>
     * <li>{@link #TRANSACTION_TYPE_DEPOSIT TRANSACTION_TYPE_DEPOSIT}</li>
     * <li>{@link #TRANSACTION_TYPE_APPROVE_AND_DEPOSIT TRANSACTION_TYPE_APPROVE_AND_DEPOSIT}</li>
     * <li>{@link #TRANSACTION_TYPE_CREDIT TRANSACTION_TYPE_CREDIT}</li>
     * <li>{@link #TRANSACTION_TYPE_REVERSE_APPROVAL TRANSACTION_TYPE_REVERSE_APPROVAL}</li>
     * <li>{@link #TRANSACTION_TYPE_REVERSE_DEPOSIT TRANSACTION_TYPE_REVERSE_DEPOSIT}</li>
     * <li>{@link #TRANSACTION_TYPE_REVERSE_CREDIT TRANSACTION_TYPE_REVERSE_CREDIT}</li>
     * </ul>
     * 
	 * @return The type of the financial transaction
	 * @see #setTransactionType(short)
	 */
	public short getTransactionType() {
		return transactionType;
	}
}
