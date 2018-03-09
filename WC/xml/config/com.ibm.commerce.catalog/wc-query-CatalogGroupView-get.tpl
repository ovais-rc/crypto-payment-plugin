BEGIN_SYMBOL_DEFINITIONS

	<!-- CATGROUP table -->
	COLS:CATGROUP=CATGROUP:*
	COLS:CATGROUP_ID=CATGROUP:CATGROUP_ID
	COLS:CATGROUP:IDENTIFIER=CATGROUP:IDENTIFIER
	COLS:CATGROUP:MEMBER_ID=CATGROUP:MEMBER_ID

	<!-- CATTOGRP table -->
	COLS:CATTOGRP=CATTOGRP:*
	COLS:CATTOGRP:CATGROUP_ID=CATTOGRP:CATGROUP_ID

	<!-- CATGRPREL Table -->
	COLS:CATGRPREL=CATGRPREL:*
	COLS:CATGROUP_ID_PARENT=CATGRPREL:CATGROUP_ID_PARENT
	COLS:CATGROUP_ID_CHILD=CATGRPREL:CATGROUP_ID_CHILD
	COLS:CATGRPREL:SEQUENCE=CATGRPREL:SEQUENCE

	<!-- CATGRPDESC Table -->
	COLS:CATGRPDESC=CATGRPDESC:*
	COLS:CATGRPDESC:NAME=CATGRPDESC:NAME
	COLS:CATGRPDESC:CATGROUP_ID=CATGRPDESC:CATGROUP_ID
	COLS:CATGRPDESC:LANGUAGE_ID=CATGRPDESC:LANGUAGE_ID
	COLS:CATGRPDESC:SHORTDESCRIPTION=CATGRPDESC:SHORTDESCRIPTION	
	COLS:CATGRPDESC:THUMBNAIL=CATGRPDESC:THUMBNAIL		

	<!-- STORECGRP table -->
	COLS:STORECGRP=STORECGRP:*
	COLS:STORECGRP:STOREENT_ID=STORECGRP:STOREENT_ID
	COLS:STORECGRP:CATGROUP_ID=STORECGRP:CATGROUP_ID		

END_SYMBOL_DEFINITIONS


<!-- ========================================================== 
     Returns the catalog group information for a given set of unique Ids of catalog groups.  
     @param UniqueID The unique ids of the catalog groups.              
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView[CatalogGroupView[(UniqueID=)]]
	base_table=CATGROUP
	sql=
	  SELECT 
	  		CATGROUP.$COLS:CATGROUP_ID$
	  FROM 
	  		CATGROUP JOIN STORECGRP ON (
				CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
				STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)
			)
	  WHERE 
			CATGROUP.MARKFORDELETE = 0 AND
	  		CATGROUP.CATGROUP_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================== 
     Returns the catalog group information for a given set of identifier of the catalog groups.  
     @param Identifier The identifiers of the catalog groups.              
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView[CatalogGroupView[(Identifier=)]]
	base_table=CATGROUP
	sql=
	  SELECT 
	  		CATGROUP.$COLS:CATGROUP_ID$
	  FROM 
	  		CATGROUP JOIN STORECGRP ON (
				CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND
				STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)
			)
	  WHERE 
			CATGROUP.MARKFORDELETE = 0 AND
	  		CATGROUP.IDENTIFIER IN (?Identifier?) 
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catgroup Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
	base_table=CATGROUP
	additional_entity_objects=true
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP$,
				CATGRPDESC.$COLS:CATGRPDESC$,
				CATTOGRP.$COLS:CATTOGRP$
		FROM
				CATGROUP
				 LEFT OUTER JOIN
				CATGRPDESC ON 
					 (CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID AND
					  CATGRPDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				CATTOGRP ON 
					(CATGROUP.CATGROUP_ID = CATTOGRP.CATGROUP_ID AND
					 (CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$ OR CATTOGRP.CATALOG_ID_LINK IS NULL))
		WHERE
                CATGROUP.CATGROUP_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- =============================================================================
     Adds store identifier (STORECENT table) of catalog entry to the 
     resultant data graph.                                                 
     ============================================================================= -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupStoreIdentifier
	base_table=STORECGRP
	sql=
		SELECT 
			STORECGRP.$COLS:STORECGRP:CATGROUP_ID$,
			STORECGRP.$COLS:STORECGRP:STOREENT_ID$
		FROM 
			STORECGRP 
		WHERE 
			STORECGRP.CATGROUP_ID IN ($UNIQUE_IDS$) AND
			STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)
END_ASSOCIATION_SQL_STATEMENT			

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catgroup Parent Relations                            -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupParentRelationShips
	base_table=CATGRPREL
	sql=
		SELECT 
				CATGRPREL.$COLS:CATGRPREL$
		FROM
				CATGRPREL
		WHERE
				CATGRPREL.CATGROUP_ID_CHILD IN ($UNIQUE_IDS$) AND
				(CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$ OR CATALOG_ID_LINK IS NULL)

END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Catalog Group Summary Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Group with description summary.             -->
<!-- 	2) Catalog Group top catalog group.                    -->
<!-- 	3) Catalog Group parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Store_Details
	BEGIN_ENTITY 
	  base_table=CATGROUP
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogGroupGraphComposer
	  associated_sql_statement=IBM_RootCatalogGroupWithDescriptionWithTopCatGroup
      associated_sql_statement=IBM_CatalogGroupStoreIdentifier       
      associated_sql_statement=IBM_CatalogGroupParentRelationShips
    END_ENTITY
END_PROFILE


<!-- ==========================================================
	 Defines access profile aliases for Catalog Groups.
     ========================================================== -->
BEGIN_PROFILE_ALIASES
  base_table=CATGROUP
  IBM_Store_Details_SEO=IBM_Store_Details
END_PROFILE_ALIASES