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
import java.util.Date;


public class Payment {
   
    /** Amount representing $0.00000 */
    public static final BigDecimal ZERO_AMOUNT = new BigDecimal("0.00000");    

    /** The unique identifier of the payment container. */
    private String id = null;

    /** The current state of the payment container. */
    private short state = 0;

    /** The target amount to be approved and deposited under this payment. */
    private BigDecimal targetAmount = ZERO_AMOUNT;

    /** The currently approved .*/
    private BigDecimal approvedAmount = ZERO_AMOUNT;

    /** The amount being approved. */
    private BigDecimal approvingAmount = ZERO_AMOUNT;

    /** The currently depositing. */
    private BigDecimal depositingAmount = ZERO_AMOUNT;

    /** The currently deposited. */
    private BigDecimal depositedAmount = ZERO_AMOUNT;

    /** The currently reversing approved. */
    private BigDecimal reversingApprovedAmount = ZERO_AMOUNT;

    /** The currently reversing deposited. */
    private BigDecimal reversingDepositedAmount = ZERO_AMOUNT;

    /** The AVS code associated with the payment object after an approval. */
    private short avsCode = -1;

    /** Indicates if the payment requires external intervention. */
    private boolean attentionRequired = false;

    /** The associated payment instruction. */
    private PaymentInstruction paymentInstruction = null;

    /** The time the approval has expired. */
    private Date expirationDate = null;

    /** indicates if the approval has expired. */
    private boolean isExpired = false;

    /** The list of deposit payment transactions associated with this payment container. */
    private ArrayList depositTransactions = null;

    /** The list of reverse approval transactions associated with this payment container. */
    private ArrayList reverseApprovalTransactions = null;

    /** The list of reverse deposit transactions associated with this payment container. */
    private ArrayList reverseDepositTransactions = null;

    /** The approval transaction associated with this payment container. */
    private FinancialTransaction approveTransaction = null;



    /**
     * <p>
     * This method sets the <code>approve</code> transaction container.
     * </p>
     *
     * @param approveTransaction The approve transaction container.
     *
     * @see #getApproveTransaction().
     */
    public void setApproveTransaction(FinancialTransaction approveTransaction) {
    	this.approveTransaction = approveTransaction;
    }

    /**
     * <p>
     * This method gets the <code>approve</code> transaction container.
     * </p>
     *
     * @return Approve transaction container.
     *
     * @see #setApproveTransaction(FinancialTransactionImpl)
     */
    public FinancialTransaction getApproveTransaction() {
        return approveTransaction;
    }

    /**
     * <p>
     * This method sets the approved amount after an <code>approve</code> transaction.
     * </p>
     * 
     * <p>
     * The plug-ins will invoke this method only if the actually approved amount is different from
     * the requested <code>approve</code> transaction amount. This is only possible for back-end
     * systems that support amounts to be processed that are less that the requested amount.
     * </p>
     * 
     * <p>
     * Plug-ins will also invoke this method when supporting queries.
     * </p>
     * 
     * <p>
     * During <code>approve reversal</code> transactions, the approved amount should decrease.
     * </p>
     * 
     * <p>
     * <b> Gift Certificate example </b>
     * </p>
     * 
     * <p>
     * Suppose a Plugin supports Gift Certificates(GC). If an <code>approve</code> asks  for $15.00
     * in a given GC and the GC has actually only $14.45 remaining, the Plugin could approve
     * $14.45.
     * </p>
     * 
     * <p>
     * This is the rationale: Gift Certificates have very limited amounts and are typically used
     * with other payment methods like Credit Cards. The Gift Certificate is expected to  be fully
     * consumed before the Credit Card is charged. If the requested amount cannot be fully
     * processed, the remaining is expected to be processed later on against the Credit Card.
     * </p>
     * 
     * <p>
     * Accepting the behavior above really depends on the Plugin. Even though this scenario is
     * possible, the Plugin might choose to reject the <code>approve</code> transaction indicating
     * that the account limit has been reached.
     * </p>
     *
     * @param approvedAmount The approved amount to be set.
     *
     * @see #getApprovedAmount().
     */
    public void setApprovedAmount(BigDecimal approvedAmount) {
        this.approvedAmount = approvedAmount;
    }

