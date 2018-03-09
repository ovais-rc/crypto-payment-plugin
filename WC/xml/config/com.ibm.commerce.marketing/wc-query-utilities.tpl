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

	<!-- DMACTIVITY table -->
	COLS:DMACTIVITY=DMACTIVITY:*
	COLS:DMACTIVITY_TOSTART=DMACTIVITY:DMACTIVITY_ID, STATE, STARTDATE, DMACTTYPE_ID, OPTCOUNTER
	COLS:DMACTIVITY_NAME=DMACTIVITY:DMACTIVITY_ID, NAME, DMCAMPAIGN_ID, OPTCOUNTER
	COLS:DMACTIVITY_PRIORITY=DMACTIVITY:DMACTIVITY_ID, PRIORITY, OPTCOUNTER
	
	<!-- DMACTTYPE table -->
	COLS:DMACTTYPE=DMACTTYPE:*
		
	<!-- DMACTATTR table -->
	COLS:DMACTATTR=DMACTATTR:*
	
	<!-- DMTRIGLSTN table -->
	COLS:DMTRIGLSTN=DMTRIGLSTN:*
	
	<!-- DMELEMENT table -->
	COLS:DMELEMENT=DMELEMENT:*	
	COLS:DMELEMENT_KEY=DMELEMENT:DMELEMENT_ID, OPTCOUNTER
	
	<!-- DMELETEMPLATE table -->
	COLS:DMELETEMPLATE=DMELETEMPLATE:*
		
	<!-- DMELEMENTTYPE table -->
	COLS:DMELEMENTTYPE=DMELEMENTTYPE:*
			
	<!-- DMELEMENTNVP table -->
	COLS:DMELEMENTNVP=DMELEMENTNVP:*			
	
	<!-- DMTRIGSND table -->
	COLS:DMTRIGSND=DMTRIGSND:*
	
	<!-- DMELESTATS table -->
	COLS:DMELESTATS=DMELESTATS:*
	
	<!-- DMEXPSTATS table -->
	COLS:DMEXPSTATS=DMEXPSTATS:*
	
	<!-- DMUSERBHVR table -->
	COLS:DMUSERBHVR=DMUSERBHVR:*
	
	<!-- EMSPOT table -->
	COLS:EMSPOT=EMSPOT:*
		
	<!-- DMEMSPOTSTATS table -->
	COLS:DMEMSPOTSTATS=DMEMSPOTSTATS:*
	
	<!-- DMEMSPOTCMD table -->
	COLS:DMEMSPOTCMD=DMEMSPOTCMD:*
	COLS:DMEMSPOTCMD_SPOTORDERID=DMEMSPOTCMD:DMEMSPOTORD_ID, OPTCOUNTER
	
	<!-- DMEMSPOTDEF table -->
	COLS:DMEMSPOTDEF=DMEMSPOTDEF:*
		
	<!-- DMEMSPOTORD table -->
	COLS:DMEMSPOTORD=DMEMSPOTORD:*
	COLS:DMEMSPOTORD_INTERFACENAME=DMEMSPOTORD:INTERFACENAME, OPTCOUNTER
	
	<!-- DMEXPFAMILY table -->
	COLS:DMEXPFAMILY=DMEXPFAMILY:*
	
	<!-- DMEXPLOG table -->
	COLS:DMEXPLOG=DMEXPLOG:*
	
	<!-- ATCHREL table -->
	COLS:ATCHREL=ATCHREL:*
	COLS:ATCHRELDSC=ATCHRELDSC:*
	COLS:ATCHRLUS_ID=ATCHRLUS:ATCHRLUS_ID
	COLS:ATCHOBJTYP_ID=ATCHOBJTYP:ATCHOBJTYP_ID
	
	<!-- DMMBRGRPPZN -->
	COLS:DMMBRGRPPZN=DMMBRGRPPZN:*
	
	<!-- DMRANKINGITEM table -->
	COLS:DMRANKINGITEM=DMRANKINGITEM:*
	
	<!-- DMRANKINGSTAT table -->
	COLS:DMRANKINGSTAT=DMRANKINGSTAT:*

	<!-- DMEMSPOTCOLLDEF table -->
	COLS:DMEMSPOTCOLLDEF=DMEMSPOTCOLLDEF:*

	<!-- COLLIMGMAPAREA table -->
	COLS:COLLIMGMAPAREA=COLLIMGMAPAREA:*
	COLS:COLLIMGMAPAREA_ID=COLLIMGMAPAREA:COLLIMGMAPAREA_ID
	COLS:COLLATERAL_ID=COLLIMGMAPAREA:COLLATERAL_ID
	COLS:HTMLDEF=COLLIMGMAPAREA:HTMLDEF

END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- Access Profiles                                                          -->
<!-- IBM_Admin_Summary       A subset of all the columns in the table         -->
<!-- IBM_Admin_Details       All the columns from the table                   -->
<!-- IBM_Admin_ActivityName  The NAME column from the DMACTIVITY table        -->
<!-- ======================================================================== -->

<!-- Activity Type -->

<!-- ======================================================================== -->
<!-- This SQL will return all the defined activity types.                     -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the defined activity types -->
	name=/DMACTTYPE+IBM_Admin_Details
	base_table=DMACTTYPE
	sql=
		SELECT
				DMACTTYPE.$COLS:DMACTTYPE$
		FROM
				DMACTTYPE
END_XPATH_TO_SQL_STATEMENT

<!-- Activity Attributes -->

<!-- ======================================================================== -->
<!-- This SQL will return the activity attributes of the specified activity.  -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMACTIVITY_ID The identifier of the activity to retrieve the      -->
<!--                      attributes.                                         -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch attributes of an activity from DMACTATTR - operational table, so no joins to content tables -->
	name=/DMACTATTR[DMACTIVITY_ID=]+IBM_Admin_Details
	base_table=DMACTATTR
	sql=
		SELECT
				DMACTATTR.$COLS:DMACTATTR$
		FROM
				DMACTATTR
		WHERE
				DMACTATTR.DMACTIVITY_ID = ?DMACTIVITY_ID?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the name of the activity based on an activity       -->
<!-- family identifier.                                                       -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_ActivityName   -->
<!-- @param FAMILY_ID The identifier of the activity to retrieve the          -->
<!--                  attributes.                                             -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch name of an activity based on the family identifier -->
	name=/DMACTIVITY[FAMILY_ID=]+IBM_Admin_ActivityName
	base_table=DMACTIVITY
	sql=
		SELECT
				DMACTIVITY.$COLS:DMACTIVITY_NAME$, DMEXPFAMILY.$COLS:DMEXPFAMILY$
		FROM
				DMACTIVITY, DMEXPFAMILY
		WHERE
				DMACTIVITY.DMACTIVITY_ID = DMEXPFAMILY.DMACTIVITY_ID AND
				DMEXPFAMILY.FAMILY_ID = ?FAMILY_ID? AND
				DMEXPFAMILY.SEQUENCE = (SELECT MAX(SEQUENCE) FROM DMEXPFAMILY WHERE DMEXPFAMILY.FAMILY_ID = ?FAMILY_ID?)
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the experiment log entries for a customer in the    -->
<!-- specified store.                                                         -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param PERSONALIZATIONID The identifier of the user.                     -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the experiment log entries for a customer -->
	name=/DMEXPLOG[PERSONALIZATIONID= AND STOREENT_ID=]+IBM_Admin_Details
	base_table=DMEXPLOG
	sql=
		SELECT
				DMEXPLOG.$COLS:DMEXPLOG$
		FROM
				DMEXPLOG
		WHERE
				DMEXPLOG.PERSONALIZATIONID = ?PERSONALIZATIONID? AND
				DMEXPLOG.STOREENT_ID = ?STOREENT_ID?
END_XPATH_TO_SQL_STATEMENT

<!-- Campaign Elements -->

