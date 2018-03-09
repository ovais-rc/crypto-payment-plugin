<!--********************************************************************-->
<!--  Licensed Materials - Property of IBM                              -->
<!--                                                                    -->
<!--  WebSphere Commerce                                                -->
<!--                                                                    -->
<!--  (c) Copyright IBM Corp. 2008, 2015                                -->
<!--                                                                    -->
<!--  US Government Users Restricted Rights - Use, duplication or       -->
<!--  disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<!--                                                                    -->
<!--********************************************************************-->

BEGIN_SYMBOL_DEFINITIONS
  
  <!-- PX_PROMOTION table -->
  COLS:PX_PROMOTION=PX_PROMOTION:*
  COLS:PX_PROMOTION_PK=PX_PROMOTION:PX_PROMOTION_ID
  COLS:PX_PROMOTION_SUMMARY=PX_PROMOTION:PX_PROMOTION_ID, STOREENT_ID, NAME, VERSION, REVISION, PX_GROUP_ID, PRIORITY, STATUS, EXCLSVE, TYPE, CDREQUIRED, TGTSALES, STARTDATE, ENDDATE, PERORDLMT,PERSHOPPERLMT,TOTALLMT, EFFECTIVE, EXPIRE, TRANSFER

  <!-- PX_PROMOAUTH table -->
  COLS:PX_PROMOAUTH=PX_PROMOAUTH:*

  <!-- PX_PROMOCD table -->
  COLS:PX_PROMOCD=PX_PROMOCD:*

  <!-- PX_DESCRIPTION table -->
  COLS:PX_DESCRIPTION=PX_DESCRIPTION:*

  <!-- PX_GROUP table -->
  COLS:PX_GROUP=PX_GROUP:*
  COLS:PX_GROUP_IDS=PX_GROUP:PX_GROUP_ID, GRPNAME, STOREENT_ID
  
  <!-- PX_CDSPEC table-->
  COLS:PX_CDSPEC=PX_CDSPEC:*

  <!-- PX_CDPOOL table-->
  COLS:PX_CDPOOL=PX_CDPOOL:*
    
  <!-- PX_CDUSAGE table-->
  COLS:PX_CDUSAGE=PX_CDUSAGE:*
  <!-- PX_CDPROMO table-->
  COLS:PX_CDPROMO=PX_CDPROMO:*
  
  <!-- PX_ELEMENT table -->
  COLS:PX_ELEMENT=PX_ELEMENT:*
  
  <!-- PX_ELEMENTNVP table -->
  COLS:PX_ELEMENTNVP=PX_ELEMENTNVP:*
    
END_SYMBOL_DEFINITIONS

<!-- ========================================================================  -->
<!--  Get the Promotion(s) with the specified access profile IBM_Admin_Details -->
<!--                                                                           -->
<!--  @param Context:ENTITY_PKS                                                -->
<!--     The primary keys of the Promotions.                                   -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--  @param Control:LANGUAGES                                                 -->
<!--     The language for which to retrieve the promotion description .This    --> 
<!--     parameter is retrieved from within the business context.              -->
<!--===========================================================================-->

BEGIN_ASSOCIATION_SQL_STATEMENT
  name=IBM_Admin_Details_AssociationSQL
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_SUMMARY$, 
        PX_PROMOAUTH.$COLS:PX_PROMOAUTH$,
        PX_GROUP.$COLS:PX_GROUP_IDS$,
        PX_PROMOCD.$COLS:PX_PROMOCD$,
        PX_CDSPEC.$COLS:PX_CDSPEC$,
        PX_DESCRIPTION.$COLS:PX_DESCRIPTION$        
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        INNER JOIN PX_GROUP ON PX_PROMOTION.PX_GROUP_ID=PX_GROUP.PX_GROUP_ID
        LEFT JOIN PX_PROMOCD ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOCD.PX_PROMOTION_ID
        LEFT JOIN PX_CDSPEC ON PX_PROMOTION.PX_PROMOTION_ID=PX_CDSPEC.PX_PROMOTION_ID
        LEFT JOIN PX_DESCRIPTION ON PX_PROMOTION.PX_PROMOTION_ID=PX_DESCRIPTION.PX_PROMOTION_ID
        AND PX_DESCRIPTION.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID in ($ENTITY_PKS$) AND
        PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
    ORDER BY PX_PROMOTION.PX_PROMOTION_ID               
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- Promotion Admin Details Access Profile                                   -->
<!-- This profile returns the details of the Promotion noun.                  -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
       name=IBM_Admin_Details
       BEGIN_ENTITY 
         base_table=PX_PROMOTION
         associated_sql_statement=IBM_Admin_Details_AssociationSQL
    END_ENTITY
END_PROFILE

