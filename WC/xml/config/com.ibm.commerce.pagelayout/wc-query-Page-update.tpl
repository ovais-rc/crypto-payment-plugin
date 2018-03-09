BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun Page  -->
	<!-- Defining all columns of the table -->
	COLS:PLPAGE = PLPAGE:* 	
	<!-- Defining the unique ID column of the table -->
	COLS:PLPAGE_ID = PLPAGE:PLPAGE_ID
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- XPath: /Page/PageIdentifier[(UniqueID=)]-->
<!-- Get the information for Page with specified unique ID for an update operation -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique id of Page to retrieve -->   
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Page[PageIdentifier[(UniqueID=)]]+IBM_Admin_PageUpdate
	base_table=PLPAGE
	sql=	
		SELECT PLPAGE.$COLS:PLPAGE$
	    FROM PLPAGE 
	    WHERE PLPAGE.PLPAGE_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================================= 	-->
<!-- XPath: /Page[PageIdentifier[ExternalIdentifier[(Name=) and StoreIdentifier[UniqueID=]]]] -->
<!-- Get Pages by Names and Store Id. 						   						            -->
<!-- @param Name - The Names of the Pages to fetch.			  		                    		-->
<!-- @param UniqueID - The ID of Store that the Pages belongs to.                        		-->
<!-- ========================================================================================= 	-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Page[PageIdentifier[ExternalIdentifier[(Name=) and StoreIdentifier[UniqueID=]]]]+IBM_Admin_PageUpdate
	base_table=PLPAGE
	sql=	
		SELECT 
	     				PLPAGE.$COLS:PLPAGE$
	     	FROM
	     				PLPAGE
	     	WHERE
						PLPAGE.ADMINNAME IN (?Name?)  AND
						PLPAGE.STOREENT_ID = (?UniqueID?)
		    ORDER BY 
				        PLPAGE.ADMINNAME
END_XPATH_TO_SQL_STATEMENT


