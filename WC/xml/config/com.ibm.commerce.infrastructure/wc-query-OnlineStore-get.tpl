<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2010                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS

	<!-- STORE table -->
	COLS:STORE_ID			= STORE:STORE_ID
	COLS:STORE_SUMMARY		= STORE:STORE_ID, STORETYPE, OPTCOUNTER
	COLS:STORE_DETAILS		= STORE:STORE_ID, STORETYPE, STATUS, OPTCOUNTER
	COLS:STORE_ALL			= STORE:*
	
	<!-- STOREENT table -->
	COLS:STOREENT_ID		= STOREENT:STOREENT_ID, IDENTIFIER, OPTCOUNTER
	COLS:STOREENT_SUMMARY		= STOREENT:STOREENT_ID, MEMBER_ID, IDENTIFIER, OPTCOUNTER
	COLS:STOREENT_DETAILS		= STOREENT:STOREENT_ID, MEMBER_ID, IDENTIFIER, OPTCOUNTER
	COLS:STOREENT_ALL		= STOREENT:*
	
	<!-- STOREENTDS table -->
	COLS:STOREENTDS_DETAILS		= STOREENTDS:STOREENT_ID, LANGUAGE_ID, DISPLAYNAME, DESCRIPTION, OPTCOUNTER
	COLS:STOREENTDS_ALL		= STOREENTDS:*
	
	<!-- STADDRESS table -->
	COLS:STADDRESS_ALL		= STADDRESS:*
	
	<!-- CURLIST table -->
	COLS:CURLIST_ALL		= CURLIST:*
	
	<!-- STORELANG table -->
	COLS:STORELANG_ALL		= STORELANG:*
	
	<!-- MBRROLE table -->
	COLS:ROLE_ID			= MBRROLE:*
	
	<!-- STOREREL table -->
	COLS:STOREREL_ALL		= STOREREL:*


	<!-- SEOPAGEDEF table -->
	COLS:SEOPAGEDEF_ID = SEOPAGEDEF:SEOPAGEDEF_ID,OPTCOUNTER
	COLS:SEOAGEDEF_ALL = SEOPAGEDEF:*

	<!-- SEOPAGEDEFDESC table -->
	COLS:SEOPAGEDEFDESC_ALL = SEOPAGEDEFDESC:*

	<!-- SEOURL table -->
	COLS:SEOURL_ID		= SEOURL:SEOURL_ID
	COLS:SEOURL_ALL		= SEOURL:*
	COLS:SEOURL_SUMMARY = SEOURL:TOKENNAME,SEOURL_ID, TOKENVALUE
	
	<!-- SEOURLKEYWORD table -->
	COLS:SEOURLKEYWORD_SUMMARY	= SEOURLKEYWORD:SEOURLKEYWORD_ID,SEOURL_ID,URLKEYWORD,MOBILEURLKEYWORD,STOREENT_ID,LANGUAGE_ID
	COLS:SEOURLKEYWORD_ALL	= SEOURLKEYWORD:*
	
	<!-- STOREENT table -->
	COLS:STOREENT_UID		= STOREENT:STOREENT_ID
	
	<!-- STOREDEFCAT table -->
	COLS:STOREDEFCAT_ALL		= STOREDEFCAT:*
	
		
	<!-- STORECONF table -->
	COLS:STORECONF_ALL		= STORECONF:*
	
END_SYMBOL_DEFINITIONS

<!-- ===================================================================================== -->
<!-- OnlineStore Access Profiles                                                           -->
<!-- IBM_Admin_Summary          STORE_ID from the STORE table                              -->
<!-- IBM_Admin_Details          STATUS, STORETYPE from the STORE table and                 -->
<!--                            LANGUAGE_ID, DESCRIPTION from the STOREENTDS table         -->
<!-- IBM_Admin_All              SETCCURR from STOREENT                                     -->
<!--                            LANGUAGE_ID from STORE                                     -->
<!--                            All columns from STADDRESS (for contact and location info) -->
<!--                            CURRSTR from CURLIST                                       -->
<!--                            LANGUAGE_ID from STORELANG                                 -->
<!-- ===================================================================================== -->

