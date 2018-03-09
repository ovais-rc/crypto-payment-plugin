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

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import com.ibm.commerce.foundation.common.entities.Quantity;
import com.ibm.commerce.foundation.common.entities.UserData;

import javax.xml.datatype.XMLGregorianCalendar;

public class InventoryAvailability {

    protected InventoryAvailabilityIdentifier inventoryAvailabilityIdentifier;
    protected String inventoryStatus;
    protected Quantity availableQuantity;
    protected XMLGregorianCalendar availabilityDateTime;
    protected BigInteger availabilityOffset;
    protected XMLGregorianCalendar lastUpdateDateTime;
    protected List<FulfillmentCenterInventoryAvailability> fulfillmentCenterInventoryAvailability;
    protected UserData userData;

    /**
     * Gets the value of the inventoryAvailabilityIdentifier property.
     * 
     * @return
     *     possible object is
     *     {@link InventoryAvailabilityIdentifier }
     *     
     */
    public InventoryAvailabilityIdentifier getInventoryAvailabilityIdentifier() {
        return inventoryAvailabilityIdentifier;
    }

    /**
     * Sets the value of the inventoryAvailabilityIdentifier property.
     * 
     * @param value
     *     allowed object is
     *     {@link InventoryAvailabilityIdentifier }
     *     
     */
    public void setInventoryAvailabilityIdentifier(InventoryAvailabilityIdentifier value) {
        this.inventoryAvailabilityIdentifier = value;
    }

    /**
     * Gets the value of the inventoryStatus property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getInventoryStatus() {
        return inventoryStatus;
    }

    /**
     * Sets the value of the inventoryStatus property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setInventoryStatus(String value) {
        this.inventoryStatus = value;
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
     * Gets the value of the availabilityDateTime property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getAvailabilityDateTime() {
        return availabilityDateTime;
    }

    /**
     * Sets the value of the availabilityDateTime property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setAvailabilityDateTime(XMLGregorianCalendar value) {
        this.availabilityDateTime = value;
    }

    /**
     * Gets the value of the availabilityOffset property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getAvailabilityOffset() {
        return availabilityOffset;
    }

    /**
     * Sets the value of the availabilityOffset property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setAvailabilityOffset(BigInteger value) {
        this.availabilityOffset = value;
    }

    /**
     * Gets the value of the lastUpdateDateTime property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getLastUpdateDateTime() {
        return lastUpdateDateTime;
    }

    /**
     * Sets the value of the lastUpdateDateTime property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setLastUpdateDateTime(XMLGregorianCalendar value) {
        this.lastUpdateDateTime = value;
    }

    /**
     * Gets the value of the fulfillmentCenterInventoryAvailability property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the fulfillmentCenterInventoryAvailability property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getFulfillmentCenterInventoryAvailability().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following (s) are allowed in the list
     * {@link FulfillmentCenterInventoryAvailability }
     * 
     * 
     */
    public List<FulfillmentCenterInventoryAvailability> getFulfillmentCenterInventoryAvailability() {
        if (fulfillmentCenterInventoryAvailability == null) {
            fulfillmentCenterInventoryAvailability = new ArrayList<FulfillmentCenterInventoryAvailability>();
        }
        return this.fulfillmentCenterInventoryAvailability;
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
