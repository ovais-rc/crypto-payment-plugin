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

	<!-- DMACTTYPE table -->
	COLS:DMACTTYPE=DMACTTYPE:*
	
	<!-- DMACTIVITY table -->
	COLS:DMACTIVITY=DMACTIVITY:*
	COLS:DMACTIVITY_ID=DMACTIVITY:DMACTIVITY_ID, OPTCOUNTER
	COLS:DMACTIVITY_ID_NAME=DMACTIVITY:DMACTIVITY_ID, NAME, OPTCOUNTER
    COLS:DMACTIVITY_ID_STATE=DMACTIVITY:DMACTIVITY_ID, STATE, OPTCOUNTER	
	COLS:DMACTIVITY_NAME=DMACTIVITY:DMACTIVITY_ID, NAME, DMCAMPAIGN_ID, OPTCOUNTER
	
	<!-- DMELEMENT table -->
	COLS:DMELEMENT=DMELEMENT:*
	COLS:DMELEMENT_JOIN=DMELEMENT:DMELEMENT_ID, DMACTIVITY_ID, OPTCOUNTER
	
	<!-- DMELEMENTNVP table -->
	COLS:DMELEMENTNVP=DMELEMENTNVP:*			
	COLS:DMELEMENTNVP_JOIN=DMELEMENTNVP:DMELEMENT_ID, OPTCOUNTER							
		 	
	<!-- DMELEMENTTYPE table -->
	COLS:DMELEMENTTYPE=DMELEMENTTYPE:*
			
	<!-- DMELETEMPLATE table -->
	COLS:DMELETEMPLATE=DMELETEMPLATE:*
			
	<!-- DMTEMPLATETYPE table -->
	COLS:DMTEMPLATETYPE=DMTEMPLATETYPE:*
				
	<!-- DMEXPFAMILY table -->
	COLS:DMEXPFAMILY=DMEXPFAMILY:*
					
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- Activity Access Profiles                                                 -->
<!-- IBM_Admin_Details          All the columns from the DMACTIVITY table     -->
<!-- IBM_Admin_TemplateDetails  All the columns from the DMACTIVITY and       -->
<!--                            DMTEMPLATETYPE tables                         -->
<!-- IBM_Admin_ActivityName     The NAME column from the DMACTIVITY table     -->
<!-- IBM_Admin_CampaignElements All the columns from the DMELEMENT table      -->
<!-- ======================================================================== -->

BEGIN_PROFILE_ALIASES
  base_table=DMACTIVITY
  IBM_Details=IBM_Admin_Details
  IBM_TemplateDetails=IBM_Admin_TemplateDetails
  IBM_ActivityName=IBM_Admin_ActivityName
  IBM_CampaignElements=IBM_Admin_CampaignElements
END_PROFILE_ALIASES

<!-- Activity -->

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityIdentifier The identifier of the activity to retrieve.    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all information of one marketing activity in DMACTIVITY -->
	name=/Activity[ActivityIdentifier[(UniqueID=)]]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMACTTYPE.$COLS:DMACTTYPE$, DMEXPFAMILY.$COLS:DMEXPFAMILY$
		FROM
				DMACTIVITY
				JOIN DMACTTYPE ON (DMACTIVITY.DMACTTYPE_ID = DMACTTYPE.DMACTTYPE_ID)
				LEFT OUTER JOIN DMEXPFAMILY ON (DMACTIVITY.DMACTIVITY_ID = DMEXPFAMILY.DMACTIVITY_ID)
		WHERE
				DMACTIVITY.DMACTIVITY_ID in ( ?UniqueID? )				
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for the specified unique identifier and state. Multiple results are      -->
<!-- returned if multiple identifiers are specified.                          -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityIdentifier The identifier of the activity to retrieve.    -->
<!-- @param State The state of the activity to retrieve.
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all information of one marketing activity in DMACTIVITY -->
	name=/Activity[ActivityIdentifier[(UniqueID=)] and (State=)]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMACTTYPE.$COLS:DMACTTYPE$, DMEXPFAMILY.$COLS:DMEXPFAMILY$
		FROM
				DMACTIVITY
				JOIN DMACTTYPE ON (DMACTIVITY.DMACTTYPE_ID = DMACTTYPE.DMACTTYPE_ID)
				LEFT OUTER JOIN DMEXPFAMILY ON (DMACTIVITY.DMACTIVITY_ID = DMEXPFAMILY.DMACTIVITY_ID)
		WHERE
				DMACTIVITY.DMACTIVITY_ID in ( ?UniqueID? ) AND 
				DMACTIVITY.STATE IN (?State?)		
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for the specified activity type and whose start date has past.           -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityType The type of the activity to retrieve.                -->
<!-- @param StartDate This parameter specfies to find start dates that have   -->
<!--                  passed. The exact date specified is currently not used. -->
<!--                  The database current timestamp is used.                 -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch which activities are ready to start DMACTIVITY - called by ProcessSendTriggersMarketingTriggerCmdImpl -->
	name=/Activity[ActivityType= and StartDate=]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND 
				DMACTIVITY.STARTDATE <= CURRENT_TIMESTAMP AND 
				DMACTIVITY.STATE = 1 AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for the specified activity type and whose end date has past.             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param EndDate This parameter specfies to find end dates that have       -->