<!-- ========================================================================  -->
<!--  Get the Promotion Code Specification 									   -->
<!--                                                                           -->
<!--  @param PX_PROMOTION_ID                                                   -->
<!--     The primary keys of the Promotion.                                    -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_CDSPEC[(PX_PROMOTION_ID=)]+IBM_Admin_All
  base_table=PX_CDSPEC
  sql=
    SELECT 
        PX_CDSPEC.$COLS:PX_CDSPEC$ 
    FROM
        PX_CDSPEC
    WHERE
        PX_CDSPEC.PX_PROMOTION_ID = ?PX_PROMOTION_ID?              
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the Promotion Codes           									   -->
<!--                                                                           -->
<!--  @param PX_PROMOTION_ID                                                   -->
<!--     The primary keys of the Promotion.                                    -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_CDPOOL[(PX_PROMOTION_ID=)]+IBM_Admin_All
  base_table=PX_CDPOOL
  sql=
    SELECT 
        PX_CDPOOL.$COLS:PX_CDPOOL$ 
    FROM
        PX_CDPOOL
        INNER JOIN PX_CDPROMO ON PX_CDPROMO.PX_CDPOOL_ID = PX_CDPOOL.PX_CDPOOL_ID
    WHERE
        PX_CDPROMO.PX_PROMOTION_ID = ?PX_PROMOTION_ID?              
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get PX_CDPOOL by reference IDs.           							   -->
<!--                                                                           -->
<!--  @param REFERENCE_ID                                                      -->
<!--     The primary keys of the Promotion reference object.                   -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/PX_CDPOOL[(REFERENCE_ID=)]+IBM_Admin_All
  base_table=PX_CDPOOL
  sql=
    SELECT 
        PX_CDPOOL.$COLS:PX_CDPOOL$ 
    FROM
        PX_CDPOOL        
    WHERE        
		PX_CDPOOL.REFERENCE_ID IN (?REFERENCE_ID?)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the PX_CDPOOL By Code           							   -->
<!--                                                                           -->
<!--  @param CODE                                                       -->
<!--     The unique promotion code of the Promotion.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDPOOL[(CODE=)]+IBM_Admin_All
  base_table=PX_CDPOOL 
  sql=  
    SELECT 
        PX_CDPOOL.$COLS:PX_CDPOOL$, 
        PX_CDUSAGE.$COLS:PX_CDUSAGE$
    FROM 
        PX_CDPOOL 
        LEFT JOIN PX_CDUSAGE ON PX_CDUSAGE.PX_CDPOOL_ID=PX_CDPOOL.PX_CDPOOL_ID
    WHERE 
        PX_CDPOOL.CODE IN (?CODE?)
        AND PX_CDPOOL.STORE_ID IN ($STOREPATH:promotions$) 
END_XPATH_TO_SQL_STATEMENT 

<!-- ========================================================================  -->
<!--  Get the PX_CDPOOL By ORDER_ID           							   -->
<!--                                                                           -->
<!--  @param CODE                                                       -->
<!--     The unique promotion code of the Promotion.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDPOOL[(ORDERS_ID=)]+IBM_Admin_All
  base_table=PX_CDPOOL 
  sql=  
    SELECT 
        PX_CDPOOL.$COLS:PX_CDPOOL$, 
        PX_CDUSAGE.$COLS:PX_CDUSAGE$
    FROM 
        PX_CDPOOL 
        LEFT JOIN PX_CDUSAGE ON PX_CDUSAGE.PX_CDPOOL_ID=PX_CDPOOL.PX_CDPOOL_ID
    WHERE 
        PX_CDUSAGE.ORDERS_ID IN (?ORDERS_ID?)
        AND PX_CDPOOL.STORE_ID IN ($STOREPATH:promotions$) 
END_XPATH_TO_SQL_STATEMENT 

<!-- ========================================================================  -->
<!--  Get the Unique Promotion By Code           							   -->
<!--                                                                           -->
<!--  @param CODE                                                       -->
<!--     The unique promotion code of the Promotion.                           -->
<!--===========================================================================-->

BEGIN_SQL_STATEMENT
  name=IBM_Select_PX_PROMOTION_By_UniqueCode 
  base_table=PX_PROMOTION 
  sql=  
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION$
    FROM 
        PX_PROMOTION 
        INNER JOIN PX_CDPROMO ON PX_PROMOTION.PX_PROMOTION_ID=PX_CDPROMO.PX_PROMOTION_ID 
        LEFT JOIN PX_CDPOOL ON PX_CDPOOL.PX_CDPOOL_ID=PX_CDPROMO.PX_CDPOOL_ID 
    WHERE 
        PX_CDPOOL.CODE IN (?CODE?)
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$) 
END_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the Promotion(s)                                                     -->
<!--                                                                           -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
    WHERE
        PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3,5)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get all the Promotions that do not belong to any folder                  -->
