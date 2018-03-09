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
	COLS:INSRULE = INSRULE:*
	COLS:INSRULECATGRP = INSRULECATGRP:*
	COLS:INSRULECATENT = INSRULECATENT:*
	COLS:INSRULEPAYMTHD = INSRULEPAYMTHD:*
	COLS:INSRULECOND = INSRULECOND:*
	COLS:INSRULEINSOPT = INSRULEINSOPT:*
END_SYMBOL_DEFINITIONS

<!-- ================================================================================== -->
<!-- XPath: /InstallmentRule/InstallmentRuleIdentifier[(UniqueID=)]-->
<!-- AccessProfile:	IBM_Update -->
<!-- Get the information for InstallmentRule with specified unique ID for an update operation -->
<!-- Access profile includes all columns from the table. -->
<!-- @param UniqueID  Unique id of InstallmentRule to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/insrule[(insrule_id=)]+IBM_Admin_Update
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE$
		FROM
			INSRULE
		WHERE
			INSRULE.INSRULE_ID IN (?insrule_id?)
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /InstallmentRule/InstallmentRuleIdentifier/ExternalIdentifier[(Name=)] -->
<!-- AccessProfile:	IBM_IdResolve -->
<!-- Get the internal unique ID for the specified external identifier. -->
<!-- Access profile includes only the unique ID -->
<!-- @param Name  Name(External ID) of InstallmentRule to retrieve -->   
<!-- ================================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/insrule[(name=)]+IBM_Admin_Update
	base_table=INSRULE
	sql=
		SELECT
			INSRULE.$COLS:INSRULE$
		FROM
			INSRULE
		WHERE
			INSRULE.STOREENT_ID=$CTX:STORE_ID$ AND
			INSRULE.NAME IN (?name?)
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================== -->
<!-- XPath: /InstallmentRule/InstallmentRuleIdentifier/ExternalIdentifier[(Name=)] -->
<!-- AccessProfile:	IBM_IdResolve -->
<!-- Get the internal unique ID for the specified external identifier. -->
<!-- Access profile includes only the unique ID -->
<!-- @param Name  Name(External ID) of InstallmentRule to retrieve -->   
<!-- ================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/insrulecatgrp[(insrulecatgrp_id=)]+IBM_Admin_Update
	base_table=INSRULECATGRP
	sql=
		SELECT
			INSRULECATGRP.$COLS:INSRULECATGRP$
		FROM
			INSRULECATGRP
		WHERE
			INSRULECATGRP.INSRULECATGRP_ID IN (?insrulecatgrp_id?)
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/insrulecatent[(insrulecatent_id=)]+IBM_Admin_Update
	base_table=INSRULECATENT
	sql=
		SELECT
			INSRULECATENT.$COLS:INSRULECATENT$
		FROM
			INSRULECATENT
		WHERE
			INSRULECATENT.INSRULECATENT_ID IN (?insrulecatent_id?)
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/insrulepaymthd[(insrulepaymthd_id=)]+IBM_Admin_Update
	base_table=INSRULEPAYMTHD
	sql=
		SELECT
			INSRULEPAYMTHD.$COLS:INSRULEPAYMTHD$
		FROM
			INSRULEPAYMTHD
		WHERE
			INSRULEPAYMTHD.INSRULEPAYMTHD_ID IN (?insrulepaymthd_id?)
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/insrulecond[(insrulecond_id=)]+IBM_Admin_Update
	base_table=INSRULECOND
	sql=
		SELECT
			INSRULECOND.$COLS:INSRULECOND$
		FROM
			INSRULECOND
		WHERE
			INSRULECOND.INSRULECOND_ID IN (?insrulecond_id?)
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/insruleinsopt[(insruleinsopt_id=)]+IBM_Admin_Update
	base_table=INSRULEINSOPT
	sql=
		SELECT
			INSRULEINSOPT.$COLS:INSRULEINSOPT$
		FROM
			INSRULEINSOPT
		WHERE
			INSRULEINSOPT.INSRULEINSOPT_ID IN (?insruleinsopt_id?)
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/insruleinsopt[(insrule_id=)]+IBM_Admin_Update
	base_table=INSRULEINSOPT
	sql=
		SELECT
			INSRULEINSOPT.$COLS:INSRULEINSOPT$
		FROM
			INSRULEINSOPT
		WHERE
			INSRULEINSOPT.INSRULE_ID IN (?insrule_id?)
END_XPATH_TO_SQL_STATEMENT



