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
import java.util.ArrayList;
import java.util.Map;


public class PaymentInstruction {
	
    /** Amount representing $0.00000 */
    public static final BigDecimal ZERO_AMOUNT = new BigDecimal("0.00000");
	
	/**
	 * The state of the <code>PaymentInstruction</code> just after its creation and before
	 * validation.
	 */
	public static final short STATE_NEW = 0;

	/**
	 * The state of <code>PaymentInstruction</code> after a successful validation.
	 */
	public static final short STATE_VALID = 1;

	/**
	 * The state of <code>PaymentInstruction</code> after a failed validation.
	 */
	public static final short STATE_INVALID = 2;

	/**
	 * The state of <code>PaymentInstruction</code> after it has been closed.
	 */
	public static final short STATE_CLOSED = 3;	

	/** The extended data of  <code>PaymentInstruction</code>*/
	private Map extendedData = null;

	/** The account */
	private String account = null;

	/** The currency */
	private String currency = null;

	/** The id */
	private String id = null;

	/** The amount of the <code>PaymentInstruction</code> */
	private BigDecimal amount = ZERO_AMOUNT;

	/** The state of <code>PaymentInstruction</code> after it is created */
	private short state = STATE_NEW;

	/** The order id of <code>PaymentInstruction</code> */
	private String orderId = null;

    /** The rma id of <code>PaymentInstruction</code> */
    private String rmaId = null;

	/** The store of <code>PaymentInstruction</code> */
	private String store = null;

	/** The payment system name of <code>PaymentInstruction</code> */
	private String paymentSystemName = null; 

	/** The time to create <code>PaymentInstruction</code> */
	private long timeCreated = 0;

	/** The time to update <code>PaymentInstruction</code> */
	private long timeUpdated = 0;

	/** The payments to process this <code>PaymentInstruction</code> */
	private ArrayList<Payment> payments = null;

	/** The credits to this <code>PaymentInstruction</code> */
	private ArrayList<Credit> credits = null;

	/** The approving amount of this <code>PaymentInstruction</code> */
	private BigDecimal approvingAmount = ZERO_AMOUNT;

	/** The approved amount of this <code>PaymentInstruction</code> */
	private BigDecimal approvedAmount = ZERO_AMOUNT;

	/** The depositing amount of this <code>PaymentInstruction</code> */
	private BigDecimal depositingAmount = ZERO_AMOUNT;

	/** The deposited amount of this <code>PaymentInstruction</code> */
	private BigDecimal depositedAmount = ZERO_AMOUNT;

	/** The crediting amount of this <code>PaymentInstruction</code> */
	private BigDecimal creditingAmount = ZERO_AMOUNT;

	/** The created amount of this <code>PaymentInstruction</code> */
	private BigDecimal creditedAmount = ZERO_AMOUNT;

	/** The reversing approved amount of this <code>PaymentInstruction</code> */
	private BigDecimal reversingApprovedAmount = ZERO_AMOUNT;

	/** The reversing deposited amount of this <code>PaymentInstruction</code> */
	private BigDecimal reversingDepositedAmount = ZERO_AMOUNT;

	/** The reversing credited amount of this <code>PaymentInstruction</code> */
	private BigDecimal reversingCreditedAmount = ZERO_AMOUNT;



	/**
	 * <p>
	 * This method  sets the account of the <code>PaymentInstruction</code>.
     * </p>
     * 
     * <p> 
     * The Plugin is responsible for setting the <code>account</code> based on the 
     * name-value pairs in <code>extended data</code>.  
     * </p>
     * 
     * <p>
     * The default reserved keyword for the account is as defined in 
     * <code>keywords.xml</code>. 
     * </p>
     * 
	 * @param accountNumber The account associated with this container.
     * @see #getExtendedData().
     * @see #getAccount().
	 */
	public void setAccount(String accountNumber) {
		this.account = accountNumber;
	}

	/**
	 * <p>
	 * This method  gets the account associated with the <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @return The account of the <code>PaymentInstruction</code>.
     * @see #setAccount(String).
	 */
	public String getAccount() {
		return account;
	}

