BEGIN_SYMBOL_DEFINITIONS


	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	COLS:CATENTRY:MEMBER_ID=CATENTRY:MEMBER_ID
	COLS:CATENTRY:PARTNUMBER=CATENTRY:PARTNUMBER
	COLS:CATENTRY:CATENTTYPE_ID=CATENTRY:CATENTTYPE_ID
	COLS:CATENTRY:MARKFORDELETE=CATENTRY:MARKFORDELETE
	COLS:CATENTRY:BASEITEM_ID=CATENTRY:BASEITEM_ID
	<!-- CATENTSUBS table -->
	COLS:CATENTSUBS=CATENTSUBS:*

	<!-- CATALOG table -->
	COLS:CATALOG=CATALOG:*
	COLS:CATALOG_ID=CATALOG:CATALOG_ID

	<!-- CATGROUP table -->
	COLS:CATGROUP=CATGROUP:*
	COLS:CATGROUP_ID=CATGROUP:CATGROUP_ID



	<!-- STORECAT table -->
	COLS:STORECAT=STORECAT:*


	<!-- STORECGRP table -->
	COLS:STORECGRP=STORECGRP:*

	<!-- STORECENT table -->
	COLS:STORECENT=STORECENT:*


	<!-- Other tables -->
	COLS:ATTRVAL=ATTRVAL:*
	COLS:ATTRVALDESC=ATTRVALDESC:*

	COLS:ATTRIBUTE=ATTRIBUTE:*
	COLS:ATTRIBUTE_ID=ATTRIBUTE:ATTRIBUTE_ID
	COLS:ATTRVALUE=ATTRVALUE:*
	COLS:ATTRVALUE_ID=ATTRVALUE:ATTRVALUE_ID
	COLS:ATTRVALUE:ATTRIBUTE_ID=ATTRVALUE:ATTRIBUTE_ID
	COLS:CATENTDESC=CATENTDESC:*
	COLS:CATENTREL=CATENTREL:*
	COLS:CATENTATTR=CATENTATTR:*
	COLS:CATENTSHIP=CATENTSHIP:*
	COLS:CATGPENREL=CATGPENREL:*
	COLS:CATCLSFCOD=CATCLSFCOD:*
	COLS:CATCONFINF=CATCONFINF:*
	COLS:CATENCALCD=CATENCALCD:*
	COLS:DKPDCCATENTREL=DKPDCCATENTREL:*
	COLS:DKPDCCOMPLIST=DKPDCCOMPLIST:*
	COLS:DKPDCREL=DKPDCREL:*
	COLS:DISPENTREL=DISPENTREL:*
	COLS:CATENTTYPE=CATENTTYPE:*
	COLS:LISTPRICE=LISTPRICE:*
	COLS:BASEITEM=BASEITEM:*
	COLS:OFFER=OFFER:*
	COLS:ITEMSPC=ITEMSPC:*
	COLS:MASSOCCECE=MASSOCCECE:*

	COLS:CATALOGDSC=CATALOGDSC:*
	COLS:CATTOGRP=CATTOGRP:*
	COLS:CATGRPREL=CATGRPREL:*
	COLS:CATCNTR=CATCNTR:*
	COLS:CATGRPTPC=CATGRPTPC:*
	COLS:CATGRPPS=CATGRPPS:*
	COLS:PRSETCEREL=PRSETCEREL:*


	COLS:CATGPCALCD=CATGPCALCD:*
	COLS:CATGRPATTR=CATGRPATTR:*
	COLS:CATGRPDESC=CATGRPDESC:*
	COLS:MASSOCGPGP=MASSOCGPGP:*
	COLS:MASSOC=MASSOC:*
	COLS:MASSOCTYPE=MASSOCTYPE:*
	COLS:ITEMVERSN=ITEMVERSN:*
	COLS:VERSIONSPC=VERSIONSPC:*
	COLS:ITEMTYPE=ITEMTYPE:*
	COLS:BASEITMDSC=BASEITMDSC:*

	<!-- ATCHREL table -->
	COLS:ATCHREL=ATCHREL:*
	COLS:ATCHRELDSC=ATCHRELDSC:*
	COLS:ATCHRLUS_ID=ATCHRLUS:ATCHRLUS_ID
	COLS:ATCHOBJTYP_ID=ATCHOBJTYP:ATCHOBJTYP_ID

    <!-- CATENTRYATTR table -->
	COLS:CATENTRYATTR=CATENTRYATTR:*
	COLS:CATENTRYATTR:ATTRVAL_ID=CATENTRYATTR:ATTRVAL_ID
	COLS:CATENTRYATTR:ATTR_ID=CATENTRYATTR:ATTR_ID
	COLS:CATENTRYATTR:CATENTRY_ID=CATENTRYATTR:CATENTRY_ID

	<!-- Calculation code tables -->
	COLS:CALCODE=CALCODE:*

	<!-- CATENTDESCOVR table -->
	COLS:CATENTDESCOVR=CATENTDESCOVR:*

	<!-- CATOVRGRP table -->
	COLS:CATOVRGRP=CATOVRGRP:*

	<!-- CATENTRY_EXTERNAL_CONTENT_REL table -->
	COLS:CATENTRY_EXTERNAL_CONTENT_REL=CATENTRY_EXTERNAL_CONTENT_REL:*



END_SYMBOL_DEFINITIONS

