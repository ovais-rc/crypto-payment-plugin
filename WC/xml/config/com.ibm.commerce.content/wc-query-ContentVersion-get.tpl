<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2010                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS
		<!-- CMVERSNINFO table -->
		COLS:CMVERSNINFO = CMVERSNINFO:*
		<!-- CMACTVERSN table -->				     							 		     
		COLS:CMACTVERSN = CMACTVERSN:*						
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- This SQL will return the data of the ContentVersion noun                 -->
<!-- for all the versions of the specified ObjectId and ObjectType.           -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param ObjectId The uniqueId of the object                               -->
<!-- @param ObjectType The UI ObjectType name of the object.                  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ContentVersion[ContentVersionIdentifier[ContentVersionExternalIdentifier[ObjectId= and ObjectType=]]]+IBM_Admin_Summary  
	base_table=CMVERSNINFO
	sql=	
		SELECT CMVERSNINFO.$COLS:CMVERSNINFO$			
	  	FROM 	CMVERSNINFO 	  			
	  	WHERE 	CMVERSNINFO.OBJECT_ID = ?ObjectId? AND 
	  			CMVERSNINFO.UI_OBJECT_NAME = ?ObjectType? AND
	  			CMVERSNINFO.STOREENT_ID = $CTX:STORE_ID$
	  			ORDER BY CMVERSNINFO.CREATETIME ASC
	paging_count
  	sql =
    	SELECT  
        	COUNT(*) as countrows	  
		FROM
				CMVERSNINFO
		WHERE
				CMVERSNINFO.OBJECT_ID = ?ObjectId? AND 
				CMVERSNINFO.UI_OBJECT_NAME = ?ObjectType? AND
				CMVERSNINFO.STOREENT_ID = $CTX:STORE_ID$				
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the ContentVersion noun                 -->
<!-- for a specific version of the specified ObjectId and ObjectType.         -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param ObjectId The uniqueId of the object                               -->
<!-- @param ObjectType The UI ObjectType name of the object.                  -->
<!-- @param VersionNumber The versionNumber of the object.                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ContentVersion[ContentVersionIdentifier[ContentVersionExternalIdentifier[ObjectId= and ObjectType= and VersionNumber=]]]+IBM_Admin_Summary  
	base_table=CMVERSNINFO
	sql=	
		SELECT CMVERSNINFO.$COLS:CMVERSNINFO$ 				
	  	FROM   CMVERSNINFO 	  				
	  	WHERE 	CMVERSNINFO.OBJECT_ID = ?ObjectId? AND 
	  			CMVERSNINFO.UI_OBJECT_NAME = ?ObjectType? AND
				CMVERSNINFO.VERSION_IDENTIFIER = ?VersionNumber? AND
				CMVERSNINFO.STOREENT_ID = $CTX:STORE_ID$				
	  			ORDER BY CMVERSNINFO.CREATETIME ASC
	paging_count
  	sql =
    	SELECT  
        	COUNT(*) as countrows	  
		FROM
				CMVERSNINFO
		WHERE
				CMVERSNINFO.OBJECT_ID = ?ObjectId? AND 
				CMVERSNINFO.UI_OBJECT_NAME = ?ObjectType? AND
				CMVERSNINFO.STOREENT_ID = $CTX:STORE_ID$				
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the ContentVersion noun                 -->
<!-- for the specified version identifier.                                    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param UniqueId The uniqueId of the version                              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ContentVersion[ContentVersionIdentifier[UniqueId=]]+IBM_Admin_Summary  
	base_table=CMVERSNINFO			   		   
	sql=	
		SELECT CMVERSNINFO.$COLS:CMVERSNINFO$				  				
	  	FROM 	CMVERSNINFO 	  				
	  	WHERE 	CMVERSNINFO.CMVERSNINFO_ID = ?UniqueId?	AND
	  			CMVERSNINFO.STOREENT_ID = $CTX:STORE_ID$	
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the ContentVersion noun                 -->
<!-- for the active version of the specified ObjectId and ObjectType.         -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Active         -->
<!-- @param ObjectId The uniqueId of the object                               -->
<!-- @param ObjectType The UI ObjectType name of the object.                  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ContentVersion[ContentVersionIdentifier[ContentVersionExternalIdentifier[ObjectId= and (ObjectType=)]]]+IBM_Admin_Active  
	base_table=CMACTVERSN			   
	sql=	
		SELECT CMACTVERSN.$COLS:CMACTVERSN$   							 	    
	  	FROM   CMACTVERSN   	  				
	  	WHERE  CMACTVERSN.OBJECT_ID = ?ObjectId? AND 
	  	       CMACTVERSN.UI_OBJECT_NAME IN (?ObjectType?) AND 
	  	       (CMACTVERSN.WORKSPACE = ?workspaceName? OR CMACTVERSN.WORKSPACE = ?defaultWorkspaceName?) AND
	  	       CMACTVERSN.STOREENT_ID = $CTX:STORE_ID$	  	       
	  	ORDER BY CMACTVERSN.CONTENT_TASKGRP ASC

END_XPATH_TO_SQL_STATEMENT
