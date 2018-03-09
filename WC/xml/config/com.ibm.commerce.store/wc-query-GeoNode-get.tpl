BEGIN_SYMBOL_DEFINITIONS
	
	COLS:GEONODE=GEONODE:*	
	COLS:GEONODEID=GEONODE:GEONODE_ID
	COLS:GEOTREE=GEOTREE:*
	COLS:GEONDDS=GEONDDS:*

END_SYMBOL_DEFINITIONS


<!-- ===========================================================================
     Get all site level top level geo nodes.
     @param topGeoNode  A flag to indicate whether top level or non-top level geo nodes are retrieved.  This is reserved for future use
                        when non-top level geo nodes are needed.  Right now, the only valid value is true.
     @param CTX:LANG_ID The language for which to retrieve the geo nodes.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/GeoNode[@topGeoNode=]+IBM_Store_All
	base_table=GEONODE
	sql=
		SELECT
			GEONODE.$COLS:GEONODE$,
			GEONDDS.$COLS:GEONDDS$,
			GEOTREE.$COLS:GEOTREE$
		FROM
			GEONODE, GEONDDS, GEOTREE
		WHERE
			GEOTREE.PARENT_GEONODE_ID IS NULL
			AND GEONODE.STOREENT_ID = 0
			AND GEONODE.GEONODE_ID = GEOTREE.CHILD_GEONODE_ID
			AND GEONODE.GEONODE_ID = GEONDDS.GEONODE_ID
			AND GEONDDS.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			GEOTREE.SEQUENCE, GEONODE.GEONODE_ID

END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get all top level geo nodes of a web store.
     @param topGeoNode  A flag to indicate whether top level or non-top level geo nodes are retrieved.  This is reserved for future use
                        when non-top level geo nodes are needed.  Right now, the only valid value is true.
	 @param UniqueID    The unique ID of the web store.
     @param CTX:LANG_ID The language for which to retrieve the geo nodes.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/GeoNode[@topGeoNode= and StoreIdentifier[UniqueID=]]+IBM_Store_All
	base_table=GEONODE
	sql=
		SELECT
			GEONODE.$COLS:GEONODE$,
			GEONDDS.$COLS:GEONDDS$,
			GEOTREE.$COLS:GEOTREE$
		FROM
			GEONODE, GEONDDS, GEOTREE
		WHERE
			GEOTREE.PARENT_GEONODE_ID IS NULL
			AND GEONODE.STOREENT_ID = ?UniqueID?
			AND GEONODE.GEONODE_ID = GEOTREE.CHILD_GEONODE_ID
			AND GEONODE.GEONODE_ID = GEONDDS.GEONODE_ID
			AND GEONDDS.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			GEOTREE.SEQUENCE, GEONODE.GEONODE_ID

END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get a geo node by its unique ID.
     @param UniqueID    The unique ID of the geo node.
     @param CTX:LANG_ID The language for which to retrieve the geo nodes.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/GeoNode[GeoNodeIdentifier[UniqueID=]]+IBM_Store_All
	base_table=GEONODE
	sql=
		SELECT
			GEONODE.$COLS:GEONODE$,
			GEONDDS.$COLS:GEONDDS$
		FROM
			GEONODE, GEONDDS
		WHERE
			GEONODE.GEONODE_ID = ?UniqueID?
			AND GEONODE.GEONODE_ID = GEONDDS.GEONODE_ID
			AND GEONDDS.LANGUAGE_ID = $CTX:LANG_ID$

END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get child geo nodes of a geo node by the unique ID of the parent geo node.
     @param UniqueID    The unique ID of the parent goe node.
     @param CTX:LANG_ID The language for which to retrieve the geo nodes.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/GeoNode[ParentGeoNodeIdentifier[UniqueID=]]+IBM_Store_All
	base_table=GEONODE
	sql=
		SELECT
			GEONODE.$COLS:GEONODE$,
			GEONDDS.$COLS:GEONDDS$,
			GEOTREE.$COLS:GEOTREE$
		FROM
			GEONODE, GEONDDS, GEOTREE
		WHERE
			GEOTREE.PARENT_GEONODE_ID = ?UniqueID?
			AND GEONODE.GEONODE_ID = GEOTREE.CHILD_GEONODE_ID
			AND GEONODE.GEONODE_ID = GEONDDS.GEONODE_ID
			AND GEONDDS.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			GEOTREE.SEQUENCE, GEONODE.GEONODE_ID

END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get site level child geo nodes of a geo node by the external identifier of the parent geo node.
     @param ExternalIdentifier The external identifier of the parent goe node.
     @param CTX:LANG_ID        The language for which to retrieve the geo nodes.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/GeoNode[ParentGeoNodeIdentifier[ExternalIdentifier=]]+IBM_Store_All
	base_table=GEONODE
	sql=
		SELECT
			GEONODE.$COLS:GEONODE$,
			GEONDDS.$COLS:GEONDDS$,
			GEOTREE.$COLS:GEOTREE$
		FROM
			GEONODE, GEONDDS, GEOTREE
		WHERE
			GEOTREE.PARENT_GEONODE_ID = (
				SELECT GEONODE_ID FROM GEONODE WHERE IDENTIFIER = ?ExternalIdentifier?
					AND GEONODE.STOREENT_ID = 0
			)
			AND GEONODE.GEONODE_ID = GEOTREE.CHILD_GEONODE_ID
			AND GEONODE.GEONODE_ID = GEONDDS.GEONODE_ID
			AND GEONDDS.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			GEOTREE.SEQUENCE, GEONODE.GEONODE_ID

