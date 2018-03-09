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


public class Credit {

    /** The unique identifier of the credit container. */
    private String id = null;

    /** The current state of the credit container. */
    private short state = 0;

    /** The payment instruction which this credit container is associated with. */
    private PaymentInstruction paymentInstruction = null;

    /** The credit transaction associated with this credit container. */
    private FinancialTransaction creditTransaction = null;

    /** The current credited amount; this amount has being processed. */
    private BigDecimal creditedAmount = BigDecimal.ZERO;

    /** The current amount being credited; this amount is being processed .*/
    private BigDecimal creditingAmount = BigDecimal.ZERO;

    /** The current credited amount being reversed; this amount is being processed .*/
    private BigDecimal reversingAmount = BigDecimal.ZERO;

    /** The target amount to be credited. */
    private BigDecimal targetAmount = BigDecimal.ZERO;


    /**
     * <p>
     * This method sets the <code>credit</code> transaction to the <code>Credit</code> container.
     * </p>
     * 
     * <p>
     * Plug-ins will invoke this method when optionally supporting a credit query.
     * </p>
     *
     * @param creditTransaction The <code>credit</code> transaction to be set.
     *
     * @see #getCreditTransaction
     */
    public void setCreditTransaction(FinancialTransaction creditTransaction) {
        this.creditTransaction = creditTransaction;
    }

    /**
     * <p>
     * This method gets the associated <code>credit</code> transaction if any.
     * </p>
     * 
     * <p>
     * This method allows a plug-in to obtain the credit transaction that has been executed under
     * the <code>Credit</code>.
     * </p>
     *
     * @return The credit transaction associated with this credit container if any;
     *         <code>null</code> if no <code>credit</code> transaction is associated.
     *
     * @see #setCreditTransaction(FinancialTransactionImpl)
     */
    public FinancialTransaction getCreditTransaction() {
        return creditTransaction;
    }

    /**
     * <p>
     * This method sets the amount credited in the container.
     * </p>
     * 
     * <p>
     * Plug-ins will invoke this method when supporting queries.
     * </p>
     *
     * @param creditedAmount The currently credited amount.
     *
     * @see #getCreditedAmount()
     */
    public void setCreditedAmount(BigDecimal creditedAmount) {
        this.creditedAmount = creditedAmount;
    }

    /**
     * <p>
     * This method gets the currently credited amount.
     * </p>
     * 
     * <p>
     * Plug-ins can use this method to verify how much has been actually credited after a
     * successful <code>credit</code> transaction. Usually the actual credited amount is the same
     * of the requested amount. However, some payment back-end systems might process a different
     * amount.
     * </p>
     *
     * @return The currently credited amount.
     *
     * @see #setCreditedAmount(BigDecimal)
     */
    public BigDecimal getCreditedAmount() {
        return creditedAmount;
    }

    /**
     * <p>
     * This method sets the amount being credited, that is, in pending to be credited.
     * </p>
     * 
     * <p>
     * Plug-ins will invoke this method when supporting queries.
     * </p>
     *
     * @param creditingAmount The credit <samp>amount</samp> in pending.
     *
     * @see #getCreditingAmount()
     */
    public void setCreditingAmount(BigDecimal creditingAmount) {
    	this.creditingAmount = creditingAmount;
    }

    /**
     * <p>
     * This method gets the amount being currently credited.
     * </p>
     * 
     * <p>
     * Plug-ins can use this method to verify how much <samp>credit is</samp> in pending. <code>credit</code>
     * transactions might go in pending for a variety of reasons including slow network
     * processing, timeouts and when offline processing is required. Offline processing typically
     * requires human interaction to process transactions over the phone or through a swipe
     * machine.
     * </p>
     *
     * @return The current amount being credited (pending).
     *
     * @see #setCreditingAmount(BigDecimal)
     */
    public BigDecimal getCreditingAmount() {
        return creditingAmount;
    }

