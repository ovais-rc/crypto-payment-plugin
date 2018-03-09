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

	<!-- DMELEMENTTYPE table -->
	COLS:DMELEMENTTYPE=DMELEMENTTYPE:*
	
	<!-- DMELETEMPLATE table -->
	COLS:DMELETEMPLATE=DMELETEMPLATE:*
								
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- Campaign Element Template Access Profiles                                -->
<!-- IBM_Admin_Details      All the columns from the DMELETEMPLATE and        -->
<!--                        DMELEMENTTYPE tables                              -->
<!-- ======================================================================== -->

BEGIN_PROFILE_ALIASES
  base_table=DMELETEMPLATE
  IBM_Details=IBM_Admin_Details
END_PROFILE_ALIASES

<!-- Campaign Element Templates -->

<!-- ======================================================================== -->
<!-- This SQL will return the elements of the CampaignElementTemplate noun    -->
<!-- for all the campaign element templates in the database associated with   -->
<!-- all stores, in the current store, and in any stores in the campaigns     -->
<!-- store path.                                                              -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all campaign element templates in DMELETEMPLATE -->
	name=/CampaignElementTemplate+IBM_Admin_Details
	base_table=DMELETEMPLATE
	sql=
		SELECT 
				DMELETEMPLATE.$COLS:DMELETEMPLATE$, 
				DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMELETEMPLATE, DMELEMENTTYPE
		WHERE
				DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID AND
				(DMELETEMPLATE.STOREENT_ID in ($STOREPATH:campaigns$) OR DMELETEMPLATE.STOREENT_ID IS NULL OR DMELETEMPLATE.STOREENT_ID = 0)

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the elements of the CampaignElementTemplate noun    -->
<!-- for all the campaign element templates in the database of the specified  -->
<!-- type associated with all stores, in the current store, and in any stores -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param CampaignElementFormat The format of the campaign element          -->
<!--                              templates to retrieve.                      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all campaign element templates in DMELETEMPLATE by type -->
	name=/CampaignElementTemplate[CampaignElementTemplateIdentifier[CampaignElementFormat=]]+IBM_Admin_Details
	base_table=DMELETEMPLATE
	sql=
		SELECT 
				DMELETEMPLATE.$COLS:DMELETEMPLATE$, 
				DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMELETEMPLATE, DMELEMENTTYPE
		WHERE
				DMELETEMPLATE.DMELEMENTTYPE_ID = ?CampaignElementFormat? AND 
				DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID AND
        (DMELETEMPLATE.STOREENT_ID in ($STOREPATH:campaigns$) OR DMELETEMPLATE.STOREENT_ID IS NULL OR DMELETEMPLATE.STOREENT_ID = 0)				

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the elements of the CampaignElementTemplate noun    -->
<!-- for the specified unique identifier.                                     -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param CampaignElementTemplateIdentifier The identifier of the campaign  -->
<!--                              element templates to retrieve.              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch a campaign element template from DMELETEMPLATE -->
	name=/CampaignElementTemplate[CampaignElementTemplateIdentifier[UniqueID=]]+IBM_Admin_Details
	base_table=DMELETEMPLATE
	sql=
		SELECT 
				DMELETEMPLATE.$COLS:DMELETEMPLATE$, 
				DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMELETEMPLATE, DMELEMENTTYPE
		WHERE
				DMELETEMPLATE.DMELETEMPLATE_ID = ?UniqueID? AND 
				DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the elements of the CampaignElementTemplate noun    -->
<!-- of the template with the specified name and format.                      -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param CampaignElementFormat The format of the campaign element          -->
<!--                              template to retrieve.                       -->
<!-- @param Name The name of the campaign element template to retrieve.       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch a campaign element template from DMELETEMPLATE by name and type -->
	name=/CampaignElementTemplate[CampaignElementTemplateIdentifier[ExternalIdentifier[CampaignElementFormat= and Name=]]]+IBM_Admin_Details
	base_table=DMELETEMPLATE
	sql=
		SELECT 
				DMELETEMPLATE.$COLS:DMELETEMPLATE$, 
				DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMELETEMPLATE, DMELEMENTTYPE
		WHERE
				DMELETEMPLATE.NAME = ?Name? AND 
				DMELETEMPLATE.DMELEMENTTYPE_ID = ?CampaignElementFormat? AND 
				DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID AND
				(DMELETEMPLATE.STOREENT_ID in ($STOREPATH:campaigns$) OR DMELETEMPLATE.STOREENT_ID IS NULL OR DMELETEMPLATE.STOREENT_ID = 0)
    ORDER BY DMELETEMPLATE.STOREENT_ID DESC

END_XPATH_TO_SQL_STATEMENT