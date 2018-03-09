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
	COLS:STORE_ALL          = STORE:*

	<!-- STOREENT table -->
	COLS:STOREENT_DETAILS   = STOREENT:STOREENT_ID, MEMBER_ID, IDENTIFIER, OPTCOUNTER
	COLS:STOREENT_ALL       = STOREENT:*

	<!-- STOREENTDS table -->
	COLS:STOREENTDS_DETAILS = STOREENTDS:STOREENT_ID, LANGUAGE_ID, DISPLAYNAME, DESCRIPTION, OPTCOUNTER
	COLS:STOREENTDS_ALL     = STOREENTDS:*

	<!-- STADDRESS table -->
	COLS:STADDRESS_ALL      = STADDRESS:*

	<!-- STORELANG table -->
	COLS:STORELANG_ALL      = STORELANG:*

	<!-- CURLIST table -->
	COLS:CURLIST_ALL        = CURLIST:*
	
	<!-- SEOURLKEYWORD table -->
	COLS:SEOURLKEYWORD_ALL	= SEOURLKEYWORD:*
	
	<!-- SEOURL table -->
	COLS:SEOURL_ALL = SEOURL:*

	<!-- STOREDEFCAT table -->
	COLS:STOREDEFCAT_ALL	= STOREDEFCAT:*
	
	<!-- SEOPAGEDEF table-->
	COLS:SEOPAGEDEF = SEOPAGEDEF:* 
	
	<!-- SEOPAGEDEFDESC table-->
	COLS:SEOPAGEDEFDESC = SEOPAGEDEFDESC:*
	
	<!-- SEOPAGEDEFOVR table -->
	COLS:SEOPAGEDEFOVR = SEOPAGEDEFOVR:*

END_SYMBOL_DEFINITIONS




BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the description information from STOREENTDS for the OnlineStore part OnlineStoreDescription -->
	name=/OnlineStoreDescription[StoreIdentifier[(UniqueID=)]]+IBM_Admin_Details
	base_table=STOREENTDS
	sql=
		SELECT DISTINCT STOREENTDS.$COLS:STOREENTDS_DETAILS$
		FROM            STORE, STOREENT, STOREENTDS
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
				STOREENTDS.STOREENT_ID = STOREENT.STOREENT_ID and
				STORE.STORE_ID <> 0 and
				STOREENT.MARKFORDELETE <> 1 and
				STORE.STORE_ID in (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the contact information from STADDRESS for the OnlineStore part OnlineStoreContact -->
	name=/OnlineStoreContact[StoreIdentifier[(UniqueID=)]]+IBM_Admin_All
	base_table=STOREENTDS
	sql=
		SELECT DISTINCT STOREENTDS.$COLS:STOREENTDS_ALL$,STADDRESS.$COLS:STADDRESS_ALL$
		FROM            STORE, STOREENT, STOREENTDS
				LEFT OUTER JOIN STADDRESS ON STOREENTDS.STADDRESS_ID_CONT = STADDRESS.STADDRESS_ID
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
				STOREENTDS.STOREENT_ID = STOREENT.STOREENT_ID and
				STORE.STORE_ID <> 0 and
				STOREENT.MARKFORDELETE <> 1 and
				STORE.STORE_ID in (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the location information from STADDRESS for the OnlineStore part OnlineStoreLocation -->
	name=/OnlineStoreLocation[StoreIdentifier[(UniqueID=)]]+IBM_Admin_All
	base_table=STOREENTDS
	sql=
		SELECT DISTINCT STOREENTDS.$COLS:STOREENTDS_ALL$,STADDRESS.$COLS:STADDRESS_ALL$
		FROM            STORE, STOREENT, STOREENTDS
				LEFT OUTER JOIN STADDRESS ON STOREENTDS.STADDRESS_ID_LOC = STADDRESS.STADDRESS_ID
		WHERE           STORE.STORE_ID = STOREENT.STOREENT_ID and
				STOREENTDS.STOREENT_ID = STOREENT.STOREENT_ID and
				STORE.STORE_ID <> 0 and
				STOREENT.MARKFORDELETE <> 1 and
				STORE.STORE_ID in (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /OnlineStore[SEOContentURLs[(UniqueID=)]]									    -->
<!-- AccessProfile:	IBM_OnlineStoreKeyword_Update -->
<!-- Gets the SEO URL keyword entities using the UniqueIDs provided as parameter -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique id of the URL to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/OnlineStore[SEOContentURLs[(UniqueID=)]]+IBM_OnlineStoreKeyword_Update
	base_table=SEOURL
	sql=
		SELECT SEOURLKEYWORD.$COLS:SEOURLKEYWORD_ALL$,SEOURL.$COLS:SEOURL_ALL$
		FROM   SEOURLKEYWORD,SEOURL
		WHERE  SEOURL.SEOURL_ID = SEOURLKEYWORD.SEOURL_ID AND
		       SEOURL.SEOURL_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /OnlineStore[DefaultCatalog[(UniqueId=)]]									    -->
<!-- AccessProfile:	IBM_DefaultCatalog_Update -->
<!-- Gets the default catalog entities using the UniqueIDs provided as parameter -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique id of the URL to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/OnlineStore[DefaultCatalog[(UniqueID=)]]+IBM_DefaultCatalog_Update
	base_table=STOREDEFCAT
	sql=
		SELECT STOREDEFCAT.$COLS:STOREDEFCAT_ALL$
		FROM   STOREDEFCAT
		WHERE  STOREDEFCAT.STOREDEFCAT_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /OnlineStore[StoreIdentifier[UniqueID=] AND TokenName=]			-->
<!-- AccessProfile:	IBM_IdResolve -->
<!-- Resolves the SEO URL based on the token name and store identifier -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID    Unique id of Online Store -->   
<!-- @param TokenName   The token name associated with the URL Keyword -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/OnlineStore[StoreIdentifier[UniqueID=] AND TokenName=]+IBM_IdResolve
	base_table=SEOURL
	sql=
		SELECT SEOURL.$COLS:SEOURL_ALL$
		FROM   SEOURL JOIN SEOURLKEYWORD ON SEOURL.SEOURL_ID = SEOURLKEYWORD.SEOURL_ID
		WHERE  SEOURLKEYWORD.STOREENT_ID = ?UniqueID? 
		AND SEOURL.TOKENNAME = ?TokenName?
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /OnlineStore[StoreIdentifier[UniqueID=] AND TokenName= AND URLKEYWORD=]			-->
<!-- AccessProfile:	IBM_IdResolve -->
<!-- Resolves the SEO URL based on the token name and store identifier -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID    Unique id of Online Store -->   
<!-- @param TokenName   The token name associated with the URL Keyword -->
<!-- @param TokenValue   The keyword associated with the URL Keyword -->
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/OnlineStore[StoreIdentifier[UniqueID=] AND TokenName= AND TokenValue=]+IBM_IdResolve
	base_table=SEOURL
	sql=
		SELECT SEOURL.$COLS:SEOURL_ALL$
		FROM   SEOURL JOIN SEOURLKEYWORD ON SEOURL.SEOURL_ID = SEOURLKEYWORD.SEOURL_ID
		WHERE  SEOURLKEYWORD.STOREENT_ID = ?UniqueID? 
		AND SEOURL.TOKENNAME = ?TokenName?
		AND SEOURL.TOKENVALUE = ?TokenValue?
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /OnlineStore/SEOPageDefinitions[@pageGroup= and ObjectIdentifier= and ParentStoreIdentifier[UniqueID=]] -->
<!-- AccessProfile:	IBM_Admin_SEOPageDef_Update -->
<!-- Find the SEO page definition based on the page name and owning store identifier -->
<!-- Access profile includes all columns from the table. -->
<!-- @param pageGroup   The object type of SEO page definition override-->  
<!-- @param ObjectIdentifier The object id of the SEO page definition override 
<!-- @param UniqueID    The owning store identifier -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/OnlineStore/SEOPageDefinitions[@pageGroup= and ObjectIdentifier= and ParentStoreIdentifier[UniqueID=]]+IBM_Admin_SEOPageDef_Update
	base_table=SEOPAGEDEF
	className=com.ibm.commerce.infrastructure.facade.server.services.dataaccess.db.jdbc.SEOContentPageDefinitionsSQLComposer
	sql=
		SELECT SEOPAGEDEF.$COLS:SEOPAGEDEF$, SEOPAGEDEFDESC.$COLS:SEOPAGEDEFDESC$, SEOPAGEDEFOVR.$COLS:SEOPAGEDEFOVR
		FROM SEOPAGEDEF LEFT JOIN SEOPAGEDEFOVR ON SEOPAGEDEFOVR.SEOPAGEDEF_ID = SEOPAGEDEF.SEOPAGEDEF_ID
		                LEFT JOIN SEOPAGEDEFDESC ON SEOPAGEDEF.SEOPAGEDEF_ID = SEOPAGEDEFDESC.SEOPAGEDEF_ID 		                
END_XPATH_TO_SQL_STATEMENT
