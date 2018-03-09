<!-- TODO: This is a sample query template file. -->
<!-- Please modify to match your implementation. -->

BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun GiftList  -->
		<!-- Defining all columns of the table -->
		COLS:GRGFTREG  = GRGFTREG:* 	
		<!-- Defining the unique ID column of the table -->
		COLS:GIFTREGISTRY_ID  = GRGFTREG:GIFTREGISTRY_ID, OPTCOUNTER
		<!-- Defining all columns of the table -->
		COLS:GRRGSTRNT  = GRRGSTRNT:*
		<!-- Defining all columns of the table -->
		COLS:GRADDR  = GRADDR:* 	
		<!-- Defining all columns of the table -->
		COLS:GRGFTITM = GRGFTITM:*
		COLS:GRPERATTR = GRPERATTR:*
<!-- Defining all the columns in the GRUSERAUTH table -->
		COLS:GRUSERAUTH = GRUSERAUTH:*	
		COLS:GUESTACCESSOPTION = GRGFTREG:GUESTACCESSOPTION, OPTCOUNTER 	
		COLS:GRPURREC = GRPURREC:*
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- XPath: /GiftList/GiftListIdentifier[(UniqueID=)]-->
<!-- AccessProfile:	IBM_Update -->
<!-- Get the information for GiftList with specified unique ID for an update operation -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique id of GiftList to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[(UniqueID=)]]+IBM_GiftList_Update	     
	base_table=GRGFTREG
	sql=	
		SELECT
				GRGFTREG.$COLS:GRGFTREG$,
				GRADDR.$COLS:GRADDR$
		FROM
				GRGFTREG LEFT OUTER JOIN GRADDR ON GRGFTREG.PREEVENTADDRESS_ID = GRADDR.ADDRESS_ID OR
				GRGFTREG.POSTEVENTADDRESS_ID = GRADDR.ADDRESS_ID
		WHERE 
				GRGFTREG.GIFTREGISTRY_ID IN (?UniqueID?) AND 
				NOT GRGFTREG.STATUS = 4 
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /GiftList/GiftListIdentifier/ExternalIdentifier[(Name=)] -->
<!-- AccessProfile:	IBM_IdResolve -->
<!-- Get the internal unique ID for the specified external identifier. -->
<!-- Access profile includes only the unique ID -->
<!-- @param Name  Name(External ID) of GiftList to retrieve -->   
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[GiftListExternalIdentifier[ExternalIdentifier= and StoreIdentifier[UniqueID=]]]]+IBM_IdResolve
	base_table=GRGFTREG
	sql=	
		SELECT 
	     				GRGFTREG.$COLS:GIFTREGISTRY_ID$	     				
	     	FROM
	     				GRGFTREG
	     	WHERE
						GRGFTREG.EXTERNALID = ?ExternalIdentifier? AND GRGFTREG.STOREID = ?UniqueID? AND 
						NOT GRGFTREG.STATUS = 4 
						

END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /GiftList/GiftListRegistrant/UserIdentifier/[(UniqueId=)] -->
<!-- AccessProfile:	IBM_GiftRegistrant_Update -->
<!-- Get the internal unique ID for the specified external identifier. -->
<!-- Access profile includes only the unique ID -->
<!-- @param Name  Name(External ID) of GiftList to retrieve -->   
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[UniqueID=]]/Registrant+IBM_IdResolve
	base_table=GRRGSTRNT
	sql=
		SELECT 
	     				GRRGSTRNT.$COLS:GRRGSTRNT$,
					GRADDR.$COLS:GRADDR$	     				
	     	FROM
	     				GRRGSTRNT LEFT OUTER JOIN GRADDR ON GRRGSTRNT.ADDRESS_ID = GRADDR.ADDRESS_ID
	     	WHERE
					GRRGSTRNT.GIFTREGISTRY_ID IN (?UniqueID?) AND GRRGSTRNT.RGSTRNTTYPE = 0

END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[(UniqueID=)] AND [GiftListItemIdentifier[(GiftListItemID=)]]]/Item+IBM_GiftListItem_Update
	base_table=GRGFTITM
	sql=
		SELECT
				GRGFTITM.$COLS:GRGFTITM$,
				GRPERATTR.$COLS:GRPERATTR$
		FROM
				GRGFTITM LEFT OUTER JOIN GRPERATTR ON GRPERATTR.GIFTITEM_ID = GRGFTITM.GIFTITEM_ID
		WHERE 
				GRGFTITM.GIFTREGISTRY_ID IN (?UniqueID?) AND GRGFTITM.GIFTITEM_ID IN (?GiftListItemID?) 
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[UniqueID=]]+IBM_IdResolve
	base_table=GRGFTREG
	sql=
		SELECT
				GRGFTREG.$COLS:GRGFTREG$
		FROM
				GRGFTREG
		WHERE 
				GRGFTREG.GIFTREGISTRY_ID = ?UniqueID? AND 
				NOT GRGFTREG.STATUS = 4 
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[UniqueID=] AND [GiftListItemIdentifier[CatalogEntryIdentifier[ExternalIdentifier[PartNumber= AND @OwnerID=]]]]]+IBM_IdResolve
	base_table=GRGFTITM
	sql=
		SELECT 
			GRGFTITM.$COLS:GRGFTITM$
		FROM
			GRGFTITM
		WHERE
			GRGFTITM.GIFTREGISTRY_ID = ?UniqueID? AND GRGFTITM.PARTNUMBER = ?PartNumber? AND GRGFTITM.PARTAUXKEY = ?OwnerID?