<!--                passed. The exact date specified is currently not used.   -->
<!--                The database current timestamp is used.                   -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch which activities are expired - called by ProcessSendTriggersMarketingTriggerCmdImpl -->
	name=/Activity[EndDate=]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STATE = 1 AND
				DMACTIVITY.ENDDATE IS NOT NULL AND
				DMACTIVITY.ENDDATE <= CURRENT_TIMESTAMP AND 
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for all the activities in the current store, and in any stores           -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the activities in DMACTIVITY in one store -->
	name=/Activity
	base_table=DMACTIVITY
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
				LEFT OUTER JOIN DMEXPFAMILY ON (DMACTIVITY.DMACTIVITY_ID = DMEXPFAMILY.DMACTIVITY_ID)
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMACTIVITY.DMACTTYPE_ID IN (0, 1, 2) AND
				DMACTIVITY.STATE IN (0, 1) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1)
	  ORDER BY DMACTIVITY.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMACTIVITY.DMACTTYPE_ID IN (0, 1, 2) AND
				DMACTIVITY.STATE IN (0, 1) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1)
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- of the activity with the specified name.                                 -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The name of the activity to retrieve.                        -->
<!-- @param Context:StoreID The store for which to retrieve the               -->
<!--       activity. This parameter is retrieved from within                  -->
<!--       the business context.                                              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing activity by name and store in DMACTIVITY -->
	name=/Activity[ActivityIdentifier[ExternalIdentifier[Name=]]]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STOREENT_ID = $CTX:STORE_ID$ AND
				DMACTIVITY.NAME = ?Name?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for all the activities of the specified type in the current store        -->
