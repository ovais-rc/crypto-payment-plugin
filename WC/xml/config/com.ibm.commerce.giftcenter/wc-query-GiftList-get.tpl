<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2009, 2010                                -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->

BEGIN_SYMBOL_DEFINITIONS
	COLS:GIFTREGISTRY_ID=				GRGFTREG:GIFTREGISTRY_ID
	COLS:GRGFTREG_EVENTTYPE_ID=			GRGFTREG:EVENTTYPE_ID
	COLS:GRGFTREG=						GRGFTREG:*
	COLS:GIFTREGISTRY_SUMMARY=			GRGFTREG:GIFTREGISTRY_ID, STATUS, GUESTACCESSOPTION, STOREID, OPTFOREMAIL, DESCRIPTION, MESSAGEFORGUEST, NAME, FIELD3, FIELD4, FIELD5, OPTCOUNTER
	
	COLS:EVENTTYPE_ID=					GREVNTTYPE:EVENTTYPE_ID
	COLS:GREVNTTYPE=					GREVNTTYPE:*
	
	COLS:ANNHISTORY_ID=					GRANNHIST:ANNHISTORY_ID
	COLS:GRANNHIST= 					GRANNHIST:*
	
	COLS:EMAILLIST_ID=					GREMLLIST:EMAILLIST_ID
	COLS:GREMLLIST=						GREMLLIST:*
	
	COLS:ADDRESS_ID=					GRADDR:ADDRESS_ID
	COLS:GRADDR=						GRADDR:*
	COLS:GRADDR_SUMMARY=				GRADDR:ADDRESS_ID, LASTNAME, FIRSTNAME, MIDDLENAME, COUNTRY, STATE, OPTCOUNTER
	
	COLS:GIFTITEM_ID=					GRGFTITM:GIFTITEM_ID
	COLS:GRGFTITM=						GRGFTITM:*
	
	COLS:GRUSERAUTH=					GRUSERAUTH:*
	
	COLS:GRPERATTR=						GRPERATTR:*
	
	COLS:GRRGSTRNT=						GRRGSTRNT:*

	COLS:PURCHASERECORD_ID=				GRPURREC:PURCHASERECORD_ID
	COLS:GRPURREC=						GRPURREC:*
	
END_SYMBOL_DEFINITIONS


<!-- ===========================================================================
     Get gift list by unique ID(s).
     @param UniqueID    The Unique ID(s) of the gift list.
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[(UniqueID=)]]
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$
		FROM
                     GRGFTREG
              WHERE
                     GRGFTREG.GIFTREGISTRY_ID IN ( ?UniqueID? ) AND
                     GRGFTREG.STOREID = $CTX:STORE_ID$ AND 
                     NOT GRGFTREG.STATUS = 4 
              ORDER BY GRGFTREG.EVENTDATE DESC, GRGFTREG.NAME ASC
       paging_count
       sql =
       		  SELECT 
                     COUNT(*) as COUNTER
              FROM
                     GRGFTREG
		WHERE
			GRGFTREG.GIFTREGISTRY_ID IN ( ?UniqueID? ) AND
			GRGFTREG.STOREID = $CTX:STORE_ID$ AND 
            NOT GRGFTREG.STATUS = 4 
END_XPATH_TO_SQL_STATEMENT 

<!-- ===========================================================================
     Get gift list by External ID(s).
     @param ExternalIdentifier    The External ID(s) of the gift list.
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[GiftListExternalIdentifier[(ExternalIdentifier=)]]]
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$
		FROM
			GRGFTREG
		WHERE
			GRGFTREG.EXTERNALID IN ( ?ExternalIdentifier? ) AND
			GRGFTREG.STOREID = $CTX:STORE_ID$ AND
			NOT GRGFTREG.STATUS = 4 
        ORDER BY GRGFTREG.EVENTDATE DESC, GRGFTREG.NAME ASC
       paging_count
       sql =
             SELECT 
                     COUNT(*) as COUNTER
              FROM
                     GRGFTREG
              WHERE
                     GRGFTREG.EXTERNALID IN ( ?ExternalIdentifier? ) AND
                     GRGFTREG.STOREID = $CTX:STORE_ID$ AND 
                     NOT GRGFTREG.STATUS = 4 
