BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun Page  -->
		<!-- Defining all columns of the table -->
		COLS:PLPAGE=PLPAGE:* 	
		<!-- Defining the unique ID column of the table -->
		COLS:PLPAGE_ID=PLPAGE:PLPAGE_ID
		COLS:ADMINNAME=PLPAGE:ADMINNAME
		COLS:MEMBER_ID=PLPAGE:MEMBER_ID
		COLS:STOREENT_ID=PLPAGE:STOREENT_ID
		COLS:PAGELAYOUTTYPE_ID=PLPAGE:PAGELAYOUTTYPE_ID
		COLS:DELETABLE=PLPAGE:DELETABLE
		COLS:ADMINNAMEEDITABLE=PLPAGE:ADMINNAMEEDITABLE
		COLS:URLCONFIGURABLE=PLPAGE:URLCONFIGURABLE
		
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- XPath: /Page[PageIdentifier[(UniqueID=)]] -->
<!-- Get the information for Page with the specified unique ID. -->
<!-- access profile for this SQL: IBM_Admin_Summary, IBM_Admin_Details -->
<!-- @param UniqueID  Unique ID of Page to retrieve. -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Page[PageIdentifier[(UniqueID=)]]
	base_table=PLPAGE
	sql=	
		SELECT 
			PLPAGE.$COLS:PLPAGE_ID$
		FROM
			PLPAGE
		WHERE
			PLPAGE.PLPAGE_ID IN (?UniqueID?)
		ORDER BY
			PLPAGE.ADMINNAME
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================= 	-->
<!-- XPath: /Page[PageIdentifier[ExternalIdentifier[(Name=) and StoreIdentifier[UniqueID=]]]]  	-->
<!-- Fetches Pages by Names for a given Store ID. 						   						-->
<!-- The access profiles that apply to this SQL are:											-->
<!--	IBM_Admin_Summary																		-->
<!--	IBM_Admin_Details																		-->
<!-- @param Name - The Names of the Pages to fetch.			  		                    		-->
<!-- ========================================================================================= 	-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Page[PageIdentifier[ExternalIdentifier[(Name=) and StoreIdentifier[UniqueID=]]]]
	base_table=PLPAGE
	sql=	
		SELECT 
	     				PLPAGE.$COLS:PLPAGE_ID$
	     	FROM
	     				PLPAGE
	     	WHERE
						PLPAGE.ADMINNAME IN (?Name?)  AND
						PLPAGE.STOREENT_ID = ?UniqueID?
		    ORDER BY 
				        PLPAGE.ADMINNAME
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================= 	-->
<!-- XPath: /Page[PageIdentifier[ExternalIdentifier[(Name=)]]]  	-->
<!-- Fetches Pages by Names. 						   						-->
<!-- The access profiles that apply to this SQL are:											-->
<!--	IBM_Store_Summary																		-->
<!-- @param Name - The Names of the Pages to fetch.			  		                    		-->
<!-- ========================================================================================= 	-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Page[PageIdentifier[ExternalIdentifier[(Name=)]]]
	base_table=PLPAGE
	sql=	
		SELECT 
	     				PLPAGE.$COLS:PLPAGE_ID$
	     	FROM
	     				PLPAGE
	     	WHERE
						PLPAGE.ADMINNAME IN (?Name?)  AND
						PLPAGE.STOREENT_ID in ($STOREPATH:view$,0)
		    ORDER BY 
				        PLPAGE.ADMINNAME
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================= 	-->
<!-- XPath: /Page  	-->
<!-- Fetches all the Pages for the current store path as well as the site.             		    -->
<!-- The access profiles that apply to this SQL are:											-->
<!--	IBM_Admin_Summary																		-->
<!--	IBM_Admin_Details																		-->
<!-- ========================================================================================= 	-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Page
	base_table=PLPAGE
	sql=	
		SELECT 
	     				PLPAGE.$COLS:PLPAGE_ID$
	     	FROM
	     				PLPAGE
	     	WHERE
						PLPAGE.STOREENT_ID IN ($STOREPATH:view$,0) 
		    ORDER BY 
				        PLPAGE.ADMINNAME
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================= 	-->
<!-- XPath: /Page[@pageGroup=]  	-->
<!-- Fetches all the Pages by page group for the current store path as well as the site.             		    -->
<!-- The access profiles that apply to this SQL are:											-->
<!--	IBM_Admin_Summary																		-->
<!--	IBM_Admin_Details																		-->
<!-- ========================================================================================= 	-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Page[@pageGroup=]
	base_table=PLPAGE
	sql=	
		SELECT 
	     				PLPAGE.$COLS:PLPAGE_ID$
	     	FROM
	     				PLPAGE
	     	WHERE
						PLPAGE.PAGELAYOUTTYPE_ID IN(?pageGroup?) AND
						PLPAGE.STOREENT_ID IN ($STOREPATH:view$ , 0) 
		    ORDER BY 
				        PLPAGE.ADMINNAME
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================= 	-->
<!-- XPath: /Page[@urlConfigurable=]  	-->
<!-- Fetches all the URL configurable Pages for the current store path as well as the site.     -->
<!-- The access profiles that apply to this SQL are:											-->
<!--	IBM_Admin_Summary																		-->
<!--	IBM_Admin_Details																		-->
<!-- ========================================================================================= 	-->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Page[@urlConfigurable=]
	base_table=PLPAGE
	sql=	
		SELECT 
	     				PLPAGE.$COLS:PLPAGE_ID$
	     	FROM
	     				PLPAGE
	     	WHERE
						PLPAGE.URLCONFIGURABLE = (CASE WHEN CAST((?urlConfigurable?) as char(5)) = 'true' THEN 1 ELSE 0 END) AND
						PLPAGE.STOREENT_ID IN ($STOREPATH:view$ , 0) 
		    ORDER BY 
				        PLPAGE.ADMINNAME
