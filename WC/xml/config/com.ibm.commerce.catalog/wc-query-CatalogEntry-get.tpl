BEGIN_SYMBOL_DEFINITIONS

	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	COLS:CATENTRY_BASE_ATTRS=CATENTRY:CATENTRY_ID,MFNAME
        COLS:CATENTRY:PARTNUMBER=CATENTRY:PARTNUMBER
	COLS:CATENTRY:CATENTTYPE_ID=CATENTRY:CATENTTYPE_ID
	
	<!-- ATTRIBUTE table -->
	COLS:ATTRIBUTE=ATTRIBUTE:*
	<!-- ATTRIBUTE table -->
	COLS:ATTRIBUTE_BASIC=ATTRIBUTE:ATTRIBUTE_ID,LANGUAGE_ID,NAME,ATTRTYPE_ID,CATENTRY_ID,USAGE
	
	<!-- ATTRVALUE table -->
	COLS:ATTRVALUE=ATTRVALUE:ATTRVALUE_ID, LANGUAGE_ID, ATTRIBUTE_ID, OPERATOR_ID, SEQUENCE, CATENTRY_ID, NAME, STRINGVALUE, INTEGERVALUE, FLOATVALUE, FIELD1, IMAGE1, IMAGE2, FIELD2, FIELD3, OID, QTYUNIT_ID, ATTACHMENT_ID

	<!-- STORECENT table -->
	COLS:STORECENT=STORECENT:*
	COLS:STOREENT_ID=STORECENT:STOREENT_ID	

    <!-- ATTR table -->
	COLS:ATTR=ATTR:ATTR_ID,SEQUENCE,DISPLAYABLE,SEARCHABLE,COMPARABLE,FIELD1,FIELD2,FIELD3,ATTRUSAGE,IDENTIFIER,STOREDISPLAY
	
    <!-- ATTRVAL table -->	
	COLS:ATTRVAL=ATTRVAL:ATTRVAL_ID,IDENTIFIER,ATTR_ID,FIELD1,FIELD2,FIELD3
    
    <!-- ATTRDESC table -->		
	COLS:ATTRDESC=ATTRDESC:ATTR_ID,LANGUAGE_ID,ATTRTYPE_ID, NAME,DESCRIPTION,DESCRIPTION2,FIELD1,GROUPNAME,QTYUNIT_ID,NOTEINFO

    <!-- ATTRVALDESC table -->	
	COLS:ATTRVALDESC=ATTRVALDESC:ATTRVAL_ID,LANGUAGE_ID,ATTR_ID,VALUE,STRINGVALUE,INTEGERVALUE,FLOATVALUE,SEQUENCE,QTYUNIT_ID,IMAGE1,IMAGE2,FIELD1,FIELD2,FIELD3,VALUSAGE
	
    <!-- CATENTRYATTR table -->		
    COLS:CATENTRYATTR=CATENTRYATTR:CATENTRY_ID,ATTR_ID, ATTRVAL_ID,USAGE,SEQUENCE,FIELD1,FIELD2,FIELD3

    <!-- ATTR table -->
	COLS:ATTR_BASIC=ATTR:ATTR_ID,IDENTIFIER,ATTRTYPE_ID,DISPLAYABLE,SEARCHABLE,COMPARABLE 	

    <!-- ATTRVAL table -->	
	COLS:ATTRVAL_BASIC=ATTRVAL:ATTRVAL_ID,IDENTIFIER,ATTR_ID
    
    <!-- ATTRDESC table -->		
	COLS:ATTRDESC_BASIC=ATTRDESC:ATTR_ID,NAME,LANGUAGE_ID

    <!-- ATTRVALDESC table -->		
	COLS:ATTRVALDESC_BASIC=ATTRVALDESC:ATTRVAL_ID,ATTR_ID,VALUE,STRINGVALUE,INTEGERVALUE,FLOATVALUE,LANGUAGE_ID

    <!-- CATENTRYATTR table -->		
    COLS:CATENTRYATTR_BASIC=CATENTRYATTR:CATENTRY_ID,ATTR_ID, ATTRVAL_ID,USAGE,SEQUENCE


	
	<!-- CATENTSUBS table -->
	COLS:CATENTSUBS=CATENTSUBS:*
	
	<!-- CATCONFINF table -->
	COLS:CATCONFINF=CATCONFINF:*
	
	<!-- DKPREDEFCONF table -->
	COLS:DKPREDEFCONF=DKPREDEFCONF:*
	
	<!-- DKPDCCATENTREL table -->
	COLS:DKPDCCATENTREL=DKPDCCATENTREL:*
	
	
	<!-- KPDCCOMPLIST table -->
	COLS:DKPDCCOMPLIST:CATENTRY_ID=DKPDCCOMPLIST:CATENTRY_ID
	COLS:DKPDCCOMPLIST:SEQUENCE=DKPDCCOMPLIST:SEQUENCE
	COLS:DKPDCCOMPLIST:GROUPNAME=DKPDCCOMPLIST:GROUPNAME
	COLS:DKPDCCOMPLIST:DKPREDEFCONF_ID=DKPDCCOMPLIST:DKPREDEFCONF_ID
	COLS:DKPDCCOMPLIST:DKPDCCOMPLIST_ID=DKPDCCOMPLIST:DKPDCCOMPLIST_ID
	COLS:DKPDCCOMPLIST:QUANTITY=DKPDCCOMPLIST:QUANTITY
	COLS:DKPDCCOMPLIST:QTYUNIT_ID=DKPDCCOMPLIST:QTYUNIT_ID
	
		<!-- CATENTREL Table -->
	COLS:CATENTREL=CATENTREL:*
	COLS:CATENTRY_ID_CHILD=CATENTREL:CATENTRY_ID_CHILD
	COLS:CATENTRY_ID_PARENT=CATENTREL:CATENTRY_ID_PARENT
	COLS:CATENTREL:QUANTITY=CATENTREL:QUANTITY
	COLS:CATENTREL:GROUPNAME=CATENTREL:GROUPNAME
	COLS:CATENTREL:SEQUENCE=CATENTREL:SEQUENCE
	
	<!-- CATENTDESC table -->
	COLS:CATENTDESC=CATENTDESC:*
	COLS:CATENTDESC:CATENTRY_ID=CATENTDESC:CATENTRY_ID
	COLS:CATENTDESC:LANGUAGE_ID=CATENTDESC:LANGUAGE_ID
	COLS:CATENTDESC:NAME=CATENTDESC:NAME
	<!-- MASSOCCECE table for merchandising associations -->
	COLS:MASSOCCECE=MASSOCCECE:*
	COLS:MASSOCCECE:MASSOCCECE_ID=MASSOCCECE:MASSOCCECE_ID
	COLS:MASSOCCECE:MASSOCTYPE_ID=MASSOCCECE:MASSOCTYPE_ID
	COLS:MASSOCCECE:QUANTITY=MASSOCCECE:QUANTITY
	COLS:MASSOCCECE:CATENTRY_ID_FROM=MASSOCCECE:CATENTRY_ID_FROM
	COLS:MASSOCCECE:CATENTRY_ID_TO=MASSOCCECE:CATENTRY_ID_TO
	
	<!-- CATENTSHIP Table -->
	COLS:CATENTSHIP=CATENTSHIP:*
	
END_SYMBOL_DEFINITIONS


<!-- ========================================================== 
     Gets the catalog entry and its parent catalog entry's attribute dictionary attribute 
     relationships with values (CATENTRYATTR table) according to the attribute names to the resultant data graph.
     The attribute names passed in has to be upper case (like 'COLOR') and all case of the attribute name will be returned (like 'Color', 'color', 'COLOR').
     including descriptive attributes and SKU's defining attributes.         
     @param UniqueID The unique ids of the catalog entry.              
     @param language The language ids of the attributes to be returned. 
     @param Name The upper case of the attribute names to return.           
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[(Name=)]+IBM_CatalogEntryDictionaryAttributesParentWithoutEntitlementCheck
	base_table=CATENTRY
	sql=

		SELECT 
				CATENTRY.$COLS:CATENTRY$, CATENTRYATTR.$COLS:CATENTRYATTR_BASIC$, ATTR.$COLS:ATTR_BASIC$, ATTRDESC.$COLS:ATTRDESC_BASIC$, ATTRVAL.$COLS:ATTRVAL_BASIC$, ATTRVALDESC.$COLS:ATTRVALDESC_BASIC$
		FROM 	
				CATENTRY
					LEFT OUTER JOIN 
					(
						CATENTRYATTR 
						JOIN ATTR ON
							ATTR.ATTR_ID = CATENTRYATTR.ATTR_ID AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$) 
						JOIN ATTRDESC ON	 
							ATTRDESC.ATTR_ID = ATTR.ATTR_ID AND ATTRDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) AND UPPER(ATTRDESC.NAME) IN (?Name?)
						JOIN ATTRVAL ON 	 
							ATTRVAL.ATTRVAL_ID = CATENTRYATTR.ATTRVAL_ID AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
						JOIN ATTRVALDESC ON	 
							ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
					)		
					ON  CATENTRYATTR.CATENTRY_ID = CATENTRY.CATENTRY_ID AND CATENTRYATTR.ATTRVAL_ID <> 0	
		WHERE 
				CATENTRY.CATENTRY_ID IN (?UniqueID?) OR CATENTRY.CATENTRY_ID IN (SELECT CATENTREL.CATENTRY_ID_PARENT FROM CATENTREL WHERE CATENTREL.CATENTRY_ID_CHILD IN (?UniqueID?))

END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================== 
     Gets the catalog entry and its parent catalog entry's classic attribute 
     relationships with values (ATTRIBUTE and ATTRVALUE table) according to the attribute names to the resultant data graph.
     The attribute names passed in has to be upper case (like 'COLOR') and all case of the attribute name will be returned (like 'Color', 'color', 'COLOR').
     including descriptive attributes and SKU's defining attributes.         
     @param UniqueID The unique ids of the catalog entry.              
     @param language The language ids of the attributes to be returned. 
     @param Name The upper case of the attribute names to return.           
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[(Name=)]+IBM_CatalogEntryClassicAttributesParentWithoutEntitlementCheck
	base_table=CATENTRY
	sql=
		
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$, ATTRIBUTE.$COLS:ATTRIBUTE$, ATTRVALUE.$COLS:ATTRVALUE$
		FROM 	
				CATENTRY	
					LEFT JOIN ATTRVALUE ON		
						ATTRVALUE.CATENTRY_ID = CATENTRY.CATENTRY_ID AND ATTRVALUE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
					JOIN ATTRIBUTE ON 
						ATTRIBUTE.ATTRIBUTE_ID = ATTRVALUE.ATTRIBUTE_ID AND UPPER(ATTRIBUTE.NAME) IN (?Name?) AND ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) 
		WHERE 
				CATENTRY.CATENTRY_ID IN (?UniqueID?) OR CATENTRY.CATENTRY_ID IN (SELECT CATENTREL.CATENTRY_ID_PARENT FROM CATENTREL WHERE CATENTREL.CATENTRY_ID_CHILD IN (?UniqueID?))
				
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================================= -->
<!-- SQL query is used to return records from CATENTRY, CATCONFINF, DKPDCCATENTREL, and DKPREDEFCONF   -->
<!-- tables. This data is Dynamic Kit predefined configuration information that is used to populate    -->
<!-- the CatalogNavigationView noun.           	     		                                       -->
<!-- Note: sequence 0 is used to create a pre-configuration and only one pre-configuration exists for  -->
<!--  a given dynamic kit.                                                                             -->
<!-- ================================================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView[CatalogEntryView[UniqueID=]]+IBM_Store_CatalogEntryComponent
	base_table=CATENTRY
	sql=
	SELECT CATENTRY.$COLS:CATENTRY$,
	       CATCONFINF.$COLS:CATCONFINF$,
	       DKPDCCATENTREL.$COLS:DKPDCCATENTREL$,
	       DKPREDEFCONF.$COLS:DKPREDEFCONF$
	  FROM 
	  CATENTRY
	        LEFT OUTER JOIN CATCONFINF ON
	  		CATENTRY.CATENTRY_ID = CATCONFINF.CATENTRY_ID
	        LEFT OUTER JOIN  DKPDCCATENTREL ON 
	        CATCONFINF.CATENTRY_ID = DKPDCCATENTREL.CATENTRY_ID
	        LEFT OUTER JOIN  DKPREDEFCONF ON 
	        DKPDCCATENTREL.DKPREDEFCONF_ID = DKPREDEFCONF.DKPREDEFCONF_ID
	 WHERE (CATENTRY.CATENTRY_ID  = ?UniqueID?)			
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================================= -->
<!-- This SQL query is used to return records from CATENTRY, CATCONFINF tables.                        -->
<!-- This data is the predefined configuration information for Dynamic Kit/Predefined Dynamic Kit      -->
<!-- which will be used to populate the CatalogNavigationView noun.           	     	               -->
<!-- ================================================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView[CatalogEntryView[UniqueID=]]+IBM_Store_CatalogEntryComponent_Multiple_PDK
	base_table=CATENTRY
	sql=
	SELECT CATENTRY.$COLS:CATENTRY$,
	       CATCONFINF.$COLS:CATCONFINF$
	  FROM 
	  CATENTRY
	        LEFT OUTER JOIN CATCONFINF ON
	  		CATENTRY.CATENTRY_ID = CATCONFINF.CATENTRY_ID
	 WHERE CATENTRY.CATENTRY_ID  = ?UniqueID?	AND CATENTRY.CATENTTYPE_ID IN ('DynamicKitBean','PredDynaKitBean')	
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================================= -->
<!-- This SQL query will returns records for DKPDCCOMPLIST table. This records are a list of            -->
<!-- components that would exists in a predefined configured dynamic kit.                              -->
<!-- ================================================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView/CatalogEntryView/ComponentView[UniqueID=]+IBM_Store_CatalogEntryComponent
	base_table=DKPDCCOMPLIST
	sql=
	SELECT 
	       DKPDCCOMPLIST.$COLS:DKPDCCOMPLIST:CATENTRY_ID$,
	       DKPDCCOMPLIST.$COLS:DKPDCCOMPLIST:SEQUENCE$,
		   DKPDCCOMPLIST.$COLS:DKPDCCOMPLIST:GROUPNAME$,
	       DKPDCCOMPLIST.$COLS:DKPDCCOMPLIST:DKPREDEFCONF_ID$,
	       DKPDCCOMPLIST.$COLS:DKPDCCOMPLIST:DKPDCCOMPLIST_ID$,
		   DKPDCCOMPLIST.$COLS:DKPDCCOMPLIST:QUANTITY$,
		   DKPDCCOMPLIST.$COLS:DKPDCCOMPLIST:QTYUNIT_ID$
	  FROM 
	       DKPDCCOMPLIST   
	  WHERE 
	       (DKPDCCOMPLIST.DKPREDEFCONF_ID  = ?UniqueID?) 
	  ORDER BY 
	        DKPDCCOMPLIST.SEQUENCE  			
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================================= -->
<!-- This SQL query will returns records for CATENTRY and CATENTREL table. This records are a list of  -->
<!-- components that would exists in a predefined dynamic kit.                                         -->
<!-- ================================================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView/CatalogEntryView/ComponentView[UniqueID=]+IBM_Store_CatalogEntryComponent_Multiple_PDK
	base_table=CATENTRY
	sql=
	SELECT CATENTRY.$COLS:CATENTRY$,
	       CATENTREL.$COLS:CATENTREL$
	  FROM 
	  CATENTRY
	  		JOIN CATENTREL ON 
	  		CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID
	  WHERE
	        CATENTREL.CATENTRY_ID_PARENT = ?UniqueID? AND CATENTREL.CATRELTYPE_ID='PDK_COMPONENT'
	  ORDER BY 
	        CATENTREL.SEQUENCE,CATENTRY.CATENTRY_ID  			
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================================= -->
<!-- This SQL query will return the records for Package and Bundle component from CATENTRY  and CATENTREL
<!--  Table. These records are list of items that would exist  -->
<!-- in a predefined configured package or bundle.                              -->
<!-- ================================================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView[CatalogEntryView[UniqueID=]]/Components+IBM_Store_CatalogEntryComponents
    base_table=CATENTRY
	sql=
	SELECT CATENTRY.$COLS:CATENTRY_ID$,
		   CATENTREL.$COLS:CATENTREL$,
		   CATENTSHIP.$COLS:CATENTSHIP$
	  FROM 
	  CATENTRY  
				JOIN 
				CATENTREL ON
					(CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID AND CATENTREL.CATENTRY_ID_PARENT = ?UniqueID? AND CATENTREL.CATRELTYPE_ID IN ('PACKAGE_COMPONENT' ,'BUNDLE_COMPONENT' ))
				LEFT OUTER JOIN
				CATENTSHIP ON
					(CATENTSHIP.CATENTRY_ID = CATENTRY.CATENTRY_ID)
	   ORDER BY
				CATENTREL.SEQUENCE, CATENTRY.CATENTRY_ID   			
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================================= -->
<!-- This SQL query will return records for Merchandising Associations from MASSOCCECE table.
<!-- ================================================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView/CatalogEntryView[(UniqueID=)]/MerchandisingAssociations+IBM_Store_CatalogEntryMerchandisingAssociations
    	base_table=MASSOCCECE
	sql=
	SELECT MASSOCCECE.$COLS:MASSOCCECE:MASSOCCECE_ID$,
		   MASSOCCECE.$COLS:MASSOCCECE:MASSOCTYPE_ID$,
		   MASSOCCECE.$COLS:MASSOCCECE:QUANTITY$,
		   MASSOCCECE.$COLS:MASSOCCECE:CATENTRY_ID_FROM$,
		   MASSOCCECE.$COLS:MASSOCCECE:CATENTRY_ID_TO$
	  FROM 
	 	MASSOCCECE,
		CATENTDESC
	  WHERE MASSOCCECE.CATENTRY_ID_FROM IN (?UniqueID?) AND
        	   MASSOCCECE.STORE_ID IN ($STOREPATH:catalog$) AND	
		   MASSOCCECE.CATENTRY_ID_TO = CATENTDESC.CATENTRY_ID AND
		   CATENTDESC.PUBLISHED = 1 AND
		   CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
	  ORDER BY
		MASSOCCECE.CATENTRY_ID_FROM, MASSOCCECE.RANK   			
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================================= -->
<!-- This SQL query will return records for allowed values of classic attribute from ATTRVALUE table.
<!-- It returns only the defining values used by the SKUs.
<!-- ================================================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView/CatalogEntryView/Attributes[(UniqueID=)]/Value+IBM_Store_CatalogEntryAttributeAllowedValues
    base_table=ATTRVALUE
	sql=
		SELECT
			ATTRVALUE.$COLS:ATTRVALUE$ 
		FROM 
			ATTRVALUE  
		WHERE
			ATTRVALUE.ATTRIBUTE_ID IN (?UniqueID?) AND
			ATTRVALUE.CATENTRY_ID <> 0 AND
			ATTRVALUE.LANGUAGE_ID=($CTX:LANG_ID$)
		ORDER BY
			ATTRVALUE.SEQUENCE 			
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================== 
     Gets the product's classic defining attributes to the resultant data graph.
     The allowed values of the defining attributes are also returned.
     @param UniqueID The unique ids of the catalog entry.
     @param language The language ids of the attributes to be returned.                        
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[(@language=)]+IBM_CatalogEntryAttributeAllowedValues
	base_table=ATTRIBUTE
	sql=
		SELECT 
				ATTRIBUTE.$COLS:ATTRIBUTE$, ATTRVALUE.$COLS:ATTRVALUE$ 
		FROM
				ATTRIBUTE
					LEFT OUTER JOIN ATTRVALUE ON
				(	
					ATTRVALUE.ATTRIBUTE_ID =  ATTRIBUTE.ATTRIBUTE_ID AND
					ATTRVALUE.CATENTRY_ID = 0 AND
					ATTRVALUE.LANGUAGE_ID IN (?language?)            	
				)
		WHERE
				ATTRIBUTE.CATENTRY_ID IN (?UniqueID?) AND
				(ATTRIBUTE.USAGE = '1' OR ATTRIBUTE.USAGE IS NULL ) AND
				ATTRIBUTE.LANGUAGE_ID IN (?language?)
        ORDER BY
        		ATTRIBUTE.CATENTRY_ID, ATTRIBUTE.SEQUENCE, ATTRVALUE.SEQUENCE
			
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================== 
     Gets product SKUs' classic attribute 
     relationships with values (CATENTRYATTR table) to the resultant data graph.
     It returns attributes with value assigned (CATENTRYATTR.ATTRVAL_ID <> 0), 
     including SKU's descriptive attributes and SKU's defining attributes.         
     @param UniqueID The unique ids of the product.              
     @param language The language ids of the attributes to be returned.            
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[ParentCatalogEntryIdentifier[UniqueID=]]/CatalogEntryAttributes[(@language=)]+IBM_ProductItemDefiningAttributeValues
	base_table=ATTRVALUE
	sql=
	
		SELECT 
				ATTRIBUTE.$COLS:ATTRIBUTE_BASIC$, ATTRVALUE.$COLS:ATTRVALUE$ 
		FROM
				CATENTREL,ATTRIBUTE, ATTRVALUE
		WHERE
		 		CATENTREL.CATENTRY_ID_PARENT = ?UniqueID? AND
 				ATTRVALUE.CATENTRY_ID = CATENTREL.CATENTRY_ID_CHILD AND 
                ATTRVALUE.LANGUAGE_ID IN (?language?) AND
				ATTRIBUTE.ATTRIBUTE_ID = ATTRVALUE.ATTRIBUTE_ID AND 
				(ATTRIBUTE.USAGE = '1' OR ATTRIBUTE.USAGE IS NULL ) AND     
				ATTRIBUTE.LANGUAGE_ID IN (?language?)
		ORDER BY
        		ATTRVALUE.CATENTRY_ID, ATTRIBUTE.SEQUENCE, ATTRVALUE.SEQUENCE
	
	
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================== 
     Gets the classic descriptive attributes and SKU's defining attributes to the resultant data graph.
     The allowed values of the defining attributes are not returned.
     @param UniqueID The unique ids of the catalog entry.  
     @param language The language ids of the attributes to be returned.                     
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[(@language=)]+IBM_CatalogEntryAttributeValues
	base_table=ATTRVALUE
	sql=
		SELECT 
				ATTRIBUTE.$COLS:ATTRIBUTE$, ATTRVALUE.$COLS:ATTRVALUE$ 
		FROM
				ATTRIBUTE, ATTRVALUE
		WHERE
 				ATTRVALUE.CATENTRY_ID IN (?UniqueID?) AND
                ATTRVALUE.LANGUAGE_ID IN (?language?) AND
				ATTRIBUTE.ATTRIBUTE_ID = ATTRVALUE.ATTRIBUTE_ID AND      
				ATTRIBUTE.LANGUAGE_ID IN (?language?)
		ORDER BY
        		ATTRVALUE.CATENTRY_ID, ATTRIBUTE.SEQUENCE, ATTRVALUE.SEQUENCE
			
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================== 
     Gets the catalog entry's attribute dictionary attribute 
     relationships with values (CATENTRYATTR table) to the resultant data graph.
     It returns attributes with value assigned (CATENTRYATTR.ATTRVAL_ID <> 0), 
     including descriptive attributes and SKU's defining attributes.         
     @param UniqueID The unique ids of the catalog entry.              
     @param language The language ids of the attributes to be returned.            
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[(@language=)]+IBM_CatalogEntryAttributeDictionaryAttributeValues
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$, ATTR.$COLS:ATTR$, ATTRDESC.$COLS:ATTRDESC$, ATTRVAL.$COLS:ATTRVAL$, ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				CATENTRYATTR
					INNER JOIN ATTR ON 
						ATTR.ATTR_ID = CATENTRYATTR.ATTR_ID AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$) AND CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND CATENTRYATTR.ATTRVAL_ID <> 0
					INNER JOIN  ATTRVAL ON
						 ATTRVAL.ATTRVAL_ID = CATENTRYATTR.ATTRVAL_ID AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
					LEFT JOIN ATTRDESC ON
					    ATTRDESC.ATTR_ID = ATTR.ATTR_ID AND ATTRDESC.LANGUAGE_ID IN (?language?)
					LEFT JOIN ATTRVALDESC ON
						ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND ATTRVALDESC.LANGUAGE_ID IN (?language?)
				ORDER BY
      				CATENTRYATTR.CATENTRY_ID,
				    CATENTRYATTR.SEQUENCE,
				    CATENTRYATTR.ATTR_ID				
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================== 
     Gets the catalog entry's attribute dictionary attribute specified by attribute associated keyword.
     It returns attributes with value assigned (CATENTRYATTR.ATTRVAL_ID <> 0), 
     including descriptive attributes and SKU's defining attributes.         
     @param UniqueID The unique ids of the catalog entry.              
     @param language The language ids of the attributes to be returned.    
     @param Keyword The attribute associated keyword (GROUPNAME) to be returned.        
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[(@language=) and (Keyword=)]+IBM_CatalogEntryAttributeDictionaryAttributeValues
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$, ATTR.$COLS:ATTR$, ATTRDESC.$COLS:ATTRDESC$, ATTRVAL.$COLS:ATTRVAL$, ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				CATENTRYATTR
					INNER JOIN ATTR ON 
						ATTR.ATTR_ID = CATENTRYATTR.ATTR_ID AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$) AND CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND CATENTRYATTR.ATTRVAL_ID <> 0
					INNER JOIN  ATTRVAL ON
						 ATTRVAL.ATTRVAL_ID = CATENTRYATTR.ATTRVAL_ID AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
					INNER JOIN ATTRDESC ON
					    ATTRDESC.ATTR_ID = ATTR.ATTR_ID AND ATTRDESC.LANGUAGE_ID IN (?language?) AND 
					    (UPPER(ATTRDESC.GROUPNAME) LIKE UPPER(?Keyword?)  ESCAPE '+' )
					    
					LEFT JOIN ATTRVALDESC ON
						ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND ATTRVALDESC.LANGUAGE_ID IN (?language?)
				ORDER BY
      				CATENTRYATTR.CATENTRY_ID,
				    CATENTRYATTR.SEQUENCE,
				    CATENTRYATTR.ATTR_ID				
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================== 
     Gets the catalog entry's attribute dictionary attribute 
     relationship with allowed values (CATENTRYATTR table) to the resultant data graph.
     It returns attributes with no value assigned (CATENTRYATTR.ATTRVAL_ID = 0). 
     For example, product's defining attributes.   
     Similar to profile IBM_CatalogEntryAttributeDictionaryAttributeValues, however 
     the result is filtered by attributes with the STOREDISPLAY flag set and 
     greater than 0.	 
     @param UniqueID The unique ids of the catalog entry.      
     @param language The language ids of the attributes to be returned.                    
     ========================================================== -->
	 
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[(@language=)]+IBM_CatalogEntryStoreDisplayAttributeDictionaryAttributeValues
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$, ATTR.$COLS:ATTR$, ATTRDESC.$COLS:ATTRDESC$, ATTRVAL.$COLS:ATTRVAL$, ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				CATENTRYATTR
					INNER JOIN ATTR ON 
						ATTR.ATTR_ID = CATENTRYATTR.ATTR_ID AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$) AND CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND CATENTRYATTR.ATTRVAL_ID <> 0 AND ATTR.STOREDISPLAY IS NOT NULL AND ATTR.STOREDISPLAY > 0
					INNER JOIN  ATTRVAL ON
						 ATTRVAL.ATTRVAL_ID = CATENTRYATTR.ATTRVAL_ID AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
					LEFT JOIN ATTRDESC ON
					    ATTRDESC.ATTR_ID = ATTR.ATTR_ID AND ATTRDESC.LANGUAGE_ID IN (?language?)
					LEFT JOIN ATTRVALDESC ON
						ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND ATTRVALDESC.LANGUAGE_ID IN (?language?)
				ORDER BY
      				CATENTRYATTR.CATENTRY_ID,
				    CATENTRYATTR.SEQUENCE,
				    CATENTRYATTR.ATTR_ID				
