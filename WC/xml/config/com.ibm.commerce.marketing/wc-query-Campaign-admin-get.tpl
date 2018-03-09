<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2007                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS
	
	<!-- DMCAMPAIGN table -->
	COLS:DMCAMPAIGN=DMCAMPAIGN:*
	COLS:DMCAMPAIGN_ID_NAME=DMCAMPAIGN:DMCAMPAIGN_ID, NAME
	COLS:DMCAMPAIGN_NAME=DMCAMPAIGN:NAME, OPTCOUNTER
		
	<!-- DMACTIVITY table -->
	COLS:DMACTIVITY_CAMPAIGN_ID=DMACTIVITY:DMACTIVITY_ID, DMCAMPAIGN_ID, OPTCOUNTER
			
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- Campaign Access Profiles                                                 -->
<!-- IBM_Admin_Details       All the columns from the DMCAMPAIGN table        -->
<!-- IBM_Admin_CampaignName  The NAME column from the DMCAMPAIGN table        -->
<!-- ======================================================================== -->

BEGIN_PROFILE_ALIASES
  base_table=DMCAMPAIGN
  IBM_Details=IBM_Admin_Details
  IBM_CampaignName=IBM_Admin_CampaignName
END_PROFILE_ALIASES

<!-- Campaign  -->

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Campaign noun                       -->
<!-- for all the campaigns in the current store, and in any stores            -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the campaigns in DMCAMPAIGN in one store -->
	name=/Campaign+IBM_Admin_Details
	base_table=DMCAMPAIGN
	sql=
		SELECT 
				DMCAMPAIGN.$COLS:DMCAMPAIGN$
		FROM
				DMCAMPAIGN
		WHERE
				DMCAMPAIGN.STOREENT_ID in ($STOREPATH:campaigns$)
		ORDER BY DMCAMPAIGN.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows
		FROM
				DMCAMPAIGN
		WHERE
				DMCAMPAIGN.STOREENT_ID in ($STOREPATH:campaigns$)
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Campaign noun                       -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param CampaignIdentifier The identifier of the campaign to retrieve.    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  <!-- fetch the summary of one campaign in DMCAMPAIGN -->
  name=/Campaign[CampaignIdentifier[(UniqueID=)]]+IBM_Admin_Details
  base_table=DMCAMPAIGN
  sql=
    SELECT 
        DMCAMPAIGN.$COLS:DMCAMPAIGN$
    FROM
        DMCAMPAIGN
    WHERE
        DMCAMPAIGN.DMCAMPAIGN_ID in ( ?UniqueID? )

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Campaign noun                       -->
<!-- that match the specified search criteria                                 -->
<!-- for all the campaigns in the current store, and in any stores            -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- search all the campaigns in DMCAMPAIGN in one store -->
	name=/Campaign[search()]
	base_table=DMCAMPAIGN
	sql=
		SELECT 
				DISTINCT DMCAMPAIGN.$COLS:DMCAMPAIGN_ID_NAME$
		FROM
				DMCAMPAIGN, $ATTR_TBLS$
		WHERE
				DMCAMPAIGN.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMCAMPAIGN.$ATTR_CNDS$
		ORDER BY DMCAMPAIGN.NAME
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Campaign noun                       -->
<!-- of the campaign with the specified name.                                 -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The name of the campaign to retrieve.                        -->
<!-- @param Context:StoreID The store for which to retrieve the               -->
<!--       campaigns. This parameter is retrieved from within                 -->
<!--       the business context.                                              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing campaign by name and store in DMCAMPAIGN -->
	name=/Campaign[CampaignIdentifier[ExternalIdentifier[Name=]]]+IBM_Admin_Details
	base_table=DMCAMPAIGN
	sql=
		SELECT 
				DMCAMPAIGN.$COLS:DMCAMPAIGN$
		FROM
				DMCAMPAIGN
		WHERE
				DMCAMPAIGN.STOREENT_ID = $CTX:STORE_ID$ AND
		    DMCAMPAIGN.NAME = ?Name?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the name of the Campaign noun                       -->
<!-- of the campaign with the specified unique identifier.                    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_CampaignName   -->
<!-- @param Name The name of the campaign to retrieve.                        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  <!-- fetch the name of one campaign in DMCAMPAIGN -->
  name=/Campaign[CampaignIdentifier[UniqueID=]]+IBM_Admin_CampaignName
  base_table=DMCAMPAIGN
  sql=
    SELECT 
        DMCAMPAIGN.$COLS:DMCAMPAIGN_NAME$
    FROM
        DMCAMPAIGN
    WHERE
        DMCAMPAIGN.DMCAMPAIGN_ID = ?UniqueID?

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Campaign noun                       -->
<!-- of the campaign associated with the specified activity.                  -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityIdentifier The identifier of the activity for which       -->
<!--                           to retrieve the campaign.                      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing campaign in DMCAMPAIGN from its associated activity -->
	name=/Campaign[ActivityIdentifier[UniqueID=]]+IBM_Admin_Details
	base_table=DMCAMPAIGN
	sql=
		SELECT 
				DMCAMPAIGN.$COLS:DMCAMPAIGN$, DMACTIVITY.$COLS:DMACTIVITY_CAMPAIGN_ID$
		FROM
				DMCAMPAIGN, DMACTIVITY
		WHERE
				DMCAMPAIGN.DMCAMPAIGN_ID = DMACTIVITY.DMCAMPAIGN_ID AND
		    DMACTIVITY.DMACTIVITY_ID = ?UniqueID?
								
END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================== -->
<!-- This associated SQL will return the details of the Campaign noun.        -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- returns the data of the Campaign noun -->
	name=IBM_CampaignDetailsAssoc
	base_table=DMCAMPAIGN
	sql=
		SELECT 
				DMCAMPAIGN.$COLS:DMCAMPAIGN$
		FROM
				DMCAMPAIGN
		WHERE
				DMCAMPAIGN.DMCAMPAIGN_ID in ($ENTITY_PKS$)
		ORDER BY DMCAMPAIGN.NAME
								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- Campaign Admin Details Access Profile                                    -->
<!-- This profile returns the details of the Campaign noun.                   -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Admin_Details
       BEGIN_ENTITY 
         base_table=DMCAMPAIGN
         associated_sql_statement=IBM_CampaignDetailsAssoc
    END_ENTITY
END_PROFILE



