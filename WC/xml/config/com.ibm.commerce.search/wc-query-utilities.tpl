BEGIN_SYMBOL_DEFINITIONS

END_SYMBOL_DEFINITIONS

BEGIN_SQL_STATEMENT
	<!-- Fetch master catalog ID for a store -->
	<!-- xpath = "/Storecat[@storeId=]" -->
	name=/Storecat[@storeId=]+IBM_Admin_CatalogIDProfile
	base_table=STORECAT
	sql=
		SELECT 
				STORECAT.CATALOG_ID
		FROM
				STORECAT
    	WHERE
           	( STORECAT.STOREENT_ID = ?storeId? 
           	  OR STORECAT.STOREENT_ID in (select STOREREL.RELATEDSTORE_ID from STOREREL where STOREREL.STORE_ID = ?storeId? and STRELTYP_ID = -4 and sequence = 1)
           	)    
			AND STORECAT.MASTERCATALOG = '1' 
			
END_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  To get attribute name by identifier   -->
<!-- ========================================================================= -->
BEGIN_SQL_STATEMENT
	name=SELECT_SEARCHABLE_ATTR_NAME
	base_table=ATTRDESC
	sql=
	select ATTR_ID,NAME 
	from ATTRDESC WHERE ATTR_ID IN(SELECT ATTR_ID FROM ATTR WHERE IDENTIFIER =?name? and storeent_id in (?storeent_id?) and SEARCHABLE=1) AND LANGUAGE_ID=?languageId?
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	<!-- Fetch all store IDs for which their searchterm associations is modified in the given task groups -->
	name=IBM_Select_Store_Modified_STA_In_TaskGroup
	base_table=SRCHTERMASSOC
	sql=
		SELECT 
				DISTINCT(STOREENT_ID)
		FROM
				$SCHEMA$.SRCHTERMASSOC
		WHERE
				CONTENT_TASKGRP in (?taskgrp_id?)
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	<!-- Fetch the total session count number that is needed to calculate the percentage of a keyword hits/misses  -->
	name=IBM_Select_Total_Session_Count
	base_table=SRCHSTAT
	dbtype=oracle
	sql=
		SELECT 
				SUM(KEYWORDCOUNT) TOTAL_SESSION_COUNT
		FROM
				SRCHSTAT
		WHERE SRCHSTAT.STOREENT_ID in ($STOREPATH:catalog$) 
			   AND LOGDATE >= TO_TIMESTAMP(?LOGDATE_START?, 'YYYY-MM-DD HH24:MI:SS.FF')
			   AND LOGDATE <= TO_TIMESTAMP(?LOGDATE_END?, 'YYYY-MM-DD HH24:MI:SS.FF') 			   
	dbtype=any	
	sql=
		SELECT 
				SUM(KEYWORDCOUNT) TOTAL_SESSION_COUNT
		FROM
				SRCHSTAT
		WHERE SRCHSTAT.STOREENT_ID in ($STOREPATH:catalog$) 
		       AND LOGDATE >= (?LOGDATE_START?) 
			   AND LOGDATE <= (?LOGDATE_END?)
END_SQL_STATEMENT