<!--                                                                           -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotions[NoParentFolder]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
    WHERE
        PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3,5)
        AND NOT EXISTS (SELECT 1 
                        FROM   FOLDERITEM, FOLDER
                        WHERE  FOLDERITEM.FOLDERITEMTYPE='PromotionType'
                        AND    PX_PROMOTION.PX_PROMOTION_ID=FOLDERITEM.REFERENCE_ID
                        AND    FOLDER.STOREENT_ID IN ($STOREPATH:promotions$)
                        AND    FOLDER.TYPE = 'IBM_PromotionFolder'
                        AND    FOLDERITEM.FOLDER_ID = FOLDER.FOLDER_ID)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the active Promotions with redemption limits on the site             -->
<!--                                                                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion+IBM_Admin_Limits
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$
    FROM
        PX_PROMOTION 
    WHERE
        PX_PROMOTION.STATUS IN (1,5)
        AND (PX_PROMOTION.PERORDLMT > 0 or PX_PROMOTION.PERSHOPPERLMT > 0 OR PX_PROMOTION.TOTALLMT > 0)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the Promotion(s) having the specified unique id(s) (PX_PROMOTION_ID  -->
<!--  in PX_PROMOTION table)                                                   -->
<!--                                                                           -->
<!--  @param UniqueID                                                          -->
<!--     The identifier(s) for which to retrieve the Promotion                 -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[PromotionIdentifier[(UniqueID=)]]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$ 
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID IN (?UniqueID?)
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3,5,6)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the Promotion(s) having the specified unique id(s) (PX_PROMOTION_ID  -->
<!--  in PX_PROMOTION table) and status                                        -->
<!--                                                                           -->
<!--  @param UniqueID                                                          -->
<!--     The identifier(s) for which to retrieve the Promotion                 -->
<!--  @param Status                                                            -->
<!--     The status of the Promotion                                           -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[PromotionIdentifier[(UniqueID=)] and (Status=)]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$ 
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID IN (?UniqueID?)
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (?Status?)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the Promotion(s) having the specified unique id(s) (PX_PROMOTION_ID  -->
<!--  in PX_PROMOTION table) and with the specified access profile             -->
<!--  IBM_Admin_PromotionElements                                              -->
<!--                                                                           -->
<!--  @param UniqueID                                                          -->
<!--     The identifier(s) for which to retrieve the Promotion                 -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--  @param Control:LANGUAGES                                                 -->
<!--     The language for which to retrieve the promotion description .This    --> 
<!--     parameter is retrieved from within the business context.              -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[PromotionIdentifier[(UniqueID=)]]+IBM_Admin_PromotionElements
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_SUMMARY$, 
        PX_ELEMENT.$COLS:PX_ELEMENT$,       
        PX_ELEMENTNVP.$COLS:PX_ELEMENTNVP$        
    FROM
        PX_PROMOTION 
        LEFT JOIN PX_ELEMENT ON PX_PROMOTION.PX_PROMOTION_ID=PX_ELEMENT.PX_PROMOTION_ID
        LEFT JOIN PX_ELEMENTNVP ON PX_ELEMENT.PX_ELEMENT_ID=PX_ELEMENTNVP.PX_ELEMENT_ID
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID IN (?UniqueID?)
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3,5,6)
    ORDER BY PX_ELEMENT.PX_ELEMENT_ID
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================================  -->
<!--  Get the PX_CDUSAGE By ORDERS_ID and PX_CDPOOL_ID                         -->
<!--                                                                           -->
<!--  @param ORDERS_ID                                                         -->
<!--     The order id which use the promotion.                                 -->
<!--  @param PX_CDPOOL_ID                                                      -->
<!--     The promotion code id                     .                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDUSAGE[(ORDERS_ID=) AND (PX_CDPOOL_ID=)]+IBM_Admin_All
  base_table=PX_CDUSAGE 
  sql=  
    SELECT 
        PX_CDUSAGE.$COLS:PX_CDUSAGE$
    FROM 
        PX_CDUSAGE 
    WHERE 
        PX_CDUSAGE.PX_CDPOOL_ID IN (?PX_CDPOOL_ID?)
        AND PX_CDUSAGE.ORDERS_ID IN (?ORDERS_ID?)
END_XPATH_TO_SQL_STATEMENT 

<!-- ========================================================================  -->
<!--  Get the PX_CDPROMO By PX_PROMOTION_ID and PX_CDPOOL_ID                   -->
<!--                                                                           -->
<!--  @param PX_PROMOTION_ID                                                   -->
<!--     The promotion id of the promotion which uses the code.	               -->
<!--  @param PX_CDPOOL_ID                                                      -->
<!--     The promotion code id of the code.   				                   -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDPROMO[PX_PROMOTION_ID= AND PX_CDPOOL_ID=]+IBM_Admin_All
  base_table=PX_CDPROMO 
  sql=  
    SELECT 
        PX_CDPROMO.$COLS:PX_CDPROMO$
    FROM 
        PX_CDPROMO
		LEFT JOIN PX_PROMOTION ON PX_CDPROMO.PX_PROMOTION_ID=PX_PROMOTION.PX_PROMOTION_ID
		LEFT JOIN PX_CDPOOL ON PX_CDPROMO.PX_CDPOOL_ID=PX_CDPOOL.PX_CDPOOL_ID
    WHERE 
		PX_PROMOTION.PX_PROMOTION_ID = ?PX_PROMOTION_ID?
		AND PX_CDPOOL.PX_CDPOOL_ID = ?PX_CDPOOL_ID?                
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the PX_CDPROMO By PX_PROMOTION_ID and PX_CDPOOL_ID                   -->
<!--                                                                           -->
<!--  @param PX_CDPOOL_ID                                                      -->
<!--     The promotion code id of the code.   				                   -->
<!--  @param STATUS                                                            -->
<!--     The status of the px_cdpromo.       				                   -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDPROMO[PX_CDPOOL_ID= AND (STATUS=)]+IBM_Admin_All
  base_table=PX_CDPROMO 
  sql=  
    SELECT 
        PX_CDPROMO.$COLS:PX_CDPROMO$
    FROM 
        PX_CDPROMO
		LEFT JOIN PX_CDPOOL ON PX_CDPROMO.PX_CDPOOL_ID=PX_CDPOOL.PX_CDPOOL_ID
    WHERE 
		PX_CDPOOL.PX_CDPOOL_ID = ?PX_CDPOOL_ID? 
		AND PX_CDPROMO.STATUS IN (?STATUS?)               
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the PX_CDPROMO By PX_PROMOTION_ID                                    -->
<!--                                                                           -->
<!--  @param PX_PROMOTION_ID                                                   -->
<!--     The promotion id of the promotion which uses the code.	               -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDPROMO[PX_PROMOTION_ID=]+IBM_Admin_All
  base_table=PX_CDPROMO 
  sql=  
    SELECT 
        PX_CDPROMO.$COLS:PX_CDPROMO$
    FROM 
        PX_CDPROMO
    WHERE 
		PX_CDPROMO.PX_PROMOTION_ID = ?PX_PROMOTION_ID?            
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the PX_PROMOTION By UNIQUE_CODE, PROMOTION_STATUS, PX_CDPROMO_STATUS -->
<!--  and PX_CDPOOL_STATUS                                                     -->
<!--  @param UNIQUE_CODE                                                       -->
<!--     The unique promotion code of the Promotion.                           -->
<!--  @param PROMOTION_STATUS                                                  -->
<!--     The status of promotion                   .                           -->
<!--  @param PX_CDPROMO_STATUS                                                 -->
<!--     The status of PX_CDPROMO                  .                           -->
<!--  @param PX_CDPOOL_STATUS                                                  -->
<!--     The status of PX_CDPOOL                   .                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_PROMOTION[(UNIQUE_CODE=) AND (PROMOTION_STATUS=) AND (PX_CDPROMO_STATUS=) AND (PX_CDPOOL_STATUS=)]+IBM_Admin_All
  base_table=PX_PROMOTION 
  sql=  
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION$,
        PX_CDSPEC.$COLS:PX_CDSPEC$,
        PX_CDPROMO.$COLS:PX_CDPROMO$,
        PX_CDPOOL.$COLS:PX_CDPOOL$,
        PX_CDUSAGE.$COLS:PX_CDUSAGE$
    FROM 
        PX_PROMOTION 
        INNER JOIN PX_CDPROMO ON PX_PROMOTION.PX_PROMOTION_ID=PX_CDPROMO.PX_PROMOTION_ID 
        LEFT JOIN PX_CDPOOL ON PX_CDPOOL.PX_CDPOOL_ID=PX_CDPROMO.PX_CDPOOL_ID 
        LEFT JOIN PX_CDUSAGE ON PX_CDUSAGE.PX_CDPOOL_ID=PX_CDPOOL.PX_CDPOOL_ID
        LEFT JOIN PX_CDSPEC ON PX_CDSPEC.PX_PROMOTION_ID=PX_PROMOTION.PX_PROMOTION_ID 
    WHERE 
        PX_CDPOOL.CODE IN (?UNIQUE_CODE?)
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (?PROMOTION_STATUS?) 
        AND PX_CDPROMO.STATUS IN (?PX_CDPROMO_STATUS?) 
        AND PX_CDPOOL.STATUS IN (?PX_CDPOOL_STATUS?) 