END_XPATH_TO_SQL_STATEMENT 

<!-- ===========================================================================
     Gift list search based on registrants last name, first name, email address
	  country and registry number	
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[search()]
	base_table=GRGFTREG
	className=com.ibm.commerce.giftcenter.facade.server.services.dataaccess.db.jdbc.GiftListSearchSQLComposer
	sql=
              SELECT 
                     GRGFTREG.$COLS:GIFTREGISTRY_ID$
              FROM
                     GRGFTREG, GRRGSTRNT, GRADDR, $ATTR_TBLS$
              WHERE                     
                     GRGFTREG.GIFTREGISTRY_ID = GRRGSTRNT.GIFTREGISTRY_ID AND 
					 NOT GRGFTREG.GUESTACCESSOPTION = 1 AND 
					 GRGFTREG.STATUS IN (1, 5) AND               
                     GRRGSTRNT.RGSTRNTTYPE IN (0, 1)  AND
                     GRGFTREG.STOREID = $CTX:STORE_ID$ AND
                     GRRGSTRNT.ADDRESS_ID = GRADDR.ADDRESS_ID AND $ATTR_CNDS$ AND $GRADDR_CNDS$
              ORDER BY GRGFTREG.EVENTDATE DESC, GRGFTREG.NAME ASC 
END_XPATH_TO_SQL_STATEMENT 

<!-- ===========================================================================
     Gift list search based on registrants last name, first name, email address
	  country, registry number	and event date
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[EventInformation[EventDate=] and search()]
	base_table=GRGFTREG
	className=com.ibm.commerce.giftcenter.facade.server.services.dataaccess.db.jdbc.GiftListSearchSQLComposer
	dbtype=oracle
	sql=
              SELECT 
                     GRGFTREG.$COLS:GIFTREGISTRY_ID$
              FROM
                     GRGFTREG, GRRGSTRNT, GRADDR, $ATTR_TBLS$
              WHERE                     
                     GRGFTREG.GIFTREGISTRY_ID = GRRGSTRNT.GIFTREGISTRY_ID AND 
					 NOT GRGFTREG.GUESTACCESSOPTION = 1 AND 
					 GRGFTREG.STATUS IN (1, 5) AND               
                     GRRGSTRNT.RGSTRNTTYPE IN (0, 1) AND
                     GRGFTREG.STOREID = $CTX:STORE_ID$ AND
                     GRRGSTRNT.ADDRESS_ID = GRADDR.ADDRESS_ID AND
                     GRGFTREG.EVENTDATE=TO_TIMESTAMP(?EventDate?, 'YYYY-MM-DD HH24:MI:SS.FF') AND
                     $ATTR_CNDS$ AND $GRADDR_CNDS$
              ORDER BY GRGFTREG.EVENTDATE DESC, GRGFTREG.NAME ASC 
	dbtype=any
	sql=
              SELECT 
                     GRGFTREG.$COLS:GIFTREGISTRY_ID$
              FROM
                     GRGFTREG, GRRGSTRNT, GRADDR, $ATTR_TBLS$
              WHERE                     
                     GRGFTREG.GIFTREGISTRY_ID = GRRGSTRNT.GIFTREGISTRY_ID AND 
					 NOT GRGFTREG.GUESTACCESSOPTION = 1 AND 
					 GRGFTREG.STATUS IN (1, 5) AND               
                     GRRGSTRNT.RGSTRNTTYPE IN (0, 1) AND
                     GRGFTREG.STOREID = $CTX:STORE_ID$ AND
                     GRRGSTRNT.ADDRESS_ID = GRADDR.ADDRESS_ID AND
                     GRGFTREG.EVENTDATE=?EventDate? AND
                     $ATTR_CNDS$ AND $GRADDR_CNDS$
              ORDER BY GRGFTREG.EVENTDATE DESC, GRGFTREG.NAME ASC 
