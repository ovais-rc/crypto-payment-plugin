BEGIN_SYMBOL_DEFINITIONS
	<!-- CATALOG table -->
	COLS:CATALOG=CATALOG:*
	COLS:CATALOG_ID=CATALOG:CATALOG_ID
	COLS:CATALOG:MEMBER_ID=CATALOG:MEMBER_ID
	COLS:CATALOG:IDENTIFIER=CATALOG:IDENTIFIER
	<!-- STORECAT table -->
	COLS:STORECAT=STORECAT:*
	<!-- CATALOGDSC Table -->
	COLS:CATALOGDSC=CATALOGDSC:*
	COLS:CATALOGDSC:CATALOG_ID=CATALOGDSC:CATALOG_ID
	COLS:CATALOGDSC:LANGUAGE_ID=CATALOGDSC:LANGUAGE_ID
	COLS:CATALOGDSC:NAME=CATALOGDSC:NAME	
	COLS:CATALOGDSC:SHORTDESCRIPTION=CATALOGDSC:SHORTDESCRIPTION
	COLS:CATALOGDSC:THUMBNAIL=CATALOGDSC:THUMBNAIL

  <!-- ATCHREL table -->
	COLS:ATCHREL=ATCHREL:*
	COLS:ATCHREL:ATCHTGT_ID=ATCHREL:ATCHTGT_ID
	COLS:ATCHREL:SEQUENCE=ATCHREL:SEQUENCE
	
	<!-- ATCHRLUS table -->
	COLS:ATCHRLUS=ATCHRLUS:*
	COLS:ATCHRLUS:IDENTIFIER=ATCHRLUS:IDENTIFIER
	
	<!-- ATCHRELDSC table -->
	COLS:ATCHRELDSC=ATCHRELDSC:*
	COLS:ATCHRELDSC:NAME=ATCHRELDSC:NAME
	COLS:ATCHRELDSC:SHORTDESCRIPTION=ATCHRELDSC:SHORTDESCRIPTION
	COLS:ATCHRELDSC:LONGDESCRIPTION=ATCHRELDSC:LONGDESCRIPTION

