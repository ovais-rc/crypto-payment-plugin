BEGIN_SYMBOL_DEFINITIONS
	
	<!-- The table for noun Subscription  -->
		<!-- Defining all columns of the table -->
		COLS:SUBSCRIPTION = SUBSCRIPTION:* 	
		<!-- Defining all columns of the SUBSCRSCHJOBS table -->
		COLS:SUBSCRSCHJOBS = SUBSCRSCHJOBS:* 	
		<!-- Defining the unique ID column of the table -->
		COLS:SUBSCRIPTION_ID = SUBSCRIPTION:SUBSCRIPTION_ID, OPTCOUNTER
		<!-- Defining all the columns of the SUBSCRTEMPLATE table -->
		COLS:SUBSCRTEMPLATE = SUBSCRTEMPLATE:*
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- XPath: /Subscription[PurchaseDetails[OrderIdentifier[UniqueID=] and OrderItemIdentifier[UniqueID=]]]-->
<!-- AccessProfile:	IBM_IdResolve -->
<!-- Resolves the subscription using order ID and order item ID. This query is used to resolve subscriptions. -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID.1  Unique id of OrderID -->   
<!-- @param UniqueID.2  Unique id of OrderItemID -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Subscription[PurchaseDetails[OrderIdentifier[UniqueID=] and OrderItemIdentifier[UniqueID=]]]+IBM_IdResolve
	base_table=SUBSCRIPTION
	sql=	
		SELECT 
	     				SUBSCRIPTION.$COLS:SUBSCRIPTION_ID$
	     	FROM
	     				SUBSCRIPTION
	     	WHERE
						SUBSCRIPTION.ORDERS_ID = ?UniqueID.1? AND SUBSCRIPTION.ORDERITEMS_ID = ?UniqueID.2?

END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Subscription[PurchaseDetails[OrderIdentifier[UniqueID=]]]-->
<!-- AccessProfile:	IBM_IdResolve -->
<!-- Resolves the subscription using order ID. This query is used to resolve subscriptions which are recurring orders. -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique id of Order-->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Subscription[PurchaseDetails[OrderIdentifier[UniqueID=]]]+IBM_IdResolve
	base_table=SUBSCRIPTION
	sql=	
		SELECT 
	     				SUBSCRIPTION.$COLS:SUBSCRIPTION_ID$
	     	FROM
	     				SUBSCRIPTION
	     	WHERE
						SUBSCRIPTION.ORDERS_ID = ?UniqueID?

END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Subscription[SubscriptionIdentifier[(UniqueID=)]]-->
<!-- AccessProfile:	IBM_Subscription_Update -->
<!-- Gets the subscription entities using the UniqueIDs provided as parameter -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique id of Subscription to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Subscription[SubscriptionIdentifier[(UniqueID=)]]+IBM_Subscription_Update
	base_table=SUBSCRIPTION
	sql=	
		SELECT 
	     				SUBSCRIPTION.$COLS:SUBSCRIPTION$
	     	FROM
	     				SUBSCRIPTION
	     	WHERE
						SUBSCRIPTION.SUBSCRIPTION_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Subscription[SubscriptionIdentifier[UniqueID=]]-->
<!-- AccessProfile:	IBM_IdResolve -->
<!-- Gets the subscription entity using the UniqueID provided as parameter -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique id of Subscription to retrieve -->   
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Subscription[SubscriptionIdentifier[UniqueID=]]+IBM_IdResolve
	base_table=SUBSCRIPTION
	sql=	
		SELECT 
	     				SUBSCRIPTION.$COLS:SUBSCRIPTION$
	     	FROM
	     				SUBSCRIPTION
	     	WHERE
						SUBSCRIPTION.SUBSCRIPTION_ID = ?UniqueID?
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Subscription[SubscriptionIdentifier[UniqueID=]]-->
<!-- AccessProfile:	IBM_Scheduler_Cancel -->
<!-- Gets all the pending cancel jobs that have been scheduled using the UniqueID provided as parameter -->
<!-- Access profile includes all columns from the SUBSCRSCHJOBS table. -->
<!-- @param UniqueID  Unique id of Subscription whose unprocessed Cancel jobs have to be retrieved -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Subscription[SubscriptionIdentifier[UniqueID=]]+IBM_Scheduler_Cancel
	base_table=SUBSCRSCHJOBS
	sql=
		SELECT
				SUBSCRSCHJOBS.$COLS:SUBSCRSCHJOBS$
		FROM
				SUBSCRSCHJOBS
		WHERE 
				SUBSCRSCHJOBS.SUBSCRIPTION_ID =?UniqueID? and SUBSCRSCHJOBS.ACTION='Cancel' and SUBSCRSCHJOBS.STATUS=0
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Subscription[SubscriptionIdentifier[UniqueID=]]-->
<!-- AccessProfile:	IBM_Scheduler_CreateChildOrder -->
<!-- Gets all the pending CreateChildOrder jobs that have been scheduled using the UniqueID provided as parameter -->
<!-- Access profile includes all columns from the SUBSCRSCHJOBS table. -->
<!-- @param UniqueID  Unique id of Subscription whose unprocessed CreateChildOrder jobs have to be retrieved -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Subscription[SubscriptionIdentifier[UniqueID=]]+IBM_Scheduler_CreateChildOrder
	base_table=SUBSCRSCHJOBS
	sql=
		SELECT
				SUBSCRSCHJOBS.$COLS:SUBSCRSCHJOBS$
		FROM
				SUBSCRSCHJOBS
		WHERE 
				SUBSCRSCHJOBS.SUBSCRIPTION_ID = ?UniqueID? and SUBSCRSCHJOBS.ACTION='CreateChildOrder' and SUBSCRSCHJOBS.STATUS=0
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /Subscription[SubscriptionIdentifier[UniqueID=] and ActionDate=]-->
<!-- AccessProfile:	IBM_Scheduler_Jobs -->
<!-- Gets all the pending jobs that have been scheduled for a given subscription for a future date, using the UniqueID and ActionDate provided as parameters -->
<!-- Access profile includes all columns from the SUBSCRSCHJOBS and SUBSCRIPTION tables  -->
<!-- @param UniqueID  Unique id of Subscription whose unprocessed jobs have to be retrieved -->   
<!-- @param ActionDate Action date of the subscription cancel job which is being processed -->
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Subscription[SubscriptionIdentifier[UniqueID=] and ActionDate=]+IBM_Scheduler_Jobs
	base_table=SUBSCRIPTION
	dbtype=oracle
	sql=
		SELECT
				SUBSCRIPTION.$COLS:SUBSCRIPTION$,
				SUBSCRSCHJOBS.$COLS:SUBSCRSCHJOBS$

		FROM 
				SUBSCRIPTION LEFT OUTER JOIN SUBSCRSCHJOBS ON SUBSCRIPTION.SUBSCRIPTION_ID=SUBSCRSCHJOBS.SUBSCRIPTION_ID AND SUBSCRSCHJOBS.STATUS=0 AND 
