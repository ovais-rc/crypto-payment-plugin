<!--
 ******************************************************************************
 *                                                                            *
 * Licensed Materials - Property of IBM                                       *
 *                                                                            *
 * 5697-D24                                                                   *
 *                                                                            *
 * (c)  Copyright  IBM Corp.  1999.      All Rights Reserved                  *
 *                                                                            *
 * US Government Users Restricted Rights - Use, duplication or                *
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.          *
 *                                                                            *
 ******************************************************************************
-->

<!-- =============================================================== -->

<!ENTITY % boolean "(0 | 1)">

<!ELEMENT ProductNumberByMerchant (#PCDATA)>
<!ELEMENT MerchantID (#PCDATA)>
<!ATTLIST MerchantID
   type CDATA #IMPLIED>

<!ELEMENT Currency (#PCDATA)>
<!ELEMENT Quantity (#PCDATA)>
<!ELEMENT ItemUnitPrice (#PCDATA)>

<!ELEMENT UserData (UserDataField+)>
<!ELEMENT UserDataField (#PCDATA)>
<!ATTLIST UserDataField
	name CDATA #REQUIRED
>
