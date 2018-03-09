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

import javax.xml.datatype.XMLGregorianCalendar;
import com.ibm.commerce.foundation.common.entities.Quantity;
import com.ibm.commerce.foundation.common.entities.UserData;




public class ExpectedInventory {

    protected Quantity availableQuantity;
    protected XMLGregorianCalendar availabilityDateTime;
    protected UserData userData;

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
