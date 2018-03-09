package com.ibm.commerce.inventory.entities;

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

import java.util.ArrayList;
import java.util.List;

import com.ibm.commerce.foundation.common.entities.FulfillmentCenterIdentifier;
import com.ibm.commerce.foundation.common.entities.Quantity;
import com.ibm.commerce.foundation.common.entities.UserData;


public class FulfillmentCenterInventoryAvailability {

    protected FulfillmentCenterIdentifier fulfillmentCenterIdentifier;
    protected Quantity availableQuantity;
    protected List<ExpectedInventory> expectedInventory;
    protected UserData userData;

    /**
     * Gets the value of the fulfillmentCenterIdentifier property.
     * 
     * @return
     *     possible object is
     *     {@link FulfillmentCenterIdentifier }
     *     
     */
    public FulfillmentCenterIdentifier getFulfillmentCenterIdentifier() {
        return fulfillmentCenterIdentifier;
    }

    /**
     * Sets the value of the fulfillmentCenterIdentifier property.
     * 
     * @param value
     *     allowed object is
     *     {@link FulfillmentCenterIdentifier }
     *     
     */
    public void setFulfillmentCenterIdentifier(FulfillmentCenterIdentifier value) {
        this.fulfillmentCenterIdentifier = value;
    }

    /**
     * Gets the value of the availableQuantity property.
     * 
     * @return
     *     possible object is
     *     {@link Quantity }
     *     
     */
    public Quantity getAvailableQuantity() {
        return availableQuantity;
    }

    /**
     * Sets the value of the availableQuantity property.
     * 
     * @param value
     *     allowed object is
     *     {@link Quantity }
     *     
     */
    public void setAvailableQuantity(Quantity value) {
        this.availableQuantity = value;
    }

    /**
     * Gets the value of the expectedInventory property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the expectedInventory property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getExpectedInventory().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link ExpectedInventory }
     * 
     * 
     */
    public List<ExpectedInventory> getExpectedInventory() {
        if (expectedInventory == null) {
            expectedInventory = new ArrayList<ExpectedInventory>();
        }
        return this.expectedInventory;
    }

    /**
     * The user data area.
     * 
     * @return
     *     possible object is
     *     {@link UserData }
     *     
     */
    public UserData getUserData() {
        return userData;
    }

    /**
     * Sets the value of the userData property.
     * 
     * @param value
     *     allowed object is
     *     {@link UserData }
     *     
     */
    public void setUserData(UserData value) {
        this.userData = value;
    }

}
