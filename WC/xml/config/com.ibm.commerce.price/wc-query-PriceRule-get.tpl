<!-- TODO: This is a sample query template file. -->
<!-- Please modify to match your implementation. -->

BEGIN_SYMBOL_DEFINITIONS
	
		<!-- PRICERULE table -->
		COLS:PRICERULE = PRICERULE:* 
		COLS:PRICERULE_ID = PRICERULE:PRICERULE_ID
		COLS:PRICERULE_ID_NAME = PRICERULE:PRICERULE_ID,IDENTIFIER
		
		<!-- PRELEMENT table -->
		COLS:PRELEMENT = PRELEMENT:* 
		COLS:PRELEMENT_ID = PRELEMENT:PRELEMENT_ID
		
		<!-- PRELETEMPLATE table -->
		COLS:PRELETEMPLATE = PRELETEMPLATE:*
		
		<!-- PRELETPLTGRP table -->
		COLS:PRELETPLTGRP = PRELETPLTGRP:*
		
		<!-- PRELEMENTATTR table -->
		COLS:PRELEMENTATTR = PRELEMENTATTR:* 
		
END_SYMBOL_DEFINITIONS

<!-- PriceRule -->

<!-- ======================================================================== -->
<!-- XPath: /PriceRule/PriceRuleIdentifier[(UniqueID=)]                   	  -->
<!-- This SQL will return the data of the PriceRule noun for the specified    -->
<!-- unique identifier. Multiple results are returned                         -->
<!-- if multiple identifiers are specified.                                   -->
<!-- AccessProfile: IBM_Admin_Details        								  -->
<!-- @param PriceRuleIdentifier The identifier of the price rule to retrieve.    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceRule/PriceRuleIdentifier[(UniqueID=)]+IBM_Admin_Details 
	base_table=PRICERULE
	sql=
		SELECT 
				PRICERULE.$COLS:PRICERULE$
		FROM
				PRICERULE
		WHERE
				PRICERULE.PRICERULE_ID IN (?UniqueID?)	 AND PRICERULE.MARKFORDELETE = 0
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceRule[PriceRuleIdentifier[ExternalIdentifier[Name=]]]        -->
<!-- This SQL will return the data of the PriceRule noun for the specified    -->
<!-- name.                                    		                          -->
<!-- AccessProfile: IBM_Admin_Details        								  -->
<!-- @param Name The name of the price rule to retrieve.                      -->
<!-- @param Context:StoreID The store for which to retrieve the price rule.   -->
<!--        The parameter is retrieved from within the business context.      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceRule[PriceRuleIdentifier[ExternalIdentifier[Name=]]]+IBM_Admin_Details 
	base_table=PRICERULE
	sql=
		SELECT 
				PRICERULE.$COLS:PRICERULE$
		FROM
				PRICERULE
		WHERE
				PRICERULE.IDENTIFIER IN (?Name?) AND PRICERULE.STOREENT_ID IN ($CTX:STORE_ID$) 	AND PRICERULE.MARKFORDELETE = 0
							
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceRule[PriceRuleIdentifier[ExternalIdentifier[Name= and StoreIdentifier[UniqueID=]]]]        -->
<!-- This SQL will return the data of the PriceRule noun for the specified    -->
<!-- name using store path.                                    		                          -->
<!-- AccessProfile: IBM_Admin_Details        								  -->
<!-- @param Name The name of the price rule to retrieve.                      -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceRule[PriceRuleIdentifier[ExternalIdentifier[Name= and StoreIdentifier[UniqueID=]]]]+IBM_Admin_Details 
	base_table=PRICERULE
	sql=
		SELECT 
				PRICERULE.$COLS:PRICERULE$
		FROM
				PRICERULE
		WHERE
				PRICERULE.IDENTIFIER IN (?Name?) AND PRICERULE.STOREENT_ID IN ($STOREPATH:pricerule$) AND PRICERULE.MARKFORDELETE = 0
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceRule                                                        -->
<!-- This SQL will return the data of the PriceRule noun which is independent -->
<!-- and ready.                                    		                      -->
<!-- AccessProfile: IBM_Admin_AssignablePriceRule        					  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceRule+IBM_Admin_AssignablePriceRule 
	base_table=PRICERULE
	sql=
		SELECT 
				PRICERULE.$COLS:PRICERULE$
		FROM
				PRICERULE
		WHERE
				PRICERULE.DEPENDENT = 0 AND PRICERULE.MARKFORDELETE = 0 AND PRICERULE.STOREENT_ID IN ($STOREPATH:pricerule$) 	
		ORDER BY PRICERULE.IDENTIFIER						
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceRule/PriceRuleIdentifier[(UniqueID=)]                       -->
<!-- This SQL will return the details including element data of the PriceRule -->
<!-- noun for the specified identifier.                                       -->
<!-- AccessProfile: IBM_Admin_PriceRuleElementsDetails        								  -->
<!-- @param PriceRuleIdentifier The identifier of the price rule to retrieve. -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceRule/PriceRuleIdentifier[(UniqueID=)]+IBM_Admin_PriceRuleElementsDetails 
	base_table=PRICERULE
	sql= 
		SELECT 
				PRICERULE.$COLS:PRICERULE$,
				PRELEMENT.$COLS:PRELEMENT$,
				PRELETEMPLATE.$COLS:PRELETEMPLATE$,
				PRELETPLTGRP.$COLS:PRELETPLTGRP$

		FROM
				PRICERULE,PRELEMENT,PRELETEMPLATE,PRELETPLTGRP
		WHERE
				PRICERULE.PRICERULE_ID IN (?UniqueID?) AND
				PRICERULE.PRICERULE_ID = PRELEMENT.PRICERULE_ID AND
				PRELEMENT.PRELETEMPLATE_ID = PRELETEMPLATE.PRELETEMPLATE_ID AND
				PRELETEMPLATE.PRELETPLTGRP_ID = PRELETPLTGRP.PRELETPLTGRP_ID AND PRICERULE.MARKFORDELETE = 0

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PRELEMENTATTR[PRELEMENT_ID=]                                     -->
<!-- This SQL will return the element attribute data for the specified element-->
<!-- identifier.                                                              -->
<!-- AccessProfile: IBM_Admin_Details        								  -->
<!-- @param PRELEMENT_ID The identifier of the element.                       -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PRELEMENTATTR[PRELEMENT_ID=]+IBM_Admin_Details
	base_table=PRELEMENTATTR
	sql=
		SELECT 
				PRELEMENTATTR.$COLS:PRELEMENTATTR$
		FROM
				PRELEMENTATTR
		WHERE
				PRELEMENTATTR.PRELEMENT_ID = ?PRELEMENT_ID?
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PRELEMENT[PRICERULE_ID= and NAME=]                               -->
<!-- This SQL will return the element id for the specified element name.      -->
<!-- AccessProfile: IBM_Admin_Summary        								  -->
<!-- @param PRICERULE_ID The identifier of the price rule.                    -->
<!-- @param NAME The name of the price rule element.                          -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
    name=/PRELEMENT[PRICERULE_ID= and NAME=]+IBM_Admin_Summary	
	base_table=PRELEMENT
	sql=
		SELECT 
				PRELEMENT.$COLS:PRELEMENT_ID$
		FROM
				PRELEMENT
		WHERE
				PRELEMENT.PRICERULE_ID = ?PRICERULE_ID?  AND
				PRELEMENT.IDENTIFIER = ?NAME?
					
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceRule                                                        -->
<!-- This SQL will return the price rule in a specific store including its    -->
<!-- asset stores.                                                            -->
<!-- AccessProfile: IBM_Admin_Summary        								  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  	name=/PriceRule+IBM_Admin_Summary
  	base_table=PRICERULE
  	sql=
    	SELECT 
        		PRICERULE.$COLS:PRICERULE$
    	FROM
        		PRICERULE
    	WHERE
        		PRICERULE.STOREENT_ID IN ($STOREPATH:pricerule$) AND PRICERULE.MARKFORDELETE = 0
        ORDER BY PRICERULE.IDENTIFIER
    paging_count
  	sql =
    SELECT  
        COUNT(*) as countrows	  
		FROM
        		PRICERULE
    	WHERE
        		PRICERULE.STOREENT_ID IN ($STOREPATH:pricerule$) AND PRICERULE.MARKFORDELETE = 0
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath:/PriceRule[PriceRuleElement[PriceRuleElementIdentifier[(UniqueID=)]]] -->
<!-- This SQL will return the price rule for a specific element identifier.   -->
<!-- AccessProfile: IBM_Admin_PriceRuleElementsDetails        				  -->
<!-- @param PriceRuleElementIdentifier The identifier of the element.         -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceRule[PriceRuleElement[PriceRuleElementIdentifier[(UniqueID=)]]]+IBM_Admin_PriceRuleElementsDetails
	base_table=PRICERULE
	sql=
		SELECT 
		    	PRICERULE.$COLS:PRICERULE_ID$,
				PRELEMENT.$COLS:PRELEMENT$,
				PRELETEMPLATE.$COLS:PRELETEMPLATE$,
				PRELETPLTGRP.$COLS:PRELETPLTGRP$
		FROM
				PRICERULE, PRELEMENT, PRELETEMPLATE, PRELETPLTGRP
		WHERE
		    	PRICERULE.PRICERULE_ID = PRELEMENT.PRICERULE_ID AND 
				PRELEMENT.PRELEMENT_ID in ( ?UniqueID? ) AND 
				PRELETEMPLATE.PRELETEMPLATE_ID = PRELEMENT.PRELETEMPLATE_ID 
				AND PRELETPLTGRP.PRELETPLTGRP_ID = PRELETEMPLATE.PRELETPLTGRP_ID AND PRICERULE.MARKFORDELETE = 0
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath:/PriceRuleElementTemplate[PriceRuleElementTemplateIdentifier[ExternalIdentifier[Name= and PriceRuleElementTemplateGroup=]]] -->
<!-- This SQL will return the element template data for a specific element.   -->
<!-- AccessProfile: IBM_Admin_PriceRuleElementsDetails        				  -->
<!-- @param Name The name of the price rule element template.                 -->
<!-- @param PriceRuleElementTemplateGroup The element template group.         -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceRuleElementTemplate[PriceRuleElementTemplateIdentifier[ExternalIdentifier[Name= and PriceRuleElementTemplateGroup=]]]+IBM_Admin_Details
	base_table=PRELETEMPLATE
	sql=
		SELECT 
				PRELETEMPLATE.$COLS:PRELETEMPLATE$,
				PRELETPLTGRP.$COLS:PRELETPLTGRP$
		FROM
				PRELETEMPLATE, PRELETPLTGRP
		WHERE
				PRELETEMPLATE.IDENTIFIER = ?Name? AND 
				PRELETEMPLATE.PRELETPLTGRP_ID = ?PriceRuleElementTemplateGroup? AND 
				PRELETEMPLATE.PRELETPLTGRP_ID = PRELETPLTGRP.PRELETPLTGRP_ID

