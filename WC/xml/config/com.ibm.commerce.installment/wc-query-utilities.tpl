<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce 5724-I36, 5724-I37, 5724-I38, 5724-I39,        -->
<!--  5724-I40, 5724-I41                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2009                                      -->
<!--                                                                    -->
<!-- US Government Users Restricted Rights - Use, duplication or        -->
<!-- disclosure restricted by GSA ADP Schedule Contract with IBM Corp.  -->
<!--********************************************************************-->

BEGIN_SYMBOL_DEFINITIONS
END_SYMBOL_DEFINITIONS

BEGIN_SQL_STATEMENT
  name=IBM_GetParentCatalogEntryId
  base_table=CATENTREL
  sql=SELECT CATENTRY_ID_PARENT FROM CATENTREL WHERE CATENTRY_ID_CHILD=?catalogEntryId? AND CATRELTYPE_ID=?type?
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
  name=IBM_GetParentCatalogGroupIdByCatalogEntryId
  base_table=CATGPENREL
  sql=SELECT CATGROUP_ID FROM CATGPENREL WHERE CATALOG_ID=?catalogId? AND CATENTRY_ID=?catalogEntryId? 
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
  name=IBM_GetParentCatalogGroupIdByCatalogGroupId
  base_table=CATGRPREL
  sql=SELECT CATGROUP_ID_PARENT FROM CATGRPREL WHERE CATALOG_ID=?catalogId? AND CATGROUP_ID_CHILD=?catalogGroupId? 
END_SQL_STATEMENT