<!-- ========================================================================================== -->
<!-- This SQL will return the data of the OnlineStore noun for all the stores.                  -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the summary of all the OnlineStores in STORE -->
	name=/OnlineStore
	sql_key_processor=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.processor.OnlineStoreFilterKeyProcessor
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$, STOREENT.$COLS:STOREENT_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID <> 0 and
						STOREENT.MARKFORDELETE <> 1
		ORDER BY STOREENT.IDENTIFIER
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================== -->
<!-- This SQL will return the data of the OnlineStore noun for the specified unique identifier. -->
<!-- Multiple results are returned if multiple identifiers are specified.                       -->
<!-- @param UniqueID The identifier of the store to retrieve.                                   -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the summary of one OnlineStore in STORE -->
	name=/OnlineStore[StoreIdentifier[(UniqueID=)]]
	sql_key_processor=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.processor.OnlineStoreFilterKeyProcessor
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$, STOREENT.$COLS:STOREENT_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STOREENT.MARKFORDELETE <> 1 and
						STORE.STORE_ID in (?UniqueID?)
		ORDER BY STOREENT.IDENTIFIER
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================== -->
<!-- This SQL will return the data of the OnlineStore noun for the specified search criteria.   -->
<!-- Multiple results are returned if there are multiple matches.                               -->
<!-- @param ATTR_CNDS The search criteria.                                                      -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the summary of one OnlineStore in STORE -->
	name=/OnlineStore[search()]
	sql_key_processor=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.processor.OnlineStoreFilterKeyProcessor
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$, STOREENT.$COLS:STOREENT_ID$
		FROM            STORE, STOREENT, $ATTR_TBLS$
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID <> 0 and
						STOREENT.MARKFORDELETE <> 1 and
						STOREENT.$ATTR_CNDS$
		ORDER BY STOREENT.IDENTIFIER
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================== -->
<!-- This SQL will return the data of the OnlineStore noun for the specified name identifier.   -->
<!-- Multiple results are returned if there are multiple matches.                               -->
<!-- @param NameIdentifier The name of the store to retrieve.                                   -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the summary of one OnlineStore in STORE -->
	name=/OnlineStore[StoreIdentifier[ExternalIdentifier[(NameIdentifier=)]]]
	sql_key_processor=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.processor.OnlineStoreFilterKeyProcessor
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$, STOREENT.$COLS:STOREENT_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID <> 0 and
						STOREENT.MARKFORDELETE <> 1 and
						STOREENT.IDENTIFIER = ?NameIdentifier?
		ORDER BY STOREENT.IDENTIFIER
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================== -->
<!-- This SQL will return the data of the OnlineStore noun for the specified name identifier.   -->
<!-- Multiple results are returned if there are multiple matches.                               -->
<!-- @param NameIdentifier The name of the store to retrieve.                                   -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the summary of one OnlineStore in STORE -->
	name=/OnlineStore[StoreIdentifier[ExternalIdentifier[(contains(NameIdentifier,))]]]
	sql_key_processor=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.processor.OnlineStoreFilterKeyProcessor
	base_table=STOREENT
	dbtype=db2
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$, STOREENT.$COLS:STOREENT_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID <> 0 and
						STOREENT.MARKFORDELETE <> 1 and
						(UPPER(STOREENT.IDENTIFIER) LIKE UPPER(CAST(?NameIdentifier? AS VARCHAR(254))) ESCAPE '+')
		ORDER BY STOREENT.IDENTIFIER
	
	dbtype=any
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$, STOREENT.$COLS:STOREENT_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID <> 0 and
						STOREENT.MARKFORDELETE <> 1 and
						(UPPER(STOREENT.IDENTIFIER) LIKE UPPER(?NameIdentifier?) ESCAPE '+')
		ORDER BY STOREENT.IDENTIFIER
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================== -->
<!-- This SQL will return the data of the OnlineStore noun for the specified name identifier.   -->
<!-- Multiple results are returned if there are multiple matches.                               -->
<!-- @param NameIdentifier The name of the store to retrieve.                                   -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the summary of one OnlineStore in STORE -->
	name=/OnlineStore[StoreIdentifier[ExternalIdentifier[(starts-with(NameIdentifier,))]]]
	sql_key_processor=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.processor.OnlineStoreFilterKeyProcessor
	base_table=STOREENT
	dbtype=db2
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$, STOREENT.$COLS:STOREENT_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID <> 0 and
						STOREENT.MARKFORDELETE <> 1 and
						(UPPER(STOREENT.IDENTIFIER) LIKE UPPER(CAST(?NameIdentifier? AS VARCHAR(254))) ESCAPE '+')
		ORDER BY STOREENT.IDENTIFIER
	
	dbtype=any
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$, STOREENT.$COLS:STOREENT_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID <> 0 and
						STOREENT.MARKFORDELETE <> 1 and
						(UPPER(STOREENT.IDENTIFIER) LIKE UPPER(?NameIdentifier?) ESCAPE '+')
		ORDER BY STOREENT.IDENTIFIER
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================== -->
<!-- This SQL will return the data of the OnlineStore noun for the specified name identifier.   -->
<!-- Multiple results are returned if there are multiple matches.                               -->
<!-- @param NameIdentifier The name of the store to retrieve.                                   -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the summary of one OnlineStore in STORE -->
	name=/OnlineStore[StoreIdentifier[ExternalIdentifier[(ends-with(NameIdentifier,))]]]
	sql_key_processor=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.processor.OnlineStoreFilterKeyProcessor
	base_table=STOREENT
	dbtype=db2
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$, STOREENT.$COLS:STOREENT_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID <> 0 and
						STOREENT.MARKFORDELETE <> 1 and
						(UPPER(STOREENT.IDENTIFIER) LIKE UPPER(CAST(?NameIdentifier? AS VARCHAR(254))) ESCAPE '+')
		ORDER BY STOREENT.IDENTIFIER
	
	dbtype=any
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$, STOREENT.$COLS:STOREENT_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID <> 0 and
						STOREENT.MARKFORDELETE <> 1 and
						(UPPER(STOREENT.IDENTIFIER) LIKE UPPER(?NameIdentifier?) ESCAPE '+')
		ORDER BY STOREENT.IDENTIFIER
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get the SEO Page definitions for a store by PageName.
     @param ObjectTypeID  The object type ID associated to the page name.
     @param PageName	  The name of the page.
     @param UniqueID      The Unique ID of the store.
     Supported Access Profiles are IBM_Admin_SEOPageDefinition_Details 
     and IBM_Store_SEOPageDefinition_Details .
     =========================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/OnlineStore[ObjectTypeID= and PageName= and StoreIdentifier[UniqueID=]]
	base_table=STOREENT
	className=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.db.jdbc.OnlineStorePageDefinitionsSQLComposer
	sql=
		SELECT 
		    SEOPAGEDEF.$COLS:SEOPAGEDEF_ID$
		FROM
                    SEOPAGEDEF
        WHERE
                    SEOPAGEDEF.STOREENT_ID IN ($STOREPATH:view$) AND
		    SEOPAGEDEF.PAGENAME = ?PageName?
