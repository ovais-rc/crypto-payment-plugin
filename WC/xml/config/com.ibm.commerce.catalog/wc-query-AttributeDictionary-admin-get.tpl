BEGIN_SYMBOL_DEFINITIONS
	
	<!-- ATTRDICT table -->
	COLS:ATTRDICT=ATTRDICT:*
	COLS:ATTRDICT_ID=ATTRDICT:ATTRDICT_ID
	COLS:ATTRDICT:STOREENT_ID=ATTRDICT:STOREENT_ID
	
	<!-- ATTRVAL table -->
	COLS:ATTRVAL=ATTRVAL:*

	<!-- ATTR table -->
	COLS:ATTR=ATTR:*
	COLS:ATTR_ID=ATTR:ATTR_ID
	COLS:ATTR:STOREENT_ID=ATTR:STOREENT_ID
	COLS:ATTR:SEQUENCE=ATTR:SEQUENCE
	
	<!-- ATTRVALDESC table -->		
	COLS:ATTRVALDESC=ATTRVALDESC:*

	<!-- ATTRDESC table -->		
	COLS:ATTRDESC=ATTRDESC:*
	
	<!-- ATTRDICTGRP table -->
	COLS:ATTRDICTGRP_ID=ATTRDICTGRP:ATTRDICTGRP_ID	
	COLS:ATTRDICTGRP:STOREENT_ID=ATTRDICTGRP:STOREENT_ID
		
END_SYMBOL_DEFINITIONS

<!--=======================================================QUERY STATEMENTS BEGUN ============================================-->

<!-- XPath: /AttributeDictionary		-->
<!-- Find the attribute dictionary for current store -->
<!-- AccessProfile:	IBM_Admin_Summary 		-->		

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionary+IBM_Admin_Summary
	base_table=ATTRDICT
	sql=
		SELECT 
	     		ATTRDICT.$COLS:ATTRDICT$     				
	     	FROM
	     		ATTRDICT				
	     	WHERE
	     	ATTRDICT.STOREENT_ID IN ($STOREPATH:catalog$)
						
END_XPATH_TO_SQL_STATEMENT


<!-- Find the attribute dictionary attribute by unique Id	-->
<!-- AccessProfile:	IBM_Admin_Summary 				-->		

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionary[AttributeDictionaryIdentifier[(UniqueID=)]]+IBM_Admin_Summary
	base_table=ATTRDICT
	sql=
		SELECT 
			ATTRDICT.$COLS:ATTRDICT$     				
	     	FROM
			ATTRDICT				
	     	WHERE
			ATTRDICT.ATTRDICT_ID IN (?UniqueID?)
						
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
     Gets the attribute values based on the attribute ID and the 
	 attribute value IDs.
	 @param UniqueID The attribute ID to find ATTRVAL records for. 	
	 @param identifier The attribute value IDs to find ATTRVAL records for.
     ====================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute/AttributeIdentifier[(UniqueID=) and AttributeAllowedValue[(identifier=)]]+IBM_Admin_AttributeDictionary_AttributeValue
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$     				
	    FROM
				ATTRVAL				
	    WHERE
				ATTRVAL.ATTR_ID IN (?UniqueID?)
				AND ATTRVAL.ATTRVAL_ID IN (?identifier?)
				AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)						
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================== 
     Gets the attribute based on attribute dictionary attribute id  
     @param UniqueId Unique identifier of the attribute 
    	                      
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[(UniqueID=)]]+IBM_Admin_IdResolve
	base_table=ATTR
	sql=
		SELECT 
				ATTR.$COLS:ATTR$     				
	    FROM
				ATTR				
	    WHERE
				ATTR.ATTR_ID IN (?UniqueID?)
				AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
						
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================== 
     Gets the attribute value based on attribute dictionary attribute value id 
     @param identifier The attribute value identifier
                 
     ========================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute/AllowedValue[(@identifier=)]+IBM_Admin_IdResolve
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$     				
	    FROM
				ATTRVAL				
	    WHERE
				ATTRVAL.ATTRVAL_ID IN (?identifier?)
				AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
						
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Gets the attribute value based on attribute dictionary attribute id and attribute value id
	This XPath is deprecated, use the one blow instead.
	@param UniqueId Unique identifier of the attribute 
	@param identifier The attribute value identifier
	   
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute/AttributeIdentifier[(UniqueID=)] and AllowedValue[(@identifier=)]+IBM_Admin_IdResolve
	base_table=ATTRVAL
	sql=
		SELECT 
			ATTRVAL.$COLS:ATTRVAL$ 
		FROM 
			ATTRVAL 
		WHERE 
			ATTRVAL.ATTR_ID IN (?UniqueID?) AND ATTRVAL.ATTRVAL_ID IN (?identifier?) AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Gets the attribute value based on attribute dictionary attribute id and attribute value id
	@param UniqueId Unique identifier of the attribute 
	@param identifier The attribute value identifier
	   
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[(UniqueID=)] and AllowedValue[(@identifier=)]]+IBM_Admin_IdResolve
	base_table=ATTRVAL
	sql=
		SELECT 
			ATTRVAL.$COLS:ATTRVAL$ 
		FROM 
			ATTRVAL 
		WHERE 
			ATTRVAL.ATTR_ID IN (?UniqueID?) AND ATTRVAL.ATTRVAL_ID IN (?identifier?) AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Gets the attribute value description based on attribute dictionary attribute value id and language id
	@param identifier The attribute value identifier
	@param language The language id 
		   
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute/AllowedValue[(@identifier=) and (@language=)]+IBM_Admin_IdResolve
	base_table=ATTRVALDESC
	sql=
		SELECT 
			ATTRVALDESC.$COLS:ATTRVALDESC$ 
		FROM 
			ATTRVALDESC 
		WHERE 
			ATTRVALDESC.ATTRVAL_ID IN (?identifier?) AND ATTRVALDESC.LANGUAGE_ID IN (?language?)
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Gets the attribute value description based on attribute dictionary attribute value id and language id
	@param identifier The attribute value identifier
	@param language The language id 
		   
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute/AllowedValue[(@identifier=)]+IBM_Admin_AttributeDictionary_AttributeValue
	base_table=ATTRVALDESC
	sql=
		SELECT 
			ATTRVALDESC.$COLS:ATTRVALDESC$ 
		FROM 
			ATTRVALDESC 
		WHERE 
			ATTRVALDESC.ATTRVAL_ID IN (?identifier?)
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================== 
     Gets the attribute descriptions based on the attribute id and the language id.
	 @param UniqueID 
			The attribute dictionary attribute ID.
	 @param language
			The language ID to use for fetching the descriptions.
