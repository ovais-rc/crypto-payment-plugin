BEGIN_SYMBOL_DEFINITIONS
	
	<!-- ATTR table -->
	COLS:ATTR=ATTR:*
	COLS:ATTR_ID=ATTR:ATTR_ID
	COLS:ATTR:IDENTIFIER=ATTR:IDENTIFIER
	COLS:ATTR:ATTRUSAGE=ATTR:ATTRUSAGE
	COLS:ATTR:ATTRTYPE_ID=ATTR:ATTRTYPE_ID
	COLS:ATTR:ATTRDICT_ID=ATTR:ATTRDICT_ID
	COLS:ATTR:STOREENT_ID=ATTR:STOREENT_ID
	COLS:ATTR:SEQUENCE =ATTR:SEQUENCE 
	COLS:ATTR:DISPLAYABLE=ATTR:DISPLAYABLE
	COLS:ATTR:SEARCHABLE=ATTR:SEARCHABLE
	COLS:ATTR:COMPARABLE=ATTR:COMPARABLE
	COLS:ATTR:FACETABLE=ATTR:FACETABLE
	COLS:ATTR:MERCHANDISABLE=ATTR:MERCHANDISABLE	
	COLS:ATTR:OPTCOUNTER=ATTR:OPTCOUNTER
	
	<!-- ATTRDESC table -->
	COLS:ATTRDESC=ATTRDESC:*
	COLS:ATTRDESC:ATTR_ID=ATTRDESC:ATTR_ID
	COLS:ATTRDESC:LANGUAGE_ID=ATTRDESC:LANGUAGE_ID
	COLS:ATTRDESC:ATTRTYPE_ID=ATTRDESC:ATTRTYPE_ID
	COLS:ATTRDESC:NAME=ATTRDESC:NAME
	COLS:ATTRDESC:GROUPNAME=ATTRDESC:GROUPNAME
	COLS:ATTRDESC:DESCRIPTION=ATTRDESC:DESCRIPTION
	COLS:ATTRDESC:DESCRIPTION2=ATTRDESC:DESCRIPTION2
	COLS:ATTRDESC:QTYUNIT_ID=ATTRDESC:QTYUNIT_ID
	COLS:ATTRDESC:NOTEINFO=ATTRDESC:NOTEINFO
	COLS:ATTRDESC:FIELD1=ATTRDESC:FIELD1
	COLS:ATTRDESC:OPTCOUNTER=ATTRDESC:OPTCOUNTER

	<!-- ATTRVAL table -->
	COLS:ATTRVAL=ATTRVAL:*
	COLS:ATTRVAL_ID=ATTRVAL:ATTRVAL_ID
	COLS:ATTRVAL:ATTR_ID=ATTRVAL:ATTR_ID
	<!-- ATTRVALDESC table -->		
	COLS:ATTRVALDESC=ATTRVALDESC:*
	<!-- FACET table -->
	COLS:FACET=FACET:*

	<!-- CATENTRYATTR table -->
	COLS:CATENTRYATTR=CATENTRYATTR:*
	
<!-- ATTRDICTGRP table -->
	COLS:ATTRDICTGRP=ATTRDICTGRP:*
	COLS:ATTRDICTGRP:ATTRDICTGRP_ID=ATTRDICTGRP:ATTRDICTGRP_ID
	COLS:ATTRDICTGRP:IDENTIFIER=ATTRDICTGRP:IDENTIFIER
	COLS:ATTRDICTGRP:ATTRDICT_ID=ATTRDICTGRP:ATTRDICT_ID
	COLS:ATTRDICTGRP:STOREENT_ID=ATTRDICTGRP:STOREENT_ID
	COLS:ATTRDICTGRP:MARKFORDELETE=ATTRDICTGRP:MARKFORDELETE
	COLS:ATTRDICTGRP:OPTCOUNTER=ATTRDICTGRP:OPTCOUNTER

	

END_SYMBOL_DEFINITIONS

<!--=======================================================QUERY STATEMENTS BEGUN ============================================-->