    /**
     * <p>
     * This method gets the currently approved amount.
     * </p>
     * 
     * <p>
     * The approved amount will be different from zero only after the initial  <code>approve</code>
     * transaction has successfully finished and before any <code>approve reversal</code>
     * transactions.
     * </p>
     * 
     * <p>
     * The approved amount can be different from the target amount associated with the
     * <code>Payment</code> container. This occurs if the back-end system supports processing less
     * that the requested amount during an <code>approval</code> transaction. Also, if reversals
     * have occurred, the approved amount will be different from the target amount.
     * </p>
     * 
     * <p>
     * For an example of differences between approved amount and target amount, please refer to
     * {@link #setApprovedAmount(BigDecimal)}.
     * </p>
     *
     * @return The amount that has been approved.
     *
     * @see #setApprovedAmount(BigDecimal).
     */
    public BigDecimal getApprovedAmount() {
        return approvedAmount;
    }

    /**
     * This method sets the amount being approved.
     * 
     * <p>
     * Plug-ins will invoke this method when supporting queries.
     * </p>
     *
     * @param approvingAmount The amount being approved.
     *
     * @see #getApprovingAmount().
     */
    public void setApprovingAmount(BigDecimal approvingAmount) {
        this.approvingAmount = approvingAmount;
    }

    /**
     * <p>
     * This method gets the amount being approved.
     * </p>
     * 
     * <p>
     * The approving amount will be different from zero when the initial  <code>approve</code>
     * transaction has been issued and not completed. Or if its state stays in pending state {@link
     * FinancialTransaction#STATE_PENDING pending} after its execution.
     * </p>
     *
     * @return The amount being approved.
     *
     * @see #setApprovingAmount(BigDecimal).
     */
    public BigDecimal getApprovingAmount() {
        return approvingAmount;
    }

    /**
     * <p>
     * This method sets a flag to indicate that the <code>Payment</code> requires attention even though all
     * transactions might have finalized successfully.
     * </p>
     * 
     * <p>
     * External intervention might be required. Typical examples:
     * </p>
     * 
     * <ul>
     * <li>
     * <samp>AVS</samp> codes different from the code {@link #AVS_COMPLETE_MATCH} during  <code>approve</code> and
     * <code>approveAndDeposit</code> transactions.
     * </li>
     * </ul>
     * 
     * <p>
     * The Plugin might have other reasons to raise this flag that are specific to the payment
     * protocol being implemented.
     * </p>
     *
     * @param attentionRequired If the <code>Payment</code> requires external intervention.
     *
     * @see #isAttentionRequired().
     */
    public void setAttentionRequired(boolean attentionRequired) {
        this.attentionRequired = attentionRequired;
    }

    /**
     * <p>
     * This method checks if the <code>Payment</code> requires external intervention.
     * </p>
     *
     * @return If the <code>Payment</code> requires external intervention.
     *
     * @see #setAttentionRequired(boolean).
     */
    public boolean isAttentionRequired() {
        return attentionRequired;
    }

    /**
     * <p>
     * This method sets the <samp>AVS</samp> code for the <code>approve</code> transaction.
     * </p>
     * 
     * <p>
     * <samp>AVS</samp> stands for Address Verification System/Service. An <samp>AVS</samp> code is typically returned by a
     * payment back-end system during approvals (authorization) transactions. When there is a
     * mismatch between the billing address specified in the transaction and the actual billing
     * address registered in the account being charged.
     * </p>
     * 
     * <p>
     * Plug-ins are responsible for setting the <samp>AVS</samp> code for <code>approve</code> transactions
     * whenever necessary. If plug-ins do not set the <samp>AVS</samp> code, the Payment Plugin Controller will
     * use {@link #AVS_COMPLETE_MATCH}.
     * </p>
     * 
     * <p>
     * These are the possible <samp>AVS</samp> codes:
     * 
     * <ul>
     * <li>
     * {@link #AVS_COMPLETE_MATCH}
     * </li>
     * <li>
     * {@link #AVS_NO_MATCH}
     * </li>
     * <li>
     * {@link #AVS_OTHER_RESPONSE}
     * </li>
     * <li>
     * {@link #AVS_POSTALCODE_MATCH}
     * </li>
     * <li>
     * {@link #AVS_STREET_ADDRESS_MATCH}
     * </li>
     * </ul>
     * </p>
     *
     * @param avsCode The <samp>AVS</samp> code to be set.
     *
     * @see #getAvsCode().
     */
    public void setAvsCode(short avsCode) {
        this.avsCode = avsCode;
    }

