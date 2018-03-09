
BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun PRCONSTANT  -->
		<!-- Defining all columns of the table -->
		COLS:PRCONSTANT = PRCONSTANT:* 	
		<!-- Defining the unique ID column of the table -->
		COLS:PRCONSTANT_ID = PRCONSTANT:PRCONSTANT_ID
		<!-- Defining the identifier column of the table -->
		COLS:PRCONSTANT_IDENTIFIER = PRCONSTANT:IDENTIFIER
		<!-- Defining the description column of the table -->
		COLS:PRCONSTANT_DESC = PRCONSTANT:DESCRIPTION
		
	<!-- Defining all columns of the table PRCONVALUE  -->
		COLS:PRCONVALUE = PRCONVALUE:*
		
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- XPath: /PriceConstant/PriceConstantIdentifier[(UniqueID=)]-->
<!-- AccessProfile:	IBM_Admin_Update -->
<!-- Get the information for PRCONSTANT with specified unique ID for an update operation -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique id of PRCONSTANT to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceConstant/PriceConstantIdentifier[(UniqueID=)]+IBM_Admin_Update
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
<!-- XPath: /PriceConstant/PriceConstantIdentifier/ExternalIdentifier[(Name=)] -->
<!-- AccessProfile:	IBM_Admin_IdResolve -->
<!-- Get the internal unique ID for the specified external identifier. -->
<!-- Access profile includes only the unique ID -->
<!-- @param Name  Name(External ID) of PRCONSTANT to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceConstant/PriceConstantIdentifier/ExternalIdentifier[(Name=)]+IBM_Admin_IdResolve
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

<!-- ================================================================================== --> 
<!-- XPath: /PriceConstant[PriceConstantIdentifier[(UniqueID=)]]/Values
<!-- AccessProfile: IBM_Admin_PriceConstantValue_Update
<!-- Get the value of the price constant based on the price constant id  -->
<!-- @param UniqueID The catalog entry id  -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceConstant[PriceConstantIdentifier[(UniqueID=)]]/Values+IBM_Admin_PriceConstantValue_Update
	base_table=PRCONVALUE
	sql=
		SELECT 
	     		PRCONVALUE.$COLS:PRCONVALUE$	     				
	    FROM
	     		PRCONVALUE
	    WHERE
				PRCONVALUE.PRCONSTANT_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT