BEGIN_SYMBOL_DEFINITIONS
    
	COLS:STLOC=STLOC:*
	COLS:STLOCID=STLOC:STLOC_ID
	COLS:IDENTIFIER=STLOC:IDENTIFIER
	COLS:STLOCDS=STLOCDS:*
	COLS:STLOCATTR=STLOCATTR:*
	
END_SYMBOL_DEFINITIONS


<!-- ===========================================================================
     Get physical stores by unique IDs of the physical stores.
     @param UniqueID    The unique IDs of the physical stores.
     @param CTX:LANG_ID The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	
	name=/PhysicalStore[PhysicalStoreIdentifier[(UniqueID=)]]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$, STLOC.$COLS:IDENTIFIER$
		FROM
			STLOC, STLOCDS, STLOCATTR
		WHERE 
	    	    	STLOC.STLOC_ID IN ( ?UniqueID? ) 
	    	    	AND STLOC.ACTIVE = 1
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			STLOC.IDENTIFIER
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get site level physical stores by external identifiers of the physical stores.
     @param ExternalIdentifier The external identifiers of the physical stores.
     @param CTX:LANG_ID        The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	
	name=/PhysicalStore[PhysicalStoreIdentifier[(ExternalIdentifier=)]]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$, STLOC.$COLS:IDENTIFIER$
		FROM
			STLOC, STLOCDS, STLOCATTR
	    	WHERE 
	    	    	STLOC.IDENTIFIER IN ( ?ExternalIdentifier? )
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = 0
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			STLOC.IDENTIFIER
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get web store level physical stores by external identifiers of the physical stores and web store unique ID.
     @param ExternalIdentifier The external identifiers of the physical stores.
     @param UniqueID           The unique ID of the web store.
     @param CTX:LANG_ID        The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	
	name=/PhysicalStore[PhysicalStoreIdentifier[(ExternalIdentifier=)] and StoreIdentifier[UniqueID=]]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$, STLOC.$COLS:IDENTIFIER$
		FROM
			STLOC, STLOCDS, STLOCATTR
	    	WHERE 
	    	    	STLOC.IDENTIFIER IN ( ?ExternalIdentifier? )
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = ?UniqueID?
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			STLOC.IDENTIFIER
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get site level physical stores by either the unique IDs or the external identifiers of the physical stores.
     @param UniqueID           The unique IDs of the physical stores.
     @param ExternalIdentifier The external identifiers of the physical stores.
     @param CTX:LANG_ID        The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	
	name=/PhysicalStore[PhysicalStoreIdentifier[(ExternalIdentifier=) or (UniqueID=)]]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$, STLOC.$COLS:IDENTIFIER$
		FROM
			STLOC, STLOCDS, STLOCATTR
	        WHERE 
	    	    	(STLOC.STLOC_ID IN ( ?UniqueID? ) 
	    	    	 OR STLOC.IDENTIFIER IN ( ?ExternalIdentifier? ))
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = 0
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			STLOC.IDENTIFIER
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get web store level physical stores by either the unique IDs or the external identifiers of the physical stores, and the web store unique ID.
     @param ExternalIdentifier The external identifiers of the physical stores.
     @param UniqueID.1         The unique IDs of the physical stores.
     @param UniqueID.2         The unique ID of the web store.
     @param CTX:LANG_ID        The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	
	name=/PhysicalStore[PhysicalStoreIdentifier[(ExternalIdentifier=) or (UniqueID=)] and StoreIdentifier[UniqueID=]]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$, STLOC.$COLS:IDENTIFIER$
		FROM
			STLOC, STLOCDS, STLOCATTR
	        WHERE 
	    	    	(STLOC.STLOC_ID IN ( ?UniqueID.1? ) 
	    	    	 OR STLOC.IDENTIFIER IN ( ?ExternalIdentifier? ))
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = ?UniqueID.2?
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			STLOC.IDENTIFIER
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get physical stores by geonode unique ID.
     @param UniqueID    The unique ID of the geonode in which the physical stores locate.
     @param CTX:LANG_ID The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[LocationInfo[GeoNodeIdentifier[UniqueID=]]]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$, STLOC.$COLS:IDENTIFIER$
		FROM
			STLOC, STLOCDS, STLOCATTR
	    	WHERE 
	    	    	STLOC.GEONODE_ID IN ( ?UniqueID? )
	    	    	AND STLOC.ACTIVE = 1
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			STLOC.IDENTIFIER
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get physical store IDs by geonode unique ID with specific attributes.
     @param UniqueID    The unique ID of the geonode in which the physical stores locates.
     @param search()    This contains the name-value pairs of the attributes of the physical stores to be returned.
     @param CTX:LANG_ID The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[LocationInfo[GeoNodeIdentifier[UniqueID=]] and search()]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$, STLOC.$COLS:IDENTIFIER$
		FROM
			STLOC, STLOCDS, STLOCATTR, $ATTR_TBLS$
	    	WHERE 
	    	    	STLOC.GEONODE_ID IN ( ?UniqueID? )
	    	    	AND STLOC.ACTIVE = 1
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOC.$ATTR_CNDS$
		ORDER BY
			STLOC.IDENTIFIER
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get site level physical stores based on a geo code as a starting location.
     @param Latitude          The latitude value of the geo code.
     @param Longitude         The Longitude value of the geo code.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[LocationInfo[GeoCode[Latitude= and Longitude=]]]+IBM_Store_Details
	base_table=STLOC
	sql=
		SELECT 
			STLOC.$COLS:STLOC$,
			STLOCDS.$COLS:STLOCDS$,
			STLOCATTR.$COLS:STLOCATTR$
		FROM
			STLOC, STLOCDS, STLOCATTR
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND (
	    	    	  (  ( $CTX:NW_LONGITUDE$ <= cast(0 as decimal(20,5)) OR $CTX:SE_LONGITUDE$ >= cast(0 as decimal(20,5)) )  
	    	    	     AND 
	    	    	     (STLOC.LONGITUDE > $CTX:NW_LONGITUDE$ AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$) 
	    	    	  )
	    	    	  OR 
	    	    	  (  ( $CTX:NW_LONGITUDE$ > cast(0 as decimal(20,5)) AND $CTX:SE_LONGITUDE$ < cast(0 as decimal(20,5)) ) 
	    	    	     AND 
	    	    	     ( STLOC.LONGITUDE < $CTX:SE_LONGITUDE$ OR STLOC.LONGITUDE > $CTX:NW_LONGITUDE$ ) 
	    	    	  )
	    	    	)	    	    	 
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = 0
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get web store level physical stores by web store unique ID and based on a geo code as a starting location.
     @param Latitude          The latitude value of the geo code.
     @param Longitude         The Longitude value of the geo code.
	 @param UniqueID          The unique ID of the web store.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[LocationInfo[GeoCode[Latitude= and Longitude=]] and StoreIdentifier[UniqueID=]]+IBM_Store_Details
	base_table=STLOC
	sql=
		SELECT 
			STLOC.$COLS:STLOC$,
			STLOCDS.$COLS:STLOCDS$,
			STLOCATTR.$COLS:STLOCATTR$
		FROM
			STLOC, STLOCDS, STLOCATTR
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND STLOC.LONGITUDE > $CTX:NW_LONGITUDE$
	    	    	AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$ 
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = ?UniqueID?
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get site level physical store IDs based on a geo code as a starting location with specific attributes.
     @param Latitude          The latitude value of the geo code.
     @param Longitude         The Longitude value of the geo code.
     @param search()          This contains the name-value pairs of the attributes of the physical stores to be returned.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[LocationInfo[GeoCode[Latitude= and Longitude=]] and search()]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$
		FROM
			STLOC, STLOCDS, STLOCATTR, $ATTR_TBLS$
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND STLOC.LONGITUDE > $CTX:NW_LONGITUDE$
	    	    	AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = 0
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOC.$ATTR_CNDS$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get web store level physical store IDs by web store Unique ID and based on a geo code as a starting location with specific attributes.
     @param Latitude          The latitude value of the geo code.
     @param Longitude         The Longitude value of the geo code.
	 @param UniqueID          The unique ID of the web store.
     @param search()          This contains the name-value pairs of the attributes of the physical stores to be returned.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[LocationInfo[GeoCode[Latitude= and Longitude=]] and StoreIdentifier[UniqueID=] and search()]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$
		FROM
			STLOC, STLOCDS, STLOCATTR, $ATTR_TBLS$
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND STLOC.LONGITUDE > $CTX:NW_LONGITUDE$
	    	    	AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = ?UniqueID?
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOC.$ATTR_CNDS$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get site level physical stores based on a physical store unique ID as a starting location.
     @param UniqueID          The unique ID of the starting location.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[PhysicalStoreIdentifier[UniqueID=]]+IBM_Store_Details
	base_table=STLOC
	sql=
		SELECT 
			STLOC.$COLS:STLOC$,
			STLOCDS.$COLS:STLOCDS$,
			STLOCATTR.$COLS:STLOCATTR$
		FROM
			STLOC, STLOCDS, STLOCATTR
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND STLOC.LONGITUDE > $CTX:NW_LONGITUDE$
	    	    	AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = 0
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get web store level physical stores by web store unique ID and based on a physical store unique ID as a starting location.
     @param UniqueID.1        The unique ID of the starting location.
	 @param UniqueID.2        The unique ID of the web store.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[PhysicalStoreIdentifier[UniqueID=] and StoreIdentifier[UniqueID=]]+IBM_Store_Details
	base_table=STLOC
	sql=
		SELECT 
			STLOC.$COLS:STLOC$,
			STLOCDS.$COLS:STLOCDS$,
			STLOCATTR.$COLS:STLOCATTR$
		FROM
			STLOC, STLOCDS, STLOCATTR
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND STLOC.LONGITUDE > $CTX:NW_LONGITUDE$
	    	    	AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = ?UniqueID.2?
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get site level physical stores based on a physical store external identifier as a starting location.
     @param UniqueID          The external identifier of the starting location.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[PhysicalStoreIdentifier[ExternalIdentifier=]]+IBM_Store_Details
	base_table=STLOC
	sql=
		SELECT 
			STLOC.$COLS:STLOC$,
			STLOCDS.$COLS:STLOCDS$,
			STLOCATTR.$COLS:STLOCATTR$
		FROM
			STLOC, STLOCDS, STLOCATTR
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND STLOC.LONGITUDE > $CTX:NW_LONGITUDE$
	    	    	AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = 0
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get web store level physical stores by web store unique ID and based on a physical store external identifier as a starting location.
     @param ExternalIdentifier The external identifier of the starting location.
	 @param UniqueID           The unique ID of the web store.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[PhysicalStoreIdentifier[ExternalIdentifier=] and StoreIdentifier[UniqueID=]]+IBM_Store_Details
	base_table=STLOC
	sql=
		SELECT 
			STLOC.$COLS:STLOC$,
			STLOCDS.$COLS:STLOCDS$,
			STLOCATTR.$COLS:STLOCATTR$
		FROM
			STLOC, STLOCDS, STLOCATTR
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND STLOC.LONGITUDE > $CTX:NW_LONGITUDE$
	    	    	AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$
	    	    	AND STLOC.ACTIVE = 1
			AND STLOC.STOREENT_ID = ?UniqueID?
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get site level physical stores based on a physical store unique ID as a starting location with specific attributes.
     @param UniqueID          The unique ID of the starting location.
     @param search()          This contains the name-value pairs of the attributes of the physical stores to be returned.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[PhysicalStoreIdentifier[UniqueID=] and search()]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$
		FROM
			STLOC, STLOCDS, STLOCATTR, $ATTR_TBLS$
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND STLOC.LONGITUDE > $CTX:NW_LONGITUDE$
	    	    	AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$
	    	    	AND STLOC.ACTIVE = 1
					AND STLOC.STOREENT_ID = 0
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOC.$ATTR_CNDS$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get web store level physical stores by web store unique ID and based on a physical store unique ID as a starting location with specific attributes.
     @param UniqueID.1        The unique ID of the starting location.
	 @param UniqueID.2        The unique ID of the web store.
     @param search()          This contains the name-value pairs of the attributes of the physical stores to be returned.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[PhysicalStoreIdentifier[UniqueID=] and StoreIdentifier[UniqueID=] and search()]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$
		FROM
			STLOC, STLOCDS, STLOCATTR, $ATTR_TBLS$
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND STLOC.LONGITUDE > $CTX:NW_LONGITUDE$
	    	    	AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$
	    	    	AND STLOC.ACTIVE = 1
					AND STLOC.STOREENT_ID = ?UniqueID.2?
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOC.$ATTR_CNDS$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get site level physical stores based on a physical store external identifier as a starting location with specific attributes.
     @param UniqueID          The external identifier of the starting location.
     @param search()          This contains the name-value pairs of the attributes of the physical stores to be returned.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[PhysicalStoreIdentifier[ExternalIdentifier=] and search()]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$
		FROM
			STLOC, STLOCDS, STLOCATTR, $ATTR_TBLS$
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND STLOC.LONGITUDE > $CTX:NW_LONGITUDE$
	    	    	AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$
	    	    	AND STLOC.ACTIVE = 1
					AND STLOC.STOREENT_ID = 0
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOC.$ATTR_CNDS$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     Get web store level physical stores by web store unique ID and based on a physical store external identifier as a starting location with specific attributes.
     @param ExternalIdentifier The external identifier of the starting location.
	 @param UniqueID           The unique ID of the web store.
     @param search()           This contains the name-value pairs of the attributes of the physical stores to be returned.
     @param CTX:NW_LATITUDE
     @param CTX:SE_LATITUDE
     @param CTX:NW_LONGITUDE
     @param CTX:SE_LONGITUDE
     @param CTX:LANG_ID       The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT

	name=/PhysicalStore[PhysicalStoreIdentifier[ExternalIdentifier=] and StoreIdentifier[UniqueID=] and search()]
	base_table=STLOC
	sql=
		SELECT 
			DISTINCT STLOC.$COLS:STLOCID$
		FROM
			STLOC, STLOCDS, STLOCATTR, $ATTR_TBLS$
	    	WHERE 
	    	    	STLOC.LATITUDE < $CTX:NW_LATITUDE$
	    	    	AND STLOC.LATITUDE > $CTX:SE_LATITUDE$
	    	    	AND STLOC.LONGITUDE > $CTX:NW_LONGITUDE$
	    	    	AND STLOC.LONGITUDE < $CTX:SE_LONGITUDE$
	    	    	AND STLOC.ACTIVE = 1
					AND STLOC.STOREENT_ID = ?UniqueID?
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOC.$ATTR_CNDS$
									