<!-- and in any stores in the campaigns store path.                           -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityType The format of the activities to retrieve.            -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the activities in DMACTIVITY in one store by type -->
	name=/Activity[ActivityType=]
	base_table=DMACTIVITY
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
				LEFT OUTER JOIN DMEXPFAMILY ON (DMACTIVITY.DMACTIVITY_ID = DMEXPFAMILY.DMACTIVITY_ID)
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMACTIVITY.STATE IN (0, 1) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1)
	  ORDER BY DMACTIVITY.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMACTIVITY.STATE IN (0, 1) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1)
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for all the activities in the specified campaign.                        -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param CampaignIdentifier The identifier of the campaign for which       -->
<!--                           to retrieve the activities.                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the activities in DMACTIVITY in one campaign -->
	name=/Activity[CampaignIdentifier[UniqueID=]]
	base_table=DMACTIVITY
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
				LEFT OUTER JOIN DMEXPFAMILY ON (DMACTIVITY.DMACTIVITY_ID = DMEXPFAMILY.DMACTIVITY_ID)
		WHERE
				DMACTIVITY.DMCAMPAIGN_ID = ?UniqueID? AND
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMACTIVITY.DMACTTYPE_ID IN (0, 1, 2) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
	  ORDER BY DMACTIVITY.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.DMCAMPAIGN_ID = ?UniqueID? AND
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMACTIVITY.DMACTTYPE_ID IN (0, 1, 2) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for all the activities of the specified type in the specified campaign.  -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityType The format of the activities to retrieve.            -->
<!-- @param CampaignIdentifier The identifier of the campaign for which       -->
<!--                           to retrieve the activities.                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the activities in DMACTIVITY in one campaign by type -->
	name=/Activity[ActivityType= and CampaignIdentifier[UniqueID=]]
	base_table=DMACTIVITY
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
				LEFT OUTER JOIN DMEXPFAMILY ON (DMACTIVITY.DMACTIVITY_ID = DMEXPFAMILY.DMACTIVITY_ID)
		WHERE
				DMACTIVITY.DMCAMPAIGN_ID = ?UniqueID? AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
	  ORDER BY DMACTIVITY.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.DMCAMPAIGN_ID = ?UniqueID? AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1) 
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for all the activity templates in the current store, and in any stores   -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_TemplateDetails -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the activity templates in DMACTIVITY in one store -->
	name=/Activity+IBM_Admin_TemplateDetails
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMTEMPLATETYPE.$COLS:DMTEMPLATETYPE$
		FROM
				DMACTIVITY, DMTEMPLATETYPE
		WHERE
				(DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) OR DMACTIVITY.STOREENT_ID = 0) AND
				DMACTIVITY.DMTEMPLATETYPE_ID = DMTEMPLATETYPE.DMTEMPLATETYPE_ID AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1)
	  ORDER BY DMACTIVITY.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				DMACTIVITY, DMTEMPLATETYPE
		WHERE
				(DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) OR DMACTIVITY.STOREENT_ID = 0) AND
				DMACTIVITY.DMTEMPLATETYPE_ID = DMTEMPLATETYPE.DMTEMPLATETYPE_ID AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1)
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for all the activity templates of the specified type in the current      -->
<!-- store, and in any stores in the campaigns store path.                    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_TemplateDetails -->
<!-- @param ActivityType The format of the activity templates to retrieve.    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the activity templates in DMACTIVITY in one store by type -->
	name=/Activity[ActivityType=]+IBM_Admin_TemplateDetails
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMTEMPLATETYPE.$COLS:DMTEMPLATETYPE$
		FROM
				DMACTIVITY, DMTEMPLATETYPE
		WHERE
				(DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) OR DMACTIVITY.STOREENT_ID = 0) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMTEMPLATETYPE_ID = DMTEMPLATETYPE.DMTEMPLATETYPE_ID AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1)
	  ORDER BY DMACTIVITY.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				DMACTIVITY, DMTEMPLATETYPE
		WHERE
				(DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) OR DMACTIVITY.STOREENT_ID = 0) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMTEMPLATETYPE_ID = DMTEMPLATETYPE.DMTEMPLATETYPE_ID AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1)
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that match the specified search criteria                                 -->
<!-- for all the activities in the current store, and in any stores           -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- search all the activities in DMACTIVITY in one store -->
	name=/Activity[search()]
	base_table=DMACTIVITY
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY, $ATTR_TBLS$
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMACTIVITY.DMACTTYPE_ID IN (0, 1, 2) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND
				DMACTIVITY.$ATTR_CNDS$
	  ORDER BY DMACTIVITY.NAME
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that match the specified search criteria                                 -->
<!-- for all the activities in the current store, and in any stores           -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityType The format of the activities to retrieve.            -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- search all the activities in DMACTIVITY in one store -->
	name=/Activity[ActivityType= and search()]
	base_table=DMACTIVITY
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY, $ATTR_TBLS$
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND				
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND
				DMACTIVITY.STATE IN (0, 1) AND
				DMACTIVITY.$ATTR_CNDS$
	  ORDER BY DMACTIVITY.NAME
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that match the specified search criteria                                 -->
<!-- for all the activity templates in the current store,                     -->
<!-- and in any stores in the campaigns store path.                           -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_TemplateDetails -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- search all the activity templates in DMACTIVITY in one store -->
	name=/Activity[TemplateFormat and search()]
	base_table=DMACTIVITY
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$

		FROM
				DMACTIVITY, DMTEMPLATETYPE, $ATTR_TBLS$
		WHERE
				(DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) OR DMACTIVITY.STOREENT_ID = 0) AND
				DMACTIVITY.DMTEMPLATETYPE_ID = DMTEMPLATETYPE.DMTEMPLATETYPE_ID AND
				DMACTIVITY.DMACTTYPE_ID IN (0, 1, 2) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND
				DMACTIVITY.$ATTR_CNDS$
	  ORDER BY DMACTIVITY.NAME
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that match the specified search criteria                                 -->
<!-- for all the activity templates in the current store,                     -->
<!-- and in any stores in the campaigns store path.                           -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_TemplateDetails -->
<!-- @param ActivityType The format of the activities to retrieve.            -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- search all the activity templates in DMACTIVITY in one store -->
	name=/Activity[ActivityType= and TemplateFormat and search()]
	base_table=DMACTIVITY
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY, DMTEMPLATETYPE, $ATTR_TBLS$
		WHERE
				(DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) OR DMACTIVITY.STOREENT_ID = 0) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMTEMPLATETYPE_ID = DMTEMPLATETYPE.DMTEMPLATETYPE_ID AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND
				DMACTIVITY.$ATTR_CNDS$
	  ORDER BY DMACTIVITY.NAME
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that has a name value pair that matches the specified name and value.    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The business object name.                                    -->
<!-- @param Value The business object value.                                  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the activities associated with a name value pair -->
	name=/Activity[CampaignElement[Name= and Value=]]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMELEMENT.$COLS:DMELEMENT$, DMELEMENTNVP.$COLS:DMELEMENTNVP$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    ORDER BY DMACTIVITY.NAME				
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows    
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the UI not displayable Activity noun    -->
<!-- that has a name value pair that matches the specified name and value.    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The business object name.                                    -->
<!-- @param Value The business object value.                                  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the UI not displayable activities associated with a name value pair -->
	name=/Activity[CampaignElement[Name= and Value=] and UIDisplayable=0]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMELEMENT.$COLS:DMELEMENT$, DMELEMENTNVP.$COLS:DMELEMENTNVP$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				DMACTIVITY.UIDISPLAYABLE = 0 AND 
				DMACTIVITY.STATE IN (0, 1)
    ORDER BY DMACTIVITY.NAME				
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows    
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				DMACTIVITY.UIDISPLAYABLE = 0 AND 
				DMACTIVITY.STATE IN (0, 1)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that has a name value pair that matches the specified name and value.    -->