END_SYMBOL_DEFINITIONS

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog noun         -->
<!-- given the specified unique identifier.                        -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_CatalogAttachmentReference                                -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param STOREPATH:catalog - The store for which to retrieve    -->
<!--        the catalog. This parameter is retrieved from          -->
<!--	      within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)]]
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG_ID$
		FROM
				CATALOG
						JOIN STORECAT ON (STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$))
        WHERE
               CATALOG.CATALOG_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog(s) having the specified unique id(s) (CATALOG_ID in CATALOG table) and with the specified access profile IBM_Admin_Summary
	@param CatalogIdentifier The identifier(s) for which to retrieve the catalog        
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
	@param Control:LANGUAGES The language for which to retrieve the catalog entry .This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)]]+IBM_Admin_Summary
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG_ID$, CATALOG.$COLS:CATALOG:MEMBER_ID$,
				CATALOG.$COLS:CATALOG:IDENTIFIER$, 
				CATALOGDSC.$COLS:CATALOGDSC:CATALOG_ID$, CATALOGDSC.$COLS:CATALOGDSC:LANGUAGE_ID$,
				CATALOGDSC.$COLS:CATALOGDSC:NAME$, CATALOGDSC.$COLS:CATALOGDSC:SHORTDESCRIPTION$,
				CATALOGDSC.$COLS:CATALOGDSC:THUMBNAIL$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 
				        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
        WHERE
               CATALOG.CATALOG_ID IN (?UniqueID?)
    	
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog(s) having the specified identifier(s) (IDENTIFIER in CATALOG table) and with the specified access profile IBM_Admin_Summary
	@param CatalogIdentifier The identifier(s) for which to retrieve the catalog        
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
	@param Control:LANGUAGES The language for which to retrieve the catalog entry .This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[ExternalIdentifier[(Identifier=)]]]+IBM_Admin_Summary
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG_ID$, CATALOG.$COLS:CATALOG:MEMBER_ID$,
				CATALOG.$COLS:CATALOG:IDENTIFIER$, 
				CATALOGDSC.$COLS:CATALOGDSC:CATALOG_ID$, CATALOGDSC.$COLS:CATALOGDSC:LANGUAGE_ID$,
				CATALOGDSC.$COLS:CATALOGDSC:NAME$, CATALOGDSC.$COLS:CATALOGDSC:SHORTDESCRIPTION$,
				CATALOGDSC.$COLS:CATALOGDSC:THUMBNAIL$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 
				        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
        WHERE
                CATALOG.IDENTIFIER IN (?Identifier?) 
   	
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog(s) having the specified unique id(s) (CATALOG_ID in CATALOG table) and with the specified access profile IBM_Admin_Details
	@param CatalogIdentifier The identifier(s) for which to retrieve the catalog        
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
	@param Control:LANGUAGES The language for which to retrieve the catalog entry .This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)]]+IBM_Admin_Details
	base_table=CATALOG
	param=versionable

	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				CATALOGDSC.$COLS:CATALOGDSC$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 
				        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
        WHERE
               CATALOG.CATALOG_ID IN (?UniqueID?)
  	
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog(s) having the specified identifier(s) (IDENTIFIER in CATALOG table) and with the specified access profile IBM_Admin_Details
	@param CatalogIdentifier The identifier(s) for which to retrieve the catalog        
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
	@param Control:LANGUAGES The language for which to retrieve the catalog entry .This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[ExternalIdentifier[(Identifier=)]]]+IBM_Admin_Details
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				CATALOGDSC.$COLS:CATALOGDSC$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 
				        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
        WHERE
               CATALOG.IDENTIFIER IN (?Identifier?)
  	
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog(s) having the specified unique id(s) (CATALOG_ID in CATALOG table) and with the specified access profile IBM_Admin_All
	@param CatalogIdentifier The identifier(s) for which to retrieve the catalog        
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
	@param Control:LANGUAGES The language for which to retrieve the catalog entry .This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)]]+IBM_Admin_All
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				CATALOGDSC.$COLS:CATALOGDSC$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 
				        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
        WHERE
               CATALOG.CATALOG_ID IN (?UniqueID?)
  	
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog(s) having the specified identifier(s) (IDENTIFIER in CATALOG table) and with the specified access profile IBM_Admin_All
	@param CatalogIdentifier The identifier(s) for which to retrieve the catalog        
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
	@param Control:LANGUAGES The language for which to retrieve the catalog entry .This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[ExternalIdentifier[(Identifier=)]]]+IBM_Admin_All
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				CATALOGDSC.$COLS:CATALOGDSC$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 
				        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
        WHERE
               CATALOG.IDENTIFIER IN (?Identifier?)
  	
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog(s) of the store having the specified value for the master catalog flag (MASTERCATALOG in CATALOG table) and with the specified access profile IBM_Admin_Details
	@param primary The value of the master catalog flag. A value of 'true' implies mastercatalog. (true will return master catalogs & false will return sales catalogs)
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
	@param Control:LANGUAGES The language for which to retrieve the catalog entry .This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT	
	name=/Catalog[@primary=]+IBM_Admin_Summary
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG,
				STORECAT
		WHERE
				CATALOG.CATALOG_ID = STORECAT.CATALOG_ID AND 
				STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)AND
				STORECAT.MASTERCATALOG = (CASE WHEN CAST((?primary?) as char(5)) = 'true' THEN '1' ELSE '0' END)
		ORDER BY
				CATALOG.CATALOG_ID			
	paging_count			
  	sql =
              SELECT 
                            COUNT(*) as countrows
		FROM
				CATALOG,
				STORECAT
		WHERE
				CATALOG.CATALOG_ID = STORECAT.CATALOG_ID AND 
				STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)AND
				STORECAT.MASTERCATALOG = (CASE WHEN CAST((?primary?) as char(5)) = 'true' THEN '1' ELSE '0' END)

END_XPATH_TO_SQL_STATEMENT



