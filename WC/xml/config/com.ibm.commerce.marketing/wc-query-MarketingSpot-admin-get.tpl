<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2007, 2015                                -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS

	<!-- EMSPOT table -->
	COLS:EMSPOT=EMSPOT:*
	COLS:EMSPOT_ID_NAME=EMSPOT:EMSPOT_ID, NAME
	COLS:DMEMSPOTDEF=DMEMSPOTDEF:*
	COLS:DMEMSPOTCOLLDEF=DMEMSPOTCOLLDEF:*
								
	<!-- DMEMSPOTCMD table -->
	COLS:DMEMSPOTCMD=DMEMSPOTCMD:*
		
	<!-- DMEMSPOTORD table -->
	COLS:DMEMSPOTORD=DMEMSPOTORD:*
									
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- Marketing Spot Access Profiles                                           -->
<!-- IBM_Admin_Details       All the columns from the EMSPOT table            -->
<!-- ======================================================================== -->

BEGIN_PROFILE_ALIASES
  base_table=EMSPOT
  IBM_Details=IBM_Admin_Details
END_PROFILE_ALIASES

<!-- Marketing Spots -->

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- for all the eMarketingSpots in the current store, and in any stores      -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Usage The usage type of the eMarketing spot.                      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the eMarketingSpots in EMSPOT in one store -->
	name=/MarketingSpot[Usage=]+IBM_Admin_Details
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID in ($STOREPATH:campaigns$) AND
				EMSPOT.USAGETYPE = ?Usage? AND
				(EMSPOT.UIDISPLAYABLE IS NULL OR EMSPOT.UIDISPLAYABLE = 1)
	  ORDER BY EMSPOT.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID in ($STOREPATH:campaigns$) AND
				EMSPOT.USAGETYPE = ?Usage? AND
				(EMSPOT.UIDISPLAYABLE IS NULL OR EMSPOT.UIDISPLAYABLE = 1)
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param MarketingSpotIdentifier The identifier of the eMarketing          -->
<!--                              spot to retrieve.                           -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch eMarketingSpots in EMSPOT by ID -->
	name=/MarketingSpot[MarketingSpotIdentifier[(UniqueID=)]]
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.EMSPOT_ID IN ( ?UniqueID? )
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- of the e-marketing spot with the specified name.                         -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The name of the e-marketing spot to retrieve.                -->
<!-- @param Context:StoreID The store for which to retrieve the               -->
<!--       marketing spot. This parameter is retrieved from within            -->
<!--       the business context.                                              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing marketing spot by name and store in EMSPOT -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[Name=]]]+IBM_Admin_Details
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID = $CTX:STORE_ID$ AND
				EMSPOT.USAGETYPE = 'MARKETING' AND
				EMSPOT.NAME = ?Name?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- of the e-marketing spot with the specified name and usage.               -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The name of the e-marketing spot to retrieve.                -->
<!-- @param Usage The usage type of the eMarketing spot.                      -->
<!-- @param Context:StoreID The store for which to retrieve the               -->
<!--       marketing spot. This parameter is retrieved from within            -->
<!--       the business context.                                              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing marketing spot by name and usage in EMSPOT -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[Name=]] and Usage=]+IBM_Admin_Details
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID = $CTX:STORE_ID$ AND
				EMSPOT.USAGETYPE = ?Usage? AND
				EMSPOT.NAME = ?Name?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- of the e-marketing spot with the specified name and usage.               -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The name of the e-marketing spot to retrieve.                -->