	/**
	 * <p>
	 * This method  sets the target amount to be processed on one or more payment or credit transactions.
	 * </p>
	 *
     * <p>
     * This amount is usually a hint for the actual amount to be processed. Plugin implementations
     * might decide to support amounts exceeding the target amount or not. 
     * </p>
     * 
	 * @param amount The total target amount to be processed in transactions associated with this
     *        <code>PaymentInstruction</code>.
	 */
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	/**
	 * <p>
	 * This method gets the target amount to be processed by associated financial transactions.  
	 * </p>
	 *
	 * @return The target amount.
     * @see #setAmount(BigDecimal).
	 */
	public BigDecimal getAmount() {
		return amount;
	}

	/**
	 * <p>
	 * This method sets the currently approved amount on this <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @param approvedAmount The currently approvedAmount.
	 */
	public void setApprovedAmount(BigDecimal approvedAmount) {
		this.approvedAmount = approvedAmount;
	}

	/**
	 * <p>
	 * This method gets the currently approved amount on this <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @return Decimal value representing the currently approvedAmount.
     * @see #setApprovedAmount(BigDecimal).
	 */
	public BigDecimal getApprovedAmount() {
		return approvedAmount;
	}

	/**
	 * <p>This method sets the current amount being approved. </p>
	 *
	 * @param approvingAmount Decimal value representing the currently approvingAmount.
	 */
	public void setApprovingAmount(BigDecimal approvingAmount) {
		this.approvingAmount = approvingAmount;
	}

	/**
	 * <p>
	 * This method gets the amount being approved.
	 * </p>
	 *
	 * @return The amount being approved.
     * @see #setApprovingAmount(BigDecimal).
	 */
	public BigDecimal getApprovingAmount() {
		return approvingAmount;
	}

	/**
	 * <p>
	 * This method sets the currently credited amount on this <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @param creditAmount Decimal value representing the currently creditedAmount.
	 */
	public void setCreditedAmount(BigDecimal creditAmount) {
		creditedAmount = creditAmount;
	}

	/**
	 * <p>
	 * This method gets the currently credited amount on this <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @return Decimal value representing the currently creditedAmount.
     * @see #setCreditedAmount(BigDecimal).
	 */
	public BigDecimal getCreditedAmount() {
		return creditedAmount;
	}

	/**
	 * <p>
	 * This method sets the amount being credited.
	 * </p>
	 *
	 * @param creditingAmount The amount being credited.
	 */
	public void setCreditingAmount(BigDecimal creditingAmount) {
		this.creditingAmount = creditingAmount;
	}

	/**
	 * <p>
	 * This method gets the amount being credited. </p>
	 * </p>
	 *
	 * @return The amount being credited.
     * @see #setCreditingAmount(BigDecimal).
	 */
	public BigDecimal getCreditingAmount() {
		return creditingAmount;
	}

	/**
	 * <p>
	 * This method sets a list of {@link com.ibm.commerce.payments.plugin.Credit} containers associated with this 
     * <codePaymentInstruction</code>.
	 * </p>
	 *
	 * @param credits The list of associated {@link com.ibm.commerce.payments.plugin.Credit} containers .
	 */
	public void setCredits(ArrayList<Credit> credits) {
		this.credits = credits;
	}

	/**
	 * <p>
	 * This method gets the list of associated {@link com.ibm.commerce.payments.plugin.Credit} containers.
	 * </p>
	 *
	 * @return The list of associated {@link com.ibm.commerce.payments.plugin.Credit} containers; this list may be empty.
     * @see #setCredits(ArrayList).
	 */
	public ArrayList<Credit> getCredits() {
		return credits;
	}

	/**
	 * <p>
	 * This method sets the currency to be used in financial transactions associated with the
     * <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @param currency The currency associated with this <code>PaymentInstruction</code>.
	 */
	public void setCurrency(String currency) {
		this.currency = currency;
	}

	/**
	 * <p>
	 * This method gets the currency of the <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @return The currency associated with the <code>PaymentInstruction</code>
     * @see #setCurrency(String).
	 */
	public String getCurrency() {
		return currency;
	}

