BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun PageLayout  -->
		<!-- Defining all columns of the table -->
		COLS:PAGELAYOUT = PAGELAYOUT:* 	
		<!-- Defining the unique ID column of the table -->
		COLS:PAGELAYOUT_ID = PAGELAYOUT:PAGELAYOUT_ID
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- XPath: /PageLayout/PageLayoutIdentifier[(UniqueID=)]-->
<!-- Get the information for PageLayout with specified unique ID for an update operation -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique id of PageLayout to retrieve -->   
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PageLayout[PageLayoutIdentifier[(UniqueID=)]]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$
	     	FROM
	     				PAGELAYOUT
	     	WHERE
						PAGELAYOUT.PAGELAYOUT_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================== -->
<!-- This SQL will return the data of the PageLayout noun for the specified external identifier. -->
<!-- @param Name The name of the page layout to retrieve.										 -->  
<!-- @param UniqueID - The unique ID of the store for which to retrieve the page layout.          -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PageLayout[PageLayoutExternalIdentifier[Name= and StoreIdentifier[UniqueID=]]]+IBM_IdResolve
	base_table=PAGELAYOUT
	sql=
		SELECT 			
						PAGELAYOUT.$COLS:PAGELAYOUT$
		FROM            
						PAGELAYOUT
		WHERE           
						PAGELAYOUT.NAME = ?Name? and
						PAGELAYOUT.STOREENT_ID = ?UniqueID? and
						PAGELAYOUT.STATE <> 2
END_XPATH_TO_SQL_STATEMENT

<!-- =============================================================================== -->
<!-- Get PageLayout query to retrieve all the information						     -->
<!-- =============================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_PageLayoutDetails
	base_table=PAGELAYOUT
	sql=
		SELECT 
			PAGELAYOUT.$COLS:PAGELAYOUT$
		FROM
			PAGELAYOUT
		WHERE
			PAGELAYOUT.PAGELAYOUT_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Page Layout update Access Profile. This access            -->
<!-- profile is used to get the information for updating the   -->
<!-- page layout    		       							   -->
<!-- ========================================================= -->
BEGIN_PROFILE
name=IBM_PageLayout_Update
 	BEGIN_ENTITY 
     base_table=PAGELAYOUT
     associated_sql_statement=IBM_PageLayoutDetails
    END_ENTITY
END_PROFILE

