BEGIN_SYMBOL_DEFINITIONS

	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID

	<!-- CATENTREL table -->	
	COLS:CATENTREL=CATENTREL:*

	<!-- CATGPENREL table -->	
	COLS:CATGPENREL=CATGPENREL:*

	<!-- STORECENT table -->
	COLS:STORECENT:STOREENT_ID=STORECENT:STOREENT_ID
	COLS:STORECENT:CATENTRY_ID=STORECENT:CATENTRY_ID		

	<!-- CATENTDESC table -->
	COLS:CATENTDESC=CATENTDESC:*

	<!-- OFFER table -->
	COLS:OFFER=OFFER:*
	
	<!-- OFFERPRICE table -->
	COLS:OFFERPRICE=OFFERPRICE:*

END_SYMBOL_DEFINITIONS


<!-- ========================================================== 
     Returns the catalog entry information for a given set of unique Ids of catalog entries.  
     @param UniqueID The unique ids of the catalog entries.              
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView[CatalogEntryView[(UniqueID=)]]
	base_table=CATENTRY
	sql=
	  SELECT 
	  		CATENTRY.$COLS:CATENTRY_ID$
	  FROM 
	  		CATENTRY JOIN STORECENT ON (
				CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
				STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
			)
	  WHERE 
			CATENTRY.MARKFORDELETE = 0 AND
	  		CATENTRY.CATENTRY_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================== 
     Returns the catalog entry information for a given set of partnumbers of the catalog entries.  
     @param PartNumber The part numbers of the catalog entries.              
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView[CatalogEntryView[(PartNumber=)]]
	base_table=CATENTRY
	sql=
	  SELECT 
	  		CATENTRY.$COLS:CATENTRY_ID$
	  FROM 
	  		CATENTRY JOIN STORECENT ON (
				CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
				STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
			)
	  WHERE 
			CATENTRY.MARKFORDELETE = 0 AND
	  		CATENTRY.PARTNUMBER IN (?PartNumber?)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info 				                   -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntry
	base_table=CATENTRY
	additional_entity_objects=false
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY$
		FROM
				CATENTRY
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- =============================================================================
     Adds store identifier (STORECENT table) of catalog entry to the 
     resultant data graph.                                                 
     ============================================================================= -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryStoreIdentifier
	base_table=STORECENT
	sql=

		SELECT 
			STORECENT.$COLS:STORECENT:CATENTRY_ID$,
			STORECENT.$COLS:STORECENT:STOREENT_ID$
		FROM 
			STORECENT 
		WHERE 
			STORECENT.CATENTRY_ID IN ($UNIQUE_IDS$) AND
			STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
END_ASSOCIATION_SQL_STATEMENT			

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentry descrition Info 				               -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDescription
	base_table=CATENTDESC
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTDESC.$COLS:CATENTDESC$
		FROM
				CATENTDESC
				        	
		WHERE
                CATENTDESC.CATENTRY_ID IN ($UNIQUE_IDS$) AND CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL: -->
<!-- Adds offer price for a given currency -->
<!-- to the resultant data graph. -->
<!-- #### Asociated SQL to DataExtract the offerprice #### -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryOfferPriceForCurrency
	base_table=OFFER
	sql=
		SELECT 
				OFFER.$COLS:OFFER$,OFFERPRICE.$COLS:OFFERPRICE$
		FROM
				OFFER,OFFERPRICE
		WHERE
        		OFFER.CATENTRY_ID IN ($UNIQUE_IDS$) AND OFFER.OFFER_ID = OFFERPRICE.OFFER_ID AND OFFERPRICE.CURRENCY IN ($CTX:CURRENCY$) AND 
			OFFER.TRADEPOSCN_ID IN (
				SELECT CATGRPTPC.TRADEPOSCN_ID 
				FROM CATGRPTPC 
				WHERE CATGRPTPC.CATALOG_ID = $CTX:CATALOG_ID$ AND CATGRPTPC.CATGROUP_ID = 0 AND 
				( CATGRPTPC.STORE_ID IN ($STOREPATH:catalog$) OR CATGRPTPC.STORE_ID = 0 ))

END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds parent catgroup info                                 -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryToCatalogGroupRelationship
	base_table=CATGPENREL
	sql=
		SELECT 
				CATGPENREL.$COLS:CATGPENREL$
		FROM
				CATGPENREL
        WHERE
        		CATGPENREL.CATENTRY_ID IN ($UNIQUE_IDS$)
                
END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================== -->
<!-- This associated SQL:                                           -->
<!-- Adds parent product info of a SKU (PRODUCT_ITEM relationship)  -->
<!-- to the resultant data graph.                                   -->
<!-- ============================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_ParentCatalogEntryForRootRelationships
	base_table=CATENTREL
	sql=
		SELECT 
				CATENTREL.$COLS:CATENTREL$
		FROM
				CATENTREL
		WHERE
				CATENTREL.CATENTRY_ID_CHILD IN ($UNIQUE_IDS$) AND
				CATENTREL.CATRELTYPE_ID = 'PRODUCT_ITEM'
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Catalog Entry Summary Access Profile for Store.           -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry offer price.                          -->
<!-- 	3) Catalog Entry parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Store_Summary
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryDescription	  
      associated_sql_statement=IBM_CatalogEntryOfferPriceForCurrency       
      associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
      associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
    END_ENTITY
END_PROFILE


<!-- ==========================================================
	 Defines access profile aliases for Catalog Entries.
     ========================================================== -->
BEGIN_PROFILE_ALIASES
  base_table=CATENTRY
  IBM_Store_Summary_SEO=IBM_Store_Summary
END_PROFILE_ALIASES