<!-- Find the attribute dictionary attributes by attribute dictionary unique Id
     AccessProfile:	IBM_Admin_Summary, IBM_Admin_Details			
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[ExternalIdentifier[AttributeDictionaryIdentifier[(UniqueID=)]]]]
	base_table=ATTR
	sql=
		SELECT 
				ATTR.$COLS:ATTR_ID$     				
	    FROM
				ATTR				
	    WHERE
				ATTR.ATTRDICT_ID IN (?UniqueID?)
				AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
						
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================== 
     Gets the attributes according to attribute dictionary ids  
     AccessProfile:	IBM_Admin_Summary, IBM_Admin_Details                       
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[(UniqueID=)]]
	base_table=ATTR
	sql=
		SELECT 
				ATTR.$COLS:ATTR_ID$     				
	    FROM
				ATTR				
	    WHERE
				ATTR.ATTR_ID IN (?UniqueID?)
				AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
						
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================== 
     Finds the child attributes of the given attribute dictionary 
     which does not have any parent attribute groups.  
     AccessProfile:	IBM_Admin_Summary, IBM_Admin_Details                       
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[ExternalIdentifier[AttributeDictionaryIdentifier[(UniqueID=)]] and ParentAttributeGroup]]
	base_table=ATTR
	sql=
		SELECT 
				ATTR.$COLS:ATTR_ID$     				
	    FROM
				ATTR				
	    WHERE
				ATTR.ATTRDICT_ID IN (?UniqueID?)
				AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
		ORDER BY ATTR.SEQUENCE					
						
END_XPATH_TO_SQL_STATEMENT



<!-- ================================================================================================================== -->
<!-- This SQL will return the allowed values of the current page for the attribute dictionary attribute                 -->
<!-- The sorting order of the allowed values are always according to the sequence of the default language				-->
<!-- ================================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[UniqueID=]]/AllowedValue
	base_table=ATTR
	
    sql=
    
		  SELECT 
		  		DISTINCT ATTR.$COLS:ATTR_ID$, ATTRVAL.$COLS:ATTRVAL_ID$, ATTRVALDESC.SEQUENCE
		  FROM 
		  		ATTR, ATTRVAL, ATTRVALDESC
		  WHERE
		  		ATTR.ATTR_ID = ?UniqueID? AND 
		  		ATTR.ATTRUSAGE = 1 AND 
		  		ATTR.STOREENT_ID IN ($STOREPATH:catalog$) AND		  		
		  		ATTRVAL.ATTR_ID =  ATTR.ATTR_ID AND
				ATTRVAL.STOREENT_ID IN ( $STOREPATH:catalog$ ) AND
				ATTRVAL.VALUSAGE IS NOT NULL AND
				ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND
				ATTRVALDESC.LANGUAGE_ID = (SELECT LANGUAGE_ID FROM STORE WHERE STORE_ID=$CTX:STORE_ID$)
				 
		  ORDER BY 
		  	  	ATTRVALDESC.SEQUENCE	  		
    
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================================================== -->
<!-- This SQL will return the attribute and its allowed values for the given attribute dictionary attribute id and attribute value ids                -->
<!-- The sorting order of the allowed values are always according to the sequence of the language				-->
<!-- ================================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[UniqueID=]]/AllowedValue[(@identifier=)]+IBM_Admin_AttributeDictionaryAttributeAllowedValues
	base_table=ATTR
	  sql=
    
		  SELECT 
		  		DISTINCT ATTR.$COLS:ATTR$, ATTRDESC.$COLS:ATTRDESC:ATTR_ID$, ATTRDESC.$COLS:ATTRDESC:LANGUAGE_ID$, 
		  		ATTRDESC.$COLS:ATTRDESC:NAME$, ATTRVAL.$COLS:ATTRVAL$, ATTRVALDESC.$COLS:ATTRVALDESC$, FACET.$COLS:FACET$
		  FROM 
		  		ATTR
		  		JOIN ATTRVAL ON (ATTR.ATTR_ID = ATTRVAL.ATTR_ID)
		  		JOIN ATTRVALDESC ON (ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID)
					LEFT OUTER JOIN ATTRDESC ON (ATTRDESC.ATTR_ID=ATTR.ATTR_ID)
		      LEFT OUTER JOIN FACET ON (FACET.ATTR_ID=ATTR.ATTR_ID)
		  WHERE
		  		ATTRVAL.ATTR_ID=?UniqueID? AND
		  		ATTRVAL.ATTRVAL_ID IN (?identifier?) AND 
		  		ATTR.ATTRUSAGE = 1 AND 
		  		ATTR.STOREENT_ID IN ($STOREPATH:catalog$) AND	
		  		ATTRDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) AND
				  ATTRVAL.STOREENT_ID IN ( $STOREPATH:catalog$ ) AND
				  ATTRVAL.VALUSAGE IS NOT NULL AND
				  ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
				  
				
				 
		  ORDER BY 
		  	  	ATTRVALDESC.SEQUENCE	  		
    
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================================================== -->
<!-- This SQL will return the attribute and its default allowed value for the given attribute dictionary attribute id	-->
<!-- ================================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[UniqueID=]]/AllowedValue[(@default=)]+IBM_Admin_AttributeDictionaryAttributeAllowedValues
	base_table=ATTR
	  sql=
	  		SELECT 
		  		DISTINCT ATTR.$COLS:ATTR$, ATTRDESC.$COLS:ATTRDESC:ATTR_ID$, ATTRDESC.$COLS:ATTRDESC:LANGUAGE_ID$, 
		  		ATTRDESC.$COLS:ATTRDESC:NAME$, ATTRVAL.$COLS:ATTRVAL$, ATTRVALDESC.$COLS:ATTRVALDESC$, FACET.$COLS:FACET$
		  FROM 
		  		ATTR
		  		JOIN ATTRVAL ON (ATTR.ATTR_ID = ATTRVAL.ATTR_ID)
		  		JOIN ATTRVALDESC ON (ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID)
				LEFT OUTER JOIN ATTRDESC ON (ATTRDESC.ATTR_ID=ATTR.ATTR_ID)
				LEFT OUTER JOIN FACET ON (FACET.ATTR_ID=ATTR.ATTR_ID)
		  WHERE
		  		ATTRVAL.ATTR_ID=?UniqueID? AND
		  		ATTR.ATTRUSAGE = 1 AND 
		  		ATTR.STOREENT_ID IN ($STOREPATH:catalog$) AND	
		  		ATTRDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) AND
				ATTRVAL.STOREENT_ID IN ( $STOREPATH:catalog$ ) AND
				ATTRVAL.VALUSAGE = 2 AND
				ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		  	  	