    /**
     * <p>
     * This method gets the <samp>AVS</samp> code associated with the <code>approve</code> transaction.
     * </p>
     * 
     * <p>
     * These are the possible <samp>AVS</samp> codes:
     * 
     * <ul>
     * <li>
     * {@link #AVS_COMPLETE_MATCH}
     * </li>
     * <li>
     * {@link #AVS_NO_MATCH}
     * </li>
     * <li>
     * {@link #AVS_OTHER_RESPONSE}
     * </li>
     * <li>
     * {@link #AVS_POSTALCODE_MATCH}
     * </li>
     * <li>
     * {@link #AVS_STREET_ADDRESS_MATCH}
     * </li>
     * </ul>
     * </p>
     *
     * @return The <samp>AVS</samp> code.
     *
     * @see #setAvsCode(short).
     */
    public short getAvsCode() {
        return avsCode;
    }

    /**
     * <p>
     * This method sets a list of <code>deposit</code> transactions.
     * </p>
     * 
     * <p>
     * Each element in the list is a {@link FinancialTransaction FinancialTransaction}.
     * </p>
     *
     * @param depositTransactions A list of {@link FinancialTransaction FinancialTransaction}
     *        containing <code>deposit</code> transactions to be set.
     *
     * @see #getDepositTransactions().
     */
    public void setDepositTransactions(ArrayList depositTransactions) {
        this.depositTransactions = depositTransactions;
    }

    /**
     * <p>
     * This method gets a list of <code>deposit</code> transactions.
     * </p>
     * 
     * <p>
     * Each element in the list is a {@link FinancialTransaction FinancialTransaction}.
     * </p>
     *
     * @return A list of {@link FinancialTransaction FinancialTransaction} with deposits; this list
     *         is potentially empty.
     *
     * @see #getDepositTransactions().
     */
    public ArrayList getDepositTransactions() {
        return depositTransactions;
    }

    /**
     * <p>
     * This method sets the currently deposited amount.
     * </p>
     * 
     * <p>
     * The deposited amount is set by the Payment Plugin Controller on a successful
     * <code>deposit</code> transaction.  If multiple deposits have been made against a Payment
     * this will represent the sum of the deposited amounts of all the individual transactions.
     * </p>
     * 
     * <p>
     * Plug-ins will invoke this method when supporting queries.
     * </p>
     *
     * @param depositedAmount The targetAmount deposited by the back-end system.
     *
     * @see #getDepositedAmount().
     */
    public void setDepositedAmount(BigDecimal depositedAmount) {
        this.depositedAmount = depositedAmount;
    }

    /**
     * <p>
     * This method gets the amount currently deposited.
     * </p>
     * 
     * <p>
     * If multiple deposits have been made against a {@link Payment Payment}, this amount will
     * represent the total amount deposited for  all <code>deposit</code> transactions, that is,
     * the sum of all the individual  <code>deposit</code> transaction amounts.
     * </p>
     *
     * @return The total deposited amount in for this <code>Payment</code>.
     *
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
     * <p>
     * The Payment Plugin Controller will set the depositing amount on <code>deposit</code>
     * transactions that go to the state {@link FinancialTransaction#STATE_PENDING}.
     * </p>
     * 
     * <p>
     * Plug-ins will invoke this method when supporting queries.
     * </p>
     *
     * @param depositingAmount The amount being deposited.
     *
     * @see #getDepositingAmount().
     */
    public void setDepositingAmount(BigDecimal depositingAmount) {
        this.depositingAmount = depositingAmount;
    }

    /**
     * <p>
     * This method gets the amount being deposited.
     * </p>
     *
     * @return The current amount being deposited.
     *
     * @see #setDepositingAmount(BigDecimal).
     */
    public BigDecimal getDepositingAmount() {
        return depositingAmount;
    }

    /**
     * <p>
     * This method sets the expiration date of the <code>Payment</code> approval (authorization).
     * </p>
     * 
     * <p>
     * The expiration date is expressed on GMT standard time.
     * </p>
     * 
     * <p>
     * Plug-ins will invoke this method when supporting queries.
     * </p>
     *
     * @param expirationDate The expiration date to be set.
     *
     * @see #isExpired().
     * @see #setExpired(boolean).
     * @see #getExpirationDate().
     * @see com.ibm.commerce.payments.plugin.PluginConfiguration
     */
    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    /**
     * <p>
     * This method gets the date the payment approval (authorization) is supposed to expire.
     * </p>
     * 
     * <p>
     * This value is calculated by the Payment Plugin Controller based on the  actual approval
     * timestamp and the Plugin configuration of the expiration  .
     * </p>
     *
     * @return The date the payment approval (authorization) expires.
     *
     * @see #isExpired()
     * @see #setExpired(boolean).
     * @see #setExpirationDate(Date).
     */
    public Date getExpirationDate() {
        return expirationDate;
    }