END_XPATH_TO_SQL_STATEMENT

<!-- ===========================================================================
		Get the SEO Page definitions for a content page in a store by PageId.
		@param UniqueID   The Unique ID of the store
		@param pageGroup  The name of content page group
		@param objectIdentifier	  The id of the page
		Supported Access Profile: IBM_Admin_SEOPageDefinition_Details 
		=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/OnlineStore[OnlineStoreIdentifier[UniqueID=] and SEOProperty[(ObjectIdentifier=) and pageGroup=]]
	base_table=STOREENT
	sql=
		SELECT 
			SEOPAGEDEF.$COLS:SEOPAGEDEF_ID$
		FROM
			SEOPAGEDEF, SEOPAGEDEFOVR
		WHERE
			SEOPAGEDEF.SEOPAGEDEF_ID = SEOPAGEDEFOVR.SEOPAGEDEF_ID AND
			SEOPAGEDEF.STOREENT_ID IN ($STOREPATH:view$) AND
			SEOPAGEDEFOVR.OBJECTTYPE = ?pageGroup? AND
			SEOPAGEDEFOVR.OBJECT_ID IN (?ObjectIdentifier?)
END_XPATH_TO_SQL_STATEMENT

<!-- ===========================================================================
		Get the SEO URL for a content page in a store by PageId.
		@param UniqueID   The Unique ID of the store
		@param TokenName  The tokenname of the url. For content page the value is StaticPagesToken
		@param TokenValue	 The tokenvalue of the url. The id of the page should be used for tokenvalue
		Supported Access Profile: IBM_ContentPage_Url_Details 
		=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/OnlineStore[OnlineStoreIdentifier[UniqueID=] and SEOURLType[TokenName= and TokenValue=]]
	base_table=STOREENT
	sql=
		SELECT 
			STOREENT.$COLS:STOREENT_UID$
		FROM
			STOREENT
		WHERE
			STOREENT.STOREENT_ID = ?UniqueID? 
		ORDER BY STOREENT.STOREENT_ID
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================== -->
<!-- This SQL will return the data of the OnlineStore noun for the specified search criteria.   -->
<!-- This will return all the static seo page url keywords for a given store id.
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the details of OnlineStoreConfiguredURL noun part in OnlineStore -->
	name=/OnlineStore[StoreIdentifier[UniqueID=]]
	base_table=STOREENT
	sql=
		SELECT 
			STOREENT.$COLS:STOREENT_UID$
		FROM
                     STOREENT
              WHERE
                     STOREENT.STOREENT_ID = ?UniqueID? 
              ORDER BY STOREENT.STOREENT_ID
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================================== -->
<!-- This SQL will return the data of the OnlineStore noun for the specified search criteria.   -->
<!-- This will return all the static seo page url keywords for the given list of SEOURL_ID.
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the details of OnlineStoreConfiguredURL noun part in OnlineStore -->
	name=/OnlineStore[SEOContentURL[URLKeyword[(URLKeywordID=)]]]
	base_table=STOREENT
	sql=
		SELECT 
			SEOURL.$COLS:SEOURL_ID$
		FROM
               SEOURL
              WHERE
                 SEOURL.SEOURL_ID IN (?URLKeywordID?)
              ORDER BY SEOURL.SEOURL_ID
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================================================== -->
<!-- This SQL will return the data of the OnlineStore noun for the specified search criteria.   	-->
<!-- This will return all stores related to the store with the specified unique identifier   		--> 
<!-- @param UniqueID The identifier of the related store.                                           -->
<!-- @param relationshipType The type of store relationship.                                        -->
<!-- ============================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/OnlineStore[OnlineStoreRelatedStores[StoreIdentifier[(UniqueID=)]]]
	sql_key_processor=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.processor.OnlineStoreFilterKeyProcessor	
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$, STOREENT.$COLS:STOREENT_ID$
		FROM            STORE, STOREENT, STOREREL 
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID = STOREREL.STORE_ID and
						STOREREL.RELATEDSTORE_ID = ?UniqueID? and
						STOREENT.MARKFORDELETE <> 1
		ORDER BY STOREENT.IDENTIFIER
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================== -->
<!-- This SQL is added for DataExtract. It returns the OnlineStore noun for the specified criteria. -->
<!-- This will return store data for the catalog asset store                                        --> 
<!-- ============================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the summary of one OnlineStore in STORE -->
	name=/OnlineStore[OnlineStoreIdentifier[(UniqueID=)]]/OnlineStoreRelatedStores[(@relationshipType=)]+IBM_Admin_RelatedStores_All
	base_table=STOREENT
	sql=
		SELECT          STORE.$COLS:STORE_ALL$, STOREENT.$COLS:STOREENT_ALL$, STOREREL.$COLS:STOREREL_ALL$
			FROM            STORE, STOREENT LEFT OUTER JOIN STOREREL ON (STOREENT.STOREENT_ID = STOREREL.STORE_ID AND STOREREL.STRELTYP_ID IN (?relationshipType?))
			WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN (?UniqueID?) and
						STOREENT.MARKFORDELETE <> 1
			ORDER BY STOREENT.IDENTIFIER, STOREREL.SEQUENCE
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================================== -->
<!-- OnlineStore Tables                                                                         -->
<!-- ========================================================================================== -->