<!-- The value parameter is compared with a case insensitive search.          -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityType The format of the activities to retrieve.            -->
<!-- @param Name The business object name.                                    -->
<!-- @param CampaignElement/CampaignElementVariable/Value The business object value.  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the activities associated with a name value pair -->
	name=/Activity[ActivityType= and CampaignElement[CampaignElementVariable[Name=]] and search(ActivityIdentifier/ExternalIdentifier/Name= or CampaignElement/CampaignElementVariable/Value= or Description=)]
	base_table=DMACTIVITY
	dbtype=any
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
		    DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				UPPER(DMELEMENTNVP.VALUE) = UPPER(?CampaignElement/CampaignElementVariable/Value?) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    UNION
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND				
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(UPPER(DMACTIVITY.NAME) = UPPER(?ActivityIdentifier/ExternalIdentifier/Name?) OR
				 UPPER(DMACTIVITY.DESCRIPTION) = UPPER(?Description?) ) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    ORDER BY NAME	
 	dbtype=db2		
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
		    DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				(UPPER(DMELEMENTNVP.VALUE) = UPPER(CAST(?CampaignElement/CampaignElementVariable/Value? AS VARCHAR(254))) ) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    UNION
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
        DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND				
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(UPPER(DMACTIVITY.NAME) = UPPER(CAST(?ActivityIdentifier/ExternalIdentifier/Name? AS VARCHAR(64))) OR
				 UPPER(DMACTIVITY.DESCRIPTION) = UPPER(CAST(?Description? AS VARCHAR(254))) ) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)		
    ORDER BY NAME 		

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that has a name value pair that matches the specified name and value.    -->
<!-- The value parameter is compared with a case insensitive search and       -->
<!-- must be contained within the matching value.                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityType The format of the activities to retrieve.            -->
<!-- @param Name The business object name.                                    -->
<!-- @param CampaignElement/CampaignElementVariable/Value The business object value.  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the activities associated with a name value pair -->
	name=/Activity[ActivityType= and CampaignElement[CampaignElementVariable[Name=]] and search(contains(ActivityIdentifier/ExternalIdentifier/Name,) or contains(CampaignElement/CampaignElementVariable/Value,) or contains(Description,))]
	base_table=DMACTIVITY
	dbtype=any
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
		    DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				(UPPER(DMELEMENTNVP.VALUE) LIKE UPPER(?CampaignElement/CampaignElementVariable/Value?) ESCAPE '+') AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    UNION
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND				
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(UPPER(DMACTIVITY.NAME) LIKE UPPER(?ActivityIdentifier/ExternalIdentifier/Name?) ESCAPE '+' OR
				 UPPER(DMACTIVITY.DESCRIPTION) LIKE UPPER(?Description?) ESCAPE '+' ) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)		
    ORDER BY NAME	
 	dbtype=db2		
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
		    DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				(UPPER(DMELEMENTNVP.VALUE) LIKE UPPER(CAST(?CampaignElement/CampaignElementVariable/Value? AS VARCHAR(254))) ESCAPE '+') AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    UNION
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
        DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND				
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(UPPER(DMACTIVITY.NAME) LIKE UPPER(CAST(?ActivityIdentifier/ExternalIdentifier/Name? AS VARCHAR(64))) ESCAPE '+' OR
				 UPPER(DMACTIVITY.DESCRIPTION) LIKE UPPER(CAST(?Description? AS VARCHAR(254))) ESCAPE '+' ) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)							
    ORDER BY NAME 		

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that has a name value pair that matches the specified name and value.    -->
<!-- The value parameter is compared with a case insensitive search and       -->
<!-- must be at the start of the matching value.                              -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityType The format of the activities to retrieve.            -->
<!-- @param Name The business object name.                                    -->
<!-- @param CampaignElement/CampaignElementVariable/Value The business object value.  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the activities associated with a name value pair -->
	name=/Activity[ActivityType= and CampaignElement[CampaignElementVariable[Name=]] and search(starts-with(ActivityIdentifier/ExternalIdentifier/Name,) or starts-with(CampaignElement/CampaignElementVariable/Value,) or starts-with(Description,))]
	base_table=DMACTIVITY
	dbtype=any
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
		    DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				(UPPER(DMELEMENTNVP.VALUE) LIKE UPPER(?CampaignElement/CampaignElementVariable/Value?) ESCAPE '+') AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    UNION
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
        DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND				
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(UPPER(DMACTIVITY.NAME) LIKE UPPER(?ActivityIdentifier/ExternalIdentifier/Name?) ESCAPE '+' OR
				 UPPER(DMACTIVITY.DESCRIPTION) LIKE UPPER(?Description?) ESCAPE '+' ) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)						
    ORDER BY NAME	
 	dbtype=db2		
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
		    DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				(UPPER(DMELEMENTNVP.VALUE) LIKE UPPER(CAST(?CampaignElement/CampaignElementVariable/Value? AS VARCHAR(254))) ESCAPE '+') AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    UNION
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND				
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(UPPER(DMACTIVITY.NAME) LIKE UPPER(CAST(?ActivityIdentifier/ExternalIdentifier/Name? AS VARCHAR(64))) ESCAPE '+' OR
				 UPPER(DMACTIVITY.DESCRIPTION) LIKE UPPER(CAST(?Description? AS VARCHAR(254))) ESCAPE '+' ) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1)	AND 
				DMACTIVITY.STATE IN (0, 1)								
    ORDER BY NAME 		

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that has a name value pair that matches the specified name and value.    -->
<!-- The value parameter is compared with a case insensitive search and       -->
<!-- must be at the end of the matching value.                                -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityType The format of the activities to retrieve.            -->
<!-- @param Name The business object name.                                    -->
<!-- @param CampaignElement/CampaignElementVariable/Value The business object value.  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the activities associated with a name value pair -->
	name=/Activity[ActivityType= and CampaignElement[CampaignElementVariable[Name=]] and search(ends-with(ActivityIdentifier/ExternalIdentifier/Name,) or ends-with(CampaignElement/CampaignElementVariable/Value,) or ends-with(Description,))]
	base_table=DMACTIVITY
	dbtype=any
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				(UPPER(DMELEMENTNVP.VALUE) LIKE UPPER(?CampaignElement/CampaignElementVariable/Value?) ESCAPE '+') AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    UNION
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
        DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND				
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(UPPER(DMACTIVITY.NAME) LIKE UPPER(?ActivityIdentifier/ExternalIdentifier/Name?) ESCAPE '+' OR
				 UPPER(DMACTIVITY.DESCRIPTION) LIKE UPPER(?Description?) ESCAPE '+' ) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1)	 AND 
				DMACTIVITY.STATE IN (0, 1)
    ORDER BY NAME	
 	dbtype=db2		
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				(UPPER(DMELEMENTNVP.VALUE) LIKE UPPER(CAST(?CampaignElement/CampaignElementVariable/Value? AS VARCHAR(254))) ESCAPE '+') AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    UNION
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND				
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(UPPER(DMACTIVITY.NAME) LIKE UPPER(CAST(?ActivityIdentifier/ExternalIdentifier/Name? AS VARCHAR(64))) ESCAPE '+' OR
				 UPPER(DMACTIVITY.DESCRIPTION) LIKE UPPER(CAST(?Description? AS VARCHAR(254))) ESCAPE '+' ) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)				
    ORDER BY NAME 		

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that has a name value pair that matches the specified name and value.    -->
<!-- The current store and the specified stores will be checked.              -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The business object name.                                    -->
<!-- @param Value The business object value.                                  -->
<!-- @param StoreIdentifier The additional stores to check.                   -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the activities associated with a name value pair -->
	name=/Activity[ActivityIdentifier[ExternalIdentifier[StoreIdentifier[(UniqueID=)]]] and CampaignElement[Name= and Value=]]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMELEMENT.$COLS:DMELEMENT$, DMELEMENTNVP.$COLS:DMELEMENTNVP$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    ( DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) OR DMACTIVITY.STOREENT_ID in (?UniqueID?) ) AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    ORDER BY DMACTIVITY.NAME				
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows    
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    ( DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) OR DMACTIVITY.STOREENT_ID in (?UniqueID?) ) AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND
				DMACTIVITY.STATE IN (0, 1)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the UI not displayble Activity noun     -->
