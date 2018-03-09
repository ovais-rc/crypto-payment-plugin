BEGIN_SYMBOL_DEFINITIONS
	<!-- INVCNF table -->
	COLS:INVCNF=INVCNF:*

	<!-- INVCNFREL table -->
	COLS:INVCNFREL=INVCNFREL:*

	<!-- INVAVL table -->
	COLS:INVAVL=INVAVL:*

END_SYMBOL_DEFINITIONS

<!-- ============================================================= -->
<!-- This SQL will return the elements of the inventory            -->
<!-- configuration for the given catentry/location combination.    -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Details                                                  -->
<!-- @param catEntryId - The catalog entry ID                      -->
<!-- @param storeId    - The online store ID       	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InventoryConfiguration[catEntryId= and storeId=]+IBM_Details
	base_table=INVCNF
	sql=
		SELECT 
				INVCNF.$COLS:INVCNF$
		FROM
				INVCNF
						JOIN INVCNFREL ON (INVCNF.INVCNF_ID=INVCNFREL.INVCNF_ID) 
    WHERE
        (INVCNFREL.CATENTRY_ID = ?catEntryId? AND INVCNFREL.STORE_ID = ?storeId?)
         or (INVCNFREL.CATENTRY_ID is null AND INVCNFREL.STORE_ID = ?storeId?)
         or (INVCNFREL.CATENTRY_ID = ?catEntryId? AND INVCNFREL.STORE_ID is null AND INVCNFREL.STLOC_ID is null) 
         or (INVCNFREL.CATENTRY_ID is null AND INVCNFREL.STORE_ID is null AND INVCNFREL.STLOC_ID is null) 
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the inventory            -->
<!-- configuration for the given catentry/location combination.    -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Details                                                  -->
<!-- @param catEntryId - The catalog entry ID                      -->
<!-- @param stlocId    - The physical store ID       	             -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InventoryConfiguration[catEntryId= and stlocId=]+IBM_Details
	base_table=INVCNF
	sql=
		SELECT 
				INVCNF.$COLS:INVCNF$
		FROM
				INVCNF
						JOIN INVCNFREL ON (INVCNF.INVCNF_ID=INVCNFREL.INVCNF_ID) 
    WHERE
        (INVCNFREL.CATENTRY_ID = ?catEntryId? AND INVCNFREL.STLOC_ID = ?stlocId?)
         or (INVCNFREL.CATENTRY_ID is null AND INVCNFREL.STLOC_ID = ?stlocId?)
         or (INVCNFREL.CATENTRY_ID = ?catEntryId? AND INVCNFREL.STORE_ID is null AND INVCNFREL.STLOC_ID is null) 
         or (INVCNFREL.CATENTRY_ID is null AND INVCNFREL.STORE_ID is null AND INVCNFREL.STLOC_ID is null) 
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the inventory            -->
<!-- availability for the given catentry/location combination.     -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Store_Details                                             -->
<!-- @param UniqueID.1 - The catalog entry ID                      -->
<!-- @param UniqueID.2 - The online store ID       	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InventoryAvailability[InventoryAvailabilityIdentifier/ExternalIdentifier[CatalogEntryIdentifier[(UniqueID=)] and OnlineStoreIdentifier[(UniqueID=)]]]+IBM_Store_Details
	base_table=INVAVL
	sql=
		SELECT 
				INVAVL.$COLS:INVAVL$
		FROM
				INVAVL
    WHERE
        INVAVL.CATENTRY_ID in (?UniqueID.1?) AND INVAVL.STORE_ID in (?UniqueID.2?)

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the inventory            -->
<!-- availability for the given catentry/location combination.     -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Store_Details                                             -->
<!-- @param UniqueID.1 - The catalog entry ID                      -->
<!-- @param UniqueID.2 - The physical store ID                     -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InventoryAvailability[InventoryAvailabilityIdentifier/ExternalIdentifier[CatalogEntryIdentifier[(UniqueID=)] and PhysicalStoreIdentifier[(UniqueID=)]]]+IBM_Store_Details
	base_table=INVAVL
	sql=
		SELECT 
				INVAVL.$COLS:INVAVL$
		FROM
				INVAVL
    WHERE
        INVAVL.CATENTRY_ID in (?UniqueID.1?) AND INVAVL.STLOC_ID in (?UniqueID.2?)

END_XPATH_TO_SQL_STATEMENT



<!-- ============================================================= -->
<!-- This SQL will return all the inventory configuration .        -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Details_All                                               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InventoryConfiguration+IBM_Details_All
	base_table=INVCNF
	sql=
		SELECT 
				INVCNF.$COLS:INVCNF$, INVCNFREL.$COLS:INVCNFREL$
		FROM
				INVCNF, INVCNFREL
		WHERE
				INVCNF.INVCNF_ID=INVCNFREL.INVCNF_ID
						
END_XPATH_TO_SQL_STATEMENT