<!-- ======================================================================
	Get catalog entry ID based on partnumber and owner id
	@param PartNumber The partnumber of the catalog entry
	@param ownerID The owner id of the catalog entry
	@param Context:STORE_ID The store for which to retrieve the catalog entry .
	 This parameter is retrieved from within the business context.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[ExternalIdentifier[(@ownerID= and PartNumber=)]]]+IBM_Admin_IdResolve
	base_table=CATENTRY
	sql=
			SELECT
	     				CATENTRY.$COLS:CATENTRY_ID$
	     	FROM
	     				CATENTRY
	     					JOIN STORECENT ON STORECENT.CATENTRY_ID=CATENTRY.CATENTRY_ID
	     	WHERE
						CATENTRY.PARTNUMBER=?PartNumber? AND CATENTRY.MEMBER_ID=?ownerID?
						 AND STORECENT.STOREENT_ID IN ($STOREPATH:catalog$) AND CATENTRY.MARKFORDELETE=0
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get catalog entry ID based on partnumber and owner id
	@param PartNumber The partnumber of the catalog entry
	@param ownerID The owner id of the catalog entry
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[ExternalIdentifier[(@ownerID= and PartNumber=)]]]+IBM_Admin_IdResolve_Without_Store_Filter
	base_table=CATENTRY
	sql=
			SELECT
	     				CATENTRY.$COLS:CATENTRY_ID$
	     	FROM
	     				CATENTRY
	     	WHERE
						CATENTRY.PARTNUMBER=?PartNumber? AND CATENTRY.MEMBER_ID=?ownerID?

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get catalog entry ID based on partnumber and owner id.
	@param PartNumber The part number of the catalog entry
	@param Context:OWNER_ID The owner id of the catalog entry from the context.
	This parameter is retrieved from within the business context.
	@param Context:STORE_ID The store for which to retrieve the catalog entry.
	This parameter is retrieved from within the business context.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[ExternalIdentifier[(PartNumber=)]]]+IBM_Admin_IdResolve
	<!-- name=/CatalogEntry[(@partNumber=)]+IBM_Admin_IdResolve -->
	base_table=CATENTRY
	sql=
			SELECT
	     				CATENTRY.$COLS:CATENTRY_ID$
	     	FROM
	     				CATENTRY
	     					JOIN STORECENT ON STORECENT.CATENTRY_ID=CATENTRY.CATENTRY_ID
	     	WHERE
						CATENTRY.PARTNUMBER=?PartNumber? AND CATENTRY.MEMBER_ID=$CTX:OWNER_ID$
						 AND STORECENT.STOREENT_ID IN ($STOREPATH:catalog$) AND CATENTRY.MARKFORDELETE=0
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the descriptions of the catalog entry based on the catalog entry id and
	belonging to the specified store in context
	@param UniqueID The catalog entry id
	@param Context:STORE_ID The store for which to retrieve the catalog entry .
	This parameter is retrieved from within the business context.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/Description[(@languageID=)]+IBM_Admin_CatalogEntryDescriptionUpdate
	base_table=CATENTDESC
	sql=
		SELECT
	     			CATENTDESC.$COLS:CATENTDESC$
	     	FROM
	     			CATENTDESC

	     	WHERE
				CATENTDESC.CATENTRY_ID IN (?UniqueID?) AND
				CATENTDESC.LANGUAGE_ID IN (?languageID?)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the list prices of the catalog entry based on the catalog entry id and belonging to the specified store in context
	@param UniqueID The catalog entry id
	@param Context:STORE_ID The store for which to retrieve the catalog entry . This parameter is retrieved from within the business context.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/ListPrice+IBM_Admin_CatalogEntryListPriceUpdate
	base_table=LISTPRICE
	sql=
			SELECT
	     				LISTPRICE.$COLS:LISTPRICE$
	     	FROM
	     				LISTPRICE
	     					JOIN STORECENT ON STORECENT.CATENTRY_ID=LISTPRICE.CATENTRY_ID
	     	WHERE
						LISTPRICE.CATENTRY_ID IN (?UniqueID?)
						 AND STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the associations of the catalog entry based on the catalog entry id of the parent and child and the association type
	This query is not in use by the BVA4 code and need to be deprecated.
	@param catalogEntryIdFrom The catalog entry id of the parent
	@param catalogEntryIdTo The catalog entry id of the child
	@param massocTypeId The association type id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/Association[@catalogEntryIdFrom= and @catalogEntryIdTo= and @massocTypeId=]+IBM_Admin_IdResolve
	base_table=MASSOCCECE
	sql=
			SELECT
	     				MASSOCCECE.$COLS:MASSOCCECE$
	     	FROM
	     				MASSOCCECE
	     	WHERE
						MASSOCCECE.CATENTRY_ID_FROM=?catalogEntryIdFrom?
						AND MASSOCCECE.CATENTRY_ID_TO=?catalogEntryIdTo?
						AND MASSOCCECE.MASSOCTYPE_ID=?massocTypeId?
END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================
	Get the associations of the catalog entry based on the catalog entry id of the parent and child and the association type and the semantic specifier
	@param catalogEntryIdFrom The catalog entry id of the parent
	@param catalogEntryIdTo The catalog entry id of the child
	@param massocTypeId The association type id
	@param massocId The semantic specifier
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/Association[@catalogEntryIdFrom= and @catalogEntryIdTo= and @massocTypeId= and @massocId=]+IBM_Admin_IdResolve
	base_table=MASSOCCECE
	sql=
			SELECT
	     				MASSOCCECE.$COLS:MASSOCCECE$
	     	FROM
	     				MASSOCCECE
	     	WHERE
						MASSOCCECE.CATENTRY_ID_FROM=?catalogEntryIdFrom?
						AND MASSOCCECE.CATENTRY_ID_TO=?catalogEntryIdTo?
						AND MASSOCCECE.MASSOCTYPE_ID=?massocTypeId?
						AND MASSOCCECE.MASSOC_ID =?massocId?
						AND MASSOCCECE.STORE_ID = $CTX:STORE_ID$
END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================
	Get the associations of the catalog entry based on the association id
	@param massocCatalogEntryRelationId The association relation id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/Association[(@massocCatalogEntryRelationId=)]+IBM_Admin_CatalogEntryAssociationUpdate
	base_table=MASSOCCECE
	sql=
			SELECT
	     				MASSOCCECE.$COLS:MASSOCCECE$
	     	FROM
	     				MASSOCCECE
	     	WHERE
						MASSOCCECE.MASSOCCECE_ID IN (?massocCatalogEntryRelationId?)
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the parent-child relationships of the catalog entry based on the catalog entry id of the parent and child
	@param catalogEntryIdFrom The catalog entry id of the parent
	@param catalogEntryIdTo The catalog entry id of the child
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/NavigationRelationship[(@catalogEntryIdFrom= and @catalogEntryIdTo=)]+IBM_Admin_IdResolve
	base_table=CATENTREL
	sql=
			SELECT
	     				CATENTREL.$COLS:CATENTREL$
	     	FROM
	     				CATENTREL
	     	WHERE
						CATENTREL.CATENTRY_ID_PARENT=?catalogEntryIdFrom?
						AND CATENTREL.CATENTRY_ID_CHILD=?catalogEntryIdTo?
