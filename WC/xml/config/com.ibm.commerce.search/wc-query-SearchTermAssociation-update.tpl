BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun SearchTermAssociation  -->
		<!-- Defining all columns of the table -->
		COLS:SRCHTERMASSOC = SRCHTERMASSOC:* 	
		
		<!-- Defining the unique ID column of the table -->
		COLS:SRCHTERMASSOC_ID = SRCHTERMASSOC:SRCHTERMASSOC_ID
		
		COLS:SRCHTERM = SRCHTERM:* 		
		
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- XPath: /SearchTermAssociation[(UniqueID=)]-->
<!-- AccessProfile:	IBM_Admin_SearchTermAssociationUpdate -->
<!-- Get the information for SearchTermAssociation with specified unique ID for an update operation -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique ID of the SearchTermAssociation to retrieve. -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/SearchTermAssociation[(UniqueID=)]+IBM_Admin_SearchTermAssociationUpdate
	base_table=SRCHTERMASSOC
	sql=	
		SELECT 
	     	SRCHTERMASSOC.$COLS:SRCHTERMASSOC$,
	     	SRCHTERM.$COLS:SRCHTERM$
	     FROM
	        SRCHTERMASSOC LEFT OUTER JOIN SRCHTERM ON SRCHTERM.SRCHTERMASSOC_ID = SRCHTERMASSOC.SRCHTERMASSOC_ID
	     WHERE
			SRCHTERMASSOC.SRCHTERMASSOC_ID in (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT


