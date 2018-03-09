<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce 5724-I36, 5724-I37, 5724-I38, 5724-I39,        -->
<!--  5724-I40, 5724-I41                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2009                                      -->
<!--                                                                    -->
<!-- US Government Users Restricted Rights - Use, duplication or        -->
<!-- disclosure restricted by GSA ADP Schedule Contract with IBM Corp.  -->
<!--********************************************************************-->

BEGIN_SYMBOL_DEFINITIONS
	COLS:INSRULE_ID = INSRULE:INSRULE_ID
	COLS:INSRULE_ID_NAME=INSRULE:INSRULE_ID, NAME
	COLS:INSRULE = INSRULE:*
	COLS:INSRULECATGRP = INSRULECATGRP:*
	COLS:INSRULECATENT = INSRULECATENT:*
	COLS:INSRULEPAYMTHD = INSRULEPAYMTHD:*
	COLS:INSRULECOND = INSRULECOND:*
	COLS:INSRULEINSOPT = INSRULEINSOPT:*
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- XPath: /InstallmentRule/InstallmentRuleIdentifier[(UniqueID=)] -->
<!-- AccessProfile:	IBM_All -->
<!-- Get the all information for InstallmentRule with specified unique ID. -->
<!-- All access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique ID of InstallmentRule to retrieve. -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InstallmentRule
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE_ID$
		FROM
			INSRULE
		WHERE
			INSRULE.STOREENT_ID IN ($STOREPATH:installment$)
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /InstallmentRule/InstallmentRuleIdentifier[(UniqueID=)] -->
<!-- AccessProfile:	IBM_Details -->
<!-- Get the detail information for InstallmentRule with the specfified unique ID. -->
<!-- Details access profile includes the unique ID and external name. -->
<!-- @param UniqueID  Unique ID of InstallmentRule to retrieve. -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InstallmentRule[InstallmentRuleIdentifier[(UniqueID=)]]
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE_ID$
		FROM
			INSRULE
		WHERE
			INSRULE.INSRULE_ID IN (?UniqueID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /InstallmentRule/InstallmentRuleIdentifier[(UniqueID=)] -->
<!-- AccessProfile:	IBM_Summary -->
<!-- Get the summary information for InstallmentRule with the specified unique ID. -->
<!-- Summary access profile includes the unique ID. -->
<!-- @param UniqueID  Unique ID of InstallmentRule to retrieve. -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InstallmentRule[InstallmentRuleIdentifier/ExternalIdentifier[(Name=)]]
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE_ID$
		FROM
			INSRULE
		WHERE
			INSRULE.STOREENT_ID IN ($STOREPATH:installment$) AND
			INSRULE.NAME IN (?Name?)
END_XPATH_TO_SQL_STATEMENT


<!-- ================================================================================== -->
<!-- XPath: /InstallmentRule/InstallmentRuleIdentifier/ExternalIdentifier[(Name=)] -->
<!-- AccessProfile:	IBM_All -->
<!-- Get all information for InstallmentRule with the specfified external ID (name) -->
<!-- All access profile includes all columns in the table. -->
<!-- @param Name  Name (External ID) of InstallmentRule to retrieve.	-->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InstallmentRule[CatalogEntryAssociation/CatalogEntryIdentifier[(UniqueID=)] and CatalogGroupAssociation/CatalogGroupIdentifier[(UniqueID=)] and PaymentMethodAssociation[PaymentMethodName=]]
	base_table=INSRULE
        dbtype=any
	sql=
		SELECT
			INSRULE.$COLS:INSRULE_ID$
		FROM
			INSRULE
		WHERE
			INSRULE.STOREENT_ID IN ($STOREPATH:installment$) AND
			(INSRULE.STARTDATE IS NULL OR INSRULE.STARTDATE<=CURRENT_TIMESTAMP) AND
			(INSRULE.ENDDATE IS NULL OR INSRULE.ENDDATE>CURRENT_TIMESTAMP) AND
			INSRULE.STATUS=1 AND
			INSRULE.INSRULE_ID IN
			(
				(
					SELECT INSRULECATGRP.INSRULE_ID FROM INSRULECATGRP WHERE (INSRULECATGRP.CATGROUP_ID IS NULL OR INSRULECATGRP.CATGROUP_ID IN (?UniqueID.2?)) AND INSRULECATGRP.ASSOCTYPE=0
					UNION
					SELECT INSRULECATENT.INSRULE_ID FROM INSRULECATENT WHERE (INSRULECATENT.CATENTRY_ID IS NULL OR INSRULECATENT.CATENTRY_ID IN (?UniqueID.1?)) AND INSRULECATENT.ASSOCTYPE=0
				)
				INTERSECT
				SELECT INSRULEPAYMTHD.INSRULE_ID FROM INSRULEPAYMTHD WHERE (INSRULEPAYMTHD.PAYMTHD IS NULL OR INSRULEPAYMTHD.PAYMTHD=?PaymentMethodName?) AND INSRULEPAYMTHD.ASSOCTYPE=0
				EXCEPT
				SELECT INSRULECATGRP.INSRULE_ID FROM INSRULECATGRP WHERE INSRULECATGRP.CATGROUP_ID IN (?UniqueID.2?) AND INSRULECATGRP.ASSOCTYPE=1
				EXCEPT
				SELECT INSRULECATENT.INSRULE_ID FROM INSRULECATENT WHERE INSRULECATENT.CATENTRY_ID IN (?UniqueID.1?) AND INSRULECATENT.ASSOCTYPE=1
				EXCEPT
				SELECT INSRULEPAYMTHD.INSRULE_ID FROM INSRULEPAYMTHD WHERE INSRULEPAYMTHD.PAYMTHD=?PaymentMethodName? AND INSRULEPAYMTHD.ASSOCTYPE=1
			)

        dbtype=db2
	sql=
		SELECT
			INSRULE.$COLS:INSRULE_ID$
		FROM
			INSRULE
		WHERE
			INSRULE.STOREENT_ID IN ($STOREPATH:installment$) AND
			(INSRULE.STARTDATE IS NULL OR INSRULE.STARTDATE<=CURRENT_TIMESTAMP) AND
			(INSRULE.ENDDATE IS NULL OR INSRULE.ENDDATE>CURRENT_TIMESTAMP) AND
			INSRULE.STATUS=1 AND
			INSRULE.INSRULE_ID IN
			(
				(
					SELECT INSRULECATGRP.INSRULE_ID FROM INSRULECATGRP WHERE (INSRULECATGRP.CATGROUP_ID IS NULL OR INSRULECATGRP.CATGROUP_ID IN (?UniqueID.2?)) AND INSRULECATGRP.ASSOCTYPE=0
					UNION
					SELECT INSRULECATENT.INSRULE_ID FROM INSRULECATENT WHERE (INSRULECATENT.CATENTRY_ID IS NULL OR INSRULECATENT.CATENTRY_ID IN (?UniqueID.1?)) AND INSRULECATENT.ASSOCTYPE=0
				)
				INTERSECT
				SELECT INSRULEPAYMTHD.INSRULE_ID FROM INSRULEPAYMTHD WHERE (INSRULEPAYMTHD.PAYMTHD IS NULL OR INSRULEPAYMTHD.PAYMTHD=?PaymentMethodName?) AND INSRULEPAYMTHD.ASSOCTYPE=0
				EXCEPT
				SELECT INSRULECATGRP.INSRULE_ID FROM INSRULECATGRP WHERE INSRULECATGRP.CATGROUP_ID IN (?UniqueID.2?) AND INSRULECATGRP.ASSOCTYPE=1
				EXCEPT
				SELECT INSRULECATENT.INSRULE_ID FROM INSRULECATENT WHERE INSRULECATENT.CATENTRY_ID IN (?UniqueID.1?) AND INSRULECATENT.ASSOCTYPE=1
				EXCEPT
				SELECT INSRULEPAYMTHD.INSRULE_ID FROM INSRULEPAYMTHD WHERE INSRULEPAYMTHD.PAYMTHD=?PaymentMethodName? AND INSRULEPAYMTHD.ASSOCTYPE=1
			)

        dbtype=oracle
	sql=
		SELECT
			INSRULE.$COLS:INSRULE_ID$
		FROM
			INSRULE
		WHERE
			INSRULE.STOREENT_ID IN ($STOREPATH:installment$) AND
			(INSRULE.STARTDATE IS NULL OR INSRULE.STARTDATE<=CURRENT_TIMESTAMP) AND
			(INSRULE.ENDDATE IS NULL OR INSRULE.ENDDATE>CURRENT_TIMESTAMP) AND
			INSRULE.STATUS=1 AND
			INSRULE.INSRULE_ID IN
			(
				(
					SELECT INSRULECATGRP.INSRULE_ID FROM INSRULECATGRP WHERE (INSRULECATGRP.CATGROUP_ID IS NULL OR INSRULECATGRP.CATGROUP_ID IN (?UniqueID.2?)) AND INSRULECATGRP.ASSOCTYPE=0
					UNION
					SELECT INSRULECATENT.INSRULE_ID FROM INSRULECATENT WHERE (INSRULECATENT.CATENTRY_ID IS NULL OR INSRULECATENT.CATENTRY_ID IN (?UniqueID.1?)) AND INSRULECATENT.ASSOCTYPE=0
				)
				INTERSECT
				SELECT INSRULEPAYMTHD.INSRULE_ID FROM INSRULEPAYMTHD WHERE (INSRULEPAYMTHD.PAYMTHD IS NULL OR INSRULEPAYMTHD.PAYMTHD=?PaymentMethodName?) AND INSRULEPAYMTHD.ASSOCTYPE=0
				MINUS
				SELECT INSRULECATGRP.INSRULE_ID FROM INSRULECATGRP WHERE INSRULECATGRP.CATGROUP_ID IN (?UniqueID.2?) AND INSRULECATGRP.ASSOCTYPE=1
				MINUS
				SELECT INSRULECATENT.INSRULE_ID FROM INSRULECATENT WHERE INSRULECATENT.CATENTRY_ID IN (?UniqueID.1?) AND INSRULECATENT.ASSOCTYPE=1
				MINUS
				SELECT INSRULEPAYMTHD.INSRULE_ID FROM INSRULEPAYMTHD WHERE INSRULEPAYMTHD.PAYMTHD=?PaymentMethodName? AND INSRULEPAYMTHD.ASSOCTYPE=1
			)
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /InstallmentRule/InstallmentRuleIdentifier/ExternalIdentifier[(Name=)] -->
<!-- AccessProfile:	IBM_Details -->
<!-- Get the details information for InstallmentRule with the specfified external ID (name). -->
<!-- Detail access profile includes the unique ID and name. -->
<!-- @param Name  Name (External ID) of InstallmentRule to retrieve. --> 
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/InstallmentRule[search()]
	base_table=INSRULE
	sql=
		SELECT 
				DISTINCT INSRULE.$COLS:INSRULE_ID_NAME$
		FROM
				INSRULE, $ATTR_TBLS$
		WHERE
				INSRULE.STOREENT_ID IN ($STOREPATH:installment$) AND
				INSRULE.$ATTR_CNDS$
		ORDER BY INSRULE.NAME
END_XPATH_TO_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Summary
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE$
		FROM
			INSRULE
		WHERE
			INSRULE.INSRULE_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_SummaryOrderByPriorityDesc
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE$
		FROM
			INSRULE
		WHERE
			INSRULE.INSRULE_ID IN ($ENTITY_PKS$)
		ORDER BY
			INSRULE.PRIORITY DESC, INSRULE.INSRULE_ID DESC
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogGroupAssociation
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE_ID$, INSRULECATGRP.$COLS:INSRULECATGRP$
		FROM
			INSRULE
		JOIN
			INSRULECATGRP ON INSRULECATGRP.INSRULE_ID=INSRULE.INSRULE_ID
		WHERE
			INSRULE.INSRULE_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAssociation
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE_ID$, INSRULECATENT.$COLS:INSRULECATENT$
		FROM
			INSRULE
		JOIN
			INSRULECATENT ON INSRULECATENT.INSRULE_ID=INSRULE.INSRULE_ID
		WHERE
			INSRULE.INSRULE_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_PaymentMethodAssociation
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE_ID$, INSRULEPAYMTHD.$COLS:INSRULEPAYMTHD$
		FROM
			INSRULE
		JOIN
			INSRULEPAYMTHD ON INSRULEPAYMTHD.INSRULE_ID=INSRULE.INSRULE_ID
		WHERE
			INSRULE.INSRULE_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Condition
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE_ID$, INSRULECOND.$COLS:INSRULECOND$
		FROM
			INSRULE
		JOIN
			INSRULECOND ON INSRULECOND.INSRULE_ID=INSRULE.INSRULE_ID
		WHERE
			INSRULE.INSRULE_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_InstallmentOption
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE_ID$, INSRULEINSOPT.$COLS:INSRULEINSOPT$
		FROM
			INSRULE
		JOIN
			INSRULEINSOPT ON INSRULEINSOPT.INSRULE_ID=INSRULE.INSRULE_ID
		WHERE
			INSRULE.INSRULE_ID IN ($ENTITY_PKS$)
		ORDER BY
			INSRULE.INSRULE_ID, INSRULEINSOPT.INSTALLMENTS
END_ASSOCIATION_SQL_STATEMENT

BEGIN_PROFILE
	name=IBM_Admin_Summary
	BEGIN_ENTITY
		base_table=INSRULE
		associated_sql_statement=IBM_Summary
	END_ENTITY
END_PROFILE

BEGIN_PROFILE
	name=IBM_Admin_Details
	BEGIN_ENTITY
		base_table=INSRULE
		associated_sql_statement=IBM_Summary
		associated_sql_statement=IBM_CatalogGroupAssociation
		associated_sql_statement=IBM_CatalogEntryAssociation
		associated_sql_statement=IBM_PaymentMethodAssociation
		associated_sql_statement=IBM_Condition
		associated_sql_statement=IBM_InstallmentOption
	END_ENTITY
END_PROFILE

BEGIN_PROFILE
	name=IBM_Admin_All
	BEGIN_ENTITY
		base_table=INSRULE
		associated_sql_statement=IBM_Summary
		associated_sql_statement=IBM_CatalogGroupAssociation
		associated_sql_statement=IBM_CatalogEntryAssociation
		associated_sql_statement=IBM_PaymentMethodAssociation
		associated_sql_statement=IBM_Condition
		associated_sql_statement=IBM_InstallmentOption
	END_ENTITY
END_PROFILE

BEGIN_PROFILE
	name=IBM_Runtime_Details
	BEGIN_ENTITY
		base_table=INSRULE
		associated_sql_statement=IBM_SummaryOrderByPriorityDesc
		associated_sql_statement=IBM_Condition
		associated_sql_statement=IBM_InstallmentOption
	END_ENTITY
END_PROFILE