END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================
	Get the parent-child relationships of the catalog entry based on the catalog entry id of the parent
	@param catalogEntryIdFrom The catalog entry id of the parent
        @param STOREPATH:catalog  Store Id retrieved form the business context
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/NavigationRelationship[(@catalogEntryIdFrom=)]+IBM_Admin_CatalogEntryRelationUpdate
	base_table=CATENTREL
	sql=
			SELECT
	     				CATENTREL.$COLS:CATENTREL$, CATENTRY.$COLS:CATENTRY$
	     	FROM
	     				CATENTREL, CATENTRY

	     	WHERE
						CATENTREL.CATENTRY_ID_PARENT IN (?catalogEntryIdFrom?)
						AND CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the parent-child relationships of the catalog entry based on the catalog entry id of the child
	@param catalogEntryIdTo The catalog entry id of the child
        @param STOREPATH:catalog  Store Id retrieved form the business context
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/NavigationRelationship[(@catalogEntryIdTo=)]+IBM_Admin_CatalogEntryRelationUpdate
	base_table=CATENTREL
	sql=
			SELECT
	     				CATENTREL.$COLS:CATENTREL$, CATENTRY.$COLS:CATENTRY$
	     	FROM
	     				CATENTREL, CATENTRY
	     	WHERE
						CATENTREL.CATENTRY_ID_CHILD IN (?catalogEntryIdTo?)
						AND CATENTREL.CATENTRY_ID_PARENT = CATENTRY.CATENTRY_ID
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the parent-child relationships of the catalog entry based on the catalog entry id of the child
	@param catalogEntryIdTo The catalog entry id of the child
=========================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/NavigationRelationship[(@catalogEntryIdTo=)]+IBM_Admin_CatalogEntry_SKUDisplaySequence
	base_table=CATENTREL
	sql=
			SELECT
	     				CATENTREL.$COLS:CATENTREL$
	     	FROM
	     				CATENTREL
	     	WHERE
					CATENTREL.CATENTRY_ID_CHILD IN (?catalogEntryIdTo?)
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the catalog group relationships of the catalog entry based on the catalog entry id
	@param catalogEntryIdTo The catalog entry id
        @param STOREPATH:catalog  Store Id retrieved form the business context
	@param CTX:CATALOG_ID  Catalog id retrived from the business context
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/NavigationRelationship+IBM_Admin_CatalogEntryGroupRelation
	base_table=CATGPENREL
	sql=
			SELECT
	     				CATGPENREL.$COLS:CATGPENREL$
	     	FROM
	     				CATGPENREL
	     	WHERE
	     	            CATGPENREL.CATENTRY_ID in (?UniqueID?)
					    AND CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$
END_XPATH_TO_SQL_STATEMENT
<!-- ======================================================================
	Get all the catalog group relationships of the catalog entry based on the catalog entry id
	@param UniqueId The catalog entry id
        @param STOREPATH:catalog  Store Id retrieved form the business context

=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/NavigationRelationship+IBM_Admin_CatalogEntryAllGroupRelation
	base_table=CATGPENREL
	sql=
			SELECT
	     				CATGPENREL.$COLS:CATGPENREL$
	     	FROM
	     				CATGPENREL
	     	WHERE
	     	            CATGPENREL.CATENTRY_ID in (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT



<!-- ======================================================================
	Resolve ATTRIBUTE records based on the CATENTRY_ID and attribute NAME, for the site-default language
	@param UniqueID The catalog entry id
	@param Name The name of the attribute
	@param languageId The language id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[Attributes[@languageId= and (Name=)]]+IBM_Admin_IdResolve
	base_table=ATTRIBUTE
	sql=
		SELECT
			ATTRIBUTE.$COLS:ATTRIBUTE$
		FROM
			ATTRIBUTE
        WHERE
                ATTRIBUTE.CATENTRY_ID IN (?UniqueID?) AND
                ATTRIBUTE.LANGUAGE_ID = ?languageId? AND
                ATTRIBUTE.NAME IN (?Name?)
END_XPATH_TO_SQL_STATEMENT




<!-- ======================================================================
	Get the attribute records associated with a catalog entry, by attribute Id for all languages
	@param UniqueID The catalog entry id
	@param attrId The dictionary attribute id
=========================================================================== -->
<!-- Get the attribute records associated with a catalog entry, by attribute Id for all languages -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[Attributes[ExtendedData[(attrId=)]]]
	base_table=ATTRIBUTE
	sql=
		SELECT
			ATTRIBUTE.$COLS:ATTRIBUTE_ID$
		FROM
			ATTRIBUTE
        WHERE
        	ATTRIBUTE.CATENTRY_ID IN (?UniqueID?) AND ATTRIBUTE.ATTRIBUTE_ID IN (?attrId?)
END_XPATH_TO_SQL_STATEMENT




<!-- ================================================================================================
	Fetch the allowed values and values for a catalog entry, by attribute value Id in all languages
	@param identifier The identifier of the allowed value
================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryAttributes[Attributes[AllowedValue[(@identifier=)]]]]+IBM_Admin_CatalogEntryAttributeAllowedValueUpdate
	base_table=ATTRVALUE
	sql=
		SELECT
			ATTRVALUE.$COLS:ATTRVALUE$
		FROM
			ATTRVALUE
		WHERE
			ATTRVALUE.ATTRVALUE_ID IN (?identifier?) AND ATTRVALUE.CATENTRY_ID = 0

END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================
	Get all the children of the catalog entry based on the catalog entry id of the parent
	@param UniqueID The catalog entry id of the parent
	@param catalogId The catalog id of the parent
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(CatalogEntryIdentifier[(UniqueID=)]) and (@catalogId=)]+IBM_Admin_CatalogEntryParentCatalogGroupProfile
	<!-- name=/CatEntry[(@catEntryId=) and (@catalogId=)]+IBM_Admin_CatalogEntryParentCatalogGroupProfile -->
	base_table=CATENTRY
	sql=
             	SELECT
	     			CATENTRY.$COLS:CATENTRY$,
				CATGPENREL.$COLS:CATGPENREL$


	     	FROM
	     			CATENTRY
				LEFT OUTER JOIN CATGPENREL
				ON
				(
					CATGPENREL.CATENTRY_ID= CATENTRY.CATENTRY_ID
					AND
					CATGPENREL.CATALOG_ID IN (?catalogId?)
				)

 		WHERE
				CATENTRY.MARKFORDELETE=0 AND
				CATENTRY.CATENTRY_ID  IN (?UniqueID?)


