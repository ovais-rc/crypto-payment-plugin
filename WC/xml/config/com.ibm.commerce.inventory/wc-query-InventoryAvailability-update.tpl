BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun INVENTORYAVAILABILITY  -->
		<!-- getting all columns in the table-->
		<!-- INVAVL table -->
		COLS:INVAVL=INVAVL:*
		<!-- getting uid column in the table-->
		COLS:INVAVL_ID = INVAVL:INVAVL_ID
		
END_SYMBOL_DEFINITIONS

<!-- ============================================================= -->
<!-- This SQL will return the elements of the inventory            -->
<!-- availability for the given catentry/location combination.     -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Update                                                   -->
<!-- @param UniqueID.1 - The catalog entry ID                      -->
<!-- @param UniqueID.2 - The online store ID       	               -->
<!-- @param UniqueID.3 - The physical store ID       	             -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InventoryAvailability[InventoryAvailabilityIdentifier/ExternalIdentifier[CatalogEntryIdentifier[(UniqueID=)] and (OnlineStoreIdentifier[(UniqueID=)] or PhysicalStoreIdentifier[(UniqueID=)])]]+IBM_Update
	base_table=INVAVL
	sql=
		SELECT 
				INVAVL.$COLS:INVAVL$
		FROM
				INVAVL
    WHERE
        INVAVL.CATENTRY_ID in (?UniqueID.1?) AND (INVAVL.STORE_ID in (?UniqueID.2?) OR INVAVL.STLOC_ID in (?UniqueID.3?))

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the inventory            -->
<!-- availability for the given catentry/location combination.     -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Details                                                  -->
<!-- @param UniqueID.1 - The catalog entry ID                      -->
<!-- @param UniqueID.2 - The online store ID       	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InventoryAvailability[InventoryAvailabilityIdentifier/ExternalIdentifier[CatalogEntryIdentifier[(UniqueID=)] and OnlineStoreIdentifier[(UniqueID=)]]]+IBM_Update
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
<!-- IBM_Details                                                  -->
<!-- @param UniqueID.1 - The catalog entry ID                      -->
<!-- @param UniqueID.2 - The physical store ID       	             -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InventoryAvailability[InventoryAvailabilityIdentifier/ExternalIdentifier[CatalogEntryIdentifier[(UniqueID=)] and PhysicalStoreIdentifier[(UniqueID=)]]]+IBM_Update
	base_table=INVAVL
	sql=
		SELECT 
				INVAVL.$COLS:INVAVL$
		FROM
				INVAVL
    WHERE
        INVAVL.CATENTRY_ID in (?UniqueID.1?) AND INVAVL.STLOC_ID in (?UniqueID.2?)

END_XPATH_TO_SQL_STATEMENT
