BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun SearchTermAssociation  -->
	<!-- Defining all columns of the table -->
	COLS:SRCHTERMASSOC = SRCHTERMASSOC:* 	
	
	<!-- Defining the unique ID column of the table -->
	COLS:SRCHTERMASSOC_ID = SRCHTERMASSOC:SRCHTERMASSOC_ID
	
	COLS:SRCHTERM = SRCHTERM:* 		
		
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- XPath: /SearchTermAssociation[(AssociationType=)] -->
<!-- This is the first part of a two-step query. It gets the distinct Search Term Association unique IDs 
     of the specified association types for the store path and data languages.
<!-- @param AssociationType Retrieve STAs of these association types. The value specified in the XPath is the external value used in the logical model. 
                            The value used in the SQL is the integer value stored in the database. The conversion is done by SearchTermAssociationSQLComposer. --> 
<!-- @param STOREPATH:catalog Retrieve STAs that are defined in the current storepath. -->   
<!-- @param CONTROL:LANGUAGES Retrieve STAs that are defined in the specified data languages. -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/SearchTermAssociation[(AssociationType=)]
	base_table=SRCHTERMASSOC
	className=com.ibm.commerce.search.facade.server.services.dataaccess.db.jdbc.SearchTermAssociationSQLComposer
	sql=
	     SELECT 
	        DISTINCT SRCHTERMASSOC.SRCHTERMASSOC_ID
	     FROM
	        SRCHTERMASSOC LEFT OUTER JOIN SRCHTERM ON SRCHTERM.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID
	     WHERE
	        SRCHTERMASSOC.STOREENT_ID in ($STOREPATH:catalog$) AND 
	        SRCHTERMASSOC.LANGUAGE_ID in ($CONTROL:LANGUAGES$) AND
	        SRCHTERMASSOC.ASSOCIATIONTYPE in (?AssociationType?)	        

   paging_count
	 sql=
	     SELECT 
		       COUNT( DISTINCT SRCHTERMASSOC.SRCHTERMASSOC_ID)
		     FROM
		        SRCHTERMASSOC LEFT OUTER JOIN SRCHTERM ON SRCHTERM.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID
		     WHERE
		        SRCHTERMASSOC.STOREENT_ID in ($STOREPATH:catalog$) AND 
		        SRCHTERMASSOC.LANGUAGE_ID in ($CONTROL:LANGUAGES$) AND
		        SRCHTERMASSOC.ASSOCIATIONTYPE in (?AssociationType?)	          
END_XPATH_TO_SQL_STATEMENT

<!-- ===========================================================================
     Get search term associations for IBM_Admin_Summary access profile. 
     This access profile contains all the columns in SRCHTERMASSOC and SRCHTERM tables.
     =========================================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_SearchTermAssociations
	base_table=SRCHTERMASSOC
	className=com.ibm.commerce.search.facade.server.services.dataaccess.db.jdbc.SearchTermAssociationSQLComposer
	sql=
	     SELECT 
	        SRCHTERMASSOC.$COLS:SRCHTERMASSOC$,
            SRCHTERM.$COLS:SRCHTERM$
	     FROM
	        SRCHTERMASSOC LEFT OUTER JOIN SRCHTERM ON SRCHTERM.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID
	     WHERE
	        SRCHTERMASSOC.SRCHTERMASSOC_ID in ($ENTITY_PKS$)        
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Definition for IBM_Admin_Summary access profile.
     =========================================================================== -->

BEGIN_PROFILE 
    name=IBM_Admin_Summary
      BEGIN_ENTITY 
         base_table=SRCHTERMASSOC
         associated_sql_statement=IBM_SearchTermAssociations
      END_ENTITY
END_PROFILE

<!-- ================================================================================== -->
<!-- XPath: /SearchTermAssociation[AssociationType= and (SearchTerms=)] -->
<!-- AccessProfile:	IBM_Admin_Summary -->
<!-- Get the IBM_Admin_Summary information for SearchTermAssociations of the specified AssociationType that contains the specified SearchTerm -->
<!-- This access profile includes all columns from the following table:  SRCHTERMASSOC and SRCHTERM -->
<!-- @param AssociationType Retrieve STAs of this association type. The value specified in the XPath is the external value used in the logical model. 
                            The value used in the SQL is the integer value stored in the database. The conversion is done by SearchTermAssociationSQLComposer. -->   
