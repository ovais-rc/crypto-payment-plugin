<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2007, 2015                                -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS

	<!-- COLLATERAL table -->
	COLS:COLLATERAL=COLLATERAL:*
	COLS:COLLATERAL_ID_NAME=COLLATERAL:COLLATERAL_ID, NAME
	COLS:COLLATERAL_ID=COLLATERAL:COLLATERAL_ID
		
	<!-- COLLDESC table -->
	COLS:COLLDESC=COLLDESC:*
		
	<!-- ATCHREL table -->
	COLS:ATCHREL=ATCHREL:*
	COLS:ATCHRELDSC=ATCHRELDSC:*
	COLS:ATCHRLUS=ATCHRLUS:*			

	<!-- COLLIMGMAPAREA table -->
	COLS:COLLIMGMAPAREA=COLLIMGMAPAREA:*
						
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- Marketing Content Access Profiles                                        -->
<!-- IBM_Admin_Summary All the columns from the COLLATERAL table              -->
<!-- IBM_Admin_Details All the columns from the COLLATERAL and COLLDESC tables -->
<!-- IBM_Admin_Description All the columns from the COLLDESC table            -->
<!-- ======================================================================== -->

BEGIN_PROFILE_ALIASES
  base_table=COLLATERAL
  IBM_Summary=IBM_Admin_Summary
  IBM_Details=IBM_Admin_Details
END_PROFILE_ALIASES

<!-- Marketing Content -->

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingContent noun               -->
<!-- for all the marketing content in the current store, and in any stores    -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the marketing content in COLLATERAL in one store -->
	name=/MarketingContent+IBM_Admin_Summary
	base_table=COLLATERAL
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL$
		FROM
				COLLATERAL
		WHERE
				COLLATERAL.STOREENT_ID in ($STOREPATH:campaigns$) AND
				(COLLATERAL.UIDISPLAYABLE IS NULL OR COLLATERAL.UIDISPLAYABLE = 1) 
	  ORDER BY COLLATERAL.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				COLLATERAL
		WHERE
				COLLATERAL.STOREENT_ID in ($STOREPATH:campaigns$) AND
				(COLLATERAL.UIDISPLAYABLE IS NULL OR COLLATERAL.UIDISPLAYABLE = 1)         
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingContent noun               -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param MarketingContentIdentifier The identifier of the marketing        -->
<!--                              content to retrieve.                        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Content in COLLATERAL table -->
	name=/MarketingContent[MarketingContentIdentifier[(UniqueID=)]]
	base_table=COLLATERAL
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL_ID$				
		FROM
				COLLATERAL					
		WHERE
				COLLATERAL.COLLATERAL_ID IN ( ?UniqueID? )
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the description data of the MarketingContent noun   -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Description    -->
<!-- @param MarketingContentIdentifier The identifier of the marketing        -->
<!--                              content descriptions to retrieve.           -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Content descriptions in COLLDESC table -->
	name=/MarketingContent[MarketingContentIdentifier[(UniqueID=)]]+IBM_Admin_Description
	base_table=COLLDESC
	sql=
		SELECT 
				COLLDESC.$COLS:COLLDESC$				
		FROM
				COLLDESC					
		WHERE
				COLLDESC.COLLATERAL_ID IN ( ?UniqueID? )
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingContent noun               -->
<!-- that match the specified search criteria                                 -->
<!-- for all the marketing content in the current store, and in any stores    -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- search all the Marketing Content in COLLATERAL in one store -->
	name=/MarketingContent[search()]
	base_table=COLLATERAL
	sql=
		SELECT 
				DISTINCT COLLATERAL.$COLS:COLLATERAL_ID_NAME$
		FROM
				COLLATERAL, $ATTR_TBLS$
		WHERE
				COLLATERAL.STOREENT_ID in ($STOREPATH:campaigns$) AND
				(COLLATERAL.UIDISPLAYABLE IS NULL OR COLLATERAL.UIDISPLAYABLE = 1) AND
				COLLATERAL.$ATTR_CNDS$
	  ORDER BY COLLATERAL.NAME
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingContent noun               -->
<!-- that match the specified search criteria                                 -->
<!-- for all the marketing content in the current store, and in any stores    -->
<!-- in the campaigns store path of the specified marketing content type.     -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param MarketingContentFormat/UniqueID the type of content to return.    -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- search all the Marketing Content in COLLATERAL in one store -->
	name=/MarketingContent[MarketingContentFormat[UniqueID=] and search()]
	base_table=COLLATERAL
	sql=
		SELECT 
				DISTINCT COLLATERAL.$COLS:COLLATERAL_ID_NAME$
		FROM
				COLLATERAL, $ATTR_TBLS$
		WHERE
				COLLATERAL.STOREENT_ID in ($STOREPATH:campaigns$) AND
				COLLATERAL.COLLTYPE_ID = ?UniqueID? AND
				(COLLATERAL.UIDISPLAYABLE IS NULL OR COLLATERAL.UIDISPLAYABLE = 1) AND
				COLLATERAL.$ATTR_CNDS$
	  ORDER BY COLLATERAL.NAME
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingContent noun               -->
<!-- of the marketing content with the specified name.                        -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param Name The name of the marketing content to retrieve.               -->
<!-- @param Context:StoreID The store for which to retrieve the               -->
<!--       marketing content. This parameter is retrieved from within         -->
<!--       the business context.                                              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing marketing content by name and store in COLLATERAL -->
	name=/MarketingContent[MarketingContentIdentifier[ExternalIdentifier[Name=]]]+IBM_Admin_Summary
	base_table=COLLATERAL
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL$			
		FROM
				COLLATERAL
		WHERE
				COLLATERAL.STOREENT_ID = $CTX:STORE_ID$ AND
				COLLATERAL.NAME = ?Name?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the image map data of the MarketingContent noun     -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_ImageMap       -->