END_XPATH_TO_SQL_STATEMENT 

<!-- ========================================================================  -->
<!--  Get the PX_PROMOTION By ORDERS_ID                                        -->
<!--                                                                           -->
<!--  @param ORDERS_ID                                                         -->
<!--     The order id which use the promotion.                                 -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_PROMOTION[(ORDERS_ID=)]+IBM_Admin_All
  base_table=PX_PROMOTION 
  sql=  
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION$,
        PX_CDSPEC.$COLS:PX_CDSPEC$,
        PX_CDPROMO.$COLS:PX_CDPROMO$,
        PX_CDPOOL.$COLS:PX_CDPOOL$,
        PX_CDUSAGE.$COLS:PX_CDUSAGE$
    FROM 
        PX_PROMOTION 
        INNER JOIN PX_CDPROMO ON PX_PROMOTION.PX_PROMOTION_ID=PX_CDPROMO.PX_PROMOTION_ID 
        LEFT JOIN PX_CDPOOL ON PX_CDPOOL.PX_CDPOOL_ID=PX_CDPROMO.PX_CDPOOL_ID 
        LEFT JOIN PX_CDUSAGE ON PX_CDUSAGE.PX_CDPOOL_ID=PX_CDPOOL.PX_CDPOOL_ID
        LEFT JOIN PX_CDSPEC ON PX_CDSPEC.PX_PROMOTION_ID=PX_PROMOTION.PX_PROMOTION_ID 
    WHERE 
        PX_CDUSAGE.ORDERS_ID = (?ORDERS_ID?)
		AND PX_CDPROMO.STATUS = 1
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$) 
END_XPATH_TO_SQL_STATEMENT 

<!-- ========================================================================  -->
<!--  Get the Promotion(s) that has its ElementType and its Id NVP matches     -->
<!--  the specified ElementType and Id value.                                  -->
<!--                                                                           -->
<!--  @param ElementType                                                       -->
<!--     The ElementType of the row in the PX_ELEMENT table                    -->
<!--  @param Value                                                             -->
<!--     The Value of the row in the PX_ELEMENTNVP table with its name as Id   -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[Element[(ElementType=) and ElementVariable[(Value=)]]]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        INNER JOIN PX_ELEMENT ON PX_PROMOTION.PX_PROMOTION_ID=PX_ELEMENT.PX_PROMOTION_ID AND PX_ELEMENT.TYPE IN (?ElementType?)
        INNER JOIN PX_ELEMENTNVP ON PX_ELEMENT.PX_ELEMENT_ID=PX_ELEMENTNVP.PX_ELEMENT_ID
    WHERE
        PX_ELEMENTNVP.NAME IN ('Id')
        AND PX_ELEMENTNVP.VALUE IN (?Value?)
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3)

