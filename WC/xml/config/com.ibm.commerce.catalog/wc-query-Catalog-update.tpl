BEGIN_SYMBOL_DEFINITIONS
	<!-- CATALOG table -->
	COLS:CATALOG=CATALOG:*
	COLS:CATALOG_ID=CATALOG:CATALOG_ID 
	COLS:MEMBER_ID=CATALOG:MEMBER_ID
	<!-- CATTOGRP table -->
	COLS:CATTOGRP=CATTOGRP:*
	<!-- STORECAT table -->
	COLS:STORECAT=STORECAT:*
	COLS:CATALOGDSC=CATALOGDSC:*
END_SYMBOL_DEFINITIONS

<!-- ====================================================================== 
	Get the catalog(s) of the store having the specified value for identifier(s)
	@param Identifier The identifier of the catalog . 
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/Catalog[CatalogIdentifier[ExternalIdentifier[(Identifier=)]]]+IBM_Admin_IdResolve
	base_table=CATALOG
	sql=
			SELECT 
	     				CATALOG.$COLS:CATALOG_ID$
	     	FROM
	     				CATALOG
	     					JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 						  
	     	WHERE
						CATALOG.IDENTIFIER=?Identifier?
						 AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog(s) of the store having the specified value for identifier(s)
	@param Identifier The identifier of the catalog . 
	@param ownerID The member id of the catalog . 
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/Catalog[CatalogIdentifier[ExternalIdentifier[(Identifier=) and (@ownerID=)]]]+IBM_Admin_IdResolve
	base_table=CATALOG
	sql=
			SELECT 
	     				CATALOG.$COLS:CATALOG_ID$
	     	FROM
	     				CATALOG
	     					JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 						  
	     	WHERE
						CATALOG.IDENTIFIER=?Identifier?
						AND CATALOG.MEMBER_ID = ?ownerID?
						 AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog(s) having the specified value for identifier(s)
	@param Identifier The identifier of the catalog . 
	@param ownerID The member id of the catalog . 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/Catalog[CatalogIdentifier[ExternalIdentifier[(Identifier=) and (@ownerID=)]]]+IBM_Admin_IdResolve_Without_Store_Filter
	base_table=CATALOG
	sql=
			SELECT 
	     				CATALOG.$COLS:CATALOG_ID$
	     	FROM
	     				CATALOG
	     					 						  
	     	WHERE
						CATALOG.IDENTIFIER=?Identifier?
						AND CATALOG.MEMBER_ID = ?ownerID?
						
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog(s) of the store having the specified value for unique id(s)
	@param UniqueID The unique id of the catalog . 
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/Catalog[CatalogIdentifier[(UniqueID=)]]+IBM_Admin_CatalogUpdate
	base_table=CATALOG
	sql=
			SELECT 
	     				CATALOG.$COLS:CATALOG$
	     	FROM
	     				CATALOG
	     					JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 						  
	     	WHERE
						CATALOG.CATALOG_ID IN (?UniqueID?)
						 AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the descriptions of the catalog of the given store having the specified value for unique id(s)
	@param UniqueID The unique id of the catalog . 
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)]]+IBM_Admin_CatalogDescriptionUpdate
	base_table=CATALOGDSC
	sql=
			SELECT 
	     				CATALOGDSC.$COLS:CATALOGDSC$
	     	FROM
	     				CATALOGDSC
	     					JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOGDSC.CATALOG_ID 						  
	     	WHERE
						CATALOGDSC.CATALOG_ID IN (?UniqueID?) 
						 AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the top category if it exists for the catalog with the given unique id
	@param UniqueID The unique id(s) of the catalog . 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)]]+IBM_Admin_CatalogTopCategory
	base_table=CATTOGRP
	sql=
			SELECT 
	     				CATTOGRP.$COLS:CATTOGRP$
	     	FROM
	     				CATTOGRP
	     					JOIN STORECAT ON STORECAT.CATALOG_ID=CATTOGRP.CATALOG_ID
	     					JOIN CATGROUP ON CATTOGRP.CATGROUP_ID=CATGROUP.CATGROUP_ID
	     	WHERE
						CATTOGRP.CATALOG_ID IN (?UniqueID?)
						 	AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
						 	AND CATGROUP.MARKFORDELETE = 0
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the owner id of the catalog having the specified identifier(s)
	@param Identifier The identifier(s) of the catalog . 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[ExternalIdentifier[(Identifier=)]]]+IBM_Admin_AccessControlGetOwner
	base_table=CATALOG
	sql=
			SELECT 
	     				CATALOG.$COLS:MEMBER_ID$
	     	FROM
	     				CATALOG
	     	WHERE
						CATALOG.IDENTIFIER=?Identifier?
