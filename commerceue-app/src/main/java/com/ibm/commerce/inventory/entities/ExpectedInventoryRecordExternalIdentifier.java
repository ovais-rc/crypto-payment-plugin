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
import com.ibm.commerce.foundation.common.entities.StoreIdentifier;


public class ExpectedInventoryRecordExternalIdentifier {

    protected StoreIdentifier storeIdentifier;
    protected String vendorName;
    protected XMLGregorianCalendar createDate;

    /**
     * Gets the value of the storeIdentifier property.
     * 
     * @return
     *     possible object is
     *     {@link StoreIdentifier }
     *     
     */
    public StoreIdentifier getStoreIdentifier() {
        return storeIdentifier;
    }

    /**
     * Sets the value of the storeIdentifier property.
     * 
     * @param value
     *     allowed object is
     *     {@link StoreIdentifier }
     *     
     */
    public void setStoreIdentifier(StoreIdentifier value) {
        this.storeIdentifier = value;
    }

    /**
     * Gets the value of the vendorName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getVendorName() {
        return vendorName;
    }

    /**
     * Sets the value of the vendorName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setVendorName(String value) {
        this.vendorName = value;
    }

    /**
     * Gets the value of the createDate property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getCreateDate() {
        return createDate;
    }

    /**
     * Sets the value of the createDate property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setCreateDate(XMLGregorianCalendar value) {
        this.createDate = value;
    }

}