<!-- ======================================================================== -->
<!-- This SQL will return all the campaign elements that have an associated   -->
<!-- behavior rule for detecting triggers and targets.                        -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all campaign elements that have a behavior rule from DMELEMENT -->
	name=/DMACTIVITY[DMELEMENT[DMELETEMPLATE[BEHAVIORXML]]]+IBM_Admin_Details
	base_table=DMELEMENT
	sql=
		SELECT 
				DMELEMENT.$COLS:DMELEMENT$,
				DMELETEMPLATE.$COLS:DMELETEMPLATE$,
				DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMELEMENT, DMELETEMPLATE, DMELEMENTTYPE, DMACTIVITY
		WHERE
				DMELETEMPLATE.DMELETEMPLATE_ID = DMELEMENT.DMELETEMPLATE_ID AND 
				DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID AND 
				DMELETEMPLATE.BEHAVIORXML IS NOT NULL AND 
				DMELETEMPLATE.DMELEMENTTYPE_ID <> 6 AND
				DMELEMENT.DMACTIVITY_ID = DMACTIVITY.DMACTIVITY_ID AND 
				DMACTIVITY.STATE = 1 AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL
				AND DMELEMENT.DMELETEMPLATE_ID NOT IN (SELECT DMELETEMPLATE_ID FROM DMELETEMPLATE WHERE BEHAVIORXML LIKE '%action=""%')
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return all the campaign elements in the specified activity -->
<!-- that have an associated behavior rule for detecting triggers and targets.-->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMACTIVITY_ID The identifier of the activity to retrieve the      -->
<!--                    campaign elements.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all campaign elements from one marketing activity that have a behavior rule in DMELEMENT -->
	name=/DMACTIVITY[DMACTIVITY_ID= and DMELEMENT[DMELETEMPLATE[BEHAVIORXML]]]+IBM_Admin_Details
	base_table=DMELEMENT
	sql=
		SELECT 
				DMELEMENT.$COLS:DMELEMENT$,
				DMELETEMPLATE.$COLS:DMELETEMPLATE$,
				DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMELEMENT, DMELETEMPLATE, DMELEMENTTYPE, DMACTIVITY
		WHERE
				DMELETEMPLATE.DMELETEMPLATE_ID = DMELEMENT.DMELETEMPLATE_ID AND 
				DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID AND 
				DMELETEMPLATE.BEHAVIORXML IS NOT NULL AND 
				DMELETEMPLATE.DMELEMENTTYPE_ID <> 6 AND
				DMELEMENT.DMACTIVITY_ID = DMACTIVITY.DMACTIVITY_ID AND 
				DMACTIVITY.DMACTIVITY_ID = ?DMACTIVITY_ID?
				AND DMELEMENT.DMELETEMPLATE_ID NOT IN (SELECT DMELETEMPLATE_ID FROM DMELETEMPLATE WHERE BEHAVIORXML LIKE '%action=""%')
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the campaign element ID of the Activity noun        -->
<!-- for the campaign element in the specified activity with the specified    -->
<!-- element name.                                                            -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param NAME The name of the campaign element from which to retrieve the  -->
<!--                    campaign element ID.                                  -->
<!-- @param DMACTIVITY_ID The identifier of the activity from which to        -->
<!--                    retrieve the campaign element ID.                     -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the element id associated with an element name in DMELEMENT -->
  name=/DMELEMENT[DMACTIVITY_ID= and NAME=]+IBM_Admin_Summary	
	base_table=DMELEMENT
	sql=
		SELECT 
				DMELEMENT.$COLS:DMELEMENT_KEY$
		FROM
				DMELEMENT
		WHERE
				DMELEMENT.NAME = ?NAME? AND
				DMELEMENT.DMACTIVITY_ID = ?DMACTIVITY_ID?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the campaign elements of the Activity noun          -->
<!-- for all the campaign elements in active activities.                      -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all campaign elements under active activities -->
	name=/DMACTIVITY[STATE=1]/DMELEMENT+IBM_Admin_Summary
	base_table=DMELEMENT
	sql=
		SELECT 
				DMELEMENT.$COLS:DMELEMENT_KEY$
		FROM
				DMELEMENT, DMACTIVITY
		WHERE
				DMELEMENT.DMACTIVITY_ID = DMACTIVITY.DMACTIVITY_ID AND 
				DMACTIVITY.STATE = 1 AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the child campaign elements of the specified        -->
<!-- parent campaign elements in an activity.                                 -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the child campaign elements under a parent element in an activity -->
	name=/DMELEMENT[DMACTIVITY_ID= and PARENT=]+IBM_Admin_Details
	base_table=DMELEMENT
	sql=
		SELECT 
				DMELEMENT.$COLS:DMELEMENT$,
				DMELETEMPLATE.$COLS:DMELETEMPLATE$,
				DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMELEMENT, DMELETEMPLATE, DMELEMENTTYPE
		WHERE
		    DMELEMENT.DMACTIVITY_ID = ?DMACTIVITY_ID? AND
				DMELEMENT.PARENT = ?PARENT? AND 
				DMELETEMPLATE.DMELETEMPLATE_ID = DMELEMENT.DMELETEMPLATE_ID AND
				DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID
		ORDER BY SEQUENCE ASC
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the top level campaign elements of the specified    -->
<!-- activity which do not have a parent campaign element.                    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the top level campaign elements in an activity -->
	name=/DMELEMENT[DMACTIVITY_ID= and PARENT=NULL]+IBM_Admin_Details
	base_table=DMELEMENT
	sql=
		SELECT 
				DMELEMENT.$COLS:DMELEMENT$,
				DMELETEMPLATE.$COLS:DMELETEMPLATE$,
				DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMELEMENT, DMELETEMPLATE, DMELEMENTTYPE
		WHERE
		    DMELEMENT.DMACTIVITY_ID = ?DMACTIVITY_ID? AND
				DMELEMENT.PARENT IS NULL AND 
				DMELEMENT.RELATED_ID IS NULL AND 
				DMELETEMPLATE.DMELETEMPLATE_ID = DMELEMENT.DMELETEMPLATE_ID AND
				DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID
		ORDER BY SEQUENCE ASC
								
END_XPATH_TO_SQL_STATEMENT



<!-- Campaign Element Name Value Pairs -->

<!-- ======================================================================== -->
<!-- This SQL will return the name value pairs of the specified element.      -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMELEMENT_ID The identifier of the element to retrieve the        -->
<!--                     name value pairs.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the name value pairs associated with a campaign element from DMELEMENTNVP -->
	name=/DMELEMENTNVP[DMELEMENT_ID=]+IBM_Admin_Details
	base_table=DMELEMENTNVP
	sql=
		SELECT 
				DMELEMENTNVP.$COLS:DMELEMENTNVP$
		FROM
				DMELEMENTNVP
		WHERE
				DMELEMENTNVP.DMELEMENT_ID = ?DMELEMENT_ID?
		ORDER BY SEQUENCE ASC				
								
END_XPATH_TO_SQL_STATEMENT



<!-- ======================================================================== -->
<!-- This SQL will return the name value pairs of the child elements of the   -->
<!-- specified element and the child elements are of the specified element    -->
<!-- type.                                                                    -->
<!-- @param DMACTIVITY_ID The ID of the activity.                             -->
<!-- @param DMELEMENTTYPE_ID The type of the child elements to return.        -->
<!-- @param PARENT The name of the parent element for which to find the child -->
<!--        elements.                                                         -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the name value pairs associated with a campaign element from DMELEMENTNVP -->
	name=/DMELEMENTNVP[DMACTIVITY_ID= and DMELEMENTTYPE_ID= and PARENT=]+IBM_Admin_Details
	
	base_table=DMELEMENTNVP
	sql=
		SELECT 
			DMELEMENTNVP.$COLS:DMELEMENTNVP$
		FROM
			DMELEMENTNVP, DMELEMENT, DMELETEMPLATE
		WHERE
		    DMELEMENT.DMACTIVITY_ID = ?DMACTIVITY_ID? AND
		    DMELEMENT.PARENT = ?PARENT? AND 
  		    DMELETEMPLATE.DMELEMENTTYPE_ID = ?DMELEMENTTYPE_ID? AND
		    DMELEMENT.DMELETEMPLATE_ID = DMELETEMPLATE.DMELETEMPLATE_ID AND
		    DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID 
		ORDER BY DMELEMENT.SEQUENCE ASC, DMELEMENTNVP.SEQUENCE ASC
END_XPATH_TO_SQL_STATEMENT



<!-- ======================================================================== -->
<!-- This SQL will return the name value pairs of the specified element with  -->
<!-- the specified name.                                                      -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMELEMENT_ID The identifier of the element to retrieve the        -->
<!--                     name value pairs.                                    -->
<!-- @param NAME       The name of the name value pair to retrieve.           -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the name value pair associated with a campaign element from DMELEMENTNVP -->
	name=/DMELEMENTNVP[DMELEMENT_ID= and NAME=]+IBM_Admin_Details
	base_table=DMELEMENTNVP
	sql=
		SELECT 
				DMELEMENTNVP.$COLS:DMELEMENTNVP$
		FROM
				DMELEMENTNVP
		WHERE
				DMELEMENTNVP.DMELEMENT_ID = ?DMELEMENT_ID? AND
				DMELEMENTNVP.NAME = ?NAME?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the name value pairs of the specified element that  -->
