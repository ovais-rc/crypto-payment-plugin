<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2011                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS
	
	<!-- PAGELAYOUT table -->
	COLS:PAGELAYOUT_ID		= PAGELAYOUT:PAGELAYOUT_ID
	COLS:PAGELAYOUTTYPE_ID	= PAGELAYOUT:PAGELAYOUTTYPE_ID
	COLS:PAGELAYOUT_ALL		= PAGELAYOUT:*
	COLS:PAGELAYOUT_STORE_SUMMARY	= PAGELAYOUT:PAGELAYOUT_ID, NAME, VIEWNAME, MEMBER_ID, STOREENT_ID, MASTERCSS, PAGELAYOUTTYPE_ID, ISTEMPLATE, STATE, OPTCOUNTER
	COLS:PAGELAYOUT_ADMIN_SUMMARY	= PAGELAYOUT:PAGELAYOUT_ID, NAME, VIEWNAME, MEMBER_ID, STOREENT_ID, MASTERCSS, PAGELAYOUTTYPE_ID, ISTEMPLATE, STATE, DESCRIPTION, THUMBNAIL, FULLIMAGE, OPTCOUNTER
	
	<!-- PAGELAYOUTTYPE table -->
	COLS:PAGELAYOUTTYPE_ALL	= PAGELAYOUTTYPE:*
	
END_SYMBOL_DEFINITIONS

<!-- ========================================================================= -->
<!-- ==========================XPATH TO SQL STATEMETS========================= -->
<!-- ========================================================================= -->

<!-- ========================================================================================== -->
<!-- This SQL will return the data of the PageLayout noun for the specified unique identifier.  -->
<!-- Multiple results are returned if multiple identifiers are specified.                       -->
<!-- @param UniqueID The identifier of the page layout to retrieve.								-->  
<!-- @param Context:StoreID - The store for which to retrieve the page layout. This parameter	--> 
<!--						is retrieved from within the business context.                      -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PageLayout[PageLayoutIdentifier[(UniqueID=)]]
	base_table=PAGELAYOUT
	sql=
		SELECT 			
						PAGELAYOUT.$COLS:PAGELAYOUT_ID$
		FROM            
						PAGELAYOUT
		WHERE           
						PAGELAYOUT.PAGELAYOUT_ID in (?UniqueID?) and
						PAGELAYOUT.STOREENT_ID in ($STOREPATH:view$) and
						PAGELAYOUT.STATE <> 2
		ORDER BY 
						PAGELAYOUT.NAME
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================== -->
<!-- This SQL will return the data of the PageLayout noun for the specified page layout type.   -->
<!-- @param LayoutType The layout type of the page layout to retrieve.							-->  
<!-- @param Context:StoreID - The store for which to retrieve the page layout. This parameter	--> 
<!--						is retrieved from within the business context.                      -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PageLayout[LayoutType=]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
	     				PAGELAYOUT.$COLS:PAGELAYOUT_ID$    				
	     	FROM
	     				PAGELAYOUT
	     	WHERE
						PAGELAYOUT.PAGELAYOUTTYPE_ID = ?LayoutType? and
						PAGELAYOUT.STOREENT_ID in ($STOREPATH:view$) and 
						PAGELAYOUT.STATE <> 2
			ORDER BY 
						PAGELAYOUT.NAME
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================================== -->
<!-- This SQL will return the elements of the Page Layout noun(s) given the specified search  	--> 
<!-- criteria.                          														-->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary							-->
<!-- @param LayoutType - The layout type(s) for which to retrieve. 								--> 
<!-- @param Context:StoreID - The store for which to retrieve the page layout. This parameter	--> 
<!--						is retrieved from within the business context.                      -->
<!-- ========================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PageLayout[(LayoutType=) and search()]
	base_table=PAGELAYOUT
	sql=	
		SELECT 
				PAGELAYOUT.$COLS:PAGELAYOUT_ID$    				
     	FROM
				PAGELAYOUT, $ATTR_TBLS$
	    WHERE
				PAGELAYOUT.PAGELAYOUTTYPE_ID = ?LayoutType? and
				PAGELAYOUT.STOREENT_ID in ($STOREPATH:view$) and 
				PAGELAYOUT.STATE <> 2 and
				$ATTR_CNDS$
		ORDER BY 
				PAGELAYOUT.NAME	
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- =============================ASSOCIATION QUERIES========================= -->
<!-- ========================================================================= -->

<!-- =============================================================================== -->
<!-- Get PageLayout query to retrieve the basic information necessary for the Store  -->
<!-- =============================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_PageLayout_Store_Summary
	base_table=PAGELAYOUT
	sql=
		SELECT 
			PAGELAYOUT.$COLS:PAGELAYOUT_STORE_SUMMARY$
		FROM
			PAGELAYOUT
		WHERE
			PAGELAYOUT.PAGELAYOUT_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- =============================================================================== -->
<!-- Get PageLayout query to retrieve the summary information necessary for CMC      -->
<!-- =============================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_PageLayout_Admin_Summary
	base_table=PAGELAYOUT
	sql=
		SELECT 
			PAGELAYOUT.$COLS:PAGELAYOUT_ADMIN_SUMMARY$
		FROM
			PAGELAYOUT
		WHERE
			PAGELAYOUT.PAGELAYOUT_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- =============================================================================== -->
<!-- Get PageLayout type query to retrieve the page layout type information 		 -->
<!-- necessary for the Store  														 -->
<!-- =============================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_PageLayoutType
	base_table=PAGELAYOUT
	sql=
		SELECT 
			PAGELAYOUT.$COLS:PAGELAYOUT_ID$, PAGELAYOUT.$COLS:PAGELAYOUTTYPE_ID$,
			PAGELAYOUTTYPE.$COLS:PAGELAYOUTTYPE_ALL$
		FROM
			PAGELAYOUT, PAGELAYOUTTYPE
		WHERE
			PAGELAYOUT.PAGELAYOUT_ID IN ($ENTITY_PKS$) and
			PAGELAYOUTTYPE.PAGELAYOUTTYPE_ID = PAGELAYOUT.PAGELAYOUTTYPE_ID
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================================= -->
<!-- =============================PROFILE DEFINITIONS========================= -->
<!-- ========================================================================= -->

<!-- ========================================================= -->
<!-- Page Layout admin summary Access Profile. This access     -->
<!-- profile is designed for the Store Page Composer Tool.     -->
<!-- It returns the summary information of a page layout.      -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Page Layout summary			                       -->
<!-- 	2) Page Layout description		                       -->
<!-- ========================================================= -->
BEGIN_PROFILE
  name=IBM_Admin_Summary
  BEGIN_ENTITY
    base_table=PAGELAYOUT
    associated_sql_statement=IBM_PageLayout_Admin_Summary
    associated_sql_statement=IBM_PageLayoutType
  END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Page Layout store summary Access Profile. This access     -->
<!-- profile is used to get the basic information for the      -->
<!-- store.												       -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Page Layout store summary	                       -->
<!-- ========================================================= -->
BEGIN_PROFILE
  name=IBM_Store_Summary
  BEGIN_ENTITY
    base_table=PAGELAYOUT
    associated_sql_statement=IBM_PageLayout_Store_Summary
  END_ENTITY
END_PROFILE