	/**
	 * <p>
	 * This method sets the currently deposited amount on this <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @param depositedAmount The currently deposited amount.
	 */
	public void setDepositedAmount(BigDecimal depositedAmount) {
		this.depositedAmount = depositedAmount;
	}

	/**
	 * <p>
	 * This method gets the currently deposited amount on this <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @return Decimal value representing the currently depositedAmount.
     * @see #setDepositedAmount(BigDecimal).
	 */
	public BigDecimal getDepositedAmount() {
		return depositedAmount;
	}

	/**
     * <p>
	 * This method sets the amount being deposited.
     * </p>
	 *
	 * @param depositingAmount The amount being deposited.
	 */
	public void setDepositingAmount(BigDecimal depositingAmount) {
		this.depositingAmount = depositingAmount;
	}

	/**
	 * <p>
	 * This method gets the amount being deposited.
	 * </p>
	 *
	 * @return The amount being deposited.
     * @see #setDepositingAmount(BigDecimal).
	 */
	public BigDecimal getDepositingAmount() {
		return depositingAmount;
	}

	/**
	 * <p>
	 * This method sets the extra protocol data associated with the <code>PaymentInstruction</code>.  
     * </p>
     * 
	 * @param extendedData The map of name-value pairs representing extended payment information
     * @see #getExtendedData().
	 */
	public void setExtendedData(Map extendedData) {
		this.extendedData = extendedData;
	}

	/**
	 * <p>
	 * This method gets the extra protocol data associated with this <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @return The extra protocol data associated with this <code>PaymentInstruction</code>.
     * @see #setExtendedData(ExtendedData).
	 */
	public Map getExtendedData() {
		return extendedData;
	}

	/**
	 * This method gets the unique identifier of the <code>PaymentInstruction</code> container.
	 *
	 * @return The identifier for the <code>PaymentInstruction</code>.
	 */
	public String getId() {
		return id;
	}
	
	/**
	 * This method sets the unique identifier of the <code>PaymentInstruction</code> container.
	 * @param id
	 */
	public void setId(String id) {
		this.id = id;
	}	

	/**
	 * <p>
	 * This method sets the unique order identifier associated with the <code>PaymentInstruction</code>.
	 * </p>
	 *
     * <p>
     * This is an optional field, since there might not be any order associated with the
     * <code>PaymentInstruction</code>. 
     * </p>
     * 
	 * @param orderId The identifier of the associated order.
	 */
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	/**
	 * <p>
	 * This method gets the order associated with the <code>PaymentInstruction</code>. 
	 * </p>
	 *
	 * @return The associated order;  <code>null</code> if there is no order associated with
     *         the <code>PaymentInstruction</code> .
     * @see #setOrderId(String).
	 */
	public String getOrderId() {
		return orderId;
	}


	/**
	 * <p>
	 * This method gets the Return Merchandizing Authorization ID associated with the 
	 * <code>PaymentInstruction</code>. 
	 * </p>
	 *
	 * @return The associated Return Merchandizing Authorization ID;
	 *         <code>null</code> if not present .
	 * @see #setOrderId(String).
	 */
	public String getRmaId() {
		return rmaId;
	}

	/**
	 * <p>
	 * This method sets the Return Merchandizing Authorization ID associated with the 
	 * <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * <p>
	 * This is an optional field, since there might not be any returns associated with the
	 * <code>PaymentInstruction</code>. 
	 * </p>
	 * 
	 * @param rmaId The Return Merchandizing Authorization ID.
	 */
	public void setRmaId(String rmaId) {
		this.rmaId = rmaId;
	}
	/**
	 * <p>
	 * This method sets the payment system that will process this <code>PaymentInstruction</code>.
	 * </p>
     * 
     * <p>
     * The payment system name is typically the name of the plugin implementation defined in the
     * Plugin configuration. However, since multiple payment systems can be associated with the same
     * Plugin. The payment system name can be used by the Plugin to distinguish which back-end 
     * system or protocol the Plugin needs to use. This <samp>n-to-1</samp> mapping is relevant only to plug-ins 
     * that support multiple payment protocols.
     * </p>
	 *
	 * @param paymentSystemName The name of the payment system to process financial transactions.
	 */
	public void setPaymentSystemName(String paymentSystemName) {
		this.paymentSystemName = paymentSystemName;
	}