END_XPATH_TO_SQL_STATEMENT 

<!-- ===========================================================================
     Gift list search based on event date
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[EventInformation[EventDate=]]
	base_table=GRGFTREG
	dbtype=oracle
	sql=
              SELECT 
                     GRGFTREG.$COLS:GIFTREGISTRY_ID$
              FROM
                     GRGFTREG
              WHERE                     
					 NOT GRGFTREG.GUESTACCESSOPTION = 1 AND 
					 GRGFTREG.STATUS IN (1, 5) AND               
                     GRGFTREG.EVENTDATE=TO_TIMESTAMP(?EventDate?, 'YYYY-MM-DD HH24:MI:SS.FF') AND
                     GRGFTREG.STOREID = $CTX:STORE_ID$
              ORDER BY GRGFTREG.EVENTDATE DESC, GRGFTREG.NAME ASC 
	dbtype=any
	sql=
              SELECT 
                     GRGFTREG.$COLS:GIFTREGISTRY_ID$
              FROM
                     GRGFTREG
              WHERE                     
					 NOT GRGFTREG.GUESTACCESSOPTION = 1 AND 
					 GRGFTREG.STATUS IN (1, 5) AND               
                     GRGFTREG.EVENTDATE=?EventDate? AND
                     GRGFTREG.STOREID = $CTX:STORE_ID$
              ORDER BY GRGFTREG.EVENTDATE DESC, GRGFTREG.NAME ASC 	
END_XPATH_TO_SQL_STATEMENT 


<!-- ============================================================= -->
<!-- This SQL will return all Gift List noun(s)                    -->
<!-- for the specified user ID.                                    -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Store_Summary, IBM_Store_Details, and IBM_Store_All       -->
<!-- profiles.													   -->
<!-- @param Registry - true to select gift registries, false to    -->
<!--     				   select wish lists.                          -->
<!-- @param UniqueID - The user ID.                                -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[Registrant[PersonIdentifier[UniqueID=]] and Registry=]
	base_table=GRGFTREG	
	sql=
              SELECT 
                     GRGFTREG.$COLS:GIFTREGISTRY_ID$
              FROM 
                     GRGFTREG JOIN GRRGSTRNT ON (GRGFTREG.GIFTREGISTRY_ID = GRRGSTRNT.GIFTREGISTRY_ID) 
              WHERE
                     GRRGSTRNT.USERID = ?UniqueID? AND
                     GRRGSTRNT.RGSTRNTTYPE = 0 AND
                     GRGFTREG.REGTYPE = ?Registry? AND
                     NOT GRGFTREG.STATUS = 4 AND
                     GRGFTREG.STOREID = $CTX:STORE_ID$
              ORDER BY GRGFTREG.EVENTDATE DESC, GRGFTREG.NAME ASC
       paging_count
       sql =
		SELECT 
                     COUNT(*) as COUNTER
		FROM 
			GRGFTREG JOIN GRRGSTRNT ON (GRGFTREG.GIFTREGISTRY_ID = GRRGSTRNT.GIFTREGISTRY_ID) 
		WHERE
			GRRGSTRNT.USERID = ?UniqueID? AND
			GRRGSTRNT.RGSTRNTTYPE = 0 AND
			GRGFTREG.REGTYPE = ?Registry? AND 
			NOT GRGFTREG.STATUS = 4	AND
			GRGFTREG.STOREID = $CTX:STORE_ID$		 				 	
END_XPATH_TO_SQL_STATEMENT 

