BEGIN_SYMBOL_DEFINITIONS

	
	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	
	<!-- CATALOG table -->
	COLS:CATALOG=CATALOG:*
	COLS:CATALOG_ID=CATALOG:CATALOG_ID
	
	<!-- CATGROUP table -->
	COLS:CATGROUP=CATGROUP:*
	COLS:CATGROUP_ID=CATGROUP:CATGROUP_ID
	COLS:MEMBER_ID=CATGROUP:MEMBER_ID
	
	
	
	<!-- STORECAT table -->
	COLS:STORECAT=STORECAT:*
	
	
	<!-- STORECGRP table -->
	COLS:STORECGRP=STORECGRP:*
	
	<!-- Other tables -->
	COLS:ATTRIBUTE=ATTRIBUTE:*
	COLS:ATTRVALUE=ATTRVALUE:*
	COLS:CATENTDESC=CATENTDESC:* 
	COLS:CATENTREL=CATENTREL:*
	COLS:CATENTATTR=CATENTATTR:*
	COLS:CATENTSHIP=CATENTSHIP:*
	
	COLS:CATGPENREL=CATGPENREL:*
	COLS:CATGPENREL:CATGROUP_ID=CATGPENREL:CATGROUP_ID
	
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
	COLS:CATGRPREL:CATGROUP_ID_PARENT=CATGRPREL:CATGROUP_ID_PARENT
	
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

	COLS:CALCODE=CALCODE:*
	COLS:FACETCATGRP=FACETCATGRP:*
	COLS:CATGRPRULE=CATGRPRULE:*
	
  COLS:CATGROUP_EXTERNAL_CONTENT_REL=CATGROUP_EXTERNAL_CONTENT_REL:*
	
END_SYMBOL_DEFINITIONS


<!-- ===================================================================================== -->
<!-- ============ Catalog Group Change and Process Queries Begin ========================= -->
<!-- ===================================================================================== -->


<!-- ============================================================================================= -->
<!-- This SQL will return the description of a catalog group in a language for which the languageId-->
<!-- is passed in the xpath. This SQL can fetch multiple descriptions for multiple catalog groups  -->
<!-- based on the catalog group id and languageId passed in the xpath.				   -->	
<!-- Used by ChangeCatalogGroupDescritpion service.                                                -->
<!--                                                                                               -->
<!-- @param UniqueID UniqueId of catalog group whose description has to be fetched.          -->
<!-- @param languageID  Language of description to be fetched                                      -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]/Description[(@languageID=)]+IBM_Admin_CatalogGroupDescriptions
	base_table=CATGRPDESC	
	sql=
		                            
              SELECT 
                            CATGRPDESC.$COLS:CATGRPDESC$
              FROM
                            CATGRPDESC
              WHERE                            
                            CATGRPDESC.CATGROUP_ID IN (?UniqueID?) AND
                            CATGRPDESC.LANGUAGE_ID IN (?languageID?)
			
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the details of catalog group whose uniqueId is passed in xpath.	   -->
<!-- The SQL fetches only those catalog groups which are not marked for delete and belongs to the  -->
<!-- store present in current business context. Multiple results are returned if multiple catalog  -->	
<!-- group ids are passed. Used by ChangeCatalogGroupIdentifier service.			   -->
<!-- @param UniqueID UniqueId of catalog group whose details has to be fetched.              -->
<!-- @param CTX:STORE_ID  Store Id of store for which the catalog group has to be fetched.	   -->
<!--			  Store Id is retrieved form the business context                          -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_CatalogGroupIdentifierProfile
	base_table=CATGROUP
	sql=
		                            
              SELECT 
                            CATGROUP.$COLS:CATGROUP$
              FROM
                            CATGROUP
                             LEFT OUTER JOIN STORECGRP ON STORECGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID
              WHERE                            
                            CATGROUP.CATGROUP_ID in (?UniqueID?) AND
                            STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$) AND
                             CATGROUP.MARKFORDELETE = 0							
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the navigation relationship between a parent catalog group and child     -->
<!-- catalog group which belongs to the catalog preset in business context. This relationship data -->
<!-- is used to change the display sequence of sub categories of a category as well as the parent  -->	
<!-- category of a category. Multiple results are returned if multiple Catalog Group IDs are       -->
<!-- passed. Used by ChangeCatalogGroupNavigationRelationship service.				   -->
<!-- @param childCatalogGroupID UniqueId of child catalog group.		                   -->
<!-- @param parentCatalogGroupID UniqueId of parent catalog group.		                   -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the navigation relationship has 	   -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup/NavigationRelationship[(@childCatalogGroupID=) and (@parentCatalogGroupID=)]+IBM_Admin_CatalogGroupNavigationRelationshipProfile
	base_table=CATGRPREL
	sql=
		                            
              SELECT 
                         CATGRPREL.$COLS:CATGRPREL$
              FROM
                         CATGRPREL	
			  WHERE                            
                         CATGRPREL.CATGROUP_ID_PARENT IN (?parentCatalogGroupID?) and
                         CATGRPREL.CATGROUP_ID_CHILD IN (?childCatalogGroupID?) and
                         CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$ 
		
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the navigation relationship between a parent catalog group and child     -->
<!-- catalog entry which belongs to the catalog preset in business context. This relationship data -->
<!-- is used to change the display sequence of child catalog entry of a category as well as the    -->	
<!-- parent category of a catalog entry. Multiple results are returned if multiple child catalog   -->
<!-- entry and and multiple parent catalog group IDs are passed.				   -->
<!-- Used by ChangeCatalogGroupNavigationRelationship service.				           -->
<!-- @param @childCatalogEntryID UniqueId of child catalog entry.		                   -->
<!-- @param @parentCatalogGroupID UniqueId of parent catalog group.		                   -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the navigation relationship has 	   -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup/NavigationRelationship[(@childCatalogEntryID=) and (@parentCatalogGroupID=)]+IBM_Admin_CatalogGroupNavigationRelationshipProfile
	base_table=CATGPENREL
	sql=
		                            
              SELECT 
			  CATGPENREL.$COLS:CATGPENREL$
              FROM
                            CATGPENREL 
			  WHERE                            
                            CATGPENREL.CATGROUP_ID  IN (?parentCatalogGroupID?) and
                            CATGPENREL.CATENTRY_ID IN (?childCatalogEntryID?) and
                            CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the navigation relationship between a parent catalog group and child     -->
