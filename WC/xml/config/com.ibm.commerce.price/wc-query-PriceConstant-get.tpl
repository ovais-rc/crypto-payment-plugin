
BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun PriceConstant  -->
		<!-- Defining all columns of the table -->
		COLS:PRCONSTANT = PRCONSTANT:* 	
		<!-- Defining the unique ID column of the table -->
		COLS:PRCONSTANT_ID = PRCONSTANT:PRCONSTANT_ID
		<!-- Defining the name column of the table -->
		COLS:PRCONSTANT_IDENTIFIER = PRCONSTANT:IDENTIFIER
		<!-- Defining the description column of the table -->
		COLS:PRCONSTANT_DESC = PRCONSTANT:DESCRIPTION
		COLS:PRCONSTANT_STOREENT_ID = PRCONSTANT:STOREENT_ID
		
	<!-- Defining all columns of the table PRCONVALUE  -->
		COLS:PRCONVALUE = PRCONVALUE:*
		
END_SYMBOL_DEFINITIONS


<!-- ================================================================================== -->
<!-- XPath: /PriceConstant -->
<!-- AccessProfile:	IBM_Admin_Summary -->
<!-- A two-step query to get all PRCONSTANT for a specific store. -->
<!-- All access profile includes all columns from the table. -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceConstant
	base_table=PRCONSTANT
	sql=	
		SELECT 
	     				PRCONSTANT.$COLS:PRCONSTANT_ID$
	     	FROM
	     				PRCONSTANT	     				
	     	WHERE
						PRCONSTANT.STOREENT_ID IN ($STOREPATH:pricerule$) AND
						PRCONSTANT.MARKFORDELETE=0
		ORDER BY PRCONSTANT.IDENTIFIER ASC

END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /PriceConstant/PriceConstantIdentifier[(UniqueID=)] -->
<!-- AccessProfile:	IBM_Admin_Details -->
<!-- Get the all information for PriceConstant and PriceConstantValue with specified unique ID. -->
<!-- All access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique ID of PriceConstant to retrieve. -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceConstant/PriceConstantIdentifier[(UniqueID=)]+IBM_Admin_Details
	base_table=PRCONSTANT
	sql=	
		SELECT 
	     				PRCONSTANT.$COLS:PRCONSTANT$,
	     				PRCONVALUE.$COLS:PRCONVALUE$				
	     	FROM
	     				PRCONSTANT LEFT OUTER JOIN PRCONVALUE ON (PRCONSTANT.PRCONSTANT_ID = PRCONVALUE.PRCONSTANT_ID)
	     	WHERE
						PRCONSTANT.PRCONSTANT_ID IN (?UniqueID?) AND
						PRCONSTANT.MARKFORDELETE=0

END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /PriceConstant/PriceConstantIdentifier[(UniqueID=)] -->
<!-- AccessProfile:	IBM_Admin_Summary -->
<!-- Get the summary information for PRCONSTANT with the specified unique ID. -->
<!-- Summary access profile includes the unique ID. -->
<!-- @param UniqueID  Unique ID of PRCONSTANT to retrieve. -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceConstant/PriceConstantIdentifier[(UniqueID=)]+IBM_Admin_Summary
	base_table=PRCONSTANT
	sql=	
		SELECT 
	     				PRCONSTANT.$COLS:PRCONSTANT$ 
	     	FROM
	     				PRCONSTANT
	     	WHERE
						PRCONSTANT.PRCONSTANT_ID IN (?UniqueID?) AND
						PRCONSTANT.MARKFORDELETE=0 

END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /PriceConstant/PriceConstantIdentifier/ExternalIdentifier[(Name=)] -->
<!-- AccessProfile:	IBM_Admin_Summary -->
<!-- Two-step query to get the information for PRCONSTANT and PRCONVALUE with specified external ID (name). -->
<!-- @param Name  Name (External ID) of PRCONSTANT to retrieve. --> 
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceConstant/PriceConstantIdentifier/ExternalIdentifier[(Name=)]
	base_table=PRCONSTANT
	sql=	
		SELECT 
	     				PRCONSTANT.$COLS:PRCONSTANT_ID$	     				
	     	FROM
	     				PRCONSTANT
	     	WHERE
						PRCONSTANT.IDENTIFIER IN (?Name?) AND
						PRCONSTANT.STOREENT_ID IN ($STOREPATH:pricerule$) AND
						PRCONSTANT.MARKFORDELETE=0

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceConstant[search()] 										  -->
<!-- This SQL will return the price constants that match the specified search -->
<!-- criteria.   															  -->
<!-- AccessProfile: IBM_Admin_Summary        				                  -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  	name=/PriceConstant[search()]
  	base_table=PRCONSTANT
  	sql=
    	SELECT 
        		PRCONSTANT.$COLS:PRCONSTANT$ 
   	 	FROM
        		PRCONSTANT,$ATTR_TBLS$
    	WHERE
        		PRCONSTANT.STOREENT_ID IN ($STOREPATH:pricerule$) AND PRCONSTANT.MARKFORDELETE = 0 
        		AND PRCONSTANT.$ATTR_CNDS$
    	ORDER BY PRCONSTANT.IDENTIFIER
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return the summary of the price Constant.       -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_PriceConstant_Name
	base_table=PRCONSTANT
	sql=
		SELECT 
				PRCONSTANT.$COLS:PRCONSTANT$,
	     		PRCONVALUE.$COLS:PRCONVALUE$
		FROM
				PRCONSTANT LEFT OUTER JOIN PRCONVALUE ON (PRCONSTANT.PRCONSTANT_ID = PRCONVALUE.PRCONSTANT_ID)
		WHERE
				PRCONSTANT.PRCONSTANT_ID in ($ENTITY_PKS$)
	  								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- Price Constant Summary Details Access Profile                            -->
<!-- This profile returns the summary of the price Constant.                  -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
    name=IBM_Admin_Summary
    BEGIN_ENTITY 
    	base_table=PRCONSTANT
    	className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
    	associated_sql_statement=IBM_PriceConstant_Name         
    END_ENTITY
END_PROFILE