END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get web store level child geo nodes of a geo node by the external identifier of the parent geo node and the web store unique ID.
     @param ExternalIdentifier The external identifier of the parent goe node.
	 @param UniqueID           The unique ID of the web store.
     @param CTX:LANG_ID        The language for which to retrieve the geo nodes.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/GeoNode[ParentGeoNodeIdentifier[ExternalIdentifier=] and StoreIdentifier[UniqueID=]]+IBM_Store_All
	base_table=GEONODE
	sql=
		SELECT
			GEONODE.$COLS:GEONODE$,
			GEONDDS.$COLS:GEONDDS$,
			GEOTREE.$COLS:GEOTREE$
		FROM
			GEONODE, GEONDDS, GEOTREE
		WHERE
			GEOTREE.PARENT_GEONODE_ID = (
				SELECT GEONODE_ID FROM GEONODE WHERE IDENTIFIER = ?ExternalIdentifier?
					AND GEONODE.STOREENT_ID = ?UniqueID?
			)
			AND GEONODE.GEONODE_ID = GEOTREE.CHILD_GEONODE_ID
			AND GEONODE.GEONODE_ID = GEONDDS.GEONODE_ID
			AND GEONDDS.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			GEOTREE.SEQUENCE, GEONODE.GEONODE_ID

END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get site level geo node information of a geo node by its type and name.
     @param Type        The type of the geo node.
     @param CTX:LANG_ID The language for which to retrieve the geo nodes.  This parameter is retrieved from the Commerce business context. 
     @param ATTR_CNDS   The name of the geo node is contained in this search criteria
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/GeoNode[@type= and search()]
	base_table=GEONODE
	sql=
		SELECT
		        DISTINCT GEONODE.$COLS:GEONODEID$
		FROM
			GEONODE, GEONDDS, $ATTR_TBLS$
		WHERE
			GEONODE.TYPE = ?type?
			AND GEONODE.STOREENT_ID = 0
			AND GEONODE.GEONODE_ID = GEONDDS.GEONODE_ID
			AND GEONDDS.LANGUAGE_ID = $CTX:LANG_ID$
			AND GEONODE.$ATTR_CNDS$
		ORDER BY
			GEONODE.GEONODE_ID

END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get web store level geo node information of a geo node by its type and name, and the web store unique ID.
     @param Type        The type of the geo node.
	 @param UniqueID    The unique ID of the web store.
     @param CTX:LANG_ID The language for which to retrieve the geo nodes.  This parameter is retrieved from the Commerce business context. 
     @param ATTR_CNDS   The name of the geo node is contained in this search criteria
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/GeoNode[@type= and StoreIdentifier[UniqueID=] and search()]
	base_table=GEONODE
	sql=
		SELECT
		        DISTINCT GEONODE.$COLS:GEONODEID$
		FROM
			GEONODE, GEONDDS, $ATTR_TBLS$
		WHERE
			GEONODE.TYPE = ?type?
			AND GEONODE.STOREENT_ID = ?UniqueID?
			AND GEONODE.GEONODE_ID = GEONDDS.GEONODE_ID
			AND GEONDDS.LANGUAGE_ID = $CTX:LANG_ID$
			AND GEONODE.$ATTR_CNDS$
		ORDER BY
			GEONODE.GEONODE_ID

END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     The associated SQL that retrieves the geonode all information.
     @param ENTITY_PKS  The result geonode IDs from the previous SQL execution.
     @param CTX:LANG_ID The language for which to retrieve the geonode information.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT

	name=GeoNodeAll
	base_table=GEONODE
	additional_entity_objects=true
	sql=
		SELECT
			GEONODE.$COLS:GEONODE$,
			GEONDDS.$COLS:GEONDDS$
		FROM
			GEONODE, GEONDDS
	    	WHERE 
	    	    	GEONODE.GEONODE_ID IN ( $ENTITY_PKS$ )
			AND GEONODE.GEONODE_ID = GEONDDS.GEONODE_ID
			AND GEONDDS.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			GEONODE.GEONODE_ID
                
END_ASSOCIATION_SQL_STATEMENT


<!-- ===================================================================================
     The profile to associate access profile IBM_Store_All to the related SQL statement.
     =================================================================================== -->
BEGIN_PROFILE 

	name=IBM_Store_All
	BEGIN_ENTITY 
		base_table=GEONODE
		associated_sql_statement=GeoNodeAll
	END_ENTITY
	
END_PROFILE


<!-- ========================================================================= -->
<!-- Get all TYPE of GEONODE on the server                                     -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	
	name=IBM_ALL_GEONODE_TYPE
	base_table=geonode
	sql=
		SELECT 
			DISTINCT TYPE 
		FROM 
			GEONODE
END_SQL_STATEMENT