<!-- Filter utility queries -->

BEGIN_SQL_STATEMENT
	name=IBM_Store_Filter_Not_In_StoreTypes
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN (?ENTITY_PKS?) and
						(STOREENT.MARKFORDELETE = 1 or STORE.STORETYPE NOT IN (?StoreTypes?) or
						((STOREENT.MEMBER_ID NOT IN (SELECT MBRROLE.ORGENTITY_ID FROM MBRROLE WHERE MBRROLE.ROLE_ID != -29 AND MBRROLE.MEMBER_ID = ?MemberId?)) and
						(NOT EXISTS (SELECT MBRROLE.ORGENTITY_ID FROM MBRROLE WHERE MBRROLE.ROLE_ID != -29 AND MBRROLE.MEMBER_ID = ?MemberId? AND MBRROLE.ORGENTITY_ID IN (SELECT MBRREL.ANCESTOR_ID FROM MBRREL WHERE MBRREL.DESCENDANT_ID = STOREENT.MEMBER_ID))))
						)
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=IBM_Store_Filter_Not_In_StoreTypes_For_RemoteConfiguration
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN (?ENTITY_PKS?) and
						(STOREENT.MARKFORDELETE = 1 or STORE.STORETYPE NOT IN (?StoreTypes?))
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=IBM_Store_Filter_Not_Null_StoreTypes
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN (?ENTITY_PKS?) and
						(STOREENT.MARKFORDELETE = 1 or STORE.STORETYPE IS NOT NULL or
						((STOREENT.MEMBER_ID NOT IN (SELECT MBRROLE.ORGENTITY_ID FROM MBRROLE WHERE MBRROLE.ROLE_ID != -29 AND MBRROLE.MEMBER_ID = ?MemberId?)) and
						(NOT EXISTS (SELECT MBRROLE.ORGENTITY_ID FROM MBRROLE WHERE MBRROLE.ROLE_ID != -29 AND MBRROLE.MEMBER_ID = ?MemberId? AND MBRROLE.ORGENTITY_ID IN (SELECT MBRREL.ANCESTOR_ID FROM MBRREL WHERE MBRREL.DESCENDANT_ID = STOREENT.MEMBER_ID))))
						)
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=IBM_Store_Filter_Get_Member_Roles
	base_table=MBRROLE
	sql=
		SELECT DISTINCT MBRROLE.$COLS:ROLE_ID$
		FROM            MBRROLE
		WHERE           MBRROLE.MEMBER_ID = ?MemberId?
