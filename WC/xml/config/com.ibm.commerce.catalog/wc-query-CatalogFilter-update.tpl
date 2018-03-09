BEGIN_SYMBOL_DEFINITIONS
	<!-- CATFILTER table -->
	COLS:CATFILTER=CATFILTER:*
	COLS:CATFILTER_ID=CATFILTER:CATFILTER_ID 
	COLS:STOREENT_ID=CATFILTER:STOREENT_ID
	COLS:CATALOG_ID=CATFILTER:CATALOG_ID
	COLS:IDENTIFIER=CATFILTER:IDENTIFIER
	
	<!-- CATFLTDSC table -->
	COLS:CATFLTDSC=CATFLTDSC:*
	
	<!-- CFPRODUCTSET table -->
	COLS:CFPRODUCTSET=CFPRODUCTSET:*
	
	<!-- PRODUCTSET table -->
	COLS:PRODUCTSET=PRODUCTSET:*
	
	<!-- PRSETCEREL table -->
  COLS:PRSETCEREL=PRSETCEREL:*
	
	<!-- CFCATGROUP table -->
	COLS:CFCATGROUP=CFCATGROUP:*

  <!-- CFCONDGRP table -->
  COLS:CFCONDGRP=CFCONDGRP:*
  
  <!-- CFCOND table -->
  COLS:CFCOND=CFCOND:*
	
	
  <!-- CFCONDVAL table -->
  COLS:CFCONDVAL=CFCONDVAL:*
	
	
END_SYMBOL_DEFINITIONS

<!-- ====================================================================== 
	Get the catfilter(s) of the store having the specified value for unique id(s)
	@param UniqueID The unique id of the catfilter . 
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/CatalogFilter[CatalogFilterIdentifier[(UniqueID=)]]+IBM_Admin_IdResolve
	base_table=CATFILTER
	sql=
			SELECT 
	     				CATFILTER.$COLS:CATFILTER$
	     	FROM
	     				CATFILTER	     									  
	     	WHERE
						CATFILTER.CATFILTER_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog filter(s) of the store having the specified value for identifier(s)
	@param Identifier The identifier of the catalog filter. 
	@param catalogID The catalog id of the catalog filter. 
	@param Context:STORE_ID The store for which to retrieve the catalog . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/CatalogFilter[CatalogFilterIdentifier[ExternalIdentifier[(Identifier=) and (@catalogID=)]]]+IBM_Admin_IdResolve
	base_table=CATFILTER
	sql=
			SELECT 
	     				CATFILTER.$COLS:CATFILTER_ID$
	     	FROM
	     				CATFILTER	     									  
	     	WHERE
						CATFILTER.IDENTIFIER=?Identifier?						
						 AND CATFILTER.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the inclusion/exclusion productset(s) of the a catalog filter with the specified value for unique id(s).
	@param UniqueID The unique id of the catfilter . 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/CatalogFilter[CatalogFilterIdentifier[(UniqueID=)]]+IBM_Admin_Resolve_Productsets_For_Deletion
	base_table=PRODUCTSET
	sql=
			SELECT 
	     				PRODUCTSET.$COLS:PRODUCTSET$
	     	FROM
	     				PRODUCTSET	     									  
	     	WHERE
						PRODUCTSET.PRODUCTSET_ID IN (SELECT PRODUCTSET_ID FROM CFPRODUCTSET WHERE CATFILTER_ID = ?UniqueID?)
END_XPATH_TO_SQL_STATEMENT