<!-- catalog entry which belongs to the given catalog. 						   -->
<!-- Used by Link service to verify if a link already exists.				           -->
<!-- @param @childCatalogEntryID UniqueId of child catalog entry.		                   -->
<!-- @param @parentCatalogGroupID UniqueId of parent catalog group.		                   -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup/NavigationRelationship[(@childCatalogEntryID=) and (@parentCatalogGroupID=) and (@catalogId=)]+IBM_Admin_CatalogGroupNavigationRelationshipProfile
	base_table=CATGPENREL
	sql=
		                            
              SELECT 
			  CATGPENREL.$COLS:CATGPENREL$
              FROM
                            CATGPENREL 
			  WHERE                            
                            CATGPENREL.CATGROUP_ID  = (?parentCatalogGroupID?) and
                            CATGPENREL.CATENTRY_ID = (?childCatalogEntryID?) and
                            CATGPENREL.CATALOG_ID = ?catalogId?

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the navigation relationship between a parent catalog group and child     -->
<!-- catalog entry as well as child catalog group which belongs to the catalog preset in business  -->
<!-- context. This relationship data is used to change the display sequence of child catalog entry -->	
<!-- and child catalog groups of a category as well as the parent category. Multiple results are   -->
<!-- returned if multiple child catalog entry, child catalog group and parent catalog group IDs are-->
<!-- passed. Used by ChangeCatalogGroupNavigationRelationship service.				   -->
<!-- @param childCatalogEntryID UniqueId of child catalog entry.		                   -->
<!-- @param childCatalogGroupID UniqueId of child catalog group.		                   -->
<!-- @param parentCatalogGroupID UniqueId of parent catalog group.		                   -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the navigation relationship has 	   -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- ============================================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup/NavigationRelationship[(@childCatalogEntryID=) and (@childCatalogGroupID=) and (@parentCatalogGroupID=)]+IBM_Admin_CatalogGroupNavigationRelationshipProfile
	base_table=CATGROUP
	sql=
		     SELECT 
                            CATGROUP.$COLS:CATGROUP_ID$,			    
			    			CATGRPREL.$COLS:CATGRPREL$,
			    			CATGPENREL.$COLS:CATGPENREL$
              FROM
                            CATGROUP	
					
				LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					CATGRPREL.CATGROUP_ID_PARENT= CATGROUP.CATGROUP_ID 
					AND 
					CATGRPREL.CATGROUP_ID_CHILD IN (?childCatalogGroupID?)
					AND
					CATGRPREL.CATALOG_ID IN ($CTX:CATALOG_ID$)
				)
				LEFT OUTER JOIN CATGPENREL 
				ON	
				(
					CATGPENREL.CATGROUP_ID = CATGROUP.CATGROUP_ID 
					AND 
					CATGPENREL.CATENTRY_ID IN (?childCatalogEntryID?)
					AND
					CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$ 
				)
              WHERE                            
                             
                    CATGROUP.CATGROUP_ID  IN (?parentCatalogGroupID?)
		

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the details of a Catalog Group along with its merchandising associations,-->
<!-- catalog group to catalog entry relations, catalog group to catalog group relatios if catalog  -->
<!-- is not a top category other wise top category relation and catalog group to store relation.   -->	
<!-- Multiple results are returned if multiple catalog group ids are passed. Catalog Id is         -->
<!-- retrieved from business context and used to retrieve category to category relation or category-->
<!-- to catalog relation for a if catalog group is top category.				   -->	
<!-- @param UniqueID UniqueId of catalog group.						   -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the navigation relationship has 	   -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- @param CTX:STORE_ID  Store Id of store for which the catalog group has to be fetched.	   -->
<!--			  Store Id is retrieved form the business context                          -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_CatalogGroupProfile
	base_table=CATGROUP
	sql=
		SELECT
			CATGROUP.$COLS:CATGROUP$,
			CATGRPREL.$COLS:CATGRPREL$,
			STORECGRP.$COLS:STORECGRP$,
			CATGPCALCD.$COLS:CATGPCALCD$,
			CALCODE.$COLS:CALCODE$
		FROM CATGROUP
		
			LEFT OUTER JOIN CATGRPREL ON (
				CATGRPREL.CATGROUP_ID_CHILD = CATGROUP.CATGROUP_ID AND
				CATGRPREL.CATALOG_ID IN ($CTX:CATALOG_ID$)
			)
			JOIN STORECGRP ON (
				STORECGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID AND
				STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)
			)
			LEFT OUTER JOIN CATGPCALCD ON (
				CATGPCALCD.CATGROUP_ID = CATGROUP.CATGROUP_ID
			)
			LEFT OUTER JOIN CALCODE ON (
				CALCODE.CALCODE_ID = CATGPCALCD.CALCODE_ID
			)
		WHERE
			CATGROUP.MARKFORDELETE = 0 AND
			CATGROUP.CATGROUP_ID IN (?UniqueID?)	
										
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get all the catalog entry relationships of the catalog group based on the catalog group id. 
	@param UniqueId The catalog group id 
	@param CTX:CATALOG_ID The catalog id is retreived from the context
       
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_CatGroupAllChildCatentryRelation
	base_table=CATGPENREL
	sql=
		SELECT 
	     				CATGPENREL.$COLS:CATGPENREL$
	     	FROM
	     				CATGPENREL				  
	     	WHERE
	     				CATGPENREL.CATGROUP_ID in (?UniqueID?) 
					AND 
					CATGPENREL.CATALOG_ID IN ($CTX:CATALOG_ID$)
					   
END_XPATH_TO_SQL_STATEMENT

<!-- ============ Change Catalog Group Parent  ========================= -->

	<!-- ============================================================================================= -->
	<!-- Fetch a catalog group with parent catalog group relationships and if this is a top category   -->
	<!-- also fetch the relationship to the catalog.                                                   -->
	<!-- This SQL will fetch a catgroup and the corresponding catgrprel where the catalog group is     -->
	<!-- a child and also the cattogrp that points to this catalog group.                              -->       
	<!-- catgroup_id_child in @catGroupId and catalog_id in @catalogId and catalog_id_link is not null --> 
	<!-- @param UniqueID Id of catalog group to fetch                                                -->
	<!-- @param catalogId  Catalog id                                                                  -->
	<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT	                                                                          
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)] and (@catalogId=)]+IBM_Admin_CatalogGroupParentAndTopCatalogGroupProfile
	base_table=CATGROUP
	sql=		                            
             	SELECT 
	     			CATGROUP.$COLS:CATGROUP_ID$,
				CATGRPREL.$COLS:CATGRPREL$,
				CATTOGRP.$COLS:CATTOGRP$

	     					     				
	     	FROM
	     			CATGROUP 
				LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					CATGRPREL.CATGROUP_ID_CHILD= CATGROUP.CATGROUP_ID 
					AND 
					CATGRPREL.CATALOG_ID IN (?catalogId?)
				)
				LEFT OUTER JOIN CATTOGRP
				ON
				(
					CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID 
					AND
					CATTOGRP.CATALOG_ID IN (?catalogId?)

				) 

 		WHERE
				CATGROUP.MARKFORDELETE=0 AND		
				CATGROUP.CATGROUP_ID  IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the relationship between the given catalog group and its parent catalog  -->