END_SQL_STATEMENT

<!-- Association queries -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Store_Summary
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_SUMMARY$, STOREENT.$COLS:STOREENT_SUMMARY$
		FROM            STORE, STOREENT
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN ($ENTITY_PKS$) and
						STOREENT.MARKFORDELETE <> 1
		ORDER BY STOREENT.IDENTIFIER
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Store_Details_NoLanguage
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_DETAILS$, STOREENT.$COLS:STOREENT_DETAILS$, STDS.$COLS:STOREENTDS_DETAILS$
		FROM            STORE, STOREENT
				LEFT OUTER JOIN STOREENTDS STDS ON STOREENT.STOREENT_ID = STDS.STOREENT_ID
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN ($ENTITY_PKS$) and
						STOREENT.MARKFORDELETE <> 1
		ORDER BY STOREENT.IDENTIFIER
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Store_Details_Language
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_DETAILS$, STOREENT.$COLS:STOREENT_DETAILS$, STDS.$COLS:STOREENTDS_DETAILS$, CURLIST.$COLS:CURLIST_ALL$, STORELANG.$COLS:STORELANG_ALL$
		FROM            STORE, STOREENT
				LEFT OUTER JOIN STOREENTDS STDS ON (STOREENT.STOREENT_ID = STDS.STOREENT_ID and STDS.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				LEFT OUTER JOIN CURLIST ON STOREENT.STOREENT_ID = CURLIST.STOREENT_ID
				LEFT OUTER JOIN STORELANG ON STOREENT.STOREENT_ID = STORELANG.STOREENT_ID				
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN ($ENTITY_PKS$) and
						STOREENT.MARKFORDELETE <> 1
		ORDER BY STOREENT.IDENTIFIER
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Store_All_1_NoLanguage
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ALL$, STOREENT.$COLS:STOREENT_ALL$, STDS.$COLS:STOREENTDS_ALL$, STLOC.$COLS:STADDRESS_ALL$, STCONT.$COLS:STADDRESS_ALL$
		FROM            STORE, STOREENT
				LEFT OUTER JOIN STOREENTDS STDS ON STOREENT.STOREENT_ID = STDS.STOREENT_ID
				LEFT OUTER JOIN STADDRESS STLOC ON STDS.STADDRESS_ID_LOC = STLOC.STADDRESS_ID
				LEFT OUTER JOIN STADDRESS STCONT ON STDS.STADDRESS_ID_CONT = STCONT.STADDRESS_ID
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN ($ENTITY_PKS$) and
						STOREENT.MARKFORDELETE <> 1
		ORDER BY STOREENT.IDENTIFIER
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Store_All_1_Language
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ALL$, STOREENT.$COLS:STOREENT_ALL$, STDS.$COLS:STOREENTDS_ALL$, STLOC.$COLS:STADDRESS_ALL$, STCONT.$COLS:STADDRESS_ALL$
		FROM            STORE, STOREENT
				LEFT OUTER JOIN STOREENTDS STDS ON STOREENT.STOREENT_ID = STDS.STOREENT_ID and STDS.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
				LEFT OUTER JOIN STADDRESS STLOC ON STDS.STADDRESS_ID_LOC = STLOC.STADDRESS_ID
				LEFT OUTER JOIN STADDRESS STCONT ON STDS.STADDRESS_ID_CONT = STCONT.STADDRESS_ID
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN ($ENTITY_PKS$) and
						STOREENT.MARKFORDELETE <> 1
		ORDER BY STOREENT.IDENTIFIER
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Store_All_2
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ALL$, STOREENT.$COLS:STOREENT_ALL$, CURLIST.$COLS:CURLIST_ALL$
		FROM            STORE, STOREENT, CURLIST
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN ($ENTITY_PKS$) and
						STOREENT.MARKFORDELETE <> 1 and
						STORE.STORE_ID = CURLIST.STOREENT_ID
		ORDER BY STOREENT.IDENTIFIER
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Store_All_3
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ALL$, STOREENT.$COLS:STOREENT_ALL$, STORELANG.$COLS:STORELANG_ALL$
		FROM            STORE, STOREENT, STORELANG
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN ($ENTITY_PKS$) and
						STOREENT.MARKFORDELETE <> 1 and
						STORE.STORE_ID = STORELANG.STOREENT_ID
		ORDER BY STOREENT.IDENTIFIER
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Store_All_4
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ALL$, STOREENT.$COLS:STOREENT_ALL$, STOREREL.$COLS:STOREREL_ALL$
		FROM            STORE, STOREENT, STOREREL
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
						STORE.STORE_ID IN ($ENTITY_PKS$) and
						STOREENT.MARKFORDELETE <> 1 and
						STORE.STORE_ID = STOREREL.STORE_ID
		ORDER BY STOREENT.IDENTIFIER
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the language specific page definition description for 
     the resolved page definition ID. The language is specified as a control parameter. 
     =========================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_SEO_PageDefinitions
	base_table=STOREENT
	sql=
		SELECT 
			SEOPAGEDEF.$COLS:SEOAGEDEF_ALL$,
			SEOPAGEDEFDESC.$COLS:SEOPAGEDEFDESC_ALL$,
			STOREENT.$COLS:STOREENT_SUMMARY$
		FROM
			STOREENT,SEOPAGEDEF,SEOPAGEDEFDESC
		WHERE
			SEOPAGEDEF.SEOPAGEDEF_ID = SEOPAGEDEFDESC.SEOPAGEDEF_ID AND
			SEOPAGEDEF.SEOPAGEDEF_ID IN ($ENTITY_PKS$) AND
			SEOPAGEDEFDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) AND
			STOREENT.STOREENT_ID =  $CTX:STORE_ID$
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the language specific page definition description for 
     the resolved page definition ID. The language is specified as a control parameter.
     In addition the page definition description for store default language is also
     retrieved.
     =========================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_SEO_PageDefinitions_For_Store
	base_table=STOREENT
	sql=
		SELECT 
			SEOPAGEDEF.$COLS:SEOAGEDEF_ALL$,
			SEOPAGEDEFDESC.$COLS:SEOPAGEDEFDESC_ALL$,
			STOREENT.$COLS:STOREENT_SUMMARY$
		FROM
			STOREENT,SEOPAGEDEF,SEOPAGEDEFDESC
		WHERE
			SEOPAGEDEF.SEOPAGEDEF_ID = SEOPAGEDEFDESC.SEOPAGEDEF_ID AND
			SEOPAGEDEF.SEOPAGEDEF_ID IN ($ENTITY_PKS$) AND
			(SEOPAGEDEFDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) OR 
			SEOPAGEDEFDESC.LANGUAGE_ID IN (SELECT STORE.LANGUAGE_ID FROM STORE WHERE STORE.STORE_ID = $CTX:STORE_ID$)) AND
			STOREENT.STOREENT_ID =  $CTX:STORE_ID$