SUBSCRSCHJOBS.ACTIONDATE > TO_TIMESTAMP(?ActionDate?, 'YYYY-MM-DD HH24:MI:SS.FF') 
		WHERE 
				SUBSCRIPTION.SUBSCRIPTION_ID = ?UniqueID?

	dbtype=any
	sql=
		SELECT
				SUBSCRIPTION.$COLS:SUBSCRIPTION$,
				SUBSCRSCHJOBS.$COLS:SUBSCRSCHJOBS$

		FROM 
				SUBSCRIPTION LEFT OUTER JOIN SUBSCRSCHJOBS ON SUBSCRIPTION.SUBSCRIPTION_ID=SUBSCRSCHJOBS.SUBSCRIPTION_ID AND SUBSCRSCHJOBS.STATUS=0 AND SUBSCRSCHJOBS.ACTIONDATE > ?ActionDate?
		WHERE 
				SUBSCRIPTION.SUBSCRIPTION_ID = ?UniqueID?

END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Subscription[ScheduledAction[ActionID=]]-->
<!-- AccessProfile:	IBM_IdResolve -->
<!-- Gets the subscription scheduled job using the UniqueID provided as parameter -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Action Id of the scheduled job to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	base_table=SUBSCRSCHJOBS
	name=/Subscription[ScheduledAction[ActionID=]]+IBM_IdResolve
		sql=
		SELECT 
					SUBSCRSCHJOBS.$COLS:SUBSCRSCHJOBS$
		FROM 
					SUBSCRSCHJOBS
		WHERE 
				    SUBSCRSCHJOBS.SCHEDULED_ID = ?ActionID?
				    		
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /Subscription[SubscriptionIdentifier[UniqueID=]]-->
<!-- AccessProfile:	IBM_SubscriptionState_Update -->
<!-- Gets the subscription using the UniqueID provided as parameter. This query is specifically -->
<!-- used to update the subscription state -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  unique ID of the subscription whose state has to be updated. -->   
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Subscription[SubscriptionIdentifier[UniqueID=]]+IBM_SubscriptionState_Update
	base_table=SUBSCRIPTION
	sql=	
		SELECT 
	     				SUBSCRIPTION.$COLS:SUBSCRIPTION$
	     	FROM
	     				SUBSCRIPTION
	     	WHERE
						SUBSCRIPTION.SUBSCRIPTION_ID = ?UniqueID?
END_XPATH_TO_SQL_STATEMENT
<!-- ================================================================================== -->
<!-- XPath: /Subscription[ParentCatalogEntryIdentifier[UniqueID=]]-->
<!-- AccessProfile:	IBM_IdResolve -->
<!-- Gets the subscription template corresponding to the catalog entry ID -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID The catalog entry ID.  
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Subscription[ParentCatalogEntryIdentifier[UniqueID=]]+IBM_IdResolve
	base_table=SUBSCRTEMPLATE
	sql=	
		SELECT 
	     				SUBSCRTEMPLATE.$COLS:SUBSCRTEMPLATE$
	     	FROM
	     				SUBSCRTEMPLATE
	     	WHERE
						SUBSCRTEMPLATE.CATENTRY_ID = ?UniqueID?
END_XPATH_TO_SQL_STATEMENT
