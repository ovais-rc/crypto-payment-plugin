<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2012                                     -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS

	<!-- All the columns of the store page layout type relation table -->
	COLS:STOREPLTYPES_ALL = STOREPLTYPES:*
	COLS:PAGELAYOUTTYPE_ALL = PAGELAYOUTTYPE:*
END_SYMBOL_DEFINITIONS

<!-- =========================================================================================================== -->
<!-- This SQL will return all the store page layout type relations defined.                       -->
<!-- =========================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  base_table=STOREPLTYPES
  name=/STOREPLTYPES+IBM_Admin_All
  sql=
		SELECT 
			STOREPLTYPES.$COLS:STOREPLTYPES_ALL$, PAGELAYOUTTYPE.$COLS:PAGELAYOUTTYPE_ALL$
		FROM	
			STOREPLTYPES, PAGELAYOUTTYPE
		WHERE
			STOREPLTYPES.PAGELAYOUTTYPE_ID = PAGELAYOUTTYPE.PAGELAYOUTTYPE_ID
END_XPATH_TO_SQL_STATEMENT