<!-- ====================================================================== 
	Get the catalog(s) of the store having the specified value for the master catalog flag (MASTERCATALOG in CATALOG table) and with the specified access profile IBM_Admin_Details
	@param primary The value of the master catalog flag. A value of 'true' implies mastercatalog. (true will return master catalogs & false will return sales catalogs)
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
	@param Control:LANGUAGES The language for which to retrieve the catalog entry .This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT	
	name=/Catalog[@primary=]+IBM_Admin_Details
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				STORECAT.$COLS:STORECAT$,
				CATALOGDSC.$COLS:CATALOGDSC$
		FROM

				STORECAT,
				CATALOG				
				LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 
				        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
				
		WHERE
				CATALOG.CATALOG_ID = STORECAT.CATALOG_ID AND 
				STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)AND
				STORECAT.MASTERCATALOG = (CASE WHEN CAST((?primary?) as char(5)) = 'true' THEN '1' ELSE '0' END)
		ORDER BY
				CATALOG.CATALOG_ID	
	paging_count			
  	sql =
              SELECT 
                            COUNT(DISTINCT CATALOG.CATALOG_ID) as countrows
		FROM

				STORECAT,
				CATALOG				
				LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 
				        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
				
		WHERE
				CATALOG.CATALOG_ID = STORECAT.CATALOG_ID AND 
				STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)AND
				STORECAT.MASTERCATALOG = (CASE WHEN CAST((?primary?) as char(5)) = 'true' THEN '1' ELSE '0' END)

END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog(s) having the specified unique id(s) (CATALOG_ID in CATALOG table) and with the specified access profile IBM_Admin_CatalogAllDescriptions.
	Retrieves catalog descriptions in all languages.
	@param CatalogIdentifier The identifier(s) for which to retrieve the catalog        
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)]]+IBM_Admin_CatalogAllDescriptions
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				CATALOGDSC.$COLS:CATALOGDSC$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 				        	
        WHERE
               CATALOG.CATALOG_ID IN (?UniqueID?)
  	
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog(s) having the specified identifier(s) (IDENTIFIER in CATALOG table) and with the specified access profile IBM_Admin_CatalogAllDescriptions.
	Retrieves catalog descriptions in all languages.
	@param CatalogIdentifier The identifier(s) for which to retrieve the catalog        
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[ExternalIdentifier[(Identifier=)]]]+IBM_Admin_CatalogAllDescriptions
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				CATALOGDSC.$COLS:CATALOGDSC$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 				        	
        WHERE
               CATALOG.IDENTIFIER IN (?Identifier?)
 	
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog(s) having the specified unique id(s) (CATALOG_ID in CATALOG table) and with the specified access profile IBM_Admin_CatalogDescription.
	Retrieves catalog descriptions in all the input languages.
	@param CatalogIdentifier The identifier(s) for which to retrieve the catalog        
	@param LANGUAGES The languages(s) for which to retrieve the catalog description       
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[(UniqueID=)]]+IBM_Admin_CatalogDescription
	base_table=CATALOG
	param=versionable
	
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				CATALOGDSC.$COLS:CATALOGDSC$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID
				        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
				   				        	
        WHERE
               CATALOG.CATALOG_ID IN (?UniqueID?)
 	
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog(s) having the specified identifier(s) (IDENTIFIER in CATALOG table) and with the specified access profile IBM_Admin_CatalogDescription.
	Retrieves catalog descriptions in all the input languages.
	@param CatalogIdentifier The identifier(s) for which to retrieve the catalog        
	@param LANGUAGES The languages(s) for which to retrieve the catalog description       
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[CatalogIdentifier[ExternalIdentifier[(Identifier=)]]]+IBM_Admin_CatalogDescription
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				CATALOGDSC.$COLS:CATALOGDSC$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID
				        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
				   				        	
        WHERE
               CATALOG.IDENTIFIER IN (?Identifier?)
 	
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the catalog(s) to which the specified    -->
<!-- attachment is associated.                                     -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_CatalogDescription, 				   -->
<!-- IBM_Admin_CatalogAttachmentReference                          -->
<!-- @param UniqueID The identifier of the attachment              -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	      the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[AttachmentReference[AttachmentIdentifier[(UniqueID=)]]]
	base_table=CATALOG	
	sql=
		SELECT 
				DISTINCT(CATALOG.$COLS:CATALOG_ID$)
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				    JOIN ATCHREL ON ATCHREL.BIGINTOBJECT_ID = CATALOG.CATALOG_ID
				    JOIN ATCHOBJTYP ON (ATCHREL.ATCHOBJTYP_ID = ATCHOBJTYP.ATCHOBJTYP_ID AND ATCHOBJTYP.IDENTIFIER = 'CATALOG')
    WHERE
        ATCHREL.ATCHTGT_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT


<!-- 
	========================================================== 
     Search the catalogs that matches the specified search
	 criteria. 
	 1: attribute is searchable and can be indexed to search engine.
     Access profiles supported: IBM_Admin_Summary, IBM_Admin_Details                       
    ========================================================== 
-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Catalog[search()]
	base_table=CATALOG
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=Description/Name:254
	param=CatalogIdentifier/ExternalIdentifier/Identifier:254

	sql=
		SELECT 
				CATALOG.$COLS:CATALOG_ID$
		
		FROM
				CATALOG, STORECAT, $ATTR_TBLS$
				        	
        WHERE
        		STORECAT.CATALOG_ID=CATALOG.CATALOG_ID AND
        		STORECAT.STOREENT_ID IN ($STOREPATH:catalog$) AND
              	CATALOG.$ATTR_CNDS$
		ORDER BY 
              	CATALOG.CATALOG_ID $DB:UNCOMMITTED_READ$				
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get all the catalog(s) of the store.
	@param STOREPATH:catalog The store path for which to retrieve the catalog . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT	
	name=/Catalog
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG_ID$
		FROM
				STORECAT,
				CATALOG				
		WHERE
				CATALOG.CATALOG_ID = STORECAT.CATALOG_ID AND 
				STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
		ORDER BY
				CATALOG.CATALOG_ID	
	paging_count			
  	sql =
        SELECT 
                COUNT(DISTINCT CATALOG.CATALOG_ID) as countrows
		FROM
				STORECAT,
				CATALOG				
		WHERE
				CATALOG.CATALOG_ID = STORECAT.CATALOG_ID AND 
				STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)

END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================= -->
<!-- =============================ASSOCIATION QUERIES========================= -->
<!-- ========================================================================= -->


<!-- ============================================================ -->
<!-- This associated SQL:                                         -->
<!-- Adds Catalog Description Info                                -->
<!-- to the resultant data graph.                                 -->
<!-- ============================================================ -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogDescription
	base_table=CATALOG
	param=versionable

	sql=
		SELECT 
				CATALOG.$COLS:CATALOG_ID$,
				CATALOGDSC.$COLS:CATALOGDSC$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
						JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
				    LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID
				      AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
    WHERE
        CATALOG.CATALOG_ID IN ($ENTITY_PKS$)

END_ASSOCIATION_SQL_STATEMENT