<!-- @param MarketingContentIdentifier The identifier of the marketing        -->
<!--                              content to retrieve image map.              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Content image maps in COLLIMGMAPAREA table -->
	name=/MarketingContent[MarketingContentIdentifier[(UniqueID=)]]+IBM_Admin_ImageMap
	base_table=COLLATERAL
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL$, COLLIMGMAPAREA.$COLS:COLLIMGMAPAREA$				
		FROM
				COLLATERAL
				LEFT OUTER JOIN COLLIMGMAPAREA ON COLLIMGMAPAREA.COLLATERAL_ID = COLLATERAL.COLLATERAL_ID 
		WHERE
				COLLATERAL.COLLATERAL_ID IN ( ?UniqueID? )
	  ORDER BY COLLIMGMAPAREA.SEQUENCE ASC
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return the summary of the MarketingContent noun -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Content in COLLATERAL -->
	name=IBM_MarketingContentSummaryAssoc
	base_table=COLLATERAL
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL$
		FROM
				COLLATERAL
		WHERE
				COLLATERAL.COLLATERAL_ID in ($ENTITY_PKS$)
	  ORDER BY COLLATERAL.NAME								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- MarketingContent Admin Summary Access Profile                            -->
<!-- This profile returns the summary of the MarketingContent noun.           -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Admin_Summary
       BEGIN_ENTITY 
         base_table=COLLATERAL
         associated_sql_statement=IBM_MarketingContentSummaryAssoc
    END_ENTITY
END_PROFILE

<!-- ======================================================================== -->
<!-- MarketingContent Store Summary Access Profile                            -->
<!-- This profile returns the summary of the MarketingContent noun.           -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Store_Summary
       BEGIN_ENTITY 
         base_table=COLLATERAL
         associated_sql_statement=IBM_MarketingContentSummaryAssoc
    END_ENTITY
END_PROFILE