END_XPATH_TO_SQL_STATEMENT



<!-- ======================================================================
	Get all the children of the catalog entry based on the catalog entry id of the parent
	and catalog entry of type PRODUCT_ITEM
	@param catEntryId The catalog entry id of the parent
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]+IBM_Admin_CatalogEntryChildrenSKUProfile
	<!-- name=/CatEntry[(@catEntryId=)]+IBM_Admin_CatalogEntryChildrenSKUProfile -->
	base_table=CATENTRY
	sql=
            SELECT
	     			CATENTRY.$COLS:CATENTRY$,
				    CATENTREL.$COLS:CATENTREL$


	     	FROM
	     		CATENTRY
				LEFT OUTER JOIN CATENTREL
				ON
				(
					CATENTREL.CATENTRY_ID_PARENT= CATENTRY.CATENTRY_ID AND
					CATENTREL.CATRELTYPE_ID = 'PRODUCT_ITEM'

				)

 		  WHERE
				CATENTRY.MARKFORDELETE=0 AND
				CATENTRY.CATENTRY_ID  IN (?UniqueID?)



END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================
	Get the parent-child relationships of the catalog entry based on the catalog entry id of the parent and child
	and catalog entry of type PRODUCT_ITEM
	@param catalogEntryIdFrom The catalog entry id of the parent
	@param catalogEntryIdTo The catalog entry id of the child
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
        name=/CatalogEntry/NavigationRelationship[((@catalogEntryIdFrom= and @catalogEntryIdTo=))]+IBM_Admin_CatalogEntryProductItemRelationUpdate
	<!-- name=/CatalogEntryRelation[((@catalogEntryIdFrom= and @catalogEntryIdTo=))]+IBM_CatalogEntryRelation_Update -->
	base_table=CATENTREL
	sql=
			SELECT
	     				CATENTREL.$COLS:CATENTREL$
	     	FROM
	     				CATENTREL
	     	WHERE
						CATENTREL.CATENTRY_ID_PARENT IN (?catalogEntryIdFrom?)
						AND CATENTREL.CATENTRY_ID_CHILD IN (?catalogEntryIdTo?)
						AND CATENTREL.CATRELTYPE_ID='PRODUCT_ITEM'
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the parent-child relationships of the catalog entry based on the catalog entry id
	of the parent and child
	and catalog entry of type PACKAGE_COMPONENT,BUNDLE_COMPONENT,DYNAMIC_KIT_COMPONENT

	@param catalogEntryIdFrom The catalog entry id of the parent
	@param catalogEntryIdTo The catalog entry id of the child
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/KitComponent[((@catalogEntryIdFrom= and @catalogEntryIdTo=))]+IBM_Admin_CatalogEntryKitComponentUpdate
	base_table=CATENTREL
	<!-- name=/CatalogEntryRelation[((@catalogEntryIdFrom= and @catalogEntryIdTo=))]+IBM_CatalogEntryKitComponent_Update -->
	sql=
			SELECT
	     				CATENTREL.$COLS:CATENTREL$
	     	FROM
	     				CATENTREL
	     	WHERE
						CATENTREL.CATENTRY_ID_PARENT IN (?catalogEntryIdFrom?)
						AND CATENTREL.CATENTRY_ID_CHILD IN (?catalogEntryIdTo?)
						AND CATENTREL.CATRELTYPE_ID IN ('PACKAGE_COMPONENT','BUNDLE_COMPONENT','DYNAMIC_KIT_COMPONENT')
END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================
	Get the owner id of the catalog entry having the specified partNumber(s)

	@param PartNumber The part number(s) of the catalog entry.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryIdentifier[ExternalIdentifier[(PartNumber=)]+IBM_Admin_AccessControlGetOwner
	<!-- name=/CatalogEntry[(@partNumber=)]+IBM_AccessControlGetOwner -->
	base_table=CATENTRY
	sql=
			SELECT
	     				CATENTRY.$COLS:CATENTRY:MEMBER_ID$
	     	FROM
	     				CATENTRY
	     	WHERE
						CATENTRY.PARTNUMBER=?PartNumber?
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the owner id of the catalog entry having the specified unique id(s)
	@param catalogEntryId The unique id(s) of the catalog entry.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]+IBM_Admin_AccessControlGetOwner
	<!-- name=/CatalogEntry[(@catalogEntryId=)]+IBM_AccessControlGetOwner -->
	base_table=CATENTRY
	sql=
			SELECT
	     				CATENTRY.$COLS:CATENTRY:MEMBER_ID$
	     	FROM
	     				CATENTRY
	     	WHERE
						CATENTRY.CATENTRY_ID=?UniqueID?
END_XPATH_TO_SQL_STATEMENT



<!-- ======================================================================
	Get all the catalog entry product set relations for the given catalog entry id and product set id
	@param productSetId The product set id
	@param catalogEntryId The catalog entry id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch catalog entry to product set relationships-->
	<!-- xpath = "/CatEntry" -->
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)] and (@productSetId=)]+IBM_Admin_CatalogEntryToProductSetRelationship
	<!-- name=/CatEntry[(@catEntryId=) and (@productSetId=)]+IBM_CatalogEntryToProductSetRelationship -->
	base_table=CATENTRY
	sql=
             	SELECT
	     			CATENTRY.$COLS:CATENTRY_ID$,
				PRSETCEREL.$COLS:PRSETCEREL$


	     	FROM
	     			CATENTRY
				LEFT OUTER JOIN PRSETCEREL
				ON
				(
					PRSETCEREL.CATENTRY_ID= CATENTRY.CATENTRY_ID
					AND
					PRSETCEREL.PRODUCTSET_ID IN (?productSetId?)
				)
 		WHERE
				CATENTRY.MARKFORDELETE=0 AND
				CATENTRY.CATENTRY_ID=(?UniqueID?)