<!-- @param SearchTerms Retrieve STAs that contain this input search term. -->   
<!-- @param STOREPATH:catalog Retrieve STAs that are defined in the current storepath. -->   
<!-- @param CONTROL:LANGUAGES Retrieve STAs that are defined in the specified data languages. -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/SearchTermAssociation[AssociationType= and (SearchTerms=)]+IBM_Admin_Summary
	base_table=SRCHTERMASSOC
	className=com.ibm.commerce.search.facade.server.services.dataaccess.db.jdbc.SearchTermAssociationSQLComposer
	dbtype=db2
	sql=
	     SELECT 
	        SRCHTERMASSOC.$COLS:SRCHTERMASSOC$,
            SRCHTERM.$COLS:SRCHTERM$
	     FROM
	        SRCHTERMASSOC LEFT OUTER JOIN SRCHTERM ON SRCHTERM.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID
	     WHERE
	        SRCHTERMASSOC.STOREENT_ID in ($STOREPATH:catalog$)AND 
	        SRCHTERMASSOC.LANGUAGE_ID in ($CONTROL:LANGUAGES$) AND
	        SRCHTERMASSOC.ASSOCIATIONTYPE = ?AssociationType? AND
	        EXISTS (SELECT 
	        			1 
	        		FROM 
	        			SRCHTERM SRCHTERM2
	        		WHERE  
	        			SRCHTERM2.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID AND
	        			UPPER(SRCHTERM2.TERM) = UPPER(CAST(?SearchTerms? AS VARCHAR(254))) AND
	        			SRCHTERM2.TYPE = 1
	        	   )
	dbtype=any
	sql=
	     SELECT 
	        SRCHTERMASSOC.$COLS:SRCHTERMASSOC$,
            SRCHTERM.$COLS:SRCHTERM$
	     FROM
	        SRCHTERMASSOC LEFT OUTER JOIN SRCHTERM ON SRCHTERM.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID
	     WHERE
	        SRCHTERMASSOC.STOREENT_ID in ($STOREPATH:catalog$)AND 
	        SRCHTERMASSOC.LANGUAGE_ID in ($CONTROL:LANGUAGES$) AND
	        SRCHTERMASSOC.ASSOCIATIONTYPE = ?AssociationType? AND
	        EXISTS (SELECT 
	        			1 
	        		FROM 
	        			SRCHTERM SRCHTERM2
	        		WHERE  
	        			SRCHTERM2.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID AND
	        			UPPER(SRCHTERM2.TERM) = UPPER(?SearchTerms?) AND
	        			SRCHTERM2.TYPE = 1
	        	   )	        	                                     
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /SearchTermAssociation -->
<!-- AccessProfile:	IBM_Admin_Summary -->
<!-- Get the IBM_Admin_Summary information for SearchTermAssociations of the current master catalog -->
<!-- This access profile includes all columns from the following table:  SRCHTERMASSOC and SRCHTERM -->
<!-- @param CTX:STORE_ID The current store ID. The master catalog will be derived from this store ID.  -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/SearchTermAssociation+IBM_Admin_Summary
	base_table=SRCHTERMASSOC
	dbtype=oracle
	sql=
	     SELECT 
	        SRCHTERMASSOC.$COLS:SRCHTERMASSOC$,
            SRCHTERM.$COLS:SRCHTERM$
	     FROM
	        SRCHTERMASSOC LEFT OUTER JOIN SRCHTERM ON SRCHTERM.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID
	     WHERE
	        SRCHTERMASSOC.STATUS = 1 AND
	        SRCHTERMASSOC.TYPE is null AND
	        SRCHTERMASSOC.SCOPE =         
	        	(SELECT 
					TO_CHAR(STORECAT.CATALOG_ID)
				FROM
					STORECAT
		    	WHERE
		           	( STORECAT.STOREENT_ID = $CTX:STORE_ID$ 
		           	  OR STORECAT.STOREENT_ID in (select STOREREL.RELATEDSTORE_ID from STOREREL where STOREREL.STORE_ID = $CTX:STORE_ID$ and STRELTYP_ID = -4 and sequence = 1)
		           	)    
					AND STORECAT.MASTERCATALOG = '1'
				)
	dbtype=any				
	sql=
	     SELECT 
	        SRCHTERMASSOC.$COLS:SRCHTERMASSOC$,
            SRCHTERM.$COLS:SRCHTERM$
	     FROM
	        SRCHTERMASSOC LEFT OUTER JOIN SRCHTERM ON SRCHTERM.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID
	     WHERE
	        SRCHTERMASSOC.STATUS = 1 AND
	        SRCHTERMASSOC.TYPE is null AND
	        SRCHTERMASSOC.SCOPE =         
	        	(SELECT 
					CHAR(STORECAT.CATALOG_ID)
				FROM
					STORECAT
		    	WHERE
		           	( STORECAT.STOREENT_ID = $CTX:STORE_ID$ 
		           	  OR STORECAT.STOREENT_ID in (select STOREREL.RELATEDSTORE_ID from STOREREL where STOREREL.STORE_ID = $CTX:STORE_ID$ and STRELTYP_ID = -4 and sequence = 1)
		           	)    
					AND STORECAT.MASTERCATALOG = '1'
				)
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /SearchTermAssociation[(AssociationType=) and (SearchTerms=)] -->
<!-- AccessProfile:	IBM_Admin_Summary -->
<!-- Get the IBM_Admin_Summary information for SearchTermAssociations of the specified AssociationType that contains the specified SearchTerm -->
<!-- This access profile includes all columns from the following table:  SRCHTERMASSOC and SRCHTERM -->
<!-- @param AssociationType Retrieve STAs of this association type. The value specified in the XPath is the external value used in the logical model. 
                            The value used in the SQL is the integer value stored in the database. The conversion is done by SearchTermAssociationSQLComposer. -->   
