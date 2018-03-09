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
<!-- Do not include NCCommon.mod because there are other dtds, like 
Create_NC_Customer_10.dtd, that reference this file and NCCommon.mod. -->

<!ELEMENT Customer (LoginInfo, MerchantID?, MethodOfCommunication?, 
	ChallengeQuestion?, ChallengeAnswer?, ShopperField*, 
	ContactPersonName, RepCompany?, Address, ContactInfo, DayPhoneInfo?, 
	EveningPhoneInfo?, BestTimeToCall?, IncludePackageInsert?, AddressOptField*, 
	Gender?, AgeGroup?, IncomeGroup?, MaritalStatus?, 
	NumberOfChildren?, NumberInHouse?, WorkCompany?, Interests?, PreviousOrder?,
	Demographics*, UserData?)>

<!ELEMENT LoginInfo (LoginID, Password?, VerifyPassword?)>
<!ELEMENT LoginID (#PCDATA)>
<!ELEMENT Password (#PCDATA)>
<!ELEMENT VerifyPassword (#PCDATA)>
<!ELEMENT MethodOfCommunication (#PCDATA)>
<!ELEMENT ChallengeQuestion (#PCDATA)>
<!ELEMENT ChallengeAnswer (#PCDATA)>
<!ELEMENT ShopperField (#PCDATA)>

<!ELEMENT ContactPersonName (Title?, (FullName | (LastName, FirstName?, MiddleName?)), AlternateName?)>
<!ELEMENT Title (#PCDATA)>
<!ELEMENT FullName (#PCDATA)>
<!ELEMENT LastName (#PCDATA)>
<!ELEMENT FirstName (#PCDATA)>
<!ELEMENT MiddleName (#PCDATA)>
<!ELEMENT AlternateName (#PCDATA)>

<!ELEMENT Address (AddressLine+, City, State, Zip, Country)>
<!ELEMENT AddressLine (#PCDATA)>
<!ELEMENT City (#PCDATA)>
<!ELEMENT State (#PCDATA)>
<!ELEMENT Zip (#PCDATA)>
<!ELEMENT Country (#PCDATA)>


<!ELEMENT ContactInfo (Telephone*, Email*, Fax?)>

<!ELEMENT Telephone (#PCDATA)>

<!ELEMENT Email (#PCDATA)>

<!ELEMENT Fax (#PCDATA)>


<!ELEMENT RepCompany (#PCDATA)>

<!ELEMENT DayPhoneInfo (PhoneInfo)>
<!ELEMENT EveningPhoneInfo (PhoneInfo)>
<!ELEMENT PhoneInfo EMPTY>
<!ATTLIST PhoneInfo
	type CDATA #IMPLIED 
	isListed %boolean;  #IMPLIED      
>
<!ELEMENT BestTimeToCall (#PCDATA)>
<!ELEMENT IncludePackageInsert (#PCDATA)>
<!ELEMENT AddressOptField (#PCDATA)>
<!ELEMENT Gender EMPTY>
<!ATTLIST Gender
	value (F | M | N) #REQUIRED
>   
<!ELEMENT AgeGroup (#PCDATA)>
<!ELEMENT IncomeGroup (#PCDATA)>
<!ELEMENT MaritalStatus EMPTY>
<!ATTLIST MaritalStatus
	value (S | M | C | P | D | W | O | N) #REQUIRED
>
<!ELEMENT NumberOfChildren (#PCDATA)>
<!ELEMENT NumberInHouse (#PCDATA)>
<!ELEMENT WorkCompany (#PCDATA)>
<!ELEMENT Interests (#PCDATA)>
<!ELEMENT PreviousOrder (#PCDATA)>
<!ELEMENT Demographics (#PCDATA)>