<!-- are required to match against a trigger.                                 -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMELEMENT_ID The identifier of the element to retrieve the        -->
<!--                     trigger matching name value pairs.                   -->
<!-- @param TRIGGERMATCH If the nvp is used to match a trigger occurence.     -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the name value pairs associated with a campaign element from DMELEMENTNVP used to match a trigger -->
	name=/DMELEMENTNVP[DMELEMENT_ID= and TRIGGERMATCH=]+IBM_Admin_Details
	base_table=DMELEMENTNVP
	sql=
		SELECT 
				DMELEMENTNVP.$COLS:DMELEMENTNVP$
		FROM
				DMELEMENTNVP
		WHERE
				DMELEMENTNVP.DMELEMENT_ID = ?DMELEMENT_ID? AND
				DMELEMENTNVP.TRIGGERMATCH = ?TRIGGERMATCH?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the campaign elements of the Activity noun          -->
<!-- for the campaign elements in the specified activity with the specified   -->
<!-- name in its name value pairs for the element of the specified format.    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param NAME The name of the campaign element name value pair.            -->
<!-- @param DMELEMENTTYPE_ID The format type of the campaign element.         -->
<!-- @param DMACTIVITY_ID The identifier of the activity from which to        -->
<!--                   retrieve the campaign element ID.                      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the element id associated with an element name in DMELEMENT -->
	name=/DMELEMENT[DMACTIVITY_ID= AND DMELEMENTNVP[DMELEMENTTYPE_ID= and NAME=]]+IBM_Admin_Details
	base_table=DMELEMENT
	sql=
		SELECT 
				DMELEMENT.$COLS:DMELEMENT$, DMELEMENTNVP.$COLS:DMELEMENTNVP$, DMELETEMPLATE.$COLS:DMELETEMPLATE$
		FROM
				DMELEMENT, DMELEMENTNVP, DMELETEMPLATE
		WHERE
				DMELEMENT.DMACTIVITY_ID = ?DMACTIVITY_ID? AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND
				DMELEMENTNVP.NAME = ?NAME? AND
				DMELEMENT.DMELETEMPLATE_ID = DMELETEMPLATE.DMELETEMPLATE_ID AND 
				DMELETEMPLATE.DMELEMENTTYPE_ID = ?DMELEMENTTYPE_ID?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the all the details of the campaign elements        -->
<!-- in the specified activity with the specified. All the element            -->
<!-- name-value pair and element template information is included.            -->
<!-- name in its name value pairs for the element of the specified format.    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMACTIVITY_ID The identifier of the activity from which to        -->
<!--                   retrieve the campaign elements.                        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the element id associated with an element name in DMELEMENT -->
	name=/DMELEMENT[DMACTIVITY_ID=]+IBM_Admin_Details
	base_table=DMELEMENT
	sql=
		SELECT 
				DMELEMENT.$COLS:DMELEMENT$, DMELEMENTNVP.$COLS:DMELEMENTNVP$, DMELETEMPLATE.$COLS:DMELETEMPLATE$, DMELEMENTTYPE.$COLS:DMELEMENTTYPE$
		FROM
				DMELEMENT
				JOIN DMELETEMPLATE ON (DMELEMENT.DMELETEMPLATE_ID = DMELETEMPLATE.DMELETEMPLATE_ID)
				JOIN DMELEMENTTYPE ON (DMELETEMPLATE.DMELEMENTTYPE_ID = DMELEMENTTYPE.DMELEMENTTYPE_ID)
				LEFT OUTER JOIN DMELEMENTNVP ON (DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID)
		WHERE
				DMELEMENT.DMACTIVITY_ID = ?DMACTIVITY_ID?
		ORDER BY DMELEMENT.PARENT, DMELEMENT.SEQUENCE ASC, DMELEMENTNVP.SEQUENCE ASC				
								
END_XPATH_TO_SQL_STATEMENT

<!-- Trigger Listener -->

<!-- ======================================================================== -->
<!-- This SQL will return the trigger listener data for the specified         -->
<!-- element.                                                                 -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMELEMENT_ID The identifier of the element to retrieve the        -->
<!--                     trigger listener data.                               -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the trigger listener associated with a campaign element from DMTRIGLSTN -->
	name=/DMTRIGLSTN[DMELEMENT_ID=]+IBM_Admin_Details
	base_table=DMTRIGLSTN
	sql=
		SELECT 
				DMTRIGLSTN.$COLS:DMTRIGLSTN$
		FROM
				DMTRIGLSTN
		WHERE
				DMTRIGLSTN.DMELEMENT_ID = ?DMELEMENT_ID?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the trigger listener data that match the specified  -->
<!-- trigger name and store.                                                  -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param NAME        The name of the trigger.                              -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the trigger listeners by name and store from DMTRIGLSTN -->
	name=/DMTRIGLSTN[NAME= and STOREENT_ID=]+IBM_Admin_Details
	base_table=DMTRIGLSTN
	sql=
		SELECT 
				DMTRIGLSTN.$COLS:DMTRIGLSTN$
		FROM
				DMTRIGLSTN, DMACTIVITY
		WHERE
				DMTRIGLSTN.NAME = ?NAME? AND 
				(DMTRIGLSTN.STOREENT_ID = ?STOREENT_ID? OR DMTRIGLSTN.STOREENT_ID in ($STOREPATH:campaigns$)) AND 
				DMTRIGLSTN.DMACTIVITY_ID = DMACTIVITY.DMACTIVITY_ID AND 
				DMACTIVITY.STATE = 1 AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the trigger listener data that match the specified  -->
<!-- DisplayEms trigger by e-Marketing Spot ID and store.                     -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param EMSPOT_ID   The ID of the e-Marketing Spot.                       -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the trigger listeners by name and store from DMTRIGLSTN -->
	name=/DMTRIGLSTN[EMSPOT_ID= and STOREENT_ID=]+IBM_Admin_Details
	base_table=DMTRIGLSTN
	sql=
		SELECT 
				DMTRIGLSTN.$COLS:DMTRIGLSTN$, DMELEMENT.$COLS:DMELEMENT_KEY$, DMELEMENTNVP.$COLS:DMELEMENTNVP$, DMACTIVITY.$COLS:DMACTIVITY_PRIORITY$
		FROM
				DMTRIGLSTN, DMELEMENT, DMELEMENTNVP, DMACTIVITY
		WHERE
				DMTRIGLSTN.NAME = 'DisplayEms' AND 
				DMTRIGLSTN.STOREENT_ID = ?STOREENT_ID? AND 
				DMTRIGLSTN.DMELEMENT_ID = DMELEMENT.DMELEMENT_ID AND 
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND 
				DMELEMENTNVP.NAME = 'emsId' AND  
				DMELEMENTNVP.VALUE = ?EMSPOT_ID? AND  
				DMELEMENTNVP.TRIGGERMATCH = 1 AND
				DMTRIGLSTN.DMACTIVITY_ID = DMACTIVITY.DMACTIVITY_ID AND 
				DMACTIVITY.STATE = 1 AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the e-Marketing Spots of the specified e-Marketing  -->
<!-- spot usage type that are associated with active activities of the        -->
<!-- specified activity type. The e-Marketing Spot is associated with the     -->
<!-- activity by the specified name-value pair.                               -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMACTTYPE_ID   The type of the activity.                          -->
<!-- @param NAME           The name of the name-value pair.                   -->
<!-- @param STOREENT_ID    The identifier of the store.                       -->
<!-- @param USAGETYPE      The type of the e-Marketing Spot.                  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the trigger listeners by name and store from DMTRIGLSTN -->
	name=/EMSPOT[DMACTTYPE_ID= and NAME= and STOREENT_ID= and USAGETYPE=]+IBM_Admin_Details
	base_table=EMSPOT
	 dbtype=oracle
	 sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT, DMELEMENT, DMELEMENTNVP, DMACTIVITY
		WHERE
				EMSPOT.STOREENT_ID = ?STOREENT_ID? AND 
				EMSPOT.USAGETYPE = ?USAGETYPE? AND 		
				DMELEMENTNVP.VALUE = EMSPOT.EMSPOT_ID AND
				DMELEMENTNVP.NAME = ?NAME? AND 
				DMELEMENTNVP.TRIGGERMATCH = 1 AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND 
				DMELEMENT.DMACTIVITY_ID = DMACTIVITY.DMACTIVITY_ID AND 
				DMACTIVITY.STATE = 1 AND
				DMACTIVITY.DMACTTYPE_ID = ?DMACTTYPE_ID? AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL
	 
	dbtype=any
	sql=
		SELECT 
				EMSPOT.$COLS:EMSPOT$
		FROM
				EMSPOT, DMELEMENT, DMELEMENTNVP, DMACTIVITY
		WHERE
				EMSPOT.STOREENT_ID = ?STOREENT_ID? AND 
				EMSPOT.USAGETYPE = ?USAGETYPE? AND 		
				DMELEMENTNVP.VALUE = CAST (EMSPOT.EMSPOT_ID AS CHAR(254)) AND
				DMELEMENTNVP.NAME = ?NAME? AND 
				DMELEMENTNVP.TRIGGERMATCH = 1 AND
				DMELEMENT.DMELEMENT_ID = DMELEMENTNVP.DMELEMENT_ID AND 
				DMELEMENT.DMACTIVITY_ID = DMACTIVITY.DMACTIVITY_ID AND 
				DMACTIVITY.STATE = 1 AND
				DMACTIVITY.DMACTTYPE_ID = ?DMACTTYPE_ID? AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the trigger listener data for the specified         -->