END_XPATH_TO_SQL_STATEMENT


BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[UniqueID=]]+IBM_GiftRegistrant_IdResolve
	base_table=GRRGSTRNT
	sql=
		SELECT
				GRRGSTRNT.$COLS:GRRGSTRNT$
		FROM
				GRRGSTRNT
		WHERE 
				GRRGSTRNT.GIFTREGISTRY_ID = ?UniqueID?
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[UniqueID=]]+IBM_GiftListOwner_IdResolve
	base_table=GRRGSTRNT
	sql=
		SELECT
				GRRGSTRNT.$COLS:GRRGSTRNT$
		FROM
				GRRGSTRNT
		WHERE 
				GRRGSTRNT.GIFTREGISTRY_ID = ?UniqueID? AND GRRGSTRNT.RGSTRNTTYPE=0
END_XPATH_TO_SQL_STATEMENT		

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[(UniqueID=)] AND Registrant[(RegistrantID=)]]/Registrant+IBM_GiftListRegistrant_Update
	base_table=GRRGSTRNT
	sql=
		SELECT 
	     				GRRGSTRNT.$COLS:GRRGSTRNT$,
					GRADDR.$COLS:GRADDR$	     				
	     	FROM
	     				GRRGSTRNT LEFT OUTER JOIN GRADDR ON GRRGSTRNT.ADDRESS_ID = GRADDR.ADDRESS_ID
	     	WHERE
					GRRGSTRNT.GIFTREGISTRY_ID IN (?UniqueID?) AND GRRGSTRNT.REGISTRANT_ID IN (?RegistrantID?) AND GRRGSTRNT.RGSTRNTTYPE = 0


END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[(UniqueID=)] AND CoRegistrant[(CoRegistrantID=)]]/CoRegistrant+IBM_GiftListCoRegistrant_Update
	base_table=GRRGSTRNT
	sql=
		SELECT 
	     				GRRGSTRNT.$COLS:GRRGSTRNT$,
					GRADDR.$COLS:GRADDR$	     				
	     	FROM
	     				GRRGSTRNT LEFT OUTER JOIN GRADDR ON GRRGSTRNT.ADDRESS_ID = GRADDR.ADDRESS_ID
	     	WHERE
					GRRGSTRNT.GIFTREGISTRY_ID IN (?UniqueID?) AND GRRGSTRNT.REGISTRANT_ID IN (?CoRegistrantID?) AND ( GRRGSTRNT.RGSTRNTTYPE = 1 OR GRRGSTRNT.RGSTRNTTYPE > 5)


END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[(UniqueID=)]]/AccessSpecifier+IBM_GiftListAccessSpecifier_Update
	base_table=GRUSERAUTH
	sql=
		SELECT
				GRUSERAUTH.$COLS:GRUSERAUTH$
		FROM
				GRUSERAUTH
		WHERE 
				GRUSERAUTH.GIFTREGISTRY_ID IN (?UniqueID?) AND GRUSERAUTH.STATUS = 1
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[UniqueID=] AND [PurchaseRecord[PurchaseRecordIdentifier[(UniqueID=)]]]]/PurchaseRecord+IBM_GiftListPurchaseRecord_Update
	base_table=GRPURREC
	sql=
		SELECT  
			GRPURREC.$COLS:GRPURREC$, 
			GRADDR.$COLS:GRADDR$
		FROM	
			GRPURREC LEFT JOIN GRADDR ON (GRPURREC.ADDRESS_ID = GRADDR.ADDRESS_ID)
		WHERE 
			GRPURREC.GIFTREGISTRY_ID = ?UniqueID? AND GRPURREC.PURCHASERECORD_ID IN (?PurchaseRecordId?)
			
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[UniqueID=]]+IBM_GiftListAccessSpecifier_IdResolve
	base_table=GRGFTREG
	sql=
		SELECT
				GRGFTREG.$COLS:GIFTREGISTRY_ID$,GRGFTREG.$COLS:GUESTACCESSOPTION$,
				GRUSERAUTH.$COLS:GRUSERAUTH$
		FROM
				GRGFTREG LEFT OUTER JOIN GRUSERAUTH ON GRGFTREG.GIFTREGISTRY_ID = GRUSERAUTH.GIFTREGISTRY_ID
		WHERE 
				GRGFTREG.GIFTREGISTRY_ID = ?UniqueID?  AND 
				NOT GRGFTREG.STATUS = 4 
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[UniqueID=] and [PurchaseRecord[PurchasedItemDetails[TransactionID=]]]]+IBM_IdResolve
	base_table=GRPURREC
	sql=
		SELECT 
			GRPURREC.$COLS:GRPURREC$
		FROM
			GRPURREC 
		WHERE 
			GRPURREC.GIFTREGISTRY_ID = ?UniqueID? AND GRPURREC.TRANSACTIONID = ?TransactionID?
END_XPATH_TO_SQL_STATEMENT	