END_XPATH_TO_SQL_STATEMENT

<!-- 
	========================================================== 
     Get the attribute dictionary attribute that matches the specified search
	 criteria. Possible values for the searchable property include: 
	 0: attribute is not searchable.
	 1: attribute is searchable and can be indexed to search engine.
     Access profiles supported: IBM_Admin_Summary, IBM_Admin_Details                       
    ========================================================== 
-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[search() and searchable=]
	base_table=ATTR
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=AttributeDescription/Name:254
	param=AttributeIdentifier/ExternalIdentifier/Identifier:254
	
	sql=
		SELECT 
				ATTR.$COLS:ATTR_ID$     				
	    FROM
				ATTR, $ATTR_TBLS$				
	    WHERE
				ATTR.SEARCHABLE = ?searchable?
				AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
				AND ATTR.$ATTR_CNDS$
		ORDER BY 
              	ATTR.ATTR_ID $DB:UNCOMMITTED_READ$				
END_XPATH_TO_SQL_STATEMENT

<!-- 
	========================================================== 
     Get the attribute dictionary attributes that match the
     specified search criteria and properties.
	 Possible values for the facetable property include: 
	 0: attribute is not facetable.
	 1: attribute is facetable.
	 Possible values for the merchandisable property include: 
	 0: attribute is not merchandisable.
	 1: attribute is merchandisable.
	 Possible values for the AttributeType property include: 
	 0: attribute has assigned values.
	 1: attribute has predefined values.
     Access profiles supported: IBM_Admin_Summary, IBM_Admin_Details                       
    ========================================================== 