END_ASSOCIATION_SQL_STATEMENT
<!-- ===========================================================================
     Query to retrieve the language specific URL keyword for static pages for 
     the given store id.The language is specified as a control parameter.
     =========================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_SEO_URL_FOR_STATIC_PAGES
	base_table=SEOURL
	sql=
		SELECT 
			SEOURLKEYWORD.$COLS:SEOURLKEYWORD_SUMMARY$,
			SEOURL.$COLS:SEOURL_SUMMARY$
		FROM
                  SEOURL, SEOURLKEYWORD
              WHERE
              		SEOURLKEYWORD.STOREENT_ID IN ($ENTITY_PKS$) AND
                    SEOURLKEYWORD.SEOURL_ID = SEOURL.SEOURL_ID AND 
                    SEOURLKEYWORD.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) AND
                    SEOURL.TOKENNAME IN ($UNIQUE_IDS$) AND  
                    SEOURLKEYWORD.STATUS = 1
              ORDER BY SEOURLKEYWORD.SEOURL_ID
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the language specific URL keyword for static pages for 
     the given store id and it's parent stores.
     The language is specified as a control parameter. 
     =========================================================================== -->

     BEGIN_ASSOCIATION_SQL_STATEMENT 
	name=IBM_SEO_URL_Static_Page_Parent_Summary 
	base_table=SEOURLKEYWORD
	sql=   
		SELECT  
			SEOURLKEYWORD.$COLS:SEOURLKEYWORD_SUMMARY$, 
			SEOURL.$COLS:SEOURL_SUMMARY$  
		FROM  
	                   SEOURLKEYWORD JOIN SEOURL ON (SEOURLKEYWORD.SEOURL_ID = SEOURL.SEOURL_ID) 
                WHERE  
                           SEOURLKEYWORD.STOREENT_ID IN($STOREPATH:view$) AND 
                        SEOURLKEYWORD.STOREENT_ID NOT IN($UNIQUE_IDS$) AND 
                        SEOURL.TOKENNAME IN (SELECT SEOTOKENUSGTYPE.PRIMARYTOKEN FROM SEOTOKENUSGTYPE  
                        WHERE SEOTOKENUSGTYPE.STOREENT_ID IN ($STOREPATH:view$,0) AND  
                        SEOTOKENUSGTYPE.ISSTATIC  = 1) AND   
                        SEOURLKEYWORD.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) AND  
                        SEOURLKEYWORD.STATUS = 1   
               ORDER BY SEOURLKEYWORD.SEOURL_ID 
 END_ASSOCIATION_SQL_STATEMENT  

