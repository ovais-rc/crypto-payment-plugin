<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2007, 2012                                -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->
BEGIN_SYMBOL_DEFINITIONS

	<!-- EMLMSG table -->
	COLS:EMLMSG=EMLMSG:*
	COLS:EMLMSG_ID_NAME=EMLMSG:EMLMSG_ID, NAME

	<!-- EMLMCREL table -->
	COLS:EMLMCREL=EMLMCREL:*
	
	<!-- EMLCONTENT table -->
	COLS:EMLCONTENT=EMLCONTENT:*
								
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- Marketing Email Template Access Profiles                                 -->
<!-- IBM_Admin_Summary All the columns from the EMLMSG table                  -->
<!-- IBM_Admin_Details All the columns from the EMLMSG and EMLCONTENT tables  -->
<!-- ======================================================================== -->

BEGIN_PROFILE_ALIASES
  base_table=EMLMSG
  IBM_Summary=IBM_Admin_Summary
  IBM_Details=IBM_Admin_Details
END_PROFILE_ALIASES

<!-- Marketing Email Templates -->

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingEmailTemplate noun         -->
<!-- for all the email templates in the current store, and in any stores      -->
<!-- in the campaigns store path.  It will only return email templates        -->
<!-- that have an email content definition.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the email templates (with content) in EMLMSG, EMLCONTENT in one store -->
	name=/MarketingEmailTemplate[MarketingEmailContent]+IBM_Admin_Details
	base_table=EMLMSG
	sql=
		SELECT 
				EMLMSG.$COLS:EMLMSG$,
				EMLMCREL.$COLS:EMLMCREL$,
				EMLCONTENT.$COLS:EMLCONTENT$
		FROM
				EMLMSG, EMLMCREL, EMLCONTENT
		WHERE
				EMLMSG.STOREENT_ID in ($STOREPATH:campaigns$) AND
				EMLMSG.EMLMSG_ID = EMLMCREL.EMLMSG_ID AND
				EMLCONTENT.EMLCONTENT_ID = EMLMCREL.EMLCONTENT_ID AND
				EMLMSG.STATUS = 1
	  ORDER BY EMLMSG.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				EMLMSG, EMLMCREL, EMLCONTENT
		WHERE
				EMLMSG.STOREENT_ID in ($STOREPATH:campaigns$) AND
				EMLMSG.EMLMSG_ID = EMLMCREL.EMLMSG_ID AND
				EMLCONTENT.EMLCONTENT_ID = EMLMCREL.EMLCONTENT_ID AND
				EMLMSG.STATUS = 1        
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingEmailTemplate noun         -->
<!-- for all the email templates in the current store, and in any stores      -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch all the email templates (both jsp and with content) in EMLMSG in one store -->
	name=/MarketingEmailTemplate
	base_table=EMLMSG
	sql=
		SELECT 
				EMLMSG.$COLS:EMLMSG$
		FROM
				EMLMSG
		WHERE
				EMLMSG.STOREENT_ID in ($STOREPATH:campaigns$) AND
				EMLMSG.STATUS = 1
	  ORDER BY EMLMSG.NAME
  paging_count
  sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
				EMLMSG
		WHERE
				EMLMSG.STOREENT_ID in ($STOREPATH:campaigns$) AND
				EMLMSG.STATUS = 1        
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingEmailTemplate noun         -->
<!-- for the specified unique identifier. Multiple results are returned       -->
<!-- if multiple identifiers are specified.                                   -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param MarketingEmailTemplateIdentifier The identifier of the email      -->
<!--                              template to retrieve.                       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- fetch email templates (both jsp and with content) in EMLMSG, EMLCONTENT by ID -->
	name=/MarketingEmailTemplate[MarketingEmailTemplateIdentifier[(UniqueID=)]]+IBM_Admin_Details
	base_table=EMLMSG
	sql=
		SELECT 
				EMLMSG.$COLS:EMLMSG$,
				EMLMCREL.$COLS:EMLMCREL$,
				EMLCONTENT.$COLS:EMLCONTENT$
		FROM
				EMLMSG
        LEFT OUTER JOIN EMLMCREL ON (EMLMSG.EMLMSG_ID = EMLMCREL.EMLMSG_ID)
        LEFT OUTER JOIN EMLCONTENT ON (EMLMCREL.EMLCONTENT_ID = EMLCONTENT.EMLCONTENT_ID)				
		WHERE
				EMLMSG.EMLMSG_ID IN ( ?UniqueID? ) AND
				EMLMSG.STATUS = 1				
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingEmailTemplate noun         -->
<!-- that match the specified search criteria                                 -->
<!-- for all the email templates in the current store, and in any stores      -->
<!-- in the campaigns store path.                                             -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- search all the email templates (both jsp and with content) in EMLMSG, EMLCONTENT in one store -->
	name=/MarketingEmailTemplate[search()]
	base_table=EMLMSG
	sql=
		SELECT 
				DISTINCT EMLMSG.$COLS:EMLMSG_ID_NAME$								
		FROM
				EMLMSG, $ATTR_TBLS$	
		WHERE
				EMLMSG.STOREENT_ID in ($STOREPATH:campaigns$) AND
				EMLMSG.STATUS = 1 AND				
				EMLMSG.$ATTR_CNDS$
	  ORDER BY EMLMSG.NAME
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This SQL will return the data of the MarketingEmailTemplate noun         -->
<!-- of the email template with the specified name.                           -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Summary        -->
<!-- @param Name The name of the campaign element template to retrieve.       -->
<!-- @param Context:StoreID The store for which to retrieve the               -->
<!--       email template. This parameter is retrieved from within            -->
<!--       the business context.                                              -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	<!-- find an existing email template by name and store in EMLMSG -->
	name=/MarketingEmailTemplate[MarketingEmailTemplateIdentifier[ExternalIdentifier[Name=]]]+IBM_Admin_Summary
	base_table=EMLMSG
	sql=
		SELECT 
				EMLMSG.$COLS:EMLMSG$			
		FROM
				EMLMSG
		WHERE
				EMLMSG.STOREENT_ID = $CTX:STORE_ID$ AND
				EMLMSG.NAME = ?Name?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return the details of the                       -->
<!-- MarketingEmailTemplate noun.                                             -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	<!-- returns email templates (both jsp and with content) in EMLMSG, EMLCONTENT -->
	name=IBM_MarketingEmailTemplateDetailsAssoc
	base_table=EMLMSG
	sql=
		SELECT 
				EMLMSG.$COLS:EMLMSG$,
				EMLMCREL.$COLS:EMLMCREL$,
				EMLCONTENT.$COLS:EMLCONTENT$				
		FROM
				EMLMSG
				LEFT OUTER JOIN EMLMCREL ON (EMLMSG.EMLMSG_ID = EMLMCREL.EMLMSG_ID)
        LEFT OUTER JOIN EMLCONTENT ON (EMLMCREL.EMLCONTENT_ID = EMLCONTENT.EMLCONTENT_ID)	
		WHERE
				EMLMSG.EMLMSG_ID in ($ENTITY_PKS$)		
	  ORDER BY EMLMSG.NAME								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- MarketingEmailTemplate Details Access Profile.                           -->
<!-- This profile returns the details of the MarketingEmailTemplate noun.     -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Admin_Details
       BEGIN_ENTITY 
         base_table=EMLMSG
         associated_sql_statement=IBM_MarketingEmailTemplateDetailsAssoc
    END_ENTITY
END_PROFILE