<!-- ============================================================ -->
<!-- This associated SQL:                                         -->
<!-- Adds Attachment Reference Description Info                   -->
<!-- to the resultant data graph.                                 -->
<!-- ============================================================ -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogAttachmentReferenceDescription
	base_table=CATALOG
	additional_entity_objects=true	
	param=versionable
	
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$, ATCHREL.$COLS:ATCHREL$, ATCHRLUS.$COLS:ATCHRLUS$, ATCHRELDSC.$COLS:ATCHRELDSC$
		FROM
				CATALOG
				JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
							AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)				
				JOIN ATCHREL ON ATCHREL.BIGINTOBJECT_ID = CATALOG.CATALOG_ID
				JOIN ATCHRLUS ON ATCHREL.ATCHRLUS_ID = ATCHRLUS.ATCHRLUS_ID
				JOIN ATCHOBJTYP ON (ATCHREL.ATCHOBJTYP_ID = ATCHOBJTYP.ATCHOBJTYP_ID AND ATCHOBJTYP.IDENTIFIER = 'CATALOG')
				LEFT OUTER JOIN ATCHRELDSC ON (ATCHREL.ATCHREL_ID = ATCHRELDSC.ATCHREL_ID AND ATCHRELDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
		WHERE
        CATALOG.CATALOG_ID IN ($ENTITY_PKS$)         
  
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the catalog and catalog description summary to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogSummary
	base_table=CATALOG
	sql=

		SELECT 
				CATALOG.$COLS:CATALOG_ID$, CATALOG.$COLS:CATALOG:MEMBER_ID$,
				CATALOG.$COLS:CATALOG:IDENTIFIER$, 
				CATALOGDSC.$COLS:CATALOGDSC:CATALOG_ID$, CATALOGDSC.$COLS:CATALOGDSC:LANGUAGE_ID$,
				CATALOGDSC.$COLS:CATALOGDSC:NAME$, CATALOGDSC.$COLS:CATALOGDSC:SHORTDESCRIPTION$,
				CATALOGDSC.$COLS:CATALOGDSC:THUMBNAIL$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
					JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
						AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
			        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 
			        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
				        	
        WHERE
              	CATALOG.CATALOG_ID IN ($ENTITY_PKS$)
		ORDER BY 
              	CATALOG.CATALOG_ID				

END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds the catalog and catalog description details to the resultant data graph.                         
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogDetail
	base_table=CATALOG
	sql=

		SELECT 
				CATALOG.$COLS:CATALOG$,
				CATALOGDSC.$COLS:CATALOGDSC$,
				STORECAT.$COLS:STORECAT$
		
		FROM
				CATALOG
					JOIN STORECAT ON STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
						AND STORECAT.STOREENT_ID IN ($STOREPATH:catalog$)
			        LEFT OUTER JOIN CATALOGDSC ON CATALOGDSC.CATALOG_ID = CATALOG.CATALOG_ID 
			        	AND CATALOGDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
				        	
        WHERE
              	CATALOG.CATALOG_ID IN ($ENTITY_PKS$)
		ORDER BY 
              	CATALOG.CATALOG_ID				

END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================================= -->
<!-- =============================PROFILE DEFINITIONS========================= -->
<!-- ========================================================================= -->

<!-- ========================================================= -->
<!-- Catalog Descriptions Access Profile.                      -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog with descriptions for languages.              -->
<!-- 	   passes in the control parameter 'LANGUAGES'.          -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogDescription
	BEGIN_ENTITY 
	  base_table=CATALOG 
	  className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
      associated_sql_statement=IBM_CatalogDescription
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Attachment References Access Profile.             -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog with attachment reference.                    -->
<!-- 	2) Catalog with attachment reference description.        -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogAttachmentReference
	BEGIN_ENTITY 
	  base_table=CATALOG
	  className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
      associated_sql_statement=IBM_CatalogDescription     
      associated_sql_statement=IBM_CatalogAttachmentReferenceDescription
    END_ENTITY
END_PROFILE


BEGIN_PROFILE 
	name=IBM_Admin_Summary
	BEGIN_ENTITY 
	  base_table=CATALOG
	  associated_sql_statement=IBM_CatalogSummary
    END_ENTITY
END_PROFILE


BEGIN_PROFILE 
	name=IBM_Admin_Details
	BEGIN_ENTITY 
	  base_table=CATALOG
	  associated_sql_statement=IBM_CatalogDetail
    END_ENTITY
END_PROFILE



<!-- ========================================================= -->
<!-- Catalog Access Profile Alias definition             -->
<!--                                                            -->
<!-- ========================================================= -->

BEGIN_PROFILE_ALIASES
  base_table=CATALOG
  IBM_Summary=IBM_Admin_Summary
  IBM_Details=IBM_Admin_Details
  IBM_All=IBM_Admin_All
  IBM_CatalogAllDescriptions=IBM_Admin_CatalogAllDescriptions
  IBM_CatalogDescription=IBM_Admin_CatalogDescription
END_PROFILE_ALIASES