END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================
	Find catalog entry attribute by id
	@param attributeId The catalog entry attribute id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Attribute[(@attributeId=) and (@languageId=)]+IBM_Admin_IdResolve
	base_table=ATTRIBUTE
	sql=
		SELECT
			ATTRIBUTE.$COLS:ATTRIBUTE$
		FROM
			ATTRIBUTE
		WHERE
			ATTRIBUTE_ID = ?attributeId? AND LANGUAGE_ID=?languageId?
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Find catalog entry attribute value by id and name
	@param attributeId The catalog entry attribute id
	@param name The catalog entry attribute value name
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeValue[(@attributeId=) and (@name=) and (@languageId=)]+IBM_Admin_IdResolve
	base_table=ATTRVALUE
	sql=
		SELECT
			ATTRVALUE.$COLS:ATTRVALUE$
		FROM
			ATTRVALUE
		WHERE
			ATTRIBUTE_ID = ?attributeId? AND NAME=?name? AND LANGUAGE_ID=?languageId?
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Find catalog entry attribute value by id and name and catentry id
	@param attributeId The catalog entry attribute id
	@param name The catalog entry attribute value name
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeValue[(@attributeId=) and (@name=) and (@languageId=)]+IBM_Admin_AttributeValue_Create
	base_table=ATTRVALUE
	sql=
		SELECT
			ATTRVALUE.$COLS:ATTRVALUE$
		FROM
			ATTRVALUE
		WHERE
			ATTRIBUTE_ID = ?attributeId? AND NAME=?name? AND LANGUAGE_ID=?languageId? AND CATENTRY_ID=0
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Find catalog entry attribute value by id and name
	@param attributeId The catalog entry attribute id
	@param name The catalog entry attribute value name
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeValue[(@attributeId=) and (@catEntryId=)]+IBM_Admin_AttributeValue_Update
	base_table=ATTRVALUE
	sql=
		SELECT
			ATTRVALUE.$COLS:ATTRVALUE$
		FROM
			ATTRVALUE
		WHERE
			ATTRIBUTE_ID = ?attributeId? AND CATENTRY_ID in (?catEntryId?)
END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================
	Find catalog entry attribute values' IDs by catentry id
	@param UniqueId The catalog entry id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeValue[(@catEntryId=)]+IBM_Admin_CatalogEntryAttributeValueIds
	base_table=ATTRVALUE
	sql=
		SELECT
			ATTRVALUE.$COLS:ATTRVALUE_ID$, ATTRVALUE.$COLS:ATTRVALUE:ATTRIBUTE_ID$
		FROM
			ATTRVALUE
		WHERE
			ATTRVALUE.CATENTRY_ID = ?catEntryId?
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Find SKU's defining attribute dictionary attribute values by product id
	@param UniqueId The unique id of the product
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeValue[(@catEntryId=)]+IBM_Admin_SKUDefiningAttributeDictionaryAttributeValueIds
	base_table=CATENTRYATTR
	sql=
		SELECT
			CATENTRYATTR.$COLS:CATENTRYATTR:CATENTRY_ID$, CATENTRYATTR.$COLS:CATENTRYATTR:ATTR_ID$, CATENTRYATTR.$COLS:CATENTRYATTR:ATTRVAL_ID$
		FROM
			CATENTRYATTR, CATENTREL, CATENTRY
		WHERE
			CATENTRYATTR.CATENTRY_ID = CATENTREL.CATENTRY_ID_CHILD AND
			CATENTRYATTR.USAGE = '1' AND
			CATENTREL.CATENTRY_ID_PARENT IN (?catEntryId?) AND
			CATENTREL.CATRELTYPE_ID='PRODUCT_ITEM' AND
			CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID AND
			CATENTRY.MARKFORDELETE = 0
		ORDER BY
			CATENTRYATTR.CATENTRY_ID
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Find catalog entry defining attribute dictionary attribute values' IDs by catentry id
	@param UniqueId The catalog entry id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/AttributeValue[(@catEntryId=)]+IBM_Admin_CatalogEntryDefiningAttributeDictionaryAttributeValueIds
	base_table=CATENTRYATTR
	sql=
		SELECT
			CATENTRYATTR.$COLS:CATENTRYATTR:ATTR_ID$, CATENTRYATTR.$COLS:CATENTRYATTR:ATTRVAL_ID$
		FROM
			CATENTRYATTR
		WHERE
			CATENTRYATTR.CATENTRY_ID = ?catEntryId? and CATENTRYATTR.USAGE = '1'
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Find the defining classic attributes according to a list of attribute ids.
	@param attrId The attribute ids.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Attribute[(@attrId=)]+IBM_Admin_DefiningAttributeIds
	base_table=ATTRIBUTE
	sql=
		SELECT
			ATTRIBUTE.$COLS:ATTRIBUTE_ID$
		FROM
			ATTRIBUTE
		WHERE
			ATTRIBUTE.ATTRIBUTE_ID in (?attrId?) AND (USAGE = '1' OR USAGE IS NULL)
