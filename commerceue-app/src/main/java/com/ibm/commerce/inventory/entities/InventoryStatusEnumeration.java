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


public enum InventoryStatusEnumeration {

    AVAILABLE("Available"),
    BACKORDERABLE("Backorderable"),
    UNAVAILABLE("Unavailable");
    private final String value;

    InventoryStatusEnumeration(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static InventoryStatusEnumeration fromValue(String v) {
        for (InventoryStatusEnumeration c: InventoryStatusEnumeration.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
