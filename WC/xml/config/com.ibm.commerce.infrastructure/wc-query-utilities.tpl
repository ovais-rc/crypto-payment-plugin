<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2012, 2017 All Rights Reserved.           -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->

<!-- ========================================================================= -->
<!--  Determine all facetable columns registered for search                    -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SEARCH_COLUMN_DISPLAY_NAMES
	base_table=SRCHATTRDESC
	sql=
	SELECT SRCHATTR_ID,DISPLAYNAME
	from SRCHATTRDESC
	where 
		 SRCHATTRDESC.SRCHATTR_ID IN (?srchattrIdList?)
		 and 
		 LANGUAGE_ID=?languageId?
		 ORDER BY DISPLAYNAME
END_SQL_STATEMENT

<!-- ====================================================================== 
<!--	Find if given master catalog is configured in SRCHCONF.
<!-- ======================================================================
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHCONF_BY_INDEXSCOP
	base_table=SRCHCONF
	sql=
		SELECT COUNT(*) AS COUNT
			FROM SRCHCONF
		WHERE INDEXSCOPE=?masterCatalogId?
END_SQL_STATEMENT

<!-- ====================================================================== 
<!--	Find store supported languages.
<!-- ======================================================================
BEGIN_SQL_STATEMENT
	name=SELECT_STORE_SUPPORTED_LANGUAGES
	base_table=LANGUAGE
	sql=
		SELECT l.language_id 
			FROM language l, storelang sl, storecat sc, catalog c 
		WHERE c.catalog_id=?masterCatalogId? AND
			c.catalog_id=sc.catalog_id AND
			sc.storeent_id=sl.storeent_id AND
			sc.mastercatalog='1' AND
			sl.language_id=l.language_id
END_SQL_STATEMENT

<!-- ====================================================================== 
<!--	Find related store supported languages.
<!-- ======================================================================
BEGIN_SQL_STATEMENT
	name=SELECT_RELATED_STORE_SUPPORTED_LANGUAGES
	base_table=LANGUAGE
	sql=
		SELECT distinct l.language_id, l.localename 
			FROM language l, storelang sl, storecat sc, catalog c, storerel sr 
		WHERE c.catalog_id=?masterCatalogId? AND 
			c.catalog_id=sc.catalog_id AND 
			sc.mastercatalog='1' AND 
			sr.relatedstore_id=sc.storeent_id AND 
			sr.streltyp_id=-4 AND 
			sr.store_id=sl.storeent_id AND 
			sl.language_id=l.language_id
END_SQL_STATEMENT

<!-- ====================================================================== 
<!--	Update the SRCHCONF table languages column with the master catalog 
<!--	supported languages.
<!-- ======================================================================
BEGIN_SQL_STATEMENT
	name=UPDATE_SRCHCONF_LANGUAGES_BY_INDEXSCOP
	base_table=SRCHCONF
	sql=
		UPDATE SRCHCONF 
		SET LANGUAGES=?languages?
		WHERE INDEXSCOPE=?masterCatalogId?
END_SQL_STATEMENT

<!-- ====================================================================== 
<!--	Delete entries from SRCHCONFEXT by masterCatalogId and language_id.
<!-- ======================================================================
BEGIN_SQL_STATEMENT
	name=DELETE_SRCHCONFEXT_BY_INDEXSCOP_AND_LANGUAGES
	base_table=SRCHCONFEXT
	sql=
		DELETE FROM SRCHCONFEXT		
		WHERE INDEXSCOPE=?masterCatalogId? AND
		LANGUAGE_ID NOT IN (?languages?)		
END_SQL_STATEMENT

<!-- ====================================================================== 
<!--	Find current languages in SRCHCONFEXT table.
<!-- ======================================================================
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHCONFEXT_LANGUAGES_BY_INDEXSCOP
	base_table=SRCHCONFEXT
	sql=
		SELECT DISTINCT LANGUAGE_ID 
			FROM SRCHCONFEXT 
		WHERE INDEXSCOPE=?masterCatalogId? AND 
		LANGUAGE_ID IS NOT NULL
END_SQL_STATEMENT

<!-- ====================================================================== 
<!--	Find highest SRCHCONFEXT_ID value from the SRCHCONFEXT table.
<!-- ======================================================================
BEGIN_SQL_STATEMENT
	name=SELECT_MAX_SRCHCONFEXT_ID
	base_table=SRCHCONFEXT
	sql=
		SELECT max(SRCHCONFEXT_ID) AS MAXID FROM SRCHCONFEXT
END_SQL_STATEMENT

<!-- ====================================================================== 
<!--	Inserte new entry into SRCHCONFEXT for newly added language.
<!-- ======================================================================
BEGIN_SQL_STATEMENT
	name=INSERT_INTO_SRCHCONFEXT
	base_table=SRCHCONFEXT
	sql=
		INSERT INTO SRCHCONFEXT 
			(SRCHCONFEXT_ID, INDEXTYPE, INDEXSCOPE, LANGUAGE_ID, INDEXSUBTYPE, CONFIG) 
		VALUES 
			(?srchconfext_id?, ?indexType?, ?masterCatalogId?, ?language_id?, ?indexSubType?, '')
END_SQL_STATEMENT