<!-- @param Usage The usage type of the eMarketing spot.                      -->
<!-- @param UniqueID The store for which to retrieve the marketing spot.      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing marketing spot by name, usage and store in EMSPOT -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[Name= and StoreIdentifier[UniqueID=]]] and Usage=]+IBM_Admin_Details
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$,
				DMEMSPOTDEF.$COLS:DMEMSPOTDEF$,
				DMEMSPOTCMD.$COLS:DMEMSPOTCMD$,
				DMEMSPOTORD.$COLS:DMEMSPOTORD$,
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$				
		FROM
				EMSPOT
				LEFT OUTER JOIN DMEMSPOTDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTDEF.EMSPOT_ID AND DMEMSPOTDEF.STOREENT_ID = ?UniqueID?)	
				LEFT OUTER JOIN DMEMSPOTCMD ON (EMSPOT.EMSPOT_ID = DMEMSPOTCMD.EMSPOT_ID AND DMEMSPOTCMD.STOREENT_ID = ?UniqueID?)								
				LEFT OUTER JOIN DMEMSPOTORD ON (DMEMSPOTCMD.DMEMSPOTORD_ID = DMEMSPOTORD.DMEMSPOTORD_ID)	
				LEFT OUTER JOIN DMEMSPOTCOLLDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTCOLLDEF.EMSPOT_ID AND DMEMSPOTCOLLDEF.STOREENT_ID = ?UniqueID?)
		WHERE
				EMSPOT.STOREENT_ID = ?UniqueID? AND
				EMSPOT.USAGETYPE = ?Usage? AND
				EMSPOT.NAME = ?Name?
		ORDER BY DMEMSPOTDEF.SEQUENCE ASC, DMEMSPOTCOLLDEF.SEQUENCE ASC
									
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return all the data of the MarketingSpot noun              -->
<!-- for the e-marketing spot in the specified store.                         -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param SpotUniqueID The ID of the e-marketing spot.                      -->
<!-- @param StoreUniqueID The store for which to retrieve the                 -->
<!--                      marketing spot info.                                -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing marketing spot by name, usage and store in EMSPOT -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[StoreIdentifier[StoreUniqueID=]] and SpotUniqueID=]]+IBM_Admin_Details
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$,
				DMEMSPOTDEF.$COLS:DMEMSPOTDEF$,
				DMEMSPOTCMD.$COLS:DMEMSPOTCMD$,
				DMEMSPOTORD.$COLS:DMEMSPOTORD$,
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$				
		FROM
				EMSPOT
				LEFT OUTER JOIN DMEMSPOTDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTDEF.EMSPOT_ID AND DMEMSPOTDEF.STOREENT_ID = ?StoreUniqueID?)	
				LEFT OUTER JOIN DMEMSPOTCMD ON (EMSPOT.EMSPOT_ID = DMEMSPOTCMD.EMSPOT_ID AND DMEMSPOTCMD.STOREENT_ID = ?StoreUniqueID?)								
				LEFT OUTER JOIN DMEMSPOTORD ON (DMEMSPOTCMD.DMEMSPOTORD_ID = DMEMSPOTORD.DMEMSPOTORD_ID)	
				LEFT OUTER JOIN DMEMSPOTCOLLDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTCOLLDEF.EMSPOT_ID AND DMEMSPOTCOLLDEF.STOREENT_ID = ?StoreUniqueID?)
		WHERE
				EMSPOT.EMSPOT_ID = ?SpotUniqueID?		
		ORDER BY DMEMSPOTDEF.SEQUENCE ASC, DMEMSPOTCOLLDEF.SEQUENCE ASC													
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- of the e-marketing spot with the specified usage in the specific store.  -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Usage The usage type of the eMarketing spot.                      -->
<!-- @param UniqueID The store for which to retrieve the marketing spot.      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing marketing spot by name, usage and store in EMSPOT -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[StoreIdentifier[UniqueID=]]] and Usage=]
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID = ?UniqueID? AND
				EMSPOT.USAGETYPE = ?Usage? AND
				(EMSPOT.UIDISPLAYABLE IS NULL OR EMSPOT.UIDISPLAYABLE = 1)
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- that match the specified search criteria                                 -->
<!-- for all the eMarketingSpots in the current store, and in any stores      -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Usage The usage type of the eMarketing spot.                      -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- search all the eMarketingSpots in EMSPOT in one store -->
	name=/MarketingSpot[Usage= and search()]
	base_table=EMSPOT
	sql=
		SELECT 
				DISTINCT EMSPOT.$COLS:EMSPOT_ID_NAME$
		FROM
				EMSPOT, $ATTR_TBLS$
		WHERE
				EMSPOT.STOREENT_ID in ($STOREPATH:campaigns$) AND
				EMSPOT.USAGETYPE = ?Usage? AND
				(EMSPOT.UIDISPLAYABLE IS NULL OR EMSPOT.UIDISPLAYABLE = 1) AND
				EMSPOT.$ATTR_CNDS$
	  ORDER BY EMSPOT.NAME
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the default content data of the MarketingSpot noun  -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_DefaultContent -->
<!-- @param MarketingSpotIdentifier The identifier of the marketing spot for  -->
<!--                             which to retrieve the default content.       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Spot default content in DMEMSPOTDEF table -->
	name=/MarketingSpot[MarketingSpotIdentifier[(UniqueID=)]]+IBM_Admin_DefaultContent
	base_table=DMEMSPOTDEF
	sql=
		SELECT 
				DMEMSPOTDEF.$COLS:DMEMSPOTDEF$				
		FROM
				DMEMSPOTDEF					
		WHERE
				DMEMSPOTDEF.EMSPOT_ID IN ( ?UniqueID? )
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the default content data of the MarketingSpot noun  -->
<!-- for the specified store identifier and usage type. Multiple results      -->
<!-- are returned based on the number of data entries for that store and      -->
<!-- usage.								      -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_DefaultContent -->
<!-- @param Usage The usage type of the e-Marketing spot.                     -->
<!-- @param UniqueID The store for which to retrieve the marketing spot.      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Spot default content in DMEMSPOTDEF table -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[StoreIdentifier[UniqueID=]]] and Usage=]+IBM_Admin_DefaultContent	    
	base_table=EMSPOT
	sql=
		SELECT 
			EMSPOT.$COLS:EMSPOT$,
			DMEMSPOTDEF.$COLS:DMEMSPOTDEF$ 
		FROM
			EMSPOT JOIN DMEMSPOTDEF ON (DMEMSPOTDEF.EMSPOT_ID = EMSPOT.EMSPOT_ID)			
		WHERE
			DMEMSPOTDEF.STOREENT_ID = ?UniqueID? AND			
			EMSPOT.USAGETYPE = ?Usage? AND
			(EMSPOT.UIDISPLAYABLE IS NULL OR EMSPOT.UIDISPLAYABLE = 1)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return all the e-Marketing Spots for which the specified   -->