<!-- that has a name value pair that matches the specified name and value.    -->
<!-- The current store and the specified stores will be checked.              -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The business object name.                                    -->
<!-- @param Value The business object value.                                  -->
<!-- @param StoreIdentifier The additional stores to check.                   -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the UI not displayble activities associated with a name value pair -->
	name=/Activity[ActivityIdentifier[ExternalIdentifier[StoreIdentifier[(UniqueID=)]]] and CampaignElement[Name= and Value=] and UIDisplayable=0]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMELEMENT.$COLS:DMELEMENT$, DMELEMENTNVP.$COLS:DMELEMENTNVP$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    ( DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) OR DMACTIVITY.STOREENT_ID in (?UniqueID?) ) AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				DMACTIVITY.UIDISPLAYABLE = 0 AND 
				DMACTIVITY.STATE IN (0, 1)
    ORDER BY DMACTIVITY.NAME				
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows    
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    ( DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) OR DMACTIVITY.STOREENT_ID in (?UniqueID?) ) AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				DMACTIVITY.UIDISPLAYABLE = 0 AND
				DMACTIVITY.STATE IN (0, 1)

END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================== -->
<!-- This SQL will return the name of the Activity noun                       -->
<!-- that has a name value pair that matches the specified name and value.    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_ActivityName   -->
<!-- Note that this query returns activites from all stores.                  -->
<!-- If you only want activites from the current store, then use the          -->
<!-- IBM_Admin_Details access profile.                                        -->
<!-- @param Name The business object name.                                    -->
<!-- @param Value The business object value.                                  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the activities associated with a name value pair -->
	name=/Activity[CampaignElement[Name= and Value=]]+IBM_Admin_ActivityName
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY_NAME$, DMELEMENT.$COLS:DMELEMENT_JOIN$, DMELEMENTNVP.$COLS:DMELEMENTNVP_JOIN$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    ORDER BY DMACTIVITY.NAME				
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows    
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that has a name value pair that matches the specified name.              -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The business object name.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the activities associated with a name value pair -->
	name=/Activity[CampaignElement[CampaignElementVariable[Name=]]]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMELEMENT.$COLS:DMELEMENT$, DMELEMENTNVP.$COLS:DMELEMENTNVP$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the UI not displayable Activity noun    -->