<!-- ====================================================================== 
	Get the catalog filter description(s)
	@param UniqueID The unique id of the catalog filter. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/CatalogFilter[CatalogFilterIdentifier[(UniqueID=)]]+IBM_Admin_CatalogFilterDescriptionUpdate
	base_table=CATFLTDSC
	sql=
			SELECT 
	     				CATFLTDSC.$COLS:CATFLTDSC$
	     	FROM
	     				CATFLTDSC	     									  
	     	WHERE
						CATFLTDSC.CATFILTER_ID IN (?UniqueID?)				
						
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog filter associated product set(s) and corresponding catalog entry(s).
	@param UniqueID The unique id of the catalog filter. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/CatalogFilter[CatalogFilterIdentifier[(UniqueID=)]]+IBM_Admin_CatalogFilterProductSetSelectionUpdate
	base_table=CFPRODUCTSET
	sql=
			SELECT 
	     				CFPRODUCTSET.$COLS:CFPRODUCTSET$,
	     				PRODUCTSET.$COLS:PRODUCTSET$,
	     				PRSETCEREL.$COLS:PRSETCEREL$
	     	FROM
	     				CFPRODUCTSET 
	     				LEFT OUTER JOIN PRODUCTSET ON CFPRODUCTSET.PRODUCTSET_ID = PRODUCTSET.PRODUCTSET_ID
	     				LEFT OUTER JOIN PRSETCEREL ON PRSETCEREL.PRODUCTSET_ID = PRODUCTSET.PRODUCTSET_ID  						  
	     	WHERE
						CFPRODUCTSET.CATFILTER_ID IN (?UniqueID?)				
						
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog filter associated catalog groups.
	@param UniqueID The unique id of the catalog filter. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/CatalogFilter[CatalogFilterIdentifier[(UniqueID=)]]+IBM_Admin_CatalogFilterCatalogGroupSelectionUpdate
	base_table=CFCATGROUP
	sql=
			SELECT 
	     				CFCATGROUP.$COLS:CFCATGROUP$
	     	FROM
	     				CFCATGROUP	     									  
	     	WHERE
						CFCATGROUP.CATFILTER_ID IN (?UniqueID?)				
						
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the condition groups by their unique IDs.
	@param UniqueID The unique ids of the condition groups. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/CatalogFilter/CatalogGroupSelection/ConditionGroup[ConditionGroupIdentifier[(UniqueID=)]]+IBM_Admin_ConditionGroupUpdate
	base_table=CFCONDGRP
	sql=
			SELECT 
	     				CFCONDGRP.$COLS:CFCONDGRP$
	     	FROM
	     				CFCONDGRP	     									  
	     	WHERE
						CFCONDGRP.CFCONDGRP_ID IN (?UniqueID?)						
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the condition groups by their identifier.
	@param UniqueID The unique ids of the condition groups. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/CatalogFilter[CatalogFilterIdentifier[(UniqueID=)]]/CatalogGroupSelection/ConditionGroup[ConditionGroupIdentifier[ExternalIdentifier[(Identifier=)]]]+IBM_Admin_ConditionGroupFindByIdentifier
	base_table=CFCONDGRP
	sql=
			SELECT 
	     				CFCONDGRP.$COLS:CFCONDGRP$
	     	FROM
	     				CFCONDGRP	     									  
	     	WHERE
					CFCONDGRP.IDENTIFIER = ?Identifier?  AND CFCONDGRP.CFCATGROUP_ID IN (SELECT CFCATGROUP_ID FROM CFCATGROUP WHERE CATFILTER_ID = ?UniqueID?)
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the catalog filter conditions.
	@param UniqueID The unique id of the catalog filter condition. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/CatalogFilterCondition[CatalogFilterConditionIdentifier[(UniqueID=)]]+IBM_Admin_CatalogFilterConditionUpdate
	base_table=CFCOND
	sql=
			SELECT 
	     				CFCOND.$COLS:CFCOND$,
	     				CFCONDVAL.$COLS:CFCONDVAL$
	     	FROM
	     				CFCOND LEFT OUTER JOIN CFCONDVAL ON CFCOND.CFCOND_ID = CFCONDVAL.CFCOND_ID	     									  
	     	WHERE
						CFCOND.CFCOND_ID IN (?UniqueID?)				
						
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog filter condition values.
	@param UniqueID The unique id of the catalog filter condition value. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/CatalogFilter/CatalogGroupSelection/ConditionGroup/Condition/ConditionAttributeValue[ConditionValueIdentifier[(UniqueID=)]]+IBM_Admin_CatalogFilterConditionValueUpdate
	base_table=CFCONDVAL
	sql=
			SELECT 
	     				CFCONDVAL.$COLS:CFCONDVAL$
	     	FROM
	     				CFCONDVAL	     									  
	     	WHERE
						CFCONDVAL.CFCONDVAL_ID IN (?UniqueID?)						
END_XPATH_TO_SQL_STATEMENT