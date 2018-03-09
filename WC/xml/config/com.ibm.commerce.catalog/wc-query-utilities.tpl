BEGIN_SYMBOL_DEFINITIONS

	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	COLS:MEMBER_ID=CATENTRY:MEMBER_ID
	COLS:CATENTRY:PARTNUMBER=CATENTRY:PARTNUMBER
	COLS:CATENTRY:MEMBER_ID=CATENTRY:MEMBER_ID
	
	
	<!-- CATALOG table -->
	COLS:CATALOG=CATALOG:*
	COLS:CATALOG_ID=CATALOG:CATALOG_ID
	COLS:CATALOG:IDENTIFIER=CATALOG:IDENTIFIER
	
	<!-- CATGROUP table -->
	COLS:CATGROUP=CATGROUP:*
	COLS:CATGROUP_ID=CATGROUP:CATGROUP_ID
	COLS:CATGROUP:IDENTIFIER=CATGROUP:IDENTIFIER
	COLS:CATGROUP:MEMBER_ID=CATGROUP:MEMBER_ID
	
	
	
	<!-- STORECAT table -->
	COLS:STORECAT=STORECAT:*
	
	
	<!-- STORECGRP table -->
	COLS:STORECGRP=STORECGRP:*
	COLS:STORECGRP:STOREENT_ID=STORECGRP:STOREENT_ID
	COLS:STORECGRP:CATGROUP_ID=STORECGRP:CATGROUP_ID	
	
	<!-- STORECENT table -->
	COLS:STORECENT=STORECENT:*
	COLS:STORECENT:STOREENT_ID=STORECENT:STOREENT_ID
	COLS:STORECENT:CATENTRY_ID=STORECENT:CATENTRY_ID
	
	<!-- Other tables -->
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
	
    <!-- ATTR table -->
	COLS:ATTR=ATTR:*
    
    <!-- ATTRVAL table -->	
	COLS:ATTRVAL=ATTRVAL:*
    
    <!-- ATTRDESC table -->		
	COLS:ATTRDESC=ATTRDESC:*
    
    <!-- ATTRVALDESC table -->		
	COLS:ATTRVALDESC=ATTRVALDESC:*
	
    <!-- CATENTRYATTR table -->		
	COLS:CATENTRYATTR=CATENTRYATTR:*

	<!-- CATOVRGRP table -->
	COLS:CATOVRGRP=CATOVRGRP:*
		
		
	<!-- CATENTDESCOVR table -->
	<!-- COLS:CATENTDESCOVR=CATENTDESCOVR:CATENTDESCOVR_ID, NAME, SHORTDESCRIPTION, LONGDESCRIPTION, THUMBNAIL, FULLIMAGE, KEYWORD -->
	COLS:CATENTDESCOVR=CATENTDESCOVR:*
	
	<!-- EXTERNAL_CONTENT table -->
	COLS:EXTERNAL_CONTENT=EXTERNAL_CONTENT:*
		
	<!-- EXTERNAL_CONTENT_ASSET table -->
	COLS:EXTERNAL_CONTENT_ASSET=EXTERNAL_CONTENT_ASSET:*
	
  <!-- EXTERNAL_CONTENT_TYPE table -->
	COLS:EXTERNAL_CONTENT_TYPE=EXTERNAL_CONTENT_TYPE:*

  <!-- CATENTRY_EXTERNAL_CONTENT_REL table -->
  COLS:CATENTRY_EXTERNAL_CONTENT_REL=CATENTRY_EXTERNAL_CONTENT_REL:*

  COLS:CATGROUP_EXTERNAL_CONTENT_REL=CATGROUP_EXTERNAL_CONTENT_REL:*


		
END_SYMBOL_DEFINITIONS