<!-- ======================================================================== -->
<!-- This associated SQL will return all the marketing content description    -->
<!-- info of the MarketingContent noun.                                       -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Content with attachment in COLLATERAL -->
	name=IBM_MarketingContentDescription
	base_table=COLLATERAL
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL$,
				COLLDESC.$COLS:COLLDESC$				
		FROM
				COLLATERAL 
					LEFT OUTER JOIN COLLDESC ON (COLLDESC.COLLATERAL_ID = COLLATERAL.COLLATERAL_ID 
						AND COLLDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)) 					
		WHERE
				COLLATERAL.COLLATERAL_ID IN ($ENTITY_PKS$) 				
						
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return all the attachment reference             -->
<!-- description info of the MarketingContent noun.                           -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Content with attachment in COLLATERAL -->
	name=IBM_MarketingContentAttachmentReferenceDescription
	base_table=COLLATERAL
	additional_entity_objects=true	
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL$,
				ATCHREL.$COLS:ATCHREL$,
				ATCHRELDSC.$COLS:ATCHRELDSC$,
				ATCHRLUS.$COLS:ATCHRLUS$
		FROM
				COLLATERAL					
					JOIN ATCHREL ON (ATCHREL.BIGINTOBJECT_ID = COLLATERAL.COLLATERAL_ID)
					LEFT OUTER JOIN ATCHRELDSC ON (ATCHRELDSC.ATCHREL_ID = ATCHREL.ATCHREL_ID AND ATCHRELDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
					JOIN ATCHRLUS ON (ATCHRLUS.ATCHRLUS_ID = ATCHREL.ATCHRLUS_ID)
					JOIN ATCHOBJTYP ON (ATCHREL.ATCHOBJTYP_ID = ATCHOBJTYP.ATCHOBJTYP_ID AND ATCHOBJTYP.IDENTIFIER = 'COLLATERAL')
		WHERE
				COLLATERAL.COLLATERAL_ID IN ($ENTITY_PKS$) AND COLLATERAL.STOREENT_ID in ($STOREPATH:campaigns$)
						
				
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return all the marketing content image map      -->
<!-- info of the MarketingContent noun.                                       -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- return Marketing Content with attachment in COLLATERAL -->
	name=IBM_MarketingContentImageMap
	base_table=COLLATERAL
	sql=
		SELECT 
				COLLATERAL.$COLS:COLLATERAL$, 
				COLLIMGMAPAREA.$COLS:COLLIMGMAPAREA$				
		FROM
				COLLATERAL
					LEFT OUTER JOIN COLLIMGMAPAREA ON (COLLIMGMAPAREA.COLLATERAL_ID = COLLATERAL.COLLATERAL_ID 
						AND COLLIMGMAPAREA.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))					
		WHERE
				COLLATERAL.COLLATERAL_ID IN ($ENTITY_PKS$)
    ORDER BY COLLIMGMAPAREA.SEQUENCE ASC				
						
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- MarketingContent details including marketing content description,        -->
<!-- attachment reference description and image map.                          -->
<!-- This profile returns the following information:                          -->
<!--  1) Marketing content description                                        -->
<!--  2) Attachment reference description                                     -->
<!--  3) Marketing content image map                                          -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Admin_Details
       BEGIN_ENTITY 
         base_table=COLLATERAL
         className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
         associated_sql_statement=IBM_MarketingContentDescription
         associated_sql_statement=IBM_MarketingContentAttachmentReferenceDescription
         associated_sql_statement=IBM_MarketingContentImageMap
    END_ENTITY
END_PROFILE

<!-- ======================================================================== -->
<!-- MarketingContent details including marketing content description and     -->
<!-- attachment reference description and image map.                          -->
<!-- This profile returns the following information:                          -->
<!--  1) Marketing content description                                        -->
<!--  2) Attachment reference description                                     -->
<!--  3) Marketing content image map                                          -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Store_Details
       BEGIN_ENTITY 
         base_table=COLLATERAL
         className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
         associated_sql_statement=IBM_MarketingContentDescription
         associated_sql_statement=IBM_MarketingContentAttachmentReferenceDescription
         associated_sql_statement=IBM_MarketingContentImageMap
    END_ENTITY
END_PROFILE

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingContent noun               -->
<!-- for the attachment unique identifier.                                    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param AttachmentIdentifier The identifier of the attachment target.     -->
<!-- @param Control:LANGUAGES The language for which to retrieve the          -->
<!--    marketing content. This parameter is retrieved from within            -->
<!--    the business context.                                                 -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch Marketing Content in COLLATERAL by attachment target ID -->
	name=/MarketingContent[Attachment[AttachmentIdentifier[(UniqueID=)]]]
	base_table=COLLATERAL	
	sql=
		SELECT 
				DISTINCT(COLLATERAL.$COLS:COLLATERAL_ID$)
		FROM
				COLLATERAL 
				JOIN ATCHREL ON (ATCHREL.BIGINTOBJECT_ID = COLLATERAL.COLLATERAL_ID)
				JOIN ATCHOBJTYP ON (ATCHREL.ATCHOBJTYP_ID = ATCHOBJTYP.ATCHOBJTYP_ID	
						 AND ATCHOBJTYP.IDENTIFIER = 'COLLATERAL')
		WHERE ATCHREL.ATCHTGT_ID IN (?UniqueID?) AND COLLATERAL.STOREENT_ID in ($STOREPATH:campaigns$) AND
				(COLLATERAL.UIDISPLAYABLE IS NULL OR COLLATERAL.UIDISPLAYABLE = 1)
				     
	
END_XPATH_TO_SQL_STATEMENT
