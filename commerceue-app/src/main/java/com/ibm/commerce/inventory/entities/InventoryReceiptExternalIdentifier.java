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

import com.ibm.commerce.foundation.common.entities.CatalogEntryIdentifier;
import com.ibm.commerce.foundation.common.entities.FulfillmentCenterIdentifier;
import com.ibm.commerce.foundation.common.entities.StoreIdentifier;

public class InventoryReceiptExternalIdentifier {

    protected CatalogEntryIdentifier catalogEntryIdentifier;
    protected StoreIdentifier storeIdentifier;
    protected FulfillmentCenterIdentifier fulfillmentCenterIdentifier;
    protected XMLGregorianCalendar creationTime;

    /**
     * Gets the value of the catalogEntryIdentifier property.
     * 
     * @return
     *     possible object is
     *     {@link CatalogEntryIdentifier }
     *     
     */
    public CatalogEntryIdentifier getCatalogEntryIdentifier() {
        return catalogEntryIdentifier;
    }

    /**
     * Sets the value of the catalogEntryIdentifier property.
     * 
     * @param value
     *     allowed object is
     *     {@link CatalogEntryIdentifier }
     *     
     */
    public void setCatalogEntryIdentifier(CatalogEntryIdentifier value) {
        this.catalogEntryIdentifier = value;
    }

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
     * Gets the value of the creationTime property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getCreationTime() {
        return creationTime;
    }

    /**
     * Sets the value of the creationTime property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setCreationTime(XMLGregorianCalendar value) {
        this.creationTime = value;
    }

}