<!-- ====================================================================== 
	Select child catalog entries based on the product catentry ID
	@param catalogEntryId The parent catalog entry id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ChildCatalogEntry
	base_table=CATENTREL
	sql=
		SELECT CATENTREL.CATENTRY_ID_CHILD FROM CATENTREL WHERE CATENTREL.CATENTRY_ID_PARENT=?catalogEntryId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select child catalog entries based on the product catentry ID
	and not marked for delete
	@param catalogEntryId The parent catalog entry id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_Active_ChildCatalogEntry
	base_table=CATENTREL
	sql=
		SELECT CATENTREL.CATENTRY_ID_CHILD FROM CATENTREL, CATENTRY WHERE CATENTREL.CATENTRY_ID_PARENT=?catalogEntryId?
			AND CATENTRY.CATENTRY_ID=CATENTREL.CATENTRY_ID_CHILD AND CATENTRY.MARKFORDELETE=0
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select catalog entry ID by part number and store path.
	@param partNumberList The part numbers 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogEntry_By_PartNumber
	base_table=CATENTRY
	sql=
			SELECT CATENTRY.CATENTRY_ID 
			FROM 
			CATENTRY LEFT OUTER JOIN STORECENT
			ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID) 
		WHERE
			CATENTRY.PARTNUMBER IN (?partNumberList?) AND  		
			CATENTRY.MARKFORDELETE = 0 AND
			STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ )
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select catalog entry ID by part number and member(owner) id.
	@param partNumberList the part number
	@param memberId the member ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogEntry_By_PartNumber_And_Owner
	base_table=CATENTRY
	sql=
			SELECT CATENTRY.CATENTRY_ID 
			FROM 
			CATENTRY
		WHERE
			CATENTRY.PARTNUMBER IN (?partNumberList?) AND MEMBER_ID =?memberId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete catalog entries and the children (set markfordelete and update partnumber)
	@param catalogEntryIdList A list of catalog entry IDs
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_CatalogEntry
	base_table=CATENTRY
	dbtype=oracle	
	sql=
			UPDATE 
						CATENTRY
	     	SET 
	     				CATENTRY.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(CATENTRY.PARTNUMBER||'-'||SYSTIMESTAMP)<=64 
	     				THEN 
	     					CATENTRY.PARTNUMBER||'-'||SYSTIMESTAMP  
	     				ELSE 
	     					SUBSTR(CATENTRY.PARTNUMBER,1,64-LENGTH(''||SYSTIMESTAMP)-1)||'-'||SYSTIMESTAMP END
	     				,CATENTRY.MARKFORDELETE=1
	     	WHERE
						CATENTRY.CATENTRY_ID IN (?catalogEntryIdList?)
	dbtype=db2
	sql=
			UPDATE 
						CATENTRY
	     	SET 
	     				CATENTRY.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(CATENTRY.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=64 
	     				THEN 
	     					CATENTRY.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)
	     				ELSE 
	     					SUBSTR(CATENTRY.PARTNUMBER,1,64-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,CATENTRY.MARKFORDELETE=1
	     	WHERE
						CATENTRY.CATENTRY_ID IN (?catalogEntryIdList?)

	sql=
			UPDATE 
						CATENTRY
	     	SET 
	     				CATENTRY.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(CATENTRY.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=64 
	     				THEN 
	     					CATENTRY.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)  
	     				ELSE 
	     					SUBSTR(CATENTRY.PARTNUMBER,1,64-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,CATENTRY.MARKFORDELETE=1
	     	WHERE
						CATENTRY.CATENTRY_ID IN (?catalogEntryIdList?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select item specification by a list of catalog entry IDs
	@param catalogEntryIdList A list of catalog entry IDs
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ItemSpecification_By_CatalogEntryIdList
	base_table=CATENTRY
	sql = 
	SELECT CATENTRY.ITEMSPC_ID FROM CATENTRY 
	WHERE CATENTRY.CATENTRY_ID IN (?catalogEntryIdList?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete item specification (set markfordelete and update partnumber)
	@param itemspcIdList A list of item specification IDs 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_ItemSpecification
	base_table=ITEMSPC
	dbtype=oracle	
	sql=
			UPDATE 
						ITEMSPC
	     	SET 
	     				ITEMSPC.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(ITEMSPC.PARTNUMBER||'-'||SYSTIMESTAMP)<=64 
	     				THEN 
	     					ITEMSPC.PARTNUMBER||'-'||SYSTIMESTAMP  
	     				ELSE 
	     					SUBSTR(ITEMSPC.PARTNUMBER,1,64-LENGTH(''||SYSTIMESTAMP)-1)||'-'||SYSTIMESTAMP END
	     				,ITEMSPC.MARKFORDELETE=1
	     	WHERE
						ITEMSPC.ITEMSPC_ID IN (?itemspcIdList?)
	dbtype=db2
	sql=
			UPDATE 
						ITEMSPC
	     	SET 
	     				ITEMSPC.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(ITEMSPC.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=64 
	     				THEN 
	     					ITEMSPC.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)
	     				ELSE 
	     					SUBSTR(ITEMSPC.PARTNUMBER,1,64-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,ITEMSPC.MARKFORDELETE=1
	     	WHERE
						ITEMSPC.ITEMSPC_ID IN (?itemspcIdList?)

	sql=
			UPDATE 
						ITEMSPC
	     	SET 
	     				ITEMSPC.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(ITEMSPC.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=64 
	     				THEN 
	     					ITEMSPC.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)  
	     				ELSE 
	     					SUBSTR(ITEMSPC.PARTNUMBER,1,64-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,ITEMSPC.MARKFORDELETE=1
	     	WHERE
						ITEMSPC.ITEMSPC_ID IN (?itemspcIdList?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select base item by a list of catalog entry IDs
	@param catalogEntryIdList A list of catalog entry IDs
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_BaseItem_By_CatalogEntryIdList
	base_table=CATENTRY
	sql = 
	SELECT CATENTRY.BASEITEM_ID FROM CATENTRY 
	WHERE CATENTRY.CATENTRY_ID IN (?catalogEntryIdList?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete base item (set markfordelete and update partnumber)
	@param baseItemIdList A list of base item IDs
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_BaseItem
	base_table=BASEITEM
	dbtype=oracle	
	sql=
			UPDATE 
						BASEITEM
	     	SET 
	     				BASEITEM.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(BASEITEM.PARTNUMBER||'-'||SYSTIMESTAMP)<=72 
	     				THEN 
	     					BASEITEM.PARTNUMBER||'-'||SYSTIMESTAMP  
	     				ELSE 
	     					SUBSTR(BASEITEM.PARTNUMBER,1,72-LENGTH(''||SYSTIMESTAMP)-1)||'-'||SYSTIMESTAMP END
	     				,BASEITEM.MARKFORDELETE=1
	     	WHERE
						BASEITEM.BASEITEM_ID IN (?baseItemIdList?)
	dbtype=db2
	sql=
			UPDATE 
						BASEITEM
	     	SET 
	     				BASEITEM.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(BASEITEM.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=72 
	     				THEN 
	     					BASEITEM.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)
	     				ELSE 
	     					SUBSTR(BASEITEM.PARTNUMBER,1,72-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,BASEITEM.MARKFORDELETE=1
	     	WHERE
						BASEITEM.BASEITEM_ID IN (?baseItemIdList?)

	sql=
			UPDATE 
						BASEITEM
	     	SET 
	     				BASEITEM.PARTNUMBER=
	     				CASE WHEN 
	     					LENGTH(BASEITEM.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP))<=72 
	     				THEN 
	     					BASEITEM.PARTNUMBER||'-'||CHAR(CURRENT TIMESTAMP)  
	     				ELSE 
	     					SUBSTR(BASEITEM.PARTNUMBER,1,72-LENGTH(''||CHAR(CURRENT TIMESTAMP))-1)||'-'||CHAR(CURRENT TIMESTAMP) END
	     				,BASEITEM.MARKFORDELETE=1
	     	WHERE
						BASEITEM.BASEITEM_ID IN (?baseItemIdList?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Update the LASTUPDATE timestamp of the catalog entry
	@param catalogEntryId The catalog entry id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_CatalogEntry_UpdateLastUpdateTimeStamp
	base_table=CATENTRY
	dbtype=oracle
	sql=
			UPDATE 
						CATENTRY
	     	SET 
	     				CATENTRY.LASTUPDATE=SYSTIMESTAMP
	     				
	     	WHERE
						CATENTRY.CATENTRY_ID=?catalogEntryId?
	sql=
			UPDATE 
						CATENTRY
	     	SET 
	     				CATENTRY.LASTUPDATE=CURRENT TIMESTAMP

	     	WHERE
						CATENTRY.CATENTRY_ID=?catalogEntryId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Update the LASTUPDATE timestamp of the catalog group
	@param catalogGroupId The catalog group id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_CatalogGroup_UpdateLastUpdateTimeStamp
	base_table=CATGROUP
	dbtype=oracle
	sql=
			UPDATE 
						CATGROUP
	     	SET 
	     				CATGROUP.LASTUPDATE=SYSTIMESTAMP
	     				
	     	WHERE
						CATGROUP.CATGROUP_ID=?catalogGroupId?
	sql=
			UPDATE 
						CATGROUP
	     	SET 
	     				CATGROUP.LASTUPDATE=CURRENT TIMESTAMP

	     	WHERE
						CATGROUP.CATGROUP_ID=?catalogGroupId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Add a new product set catalog entry relation
	@param productSetId The product set id
	@param catalogEntryId The catalog entry id
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_SyncProductSet_AddNewProductSetCatalogEntryRelation_Update
	base_table=PRSETCEREL
	sql=
		INSERT INTO 
	     		PRSETCEREL
	     				(PRODUCTSET_ID, CATENTRY_ID)
	     	VALUES
					( ?productSetId? , ?catalogEntryId?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete existing catalog entry product set relation
	@param productSetId The product set id
	@param catalogEntryId The catalog entry id
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_SyncProductSet_DeleteExistingProductSetCatalogEntryRelation_Update
	base_table=PRSETCEREL
	sql=
		DELETE 
			FROM  PRSETCEREL
		WHERE
		PRSETCEREL.PRODUCTSET_ID=?productSetId? AND PRSETCEREL.CATENTRY_ID=?catalogEntryId?  
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete the existing catalog entry category relation for reparenting the catalog entry
	@param catalogEntryId The catalog entry id 
	@param categoryId The catalog group id 
	@param catalogId The catalog id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_ReparentCatalogEntry_DeleteExistingCategoryRelation
	base_table=CATGPENREL
	sql=
			DELETE 
	     	FROM
	     				CATGPENREL
	     	WHERE
						CATGPENREL.CATENTRY_ID=?catalogEntryId? AND
						CATGPENREL.CATGROUP_ID = ?categoryId? AND
						 CATGPENREL.CATALOG_ID= ?catalogId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete the existing catalog entry category relation for reparenting the catalog entry
	@param catalogEntryId The catalog entry id 
	@param catalogGroupId The catalog group id 
	@param catalogId The catalog id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_ReparentCatalogEntry_DeleteExistingCategoryRelationWithCatgroup
	base_table=CATGPENREL
	sql=
			DELETE 
	     	FROM
	     				CATGPENREL
	     	WHERE
						CATGPENREL.CATENTRY_ID=?catalogEntryId? AND CATGPENREL.CATALOG_ID=?catalogId? AND CATGPENREL.CATGROUP_ID =?catalogGroupId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Add new catalog entry category relation for reparenting the catalog entry
	@param catalogEntryId The catalog entry id 
	@param catalogGroupId The catalog group id 
	@param catalogId The catalog id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_ReparentCatalogEntry_AddNewCategoryRelation
	base_table=CATGPENREL
	dbtype=oracle
	sql=
			INSERT INTO 
	     				CATGPENREL
	     				(CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	     	VALUES
						( ?catalogGroupId? , ?catalogId? , ?catalogEntryId? , 0, SYSTIMESTAMP)

	dbtype=db2
	sql=
			INSERT INTO 
	     				CATGPENREL
	     				(CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	     	VALUES
						( ?catalogGroupId? , ?catalogId? , ?catalogEntryId? , 0, current timestamp)

	sql=
			INSERT INTO 
	     				CATGPENREL
	     				(CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	     	VALUES
						( ?catalogGroupId? , ?catalogId? , ?catalogEntryId? , 0, current timestamp)
END_SQL_STATEMENT


<!-- ====================================================================== 
  Executed during unlink.
	Select child catalog entries based on the catalog group id and the source catalog id
	This query is used to find the catalog group to catalog entry relationships to be deleted which were created by a previous link operation.
	@param catGroupId The catalog group id 
	@param sourceCatalogId The catalog id for the source relations 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ChildCatalogEntry_For_Unlink
	base_table=CATGPENREL
	sql=
		SELECT CATGPENREL.CATENTRY_ID from CATGPENREL where CATGPENREL.CATGROUP_ID=?catGroupId? and CATGPENREL.CATALOG_ID=?sourceCatalogId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete the existing catalog group catentry relation for the catalog group.
	@param categoryId The catalog group id 
	@param catalogId The catalog id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_CatalogGroup_ExistingCatentryRelation
	base_table=CATGPENREL
	sql=
			DELETE 
	     	FROM
	     				CATGPENREL
	     	WHERE
						CATGPENREL.CATGROUP_ID = ?categoryId? AND
						CATGPENREL.CATALOG_ID= ?catalogId?
END_SQL_STATEMENT



<!-- ================================================================================================= 
	Executed during unlink. Use to delete catalog group to catalog entry relations that were created by a previous link operation.
	@param catGroupId The catalog group id 
	@param catalogId The catalog id for the new relations	
	@param catalogEntryIdList A list of catalog entry IDs whose relationships need to be deleted 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveCatalogGroupToCatalogEntryLinkRelations
	base_table=CATGPENREL
	sql=
	DELETE FROM CATGPENREL WHERE CATGROUP_ID=?catGroupId? and CATALOG_ID=?catalogId? AND CATENTRY_ID IN (?catalogEntryIdList?)

END_SQL_STATEMENT


<!-- ================================================================================================= 
	Executed during unlink. Use to delete catalog group to catalog entry relations that were created by a previous link operation in one step.
	It combines IBM_Select_ChildCatalogEntry_For_Unlink and IBM_Delete_RemoveCatalogGroupToCatalogEntryLinkRelations. 
	@param catGroupId The catalog group id 
	@param linkCatalogIds The list of linked catalog ids	
	@param sourceCatalogId The catalog id for the source relations 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveAllCatalogGroupToCatalogEntryLinkRelations
	base_table=CATGPENREL
	sql=
	DELETE FROM CATGPENREL WHERE CATGROUP_ID=?catGroupId? and CATALOG_ID IN (?linkCatalogIds?) 
		AND 
		CATENTRY_ID IN 
		(SELECT CATGPENREL.CATENTRY_ID from CATGPENREL where CATGPENREL.CATGROUP_ID=?catGroupId? and CATGPENREL.CATALOG_ID=?sourceCatalogId?)
		
END_SQL_STATEMENT

<!-- ================================================================================================= 
	Executed during unlink in workspace. Use to delete catalog group to catalog entry relations that were created by a previous link operation in one step.
	@param catGroupId The catalog group id 
	@param linkCatalogIds The list of linked catalog ids	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveAllCatalogGroupToCatalogEntryLinkRelationsInWorkspace
	base_table=CATGPENREL
	sql=
	DELETE FROM CATGPENREL WHERE CATGROUP_ID=?catGroupId? and CATALOG_ID IN (?linkCatalogIds?) 

END_SQL_STATEMENT

<!-- ====================================================================== 
	Add new catalog group to catalog entry relations for link creation.
	@param catGroupId The catalog group id 
	@param catalogId The catalog id for the new relations	
	@param sourceCatalogId The catalog id for the source relations 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_CreateCatalogGroupToCatalogEntryLinkRelations
	base_table=CATGPENREL
	dbtype=oracle
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, RULE, SEQUENCE, LASTUPDATE)
	select t1.catgroup_id, TO_NUMBER(?catalogId?), t1.catentry_id, t1.rule, t1.sequence, SYSTIMESTAMP
	from catgpenrel t1
	where catgroup_id in (?catGroupId?) and catalog_id=?sourceCatalogId? and
	not exists(select 1 
	   from catgpenrel t2
	   where t2.catgroup_id=t1.catgroup_id and t2.catalog_id=?catalogId? and t2.catentry_id=t1.catentry_id)
	   
	dbtype=db2
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, RULE, SEQUENCE, LASTUPDATE)
	select t1.catgroup_id, CAST(?catalogId? as BIGINT), t1.catentry_id, t1.rule, t1.sequence, current timestamp
	from catgpenrel t1
	where catgroup_id in (?catGroupId?) and catalog_id=?sourceCatalogId?
	except 
		select t2.catgroup_id, CAST(?catalogId? as BIGINT), t2.catentry_id, t2.rule, t2.sequence, current timestamp 
		from catgpenrel t2 
		where t2.catgroup_id in (?catGroupId?) and t2.catalog_id=?catalogId? 
		
	dbtype=derby
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, RULE, SEQUENCE, LASTUPDATE)
	select t1.catgroup_id, ?catalogId?, t1.catentry_id, t1.rule, t1.sequence, current timestamp
	from catgpenrel t1
	where catgroup_id in (?catGroupId?) and catalog_id=?sourceCatalogId? and
	not exists(select 1 
	   from catgpenrel t2
	   where t2.catgroup_id=t1.catgroup_id and t2.catalog_id=?catalogId? and t2.catentry_id=t1.catentry_id)
	     
	dbtype=any
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, RULE, SEQUENCE, LASTUPDATE)
	select t1.catgroup_id, CAST(?catalogId? as BIGINT), t1.catentry_id, t1.rule, t1.sequence, current timestamp
	from catgpenrel t1
	where catgroup_id in (?catGroupId?) and catalog_id=?sourceCatalogId?
	except 
		select t2.catgroup_id, CAST(?catalogId? as BIGINT), t2.catentry_id, t2.rule, t2.sequence, current timestamp 
		from catgpenrel t2 
		where t2.catgroup_id in (?catGroupId?) and t2.catalog_id=?catalogId? 
	        
END_SQL_STATEMENT

<!-- =============================================================================== 
	Create a new catalog group to catalog entry relations.
	@param catGroupId The catalog group id	
	@param catalogId The catalog id for the new relations
	@param catEntryId The catalog entry id 	
	@param sequence The display sequence number	
==================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_CreateCatalogGroupToCatalogEntryRelation
	base_table=CATGPENREL
	dbtype=oracle
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE) VALUES
					( ?catGroupId? , ?catalogId?, ?catEntryId?, ?sequence?, SYSTIMESTAMP)
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE) VALUES
					( ?catGroupId? , ?catalogId?, ?catEntryId?, ?sequence?, current timestamp)				
	        
END_SQL_STATEMENT
<!-- =============================================================================== 
	Add new catalog group to catalog entry relations for SKUs of a product.
	@param catGroupId The catalog group id
	@param catEntryId The product id 
	@param catalogId The catalog id for the new relations	
	
==================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_CreateCatalogGroupToCatalogEntryRelationsForSKUs	      
	base_table=CATGPENREL
	dbtype=oracle
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	select TO_NUMBER(?catGroupId?), TO_NUMBER(?catalogId?), t1.catentry_id_child, t1.sequence, SYSTIMESTAMP
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='PRODUCT_ITEM'
	   
	dbtype=db2
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	select CAST(?catGroupId? as BIGINT), CAST(?catalogId? as BIGINT), t1.catentry_id_child, t1.sequence, current timestamp
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='PRODUCT_ITEM'
	  
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	select CAST(?catGroupId? as BIGINT), CAST(?catalogId? as BIGINT), t1.catentry_id_child, t1.sequence, current timestamp
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='PRODUCT_ITEM'   
	        
END_SQL_STATEMENT
<!-- =============================================================================== 
	Add new catalog group to catalog entry relations for PDKs of a product.
	@param catGroupId The catalog group id
	@param catEntryId The product id 
	@param catalogId The catalog id for the new relations	
	
==================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_CreateCatalogGroupToCatalogEntryRelationsForPDKs	      
	base_table=CATGPENREL
	dbtype=oracle
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	select TO_NUMBER(?catGroupId?), TO_NUMBER(?catalogId?), t1.catentry_id_child, t1.sequence, SYSTIMESTAMP
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='DK_PDK'
	   
	dbtype=db2
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	select CAST(?catGroupId? as BIGINT), CAST(?catalogId? as BIGINT), t1.catentry_id_child, t1.sequence, current timestamp
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='DK_PDK'
	  
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, SEQUENCE, LASTUPDATE)
	select CAST(?catGroupId? as BIGINT), CAST(?catalogId? as BIGINT), t1.catentry_id_child, t1.sequence, current timestamp
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='DK_PDK'   
	        
END_SQL_STATEMENT
<!-- ================================================================================================= 
	Execute during catalog entry reparent. Use to delete old catalog group to catalog entry relations
	to a product and SKUs of a product and PDKs of a DK.
	@param catGroupId The catalog group id 
	@param catalogId The catalog id for the new relations	
	@param catEntryId The catalog entry Id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveCatalogGroupToCatalogEntryRelationsForProductAndSKUs
	base_table=CATGPENREL
	sql=
	DELETE FROM CATGPENREL WHERE CATGROUP_ID=?catGroupId? and CATALOG_ID=?catalogId? AND 
	(CATENTRY_ID IN (SELECT CATENTREL.CATENTRY_ID_CHILD from CATENTREL where CATENTREL.CATENTRY_ID_PARENT=?catEntryId? and (CATRELTYPE_ID='PRODUCT_ITEM' OR CATRELTYPE_ID='DK_PDK')) 
	OR CATENTRY_ID=?catEntryId?)
	
	<!-- The following SQL applies to workspaces -->
    cm
    sql=
	DELETE FROM CATGPENREL WHERE CATGROUP_ID=?catGroupId? and CATALOG_ID=?catalogId? AND 
	(CATENTRY_ID IN (SELECT A.CATENTRY_ID_CHILD from $CM:READ$.CATENTREL A where A.CATENTRY_ID_PARENT=?catEntryId? and A.CATRELTYPE_ID='PRODUCT_ITEM') 
	OR CATENTRY_ID=?catEntryId?)
	
END_SQL_STATEMENT
<!-- ================================================================================================= 
	Execute during catalog entry reparent. Use to delete old catalog group to catalog entry relations
	to a product and SKUs of a product and PDKs of a DK.
	@param catGroupId The catalog group id 
	@param catalogId The catalog id for the new relations	
	@param catEntryId The catalog entry Id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveCatalogGroupToCatalogEntryRelationsForProductAndSKUsList
	base_table=CATGPENREL
	sql=
	DELETE FROM CATGPENREL WHERE CATGROUP_ID = ?catGroupId? AND CATALOG_ID IN (?catalogId?)	AND 
	CATENTRY_ID IN (SELECT CATENTRY_ID FROM CATENTRY WHERE CATENTRY_ID IN (?catEntryId?)
		UNION ALL SELECT CATENTREL.CATENTRY_ID_CHILD FROM CATENTREL WHERE CATENTREL.CATENTRY_ID_PARENT IN ( ?catEntryId? ) AND CATRELTYPE_ID IN ('PRODUCT_ITEM', 'DK_PDK'))
	
	<!-- The following SQL applies to workspaces -->
    cm
    sql=
	DELETE FROM CATGPENREL WHERE CATGROUP_ID = ?catGroupId? AND CATALOG_ID IN (?catalogId?) AND 
	CATENTRY_ID IN (SELECT CATENTRY_ID FROM CATENTRY WHERE CATENTRY_ID IN (?catEntryId?)
		UNION ALL SELECT A.CATENTRY_ID_CHILD FROM $CM:READ$.CATENTREL A WHERE A.CATENTRY_ID_PARENT IN ( ?catEntryId? )	AND A.CATRELTYPE_ID IN ('PRODUCT_ITEM', 'DK_PDK'))
	
END_SQL_STATEMENT
<!-- ================================================================================================= 
	Execute during catalog entry delete. Use to delete all catalog group to catalog entry relations
	to a product and SKUs of a product.
	@param catalogEntryIdList The list of child catalog entry IDs 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveAllCatalogGroupToCatalogEntryRelationsForProductAndSKUs
	base_table=CATGPENREL

	sql=
	DELETE FROM CATGPENREL 
	WHERE CATENTRY_ID IN (?catalogEntryIdList?)
			

END_SQL_STATEMENT

<!-- ============================================================================== 
	Get the identifier of a catalog according to its unique id.
	@param catalogId The unique id of the catalog group. 
=================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_CatalogIdentifier
	base_table=CATALOG
	sql=	
		SELECT 
			CATALOG.$COLS:CATALOG:IDENTIFIER$
		FROM 
			CATALOG
		WHERE 
			CATALOG.CATALOG_ID IN (?catalogId?)
END_SQL_STATEMENT


<!-- ============================================================================== 
	Get the catalog group relationship according to catalog id, parent group id and 
	child group id.
	@param catalogId The unique id of the catalog.
	@param parentCatalogGroupID The unique id of the parent group in the relationship
	@param childCatalogGroupID The unique id of the child group in the relationship
=================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_CatalogGroupRelationship
	base_table=CATGRPREL
	sql=	
		SELECT 
			CATGRPREL.$COLS:CATGRPREL$
		FROM 
			CATGRPREL
		WHERE 
			CATGRPREL.CATALOG_ID IN (?catalogId?) AND
			CATGRPREL.CATGROUP_ID_PARENT IN (?parentCatalogGroupID?) AND
			CATGRPREL.CATGROUP_ID_CHILD IN (?childCatalogGroupID?)
END_SQL_STATEMENT

<!-- ============================================================================== 
	Get the owning store id of a catalog according to its unique id.
	@param catalogId The unique id of the catalog. 
=================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_CatalogStoreID
	base_table=STORECAT
	sql=	
		SELECT 
			STORECAT.$COLS:STORECAT$
		FROM 
			STORECAT
		WHERE 
			STORECAT.CATALOG_ID IN (?catalogId?)
END_SQL_STATEMENT
			

<!-- ========================================================= -->
<!-- =====Get name of supported merchandising association===== -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/MASSOCTYPE+IBM_Admin_SupportedMerchandisingAssociationName
	base_table=MASSOCTYPE
	sql=
		SELECT
			MASSOCTYPE.$COLS:MASSOCTYPE$
		FROM  MASSOCTYPE
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================= -->
<!-- =====Get supported semantic specifiers for association=== -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/MASSOC+IBM_Admin_SupportedSemanticSpecifiers
	base_table=MASSOC
	sql=
		SELECT
			MASSOC.$COLS:MASSOC$
		FROM  MASSOC
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will delete the Catalog Group to Catalog relation for the given Catalog Group Id     -->
<!-- and Catalog Id.                                                                               -->
<!-- @param catalogGroupID Id of catalog group.                                                    -->
<!-- @param catalogID  The catalog id for which relation has to be deleted.                        --> 
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_TopCatGroupRelation
	base_table=CATTOGRP
	sql=
		DELETE 
	     	FROM
	     				CATTOGRP
	     	WHERE
						CATTOGRP.CATGROUP_ID IN (?catalogGroupID?) AND CATTOGRP.CATALOG_ID = ?catalogID?
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will update the sequence of a Catalog Group to Catalog relation for the given        -->
<!-- Catalog Group Id and Catalog Id.                                                              -->
<!-- @param catalogGroupID Id of catalog group.                                                    -->
<!-- @param catalogID  The catalog id for which relation has to be updated.                        --> 
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_TopCatGroupSequence
	base_table=CATTOGRP
	sql=
			UPDATE 
	     			CATTOGRP
	     	SET 	CATTOGRP.SEQUENCE = ?sequence?		
	     	WHERE
					CATTOGRP.CATGROUP_ID IN (?catalogGroupID?) AND CATTOGRP.CATALOG_ID = ?catalogID?
					
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will update the short description of a Catalog entry in the BaseItem table.          -->
<!-- for the given BaseItem Id and language Id.                                                    -->
<!-- @param baseItemID Id of catalog entry.                                                        -->
<!-- @param languageId of catalog entry description.                                               -->
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_BaseItemShortDescription
	base_table=BASEITMDSC
	sql=
			UPDATE 
	     			BASEITMDSC
	     	SET 	
	     			BASEITMDSC.SHORTDESCRIPTION = ?shortDescription?		
	     	WHERE
					BASEITMDSC.BASEITEM_ID = ?baseItemID? and BASEITMDSC.LANGUAGE_ID = ?languageId?					
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will update the long description of a Catalog entry in the BaseItem table.           -->
<!-- for the given BaseItem Id and language Id.                                                    -->
<!-- @param baseItemID Id of catalog entry.                                                        -->
<!-- @param languageId of catalog entry description.                                               -->
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_BaseItemLongDescription
	base_table=BASEITMDSC
	sql=
			UPDATE 
	     			BASEITMDSC
	     	SET 	
	     			BASEITMDSC.LONGDESCRIPTION = ?longDescription?		
	     	WHERE
					BASEITMDSC.BASEITEM_ID = ?baseItemID? and BASEITMDSC.LANGUAGE_ID = ?languageId?					
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will update the partnumber of a Catalog entry in the BaseItem table for the given    -->
<!-- BaseItem Id.                                                                                  -->
<!-- @param baseItemID Id of catalog entry.                                                        -->
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_BaseItemPartNumber
	base_table=BASEITEM
	sql=
			UPDATE 
	     			BASEITEM
	     	SET 	BASEITEM.PARTNUMBER = ?partnumber?		
	     	WHERE
					BASEITEM.BASEITEM_ID = ?baseItemID?
					
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will synchronize the sequence of Catalog Groups to Catalog Group relation for the    -->
<!-- given Catalog Group Id and Catalog Links to Catalog Id.                                       -->
<!-- @param sequence Sequence of child catalog group.                                              -->
<!-- @param childCatGroupId Id of child catalog group.                                             -->
<!-- @param catalogGroupID Id of parent catalog group.                                             -->
<!-- @param catalogID  The catalog id link for which relation has to be updated.                   --> 
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_LinkedCatGroupSequence
	base_table=CATGRPREL
	sql=
			UPDATE 
	     			CATGRPREL
	     	SET 	CATGRPREL.SEQUENCE = ?sequence?		
	     	WHERE
			CATGRPREL.CATGROUP_ID_CHILD IN (?childCatGroupId?) AND
			CATGRPREL.CATGROUP_ID_PARENT IN (?catalogGroupID?) AND
			CATGRPREL.CATALOG_ID_LINK = ?catalogID?
					
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will synchronize the sequence of Catalog Entries to Catalog Group relation for the   -->
<!-- given Catalog Group Id and Catalog Links Catalog Id.                                          -->
<!-- @param sequence Sequence of child catalog entry.                                              -->
<!-- @param catalogEntryId Id of child catalog entry.                                              -->
<!-- @param catalogGroupID Id of parent catalog group.                                             -->
<!-- @param catalogID  The catalog id link for which relation has to be updated.                   --> 
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_LinkedCatEntrySequence
	base_table=CATGPENREL
	sql=
	
			UPDATE CATGPENREL SET CATGPENREL.SEQUENCE = ?sequence? 
			WHERE 
					CATGPENREL.CATENTRY_ID = ?catalogEntryId? AND 
					CATGPENREL.CATGROUP_ID = ?catalogGroupID? AND 
					CATGPENREL.CATALOG_ID <> ?catalogID?	
					
END_SQL_STATEMENT


BEGIN_SQL_STATEMENT
	<!-- ============================================================================================= -->
	<!-- Delete all links from a parent catalog group to a child catalog group in a catalog.           -->
	<!-- This SQL will delete from catgrprel where catgroup_id_parent in @parentCatGroupId and         -->       
	<!-- catgroup_id_child in @catGroupId and catalog_id in @catalogId and catalog_id_link is not null --> 
	<!-- @param catGroupId One or more catalog group ids                                               -->
	<!-- @param catalogId  One or more catalog ids                                                     -->
	<!-- @param parentCatGroupId Parent catalog group id                                               -->
	<!-- ============================================================================================= -->
	name=IBM_Delete_LinkFromParentCatalogGroup
	base_table=CATGRPREL
	sql=		                            
             	DELETE FROM CATGRPREL
 				WHERE				
 				CATGRPREL.CATGROUP_ID_PARENT in (?parentCatGroupId?) AND		
				CATGRPREL.CATGROUP_ID_CHILD in (?catGroupId?) AND
				CATGRPREL.CATALOG_ID IN (?catalogId?) AND
				CATGRPREL.CATALOG_ID_LINK IS NOT NULL

END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	<!-- ============================================================================================= -->
	<!-- Delete all links from the root of a catalog to one or more catalog groups.                    -->
	<!-- This SQL will delete from cattogrp where catgroup_id in @catGroupId and                       -->       
	<!-- catalog_id in @catalogId and catalog_id_link is not null                                      --> 
	<!-- @param catGroupId One or more catalog group ids                                               -->
	<!-- @param catalogId  One or more catalog ids                                                     -->
	<!-- ============================================================================================= -->
	name=IBM_Delete_LinkFromCatalogRoot
	base_table=CATTOGRP
	sql=		                            
             	DELETE FROM CATTOGRP
 				WHERE						
				CATTOGRP.CATGROUP_ID IN (?catGroupId?) AND
				CATTOGRP.CATALOG_ID IN (?catalogId?) AND
				CATTOGRP.CATALOG_ID_LINK IS NOT NULL

END_SQL_STATEMENT	 


BEGIN_SQL_STATEMENT
	<!-- ============================================================================================= -->
	<!-- Delete links from any catalog root to one or more catalog groups.                             -->
	<!-- This SQL will delete from cattogrp where catgroup_id in @catGroupId and                       -->       
	<!-- catalog_id_link in @catalogIdLink                                                             --> 
	<!-- @param catGroupId One or more catalog group ids                                               -->
	<!-- @param catalogIdLink The source catalog of the link                                           -->
	<!-- ============================================================================================= -->
	name=IBM_Delete_LinksFromAnyCatalogRoot
	base_table=CATTOGRP
	sql=		                            
             	DELETE FROM CATTOGRP
 				WHERE						
				CATTOGRP.CATGROUP_ID IN (?catGroupId?) AND
				CATTOGRP.CATALOG_ID_LINK IN (?catalogIdLink?)

END_SQL_STATEMENT	

BEGIN_SQL_STATEMENT	
	<!-- ============================================================================================= -->
	<!-- Delete links from any parent catalog groups to a catalog group.                               -->
	<!-- This SQL will delete from catgrprel where catgroup_id_child in @catGroupId and                -->       
	<!-- catalog_id_link in @catalogIdLink                                                             --> 
	<!-- @param catGroupId One or more catalog group ids                                               -->
	<!-- @param catalogIdLink The source catalog of the link                                           -->
	<!-- ============================================================================================= -->
	name=IBM_Delete_LinksFromAnyParentCatalogGroup
	base_table=CATGRPREL
	sql=		                            
             	DELETE FROM CATGRPREL
 				WHERE 				
				CATGRPREL.CATGROUP_ID_CHILD IN (?catGroupId?) AND
				CATGRPREL.CATALOG_ID_LINK IN (?catalogIdLink?)

END_SQL_STATEMENT

BEGIN_SQL_STATEMENT	
	<!-- ============================================================================================= -->
	<!-- Delete all relations from any parent catalog group to a catalog entry.                        -->
	<!-- This SQL will delete from catgpenrel where catentry_id in @catEntryId                         -->       
	<!-- @param catEntryId One or more catalog group ids                                               -->
	<!-- ============================================================================================= -->
	name=IBM_Delete_ParentCatalogGroupToCatalogEntryRelation
	base_table=CATGRPREL
	sql=		                            
             	DELETE FROM CATGPENREL
 				WHERE 				
				CATGPENREL.CATENTRY_ID in (?catEntryId?) 

END_SQL_STATEMENT

<!-- ================================================================================================ -->
<!-- Given a list of catalog entry ids, filter out the ones mark for delete or not in the store path
<!-- @param catEntryId The list of catalog entry ids.
<!-- ================================================================================================ -->

BEGIN_SQL_STATEMENT
	name=IBM_Get_FilteredCatalogEntryIDs
	base_table=CATENTRY
	sql=
	SELECT 
		CATENTRY.CATENTRY_ID 
	FROM 
		CATENTRY LEFT OUTER JOIN STORECENT
		ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID) 

		WHERE
			CATENTRY.CATENTRY_ID IN (?catEntryId?) AND  		
			(CATENTRY.MARKFORDELETE = 1 OR
			STORECENT.STOREENT_ID NOT IN ( $STOREPATH:catalog$ ) OR STORECENT.STOREENT_ID IS NULL)
END_SQL_STATEMENT

<!-- ============================================================================== 
	Get the parent product id according to catalog entry id.
	@param UniqueID The unique id of the catalog entry.
=================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_ParentCatalogEntry
	base_table=CATENTREL
	sql=	
		SELECT 
			CATENTREL.CATENTRY_ID_PARENT
		FROM 
			CATENTREL
		WHERE 
			CATENTREL.CATENTRY_ID_CHILD = ?UniqueID? AND CATRELTYPE_ID = 'PRODUCT_ITEM'
END_SQL_STATEMENT

<!-- ============================================================================== 
	Get the catalog entries according to catalog entry ids.
	@param UniqueID The unique ids of the catalog entries.
=================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_CatalogEntry
	base_table=CATENTRY
	sql=	
		SELECT 
			CATENTRY.*
		FROM 
			CATENTRY
		WHERE 
			CATENTRY.CATENTRY_ID IN (?UniqueID?)
END_SQL_STATEMENT

<!-- ======================================================================================================== 
	Get the catalog entries's all attribute dictionary attributes and values according to catalog entry ids.
	@param UniqueID The unique id of the catalog entry.
	@param storePath The store path of the current store.
	@param languageId The language of the attribute to be returned.
============================================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_CatalogEntryAttributeDictionaryAttributes
	base_table=CATENTRYATTR
	sql=	
		SELECT 
			CATENTRYATTR.CATENTRY_ID, ATTRDESC.NAME, ATTRVALDESC.VALUE, ATTRVALDESC.STRINGVALUE,ATTRVALDESC.INTEGERVALUE,ATTRVALDESC.FLOATVALUE
		FROM 
			CATENTRYATTR
				JOIN ATTR ON
					ATTR.ATTR_ID = CATENTRYATTR.ATTR_ID AND ATTR.STOREENT_ID IN (?storePath?) 
				JOIN ATTRDESC ON	 
					ATTRDESC.ATTR_ID = ATTR.ATTR_ID AND ATTRDESC.LANGUAGE_ID IN (?languageId?)
				JOIN ATTRVAL ON 	 
					ATTRVAL.ATTRVAL_ID = CATENTRYATTR.ATTRVAL_ID AND ATTRVAL.STOREENT_ID IN (?storePath?)
				JOIN ATTRVALDESC ON	 
					ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND ATTRVALDESC.LANGUAGE_ID IN (?languageId?)
			
		WHERE 
			CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND CATENTRYATTR.ATTRVAL_ID <> 0
		ORDER BY
			CATENTRYATTR.CATENTRY_ID
END_SQL_STATEMENT

<!-- ============================================================================================================================================ 
	Get the catalog entries's attribute dictionary attributes and values according to catalog entry ids and attribute names (case insensitive).
	@param UniqueID The unique id of the catalog entry.
	@param Name The name of the attribute.
	@param storePath The store path of the current store.
	@param languageId The language of the attribute to be returned.
================================================================================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_CatalogEntryAttributeDictionaryAttributesByNames
	base_table=CATENTRYATTR
	sql=	
		SELECT 
			CATENTRYATTR.CATENTRY_ID, ATTRDESC.NAME, ATTRVALDESC.VALUE, ATTRVALDESC.STRINGVALUE,ATTRVALDESC.INTEGERVALUE,ATTRVALDESC.FLOATVALUE
		FROM 
			CATENTRYATTR
				JOIN ATTR ON
					ATTR.ATTR_ID = CATENTRYATTR.ATTR_ID AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$) 
				JOIN ATTRDESC ON	 
					ATTRDESC.ATTR_ID = ATTR.ATTR_ID AND ATTRDESC.LANGUAGE_ID IN (?languageId?) AND UPPER(ATTRDESC.NAME) IN (?Name?)
				JOIN ATTRVAL ON 	 
					ATTRVAL.ATTRVAL_ID = CATENTRYATTR.ATTRVAL_ID AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
				JOIN ATTRVALDESC ON	 
					ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND ATTRVALDESC.LANGUAGE_ID IN (?languageId?)
			
		WHERE 
			CATENTRYATTR.CATENTRY_ID IN (?UniqueID?) AND CATENTRYATTR.ATTRVAL_ID <> 0
		ORDER BY
			CATENTRYATTR.CATENTRY_ID
END_SQL_STATEMENT


<!-- ========================================================================================== 
	Get the catalog entries's all classic attributes and values according to catalog entry ids.
	@param UniqueID The unique id of the catalog entry.
	@param languageId The language of the attribute to be returned.
============================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_CatalogEntryClassicAttributes
	base_table=ATTRVALUE
	sql=
	
		SELECT 
				ATTRIBUTE.ATTRIBUTE_ID, ATTRIBUTE.NAME, ATTRVALUE.CATENTRY_ID, ATTRVALUE.STRINGVALUE, ATTRVALUE.STRINGVALUE, ATTRVALUE.INTEGERVALUE, ATTRVALUE.FLOATVALUE, ATTRVALUE.NAME AS VALUE
		FROM 	
				ATTRVALUE		
					JOIN ATTRIBUTE ON 
						ATTRIBUTE.ATTRIBUTE_ID = ATTRVALUE.ATTRIBUTE_ID AND ATTRIBUTE.LANGUAGE_ID IN (?languageId?) 
		WHERE 
				ATTRVALUE.CATENTRY_ID IN (?UniqueID?) AND ATTRVALUE.LANGUAGE_ID IN (?languageId?)
				
		ORDER BY 
				ATTRVALUE.CATENTRY_ID
				
END_SQL_STATEMENT

<!-- ============================================================================================================ 
	Get the catalog entries's classic attributes and values according to catalog entry ids and attribute names
	@param UniqueID The unique id of the catalog entry.
	@param Name The name of the attribute.
	@param languageId The language of the attribute to be returned.
================================================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Get_CatalogEntryClassicAttributesByNames
	base_table=ATTRVALUE
	sql=
	
		SELECT 
				ATTRIBUTE.ATTRIBUTE_ID, ATTRIBUTE.NAME, ATTRVALUE.CATENTRY_ID, ATTRVALUE.STRINGVALUE, ATTRVALUE.STRINGVALUE, ATTRVALUE.INTEGERVALUE, ATTRVALUE.FLOATVALUE, ATTRVALUE.NAME AS VALUE
		FROM 	
				ATTRVALUE		
					JOIN ATTRIBUTE ON 
						ATTRIBUTE.ATTRIBUTE_ID = ATTRVALUE.ATTRIBUTE_ID AND UPPER(ATTRIBUTE.NAME) IN (?Name?) AND ATTRIBUTE.LANGUAGE_ID IN (?languageId?) 
		WHERE 
				ATTRVALUE.CATENTRY_ID IN (?UniqueID?) AND ATTRVALUE.LANGUAGE_ID IN (?languageId?)
				
		ORDER BY 
				ATTRVALUE.CATENTRY_ID
				
END_SQL_STATEMENT

<!-- ====================================================================== 
	Check if the specified catalog entry id is valid. 
	@param catEntryId The unique id of the catalog entry. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT	
	name=/CatalogEntry/CatalogEntryIdentifier[(UniqueID=)]+IBM_Admin_IdResolve
	base_table=CATENTRY
	sql=
		SELECT 
			CATENTRY_ID_1
		FROM 
		(
		  SELECT 
		  		CATENTRY.$COLS:CATENTRY_ID$ CATENTRY_ID_1
		  FROM 
		  		CATENTRY
		  WHERE 
		  		CATENTRY.CATENTRY_ID = (?UniqueID?)  AND 
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
	Get the catalog(s) of the store having the specified value for CATALOG_ID
	@param UniqueID The unique id of the catalog. 
	@param storeId The store for which to retrieve the catalog. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all properties + the storecat of a catalog -->
	<!-- xpath = "/Catalog[CatalogIdentifier[(UniqueID=)] and (@storeId=)]]" -->
	name=/Catalog[CatalogIdentifier[(UniqueID=)] and (@storeId=)]]+IBM_Admin_CatalogStoreDetailsProfile	
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
					JOIN STORECAT ON (STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
					AND STORECAT.STOREENT_ID in (?storeId?))					
				        
        	WHERE
               		CATALOG.CATALOG_ID in (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT
<!-- ====================================================================== 
	Get the master catalog of the specified store.
	@param storeId The store for which to retrieve the catalog. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all properties + the storecat for the master catalog of a store -->
	<!-- xpath = "/Catalog[@storeId=]" -->
	name=/Catalog[@storeId=]+IBM_Admin_CatalogStoreDetailsProfile
	base_table=CATALOG
	sql=
		SELECT 
				CATALOG.$COLS:CATALOG$,
				STORECAT.$COLS:STORECAT$
		FROM
				CATALOG
					JOIN STORECAT ON (STORECAT.CATALOG_ID=CATALOG.CATALOG_ID 
					AND STORECAT.STOREENT_ID=?storeId?)					
				        
        	WHERE
               		STORECAT.STOREENT_ID = ?storeId? AND
			STORECAT.MASTERCATALOG = '1' 
			
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get attribute dictionary attributes of a catalog entry according to the 
	unique ids of the attribute dictionary attributes.
	@param UniqueID The unique ids of the attribute dictionary attributes. 
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryAttributes[AttributeIdentifier/(UniqueID=)]+IBM_Admin_AttributeDictionaryAttribute
	base_table=ATTR
	sql=
		SELECT 
				ATTR.$COLS:ATTR$,
				ATTRDESC.$COLS:ATTRDESC$,
				ATTRVAL.$COLS:ATTRVAL$,
				ATTRVALDESC.$COLS:ATTRVALDESC$
							
		FROM
				ATTR
				LEFT OUTER JOIN ATTRDESC ON
					(ATTRDESC.ATTR_ID=ATTR.ATTR_ID AND
					 ATTRDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
							 
				LEFT OUTER JOIN ATTRVAL ON
					(ATTRVAL.ATTR_ID = ATTR.ATTR_ID AND
					ATTRVAL.VALUSAGE is NOT NULL AND
					ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$))
					LEFT OUTER JOIN ATTRVALDESC ON
			        	(ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND
					    ATTRVALDESC.LANGUAGE_ID = ATTRDESC.LANGUAGE_ID)		
				        
        WHERE
		        ATTR.ATTR_ID IN (?UniqueID?) AND ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
		        
		ORDER BY
				ATTRVALDESC.SEQUENCE				
			
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= 
	Get values of attribute dictionary attributes of a catalog entry 
	according to the identifiers of the attribute values.
	@param identifier The identifiers (unique ids) of the attribute dictionary attribute values. 
================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryAttributes/Attributes/Value[(@identifier=)]+IBM_Admin_AttributeDictionaryAttribute
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$,			
				ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				ATTRVAL
				LEFT OUTER JOIN ATTRVALDESC ON
					(ATTRVALDESC.ATTRVAL_ID = ATTRVAL.ATTRVAL_ID AND
					ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				        
        WHERE
		        ATTRVAL.ATTRVAL_ID IN (?identifier?) AND ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
			
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================================================== 
	Get classic attributes according to the unique ids of the classic attributes.
	@param UniqueID The unique ids of the classic attributes. 
================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryAttributes[AttributeIdentifier/(UniqueID=)]+IBM_Admin_Attribute
	base_table=ATTRIBUTE
	sql=
		SELECT 
			ATTRIBUTE.$COLS:ATTRIBUTE$ 
		FROM 
			ATTRIBUTE  
		WHERE
			ATTRIBUTE.ATTRIBUTE_ID IN (?UniqueID?) AND
			ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRIBUTE.SEQUENCE
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================================================== 
	Get allowed values of classic attributes according to the unique ids of the classic attributes.
	@param UniqueID The unique ids of the classic attributes. 
================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryAttributes[AttributeIdentifier/(UniqueID=)]/AllowedValue+IBM_Admin_Attribute
	base_table=ATTRVALUE
	sql=
		SELECT 
			ATTRVALUE.$COLS:ATTRVALUE$ 
		FROM 
			ATTRVALUE  
		WHERE
			ATTRVALUE.ATTRIBUTE_ID IN (?UniqueID?) AND
			ATTRVALUE.CATENTRY_ID = 0 AND
			ATTRVALUE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRVALUE.SEQUENCE						
			
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================== 
	Get the identifier information of a catalog entry according to its unique id.
	The information can be used to build the logical catalog entry identifier.
	@param UniqueID The unique id of the catalog entry. 
=================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]+IBM_Admin_IDENTIFIER
	base_table=CATENTRY
	sql=

		SELECT 
			CATENTRY.$COLS:CATENTRY_ID$,
			CATENTRY.$COLS:CATENTRY:MEMBER_ID$,
			CATENTRY.$COLS:CATENTRY:PARTNUMBER$,
			STORECENT.$COLS:STORECENT:CATENTRY_ID$,
			STORECENT.$COLS:STORECENT:STOREENT_ID$
		FROM 
			CATENTRY,STORECENT 
		WHERE 
			CATENTRY.CATENTRY_ID IN (?UniqueID?) AND CATENTRY.MARKFORDELETE = 0 AND 
			CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================== 
	Get the identifier information of a catalog group according to its unique id.
	The information can be used to build the logical catalog group identifier.
	@param UniqueID The unique id of the catalog group. 
=================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_IDENTIFIER
	base_table=CATGROUP
	sql=
	
		SELECT 
			CATGROUP.$COLS:CATGROUP_ID$,
			CATGROUP.$COLS:CATGROUP:MEMBER_ID$,
			CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
			STORECGRP.$COLS:STORECGRP:CATGROUP_ID$,
			STORECGRP.$COLS:STORECGRP:STOREENT_ID$
		FROM 
			CATGROUP,STORECGRP 
		WHERE 
			CATGROUP.CATGROUP_ID IN (?UniqueID?) AND CATGROUP.MARKFORDELETE = 0 AND 
			CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================== 
	Get the store identifier information of a catalog entry according to its unique id.
	The information can be used to build the logical store identifier.
	@param UniqueID The unique id of the catalog entry. 
=================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry/CatalogEntryIdentifier[(UniqueID=)]/ExternalIdentifier/StoreIdentifier+IBM_Admin_IDENTIFIER
	base_table=STORECENT
	sql=

		SELECT 
			STORECENT.$COLS:STORECENT:CATENTRY_ID$,
			STORECENT.$COLS:STORECENT:STOREENT_ID$
		FROM 
			STORECENT 
		WHERE 
			STORECENT.CATENTRY_ID IN (?UniqueID?) AND
			STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This query is deprecated in the FEP4 code.                -->
<!-- See /MASSOCTYPE+IBM_Admin_SupportedMerchandisingAssociationName -->
<!-- =====Get name of supported merchandising association===== -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/MassocType+IBM_Admin_SupportedMerchandisingAssociationName
	base_table=MASSOCTYPE
	sql=
		SELECT
			MASSOCTYPE.$COLS:MASSOCTYPE$
		FROM  MASSOCTYPE
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This query is deprecated in the FEP4 code.                -->
<!-- See /MASSOC+IBM_Admin_SupportedSemanticSpecifiers               -->
<!-- =====Get supported semantic specifiers for association=== -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Massoc+IBM_Admin_SupportedSemanticSpecifiers
	base_table=MASSOC
	sql=
		SELECT
			MASSOC.$COLS:MASSOC$
		FROM  MASSOC
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================================ -->
<!--  Initialize the catalog entry long description email message to empty_clob() -->
<!--                                                                              -->
<!--  @param CATENTRY_ID                                                          -->
<!--     The unique identifier of the catalog entry.                              -->
<!--  @param LANGUAGE_ID                                                          -->
<!--     The language identifier                                                  -->
<!--==============================================================================-->
BEGIN_SQL_STATEMENT
  base_table=CATENTDESC
  name=IBM_Set_CatEntry_LongDescription_To_Empty_Clob
  sql=update CATENTDESC set LONGDESCRIPTION = EMPTY_CLOB() where CATENTRY_ID = ?CATENTRY_ID? and LANGUAGE_ID=?LANGUAGE_ID?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Get the catalog entry long description clob column for an update         -->
<!--  on Oracle 9i; because of the Oracle bug, the CLOB column can not         -->
<!--  be the first or the last in the SELECT list.                             -->
<!--                                                                           -->
<!--  @param CATENTRY_ID                                                       -->
<!--     The unique identifier of the catalog entry.                           -->
<!--  @param LANGUAGE_ID                                                       -->
<!--     The language identifier                                               -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=EMLCONTENT
  name=IBM_Select_CatEntry_LongDescription
  sql=select CATENTRY_ID, LONGDESCRIPTION, CATENTRY_ID from CATENTDESC where CATENTRY_ID = ?CATENTRY_ID? and LANGUAGE_ID=?LANGUAGE_ID? FOR UPDATE
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select active child SKUs based on the product catentry ID
	@param catalogEntryId The parent catalog entry id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ChildSKU
	base_table=CATENTREL
	sql=
		SELECT CATENTREL.CATENTRY_ID_CHILD FROM CATENTREL, CATENTRY WHERE CATENTREL.CATENTRY_ID_PARENT=?catalogEntryId? AND CATRELTYPE_ID = 'PRODUCT_ITEM'
			AND CATENTRY.CATENTRY_ID=CATENTREL.CATENTRY_ID_CHILD AND CATENTRY.MARKFORDELETE=0
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if attribute value is used by other catalog entries other than the speified one  -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CATENTRYATTR_BY_ATTRVAL_ID
	base_table=CATENTRYATTR
	sql=
	SELECT COUNT(*) AS COUNT
	FROM CATENTRYATTR
	WHERE ATTR_ID = ?attrId? AND ATTRVAL_ID = ?attrValId? AND CATENTRY_ID <> ?catentryId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the number of records in the ATTRIBUTE table           	       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTRIBUTE_COUNT
	base_table=ATTRIBUTE
	sql=
	SELECT COUNT(*) AS COUNT
	FROM ATTRIBUTE
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if classic attribute table ATTRIBUTE is empty or not           -->
<!-- ========================================================================= -->

BEGIN_SQL_STATEMENT
    name=IsAttributeTableEmpty
    base_table=ATTRIBUTE

    dbtype=db2
    sql=
    select count(*) as COUNT from ( 
    	select 1 from ATTRIBUTE fetch first 1 rows only) as subquery
  
    dbtype=derby
    sql=
    select count(*) as COUNT from ( 
    	select 1 from ATTRIBUTE fetch first 1 rows only) as subquery
  
    dbtype=oracle
    sql=
    select count(*) as COUNT from ( 
    	select 1 from ATTRIBUTE where ROWNUM=1)
  
    dbtype=any
    sql=
    select count(*) as COUNT
    	from ATTRIBUTE
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select parent catalog entries based on the product catentry ID
	@param catalogEntryId The child catalog entry id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ParentCatalogEntry
	base_table=CATENTREL
	sql=
		SELECT CATENTREL.CATENTRY_ID_PARENT FROM CATENTREL WHERE CATENTREL.CATENTRY_ID_CHILD=?catalogEntryId?
END_SQL_STATEMENT


<!-- ====================================================================== 
	Selects the language column from the store table which holds the store
	default language.
	@param storeId The ID of the store 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_StoreDefaultLang
	base_table=STORE
	sql=
		select LANGUAGE_ID from STORE where STORE_ID=?storeId?  
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select all the catalog entry templates in the seopagedef table for a given
	store path.
	@param pageName The page name of the record to retrieve.
	@param objectId The ID of the object to retrieve.
	@param objectType The object type to return. For example Product or Category.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefForTemplate
	base_table=SEOPAGEDEF
	sql=
		select * from seopagedef left join seopagedefovr on seopagedef.seopagedef_id = seopagedefovr.seopagedef_id 
		where seopagedef.storeent_id in ($STOREPATH:view$) 
		and object_id = ?objectId? and seopagedef.pagename = ?pageName?	and objecttype=?objectType?
END_SQL_STATEMENT


<!-- ====================================================================== 
	Select the seopagedef entry for a specific catalog entry in a store path.
	@param objectId The unique ID of the catalog entry.
	@param objectType The object type to return. For example Product or Category.
	@param pageName The page name of the record to retrieve .
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefForCatentry
	base_table=SEOPAGEDEF
	sql=
		select * from seopagedef left join seopagedefovr on seopagedef.seopagedef_id = seopagedefovr.seopagedef_id 
		where seopagedef.storeent_id in ($STOREPATH:catalog$) 
		and object_id = ?objectId? and seopagedef.pagename = ?pageName? and objecttype=?objectType?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the url keyword for a given catalog entry or catalog group.
	@param languageId The language ID to retrieve.
	@param tokenName The type of token to use.
	@param tokenValue The value of the token to use. This is a catentry or catgroup ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOURL
	base_table=seourl
	sql=
		select * from seourl left join seourlkeyword on seourl.seourl_id = seourlkeyword.seourl_id where status=1 and tokenvalue=?tokenValue? and tokenname=?tokenName? and language_id=?languageId? and storeent_id=?storeId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select all columns from the seopagedefovr table given a catalog entry ID.
	@param objectId The ID of a catalog entry or catalog group to retrieve.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_Catentry_SEOPageDefOvr
	base_table=SEOPAGEDEFEXT
	sql=
		select * from SEOPAGEDEFOVR where object_id=?objectId? 
END_SQL_STATEMENT


<!-- ====================================================================== 
	Select all columns from the seopagedefdesc table given a seopagedef ID 
	and a set of languages.
	@param seopagedefId The ID from the seopagedef table.
	@param langIds A list of language IDs.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefDesc
	base_table=SEOPAGEDEFDESC
	sql=
		select * from SEOPAGEDEFDESC where SEOPAGEDEF_ID=?seopagedefId? and language_id in (?langIds?)  
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select the seopagedef entry for a specific catalog group in a store path.
	@param catgroupId The unique ID of the catalog group. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOPageDefForCatgroup
	base_table=SEOPAGEDEF
	sql=
		select * from seopagedef left join seopagedefovr on seopagedef.seopagedef_id = seopagedefovr.seopagedef_id 
		where seopagedef.storeent_id in ($STOREPATH:catalog$) 
		and objecttype= ?objectType? and object_id = ?catgroupId? 
END_SQL_STATEMENT


<!-- ====================================================================== 
	Select parent catalog group based on the child catgroup ID
	@param catalogGroupId The child catalog group id 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_ParentCatalogGroup
	base_table=CATENTREL
	sql=
		SELECT CATGROUP_ID_PARENT FROM CATGRPREL WHERE CATGROUP_ID_CHILD=?catalogGroupId? AND CATALOG_ID=?catalogId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select catalog entry ID by part numbers and store path.
	@param partNumberList The part numbers 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogEntry_By_PartNumbers
	base_table=CATENTRY
	sql=
			SELECT CATENTRY.CATENTRY_ID,  CATENTRY.PARTNUMBER, STORECENT.STOREENT_ID
			FROM 
			CATENTRY LEFT OUTER JOIN STORECENT
			ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID) 
		WHERE
			CATENTRY.PARTNUMBER IN (?partNumberList?) AND  		
			CATENTRY.MARKFORDELETE = 0 AND
			STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ )
END_SQL_STATEMENT


<!-- ====================================================================== 
	Delete dynamic kit preconfiguration.
	@param catalogEntryId The catalog entry id of the dynamic kit.
	@param sequence The sequence of the preconfigruation.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_DynamicKitPreConfiguration
	base_table=DKPREDEFCONF
	sql=
		DELETE FROM
	     	DKPREDEFCONF
	     	WHERE DKPREDEFCONF_ID IN (
	     		SELECT DKPREDEFCONF_ID FROM DKPDCCATENTREL
	     				WHERE CATENTRY_ID=?catalogEntryId? AND
	     				SEQUENCE=?sequence? 
	     				)
END_SQL_STATEMENT



<!-- ====================================================================== 
	Add a new dynamic kit preconfiguration
	@param dkPreDefConfId The dynamic kit predefined  configuration id.
	@param completeFlag The flag to indicate whether the configuration is complete.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_DynamicKitPreConfiguration
	base_table=DKPREDEFCONF
	sql=
		INSERT INTO 
	     	DKPREDEFCONF
	     				(DKPREDEFCONF_ID, COMPLETE)
	     	VALUES
					(?dkPreDefConfId?, ?completeFlag?)
END_SQL_STATEMENT


<!-- ====================================================================== 
	Add a new dynamic kit preconfiguration component
	@param dkPreDefCompListId The dynamic kit predefined  configuration component id.
	@param dkPreDefConfId The dynamic kit predefined  configuration id.
	@param catalogEntryId The catalog entry ID of the component.
	@param groupName The group name of the component.
	@param quantity The quantity.
	@param quantityUnitId The quantity unit.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_DynamicKitPreConfigurationComponent
	base_table=DKPDCCOMPLIST
	sql=
		INSERT INTO 
	     	DKPDCCOMPLIST
	     				(DKPDCCOMPLIST_ID, DKPREDEFCONF_ID, CATENTRY_ID, GROUPNAME, QUANTITY, QTYUNIT_ID)
	     	VALUES
					(?dkPreDefCompListId?, ?dkPreDefConfId?, ?catalogEntryId?, ?groupName?, ?quantity?, ?quantityUnitId?)
END_SQL_STATEMENT


<!-- ====================================================================== 
	Add a new dynamic kit preconfiguration to catalog entry relationship
	@param dkPreDefConfId The dynamic kit predefined  configuration id.
	@param catalogEntryId The catalog entry id of the dynamic kit.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_DynamicKitPreConfigurationCatalogEntryRelation
	base_table=DKPDCCATENTREL
	sql=
		INSERT INTO 
	     	DKPDCCATENTREL
	     				(DKPREDEFCONF_ID, CATENTRY_ID)
	     	VALUES
					(?dkPreDefConfId?, ?catalogEntryId?)
END_SQL_STATEMENT
<!-- ====================================================================== 
	Looks for seo url records matching a certain keyword value in a given language
	@param keyword The keyword to look for.
	@param languageId The language ID to look for.
	@param storeentId The storeent ID to look for.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOURLKEYWORD_BY_KEYWORD
	base_table=seourlkeyword
	sql=
		select seourlkeyword.seourlkeyword_id from seourlkeyword where urlkeyword = ?keyword? and storeent_id = ?storeentId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete TMD information from seopagedef for a catgroup or a catentry
	@param objecttype The type of object (CatalogGroup or CatalogEntry)
	@param catalogObjectList List of IDs of the object (catgroup ids or catentry ids)
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_DELETE_SEO_TMD
	base_table=seopagedef
	sql=
		delete from seopagedef where seopagedef_id in (select seopagedef_id from seopagedefovr where objecttype=?objecttype? and object_id in (?catalogObjectList?))
END_SQL_STATEMENT

<!-- ====================================================================== 
	Update status of a URL for a catgroup or a catentry
	@param status The status to set
	@param catalogObjectList List of IDs of the object (catgroup ids or catentry ids)
	@param tokenname indicates if it is for a catgroup or catentry (CategoryToken or ProductToken)
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_SET_STATUS_SEO_URL
	base_table=seourlkeyword
	sql=
		update seourlkeyword
		set status=?status?
		where seourl_id in 
			(select seourl.seourl_id
			from seourl
			where seourl.seourl_id = seourlkeyword.seourl_id
				and tokenvalue in (?catalogObjectList?) and tokenname=?tokenname?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the url keyword for a given urlkeyword and store id.
	@param urlKeyword Url keyword mapped to the token value.
	@param storeId Store identifier of the url keyword.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOUrlKeyword_KeywordAndStoreId
	base_table=seourlkeyword
	sql=
		SELECT * FROM SEOURLKEYWORD WHERE URLKEYWORD=?urlKeyword? AND STOREENT_ID=?storeId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the url keyword for a given token name and token value.
	@param storeId Store identifier of the url keyword.
	@param tokenName The name of the url keyword token.
	@param tokenValue The value that the token maps to.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOUrlKeyword_StoreIdAndTokenNameAndTokenValue
	base_table=seourlkeyword
	sql=
		SELECT SEOURL_ID FROM SEOURLKEYWORD WHERE STOREENT_ID=?storeId? AND SEOURL_ID IN (SELECT SEOURL_ID FROM SEOURL WHERE TOKENNAME=?tokenName? AND TOKENVALUE=?tokenValue?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Selects the url keyword for a given token name and url keyword.
	@param storeId Store identifier of the url keyword.
	@param urlKeyword The keyword to look for.
	@param tokenName The name of the url keyword token.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_SEOUrlKeyword_StoreIdAndUrlKeywordAndTokenName
	base_table=seourlkeyword
	sql=
		SELECT SEOURL_ID FROM SEOURLKEYWORD WHERE STOREENT_ID=?storeId? AND URLKEYWORD=?urlKeyword? AND SEOURL_ID IN (SELECT SEOURL_ID FROM SEOURL WHERE TOKENNAME=?tokenName?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Updates the status of the specified url keywords
	@param status The updated status value.
	@param seoUrlId The list of identifiers of the seo url to update.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_SEOUrlKeyword_Status
	base_table=seourlkeyword
	sql=
		UPDATE SEOURLKEYWORD SET STATUS=?status? WHERE SEOURL_ID IN (?seoUrlId?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Updates the token value of the specified seo urls
	@param tokenValue The updated token value.
	@param seoUrlId The list of identifiers of the seo urls to update.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_SEOUrl_TokenValue
	base_table=seourl
	sql=
		UPDATE SEOURL SET TOKENVALUE=?tokenValue? WHERE SEOURL_ID IN (?seoUrlId?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Insert new seo token mapping to the new url along with other properties.
	@param seoUrlId Identifier of the url token.
	@param tokenName Name of the url token.
	@param tokenValue Value mapped to the url token.
	@param priority Relative priority for the url.
	@param changeFreq Frequency of change for the url.
	@param mobilePriority Relative priority for the mobile version of the url.
	@param mobileChangeFreq Frequency of change for the mobile version of the url.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_SEOUrl
	base_table=SEOURL
	sql=
    INSERT INTO SEOURL
           (SEOURL_ID, TOKENNAME, TOKENVALUE, PRIORITY, CHANGE_FREQUENCY, MOBILE_PRIORITY, MOBILE_CHG_FREQ)
    VALUES (?seoUrlId?, ?tokenName?, ?tokenValue?, ?priority?, ?changeFreq?, ?mobilePriority?, ?mobileChangeFreq?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Insert new keyword for the new seo url.
	@param seoUrlKeywordId Identifier of the seo url keyword.
	@param seoUrlId Identifier of the url token.
	@param storeId Store identifier of the url keyword.
	@param langId Identifier of the language this url keyword is in.
	@param urlKeyword Url keyword mapped to the token value.
	@param mobileUrlKeyword Mobile url keyword mapped to the token value.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_SEOUrlKeyword
	base_table=SEOURLKEYWORD
	sql=
    INSERT INTO SEOURLKEYWORD
           (SEOURLKEYWORD_ID, SEOURL_ID, STOREENT_ID, LANGUAGE_ID, URLKEYWORD, MOBILEURLKEYWORD)
    VALUES (?seoUrlKeywordId?, ?seoUrlId?, ?storeId?, ?langId?, ?urlKeyword?, ?mobileUrlKeyword?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Get the count of how many times the attribute is referenced by catalog entries 
	in CATENTRYATTR table.  This query will not count the catalog entries which are marked for delete.
	@param attrId The unique ID of the attribute.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CountCatalogEntryAttributeRelationshipByAttribute
	base_table=CATENTRYATTR
	sql=
		select count(*) from catentryattr 
				JOIN CATENTRY ON CATENTRYATTR.CATENTRY_ID = CATENTRY.CATENTRY_ID
				where catentryattr.attr_id=?attrId? AND CATENTRY.MARKFORDELETE=0
END_SQL_STATEMENT

<!-- ====================================================================== 
	Get the count of how many times the specified attribute is referenced 
	by marketing activities.
	@param attrId The unique ID of the attribute.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CountAttributeActivityRelationshipByAttributeID
	base_table=DMELEMENTNVP
	sql=
		select 
			count(*) from dmelementnvp 
		where 
			name='filterName' and 
			value=?attrId? and
			dmelement_id in (select dmelement_id from dmelementnvp where name='filterType' and value in ('attributeType', 'facetableAttributeType'))
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=IBM_Select_DefaultCatalog
	base_table=STOREDEFCAT
	sql=
		SELECT 
			STOREDEFCAT.CATALOG_ID, STOREDEFCAT.STOREENT_ID
		FROM 
			STOREDEFCAT, CATALOG
		WHERE 
			STOREDEFCAT.STOREENT_ID in ($STOREPATH:catalog$) AND
			CATALOG.CATALOG_ID = STOREDEFCAT.CATALOG_ID
END_SQL_STATEMENT

<!-- ========================================================= -->
<!-- =====Get default override group of the given store ===== -->
<!-- ========================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CATOVRGRP+IBM_Admin_DefaultCatalogOverrideGroupForStore
	base_table=CATOVRGRP
	sql=
		SELECT
			CATOVRGRP.$COLS:CATOVRGRP$
		FROM  CATOVRGRP WHERE CATOVRGRP.STOREENT_ID=?storeId?
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================================ -->
<!--  Initialize the catalog entry long description override to empty_clob() -->
<!--                                                                              -->
<!--  @param UniqueID                                                          -->
<!--     The unique identifier of the catalog entry description override.                              -->
<!--==============================================================================-->
BEGIN_SQL_STATEMENT
  base_table=CATENTDESCOVR
  name=IBM_Set_CatEntry_Desc_Override_LongDescription_To_Empty_Clob
  sql=update CATENTDESCOVR set LONGDESCRIPTION = EMPTY_CLOB() where CATENTDESCOVR.CATENTDESCOVR_ID = ?UniqueID?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Get the catalog entry long description override clob column for an update         -->
<!--  on Oracle 9i; because of the Oracle bug, the CLOB column can not         -->
<!--  be the first or the last in the SELECT list.                             -->
<!--                                                                           -->
<!--  @param UniqueID                                                          -->
<!--     The unique identifier of the catalog entry description override.                              -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=CATENTDESCOVR
  name=IBM_Select_CatEntry_Desc_Override_LongDescription
  sql=select CATENTDESCOVR_ID, LONGDESCRIPTION, CATENTDESCOVR_ID from CATENTDESCOVR where CATENTDESCOVR.CATENTDESCOVR_ID = ?UniqueID? FOR UPDATE
END_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the catalog override group id for a store .
	 @param storeId
		The unique identifier for store
     =========================================================================== -->
BEGIN_SQL_STATEMENT
  name=IBM_Select_OverrideGroupID_By_StoreID
  base_table=STORECATOVRGRP
  sql= SELECT STORECATOVRGRP.CATOVRGRP_ID 
  		FROM 
  			STORECATOVRGRP 
  		WHERE 
  			STORECATOVRGRP.STOREENT_ID IN (?storeId?)
END_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the catalog entry description override for the given catalog entries, overide group and language ids.
     @param UniqueID List of unique identifiers for catalog entries
     @param catOverrideGroupID The unique identifier of the catalog override group.  
     @param language The language ids.
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CATENTDESCOVR[CATENTRY_ID= AND CATOVRGRP_ID=]+IBM_Get_CatalogEntryDescriptionOverride
	base_table=CATENTDESCOVR
	sql=
		SELECT CATENTDESCOVR.$COLS:CATENTDESCOVR$ FROM CATENTDESCOVR WHERE 
		CATENTDESCOVR.CATENTRY_ID IN (?UniqueID?) AND 
		CATENTDESCOVR.CATOVRGRP_ID = ?catOverrideGroupID?  AND 
		CATENTDESCOVR.LANGUAGE_ID IN (?language?) 	
		ORDER BY CATENTDESCOVR.CATENTRY_ID, CATENTDESCOVR.LANGUAGE_ID
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Query to retrieve the catalog entry description for the given catalog entries and language ids.
     @param UniqueID List of unique identifiers for catalog entries
     @param language The language ids.     
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CATENTDESC[CATENTRY_ID= AND LANGUAGE_ID=]+IBM_Get_CatalogEntryDescriptions
	base_table=CATENTDESC
	sql=
		SELECT CATENTDESC.$COLS:CATENTDESC$ FROM 
			CATENTDESC 
		WHERE CATENTDESC.CATENTRY_ID IN (?UniqueID?) AND CATENTDESC.LANGUAGE_ID IN (?language?)
		ORDER BY CATENTDESC.CATENTRY_ID, CATENTDESC.LANGUAGE_ID
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Select parent catalog entry based on the item catentry ID.
	@param catalogEntryId Unique ID of the item.	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogEntryParent
	base_table=CATENTREL
	sql=
		select CATENTRY_ID_PARENT from CATENTREL where CATENTRY_ID_CHILD=?catalogEntryId? and CATRELTYPE_ID='PRODUCT_ITEM'
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the UOM of CATENTRY from CATENTSHIP table                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_UOM_From_CATENTSHIP
	base_table=CATENTSHIP
	sql=
	SELECT CATENTRY_ID, QUANTITYMEASURE
	FROM CATENTSHIP
	WHERE CATENTRY_ID IN (?UniqueID?)
        ORDER BY CATENTRY_ID
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Retrieve attributte values for a given list of attribute identifiers     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_VALUES
	base_table=ATTRVALDESC
	sql=
	SELECT VALUE
	  FROM ATTRVALDESC
	WHERE ATTRVAL_ID=?attributeValueId? AND LANGUAGE_ID=$CTX:LANG_ID$
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Retrieve attributte values for a given list of attribute identifiers     -->
<!--  for all languages                                                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_VALUES_FOR_ALL_LANGUAGES
	base_table=ATTRVALDESC
	sql=
	SELECT VALUE
	  FROM ATTRVALDESC
	WHERE ATTRVAL_ID=?attributeValueId? 
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get attribute name by identifier   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SEARCHABLE_ATTR_NAME
	base_table=ATTRDESC
	sql=
	select ATTR_ID,NAME 
	from ATTRDESC WHERE ATTR_ID IN(SELECT ATTR_ID FROM ATTR WHERE IDENTIFIER =?name? and storeent_id in (?storeent_id?) and SEARCHABLE=1) AND LANGUAGE_ID=?languageId?
END_SQL_STATEMENT


<!-- ====================================================================== 
	Add a new Predefined Dynamic kit component
	@param parentCatalogEntryId The parent PDK catalog entry id.
	@param catalogEntryId The catalog entry ID of the component.
	@param groupName The group name of the component.
	@param quantity The quantity.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_PDK_Component
	base_table=CATENTREL
	sql=
		INSERT INTO 
	     	CATENTREL
	     				(CATENTRY_ID_PARENT, CATRELTYPE_ID, CATENTRY_ID_CHILD, GROUPNAME, QUANTITY)
	     	VALUES
					(?parentCatalogEntryId?, 'PDK_COMPONENT', ?catalogEntryId?, ?groupName?, ?quantity?)
END_SQL_STATEMENT



<!-- ====================================================================== 
	Delete PDK Component
	@param catalogEntryIdList The PDK catalog entry id list.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_PDK_Component
	base_table=CATENTREL
	sql=
	DELETE
	FROM
	    CATENTREL
	WHERE
    	CATENTRY_ID_PARENT IN (?catalogEntryIdList?) AND
    	CATRELTYPE_ID='PDK_COMPONENT'
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete PDK configuration
	@param catalogEntryIdList The catalog entry ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_PDK_Configuration
	base_table=CATCONFINF
	sql=
		DELETE FROM
	     	CATCONFINF
	     	WHERE CATENTRY_ID IN  ( ?catalogEntryIdList? )
END_SQL_STATEMENT


<!-- ====================================================================== 
	Get DK configuration by child PDK.
	@param catalogEntryId The catalog entry ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_DKConfigurationByChildPDK
	base_table=CATCONFINF
	sql=
		SELECT CATENTRY_ID, REFERENCE, CONFIGURATION FROM
	     	CATCONFINF
	     	WHERE CATENTRY_ID IN  (
	     		SELECT CATENTRY_ID_PARENT FROM CATENTREL WHERE CATENTRY_ID_CHILD = (?catalogEntryId?)
	     	)
END_SQL_STATEMENT


<!-- ====================================================================== 
	Get trading position container ID and stoer ID from the CATGRPTPC table.
	@param tradingPositionCNIdList The list of trading position container ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_TradingPositionContainerAndStoreForStandardOfferPrice
	base_table=CATGRPTPC
	sql=
		SELECT TRADEPOSCN_ID, STORE_ID FROM CATGRPTPC 
		WHERE CATGROUP_ID = 0 AND TRADEPOSCN_ID IN (?tradingPositionCNIdList?)
			AND CATGRPTPC.CATALOG_ID IN (SELECT CATALOG_ID FROM STORECAT WHERE STOREENT_ID IN ($STOREPATH:catalog$) AND MASTERCATALOG='1' ) 
			AND (CATGRPTPC.STORE_ID IN ($STOREPATH:catalog$) OR CATGRPTPC.STORE_ID = 0 )
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete existing merchandising associations for the given source catalog entry
	and the store in the current context.
	
	@param catEntryId The catalog entry id
	@param storeId The store id
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_DeleteCatEntryAssociationsForSourceCatalogEntry
	base_table=MASSOCCECE
	sql=
		DELETE 
			FROM  MASSOCCECE
		WHERE
		MASSOCCECE.CATENTRY_ID_FROM=?catEntryId?
		AND STORE_ID=?storeId?
END_SQL_STATEMENT


<!-- ====================================================================== 
	Delete existing merchandising associations for the given target catalog entry
	and the store in the current context.
	
	@param catEntryId The catalog entry id
	@param storeId The store id	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_DeleteCatEntryAssociationsForTargetCatalogEntry
	base_table=MASSOCCECE
	sql=
		DELETE 
			FROM  MASSOCCECE
		WHERE
		MASSOCCECE.CATENTRY_ID_TO=?catEntryId?
		AND STORE_ID=?storeId? 
END_SQL_STATEMENT



<!-- ====================================================================== 
	Update the data type of descriptions for the given attribute dictionary attribute.
	
	@param attrDataTypeID The data type ID value to be set.
	@param attrID The ID of the attribute dictionary attribute.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_AttributeDicionaryAttribute_DescriptionsDataType
	base_table=ATTRDESC
	sql=
		UPDATE  ATTRDESC
			set ATTRTYPE_ID=?attrDataTypeID?
		WHERE
			ATTRDESC.ATTR_ID=?attrID?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Set the previous default allowed value to be non default allowed value 
	by updating the usage of the allowed value.
	
	@param UniqueID The ID of the current default allowed value.
	@param attrID The ID of the attribute dictionary attribute whose allowed value usage needs to be set.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_AttributeDicionaryAttribute_OldDefaultAllowedValue_Usage_NonDefault
	base_table=ATTRVAL
	sql=
		UPDATE  ATTRVAL
			set VALUSAGE = 1
		WHERE
			ATTRVAL.ATTR_ID=?attrID? 
			AND	ATTRVAL.ATTRVAL_ID <> ?UniqueID? 
			AND	VALUSAGE = 2
END_SQL_STATEMENT


<!-- ====================================================================== 
	Set the previous default allowed value to be non default allowed value 
	by updating the usage of the allowed value descriptions.
	
	@param UniqueID The ID of the current default allowed value.
	@param attrID The ID of the attribute dictionary attribute whose allowed value description usage needs to be set.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_AttributeDicionaryAttribute_OldDefaultAllowedValueDescription_Usage_NonDefault
	base_table=ATTRVALDESC
	sql=
		UPDATE  ATTRVALDESC
			set VALUSAGE = 1
		WHERE
			ATTRVALDESC.ATTR_ID = ?attrID? 
			AND ATTRVALDESC.ATTRVAL_ID <> ?UniqueID? 
			AND VALUSAGE = 2
END_SQL_STATEMENT



<!-- ========================================================================= -->
<!--  Check for delta or full update from the catalog entry delta update table -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_DELTA_INDEXING
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT TI_DELTA_CATENTRY.MASTERCATALOG_ID,
		   TI_DELTA_CATENTRY.CATENTRY_ID,
		   TI_DELTA_CATENTRY.ACTION
	  FROM TI_DELTA_CATENTRY
	 WHERE (TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?
	 	    AND TI_DELTA_CATENTRY.CATENTRY_ID = ?catalogEntryId?
		    AND TI_DELTA_CATENTRY.ACTION = 'U')
	    OR (TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?
		    AND TI_DELTA_CATENTRY.ACTION = 'F')			
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Check for only full update from the catalog entry delta update table     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_FULL_INDEXING
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT TI_DELTA_CATENTRY.MASTERCATALOG_ID,
		   TI_DELTA_CATENTRY.CATENTRY_ID,
		   TI_DELTA_CATENTRY.ACTION
	  FROM TI_DELTA_CATENTRY
	 WHERE TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATENTRY.ACTION = 'F'	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Check for any action from the catalog entry delta update table           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_ANY_INDEXING
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT TI_DELTA_CATENTRY.MASTERCATALOG_ID,
		   TI_DELTA_CATENTRY.CATENTRY_ID,
		   TI_DELTA_CATENTRY.ACTION
	  FROM TI_DELTA_CATENTRY
	 WHERE TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Determine if indexing is being performed                                 -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IS_PERFORMING_INDEXING
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT TI_DELTA_CATENTRY.CATENTRY_ID, TI_DELTA_CATENTRY.LASTUPDATE 
	  FROM TI_DELTA_CATENTRY
	 WHERE TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATENTRY.ACTION = 'P'
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Delete a row into the catalog entry delta update table                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_TI_DELTA_CATENTRY
	base_table=TI_DELTA_CATENTRY
	sql=
	DELETE FROM TI_DELTA_CATENTRY
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
       AND ACTION IN (?action?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Insert a row into the catalog entry delta update table                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_TI_DELTA_CATENTRY
	base_table=TI_DELTA_CATENTRY
	sql=
	INSERT INTO TI_DELTA_CATENTRY (MASTERCATALOG_ID, CATENTRY_ID, ACTION) 
	VALUES (?masterCatalogId?, ?catalogEntryId?, ?action?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Select a scope from search configuration table                           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHCONF
	base_table=SRCHCONF
	sql=
	SELECT SRCHCONF.LANGUAGES,
		   SRCHCONF.CONFIG
	  FROM SRCHCONF
	 WHERE SRCHCONF.INDEXTYPE = ?indexType?
	   AND SRCHCONF.INDEXSCOPE = ?masterCatalogId?	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Select all scopes from search configuration table                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ALL_SRCHCONF
	base_table=SRCHCONF
	sql=
	SELECT DISTINCT SRCHCONF.INDEXSCOPE
	  FROM SRCHCONF
	 WHERE SRCHCONF.INDEXTYPE = ?indexType?	
END_SQL_STATEMENT



<!-- ========================================================================= -->
<!--  Insert search related statistics                                         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Admin_Insert_InsertSearchStatistics
    base_table=SRCHSTAT
    dbtype=any
	sql=
    INSERT INTO SRCHSTAT
           (SRCHSTAT_ID, KEYWORD, LANGUAGE_ID, STOREENT_ID, CATALOG_ID, KEYWORDCOUNT, SEARCHCOUNT, SUGGESTIONCOUNT, SUGGESTION, LOGDETAIL, LOGDATE)
    VALUES (?SRCHSTAT_ID?, ?KEYWORD?, ?LANGUAGE_ID?, ?STOREENT_ID?, ?CATALOG_ID?, ?KEYWORDCOUNT?, ?SEARCHCOUNT?, ?SUGGESTIONCOUNT?, ?SUGGESTION?, ?LOGDETAIL?, ?LOGDATE?)
	dbtype=oracle
	sql=
    INSERT INTO SRCHSTAT
           (SRCHSTAT_ID, KEYWORD, LANGUAGE_ID, STOREENT_ID, CATALOG_ID, KEYWORDCOUNT, SEARCHCOUNT, SUGGESTIONCOUNT, SUGGESTION, LOGDETAIL, LOGDATE)
    VALUES (?SRCHSTAT_ID?, ?KEYWORD?, ?LANGUAGE_ID?, ?STOREENT_ID?, ?CATALOG_ID?, ?KEYWORDCOUNT?, ?SEARCHCOUNT?, ?SUGGESTIONCOUNT?, ?SUGGESTION?, ?LOGDETAIL?, TO_TIMESTAMP(?LOGDATE?, 'YYYY-MM-DD hh24:mi:ss.ff'))
	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Check for delta or full update from the catalog group delta update table -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_DELTA_CATGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT TI_DELTA_CATGROUP.MASTERCATALOG_ID,
		   TI_DELTA_CATGROUP.CATGROUP_ID,
		   TI_DELTA_CATGROUP.ACTION
	  FROM TI_DELTA_CATGROUP
	 WHERE (TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?
	 	    AND TI_DELTA_CATGROUP.CATGROUP_ID = ?catalogGroupId?
		    AND TI_DELTA_CATGROUP.ACTION = 'U')
	    OR (TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?
		    AND TI_DELTA_CATGROUP.ACTION = 'F')			
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Check for only full update from the catalog group delta update table     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_FULL_CATGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT TI_DELTA_CATGROUP.MASTERCATALOG_ID,
		   TI_DELTA_CATGROUP.CATGROUP_ID,
		   TI_DELTA_CATGROUP.ACTION
	  FROM TI_DELTA_CATGROUP
	 WHERE TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATGROUP.ACTION = 'F'	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Check for any action from the catalog group delta update table           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_ANY_CATGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT TI_DELTA_CATGROUP.MASTERCATALOG_ID,
		   TI_DELTA_CATGROUP.CATGROUP_ID,
		   TI_DELTA_CATGROUP.ACTION
	  FROM TI_DELTA_CATGROUP
	 WHERE TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Count any action from the catalog entry delta update table               -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=COUNT_ANY_CATENTRY_INDEXING
	base_table=TI_DELTA_CATENTRY
	
	dbtype=oracle
	sql=
	SELECT COUNT (*) as ROWCOUNT FROM (SELECT CATENTRY_ID FROM TI_DELTA_CATENTRY 
	  WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P', 'B', 'Q', 'R') AND ROWNUM =1)
	  
	dbtype=db2
	sql=
	SELECT COUNT (*) as ROWCOUNT FROM (SELECT CATENTRY_ID FROM TI_DELTA_CATENTRY 
	WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P', 'B', 'Q', 'R') FETCH FIRST 1 ROWS ONLY)
	
	sql=
	SELECT COUNT(*) as ROWCOUNT FROM TI_DELTA_CATENTRY 
	WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P','Q','B','R') 
	
	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Count any action from the catalog group delta update table               -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=COUNT_ANY_CATGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	dbtype=oracle
	sql=
	SELECT COUNT (*) as ROWCOUNT FROM (SELECT CATGROUP_ID FROM TI_DELTA_CATGROUP 
	  WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P', 'B', 'Q', 'R') AND ROWNUM =1)
	  
	dbtype=db2
	sql=
	SELECT COUNT (*) as ROWCOUNT FROM (SELECT CATGROUP_ID FROM TI_DELTA_CATGROUP 
	WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P', 'B', 'Q', 'R') FETCH FIRST 1 ROWS ONLY)
	
	sql=
	SELECT COUNT(*) as ROWCOUNT FROM TI_DELTA_CATGROUP 
	WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P','Q','B','R') 
	
	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Determine if indexing is being performed                                 -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IS_PERFORMING_CATGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT TI_DELTA_CATGROUP.CATGROUP_ID, TI_DELTA_CATGROUP.LASTUPDATE 
	  FROM TI_DELTA_CATGROUP
	 WHERE TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATGROUP.ACTION = 'P'
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Delete a row into the catalog group delta update table                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_TI_DELTA_CATGROUP
	base_table=TI_DELTA_CATGROUP
	sql=
	DELETE FROM TI_DELTA_CATGROUP
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
       AND ACTION IN (?action?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Insert a row into the catalog group delta update table                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_TI_DELTA_CATGROUP
	base_table=TI_DELTA_CATGROUP
	sql=
	INSERT INTO TI_DELTA_CATGROUP (MASTERCATALOG_ID, CATGROUP_ID, ACTION) 
	VALUES (?masterCatalogId?, ?catalogGroupId?, ?action?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Find catalog entry in TI_DELTA_CATENTRY table                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_TI_DELTA_CATENTRY
	base_table=TI_DELTA_CATENTRY
	sql=
    SELECT ACTION FROM TI_DELTA_CATENTRY
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATENTRY_ID = ?catalogEntryId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Find catalog group in TI_DELTA_CATGROUP table                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_TI_DELTA_CATGROUP
	base_table=TI_DELTA_CATGROUP
	sql=
    SELECT ACTION FROM TI_DELTA_CATGROUP
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATGROUP_ID = ?catalogGroupId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Update catalog entry in TI_DELTA_CATENTRY table                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_TI_DELTA_CATENTRY
	base_table=TI_DELTA_CATENTRY
	sql=
    UPDATE TI_DELTA_CATENTRY
       SET ACTION = ?action?
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATENTRY_ID = ?catalogEntryId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Update catalog group in TI_DELTA_CATGROUP table                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_TI_DELTA_CATGROUP
	base_table=TI_DELTA_CATGROUP
	sql=
    UPDATE TI_DELTA_CATGROUP
       SET ACTION = ?action?
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATGROUP_ID = ?catalogGroupId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Determine immediate parent category for cache invalidation on product    -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_PARENT_CATEGORY_FOR_PRODUCT
	base_table=CATGPENREL
	sql=
	SELECT CATGROUP_ID, CATALOG_ID
	  FROM CATGPENREL
	 WHERE CATENTRY_ID IN (?catalogEntryId?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Determine immediate parent category for cache invalidation on category   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_PARENT_CATEGORY_FOR_CATEGORY
	base_table=CATGRPREL
	sql=
	SELECT CATGROUP_ID_PARENT, CATALOG_ID
	  FROM CATGRPREL
	 WHERE CATGROUP_ID_CHILD IN (?catalogGroupId?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Insert a row into the cache invalidation table                           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_CACHEIVL
	base_table=CACHEIVL
	sql=
	INSERT INTO CACHEIVL (DATAID, INSERTTIME) 
	VALUES (?dataId?, ?insertTime?)
	dbtype=oracle
	sql=
    INSERT INTO CACHEIVL (DATAID, INSERTTIME)
	VALUES (?dataId?, TO_TIMESTAMP(?insertTime?, 'YYYY-MM-DD hh24:mi:ss.ff'))
END_SQL_STATEMENT



<!-- ========================================================================= -->
<!--  Retrieve the owning store of a product                                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_STORECENT_WORKSPACE
	base_table=STORECENT
	sql=
		SELECT STOREENT_ID
		  FROM $SCHEMA$.STORECENT 
		 WHERE CATENTRY_ID = ?catEntryId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Retrieve the owning store of a category                                  -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_STORECGRP_WORKSPACE
	base_table=STORECGRP
	sql=
		SELECT STOREENT_ID
		  FROM $SCHEMA$.STORECGRP 
		 WHERE CATGROUP_ID = ?catGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Count any action from the catalog entry delta update table               -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=COUNT_ANY_CATENTRY_INDEXING_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	dbtype=oracle
	sql=
	SELECT COUNT (*) as ROWCOUNT FROM (SELECT CATENTRY_ID FROM $SCHEMA$.TI_DELTA_CATENTRY 
	  WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P', 'B', 'Q', 'R') AND ROWNUM =1)
	  
	dbtype=db2
	sql=
	SELECT COUNT (*) as ROWCOUNT FROM (SELECT CATENTRY_ID FROM $SCHEMA$.TI_DELTA_CATENTRY 
	WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P', 'B', 'Q', 'R') FETCH FIRST 1 ROWS ONLY)
	
	sql=
	SELECT COUNT(*) as ROWCOUNT FROM $SCHEMA$.TI_DELTA_CATENTRY 
	WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P','Q','B','R') 
	
	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Count any action from the catalog group delta update table               -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=COUNT_ANY_CATGROUP_INDEXING_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	dbtype=oracle
	sql=
	SELECT COUNT (*) as ROWCOUNT FROM (SELECT CATGROUP_ID FROM $SCHEMA$.TI_DELTA_CATGROUP 
	  WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P', 'B', 'Q', 'R') AND ROWNUM =1)
	  
	dbtype=db2
	sql=
	SELECT COUNT (*) as ROWCOUNT FROM (SELECT CATGROUP_ID FROM $SCHEMA$.TI_DELTA_CATGROUP 
	  WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P', 'B', 'Q', 'R') FETCH FIRST 1 ROWS ONLY)
	
	sql=
	SELECT COUNT(*) as ROWCOUNT FROM $SCHEMA$.TI_DELTA_CATGROUP 
	WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION NOT IN ('P','Q','B','R') 
	
	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for delta or full update from the catalog entry delta update table -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_DELTA_INDEXING_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT MASTERCATALOG_ID,
		   CATENTRY_ID,
		   ACTION
	  FROM $SCHEMA$.TI_DELTA_CATENTRY
	 WHERE (MASTERCATALOG_ID = ?masterCatalogId?
	 	    AND CATENTRY_ID = ?catalogEntryId?
		    AND ACTION = 'U')
	    OR (MASTERCATALOG_ID = ?masterCatalogId?
		    AND ACTION = 'F')			
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for only full update from the catalog entry delta update table     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_FULL_INDEXING_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT MASTERCATALOG_ID,
		   CATENTRY_ID,
		   ACTION
	  FROM $SCHEMA$.TI_DELTA_CATENTRY
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
       AND ACTION = 'F'	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for any action from the catalog entry delta update table           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_ANY_INDEXING_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT MASTERCATALOG_ID,
		   CATENTRY_ID,
		   ACTION
	  FROM $SCHEMA$.TI_DELTA_CATENTRY
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if indexing in the given schema is being performed             -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IS_PERFORMING_INDEXING_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT CATENTRY_ID, LASTUPDATE
	  FROM $SCHEMA$.TI_DELTA_CATENTRY
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
       AND ACTION = 'P'
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if indexing in the given schema is being performed             -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IS_PERFORMING_CATGROUP_INDEXING_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT CATGROUP_ID, LASTUPDATE
	  FROM $SCHEMA$.TI_DELTA_CATGROUP
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
       AND ACTION = 'P'
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for delta or full update from the catalog group delta update table -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_DELTA_CATGROUP_INDEXING_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT MASTERCATALOG_ID,
		   CATGROUP_ID,
		   ACTION
	  FROM $SCHEMA$.TI_DELTA_CATGROUP
	 WHERE (MASTERCATALOG_ID = ?masterCatalogId?
	 	    AND CATGROUP_ID = ?catalogGroupId?
		    AND ACTION = 'U')
	    OR (MASTERCATALOG_ID = ?masterCatalogId?
		    AND ACTION = 'F')			
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for only full update from the catalog group delta update table     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_FULL_CATGROUP_INDEXING_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT MASTERCATALOG_ID,
		   CATGROUP_ID,
		   ACTION
	  FROM $SCHEMA$.TI_DELTA_CATGROUP
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
       AND ACTION = 'F'	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for any action from the catalog group delta update table           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_ANY_CATGROUP_INDEXING_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT MASTERCATALOG_ID,
		   CATGROUP_ID,
		   ACTION
	  FROM $SCHEMA$.TI_DELTA_CATGROUP
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the lastest update from TI_CATENTRY_WS table                         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=GET_MAXMUM_LASTUPDATE_FROM_CATENTRY_WS
	base_table=TI_CATENTRY_WS
	sql=
	SELECT max(lastupdate) as lastupdate
	  FROM TI_CATENTRY_WS
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the lastest update from TI_CATGROUP_WS table                         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=GET_MAXMUM_LASTUPDATE_FROM_CATGROUP_WS
	base_table=TI_CATGROUP_WS
	sql=
	SELECT max(lastupdate) as lastupdate
	  FROM TI_CATGROUP_WS
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Undo catalog entry in TI_DELTA_CATENTRY table                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=RESET_TI_DELTA_CATENTRY
	base_table=TI_DELTA_CATENTRY
	sql=
    DELETE FROM $SCHEMA$.TI_DELTA_CATENTRY
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATENTRY_ID = ?catalogEntryId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Undo catalog entry in TI_DELTA_CATGROUP table                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=RESET_TI_DELTA_CATGROUP
	base_table=TI_DELTA_CATGROUP
	sql=
    DELETE FROM $SCHEMA$.TI_DELTA_CATGROUP
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATGROUP_ID = ?catalogGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select a row from the catalog entry workspace table                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_TI_CATENTRY_WS
	base_table=TI_CATENTRY_WS
	sql=
	SELECT LASTUPDATE 
	FROM $SCHEMA$.TI_CATENTRY_WS
	WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	and CATENTRY_ID = ?catalogEntryId?
	and TASKGROUP = ?taskGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select a row from the catalog group workspace table                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_TI_CATGROUP_WS
	base_table=TI_CATGROUP_WS
	sql=
	SELECT LASTUPDATE
	FROM $SCHEMA$.TI_CATGROUP_WS
	WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	and CATGROUP_ID = ?catalogGroupId?
	and TASKGROUP = ?taskGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert a row into the catalog entry workspace table                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_TI_CATENTRY_WS
	base_table=TI_CATENTRY_WS
	sql=
	INSERT INTO $SCHEMA$.TI_CATENTRY_WS 
	(MASTERCATALOG_ID, CATENTRY_ID, LASTUPDATE, TASKGROUP, ACTION, CONTENT_BASE) 
	VALUES 
	(?masterCatalogId?, ?catalogEntryId?, ?lastupdate?, ?taskGroupId?, ?action?, 1)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert a row into the catalog group workspace table                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_TI_CATGROUP_WS
	base_table=TI_CATGROUP_WS
	sql=
	INSERT INTO $SCHEMA$.TI_CATGROUP_WS 
	(MASTERCATALOG_ID, CATGROUP_ID, LASTUPDATE, TASKGROUP, ACTION, CONTENT_BASE) 
	VALUES 
	(?masterCatalogId?, ?catalogGroupId?, ?lastupdate?, ?taskGroupId?, ?action?, 1)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Update a row in the catalog entry workspace table                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_TI_CATENTRY_WS
	base_table=TI_CATENTRY_WS
	sql=
	UPDATE $SCHEMA$.TI_CATENTRY_WS SET LASTUPDATE = ?lastupdate?, ACTION = ?action?
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
	   AND CATENTRY_ID = ?catalogEntryId? 
	   AND TASKGROUP = ?taskGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Update a row in the catalog group workspace table                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_TI_CATGROUP_WS
	base_table=TI_CATGROUP_WS
	sql=
	UPDATE $SCHEMA$.TI_CATGROUP_WS SET LASTUPDATE = ?lastupdate?, ACTION = ?action? 
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
	   AND CATGROUP_ID = ?catalogGroupId? 
	   AND TASKGROUP = ?taskGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete a row from the catalog entry workspace table                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_TI_CATENTRY_WS
	base_table=TI_CATENTRY_WS
	sql=
	DELETE FROM $SCHEMA$.TI_CATENTRY_WS where MASTERCATALOG_ID = ?masterCatalogId? 
	and CATENTRY_ID = ?catalogEntryId?
	and TASKGROUP = ?taskGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete a row from the catalog group workspace table                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_TI_CATGROUP_WS
	base_table=TI_CATGROUP_WS
	sql=
	DELETE FROM $SCHEMA$.TI_CATGROUP_WS where MASTERCATALOG_ID = ?masterCatalogId? 
	and CATGROUP_ID = ?catalogGroupId?
	and TASKGROUP = ?taskGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select rows from the catalog entry workspace table by catalog entry      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_BY_CATENTRY_TI_CATENTRY_WS
	base_table=TI_CATENTRY_WS
	sql=
	SELECT ACTION, TASKGROUP 
	FROM $SCHEMA$.TI_CATENTRY_WS
	WHERE MASTERCATALOG_ID = ?masterCatalogId?
	and	CATENTRY_ID = ?catalogEntryId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select rows from the catalog group workspace table by catalog group      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_BY_CATGROUP_TI_CATGROUP_WS
	base_table=TI_CATGROUP_WS
	sql=
	SELECT ACTION, TASKGROUP 
	FROM $SCHEMA$.TI_CATGROUP_WS
	WHERE MASTERCATALOG_ID = ?masterCatalogId?
	and	CATGROUP_ID = ?catalogGroupId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Select rows from the catalog group workspace table by taskgroup          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_BY_TASKGROUP_TI_CATGROUP_WS
	base_table=TI_CATGROUP_WS
	sql=
	SELECT CATGROUP_ID, MASTERCATALOG_ID, ACTION
	FROM $SCHEMA$.TI_CATGROUP_WS where 
	TASKGROUP = ?taskGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select masterCatalogs from the catalog entry workspace table          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CATALOG_ID_TI_CATENTRY_WS
	base_table=TI_CATENTRY_WS
	sql=
	SELECT DISTINCT MASTERCATALOG_ID
	FROM $SCHEMA$.TI_CATENTRY_WS
	WHERE TASKGROUP = ?taskGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select masterCatalogs from the catalog group workspace table             -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CATALOG_ID_TI_CATGROUP_WS
	base_table=TI_CATGROUP_WS
	sql=
	SELECT DISTINCT MASTERCATALOG_ID
	FROM $SCHEMA$.TI_CATGROUP_WS
	WHERE TASKGROUP = ?taskGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select all rows from the catalog entry workspace table by master catalog -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_MASTERCATALOG_ID_TI_CATENTRY_WS
	base_table=TI_CATENTRY_WS
	sql=
	SELECT CATENTRY_ID, ACTION, TASKGROUP
	FROM $SCHEMA$.TI_CATENTRY_WS
	WHERE MASTERCATALOG_ID = ?masterCatalogId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select all rows from the catalog group workspace table by master catalog -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_MASTERCATALOG_ID_TI_CATGROUP_WS
	base_table=TI_CATGROUP_WS
	sql=
	SELECT CATGROUP_ID, ACTION, TASKGROUP
	FROM $SCHEMA$.TI_CATGROUP_WS
	WHERE MASTERCATALOG_ID = ?masterCatalogId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete rows from the catalog entry workspace table by taskgroup          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_BY_TASKGROUP_TI_CATENTRY_WS
	base_table=TI_CATENTRY_WS
	sql=
	DELETE FROM $SCHEMA$.TI_CATENTRY_WS where TASKGROUP = ?taskGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete rows from the catalog group workspace table by taskgroup          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_BY_TASKGROUP_TI_CATGROUP_WS
	base_table=TI_CATGROUP_WS
	sql=
	DELETE FROM $SCHEMA$.TI_CATGROUP_WS where TASKGROUP = ?taskGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert a row into the catalog entry delta update workspace table         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_TI_DELTA_CATENTRY_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
	INSERT INTO $SCHEMA$.TI_DELTA_CATENTRY (MASTERCATALOG_ID, CATENTRY_ID, ACTION, LASTUPDATE, CONTENT_BASE) 
	VALUES (?masterCatalogId?, ?catalogEntryId?, ?action?, ?lastupdate?, 1)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert a row into the catalog group delta update workspace table         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_TI_DELTA_CATGROUP_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
	INSERT INTO $SCHEMA$.TI_DELTA_CATGROUP (MASTERCATALOG_ID, CATGROUP_ID, ACTION, LASTUPDATE, CONTENT_BASE) 
	VALUES (?masterCatalogId?, ?catalogGroupId?, ?action?, ?lastupdate?, 1)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Find catalog entry in TI_DELTA_CATENTRY table                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_TI_DELTA_CATENTRY_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
    SELECT ACTION 
    FROM $SCHEMA$.TI_DELTA_CATENTRY
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATENTRY_ID = ?catalogEntryId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Find catalog group in TI_DELTA_CATGROUP table                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_TI_DELTA_CATGROUP_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
    SELECT ACTION 
    FROM $SCHEMA$.TI_DELTA_CATGROUP
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATGROUP_ID = ?catalogGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Update catalog entry in TI_DELTA_CATENTRY table                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_TI_DELTA_CATENTRY_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
    UPDATE $SCHEMA$.TI_DELTA_CATENTRY
       SET ACTION = ?action?
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATENTRY_ID = ?catalogEntryId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Update catalog group in TI_DELTA_CATGROUP table                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_TI_DELTA_CATGROUP_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
    UPDATE $SCHEMA$.TI_DELTA_CATGROUP
       SET ACTION = ?action?
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATGROUP_ID = ?catalogGroupId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete a row into the catalog entry delta update table                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_TI_DELTA_CATENTRY_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
	DELETE FROM $SCHEMA$.TI_DELTA_CATENTRY
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
       AND ACTION IN (?action?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete a row into the catalog group delta update table                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_TI_DELTA_CATGROUP_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
	DELETE FROM $SCHEMA$.TI_DELTA_CATGROUP
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
       AND ACTION IN (?action?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Deep search for catentried and categroups.                               -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DEEP_SELECT_CATENTRIES_FOR_CATGROUP
	base_table=CATGROUP
	dbtype=any
	sql=
		WITH CATEGORY (CATGROUP_ID) AS (
			SELECT 
				DISTINCT CATGROUP.CATGROUP_ID CATGROUP_ID 
			FROM 
				CATGROUP 
			WHERE 
				CATGROUP.CATGROUP_ID=?catalogGroupId? 
			UNION ALL 
			SELECT  
				CATGRPREL.CATGROUP_ID_CHILD 
			FROM 
				CATEGORY, CATGRPREL 
			WHERE 
				CATEGORY.CATGROUP_ID = CATGRPREL.CATGROUP_ID_PARENT 
				AND 
				CATGRPREL.CATALOG_ID=?masterCatalogId?	
		)
		SELECT 
			CATGROUP.CATGROUP_ID, CATGPENREL.CATENTRY_ID
		FROM 
		    CATEGORY, CATGPENREL, CATGROUP
		WHERE 
            CATEGORY.CATGROUP_ID = CATGROUP.CATGROUP_ID
            AND
            CATGPENREL.CATGROUP_ID = CATEGORY.CATGROUP_ID 
            AND 
            CATGPENREL.CATALOG_ID =?masterCatalogId?	
            AND
            CATGROUP.MARKFORDELETE=0 

	dbtype=oracle
	sql=
		WITH CATEGORY AS (
			SELECT 
				DISTINCT CATGROUP.CATGROUP_ID CATGROUP_ID 
			FROM 
				CATGROUP 
			WHERE 
				CATGROUP.CATGROUP_ID=?catalogGroupId?
			AND
				MARKFORDELETE=0
			UNION ALL 
			SELECT 
				CATGRPREL.CATGROUP_ID_CHILD CATGROUP_ID
			FROM 
				CATGRPREL, CATGROUP
			WHERE 
				CATGRPREL.CATGROUP_ID_CHILD = CATGROUP.CATGROUP_ID
			AND
				CATGROUP.MARKFORDELETE=0
			AND
				CATGRPREL.CATALOG_ID=?masterCatalogId?
			START WITH 
				CATGRPREL.CATGROUP_ID_PARENT=?catalogGroupId?
			CONNECT BY PRIOR 
				CATGRPREL.CATGROUP_ID_CHILD = CATGRPREL.CATGROUP_ID_PARENT	
		) 
		SELECT 
			CATEGORY.CATGROUP_ID, CATGPENREL.CATENTRY_ID
		FROM 
		    CATEGORY, CATGPENREL
		WHERE 
            CATGPENREL.CATGROUP_ID = CATEGORY.CATGROUP_ID 
            AND 
            CATGPENREL.CATALOG_ID =?masterCatalogId?	
			
	dbtype=derby
    sql=
    	SELECT
    		CATGROUP.CATGROUP_ID, CATGPENREL.CATENTRY_ID
		FROM
   			CATGPENREL, CATGROUP
		WHERE
    		CATGPENREL.CATGROUP_ID=CATGROUP.CATGROUP_ID
		AND 
			CATGPENREL.CATALOG_ID=?masterCatalogId?
		AND 
			CATGROUP.CATGROUP_ID IN (?catalogGroupId?)
		AND 
			CATGROUP.MARKFORDELETE=0
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine all facetable columns registered for search                    -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CATEGORY_FACET_OVERRIDE
	base_table=FACETCATGRP
	sql=
	SELECT FACETCATGRP.SEQUENCE,FACETCATGRP.STOREENT_ID,FACETCATGRP.DISPLAYABLE,SRCHATTRPROP.PROPERTYVALUE, FACETCATGRP.CATGROUP_ID
	from FACETCATGRP, FACET, SRCHATTRPROP
	where  FACET.FACET_ID=FACETCATGRP.FACET_ID and 
		  FACET.SRCHATTR_ID=SRCHATTRPROP.SRCHATTR_ID and 
		  CATGROUP_ID IN (?categoryId?,0) and 
		  FACETCATGRP.storeent_id IN (?storeList?) and 
		  SRCHATTRPROP.PROPERTYNAME IN ('facet','facet-classicAttribute','facet-category','facet-range') 
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=SELECT_CATEGORY_FACET_OVERRIDE_WORKSPACE
	base_table=FACETCATGRP
	sql=
	SELECT FCG.SEQUENCE, FCG.STOREENT_ID, FCG.DISPLAYABLE, SAP.PROPERTYVALUE
	from $SCHEMA$.FACETCATGRP FCG, $SCHEMA$.FACET F, $SCHEMA$.SRCHATTRPROP SAP
	where  F.FACET_ID=FCG.FACET_ID and 
		  F.SRCHATTR_ID=SAP.SRCHATTR_ID and 
		  FCG.CATGROUP_ID=?categoryId? and 
		  FCG.storeent_id IN (?storeList?) and 
		  SAP.PROPERTYNAME IN ('facet','facet-classicAttribute','facet-category','facet-range')
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if a facet exists (via facet_id in FACET table)                -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_FACET_RECORD
	base_table=FACET
	sql=
	SELECT FACET_ID
	from FACET
	where FACET_ID=?facetId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the catalog entries associated with an attribute dictionary    -->
<!--  attribute.                                                               -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CATENTRY_FOR_ATTRIBUTE_DICTIONARY_ATTRIBUTE
	base_table=CATENTRYATTR
	sql=
	SELECT CATENTRY_ID
	from CATENTRYATTR
	where ATTR_ID=?attrId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the catalog entries associated with an attribute dictionary    -->
<!--  attribute.                                                               -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CATENTRY_FOR_ATTRIBUTE_DICTIONARY_ATTRIBUTE_WORKSPACE
	base_table=CATENTRYATTR
	sql=
	SELECT CATENTRY_ID
	from $SCHEMA$.CATENTRYATTR
	where ATTR_ID=?attrId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the facet information                                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_FACETABLE_INFORMATION_FOR_KEYWORD_SEARCH
	base_table=FACET
	sql=
	select 
	srchattr.srchattr_id as srchattr_id,
	srchattrprop.propertyname as propertyname,
	srchattrprop.propertyvalue as propertyvalue,
	srchattr.identifier as srchattridentifier,
	facet.facet_id as facet_id,
	facet.attr_id as attr_id,
	facet.selection as selection,
	facet.keyword_search as keyword_search,
	facet.zero_display as zero_display,
	facet.storeent_id as storeent_id,
	facet.max_display as max_display,
	facet.sequence as sequence,
	facet.group_id as group_id,
	facet.sort_order as sort_order,
	facet.field1 as ffield1,
	facet.field2 as ffield2,
	facet.field3 as ffield3,
	facetdesc.name as fname,
	facetdesc.language_id as flang,
	facetdesc.description as fdesc,
	facetdesc.field1 as fdescfield1,
	facetdesc.field2 as fdescfield2,
	facetdesc.field3 as fdescfield3,
	attr.identifier as attridentifier,
	attr.attrtype_id as attrtype,
	attr.sequence as attrsequence,
	attr.facetable as facetable,
	attrdesc.name as attrname,
	attrdesc.language_id as attrlang,
	attrdesc.description as attrdesc 
	from srchattrprop 
	JOIN srchattr ON srchattrprop.srchattr_id=srchattr.srchattr_id 
	JOIN facet ON facet.srchattr_id=srchattr.srchattr_id 
	LEFT JOIN facetdesc ON facet.facet_id=facetdesc.facet_id and facetdesc.language_id=?languageId?
	LEFT JOIN attr on facet.attr_id=attr.attr_id 
	LEFT JOIN attrdesc on attr.attr_id=attrdesc.attr_id and attrdesc.language_id=?languageId?
	where 
	facet.keyword_search=1 and
	srchattr.indextype=?indexType? and 
	srchattrprop.propertyname IN ('facet','facet-classicAttribute','facet-category','facet-range') and 
	facet.storeent_id IN (?storeList?)
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=SELECT_FACETABLE_INFORMATION_FOR_KEYWORD_SEARCH_WORKSPACE
	base_table=FACET
	sql=
	select 
	SA.srchattr_id as srchattr_id,
	SAP.propertyname as propertyname,
	SAP.propertyvalue as propertyvalue,
	SA.identifier as srchattridentifier,
	F.facet_id as facet_id,
	F.attr_id as attr_id,
	F.selection as selection,
	F.keyword_search as keyword_search,
	F.zero_display as zero_display,
	F.storeent_id as storeent_id,
	F.max_display as max_display,
	F.sequence as sequence,
	F.group_id as group_id,
	F.sort_order as sort_order,
	F.field1 as ffield1,
	F.field2 as ffield2,
	F.field3 as ffield3,
	FD.name as fname,
	FD.language_id as flang,
	FD.description as fdesc,
	FD.field1 as fdescfield1,
	FD.field2 as fdescfield2,
	FD.field3 as fdescfield3,
	A.identifier as attridentifier,
	A.attrtype_id as attrtype,
	A.sequence as attrsequence,
	A.facetable as facetable,
	AD.name as attrname,
	AD.language_id as attrlang,
	AD.description as attrdesc 
	from $SCHEMA$.srchattrprop SAP
	JOIN $SCHEMA$.srchattr SA ON SAP.srchattr_id=SA.srchattr_id 
	JOIN $SCHEMA$.facet F ON F.srchattr_id=SA.srchattr_id 
	LEFT JOIN $SCHEMA$.facetdesc FD ON F.facet_id=FD.facet_id and FD.language_id=?languageId?
	LEFT JOIN $SCHEMA$.attr A on F.attr_id=A.attr_id 
	LEFT JOIN $SCHEMA$.attrdesc AD on A.attr_id=AD.attr_id and AD.language_id=?languageId?
	where 
	F.keyword_search=1 and
	SA.indextype=?indexType? and 
	SAP.propertyname IN ('facet','facet-classicAttribute','facet-category','facet-range') and 
	F.storeent_id IN (?storeList?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the image and sequence of the facetable attribute values       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_FACET_VALUE_IMAGE_AND_SEQUENCE
	base_table=ATTRDICTSRCHCONF
	sql=
	select distinct ADSC.SRCHFIELDNAME, AVD.value, AV.storeent_id, AVD.sequence, AVD.image1, AVD.image2 
	from 
	  attrdictsrchconf ADSC, attr A, attrval AV, attrvaldesc AVD
	where 
	  ADSC.ATTR_ID is not NULL and  
	  ADSC.attr_id = A.attr_id and
	  ADSC.mastercatalog_id = ?catalogId? and
	  ADSC.srchfieldname in (?searchFieldName?) and
	  A.storeent_id in (?storeList?) and
	  A.facetable = 1 and
	  AV.attr_id = A.attr_id and
	  AV.storeent_id in (?storeList?) and
	  AV.attrval_id = AVD.attrval_id and
	  AVD.language_id = ?languageId?
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=SELECT_FACET_VALUE_IMAGE_AND_SEQUENCE_WORKSPACE
	base_table=ATTRDICTSRCHCONF
	sql=
	select distinct ADSC.SRCHFIELDNAME, AVD.value, AV.storeent_id, AVD.sequence, AVD.image1, AVD.image2 
	from 
	  $SCHEMA$.attrdictsrchconf ADSC, $SCHEMA$.attr A, $SCHEMA$.attrval AV, $SCHEMA$.attrvaldesc AVD
	where 
	  ADSC.ATTR_ID is not NULL and  
	  ADSC.attr_id = A.attr_id and
	  ADSC.mastercatalog_id = ?catalogId? and
	  ADSC.srchfieldname in (?searchFieldName?) and
	  A.storeent_id in (?storeList?) and
	  A.facetable = 1 and
	  AV.attr_id = A.attr_id and
	  AV.storeent_id in (?storeList?) and
	  AV.attrval_id = AVD.attrval_id and
	  AVD.language_id = ?languageId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the facet configuration for a list of search columns           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_FACET_CONFIGURATION_FOR_SEARCH_COLUMNS
	base_table=FACET
	sql=
	select propertyvalue, selection, sort_order, keyword_search, zero_display, max_display from 
	srchattrprop join facet on srchattrprop.srchattr_id=facet.srchattr_id 
	where propertyname in ('facet','facet-classicAttribute','facet-category','facet-range')
		and storeent_id in (?storeList?)
		and propertyvalue in (?propertyValueList?)
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=SELECT_FACET_CONFIGURATION_FOR_SEARCH_COLUMNS_WORKSPACE
	base_table=FACET
	sql=
	select propertyvalue, selection, sort_order, keyword_search, zero_display, max_display from 
	$SCHEMA$.srchattrprop SAP join $SCHEMA$.facet F on SAP.srchattr_id=F.srchattr_id 
	where propertyname in ('facet','facet-classicAttribute','facet-category','facet-range')
		and storeent_id in (?storeList?)
		and propertyvalue in (?propertyValueList?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine an attribute is facetable or searchable                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTRIBUTE_STORE
	base_table=ATTR
	sql=
	select STOREENT_ID from ATTR
	 where ATTR_ID=?attributeId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine an attribute is facetable or searchable in workspace           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTRIBUTE_STORE_WORKSPACE
	base_table=ATTR
	sql=
	select STOREENT_ID 
	 from $SCHEMA$.ATTR
	 where ATTR_ID=?attributeId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the number of active workspaces                                -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ACTIVE_WORKSPACES
	base_table=CMWSSCHEMA
	sql=
	select WORKSPACE, READSCHEMA, WRITESCHEMA, BASESCHEMA
	from CMWSSCHEMA, CMFWKSPC
	WHERE IDENTIFIER = WORKSPACE
	and STATUS = 1
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the workspace schema name                                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=FIND_WORKSPACE_SCHEMA
	base_table=CMWSSCHEMA
	sql=
	select READSCHEMA, WRITESCHEMA, BASESCHEMA
	from CMWSSCHEMA
	WHERE WORKSPACE = ?workspaceId?
END_SQL_STATEMENT

<!-- ================================================================================================== -->
<!--  Fetch all attributes and related properties from SRCHATTR, SRCHATTRPROP, FACET, FACETCATGRP, ATTR -->
<!-- ================================================================================================== -->
BEGIN_SQL_STATEMENT
	<!--  -->
	name=IBM_Select_Search_Attributes_Properties
	base_table=SRCHATTR
	sql=
		SELECT SRCHATTR.INDEXTYPE, SRCHATTR.INDEXSCOPE, SRCHATTR.IDENTIFIER, SRCHATTRPROP.PROPERTYNAME, 
			SRCHATTRPROP.PROPERTYVALUE, SRCHATTR.SRCHATTR_ID, FACET.SELECTION, FACET.MAX_DISPLAY, FACET.GROUP_ID
		FROM SRCHATTR
		LEFT OUTER JOIN SRCHATTRPROP ON SRCHATTR.SRCHATTR_ID = SRCHATTRPROP.SRCHATTR_ID
		LEFT OUTER JOIN FACET ON SRCHATTR.SRCHATTR_ID = FACET.SRCHATTR_ID
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the order of facets for a given category                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_FACET_ORDER_FOR_CATEGORY_NAVIGATION
	base_table=FACET
	sql=
	SELECT FACET.SRCHATTR_ID, COALESCE(FACETCATGRP.SEQUENCE, FACET.SEQUENCE) SEQUENCE
	FROM FACET
	  LEFT OUTER JOIN FACETCATGRP ON FACET.FACET_ID = FACETCATGRP.FACET_ID 
	  		AND FACETCATGRP.CATGROUP_ID=?catalogGroupId?
	  		AND FACETCATGRP.STOREENT_ID in (?storeId?)
	WHERE FACET.SRCHATTR_ID IN (?srchAttrId?)
        ORDER BY SEQUENCE ASC
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=SELECT_FACET_ORDER_FOR_CATEGORY_NAVIGATION_WORKSPACE
	base_table=FACET
	sql=
	SELECT F.SRCHATTR_ID, COALESCE(FCG.SEQUENCE, F.SEQUENCE) SEQUENCE
	FROM $SCHEMA$.FACET F
	  LEFT OUTER JOIN $SCHEMA$.FACETCATGRP FCG ON F.FACET_ID = FCG.FACET_ID 
	  		AND FCG.CATGROUP_ID=?catalogGroupId?
	  		AND FCG.STOREENT_ID in (?storeId?) 
	WHERE F.SRCHATTR_ID IN (?srchAttrId?)
        ORDER BY SEQUENCE ASC
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the order of facets for keyword search                         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_FACET_ORDER_FOR_KEYWORD_SEARCH 
	base_table=FACET
	sql=
	SELECT FACET.SRCHATTR_ID, FACET.SEQUENCE
	FROM FACET
	WHERE FACET.SRCHATTR_ID IN (?srchAttrId?)
        ORDER BY SEQUENCE ASC
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=SELECT_FACET_ORDER_FOR_KEYWORD_SEARCH_WORKSPACE
	base_table=FACET
	sql=
	SELECT SRCHATTR_ID, SEQUENCE
	FROM $SCHEMA$.FACET
	WHERE SRCHATTR_ID IN (?srchAttrId?)
        ORDER BY SEQUENCE ASC
END_SQL_STATEMENT




<!-- ========================================================================= -->
<!--  Select from search attribute table                                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHATTR_IDENTIFIER
	base_table=SRCHATTR
	sql=
	SELECT IDENTIFIER from SRCHATTR where SRCHATTR_ID = ?srchattr_id?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select from search attribute table                                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHATTR_IDENTIFIER_WORKSPACE
	base_table=SRCHATTR
	sql=
	SELECT IDENTIFIER from $SCHEMA$.SRCHATTR where SRCHATTR_ID = ?srchattr_id?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select from search attribute table                                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHATTR_ID_BY_UNIQUE_INDEX
	base_table=SRCHATTR
	sql=
	SELECT SRCHATTR_ID from SRCHATTR where INDEXSCOPE = ?indexscope? 
		and INDEXTYPE = ?indextype? and IDENTIFIER = ?identifier?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To update srchattr identifier                                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_SRCHATTR_IDENTIFIER
	base_table=SRCHATTR
	sql=
	update srchattr set identifier = ?identifier? where srchattr_id IN (?srchattr_id?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To update srchattr identifier                                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_SRCHATTR_IDENTIFIER_WORKSPACE
	base_table=SRCHATTR
	sql=
	update $SCHEMA$.srchattr set identifier = ?identifier? where srchattr_id IN (?srchattr_id?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To insert into SRCHATTR table                                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_SRCHATTR
	base_table=SRCHATTR
	sql=
	INSERT INTO SRCHATTR (SRCHATTR_ID, INDEXSCOPE, INDEXTYPE, IDENTIFIER) VALUES
	(?srchattr_id?, ?indexScope?, ?indexType?, ?identifier?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To insert into SRCHATTR table                                            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_SRCHATTR_WORKSPACE
	base_table=SRCHATTR
	sql=
	INSERT INTO $SCHEMA$.SRCHATTR (SRCHATTR_ID, INDEXSCOPE, INDEXTYPE, IDENTIFIER) VALUES
	(?srchattr_id?, ?indexScope?, ?indexType?, ?identifier?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To insert into SRCHATTRPROP table                                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_SRCHATTRPROP
	base_table=SRCHATTRPROP
	sql=
	INSERT INTO SRCHATTRPROP (SRCHATTR_ID, PROPERTYNAME, PROPERTYVALUE) VALUES
	(?srchattr_id?, ?propertyName?, ?propertyValue?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To insert into SRCHATTRPROP table                                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_SRCHATTRPROP_WORKSPACE
	base_table=SRCHATTRPROP
	sql=
	INSERT INTO $SCHEMA$.SRCHATTRPROP (SRCHATTR_ID, PROPERTYNAME, PROPERTYVALUE) VALUES
	(?srchattr_id?, ?propertyName?, ?propertyValue?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To delete from SRCHATTRPROP table                                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_SRCHATTRPROP
	base_table=SRCHATTRPROP
	sql=
	DELETE FROM SRCHATTRPROP
	 WHERE SRCHATTR_ID = ?srchattr_id?
	   AND PROPERTYNAME = ?propertyName?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To select from SRCHATTRPROP table                                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHATTRPROP
	base_table=SRCHATTRPROP
	sql=
	SELECT PROPERTYVALUE
	  FROM SRCHATTRPROP
	 WHERE SRCHATTR_ID = ?srchattr_id?
	   AND PROPERTYNAME = ?propertyName?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the facet information                                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_FACETABLE_INFORMATION
	base_table=FACET
	sql=
	select 
	srchattr.srchattr_id as srchattr_id,
	srchattrprop.propertyname as propertyname,
	srchattrprop.propertyvalue as propertyvalue,
	srchattr.identifier as srchattridentifier,
	facet.facet_id as facet_id,
	facet.attr_id as attr_id,
	facet.selection as selection,
	facet.keyword_search as keyword_search,
	facet.zero_display as zero_display,
	facet.storeent_id as storeent_id,
	facet.max_display as max_display,
	facet.sequence as sequence,
	facet.sort_order as sort_order,
	facet.group_id as group_id,
	facet.field1 as ffield1,
	facet.field2 as ffield2,
	facet.field3 as ffield3,
	facetdesc.name as fname,
	facetdesc.language_id as flang,
	facetdesc.description as fdesc,
	facetdesc.field1 as fdescfield1,
	facetdesc.field2 as fdescfield2,
	facetdesc.field3 as fdescfield3,
	attr.identifier as attridentifier,
	attr.attrtype_id as attrtype,
	attr.sequence as attrsequence,
	attr.facetable as facetable,
	attrdesc.name as attrname,
	attrdesc.language_id as attrlang,
	attrdesc.description as attrdesc 
	from srchattrprop 
	LEFT JOIN srchattr ON srchattrprop.srchattr_id=srchattr.srchattr_id 
	LEFT JOIN facet ON facet.srchattr_id=srchattr.srchattr_id 
	LEFT JOIN facetdesc ON facet.facet_id=facetdesc.facet_id and facetdesc.language_id=?languageId?
	LEFT JOIN attr on facet.attr_id=attr.attr_id
	LEFT JOIN attrdesc on attr.attr_id=attrdesc.attr_id and attrdesc.language_id=?languageId?
	where 
	srchattrprop.propertyname in ('facet','facet-classicAttribute','facet-category','facet-range') and 
	srchattr.indextype=?indexType? and 
	srchattrprop.propertyvalue in (?propertyValue?) and
	facet.storeent_id IN (?storeList?)
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=SELECT_FACETABLE_INFORMATION_WORKSPACE
	base_table=FACET
	sql=
	select 
	SA.srchattr_id as srchattr_id,
	SAP.propertyname as propertyname,
	SAP.propertyvalue as propertyvalue,
	SA.identifier as srchattridentifier,
	F.facet_id as facet_id,
	F.attr_id as attr_id,
	F.selection as selection,
	F.keyword_search as keyword_search,
	F.zero_display as zero_display,
	F.storeent_id as storeent_id,
	F.max_display as max_display,
	F.sequence as sequence,
	F.sort_order as sort_order,
	F.group_id as group_id,
	F.field1 as ffield1,
	F.field2 as ffield2,
	F.field3 as ffield3,
	FD.name as fname,
	FD.language_id as flang,
	FD.description as fdesc,
	FD.field1 as fdescfield1,
	FD.field2 as fdescfield2,
	FD.field3 as fdescfield3,
	A.identifier as attridentifier,
	A.attrtype_id as attrtype,
	A.sequence as attrsequence,
	A.facetable as facetable,
	AD.name as attrname,
	AD.language_id as attrlang,
	AD.description as attrdesc 
	from $SCHEMA$.srchattrprop SAP
	LEFT JOIN $SCHEMA$.srchattr SA ON SAP.srchattr_id=SA.srchattr_id 
	LEFT JOIN $SCHEMA$.facet F ON F.srchattr_id=SA.srchattr_id 
	LEFT JOIN $SCHEMA$.facetdesc FD ON F.facet_id=FD.facet_id and FD.language_id=?languageId?
	LEFT JOIN $SCHEMA$.attr A on F.attr_id=A.attr_id
	LEFT JOIN $SCHEMA$.attrdesc AD on A.attr_id=AD.attr_id and AD.language_id=?languageId?
	where 
	SAP.propertyname in ('facet','facet-classicAttribute','facet-category','facet-range') and 
	SA.indextype=?indexType? and 
	SAP.propertyvalue in (?propertyValue?) and
	F.storeent_id IN (?storeList?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine the facetable columns registered in the table SRCHATTRPROP.    -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_FACETABLE_COLUMNS_SRCHATTRPROP
	base_table=SRCHATTRPROP
	sql=
	select PROPERTYNAME,PROPERTYVALUE 
	from SRCHATTRPROP LEFT JOIN SRCHATTR on 
	SRCHATTRPROP.SRCHATTR_ID=SRCHATTR.SRCHATTR_ID 
	where indextype=?indexType? and propertyname in ('facet','facet-classicAttribute','facet-category','facet-range')
	and indexscope in ('0', ?masterCatalogId?)
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=SELECT_FACETABLE_COLUMNS_SRCHATTRPROP_WORKSPACE
	base_table=SRCHATTRPROP
	sql=
	select PROPERTYNAME,PROPERTYVALUE 
	from $SCHEMA$.SRCHATTRPROP SAP
	LEFT JOIN $SCHEMA$.SRCHATTR SA on 
	SAP.SRCHATTR_ID=SA.SRCHATTR_ID 
	where indextype=?indexType? and propertyname in ('facet','facet-classicAttribute','facet-category','facet-range')
	and indexscope in ('0', ?masterCatalogId?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get attribute id for a given category                                    -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_ID_FOR_CATEGORY
	base_table=FACET
	sql=
	    SELECT f.attr_id
		FROM facet f, 
		(
			SELECT  ca.attr_id
			FROM    catentryattr ca, catgpenrel cge
    		WHERE   ca.catentry_id = cge.catentry_id
    		AND     cge.catgroup_id IN (?catgroupId?)
    		AND     cge.catalog_id IN (?catalogId?)
    		group by ca.attr_id
		) q
		WHERE f.attr_id = q.attr_id
		group by f.attr_id
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_ID_FOR_CATEGORY_WORKSPACE
	base_table=FACET
	sql=
	    SELECT f.attr_id
		FROM $SCHEMA$.facet f, 
		(
		    SELECT  ca.attr_id
		    FROM    $SCHEMA$.catentryattr ca, $SCHEMA$.catgpenrel cge
		    WHERE   ca.catentry_id = cge.catentry_id
		    AND     cge.catgroup_id IN (?catgroupId?)
		    AND     cge.catalog_id IN (?catalogId?)
		    group by ca.attr_id
		) q
		WHERE f.attr_id = q.attr_id
		group by f.attr_id
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get child categories for a given category                                    -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CHILD_CATEGORIES
	base_table=CATGRPREL
	sql=
		SELECT catgroup_id_child
		FROM
			catgrprel 
		WHERE
    		catgroup_id_parent = ?parentCategoryGroupId? AND 
    		catalog_id = ?catalogId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Get the max key id from table SRCHPROPRELV                              -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_MAX_KEY_ID_SRCHPROPRELV
	base_table=SRCHPROPRELV
	sql=
	SELECT MAX(SRCHPROPRELV_ID) AS MAXID
	  FROM SRCHPROPRELV
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the index field and relevancy value from table SRCHPROPRELV         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_INDEXFIELD_INFORMATION_QUERY
	base_table=SRCHPROPRELV
	sql=
	SELECT INDEXFIELD, RELVALUE
	FROM SRCHPROPRELV
	WHERE CATALOG_ID=?catalogId? AND CATGROUP_ID=?catgroupId? AND STOREENT_ID=?storeentId?
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	name=SELECT_INDEXFIELD_INFORMATION_QUERY_WORKSPACE
	base_table=SRCHPROPRELV
	sql=
	SELECT INDEXFIELD, RELVALUE
	FROM $SCHEMA$.SRCHPROPRELV
	WHERE CATALOG_ID=?catalogId? AND CATGROUP_ID=?catgroupId? AND STOREENT_ID=?storeentId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the SRCHPROPRELV id from table SRCHPROPRELV                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHPROPRELV_ID_QUERY
	base_table=SRCHPROPRELV
	sql=
	SELECT SRCHPROPRELV_ID
	FROM SRCHPROPRELV
	WHERE CATALOG_ID=?catalogId? AND CATGROUP_ID=?catgroupId? AND STOREENT_ID=?storeId? AND INDEXFIELD=?srchfieldName?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert a record into SRCHPROPRELV                                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_SRCHPROPRELV
	base_table=SRCHPROPRELV
	sql=
	INSERT INTO SRCHPROPRELV
	(SRCHPROPRELV_ID, CATGROUP_ID, CATALOG_ID, STOREENT_ID, RELVALUE, INDEXFIELD)
	VALUES
	(?srchproprelvId?, ?catgroupId?, ?catalogId?, ?storeId?, ?relValue?, ?srchfieldName?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete a record for SRCHPROPRELV                                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_SRCHPROPRELV
	base_table=SRCHPROPRELV
	sql=
	DELETE FROM SRCHPROPRELV
	WHERE INDEXFIELD = ?srchfieldName?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete a record for SRCHATTR                                             -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_SRCHATTR
	base_table=SRCHATTR
	sql=
	DELETE FROM SRCHATTR
	WHERE SRCHATTR_ID = ?srchAttrId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete a record for SRCHATTR by property value                           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_SRCHATTR_BY_PROPERTYVALUE
	base_table=SRCHATTR
	sql=
	DELETE FROM SRCHATTR WHERE SRCHATTR_ID = 
	 (SELECT DISTINCT SRCHATTR_ID FROM SRCHATTRPROP WHERE PROPERTYVALUE = ?propertyValue?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Resolve FFMCENTER_ID from STLFFMREL table giving STLOC_ID       		   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_STLFFMREL
	base_table=STLFFMREL
	sql=
	SELECT FFMCENTER_ID
	  FROM STLFFMREL
	 WHERE STLOC_ID = ?stloc_id?
END_SQL_STATEMENT

<!-- ======================================================================================= -->
<!--  Retrieve search configuration for given master catalog by all store's default language -->
<!-- ======================================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHCONF_DEFAULT
	base_table=SRCHCONF
	dbtype=any
	sql=
	SELECT STORECAT.CATALOG_ID,
	       STORE.LANGUAGE_ID,
	       SRCHCONF.INDEXSCOPE,
		   SRCHCONF.CONFIG
	  FROM STORECAT, STORE, SRCHCONF
	 WHERE STORECAT.MASTERCATALOG = '1'
	   AND STORECAT.STOREENT_ID = STORE.STORE_ID
	   AND STORE.STATUS = 1
	   AND CHAR(STORECAT.CATALOG_ID) = SRCHCONF.INDEXSCOPE
	   AND SRCHCONF.INDEXTYPE = ?indexType?
	dbtype=oracle
	sql=
	SELECT STORECAT.CATALOG_ID,
	       STORE.LANGUAGE_ID,
	       SRCHCONF.INDEXSCOPE,
		   SRCHCONF.CONFIG
	  FROM STORECAT, STORE, SRCHCONF
	 WHERE STORECAT.MASTERCATALOG = '1'
	   AND STORECAT.STOREENT_ID = STORE.STORE_ID
	   AND STORE.STATUS = 1
	   AND TO_CHAR(STORECAT.CATALOG_ID) = SRCHCONF.INDEXSCOPE
	   AND SRCHCONF.INDEXTYPE = ?indexType?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if attribute is facetable, searchable, or merchandisable       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR
	base_table=ATTR
	sql=
	SELECT SEARCHABLE, FACETABLE, MERCHANDISABLE, STOREENT_ID, ATTRTYPE_ID, IDENTIFIER
	FROM ATTR
	WHERE ATTR_ID = ?attributeId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if attribute is facetable, searchable, or merchandisable       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_WORKSPACE
	base_table=ATTR
	sql=
	SELECT SEARCHABLE, FACETABLE, MERCHANDISABLE, STOREENT_ID, ATTRTYPE_ID, IDENTIFIER
	FROM $SCHEMA$.ATTR
	WHERE ATTR_ID = ?attributeId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if attribute is facetable or searchable or merchandisable      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_IDENTIFIER
	base_table=ATTR
	sql=
	SELECT SEARCHABLE, FACETABLE, MERCHANDISABLE, STOREENT_ID, ATTRTYPE_ID, ATTR_ID
	FROM ATTR
	WHERE IDENTIFIER = ?identifier?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if attribute is facetable or searchable or merchandisable      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_IDENTIFIER_WORKSPACE
	base_table=ATTR
	sql=
	SELECT SEARCHABLE, FACETABLE, MERCHANDISABLE, STOREENT_ID, ATTRTYPE_ID, ATTR_ID
	FROM $SCHEMA$.ATTR
	WHERE IDENTIFIER = ?identifier?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for only full update from the catalog entry delta update table     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_FULL_CATALOGENTRY_INDEXING
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT TI_DELTA_CATENTRY.MASTERCATALOG_ID,
		   TI_DELTA_CATENTRY.CATENTRY_ID,
		   TI_DELTA_CATENTRY.ACTION
	  FROM TI_DELTA_CATENTRY
	 WHERE TI_DELTA_CATENTRY.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATENTRY.ACTION = 'F' OR TI_DELTA_CATENTRY.ACTION = 'B'
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for only full update from the catalog group delta update table     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_FULL_CATALOGGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT TI_DELTA_CATGROUP.MASTERCATALOG_ID,
		   TI_DELTA_CATGROUP.CATGROUP_ID,
		   TI_DELTA_CATGROUP.ACTION
	  FROM TI_DELTA_CATGROUP
	 WHERE TI_DELTA_CATGROUP.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_CATGROUP.ACTION = 'F' OR TI_DELTA_CATGROUP.ACTION = 'B'	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for only full update from the inventory delta update table     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_FULL_INVENTORY_INDEXING
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT TI_DELTA_INVENTORY.MASTERCATALOG_ID,
		   TI_DELTA_INVENTORY.CATENTRY_ID,
		   TI_DELTA_INVENTORY.ACTION
	  FROM TI_DELTA_INVENTORY
	 WHERE TI_DELTA_INVENTORY.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_INVENTORY.ACTION = 'F' OR TI_DELTA_INVENTORY.ACTION = 'B'	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Timestamp last search cache invalidation                                 -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=GENERATE_CACHEIVL
	base_table=CACHEIVL
	sql=
	INSERT INTO CACHEIVL (TEMPLATE, DATAID, INSERTTIME) 
	VALUES ('search:', ?dataId?, ?insertTime?)
	dbtype=oracle
	sql=
    INSERT INTO CACHEIVL (TEMPLATE, DATAID, INSERTTIME)
	VALUES ('search:', ?dataId?, TO_TIMESTAMP(?insertTime?, 'YYYY-MM-DD hh24:mi:ss.ff'))
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Restart cache invalidation                                                -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=RESTART_CACHEIVL
	base_table=CACHEIVL
	sql=
	INSERT INTO CACHEIVL (TEMPLATE, DATAID, INSERTTIME) 
	VALUES ('restart:', ?dataId?, ?insertTime?)
	dbtype=oracle
	sql=
    INSERT INTO CACHEIVL (TEMPLATE, DATAID, INSERTTIME)
	VALUES ('restart:', ?dataId?, TO_TIMESTAMP(?insertTime?, 'YYYY-MM-DD hh24:mi:ss.ff'))
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Retrieve search configuration table                                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SRCHCONFEXT
	base_table=SRCHCONFEXT
	sql=
	SELECT CONFIG,
		   INDEXSUBTYPE
	  FROM SRCHCONFEXT
	 WHERE INDEXTYPE = ?indexType?
	   AND (LANGUAGE_ID = ?langId? OR LANGUAGE_ID is null)
	   AND INDEXSCOPE = ?masterCatalogId?	
END_SQL_STATEMENT

<!-- ========================================================================= 	-->
<!--  Retrieve all search configurations data                            		-->
<!-- ========================================================================= 	-->
BEGIN_SQL_STATEMENT
	name=SELECT_ALL_SRCHCONFEXT
	base_table=SRCHCONFEXT
	sql=
	SELECT DISTINCT EXT.INDEXTYPE INDEXTYPE, EXT.INDEXSCOPE, EXT.LANGUAGE_ID, EXT.INDEXSUBTYPE, EXT.CONFIG, SRCHCONF.CONFIG CONFCONFIG
	  FROM STORECAT, STORE, SRCHCONF
	  LEFT OUTER JOIN SRCHCONFEXT EXT ON(SRCHCONF.INDEXTYPE= EXT.INDEXTYPE AND SRCHCONF.INDEXSCOPE=EXT.INDEXSCOPE)
	 WHERE STORECAT.MASTERCATALOG = '1'
	   AND STORECAT.STOREENT_ID = STORE.STORE_ID
	   AND STORE.STATUS = 1
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Retrieve storecat table                                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_STORECAT
	base_table=STORECAT
	sql=
	SELECT CATALOG_ID
		   FROM STORECAT
	 WHERE CATALOG_ID = ?catalogId?
	   AND MASTERCATALOG=1	
END_SQL_STATEMENT



<!-- ========================================================================= -->
<!--  Retrieve store tables                                                    -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_STORETYPE
	base_table=STORE
	sql=
	SELECT
   		STORETYPE
	FROM
	    STORE,
	    STOREENT
	WHERE
    	STORE.STORE_ID=STOREENT.STOREENT_ID
		AND STOREENT.MARKFORDELETE <> 1
		AND STORE.STORE_ID IN (?storeId?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Find all related stores which are currently open                         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_OPEN_RELATED_STORES
	base_table=ATTRDESC
	sql=
	    SELECT STOREENT_ID, DISPLAYNAME
	      FROM STOREENTDS
	     WHERE STOREENT_ID IN (SELECT STORE_ID FROM STORE WHERE STATUS = 1)
	       AND STOREENT_ID IN (
	           SELECT STOREREL.RELATEDSTORE_ID
	             FROM STOREREL, STRELTYP
	            WHERE STOREREL.STORE_ID = ?storeId?
	              AND STOREREL.STATE = 1
	              AND STRELTYP.NAME = ?relationshipType?
	              AND STRELTYP.STRELTYP_ID = STOREREL.STRELTYP_ID
	           )
	     ORDER BY STOREENTDS.STOREENT_ID
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Populate expression for catfilter                                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_POPULATE_EXPRESSION
	base_table=EXPRESSION
	sql=
insert into EXPRESSION (EXPRESSION_ID, CATFILTER_ID, QUERY) VALUES (?expression_id?, ?catfilter_id?, ?query?)
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!--  Populate expression for catfilter with trading ID and member ID          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_POPULATE_EXPRESSION_WITH_TRADINGID_AND_MEMBERID
	base_table=EXPRESSION
	sql=
insert into EXPRESSION (EXPRESSION_ID, TRADING_ID, CATFILTER_ID, MEMBER_ID, QUERY) VALUES (?expression_id?, ?trading_id?, ?catfilter_id?, ?member_id?, ?query?)
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!-- Query TC ID and catfilter ID by trading ID and TC sub type                -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_QUERY_TC_BY_TRADINGID_AND_SUBTYPE
	base_table=TERMCOND
	sql=
SELECT TERMCOND_ID, BIGINTFIELD1 FROM TERMCOND WHERE TRADING_ID = ?trading_id? AND TCSUBTYPE_ID = ?tc_sub_type?
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!-- Query TC ID and member ID by trading ID and TC sub type                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_QUERY_PARTICIPNT_MEMBERID_BY_TERMCOND
	base_table=PARTICIPNT
	sql=
SELECT MEMBER_ID FROM PARTICIPNT WHERE TERMCOND_ID = ?termcond_id?
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!-- Load all valid trading IDs                                                -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_LOAD_ALL_VALID_TRADING
	base_table=TRADING 
	dbtype=any
	sql=
SELECT TRADING_ID FROM TRADING WHERE (STARTTIME < ?current_time? OR STARTTIME IS NULL) AND (ENDTIME > ?current_time? OR ENDTIME IS NULL) AND STATE=1 AND MARKFORDELETE = 0 AND TRDTYPE_ID =1
END_SQL_STATEMENT	
<!-- ========================================================================= -->
<!-- Query all expressions                                                     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_QUERY_ALL_EXPRESSION
	base_table=EXPRESSION
	sql=
SELECT QUERY FROM  EXPRESSION
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!-- Query expression for catfilter 										   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_QUERY_EXPRESSION
	base_table=EXPRESSION
	sql=
SELECT QUERY FROM  EXPRESSION WHERE CATFILTER_ID = ?catfilter_id?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Update expression to catfilter 										   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_UPDATE_QUERY_TO_EXPRESSION
	base_table=EXPRESSION
	sql=
UPDATE  EXPRESSION SET QUERY=?query? WHERE CATFILTER_ID = ?catfilter_id?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Update contract_id to catfilter 										   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_UPDATE_CONTRACT_TO_EXPRESSION
	base_table=EXPRESSION
	sql=
UPDATE  EXPRESSION SET TRADING=?trading_id? WHERE CATFILTER_ID = ?catfilter_id?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Get parent categories for a category 									   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_SELECT_PARENT_CATGROUP
	base_table=CATGRPREL
	sql=
	SELECT CATGROUP_ID_PARENT FROM CATGRPREL, STORECAT 
	WHERE CATGROUP_ID_CHILD= ?catalogGroupId? AND CATGRPREL.CATALOG_ID=STORECAT.CATALOG_ID AND STORECAT.MASTERCATALOG='1'
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get flex flow by storeid and feature                                  -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=LOAD_FLEX_FLOW_BY_STOREID_AND_FEATURENAME
    base_table=DMEMSPOTDEF
	sql=
    select content from DMEMSPOTDEF 
    WHERE EMSPOT_ID IN (SELECT EMSPOT_ID FROM EMSPOT WHERE NAME = ?name? AND USAGETYPE='STOREFEATURE') 
    AND STOREENT_ID IN (?storeId?)
    AND CONTENTTYPE='FeatureEnabled'
END_SQL_STATEMENT

<!-- =========================================================================================================== -->
<!-- This SQL will return the store configuration based on the store ID and configuration name specified.       -->
<!-- @param STOREENT_ID The store IDs for which the parameter is to be retrieved							-->
<!-- @param NAME The name of the parameter to be retrieved.						-->
<!-- =========================================================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=STORECONF
	name=IBM_LOAD_STORECONF_BY_NAME
	sql=
		SELECT 
			VALUE, STOREENT_ID
		FROM
			STORECONF
		WHERE
			STORECONF.STOREENT_ID IN (?storeId?) AND NAME = ?name? 
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Loading entitled contract for buyer                                      -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	<!-- Load trading
	name=IBM_LOAD_TRADING
	base_table=TRADING 
	dbtype=any
	sql=
	SELECT T.trading_id, T.account_id, T.starttime, T.endtime FROM PARTICIPNT P, TRADING T, STORECNTR S WHERE T.trading_id = P.trading_id and T.trading_id = S.contract_id 
		and S.store_id =?store_id?  and P.partrole_id = 2 and P.termcond_id is null and (P.member_id = ?member_id? or P.member_id = ?org_id? or P.member_id is null) and T.state = 1 
		and T.markfordelete = 0 
	UNION  
	SELECT T.trading_id, T.account_id, T.starttime,  T.endtime FROM PARTICIPNT P, TRADING T, STORECNTR S, mbrrel M WHERE T.trading_id = P.trading_id 
		and T.trading_id = S.contract_id and S.store_id = ?store_id? and P.partrole_id = 2 and P.termcond_id is null and P.member_id = M.ancestor_id 
		and M.descendant_id = ?org_id? and T.state = 1 and T.markfordelete = 0 
 UNION 
 SELECT T.trading_id, T.account_id,  T.starttime, T.endtime FROM PARTICIPNT P, TRADING T, STORECNTR S, mbrgrpmbr M WHERE T.trading_id = P.trading_id 
 		and T.trading_id = S.contract_id and S.store_id = ?store_id? and P.partrole_id = 2 and P.termcond_id is null and P.member_id = M.mbrgrp_id 
 		and M.member_id = ?member_id? and M.exclude='0' and T.state = 1 and T.markfordelete = 0 
 order by trading_id
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Find the default contract setting for an account                         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	<!-- Fetch default contract from account -->
	name=IBM_LOAD_DEFAULTCONTRACT_FROM_ACCOUNT
	base_table=ACCOUNT 
	dbtype=any
	sql=
	SELECT DEFAULTCONTRACT FROM ACCOUNT where ACCOUNT_ID in (?account_id?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Find base contract for a reference contract                              -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	<!-- Fetch base contract -->
	name=IBM_LOAD_BASE_CONTRACT
	base_table=store 
	dbtype=any
	sql=
	select A.contract_id, b.starttime,b.endtime FROM contract A, trading B  where  A.contract_id=B.trading_id and A.family_id in (select REFTRADING_ID from trading where trading_id =?tradingId?) and a.state = 3 and a.markfordelete = 0
	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Find active organization for a member                                    -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	<!-- Fetch active organization  -->
	name=IBM_LOAD_ACTIVE_ORGANIATION
	base_table=mbrrel 
	dbtype=any
	sql=
	SELECT ANCESTOR_ID FROM MBRREL   WHERE (DESCENDANT_ID = ?member_id?) AND SEQUENCE = 1
	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- To determine whether one member belongs to a membergroup, this will be used to determine
     whether the current caller apply to the precompiled expression            -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_IS_MEMBER_OF
	base_table=mbrgrpmbr 
	sql=
	select DESCENDANT_ID from MBRREL M WHERE M.ANCESTOR_ID = ?mbrgrp_id? AND M.DESCENDANT_ID = ?org_id?
	UNION
	SELECT MEMBER_ID FROM MBRGRPMBR M WHERE M.MBRGRP_ID = ?mbrgrp_id? AND M.MEMBER_ID = ?user_id? and exclude='0'
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Load entitlement expression by contract -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_LOAD_EXPRESSION_BY_CONTRACT_ID
	base_table=EXPRESSION
	sql=
	SELECT QUERY,MEMBER_ID,CATFILTER_ID FROM EXPRESSION WHERE TRADING_ID IN (?trading_id?) order by CATFILTER_ID
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine last cache invalidation generation time                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=FIND_LAST_INVALIDATION_GENERATE
	base_table=CACHEIVL
	dbtype=db2
	sql=
	SELECT INSERTTIME FROM CACHEIVL
	 WHERE TEMPLATE = 'search:'
	 ORDER BY INSERTTIME DESC
	 FETCH FIRST 1 ROW ONLY
	dbtype=oracle
	sql=
	SELECT INSERTTIME FROM CACHEIVL
	 WHERE TEMPLATE = 'search:'
	   AND ROWNUM <= 1
	 ORDER BY INSERTTIME DESC
	sql=
	SELECT INSERTTIME FROM CACHEIVL
	 WHERE TEMPLATE = 'search:'
	 ORDER BY INSERTTIME DESC
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine last cache invalidation replay                                 -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=FIND_LAST_CACHE_REPLAY
	base_table=CACHEIVL
	dbtype=db2
	sql=
	SELECT INSERTTIME FROM CACHEIVL
	 WHERE TEMPLATE = 'restart:'
	 ORDER BY INSERTTIME DESC
	 FETCH FIRST 1 ROW ONLY
	dbtype=oracle
	sql=
	SELECT INSERTTIME FROM CACHEIVL
	 WHERE TEMPLATE = 'restart:'
	   AND ROWNUM <= 1
	 ORDER BY INSERTTIME DESC
	sql=
	SELECT INSERTTIME FROM CACHEIVL
	 WHERE TEMPLATE = 'restart:'
	 ORDER BY INSERTTIME DESC
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine storeId for invalidation                                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_STORE_FOR_INVALIDATION
	base_table=STORECAT
	sql=
	SELECT STORECAT.STOREENT_ID
	  FROM STORECAT
	 WHERE STORECAT.CATALOG_ID = ?masterCatalogId?
	   AND STORECAT.MASTERCATALOG = '1'
	 UNION
	SELECT STOREREL.STORE_ID
	  FROM STORECAT, STOREREL
	 WHERE STORECAT.CATALOG_ID = ?masterCatalogId?
	   AND STORECAT.MASTERCATALOG = '1'
	   AND STORECAT.STOREENT_ID = STOREREL.RELATEDSTORE_ID
	   AND STOREREL.STRELTYP_ID = -4
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine catalogId for invalidation                                     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CATALOG_FOR_INVALIDATION
	base_table=STORECAT
	sql=
	SELECT SC.CATALOG_ID
	  FROM STORECAT SC
	 WHERE SC.STOREENT_ID IN (
	SELECT STORECAT.STOREENT_ID
	  FROM STORECAT
	 WHERE STORECAT.CATALOG_ID = ?masterCatalogId?
	   AND STORECAT.MASTERCATALOG = '1'
	 UNION
	SELECT STOREREL.STORE_ID
	  FROM STORECAT, STOREREL
	 WHERE STORECAT.CATALOG_ID = ?masterCatalogId?
	   AND STORECAT.MASTERCATALOG = '1'
	   AND STORECAT.STOREENT_ID = STOREREL.RELATEDSTORE_ID
	   AND STOREREL.STRELTYP_ID = -4)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Retrieve all catalog given a store                                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CATALOG_BY_STORE
	base_table=STORECAT
	sql=
	SELECT CATALOG_ID
 	  FROM STORECAT
	 WHERE STOREENT_ID IN (?storeId?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Fetch all attributes and related properties from SRCHATTR, SRCHATTRPROP, 
         FACET, FACETCATGRP, ATTR for workspace                                -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	<!-- Fetch all attributes and related properties from SRCHATTR, SRCHATTRPROP, FACET, FACETCATGRP, ATTR for workspace-->
	name=IBM_Select_Search_Attributes_Properties_Workspace
	base_table=SRCHATTR
	sql=
		SELECT S.INDEXTYPE, S.INDEXSCOPE, S.IDENTIFIER, SP.PROPERTYNAME, 
			SP.PROPERTYVALUE, S.SRCHATTR_ID, F.SELECTION, F.MAX_DISPLAY, F.GROUP_ID
		FROM $SCHEMA$.SRCHATTR S
		LEFT OUTER JOIN $SCHEMA$.SRCHATTRPROP SP ON S.SRCHATTR_ID = SP.SRCHATTR_ID
		LEFT OUTER JOIN $SCHEMA$.FACET F ON S.SRCHATTR_ID = F.SRCHATTR_ID
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if attribute is linked to a product							   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CATENTRYATTR
	base_table=CATENTRYATTR
	sql=
	SELECT COUNT(*) AS COUNT
	FROM CATENTRYATTR
	WHERE ATTR_ID = ?attributeId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if attribute is linked to a product							   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_CATENTRYATTR_WORKSPACE
	base_table=CATENTRYATTR
	sql=
	SELECT COUNT(*) AS COUNT
	FROM $SCHEMA$.CATENTRYATTR
	WHERE ATTR_ID = ?attributeId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get attribute name by identifier for workspace                        -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SEARCHABLE_ATTR_NAME_WORKSPACE
	base_table=ATTRDESC
	sql=
	select ATTR_ID,NAME 
	from $SCHEMA$.ATTRDESC WHERE ATTR_ID IN(SELECT ATTR_ID FROM $SCHEMA$.ATTR WHERE IDENTIFIER =?name? and storeent_id in (?storeent_id?) and SEARCHABLE=1) AND LANGUAGE_ID=?languageId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Determine if indexing is being performed                                 -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=IS_PERFORMING_INVENTORY_INDEXING
	base_table=TI_DELTA_INVENTORY
	sql=
	SELECT TI_DELTA_INVENTORY.CATENTRY_ID, TI_DELTA_INVENTORY.LASTUPDATE 
	  FROM TI_DELTA_INVENTORY
	 WHERE TI_DELTA_INVENTORY.MASTERCATALOG_ID = ?masterCatalogId?
       AND TI_DELTA_INVENTORY.ACTION = 'P'
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Find catalog entry in TI_DELTA_INVENTORY table                           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_TI_DELTA_INVENTORY
	base_table=TI_DELTA_INVENTORY
	sql=
    SELECT ACTION FROM TI_DELTA_INVENTORY
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATENTRY_ID = ?catalogEntryId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert a row into the inventory delta update table                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_TI_DELTA_INVENTORY
	base_table=TI_DELTA_INVENTORY
	sql=
	INSERT INTO TI_DELTA_INVENTORY (MASTERCATALOG_ID, CATENTRY_ID, ACTION) 
	VALUES (?masterCatalogId?, ?catalogEntryId?, ?action?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Update catalog entry in TI_DELTA_INVENTORY table                         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_TI_DELTA_INVENTORY
	base_table=TI_DELTA_INVENTORY
	sql=
    UPDATE TI_DELTA_INVENTORY
       SET ACTION = ?action?
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATENTRY_ID = ?catalogEntryId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Delete a row into the inventory delta update table                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_TI_DELTA_INVENTORY
	base_table=TI_DELTA_INVENTORY
	sql=
	DELETE FROM TI_DELTA_INVENTORY
	 WHERE MASTERCATALOG_ID = ?masterCatalogId?
       AND ACTION IN (?action?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Count any action from the inventory delta update table                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=COUNT_ANY_INVENTORY_INDEXING
	base_table=TI_DELTA_INVENTORY
	sql=
	SELECT COUNT(*) as ROWCOUNT
	  FROM TI_DELTA_INVENTORY
	 WHERE TI_DELTA_INVENTORY.MASTERCATALOG_ID = ?masterCatalogId?	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get catfilter without tc level participant   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=IBM_FIND_PRIVATE_CATFILTER
	base_table=TERMCOND
  sql = select a.bigintfield1,b.member_id from termcond a,participnt b  
   where a.termcond_id=b.termcond_id  and  a.trading_id in (?trading_id?) 
   and a.tcsubtype_id= ?tc_sub_type? and b.trading_id is null  and b.member_id is not null and b.partrole_id=2
END_SQL_STATEMENT   

<!-- ========================================================================= -->
<!--  To get catfilter with tc level participant   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=IBM_FIND_PUBLIC_CATFILTER
	base_table=TERMCOND
  sql = select bigintfield1 from termcond 
    where trading_id in (?trading_id?) and tcsubtype_id = ?tc_sub_type?
    and termcond_id  not in (select termcond_id from participnt 
    where trading_id is null and termcond_id is not null and partrole_id=2)
END_SQL_STATEMENT   

<!-- ========================================================================= -->
<!--  To insert private catalog filter expression
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=IBM_POPULATE_PRIVATE_CATALOG_FILTER_EXPRESSION
	base_table=EXPRESSION
  sql = INSERT INTO EXPRESSION (EXPRESSION_ID, TRADING_ID,CATFILTER_ID,MEMBER_ID,QUERY) 
        VALUES (?expression_id?, ?trading_id?, ?catfilter_id?, ?member_id?, ?query?)
END_SQL_STATEMENT   

<!-- ========================================================================= -->
<!--  To insert public catalog filter expression   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=IBM_POPULATE_PUBLIC_CATALOG_FILTER_EXPRESSION
	base_table=EXPRESSION
  sql = INSERT INTO EXPRESSION (EXPRESSION_ID, TRADING_ID, CATFILTER_ID, QUERY) 
        VALUES (?expression_id?, ?trading_id?, ?catfilter_id?, ?query?)
        
END_SQL_STATEMENT   

<!-- ========================================================================= -->
<!--  To insert productset expression   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=IBM_POPULATE_PRODUCTSET_EXPRESSION
	base_table=EXPRESSION
  sql = INSERT INTO EXPRESSION (EXPRESSION_ID, TRADING_ID,QUERY) 
        VALUES (?expression_id?, ?trading_id?, ?query?)
END_SQL_STATEMENT   

<!-- ========================================================================= -->
<!--  To delete expression by contract   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=DELETE_EXPRESSION
	base_table=EXPRESSION
  sql = DELETE FROM EXPRESSION WHERE TRADING_ID = ?trading_id?
END_SQL_STATEMENT  

<!-- ========================================================================= -->
<!--  Check for actions from the catalog entry delta update table              -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_CATENTRY_INDEXING_ACTION_AND_USER_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT MASTERCATALOG_ID,
		   CATENTRY_ID,
		   ACTION
	  FROM $SCHEMA$.TI_DELTA_CATENTRY
	 WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION IN (?action?) AND USERS_ID = ?userId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for actions from the catalog entry delta update table              -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_CATENTRY_INDEXING_ACTION
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT MASTERCATALOG_ID,
		   CATENTRY_ID,
		   ACTION
	  FROM TI_DELTA_CATENTRY
	 WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION IN (?action?)	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for actions from the catalog group delta update table              -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_CATGROUP_INDEXING_ACTION_AND_USER_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT MASTERCATALOG_ID,
		   CATGROUP_ID,
		   ACTION
	  FROM $SCHEMA$.TI_DELTA_CATGROUP
	 WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION IN (?action?) AND USERS_ID = ?userId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for actions from the catalog entry delta update table              -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=GET_USER_ID_FOR_CATENTRY_INDEXING_BY_ACTION_AND_MC_ID_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
	SELECT MASTERCATALOG_ID,
		   CATENTRY_ID,
		   USERS_ID,
		   ACTION
	  FROM $SCHEMA$.TI_DELTA_CATENTRY
	 WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION = ?action?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Check for actions from the catalog group delta update table              -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=GET_USER_ID_FOR_CATGROUP_INDEXING_BY_ACTION_AND_MC_ID_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT MASTERCATALOG_ID,
		   CATGROUP_ID,
		   USERS_ID,
		   ACTION
	  FROM $SCHEMA$.TI_DELTA_CATGROUP
	 WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION = ?action?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Check for actions from the catalog group delta update table              -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CHECK_FOR_CATGROUP_INDEXING_ACTION
	base_table=TI_DELTA_CATGROUP
	sql=
	SELECT MASTERCATALOG_ID,
		   CATGROUP_ID,
		   ACTION
	  FROM TI_DELTA_CATGROUP
	 WHERE MASTERCATALOG_ID = ?masterCatalogId? AND ACTION IN (?action?)	
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  get supported language for the specified store                           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_LANGUAGES_FOR_STORELANG
	base_table=STORELANG
	sql=
	SELECT LANGUAGE_ID FROM STORELANG WHERE STOREENT_ID= ?storeId? 	
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Clear processed entries in TI_DELTA_CATENTRY table                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CLEAR_TI_DELTA_CATENTRY_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
	DELETE FROM $SCHEMA$.TI_DELTA_CATENTRY CE
	 WHERE CE.MASTERCATALOG_ID = ?masterCatalogId?
       AND CE.ACTION != 'P'
       AND CE.LASTUPDATE < 
	(SELECT TI.LASTUPDATE FROM $SCHEMA$.TI_DELTA_CATENTRY TI
	  WHERE TI.ACTION = 'P'
	    AND TI.MASTERCATALOG_ID = CE.MASTERCATALOG_ID)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Clear processed entries in TI_DELTA_CATGROUP table                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=CLEAR_TI_DELTA_CATGROUP_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
	DELETE FROM $SCHEMA$.TI_DELTA_CATGROUP CG
	 WHERE CG.MASTERCATALOG_ID = ?masterCatalogId?
       AND CG.ACTION != 'P'
       AND CG.LASTUPDATE < 
	(SELECT TI.LASTUPDATE FROM $SCHEMA$.TI_DELTA_CATGROUP TI
	  WHERE TI.ACTION = 'P'
	    AND TI.MASTERCATALOG_ID = ?masterCatalogId?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Update catalog entry in TI_DELTA_CATENTRY table                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_TI_DELTA_CATENTRY_LASTUPDATE_AND_ACTION_FOR_USER_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
    UPDATE $SCHEMA$.TI_DELTA_CATENTRY
       SET LASTUPDATE = ?lastupdate?, ACTION = ?newAction?
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATENTRY_ID = ?catalogEntryId?
	   AND USERS_ID = ?userId?
	   AND ACTION = ?action?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Update catalog entry in TI_DELTA_CATGROUP table                          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_TI_DELTA_CATGROUP_LASTUPDATE_AND_ACTION_FOR_USER_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
    UPDATE $SCHEMA$.TI_DELTA_CATGROUP
       SET LASTUPDATE = ?lastupdate?, ACTION = ?newAction?
     WHERE MASTERCATALOG_ID = ?masterCatalogId? 
	   AND CATGROUP_ID = ?catalogGroupId?
	   AND USERS_ID = ?userId?
	   AND ACTION = ?action?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert a row into the catalog entry delta update workspace table         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_TI_DELTA_CATENTRY_WITH_USER_WORKSPACE
	base_table=TI_DELTA_CATENTRY
	sql=
	INSERT INTO $SCHEMA$.TI_DELTA_CATENTRY (MASTERCATALOG_ID, CATENTRY_ID, ACTION, LASTUPDATE, USERS_ID, CONTENT_BASE) 
	VALUES (?masterCatalogId?, ?catalogEntryId?, ?action?, ?lastupdate?, ?userId?, 1)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert a row into the catalog group delta update workspace table         -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=INSERT_TI_DELTA_CATGROUP_WITH_USER_WORKSPACE
	base_table=TI_DELTA_CATGROUP
	sql=
	INSERT INTO $SCHEMA$.TI_DELTA_CATGROUP (MASTERCATALOG_ID, CATGROUP_ID, ACTION, LASTUPDATE, USERS_ID, CONTENT_BASE) 
	VALUES (?masterCatalogId?, ?catalogGroupId?, ?action?, ?lastupdate?, ?userId?, 1)
END_SQL_STATEMENT



<!-- ========================================================================= -->
<!--  Retrieve rule last evaluation time                                       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_RULEBASEDCATEGORY_RULE
	base_table=CATGRPRULE
	sql=
	SELECT
   		*
	FROM
	    CATGRPRULE
	WHERE
    	CATGROUP_ID IN (?categoryId?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Retrieve rule based category children                                    -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_RULEBASEDCATEGORY_CHILDREN
	base_table=CATGPENREL
	sql=
	SELECT
   		CATGPENREL.CATENTRY_ID,CATGPENREL.SEQUENCE
	FROM
	    CATGPENREL JOIN CATENTRY ON CATGPENREL.CATENTRY_ID=CATENTRY.CATENTRY_ID
	WHERE
    	CATGPENREL.CATALOG_ID=?catalogId? AND
    	CATGPENREL.CATGROUP_ID=?categoryId? AND
    	( CATGPENREL.SEQUENCE <> 0 OR
    	CATENTRY.CATENTTYPE_ID <> 'ItemBean' ) AND
    	CATENTRY.MARKFORDELETE = 0 ORDER BY CATGPENREL.SEQUENCE ASC
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Find all rule based categories eligible for evaluation                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=FIND_ALL_RULE_BASED_CATEGORIES_FOR_EVAL
	base_table=CATGRPRULE
	sql=select 
			catgrprule.catgroup_id, 
			catgrprule.dmactivity_id, 
			catgrprule.evaltime, 
			catgrprule.showafter, 
			catgrprule.evaluating 
		from 
			catgroup, catgrprule 
		where 
			catgroup.catgroup_id=catgrprule.catgroup_id and 
			catgroup.dynamic=1 and 
			catgroup.markfordelete=0 and 
			(catgrprule.evaluating=0 or catgrprule.evaluating=2 or catgrprule.evaluating=-2)
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will synchronize the sequence of Catalog Entries to Catalog Group relation for the   -->
<!-- given Catalog Group Id and Catalog Links Catalog Id.                                          -->
<!-- @param sequence Sequence of child catalog entry.                                              -->
<!-- @param catalogEntryId Id of child catalog entry.                                              -->
<!-- @param catalogGroupID Id of parent catalog group.                                             -->
<!-- @param catalogID  The catalog id link for which relation has to be updated.                   --> 
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_RuleBasedCategoryCatEntrySequence
	base_table=CATGPENREL
	sql=
	
			UPDATE CATGPENREL SET CATGPENREL.SEQUENCE = ?sequence? 
			WHERE 
					CATGPENREL.CATENTRY_ID = ?catalogEntryId? AND 
					CATGPENREL.CATGROUP_ID = ?catalogGroupID? AND 
					CATGPENREL.CATALOG_ID = ?catalogID?	
					
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will select the evaluating column for a category.                                    -->
<!-- @param catalogGroupID Id of parent catalog group.                                             -->
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_RuleBasedCategory_isEvaluating
	base_table=CATGRPRULE
	sql=SELECT EVALUATING
			FROM
		CATGRPRULE 
			WHERE 
		CATGROUP_ID = ?catalogGroupID?
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will select all parent store ID and catalog ID for a given category.                 -->
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_RuleBasedCategory_storeAndCatalogSelection
	base_table=STORECGRP
	sql=
		SELECT 
			CATGRPREL.CATALOG_ID, STORECGRP.STOREENT_ID 
		FROM
			CATGRPREL,STORECGRP 
		WHERE
			STORECGRP.CATGROUP_ID=CATGRPREL.CATGROUP_ID_CHILD AND CATGRPREL.CATGROUP_ID_CHILD=?catalogGroupID?
	UNION
		SELECT 
			CATTOGRP.CATALOG_ID, STORECGRP.STOREENT_ID
		FROM 
			CATTOGRP,STORECGRP 
		WHERE
			STORECGRP.CATGROUP_ID=CATTOGRP.CATGROUP_ID AND CATTOGRP.CATGROUP_ID=?catalogGroupID?
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will update the evaluating column to '2' for all rule based categories.              -->
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_RuleBasedCategory_EvaluateAllIgnoreTimeInterval
	base_table=CATGRPRULE
	sql=
			UPDATE CATGRPRULE
				SET EVALUATING=2
			WHERE
				EVALUATING=0 OR EVALUATING=-2

END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will update the evaluating column and evaltime for a category.                       -->
<!-- @param evaltime Evaluation time of a catalog group rule.                                      -->
<!-- @param catalogGroupID Id of parent catalog group.                                             -->
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_RuleBasedCategory_FinishEvaluating
	base_table=CATGRPRULE
	dbtype=any
		sql=
			UPDATE CATGRPRULE 
				SET EVALUATING=0, 
				EVALTIME=?evaltime?			
			WHERE 
				CATGROUP_ID = ?catalogGroupID?
	dbtype=oracle
		sql=
			UPDATE CATGRPRULE 
				SET EVALUATING=0, 
				EVALTIME=TO_TIMESTAMP(?evaltime?, 'YYYY-MM-DD hh24:mi:ss.ff')
			WHERE 
				CATGROUP_ID = ?catalogGroupID?
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will update the evaluating column for a category.                                    -->
<!-- @param evaluating Evaluating a catalog group rule.                                            -->
<!-- @param catalogGroupID Id of parent catalog group.                                             -->
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_Update_RuleBasedCategory_Evaluating
	base_table=CATGRPRULE
	sql=
	
			UPDATE CATGRPRULE 
				SET EVALUATING=?evaluating? 
			WHERE 
				CATGROUP_ID = ?catalogGroupID?	
				
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will select the parent category for a given category                                 -->
<!-- @param childCategoryId The category ID of the child category                                  -->
<!-- @param catalogId The ID of the catalog                                                        -->
<!-- @param languageId The language ID                                                             -->
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_RuleBasedCategoryEvaluation_GetParentCategory
	base_table=CATGRPREL
	sql=
			SELECT 
				CATGRPREL.CATGROUP_ID_PARENT
			from 
				CATGRPREL,CATGRPDESC,CATGROUP
			where 
				CATGRPREL.CATGROUP_ID_CHILD=?childCategoryId?
					and 
				CATGRPREL.catgroup_id_parent = CATGRPDESC.catgroup_id 
					and 
				CATGRPREL.catgroup_id_parent = CATGROUP.catgroup_id
					and 		
				CATGRPREL.catalog_id=?catalogId?
					and
				CATGRPDESC.LANGUAGE_ID = ?languageId? 
					and 
				CATGRPDESC.PUBLISHED = 1
					and 
				CATGROUP.MARKFORDELETE = 0
				
END_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will select the child category for a given category                                  -->
<!-- @param parentCategoryId The category ID of the parent category                                -->
<!-- @param catalogId The ID of the catalog                                                        -->
<!-- @param languageId The language ID                                                             -->
<!-- ============================================================================================= -->
BEGIN_SQL_STATEMENT
	name=IBM_RuleBasedCategoryEvaluation_GetChildCategory
	base_table=CATGRPREL
	sql=
			SELECT 
				CATGRPREL.CATGROUP_ID_CHILD, CATGROUP.DYNAMIC
			from 
				CATGRPREL,CATGRPDESC,CATGROUP
			where 
				CATGRPREL.CATGROUP_ID_PARENT=?parentCategoryId?
					and 
				CATGRPREL.catgroup_id_child = CATGRPDESC.catgroup_id 
					and 
				CATGRPREL.catgroup_id_child = CATGROUP.catgroup_id
					and 							
				CATGRPREL.catalog_id=?catalogId?
					and
				CATGRPDESC.LANGUAGE_ID = ?languageId? 
					and 
				CATGRPDESC.PUBLISHED = 1
					and 
				CATGROUP.MARKFORDELETE = 0				
				
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select rows from the catalog entry workspace table by taskgroup          -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_BY_TASKGROUP_TI_CATENTRY_WS
	base_table=TI_CATENTRY_WS
	sql=
	SELECT DISTINCT WS.CATENTRY_ID, WS.MASTERCATALOG_ID, WS.ACTION, CE.MARKFORDELETE
	FROM $SCHEMA$.TI_CATENTRY_WS WS
	LEFT OUTER JOIN CATENTRY CE ON WS.CATENTRY_ID=CE.CATENTRY_ID
	WHERE 
	WS.TASKGROUP = ?taskGroupId? 
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get all store which use or share the master catalog   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_STORE_AND_STORETYPE_BY_MASTER_CATALOG
	base_table=STORE
	sql=
select STORE_ID,STORETYPE from store where store_id in (select storeent_id from storecat where catalog_id=?catalogId?  and mastercatalog='1') union select store_id,storetype from store where store_id in (SELECT STORE_ID FROM STOREREL REL WHERE STRELTYP_ID=-4 AND REL.relatedSTORE_ID IN (SELECT STOREENT_ID FROM STORECAT WHERE CATALOG_ID=?catalogId? and mastercatalog='1'))
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get all product,item, package from master catalog   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=SELECT_PRODUCT_ITEM_FOR_CATALOG
	base_table=CATENTRY
  sql=SELECT DISTINCT(CATENTRY.CATENTRY_ID) FROM CATENTRY,CATGPENREL WHERE CATENTRY.MARKFORDELETE=0 AND CATENTRY.CATENTRY_ID=CATGPENREL.CATENTRY_ID AND CATGPENREL.CATALOG_ID=?catalogId? AND CATENTRY.CATENTTYPE_ID IN('ProductBean','ItemBean')
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  To get all bundle from master catalog   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=SELECT_COMPOSITE_CATENTRY_FOR_CATALOG
	base_table=CATENTRY
  sql=SELECT DISTINCT(CATENTRY.CATENTRY_ID) FROM CATENTRY,CATGPENREL WHERE CATENTRY.MARKFORDELETE=0 AND CATENTRY.CATENTRY_ID=CATGPENREL.CATENTRY_ID AND CATGPENREL.CATALOG_ID=?catalogId? AND CATENTRY.CATENTTYPE_ID IN('BundleBean')
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get all bundle component from master catalog   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=SELECT_COMPONENT_FOR_BUNDLE
	base_table=CATENTREL
  sql=SELECT CATENTRY_ID_CHILD, CATENTRY_ID_PARENT FROM CATENTREL WHERE CATENTRY_ID_PARENT IN (?bundleId?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get currency by store   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=GET_CURRENCY_BY_STORE
	base_table=CURLIST
  sql=SELECT CURRSTR,STOREENT_ID FROM CURLIST WHERE STOREENT_ID IN(?storeId?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get contract by store   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=GET_CONTRACT_BY_STORE
	base_table=CONTRACT
  sql=SELECT C.CONTRACT_ID,SC.STORE_ID FROM CONTRACT C, STORECNTR SC, TRADING T  WHERE C.CONTRACT_ID=SC.CONTRACT_ID AND C.CONTRACT_ID=T.TRADING_ID AND T.STATE=1 AND T.MARKFORDELETE = 0 AND (T.ENDTIME IS NULL OR ENDTIME > ?endtime?)  AND SC.STORE_ID in(?storeId?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get catentry by store   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=GET_CATENTRY_BY_STORE
	base_table=STORECENT
  sql=SELECT a.CATENTRY_ID,a.STOREENT_ID FROM STORECENT a, CATENTRY b WHERE a.STOREENT_ID IN (?storeId?) AND a.CATENTRY_ID=b.CATENTRY_ID AND b.CATENTTYPE_ID IN ('ProductBean','ItemBean','PackageBean') AND b.MARKFORDELETE = 0 order by a.catentry_id
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get catentry by store   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=GET_CATENTRY_FROM_MASTER_CATALOG
	base_table=CATGPENREL
  sql=SELECT a.CATENTRY_ID FROM CATGPENREL A,CATENTRY B WHERE a.CATENTRY_ID=b.CATENTRY_ID  AND b.MARKFORDELETE = 0 AND A.CATALOG_ID = ?catalogId?
END_SQL_STATEMENT



<!-- ========================================================================= -->
<!--  To get store by catentry   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=GET_STORE_BY_CATENTRY
	base_table=STORECENT
  sql=SELECT STOREENT_ID,A.CATENTRY_ID FROM STORECENT A,CATGPENREL B, CATENTRY C WHERE A.CATENTRY_ID IN (?catentryId?) AND A.CATENTRY_ID=B.CATENTRY_ID AND A.CATENTRY_ID=C.CATENTRY_ID AND C.MARKFORDELETE=0 AND B.CATALOG_ID=?catalogId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get store by contract   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=GET_STORE_BY_CONTRACT
	base_table=STORECNTR
  sql=SELECT STORE_ID,CONTRACT_ID FROM STORECNTR A,TRADING B WHERE CONTRACT_ID IN (?contractId?) AND A.CONTRACT_ID=B.TRADING_ID AND B.STATE=1
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get assetstore by store   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=GET_ASSETSTORE_BY_STORE
	base_table=STOREREL
  sql=SELECT relatedstore_id,store_id FROM storerel WHERE store_id IN (?storeId?) and streltyp_id = -4 order by sequence desc
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  To get catentry with startvalue and endvalue   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=GET_CATENTRY_BY_STARTVALUE_AND_ENDVALUE
	base_table=STORECENT,CATENTRY
	
	
  
	dbtype=oracle
	sql=SELECT CATENTRY_ID, CATENTTYPE_ID 
  FROM (SELECT ROW_NUMBER() OVER(ORDER BY q.CATENTRY_ID) AS rn, 
        q.* 
        from 
  			(select distinct CATENTRY.CATENTRY_ID, CATENTRY.CATENTTYPE_ID FROM CATENTRY, STORECENT WHERE CATENTRY.MARKFORDELETE=0  AND CATENTRY.CATENTTYPE_ID IN('ProductBean','ItemBean','PackageBean') AND  CATENTRY.CATENTRY_ID=STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID=?storeId?) q
  		)
  WHERE rn BETWEEN ?start_value? AND ?end_value?
  
  dbtype=db2
	sql=SELECT CATENTRY_ID, CATENTTYPE_ID 
  FROM (SELECT ROW_NUMBER() OVER(ORDER BY q.CATENTRY_ID) AS rn, 
        q.* 
        from 
  			(select distinct CATENTRY.CATENTRY_ID, CATENTRY.CATENTTYPE_ID FROM CATENTRY, STORECENT WHERE CATENTRY.MARKFORDELETE=0 AND CATENTRY.CATENTTYPE_ID IN('ProductBean','ItemBean','PackageBean') AND CATENTRY.CATENTRY_ID=STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID=?storeId?) q
  		)
  WHERE rn BETWEEN ?start_value? AND ?end_value?
  
  dbtype=os400
	sql=SELECT t.CATENTRY_ID, t.CATENTTYPE_ID 
  FROM ((SELECT ROW_NUMBER() OVER(ORDER BY q.CATENTRY_ID) AS rn, 
        q.* 
        from 
  			(select distinct CATENTRY.CATENTRY_ID, CATENTRY.CATENTTYPE_ID FROM CATENTRY, STORECENT WHERE CATENTRY.MARKFORDELETE=0  AND CATENTRY.CATENTTYPE_ID IN('ProductBean','ItemBean','PackageBean') AND  CATENTRY.CATENTRY_ID=STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID=?storeId?) q
  		)) as t
  WHERE t.rn BETWEEN ?start_value? AND ?end_value?


  dbtype=derby
  sql=SELECT a.CATENTRY_ID,a.STOREENT_ID FROM STORECENT a, CATENTRY b WHERE a.STOREENT_ID IN (?storeId?) AND a.CATENTRY_ID=b.CATENTRY_ID AND b.CATENTTYPE_ID IN ('ProductBean','ItemBean','PackageBean') AND b.MARKFORDELETE = 0 and a.catentry_id between  ?start_value? AND ?end_value?  order by a.catentry_id
  
 END_SQL_STATEMENT 
  
<!-- ========================================================================= -->
<!--  To get parent by catentry   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=FIND_PARENT_BY_CATENTRY
	base_table=CATENTREL
  sql=SELECT CATENTRY_ID_PARENT FROM CATENTREL WHERE CATENTRY_ID_PARENT IN(?catentryId?) AND CATRELTYPE_ID IN ('BUNDLE_COMPONENT') UNION SELECT CATENTRY_ID_PARENT FROM CATENTREL WHERE CATENTRY_ID_CHILD IN(?catentryId?) AND CATRELTYPE_ID IN ('BUNDLE_COMPONENT') 

END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get child for catentry   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=FIND_CHILD_BY_CATENTRY
	base_table=CATENTREL
  sql=SELECT CATENTRY_ID_CHILD,CATENTRY_ID_PARENT FROM CATENTREL WHERE CATENTRY_ID_PARENT IN(?catentryId?) AND CATRELTYPE_ID IN ('BUNDLE_COMPONENT')

END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  To get start time for contract   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=GET_STARTTIME_BY_CONTRACT
	base_table=TRADING
  sql=SELECT STARTTIME, TRADING_ID FROM TRADING WHERE TRADING_ID IN(?contractId?) 

END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  To get whether the specified catalog is master catalog   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
  name=IS_MASTER_CATALOG
	base_table=STORECAT
  sql=select CATALOG_ID from storecat where catalog_id=?catalogId?  and mastercatalog='1'
END_SQL_STATEMENT

<!-- =============================================================================== 
	Add new catalog group to catalog entry relations for SKUs of a product.
	This will set the sequence to 0 for all product level SKUs.
	@param catGroupId The catalog group id
	@param catEntryId The product id 
	@param catalogId The catalog id for the new relations
		
==================================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Insert_CreateCatalogGroupToCatalogEntryRelationsForSKUsForRuleBasedCategories	      
	base_table=CATGPENREL
	dbtype=oracle
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, LASTUPDATE)
	select TO_NUMBER(?catGroupId?), TO_NUMBER(?catalogId?), t1.catentry_id_child, SYSTIMESTAMP
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='PRODUCT_ITEM'
	   
	dbtype=db2
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, LASTUPDATE)
	select CAST(?catGroupId? as BIGINT), CAST(?catalogId? as BIGINT), t1.catentry_id_child, current timestamp
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='PRODUCT_ITEM'
	  
	sql=
	INSERT INTO CATGPENREL (CATGROUP_ID, CATALOG_ID, CATENTRY_ID, LASTUPDATE)
	select CAST(?catGroupId? as BIGINT), CAST(?catalogId? as BIGINT), t1.catentry_id_child, current timestamp
	from catentrel t1
	where t1.catentry_id_parent=?catEntryId? and t1.CATRELTYPE_ID='PRODUCT_ITEM'  
END_SQL_STATEMENT


<!-- ========================================================= -->
<!-- Access Profile Alias definition			       -->
<!-- ========================================================= -->

BEGIN_PROFILE_ALIASES
  base_table=CATENTRY
  IBM_IdResolve=IBM_Admin_IdResolve
  IBM_IDENTIFIER=IBM_Admin_IDENTIFIER
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=MASSOCTYPE
  IBM_SupportedMerchandisingAssociationName=IBM_Admin_SupportedMerchandisingAssociationName	
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=MASSOC
  IBM_SupportedSemanticSpecifiers=IBM_Admin_SupportedSemanticSpecifiers
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATALOG
  IBM_CatalogStoreDetailsProfile=IBM_Admin_CatalogStoreDetailsProfile
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATTR
  IBM_AttributeDictionaryAttribute=IBM_Admin_AttributeDictionaryAttribute
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATTRVAL
  IBM_AttributeDictionaryAttribute=IBM_Admin_AttributeDictionaryAttribute
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATTRIBUTE
  IBM_Attribute=IBM_Admin_Attribute
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=ATTRVALUE
  IBM_Attribute=IBM_Admin_Attribute
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATGROUP
    IBM_IDENTIFIER=IBM_Admin_IDENTIFIER
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=STORECENT
    IBM_IDENTIFIER=IBM_Admin_IDENTIFIER
END_PROFILE_ALIASES


<!-- ========================================================================= -->
<!--  Insert into CEDISPCTX table				                               -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=INSERT_CEDISPCTX
	base_table=CEDISPCTX
	sql=
		INSERT INTO CEDISPCTX
			(CEDISPCTX_ID, CATGROUP_ID, STOREENT_ID, STARTTIME, DISPLAYMODE)
		VALUES
			( ?cedispctxId? , ?categoryId? , ?storeId?, ?startTime?, ?displayMode?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Update display mode for CEDISPCTX table				                   -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=UPDATE_DISPLAYMODE_FOR_CEDISPCTX_BY_CEDISPCTXID
	base_table=CEDISPCTX
	sql=
		UPDATE CEDISPCTX
			SET DISPLAYMODE = ?displayMode?
		WHERE
			CEDISPCTX_ID = ?cedispctxId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert into CEDYNDISPCTX table				                           -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=INSERT_CEDYNDISPCTX
	base_table=CEDYNDISPCTX
	
	dbtype=oracle
	sql=
		INSERT INTO CEDYNDISPCTX
			(CEDYNDISPCTX_ID, CATGROUP_ID, STOREENT_ID, STARTTIME,LASTUPDATE)
		VALUES
			( ?cedyndispctxId? , ?categoryId? , ?storeId?, ?startTime?, SYSTIMESTAMP)
	
	dbtype=db2
	sql=
		INSERT INTO CEDYNDISPCTX
			(CEDYNDISPCTX_ID, CATGROUP_ID, STOREENT_ID, STARTTIME,LASTUPDATE)
		VALUES
			( ?cedyndispctxId? , ?categoryId? , ?storeId?, ?startTime?, current timestamp)
	
	sql=
		INSERT INTO CEDYNDISPCTX
			(CEDYNDISPCTX_ID, CATGROUP_ID, STOREENT_ID, STARTTIME,LASTUPDATE)
		VALUES
			( ?cedyndispctxId? , ?categoryId? , ?storeId?, ?startTime?, current timestamp)
										
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!--  Update  CEDYNDISPCTX table with Last Update time Stamp			       -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=UPDATE_CEDYNDISPCTX_LASTUPDATED
	base_table=CEDYNDISPCTX
	
	dbtype=oracle
	sql=
		UPDATE CEDYNDISPCTX 
				SET LASTUPDATE=SYSTIMESTAMP 
			WHERE 
				CEDYNDISPCTX_ID = ?cedyndispctxId?
				
	dbtype=db2
	sql=
		UPDATE CEDYNDISPCTX 
				SET LASTUPDATE=current timestamp 
			WHERE 
				CEDYNDISPCTX_ID = ?cedyndispctxId?
							
	sql=
		UPDATE CEDYNDISPCTX 
				SET LASTUPDATE=current timestamp 
			WHERE 
				CEDYNDISPCTX_ID = ?cedyndispctxId?
								
END_SQL_STATEMENT

<!-- ====================================================================== 
	Update the LASTUPDATE timestamp of the catalog entry display context
	@param cedispctxId The catalog entry display context ID
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=UPDATE_CEDISPCTX_UPDATE_LASTUPDATE_BY_CEDISPCTXID
	base_table=CEDISPCTX
	dbtype=oracle
	sql=
			UPDATE 
						CEDISPCTX
	     	SET 
	     				CEDISPCTX.LASTUPDATE=SYSTIMESTAMP
	     				
	     	WHERE
						CEDISPCTX.CEDISPCTX_ID=?cedispctxId?
	sql=
			UPDATE 
						CEDISPCTX
	     	SET 
	     				CEDISPCTX.LASTUPDATE=CURRENT TIMESTAMP

	     	WHERE
						CEDISPCTX.CEDISPCTX_ID=?cedispctxId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select CEDISPCTX_ID from CEDISPCTX table   	                           -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=SELECT_CEDISPCTXID_FROM_CEDISPCTX
	base_table=CEDISPCTX
	sql=
	SELECT CEDISPCTX_ID 
	   FROM CEDISPCTX 
	   WHERE CATGROUP_ID =?categoryId? AND STOREENT_ID = ?storeId?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Select configuration info from CEDISPCTX table   	                   -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=SELECT_CONFIG_FROM_CEDISPCTX_BY_STORE_ID_AND_CATEGORY_ID
	base_table=CEDISPCTX
	sql=
	SELECT STARTTIME, DISPLAYMODE, CEDISPCTX_ID 
	   FROM CEDISPCTX 
	   WHERE CATGROUP_ID =?categoryId? AND STOREENT_ID = ?storeId? AND STARTTIME is null
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select configuration info from CEDISPCTX table   	                   -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=SELECT_CONFIG_FROM_CEDISPCTX_BY_STORE_ID_AND_CATEGORY_ID_AND_STARTTIME
	base_table=CEDISPCTX
	sql=
	SELECT STARTTIME, DISPLAYMODE, CEDISPCTX_ID 
	   FROM CEDISPCTX 
	   WHERE CATGROUP_ID =?categoryId? AND STOREENT_ID = ?storeId? AND STARTTIME = ?startTime?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert into CATENTDISPCONF table				                           -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=INSERT_CEDISPCONF
	base_table=CEDISPCONF
	sql=
	INSERT INTO 
	     CEDISPCONF
			(CEDISPCONF_ID, CATENTRY_ID, PROPERTY, VALUE, CEDISPCTX_ID)
		VALUES
			( ?cedispconfId? , ?catentryId? , ?property? , ?value? , ?cedispctxId?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select CATENTRY_ID AND VALUE from CEDISPCONF table                       -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=SELECT_CEDISPCONF_DATA
	base_table=CEDISPCONF
	sql=
	SELECT CATENTRY_ID, VALUE
	   FROM CEDISPCONF
	   WHERE PROPERTY =?property? AND CEDISPCTX_ID =?cedispctxId? 
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!--  Select CEDISPCTX_ID from CEDISPCONF table   	                           -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=SELECT_CEDISPCTXID_FROM_CEDISPCONF
	base_table=CEDISPCONF
	sql=
	SELECT CEDISPCTX_ID 
	   FROM CEDISPCONF 
	   WHERE CATENTRY_ID =?catentryId? AND PROPERTY = ?property?
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!--  Delete all catentryId/value pair info from CEDISPCONF table   	                           -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_CATEGORY_DATA_IN_CEDISPCONF
	base_table=CEDISPCONF
	sql=
		DELETE 
			FROM  CEDISPCONF
		WHERE
		CEDISPCONF.CEDISPCTX_ID=?cedispctxId? and CEDISPCONF.PROPERTY = ?property?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select ALL from CEDISPCTX table   	                           -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=SELECT_ALL_FROM_CEDISPCTX
	base_table=CEDISPCTX
	sql=
	SELECT CEDISPCTX_ID, CATGROUP_ID, STOREENT_ID, STARTTIME 
	   FROM CEDISPCTX 
	   WHERE STOREENT_ID IN (SELECT STORE_ID FROM STOREREL WHERE STRELTYP_ID=-4 
	      AND (RELATEDSTORE_ID= ?storeId? OR RELATEDSTORE_ID = 
	      (SELECT SL.RELATEDSTORE_ID FROM STOREREL SL WHERE SL.STORE_ID=?storeId? 
	          AND SL.RELATEDSTORE_ID <> ?storeId? AND STRELTYP_ID=-4)))
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  delete from CEDISPCTX table by CEDISPCTX_ID	                       -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=DELETE_FROM_CEDISPCTX_BY_CEDISPCTX_ID
	base_table=CEDISPCTX
	sql=
	DELETE FROM CEDISPCTX WHERE CEDISPCTX_ID = ?cedispctxId?
	   
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  delete from CEDISPCTX table by CEDISPCTX_ID	                       -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=SELECT_FROM_CEDISPCONF_BY_CEDISPCTX_ID
	base_table=CEDISPCONF
	sql=
	SELECT * FROM CEDISPCONF WHERE CEDISPCTX_ID = ?cedispctxId?
	   
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select ATTRIBUTE , WEIGHT , SORT_PREF from CEDYNDISPCONF table	       -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=SELECT_ATTR_WEIGHT_FROM_CEDYNDISPCONF
	base_table=CEDYNDISPCONF
	sql=
	SELECT ATTRIBUTE , WEIGHT , SORT_PREF
	   FROM CEDYNDISPCONF 
	   WHERE CEDYNDISPCTX_ID = ?cedyndispctx_id?
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!--  Delete all attribute/weight pair info from CEDYNDISPCONF table   	       -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_FORMULA_DATA_IN_CEDYNDISPCONF
	base_table=CEDYNDISPCONF
	sql=
		DELETE 
			FROM  CEDYNDISPCONF
		WHERE
		CEDYNDISPCONF.CEDYNDISPCTX_ID=?cedyndispctxId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert into CEDYNDISPCONF table				                           -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=INSERT_CEDYNDISPCONF
	base_table=CEDYNDISPCONF
	sql=
	INSERT INTO 
	     CEDYNDISPCONF
			(CEDYNDISPCONF_ID, ATTRIBUTE , WEIGHT , SORT_PREF , CEDYNDISPCTX_ID)
		VALUES
			( ?cedyndispconfId? , ?attributeName? , ?attributeWeight? , ?sortPref? , ?cedyndispctxId?)
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!--  Select CEDYNDISPCTX_ID from CEDYNDISPCTX table   	                       -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=SELECT_CEDYNDISPCTX_ID_FROM_CEDYNDISPCTX
	base_table=CEDYNDISPCTX
	sql=
	SELECT CEDYNDISPCTX_ID 
	   FROM CEDYNDISPCTX 
	   WHERE CATGROUP_ID =?categoryId? AND STOREENT_ID = ?storeId?
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!--  Delete a context record  from CEDYNDISPCTX table   	                   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=DELETE_CONTEXT_CEDYNDISPCTX
	base_table=CEDYNDISPCTX
	sql=
		DELETE 
			FROM  CEDYNDISPCTX
		WHERE
		CEDYNDISPCTX.CEDYNDISPCTX_ID= ?cedyndispctxId? 
END_SQL_STATEMENT

<!-- ===========================================================================
     Query to retrieve the external content for a given external content ID.
	 @param contentId
		The unique identifier for external content.
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/EXTERNAL_CONTENT+IBM_Admin_IdResolve
  base_table=EXTERNAL_CONTENT
  sql= SELECT EXTERNAL_CONTENT.$COLS:EXTERNAL_CONTENT$ 
  		FROM 
  			EXTERNAL_CONTENT 		 
  		WHERE 
  			EXTERNAL_CONTENT.CONTENT_ID IN (?contentId?)
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================================= 
	Execute during catalog entry external content update. Use to delete all cotent assets for the extenal contents.
	@param contentId
		The unique identifier for external content.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_RemoveAllExternalContentAssetsForExternalContent
	base_table=EXTERNAL_CONTENT_ASSET

	sql=
	DELETE FROM EXTERNAL_CONTENT_ASSET 
	WHERE CONTENT_ID IN (?contentId?)
			
END_SQL_STATEMENT



<!-- ====================================================================== 
	Select all external content types.
	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_All_ExternalContentType
	base_table=EXTERNAL_CONTENT_TYPE
	sql=
		SELECT EXTERNAL_CONTENT_TYPE.$COLS:EXTERNAL_CONTENT_TYPE$ FROM EXTERNAL_CONTENT_TYPE
END_SQL_STATEMENT


<!-- ====================================================================== 
	Select the owning store ID of the catalog entry external content reference
	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogOverrideGroupForCatalogEntryExternalContentReference
	base_table=CATENTRY_EXTERNAL_CONTENT_REL
	sql=
		SELECT CE_EXTERNAL_CONTENT_REL_ID, CATOVRGRP.$COLS:CATOVRGRP$
		FROM CATENTRY_EXTERNAL_CONTENT_REL
		 			JOIN CATOVRGRP ON CATENTRY_EXTERNAL_CONTENT_REL.CATOVRGRP_ID=CATOVRGRP.CATOVRGRP_ID
      WHERE  CE_EXTERNAL_CONTENT_REL_ID IN (?UniqueID?)

END_SQL_STATEMENT


<!-- ====================================================================== 
	Select the owning store ID of the catalog group external content reference
	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogOverrideGroupForCatalogGroupExternalContentReference
	base_table=CATGROUP_EXTERNAL_CONTENT_REL
	sql=
		SELECT CG_EXTERNAL_CONTENT_REL_ID, CATOVRGRP.$COLS:CATOVRGRP$
		FROM CATGROUP_EXTERNAL_CONTENT_REL
		 			JOIN CATOVRGRP ON CATGROUP_EXTERNAL_CONTENT_REL.CATOVRGRP_ID=CATOVRGRP.CATOVRGRP_ID
      WHERE  CG_EXTERNAL_CONTENT_REL_ID IN (?UniqueID?)

END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert into JOBSTATUS table				                               -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=INSERT_JOBSTATUS
	base_table=JOBSTATUS
	sql=
	INSERT INTO 
	     JOBSTATUS
			(JOBSTATUS_ID, STATUS, CALLPROGINFO, STATUSMSG, USERS_ID, PROGRESS, JOBTYPE, PROPERTIES)
		VALUES
			( ?jobStatusId? , ?status? , ?callingProgramInfo? , ?statusMsg? , ?userId?, ?progress?, ?jobType?, ?properties?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert into JOBSTATUS table without user ID				               -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=INSERT_JOBSTATUS_WITHOUT_USERID
	base_table=JOBSTATUS
	sql=
	INSERT INTO 
	     JOBSTATUS
			(JOBSTATUS_ID, STATUS, CALLPROGINFO, STATUSMSG, PROGRESS, JOBTYPE, PROPERTIES)
		VALUES
			( ?jobStatusId? , ?status? , ?callingProgramInfo? , ?statusMsg? , ?progress?, ?jobType?, ?properties?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Update the status, statusmsg, progress, lastupdate, finishtime columns of JOBSTATUS
	@param jobStatusId The job status ID.
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=Update_JobStatus_Status_StatusMsg_FinishTime_Progress_By_JobStatusID
	base_table=JOBSTATUS
	dbtype=oracle
	sql=
			UPDATE 
						JOBSTATUS
	     	SET 
	     				JOBSTATUS.STATUS = ?status?,
	     				JOBSTATUS.STATUSMSG = ?statusMsg?,
	     				JOBSTATUS.PROGRESS = ?progress?,
	     				JOBSTATUS.LASTUPDATE=SYSTIMESTAMP,
	     				JOBSTATUS.FINISHTIME=SYSTIMESTAMP
	     				
	     	WHERE
						JOBSTATUS.JOBSTATUS_ID=?jobStatusId?
	sql=
			UPDATE 
						JOBSTATUS
	     	SET 
	     				JOBSTATUS.STATUS = ?status?,
	     				JOBSTATUS.STATUSMSG = ?statusMsg?,
	     				JOBSTATUS.PROGRESS = ?progress?,
	     				JOBSTATUS.LASTUPDATE=CURRENT TIMESTAMP,
	     				JOBSTATUS.FINISHTIME=CURRENT TIMESTAMP
	     				
	     	WHERE
						JOBSTATUS.JOBSTATUS_ID=?jobStatusId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Update the status, statusmsg, progress, lastupdate columns of JOBSTATUS
	@param jobStatusId The job status ID
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=Update_JobStatus_Status_StatusMsg_Progress_By_JobStatusID
	base_table=JOBSTATUS
	dbtype=oracle
	sql=	
	       UPDATE 
						JOBSTATUS
	     	SET 
	     				JOBSTATUS.STATUS = ?status?,
	     				JOBSTATUS.STATUSMSG = ?statusMsg?,
	     				JOBSTATUS.PROGRESS = ?progress?,
	     				JOBSTATUS.LASTUPDATE=SYSTIMESTAMP
	     	WHERE
						JOBSTATUS.JOBSTATUS_ID=?jobStatusId?
	
	sql=
			UPDATE 
						JOBSTATUS
	     	SET 
	     				JOBSTATUS.STATUS = ?status?,
	     				JOBSTATUS.STATUSMSG = ?statusMsg?,
	     				JOBSTATUS.PROGRESS = ?progress?,
	     				JOBSTATUS.LASTUPDATE=CURRENT TIMESTAMP
	     	WHERE
						JOBSTATUS.JOBSTATUS_ID=?jobStatusId?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Update the progress, lastupdate columns of JOBSTATUS
	@param jobStatusId The job status ID
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=Update_JobStatus_Progress_By_JobStatusID
	base_table=JOBSTATUS
	dbtype=oracle
	sql=	
	       UPDATE 
						JOBSTATUS
	     	SET 
	     				JOBSTATUS.PROGRESS = ?progress?,
	     				JOBSTATUS.LASTUPDATE=SYSTIMESTAMP
	     	WHERE
						JOBSTATUS.JOBSTATUS_ID=?jobStatusId?
	
	sql=
			UPDATE 
						JOBSTATUS
	     	SET 
	     				JOBSTATUS.PROGRESS = ?progress?,
	     				JOBSTATUS.LASTUPDATE=CURRENT TIMESTAMP
	     	WHERE
						JOBSTATUS.JOBSTATUS_ID=?jobStatusId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select information from JOBSTATUS table   	                       -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=Get_StatusInfo_from_JOBSTATUS_by_jobStatusId
	base_table=JOBSTATUS
	sql=
	SELECT JOBSTATUS.JOBSTATUS_ID,  
	       JOBSTATUS.STATUS, 
	       JOBSTATUS.STARTTIME,
	       JOBSTATUS.FINISHTIME,
	       JOBSTATUS.LASTUPDATE,
	       JOBSTATUS.PROGRESS,
	       JOBSTATUS.USERS_ID,
	       JOBSTATUS.INTERNALID,
	       JOBSTATUS.JOBTYPE,
	       JOBSTATUS.CALLPROGINFO,
	       JOBSTATUS.PROPERTIES,
	       JOBSTATUS.STATUSMSG
	   FROM JOBSTATUS 
	   WHERE JOBSTATUS_ID = ?jobStatusId?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert into BUSEVENT table 			                                   -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=INSERT_BUSEVENT
	base_table=BUSEVENT
	sql=
	INSERT INTO BUSEVENT (BUSEVENT_ID, SEQUENCE, CREATETSTMP, EVENTDATA, CHECKED) 
	   VALUES (?busEventId?, ?sequence?, ?createTimestamp?, ?eventData?, ?checked?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Insert into JOBSUMMARY table				                               -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=INSERT_JOBSUMMARY
	base_table=JOBSUMMARY
	sql=
	INSERT INTO 
	     JOBSUMMARY
			(JOBSUMMARY_ID, JOBSTATUS_ID, SEQUENCE, SUMMARY)
		VALUES
			( ?jobSummaryId?, ?jobStatusId? , ?sequence?, ?summary?)
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Select information from JOBSUMMARY table   	                       -->
<!-- ========================================================================= --> 
BEGIN_SQL_STATEMENT
	name=Get_Summary_from_JOBSUMMARY_by_jobStatusId
	base_table=JOBSUMMARY
	sql=
	SELECT SEQUENCE,
	       SUMMARY
	   FROM JOBSUMMARY 
	   WHERE JOBSTATUS_ID = ?jobStatusId? ORDER BY SEQUENCE ASC
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select the number of relationships between the catalog entries and the attribute dictionary attributes
	with the given attribute identifiers and catalog entry IDs
	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogEntryAttrDictAttributeRelationByCatEntryIDAndAttrIdentifier
	base_table=CATENTRYATTR
	sql=
		SELECT COUNT(*) AS COUNT 
		 FROM CATENTRYATTR 
     JOIN ATTR ON CATENTRYATTR.ATTR_ID=ATTR.ATTR_ID
     WHERE ATTR.IDENTIFIER IN (?identifier?) and CATENTRY_ID IN (?catEntryId?)

END_SQL_STATEMENT

<!-- ====================================================================== 
	Select the number of relationships between the catalog entries and the external content
	with the given catalog entry IDs, language IDs and content type usage
	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogEntryExternalContentRelationByCatEntryIDAndLanguageIDAndContentTypeUsage
	base_table=CATENTRY_EXTERNAL_CONTENT_REL
	sql=
		SELECT COUNT(*) AS COUNT 
		 FROM CATENTRY_EXTERNAL_CONTENT_REL 
     JOIN EXTERNAL_CONTENT_TYPE ON CATENTRY_EXTERNAL_CONTENT_REL.TYPE=EXTERNAL_CONTENT_TYPE.IDENTIFIER
     WHERE  CATENTRY_ID IN (?catEntryId?)
      AND    LANGUAGE_ID IN (?languageID?)
      AND    EXTERNAL_CONTENT_TYPE.USAGE IN (?usage?)
      AND    CATOVRGRP_ID IN (SELECT CATOVRGRP_ID FROM STORECATOVRGRP WHERE STOREENT_ID IN ( $STOREPATH:catalog$ ))        

END_SQL_STATEMENT



<!-- ====================================================================== 
	Select the number of relationships between the catalog groups and the external content
	with the given catalog group IDs, language IDs and content type usage
	
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_CatalogGroupExternalContentRelationByCatGroupIDAndLanguageIDAndContentTypeUsage
	base_table=CATGROUP_EXTERNAL_CONTENT_REL
	sql=
		SELECT COUNT(*) AS COUNT 
		 FROM CATGROUP_EXTERNAL_CONTENT_REL 
     JOIN EXTERNAL_CONTENT_TYPE ON CATGROUP_EXTERNAL_CONTENT_REL.TYPE=EXTERNAL_CONTENT_TYPE.IDENTIFIER
     WHERE  CATGROUP_ID IN (?catGroupId?)
      AND    LANGUAGE_ID IN (?languageID?)
      AND    EXTERNAL_CONTENT_TYPE.USAGE IN (?usage?)
      AND    CATOVRGRP_ID IN (SELECT CATOVRGRP_ID FROM STORECATOVRGRP WHERE STOREENT_ID IN ( $STOREPATH:catalog$ ))        

END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the delta count from the catentry delta update table  			   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=COUNT_ANY_DELTA_CATENTRY_INDEXING
	base_table=TI_DELTA_CATENTRY	
	sql= 
	SELECT COUNT (*) as ROWCOUNT 
	FROM TI_DELTA_CATENTRY 
	WHERE MASTERCATALOG_ID = ?masterCatalogId? AND CATENTRY_ID !=-1
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!--  Get the delta count from the catgroup delta update table  			   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=COUNT_ANY_DELTA_CATGROUP_INDEXING
	base_table=TI_DELTA_CATGROUP	
	sql= 
	SELECT COUNT (*) as ROWCOUNT 
	FROM TI_DELTA_CATGROUP  
	WHERE MASTERCATALOG_ID = ?masterCatalogId? AND CATGROUP_ID !=-1
END_SQL_STATEMENT
<!-- ========================================================================= -->
<!--  Get the delta count from the invetnory delta update table  			   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=COUNT_ANY_DELTA_INVENTORY_INDEXING
	base_table=TI_DELTA_INVENTORY	
	sql= 
	SELECT COUNT (*) as ROWCOUNT 
	FROM TI_DELTA_INVENTORY 
	WHERE MASTERCATALOG_ID = ?masterCatalogId? AND CATENTRY_ID !=-1
END_SQL_STATEMENT
