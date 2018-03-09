<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2011                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->

BEGIN_SYMBOL_DEFINITIONS
	
		<!-- The tables for the Folder noun  -->
		<!-- Defining the ID column of the FOLDER table -->
		COLS:FOLDER_ID = FOLDER:FOLDER_ID 

		<!-- Defining the PARENTFOLDER_ID column of the FOLDER table -->
		COLS:PARENTFOLDER_ID = FOLDER:PARENTFOLDER_ID 

		<!-- Defining the IDENTIFIER column of the FOLDER table -->
		COLS:IDENTIFIER = FOLDER:IDENTIFIER 
			
		<!-- Defining the ID column of the FOLDERITEM table -->
		COLS:FOLDERITEM_ID = FOLDERITEM:FOLDERITEM_ID 
			
		<!-- Defining all columns of the FOLDER table -->
		COLS:FOLDER = FOLDER:* 
		
		<!-- Defining all columns of the FOLDERITEM table -->
		COLS:FOLDERITEM = FOLDERITEM:* 	
		
		<!-- Defining all columns of the STOREENT table -->		
		COLS:STOREENT = STOREENT:*
		
END_SYMBOL_DEFINITIONS


<!-- ================================================================================== -->
<!-- XPath: /Folder/FolderIdentifier[(UniqueID=)] 										-->
<!-- Get the detail information for a folder with the specified unique ID.				-->
<!-- The access profiles that apply to this SQL are:									-->
<!--	IBM_Admin_Details																-->
<!-- @param UniqueID Unique ID of the folder to retrieve.								-->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Folder[FolderIdentifier[(UniqueID=)]]
	base_table=FOLDER
	sql=	
		SELECT 
			FOLDER.$COLS:FOLDER_ID$
		FROM
			FOLDER
		WHERE
			FOLDER.FOLDER_ID = ?UniqueID?
		ORDER BY
			STOREENT_ID ASC, FOLDER.IDENTIFIER ASC
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /Folder/FolderIdentifier[(UniqueID=)]/ChildFolderItems						-->
<!-- Get the detail information for a folder plus a list of all the child				-->
<!-- folder items in that folder with paging support.									-->
<!-- The access profiles that apply to this SQL are:									-->
<!--	IBM_Admin_ChildFolderItems														-->
<!-- @param UniqueID Unique ID of the folder to retrieve.								-->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Folder[FolderIdentifier[(UniqueID=)]]/FolderItem
	base_table=FOLDER
	sql=	
		SELECT
			FOLDER.$COLS:FOLDER_ID$,
	     	FOLDERITEM.$COLS:FOLDERITEM_ID$
	    FROM
	    	FOLDER
	    INNER JOIN
	    	FOLDERITEM
	    ON
	    	FOLDER.FOLDER_ID = FOLDERITEM.FOLDER_ID
	    WHERE
	    	FOLDER.FOLDER_ID IN (?UniqueID?)
	    AND
	    	FOLDERITEM.STOREENT_ID in ($STOREPATH:catalog$, $STOREPATH:promotions$, $STOREPATH:campaigns$)
	    ORDER BY			
			FOLDERITEM.FOLDERITEMTYPE ASC, FOLDERITEM.REFERENCE_ID ASC
END_XPATH_TO_SQL_STATEMENT



<!-- =============================================================== -->
<!-- This SQL will return all the folders having a parent folder     -->
<!-- with a given unique ID for a specified store path.			     -->
<!-- The access profiles that apply to this SQL are:				 -->
<!--	IBM_Admin_Details											 -->
<!-- @param UniqueID Unique ID of the parent folder to retrieve		 -->
<!-- child folders of.											     --> 
<!-- =============================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Folder[ParentFolderIdentifier[(UniqueID=)]]
	base_table=FOLDER
	sql=
		SELECT
			FOLDER.$COLS:FOLDER_ID$
		FROM
			FOLDER
		WHERE
			PARENTFOLDER_ID IN (?UniqueID?)
		AND
			STOREENT_ID in ($STOREPATH:catalog$, $STOREPATH:promotions$, $STOREPATH:campaigns$)
		ORDER BY
			STOREENT_ID ASC, FOLDER.IDENTIFIER ASC
END_XPATH_TO_SQL_STATEMENT



<!-- ================================================================= -->
<!-- This SQL will return all the top level folders for a given tool   -->
<!--  and store path.  												   -->
<!-- The access profiles that apply to this SQL are:				   -->
<!--	IBM_Admin_Details											   -->
<!-- @param FolderUsage The tool this folder is used for.			   -->
<!-- ================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Folder[(FolderUsage=)]
	base_table=FOLDER
	sql=
		SELECT
			FOLDER.$COLS:FOLDER_ID$
		FROM
			FOLDER
		WHERE
			TYPE IN (?FolderUsage?)
		AND
			PARENTFOLDER_ID IS NULL
		AND
			FOLDER.STOREENT_ID IN ($STOREPATH:catalog$, $STOREPATH:promotions$, $STOREPATH:campaigns$)
		ORDER BY
			STOREENT_ID ASC, FOLDER.IDENTIFIER ASC
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================= -->
<!-- Adds base folder info to the resultant data graph.        -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootFolder
	base_table=FOLDER
	additional_entity_objects=true
	sql=
		SELECT 
			FOLDER.$COLS:FOLDER$
		FROM
			FOLDER
		WHERE
			FOLDER.FOLDER_ID IN ($ENTITY_PKS$)
		ORDER BY
			STOREENT_ID ASC, FOLDER.IDENTIFIER ASC