    /**
     * <p>
     * This method indicates if the <code>Payment</code> approval (authorization) has expired.
     * </p>
     * 
     * <p>
     * This flag indicates if the payment approval (authorization) has expired while the expiration
     * date is an expected expiration date. Note that if the Plugin configuration is not done
     * correctly ({@link com.ibm.commerce.payments.plugin.PluginConfiguration}), the expiration date and the
     * actual time of the expiration might vary considerably.
     * </p>
     *
     * @param expired Whether the<code>Payment</code> approval has expired or not.
     *
     * @see #isExpired().
     * @see #getExpirationDate().
     * @see #setExpirationDate(Date).
     * @see com.ibm.commerce.payments.plugin.PluginConfiguration
     */
    public void setExpired(boolean expired) {
        this.isExpired = expired;
    }

    /**
     * <p>
     * This method checks if the payment approval (authorization) has expired.
     * </p>
     *
     * @return Whether the payment has expired or not.
     *
     * @see #setExpired(boolean).
     * @see #getExpirationDate().
     * @see #setExpirationDate(Date).
     */
    public boolean isExpired() {
        return isExpired;
    }

    /**
     * <p>
     * This method gets the unique identifier of the <code>Payment</code> container.
     * </p>
     *
     * @return The unique identifier of the <code>Payment</code> container.
     */
    public String getId() {
        return id;
    }
    
    /**
     * This method sets the unique identifier of the <code>Payment</code> container.
     */
    public void setId(String id){
    	this.id = id;
    }    

    /**
     * <p>
     * This method sets the payment instruction container which this <code>Payment</code> is associated with.
     * </p>
     *
     * @param instruction The <code>PaymentInstruction</code> to be associated with  this
     *        <code>Payment</code> container.
     *
     * @see #getPaymentInstruction().
     */
    public void setPaymentInstruction(PaymentInstruction instruction) {
        paymentInstruction = instruction;
    }

    /**
     * <p>
     * This method gets the <code>PaymentInstruction</code> container this <code>Payment</code> is associated
     * with.
     * </p>
     *
     * @return The <code>PaymentInstruction</code> this payment is associated with.
     *
     * @see #setPaymentInstruction(PaymentInstructionImpl)
     */
    public PaymentInstruction getPaymentInstruction() {
        return paymentInstruction;
    }

    /**
     * <p>
     * This method sets the list <code>approve reversal</code> transactions associated with this
     * <code>Payment</code> container.
     * </p>
     * 
     * <p>
     * Each element of the list is a {@link FinancialTransaction FinancialTransaction}.
     * </p>
     *
     * @param reverseApprovalTransactions The list of {@link FinancialTransaction
     *        FinancialTransaction} containing  <code>approve reversal</code> transactions.
     *
     * @see #getReverseApprovalTransactions().
     */
    public void setReverseApprovalTransactions(ArrayList reverseApprovalTransactions) {
    	this.reverseApprovalTransactions = reverseApprovalTransactions;
    }

    /**
     * <p>
     * This method gets a list of <code>reverse approval</code> transactions.
     * </p>
     * 
     * <p>
     * Each of the element in the list is a {@link FinancialTransaction FinancialTransaction}.
     * </p>
     *
     * @return A list of {@link FinancialTransaction FinancialTransaction} with  reverse approve
     *         transaction.
     *
     * @see #setReverseApprovalTransactions(ArrayList).
     */
    public ArrayList getReverseApprovalTransactions() {
        return reverseApprovalTransactions;
    }

    /**
     * <p>
     * This method sets a list of <code>reverse deposit</code> transactions.
     * </p>
     * 
     * <p>
     * Each element in the list is a {@link FinancialTransaction FinancialTransaction}.
     * </p>
     *
     * @param reverseDepositTransactions A list containing  {@link FinancialTransaction
     *        FinancialTransaction} objects  that represent a <code>reverse deposit</code>
     *        transaction.
     *
     * @see #getReverseDepositTransactions().
     */
    public void setReverseDepositTransactions(ArrayList reverseDepositTransactions) {
        this.reverseDepositTransactions = reverseDepositTransactions;
    }