<!-- that has a name value pair that matches the specified name.              -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The business object name.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the UI not displayable activities associated with a name value pair -->
	name=/Activity[CampaignElement[CampaignElementVariable[Name=]] and UIDisplayable=0]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMELEMENT.$COLS:DMELEMENT$, DMELEMENTNVP.$COLS:DMELEMENTNVP$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMACTIVITY.UIDISPLAYABLE = 0 AND 
				DMACTIVITY.STATE IN (0, 1)

END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity nouns                      -->
<!-- for the specified family identifier.                                     -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param FamilyIdentifier The identifier of the activity family            -->
<!--                         to retrieve.                                     -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all information of one marketing activity in DMACTIVITY -->
	name=/Activity[FamilyIdentifier[UniqueID=]]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMACTTYPE.$COLS:DMACTTYPE$, DMEXPFAMILY.$COLS:DMEXPFAMILY$
		FROM
				DMACTIVITY, DMACTTYPE, DMEXPFAMILY
		WHERE
				DMEXPFAMILY.FAMILY_ID = ?UniqueID? AND
				DMACTIVITY.DMACTTYPE_ID = DMACTTYPE.DMACTTYPE_ID AND
				DMACTIVITY.DMACTIVITY_ID = DMEXPFAMILY.DMACTIVITY_ID AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
		ORDER BY SEQUENCE DESC
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for all the activities of the specified type and state.                  -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityType The format of the activities to retrieve.            -->
<!-- @param State The state of the activities to retrieve.                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the activities in DMACTIVITY in one store by type and state -->
	name=/Activity[ActivityType= and State=]
	base_table=DMACTIVITY
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
				LEFT OUTER JOIN DMEXPFAMILY ON (DMACTIVITY.DMACTIVITY_ID = DMEXPFAMILY.DMACTIVITY_ID)
		WHERE
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.STATE = ?State? AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) 
	  ORDER BY DMACTIVITY.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.STATE = ?State? AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1)
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- for all the activities of the specified type, state and experiment type. -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ActivityType The format of the activities to retrieve.            -->
<!-- @param State The state of the activities to retrieve.                    -->
<!-- @param ExperimentFormat The experiment type of the activities.           -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the activities in DMACTIVITY in one store by type, state and experiment type -->
	name=/Activity[ActivityType= and State= and ExperimentFormat=]
	base_table=DMACTIVITY
	sql=
		SELECT 
				DISTINCT DMACTIVITY.$COLS:DMACTIVITY_ID_NAME$
		FROM
				DMACTIVITY
				LEFT OUTER JOIN DMEXPFAMILY ON (DMACTIVITY.DMACTIVITY_ID = DMEXPFAMILY.DMACTIVITY_ID)
		WHERE
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.STATE = ?State? AND
				DMACTIVITY.DMEXPTYPE_ID = ?ExperimentFormat? AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) 
	  ORDER BY DMACTIVITY.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				DMACTIVITY
		WHERE
				DMACTIVITY.DMACTTYPE_ID = ?ActivityType? AND
				DMACTIVITY.STATE = ?State? AND
				DMACTIVITY.DMEXPTYPE_ID = ?ExperimentFormat? AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) 
