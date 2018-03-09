
BEGIN_SYMBOL_DEFINITIONS
	
	<!-- Account table  -->
	COLS:ACCOUNT = ACCOUNT:* 	
	COLS:ACCOUNT_ID = ACCOUNT:ACCOUNT_ID
	COLS:ACCOUNT:NAME = ACCOUNT:NAME
	COLS:ACCOUNT_ID_NAME=ACCOUNT:ACCOUNT_ID, NAME
	COLS:ACCOUNT_OWNER_ID=ACCOUNT:MEMBER_ID	
	
END_SYMBOL_DEFINITIONS

<!-- ======================================================================== -->
<!-- This SQL will return the identifier and name of the Business Account 	  -->
<!-- that match the specified search criteria                                 -->
<!-- for all the bussiness accounts in the current store 					  -->
<!-- The access profile that apply to this SQL is: IBM_Admin_Summary     	  -->
<!-- @param CTX:STORE_ID The store identifier in the context.                 -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/BusinessAccount[search()]
	base_table=ACCOUNT 
	sql=
		SELECT 
			DISTINCT ACCOUNT.$COLS:ACCOUNT_ID_NAME$ 
		FROM
			ACCOUNT, $ATTR_TBLS$ 
		WHERE
			ACCOUNT.STORE_ID = $CTX:STORE_ID$ AND ACCOUNT.MARKFORDELETE = 0 
			AND ACCOUNT.$ATTR_CNDS$
		ORDER BY ACCOUNT.NAME

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- This associated SQL will return the summary information of the business  -->
<!-- account noun.   														  -->
<!-- ======================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_BusinessAccount_Name
	base_table=ACCOUNT
	sql=
		SELECT 
				ACCOUNT.$COLS:ACCOUNT_ID$, ACCOUNT.$COLS:ACCOUNT:NAME$, 
				ACCOUNT.$COLS:ACCOUNT_OWNER_ID$ 
		FROM
				ACCOUNT
		WHERE
				ACCOUNT.ACCOUNT_ID in ($ENTITY_PKS$)
	  	ORDER BY ACCOUNT.NAME	
	  								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- Business Account Noun Admin Summary Access Profile                       -->
<!-- This profile returns a summary of the Business Account noun.             -->
<!-- ======================================================================== -->

BEGIN_PROFILE 
    name=IBM_Admin_Summary
    BEGIN_ENTITY 
    	base_table=ACCOUNT
    	className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
    	associated_sql_statement=IBM_BusinessAccount_Name         
    END_ENTITY
END_PROFILE