<!-- ============================================================= -->
<!-- This SQL will return all Gift List noun(s)                    -->
<!-- for the specified user Id and state.                          -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Store_Summary, IBM_Store_Details, and IBM_Store_All       -->
<!-- profiles.													   -->
<!-- @param Registry - true to select gift registries, false to    -->
<!--     				   select wish lists.                              -->
<!-- @param UniqueId - The user Id.                                -->
<!-- @param State - The wish list state.                           -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[Registrant[PersonIdentifier[UniqueID=]] and Registry= and (State=)]	
	base_table=GRGFTREG	
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$
		FROM 
			GRGFTREG			 
				JOIN GRRGSTRNT ON (GRGFTREG.GIFTREGISTRY_ID = GRRGSTRNT.GIFTREGISTRY_ID)														
		WHERE
			GRRGSTRNT.USERID = ?UniqueID? AND
			GRRGSTRNT.RGSTRNTTYPE = 0 AND	
			GRGFTREG.STATUS IN (?State?) AND
			GRGFTREG.REGTYPE = ?Registry? AND
			GRGFTREG.STOREID = $CTX:STORE_ID$
        ORDER BY GRGFTREG.EVENTDATE DESC, GRGFTREG.NAME ASC
END_XPATH_TO_SQL_STATEMENT 

<!-- ============================================================= -->
<!-- This SQL will return gift list noun based on externalID   and access keys      -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Store_Summary, IBM_Store_Details, IBM_Store_All profiles  -->
<!-- @param GuestAccessKey - the guest access key                  -->
<!-- @param RegistryAccessKey - the registry access key            -->
<!-- @param ExternalIdentifier - gift list external identifier     -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[AccessSpecifier[GuestAccessKey= or RegistryAccessKey=] and GiftListIdentifier[GiftListExternalIdentifier[ExternalIdentifier=]]]
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$
		FROM
			GRGFTREG
		WHERE
			GRGFTREG.EXTERNALID = ?ExternalIdentifier?	AND 
			(GRGFTREG.GUESTACCESSKEY = ?GuestAccessKey? OR GRGFTREG.REGACCESSKEY = ?RegistryAccessKey?) AND
			GRGFTREG.STOREID = $CTX:STORE_ID$ AND
			GRGFTREG.STATUS IN (1, 5) 
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the paginated Gift List items            -->
<!-- for the specified gift list ExternalId.                       -->
<!-- The access profile that apply to this SQL is:                 -->
<!-- IBM_Store_GiftListItems                                       -->
<!-- @param ExternalIdentifier - The gift list ExternalId          -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[GiftListExternalIdentifier[ExternalIdentifier=]]]/Item
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$, GRGFTITM.$COLS:GIFTITEM_ID$
		FROM
                     GRGFTREG, GRGFTITM
              WHERE
                     GRGFTREG.EXTERNALID = ?ExternalIdentifier? AND
                     GRGFTREG.GIFTREGISTRY_ID = GRGFTITM.GIFTREGISTRY_ID AND
                     GRGFTREG.STOREID = $CTX:STORE_ID$ AND 
                     NOT GRGFTREG.STATUS = 4 
              ORDER BY GRGFTITM.PARTNUMBER
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the paginated Gift List Announcements    -->
<!-- for the specified gift list ExternalId.                       -->
<!-- The access profile that apply to this SQL is:                 -->
<!-- IBM_Store_GiftListAnnouncements                               -->
<!-- @param ExternalIdentifier - The gift list ExternalId          -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[GiftListExternalIdentifier[ExternalIdentifier=]]]/Announcement
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$, GRANNHIST.$COLS:ANNHISTORY_ID$
		FROM
                     GRGFTREG, GRANNHIST
              WHERE
                     GRGFTREG.EXTERNALID = ?ExternalIdentifier? AND
                     GRGFTREG.GIFTREGISTRY_ID = GRANNHIST.GIFTREGISTRY_ID AND
                     GRGFTREG.STOREID = $CTX:STORE_ID$ AND  
                     NOT GRGFTREG.STATUS = 4
              ORDER BY GRANNHIST.SENTDATE DESC
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the paginated Gift List purchase records -->
<!-- for the specified gift list Id.                               -->
<!-- The access profile that apply to this SQL is:                 -->
<!-- IBM_Store_GiftListPurchaseRecords                             -->
<!-- @param ExternalIdentifier - The gift list external Id.        -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/GiftList[GiftListIdentifier[GiftListExternalIdentifier[ExternalIdentifier=]]]/PurchaseRecord
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$, GRPURREC.$COLS:PURCHASERECORD_ID$
		FROM
                     GRGFTREG, GRPURREC
              WHERE
                     GRGFTREG.EXTERNALID = ?ExternalIdentifier? AND
                     GRGFTREG.GIFTREGISTRY_ID = GRPURREC.GIFTREGISTRY_ID AND
                     GRGFTREG.STOREID = $CTX:STORE_ID$ AND 
                     NOT GRGFTREG.STATUS = 4 
              ORDER BY GRPURREC.PURCHASEDATE DESC