<!-- @param SearchTerms Retrieve STAs that contain this input search term. -->   
<!-- @param STOREPATH:catalog Retrieve STAs that are defined in the current storepath. -->   
<!-- @param CONTROL:LANGUAGES Retrieve STAs that are defined in the specified data languages. -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/SearchTermAssociation[(AssociationType=) and (SearchTerms=)]+IBM_Admin_Summary
	base_table=SRCHTERMASSOC
	className=com.ibm.commerce.search.facade.server.services.dataaccess.db.jdbc.SearchTermAssociationSQLComposer
	dbtype=db2
	sql=
	     SELECT 
	        SRCHTERMASSOC.$COLS:SRCHTERMASSOC$,
            SRCHTERM.$COLS:SRCHTERM$
	     FROM
	        SRCHTERMASSOC LEFT OUTER JOIN SRCHTERM ON SRCHTERM.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID
	     WHERE
	        SRCHTERMASSOC.STOREENT_ID in ($STOREPATH:catalog$)AND 
	        SRCHTERMASSOC.LANGUAGE_ID in ($CONTROL:LANGUAGES$) AND
	        SRCHTERMASSOC.ASSOCIATIONTYPE in (?AssociationType?) AND
	        EXISTS (SELECT 
	        			1 
	        		FROM 
	        			SRCHTERM SRCHTERM2
	        		WHERE  
	        			SRCHTERM2.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID AND
	        			UPPER(SRCHTERM2.TERM) = UPPER(CAST(?SearchTerms? AS VARCHAR(254))) AND
	        			SRCHTERM2.TYPE = 1
	        	   )
	dbtype=any
	sql=
	     SELECT 
	        SRCHTERMASSOC.$COLS:SRCHTERMASSOC$,
            SRCHTERM.$COLS:SRCHTERM$
	     FROM
	        SRCHTERMASSOC LEFT OUTER JOIN SRCHTERM ON SRCHTERM.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID
	     WHERE
	        SRCHTERMASSOC.STOREENT_ID in ($STOREPATH:catalog$)AND 
	        SRCHTERMASSOC.LANGUAGE_ID in ($CONTROL:LANGUAGES$) AND
	        SRCHTERMASSOC.ASSOCIATIONTYPE in (?AssociationType?) AND
	        EXISTS (SELECT 
	        			1 
	        		FROM 
	        			SRCHTERM SRCHTERM2
	        		WHERE  
	        			SRCHTERM2.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID AND
	        			UPPER(SRCHTERM2.TERM) = UPPER(?SearchTerms?) AND
	        			SRCHTERM2.TYPE = 1
	        	   )	        	                                     
END_XPATH_TO_SQL_STATEMENT