<!-- group if catalog group is not a top category.		                                   -->
<!-- It will return the relationship between catalog group to catalog present in business context  -->	
<!-- if catalog group is a top category.						           -->
<!-- Multiple results are returned if multiple catalog group ids are passed.                       -->
<!-- Data will not be returned if catalog group is marked for delete or it does not belong to	   -->
<!-- store present in the business context. Used by ChangeCatalogGroupParentCatalogGroupIdentifier -->
<!-- service.											   -->
<!-- @param UniqueID UniqueId of catalog group.				                   -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the navigation relationship has 	   -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_CatalogGroupParentAndTopCatalogGroupProfile
	base_table=CATGROUP
	sql=		                            
             	SELECT 
	     			CATGROUP.$COLS:CATGROUP_ID$,
				CATGRPREL.$COLS:CATGRPREL$,
				CATTOGRP.$COLS:CATTOGRP$

	     					     				
	     	FROM
	     			CATGROUP 
				LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					CATGRPREL.CATGROUP_ID_CHILD= CATGROUP.CATGROUP_ID 
					AND 
					CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$
				)
				LEFT OUTER JOIN CATTOGRP
				ON
				(
					CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID 
					AND
					CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$

				) 

 		WHERE
				CATGROUP.MARKFORDELETE=0 AND		
				CATGROUP.CATGROUP_ID  IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT


BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- ============================================================================================= -->
	<!-- Fetch a catalog group with its link parent catalog groups and linked catalog if it is linked  -->
	<!-- as a top category.                                                                            -->
	<!-- This SQL will fetch a catgroup and the corresponding catgrprel where the catalog group is     -->
	<!-- a linked child and also the cattogrp where the catalog has a link to the catalog group.       -->       
	<!-- @param UniqueID Id of catalog group to fetch                                                -->
	<!-- @param catalogId  The source catalog id for the catalog group                                 -->
	<!-- ============================================================================================= -->
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)] and (@catalogId=)]+IBM_Admin_CatalogGroupLinkedParentsProfile
	base_table=CATGROUP
	sql=		                            
             	SELECT 
	     			CATGROUP.$COLS:CATGROUP_ID$,
				CATGRPREL.$COLS:CATGRPREL$,
				CATTOGRP.$COLS:CATTOGRP$

	     					     				
	     	FROM
	     			CATGROUP 
				LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					CATGRPREL.CATGROUP_ID_CHILD= CATGROUP.CATGROUP_ID 
					AND 
					CATGRPREL.CATALOG_ID_LINK IN (?catalogId?)
				)
				LEFT OUTER JOIN CATTOGRP
				ON
				(
					CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID 
					AND
					CATTOGRP.CATALOG_ID_LINK IN (?catalogId?)

				) 

 		WHERE
				CATGROUP.MARKFORDELETE=0 AND		
				CATGROUP.CATGROUP_ID  IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- ============================================================================================= -->
	<!-- Fetch a catalog group with its link parent catalog groups.                                    -->
	<!-- This SQL will fetch a catgroup and the corresponding catgrprel where the catalog group is     -->
	<!-- a linked child.                                                                               -->       
	<!-- @param UniqueID UniqueId of catalog group to fetch                                            -->
	<!-- @param parentCatalogGroupID  UniqueId of parent catalog group                                 -->
	<!-- ============================================================================================= -->
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)] and (@parentCatalogGroupID=)]+IBM_Admin_CatalogGroupLinkedParentsProfile
	base_table=CATGROUP
	sql=		                            
             	SELECT 
	     			CATGROUP.$COLS:CATGROUP_ID$,
				CATGRPREL.$COLS:CATGRPREL$

	     					     				
	     	FROM
	     			CATGROUP 
				LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					CATGRPREL.CATGROUP_ID_CHILD= CATGROUP.CATGROUP_ID 
					AND 
					CATGRPREL.CATGROUP_ID_PARENT = (?parentCatalogGroupID?)
				)

 		WHERE
				CATGROUP.MARKFORDELETE=0 AND		
				CATGROUP.CATGROUP_ID  IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT

	<!-- ============================================================================================= -->
	<!-- Fetch a catalog group with its children catalog groups and its linked parents including       -->
	<!-- links from catalog root of a catalog.                                                         -->
	<!-- This SQL will fetch a catgroup,                                                               -->
	<!-- the cattogrp objects where the catalog has a link to this catalog group                       -->
	<!-- and the catgrprel objects that related this catalog group to its linked parent catalog        -->
	<!-- groups.                                                                                       -->
	<!-- @param UniqueID Id of catalog group to fetch                                                  -->
	<!-- @param catalogId  The catalog id of link source                                               -->
	<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT	
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)] and (@catalogId=)]+IBM_Admin_CatalogGroupLinkedParentsAndChildrenProfile
	base_table=CATGROUP
	sql=	SELECT 
	     		CATGROUP.$COLS:CATGROUP_ID$,
				CATGRPREL.$COLS:CATGRPREL$,
				CATTOGRP.$COLS:CATTOGRP$				
	     					     				
	     	FROM
	     			CATGROUP 				
				LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					(
					(CATGRPREL.CATGROUP_ID_CHILD= CATGROUP.CATGROUP_ID  
					AND
					CATGRPREL.CATALOG_ID_LINK IN (?catalogId?))
					OR 
					(
					CATGRPREL.CATGROUP_ID_PARENT= CATGROUP.CATGROUP_ID 
					AND 
					CATGRPREL.CATALOG_ID IN (?catalogId?)) )					
					
				)
				LEFT OUTER JOIN CATTOGRP
				ON
				(
					CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID 
					AND
					CATTOGRP.CATALOG_ID_LINK IN (?catalogId?)

				) 				

 		WHERE
				CATGROUP.MARKFORDELETE=0 AND		
				CATGROUP.CATGROUP_ID  IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT

	<!-- ============================================================================================= -->
	<!-- Fetch a catalog group with its children catalog entries and its parent and linked parents     -->
	<!-- including catalog root for top category.                                                      -->
	<!-- This SQL will fetch a catgroup, the cattogrp objects where this catalog group is a top        -->
	<!-- category or where the catalog has a link to this catalog group                                -->
	<!-- and the catgrprel objects that related this catalog group to its linked and normal parent     -->
	<!-- catalog groups.                                                                                -->
	<!-- @param UniqueID Id of catalog group to fetch                                                  -->
	<!-- @param catalogId  The catalog id of source catalog                                            -->
	<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT	
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)] and (@catalogId=)]+IBM_Admin_CatalogGroupAllParentsAndChildrenProfile
	base_table=CATGROUP
	sql=	SELECT 
	     		CATGROUP.$COLS:CATGROUP_ID$,
				CATGRPREL.$COLS:CATGRPREL$,
				CATTOGRP.$COLS:CATTOGRP$
	     					     				
	     	FROM
	     			CATGROUP 				
				LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					(
						CATGRPREL.CATGROUP_ID_CHILD= CATGROUP.CATGROUP_ID  
						AND
						(
							CATGRPREL.CATALOG_ID_LINK IN (?catalogId?)
							OR
							CATGRPREL.CATALOG_ID IN (?catalogId?)
						)
					)
					OR 
					(
						CATGRPREL.CATGROUP_ID_PARENT= CATGROUP.CATGROUP_ID 
						AND 
						CATGRPREL.CATALOG_ID IN (?catalogId?)
					 )					
					
				)
				LEFT OUTER JOIN CATTOGRP
				ON
				(
				        (
						CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID 
						AND	
						(					
							CATTOGRP.CATALOG_ID_LINK IN (?catalogId?)
						
							OR
						
							CATTOGRP.CATALOG_ID IN (?catalogId?)
						)
					)

				) 
				

 		WHERE
				CATGROUP.MARKFORDELETE=0 AND		
				CATGROUP.CATGROUP_ID  IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT


	<!-- ============================================================================================= -->
	<!-- Fetch a catalog group with its children catalog groups, its linked catalog root objects and   -->
	<!-- linked parent catalog groups but exclude links from a particular parent catalog group.        -->
	<!-- This SQL will fetch a catgroup, the associated catgrprel objects that relate this to its      -->
	<!-- children catalog groups, the associated catgrprel objects that relate this catgroup to its    -->
	<!-- linked parent catalog group except for a particular catalog group and the associated cattogrp -->
	<!-- objects that related this to its linked catalogs.                                             -->
	<!-- @param UniqueID Id of catalog group to fetch                                                  -->
	<!-- @param catalogId  The catalog id of link source                                               --> 
	<!-- @param excParentId The id of the parent catalog group to exclude                              -->
	<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT	
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)] and (@catalogId=) and (@excParentId=)]+IBM_Admin_CatalogGroupLinkedParentsAndChildrenExcludeParentProfile
	base_table=CATGROUP
	sql=		                            
             	SELECT 
	     			CATGROUP.$COLS:CATGROUP_ID$,
				CATGRPREL.$COLS:CATGRPREL$,
				CATTOGRP.$COLS:CATTOGRP$
	     					     				
	     	FROM
	     			CATGROUP 
				LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					(
					(CATGRPREL.CATGROUP_ID_CHILD= CATGROUP.CATGROUP_ID  
					AND
					CATGRPREL.CATALOG_ID_LINK IN (?catalogId?)
					AND
					CATGRPREL.CATGROUP_ID_PARENT <> (?excParentId?))
					
					OR 
					(
					CATGRPREL.CATGROUP_ID_PARENT= CATGROUP.CATGROUP_ID 
					AND 
					CATGRPREL.CATALOG_ID IN (?catalogId?)) )		
				)
				
				
				LEFT OUTER JOIN CATTOGRP
				ON
				(
					CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID 
					AND
					CATTOGRP.CATALOG_ID_LINK IN (?catalogId?)

				) 				

 		WHERE
				CATGROUP.MARKFORDELETE=0 AND		
				CATGROUP.CATGROUP_ID  IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT




<!-- ============================================================================================= -->
<!-- This SQL will return the relationship between the given catalog group and the catalog group   -->
<!-- product sets. It uses the catalog id passed in xpath to fetch the relationship data.          -->
<!-- Multiple results are returned if multiple catalog group ids and catalog ids are passed.       -->
<!-- @param UniqueID UniqueId of catalog group.				                   -->
<!-- @param catalogId Catalog Id of catalog for which the product set relationship has  	   -->
<!--		      to be fetched.							           -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)] and (@catalogId=)]+IBM_Admin_CatalogGroupToProductSetRelationship
	base_table=CATGROUP
	sql=		                            
             	SELECT 
	     			CATGROUP.$COLS:CATGROUP_ID$,
				CATGRPPS.$COLS:CATGRPPS$

	     					     				
	     	FROM
	     			CATGROUP 
				LEFT OUTER JOIN CATGRPPS 
				ON	
				(
					CATGRPPS.CATGROUP_ID= CATGROUP.CATGROUP_ID 
					AND 
					CATGRPPS.CATALOG_ID IN (?catalogId?)
				)
 		WHERE
				CATGROUP.CATGROUP_ID  IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT

<!-- ===================================================================================== -->
<!-- ============ Catalog Group Change and Process Queries End =========================== -->
<!-- ===================================================================================== -->



<!-- ===================================================================================== -->
<!-- ============ Catalog Group Change and Process Helper Queries Begin ================== -->
<!-- ===================================================================================== -->

<!-- ============================================================================================= -->
<!-- This SQL will return the UniqueID of a catalog group whose Identifier is passed in the xpath. -->
<!-- ownerID is retrived from business context and used along with identifier to retrieve the      -->
<!-- UniqueID. It is used to resolve UniqueID of catalog group when only Identifier is available.  -->	
<!-- Multiple results are returned if multiple catalog group identifiers are passed.		   -->
<!-- @param GroupIdentifier Identifier of a catalog group					   -->
<!-- @param CTX:OWNER_ID  OwnerId of catalog group, retrieved from business context                -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[ExternalIdentifier[(GroupIdentifier=)]]]+IBM_Admin_IdResolve

	<!-- name=/CatalogGroup[(@groupIdentifier=)]+IBM_Admin_IdResolve -->
	base_table=CATGROUP
	sql=
			SELECT 
	     				CATGROUP.$COLS:CATGROUP_ID$
	     	FROM
	     				CATGROUP
	     					 						  
	     	WHERE
						CATGROUP.IDENTIFIER=?GroupIdentifier? AND 
						CATGROUP.MEMBER_ID=$CTX:OWNER_ID$

