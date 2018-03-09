BEGIN_SYMBOL_DEFINITIONS

	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	COLS:CATENTRY:CATENTTYPE_ID=CATENTRY:CATENTTYPE_ID
	COLS:CATENTRY:BASEITEM_ID=CATENTRY:BASEITEM_ID
	COLS:CATENTRY:ITEMSPC_ID=CATENTRY:ITEMSPC_ID
	COLS:CATENTRY:OPTCOUNTER=CATENTRY:OPTCOUNTER

	<!-- CATALOG table -->
	COLS:CATALOG=CATALOG:*
	COLS:CATALOG_ID=CATALOG:CATALOG_ID
	<!-- CATGROUP table -->
	COLS:CATGROUP=CATGROUP:*
	COLS:CATGROUP_ID=CATGROUP:CATGROUP_ID
	<!-- Other tables -->
	COLS:INVENTORY=INVENTORY:*
	COLS:STOREITEM=STOREITEM:*

	
	COLS:ATTRIBUTE=ATTRIBUTE:*
	COLS:ATTRVALUE=ATTRVALUE:*
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
		
	COLS:STORECAT=STORECAT:*
	COLS:STORECENT=STORECENT:*

END_SYMBOL_DEFINITIONS

<!-- ========================================================================= -->
<!-- ================================== INVENTORY BEGINS ===================== -->
<!-- ========================================================================= -->

<!-- ====================================================================== 
	Get base item description based on base item id and language id
	@param BaseItemId The base item id
	@param LanguageId The language id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/BaseItemDescription[(BaseItemId=) and (LanguageId=)]+IBM_Admin_BaseItemDescription
	base_table=BASEITMDSC
	sql=
		SELECT 
				BASEITMDSC.$COLS:BASEITMDSC$
				
		FROM
				BASEITMDSC
						
        WHERE
               BASEITMDSC.BASEITEM_ID IN (?BaseItemId?) and
               BASEITMDSC.LANGUAGE_ID IN (?LanguageId?) 
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get store item based on base item id and store id
	@param BaseItemId The base item id
	@param StoreId The store id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/StoreItem[(BaseItemId=) and (storeId=)]+IBM_Admin_StoreItemDetails
	base_table=STOREITEM
	sql=
		SELECT 
				STOREITEM.$COLS:STOREITEM$
				
		FROM
				STOREITEM
						
        WHERE
               STOREITEM.BASEITEM_ID IN (?BaseItemId?) and
               STOREITEM.STOREENT_ID IN (?storeId?) 
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get inventory information based on catalog entry id, fulfillment center id and store id
	@param CatentryId The catalog entry id
	@param FfmcenterId The fulfillment center id
	@param StoreId The store id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Inventory[(CatentryId=) and (FfmcenterId=) and (StoreId=)]+IBM_Admin_InventoryDetails
	base_table=INVENTORY
	sql=
		SELECT 
				INVENTORY.$COLS:INVENTORY$
				
		FROM
				INVENTORY
						
        WHERE
               INVENTORY.CATENTRY_ID IN (?CatentryId?) and
               INVENTORY.FFMCENTER_ID IN (?FfmcenterId?) and
               INVENTORY.STORE_ID IN (?StoreId?) 
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get version specified based on version specified id
	@param VersionSpecifiedId The version specified id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/VersionSpecified[(VersionSpecifiedId=)]+IBM_Admin_VersionSpecifiedDetails
	base_table=VERSIONSPC
	sql=
		SELECT 
				VERSIONSPC.$COLS:VERSIONSPC$
				
		FROM
				VERSIONSPC
						
        WHERE
               VERSIONSPC.ITEMSPC_ID IN (?VersionSpecifiedId?)
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get base item based on base item id
	@param BaseItemId The base item id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/BaseItem[(BaseItemId=)]+IBM_Admin_BaseItemDetails
	base_table=BASEITEM
	sql=
		SELECT 
				BASEITEM.$COLS:BASEITEM$
				
		FROM
				BASEITEM
						
        WHERE
               BASEITEM.BASEITEM_ID IN (?BaseItemId?) AND
               BASEITEM.MARKFORDELETE = 0
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get item version based on base item id
	@param BaseItemId The base item id
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ItemVersion[(BaseItemId=)]+IBM_Admin_ItemVersionDetails
	base_table=ITEMVERSN
	sql=
		SELECT 
				ITEMVERSN.$COLS:ITEMVERSN$
				
		FROM
				ITEMVERSN
						
        WHERE
               ITEMVERSN.BASEITEM_ID IN (?BaseItemId?)
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get base item based on part number
	@param PartNumber The part number
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/BaseItem[(PartNumber=)]+IBM_Admin_BaseItemDetails
	base_table=BASEITEM
	sql=
		SELECT 
				BASEITEM.$COLS:BASEITEM$
				
		FROM
				BASEITEM
						
        WHERE
               BASEITEM.PARTNUMBER IN (?PartNumber?) AND
               BASEITEM.MARKFORDELETE = 0
 END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get item specified based on part number
	@param PartNumber The part number
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ItemSpecified[(PartNumber=)]+IBM_Admin_ItemSpecifiedDetails
	base_table=ITEMSPC
	sql=
		SELECT 
				ITEMSPC.$COLS:ITEMSPC$
				
		FROM
				ITEMSPC
						
        WHERE
               ITEMSPC.PARTNUMBER IN (?PartNumber?) AND
               ITEMSPC.MARKFORDELETE = 0
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================= -->
<!-- ASSOCIATION QUERIES BEGINS -->

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Inventory Info                                       -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntryWithInventory
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$,
				CATENTRY.$COLS:CATENTRY:CATENTTYPE_ID$,
				CATENTRY.$COLS:CATENTRY:OPTCOUNTER$,
				INVENTORY.$COLS:INVENTORY$
				
		FROM
				CATENTRY
				        JOIN INVENTORY ON INVENTORY.CATENTRY_ID = CATENTRY.CATENTRY_ID				         
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$) 
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Item Info                                       -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntryWithBaseItem
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$, 
				CATENTRY.$COLS:CATENTRY:CATENTTYPE_ID$,
				CATENTRY.$COLS:CATENTRY:BASEITEM_ID$,
				CATENTRY.$COLS:CATENTRY:OPTCOUNTER$,
				BASEITEM.$COLS:BASEITEM$,
				BASEITMDSC.$COLS:BASEITMDSC$,
				STOREITEM.$COLS:STOREITEM$,
				ITEMVERSN.$COLS:ITEMVERSN$
		FROM
				CATENTRY
				        JOIN BASEITEM ON BASEITEM.BASEITEM_ID = CATENTRY.BASEITEM_ID 
				        JOIN STOREITEM ON STOREITEM.BASEITEM_ID = CATENTRY.BASEITEM_ID 
				             AND STOREITEM.STOREENT_ID IN ($STOREPATH:catalog$)
				        JOIN ITEMVERSN ON ITEMVERSN.BASEITEM_ID = CATENTRY.BASEITEM_ID 
				        LEFT OUTER JOIN BASEITMDSC ON BASEITEM.BASEITEM_ID = BASEITMDSC.BASEITEM_ID AND
				             BASEITMDSC.LANGUAGE_ID= $CTX:LANG_ID$
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Item Specified Info                                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntryWithItemSpc
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$, 
				CATENTRY.$COLS:CATENTRY:CATENTTYPE_ID$,
				CATENTRY.$COLS:CATENTRY:ITEMSPC_ID$,
				CATENTRY.$COLS:CATENTRY:OPTCOUNTER$,
				ITEMSPC.$COLS:ITEMSPC$,
				VERSIONSPC.$COLS:VERSIONSPC$
		FROM
				CATENTRY
				        JOIN ITEMSPC ON ITEMSPC.ITEMSPC_ID = CATENTRY.ITEMSPC_ID 
				        JOIN VERSIONSPC ON VERSIONSPC.ITEMSPC_ID = CATENTRY.ITEMSPC_ID 
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT



<!-- ========================================================================= -->
<!-- ASSOCIATION QUERIES ENDS -->



<!-- ========================================================================= -->
<!-- PROFILES DEFINITIONS BEGINS -->



BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryFulfillmentProperties_Update
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
      associated_sql_statement=IBM_RootCatalogEntryWithBaseItem
      associated_sql_statement=IBM_RootCatalogEntryWithItemSpc
      associated_sql_statement=IBM_RootCatalogEntryWithInventory
    END_ENTITY
END_PROFILE


<!-- PROFILES DEFINITIONS ENDS -->
<!-- ========================================================================= -->

<!-- ========================================================= -->
<!-- Access Profile Alias definition			       -->
<!-- ========================================================= -->

BEGIN_PROFILE_ALIASES
  base_table=BASEITMDSC
  IBM_BaseItemDescription=IBM_Admin_BaseItemDescription
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=STOREITEM
  IBM_StoreItemDetails=IBM_Admin_StoreItemDetails
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=INVENTORY
  IBM_InventoryDetails=IBM_Admin_InventoryDetails
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=VERSIONSPC
  IBM_VersionSpecifiedDetails=IBM_Admin_VersionSpecifiedDetails
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=BASEITEM
  IBM_BaseItemDetails=IBM_Admin_BaseItemDetails
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ITEMVERSN
  IBM_ItemVersionDetails=IBM_Admin_ItemVersionDetails
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ITEMSPC
  IBM_ItemSpecifiedDetails=IBM_Admin_ItemSpecifiedDetails
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATENTRY
  IBM_CatalogEntryFulfillmentProperties_Update=IBM_Admin_CatalogEntryFulfillmentProperties_Update
END_PROFILE_ALIASES




<!-- ========================================================================= -->
<!-- ================================== INVENTORY ENDS ===================== -->
<!-- ========================================================================= -->