END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================
	Get catalog entry based on the catalog entry id
	@param catalogEntryId The catalog entry id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryId=)]
	base_table=CATENTRY
	sql=

		SELECT
			CATENTRY_ID_1
		FROM
		(
		  SELECT
		  		CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM
		  		CATENTRY
		  WHERE
		  		CATENTRY.CATENTRY_ID IN (?catalogEntryId?)  AND
				CATENTRY.MARKFORDELETE = 0
		) T1
		WHERE EXISTS
		(
		  SELECT
		  		1
		  FROM
		  		STORECENT
		  WHERE
		  		CATENTRY_ID_1 = STORECENT.CATENTRY_ID AND
		  		STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ )
		)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get catalog entry based on the catalog entry partnumber
	@param partnumber The catalog entry partnumber
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[ExternalIdentifier[(@ownerID= and PartNumber=)]]]+IBM_Admin_CatalogEntry_Basic_Partnumber
	base_table=CATENTRY
	sql=
			SELECT
	     				CATENTRY.$COLS:CATENTRY$
	     	FROM
	     				CATENTRY
						JOIN STORECENT ON STORECENT.CATENTRY_ID=CATENTRY.CATENTRY_ID

	     	WHERE
						CATENTRY.PARTNUMBER = ?PartNumber? AND CATENTRY.MEMBER_ID = ?ownerID?
						AND STORECENT.STOREENT_ID IN ($STOREPATH:catalog$) AND CATENTRY.MARKFORDELETE=0
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the store catalog entry relationship based on the catalog entry id.

	@param catalogEntryId The catalog entry id.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryStoreRelation[((@catalogEntryId= )]+IBM_Admin_CatalogEntryStoreRelation
	base_table=STORECENT
	sql=
		SELECT
	     				STORECENT.$COLS:STORECENT$
	     	FROM
	     				STORECENT
	     	WHERE
					STORECENT.CATENTRY_ID IN (?catalogEntryId?)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get attachment relation usage id based on identifier
	@param IDENTIFIER The identifier of the attachment relation usage.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ATCHRLUS[IDENTIFIER=]+IBM_Admin_IdResolve
	base_table=ATCHRLUS
	sql=
			SELECT
	     				ATCHRLUS.$COLS:ATCHRLUS_ID$
	     	FROM
	     				ATCHRLUS
	     	WHERE
						ATCHRLUS.IDENTIFIER=?IDENTIFIER?
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get attachment object type id based on CATALOG, CATENTRY, or CATGROUP
	@param IDENTIFIER The identifier of the attachment object type.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ATCHOBJTYP[IDENTIFIER=]+IBM_Admin_IdResolve
	base_table=ATCHOBJTYP
	sql=
			SELECT
	     				ATCHOBJTYP.$COLS:ATCHOBJTYP_ID$
	     	FROM
	     				ATCHOBJTYP
	     	WHERE
						ATCHOBJTYP.IDENTIFIER=?IDENTIFIER?
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the attachment reference by unique id
	@param ATCHREL_ID The attachment reference id.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ATCHREL[(ATCHREL_ID=)]+IBM_Admin_AttachmentReference_Update
	base_table=ATCHREL
	sql=
			SELECT
	     				ATCHREL.$COLS:ATCHREL$,
	     				ATCHRELDSC.$COLS:ATCHRELDSC$
	     	FROM
	     				ATCHREL LEFT OUTER JOIN ATCHRELDSC ON ATCHRELDSC.ATCHREL_ID = ATCHREL.ATCHREL_ID
	     	WHERE
						ATCHREL.ATCHREL_ID IN (?ATCHREL_ID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the attachment relation of the catalog of the given store having the specified value for object(for example catalog) Id, object type id, usage id and attachment target id
	@param ATCHTGT_ID The attachment target id.
	@param BIGINTOBJECT_ID The object id.
	@param ATCHOBJTYP_ID The object type id.
	@param ATCHRLUS_ID The usage id.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ATCHREL[ATCHTGT_ID= and BIGINTOBJECT_ID= and ATCHOBJTYP_ID= and ATCHRLUS_ID=]+IBM_Admin_AttachmentReference_Update
	base_table=ATCHREL
	sql=
			SELECT
	     				ATCHREL.$COLS:ATCHREL$,
	     				ATCHRELDSC.$COLS:ATCHRELDSC$
	     	FROM
	     				ATCHREL LEFT OUTER JOIN ATCHRELDSC ON ATCHRELDSC.ATCHREL_ID = ATCHREL.ATCHREL_ID
	     	WHERE
						ATCHREL.BIGINTOBJECT_ID = ?BIGINTOBJECT_ID? AND
						ATCHREL.ATCHOBJTYP_ID = ?ATCHOBJTYP_ID? AND
						ATCHREL.ATCHRLUS_ID = ?ATCHRLUS_ID? AND
						ATCHREL.ATCHTGT_ID = ?ATCHTGT_ID?
END_XPATH_TO_SQL_STATEMENT


<!-- =============================================================================
     Adds classic attribute values (ATTRVALUE table) of catalog entries to the
     resultant data graph.
     ============================================================================= -->

<!-- =========================================================================================================
	Get allowed values and values of classic attributes according to the classic attributes ids and unique ids
	of catalog entry.
	@param attrId The classic attribute ids.
	@param UniqueID The unique ids of the catalog entry.
========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]CatalogEntryAttributes[Attributes[ExtendedData[(attrId=)]]]/AllowedValue+IBM_Admin_AttributeValue
	base_table=ATTRVALUE
	sql=
		SELECT
			ATTRVALUE.$COLS:ATTRVALUE$
		FROM
			ATTRVALUE
		WHERE
			ATTRVALUE.ATTRIBUTE_ID IN (?attrId?) AND
			(ATTRVALUE.CATENTRY_ID = 0 OR ATTRVALUE.CATENTRY_ID IN (?UniqueID?))
		ORDER BY
			ATTRVALUE.SEQUENCE

END_XPATH_TO_SQL_STATEMENT

<!-- =========================================================================================================
	Get allowed values and SKU's values of classic attributes according to the classic attributes ids and unique id
	of the product.
	@param attrId The classic attribute ids.
	@param UniqueID The unique id of the parent product.
========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[ParentCatalogEntryIdentifier[UniqueID=]]CatalogEntryAttributes[Attributes[ExtendedData[(attrId=)]]]/AllowedValue+IBM_Admin_AttributeValue
	base_table=ATTRVALUE
	sql=
		SELECT
			ATTRVALUE.$COLS:ATTRVALUE$
		FROM
			ATTRVALUE
		WHERE
			ATTRVALUE.ATTRIBUTE_ID IN (?attrId?) AND
			(ATTRVALUE.CATENTRY_ID = 0 OR ATTRVALUE.CATENTRY_ID IN
				(SELECT CATENTREL.CATENTRY_ID_CHILD FROM CATENTREL WHERE CATENTREL.CATENTRY_ID_PARENT=?UniqueID?)
			)
		ORDER BY
			ATTRVALUE.SEQUENCE

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the attribute records associated with a catalog entry, by attribute Id for all languages
	@param UniqueID The catalog entry id
	@param attrId The dictionary attribute id
=========================================================================== -->
<!-- Get the attribute records associated with a catalog entry, by attribute Id for all languages -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[Attributes[AttributeIdentifier[(UniqueID=)]]]+IBM_Admin_CatalogEntryAttributeUpdate
	base_table=CATENTRYATTR
	sql=
		SELECT
	     			CATENTRYATTR.$COLS:CATENTRYATTR$
	     	FROM
	     			CATENTRYATTR

	     	WHERE
					CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND
					CATENTRYATTR.ATTR_ID IN (?attrId?)
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the catalog entry attribute relationship records associated with a catalog entry, attribute and different usage type.
	@param UniqueID The catalog entry id
	@param attrId The dictionary attribute id
	@param usage The usage type
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[Attributes[(@usage=) and AttributeIdentifier[(UniqueID=)]]]+IBM_Admin_CatalogEntryAttributeForDifferentAttributeUsage
	base_table=CATENTRYATTR
	sql=
		SELECT
	     			CATENTRYATTR.$COLS:CATENTRYATTR$
	     	FROM
	     			CATENTRYATTR

	     	WHERE
					CATENTRYATTR.CATENTRY_ID=?UniqueID? AND
					CATENTRYATTR.ATTR_ID=?attrId? AND
					CATENTRYATTR.USAGE<>?usage?
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the catalog entry attribute relationship records associated with a catalog entry, based on catentry id and attribute id.
	@param UniqueID The catalog entry id
	@param attrId The dictionary attribute id

=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/CatalogEntryAttributes[Attributes[AttributeIdentifier[(UniqueID=)]]]+IBM_Admin_CatalogEntryAttributeRelationship
	base_table=CATENTRYATTR
	sql=
		SELECT
	     			CATENTRYATTR.$COLS:CATENTRYATTR$
	     	FROM
	     			CATENTRYATTR

	     	WHERE
					CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND
					CATENTRYATTR.ATTR_ID IN (?attrId?)

END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================
	Find catalog entry calculation code by calculation code and store
	@param calcodeId The calculation code id
	@param storeId The store identifier
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntryCalculationCode[(@calcodeId=) and (@storeId=)]+IBM_Admin_IdResolve
	base_table=CATENCALCD
	sql=
		SELECT
			CATENCALCD.$COLS:CATENCALCD$
		FROM
			CATENCALCD
		WHERE
			CALCODE_ID = ?calcodeId? AND
			STORE_ID = ?storeId?
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Find calculation code identifier by code, usage type and store
	@param code The calculation code name
	@param calUsageId The calculation usage type identifier
	@param storeId The store identifier
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Calcode[(@code=) and (@calUsageId=) and (@storeId=)]+IBM_Admin_IdResolve
	base_table=CALCODE
	sql=
		SELECT
			CALCODE.$COLS:CALCODE$
		FROM
			CALCODE
		WHERE
			CODE = ?code? AND
			CALUSAGE_ID = ?calUsageId? AND
			STOREENT_ID = ?storeId?
END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================
	Get the description override of the catalog entry based on the description
	override unique id.
	@param UniqueID The description override unique id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/Description/Override[DescriptionOverrideIdentifier[(UniqueID=)]]+IBM_Admin_CatalogEntryDescriptionOverrideUpdate
	base_table=CATENTDESCOVR
	sql=
		SELECT
	     			CATENTDESCOVR.$COLS:CATENTDESCOVR$
	     	FROM
	     			CATENTDESCOVR

	     	WHERE
				CATENTDESCOVR.CATENTDESCOVR_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================
	Get the description override of the catalog entry and related override group information
	based on the description override unique id.
	@param UniqueID The description override unique id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/Description/Override[DescriptionOverrideIdentifier[(UniqueID=)]]+IBM_Admin_CatalogEntryDescriptionOverrideWithOverrideGroup
	base_table=CATENTDESCOVR
	sql=
		SELECT
	     			CATENTDESCOVR.$COLS:CATENTDESCOVR$, CATOVRGRP.$COLS:CATOVRGRP$
	     	FROM
	     			CATENTDESCOVR
	     			JOIN CATOVRGRP ON CATENTDESCOVR.CATOVRGRP_ID=CATOVRGRP.CATOVRGRP_ID

	     	WHERE
					CATENTDESCOVR.CATENTDESCOVR_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT



<!-- ======================================================================
	Get the description override of the catalog entry based on the catalog entry id, language id and the override group id.
	@param catalogEntryIdFrom The catalog entry id of the parent
	@param catalogEntryIdTo The catalog entry id of the child
	@param massocTypeId The association type id
	@param massocId The semantic specifier
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/Description[(@languageID=)]/Override+IBM_Admin_IdResolve
	base_table=CATENTDESCOVR
	sql=
			SELECT
	     				CATENTDESCOVR.$COLS:CATENTDESCOVR$, CATOVRGRP.$COLS:CATOVRGRP$
	     	FROM
	     				CATENTDESCOVR
							JOIN CATOVRGRP ON CATENTDESCOVR.CATOVRGRP_ID=CATOVRGRP.CATOVRGRP_ID
								AND CATOVRGRP.STOREENT_ID=$CTX:STORE_ID$
	     	WHERE
						CATENTDESCOVR.CATENTRY_ID = ?UniqueID?
						AND CATENTDESCOVR.LANGUAGE_ID =?languageID?


END_XPATH_TO_SQL_STATEMENT




<!-- ===================================================================================
     Adds the schema of classic attributes (ATTRIBUTE table) of catalog entries to the
     resultant data graph.
     =============================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeSchema
	base_table=ATTRIBUTE
	sql=

		SELECT
				ATTRIBUTE.$COLS:ATTRIBUTE$
		FROM
				ATTRIBUTE
        WHERE
				ATTRIBUTE.ATTRIBUTE_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info 				                   -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntry
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT
				CATENTRY.$COLS:CATENTRY$,
				CATENTSUBS.$COLS:CATENTSUBS$,
				CATCONFINF.$COLS:CATCONFINF$
		FROM
		    CATENTRY
		      LEFT OUTER JOIN CATENTSUBS ON (CATENTRY.CATENTRY_ID = CATENTSUBS.CATENTRY_ID)
					LEFT OUTER JOIN CATCONFINF ON (CATENTRY.CATENTRY_ID = CATCONFINF.CATENTRY_ID)
		WHERE
		    CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntryWithShipment
	base_table=CATENTRY
	sql=
		SELECT
				CATENTRY.$COLS:CATENTRY$,
				CATENTSHIP.$COLS:CATENTSHIP$
		FROM
		    CATENTRY
		      LEFT OUTER JOIN CATENTSHIP ON (CATENTRY.CATENTRY_ID = CATENTSHIP.CATENTRY_ID)
		WHERE
		    CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntryWithCalculationCode
	base_table=CATENTRY
	sql=
		SELECT
			CATENTRY.$COLS:CATENTRY$, CATENCALCD.$COLS:CATENCALCD$, CALCODE.$COLS:CALCODE$
		FROM
			CATENTRY, CATENCALCD, CALCODE
		WHERE
			CATENTRY.CATENTRY_ID = CATENCALCD.CATENTRY_ID AND
			CALCODE.CALCODE_ID = CATENCALCD.CALCODE_ID AND
			CATENCALCD.STORE_ID = $CTX:STORE_ID$ AND
			CATENCALCD.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ======================================================================
	Get the identifier information of the catalog entry (CATENTRY table)
	based on the catalog entry id
=========================================================================== -->

BEGIN_PROFILE
	name=IBM_Admin_CatalogEntry_Basic_Id
	BEGIN_ENTITY
	  base_table=CATENTRY
      associated_sql_statement=IBM_RootCatalogEntry
    END_ENTITY
END_PROFILE

<!-- ======================================================================
	Get the basic information of the catalog entry (CATENTRY table) based
	on the catalog entry id
=========================================================================== -->

BEGIN_PROFILE
	name=IBM_Admin_CatalogEntryUpdate
	BEGIN_ENTITY
	  base_table=CATENTRY
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_RootCatalogEntryWithShipment
      associated_sql_statement=IBM_RootCatalogEntryWithCalculationCode

    END_ENTITY
END_PROFILE

<!-- =================================================================================================================================
	Get the classic attributes and values of the catalog entry for updating,
	based on the catalog entry id. The Attribute Graph Composer also call XPath query
	/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]CatalogEntryAttributes[Attributes[ExtendedData[(attrId=)]]]/AllowedValue+IBM_AttributeValue
	to add the allowed values and values of the classic attributes.
