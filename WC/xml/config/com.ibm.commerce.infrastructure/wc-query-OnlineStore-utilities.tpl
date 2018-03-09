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
	
	<!-- SEOPAGEDEF table -->
	COLS:SEOPAGEDEF_ALL        = SEOPAGEDEF:*
	
	<!-- SEOPAGEDEFDESC table -->
	COLS:SEOPAGEDEFDESC_ALL        = SEOPAGEDEFDESC:*
	
	<!-- SEOPAGEDEFOVR table -->
	COLS:SEOPAGEDEFOVR_ALL        = SEOPAGEDEFOVR:*
	
	<!-- SEOURL table -->
	COLS:SEOURL_ALL        = SEOURL:*
	
	<!-- SEOURLKEYWORD table -->
	COLS:SEOURLKEYWORD_ALL        = SEOURLKEYWORD:*
	
	<!-- SEOPAGEDEFSUBPARAM table -->
	COLS:SEOPAGEDEFSUBPARAM_ALL = SEOPAGEDEFSUBPARAM:*
	
	<!-- SEOTOKENUSAGETYPE table -->
	COLS:SEOTOKENUSAGETYPE_ALL = SEOTOKENUSGTYPE:*

	<!-- SEOREDIRECT table -->
	COLS:SEOREDIRECT_ALL        = SEOREDIRECT:*
	
	<!-- SEOREDIRECTTRAFFIC table -->
	COLS:SEOREDIRECTTRAFFIC_ALL        = SEOREDIRECTTRAFFIC:*
	COLS:SEOURL_FORCACHE = SEOURL:SEOURL_ID, TOKENNAME, TOKENVALUE
	COLS:SEOURLKEYWORD_FORCACHE = SEOURLKEYWORD:SEOURLKEYWORD_ID, SEOURL_ID, URLKEYWORD, MOBILEURLKEYWORD, STATUS, LANGUAGE_ID, STOREENT_ID

	COLS:SEOREDIRECT_FORCACHE = SEOREDIRECT:*
	COLS:SEOURLKEYWORD_FORREDIRECT = SEOURLKEYWORD:SEOURLKEYWORD_ID, URLKEYWORD, MOBILEURLKEYWORD 
	
	<!-- STOREDEFCAT table -->
	COLS:STOREDEFCAT_ALL		= STOREDEFCAT:*
	
	<!-- STORECONF table -->
	COLS:STORECONF_ALL		= STORECONF:*
	
	<!-- PAGELAYOUT ID -->
	COLS:PAGELAYOUT_ID = PAGELAYOUT:PAGELAYOUT_ID
END_SYMBOL_DEFINITIONS

<!-- =========================================================================================================== -->
<!-- This SQL will return all the substitution parameters in the site.                                                   -->
<!-- =========================================================================================================== -->
BEGIN_SQL_STATEMENT
  base_table=SEOPAGEDEFSUBPARAM
  name=IBM_Select_SEO_Substitution_Parameters
  sql=
		SELECT 
			SEOPAGEDEFSUBPARAM.$COLS:SEOPAGEDEFSUBPARAM_ALL$
		FROM	
			SEOPAGEDEFSUBPARAM 
END_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return all the SEO token usage in the site.                                                   -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	base_table=SEOTOKENUSGTYPE
	name=/SEOTOKENUSGTYPE+IBM_Admin_Details
	sql=
		SELECT 
			SEOTOKENUSGTYPE.$COLS:SEOTOKENUSAGETYPE_ALL$
		FROM
			SEOTOKENUSGTYPE
END_XPATH_TO_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return all the SEO page definition entity by its unique ID 									-->
<!-- @param SEOPAGEDEF_ID The page definition ID.                             									-->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/SEOPAGEDEF[SEOPAGEDEF_ID=]+IBM_Admin_SEO
	base_table=SEOPAGEDEF
    sql=
		  select $COLS:SEOPAGEDEF_ALL$ from SEOPAGEDEF where SEOPAGEDEF_ID=?seopagedefId?
END_XPATH_TO_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return all the SEO page definition entity by its unique ID and language                       -->
<!-- @param SEOPAGEDEF_ID The page definition ID.                                                                -->
<!-- @param LANGUAGE_ID The language ID.		                                                                -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/SEOPAGEDEFDESC[SEOPAGEDEF_ID= and LANGUAGE_ID=]+IBM_Admin_SEO
	base_table=SEOPAGEDEFDESC
    sql=
		  select $COLS:SEOPAGEDEFDESC_ALL$ from SEOPAGEDEFDESC where SEOPAGEDEF_ID=?seopagedefId? and language_id=?langId?  
END_XPATH_TO_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will find and return page definitions that are overrides defined in the SEOPAGEDEFOVR table.       -->
<!-- @param SEOPAGEDEF_ID The page definition ID to look for in the SEOPAGEDEFOVR table.                         -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/SEOPAGEDEFOVR[SEOPAGEDEF_ID=]+IBM_Admin_SEO
	base_table=SEOPAGEDEFOVR
    sql=
		  select $COLS:SEOPAGEDEFOVR_ALL$ from SEOPAGEDEFOVR where SEOPAGEDEF_ID=?seopagedefId?
END_XPATH_TO_SQL_STATEMENT