    /**
     * <p>
     * This method gets the unique identifier of the <code>Credit</code> container.
     * </p>
     *
     * @return The unique identifier of the <code>Credit</code> container.
     */
    public String getId() {
        return id;
    }
    
    /**
     * <p>
     * This method sets the unique identifier of the <code>Credit</code> container.
     * </p>
     */
    public void setId(String Id) {
        this.id = Id;
    }    

    /**
     * <p>
     * This method sets the payment instruction container which this <code>credit</code> is associated with.
     * </p>
     *
     * @param instruction The <code>PaymentInstruction</code> to be associated with  this
     *        <code>credit</code> container.
     *
     * @see #getPaymentInstruction().
     */
    public void setPaymentInstruction(PaymentInstruction instruction) {
        paymentInstruction = instruction;
    }

    /**
     * <p>
     * This method gets the associated  {@link com.ibm.commerce.payments.plugin.PaymentInstruction
     * PaymentInstruction}.
     * </p>
     * 
     * <p>
     * Plug-ins need to use the  {@link com.ibm.commerce.payments.plugin.PaymentInstruction
     * PaymentInstruction}  to determine if a <code>credit</code> transaction is dependent or
     * independent.
     * </p>
     *
     * @return The payment instruction container associated with the <code>Credit</code> container.
     */
    public PaymentInstruction getPaymentInstruction() {
        return paymentInstruction;
    }

    /**
     * <p>
     * This method sets the reverse credited amount.
     * </p>
     * 
     * <p>
     * Plug-ins will invoke this method when supporting credit queries.
     * </p>
     *
     * @param reversingAmount The amount being reversed.
     *
     * @see #getReversingAmount().
     */
    public void setReversingAmount(BigDecimal reversingAmount) {
        this.reversingAmount = reversingAmount;
    }

    /**
     * <p>
     * This method gets the reversingAmount.
     * </p>
     *
     * @return Amount representing the crediting amount.
     *
     * @see #setReversingAmount(BigDecimal).
     */
    public BigDecimal getReversingAmount() {
        return reversingAmount;
    }

    /**
     * <p>
     * This method sets the state of the <code>Credit</code> container.
     * </p>
     * 
     * <p>
     * Plug-ins will invoke this method when supporting queries.
     * </p>
     * 
     * <p>
     * Valid values:
     * 
     * <ul>
     * <li>
     * {@link #STATE_NEW}
     * </li>
     * <li>
     * {@link #STATE_CREDITING}
     * </li>
     * <li>
     * {@link #STATE_CREDITED}
     * </li>
     * <li>
     * {@link #STATE_FAILED}
     * </li>
     * <li>
     * {@link #STATE_CANCELED}
     * </li>
     * </ul>
     * </p>
     *
     * @param state The new state of the <code>Credit</code> container.
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
     * This method gets the current state of the <code>Credit</code> container.
     * </p>
     * 
     * <p>
     * Valid values:
     * 
     * <ul>
     * <li>
     * {@link #STATE_CANCELED}
     * </li>
     * <li>
     * {@link #STATE_NEW}
     * </li>
     * <li>
     * {@link #STATE_CREDITED}
     * </li>
     * <li>
     * {@link #STATE_CREDITING}
     * </li>
     * <li>
     * {@link #STATE_FAILED}
     * </li>
     * </ul>
     * </p>
     *
     * @return The current state of the <code>Cedit</code> container.
     *
     * @see #setState(short).
     */
    public short getState() {
        return state;
    }


    /**
     * <p>
     * This method gets the amount that is the target as the total to be credited in the life-time of the
     * container.
     * </p>
     *
     * @return The target credit amount.
     */
    public BigDecimal getTargetAmount() {
        return targetAmount;
    }
    
    /**
     * <p>
     * This method sets the amount that is the target as the total to be credited in the life-time of the
     * container.
     * </p>
     *
     * @return The target credit amount.
     */
    public void setTargetAmount(BigDecimal targetAmount) {
        this.targetAmount = targetAmount;
    }    
	

}