END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get the catalog group based on the identifier of the category. The is storepath
	enabled.
	@param GroupIdentifier Identifier of a catalog group
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[ExternalIdentifier[(GroupIdentifier=)]]]+IBM_Admin_IdResolveWithStoreFilter
	base_table=CATGROUP
	sql=
			SELECT 
	     				CATGROUP.$COLS:CATGROUP_ID$
	     	FROM
	     				CATGROUP
	     					JOIN STORECGRP ON STORECGRP.CATGROUP_ID=CATGROUP.CATGROUP_ID 						  
	     	WHERE
						CATGROUP.IDENTIFIER=?GroupIdentifier?
						 AND STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$) AND CATGROUP.MARKFORDELETE=0
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the UniqueID of a catalog group whose Identifier  and owner id is passed -->
<!-- in the xpath. OwnerId along with identifier is used to retrieve the UniqueID.		   -->
<!-- It is used to resolve UniqueID of catalog group when Identifier and ownerId both are          -->	
<!-- available in the xpath. Multiple results are returned if multiple catalog group identifiers   -->
<!-- and ownerids are passed in request.							   -->
<!-- @param GroupIdentifier Identifier of a catalog group					   -->
<!-- @param ownerID  OwnerId of catalog group                                                      -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[ExternalIdentifier[(@ownerID= and GroupIdentifier=)]]]+IBM_Admin_IdResolve
	base_table=CATGROUP
	sql=
			SELECT 
	     				CATGROUP.$COLS:CATGROUP_ID$
	     	FROM
	     				CATGROUP
	     											  
	     	WHERE
						CATGROUP.IDENTIFIER=?GroupIdentifier? AND 
						CATGROUP.MEMBER_ID=?ownerID?
						
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the parent catalog group relation data for a catalog group whose         -->
<!-- UniqueID is passed in request. It will use the catalog id present in business context to      -->
<!-- retrieve the correct parent catalog group relation which belongs to the catalog id.           -->	
<!-- Multiple results are returned if multiple catalog group ids are passed in request             -->
<!-- @TW - This is better for description.  Add the Profile description. -->
<!-- @TW - I think this should be store path enabled and include the store. -->
<!-- @param UniqueID UniqueID of catalog group whose parent has to be retrieved		   -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the relationship has 	           -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[UniqueID=]]/NavigationRelationship+IBM_Admin_CatalogGroupParentProfile
	base_table=CATGROUP
	base_table=CATGRPREL
	sql=		                            
             	SELECT 
             		CATGRPREL.$COLS:CATGRPREL$
				FROM
	     			CATGRPREL
				WHERE
					CATGRPREL.CATGROUP_ID_CHILD IN (?UniqueID?) 
					AND 
					CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the catalog group to catalog relation data for a catalog group whose     -->
<!-- UniqueID is passed in request. It will use the catalog id present in business context to      -->
<!-- retrieve the correct relation which belongs to the catalog id.				   -->	
<!-- Multiple results are returned if multiple catalog group ids are passed in request             -->
<!-- @TW - This is better for description.  Add the Profile description. -->
<!-- @TW - I think this should be store path enabled and include the store. -->
<!-- @param UniqueID UniqueID of catalog group						   -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the relationship has 	           -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[UniqueID=]]/NavigationRelationship+IBM_Admin_CatalogGroupTopCatalogGroupProfile
	base_table=CATTOGRP
	sql=		                            
             	SELECT 
             		CATTOGRP.$COLS:CATTOGRP$
				FROM
	     			CATTOGRP
				WHERE
					CATTOGRP.CATGROUP_ID IN (?UniqueID?) 
					AND 
					CATTOGRP.CATALOG_ID = $CTX:CATALOG_ID$

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the UniqueID of a catalog group whose Identifier  and owner id is passed -->
<!-- in the xpath. OwnerId along with identifier is used to retrieve the UniqueID.		   -->
<!-- It also verifies if a catalog group is not marked for delete and exists in the store present  -->	
<!-- in business context. Multiple results are returned if multiple catalog group identifiers      -->
<!-- and ownerids are passed in request.							   -->
<!-- @param GroupIdentifier Identifier of a catalog group					   -->
<!-- @param ownerID  OwnerId of catalog group                                                      -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[ExternalIdentifier[(@ownerID= and GroupIdentifier=)]]]+IBM_Admin_CatalogGroup_Validate
	base_table=CATGROUP
	sql=
			SELECT 
	     				CATGROUP.$COLS:CATGROUP_ID$
	     	FROM
	     				CATGROUP
	     				JOIN STORECGRP ON
	     				(
	     				 	STORECGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID 
	     				 	AND
	     				 	STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)
	     				 )
						
			WHERE
			CATGROUP.IDENTIFIER = ?GroupIdentifier? AND 
			CATGROUP.MEMBER_ID = ?ownerID? AND
			CATGROUP.MARKFORDELETE=0

						
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the UniqueID of a catalog group whose UniqueId is passed		   -->
<!-- in the xpath. This sql is used to validate if a catalog group exists in system. 		   -->
<!-- It also verifies if a catalog group is not marked for delete and exists in the store present  -->	
<!-- in business context. Multiple results are returned if multiple catalog group Unique IDs       -->
<!-- are passed in request.									   -->
<!-- @param UniqueID UniqueId of a catalog group	which has to be validates		   -->
<!-- @param CTX:STORE_ID  Store Id of store for which the catalog group has to be fetched.	   -->
<!--			  Store Id is retrieved form the business context                          -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_CatalogGroup_Validate
	base_table=CATGROUP
	sql=
			SELECT 
	     				CATGROUP.$COLS:CATGROUP_ID$
	     	FROM
	     				CATGROUP
	     				JOIN STORECGRP ON
	     				(
	     				 	STORECGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID 
	     				 	AND
	     				 	STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)
	     				 )
					
			WHERE
			CATGROUP.CATGROUP_ID in (?UniqueID?) AND 
			CATGROUP.MARKFORDELETE=0
						
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the all the child catalog entries as well as child catalog groups which  -->
<!-- belong to the catalog group whose UniqueID is passed in the xpath. CatalogID present in the   -->
<!-- business context is used to retrieve the correct relationship data.                           -->	
<!-- Multiple results are returned if multiple catalog group ids are passed.			   -->
<!-- Used for validation before deleting a catalog group.					   -->
<!-- @param UniqueID UniqueId of parent catalog group.					           -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the relationship has 		   -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_CatalogGroupChildCatGroupChildCatEntryValidation
	base_table=CATGROUP
	sql=
		                            
            SELECT 
	     	CATGROUP.$COLS:CATGROUP_ID$,
			CATGRPREL.$COLS:CATGRPREL$,
			CATGPENREL.$COLS:CATGPENREL$
			
			FROM
	     	
	     	CATGROUP 
                                
				LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					
						CATGRPREL.CATGROUP_ID_PARENT = CATGROUP.CATGROUP_ID 
						AND
					    CATGRPREL.CATALOG_ID IN ($CTX:CATALOG_ID$)
				)
                LEFT OUTER JOIN CATGPENREL
				ON
				(
					CATGPENREL.CATGROUP_ID = CATGROUP.CATGROUP_ID 
					AND
					CATGPENREL.CATALOG_ID IN ($CTX:CATALOG_ID$)

				)
				

 		WHERE
				CATGROUP.CATGROUP_ID  IN (?UniqueID?)
		
								
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the catalog to catalog group relation data of the catalog group whose    -->
<!-- UniqueID is passed in the xpath. CatalogID present in the business context is used to retrieve-->
<!-- the correct relationship data. Data will be retirned only if the catalog group is a top       -->	
<!-- category. Multiple results are returned if multiple catalog group ids are passed.  	   -->
<!-- @TW - This is better for description.  Add the Profile description. -->
<!-- @param UncatalogGroupID UniqueId of catalog group.		        			   -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the relationship has 		   -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_CatalogGroupToCatalogRelValidationProfile
	base_table=CATGROUP
	sql=		                            
           	SELECT 
	     		CATGROUP.$COLS:CATGROUP_ID$,
				CATGRPREL.$COLS:CATGRPREL$,
				CATTOGRP.$COLS:CATTOGRP$

	     					     				
	     	FROM
	     		CATGROUP 
	     		LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					CATGRPREL.CATGROUP_ID_CHILD= CATGROUP.CATGROUP_ID
				)
				LEFT OUTER JOIN CATTOGRP
				ON
				(
					CATTOGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID 
				) 

 			WHERE
				CATGROUP.CATGROUP_ID  IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT



<!-- ============================================================================================= -->
<!-- This SQL will return a record if a child catalog entry exists for the given parent catalog    -->
<!-- group under the catalog in context.							   -->
<!-- Used to validate if a catgroup has any child catalog entries.				   -->
<!-- @param @parentCatalogGroupID UniqueId of parent catalog group.		                   -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the navigation relationship has 	   -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup/NavigationRelationship[@parentCatalogGroupID=]+IBM_Admin_CatalogGroupChildCatalogEntryExists
	base_table=CATGPENREL
	
	dbtype=db2
	sql=
			                            
	     SELECT 
			 CATGPENREL.$COLS:CATGPENREL:CATGROUP_ID$
	     FROM
	                 CATGPENREL, CATENTRY 
	     WHERE                            
	                 CATGPENREL.CATGROUP_ID  = ?parentCatalogGroupID? AND                            
                         CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$ AND
                         CATENTRY.CATENTRY_ID = CATGPENREL.CATENTRY_ID AND CATENTRY.MARKFORDELETE=0
             FETCH FIRST 1 ROW ONLY            

	
	dbtype=oracle
	sql=
			                            
	     SELECT 
			 CATGPENREL.$COLS:CATGPENREL:CATGROUP_ID$
	     FROM
	                 CATGPENREL, CATENTRY 
	     WHERE                            
	                 CATGPENREL.CATGROUP_ID  = ?parentCatalogGroupID? AND                            
                         CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$ AND 
                         CATENTRY.CATENTRY_ID = CATGPENREL.CATENTRY_ID AND CATENTRY.MARKFORDELETE=0 AND
                         rownum <= 1              
	
	sql=
		                            
              SELECT 
			  CATGPENREL.$COLS:CATGPENREL:CATGROUP_ID$
              FROM
                          CATGPENREL, CATENTRY 
	      WHERE                            
                          CATGPENREL.CATGROUP_ID  = ?parentCatalogGroupID? AND                            
                          CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$ AND
                          CATENTRY.CATENTRY_ID = CATGPENREL.CATENTRY_ID AND CATENTRY.MARKFORDELETE=0

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return a record if a child catalog group exists for the given parent catalog    -->
<!-- group under the catalog in context.							   -->
<!-- Used to validate if a catgroup has any child catalog groups.				   -->
<!-- @param @parentCatalogGroupID UniqueId of parent catalog group.		                   -->
<!-- @param CTX:CATALOG_ID Catalog Id of catalog for which the navigation relationship has 	   -->
<!--			   to be fetched. Catalog Id is retrieved form the business context.       -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup/NavigationRelationship[@parentCatalogGroupID=]+IBM_Admin_CatalogGroupChildCatalogGroupExists
	base_table=CATGRPREL

	dbtype=db2	
	sql=
		                            
              SELECT 
			  CATGRPREL.$COLS:CATGRPREL:CATGROUP_ID_PARENT$
              FROM
                          CATGRPREL 
	      WHERE                            
                          CATGRPREL.CATGROUP_ID_PARENT  = ?parentCatalogGroupID? AND                            
                          CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$	
             FETCH FIRST 1 ROW ONLY                          
                          
                          
	dbtype=oracle	
	sql=
		                            
              SELECT 
			  CATGRPREL.$COLS:CATGRPREL:CATGROUP_ID_PARENT$
              FROM
                          CATGRPREL 
	      WHERE                            
                          CATGRPREL.CATGROUP_ID_PARENT  = ?parentCatalogGroupID? AND                            
                          CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$ AND
                          rownum <= 1                         
	
	sql=
		                            
              SELECT 
			  CATGRPREL.$COLS:CATGRPREL:CATGROUP_ID_PARENT$
              FROM
                          CATGRPREL 
	      WHERE                            
                          CATGRPREL.CATGROUP_ID_PARENT  = ?parentCatalogGroupID? AND                            
                          CATGRPREL.CATALOG_ID = $CTX:CATALOG_ID$

END_XPATH_TO_SQL_STATEMENT

<!-- ===================================================================================== -->
<!-- ============ Catalog Group Change and Process Helper Queries End ==================== -->
<!-- ===================================================================================== -->



<!-- ===================================================================================== -->
<!-- ============ Catalog Group Copy Function Queries Begin ============================== -->
<!-- ===================================================================================== -->


BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- ============================================================================================= -->
	<!-- Fetch a catalog group, its descriptions, children catalog group and catalog entries to be     -->
	<!-- used for deep copy.                                                                           -->
	<!-- This SQL will fetch a catgroup, the corresponding catgrpdesc objects, the catgprel objects    -->
	<!-- that relates the catalog group to its child catalog groups, and the catgpenrel objects that   -->
	<!-- relates this catalog group to its children catalog entries.                                   -->
	<!-- @param UniqueID Id of catalog group to fetch                                                -->
	<!-- @param @catalogId  The catalog id of link source                                               --> 
	<!-- ============================================================================================= -->
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)] and (@catalogId=)]+IBM_Admin_CatalogGroupWithChildrenCopyProfile
	base_table=CATGROUP
	sql=	
		SELECT 
	     		CATGROUP.$COLS:CATGROUP$,
	     		CATGRPDESC.$COLS:CATGRPDESC$,
	     		CATGRPREL.$COLS:CATGRPREL$,
			CATGPENREL.$COLS:CATGPENREL$
	     					     				
	     	FROM
	     		CATGROUP	
	     		LEFT OUTER JOIN CATGRPDESC 
	     		ON
	     		(
	     			CATGRPDESC.CATGROUP_ID=CATGROUP.CATGROUP_ID  
	     		)
	     		LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					CATGRPREL.CATGROUP_ID_PARENT= CATGROUP.CATGROUP_ID 
					AND 
					CATGRPREL.CATALOG_ID IN (?catalogId?)					
				)			
				LEFT OUTER JOIN CATGPENREL 
				ON	
				(
					CATGPENREL.CATGROUP_ID=CATGROUP.CATGROUP_ID 
					AND 
					CATGPENREL.CATALOG_ID IN (?catalogId?)
				)

 		WHERE
				CATGROUP.MARKFORDELETE=0 AND		
				CATGROUP.CATGROUP_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT



	<!-- ============================================================================================= -->
	<!-- Fetch a catalog group, its descriptions and children catalog group to be used for deep copy.  -->
	<!-- This SQL will fetch a catgroup, the corresponding catgrpdesc objects and the catgrprel        -->
	<!-- objects that relates the catalog group to its child catalog groups.                           -->
	<!-- @param catGroupId Id of catalog group to fetch                                                -->
	<!-- @param catalogId  The catalog id of link source                                               --> 
	<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT	
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)] and (@catalogId=)]+IBM_Admin_CatalogGroupWithChildrenCatalogGroupOnlyCopyProfile
	base_table=CATGROUP
	sql=	
		SELECT 
	     		CATGROUP.$COLS:CATGROUP$,
	     		CATGRPDESC.$COLS:CATGRPDESC$,
	     		CATGRPREL.$COLS:CATGRPREL$
			
	     					     				
	     	FROM
	     		CATGROUP	
	     		LEFT OUTER JOIN CATGRPDESC 
	     		ON
	     		(
	     			CATGRPDESC.CATGROUP_ID=CATGROUP.CATGROUP_ID  
	     		)
	     		LEFT OUTER JOIN CATGRPREL 
				ON	
				(
					CATGRPREL.CATGROUP_ID_PARENT= CATGROUP.CATGROUP_ID 
					AND 
					CATGRPREL.CATALOG_ID IN (?catalogId?)					
				)	
				

 		WHERE
				CATGROUP.MARKFORDELETE=0 AND		
				CATGROUP.CATGROUP_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT


	<!-- ============================================================================================= -->
	<!-- Fetch all catalog groups with identifier that begins with a given name. This is used during   -->
	<!-- deep copy of catalog group when generating identifiers for the copied objects.                -->
	<!-- This SQL will fetch all catgroups with identifier like the input identifier.                  -->
	<!-- @param identifier The base identifier of the catgroup to be copied.                           -->
	<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT	
	name=/CatalogGroup[CatalogGroupIdentifier[ExternalIdentifier[(GroupIdentifier=)]]]+IBM_Admin_CatalogGroupSimilarIdentifierForCopy
	base_table=CATGROUP
	sql=	
		SELECT 
	     		CATGROUP.$COLS:CATGROUP$     		
	     					     				
	     	FROM
	     		CATGROUP	
	     		
 		WHERE					
			CATGROUP.IDENTIFIER LIKE (?GroupIdentifier?)

END_XPATH_TO_SQL_STATEMENT

<!-- ===================================================================================== -->
<!-- ============ Catalog Group Copy Function Queries End ================================ -->
<!-- ===================================================================================== -->



<!-- ===================================================================================== -->
<!-- ============ Catalog Group Taxonomy Attributes Queries End ========================== -->
<!-- ===================================================================================== -->


<!-- ===================================================================================== -->
<!-- ============ Catalog Group Access Control Queries Begin ============================= -->
<!-- ===================================================================================== -->

<!-- ============================================================================================= -->
<!-- This SQL will return the member id of catalog group whose identifier is passed in the         -->
<!-- xpath. Multiple results are returned if multiple catalog group identifiers are passed.        -->
<!-- @param GroupIdentifier Identifier of a catalog group whose memberId has to be retrieved.      -->
<!-- ============================================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[ExternalIdentifier[(GroupIdentifier=)]]]+IBM_Admin_AccessControlGetOwner
	base_table=CATGROUP
	sql=
			SELECT 
	     				CATGROUP.$COLS:MEMBER_ID$
	     	FROM
	     				CATGROUP
	     	WHERE
						CATGROUP.IDENTIFIER=?groupIdentifier?
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the member id of catalog group whose UniqueId is passed in the           -->
<!-- xpath. Multiple results are returned if multiple catalog group UniqueIds are passed.          -->
<!-- @param UniqueID UniqueId of a catalog group whose memberId has to be retrieved.         -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]+IBM_Admin_AccessControlGetOwner
	base_table=CATGROUP
	sql=
			SELECT 
	     				CATGROUP.$COLS:MEMBER_ID$
	     	FROM
	     				CATGROUP
	     	WHERE
						CATGROUP.CATGROUP_ID=?UniqueID?
END_XPATH_TO_SQL_STATEMENT


<!-- ===================================================================================== -->
<!-- ============ Catalog Group Access Control Queries End   ============================= -->
<!-- ===================================================================================== -->



BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch catalog groups based on store id and catalog group id -->
	<!-- xpath = "/Catalog" -->
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)] and (@storeId=)]]+IBM_Admin_CatalogGroupAndStore
	base_table=CATGROUP
	sql=
		SELECT 
				CATGROUP.$COLS:CATGROUP$,
				STORECGRP.$COLS:STORECGRP$
				
		FROM
				CATGROUP, STORECGRP
				
		WHERE
				CATGROUP.CATGROUP_ID = ?UniqueID? AND
				STORECGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID AND
				STORECGRP.STOREENT_ID = ?storeId?
								
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get the store catalog group relationship based on the catalog group id.
	
	@param catalogGroupId The catalog group id.	
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup/CatalogGroupStoreRelation[((@catalogGroupId= )]+IBM_Admin_CatalogGroupStoreRelation
	base_table=STORECGRP	
	sql=
		SELECT 
	     				STORECGRP.$COLS:STORECGRP$
	     	FROM
	     				STORECGRP
	     	WHERE
					STORECGRP.CATGROUP_ID IN (?catalogGroupId?)
						
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================================================= -->
<!-- This SQL will return the details of a Catalog Group along with its facets.                    -->
<!-- Multiple results are returned if multiple catalog group ids are passed.                       -->
<!-- @param UniqueID UniqueId of catalog group.						                               -->
<!-- @param CTX:STOREENT_ID  Store Id of store for which the catalog group has to be fetched.	   -->
<!--			  Store Id is retrieved form the business context                                  -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]/Facet/FacetIdentifier/[(facetId=)]+IBM_Admin_CatalogGroupFacets
	base_table=CATGROUP
	sql=
		SELECT
			CATGROUP.$COLS:CATGROUP$,
			FACETCATGRP.$COLS:FACETCATGRP$
		FROM CATGROUP
		
		LEFT OUTER JOIN FACETCATGRP ON (
			FACETCATGRP.CATGROUP_ID = CATGROUP.CATGROUP_ID AND 
			FACETCATGRP.FACET_ID=?facetId? AND
			FACETCATGRP.STOREENT_ID IN ($STOREPATH:catalog$)
		)
		
		WHERE
			CATGROUP.MARKFORDELETE = 0 AND			
			CATGROUP.CATGROUP_ID IN (?UniqueID?)	
										
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================= -->
<!-- This SQL will return the details of a Catalog Group along with its rules for dynamic sales    -->
<!-- categories.                                                                                   -->
<!-- Multiple results are returned if multiple catalog group ids are passed.                       -->
<!-- @param UniqueID UniqueId of catalog group.						                               -->
<!-- ============================================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]/Rule+IBM_Admin_CatalogGroupProfile
	base_table=CATGROUP
	sql=
		SELECT
			CATGROUP.$COLS:CATGROUP$,
			CATGRPRULE.$COLS:CATGRPRULE$
		FROM CATGROUP
		
		LEFT OUTER JOIN CATGRPRULE ON (
			CATGRPRULE.CATGROUP_ID = CATGROUP.CATGROUP_ID
		)
		
		WHERE
			CATGROUP.MARKFORDELETE = 0 AND 
			CATGROUP.CATGROUP_ID IN (?UniqueID?)	
										
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Find catalog group calculation code by calculation code and store
	@param calcodeId The calculation code id
	@param storeId The store identifier
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogGroupCalculationCode[(@calcodeId=) and (@storeId=)]+IBM_Admin_IdResolve
	base_table=CATGPCALCD
	sql=
		SELECT 
			CATGPCALCD.$COLS:CATGPCALCD$
		FROM 
			CATGPCALCD 
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

