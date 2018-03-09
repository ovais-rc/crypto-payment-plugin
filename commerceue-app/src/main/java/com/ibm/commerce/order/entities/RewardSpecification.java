//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2015.11.16 at 11:14:39 AM CST 
//


package com.ibm.commerce.order.entities;

import com.ibm.commerce.copyright.IBMCopyright;
import com.ibm.commerce.foundation.common.entities.UserData;



/**
 * Type definition of a promotion reward option
 * 				specification.
 * 
 * <p>Java class for RewardSpecification complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="RewardSpecification">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element ref="{http://www.ibm.com/xmlns/prod/commerce/9/order}GiftSetSpecification" minOccurs="0"/>
 *         &lt;element ref="{http://www.ibm.com/xmlns/prod/commerce/9/foundation}UserData" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
public class RewardSpecification {

	/**
	 * IBM copyright notice field.
	 */
	@SuppressWarnings("unused")
	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;
	
    protected GiftSetSpecification giftSetSpecification;
    protected UserData userData;

    /**
     * This element defines the specification of
     * 						gift
     * 						items.
     * 
     * @return
     *     possible object is
     *     {@link GiftSetSpecification }
     *     
     */
    public GiftSetSpecification getGiftSetSpecification() {
        return giftSetSpecification;
    }

    /**
     * Sets the value of the giftSetSpecification property.
     * 
     * @param value
     *     allowed object is
     *     {@link GiftSetSpecification }
     *     
     */
    public void setGiftSetSpecification(GiftSetSpecification value) {
        this.giftSetSpecification = value;
    }

    /**
     * User data area.
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