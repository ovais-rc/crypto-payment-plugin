<!-- TODO: This is a sample query template file. -->
<!-- Please modify to match your implementation. -->

BEGIN_SYMBOL_DEFINITIONS
	
		<!-- PREQUATION table -->
		COLS:PREQUATION = PREQUATION:* 
		COLS:PREQUATION_ID = PREQUATION:PREQUATION_ID
		COLS:PREQUATION_ID_NAME = PREQUATION:PREQUATION_ID,IDENTIFIER,DESCRIPTION
		
		<!-- PREQENTRY table -->
		COLS:PREQENTRY = PREQENTRY:*
		
		<!-- PREQENTRYTYPE table -->
		COLS:PREQENTRYTYPE = PREQENTRYTYPE:* 
		
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- XPath: /PriceEquation/FormulaIdentifier[(UniqueID=)]                   	  -->
<!-- This SQL will return the data of the PriceEquation noun for the specified    -->
<!-- unique identifier. Multiple results are returned                         -->
<!-- if multiple identifiers are specified.                                   -->
<!-- AccessProfile: IBM_Admin_Summary        								  -->
<!-- @param FormulaIdentifier The identifier of the price equation to retrieve.    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceEquation/FormulaIdentifier[(UniqueID=)]+IBM_Admin_Summary 
	base_table=PREQUATION
	sql=	
		SELECT
				PREQUATION.$COLS:PREQUATION_ID_NAME$  	     				
	    FROM
	     		PREQUATION
	    WHERE
				PREQUATION.PREQUATION_ID = ?UniqueID? 

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceEquation/FormulaIdentifier[(UniqueID=)]                   	  -->
<!-- This SQL will return the data of the PriceEquation noun for the specified    -->
<!-- unique identifier. Multiple results are returned                         -->
<!-- if multiple identifiers are specified.                                   -->
<!-- AccessProfile: IBM_Admin_Details        								  -->
<!-- @param FormulaIdentifier The identifier of the price equation to retrieve.    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceEquation/FormulaIdentifier[(UniqueID=)]+IBM_Admin_Details 
	base_table=PREQUATION
	sql=	
		SELECT 
	     		PREQUATION.$COLS:PREQUATION$ 	     				
	    FROM
	     		PREQUATION
	    WHERE
				PREQUATION.PREQUATION_ID = ?UniqueID? AND PREQUATION.MARKFORDELETE = 0 

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceEquation                                                        -->
<!-- This SQL will return the price equation in a specific store including its    -->
<!-- asset stores.                                                            -->
<!-- AccessProfile: IBM_Admin_Summary        								  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  	name=/PriceEquation+IBM_Admin_Summary
  	base_table=PREQUATION
  	sql=
      	SELECT 
        		PREQUATION.$COLS:PREQUATION$
		FROM
        		PREQUATION
    	WHERE
        		PREQUATION.STOREENT_ID IN ($STOREPATH:pricerule$) AND PREQUATION.MARKFORDELETE = 0 
    paging_count
  	sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
        		PREQUATION
    	WHERE
        		PREQUATION.STOREENT_ID IN ($STOREPATH:pricerule$) AND PREQUATION.MARKFORDELETE = 0
        		
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceEquation[FormulaIdentifier[ExternalIdentifier[Name=]]]        -->
<!-- This SQL will return the data of the PriceEquation noun for the specified    -->
<!-- name.                                    		                          -->
<!-- AccessProfile: IBM_Admin_Details        								  -->
<!-- @param Name The name of the price equation to retrieve.                      -->
<!-- @param Context:StoreID The store for which to retrieve the price equation.   -->
<!--        The parameter is retrieved from within the business context.      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceEquation[FormulaIdentifier[ExternalIdentifier[Name=]]]+IBM_Admin_Details 
	base_table=PREQUATION
	sql=
		SELECT 
				PREQUATION.$COLS:PREQUATION$
		FROM
				PREQUATION
		WHERE
				PREQUATION.IDENTIFIER IN (?Name?) AND PREQUATION.STOREENT_ID IN ($CTX:STORE_ID$) 
				AND PREQUATION.MARKFORDELETE = 0 
							
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceEquation[FormulaIdentifier[ExternalIdentifier[Name= and StoreIdentifier[UniqueID=]]]]        -->
<!-- This SQL will return the data of the PriceEquation noun for the specified    -->
<!-- name using store path.                                    		                          -->
<!-- AccessProfile: IBM_Admin_Details        								  -->
<!-- @param Name The name of the price equation to retrieve.                      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceEquation[FormulaIdentifier[ExternalIdentifier[Name= and StoreIdentifier[UniqueID=]]]]+IBM_Admin_Details 
	base_table=PREQUATION
	sql=
		SELECT 
				PREQUATION.$COLS:PREQUATION$
		FROM
				PREQUATION
		WHERE
				PREQUATION.IDENTIFIER IN (?Name?) AND PREQUATION.STOREENT_ID IN ($STOREPATH:pricerule$)
				AND PREQUATION.MARKFORDELETE = 0 
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceEquation/FormulaIdentifier[(UniqueID=)]                   	  -->
<!-- This SQL will return the detailed entry data of the PriceEquation noun for the specified   -->
<!-- unique identifier. Multiple results are returned                         -->
<!-- if multiple identifiers are specified.                                   -->
<!-- AccessProfile: IBM_Admin_PriceEquationEntryDetails        				  -->
<!-- @param FormulaIdentifier The identifier of the price equation to retrieve.   -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceEquation/FormulaIdentifier[(UniqueID=)]+IBM_Admin_PriceEquationEntryDetails 
	base_table=PREQUATION
	sql=	
		SELECT 
	     		PREQUATION.$COLS:PREQUATION$,
	     		PREQENTRY.$COLS:PREQENTRY$,
				PREQENTRYTYPE.$COLS:PREQENTRYTYPE$	     				
	    FROM
	     		PREQUATION,PREQENTRY,PREQENTRYTYPE
	    WHERE
				PREQUATION.PREQUATION_ID = ?UniqueID? AND
				PREQUATION.PREQUATION_ID = PREQENTRY.PREQUATION_ID AND
				PREQENTRY.PREQENTRYTYPE_ID = PREQENTRYTYPE.PREQENTRYTYPE_ID
				AND PREQUATION.MARKFORDELETE = 0 

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceEquation[PriceEquationEntry[PriceEquationEntryIdentifier[(UniqueID=)]]]        -->
<!-- This SQL will return the detailed entry data of the PriceEquation noun for the specified    -->
<!-- unique identifier. 						                              -->
<!-- AccessProfile: IBM_Admin_PriceEquationEntryDetails        				  -->
<!-- @param FormulaIdentifier The identifier of the price equation to retrieve.    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceEquation[PriceEquationEntry[PriceEquationEntryIdentifier[(UniqueID=)]]]+IBM_Admin_PriceEquationEntryDetails 
	base_table=PREQUATION
	sql=	
		SELECT 
	     		PREQUATION.$COLS:PREQUATION$,
	     		PREQENTRY.$COLS:PREQENTRY$,
				PREQENTRYTYPE.$COLS:PREQENTRYTYPE$	     				
	    FROM
	     		PREQUATION,PREQENTRY,PREQENTRYTYPE
	    WHERE
				PREQENTRY.PREQENTRY_ID = ?UniqueID? AND
				PREQUATION.PREQUATION_ID = PREQENTRY.PREQUATION_ID AND
				PREQENTRY.PREQENTRYTYPE_ID = PREQENTRYTYPE.PREQENTRYTYPE_ID
				AND PREQUATION.MARKFORDELETE = 0 

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PRICEEQUATIONENTRY[PREQUATION_ID=]                                     -->
<!-- This SQL will return the price equation entry data for the specified equation-->
<!-- identifier.                                                              -->
<!-- AccessProfile: IBM_Admin_Details        								  -->
<!-- @param PREQUATION_ID The identifier of the equation.                       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PRICEEQUATIONENTRY[PREQUATION_ID=]+IBM_Admin_Details
	base_table=PREQENTRY
	sql=
		SELECT 
				PREQENTRY.$COLS:PREQENTRY$,
				PREQENTRYTYPE.$COLS:PREQENTRYTYPE$
		FROM
				PREQENTRY,PREQENTRYTYPE
		WHERE
				PREQENTRY.PREQUATION_ID = ?PREQUATION_ID? AND
				PREQENTRY.PREQENTRYTYPE_ID = PREQENTRYTYPE.PREQENTRYTYPE_ID
		ORDER BY SEQUENCE ASC
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceEquation[PriceEquationEntry[PriceEquationEntryFormat= and Value=]]  -->
<!-- This SQL will return the price equation data for the specified equation entry type and value.-->
<!-- identifier.                                                              -->
<!-- AccessProfile: IBM_Admin_Details        								  -->
<!-- @param PriceEquationEntryFormat The type of the equation entry.          -->
<!-- @param Value The value of the equation entry.                            -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceEquation[PriceEquationEntry[PriceEquationEntryFormat= and Value=]]+IBM_Admin_Details
	base_table=PREQUATION
	sql=
		SELECT 
				PREQUATION.$COLS:PREQUATION$,
				PREQENTRY.$COLS:PREQENTRY$,
				PREQENTRYTYPE.$COLS:PREQENTRYTYPE$
		FROM
				PREQUATION,PREQENTRY,PREQENTRYTYPE
		WHERE
				PREQUATION.PREQUATION_ID = PREQENTRY.PREQUATION_ID AND
				PREQENTRY.PREQENTRYTYPE_ID = PREQENTRYTYPE.PREQENTRYTYPE_ID AND
				PREQENTRYTYPE.IDENTIFIER = ?PriceEquationEntryFormat? AND
				PREQENTRY.VALUE = ?Value? AND PREQUATION.STOREENT_ID IN ($STOREPATH:pricerule$) AND
				PREQUATION.MARKFORDELETE = 0 
	
	paging_count
  	sql =
    SELECT  
        COUNT(DISTINCT PREQUATION.PREQUATION_ID) as countrows	  
		FROM
				PREQUATION,PREQENTRY,PREQENTRYTYPE
		WHERE
				PREQUATION.PREQUATION_ID = PREQENTRY.PREQUATION_ID AND
				PREQENTRY.PREQENTRYTYPE_ID = PREQENTRYTYPE.PREQENTRYTYPE_ID AND
				PREQENTRYTYPE.IDENTIFIER = ?PriceEquationEntryFormat? AND
				PREQENTRY.VALUE = ?Value? AND PREQUATION.STOREENT_ID IN ($STOREPATH:pricerule$)	AND
				PREQUATION.MARKFORDELETE = 0 						
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceEquation[PriceEquationEntry[PriceEquationEntryFormat= and Value=]]  -->
<!-- This SQL will return the price equation data for the specified equation entry type and value.-->
<!-- The one above only fetches those in current context store path for price rule	-->
<!-- identifier.                                                              -->
<!-- AccessProfile: IBM_Admin_Details        								  -->
<!-- @param PriceEquationEntryFormat The type of the equation entry.          -->
<!-- @param Value The value of the equation entry.                            -->
<!-- ======================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceEquation[PriceEquationEntry[PriceEquationEntryFormat= and Value=]]+IBM_Admin_Summary
	base_table=PREQUATION
	sql=
		SELECT 
				PREQUATION.$COLS:PREQUATION$,
				PREQENTRY.$COLS:PREQENTRY$,
				PREQENTRYTYPE.$COLS:PREQENTRYTYPE$
		FROM
				PREQUATION,PREQENTRY,PREQENTRYTYPE
		WHERE
				PREQUATION.PREQUATION_ID = PREQENTRY.PREQUATION_ID AND
				PREQENTRY.PREQENTRYTYPE_ID = PREQENTRYTYPE.PREQENTRYTYPE_ID AND
				PREQENTRYTYPE.IDENTIFIER = ?PriceEquationEntryFormat? AND
				PREQENTRY.VALUE = ?Value? AND PREQUATION.MARKFORDELETE = 0
	
	paging_count
  	sql =
    SELECT  
        COUNT(DISTINCT PREQUATION.PREQUATION_ID) as countrows	  
		FROM
				PREQUATION,PREQENTRY,PREQENTRYTYPE
		WHERE
				PREQUATION.PREQUATION_ID = PREQENTRY.PREQUATION_ID AND
				PREQENTRY.PREQENTRYTYPE_ID = PREQENTRYTYPE.PREQENTRYTYPE_ID AND
				PREQENTRYTYPE.IDENTIFIER = ?PriceEquationEntryFormat? AND
				PREQENTRY.VALUE = ?Value? AND PREQUATION.MARKFORDELETE = 0							
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceEquation[search()] 											  -->
<!-- This SQL will return the price equation that match the specified search      -->
<!-- criteria.   															  -->
<!-- AccessProfile: IBM_Admin_Summary        				                  -->
<!-- @param Context:StoreID The store for which to retrieve the price equation.   -->
<!--        The parameter is retrieved from within the business context.      -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PriceEquation[search()]
  base_table=PREQUATION
  sql=
    SELECT 
        PREQUATION.$COLS:PREQUATION$ 
    FROM
        PREQUATION,$ATTR_TBLS$
    WHERE
        PREQUATION.STOREENT_ID IN ($STOREPATH:pricerule$) AND PREQUATION.MARKFORDELETE = 0 
        AND PREQUATION.$ATTR_CNDS$
    ORDER BY PREQUATION.IDENTIFIER
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return the summary of the price equation.           -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Equation_Name
	base_table=PREQUATION
	sql=
		SELECT 
				PREQUATION.$COLS:PREQUATION$
		FROM
				PREQUATION
		WHERE
				PREQUATION.PREQUATION_ID in ($ENTITY_PKS$)
	  								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- Price Equation Summary Details Access Profile                                -->
<!-- This profile returns the summary of the price equation.                      -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
    name=IBM_Admin_Summary
    BEGIN_ENTITY 
    	base_table=PREQUATION
    	className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
    	associated_sql_statement=IBM_Equation_Name         
    END_ENTITY
END_PROFILE