END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the Promotion(s) of the specified type. Possible types include:      -->
<!--  0: This promotion is applicable to people who belong to one or more of   -->
<!--  the targeted customer profiles. 										   -->
<!--  When the targeted profile file list is empty, it applies to everyone.    -->
<!--  1: This promotion is applicable only to those to whom it has been        -->
<!--  explicitly granted, that is, this promotion is a coupon promotion.       -->
<!--                                                                           -->
<!--  @param CouponRequired                                                    -->
<!--     The type for which to retrieve the Promotion.                         -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[CouponRequired=]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$ 
    FROM
        PX_PROMOTION 
        INNER JOIN PX_PROMOAUTH ON PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
    WHERE
        PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3)
		AND PX_PROMOTION.TYPE = ?CouponRequired?
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================= -->
<!--  Get the Promotion(s) of the specified type that match the specified 	   -->
<!--  search criteria. Possible promotion types include:                       -->
<!--  0: This promotion is applicable to people who belong to one or more of   -->
<!--  the targeted customer profiles. 										   -->
<!--  When the targeted profile file list is empty, it applies to everyone.    -->
<!--  1: This promotion is applicable only to those to whom it has been        -->
<!--  explicitly granted, that is, this promotion is a coupon promotion.       -->
<!--                                                                           -->
<!--  @param CouponRequired                                                    -->
<!--     The type for which to retrieve the Promotion.                         -->
<!--  @param ATTR_CNDS                                                         -->
<!--     The search criteria.                                                  -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[CouponRequired= and search()]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$ 
    FROM
        PX_PROMOAUTH, PX_PROMOTION, $ATTR_TBLS$
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        AND PX_PROMOTION.STATUS IN (0,1,3)
        AND PX_PROMOTION.TYPE = ?CouponRequired?
        AND PX_PROMOTION.$ATTR_CNDS$
   ORDER BY
        PX_PROMOTION.PX_PROMOTION_ID
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the Promotion(s) that match the specified search criteria.           -->
<!--                                                                           -->
<!--  @param ATTR_CNDS                                                         -->
<!--     The search criteria.                                                  -->
<!--  @param STOREPATH:promotions                                              -->
<!--     The stores for which to retrieve the Promotion. This parameter is     -->
<!--     retrieved from within the business context.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[search()]
  base_table=PX_PROMOTION
  className=com.ibm.commerce.promotion.facade.server.services.dataaccess.db.jdbc.PromotionSearchSQLComposer
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$
    FROM
        PX_PROMOAUTH, PX_PROMOTION, $ATTR_TBLS$
    WHERE
        PX_PROMOTION.PX_PROMOTION_ID=PX_PROMOAUTH.PX_PROMOTION_ID
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$)
        $PROMOTION_SEARCH_CNDS$
        AND PX_PROMOTION.$ATTR_CNDS$
   ORDER BY
        PX_PROMOTION.PX_PROMOTION_ID
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the PX_PROMOTION By UNIQUE_CODE                                      -->
<!--  @param UNIQUE_CODE                                                       -->
<!--     The promotion code of the Promotion.                                  -->
<!--  @param STOREENT_ID                                                       -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_PROMOTION[UNIQUE_CODE= AND (STOREENT_ID=)]+IBM_Admin_CheckUniqueCode
  base_table=PX_PROMOTION 
  sql=  
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION$,
        PX_CDSPEC.$COLS:PX_CDSPEC$,
        PX_CDPROMO.$COLS:PX_CDPROMO$,
        PX_CDPOOL.$COLS:PX_CDPOOL$
    FROM 
        PX_PROMOTION 
        INNER JOIN PX_CDPROMO ON PX_PROMOTION.PX_PROMOTION_ID=PX_CDPROMO.PX_PROMOTION_ID 
        INNER JOIN PX_CDPOOL ON PX_CDPOOL.PX_CDPOOL_ID=PX_CDPROMO.PX_CDPOOL_ID 
        INNER JOIN PX_CDSPEC ON PX_CDSPEC.PX_PROMOTION_ID=PX_PROMOTION.PX_PROMOTION_ID 
    WHERE 
        PX_CDPOOL.CODE = ?UNIQUE_CODE?
        AND PX_PROMOTION.STOREENT_ID IN (?STOREENT_ID?)
        AND PX_PROMOTION.STATUS IN (0,1,2,3,5)
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get PX_PROMOTION By CODE_FOR_REFERENCE and STOREENT_ID.                  -->
<!--  @param CODE_FOR_REFERENCE                                                -->
<!--     The promotion code to use to search for the promotions.               -->
<!--  @param STOREENT_ID                                                       -->
<!--     The stores that the promotions may belong to.                         -->
<!--===========================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_PROMOTION[CODE_FOR_REFERENCE= AND (STOREENT_ID=)]+IBM_Admin_CheckUniqueCode
  base_table=PX_PROMOTION 
  sql=  
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_SUMMARY$,
        PX_CDSPEC.$COLS:PX_CDSPEC$,     
        PX_CDPOOL.$COLS:PX_CDPOOL$
    FROM 
        PX_PROMOTION 
        INNER JOIN PX_CDPOOL ON PX_PROMOTION.PX_PROMOTION_ID=PX_CDPOOL.REFERENCE_ID 
        INNER JOIN PX_CDSPEC ON PX_CDSPEC.PX_PROMOTION_ID=PX_PROMOTION.PX_PROMOTION_ID 
    WHERE 
        PX_CDPOOL.CODE = ?CODE_FOR_REFERENCE?
		AND PX_CDPOOL.WORKSPACE IN (?WORKSPACE?)
		AND PX_CDPOOL.STATUS = 1
        AND PX_PROMOTION.STOREENT_ID IN (?STOREENT_ID?)
        AND PX_PROMOTION.STATUS IN (0,1,2,3,5)
END_XPATH_TO_SQL_STATEMENT 