END_XPATH_TO_SQL_STATEMENT

<!-- Campaign Element -->

<!-- ======================================================================== -->
<!-- This SQL will return the campaign elements of the Activity noun          -->
<!-- for the specified campaign element unique identifier.                    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_CampaignElements -->
<!-- @param CampaignElementIdentifier The identifier of the campaign element  -->
<!--                                  to retrieve.                            -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all information of one campaign element in DMELEMENT -->
	name=/Activity[CampaignElement[CampaignElementIdentifier[(UniqueID=)]]]+IBM_Admin_CampaignElements
	base_table=DMACTIVITY
	sql=
		SELECT 
		    DMACTIVITY.$COLS:DMACTIVITY_ID$,
				DMELEMENT.$COLS:DMELEMENT$,
				DMELETEMPLATE.$COLS:DMELETEMPLATE$,
				DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMACTIVITY, DMELEMENT, DMELETEMPLATE, DMELEMENTTYPE
		WHERE
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND 
				DMELEMENT.DMELEMENT_ID in ( ?UniqueID? ) AND 
				DMELETEMPLATE.DMELETEMPLATE_ID = DMELEMENT.DMELETEMPLATE_ID 
				AND DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID 
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the campaign elements of the Activity noun          -->
<!-- for all campaign elements in the specified activity.                     -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_CampaignElements -->
<!-- @param ActivityIdentifier The identifier of the activity to retrieve.    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the campaign elements in one marketing activity from DMELEMENT -->
	name=/Activity[ActivityIdentifier[UniqueID=]]+IBM_Admin_CampaignElements
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY_ID_STATE$,
				DMELEMENT.$COLS:DMELEMENT$,
				DMELETEMPLATE.$COLS:DMELETEMPLATE$,
				DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMACTIVITY, DMELEMENT, DMELETEMPLATE, DMELEMENTTYPE
		WHERE
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND 
				DMELEMENT.DMACTIVITY_ID = ?UniqueID? AND 
				DMELETEMPLATE.DMELETEMPLATE_ID = DMELEMENT.DMELETEMPLATE_ID AND 
				DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID
		ORDER BY DMELEMENT.DMELEMENT_ID
					
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the Activity noun                       -->
<!-- that has a name and corresponding values.                                -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param Name The business object name.                                    -->
<!-- @param Value The business object values.                                  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the activities associated with a name and multiple values -->
	name=/Activity[CampaignElement[Name= and (Value=)]]+IBM_Admin_Details
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMELEMENT.$COLS:DMELEMENT$, DMELEMENTNVP.$COLS:DMELEMENTNVP$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE in (?Value?) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    ORDER BY DMACTIVITY.NAME				
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows    
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
		    DMACTIVITY.STOREENT_ID in ($STOREPATH:campaigns$) AND
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE in (?Value?) AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the name of the Activity noun                       -->
<!-- that has a name value pair that matches the specified name and value.    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_ActivityName   -->
<!-- Note that this query returns activites from all stores.                  -->
<!-- If you only want activites from the current store, then use the          -->
<!-- IBM_Admin_ActivityName access profile.                                   -->
<!-- @param Name The business object name.                                    -->
<!-- @param Value The business object value.                                  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the activities associated with a name value pair -->
	name=/Activity[CampaignElement[Name= and (Value=)]]+IBM_Admin_ActivityName
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY_NAME$, DMELEMENT.$COLS:DMELEMENT_JOIN$, DMELEMENTNVP.$COLS:DMELEMENTNVP_JOIN$
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)
    ORDER BY DMACTIVITY.NAME				
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows    
		FROM
				DMACTIVITY, DMELEMENT, DMELEMENTNVP
		WHERE
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL AND
				DMELEMENTNVP.NAME = ?Name? AND
				DMELEMENTNVP.VALUE = ?Value? AND
				(DMACTIVITY.UIDISPLAYABLE IS NULL OR DMACTIVITY.UIDISPLAYABLE = 1) AND 
				DMACTIVITY.STATE IN (0, 1)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return the details of the Activity noun.        -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_ActivityDetailsAssoc
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMEXPFAMILY.$COLS:DMEXPFAMILY$
		FROM
				DMACTIVITY
				LEFT OUTER JOIN DMEXPFAMILY ON (DMACTIVITY.DMACTIVITY_ID = DMEXPFAMILY.DMACTIVITY_ID)
		WHERE
				DMACTIVITY.DMACTIVITY_ID IN ($ENTITY_PKS$)
	  ORDER BY DMACTIVITY.NAME
								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return the e-Marketing Spot details of the Activity noun. -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_ActivityMarketingSpotAssoc
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY_ID$,
				DMELEMENT.$COLS:DMELEMENT$,
				DMELETEMPLATE.$COLS:DMELETEMPLATE$,
				DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMACTIVITY, DMELEMENT, DMELETEMPLATE, DMELEMENTTYPE
		WHERE
				DMACTIVITY.DMACTIVITY_ID IN ($ENTITY_PKS$) AND	
				DMACTIVITY.DMACTTYPE_ID = 3 AND	
				DMACTIVITY.DMACTIVITY_ID = DMELEMENT.DMACTIVITY_ID AND 
				DMELETEMPLATE.DMELETEMPLATE_ID = DMELEMENT.DMELETEMPLATE_ID AND 
				DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID AND
				DMELETEMPLATE.DMELEMENTTYPE_ID = 1
								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return the template details of the Activity     -->