END_ASSOCIATION_SQL_STATEMENT
 

<!-- =========================================================== -->
<!-- Adds store identifier (STOREENT table) of a folder to the   -->
<!-- resultant data graph.                                       -->           
<!-- =========================================================== --> 
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_FolderStoreIdentifier
	base_table=FOLDER
	sql=
		SELECT 
			FOLDER.$COLS:FOLDER$,
			STOREENT.$COLS:STOREENT$
		FROM 
			FOLDER 
		LEFT JOIN 
			STOREENT 
		ON 
			FOLDER.STOREENT_ID = STOREENT.STOREENT_ID 
		WHERE 
			FOLDER.FOLDER_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT	



<!-- ===================================================================== -->
<!-- Adds folder items (FOLDERITEM table) in a folder    --> 
<!-- to the resultant data graph.                  						   -->                               
<!-- ===================================================================== --> 
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_ChildFolderItems
	base_table=FOLDER
	additional_entity_objects=true
	sql=
		SELECT
			FOLDER.$COLS:FOLDER$,
			FOLDERITEM.$COLS:FOLDERITEM$
		FROM
		     FOLDER
		LEFT JOIN
			FOLDERITEM
        ON
			FOLDER.FOLDER_ID = FOLDERITEM.FOLDER_ID
		WHERE
			FOLDER.FOLDER_ID IN ($ENTITY_PKS$)
        AND
			FOLDERITEM.FOLDERITEM_ID IN ($SUBENTITY_PKS$)
		ORDER BY			
			 FOLDERITEM.FOLDERITEMTYPE ASC, FOLDERITEM.REFERENCE_ID ASC
END_ASSOCIATION_SQL_STATEMENT	



<!-- ================================================================= -->
<!-- This SQL will return the folders that reference an object with    -->
<!--	a given reference ID and folder item type					   -->
<!-- The access profiles that apply to this SQL are:				   -->
<!--	IBM_Admin_Details											   -->
<!-- @param ReferenceID The ID of the object to find references for.   -->
<!-- @param FolderItemType The type of object to find references for.  -->
<!-- ================================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Folder[FolderItem[FolderItemType= and ReferenceID=]]
	base_table=FOLDER
	sql=
		SELECT
			FOLDER.$COLS:FOLDER_ID$
		FROM
			FOLDER
		WHERE
			FOLDER_ID 
			IN 
				(SELECT FOLDER_ID FROM FOLDERITEM 
			WHERE 
				FOLDERITEM.FOLDERITEMTYPE IN (?FolderItemType?)
			AND
			 	FOLDERITEM.REFERENCE_ID IN (?ReferenceID?))
			AND
				FOLDER.STOREENT_ID IN ($STOREPATH:catalog$, $STOREPATH:promotions$, $STOREPATH:campaigns$)
		ORDER BY
			STOREENT_ID ASC, FOLDER.IDENTIFIER ASC 
END_XPATH_TO_SQL_STATEMENT




<!-- ========================================================= --> 
<!-- Select a folder by ID.							           -->
<!-- @param folderId The unique ID of the folder to select.    --> 
<!-- ========================================================= --> 
BEGIN_SQL_STATEMENT
	name=IBM_Select_FolderById
	base_table=FOLDER
	sql=
		SELECT * FROM FOLDER WHERE FOLDER_ID=?folderId?
END_SQL_STATEMENT


<!-- ========================================================= --> 
<!-- Select parent folder id of a folder by ID.				   -->
<!-- @param folderId The unique ID of the folder to select.    --> 
<!-- ========================================================= --> 
BEGIN_SQL_STATEMENT
	name=IBM_Select_ParentFolderId_ById
	base_table=FOLDER
	sql=
		SELECT FOLDER.$COLS:IDENTIFIER$, FOLDER.$COLS:PARENTFOLDER_ID$ FROM FOLDER WHERE FOLDER_ID=?folderId?
END_SQL_STATEMENT

<!-- ============================================================== --> 
<!-- Select the store relationship by store id and related store id -->
<!-- @param storeId The unique ID of the store.                     -->
<!-- @param relatedStoreId The unique ID of the related store.      --> 
<!-- ============================================================== --> 
BEGIN_SQL_STATEMENT
	name=IBM_Select_StoreRelationship_ByStoreId
	base_table=FOLDER
	sql=
		SELECT * FROM STOREREL WHERE STORE_ID = ?storeId? AND RELATEDSTORE_ID = ?relatedStoreId?
END_SQL_STATEMENT


<!-- ============================================================================= -->
<!-- The access profile to use when returning information about a folder excluding -->
<!-- the child folder items in that folder.										   -->
<!-- ============================================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_Details
	BEGIN_ENTITY 
	  base_table=FOLDER 
	  associated_sql_statement=IBM_RootFolder	  
      associated_sql_statement=IBM_FolderStoreIdentifier
    END_ENTITY
END_PROFILE

<!-- ============================================================================= -->
<!-- The access profile to use when returning information about a folder including -->
<!-- the child folder items in that folder.										   -->
<!-- ============================================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_ChildFolderItems
	BEGIN_ENTITY 
	  base_table=FOLDER 
	  associated_sql_statement=IBM_RootFolder	  
      associated_sql_statement=IBM_FolderStoreIdentifier
      associated_sql_statement=IBM_ChildFolderItems
    END_ENTITY
END_PROFILE