<!-- ========================================================================  -->
<!--  Get the PX_CDUSAGE By UNIQUE_CODE and ORDERS_ID        				   -->
<!--                                                                           -->
<!--  @param ORDERS_ID 														   -->
<!--     The order ID                                                          -->
<!--  @param UNIQUE_CODE	                                                   -->
<!--     The unique promotion code of the Promotion.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDUSAGE[ORDERS_ID= AND UNIQUE_CODE=]+IBM_Admin_All
  base_table=PX_CDUSAGE 
  sql=  
    SELECT 
        PX_CDUSAGE.$COLS:PX_CDUSAGE$,
        PX_CDPOOL.$COLS:PX_CDPOOL$,
        PX_CDPROMO.$COLS:PX_CDPROMO$,
        PX_PROMOTION.$COLS:PX_PROMOTION$,
        PX_CDSPEC.$COLS:PX_CDSPEC$
    FROM 
        PX_CDUSAGE 
        INNER JOIN PX_CDPOOL ON PX_CDUSAGE.PX_CDPOOL_ID=PX_CDPOOL.PX_CDPOOL_ID       
        INNER JOIN PX_CDPROMO ON PX_CDPOOL.PX_CDPOOL_ID=PX_CDPROMO.PX_CDPOOL_ID 
        INNER JOIN PX_PROMOTION ON PX_CDPROMO.PX_PROMOTION_ID=PX_PROMOTION.PX_PROMOTION_ID 
        INNER JOIN PX_CDSPEC ON PX_PROMOTION.PX_PROMOTION_ID=PX_CDSPEC.PX_PROMOTION_ID 
    WHERE 
     	PX_CDUSAGE.ORDERS_ID = ?ORDERS_ID?
        AND PX_CDPOOL.CODE IN (?UNIQUE_CODE?)
END_XPATH_TO_SQL_STATEMENT 

<!-- ========================================================================  -->
<!--  Get PX_CDUSAGE by ORDERS_ID and CODE_FOR_REFERENCE      				   -->
<!--                                                                           -->
<!--  @param ORDERS_ID 														   -->
<!--     The order ID                                                          -->
<!--  @param CODE_FOR_REFERENCE	                                               -->
<!--     The promotion code to use for the corresponding entry.                -->
<!--===========================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDUSAGE[ORDERS_ID= AND CODE_FOR_REFERENCE=]+IBM_Admin_All
  base_table=PX_CDUSAGE 
  sql=  
    SELECT 
        PX_CDUSAGE.$COLS:PX_CDUSAGE$,
        PX_CDPOOL.$COLS:PX_CDPOOL$       
    FROM 
        PX_CDUSAGE 
        INNER JOIN PX_CDPOOL ON PX_CDUSAGE.PX_CDPOOL_ID=PX_CDPOOL.PX_CDPOOL_ID               
    WHERE 
     	PX_CDUSAGE.ORDERS_ID = ?ORDERS_ID?
        AND PX_CDPOOL.CODE = ?CODE_FOR_REFERENCE?
		AND PX_CDPOOL.WORKSPACE IN (?WORKSPACE?)
END_XPATH_TO_SQL_STATEMENT 

<!-- ========================================================================  -->
<!--  Get PX_CDUSAGE by ORDERS_ID                           				   -->
<!--                                                                           -->
<!--  @param ORDERS_ID 														   -->
<!--     The order ID                                                          -->
<!--===========================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDUSAGE[(ORDERS_ID=)]+IBM_Admin_All
  base_table=PX_CDUSAGE 
  sql=  
    SELECT 
        PX_CDUSAGE.$COLS:PX_CDUSAGE$,
        PX_CDPOOL.$COLS:PX_CDPOOL$       
    FROM 
        PX_CDUSAGE 
        INNER JOIN PX_CDPOOL ON PX_CDUSAGE.PX_CDPOOL_ID=PX_CDPOOL.PX_CDPOOL_ID
    WHERE 
     	PX_CDUSAGE.ORDERS_ID = ?ORDERS_ID?      
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the PX_CDUSAGE by PX_CDPOOL_ID                                       -->
<!--                                                                           -->
<!--  @param PX_CDPOOL_ID                                                      -->
<!--     The promotion code id                     .                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDUSAGE[PX_CDPOOL_ID=]+IBM_Admin_All
  base_table=PX_CDUSAGE 
  sql=  
    SELECT 
        PX_CDUSAGE.$COLS:PX_CDUSAGE$
    FROM 
        PX_CDUSAGE 
    WHERE 
        PX_CDUSAGE.PX_CDPOOL_ID = ?PX_CDPOOL_ID?
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get promotion details by calculation code ID.                            -->
<!--                                                                           -->
<!--  @param UniqueID                                                          -->
<!--     The unique calculation code ID. 				                       -->
<!--===========================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[PromotionIdentifier[CalculationCodeIdentifier[(UniqueID=)]]]
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$ 
    FROM
        PX_PROMOTION 
        INNER JOIN CLCDPROMO ON PX_PROMOTION.PX_PROMOTION_ID=CLCDPROMO.PX_PROMOTION_ID
    WHERE
        CLCDPROMO.CALCODE_ID IN (?UniqueID?)
        AND PX_PROMOTION.STOREENT_ID IN ($STOREPATH:promotions$) 