BEGIN_ASSOCIATION_SQL_STATEMENT 
	name=IBM_ContentPage_SEO_Details
	base_table=SEOURL
	sql=   
		SELECT 
			SEOURL.$COLS:SEOURL_ALL$, SEOURLKEYWORD.$COLS:SEOURLKEYWORD_ALL$
		FROM
			SEOURL JOIN SEOURLKEYWORD ON (SEOURL.SEOURL_ID = SEOURLKEYWORD.SEOURL_ID)
		WHERE
			SEOURLKEYWORD.STOREENT_ID IN ($ENTITY_PKS$) 
			AND TOKENNAME = 'StaticPagesToken' 
			AND TOKENVALUE IN ($UNIQUE_IDS$)
			AND SEOURLKEYWORD.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
			AND STATUS = 1
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the language specific URL keyword details for static pages for 
     the given URLKeywordIds.The language is specified as a control parameter.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_SEO_URL_Static_Page_Details
	base_table=STOREENT
	sql=
		SELECT 
			STOREENT.$COLS:STOREENT_UID$,
			SEOURL.$COLS:SEOURL_ALL$,
			SEOURLKEYWORD.$COLS:SEOURLKEYWORD_ALL$
		FROM
                    STOREENT,(SEOURL JOIN SEOURLKEYWORD ON(SEOURL.SEOURL_ID = SEOURLKEYWORD.SEOURL_ID)) 
              WHERE
                    SEOURLKEYWORD.SEOURL_ID IN($ENTITY_PKS$) AND
                    SEOURLKEYWORD.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) AND 
                    SEOURLKEYWORD.STATUS = 1 AND
                    STOREENT.STOREENT_ID = SEOURLKEYWORD.STOREENT_ID
              ORDER BY SEOURLKEYWORD.SEOURL_ID
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the Store Configuration data that is specific 
     Social Networks. 
     =========================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Store_Configuration
	base_table=STOREENT
	sql=
		SELECT STOREENT.$COLS:STOREENT_UID$, STORECONF.$COLS:STORECONF_ALL$
		FROM STOREENT, STORECONF
		WHERE STOREENT.STOREENT_ID = STORECONF.STOREENT_ID AND STORECONF.STOREENT_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the default catalog of the given store.
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Store_Default_Catalog
	base_table=STOREENT
	sql=
		SELECT DISTINCT STOREDEFCAT.$COLS:STOREDEFCAT_ALL$, STOREENT.$COLS:STOREENT_ALL$
		FROM STOREDEFCAT, STOREENT
		WHERE   STOREDEFCAT.STOREENT_ID = STOREENT.STOREENT_ID and
						STOREDEFCAT.STOREENT_ID IN ($ENTITY_PKS$) and
						STOREENT.MARKFORDELETE <> 1
						
		ORDER BY STOREENT.IDENTIFIER								
		
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- Infrastructure Access Profile Alias definition            -->
<!-- ========================================================= -->

BEGIN_PROFILE_ALIASES
  base_table=STOREENT
  IBM_Summary=IBM_Admin_Summary
END_PROFILE_ALIASES

BEGIN_PROFILE
  name=IBM_Admin_Summary
  BEGIN_ENTITY
    base_table=STOREENT
    associated_sql_statement=IBM_Store_Summary
    associated_sql_statement=IBM_Store_Default_Catalog        
  END_ENTITY
END_PROFILE

