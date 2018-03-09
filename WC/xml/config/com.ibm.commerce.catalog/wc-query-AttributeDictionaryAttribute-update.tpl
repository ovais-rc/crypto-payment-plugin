
BEGIN_SYMBOL_DEFINITIONS
	
	<!-- ATTR table -->
	COLS:ATTR=ATTR:*
	COLS:ATTR_ID=ATTR:ATTR_ID
	COLS:ATTR:IDENTIFIER=ATTR:IDENTIFIER
	COLS:ATTR:ATTRTYPE_ID=ATTR:ATTRTYPE_ID
	COLS:ATTR:ATTRDICT_ID=ATTR:ATTRDICT_ID
	COLS:ATTR:STOREENT_ID=ATTR:STOREENT_ID
	COLS:ATTR:SEQUENCE =ATTR:SEQUENCE 
	COLS:ATTR:DISPLAYABLE=ATTR:DISPLAYABLE
	COLS:ATTR:SEARCHABLE=ATTR:SEARCHABLE
	COLS:ATTR:COMPARABLE=ATTR:COMPARABLE
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

	<!-- ATTRVALDESC table -->		
	COLS:ATTRVALDESC=ATTRVALDESC:*

	<!-- CATENTRYATTR table -->		
	COLS:CATENTRYATTR=CATENTRYATTR:*
	<!-- FACET table -->
	COLS:FACET=FACET:*	
	<!-- ATTRDICTSRCHCONF table -->
	COLS:ATTRDICTSRCHCONF=ATTRDICTSRCHCONF:*	
	<!-- SRCHATTR table -->
	COLS:SRCHATTR=SRCHATTR:*	


	

END_SYMBOL_DEFINITIONS
<!--=======================================================QUERY STATEMENTS BEGUN ============================================-->



<!-- ====================================================================== 
	Get attribute ID based on external identifier and attribute dictionary id.
	@param identifier The external identifier of the attribute
	@param attributeDictionaryId The attribute dictionary id
=========================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[ExternalIdentifier[Identifier= and AttributeDictionaryIdentifier[(UniqueID=)]]]]+IBM_Admin_IdResolve		
	base_table=ATTR
	sql=	
		SELECT 
	     		ATTR.$COLS:ATTR_ID$
	     	FROM
	     		ATTR
	     	WHERE
			ATTR.IDENTIFIER IN (?identifier?) AND
			ATTR.ATTRDICT_ID = (?attributeDictionaryId?)			
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get attribute basic data based on the unique id.
	@param UniqueID The attribute unique id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[(UniqueID=)]]+IBM_Admin_AttributeDictionaryAttributeUpdate
	base_table=ATTR
	sql=
		SELECT 
			ATTR.$COLS:ATTR$, FACET.$COLS:FACET$, ATTRDICTSRCHCONF.$COLS:ATTRDICTSRCHCONF$, SRCHATTR.$COLS:SRCHATTR$
		FROM
	     	ATTR LEFT OUTER JOIN FACET ON ATTR.ATTR_ID=FACET.ATTR_ID
	     	LEFT OUTER JOIN ATTRDICTSRCHCONF ON ATTR.ATTR_ID=ATTRDICTSRCHCONF.ATTR_ID			LEFT OUTER JOIN SRCHATTR ON FACET.SRCHATTR_ID=SRCHATTR.SRCHATTR_ID
			
		WHERE
			ATTR.ATTR_ID IN (?UniqueID?) 
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get attribute value basic data based on the unique id.
	@param UniqueID The attribute value unique id.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute/AllowedValue[(@identifier=)]+IBM_Admin_AttributeDictionaryAttributeAllowedValueUpdate
	base_table=ATTRVAL
	sql=
		SELECT   
			ATTRVAL.$COLS:ATTRVAL$, ATTRVALDESC.$COLS:ATTRVALDESC$
	     	FROM
		    	ATTRVAL LEFT OUTER JOIN ATTRVALDESC ON ATTRVAL.ATTRVAL_ID=ATTRVALDESC.ATTRVAL_ID
	     	WHERE
			ATTRVAL.ATTRVAL_ID IN (?UniqueID?)	
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the attribute allowed value records associated with a catalog entry, based on attribute id and attribute value id.
	This query only looks at catalog entries that have NOT been marked as delete.
	This XPath is deprecated, use the one blow instead.
	@param UniqueId Unique identifier of the attribute 
	@param identifier The attribute value identifier
	   
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute/AttributeIdentifier[(UniqueID=)] and AllowedValue[(@identifier=)]+IBM_Admin_AttributeDictionaryAttributeAllowedValueUpdate
	base_table=CATENTRYATTR
	sql=
		SELECT 
			CATENTRYATTR.$COLS:CATENTRYATTR$ 
		FROM 
			CATENTRYATTR, CATENTRY 
		WHERE 
			CATENTRYATTR.CATENTRY_ID=CATENTRY.CATENTRY_ID AND 			
			CATENTRYATTR.ATTR_ID IN (?UniqueID?) AND 
			CATENTRYATTR.ATTRVAL_ID IN (?identifier?) AND
			CATENTRY.MARKFORDELETE = 0			
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the attribute allowed value records associated with a catalog entry, based on attribute id and attribute value id.
	This query only looks at catalog entries that have NOT been marked as delete.
	@param UniqueId Unique identifier of the attribute 
	@param identifier The attribute value identifier
	   
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[(UniqueID=)] and AllowedValue[(@identifier=)]]+IBM_Admin_AttributeDictionaryAttributeAllowedValueUpdate
	base_table=CATENTRYATTR
	sql=
		SELECT 
			CATENTRYATTR.$COLS:CATENTRYATTR$ 
		FROM 
			CATENTRYATTR, CATENTRY 
		WHERE 
			CATENTRYATTR.CATENTRY_ID=CATENTRY.CATENTRY_ID AND 			
			CATENTRYATTR.ATTR_ID IN (?UniqueID?) AND 
			CATENTRYATTR.ATTRVAL_ID IN (?identifier?) AND
			CATENTRY.MARKFORDELETE = 0			
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the attribute allowed value records, based on attribute id and attribute value identifier.
	This XPath is deprecated, use the one blow instead.
	@param UniqueId Unique identifier of the attribute 
	@param identifier The attribute value identifier
	   
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute/AttributeIdentifier[(UniqueID=)] and AllowedValue[(@identifier=)]+IBM_Admin_AttributeDictionaryAttributeAllowedValueCreate
	base_table=ATTRVAL
	sql=
		SELECT 
			ATTRVAL.$COLS:ATTRVAL$
		FROM 
			ATTRVAL 
		WHERE 
			ATTRVAL.ATTR_ID IN (?UniqueID?) AND 
			ATTRVAL.IDENTIFIER IN (?identifier?)
						
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the attribute allowed value records, based on attribute id and attribute value identifier.
	@param UniqueId Unique identifier of the attribute 
	@param identifier The attribute value identifier
	   
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeDictionaryAttribute[AttributeIdentifier[(UniqueID=)] and AllowedValue[(@identifier=)]]+IBM_Admin_AttributeDictionaryAttributeAllowedValueCreate
	base_table=ATTRVAL
	sql=
		SELECT 
			ATTRVAL.$COLS:ATTRVAL$
		FROM 
			ATTRVAL 
		WHERE 
			ATTRVAL.ATTR_ID IN (?UniqueID?) AND 
			ATTRVAL.IDENTIFIER IN (?identifier?)
						
END_XPATH_TO_SQL_STATEMENT