END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath:/PriceRuleElementTemplate[PriceRuleElementTemplateIdentifier[ExternalIdentifier[Name= and PriceRuleElementTemplateGroup=]]] -->
<!-- This SQL will return the children element for a specific price rule      -->
<!-- and parent element.        											  -->
<!-- AccessProfile: IBM_Admin_Details        				                  -->
<!-- @param PRICERULE_ID The price rule id.					                  -->
<!-- @param PARENT The parent element name.         						  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceRuleElement[PRICERULE_ID= and PARENT=]+IBM_Admin_Details
	base_table=PRELEMENT
	sql=
		SELECT 
				PRELEMENT.$COLS:PRELEMENT$,
				PRELETEMPLATE.$COLS:PRELETEMPLATE$,
				PRELETPLTGRP.$COLS:PRELETPLTGRP$
		FROM
				PRELEMENT, PRELETEMPLATE, PRELETPLTGRP
		WHERE
				PRELEMENT.PRICERULE_ID in ( ?PRICERULE_ID? ) AND
				PRELEMENT.PARENT = ?PARENT? AND  
				PRELETEMPLATE.PRELETEMPLATE_ID = PRELEMENT.PRELETEMPLATE_ID 
				AND PRELETPLTGRP.PRELETPLTGRP_ID = PRELETEMPLATE.PRELETPLTGRP_ID
		ORDER BY SEQUENCE ASC
								