<!-- activity.                                                                -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMACTIVITY_ID The identifier of the activity.                     -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the trigger listeners associated with a marketing activity from DMTRIGLSTN -->
	name=/DMTRIGLSTN[DMACTIVITY_ID=]+IBM_Admin_Details
	base_table=DMTRIGLSTN
	sql=
		SELECT 
				DMTRIGLSTN.$COLS:DMTRIGLSTN$
		FROM
				DMTRIGLSTN
		WHERE
				DMTRIGLSTN.DMACTIVITY_ID = ?DMACTIVITY_ID?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the trigger listener data for all the active        -->
<!-- activites.                                                               -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the active trigger listeners from DMTRIGLSTN -->
	name=/DMTRIGLSTN+IBM_Admin_Details
	base_table=DMTRIGLSTN
	sql=
		SELECT 
				DMTRIGLSTN.$COLS:DMTRIGLSTN$
		FROM
				DMTRIGLSTN, DMACTIVITY
		WHERE
				DMTRIGLSTN.DMACTIVITY_ID = DMACTIVITY.DMACTIVITY_ID AND 
				DMACTIVITY.STATE = 1 AND
				DMACTIVITY.DMTEMPLATETYPE_ID IS NULL
								
END_XPATH_TO_SQL_STATEMENT


<!-- Trigger Sender -->

<!-- ======================================================================== -->
<!-- This SQL will return the trigger sender data for all the entries that    -->
<!-- are ready to be processed.                                               -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all unprocessed triggers to send in DMTRIGSND -->
	name=/DMTRIGSND[TIMETOSEND=]+IBM_Admin_Details
	base_table=DMTRIGSND
	dbtype=oracle
	sql=SELECT DMTRIGSND.$COLS:DMTRIGSND$ FROM DMTRIGSND WHERE DMTRIGSND.TIMETOSEND <= CURRENT_TIMESTAMP AND ROWNUM <= 10000		
	dbtype=db2
	sql=SELECT DMTRIGSND.$COLS:DMTRIGSND$ FROM DMTRIGSND WHERE DMTRIGSND.TIMETOSEND <= CURRENT_TIMESTAMP FETCH FIRST 10000 ROW ONLY
	sql=SELECT DMTRIGSND.$COLS:DMTRIGSND$ FROM DMTRIGSND WHERE DMTRIGSND.TIMETOSEND <= CURRENT_TIMESTAMP
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the trigger sender data for the specified           -->
<!-- element.                                                                 -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMELEMENT_ID The identifier of the element.                       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all triggers associated with an element in DMTRIGSND -->
	name=/DMTRIGSND[DMELEMENT_ID=]+IBM_Admin_Details
	base_table=DMTRIGSND 
	sql= 
		SELECT  
				DMTRIGSND.$COLS:DMTRIGSND$ 
		FROM 
				DMTRIGSND 
		WHERE 
				DMTRIGSND.DMELEMENT_ID = ?DMELEMENT_ID?
								 
END_XPATH_TO_SQL_STATEMENT


<!-- Campaign Element Statistics -->

<!-- ======================================================================== -->
<!-- This SQL will return the statistics for the specified element.           -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMELEMENT_ID The identifier of the element.                       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all statistics associated with an element in DMELESTATS -->
	name=/DMELESTATS[DMELEMENT_ID=]+IBM_Admin_Details
	base_table=DMELESTATS 
	sql= 
		SELECT  
				DMELESTATS.$COLS:DMELESTATS$ 
		FROM 
				DMELESTATS 
		WHERE 
		    DMELESTATS.STOREENT_ID = $CTX:STORE_ID$ AND
				DMELESTATS.DMELEMENT_ID = ?DMELEMENT_ID?
								 
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the experiment statistics for the specified         -->
<!-- experiment branch element.                                               -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param EXPERIMENT_ID The identifier of the experiment branch element.    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all experiment statistics associated with an experiment element in DMEXPSTATS -->
	name=/DMEXPSTATS[EXPERIMENT_ID=]+IBM_Admin_Details
	base_table=DMEXPSTATS 
	sql= 
		SELECT  
				DMEXPSTATS.$COLS:DMEXPSTATS$ 
		FROM 
				DMEXPSTATS 
		WHERE 
		    DMEXPSTATS.STOREENT_ID = $CTX:STORE_ID$ AND
				DMEXPSTATS.EXPERIMENT_ID = ?EXPERIMENT_ID?
								 
END_XPATH_TO_SQL_STATEMENT

<!-- EMarketingSpot Statistics -->

<!-- ======================================================================== -->
<!-- This SQL will return the eMarketing Spot statistics for the specified    -->
<!-- activity.                                                                -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMACTIVITY_ID The identifier of the activity.                     -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the eMarketingSpot statistics for one activity -->
	name=/DMEMSPOTSTATS[DMACTIVITY_ID=]+IBM_Admin_Details
	base_table=DMEMSPOTSTATS
	sql=
		SELECT 
				DMEMSPOTSTATS.$COLS:DMEMSPOTSTATS$
		FROM
				DMEMSPOTSTATS
		WHERE
		    DMEMSPOTSTATS.STOREENT_ID = $CTX:STORE_ID$ AND
				DMEMSPOTSTATS.DMACTIVITY_ID = ?DMACTIVITY_ID?

END_XPATH_TO_SQL_STATEMENT


<!-- User Behavior -->

<!-- ======================================================================== -->
<!-- This SQL will return the user behavior data for the specified            -->
<!-- personalization identifier.                                              -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param PERSONALIZATIONID The identifier of the user.                     -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch a customers user behavior from DMUSERBHVR -->
	name=/DMUSERBHVR[PERSONALIZATIONID= and STOREENT_ID=]+IBM_Admin_Details
	base_table=DMUSERBHVR 
	sql= 
		SELECT  
				DMUSERBHVR.$COLS:DMUSERBHVR$ 
		FROM 
				DMUSERBHVR 
		WHERE 
		    DMUSERBHVR.STOREENT_ID = ?STOREENT_ID? AND
				DMUSERBHVR.PERSONALIZATIONID = ?PERSONALIZATIONID? 
								 
END_XPATH_TO_SQL_STATEMENT

<!-- EMarketingSpot Default Content -->

<!-- ======================================================================== -->
<!-- This SQL will return the eMarketingSpot default content data for the     -->
<!-- specified eMarketingSpot and store.                                      -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param EMSPOT_ID   The identifier of the eMarketingSpot.                 -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the eMarketingSpot default content set up for the eMarketingSpot in a store -->
	name=/DMEMSPOTDEF[EMSPOT_ID= and STOREENT_ID=]+IBM_Admin_Summary
	base_table=DMEMSPOTDEF
	sql=
		SELECT 
				DMEMSPOTDEF.$COLS:DMEMSPOTDEF$
		FROM
				DMEMSPOTDEF
		WHERE
				DMEMSPOTDEF.EMSPOT_ID = ?EMSPOT_ID? AND 								
				DMEMSPOTDEF.STOREENT_ID = ?STOREENT_ID?
		ORDER BY SEQUENCE ASC				

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the eMarketingSpot default content data for the     -->
<!-- specified eMarketingSpot, store, content type, and content unique ID.    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param CONTENT     The unique identifier of the content.                 -->
<!-- @param CONTENTTYPE The type of the content.                              -->
<!-- @param EMSPOT_ID   The identifier of the eMarketingSpot.                 -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the eMarketingSpot default content set up for the eMarketingSpot in a store -->
	name=/DMEMSPOTDEF[CONTENT= and CONTENTTYPE= and EMSPOT_ID= and STOREENT_ID=]+IBM_Admin_Summary
	base_table=DMEMSPOTDEF
	sql=
		SELECT 
				DMEMSPOTDEF.$COLS:DMEMSPOTDEF$
		FROM
				DMEMSPOTDEF
		WHERE
				DMEMSPOTDEF.EMSPOT_ID = ?EMSPOT_ID? AND 								
				DMEMSPOTDEF.STOREENT_ID = ?STOREENT_ID?  AND 								
				DMEMSPOTDEF.CONTENT = ?CONTENT?  AND 								
				DMEMSPOTDEF.CONTENTTYPE = ?CONTENTTYPE?
		ORDER BY SEQUENCE ASC				

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the eMarketingSpot default content data for the     -->
<!-- specified eMarketingSpot.		                                          -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param EMSPOT_ID   The identifier of the eMarketingSpot.                 -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the eMarketingSpot default content set up for the eMarketingSpot in a store -->
	name=/DMEMSPOTDEF[EMSPOT_ID=]+IBM_Admin_Summary
	base_table=DMEMSPOTDEF
	sql=
		SELECT 
				DMEMSPOTDEF.$COLS:DMEMSPOTDEF$
		FROM
				DMEMSPOTDEF
		WHERE
				DMEMSPOTDEF.EMSPOT_ID = ?EMSPOT_ID? 								
		ORDER BY SEQUENCE ASC				

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the eMarketingSpot default content data             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param DMEMSPOTDEF_ID The eMarketingSpot default content ID              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the eMarketingSpot default content -->
	name=/DMEMSPOTDEF[DMEMSPOTDEF_ID=]+IBM_Admin_Summary
	base_table=DMEMSPOTDEF
	sql=
		SELECT 
				DMEMSPOTDEF.$COLS:DMEMSPOTDEF$
		FROM
				DMEMSPOTDEF
		WHERE
				DMEMSPOTDEF.DMEMSPOTDEF_ID = ?DMEMSPOTDEF_ID?