END_XPATH_TO_SQL_STATEMENT

	 
<!-- ========================================================== 
     Gets the catalog entry's attribute dictionary attribute 
     relationship with allowed values (CATENTRYATTR table) to the resultant data graph.
     It returns attributes with no value assigned (CATENTRYATTR.ATTRVAL_ID = 0). 
     For example, product's defining attributes.          
     Similar to profile IBM_CatalogEntryAttributeDictionaryAttributeAllowedValues, however 
     the result is filtered by attributes with the STOREDISPLAY flag set and 
     greater than 0.
     @param UniqueID The unique ids of the catalog entry.      
     @param language The language ids of the attributes to be returned.                    
     ========================================================== -->
	 
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[(@language=)]+IBM_CatalogEntryStoreDisplayAttributeDictionaryAttributeAllowedValues
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$, ATTR.$COLS:ATTR$, ATTRDESC.$COLS:ATTRDESC$
		FROM
				CATENTRYATTR
					INNER JOIN ATTR ON 
						ATTR.ATTR_ID = CATENTRYATTR.ATTR_ID AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$) AND CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND CATENTRYATTR.ATTRVAL_ID = 0 AND ATTR.STOREDISPLAY IS NOT NULL AND ATTR.STOREDISPLAY > 0
					LEFT JOIN ATTRDESC ON
					    ATTRDESC.ATTR_ID = ATTR.ATTR_ID AND ATTRDESC.LANGUAGE_ID IN (?language?)
					ORDER BY
      				CATENTRYATTR.CATENTRY_ID,
				    CATENTRYATTR.SEQUENCE

