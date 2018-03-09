BEGIN_SYMBOL_DEFINITIONS
	COLS:SUBSCRIPTIONTYPE = SUBSCPTYPE:*
	COLS:SUBSCRSCHJOBS = SUBSCRSCHJOBS:*
	COLS:SUBSCRIPTION = SUBSCRIPTION:*
	COLS:SCHACTIONIDANDRETRIES = SUBSCRSCHJOBS:SCHEDULED_ID,RETRYCOUNT,ACTION,PARAMETER,SUBSCRIPTION_ID
	COLS:SUBSCRTMPLITEMLIST = SUBSCRTMPLITEMLIST:*
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- This SQL statement is used to retrieve the valid subscription types defined for the site.-->
<!-- The query results is used for validating the subscription type provided in the request.-->
<!-- @return A list of subscription types defined in the site.-->
<!-- ================================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=SUBSCPTYPE
	name=IBM_Select_SubscriptionTypeId_By_Name
	sql=SELECT SUBSCPTYPE.$COLS:SUBSCRIPTIONTYPE$
		FROM SUBSCPTYPE
		WHERE SUBSCPTYPE_ID = ?SubscriptionTypeCode?
END_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- This SQL statement is used to retrieve the list of scheduled actions based on input action date.-->
<!-- The scheduled actions retrieved are in active state.-->
<!-- @return A list of scheduled actions to be processed.-->
<!-- ================================================================================== -->

BEGIN_SQL_STATEMENT
	base_table=SUBSCRSCHJOBS
	name=IBM_Select_Subscription_Scheduled_Jobs
	dbtype=oracle
		sql=
		SELECT 
					SUBSCRSCHJOBS.$COLS:SCHACTIONIDANDRETRIES$
		FROM 
					SUBSCRSCHJOBS
		WHERE 
					SUBSCRSCHJOBS.ACTIONDATE <= TO_TIMESTAMP(?ActionDate?, 'YYYY-MM-DD HH24:MI:SS.FF') 
					AND SUBSCRSCHJOBS.STATUS IN (0, 4)
					
		ORDER BY  		SUBSCRSCHJOBS.ACTIONDATE ASC
	dbtype=any
	sql=
		SELECT 
					SUBSCRSCHJOBS.$COLS:SCHACTIONIDANDRETRIES$
		FROM 
					SUBSCRSCHJOBS
		WHERE 
					SUBSCRSCHJOBS.ACTIONDATE <= ?ActionDate? 
					AND SUBSCRSCHJOBS.STATUS IN (0, 4)
					
		ORDER BY  		SUBSCRSCHJOBS.ACTIONDATE ASC
		
END_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- This SQL statement is used to fetch all the time based subscriptions based on the member ID, end date and parent catentry ID
<!-- This is used by renew subscription check, to look for potential subscription renew candidates
<!-- @return A list of subscriptions to be processed.-->
<!-- ================================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=SUBSCRIPTION
	name=IBM_Select_Subscription_By_Member_EndDate_ParentID
	dbtype=oracle
		sql=
		SELECT 
				SUBSCRIPTION.$COLS:SUBSCRIPTION$
		FROM
				SUBSCRIPTION JOIN CATENTREL ON SUBSCRIPTION.CATENTRY_ID=CATENTREL.CATENTRY_ID_CHILD
		WHERE
				SUBSCRIPTION.MEMBER_ID= ?MemberID? AND SUBSCRIPTION.SUBSCPTYPE_ID = ?SubscriptionTypeCode? AND 
				
				SUBSCRIPTION.ENDDATE <= TO_TIMESTAMP(?EndDate?, 'YYYY-MM-DD HH24:MI:SS.FF') AND CATENTREL.CATENTRY_ID_PARENT = ?ParentID?
		
		ORDER BY SUBSCRIPTION.ENDDATE DESC
	dbtype=any
	sql=
		SELECT 
				SUBSCRIPTION.$COLS:SUBSCRIPTION$
		FROM
				SUBSCRIPTION JOIN CATENTREL ON SUBSCRIPTION.CATENTRY_ID=CATENTREL.CATENTRY_ID_CHILD

		WHERE
				SUBSCRIPTION.MEMBER_ID= ?MemberID? AND SUBSCRIPTION.SUBSCPTYPE_ID = ?SubscriptionTypeCode? AND SUBSCRIPTION.ENDDATE <= ?EndDate?
				
				AND CATENTREL.CATENTRY_ID_PARENT = ?ParentID? 
				
		ORDER BY SUBSCRIPTION.ENDDATE DESC
END_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- This SQL statement is used to fetch the subscriptions template based on the template ID
<!-- This is used by scheduler to create child subscriptions
<!-- @return subscription template to be processed.-->
<!-- ================================================================================== -->
BEGIN_SQL_STATEMENT
	base_table=SUBSCRTMPLITEMLIST
	name=IBM_Select_Subscription_Template_By_ID
	sql=SELECT SUBSCRTMPLITEMLIST.$COLS:SUBSCRTMPLITEMLIST$
		FROM SUBSCRTMPLITEMLIST
		WHERE SUBSCRTEMPLATE_ID = ?SubscriptionTemplate_ID?
END_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- This SQL statement is used to fetch the catentry ID of the ProductBean, given the catentry ID of the ItemBean
<!-- @return The catentry ID of the ProductBean
<!-- ================================================================================== -->

BEGIN_SQL_STATEMENT
	base_table=CATENTREL
	name=IBM_Select_Parent_CatentryID_By_Child_CatentryID
	sql=
		SELECT 
				CATENTREL.CATENTRY_ID_PARENT
		FROM
				CATENTREL
		WHERE
				CATENTREL.CATENTRY_ID_CHILD= ?CatentryID?
END_SQL_STATEMENT
<!-- ================================================================================== -->
<!-- This SQL statement is used to validate whether the input quantity type unit ID is valid.
<!-- @return The quantity type unit ID from the QTYUNIT table -->
<!-- ================================================================================== -->

BEGIN_SQL_STATEMENT
	base_table=QTYUNIT
	name=IBM_Select_QtyUnitID
	sql=
		SELECT 
				QTYUNIT.QTYUNIT_ID
		FROM
				QTYUNIT
		WHERE
				QTYUNIT.QTYUNIT_ID= ?QtyUnitID?
END_SQL_STATEMENT