END_XPATH_TO_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list purchase records query for IBM_Store_GiftListPurchaseRecords access profile.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_GiftListPurchaseRecords
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_SUMMARY$,
			GRPURREC.$COLS:GRPURREC$,
			GRADDR.$COLS:GRADDR$
		FROM
			GRGFTREG, (GRPURREC LEFT JOIN GRADDR ON (GRADDR.ADDRESS_ID = GRPURREC.ADDRESS_ID)) 
		WHERE
			GRGFTREG.GIFTREGISTRY_ID IN ( $ENTITY_PKS$ ) AND
			GRGFTREG.GIFTREGISTRY_ID = GRPURREC.GIFTREGISTRY_ID AND
			GRPURREC.PURCHASERECORD_ID IN ( $SUBENTITY_PKS$ )
		ORDER BY GRPURREC.PURCHASEDATE DESC
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list items query for IBM_Store_GiftListAnnouncements access profile.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_GiftListAnnouncements
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_SUMMARY$,
			GRANNHIST.$COLS:GRANNHIST$,
			GREMLLIST.$COLS:GREMLLIST$
		FROM
			GRGFTREG, (GRANNHIST LEFT JOIN GREMLLIST ON (GRANNHIST.ANNHISTORY_ID = GREMLLIST.ANNHISTORY_ID)) 
		WHERE
			GRGFTREG.GIFTREGISTRY_ID IN ( $ENTITY_PKS$ ) AND
			GRGFTREG.GIFTREGISTRY_ID = GRANNHIST.GIFTREGISTRY_ID AND
			GRANNHIST.ANNHISTORY_ID IN ( $SUBENTITY_PKS$ )
		ORDER BY GRANNHIST.SENTDATE DESC
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list items query for IBM_Store_GiftListItems access profile.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_GiftListItems
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_SUMMARY$,
			GRGFTITM.$COLS:GRGFTITM$,
			GRPERATTR.$COLS:GRPERATTR$
		FROM
			GRGFTREG, (GRGFTITM LEFT JOIN GRPERATTR ON (GRGFTITM.GIFTITEM_ID = GRPERATTR.GIFTITEM_ID)) 
		WHERE
			GRGFTREG.GIFTREGISTRY_ID IN ( $ENTITY_PKS$ ) AND
			GRGFTREG.GIFTREGISTRY_ID = GRGFTITM.GIFTREGISTRY_ID AND
			GRGFTITM.GIFTITEM_ID IN ( $SUBENTITY_PKS$ )
		ORDER BY GRGFTITM.PARTNUMBER
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list query for IBM_Store_Summary access profile.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_Summary
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GRGFTREG$
		FROM
			GRGFTREG
		WHERE
			GRGFTREG.GIFTREGISTRY_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list query for getting the event details.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_Events
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$,
			GRGFTREG.$COLS:GRGFTREG_EVENTTYPE_ID$,
			GREVNTTYPE.$COLS:GREVNTTYPE$
		FROM
			GRGFTREG JOIN GREVNTTYPE ON GRGFTREG.EVENTTYPE_ID = GREVNTTYPE.EVENTTYPE_ID
		WHERE
			GRGFTREG.GIFTREGISTRY_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list query for getting the access specifier details.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_AccessSpecifier
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$,
			GRUSERAUTH.$COLS:GRUSERAUTH$
		FROM
			GRGFTREG LEFT JOIN GRUSERAUTH ON GRGFTREG.GIFTREGISTRY_ID = GRUSERAUTH.GIFTREGISTRY_ID
		WHERE
			GRGFTREG.GIFTREGISTRY_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list query for IBM_Store_Details access profile.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_Details
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GRGFTREG$,
			GRADDR.$COLS:GRADDR$
		FROM
			GRGFTREG JOIN GRADDR ON GRADDR.ADDRESS_ID IN (GRGFTREG.PREEVENTADDRESS_ID, GRGFTREG.POSTEVENTADDRESS_ID)
		WHERE
			GRGFTREG.GIFTREGISTRY_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list registrant query for IBM_Store_All access profile.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_Registrant
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$,
			GRRGSTRNT.$COLS:GRRGSTRNT$,
			GRADDR.$COLS:GRADDR$
		FROM
			GRGFTREG, (GRRGSTRNT JOIN GRADDR ON (GRRGSTRNT.ADDRESS_ID = GRADDR.ADDRESS_ID))
		WHERE
			GRGFTREG.GIFTREGISTRY_ID  = GRRGSTRNT.GIFTREGISTRY_ID AND
			GRGFTREG.GIFTREGISTRY_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list query for getting the registrant details without address (only first, last, middle name and country, state information)
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_Registrant_Without_Address
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$,
			GRRGSTRNT.$COLS:GRRGSTRNT$,
			GRADDR.$COLS:GRADDR_SUMMARY$
		FROM
			GRGFTREG, (GRRGSTRNT JOIN GRADDR ON (GRRGSTRNT.ADDRESS_ID = GRADDR.ADDRESS_ID))
		WHERE
			GRGFTREG.GIFTREGISTRY_ID  = GRRGSTRNT.GIFTREGISTRY_ID AND
			GRGFTREG.GIFTREGISTRY_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list items query for IBM_Store_All access profile.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_Items
	base_table=GRGFTREG
	sql=
		SELECT 
			GRGFTREG.$COLS:GIFTREGISTRY_ID$,
			GRGFTITM.$COLS:GRGFTITM$,
			GRPERATTR.$COLS:GRPERATTR$
		FROM
			GRGFTREG, (GRGFTITM LEFT JOIN GRPERATTR ON GRGFTITM.GIFTITEM_ID = GRPERATTR.GIFTITEM_ID)
		WHERE
			GRGFTREG.GIFTREGISTRY_ID = GRGFTITM.GIFTREGISTRY_ID AND
			GRGFTREG.GIFTREGISTRY_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list announcements query for IBM_Store_All access profile.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_Announcements
	base_table=GRGFTREG
	sql=
		SELECT
			GRGFTREG.$COLS:GIFTREGISTRY_SUMMARY$,
			GRANNHIST.$COLS:GRANNHIST$,
			GREMLLIST.$COLS:GREMLLIST$
		FROM
			GRGFTREG, (GRANNHIST LEFT JOIN GREMLLIST ON (GRANNHIST.ANNHISTORY_ID = GREMLLIST.ANNHISTORY_ID))
		WHERE
			GRGFTREG.GIFTREGISTRY_ID = GRANNHIST.GIFTREGISTRY_ID 
			AND GRGFTREG.GIFTREGISTRY_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get gift list purchase records query for IBM_Store_All access profile.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_GR_PurchaseRecords
	base_table=GRGFTREG
	sql=
		select  
			GRGFTREG.$COLS:GIFTREGISTRY_SUMMARY$,
			GRPURREC.$COLS:GRPURREC$, 
			GRADDR.$COLS:GRADDR$
		FROM	
			GRGFTREG, (GRPURREC LEFT JOIN GRADDR ON (GRPURREC.ADDRESS_ID = GRADDR.ADDRESS_ID))
		WHERE 
			GRGFTREG.GIFTREGISTRY_ID = GRPURREC.GIFTREGISTRY_ID 
			AND GRGFTREG.GIFTREGISTRY_ID IN ($ENTITY_PKS$)