-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[(@facetable= or @merchandisable=) and AttributeType= and search()]
	base_table=ATTR
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=AttributeDescription/Name:254
	param=AttributeIdentifier/ExternalIdentifier/Identifier:254
	
	sql=
		SELECT 
				ATTR.$COLS:ATTR_ID$     				
	    FROM
				ATTR, $ATTR_TBLS$				
	    WHERE
				(ATTR.MERCHANDISABLE = ?merchandisable? OR ATTR.FACETABLE = ?facetable?)
				AND ( (CAST (?AttributeType? AS INTEGER) = 1 AND ATTR.ATTRUSAGE = 1)
     				OR (CAST (?AttributeType? AS INTEGER) <> 1 AND (ATTR.ATTRUSAGE = 2 OR ATTR.ATTRUSAGE IS NULL)))
				AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
				AND ATTR.$ATTR_CNDS$
		ORDER BY 
              	ATTR.ATTR_ID $DB:UNCOMMITTED_READ$				
END_XPATH_TO_SQL_STATEMENT


<!-- 
	========================================================== 
     Get the attribute dictionary attribute that match the specified search
	 criteria. Possible values for the merchandisable property include: 
	 0: attribute is not merchandisable.
	 1: attribute is merchandisable.
	 Possible values for the AttributeType property include: 
	 0: attribute has assigned values.
	 1: attribute has predefined values.
     Access profiles supported: IBM_Admin_Summary, IBM_Admin_Details                       
    ========================================================== 
-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[@merchandisable= and AttributeType= and search()]
	base_table=ATTR
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=AttributeDescription/Name:254
	param=AttributeIdentifier/ExternalIdentifier/Identifier:254
	
	sql=
		SELECT 
				ATTR.$COLS:ATTR_ID$     				
	    FROM
				ATTR, $ATTR_TBLS$				
	    WHERE
				ATTR.MERCHANDISABLE = ?merchandisable?
				AND ( (CAST (?AttributeType? AS INTEGER) = 1 AND ATTR.ATTRUSAGE = 1)
     				OR (CAST (?AttributeType? AS INTEGER) <> 1 AND (ATTR.ATTRUSAGE = 2 OR ATTR.ATTRUSAGE IS NULL)))
				AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
				AND ATTR.$ATTR_CNDS$
		ORDER BY 
              	ATTR.ATTR_ID $DB:UNCOMMITTED_READ$				
END_XPATH_TO_SQL_STATEMENT

<!-- 
	========================================================== 
     Get the attribute dictionary attribute that match the specified search
	 criteria. Possible values for the facetable property include: 
	 0: attribute is not facetable.
	 1: attribute is facetable.
	 Possible values for the AttributeType property include: 
	 0: attribute has assigned values.
	 1: attribute has predefined values.
     Access profiles supported: IBM_Admin_Summary, IBM_Admin_Details                       
    ========================================================== 
-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[@facetable= and AttributeType= and search()]
	base_table=ATTR
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=AttributeDescription/Name:254
	param=AttributeIdentifier/ExternalIdentifier/Identifier:254
	
	sql=
		SELECT 
				ATTR.$COLS:ATTR_ID$     				
	    FROM
				ATTR, $ATTR_TBLS$				
	    WHERE
				ATTR.FACETABLE = ?facetable?
				AND ( (CAST (?AttributeType? AS INTEGER) = 1 AND ATTR.ATTRUSAGE = 1)
     				OR (CAST (?AttributeType? AS INTEGER) <> 1 AND (ATTR.ATTRUSAGE = 2 OR ATTR.ATTRUSAGE IS NULL)))
				AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
				AND ATTR.$ATTR_CNDS$
		ORDER BY 
              	ATTR.ATTR_ID $DB:UNCOMMITTED_READ$				
END_XPATH_TO_SQL_STATEMENT

<!-- 
	========================================================== 
     Search the attribute dictionary attribute that matches the specified search
	 criteria. 
	 1: attribute is searchable and can be indexed to search engine.
     Access profiles supported: IBM_Admin_Summary, IBM_Admin_Details                       
    ========================================================== 
