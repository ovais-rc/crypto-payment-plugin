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
		COLS:CMVERSNINFO = CMVERSNINFO:*				     							 		     
		COLS:CMACTVERSN = CMACTVERSN:*						
END_SYMBOL_DEFINITIONS

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ContentVersion[ContentVersionIdentifier[ContentVersionExternalIdentifier[ObjectId= and ConfigGrpId=]]]+IBM_Admin_ContentVersionUpdate  
	base_table=CMVERSNINFO
	sql=	
		SELECT CMVERSNINFO.$COLS:CMVERSNINFO$, CMACTVERSN.$COLS:CMACTVERSN$   				
	  FROM CMVERSNINFO LEFT JOIN CMACTVERSN ON (CMVERSNINFO.CMVERSNINFO_ID = CMACTVERSN.CMVERSNINFO_ID)
	  WHERE CMVERSNINFO.OBJECT_ID = ?ObjectId? AND CMVERSNINFO.CONFIG_GROUP_ID = ?ConfigGroupId? AND CMVERSNINFO.STOREENT_ID = $CTX:STORE_ID$
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================== -->
<!-- This SQL will return the data of the ContentVersion noun                       -->
<!-- for the version of the specified UniqueID.                                     -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_ContentVersionUpdate -->
<!-- @param UniqueID The uniqueId of the version                                    -->
<!-- ============================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ContentVersion[ContentVersionIdentifier[UniqueID=]]+IBM_Admin_ContentVersionUpdate
	base_table=CMVERSNINFO
	sql=	
		SELECT CMVERSNINFO.$COLS:CMVERSNINFO$, CMACTVERSN.$COLS:CMACTVERSN$	
	  	FROM CMVERSNINFO LEFT JOIN CMACTVERSN ON (CMVERSNINFO.CMVERSNINFO_ID = CMACTVERSN.CMVERSNINFO_ID)
	  	WHERE  CMVERSNINFO.CMVERSNINFO_ID = ?UniqueID? AND CMVERSNINFO.STOREENT_ID = $CTX:STORE_ID$
END_XPATH_TO_SQL_STATEMENT


