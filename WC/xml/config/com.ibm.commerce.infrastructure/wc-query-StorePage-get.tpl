<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2010                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS
<!-- All the columns of the page layout type table -->
COLS:PAGELAYOUTTYPE_ALL = PAGELAYOUTTYPE:*
<!-- All the columns of the store page layout type relation table -->
COLS:STOREPLTYPES_ALL = STOREPLTYPES:*
<!-- The primary key column of the page layout type table -->
COLS:PAGELAYOUTTYPE_ID = PAGELAYOUTTYPE:PAGELAYOUTTYPE_ID
END_SYMBOL_DEFINITIONS

<!-- =========================================================================================================== -->
<!-- This SQL will return all the page layout types applicable for a store				                         -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/StorePage
	base_table=PAGELAYOUTTYPE
    sql=
		  SELECT 
		  		PAGELAYOUTTYPE.$COLS:PAGELAYOUTTYPE_ID$
		  FROM 
		  		PAGELAYOUTTYPE, STOREPLTYPES
		  WHERE 
		  		STOREPLTYPES.STOREENT_ID IN ($STOREPATH:view$, 0) 
		  		AND 
		  		STOREPLTYPES.PAGELAYOUTTYPE_ID=PAGELAYOUTTYPE.PAGELAYOUTTYPE_ID
END_XPATH_TO_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return the store page type identified by the page type										-->
<!-- @param PageType the store page type												                         -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/StorePage[PageType=]
	base_table=PAGELAYOUTTYPE
    sql=
		  SELECT 
		  		PAGELAYOUTTYPE.$COLS:PAGELAYOUTTYPE_ID$
		  FROM 
		  		PAGELAYOUTTYPE, STOREPLTYPES
		  WHERE 
		  		STOREPLTYPES.STOREENT_ID IN ($STOREPATH:view$, 0) 
		  		AND 
		  		STOREPLTYPES.PAGELAYOUTTYPE_ID=PAGELAYOUTTYPE.PAGELAYOUTTYPE_ID
		  		AND PAGELAYOUTTYPE.PAGELAYOUTTYPE_ID = ?PageType?
END_XPATH_TO_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return the store page type using the search criteria specified. The search is restricted to static pages. -->
<!-- @param search The search condition.												                         -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/StorePage[search()]
	base_table=PAGELAYOUTTYPE
    sql=
		  SELECT 
		  		PAGELAYOUTTYPE.$COLS:PAGELAYOUTTYPE_ID$
		  FROM 
		  		PAGELAYOUTTYPE, STOREPLTYPES, $ATTR_TBLS$
		  WHERE 
		  		PAGELAYOUTTYPE.ISSTATIC = 1 
		  		AND
		  		STOREPLTYPES.PAGELAYOUTTYPE_ID=PAGELAYOUTTYPE.PAGELAYOUTTYPE_ID
		  		AND
		  		STOREPLTYPES.STOREENT_ID IN ($STOREPATH:view$, 0) 
		  		AND 
		  		$ATTR_CNDS$
END_XPATH_TO_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return details of the page layout types selected				                         -->
<!-- =========================================================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
name=IBM_PageLayoutTypeDetails
	base_table=PAGELAYOUTTYPE
	sql=
		SELECT 
			PAGELAYOUTTYPE.$COLS:PAGELAYOUTTYPE_ALL$,
			STOREPLTYPES.$COLS:STOREPLTYPES_ALL$
		FROM
			PAGELAYOUTTYPE, STOREPLTYPES
		WHERE
			PAGELAYOUTTYPE.PAGELAYOUTTYPE_ID IN ($ENTITY_PKS$) 
			AND 
			PAGELAYOUTTYPE.PAGELAYOUTTYPE_ID=STOREPLTYPES.PAGELAYOUTTYPE_ID
			AND
			STOREPLTYPES.STOREENT_ID IN ($STOREPATH:view$, 0)
END_ASSOCIATION_SQL_STATEMENT


<!-- =========================================================================================================== -->
<!-- This access profile returns the details of the page layout type				                         -->
<!-- =========================================================================================================== -->
BEGIN_PROFILE
name=IBM_Admin_Summary
 	BEGIN_ENTITY 
     base_table=PAGELAYOUTTYPE
     associated_sql_statement=IBM_PageLayoutTypeDetails
    END_ENTITY
END_PROFILE