-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[search()]
	base_table=ATTR
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=AttributeDescription/Name:254
	param=AttributeIdentifier/ExternalIdentifier/Identifier:254

	sql=
		SELECT 
				ATTR.$COLS:ATTR_ID$     				
	    FROM
				ATTR, $ATTR_TBLS$				
	    WHERE
				ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
				AND ATTR.$ATTR_CNDS$
		ORDER BY 
              	ATTR.ATTR_ID $DB:UNCOMMITTED_READ$				
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================== 
     Gets the attribute descriptions based on the attribute ids and 
	 the language ids.
	 @param UniqueID 
			The attribute dictionary attribute ID.
	 @param languageID
			The language ID to use for fetching the descriptions.
	 @param STOREPATH:catalog                                
			The stores for which to retrieve the description. This parameter is      
		    retrieved from within the business context.                           
     ========================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[(UniqueID=)]]/AttributeDescription[(@languageID=)]+IBM_Admin_Details
	base_table=ATTRDESC
	sql=
		SELECT 
				ATTRDESC.$COLS:ATTRDESC$    				
	    FROM
				ATTRDESC
				INNER JOIN ATTR ON ATTR.ATTR_ID=ATTRDESC.ATTR_ID
	    WHERE
				ATTR.ATTR_ID IN (?UniqueID?)
				AND ATTRDESC.LANGUAGE_ID IN (?languageID?)
				AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)						
END_XPATH_TO_SQL_STATEMENT


<!--======================================================ASSOCIATED STATEMENTS BEGIN =====================================-->	

<!-- ========================================================== 
     Adds  attribute dictionary 
     attributes (ATTR table) base information to the
     resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeBaseSchema
	base_table=ATTR
	sql=
		SELECT 
				ATTR.$COLS:ATTR_ID$,
				ATTR.$COLS:ATTR:IDENTIFIER$,
				ATTR.$COLS:ATTR:ATTRDICT_ID$,				
				ATTR.$COLS:ATTR:STOREENT_ID$,				
				ATTR.$COLS:ATTR:SEQUENCE$,
				ATTR.$COLS:ATTR:ATTRUSAGE$,
				ATTR.$COLS:ATTR:ATTRTYPE_ID$,				
				ATTR.$COLS:ATTR:DISPLAYABLE$,				
				ATTR.$COLS:ATTR:SEARCHABLE$,	
				ATTR.$COLS:ATTR:COMPARABLE$,
				ATTR.$COLS:ATTR:MERCHANDISABLE$,				
				ATTR.$COLS:ATTR:OPTCOUNTER$			
				
				
		FROM
				ATTR
				        
        WHERE
		        ATTR.ATTR_ID IN ($ENTITY_PKS$) 
		        AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
			
END_ASSOCIATION_SQL_STATEMENT



<!-- ========================================================== 
     Adds  attribute dictionary 
     attributes (ATTR table) information to the
     resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchema
	base_table=ATTR
	sql=
		SELECT 
				ATTR.$COLS:ATTR$
		FROM
				ATTR
				        
        WHERE
		        ATTR.ATTR_ID IN ($ENTITY_PKS$) 
		        AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the base description of attribute dictionary 
     attributes (ATTRDESC table) to the
      resultant data graph.                               
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchemaBaseDescription
	base_table=ATTRDESC
	sql=
		SELECT 
				ATTRDESC.$COLS:ATTRDESC:ATTR_ID$, ATTRDESC.$COLS:ATTRDESC:LANGUAGE_ID$, 
				ATTRDESC.$COLS:ATTRDESC:NAME$, ATTRDESC.$COLS:ATTRDESC:DESCRIPTION$
		FROM
				ATTRDESC
		WHERE		
				ATTRDESC.ATTR_ID IN ($UNIQUE_IDS$) AND
				ATTRDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY ATTRDESC.LANGUAGE_ID DESC
			
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds the description of attribute dictionary 
     attributes (ATTRDESC table) to the
      resultant data graph.                               
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchemaDescription
	base_table=ATTRDESC
	sql=
		SELECT 
				ATTRDESC.$COLS:ATTRDESC$
		FROM
				ATTRDESC
		WHERE		
				ATTRDESC.ATTR_ID IN ($UNIQUE_IDS$) AND
				ATTRDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY ATTRDESC.LANGUAGE_ID	DESC
			
