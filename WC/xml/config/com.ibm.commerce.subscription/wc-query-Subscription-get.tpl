<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2009, 2010                                -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->

BEGIN_SYMBOL_DEFINITIONS	
		COLS:SUBSCRIPTION = SUBSCRIPTION:* 	
		COLS:SUBSCRIPTION_ID = SUBSCRIPTION:SUBSCRIPTION_ID
		
		<!-- Require RECURRING field as part of the IBM_Store_Summary access profile. -->
		COLS:SUBSCRIPTION_SUMMARY = SUBSCRIPTION:SUBSCRIPTION_ID,MEMBER_ID,STATUS,CATENTRY_ID,ORDERS_ID,ORDERITEMS_ID,STOREENT_ID,QUANTITY,TOTALCOST,AMOUNTPAID,CURRENCY,DESCRIPTION,STARTDATE,PAYMENT_FREQ,PAYMENTFREQ_UOM,TIMEPERIOD,TIMEPERIOD_UOM,FULFILLMENT_FREQ,FFMFREQ_UOM,NEXTFFMDATE,NEXTPAYMENTDATE,ENDDATE,CANCELDATE,SUBSCPTYPE_ID,RECURRING,TIMEPLACED,FIELD1,FIELD2,FIELD3,OPTCOUNTER
		COLS:SUBSCRIPTION_DETAILS = SUBSCRIPTION:SUBSCRIPTION_ID,REMAININGCOUNT,AMOUNT_TOCHARGE,LASTUPDATE,OPTCOUNTER
		COLS:SUBSCRIPTION_SUSPEND = SUBSCRSUSPEND:SUBSCRIPTION_ID,SUSPENDSTARTDATE,SUSPENDENDDATE,FIELD1,FIELD2,FIELD3,OPTCOUNTER
		COLS:SUBSCRIPTION_RENEW = SUBSCRRENEW:*
END_SYMBOL_DEFINITIONS

<!-- ===========================================================================
     Get list of Recurring Orders/Subscriptions by unique ID.
     @param UniqueID    The Unique ID of the buyer.
     @param SubscriptionTypeCode The value of the subscription type.
     Supported Access Profiles are IBM_STORE_SUMMARY and IBM_STORE_DETAILS .
     =========================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/Subscription[BuyerIdentifier[UniqueID=] and (SubscriptionTypeCode=)]
	base_table=SUBSCRIPTION
	className=com.ibm.commerce.subscription.facade.server.services.dataaccess.db.jdbc.SubscriptionSQLComposer
	sql=	
		SELECT 
	     				SUBSCRIPTION.$COLS:SUBSCRIPTION_ID  	     				
	     	FROM
	     				SUBSCRIPTION
	     	WHERE
						SUBSCRIPTION.MEMBER_ID = ?UniqueID? 
						AND SUBSCRIPTION.SUBSCPTYPE_ID IN ( ?SubscriptionTypeCode? )
						AND SUBSCRIPTION.STOREENT_ID IN ($CTX:STORE_ID$)
			ORDER BY 	SUBSCRIPTION.TIMEPLACED DESC
	paging_count
       sql =
       	SELECT 
	     				COUNT(*) as COUNTER 	     				
	     	FROM
	     				SUBSCRIPTION
	     	WHERE
						SUBSCRIPTION.MEMBER_ID = ?UniqueID? 
						AND SUBSCRIPTION.SUBSCPTYPE_ID IN ( ?SubscriptionTypeCode? ) 
						AND SUBSCRIPTION.STOREENT_ID IN ($CTX:STORE_ID$)
END_XPATH_TO_SQL_STATEMENT

<!-- ===========================================================================
     Get Recurring Order/Subscription details by unique ID(s).
     @param UniqueID    The Unique ID(s) of the Recurring Order/Subscription.
     Supported Access Profiles are IBM_STORE_SUMMARY and IBM_STORE_DETAILS .
     =========================================================================== -->
     