END_XPATH_TO_SQL_STATEMENT

<!-- EMarketingSpot Ordering -->

<!-- ======================================================================== -->
<!-- This SQL will return the eMarketingSpot ordering data for the specified  -->
<!-- eMarketingSpot, content type, and store.                                 -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param CONTENTTYPE The type of the content.                              -->
<!-- @param EMSPOT_ID   The identifier of the eMarketingSpot.                 -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the eMarketingSpot ordering method set up for one eMarketingSpot and content type -->
	name=/DMEMSPOTCMD[CONTENTTYPE= and EMSPOT_ID= and STOREENT_ID=]+IBM_Admin_Summary
	base_table=DMEMSPOTCMD
	sql=
		SELECT 
				DMEMSPOTCMD.$COLS:DMEMSPOTCMD_SPOTORDERID$
		FROM
				DMEMSPOTCMD
		WHERE
				DMEMSPOTCMD.CONTENTTYPE = ?CONTENTTYPE? AND
				DMEMSPOTCMD.EMSPOT_ID = ?EMSPOT_ID? AND 								
				DMEMSPOTCMD.STOREENT_ID = ?STOREENT_ID?

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the eMarketingSpot ordering data for the specified  -->
<!-- eMarketingSpot and store.                                                -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param CONTENTTYPE The type of the content.                              -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the eMarketingSpot ordering method set up for a content type in a store -->
	name=/DMEMSPOTCMD[CONTENTTYPE= and STOREENT_ID=]+IBM_Admin_Summary
	base_table=DMEMSPOTCMD
	sql=
		SELECT 
				DMEMSPOTCMD.$COLS:DMEMSPOTCMD_SPOTORDERID$
		FROM
				DMEMSPOTCMD
		WHERE
				DMEMSPOTCMD.CONTENTTYPE = ?CONTENTTYPE? AND
				DMEMSPOTCMD.EMSPOT_ID IS NULL AND 								
				DMEMSPOTCMD.STOREENT_ID = ?STOREENT_ID?

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the interface name for the specified                -->
<!-- eMarketingSpot ordering method.                                          -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param DMEMSPOTORD_ID The eMarketingSpot ordering method.                -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the interface associated with a eMarketingSpot ordering method -->
	name=/DMEMSPOTORD[DMEMSPOTORD_ID=]+IBM_Admin_Summary
	base_table=DMEMSPOTORD
	sql=
		SELECT 
				DMEMSPOTORD.$COLS:DMEMSPOTORD_INTERFACENAME$
		FROM
				DMEMSPOTORD
		WHERE
				DMEMSPOTORD.DMEMSPOTORD_ID = ?DMEMSPOTORD_ID?

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will delete the experiment log entries for the all              -->
<!-- experiments that are no longer required.                                 -->
<!-- @param created The date for which to delete earlier entries.             -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- delete experiment log entries from DMEXPLOG -->
  base_table=DMEXPLOG
	name=IBM_Admin_Delete_DeleteExperimentLogEntriesAll
	dbtype=oracle
	sql=delete from DMEXPLOG where CREATED < TO_TIMESTAMP (?created?, 'YYYY-MM-DD HH24:MI:SS.FF')
	sql=delete from DMEXPLOG where CREATED < ?created?
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will delete the experiment log entries for the specified        -->
<!-- experiments that are no longer required.                                 -->
<!-- @param experimentId The identifier of the experiment.                    -->
<!-- @param created The date for which to delete earlier entries.             -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- delete experiment log entries from DMEXPLOG -->
  base_table=DMEXPLOG
	name=IBM_Admin_Delete_DeleteExperimentLogEntriesIn
	dbtype=oracle
	sql=delete from DMEXPLOG where EXPERIMENT_ID IN ( ?experimentId? ) AND CREATED < TO_TIMESTAMP (?created?, 'YYYY-MM-DD HH24:MI:SS.FF')
	sql=delete from DMEXPLOG where EXPERIMENT_ID IN ( ?experimentId? ) AND CREATED < ?created?
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will delete the experiment log entries for all the experiments, -->
<!-- except the specified experiments, that are no longer required.           -->
<!-- @param experimentId The identifier of the experiment.                    -->
<!-- @param created The date for which to delete earlier entries.             -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- delete experiment log entries from DMEXPLOG -->
  base_table=DMEXPLOG
	name=IBM_Admin_Delete_DeleteExperimentLogEntriesNotIn
	dbtype=oracle
	sql=delete from DMEXPLOG where EXPERIMENT_ID NOT IN ( ?experimentId? ) AND CREATED < TO_TIMESTAMP (?created?, 'YYYY-MM-DD HH24:MI:SS.FF')
	sql=delete from DMEXPLOG where EXPERIMENT_ID NOT IN ( ?experimentId? ) AND CREATED < ?created?
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will delete the trigger sender entries for the specified        -->
<!-- element and user.                                                        -->
<!-- @param elementId The identifier of the element.                          -->
<!-- @param personalizationId The identifier of the user.                     -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- delete trigger sender from DMTRIGSND -->
  base_table=DMTRIGSND
	name=IBM_Admin_Delete_DeleteTriggerSender
	sql=delete from DMTRIGSND where DMELEMENT_ID = ?elementId? AND PERSONALIZATIONID LIKE ?personalizationId?
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will update the trigger sender entries time to send for the     -->
<!-- specified entry.                                                         -->
<!-- @param elementId The identifier of the element.                          -->
<!-- @param personalizationId The identifier of the user.                     -->
<!-- @param storeId The store identifier.                               -->
<!-- @param timeToSend The new time to send.                                  -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- update trigger sender for DMTRIGSND -->
  base_table=DMTRIGSND
	name=IBM_Admin_Update_UpdateTriggerSenderTimeToSend
	sql=update DMTRIGSND set TIMETOSEND=?timeToSend? where DMELEMENT_ID = ?elementId? AND PERSONALIZATIONID LIKE ?personalizationId? AND STOREENT_ID = ?storeId?
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the trigger sender data for the next batch of       -->
<!-- entries that are ready to be processed.                                  -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- find trigger sender in DMTRIGSND -->
  base_table=DMTRIGSND
	name=IBM_Admin_Select_SelectTriggerSender
	dbtype=oracle
	sql=SELECT * FROM DMTRIGSND WHERE DMTRIGSND.TIMETOSEND <= CURRENT_TIMESTAMP AND ROWNUM <= 10000
	dbtype=db2
	sql=SELECT * FROM DMTRIGSND WHERE DMTRIGSND.TIMETOSEND <= CURRENT_TIMESTAMP FETCH FIRST 10000 ROW ONLY
	sql=SELECT * FROM DMTRIGSND WHERE DMTRIGSND.TIMETOSEND <= CURRENT_TIMESTAMP	
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will update the element statistics for the specified element.   -->
<!-- @param counter The value by which to increment the statistics.           -->
<!-- @param elementId The identifier of the element.                          -->
<!-- @param storeId The identifier of the store.                              -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
	<!-- update element statistics DMELESTATS -->
	base_table=DMELESTATS
	name=IBM_Admin_Update_UpdateElementStatistics
	sql=update DMELESTATS set COUNTER = COUNTER + ?counter? where DMELEMENT_ID = ?elementId? AND STOREENT_ID = ?storeId?
								
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will update the eMarketingSpot view statistics for the          -->
<!-- eMarketing Spot under the specified activity.                            -->
<!-- @param views The value by which to increment the view statistics.        -->
<!-- @param activityId The identifier of the activity.                        -->
<!-- @param emspotId The identifier of the eMarketingSpot.                    -->
<!-- @param storeId The identifier of the store.                              -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
	<!-- update eMarketingSpot view statistics DMEMSPOTSTATS -->
	base_table=DMEMSPOTSTATS
	name=IBM_Admin_Update_UpdateEMarketingSpotViewStatistics
	sql=update DMEMSPOTSTATS set VIEWS = VIEWS + ?views? where DMACTIVITY_ID = ?activityId? AND EMSPOT_ID = ?emspotId? AND STOREENT_ID = ?storeId?
								
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will update the eMarketingSpot click statistics for the         -->
<!-- eMarketing Spot under the specified activity.                            -->
<!-- @param clicks The value by which to increment the clicks statistics.     -->
<!-- @param activityId The identifier of the activity.                        -->
<!-- @param emspotId The identifier of the eMarketingSpot.                    -->
<!-- @param storeId The identifier of the store.                              -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
	<!-- update eMarketingSpot click statistics DMEMSPOTSTATS -->
	base_table=DMEMSPOTSTATS
	name=IBM_Admin_Update_UpdateEMarketingSpotClickStatistics
	sql=update DMEMSPOTSTATS set CLICKS = CLICKS + ?clicks? where DMACTIVITY_ID = ?activityId? AND EMSPOT_ID = ?emspotId? AND STOREENT_ID = ?storeId?
								
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will update the test element view statistics for the            -->
<!-- test element under the specified experiment.                             -->
<!-- @param views The value by which to increment the view statistics.        -->
<!-- @param experimentId The identifier of the experiment branch.             -->
<!-- @param testElementId The identifier of the test element path.            -->
<!-- @param storeId The identifier of the store.                              -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
	<!-- update test element view statistics DMEXPSTATS -->
	base_table=DMEXPSTATS
	name=IBM_Admin_Update_UpdateTestElementViewStatistics
	sql=update DMEXPSTATS set VIEWS = VIEWS + ?views? where EXPERIMENT_ID = ?experimentId? AND TESTELEMENT_ID = ?testElementId? AND STOREENT_ID = ?storeId?
								
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will update the test element click statistics for the           -->
<!-- test element under the specified experiment.                             -->
<!-- @param clicks The value by which to increment the clicks statistics.     -->
<!-- @param experimentId The identifier of the experiment branch.             -->
<!-- @param testElementId The identifier of the test element path.            -->
<!-- @param storeId The identifier of the store.                              -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
	<!-- update test element click statistics DMEXPSTATS -->
	base_table=DMEXPSTATS
	name=IBM_Admin_Update_UpdateTestElementClickStatistics
	sql=update DMEXPSTATS set CLICKS = CLICKS + ?clicks? where EXPERIMENT_ID = ?experimentId? AND TESTELEMENT_ID = ?testElementId? AND STOREENT_ID = ?storeId?
								
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will update the test element view revenue statistics for the    -->
<!-- test element under the specified experiment.                             -->
<!-- @param revenue The value by which to increment the view revenue.         -->
<!-- @param currency The currency of the revenue.                             -->
<!-- @param experimentId The identifier of the experiment branch.             -->
<!-- @param testElementId The identifier of the test element path.            -->
<!-- @param storeId The identifier of the store.                              -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
	<!-- update test element view revenue statistics DMEXPSTATS -->
	base_table=DMEXPSTATS
	name=IBM_Admin_Update_UpdateTestElementViewRevenueStatistics
	sql=update DMEXPSTATS set VIEWORDERS = VIEWORDERS + 1, VIEWREVENUE = VIEWREVENUE + ?revenue?, CURRENCY = ?currency? where EXPERIMENT_ID = ?experimentId? AND TESTELEMENT_ID = ?testElementId? AND STOREENT_ID = ?storeId?
								
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will update the test element click revenue statistics for the   -->
<!-- test element under the specified experiment.                             -->
<!-- @param revenue The value by which to increment the clicks revenue.       -->
<!-- @param currency The currency of the revenue.                             -->
<!-- @param experimentId The identifier of the experiment branch.             -->
<!-- @param testElementId The identifier of the test element path.            -->
<!-- @param storeId The identifier of the store.                              -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
	<!-- update test element click revenue statistics DMEXPSTATS -->
	base_table=DMEXPSTATS
	name=IBM_Admin_Update_UpdateTestElementClickRevenueStatistics
	sql=update DMEXPSTATS set CLICKORDERS = CLICKORDERS + 1, CLICKREVENUE = CLICKREVENUE + ?revenue?, CURRENCY = ?currency? where EXPERIMENT_ID = ?experimentId? AND TESTELEMENT_ID = ?testElementId? AND STOREENT_ID = ?storeId?
								
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will delete the specified email template. This action is        -->
<!-- a mark for deletion.                                                     -->
<!-- @param UniqueID The identifier of the email template.                    -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  base_table=EMLMSG
	name=IBM_Admin_Delete_MarketingEmailTemplate
	sql=update EMLMSG set STATUS = 0 WHERE EMLMSG_ID = ?UniqueID?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Initialize the value of the email message to empty_clob()                -->