END_XPATH_TO_SQL_STATEMENT
<!-- ====================================================================== 
	Get the owner id of the catalog having the specified unique id(s)
	@param UniqueID The unique id(s) of the catalog . 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)]]+IBM_Admin_AccessControlGetOwner
	base_table=CATALOG
	sql=
			SELECT 
	     				CATALOG.$COLS:MEMBER_ID$
	     	FROM
	     				CATALOG
	     	WHERE
						CATALOG.CATALOG_ID=?UniqueID?
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog having the specified unique id, masterCatalog flag and belonging to specified store
	@param UniqueID The unique id(s) of the catalog . 
	@param masterCatalog The value of the master catalog flag. 
	@param storeId The value of store id 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)] and (@masterCatalog=) and (@storeId=)]]+IBM_Admin_CatalogDetailsProfile
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				STORECAT.$COLS:STORECAT$
				
		FROM
				CATALOG, STORECAT
				
		WHERE
				CATALOG.CATALOG_ID = ?UniqueID? AND
				STORECAT.CATALOG_ID = CATALOG.CATALOG_ID AND
				STORECAT.MASTERCATALOG = ?masterCatalog? AND
				STORECAT.STOREENT_ID = ?storeId?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the master catalog or sales catalog of the specified store in STORECAT table. Store path is not considered.
	@param UniqueID The unique id(s) of the catalog . 
	@param masterCatalog The value of the master catalog flag. 
	@param storeId The value of store id 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[(@masterCatalog=) and (@storeId=)]+IBM_Admin_CatalogDetailsProfile
	base_table=STORECAT
	sql=
		SELECT 
				STORECAT.$COLS:STORECAT$
				
		FROM
				STORECAT
				
		WHERE
				STORECAT.MASTERCATALOG = ?masterCatalog? AND
				STORECAT.STOREENT_ID = ?storeId?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog having the specified unique id, masterCatalog flag and belonging to stores in store path
	@param UniqueID The unique id(s) of the catalog . 
	@param masterCatalog The value of the master catalog flag. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)] and (@masterCatalog=)]]+IBM_Admin_CatalogDetailsProfile
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				STORECAT.$COLS:STORECAT$
				
		FROM
				CATALOG, STORECAT
				
		WHERE
				CATALOG.CATALOG_ID = ?UniqueID? AND
				STORECAT.CATALOG_ID = CATALOG.CATALOG_ID AND
				STORECAT.MASTERCATALOG = ?masterCatalog? AND
				STORECAT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
								
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog having the specified unique id and belonging to stores in store path
	@param UniqueID The unique id(s) of the catalog . 
	@param masterCatalog The value of the master catalog flag. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)]]+IBM_Admin_CatalogDetailsProfile
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				STORECAT.$COLS:STORECAT$
				
		FROM
				CATALOG, STORECAT
				
		WHERE
				CATALOG.CATALOG_ID = ?UniqueID? AND
				STORECAT.CATALOG_ID = CATALOG.CATALOG_ID AND
				STORECAT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
								
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Access Profile Alias definition			       -->
<!-- ========================================================= -->

BEGIN_PROFILE_ALIASES
  base_table=CATALOG
  IBM_IdResolve=IBM_Admin_IdResolve
  IBM_CatalogUpdate=IBM_Admin_CatalogUpdate
  IBM_AccessControlGetOwner=IBM_Admin_AccessControlGetOwner
  IBM_CatalogDetailsProfile=IBM_Admin_CatalogDetailsProfile
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATALOGDSC
  IBM_CatalogDescriptionUpdate=IBM_Admin_CatalogDescriptionUpdate
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATTOGRP
  IBM_CatalogTopCategory=IBM_Admin_CatalogTopCategory
END_PROFILE_ALIASES
