//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2015.11.16 at 11:14:39 AM CST 
//


package com.ibm.commerce.foundation.common.entities;

import java.util.ArrayList;
import java.util.List;

import com.ibm.commerce.copyright.IBMCopyright;


/**
 * 
 * 				The general price type which contain standard price,
 * 				contract prices and floor price
 * 			
 * 
 * <p>Java class for PriceInfo complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="PriceInfo">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="StandardPrice" type="{http://www.ibm.com/xmlns/prod/commerce/9/foundation}OfferPrice" minOccurs="0"/>
 *         &lt;element name="ContractPrice" type="{http://www.ibm.com/xmlns/prod/commerce/9/foundation}OfferPrice" maxOccurs="unbounded" minOccurs="0"/>
 *         &lt;element name="FloorPrice" type="{http://www.ibm.com/xmlns/prod/commerce/9/foundation}OfferPrice" minOccurs="0"/>
 *         &lt;element ref="{http://www.ibm.com/xmlns/prod/commerce/9/foundation}UserData" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
public class PriceInfo {

	/**
	 * IBM copyright notice field.
	 */
	@SuppressWarnings("unused")
	private static final String COPYRIGHT = IBMCopyright.SHORT_COPYRIGHT;
	
    protected OfferPrice standardPrice;
    protected List<OfferPrice> contractPrice;
    protected OfferPrice floorPrice;
    protected UserData userData;

    /**
     * Gets the value of the standardPrice property.
     * 
     * @return
     *     possible object is
     *     {@link OfferPrice }
     *     
     */
    public OfferPrice getStandardPrice() {
        return standardPrice;
    }

    /**
     * Sets the value of the standardPrice property.
     * 
     * @param value
     *     allowed object is
     *     {@link OfferPrice }
     *     
     */
    public void setStandardPrice(OfferPrice value) {
        this.standardPrice = value;
    }

    /**
     * Gets the value of the contractPrice property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the contractPrice property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getContractPrice().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link OfferPrice }
     * 
     * 
     */
    public List<OfferPrice> getContractPrice() {
        if (contractPrice == null) {
            contractPrice = new ArrayList<OfferPrice>();
        }
        return this.contractPrice;
    }

    /**
     * Gets the value of the floorPrice property.
     * 
     * @return
     *     possible object is
     *     {@link OfferPrice }
     *     
     */
    public OfferPrice getFloorPrice() {
        return floorPrice;
    }

    /**
     * Sets the value of the floorPrice property.
     * 
     * @param value
     *     allowed object is
     *     {@link OfferPrice }
     *     
     */
    public void setFloorPrice(OfferPrice value) {
        this.floorPrice = value;
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