END_XPATH_TO_SQL_STATEMENT


<!-- ======================================================================== -->
<!-- XPath:/PriceRuleElementTemplate[PriceRuleElementTemplateIdentifier[ExternalIdentifier[Name= and PriceRuleElementTemplateGroup=]]] -->
<!-- This SQL will return the root element for a specific price rule.         -->
<!-- AccessProfile: IBM_Admin_Details        				                  -->
<!-- @param PRICERULE_ID The price rule id.					                  -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/PriceRuleElement[PRICERULE_ID= and PARENT=NULL]+IBM_Admin_Details
	base_table=PRELEMENT
	sql=
		SELECT 
				PRELEMENT.$COLS:PRELEMENT$,
				PRELETEMPLATE.$COLS:PRELETEMPLATE$,
				PRELETPLTGRP.$COLS:PRELETPLTGRP$
		FROM
				PRELEMENT, PRELETEMPLATE, PRELETPLTGRP
		WHERE
				PRELEMENT.PRICERULE_ID in ( ?PRICERULE_ID? ) AND
				PRELEMENT.PARENT IS NULL AND  
				PRELETEMPLATE.PRELETEMPLATE_ID = PRELEMENT.PRELETEMPLATE_ID 
				AND PRELETPLTGRP.PRELETPLTGRP_ID = PRELETEMPLATE.PRELETPLTGRP_ID
		ORDER BY SEQUENCE ASC
								
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceRule[search()] 											  -->
<!-- This SQL will return the price rule that match the specified search      -->
<!-- criteria.   															  -->
<!-- AccessProfile: IBM_Admin_Summary        				                  -->
<!-- @param PriceRuleElementIdentifier The identifier of the element.         -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- @param ATTR_CNDS The search criteria.                                    -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  	name=/PriceRule[search()]
  	base_table=PRICERULE
  	sql=
    	SELECT 
        		PRICERULE.$COLS:PRICERULE$ 
   	 	FROM
        		PRICERULE,$ATTR_TBLS$
    	WHERE
        		PRICERULE.STOREENT_ID IN ($STOREPATH:pricerule$) AND PRICERULE.MARKFORDELETE = 0 
        		AND PRICERULE.$ATTR_CNDS$
    	ORDER BY PRICERULE.IDENTIFIER
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceRule[PriceRuleElement[ElementAttribute[(Name=) and Value=] and ElementTemplateIdentifier[UniqueID=]]]  -->
<!-- This SQL will return the price rule that contains a price rule element       -->
<!-- with specific name/value attribute.   															  -->
<!-- @param Name The price rule element attribute name.         -->
<!-- @param Value The price rule element attribute value.       -->
<!-- @param UniqueID The price rule element template unique identifier.       -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  	name=/PriceRule[PriceRuleElement[ElementAttribute[(Name=) and Value=] and ElementTemplateIdentifier[UniqueID=]]]+IBM_Admin_Details
  	base_table=PRICERULE
  	className=com.ibm.commerce.price.facade.server.services.dataaccess.db.jdbc.PriceRuleReferenceSQLComposer
  	param=psMark_ANDPSPriceRuleReference
  	sql=
    	SELECT 
        		PRICERULE.$COLS:PRICERULE$ 
   	 	FROM
        		PRICERULE,PRELEMENT,PRELEMENTATTR
    	WHERE
        		PRELEMENT.PRELEMENT_ID=PRELEMENTATTR.PRELEMENT_ID AND
        		PRICERULE.PRICERULE_ID=PRELEMENT.PRICERULE_ID AND
        		PRICERULE.STOREENT_ID IN ($STOREPATH:pricerule$) AND PRICERULE.MARKFORDELETE = 0 ANDPSPriceRuleReference
    	ORDER BY PRICERULE.IDENTIFIER
    paging_count
  	sql =
    	SELECT 
        		COUNT(DISTINCT PRICERULE.PRICERULE_ID) as countrows
   	 	FROM
        		PRICERULE,PRELEMENT,PRELEMENTATTR
    	WHERE
        		PRELEMENT.PRELEMENT_ID=PRELEMENTATTR.PRELEMENT_ID AND
        		PRICERULE.PRICERULE_ID=PRELEMENT.PRICERULE_ID AND
        		PRICERULE.STOREENT_ID IN ($STOREPATH:pricerule$) AND PRICERULE.MARKFORDELETE = 0 ANDPSPriceRuleReference