================================================================================================================================== -->

BEGIN_PROFILE
	name=IBM_Admin_CatalogEntryAttributeUpdate
	BEGIN_ENTITY
	  base_table=ATTRIBUTE
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.AttributeGraphComposer
      associated_sql_statement=IBM_AttributeSchema
    END_ENTITY
END_PROFILE



<!-- ======================================================================
	Get the external content relationships of the catalog entry based on the relationship unique ID.
	@param UniqueID The unique id of the relationship.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/CatalogEntry/ExternalContentReference[((UniqueID=)]+IBM_Admin_CatalogEntryExternalContentReferenceUpdate
  base_table=CATENTRY_EXTERNAL_CONTENT_REL
  sql=SELECT $COLS:CATENTRY_EXTERNAL_CONTENT_REL$ 
      FROM CATENTRY_EXTERNAL_CONTENT_REL
      WHERE  CE_EXTERNAL_CONTENT_REL_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT



<!-- ======================================================================
	Get the external content relationships of the catalog entry based on the catalog entry id, language ID, type and store
	 in context
	@param UniqueID The catalog entry id
	@param languageID The language ID
	@param Context:STORE_ID The store for which to retrieve the catalog entry .
	This parameter is retrieved from within the business context.
	@param ExternalContentType The external content type
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]/ExternalContentReference[(@languageID= and ExternalContentType=)]+IBM_Admin_IdResolve
  base_table=CATENTRY_EXTERNAL_CONTENT_REL
  sql=SELECT $COLS:CATENTRY_EXTERNAL_CONTENT_REL$ 
      FROM   CATENTRY_EXTERNAL_CONTENT_REL
      WHERE  CATENTRY_ID IN (?UniqueID?)
      AND    LANGUAGE_ID IN (?languageID?)
      AND    TYPE IN (?ExternalContentType?)
      AND    CATOVRGRP_ID IN (SELECT CATOVRGRP_ID FROM STORECATOVRGRP WHERE STOREENT_ID IN ( $STOREPATH:catalog$ ))      
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================= -->
<!-- Access Profile Alias definition			       -->
<!-- ========================================================= -->