END_ASSOCIATION_SQL_STATEMENT


<!-- ===========================================================================
     Definition for IBM_Store_Summary access profile.
     =========================================================================== -->
BEGIN_PROFILE 
   name=IBM_Store_Summary
   BEGIN_ENTITY 
     base_table=GRGFTREG
     associated_sql_statement=IBM_GR_Summary
     associated_sql_statement=IBM_GR_Registrant_Without_Address
     associated_sql_statement=IBM_GR_Events
    END_ENTITY
END_PROFILE

<!-- ===========================================================================
     Definition for IBM_Store_Details access profile.
     =========================================================================== -->
BEGIN_PROFILE 
   name=IBM_Store_Details
   BEGIN_ENTITY 
     base_table=GRGFTREG
     associated_sql_statement=IBM_GR_Summary
     associated_sql_statement=IBM_GR_Details 
     associated_sql_statement=IBM_GR_Registrant
     associated_sql_statement=IBM_GR_Events  
     associated_sql_statement=IBM_GR_AccessSpecifier  						  
    END_ENTITY
END_PROFILE

<!-- ===========================================================================
     Definition for IBM_Store_All access profile.
     =========================================================================== -->
BEGIN_PROFILE 
   name=IBM_Store_All
   BEGIN_ENTITY 
     base_table=GRGFTREG
     associated_sql_statement=IBM_GR_Summary
     associated_sql_statement=IBM_GR_Details
     associated_sql_statement=IBM_GR_Events
     associated_sql_statement=IBM_GR_AccessSpecifier
     associated_sql_statement=IBM_GR_Registrant
     associated_sql_statement=IBM_GR_Items
     associated_sql_statement=IBM_GR_Announcements
     associated_sql_statement=IBM_GR_PurchaseRecords
    END_ENTITY
