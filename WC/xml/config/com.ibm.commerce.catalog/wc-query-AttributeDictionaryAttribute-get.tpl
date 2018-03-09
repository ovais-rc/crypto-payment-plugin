BEGIN_SYMBOL_DEFINITIONS
	
    <!-- ATTR table -->
	COLS:ATTR=ATTR:ATTR_ID,SEQUENCE,FIELD1,FIELD2,FIELD3,ATTRUSAGE,IDENTIFIER
	COLS:ATTR_ID=ATTR:ATTR_ID
	
    <!-- ATTRDESC table -->		
	COLS:ATTRDESC=ATTRDESC:ATTR_ID,LANGUAGE_ID,ATTRTYPE_ID, NAME,DESCRIPTION,DESCRIPTION2,FIELD1,GROUPNAME,QTYUNIT_ID,NOTEINFO
	
END_SYMBOL_DEFINITIONS

<!-- 
	========================================================== 
     Get the attribute dictionary attribute that matches the specified search
	 criteria. Possible values for the searchable property include: 
	 0: attribute is not searchable.
	 1: attribute is searchable and can be indexed to search engine.
     Access profiles supported: IBM_Store_AttributeDictionaryAttributes                       
    ========================================================== 
-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[search() and searchable=]
	base_table=ATTR
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
			
END_ASSOCIATION_SQL_STATEMENT

<!-- =============================================================================================================================== 
Attribute Dictionary Attributes Access Profile for Store Front(return attribute dictionary and its related description)
  This profile consists of the following associated SQLs:                       
  1) IBM_AttributeDictionaryAttributeSchema - returns schema of attribute dictionary attribute .
  2) IBM_AttributeDictionaryAttributeSchemaDescription - returns schema language sensitive information of the attribute dictionary attribute . 
================================================================================================================================= -->


BEGIN_PROFILE
	name=IBM_Store_AttributeDictionaryAttributes 
	BEGIN_ENTITY 
	  base_table=ATTR
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.AttributeDictionaryAttributeGraphComposer
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
    END_ENTITY
END_PROFILE