BEGIN_XPATH_TO_SQL_STATEMENT
	name = /Subscription[SubscriptionIdentifier[(UniqueID=)]]
	base_table=SUBSCRIPTION
	sql=	
			SELECT 
	     				SUBSCRIPTION.$COLS:SUBSCRIPTION_ID  	     				
	     	FROM
	     				SUBSCRIPTION
	     	WHERE
						SUBSCRIPTION.SUBSCRIPTION_ID IN ( ?UniqueID? ) 
	paging_count
       sql =
       		SELECT 
	     				COUNT(*) as COUNTER 	     				
	     	FROM
	     				SUBSCRIPTION
	     	WHERE
						SUBSCRIPTION.SUBSCRIPTION_ID IN ( ?UniqueID? ) 
END_XPATH_TO_SQL_STATEMENT
		
<!-- ===========================================================================
     Get Subscription query for IBM_Store_Summary access profile.
     =========================================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_SUBSCR_SUMMARY
	base_table=SUBSCRIPTION
	sql=
		SELECT 
			SUBSCRIPTION.$COLS:SUBSCRIPTION_SUMMARY$
		FROM
			SUBSCRIPTION
		WHERE
			SUBSCRIPTION.SUBSCRIPTION_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get Subscription query for IBM_Store_Details access profile.
     =========================================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_SUBSCR_DETAILS
	base_table=SUBSCRIPTION
	sql=
		SELECT 
			SUBSCRIPTION.$COLS:SUBSCRIPTION_DETAILS$
		FROM
			SUBSCRIPTION
		WHERE
			SUBSCRIPTION.SUBSCRIPTION_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

<!-- ===========================================================================
     Get Subscription query to retrieve subscription suspend information.
     =========================================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_SUBSCR_SUSPEND_DETAILS
	base_table=SUBSCRIPTION
	sql=
		SELECT 
			SUBSCRIPTION.$COLS:SUBSCRIPTION_ID$,SUBSCRSUSPEND.$COLS:SUBSCRIPTION_SUSPEND$
		FROM
			SUBSCRIPTION JOIN SUBSCRSUSPEND ON (SUBSCRIPTION.SUBSCRIPTION_ID = SUBSCRSUSPEND.SUBSCRIPTION_ID)
		WHERE
			SUBSCRSUSPEND.SUBSCRIPTION_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT
<!-- ===========================================================================
     Get Subscription query to retrieve subscription renew information.
     =========================================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_SUBSCR_RENEW_DETAILS
	base_table=SUBSCRIPTION
	sql=
		SELECT 
			SUBSCRIPTION.$COLS:SUBSCRIPTION_ID$,SUBSCRRENEW.$COLS:SUBSCRIPTION_RENEW$
		FROM
			SUBSCRIPTION JOIN SUBSCRRENEW ON (SUBSCRIPTION.SUBSCRIPTION_ID = SUBSCRRENEW.SUBSCRIPTION_ID)
		WHERE
			SUBSCRRENEW.SUBSCRIPTION_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT
<!-- ===========================================================================

<!-- ===========================================================================
     Definition for IBM_Store_Summary access profile.
     =========================================================================== -->
     
BEGIN_PROFILE 
	name=IBM_Store_Summary
	BEGIN_ENTITY 
	  base_table=SUBSCRIPTION
	  associated_sql_statement=IBM_SUBSCR_SUMMARY
    END_ENTITY
END_PROFILE

<!-- ===========================================================================
     Definition for IBM_Store_Details access profile.
     =========================================================================== -->
BEGIN_PROFILE 
	name=IBM_Store_Details
	BEGIN_ENTITY 
	  base_table=SUBSCRIPTION
	  associated_sql_statement=IBM_SUBSCR_SUMMARY
	  associated_sql_statement=IBM_SUBSCR_DETAILS
	  associated_sql_statement=IBM_SUBSCR_SUSPEND_DETAILS
	  associated_sql_statement=IBM_SUBSCR_RENEW_DETAILS
    END_ENTITY
END_PROFILE