END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================== 
     Gets the catalog entry's attribute dictionary attribute 
     relationship with allowed values (CATENTRYATTR table) to the resultant data graph.
     It returns attributes with no value assigned (CATENTRYATTR.ATTRVAL_ID = 0). 
     For example, product's defining attributes.                               
     @param UniqueID The unique ids of the catalog entry.      
     @param language The language ids of the attributes to be returned.                    
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[(@language=)]+IBM_CatalogEntryAttributeDictionaryAttributeAllowedValues
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$, ATTR.$COLS:ATTR$, ATTRDESC.$COLS:ATTRDESC$
		FROM
				CATENTRYATTR
					INNER JOIN ATTR ON 
						ATTR.ATTR_ID = CATENTRYATTR.ATTR_ID AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$) AND CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND CATENTRYATTR.ATTRVAL_ID = 0
					LEFT JOIN ATTRDESC ON
					    ATTRDESC.ATTR_ID = ATTR.ATTR_ID AND ATTRDESC.LANGUAGE_ID IN (?language?)
					ORDER BY
      				CATENTRYATTR.CATENTRY_ID,
				    CATENTRYATTR.SEQUENCE

END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================== 
     Gets the catalog entry's attribute dictionary attributes specified by attribute associated keyword.
     It returns attributes with no value assigned (CATENTRYATTR.ATTRVAL_ID = 0). 
     For example, product's defining attributes.                               
     @param UniqueID The unique ids of the catalog entry.      
     @param language The language ids of the attributes to be returned.  
     @param Keyword The attribute associated keyword (GROUPNAME) to be returned.                       
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[(@language=) and (Keyword=)]+IBM_CatalogEntryAttributeDictionaryAttributeAllowedValues
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$, ATTR.$COLS:ATTR$, ATTRDESC.$COLS:ATTRDESC$
		FROM
				CATENTRYATTR
					INNER JOIN ATTR ON 
						ATTR.ATTR_ID = CATENTRYATTR.ATTR_ID AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$) AND CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND CATENTRYATTR.ATTRVAL_ID = 0
					INNER JOIN ATTRDESC ON
					    ATTRDESC.ATTR_ID = ATTR.ATTR_ID AND ATTRDESC.LANGUAGE_ID IN (?language?) AND
					    (UPPER(ATTRDESC.GROUPNAME) LIKE UPPER(?Keyword?)  ESCAPE '+' )
					ORDER BY
      				CATENTRYATTR.CATENTRY_ID,
				    CATENTRYATTR.SEQUENCE