    /**
     * <p>
     * This method gets an array of reverse deposit Transactions.
     * </p>
     * 
     * <p>
     * Each element in the list is a {@link FinancialTransaction FinancialTransaction}.
     * </p>
     *
     * @return A list containing {@link FinancialTransaction FinancialTransaction} objects  that
     *         represent a <code>reverse deposit</code> transaction.
     *
     * @see #setReverseDepositTransactions(ArrayList).
     */
    public ArrayList getReverseDepositTransactions() {
        return reverseDepositTransactions;
    }

    /**
     * <p>
     * This method sets the approved amount being reversed.
     * </p>
     * 
     * <p>
     * Plug-ins will invoke this method when supporting queries.
     * </p>
     *
     * @param reversingApprovedAmount The approved amount being reversed.
     *
     * @see #getReversingApprovedAmount().
     */
    public void setReversingApprovedAmount(BigDecimal reversingApprovedAmount) {
    	this.reversingApprovedAmount = reversingApprovedAmount;
    }

    /**
     * <p>
     * This method gets the reversing deposit amount.
     * </p>
     *
     * @return The approved amount being reversed.
     *
     * @see #setReversingApprovedAmount(BigDecimal).
     */
    public BigDecimal getReversingApprovedAmount() {
        return reversingApprovedAmount;
    }

    /**
     * <p>
     * This method sets the deposited amount being reversed.
     * </p>
     * 
     * <p>
     * Plug-ins will invoke this method when supporting queries.
     * </p>
     *
     * @param reversingDepositedAmount The deposited amount being reversed.
     *
     * @see #getReversingDepositedAmount().
     */
    public void setReversingDepositedAmount(BigDecimal reversingDepositedAmount) {
    	this.reversingDepositedAmount = reversingDepositedAmount;
    }

    /**
     * <p>
     * This method gets the deposited amount being reversed.
     * </p>
     *
     * @return The deposited amount being reversed.
     *
     * @see #setReversingDepositedAmount(BigDecimal).
     */
    public BigDecimal getReversingDepositedAmount() {
        return reversingDepositedAmount;
    }

    /**
     * <p>
     * This method sets the state of the <code>Payment</code> container.
     * </p>
     * 
     * <p>
     * These are the validate state values:
     * </p>
     * 
     * <ul>
     * <li>
     * {@link #STATE_NEW}
     * </li>
     * <li>
     * {@link #STATE_APPROVING}
     * </li>
     * <li>
     * {@link #STATE_APPROVED}
     * </li>
     * <li>
     * {@link #STATE_EXPIRED}
     * </li>
     * <li>
     * {@link #STATE_FAILED}
     * </li>
     * <li>
     * {@link #STATE_CANCELED}
     * </li>
     * </ul>
     * 
     *
     * @param state The new state of the <code>Payment</code> container to be set.
     *
     * @exception InvalidDataException If an invalid state is specified.
     *
     * @see #getState().
     */
    public void setState(short state){
        this.state = state;
    }

    /**
     * <p>
     * This method gets the state o the <code>Payment</code> container.
     * </p>
     * 
     * <p>
     * These are the validate state values:
     * </p>
     * 
     * <ul>
     * <li>
     * {@link #STATE_NEW}
     * </li>
     * <li>
     * {@link #STATE_APPROVING}
     * </li>
     * <li>
     * {@link #STATE_APPROVED}
     * </li>
     * <li>
     * {@link #STATE_EXPIRED}
     * </li>
     * <li>
     * {@link #STATE_FAILED}
     * </li>
     * <li>
     * {@link #STATE_CANCELED}
     * </li>
     * </ul>
     * 
     *
     * @return The current state of the <code>Payment</code> container.
     *
     * @see #setState(short).
     */
    public short getState() {
        return state;
    }

    /**
     * <p>
     * This method sets the target amount to be processed for the <code>approve</code> transaction.
     * </p>
     *
     * @param targetAmount The amount that has been requested to be approved by the back-end system.
     *
     * @see Payment#getTargetAmount().
     */
    public void setTargetAmount(BigDecimal targetAmount) {
        this.targetAmount = targetAmount;
    }

    /**
     * <p>
     * This method gets the requested target amount.
     * </p>
     *
     * @return The requested target amount for this <code>Payment</code> container.
     *
     * @see #setTargetAmount(BigDecimal).
     */
    public BigDecimal getTargetAmount() {
        return targetAmount;
    }
}