<!--                                                                           -->
<!--  @param EMLCONTENT_ID                                                     -->
<!--     The EMLCONTENT_ID The identifier of the email content.                -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=EMLCONTENT
  name=IBM_Set_EMLBODY_from_EMLCONTENT_To_Empty_Clob
  sql=update EMLCONTENT set EMLBODY = EMPTY_CLOB() where EMLCONTENT_ID = ?EMLCONTENT_ID?
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  Get the body of the email message in order to update the CLOB            -->
<!--  column on Oracle 9i; because of the Oracle bug, the CLOB column can not  -->
<!--  be the first or the last in the SELECT list.                             -->
<!--                                                                           -->
<!--  @param EMLCONTENT_ID                                                     -->
<!--     The EMLCONTENT_ID The identifier of the email content.                -->
<!--===========================================================================-->
BEGIN_SQL_STATEMENT
  base_table=EMLCONTENT
  name=IBM_Select_EMLBODY_from_EMLCONTENT
  sql=select EMLCONTENT_ID, EMLBODY, EMLCONTENT_ID from EMLCONTENT where EMLCONTENT_ID = ?EMLCONTENT_ID? FOR UPDATE
END_SQL_STATEMENT

<!-- Attachment -->

<!-- ======================================================================== -->
<!-- This SQL gets the attachment relation usage ID based on the usage        --> 
<!-- identifier.                                                              -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_IdResolve       -->
<!-- @param IDENTIFIER The usage identifier of the attachment relation.       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ATCHRLUS[IDENTIFIER=]+IBM_Admin_IdResolve
	base_table=ATCHRLUS
	sql=
			SELECT 
	     				ATCHRLUS.$COLS:ATCHRLUS_ID$
	     	FROM
	     				ATCHRLUS	     										  
	     	WHERE
						ATCHRLUS.IDENTIFIER = ?IDENTIFIER?
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL gets the attachment object type identifier based on the         -->
<!-- unique identifier.                                                       -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_IdResolve      -->
<!-- @param IDENTIFIER The identifier of the attachment object type.          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ATCHOBJTYP[IDENTIFIER=]+IBM_Admin_IdResolve
	base_table=ATCHOBJTYP
	sql=
			SELECT 
	     				ATCHOBJTYP.$COLS:ATCHOBJTYP_ID$
	     	FROM
	     				ATCHOBJTYP	     										  
	     	WHERE
						ATCHOBJTYP.IDENTIFIER = ?IDENTIFIER?
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL gets the attachment reference by the unique identifier.         -->
<!-- The access profiles that apply to this SQL are:                          -->
<!--                         IBM_Admin_AttachmentReference_Update             -->
<!-- @param ATCHREL_ID The attachment reference id.                             -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ATCHREL[(ATCHREL_ID=)]+IBM_Admin_AttachmentReference_Update
	base_table=ATCHREL
	sql=
			SELECT 
	     				ATCHREL.$COLS:ATCHREL$,
	     				ATCHRELDSC.$COLS:ATCHRELDSC$
	     	FROM
	     				ATCHREL LEFT OUTER JOIN ATCHRELDSC ON ATCHRELDSC.ATCHREL_ID = ATCHREL.ATCHREL_ID	     										  
	     	WHERE
						ATCHREL.ATCHREL_ID IN (?ATCHREL_ID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL gets the attachment relation of the marketing content in the    -->
<!-- given store having the specified marketing content identifier, object    -->
<!-- type identifier, usage identifier and attachment target identifier.      -->
<!-- The access profiles that apply to this SQL are:                          -->
<!--                         IBM_Admin_AttachmentReference_Update             -->
<!-- @param ATCHTGT_ID The attachment target id.                              -->
<!-- @param BIGINTOBJECT_ID The object id.                                    -->
<!-- @param ATCHOBJTYP_ID The object type id.                                 -->
<!-- @param ATCHRLUS_ID The usage id.                                         -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/ATCHREL[ATCHTGT_ID= and BIGINTOBJECT_ID= and ATCHOBJTYP_ID= and ATCHRLUS_ID=]+IBM_Admin_AttachmentReference_Update
	base_table=ATCHREL
	sql=
			SELECT 
	     				ATCHREL.$COLS:ATCHREL$,
	     				ATCHRELDSC.$COLS:ATCHRELDSC$
	     	FROM
	     				ATCHREL LEFT OUTER JOIN ATCHRELDSC ON ATCHRELDSC.ATCHREL_ID = ATCHREL.ATCHREL_ID	     										  
	     	WHERE
						ATCHREL.BIGINTOBJECT_ID = ?BIGINTOBJECT_ID? AND
						ATCHREL.ATCHOBJTYP_ID = ?ATCHOBJTYP_ID? AND
						ATCHREL.ATCHRLUS_ID = ?ATCHRLUS_ID? AND
						ATCHREL.ATCHTGT_ID = ?ATCHTGT_ID?
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will delete the member group and personalization id association -->
<!-- for the specified member group and personalization id.                   -->
<!-- @param mbrgrp_id The member group id.                                    -->
<!-- @param personalizationId The identifier of the user.                     -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- delete member group and personalization id from DMMBRGRPPZN -->
  base_table=DMMBRGRPPZN
	name=IBM_Admin_Delete_DeleteDMMBRGRPPZN
	sql=delete from DMMBRGRPPZN where MBRGRP_ID = ?mbrgrp_id? AND PERSONALIZATIONID = ?personalizationId?
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the member group and personalization id of the      -->
<!-- specified member group and personalization id.                           -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param MBRGRP_ID The identifier of the member group.                     -->
<!-- @param PERSONALIZATIONID The personalization id.                         -->
<!--                                                                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch member group and personalization id from DMMBRGRPPZN table -->
	name=/DMMBRGRPPZN[MBRGRP_ID= AND PERSONALIZATIONID=]+IBM_Admin_Details
	base_table=DMMBRGRPPZN
	sql=
		SELECT
				DMMBRGRPPZN.$COLS:DMMBRGRPPZN$
		FROM
				DMMBRGRPPZN
		WHERE
				DMMBRGRPPZN.MBRGRP_ID = ?MBRGRP_ID? and
				DMMBRGRPPZN.PERSONALIZATIONID = ?PERSONALIZATIONID?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will create a user behavior entry.                              -->
<!-- @param PERSONALIZATIONID The identifier of the user.                     -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- @param BEHAVIOR The behavior data.                                       -->
<!-- @param EVENT The event data.                                             -->
<!-- @param ACTION The action data.                                           -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- insert entries into DMUSERBHVR -->
  base_table=DMUSERBHVR
	name=IBM_Admin_Insert_InsertDmuserbehavior
	sql=insert into DMUSERBHVR (PERSONALIZATIONID, STOREENT_ID, BEHAVIOR, EVENT, ACTION, LASTUPDATED) values ( ?PERSONALIZATIONID?, ?STOREENT_ID?, ?BEHAVIOR?, ?EVENT?, ?ACTION?, CURRENT_TIMESTAMP)
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will update a user behavior entry.                              -->
<!-- @param PERSONALIZATIONID The identifier of the user.                     -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- @param BEHAVIOR The behavior data.                                       -->
<!-- @param EVENT The event data.                                             -->
<!-- @param ACTION The action data.                                           -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- update entries in DMUSERBHVR -->
  base_table=DMUSERBHVR
	name=IBM_Admin_Update_UpdateDmuserbehavior
  sql=update DMUSERBHVR set BEHAVIOR = ?BEHAVIOR?, EVENT = ?EVENT?, ACTION = ?ACTION?, LASTUPDATED = CURRENT_TIMESTAMP where PERSONALIZATIONID = ?PERSONALIZATIONID? AND STOREENT_ID = ?STOREENT_ID?
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will remove the association between a deleted MarketingContent  -->
<!-- and an eSpot default content.                                            -->
<!-- @param CollateralId The identifier of the Marketing content.             -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_eSpot_Collateral_Association
	base_table=DMEMSPOTDEF
	sql=
		DELETE FROM DMEMSPOTDEF
		WHERE           CONTENTTYPE = 'MarketingContent' and
						CONTENT = ?CollateralId?
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return all Store Identifiers, Attachment Asset Paths       -->
<!-- and Mimetypes for the given Attachment Relationship ID.                  -->
<!-- @param ATCHREL_ID The attachment relationship id to use                  -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
   name=IBM_Get_Attachment_Asset_Path_Mimetype_And_Store_By_Attachment_Relation_ID
   base_table=ATCHAST
   sql=
       SELECT 
           STOREENT.IDENTIFIER, ATCHAST.ATCHASTPATH , ATCHAST.MIMETYPE
       FROM 
           ATCHAST
       JOIN 
           STOREENT 
       ON 
           ATCHAST.STOREENT_ID = STOREENT.STOREENT_ID 
       WHERE
           ATCHAST.ATCHTGT_ID in 
               ( SELECT ATCHTGT_ID FROM ATCHREL WHERE ATCHREL_ID = ?ATCHREL_ID? )
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return all Store Identifiers, Attachment Asset Paths       -->
<!-- and Mimetypes for the given Attachment Target ID.                        -->
<!-- @param ATCHTGT_ID The attachment target id to use                        -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
   name=IBM_Get_Attachment_Asset_Path_Mimetype_And_Store_By_Attachment_Target_ID
   base_table=ATCHAST
   sql=
       SELECT 
           STOREENT.IDENTIFIER, ATCHAST.ATCHASTPATH, ATCHAST.MIMETYPE 
       FROM 
           ATCHAST
       JOIN 
           STOREENT 
       ON 
           ATCHAST.STOREENT_ID = STOREENT.STOREENT_ID 
       WHERE
           ATCHAST.ATCHTGT_ID = ?ATCHTGT_ID?
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the FILESIZE and CMFILEPATH  for the given          -->
<!-- managed file paths.                                                      -->
<!-- @param CMFILEPATH The managed file size paths to use                     -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
   name=IBM_Get_Filesize_And_Path_By_Cmfilepath
   base_table=CMFILE
   sql=
       SELECT
           CMFILE.FILESIZE, CMFILE.CMFILEPATH
       FROM
           CMFILE
       WHERE
           CMFILEPATH in (?CMFILEPATH?)
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will remove the association between a deleted MarketingContent  -->
<!-- and an Activity.			                                              -->
<!-- @param CollateralId The identifier of the Marketing content.             -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_Activity_Collateral_Association
	base_table=DMELEMENTNVP
	sql=
		DELETE FROM DMELEMENTNVP
		WHERE           DMELEMENTNVP.NAME = 'collateralIdList' and
						DMELEMENTNVP.VALUE = ?CollateralId?
END_SQL_STATEMENT

<!-- Rankiing -->

<!-- ======================================================================== -->
<!-- This SQL will return the ranking list for the specified element in the   -->
<!-- current context store.                                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMELEMENT_ID The identifier of the campaign element.              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch a ranking list from DMRANKINGITEM -->
	name=/DMRANKINGITEM[DMELEMENT_ID= AND GROUP_ID=]+IBM_Admin_Details
	base_table=DMRANKINGITEM 
	sql= 
		SELECT  
				DMRANKINGITEM.$COLS:DMRANKINGITEM$ 
		FROM 
				DMRANKINGITEM 
		WHERE 
				DMRANKINGITEM.DMELEMENT_ID = ?DMELEMENT_ID? AND
				DMRANKINGITEM.GROUP_ID = ?GROUP_ID? AND
		    DMRANKINGITEM.STOREENT_ID = $CTX:STORE_ID$				
		ORDER BY SEQUENCE ASC
								 
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the ranking list for the specified element in the   -->
<!-- specified store.                                                         -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param DMELEMENT_ID The identifier of the campaign element.              -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch a ranking list from DMRANKINGITEM -->
	name=/DMRANKINGITEM[DMELEMENT_ID= AND GROUP_ID= AND STOREENT_ID=]+IBM_Admin_Details
	base_table=DMRANKINGITEM 
	sql= 
		SELECT  
				DMRANKINGITEM.$COLS:DMRANKINGITEM$ 
		FROM 
				DMRANKINGITEM 
		WHERE 
				DMRANKINGITEM.DMELEMENT_ID = ?DMELEMENT_ID? AND
				DMRANKINGITEM.GROUP_ID = ?GROUP_ID? AND
				DMRANKINGITEM.STOREENT_ID = ?STOREENT_ID?				
								 
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will create a ranking statistic entry.                          -->
<!-- @param DMRANKINGSTAT_ID The primary key of the ranking statistic entry.  -->
<!-- @param OBJECT_ID The identifier of the object that generated the event.  -->
<!-- @param OBJECT_TYPE The type of statistic entry.                          -->
<!-- @param STOREENT_ID The store identifier.                                 -->
<!-- @param GROUP_ID The identifier of the group to which the object belongs. -->
<!-- @param AMOUNT The amount associated with the event.                      -->
<!-- ======================================================================== -->
BEGIN_SQL_STATEMENT
  <!-- insert entries into DMRANKINGSTAT -->
  base_table=DMRANKINGSTAT
	name=IBM_Admin_Insert_InsertDmrankingstat
	sql=insert into DMRANKINGSTAT (DMRANKINGSTAT_ID, OBJECT_ID, OBJECT_TYPE, STOREENT_ID, DMELEMENT_ID, GROUP_ID, AMOUNT, FLAG, TIMECREATED) values ( ?DMRANKINGSTAT_ID?, ?OBJECT_ID?, ?OBJECT_TYPE?, ?STOREENT_ID?, ?DMELEMENT_ID?, ?GROUP_ID?, ?AMOUNT?, 0, CURRENT_TIMESTAMP)
END_SQL_STATEMENT


<!-- ======================================================================== -->
<!-- This SQL will return the eMarketingSpot default title data for the     -->
<!-- specified eMarketingSpot, store, and content unique ID.    -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param COLLATERAL_ID     The unique identifier of the content.                 -->
<!-- @param EMSPOT_ID   The identifier of the eMarketingSpot.                 -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the eMarketingSpot default title set up for the eMarketingSpot in a store -->
	name=/DMEMSPOTCOLLDEF[COLLATERAL_ID= and  EMSPOT_ID= and STOREENT_ID=]+IBM_Admin_Summary
	base_table=DMEMSPOTCOLLDEF
	sql=
		SELECT 
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$
		FROM
				DMEMSPOTCOLLDEF
		WHERE
				DMEMSPOTCOLLDEF.EMSPOT_ID = ?EMSPOT_ID? AND 								
				DMEMSPOTCOLLDEF.STOREENT_ID = ?STOREENT_ID? AND
				DMEMSPOTCOLLDEF.COLLATERAL_ID = ?COLLATERAL_ID?				
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the eMarketingSpot default title content data       -->
<!-- for the specified eMarketingSpot and store.                              -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param EMSPOT_ID   The identifier of the eMarketingSpot.                 -->
<!-- @param STOREENT_ID The identifier of the store.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the eMarketingSpot default content set up for the eMarketingSpot in a store -->
	name=/DMEMSPOTCOLLDEF[EMSPOT_ID= and STOREENT_ID=]+IBM_Admin_Summary
	base_table=DMEMSPOTCOLLDEF
	sql=
		SELECT 
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$
		FROM
				DMEMSPOTCOLLDEF
		WHERE
				DMEMSPOTCOLLDEF.EMSPOT_ID = ?EMSPOT_ID? AND 								
				DMEMSPOTCOLLDEF.STOREENT_ID = ?STOREENT_ID?
		ORDER BY
				DMEMSPOTCOLLDEF.SEQUENCE ASC

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the title data of the MarketingSpot noun  -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_MarketingSpotTitle -->
<!-- @param UniqueID The identifier of the marketing spot title for  -->
<!--                             which to retrieve the marketing spot title.       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch the Marketing Spot title in DMEMSPOTCOLLDEF table -->
	name=/MarketingSpot[DefaultMarketingSpotTitle[(UniqueID=)]]+IBM_Admin_MarketingSpotTitle
	base_table=DMEMSPOTCOLLDEF
	sql=
		SELECT 
				DMEMSPOTCOLLDEF.$COLS:DMEMSPOTCOLLDEF$				
		FROM
				DMEMSPOTCOLLDEF					
		WHERE
				DMEMSPOTCOLLDEF.DMEMSPOTCOLLDEF_ID IN ( ?UniqueID? )
								
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Select image map areas by content unique id.
	@param UniqueID the unique id of the marketing content. 
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_Image_Map_Areas_By_Content_UniqueId
	base_table=COLLIMGMAPAREA
	sql=
		SELECT 
				COLLIMGMAPAREA.$COLS:COLLATERAL_ID$, COLLIMGMAPAREA.$COLS:HTMLDEF$
		FROM
				COLLIMGMAPAREA
		WHERE
				COLLIMGMAPAREA.COLLATERAL_ID IN (?UniqueID?)
END_SQL_STATEMENT

<!-- ====================================================================== 
	Select image map area by content unique id, language id and coordinates.
	@param UniqueID the unique id of the marketing content.
	@param LanguageID the language id of the marketing content map.
	@param Coordinates the coordinates of the marketing content map area.    
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Select_Image_Map_Areas_By_Content_UniqueId_LanguageId_Coordinates
	base_table=COLLIMGMAPAREA
	sql=
		SELECT 
				COLLIMGMAPAREA.$COLS:COLLIMGMAPAREA_ID$
		FROM
				COLLIMGMAPAREA
		WHERE
				COLLIMGMAPAREA.COLLATERAL_ID = ?UniqueID? AND
				COLLIMGMAPAREA.LANGUAGE_ID = ?LanguageID? AND
			    COLLIMGMAPAREA.COORDINATES = ?Coordinates?
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete all image map areas of a content.
	@param UniqueID The unique id of the marketing content
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_Content_Image_Map_Areas
	base_table=COLLIMGMAPAREA
	sql=
		DELETE FROM  
				COLLIMGMAPAREA
		WHERE
				COLLIMGMAPAREA.COLLATERAL_ID IN (?UniqueID?)
END_SQL_STATEMENT


<!-- ====================================================================== 
	Delete the image map areas with HTMLDEF column is null for a content.
	@param UniqueID The unique id of the marketing content
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_Content_Image_Map_Areas_With_Source
	base_table=COLLIMGMAPAREA
	sql=
		DELETE FROM  
				COLLIMGMAPAREA
		WHERE
				COLLIMGMAPAREA.COLLATERAL_ID IN (?UniqueID?) AND
				COLLIMGMAPAREA.HTMLDEF IS NOT NULL
END_SQL_STATEMENT

<!-- ====================================================================== 
	Delete the image map areas with HTMLDEF column is not null for a content.
	@param UniqueID The unique id of the marketing content
=========================================================================== -->
BEGIN_SQL_STATEMENT
	name=IBM_Delete_Content_Image_Map_Areas_Without_Source
	base_table=COLLIMGMAPAREA
	sql=
		DELETE FROM  
				COLLIMGMAPAREA
		WHERE
				COLLIMGMAPAREA.COLLATERAL_ID IN (?UniqueID?) AND
				COLLIMGMAPAREA.HTMLDEF IS NULL
END_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the member group and personalization id of the      -->
<!-- specified member group and personalization id.                           -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param MBRGRP_ID The identifier of the member group.                     -->
<!-- @param PERSONALIZATIONID The personalization id.                         -->
<!--                                                                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch member group and personalization id from DMMBRGRPPZN table -->
	name=/DMMBRGRPPZN[PERSONALIZATIONID=]+IBM_Admin_Details
	base_table=DMMBRGRPPZN
	sql=
		SELECT
				DMMBRGRPPZN.$COLS:DMMBRGRPPZN$
		FROM
				DMMBRGRPPZN
		WHERE
				DMMBRGRPPZN.PERSONALIZATIONID = ?PERSONALIZATIONID?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To select mbrgrp table allowexport and export all columns                -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_MRBGRP_ALLOWEXPORT_EXPORTALL
	base_table=MRBGRP
	sql=
	select mbrgrp_id, allowexport, exportall from mbrgrp where mbrgrp_id in (?mbrgrp_id?)
END_SQL_STATEMENT


<!-- ========================================================================= -->
<!--  To update mbrgrp table's allowexport column                              -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_MRBGRP_ALLOWEXPORT
	base_table=MRBGRP
	sql=
	update mbrgrp set allowexport = ?allowexport? where mbrgrp_id = ?mbrgrp_id?
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To update mbrgrp table's exportall column                                -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=UPDATE_MRBGRP_EXPORTALL
	base_table=MRBGRP
	sql=
	update mbrgrp set exportall = ?exportall? where mbrgrp_id = ?mbrgrp_id?
END_SQL_STATEMENT