BEGIN_SQL_STATEMENT
	name=IBM_Select_STA_Statistics
	base_table=SRCHSTAT
	className=com.ibm.commerce.search.facade.server.services.dataaccess.db.jdbc.SearchTermAssociationStatisticsSQLComposer
	dbtype=oracle
	sql=
	    WITH SRCHSTAT_CTE AS
		( SELECT *
		  FROM  SRCHSTAT T_LOCAL
		  WHERE T_LOCAL.LANGUAGE_ID in (?LANGUAGE_ID?)
		  AND   T_LOCAL.STOREENT_ID in ($STOREPATH:catalog$)
		  {T_LOCAL_KEYWORD_CONDITION_CLAUSE}
		 )
		SELECT  SRCHSTAT_IJ.*
		FROM    ( SELECT  
						  T.SRCHSTAT_ID,
						  T.KEYWORD,
		                  T.LANGUAGE_ID,
		                  T.STOREENT_ID,
		                  T.CATALOG_ID,
		                  T.SEARCHCOUNT,
		                  T.SUGGESTIONCOUNT,
		                  T.SUGGESTION,
		                  T.LOGDETAIL,
		                  T2.SESSIONCOUNT
		          FROM    SRCHSTAT_CTE T,
		                  ( SELECT  T1.KEYWORD,
		                            SUM(T1.KEYWORDCOUNT) SESSIONCOUNT
		                    FROM    SRCHSTAT_CTE T1
		                    WHERE   T1.LOGDATE >= TO_TIMESTAMP(?LOGDATE_START?, 'YYYY-MM-DD HH24:MI:SS.FF')
		                    AND     T1.LOGDATE <= TO_TIMESTAMP(?LOGDATE_END?, 'YYYY-MM-DD HH24:MI:SS.FF')
		                    GROUP BY
		                            T1.KEYWORD
		                  ) T2
		          WHERE   T.KEYWORD = T2.KEYWORD
		          {STATISITICS_TYPE_CLAUSE}
          		  {SRCHSTAT_SUGGESTION_CLAUSE}
		        ) SRCHSTAT_IJ
		LEFT OUTER JOIN
		        SRCHSTAT_CTE SRCHSTAT_NP
		        ON  SRCHSTAT_IJ.KEYWORD = SRCHSTAT_NP.KEYWORD
		        AND SRCHSTAT_IJ.SRCHSTAT_ID < SRCHSTAT_NP.SRCHSTAT_ID
		WHERE   SRCHSTAT_NP.SRCHSTAT_ID IS NULL
		ORDER BY
		        SRCHSTAT_IJ.SESSIONCOUNT DESC
	    
	dbtype=db2
	sql=
	  	WITH SRCHSTAT_CTE AS
		( SELECT *
		  FROM  SRCHSTAT T_LOCAL
		  WHERE T_LOCAL.LANGUAGE_ID in (?LANGUAGE_ID?)
		  AND   T_LOCAL.STOREENT_ID in ($STOREPATH:catalog$)
		  {T_LOCAL_KEYWORD_CONDITION_CLAUSE}
		 )
		SELECT  SRCHSTAT_IJ.*
		FROM    ( SELECT  T.SRCHSTAT_ID,
						  T.KEYWORD,
		                  T.LANGUAGE_ID,
		                  T.STOREENT_ID,
		                  T.CATALOG_ID,
		                  T.SEARCHCOUNT,
		                  T.SUGGESTIONCOUNT,
		                  T.SUGGESTION,
		                  T.LOGDETAIL,
		                  T2.SESSIONCOUNT
		          FROM    SRCHSTAT_CTE T,
		                  ( SELECT  T1.KEYWORD,
		                            SUM(T1.KEYWORDCOUNT) SESSIONCOUNT
		                    FROM    SRCHSTAT_CTE T1
		                    WHERE   T1.LOGDATE >= ?LOGDATE_START?
		                    AND     T1.LOGDATE <= ?LOGDATE_END?
		                    GROUP BY
		                            T1.KEYWORD
		                  ) T2
		          WHERE   T.KEYWORD = T2.KEYWORD
		          {STATISITICS_TYPE_CLAUSE}
          		  {SRCHSTAT_SUGGESTION_CLAUSE}
		        ) SRCHSTAT_IJ
		LEFT OUTER JOIN
		        SRCHSTAT_CTE SRCHSTAT_NP
		        ON  SRCHSTAT_IJ.KEYWORD = SRCHSTAT_NP.KEYWORD
		        AND SRCHSTAT_IJ.SRCHSTAT_ID < SRCHSTAT_NP.SRCHSTAT_ID
		WHERE   SRCHSTAT_NP.SRCHSTAT_ID IS NULL
		ORDER BY
		        SRCHSTAT_IJ.SESSIONCOUNT DESC
			  
	dbtype=any
	sql=
	 SELECT  SRCHSTAT_IJ.*
		FROM   	( 
		  SELECT  
				T.SRCHSTAT_ID,
				T.KEYWORD,
				T.LANGUAGE_ID,
				T.STOREENT_ID,
				T.CATALOG_ID,
				T.SEARCHCOUNT,
				T.SUGGESTIONCOUNT,
				T.SUGGESTION,
				T.LOGDETAIL,
				SESSIONCOUNT
          FROM    SRCHSTAT T,
                  ( SELECT  T_LOCAL.KEYWORD,
                            SUM(T_LOCAL.KEYWORDCOUNT) SESSIONCOUNT
                    FROM    SRCHSTAT T_LOCAL
                    WHERE   T_LOCAL.LANGUAGE_ID in (?LANGUAGE_ID?)
                    AND T_LOCAL.LOGDATE >= (?LOGDATE_START?) 
					AND T_LOCAL.LOGDATE <= (?LOGDATE_END?) 
                    AND     T_LOCAL.STOREENT_ID in ($STOREPATH:catalog$)
                    {T_LOCAL_KEYWORD_CONDITION_CLAUSE}
                    GROUP BY
                            T_LOCAL.KEYWORD
                  ) T2
          WHERE   T.KEYWORD = T2.KEYWORD
          AND     T.STOREENT_ID in ($STOREPATH:catalog$)
          AND     T.LANGUAGE_ID in (?LANGUAGE_ID?)
          {STATISITICS_TYPE_CLAUSE}
          {SRCHSTAT_SUGGESTION_CLAUSE}
        ) SRCHSTAT_IJ
		LEFT OUTER JOIN
		        ( SELECT *
		          FROM  SRCHSTAT
		          WHERE STOREENT_ID in ($STOREPATH:catalog$)
		          AND SRCHSTAT.LANGUAGE_ID in (?LANGUAGE_ID?)
		          {KEYWORD_CONDITION_CLAUSE}
		        ) SRCHSTAT_NP
		        ON  SRCHSTAT_IJ.KEYWORD = SRCHSTAT_NP.KEYWORD
		        AND SRCHSTAT_IJ.SRCHSTAT_ID < SRCHSTAT_NP.SRCHSTAT_ID
		        AND SRCHSTAT_IJ.LANGUAGE_ID = SRCHSTAT_NP.LANGUAGE_ID
		WHERE   SRCHSTAT_NP.SRCHSTAT_ID IS NULL
		ORDER BY
		        SRCHSTAT_IJ.SESSIONCOUNT DESC
	    
END_SQL_STATEMENT

BEGIN_SQL_STATEMENT
	<!-- Fetch host contract -->
	name=IBM_Load_HostingContract
	base_table=STORE 
	sql=
		SELECT CRTDBYCNTR_ID FROM STORE where STORE_ID = ?STORE_ID?
END_SQL_STATEMENT