END_PROFILE

<!-- ===========================================================================
     Definition for IBM_Store_GiftListSummaryAndItems access profile.
     =========================================================================== -->
BEGIN_PROFILE 
   name=IBM_Store_GiftListSummaryAndItems
   BEGIN_ENTITY 
     base_table=GRGFTREG
     associated_sql_statement=IBM_GR_Summary
     associated_sql_statement=IBM_GR_Registrant_Without_Address
     associated_sql_statement=IBM_GR_Events
     associated_sql_statement=IBM_GR_Items
    END_ENTITY
END_PROFILE

<!-- ===========================================================================
     Definition for IBM_Store_GiftListItems access profile.
     =========================================================================== -->
BEGIN_PROFILE 
	name=IBM_Store_GiftListItems
	BEGIN_ENTITY 
	  base_table=GRGFTREG
	  associated_sql_statement=IBM_GR_GiftListItems
    END_ENTITY
END_PROFILE


<!-- ===========================================================================
     Definition for IBM_Store_GiftListAnnouncements access profile.
     =========================================================================== -->
BEGIN_PROFILE 
	name=IBM_Store_GiftListAnnouncements
	BEGIN_ENTITY 
	  base_table=GRGFTREG
	  associated_sql_statement=IBM_GR_GiftListAnnouncements
    END_ENTITY
END_PROFILE

<!-- ===========================================================================
     Definition for IBM_Store_GiftListPurchaseRecords access profile.
     =========================================================================== -->
BEGIN_PROFILE 
   name=IBM_Store_GiftListPurchaseRecords
   BEGIN_ENTITY 
     base_table=GRGFTREG
     associated_sql_statement=IBM_GR_GiftListPurchaseRecords
    END_ENTITY
END_PROFILE