END_XPATH_TO_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- XPath: /PriceRule[PriceRuleElement[ElementAttribute[(Name=) and Value=] and ElementTemplateIdentifier[UniqueID=]]]  -->
<!-- This SQL will return the price rule that contains a price rule element from all store.
<!-- The one above only fetches those in current context store path for price rule	-->
<!-- with specific name/value attribute.   															  -->
<!-- @param Name The price rule element attribute name.         -->
<!-- @param Value The price rule element attribute value.       -->
<!-- @param UniqueID The price rule element template unique identifier.       -->
<!-- The access profiles that apply to this SQL are: IBM_Admin_Details        -->
<!-- ======================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
  	name=/PriceRule[PriceRuleElement[ElementAttribute[(Name=) and Value=] and ElementTemplateIdentifier[UniqueID=]]]+IBM_Admin_Summary
  	base_table=PRICERULE
  	className=com.ibm.commerce.price.facade.server.services.dataaccess.db.jdbc.PriceRuleReferenceSQLComposer
  	param=psMark_ANDPSPriceRuleReference
  	sql=
    	SELECT 
        		PRICERULE.$COLS:PRICERULE$ 
   	 	FROM
        		PRICERULE,PRELEMENT,PRELEMENTATTR
    	WHERE
        		PRELEMENT.PRELEMENT_ID=PRELEMENTATTR.PRELEMENT_ID AND
        		PRICERULE.PRICERULE_ID=PRELEMENT.PRICERULE_ID AND PRICERULE.MARKFORDELETE = 0 ANDPSPriceRuleReference
    	ORDER BY PRICERULE.IDENTIFIER
    paging_count
  	sql =
    	SELECT 
        		COUNT(DISTINCT PRICERULE.PRICERULE_ID) as countrows
   	 	FROM
        		PRICERULE,PRELEMENT,PRELEMENTATTR
    	WHERE
        		PRELEMENT.PRELEMENT_ID=PRELEMENTATTR.PRELEMENT_ID AND
        		PRICERULE.PRICERULE_ID=PRELEMENT.PRICERULE_ID AND PRICERULE.MARKFORDELETE = 0 ANDPSPriceRuleReference
END_XPATH_TO_SQL_STATEMENT
<!-- ======================================================================== -->
<!-- This associated SQL will return the summary of the price rule.           -->
<!-- ======================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_Pricerule_Name
	base_table=PRICERULE
	sql=
		SELECT 
				PRICERULE.$COLS:PRICERULE$
		FROM
				PRICERULE
		WHERE
				PRICERULE.PRICERULE_ID in ($ENTITY_PKS$)
	  								
END_ASSOCIATION_SQL_STATEMENT

<!-- ======================================================================== -->
<!-- Price Rule Summary Details Access Profile                                -->
<!-- This profile returns the summary of the price rule.                      -->
<!-- ======================================================================== -->
BEGIN_PROFILE 
    name=IBM_Admin_Summary
    BEGIN_ENTITY 
    	base_table=PRICERULE
    	className=com.ibm.commerce.foundation.internal.server.services.dataaccess.graphbuilderservice.DefaultGraphComposer
    	associated_sql_statement=IBM_Pricerule_Name         
    END_ENTITY
END_PROFILE