<!-- ===================================================================================-->
<!-- This SQL will return the SEO URL based on its unique ID.							-->
<!-- @param SEOURL_ID The unique ID of the SEO URL.										-->
<!-- ===================================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/SEOURL[SEOURL_ID=]+IBM_Admin_SEO
	base_table=SEOURL
    sql=
		  select $COLS:SEOURL_ALL$ from SEOURL where SEOURL_ID=?seourlId?
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================-->
<!-- This SQL will return the SEO URL keyword based on the URL ID and the language specified.-->
<!-- @param SEOURL_ID The unique ID of the SEO URL.											 -->
<!-- @param LANGUAGE_ID The language ID of the SEO URL keyword.								 -->
<!-- ========================================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/SEOURLKEYWORD[SEOURL_ID= and LANGUAGE_ID=]+IBM_Admin_SEO
	base_table=SEOURLKEYWORD
    sql=
		  select $COLS:SEOURLKEYWORD_ALL$ from SEOURLKEYWORD where SEOURL_ID=?seourlId? and LANGUAGE_ID=?langId?
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================-->
<!-- This SQL will return the SEO URL keyword based on the URL ID specified.				 -->
<!-- @param SEOURL_ID The unique ID of the SEO URL.											 -->
<!-- ========================================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/SEOURLKEYWORD[SEOURL_ID=]+IBM_Admin_SEO
	base_table=SEOURLKEYWORD
    sql=
		  select $COLS:SEOURLKEYWORD_ALL$ from SEOURLKEYWORD where SEOURL_ID=?seourlId?
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Select all the catalog entry templates in the seopagedef table for a given
	store path.
	@param pageName The page name of the record to retrieve.
	@param objectId The ID of the object to retrieve.
	@param objectType The object type to return. For example Product or Category.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefForTemplate
	base_table=SEOPAGEDEF
	sql=
		select * from seopagedef left join seopagedefovr on seopagedef.seopagedef_id = seopagedefovr.seopagedef_id 
		where seopagedef.storeent_id in ($STOREPATH:view$) 
		and object_id = ?objectId? and seopagedef.pagename = ?pageName?	and objecttype=?objectType?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select all the catalog entry templates in the seopagedef table for a given
	store path with catalog realtion.
	@param pageName The page name of the record to retrieve.
	@param objectId The ID of the object to retrieve.
	@param objectType The object type to return. For example Product or Category.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefForCatalogTemplate
	base_table=SEOPAGEDEF
	sql=
		select * from seopagedef left join seopagedefovr on seopagedef.seopagedef_id = seopagedefovr.seopagedef_id 
		where seopagedef.storeent_id in ($STOREPATH:catalog$) 
		and object_id = ?objectId? and seopagedef.pagename = ?pageName?	and objecttype=?objectType?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select the seopagedef entry for a specific catalog entry in a store path.
	@param objectId The unique ID of the catalog entry.
	@param objectType The object type to return. For example Product or Category.
	@param pageName The page name of the record to retrieve .
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDef
	base_table=SEOPAGEDEF
	sql=
		select * from seopagedef left join seopagedefovr on seopagedef.seopagedef_id = seopagedefovr.seopagedef_id 
		where seopagedef.storeent_id in ($STOREPATH:catalog$) 
		and object_id = ?objectId? and seopagedef.pagename = ?pageName? and objecttype=?objectType?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select the seopagedef entry for a specific catalog group in a store path.
	@param objectId The unique ID of the catalog group. 
	@param objectType The type of object to retrieve.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefForCatgroup
	base_table=SEOPAGEDEF
	sql=
		select * from seopagedef left join seopagedefovr on seopagedef.seopagedef_id = seopagedefovr.seopagedef_id 
		where seopagedef.storeent_id in ($STOREPATH:catalog$) 
		and objecttype= ?objectType? and object_id = ?objectId? 
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the url keyword for a given catalog group.
	@param seopagedefId The unique ID of the seo page def record. 
	@param languageId The language ID to use. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefByIdAndLanguage
	base_table=seopagedef
	sql=
		select seopagedef.seopagedef_id, seopagedefdesc.language_id from seopagedef left join seopagedefdesc on seopagedef.seopagedef_id = seopagedefdesc.seopagedef_id where seopagedefdesc.language_id=?languageId? and seopagedef.seopagedef_id=?seopagedefId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the url for a given catalog entry or catalog group.
	@param objectId The unique ID of the object to retrieve. 
	@param languageId The language ID to retrieve.
	@param tokenName The type of token to use.
	@param tokenValue The value of the token to use. This is a catentry or catgroup ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOURL
	base_table=seourl
	sql=
		select * from seourl left join seourlkeyword on seourl.seourl_id = seourlkeyword.seourl_id where status=1 and tokenvalue=?tokenValue? and tokenname=?tokenName? and storeent_id in ($STOREPATH:catalog$)
END_SQL_STATEMENT


<!-- ====================================================================== 
	Selects the url ID for a catalog entry or catalog group for a given store.
	@param languageId The language ID to retrieve.
	@param tokenName The type of token to use.
	@param tokenValue The value of the token to use. This is a catentry or catgroup ID.
	@param storeId	The store ID to use.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_URLByStoreAndLanguageId
	base_table=seourl
	sql=
		select seourl_id, storeent_id from seourlkeyword where status =1 and language_id=?languageId? and storeent_id = ?storeId? and seourl_id in (select seourl_id from seourl where tokenvalue=?tokenValue? and tokenname =?tokenName?)
END_SQL_STATEMENT