<!-- marketing content is used in a default content or title.                 -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param ContentUniqueID The ID of the marketing content.                  -->
<!-- @param Format The default content format.                                -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Spot default content and default title in DMEMSPOTDEF and DMEMSPOTCOLLDEF tables -->
	name=/MarketingSpot[DefaultContent[ContentUniqueID= and Format=]]+IBM_Admin_Summary
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$,DMEMSPOTDEF.$COLS:DMEMSPOTDEF$,DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$
		FROM
				EMSPOT
				LEFT OUTER JOIN DMEMSPOTDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTDEF.EMSPOT_ID AND DMEMSPOTDEF.CONTENTTYPE = ?Format? AND DMEMSPOTDEF.CONTENT = ?ContentUniqueID? AND DMEMSPOTDEF.STOREENT_ID IN ($STOREPATH:campaigns$))
				LEFT OUTER JOIN DMEMSPOTCOLLDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTCOLLDEF.EMSPOT_ID AND DMEMSPOTCOLLDEF.COLLATERAL_ID = ?ContentUniqueID? AND DMEMSPOTCOLLDEF.STOREENT_ID in ($STOREPATH:campaigns$))
		WHERE 
			(DMEMSPOTDEF_ID IS NOT NULL OR DMEMSPOTCOLLDEF_ID IS NOT NULL)
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows    
		FROM
				EMSPOT
				LEFT OUTER JOIN DMEMSPOTDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTDEF.EMSPOT_ID AND DMEMSPOTDEF.CONTENTTYPE = ?Format? AND DMEMSPOTDEF.CONTENT = ?ContentUniqueID? AND DMEMSPOTDEF.STOREENT_ID IN ($STOREPATH:campaigns$))
				LEFT OUTER JOIN DMEMSPOTCOLLDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTCOLLDEF.EMSPOT_ID AND DMEMSPOTCOLLDEF.COLLATERAL_ID = ?ContentUniqueID? AND DMEMSPOTCOLLDEF.STOREENT_ID in ($STOREPATH:campaigns$))
		WHERE 
			(DMEMSPOTDEF_ID IS NOT NULL OR DMEMSPOTCOLLDEF_ID IS NOT NULL)
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return all the e-Marketing Spots for which the specified   -->
<!-- marketing content is used in a default content or title.                 -->
<!-- The association can be found in any store.                               -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param ContentUniqueID The ID of the marketing content.                  -->
<!-- @param Format The default content format.                                -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Spot default content and default title in DMEMSPOTDEF and DMEMSPOTCOLLDEF tables -->
	name=/MarketingSpot[DefaultContent[ContentUniqueID= and Format= and StoreIdentifer=0]]+IBM_Admin_Summary
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$,DMEMSPOTDEF.$COLS:DMEMSPOTDEF$,DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$
		FROM
				EMSPOT
				LEFT OUTER JOIN DMEMSPOTDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTDEF.EMSPOT_ID AND DMEMSPOTDEF.CONTENTTYPE = ?Format? AND DMEMSPOTDEF.CONTENT = ?ContentUniqueID?)
				LEFT OUTER JOIN DMEMSPOTCOLLDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTCOLLDEF.EMSPOT_ID AND DMEMSPOTCOLLDEF.COLLATERAL_ID = ?ContentUniqueID?)
		WHERE 
			(DMEMSPOTDEF_ID IS NOT NULL OR DMEMSPOTCOLLDEF_ID IS NOT NULL)
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the default content data of the MarketingSpot noun  -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_DefaultContent -->
<!-- @param MarketingSpotIdentifier The identifier of the marketing spot for  -->
<!--                             which to retrieve the default content.       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Spot title in EMSPOTCOLLDEF table -->
	name=/MarketingSpot[MarketingSpotIdentifier[(UniqueID=)]]+IBM_Admin_MarketingSpotTitle
	base_table=DMEMSPOTCOLLDEF
	sql=
		SELECT 
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$				
		FROM
				DMEMSPOTCOLLDEF					
		WHERE
				DMEMSPOTCOLLDEF.EMSPOT_ID IN ( ?UniqueID? )
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingSpot noun                  -->
<!-- of the e-marketing spot with the specified name and usage for context store.               -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The name of the e-marketing spot to retrieve.                -->
<!-- @param Usage The usage type of the eMarketing spot.                      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing marketing spot by name, usage and store in EMSPOT -->
	name=/MarketingSpot[MarketingSpotIdentifier[ExternalIdentifier[(Name=)]] and Usage=]
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.STOREENT_ID IN ($STOREPATH:campaigns$, 0) AND
				EMSPOT.USAGETYPE = ?Usage? AND
		    		EMSPOT.NAME IN (?Name?)
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return all the marketing spot ordering          -->
<!-- info of the MarketingSpot noun.                                          -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Spot with title in EMSPOT and DMEMSPOTCOLLDEF -->
	name=IBM_MarketingSpotOrdering
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$,
				DMEMSPOTCMD.$COLS:DMEMSPOTCMD$,
				DMEMSPOTORD.$COLS:DMEMSPOTORD$				
		FROM
				EMSPOT 
				LEFT OUTER JOIN DMEMSPOTCMD ON (EMSPOT.EMSPOT_ID = DMEMSPOTCMD.EMSPOT_ID AND EMSPOT.STOREENT_ID = DMEMSPOTCMD.STOREENT_ID)								
				LEFT OUTER JOIN DMEMSPOTORD ON (DMEMSPOTCMD.DMEMSPOTORD_ID = DMEMSPOTORD.DMEMSPOTORD_ID)								
		WHERE
				EMSPOT.EMSPOT_ID IN ($ENTITY_PKS$)
										
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return the details of the MarketingSpot noun.   -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- returns eMarketingSpots in EMSPOT -->
	name=IBM_MarketingSpotDetailsAssoc
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT
		WHERE
				EMSPOT.EMSPOT_ID in ($ENTITY_PKS$)
	  	ORDER BY EMSPOT.NAME								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return all the marketing spot default content   -->