END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================== 
     Gets the allowed values of attribute dictionary 
     attributes (ATTRVAL table) to the
      resultant data graph.         
     The allowed values which are not used by valid SKUs of the product are filtered out                      
     ========================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[(@language=) and (@attrId=)]+IBM_CatalogEntryAttributeDictionaryAttributeAllowedValues
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$, ATTRVALDESC.$COLS:ATTRVALDESC$							
		FROM
				ATTRVAL 
				LEFT JOIN ATTRVALDESC ON
					ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND ATTRVALDESC.LANGUAGE_ID IN (?language?)				
        WHERE
				ATTRVAL.ATTR_ID IN (?attrId?) AND
				ATTRVAL.VALUSAGE is NOT NULL AND
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$) AND
				ATTRVAL.ATTRVAL_ID IN 
				( 	SELECT 
						C1.ATTRVAL_ID 
					FROM 
						CATENTRYATTR C1, CATENTREL 
					WHERE 
						C1.CATENTRY_ID = CATENTREL.CATENTRY_ID_CHILD AND
						CATENTREL.CATENTRY_ID_PARENT IN (?UniqueID?)
				)
				ORDER BY
				    ATTRVAL.ATTR_ID,
				    ATTRVALDESC.SEQUENCE				
			
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================== 
     Gets product SKUs' attribute dictionary attribute 
     relationships with values (CATENTRYATTR table) to the resultant data graph.
     It returns attributes with value assigned (CATENTRYATTR.ATTRVAL_ID <> 0), 
     including SKU's descriptive attributes and SKU's defining attributes.         
     @param UniqueID The unique ids of the product.              
     @param language The language ids of the attributes to be returned.            
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[ParentCatalogEntryIdentifier[UniqueID=]]/CatalogEntryAttributes[(@language=)]+IBM_ProductItemAttributeDictionaryDefiningAttributeValues
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$, ATTR.$COLS:ATTR_BASIC$, ATTRDESC.$COLS:ATTRDESC_BASIC$, ATTRVAL.$COLS:ATTRVAL_BASIC$, ATTRVALDESC.$COLS:ATTRVALDESC_BASIC$
		FROM
				CATENTRYATTR
					INNER JOIN CATENTREL ON 
						CATENTREL.CATENTRY_ID_PARENT = ?UniqueID? AND CATENTRYATTR.CATENTRY_ID = CATENTREL.CATENTRY_ID_CHILD AND CATENTRYATTR.ATTRVAL_ID <>0 AND CATENTRYATTR.USAGE = '1'
					INNER JOIN ATTR ON 
						ATTR.ATTR_ID = CATENTRYATTR.ATTR_ID AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
					INNER JOIN ATTRVAL ON
						 ATTRVAL.ATTRVAL_ID = CATENTRYATTR.ATTRVAL_ID AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
					LEFT JOIN ATTRDESC ON
					    ATTRDESC.ATTR_ID = ATTR.ATTR_ID AND ATTRDESC.LANGUAGE_ID IN (?language?)
					LEFT JOIN ATTRVALDESC ON
						ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND ATTRVALDESC.LANGUAGE_ID IN (?language?)
 		ORDER BY
        		CATENTRYATTR.CATENTRY_ID, CATENTRYATTR.SEQUENCE, CATENTRYATTR.ATTR_ID
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================== 
     Gets the catentry's merchandising association catentries based on the
     merchandising association type
     @param UniqueID The unique ids of the product.              
     @param AssociationType The merchandising association type.            
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogNavigationView/CatalogEntryView[(UniqueID=)]/MerchandisingAssociations[(AssociationType=)]+IBM_Store_CatalogEntryMerchandisingAssociations
    	base_table=MASSOCCECE
	sql=
	SELECT MASSOCCECE.$COLS:MASSOCCECE:MASSOCCECE_ID$,
		   MASSOCCECE.$COLS:MASSOCCECE:MASSOCTYPE_ID$,
		   MASSOCCECE.$COLS:MASSOCCECE:QUANTITY$,
		   MASSOCCECE.$COLS:MASSOCCECE:CATENTRY_ID_FROM$,
		   MASSOCCECE.$COLS:MASSOCCECE:CATENTRY_ID_TO$
	  FROM 
	  	MASSOCCECE,
		CATENTDESC
	  WHERE MASSOCCECE.CATENTRY_ID_FROM IN (?UniqueID?) AND
        	   MASSOCCECE.STORE_ID IN ($STOREPATH:catalog$) AND
		   MASSOCCECE.MASSOCTYPE_ID IN (?AssociationType?) AND
		   MASSOCCECE.CATENTRY_ID_TO = CATENTDESC.CATENTRY_ID AND
		   CATENTDESC.PUBLISHED = 1 AND
		   CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
	  ORDER BY
		MASSOCCECE.CATENTRY_ID_FROM, MASSOCCECE.RANK   			
END_XPATH_TO_SQL_STATEMENT



<!-- =============================================================================
     Adds classic attributes (ATTRIBUTE table) of catalog entries to the 
     resultant data graph.                                                 
     ============================================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeSchema
	base_table=ATTRIBUTE
	sql=
	
		SELECT 
				ATTRIBUTE.$COLS:ATTRIBUTE$
		FROM
				ATTRIBUTE
        WHERE
				ATTRIBUTE.CATENTRY_ID IN ($UNIQUE_IDS$) AND
            	ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
        ORDER BY
        		ATTRIBUTE.SEQUENCE
        	
END_ASSOCIATION_SQL_STATEMENT

<!-- =============================================================================
     Adds allowed values of classic attributes (ATTRVALUE table) to the 
     resultant data graph.                                                 
     ============================================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeAllowedValue
	base_table=ATTRVALUE
	sql=
		SELECT 
			ATTRVALUE.$COLS:ATTRVALUE$ 
		FROM 
			ATTRVALUE  
		WHERE
			ATTRVALUE.ATTRIBUTE_ID IN ($UNIQUE_IDS$) AND
			ATTRVALUE.CATENTRY_ID = 0 AND
			ATTRVALUE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRVALUE.SEQUENCE
				
END_ASSOCIATION_SQL_STATEMENT	

<!-- =============================================================================
     Adds classic attribute values (ATTRVALUE table) of catalog entries to the 
     resultant data graph.                                                 
     ============================================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeValue
	base_table=ATTRVALUE
	sql=
		SELECT 
				ATTRVALUE.$COLS:ATTRVALUE$
		FROM
				ATTRVALUE 
        WHERE
                ATTRVALUE.CATENTRY_ID IN ($UNIQUE_IDS$) AND
                ATTRVALUE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
                
END_ASSOCIATION_SQL_STATEMENT

<!-- =============================================================================
     Adds the schemas of classic attributes to the resultant data graph.                                                 
     ============================================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeSchema
	base_table=ATTRIBUTE
	sql=
		SELECT 
			ATTRIBUTE.$COLS:ATTRIBUTE$ 
		FROM 
			ATTRIBUTE  
		WHERE
			ATTRIBUTE.ATTRIBUTE_ID IN ($UNIQUE_IDS$) AND
			ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRIBUTE.SEQUENCE

END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds the catalog entry and of attribute dictionary attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeDictionaryAttribute
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$
		FROM
				CATENTRYATTR
		WHERE
		          	CATENTRYATTR.CATENTRY_ID IN ($UNIQUE_IDS$)
        	ORDER BY
        			CATENTRYATTR.SEQUENCE
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the catalog entry and defining attribute dictionary attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDefiningAttributeDictionaryAttribute
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$
		FROM
				CATENTRYATTR
		WHERE
		        CATENTRYATTR.CATENTRY_ID IN ($UNIQUE_IDS$) AND
		        CATENTRYATTR.USAGE = '1' 
		         
        ORDER BY
        		CATENTRYATTR.SEQUENCE
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the catalog entry and descriptive attribute dictionary attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$
		FROM
				CATENTRYATTR
		WHERE
		        CATENTRYATTR.CATENTRY_ID IN ($UNIQUE_IDS$) AND
		        CATENTRYATTR.USAGE <> '1' 
		         
        ORDER BY
        		CATENTRYATTR.SEQUENCE
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the schema of attribute dictionary 
     attributes (ATTR table) to the
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
		        ATTR.ATTR_ID IN ($UNIQUE_IDS$) AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
			
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