<!-- ====================================================================== 
	Selects all the url IDs in all related stores for a catalog entry or catalog group for a given language.
	@param languageId The language ID to retrieve.
	@param tokenName The type of token to use.
	@param tokenValue The value of the token to use. This is a catentry or catgroup ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_URLByLanguageId
	base_table=seourl
	sql=
		select seourlkeyword_id, seourl_id, storeent_id from seourlkeyword where status =1 and language_id=?languageId? and storeent_id in ($STOREPATH:catalog$) and seourl_id in (select seourl_id from seourl where tokenvalue=?tokenValue? and tokenname =?tokenName?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects all the url IDs in all related stores for a static page for a given language.
	@param languageId The language ID to retrieve.
	@param tokenName The type of token to use.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_URLByLanguageIdForStaticPages
	base_table=seourl
	sql=
		select seourlkeyword_id, seourl_id, urlkeyword, mobileurlkeyword from seourlkeyword where status =1 and language_id=?languageId? and storeent_id in ($STOREPATH:view$) and seourl_id in (select seourl_id from seourl where tokenname =?tokenName?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects all the url IDs in all related stores for a static page for a given language.
	@param languageId The language ID to retrieve.
	@param tokenName The type of token to use.
	@param tokenValue The value of the token.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_URLByLanguageIdAndTokenValueForStaticPages
	base_table=seourl
	sql=
		select seourlkeyword_id, seourl_id, urlkeyword, mobileurlkeyword from seourlkeyword where status =1 and language_id=?languageId? and storeent_id in ($STOREPATH:view$) and seourl_id in (select seourl_id from seourl where tokenname =?tokenName? and tokenvalue=?tokenValue?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects all the url IDs in all related stores for a static page for the store default language.
	@param storeId The store ID.
	@param tokenName The type of token to use.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_URLByDefaultLanguageForStaticPages
	base_table=seourl
	sql=
		select seourlkeyword_id, seourl_id, storeent_id from seourlkeyword where status =1 and language_id=(select store.language_id from store where store.store_id = ?storeId?)
	    and storeent_id in ($STOREPATH:view$) and seourl_id in (select seourl_id from seourl where tokenname =?tokenName?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects all the url IDs in all related stores for a static page for the store default language.
	@param storeId The store ID.
	@param tokenName The type of token to use.
	@param tokenValue The type of token to use.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_URLByDefaultLanguageAndTokenValueForStaticPages
	base_table=seourl
	sql=
		select seourlkeyword_id, seourl_id, storeent_id from seourlkeyword where status =1 and language_id=(select store.language_id from store where store.store_id = ?storeId?)
	    and storeent_id in ($STOREPATH:view$) and seourl_id in (select seourl_id from seourl where tokenname =?tokenName? and tokenvalue=?tokenValue?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	This query performs a check to see if the keyword can be deleted.
	@param languageId The language ID to retrieve.
	@param tokenName The type of token to use.
	@param storeId The store ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_Keyword_Check
	base_table=seourl
	sql=
		select seourlkeyword_id, seourl_id from seourlkeyword where status =1
		and (language_id=?languageId? or language_id = (select store.language_id from store where store.store_id = ?storeId?)) 
		and storeent_id in ($STOREPATH:view$) and seourl_id in (select seourl_id from seourl where tokenname =?tokenName?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	This query performs a check to see if the keyword can be deleted.
	@param languageId The language ID to retrieve.
	@param tokenName The type of token to use.
	@param tokenValue The value of token.
	@param storeId The store ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_KeywordByTokenValue_Check
	base_table=seourl
	sql=
		select seourlkeyword_id, seourl_id from seourlkeyword where status =1
		and (language_id=?languageId? or language_id = (select store.language_id from store where store.store_id = ?storeId?)) 
		and storeent_id in ($STOREPATH:view$) and seourl_id in (select seourl_id from seourl where tokenname =?tokenName? AND tokenvalue=?tokenValue?)
END_SQL_STATEMENT


<!-- ====================================================================== 
	This query retrieves the keyword Id based on input keyword and storeId
	@param storeId The store ID.
	@param keyword The URL keyword.
=========================================================================== -->

BEGIN_SQL_STATEMENT
	name=IBM_Select_Keyword
	base_table=seourlkeyword
	sql=
		select seourlkeyword_id from seourlkeyword where storeent_id=?storeId? and urlkeyword=?keyword?
END_SQL_STATEMENT

<!-- ====================================================================== 
	This query retrieves the keyword entity based on keyword ID
	@param keywordId The keyword ID.
=========================================================================== -->

BEGIN_SQL_STATEMENT
	name=IBM_Select_Keyword_ByID
	base_table=seourlkeyword
	sql=
		select * from seourlkeyword where seourlkeyword_id=?keywordId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	This query deletes the keyword entity based on keyword ID
	@param keywordId The keyword ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_Keyword_ByID
	base_table=seourlkeyword
	sql=
		delete from seourlkeyword where seourlkeyword_id in (?keywordId?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the seourl ID and seourlkeyword ID of a record from the seourlkeyword
	table given a urlkeyword string.
	@param urlkeyword The URL keyword string.
	@param languageId The language ID to use.
	@param storeId The store ID to use.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOURLKeywordIdByKeyword
	base_table=seourl
	sql=
		select seourlkeyword_id, seourl_id, storeent_id, urlkeyword from seourlkeyword where language_id = ?languageId? and urlkeyword=?urlkeyword? and storeent_id = ?storeId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the url keyword redirect rules that are obsolete.
	@param lastused The last time the url keyword was accessed. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=seoredirecttraffic
	name=IBM_Select_ObsoleteSEORedirect
	dbtype=oracle
		sql=
		SELECT 
				*
		FROM
				SEOREDIRECTTRAFFIC LEFT JOIN SEOREDIRECT on SEOREDIRECTTRAFFIC.seoredirect_id = SEOREDIRECT.seoredirect_id 
		WHERE
				SEOREDIRECTTRAFFIC.lastused <= TO_TIMESTAMP(?lastused?, 'YYYY-MM-DD HH24:MI:SS.FF')
				
	dbtype=any
	sql=
		SELECT 
				*
		FROM
				SEOREDIRECTTRAFFIC LEFT JOIN SEOREDIRECT on SEOREDIRECTTRAFFIC.seoredirect_id = SEOREDIRECT.seoredirect_id 
		WHERE
				SEOREDIRECTTRAFFIC.lastused <= ?lastused?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Deletes the url keyword redirect rules that are obsolete.
	@param lastused The last time the url keyword was accessed. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=seoredirect
	name=IBM_Delete_ObsoleteSEORedirect
	dbtype=oracle
		sql=delete from SEOREDIRECT where SEOREDIRECT.seoredirect_id in (select SEOREDIRECTTRAFFIC.seoredirect_id from SEOREDIRECTTRAFFIC LEFT JOIN SEOREDIRECT on SEOREDIRECTTRAFFIC.seoredirect_id = SEOREDIRECT.seoredirect_id where SEOREDIRECTTRAFFIC.lastused <= TO_TIMESTAMP(?lastused?, 'YYYY-MM-DD HH24:MI:SS.FF'))

	dbtype=any
	sql=delete from SEOREDIRECT where SEOREDIRECT.seoredirect_id in (select SEOREDIRECTTRAFFIC.seoredirect_id from SEOREDIRECTTRAFFIC LEFT JOIN SEOREDIRECT on SEOREDIRECTTRAFFIC.seoredirect_id = SEOREDIRECT.seoredirect_id where SEOREDIRECTTRAFFIC.lastused <= ?lastused?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Retrieves the SEO url keywords that are not used anymore in order to save the seourl_id for possible deletion.
	@param keyword_ids The keyword id (or comma separated list of ids) that are not used anymore. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=seourlkeyword
	name=IBM_Select_ObsoleteUrlKeywords
	sql=select * from seourlkeyword where seourlkeyword_id in (?keyword_ids?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Deletes the SEO url keywords that are not used anymore.
	@param keyword_ids The keyword id (or comma separated list of ids) that are not used anymore. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=seourlkeyword
	name=IBM_Delete_ObsoleteUrlKeywords
	sql=delete from seourlkeyword where seourlkeyword_id in (?keyword_ids?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Deletes the SEO url keywords that are inactive or expired.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=seourlkeyword
	name=IBM_Delete_InactiveExpiredUrlKeywords
	sql=delete from seourlkeyword where status in (0 , 2)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the possible SEOURL ids that maybe not used anymore. 
	@param seourl_ids The seourl id (or comma separated list of ids) which may not be used anymore. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=seourlkeyword
	name=IBM_Check_SEOURLIsUsed
	sql=
		SELECT seourlkeyword_id, seourl_id FROM seourlkeyword WHERE seourl_id in (?seourl_ids?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Retrieves the SEOURLKeywords data based on seourl_ids. 
	@param seourl_ids The seourl id (or comma separated list of ids) which may not be used anymore. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=seourlkeyword
	name=IBM_Select_SEOUrlKeywords
	sql=
		SELECT * FROM seourlkeyword WHERE seourl_id in (?seourl_ids?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Retrieves the SEOURLKeywords data with expired or inactive status. 
	@param status. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=seourlkeyword
	name=IBM_Select_InactiveExpiredUrlKeywords
	sql=
		SELECT * FROM seourlkeyword WHERE status in (0 , 2)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Deletes the SEOURL that are not used anymore.
	@param seourl_ids The seourl id (or comma separated list of ids) which may not be used anymore. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=seourl
	name=IBM_Delete_ObsoleteSeoUrl
	sql=delete from seourl where seourl_id in (?seourl_ids?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Retrieves the catalog entry ids of catentries that has been marked for deletion.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=catentry
	name=IBM_Select_MarkForDeleteCatentries
	sql=select catentry_id from catentry where markfordelete = 1
END_SQL_STATEMENT

<!-- ====================================================================== 
	Retrieves the catalog group ids of catgroups that has been marked for deletion.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=catgroup
	name=IBM_Select_MarkForDeleteCatgroups
	sql=select catgroup_id from catgroup where markfordelete = 1
END_SQL_STATEMENT

<!-- ====================================================================== 
	Retrieves the SEO urls that should be deleted because the object has been marked for deletion.
	@param tokenName The type of token to use.
	@param tokenValue The value of the token to use. This is a catentry or catgroup ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=seourl
	name=IBM_Select_SEOUrlForDeletedObjects
	sql=select seourl_id from seourl where tokenname = ?tokenName? and tokenvalue in (?tokenValues?)
END_SQL_STATEMENT


<!-- ====================================================================== 
	Select all columns from the seopagedefdesc table given a seopagedef ID 
	and a set of languages.
	@param seopagedefId The ID from the seopagedef table.
	@param langIds A list of language IDs.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefDesc
	base_table=SEOPAGEDEFDESC
	sql=
		select * from SEOPAGEDEFDESC where SEOPAGEDEF_ID=?seopagedefId? and language_id in (?langIds?)  
END_SQL_STATEMENT


<!-- ====================================================================== 
	Select all columns from the seopagedefdesc table given a seopagedef ID where
	the language ID is not in a list of languages.
	@param seopagedefId The ID from the seopagedef table.
	@param langIds A list of language IDs to exclude.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefDescNotInLang
	base_table=SEOPAGEDEFDESC
	sql=
		select * from SEOPAGEDEFDESC where SEOPAGEDEF_ID=?seopagedefId? and language_id not in (?langIds?)
END_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return a result if the input keyword already exists for a given store.			 -->
<!-- =========================================================================================================== -->

BEGIN_SQL_STATEMENT
	base_table=SEOURLKEYWORD
	name=IBM_Select_Unique_Keyword
	sql=SELECT 
			   COUNT(*) as COUNTER
		FROM 
			   SEOURLKEYWORD 
		WHERE 
			   (SEOURLKEYWORD.URLKEYWORD = ?URLKeyword? OR SEOURLKEYWORD.MOBILEURLKEYWORD = ?URLKeyword?)
			   AND SEOURLKEYWORD.STOREENT_ID IN ($STOREPATH:view$)
END_SQL_STATEMENT

<!-- ======================================================================================================================= -->
<!-- This SQL will return a result if a keyword is already defined for a given tokenName particular to a store. -->                                                 
<!-- ======================================================================================================================= -->

BEGIN_SQL_STATEMENT
	base_table=SEOURL
	name=IBM_Select_Keyword_For_TokenName
	sql=SELECT 
			   COUNT(*) as COUNTER
		FROM 
			   SEOURL JOIN SEOURLKEYWORD ON SEOURL.SEOURL_ID = SEOURLKEYWORD.SEOURL_ID
		WHERE 
			   SEOURL.TOKENNAME = ?TokenName? 
			   AND SEOURLKEYWORD.STOREENT_ID = ?StoreID?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Find all redirect rules pointing to a given SEO URL keyword
	@param Url_id ID of the SEO URL keyword
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_GET_REDIRECT_FOR_URL
	base_table=seourlkeyword
	sql=
		select * from seoredirect
		where seourlkwd_id_new=?Url_id?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Update all redirect rules pointing to a old SEO URL keyword to a new SEO URL keyword
	@param New_Url_id ID of the new SEO URL keyword
	@param New_Url_id ID of the old SEO URL keyword
	@param Url_list IDs of the SEO URL keywords that needs to be redirected to new URL
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_UPDATE_REDIRECT_FOR_URL
	base_table=seourlkeyword
	sql=
		update seoredirect
		set seourlkwd_id_new = ?New_Url_id?
		where seourlkwd_id_orig in (?Url_list?)
			and seourlkwd_id_new = ?Old_Url_id?
END_SQL_STATEMENT

<!-- ======================================================================================================================= -->
<!-- This SQL will update the redirect rules corresponding to the input keyword.											 -->
<!-- ======================================================================================================================= -->

BEGIN_SQL_STATEMENT
	base_table=SEOREDIRECT
	name=IBM_Update_Redirect_Rules
	sql=UPDATE 
			   SEOREDIRECT SET SEOREDIRECT.SEOURLKWD_ID_NEW = ?newKeywordID?
		WHERE 
			   SEOREDIRECT.SEOURLKWD_ID_ORIG IN (?originalKeywordID?) 
END_SQL_STATEMENT

<!-- ======================================================================================================================= -->
<!-- This SQL will return all the redirect rules that exist for the input keyword.											 -->
<!-- ======================================================================================================================= -->

BEGIN_SQL_STATEMENT
	base_table=SEOREDIRECT
	name=IBM_Select_Redirect_Rules
	sql=SELECT 
			   SEOREDIRECT.$COLS:SEOREDIRECT_ALL$ 
		FROM
			   SEOREDIRECT
		WHERE 
			   SEOREDIRECT.SEOURLKWD_ID_NEW = ?existingKeywordID? 
END_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the catalog override group entries.
     =========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Catalog_Override
	base_table=CATOVRGRP
	sql=
		SELECT 
			DISTINCT CATOVRGRP.CATOVRGRP_ID, CATOVRGRP.STOREENT_ID
		FROM 
			CATOVRGRP
		WHERE  
			CATOVRGRP.STOREENT_ID IN (?storeId?)						
END_SQL_STATEMENT


<!-- =========================================================================================================== -->
<!-- This SQL will return all the store URL keywords.   		                                                -->
<!-- @param STORETOKEN The token names used for the store tokens for various stores.							-->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	base_table=SEOURL
	name=/SEOURLKEYWORD[(STORETOKEN=)]+IBM_Admin_Details
	sql=
		SELECT 
			SEOURL.$COLS:SEOURL_FORCACHE$, 
			SEOURLKEYWORD.$COLS:SEOURLKEYWORD_FORCACHE$
		FROM
			SEOURL, SEOURLKEYWORD
		WHERE
			SEOURL.TOKENNAME IN (?STORETOKEN?) AND SEOURLKEYWORD.STOREENT_ID=0 AND 
			SEOURL.SEOURL_ID=SEOURLKEYWORD.SEOURL_ID 
END_XPATH_TO_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return the SEO URL Keyword based on the langId, storeId, tokenName and tokenValue specified.  -->
<!-- @param LANGID The language ID of the URL keyword.															 -->
<!-- @param TOKENNAME The token name for the URL keyword.														 -->
<!-- @param TOKENVALUE The token value for the URL keyword.	
<!-- @param STOREENT_ID The store entity ID.																		 -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	base_table=SEOURL
	name=/SEOURLKEYWORD[LANGUAGE_ID= AND TOKENNAME= AND TOKENVALUE= AND STOREENT_ID=]+IBM_Admin_Details
	sql=
		SELECT 
			SEOURLKEYWORD.$COLS:SEOURLKEYWORD_FORCACHE$, 
			SEOURL.$COLS:SEOURL_FORCACHE$
		FROM
			SEOURLKEYWORD, SEOURL

		WHERE 
			SEOURLKEYWORD.STOREENT_ID IN (?STOREENT_ID?) AND SEOURLKEYWORD.LANGUAGE_ID = ?LANGUAGE_ID?
			AND SEOURLKEYWORD.SEOURL_ID = SEOURL.SEOURL_ID 
			AND SEOURL.TOKENNAME=?TOKENNAME? AND SEOURL.TOKENVALUE=?TOKENVALUE? 
			AND SEOURLKEYWORD.STATUS=1

END_XPATH_TO_SQL_STATEMENT		

<!-- =========================================================================================================== -->
<!-- This SQL will return the SEO URL Keyword based on the langId, tokenName and tokenValue specified.  		 -->
<!-- @param LANGID The language ID of the URL keyword.															 -->
<!-- @param TOKENNAME The token name for the URL keyword.														 -->
<!-- @param TOKENVALUE The token value for the URL keyword.														 -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	base_table=SEOURL
	name=/SEOURLKEYWORD[LANGUAGE_ID= AND TOKENNAME= AND TOKENVALUE=]+IBM_Admin_Details
	sql=
		SELECT 
			SEOURLKEYWORD.$COLS:SEOURLKEYWORD_FORCACHE$, 
			SEOURL.$COLS:SEOURL_FORCACHE$
		FROM
			SEOURLKEYWORD, SEOURL

		WHERE 
			SEOURLKEYWORD.STOREENT_ID IN ($STOREPATH:catalog$) AND SEOURLKEYWORD.LANGUAGE_ID = ?LANGUAGE_ID?
			AND SEOURLKEYWORD.SEOURL_ID = SEOURL.SEOURL_ID 
			AND SEOURL.TOKENNAME=?TOKENNAME? AND SEOURL.TOKENVALUE=?TOKENVALUE? 
			AND SEOURLKEYWORD.STATUS=1

END_XPATH_TO_SQL_STATEMENT			

<!-- =========================================================================================================== -->
<!-- This SQL will return the token name and token value based on the keyword and store specified.-->
<!-- @param STOREENT_ID The store entity ID of the URL keyword.															 -->
<!-- @param URLKEYWORD The URL keyword being looked up.
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	base_table=SEOURLKEYWORD
	name=/SEOURLKEYWORD[STOREENT_ID= AND URLKEYWORD=]+IBM_Admin_Details
	sql=
		SELECT 
			SEOURLKEYWORD.$COLS:SEOURLKEYWORD_FORCACHE$,
			SEOURL.$COLS:SEOURL_FORCACHE$
		FROM
			SEOURLKEYWORD, SEOURL

		WHERE	(SEOURLKEYWORD.URLKEYWORD=?URLKEYWORD? OR SEOURLKEYWORD.MOBILEURLKEYWORD=?URLKEYWORD?)
			AND SEOURLKEYWORD.STOREENT_ID=?STOREENT_ID?
			AND SEOURL.SEOURL_ID = SEOURLKEYWORD.SEOURL_ID

END_XPATH_TO_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return the redirect rule traffic based on the original SEO URL keyword ID specified for a redirect rule.-->
<!-- @param SEOURLKWD_ID_ORIG The original SEO URL Keyword ID specified.            			 -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	base_table=SEOREDIRECTTRAFFIC
	name=/SEOREDIRECTTRAFFIC[SEOURLREDIRECT[SEOURLKWD_ID_ORIG=]]+IBM_Admin_Details
	sql=
		SELECT
			SEOREDIRECTTRAFFIC.$COLS:SEOREDIRECTTRAFFIC_ALL$ 
		FROM 
			SEOREDIRECTTRAFFIC
		WHERE
			SEOREDIRECT_ID IN (
			SELECT 
				SEOREDIRECT.SEOREDIRECT_ID
			FROM
				SEOURLKEYWORD, SEOREDIRECT, 
				(SELECT SEOREDIRECT.SEOREDIRECT_ID, SEOREDIRECT.SEOURLKWD_ID_NEW 
					FROM SEOREDIRECT 
					WHERE SEOREDIRECT.SEOURLKWD_ID_ORIG = ?SEOURLKWD_ID_ORIG?
				)  SEOREDIRECTVIEW
			WHERE
				SEOREDIRECT.SEOREDIRECT_ID = SEOREDIRECTVIEW.SEOREDIRECT_ID
				AND SEOURLKEYWORD.SEOURLKEYWORD_ID=SEOREDIRECTVIEW.SEOURLKWD_ID_NEW
			)
END_XPATH_TO_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return the redirect rule traffic based on the a redirect ID 									 -->
<!-- @param SEOREDIRECT_ID The redirect ID								           								 -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	base_table=SEOREDIRECTTRAFFIC
	name=/SEOREDIRECTTRAFFIC[SEOREDIRECT_ID=]+IBM_Admin_Details
	sql=
		SELECT
			SEOREDIRECTTRAFFIC.$COLS:SEOREDIRECTTRAFFIC_ALL$ 
		FROM 
			SEOREDIRECTTRAFFIC
		WHERE
			SEOREDIRECT_ID = ?SEOREDIRECT_ID?
END_XPATH_TO_SQL_STATEMENT


<!-- =========================================================================================================== -->
<!-- This SQL will return the redirect rule based on the a redirect ID 									 -->
<!-- @param SEOREDIRECT_ID The redirect ID								           								 -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	base_table=SEOREDIRECT
	name=/SEOREDIRECT[SEOREDIRECT_ID=]+IBM_Admin_Details
	sql=
		SELECT
			SEOREDIRECT.$COLS:SEOREDIRECT_ALL$ 
		FROM 
			SEOREDIRECT
		WHERE
			SEOREDIRECT_ID = ?SEOREDIRECT_ID?
END_XPATH_TO_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return the redirect rule based on the original SEO URL keyword ID specified.-->
<!-- @param SEOURLKWD_ID_ORIG The original SEO URL Keyword ID specified.            			 -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	base_table=SEOREDIRECT
	name=/SEOURLREDIRECT[SEOURLKWD_ID_ORIG=]+IBM_Admin_Details
	sql=
		SELECT 
			SEOREDIRECT.$COLS:SEOREDIRECT_FORCACHE$,
			SEOURLKEYWORD.$COLS:SEOURLKEYWORD_FORREDIRECT$
		FROM
			SEOURLKEYWORD, SEOREDIRECT, 
			(SELECT SEOREDIRECT.SEOREDIRECT_ID, SEOREDIRECT.SEOURLKWD_ID_NEW 
				FROM SEOREDIRECT 
				WHERE SEOREDIRECT.SEOURLKWD_ID_ORIG = ?SEOURLKWD_ID_ORIG?
			)  SEOREDIRECTVIEW
		WHERE
			SEOREDIRECT.SEOREDIRECT_ID = SEOREDIRECTVIEW.SEOREDIRECT_ID
			AND SEOURLKEYWORD.SEOURLKEYWORD_ID=SEOREDIRECTVIEW.SEOURLKWD_ID_NEW
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Select urlkeyword, mobileurlkeyword, seourlkwd_id_new, and seourlkwd_id_orig
	from the seourlkeyword and seoredirect tables given a seourlkeyword_id to
	map to the seourlkwd_id_orig
	@param urlkeywordId The ID (or comma separated list of ids) from the 
		urlkeyword table of the token to replace.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEORedirect
	base_table=SEOREDIRECT
	sql=
		select seourlkeyword.urlkeyword, seourlkeyword.mobileurlkeyword, seoredirect.seourlkwd_id_new, seoredirect.seourlkwd_id_orig from seourlkeyword left join seoredirect on seourlkeyword.seourlkeyword_id = seoredirect.seourlkwd_id_new where seourlkwd_id_orig in (?urlkeywordId?) and status = 1 order by seourlkwd_id_orig asc
END_SQL_STATEMENT


<!-- ====================================================================== 
	Selects a catalog entry's partnumber by its catentry ID.
	@param CATENTRY_ID The ID of the catalog entry.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_PartnumberByCatentryID
	base_table=CATENTRY
	sql=
		select partnumber from catentry where catentry_id = ?CATENTRY_ID?
END_SQL_STATEMENT


<!-- ====================================================================== 
	Selects a catalog group's partnumber by its catgroup ID.
	@param CATGROUP_ID The ID of the catalog group.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_IdentifierByCatgroupID
	base_table=CATGROUP
	sql=
		select identifier from catgroup where catgroup_id = ?CATGROUP_ID?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Looks for seo url records matching a certain keyword value in a given language
	@param keyword The keyword to look for.
	@param languageId The language ID to look for.
	@param storeentId The storeent ID to look for.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOURLKEYWORD_BY_KEYWORD
	base_table=seourlkeyword
	sql=
		select seourlkeyword.seourlkeyword_id from seourlkeyword where urlkeyword = ?keyword? and storeent_id = ?storeentId?
END_SQL_STATEMENT


<!-- ====================================================================== 
	Looks for seo url records matching a certain keyword value in a given 
	language in the asset store and current e-site. If called from an asset 
	store it will look in all e-sites under that asset store.
	@param keyword The keyword to look for.
	@param languageId The language ID to look for.
	@param storeId The current store this sql is being called from.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOURLKEYWORD_BY_KEYWORDALLSTORES
	base_table=seourlkeyword
	sql=
		select seourlkeyword.seourlkeyword_id from seourlkeyword where urlkeyword = ?keyword?
		and 
		( storeent_id in ($STOREPATH:catalog$)
		or 
		storeent_id in (select store_id from storerel where relatedstore_id in (?storeId?) and streltyp_id = -4))
END_SQL_STATEMENT

<!-- ====================================================================== 
	Looks for seo url records matching a certain seourl ID in a given language
	@param seourlId The keyword to look for.
	@param languageId The language ID to look for.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOURLByIdAndLanguage
	base_table=seourlkeyword
	sql=
		select seourl_id, language_id from seourlkeyword where seourl_id = ?seourlId? and language_Id = ?languageId? and status = 1 and storeent_id in ($STOREPATH:catalog$)
END_SQL_STATEMENT

<!-- ====================================================================== 
	This query is used to prefetch data for site map URLs for the catalog
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_SEO_Prefetch_Keywords_For_SiteMap
	base_table=SEOURL
	sql=SELECT SEOURLKEYWORD.SEOURLKEYWORD_ID,SEOURLKEYWORD.SEOURL_ID,SEOURL.TOKENNAME,SEOURL.TOKENVALUE,SEOURLKEYWORD.LANGUAGE_ID,SEOURLKEYWORD.STOREENT_ID,SEOURLKEYWORD.URLKEYWORD,SEOURLKEYWORD.MOBILEURLKEYWORD,SEOURLKEYWORD.STATUS 
		FROM SEOURLKEYWORD,SEOURL WHERE SEOURLKEYWORD.STOREENT_ID IN ($STOREPATH:catalog$) AND SEOURLKEYWORD.LANGUAGE_ID IN (?LANGUAGE_ID?) AND SEOURL.TOKENNAME IN (?TOKENNAME?) AND SEOURL.TOKENVALUE IN (?TOKENVALUE?) 
		AND SEOURLKEYWORD.SEOURL_ID = SEOURL.SEOURL_ID AND SEOURLKEYWORD.STATUS=1	
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select The store ID owning a catalog entry with a given ID.
	@param catentryId The catalog entry id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogEntryOwningStore
	base_table=STORECENT
	sql=
		select storeent_id from storecent where catentry_id = ?catentryId?
END_SQL_STATEMENT


<!-- ====================================================================== 
	Select The store ID owning a catalog group with a given ID.
	@param catgroupId The catalog group id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogGroupOwningStore
	base_table=STORECGRP
	sql=
		select storeent_id from storecgrp where catgroup_id = ?catgroupId?
END_SQL_STATEMENT

<!-- ===========================================================================
  Query to retrieve the active URL of a store
	@param tokenName The type of token to use.
	@param tokenValue The value of the token to use. This is a catentry or catgroup ID.
	@param languageId The language ID to retrieve.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_SEO_GetActiveUrlId_For_Store
	base_table=SEOURLKEYWORD
	sql=
		SELECT 
			SEOURLKEYWORD.STOREENT_ID, SEOURLKEYWORD.URLKEYWORD, SEOURLKEYWORD.SEOURL_ID
		FROM
			SEOURL, SEOURLKEYWORD
		WHERE
			SEOURL.SEOURL_ID = SEOURLKEYWORD.SEOURL_ID
				AND TOKENNAME=?tokenName?
				AND TOKENVALUE=?tokenValue?
				AND STOREENT_ID in ($STOREPATH:catalog$)
				AND LANGUAGE_ID=?languageId?
				AND STATUS=1
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select all the default catalog for a given store path.

=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/STOREDEFCAT+IBM_Admin_Select_Default_Catalog_For_Store_Path
	base_table=STOREDEFCAT
	sql=
		SELECT DISTINCT STOREDEFCAT.$COLS:STOREDEFCAT_ALL$
		FROM STOREDEFCAT
		WHERE 
					STOREDEFCAT.STOREENT_ID IN ($STOREPATH:catalog$)
		
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Select the default catalog for a particular store

=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/STOREDEFCAT[STOREENT_ID=]+IBM_Admin_DefaultCatalog
	base_table=STOREDEFCAT
    sql=
		  SELECT $COLS:STOREDEFCAT_ALL$ FROM STOREDEFCAT WHERE STOREENT_ID=?storeId?
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Gets the manufacturer details (name,partnumber) for the specified catalog entry.
	@param objectId The catalog entry identifier. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=CATENTRY
	name=IBM_Manufacturer_ByCatEntryID
	sql= select CATENTRY.MFNAME,CATENTRY.MFPARTNUMBER FROM CATENTRY WHERE CATENTRY_ID=?objectId?
END_SQL_STATEMENT


<!-- ====================================================================== 
	Gets the language specific category keyword for the input category.
	@param objectId The catalog group identifier. 
	@param langId The language identifier.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=CATGRPDESC
	name=IBM_CatgrpKeyword_ByID
	sql= select CATGRPDESC.KEYWORD FROM CATGRPDESC 
		WHERE LANGUAGE_ID=?langId? AND CATGROUP_ID=?objectId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Gets the catalog group ID from the identifier and member id.
	@param Identifier The identifier for the catalog group
	@param MemberId The member_id for the catalog group.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=CATGROUP
	name=FindCategoryIDByIdentifier
	sql= select * from CATGROUP where IDENTIFIER=?Identifier? and MEMBER_ID=?MemberId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Gets the catalog entry ID from the part number and member id.
	@param PartNumber The catalog entry partnumber.
	@param MemberId The member_id for the catalog entry.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=CATENTRY
	name=FindCatentryIDByPartNumber
	sql= select * from CATENTRY where PARTNUMBER=?PartNumber? and MEMBER_ID=?MemberId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Gets the page layout ID from the name and storeent id.
	@param LayoutName The name of the page layout .
	@param MemberId The storeent_id for the page layout.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=PAGELAYOUT
	name=FindPageLayoutByNameAndMemberId
	sql= select PAGELAYOUT.$COLS:PAGELAYOUT_ID$ from PAGELAYOUT where NAME=?LayoutName? and STOREENT_ID=?MemberId?
END_SQL_STATEMENT


<!-- =========================================================================================================== -->
<!-- This SQL will return the store configuration based on the store ID and configuration name specified.       -->
<!-- @param STOREENT_ID The store IDs for which the parameter is to be retrieved							-->
<!-- @param NAME The name of the parameter to be retrieved.						-->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	base_table=STORECONF
	name=/STORECONF[(STOREENT_ID=) AND NAME=]+IBM_IdResolve
	sql=
		SELECT 
			STORECONF.$COLS:STORECONF_ALL$ 
		FROM
			STORECONF
		WHERE
			STORECONF.STOREENT_ID IN (?STOREENT_ID?) AND NAME = ?NAME? 
END_XPATH_TO_SQL_STATEMENT

<!-- Online store filter utility queries -->
BEGIN_SQL_STATEMENT
	name=IBM_Filter_Store_Not_Using_FlexFlowOptions
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$
		FROM 			STORE, STOREENT 
		WHERE 			STORE.STORE_ID = STOREENT.STOREENT_ID and 
						STORE.STORE_ID IN (?ENTITY_PKS?) and 
						STORE.STORE_ID  NOT IN (SELECT DMEMSPOTDEF.STOREENT_ID FROM DMEMSPOTDEF, EMSPOT WHERE DMEMSPOTDEF.EMSPOT_ID = EMSPOT.EMSPOT_ID AND EMSPOT.NAME IN (?EmspotName?) AND DMEMSPOTDEF.CONTENTTYPE='FeatureEnabled' AND DMEMSPOTDEF.CONTENT='true')
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=IBM_Filter_Store_Using_FlexFlowOptions
	base_table=STOREENT
	sql=
		SELECT DISTINCT STORE.$COLS:STORE_ID$
		FROM 			STORE, STOREENT 
		WHERE 			STORE.STORE_ID = STOREENT.STOREENT_ID and 
						STORE.STORE_ID IN (?ENTITY_PKS?) and 
						STORE.STORE_ID IN (SELECT DMEMSPOTDEF.STOREENT_ID FROM DMEMSPOTDEF, EMSPOT WHERE DMEMSPOTDEF.EMSPOT_ID = EMSPOT.EMSPOT_ID AND EMSPOT.NAME IN (?EmspotName?) AND DMEMSPOTDEF.CONTENTTYPE='FeatureEnabled' AND DMEMSPOTDEF.CONTENT='true')
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Get all the languages on the server                                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_ALL_LANGUAGE
	base_table=language
	sql=
	SELECT language_id,localename from language
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Get all the stores on the server                                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_ALL_STORE
	base_table=store
	sql=
	SELECT store_id, directory from store
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Get all the currencies on the server                                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_ALL_CURRENCY
	base_table=curlist
	sql=
	SELECT distinct currstr from curlist
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Get all the catalogs on the server                                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_ALL_CATALOG
	base_table=catalog
	sql=
	SELECT distinct catalog_id, identifier from catalog
END_SQL_STATEMENT