END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get the active Promotions with on the site that has an element of the    -->
<!--  specified Element Type.                                                  -->
<!--                                                                           -->
<!--  @param ElementType                                                       -->
<!--     The ElementType of the row in the PX_ELEMENT table                    -->
<!--===========================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT
  name=/Promotion[Element[(ElementType=)]]+IBM_Admin_Limits
  base_table=PX_PROMOTION
  sql=
    SELECT 
        PX_PROMOTION.$COLS:PX_PROMOTION_PK$
    FROM
        PX_PROMOTION 
        INNER JOIN PX_ELEMENT ON PX_PROMOTION.PX_PROMOTION_ID=PX_ELEMENT.PX_PROMOTION_ID AND PX_ELEMENT.TYPE IN (?ElementType?)
    WHERE
        PX_PROMOTION.STATUS IN (1,5)

END_XPATH_TO_SQL_STATEMENT

<!-- ========================================================================  -->
<!--  Get PX_CDPOOL by CODE and REFERENCE_ID                                   -->
<!--  @param CODE                                                              -->
<!--     The promotion code.                                                   -->
<!--  @param REFERENCE_ID                                                      -->
<!--     The promotion ID(s) of the promotion.                                 -->
<!--===========================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDPOOL[CODE= AND (REFERENCE_ID=)]+IBM_Admin_CheckUniqueCode
  base_table=PX_CDPOOL 
  sql=  
    SELECT 
        PX_CDPOOL.$COLS:PX_CDPOOL$
    FROM 
        PX_CDPOOL          
    WHERE 
        PX_CDPOOL.CODE = ?CODE?
        AND PX_CDPOOL.REFERENCE_ID IN (?REFERENCE_ID?) 
		AND PX_CDPOOL.WORKSPACE IN (?WORKSPACE?)
END_XPATH_TO_SQL_STATEMENT 


<!-- ========================================================================  -->
<!--  Get PX_CDUSAGE by CODE_FOR_REFERENCE      							   -->
<!--                                                                           -->
<!--  @param CODE_FOR_REFERENCE	                                               -->
<!--     The promotion code to use for the corresponding entry.                -->
<!--===========================================================================-->
BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDUSAGE[CODE_FOR_REFERENCE=]+IBM_Admin_All
  base_table=PX_CDUSAGE 
  sql=  
    SELECT 
        PX_CDUSAGE.$COLS:PX_CDUSAGE$,
        PX_CDPOOL.$COLS:PX_CDPOOL$       
    FROM 
        PX_CDUSAGE 
        INNER JOIN PX_CDPOOL ON PX_CDUSAGE.PX_CDPOOL_ID=PX_CDPOOL.PX_CDPOOL_ID               
    WHERE 
        PX_CDPOOL.CODE = ?CODE_FOR_REFERENCE?
		AND PX_CDPOOL.WORKSPACE IN (?WORKSPACE?)
END_XPATH_TO_SQL_STATEMENT 

<!-- ========================================================================  -->
<!--  Get the PX_CDUSAGE By UNIQUE_CODE					      				   -->
<!--                                                                           -->
<!--  @param UNIQUE_CODE	                                                   -->
<!--     The unique promotion code of the Promotion.                           -->
<!--===========================================================================-->

BEGIN_XPATH_TO_SQL_STATEMENT 
  name=/PX_CDUSAGE[UNIQUE_CODE=]+IBM_Admin_All
  base_table=PX_CDUSAGE 
  sql=  
    SELECT 
        PX_CDUSAGE.$COLS:PX_CDUSAGE$,
        PX_CDPOOL.$COLS:PX_CDPOOL$,
        PX_CDPROMO.$COLS:PX_CDPROMO$,
        PX_PROMOTION.$COLS:PX_PROMOTION$,
        PX_CDSPEC.$COLS:PX_CDSPEC$
    FROM 
        PX_CDUSAGE 
        INNER JOIN PX_CDPOOL ON PX_CDUSAGE.PX_CDPOOL_ID=PX_CDPOOL.PX_CDPOOL_ID       
        INNER JOIN PX_CDPROMO ON PX_CDPOOL.PX_CDPOOL_ID=PX_CDPROMO.PX_CDPOOL_ID 
        INNER JOIN PX_PROMOTION ON PX_CDPROMO.PX_PROMOTION_ID=PX_PROMOTION.PX_PROMOTION_ID 
        INNER JOIN PX_CDSPEC ON PX_PROMOTION.PX_PROMOTION_ID=PX_CDSPEC.PX_PROMOTION_ID 
    WHERE 
        PX_CDPOOL.CODE IN (?UNIQUE_CODE?)
END_XPATH_TO_SQL_STATEMENT