	/**
	 * <p>
	 * This method gets the payment system name to which the <code>PaymentInstruction</code> is associated with.
	 * </p>
	 *
	 * <p></p>
	 *
	 * @return The name of the payment system used to process the <code>PaymentInstruction</code>.
     * @see #setPaymentSystemName(String).
	 */
	public String getPaymentSystemName() {
		return paymentSystemName;
	}

	/**
	 * <p>
	 * This method sets the list of {@link com.ibm.commerce.payments.plugin.Payment} containers associated with this
     * <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @param payments The list of {@link com.ibm.commerce.payments.plugin.Credit} containers associated with this .
	 */
	public void setPayments(ArrayList<Payment> payments) {
		this.payments = payments;
	}

	/**
	 * <p>
	 * This method gets a list of {@link com.ibm.commerce.payments.plugin.Payment} containers associated with this
     * <code>PaymentInstruction</code>.
	 * </p>
	 *
	 * @return The list containing the associated {@link com.ibm.commerce.payments.plugin.Payment} containers;
     *         this list might be empty.
     * @see #setPayments(ArrayList)
	 */
	public ArrayList<Payment> getPayments() {
		return payments;
	}

	/**
	 * <p>
	 * This method gets the current state of the <code>PaymentInstruction</code>.
	 * </p>
	 *
     * <p>
     * Valid values: 
     * <ul>
     * {@link #STATE_NEW}
     * {@link #STATE_VALID}
     * {@link #STATE_INVALID}
     * {@link #STATE_CLOSED}
     * </ul>
     * 
	 * @return The state of the <code>PaymentInstruction</code>.
	 */
	public short getState() {
		return state;
	}

    /**
     * <p>
     * This method sets the state of the <code>PaymentInstruction</code>.
     * </p>
     *
     * <p>
     * Valid values: 
     * <ul>
     * {@link #STATE_NEW}
     * {@link #STATE_VALID}
     * {@link #STATE_INVALID}
     * {@link #STATE_CLOSED}
     * </ul>
     * 
     * @param state The state of the <code>PaymentInstruction</code> to be set.
     */
    public void setState(short state) {
        this.state = state;
    }

	/**
	 * <p>
	 * This method sets the unique identifier of the merchant's store. 
     * </p>
     * 
	 * @param storeId The unique identifier of the merchant's store.
	 */
	public void setStore(String storeId) {
		this.store = storeId;
	}

	/**
	 * <p>
	 * This method gets the merchant's store to which the <code>PaymentInstruction</code> belongs to.
	 * </p>
	 *
	 * @return The unique identifier of the merchant's store.
	 */
	public String getStore() {
		return store;
	}

	/**
	 * <p>
	 * This method sets the time that the <code>PaymentInstruction</code> was created.
	 * </p>
	 *
	 * <p>
	 * The time should follow GMT standard time.
	 * </p>
	 *
	 * @param timeCreated The creation time in milliseconds.
	 */
	public void setTimeCreated(long timeCreated) {
		this.timeCreated = timeCreated;
	}

	/**
	 * <p>
	 * This method gets the time when the <code>PaymentInstruction</code> was created.
	 * </p>
	 *
	 * @return The time in milliseconds that the <code>PaymentInstruction</code> was created.
	 */
	public long getTimeCreated() {
		return timeCreated;
	}

	/**
	 * <p>
	 * This method sets the time the <code>PaymentInstruction</code> was last changed.
	 * </p>
	 *
	 * @param timeUpdate The update time in milliseconds.
	 */
	public void setTimeUpdate(long timeUpdate) {
		this.timeUpdated = timeUpdate;
	}

	/**
	 * <p>
	 * This method gets the most recent time that the <code>PaymentInstruction</code> was updated.
	 * </p>
	 *
	 * <p></p>
	 *
	 * @return The time in milliseconds that the <code>PaymentInstruction</code> last updated.
	 */
	public long getTimeUpdate() {
		return timeUpdated;
	}
}