<!--
===========================================================================================================
  Get external-content relationships of catalog-group based on the relationship unique ID.
  @param UniqueID The relationship unique ID.
===========================================================================================================
-->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/CatalogGroup/ExternalContentReference[((UniqueID=)]+IBM_Admin_CatalogGroupExternalContentReferenceUpdate
  base_table=CATGROUP_EXTERNAL_CONTENT_REL
  sql=SELECT $COLS:CATGROUP_EXTERNAL_CONTENT_REL$ 
      FROM   CATGROUP_EXTERNAL_CONTENT_REL
      WHERE  CG_EXTERNAL_CONTENT_REL_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT



<!-- ======================================================================
	Get the external content relationships of the catalog group based on the catalog group id, language ID, type and store
	 in context
	@param UniqueID The catalog group id
	@param languageID The language ID
	@param Context:STORE_ID The store for which to retrieve the catalog group .
	This parameter is retrieved from within the business context.
	@param ExternalContentType The external content type
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/CatalogGroup[CatalogGroupIdentifier[(UniqueID=)]]/ExternalContentReference[(@languageID= and ExternalContentType=)]+IBM_Admin_IdResolve
  base_table=CATGROUP_EXTERNAL_CONTENT_REL
  sql=SELECT $COLS:CATGROUP_EXTERNAL_CONTENT_REL$ 
      FROM   CATGROUP_EXTERNAL_CONTENT_REL
      WHERE  CATGROUP_ID IN (?UniqueID?)
      AND    LANGUAGE_ID IN (?languageID?)
      AND    TYPE IN (?ExternalContentType?)
      AND    CATOVRGRP_ID IN (SELECT CATOVRGRP_ID FROM STORECATOVRGRP WHERE STOREENT_ID IN ( $STOREPATH:catalog$ ))      
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Catalog Group Access Profile Alias definition             -->
<!--                                                            -->
<!-- ========================================================= -->

BEGIN_PROFILE_ALIASES
  base_table=CATGROUP
  IBM_CatalogGroupIdentifierProfile=IBM_Admin_CatalogGroupIdentifierProfile
  IBM_CatalogGroupNavigationRelationshipProfile=IBM_Admin_CatalogGroupNavigationRelationshipProfile
  IBM_CatalogGroupProfile=IBM_Admin_CatalogGroupProfile
  IBM_CatalogGroupParentAndTopCatalogGroupProfile=IBM_Admin_CatalogGroupParentAndTopCatalogGroupProfile
  IBM_CatalogGroupLinkedParentsProfile=IBM_Admin_CatalogGroupLinkedParentsProfile
  IBM_CatalogGroupLinkedParentsAndChildrenProfile=IBM_Admin_CatalogGroupLinkedParentsAndChildrenProfile
  IBM_CatalogGroupAllParentsAndChildrenProfile=IBM_Admin_CatalogGroupAllParentsAndChildrenProfile
  IBM_CatalogGroupLinkedParentsAndChildrenExcludeParentProfile=IBM_Admin_CatalogGroupLinkedParentsAndChildrenExcludeParentProfile
  IBM_CatalogGroupToProductSetRelationship=IBM_Admin_CatalogGroupToProductSetRelationship
  IBM_IdResolve=IBM_Admin_IdResolve
  IBM_IdResolveWithStoreFilter=IBM_Admin_IdResolveWithStoreFilter
  IBM_CatalogGroupParentProfile=IBM_Admin_CatalogGroupParentProfile
  IBM_CatalogGroup_Validate=IBM_Admin_CatalogGroup_Validate
  IBM_CatalogGroupChildCatGroupChildCatEntryValidation=IBM_Admin_CatalogGroupChildCatGroupChildCatEntryValidation
  IBM_CatalogGroupToCatalogRelValidationProfile=IBM_Admin_CatalogGroupToCatalogRelValidationProfile
  IBM_CatalogGroupWithChildrenCopyProfile=IBM_Admin_CatalogGroupWithChildrenCopyProfile
  IBM_CatalogGroupWithChildrenCatalogGroupOnlyCopyProfile=IBM_Admin_CatalogGroupWithChildrenCatalogGroupOnlyCopyProfile
  IBM_CatalogGroupSimilarIdentifierForCopy=IBM_Admin_CatalogGroupSimilarIdentifierForCopy
  IBM_AccessControlGetOwner=IBM_Admin_AccessControlGetOwner
  IBM_CatalogGroupAndStore=IBM_Admin_CatalogGroupAndStore
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATGRPDESC
  IBM_CatalogGroupDescriptions=IBM_Admin_CatalogGroupDescriptions
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATGRPREL
  IBM_CatalogGroupChildCatalogGroupExists=IBM_Admin_CatalogGroupChildCatalogGroupExists
  IBM_CatalogGroupNavigationRelationshipProfile=IBM_Admin_CatalogGroupNavigationRelationshipProfile
  IBM_CatalogGroupParentProfile=IBM_Admin_CatalogGroupParentProfile
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATGPENREL
  IBM_CatalogGroupNavigationRelationshipProfile=IBM_Admin_CatalogGroupNavigationRelationshipProfile
  IBM_CatalogGroupChildCatalogEntryExists=IBM_Admin_CatalogGroupChildCatalogEntryExists
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=CATTOGRP
  IBM_CatalogGroupTopCatalogGroupProfile=IBM_Admin_CatalogGroupTopCatalogGroupProfile	
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=STORECGRP
  IBM_CatalogGroupStoreRelation=IBM_Admin_CatalogGroupStoreRelation 	
END_PROFILE_ALIASES

<!-- ===================================================================================== -->
<!-- ================================ CATALOG GROUP QUERIES END ========================== -->
<!-- ===================================================================================== -->



