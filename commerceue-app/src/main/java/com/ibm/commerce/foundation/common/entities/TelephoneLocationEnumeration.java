//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2015.11.16 at 11:14:39 AM CST 
//


package com.ibm.commerce.foundation.common.entities;

import com.ibm.commerce.copyright.IBMCopyright;



/**
 * <p>Java class for TelephoneLocationEnumeration.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="TelephoneLocationEnumeration">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}normalizedString">
 *     &lt;enumeration value="Home1"/>
 *     &lt;enumeration value="Home2"/>
 *     &lt;enumeration value="Work1"/>
 *     &lt;enumeration value="Work2"/>
 *     &lt;enumeration value="Mobile1"/>
 *     &lt;enumeration value="Mobile2"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
public enum TelephoneLocationEnumeration {

    HOME_1("Home1"),
    HOME_2("Home2"),
    WORK_1("Work1"),
    WORK_2("Work2"),
    MOBILE_1("Mobile1"),
    MOBILE_2("Mobile2");
    private final String value;

    /**
	 * IBM copyright notice field.
	 */
	@SuppressWarnings("unused")
	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;
	
    TelephoneLocationEnumeration(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static TelephoneLocationEnumeration fromValue(String v) {
        for (TelephoneLocationEnumeration c: TelephoneLocationEnumeration.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
