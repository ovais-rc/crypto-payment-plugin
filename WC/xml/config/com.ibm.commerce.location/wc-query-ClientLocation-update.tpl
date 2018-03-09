<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2011                                      -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->

BEGIN_SYMBOL_DEFINITIONS
  COLS:CLIENTLOCATION_KEY_COL = CLIENTLOCATION:CLIENTLOCATION_ID
  COLS:CLIENTLOCATION_IBM_Update_AP_COLS = CLIENTLOCATION:*
  COLS:CLIENTLOCATION_IBM_All_AP_COLS = CLIENTLOCATION:*
  COLS:CLIENTLOCATION_IBM_Summary_AP_COLS = CLIENTLOCATION:CLIENTLOCATION_ID,OPTCOUNTER
END_SYMBOL_DEFINITIONS

<!-- Generic find -->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/ClientLocation
  base_table=CLIENTLOCATION
  sql=
    SELECT DISTINCT
      CLIENTLOCATION.$COLS:CLIENTLOCATION_KEY_COL$
    FROM
      CLIENTLOCATION
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/ClientLocation[(ClientLocationID=)]
  base_table=CLIENTLOCATION
  sql=
    SELECT DISTINCT
      CLIENTLOCATION.$COLS:CLIENTLOCATION_KEY_COL$
    FROM
      CLIENTLOCATION
    WHERE
      CLIENTLOCATION.CLIENTLOCATION_ID = ?ClientLocationID?
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/ClientLocation[search()]
  base_table=CLIENTLOCATION
  sql=
    SELECT DISTINCT
      CLIENTLOCATION.$COLS:CLIENTLOCATION_KEY_COL$
    FROM
      CLIENTLOCATION, $ATTR_TBLS$
    WHERE
      ( $ATTR_CNDS$ )
END_XPATH_TO_SQL_STATEMENT

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/CLIENTLOCATION[(CLIENTLOCATION_ID=)]
  base_table=CLIENTLOCATION
  sql=
    SELECT DISTINCT
      CLIENTLOCATION.$COLS:CLIENTLOCATION_KEY_COL$
    FROM
      CLIENTLOCATION
    WHERE
      CLIENTLOCATION.CLIENTLOCATION_ID = ?CLIENTLOCATION_ID?
END_XPATH_TO_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
  name=IBM_CLIENTLOCATION_Access_Profile_IBM_Update
  base_table=CLIENTLOCATION
  sql =
    SELECT
      CLIENTLOCATION.$COLS:CLIENTLOCATION_IBM_Update_AP_COLS$
    FROM
      CLIENTLOCATION
    WHERE
      CLIENTLOCATION.CLIENTLOCATION_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
  name=IBM_CLIENTLOCATION_Access_Profile_IBM_All
  base_table=CLIENTLOCATION
  sql =
    SELECT
      CLIENTLOCATION.$COLS:CLIENTLOCATION_IBM_All_AP_COLS$
    FROM
      CLIENTLOCATION
    WHERE
      CLIENTLOCATION.CLIENTLOCATION_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

BEGIN_ASSOCIATION_SQL_STATEMENT
  name=IBM_CLIENTLOCATION_Access_Profile_IBM_Summary
  base_table=CLIENTLOCATION
  sql =
    SELECT
      CLIENTLOCATION.$COLS:CLIENTLOCATION_IBM_Summary_AP_COLS$
    FROM
      CLIENTLOCATION
    WHERE
      CLIENTLOCATION.CLIENTLOCATION_ID IN ( $ENTITY_PKS$ )
END_ASSOCIATION_SQL_STATEMENT

BEGIN_PROFILE
  name=IBM_Update
  BEGIN_ENTITY
    base_table=CLIENTLOCATION
    associated_sql_statement=IBM_CLIENTLOCATION_Access_Profile_IBM_Update
  END_ENTITY
END_PROFILE

BEGIN_PROFILE
  name=IBM_CLIENTLOCATION_Access_Profile_IBM_Update
  BEGIN_ENTITY
    base_table=CLIENTLOCATION
    associated_sql_statement=IBM_CLIENTLOCATION_Access_Profile_IBM_Update
  END_ENTITY
END_PROFILE

BEGIN_PROFILE
  name=IBM_All
  BEGIN_ENTITY
    base_table=CLIENTLOCATION
    associated_sql_statement=IBM_CLIENTLOCATION_Access_Profile_IBM_All
  END_ENTITY
END_PROFILE

BEGIN_PROFILE
  name=IBM_CLIENTLOCATION_Access_Profile_IBM_All
  BEGIN_ENTITY
    base_table=CLIENTLOCATION
    associated_sql_statement=IBM_CLIENTLOCATION_Access_Profile_IBM_All
  END_ENTITY
END_PROFILE

BEGIN_PROFILE
  name=IBM_Summary
  BEGIN_ENTITY
    base_table=CLIENTLOCATION
    associated_sql_statement=IBM_CLIENTLOCATION_Access_Profile_IBM_Summary
  END_ENTITY
END_PROFILE

BEGIN_PROFILE
  name=IBM_CLIENTLOCATION_Access_Profile_IBM_Summary
  BEGIN_ENTITY
    base_table=CLIENTLOCATION
    associated_sql_statement=IBM_CLIENTLOCATION_Access_Profile_IBM_Summary
  END_ENTITY
END_PROFILE