=========================================================================== -->
			
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute/AttributeIdentifier[(UniqueID=)] and AttributeDescription[(@language=)]+IBM_Admin_AttributeDictionaryAttributeAllowedValueUpdate
	base_table=ATTRDESC
	sql=
		SELECT 
				ATTRDESC.$COLS:ATTRDESC$    				
		FROM
				ATTRDESC
		WHERE
				ATTRDESC.ATTR_ID IN (?UniqueID?)
				AND ATTRDESC.LANGUAGE_ID IN (?language?)
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the owner id of the attribute dictionary having the specified unique id
	@param UniqueID The unique id of the attribute dictionary. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionary[AttributeDictionaryIdentifier[(UniqueID=)]]+IBM_Admin_AccessControlGetOwner
	base_table=ATTRDICT
	sql=
			SELECT 
	     				ATTRDICT.$COLS:ATTRDICT_ID$, ATTRDICT.$COLS:ATTRDICT:STOREENT_ID$, ATTR.$COLS:ATTR:SEQUENCE$
	     	FROM
	     				ATTRDICT
	     	WHERE
						ATTRDICT.ATTRDICT_ID=?UniqueID?
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the owner id of the attribute dictionary attribute having the specified unique id
	@param UniqueID The unique id of the attribute dictionary attribute. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[UniqueID=]]+IBM_Admin_AccessControlGetOwner
	base_table=ATTR
	sql=
			SELECT 
	     				ATTR.$COLS:ATTR_ID$, ATTR.$COLS:ATTR:STOREENT_ID$
	     	FROM
	     				ATTR
	     	WHERE
						ATTR.ATTR_ID=?UniqueID?
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the owner id of the attribute dictionary attribute group having the specified unique id
	@param UniqueID The unique id of the attribute dictionary attribute group. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttributeGroup[AttributeGroupIdentifier[UniqueID=]]+IBM_Admin_AccessControlGetOwner
	base_table=ATTRDICTGRP
	sql=
			SELECT 
	     				ATTRDICTGRP.$COLS:ATTRDICTGRP_ID$, ATTRDICTGRP.$COLS:ATTRDICTGRP:STOREENT_ID$
	     	FROM
	     				ATTRDICTGRP
	     	WHERE
						ATTRDICTGRP.ATTRDICTGRP_ID=?UniqueID?
END_XPATH_TO_SQL_STATEMENT


<!--======================================================ASSOCIATED STATEMENTS BEGIN =====================================-->
<!--============================================================== ASSOCIATED STATEMENTS END ====================================-->
<!--============================================================== QUERY STATEMENTS END ===========================================-->
<!--============================================================== PROFILE DEFINTITION BEGINS =====================================-->
<!--============================================================== PROFILE DEFINTITION ENDS =========================================-->