<!-- ========================================================== 
     Adds the allowed values of attribute dictionary 
     attributes (ATTRVAL table) to the
      resultant data graph.         
     The allowed values which are not used by valid SKU of the product are filtered out                        
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchemaAllowedValue
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$							
		FROM
				ATTRVAL 
        WHERE
				ATTRVAL.ATTR_ID IN ($UNIQUE_IDS$) AND
				ATTRVAL.VALUSAGE is NOT NULL AND
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$) AND
				ATTRVAL.ATTRVAL_ID IN 
				( 	SELECT 
						C1.ATTRVAL_ID 
					FROM 
						CATENTRYATTR C1, CATENTREL, CATENTRY 
					WHERE 
						C1.CATENTRY_ID = CATENTREL.CATENTRY_ID_CHILD AND
						CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID AND
						CATENTRY.MARKFORDELETE = 0 AND
						CATENTREL.CATENTRY_ID_PARENT IN ($ENTITY_PKS$)
				)
				
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
				ATTRVALDESC.SEQUENCE				
			
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds the values of attribute dictionary attributes 
     (ATTRVAL table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeValue
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$
		FROM
				ATTRVAL
        WHERE
		        ATTRVAL.ATTRVAL_ID IN ($UNIQUE_IDS$) AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)

END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds the description for the values of attribute dictionary attributes 
     (ATTRVALDESC table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeValueDescription
	base_table=ATTRVALDESC
	sql=
		SELECT 
				ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				ATTRVALDESC
		WHERE
				ATTRVALDESC.ATTRVAL_ID IN ($UNIQUE_IDS$) AND
				ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)

END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info 				                   -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntry
	base_table=CATENTRY
	additional_entity_objects=false
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$
		FROM
				CATENTRY
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Attributes Info 	                   -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryBaseAttributes
	base_table=CATENTRY
	additional_entity_objects=false
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_BASE_ATTRS$
		FROM
				CATENTRY
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================== -->
<!-- This associated SQL:                                           -->
<!-- Adds relationships between catentries and attribute dictionary -->
<!-- attribute (CATENTRYATTR table) of catalog entry's parent       -->
<!-- to the resultant data graph.                                   -->
<!-- ============================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryParent
	base_table=CATENTRY
	additional_entity_objects=false
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$
		FROM
				CATENTRY,CATENTREL		
        WHERE
	        	CATENTREL.CATENTRY_ID_CHILD IN ($ENTITY_PKS$) AND
	        	CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_PARENT

END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================== -->
<!-- This associated SQL:                                           -->
<!-- Adds relationships between catentries and attribute dictionary -->
<!-- attribute (CATENTRYATTR table) of catalog entry's parent       -->
<!-- to the resultant data graph.                                   -->
<!-- ============================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryParentBaseAttributes
	base_table=CATENTRY
	additional_entity_objects=false
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_BASE_ATTRS$
		FROM
				CATENTRY,CATENTREL		
        WHERE
	        	CATENTREL.CATENTRY_ID_CHILD IN ($ENTITY_PKS$) AND
	        	CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_PARENT

END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentsubs Info 				               							 -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntrySubscription
	base_table=CATENTSUBS
	sql=
		SELECT 
				CATENTSUBS.$COLS:CATENTSUBS$
		FROM 
				CATENTSUBS 
		WHERE 
        CATENTSUBS.CATENTRY_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT



<!-- ============================================================= -->
<!-- This associated SQL:                                          -->
<!-- Return the child catentry id and catenttype id to a given     -->
<!-- parent catentry id and store id                               -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_GetChildCatentry
	base_table=CATENTRY
	sql=
			SELECT 
     				CATENTREL.CATENTRY_ID_CHILD,
     				CATENTRY.CATENTTYPE_ID
	     	FROM
     				CATENTREL, CATENTRY
	     	WHERE
					CATENTREL.CATENTRY_ID_PARENT IN (?UniqueID?)
					AND CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID
					AND EXISTS (SELECT STORECENT.CATENTRY_ID FROM STORECENT WHERE STOREENT_ID IN ($STOREPATH:catalog$))
			ORDER BY
					CATENTREL.SEQUENCE	
END_SQL_STATEMENT
<!-- =============================================================================================================================== 
Catalog Entry Attributes Access Profile for Store Front  
  This profile consists of the following associated SQLs:                       
  1) IBM_CatalogEntryBaseAttributes - returns root catalog entry with catalog entry id and base attributes
  2) IBM_CatalogEntryAttributeSchema - returns classic attribute schemas (definitions) of the catalog entry.      
  3) IBM_AttributeAllowedValue - returns allowed values of the classic attribute.                                 
  4) IBM_CatalogEntryAttributeValue - returns the classic attribute value of the catalog entry.                  
  5) IBM_AttributeSchema - returns classic attribute schemas (definitions) of the classic attribute value.         
  6) IBM_CatalogEntryDefiningAttributeDictionaryAttribute - returns relationship between catalog entry and defining attribute dictionary attribute.
  7) IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute - returns relationship between catalog entry and descriptive attribute dictionary attribute. For descriptive attributes, their allowed values are not returned.   
  8) IBM_AttributeDictionaryAttributeSchema - returns schema of attribute dictionary attribute .
  9) IBM_AttributeDictionaryAttributeSchemaDescription - returns schema language sensitive information of the attribute dictionary attribute . 
  10) IBM_AttributeDictionaryAttributeSchemaAllowedValue - returns allowed values of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  11) IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription - returns allowed value language sensitive information of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  12) IBM_AttributeDictionaryAttributeValue - returns value of attribute dictionary attribute.                                         
  13) IBM_AttributeDictionaryAttributeValueDescription - returns value language sensitive information of the attribute dictionary attribute.   
  14) IBM_CatalogEntrySubscription - returns the subscription attributes (subscriptionTypeId and disallowRecurringOrder) 
================================================================================================================================= -->
      
BEGIN_PROFILE 
	name=IBM_Store_CatalogEntryAttributes
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryStoreGraphComposer
	  associated_sql_statement=IBM_CatalogEntryBaseAttributes
<!-- === Following SQL statements are used to retrieve classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictionary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema	
      associated_sql_statement=IBM_AttributeAllowedValue        
      associated_sql_statement=IBM_CatalogEntryAttributeValue	  
      associated_sql_statement=IBM_AttributeSchema

<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
      associated_sql_statement=IBM_CatalogEntryDefiningAttributeDictionaryAttribute
      associated_sql_statement=IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      
      associated_sql_statement=IBM_CatalogEntrySubscription

    END_ENTITY
END_PROFILE