END_XPATH_TO_SQL_STATEMENT


<!-- =================================================== -->
<!-- XPath: /Page[search()]                              -->
<!-- Fetches Pages for a given search criteria.          -->
<!-- The access profile that applies to this SQL is:	 -->
<!-- IBM_Admin_Summary	   		    				     -->  
<!-- =================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Page[search()]
	base_table=PLPAGE
	sql=	
		SELECT 
				        PLPAGE.$COLS:PLPAGE_ID$
     	FROM
				        PLPAGE, $ATTR_TBLS$
	    WHERE
				       PLPAGE.STOREENT_ID IN ($STOREPATH:view$ , 0)  AND
				       $ATTR_CNDS$
		ORDER BY 
				       PLPAGE.ADMINNAME	
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- Adds summary information of Page to the resultant data graph of Pages.    -->
<!-- ========================================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Page_Admin_Summary
	base_table=PLPAGE
	sql=
		SELECT 
				        PLPAGE.$COLS:PLPAGE_ID$,
				        PLPAGE.$COLS:ADMINNAME$, 
	     				PLPAGE.$COLS:MEMBER_ID$, 
	     				PLPAGE.$COLS:STOREENT_ID$, 
	     				PLPAGE.$COLS:PAGELAYOUTTYPE_ID$, 
	     				PLPAGE.$COLS:DELETABLE$,
	     				PLPAGE.$COLS:ADMINNAMEEDITABLE$,
	     				PLPAGE.$COLS:URLCONFIGURABLE$
		FROM
				PLPAGE
		WHERE
                PLPAGE.PLPAGE_ID IN ($ENTITY_PKS$)
                
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================================= -->
<!-- Adds detail information of Page to the resultant data graph of Pages.    -->
<!-- ========================================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Page_Admin_Details
	base_table=PLPAGE
	sql=
		SELECT 
			PLPAGE.$COLS:PLPAGE$	
		FROM
			PLPAGE
		WHERE
			PLPAGE.PLPAGE_ID IN ($ENTITY_PKS$)
                
END_ASSOCIATION_SQL_STATEMENT

BEGIN_PROFILE_ALIASES
  base_table=PLPAGE
  IBM_Store_Summary=IBM_Admin_Summary
  IBM_Store_Details=IBM_Admin_Summary
END_PROFILE_ALIASES

<!-- ============================================================================= -->
<!-- This access profile returns the following summary information of Pages:	   -->
<!-- @deletable                                                                    -->
<!-- @pageGroup                                                                    -->
<!-- PageIdentifier                                                                -->
<!-- ============================================================================= -->
BEGIN_PROFILE 
    name=IBM_Admin_Summary
    BEGIN_ENTITY 
    	base_table=PLPAGE
    	className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
    	associated_sql_statement=IBM_Page_Admin_Summary 
    END_ENTITY
END_PROFILE

BEGIN_PROFILE 
    name=IBM_Admin_Details
    BEGIN_ENTITY 
    	base_table=PLPAGE
    	className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
    	associated_sql_statement=IBM_Page_Admin_Details 
    END_ENTITY
END_PROFILE