END_ASSOCIATION_SQL_STATEMENT
<!-- ========================================================== 
     Adds the facet of attribute dictionary 
     attributes (FACET table) to the
      resultant data graph.                               
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeFacetInformation
	base_table=FACET
	sql=
		SELECT 
				FACET.$COLS:FACET$
		FROM
				FACET
		WHERE		
				FACET.ATTR_ID IN ($UNIQUE_IDS$)
			
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds the allowed values of attribute dictionary 
     attributes (ATTRVAL table) to the
      resultant data graph.                               
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchemaAllowedValue
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$							
		FROM
				ATTRVAL, ATTRVALDESC 
        WHERE
				ATTRVAL.ATTR_ID IN ($UNIQUE_IDS$) AND
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$) AND
				ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND
				ATTRVALDESC.LANGUAGE_ID = (SELECT LANGUAGE_ID FROM STORE WHERE STORE_ID=$CTX:STORE_ID$)
				 
		  ORDER BY 
		  	  	ATTRVALDESC.SEQUENCE
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the description of the allowed values of attribute dictionary 
     attributes (ATTRVALDESC table) to the
      resultant data graph.                               
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
	base_table=ATTRVALDESC
	sql=
		SELECT 
				ATTRVALDESC.$COLS:ATTRVALDESC$
							
		FROM
				ATTRVALDESC
		WHERE
	        	ATTRVALDESC.ATTRVAL_ID IN ($UNIQUE_IDS$) AND
			    ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
				ATTRVALDESC.LANGUAGE_ID	DESC			
			
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds the catalog entry and of attribute dictionary attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchemaAllowedValue_Paging
	base_table=ATTRVAL
	sql=

		SELECT 
				ATTRVAL.$COLS:ATTRVAL$
		FROM
				ATTRVAL, ATTRVALDESC
		WHERE
				ATTRVAL.ATTR_ID IN ($UNIQUE_IDS$) AND
		        ATTRVAL.ATTRVAL_ID IN ($SUBENTITY_PKS$) AND
				ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND
				ATTRVALDESC.LANGUAGE_ID = (SELECT LANGUAGE_ID FROM STORE WHERE STORE_ID=$CTX:STORE_ID$)
				 
		  ORDER BY 
		  	  	ATTRVALDESC.SEQUENCE 

END_ASSOCIATION_SQL_STATEMENT

<!--============================================================== ASSOCIATED STATEMENTS END ====================================-->
<!--============================================================== QUERY STATEMENTS END ===========================================-->

<!--============================================================== PROFILE DEFINTITION BEGINS =====================================-->

<!-- ========================================================= -->
<!-- Attribute Summary Access Profile.                         -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Attribute with description summary.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_Summary
	BEGIN_ENTITY 
	  base_table=ATTR
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.AttributeDictionaryAttributeGraphComposer
	  associated_sql_statement=IBM_AttributeDictionaryAttributeBaseSchema
	  associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaBaseDescription
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Attribute Details Access Profile.                         -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Attribute with description details.                 -->
<!-- 	1) Attribute allowed value with description details.   -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_Details
	BEGIN_ENTITY 
	  base_table=ATTR
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.AttributeDictionaryAttributeGraphComposer
	  associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
	  associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
	  associated_sql_statement=IBM_AttributeDictionaryAttributeFacetInformation
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Attribute Allowed Value with Paging Access Profile.                   -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Attribute allowed value with description details.   -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_AttributeDictionaryAttributeAllowedValues_Paging
	BEGIN_ENTITY 
	  base_table=ATTR
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.AttributeDictionaryAttributeGraphComposer
	  associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
	  associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue_Paging
	  associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
    END_ENTITY
END_PROFILE

<!--============================================================== PROFILE DEFINTITION ENDS =========================================-->