END_XPATH_TO_SQL_STATEMENT


<!-- ===========================================================================
     The associated SQL that retrieves the physical store detail information.
     @param ENTITY_PKS  The result physical store IDs from the previous SQL execution.
     @param CTX:LANG_ID The language for which to retrieve the physical stores.  This parameter is retrieved from the Commerce business context. 
     =========================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT

	name=PhysicalStoreWithDescriptionsWithAttributes
	base_table=STLOC
	additional_entity_objects=true
	sql=
		SELECT 
			STLOC.$COLS:STLOC$,
			STLOCDS.$COLS:STLOCDS$,
			STLOCATTR.$COLS:STLOCATTR$
		FROM
			STLOC, STLOCDS, STLOCATTR
	    	WHERE 
	    	    	STLOC.STLOC_ID IN ( $ENTITY_PKS$ )
	    	    	AND STLOC.STLOC_ID = STLOCDS.STLOC_ID
	    	    	AND STLOCDS.LANGUAGE_ID = $CTX:LANG_ID$
	    	    	AND STLOCATTR.STLOC_ID = STLOC.STLOC_ID
	    	    	AND STLOCATTR.LANGUAGE_ID = $CTX:LANG_ID$
		ORDER BY
			STLOC.IDENTIFIER, STLOCATTR.SEQUENCE
                
END_ASSOCIATION_SQL_STATEMENT


<!-- =======================================================================================
     The profile to associate access profile IBM_Store_Details to the related SQL statement.
     ======================================================================================= -->
BEGIN_PROFILE 

	name=IBM_Store_Details
	BEGIN_ENTITY 
		base_table=STLOC
		associated_sql_statement=PhysicalStoreWithDescriptionsWithAttributes
	END_ENTITY
	
END_PROFILE