BEGIN_PROFILE
  name=IBM_Details
  BEGIN_ENTITY
    base_table=STOREENT
    associated_sql_statement=IBM_Store_Details_NoLanguage
    associated_sql_statement=IBM_Store_Configuration
  END_ENTITY
END_PROFILE

BEGIN_PROFILE
  name=IBM_Admin_Details  
  BEGIN_ENTITY
    base_table=STOREENT
    associated_sql_statement=IBM_Store_Details_Language
    associated_sql_statement=IBM_Store_Default_Catalog            
  END_ENTITY
END_PROFILE

BEGIN_PROFILE
  name=IBM_All
  BEGIN_ENTITY
    base_table=STOREENT
    associated_sql_statement=IBM_Store_All_1_NoLanguage
    associated_sql_statement=IBM_Store_All_2
    associated_sql_statement=IBM_Store_All_3
    associated_sql_statement=IBM_Store_All_4
  END_ENTITY
END_PROFILE

BEGIN_PROFILE
  name=IBM_Store_Conf
  BEGIN_ENTITY
    base_table=STOREENT
    associated_sql_statement=IBM_Store_Configuration
  END_ENTITY
END_PROFILE

BEGIN_PROFILE
  name=IBM_Store_All
  BEGIN_ENTITY
    base_table=STOREENT
    associated_sql_statement=IBM_Store_All_1_NoLanguage
    associated_sql_statement=IBM_Store_All_2
    associated_sql_statement=IBM_Store_All_3
    associated_sql_statement=IBM_Store_All_4
    associated_sql_statement=IBM_Store_Configuration
	associated_sql_statement=IBM_Store_Default_Catalog
  END_ENTITY
END_PROFILE

BEGIN_PROFILE
  name=IBM_Admin_All
  BEGIN_ENTITY
    base_table=STOREENT
    associated_sql_statement=IBM_Store_All_1_Language
    associated_sql_statement=IBM_Store_All_2
    associated_sql_statement=IBM_Store_All_3
    associated_sql_statement=IBM_Store_All_4
    associated_sql_statement=IBM_Store_Default_Catalog        
  END_ENTITY
END_PROFILE


<!-- ===========================================================================
     Definition for IBM_Admin_SEOPageDefinition_Details access profile.
     =========================================================================== -->

BEGIN_PROFILE
  name=IBM_Admin_SEOPageDefinition_Details
  BEGIN_ENTITY
   base_table=STOREENT
   className=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.graphbuilderservice.OnlineStorePageDefinitionsGraphComposer
   associated_sql_statement=IBM_SEO_PageDefinitions
   END_ENTITY
END_PROFILE


<!-- ===========================================================================
     Definition for IBM_Store_SEOPageDefinition_Details access profile.
     =========================================================================== -->

BEGIN_PROFILE
  name=IBM_Store_SEOPageDefinition_Details
  BEGIN_ENTITY
   base_table=STOREENT
   className=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.graphbuilderservice.OnlineStorePageDefinitionsGraphComposer
   associated_sql_statement=IBM_SEO_PageDefinitions_For_Store
   END_ENTITY
END_PROFILE
<!-- ===========================================================================
     Definition for IBM_Admin_SEO_Summary access profile.
     =========================================================================== -->

BEGIN_PROFILE
  name=IBM_Admin_SEO_Static_Page_Summary
  BEGIN_ENTITY
   base_table=STOREENT
   className=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.graphbuilderservice.OnlineStoreSEOContentURLStaticPageGraphComposer
   associated_sql_statement=IBM_Store_Summary
   associated_sql_statement=IBM_SEO_URL_FOR_STATIC_PAGES
  END_ENTITY
END_PROFILE

<!-- ===========================================================================
     Definition for IBM_Admin_SEO_Details access profile.
     =========================================================================== -->

BEGIN_PROFILE
  name=IBM_Admin_SEO_Static_Page_Details
  BEGIN_ENTITY
   base_table=STOREENT
   associated_sql_statement=IBM_SEO_URL_Static_Page_Details
  END_ENTITY
END_PROFILE

<!-- ===========================================================================
     Definition for IBM_PageComposer_Url_Details access profile.
     This profile is used for page composer static page 
     =========================================================================== -->
BEGIN_PROFILE
  name=IBM_ContentPage_Url_Details
  BEGIN_ENTITY
   base_table=STOREENT
   className=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.graphbuilderservice.OnlineStoreSEOURLContentPageGraphComposer
   associated_sql_statement=IBM_Store_Summary
   associated_sql_statement=IBM_ContentPage_SEO_Details
   END_ENTITY
END_PROFILE