<!-- info of the MarketingSpot noun.                                          -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Spot with default content in EMSPOT and DMEMSPOTDEF -->
	name=IBM_MarketingSpotDefaultContent
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$,
				DMEMSPOTDEF.$COLS:DMEMSPOTDEF$				
		FROM
				EMSPOT 
				LEFT OUTER JOIN DMEMSPOTDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTDEF.EMSPOT_ID AND DMEMSPOTDEF.STOREENT_ID IN ($STOREPATH:campaigns$))								
		WHERE
				EMSPOT.EMSPOT_ID IN ($ENTITY_PKS$)
		ORDER BY DMEMSPOTDEF.SEQUENCE ASC												
						
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return all the marketing spot title             -->
<!-- info of the MarketingSpot noun.                                          -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Spot with title in EMSPOT and DMEMSPOTCOLLDEF -->
	name=IBM_MarketingSpotTitle
	base_table=EMSPOT
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$,
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$				
		FROM
				EMSPOT 
				LEFT OUTER JOIN DMEMSPOTCOLLDEF ON (EMSPOT.EMSPOT_ID = DMEMSPOTCOLLDEF.EMSPOT_ID AND DMEMSPOTCOLLDEF.STOREENT_ID IN ($STOREPATH:campaigns$))								
		WHERE
				EMSPOT.EMSPOT_ID IN ($ENTITY_PKS$)
		ORDER BY DMEMSPOTCOLLDEF.SEQUENCE ASC												
						
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- MarketingSpot Admin Details Access Profile                               -->
<!-- This profile returns the details of the MarketingSpot noun.              -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Admin_Details
       BEGIN_ENTITY 
         base_table=EMSPOT
         className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
         associated_sql_statement=IBM_MarketingSpotDetailsAssoc         
         associated_sql_statement=IBM_MarketingSpotDefaultContent
         associated_sql_statement=IBM_MarketingSpotTitle
         associated_sql_statement=IBM_MarketingSpotOrdering
    END_ENTITY
END_PROFILE




