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

import com.ibm.commerce.foundation.common.entities.CatalogEntryIdentifier;
import com.ibm.commerce.foundation.common.entities.PhysicalStoreIdentifier;
import com.ibm.commerce.foundation.common.entities.StoreIdentifier;

/**
 * The type definition of an external identifier for an InventoryAvailability.
 */

public class InventoryAvailabilityExternalIdentifier {

    protected CatalogEntryIdentifier catalogEntryIdentifier;
    protected StoreIdentifier onlineStoreIdentifier;
    protected PhysicalStoreIdentifier physicalStoreIdentifier;

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
     * Gets the value of the onlineStoreIdentifier property.
     * 
     * @return
     *     possible object is
     *     {@link StoreIdentifier }
     *     
     */
    public StoreIdentifier getOnlineStoreIdentifier() {
        return onlineStoreIdentifier;
    }

    /**
     * Sets the value of the onlineStoreIdentifier property.
     * 
     * @param value
     *     allowed object is
     *     {@link StoreIdentifier }
     *     
     */
    public void setOnlineStoreIdentifier(StoreIdentifier value) {
        this.onlineStoreIdentifier = value;
    }

    /**
     * Gets the value of the physicalStoreIdentifier property.
     * 
     * @return
     *     possible object is
     *     {@link PhysicalStoreIdentifier }
     *     
     */
    public PhysicalStoreIdentifier getPhysicalStoreIdentifier() {
        return physicalStoreIdentifier;
    }

    /**
     * Sets the value of the physicalStoreIdentifier property.
     * 
     * @param value
     *     allowed object is
     *     {@link PhysicalStoreIdentifier }
     *     
     */
    public void setPhysicalStoreIdentifier(PhysicalStoreIdentifier value) {
        this.physicalStoreIdentifier = value;
    }

}