BEGIN_PROFILE_ALIASES
  base_table=CATENTRY
  IBM_IdResolve=IBM_Admin_IdResolve
  IBM_CatalogEntryParentCatalogGroupProfile=IBM_Admin_CatalogEntryParentCatalogGroupProfile
  IBM_CatalogEntryChildrenSKUProfile=IBM_Admin_CatalogEntryChildrenSKUProfile
  IBM_AccessControlGetOwner=IBM_Admin_AccessControlGetOwner
  IBM_CatalogEntryToProductSetRelationship=IBM_Admin_CatalogEntryToProductSetRelationship
  IBM_CatalogEntry_Basic_Partnumber=IBM_Admin_CatalogEntry_Basic_Partnumber
  IBM_CatalogEntry_Basic_Id=IBM_Admin_CatalogEntry_Basic_Id
  IBM_CatalogEntryUpdate=IBM_Admin_CatalogEntryUpdate
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATENTDESC
IBM_CatalogEntryDescriptionUpdate=IBM_Admin_CatalogEntryDescriptionUpdate
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATENTREL
  IBM_IdResolve=IBM_Admin_IdResolve
  IBM_CatalogEntryRelationUpdate=IBM_Admin_CatalogEntryRelationUpdate
  IBM_CatalogEntryProductItemRelationUpdate=IBM_Admin_CatalogEntryProductItemRelationUpdate
  IBM_CatalogEntryKitComponentUpdate=IBM_Admin_CatalogEntryKitComponentUpdate
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=MASSOCCECE
  IBM_IdResolve=IBM_Admin_IdResolve
  IBM_CatalogEntryAssociationUpdate=IBM_Admin_CatalogEntryAssociationUpdate
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATTRIBUTE
  IBM_IdResolve=IBM_Admin_IdResolve
  IBM_DefiningAttributeIds=IBM_Admin_DefiningAttributeIds
  IBM_CatalogEntryAttributeUpdate=IBM_Admin_CatalogEntryAttributeUpdate
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATTRVALUE
  IBM_IdResolve=IBM_Admin_IdResolve
  IBM_CatalogEntryAttributeAllowedValueUpdate=IBM_Admin_CatalogEntryAttributeAllowedValueUpdate
  IBM_AttributeValue_Update=IBM_Admin_AttributeValue_Update
  IBM_CatalogEntryAttributeValueIds=IBM_Admin_CatalogEntryAttributeValueIds
  IBM_AttributeValue=IBM_Admin_AttributeValue
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=LISTPRICE
  IBM_CatalogEntryListPriceUpdate=IBM_Admin_CatalogEntryListPriceUpdate
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATCHOBJTYP
  IBM_IdResolve=IBM_Admin_IdResolve
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATCHRLUS
  IBM_IdResolve=IBM_Admin_IdResolve
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATCHREL
  IBM_AttachmentReference_Update=IBM_Admin_AttachmentReference_Update
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=STORECENT
  IBM_CatalogEntryStoreRelation=IBM_Admin_CatalogEntryStoreRelation
END_PROFILE_ALIASES