<!-- noun.                                                                    -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_TemplateDetailsAssoc
	base_table=DMACTIVITY
	sql=
		SELECT 
				DMACTIVITY.$COLS:DMACTIVITY$, DMTEMPLATETYPE.$COLS:DMTEMPLATETYPE$
		FROM
				DMACTIVITY, DMTEMPLATETYPE
		WHERE
				DMACTIVITY.DMACTIVITY_ID in ($ENTITY_PKS$) AND
				DMACTIVITY.DMTEMPLATETYPE_ID = DMTEMPLATETYPE.DMTEMPLATETYPE_ID
	  ORDER BY DMACTIVITY.NAME								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- Activity Admin Details Access Profile                                    -->
<!-- This profile returns the details of the Activity noun.                   -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Admin_Details
       BEGIN_ENTITY 
         base_table=DMACTIVITY
         associated_sql_statement=IBM_ActivityDetailsAssoc
         associated_sql_statement=IBM_ActivityMarketingSpotAssoc
    END_ENTITY
END_PROFILE

<!-- ======================================================================== -->
<!-- Activity Admin Template Details Access Profile                           -->
<!-- This profile returns the template details of the Activity noun.          -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Admin_TemplateDetails
       BEGIN_ENTITY 
         base_table=DMACTIVITY
         associated_sql_statement=IBM_TemplateDetailsAssoc
    END_ENTITY
END_PROFILE