<!-- =============================================================================================================================== 
Catalog Entry Attributes Access Profile for Store Front(return catalog entry and its parent product)
  This profile consists of the following associated SQLs:                       
  1) IBM_CatalogEntryBaseAttributes - returns root catalog entry with catalog entry id and base attributes
  2) IBM_CatalogEntryParentBaseAttributes - returns parent catalog entry of the root catalog entry and base attributes.
  3) IBM_CatalogEntryAttributeSchema - returns classic attribute schemas (definitions) of the catalog entry. 
  4) IBM_AttributeAllowedValue - returns allowed values of the classic attribute.                                 
  5) IBM_CatalogEntryAttributeValue - returns the classic attribute value of the catalog entry.                  
  6) IBM_AttributeSchema - returns classic attribute schemas (definitions) of the classic attribute value.         
  7) IBM_CatalogEntryDefiningAttributeDictionaryAttribute - returns relationship between catalog entry and defining attribute dictionary attribute.
  8) IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute - returns relationship between catalog entry and descriptive attribute dictionary attribute. For descriptive attributes, their allowed values are not returned.   
  9) IBM_AttributeDictionaryAttributeSchema - returns schema of attribute dictionary attribute .
  10) IBM_AttributeDictionaryAttributeSchemaDescription - returns schema language sensitive information of the attribute dictionary attribute . 
  11) IBM_AttributeDictionaryAttributeSchemaAllowedValue - returns allowed values of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  12) IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription - returns allowed value language sensitive information of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  13) IBM_AttributeDictionaryAttributeValue - returns value of attribute dictionary attribute.                                         
  14) IBM_AttributeDictionaryAttributeValueDescription - returns value language sensitive information of the attribute dictionary attribute.   
  15) IBM_CatalogEntrySubscription - returns the subscription attributes (subscriptionTypeId and disallowRecurringOrder) for a catalog entry.
================================================================================================================================= -->

BEGIN_PROFILE 
	name=IBM_Store_CatalogEntryAttributesParent
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryStoreGraphComposer
	  associated_sql_statement=IBM_CatalogEntryBaseAttributes	  
	  associated_sql_statement=IBM_CatalogEntryParentBaseAttributes
<!-- === Following SQL statements are used to retrieve classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictionary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema	
      associated_sql_statement=IBM_AttributeAllowedValue        
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema

<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
      associated_sql_statement=IBM_CatalogEntryDefiningAttributeDictionaryAttribute
      associated_sql_statement=IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription 
      associated_sql_statement=IBM_CatalogEntrySubscription
      	  
    END_ENTITY
END_PROFILE

<!-- =============================================================================================================================== 
Catalog Entry Attributes Access Profile for Store Front Without Access Control Check. 
  This profile consists of the following associated SQLs:                       
  1) IBM_CatalogEntryBaseAttributes - returns root catalog entry with catalog entry id and base attributes
  2) IBM_CatalogEntryAttributeSchema - returns classic attribute schemas (definitions) of the catalog entry.      
  3) IBM_AttributeAllowedValue - returns allowed values of the classic attribute.                                 
  4) IBM_CatalogEntryAttributeValue - returns the classic attribute value of the catalog entry.                  
  5) IBM_AttributeSchema - returns classic attribute schemas (definitions) of the classic attribute value.         
  6) IBM_CatalogEntryDefiningAttributeDictionaryAttribute - returns relationship between catalog entry and defining attribute dictionary attribute.
  7) IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute - returns relationship between catalog entry and descriptive attribute dictionary attribute. For descriptive attributes, their allowed values are not returned.   
  8) IBM_AttributeDictionaryAttributeSchema - returns schema of attribute dictionary attribute .
  9) IBM_AttributeDictionaryAttributeSchemaDescription - returns schema language sensitive information of the attribute dictionary attribute . 
  10) IBM_AttributeDictionaryAttributeSchemaAllowedValue - returns allowed values of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  11) IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription - returns allowed value language sensitive information of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  12) IBM_AttributeDictionaryAttributeValue - returns value of attribute dictionary attribute.                                         
  13) IBM_AttributeDictionaryAttributeValueDescription - returns value language sensitive information of the attribute dictionary attribute.   
  14) IBM_CatalogEntrySubscription - returns the subscription attributes (subscriptionTypeId and disallowRecurringOrder) 
================================================================================================================================= -->
      
BEGIN_PROFILE 
	name=IBM_CatalogEntryAttributesWithoutEntitlementCheck
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryStoreGraphComposer
	  associated_sql_statement=IBM_CatalogEntryBaseAttributes
<!-- === Following SQL statements are used to retrieve classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictionary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema	
      associated_sql_statement=IBM_AttributeAllowedValue        
      associated_sql_statement=IBM_CatalogEntryAttributeValue	  
      associated_sql_statement=IBM_AttributeSchema

<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
      associated_sql_statement=IBM_CatalogEntryDefiningAttributeDictionaryAttribute
      associated_sql_statement=IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      
      associated_sql_statement=IBM_CatalogEntrySubscription

    END_ENTITY
END_PROFILE

<!-- =============================================================================================================================== 
Catalog Entry Attributes Access Profile for Store Front(return catalog entry and its parent product) Without Access Control Check.
  This profile consists of the following associated SQLs:                       
  1) IBM_CatalogEntryBaseAttributes - returns root catalog entry with catalog entry id and base attributes
  2) IBM_CatalogEntryParentBaseAttributes - returns parent catalog entry of the root catalog entry and base attributes.
  3) IBM_CatalogEntryAttributeSchema - returns classic attribute schemas (definitions) of the catalog entry. 
  4) IBM_AttributeAllowedValue - returns allowed values of the classic attribute.                                 
  5) IBM_CatalogEntryAttributeValue - returns the classic attribute value of the catalog entry.                  
  6) IBM_AttributeSchema - returns classic attribute schemas (definitions) of the classic attribute value.         
  7) IBM_CatalogEntryDefiningAttributeDictionaryAttribute - returns relationship between catalog entry and defining attribute dictionary attribute.
  8) IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute - returns relationship between catalog entry and descriptive attribute dictionary attribute. For descriptive attributes, their allowed values are not returned.   
  9) IBM_AttributeDictionaryAttributeSchema - returns schema of attribute dictionary attribute .
  10) IBM_AttributeDictionaryAttributeSchemaDescription - returns schema language sensitive information of the attribute dictionary attribute . 
  11) IBM_AttributeDictionaryAttributeSchemaAllowedValue - returns allowed values of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  12) IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription - returns allowed value language sensitive information of the attribute dictionary attribute. This associated SQL is only called for defining attributes by CatalogEntryStoreGraphComposer.
  13) IBM_AttributeDictionaryAttributeValue - returns value of attribute dictionary attribute.                                         
  14) IBM_AttributeDictionaryAttributeValueDescription - returns value language sensitive information of the attribute dictionary attribute.   
  15) IBM_CatalogEntrySubscription - returns the subscription attributes (subscriptionTypeId and disallowRecurringOrder) for a catalog entry.
================================================================================================================================= -->

BEGIN_PROFILE 
	name=IBM_CatalogEntryAttributesParentWithoutEntitlementCheck
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryStoreGraphComposer
	  associated_sql_statement=IBM_CatalogEntryBaseAttributes	  
	  associated_sql_statement=IBM_CatalogEntryParentBaseAttributes
<!-- === Following SQL statements are used to retrieve classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictionary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema	
      associated_sql_statement=IBM_AttributeAllowedValue        
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema

<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
      associated_sql_statement=IBM_CatalogEntryDefiningAttributeDictionaryAttribute
      associated_sql_statement=IBM_CatalogEntryDescriptiveAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription 
      associated_sql_statement=IBM_CatalogEntrySubscription
      	  
    END_ENTITY
END_PROFILE





