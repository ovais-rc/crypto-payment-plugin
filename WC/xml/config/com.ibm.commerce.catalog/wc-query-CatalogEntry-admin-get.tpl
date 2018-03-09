BEGIN_SYMBOL_DEFINITIONS

	<!-- CATENTRY table -->
	COLS:CATENTRY=CATENTRY:*
	COLS:CATENTRY_ID=CATENTRY:CATENTRY_ID
	COLS:CATENTRY:PARTNUMBER=CATENTRY:PARTNUMBER
	COLS:CATENTRY:MEMBER_ID=CATENTRY:MEMBER_ID
	COLS:CATENTRY:CATENTTYPE_ID=CATENTRY:CATENTTYPE_ID
	COLS:CATENTRY:MARKFORDELETE=CATENTRY:MARKFORDELETE
	COLS:CATENTRY:BASEITEM_ID=CATENTRY:BASEITEM_ID
	COLS:CATENTRY:ITEMSPC_ID=CATENTRY:ITEMSPC_ID
	COLS:CATENTRY:STARTDATE=CATENTRY:STARTDATE
	COLS:CATENTRY:ENDDATE=CATENTRY:ENDDATE
	
	
	COLS:CATENTRY_BASE_ATTRS=CATENTRY:CATENTRY_ID,MFNAME
	
	
	<!-- CATALOG table -->
	COLS:CATALOG=CATALOG:*
	COLS:CATALOG_ID=CATALOG:CATALOG_ID
	
	<!-- CATGROUP table -->
	COLS:CATGROUP=CATGROUP:*
	COLS:CATGROUP_ID=CATGROUP:CATGROUP_ID
	COLS:CATGROUP:IDENTIFIER=CATGROUP:IDENTIFIER
	COLS:CATGROUP:MEMBER_ID=CATGROUP:MEMBER_ID
	
	
	<!-- STORECGRP table -->
	COLS:STORECGRP=STORECGRP:*
	COLS:STORECGRP:STOREENT_ID=STORECGRP:STOREENT_ID
	COLS:STORECGRP:CATGROUP_ID=STORECGRP:CATGROUP_ID		
	
	<!-- Other tables -->
	COLS:INVENTORY=INVENTORY:*
	COLS:STOREITEM=STOREITEM:*
	COLS:ATTRIBUTE=ATTRIBUTE:*
	COLS:ATTRIBUTE_ID=ATTRIBUTE:ATTRIBUTE_ID
	COLS:ATTRVALUE=ATTRVALUE:*
	
	<!-- CATENTDESC table -->
	COLS:CATENTDESC=CATENTDESC:*
	COLS:CATENTDESC:CATENTRY_ID=CATENTDESC:CATENTRY_ID
	COLS:CATENTDESC:LANGUAGE_ID=CATENTDESC:LANGUAGE_ID
	COLS:CATENTDESC:NAME=CATENTDESC:NAME
	COLS:CATENTDESC:THUMBNAIL=CATENTDESC:THUMBNAIL
	COLS:CATENTDESC:SHORTDESCRIPTION=CATENTDESC:SHORTDESCRIPTION
	COLS:CATENTDESC:PUBLISHED=CATENTDESC:PUBLISHED	
	
	COLS:CATENTREL=CATENTREL:*
	COLS:CATENTRY_ID_CHILD=CATENTREL:CATENTRY_ID_CHILD
	COLS:CATENTRY_ID_PARENT=CATENTREL:CATENTRY_ID_PARENT
	COLS:CATENTATTR=CATENTATTR:*
	COLS:CATENTSHIP=CATENTSHIP:*
	COLS:CATGPENREL=CATGPENREL:*
	COLS:CATGPENREL:CATENTRY_ID=CATGPENREL:CATENTRY_ID
	COLS:CATCLSFCOD=CATCLSFCOD:*
	COLS:CATCONFINF=CATCONFINF:*
	COLS:CATENCALCD=CATENCALCD:*
	COLS:DKPREDEFCONF=DKPREDEFCONF:*	
	COLS:DKPDCCATENTREL=DKPDCCATENTREL:*
	COLS:DKPDCCOMPLIST=DKPDCCOMPLIST:*
	COLS:DKPDCREL=DKPDCREL:*
	COLS:DISPENTREL=DISPENTREL:*
	COLS:CATENTTYPE=CATENTTYPE:*
	COLS:LISTPRICE=LISTPRICE:*
	COLS:BASEITEM=BASEITEM:*
	COLS:OFFER=OFFER:*
	COLS:ITEMSPC=ITEMSPC:*
	
	COLS:MASSOCCECE=MASSOCCECE:*
	COLS:CATENTRY_ID_FROM=MASSOCCECE:CATENTRY_ID_FROM
	COLS:CATENTRY_ID_TO=MASSOCCECE:CATENTRY_ID_TO
	COLS:MASSOCCECE_ID=MASSOCCECE:MASSOCCECE_ID	
	
	COLS:CATALOGDSC=CATALOGDSC:*
	COLS:CATTOGRP=CATTOGRP:*
	COLS:CATGRPREL=CATGRPREL:*
	COLS:CATCNTR=CATCNTR:*
	COLS:CATGRPTPC=CATGRPTPC:*
	COLS:CATGRPPS=CATGRPPS:*
	
	COLS:CATGPCALCD=CATGPCALCD:*
	COLS:CATGRPATTR=CATGRPATTR:*
	COLS:CATGRPDESC=CATGRPDESC:*
	COLS:MASSOCGPGP=MASSOCGPGP:*
	COLS:MASSOC=MASSOC:*

	COLS:MASSOCTYPE=MASSOCTYPE:*
	COLS:ITEMVERSN=ITEMVERSN:*
	COLS:VERSIONSPC=VERSIONSPC:*
	COLS:ITEMTYPE=ITEMTYPE:*
	COLS:BASEITMDSC=BASEITMDSC:*
		
	COLS:STORECAT=STORECAT:*
	<!-- STORECENT table -->
	COLS:STORECENT=STORECENT:*
	COLS:STORECENT:STOREENT_ID=STORECENT:STOREENT_ID
	COLS:STORECENT:CATENTRY_ID=STORECENT:CATENTRY_ID		


	<!-- ATCHREL table -->
	COLS:ATCHREL=ATCHREL:*
	COLS:ATCHREL:ATCHTGT_ID=ATCHREL:ATCHTGT_ID
	COLS:ATCHREL:SEQUENCE=ATCHREL:SEQUENCE
	
	<!-- ATCHRLUS table -->
	COLS:ATCHRLUS=ATCHRLUS:*
	COLS:ATCHRLUS:IDENTIFIER=ATCHRLUS:IDENTIFIER
	
	<!-- ATCHRELDSC table -->
	COLS:ATCHRELDSC=ATCHRELDSC:*
	COLS:ATCHRELDSC:NAME=ATCHRELDSC:NAME
	COLS:ATCHRELDSC:SHORTDESCRIPTION=ATCHRELDSC:SHORTDESCRIPTION
	COLS:ATCHRELDSC:LONGDESCRIPTION=ATCHRELDSC:LONGDESCRIPTION

    <!-- ATTR table -->
	COLS:ATTR=ATTR:*
    
    <!-- ATTRVAL table -->	
	COLS:ATTRVAL=ATTRVAL:*
    
    <!-- ATTRDESC table -->		
	COLS:ATTRDESC=ATTRDESC:*
    
    <!-- ATTRVALDESC table -->		
	COLS:ATTRVALDESC=ATTRVALDESC:*
	
    <!-- CATENTRYATTR table -->		
	COLS:CATENTRYATTR=CATENTRYATTR:*
	COLS:CATENTRYATTR:CATENTRY_ID=CATENTRYATTR:CATENTRY_ID
	
	
	<!-- CATENTSUBS table -->
	COLS:CATENTSUBS=CATENTSUBS:*
	
	<!-- FACET table -->
	COLS:FACET=FACET:*  
	
	<!-- OFFERPRICE table -->
	COLS:OFFERPRICE=OFFERPRICE:*


	<!-- Calculation code tables -->
	COLS:CALCODE=CALCODE:*
	
	<!-- CATENTDESCOVR table -->
	COLS:CATENTDESCOVR=CATENTDESCOVR:*
		
  <!-- CATENTRY_EXTERNAL_CONTENT_REL table -->
  COLS:CATENTRY_EXTERNAL_CONTENT_REL=CATENTRY_EXTERNAL_CONTENT_REL:*

	COLS:CATENTRY_EXTERNAL_CONTENT_REL:CE_EXTERNAL_CONTENT_REL_ID=CATENTRY_EXTERNAL_CONTENT_REL:CE_EXTERNAL_CONTENT_REL_ID
 	COLS:CATENTRY_EXTERNAL_CONTENT_REL:CATENTRY_ID=CATENTRY_EXTERNAL_CONTENT_REL:CATENTRY_ID
 	COLS:CATENTRY_EXTERNAL_CONTENT_REL:CATOVRGRP_ID=CATENTRY_EXTERNAL_CONTENT_REL:CATOVRGRP_ID
 	COLS:CATENTRY_EXTERNAL_CONTENT_REL:LANGUAGE_ID=CATENTRY_EXTERNAL_CONTENT_REL:LANGUAGE_ID
 	COLS:CATENTRY_EXTERNAL_CONTENT_REL:CONTENT_ID=CATENTRY_EXTERNAL_CONTENT_REL:CONTENT_ID
 	COLS:CATENTRY_EXTERNAL_CONTENT_REL:TYPE=CATENTRY_EXTERNAL_CONTENT_REL:TYPE
 	COLS:CATENTRY_EXTERNAL_CONTENT_REL:FIELD1=CATENTRY_EXTERNAL_CONTENT_REL:FIELD1
 	COLS:CATENTRY_EXTERNAL_CONTENT_REL:FIELD2=CATENTRY_EXTERNAL_CONTENT_REL:FIELD2
 	COLS:CATENTRY_EXTERNAL_CONTENT_REL:FIELD3=CATENTRY_EXTERNAL_CONTENT_REL:FIELD3
 	COLS:CATENTRY_EXTERNAL_CONTENT_REL:OPTCOUNTER=CATENTRY_EXTERNAL_CONTENT_REL:OPTCOUNTER


  <!-- EXTERNAL_CONTENT table -->
  COLS:EXTERNAL_CONTENT=EXTERNAL_CONTENT:*

  <!-- EXTERNAL_CONTENT_ASSET table -->
  COLS:EXTERNAL_CONTENT_ASSET=EXTERNAL_CONTENT_ASSET:*
	
END_SYMBOL_DEFINITIONS



<!-- ===================================================================================== -->
<!-- ================================ GET CATENTRY BEGINS ================================ -->
<!-- ===================================================================================== -->


<!-- ========================================================================= -->
<!-- =============================SUB SELECT QUERIES========================== -->
<!-- ========================================================================= -->


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun   -->
<!-- given the specified unique identifier.                        -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- className: specifies the class name of the entitlement SQL composer -->
<!-- accessProfile: specifies the access profiels which needs to do entitlement check -->
<!-- includeBrowseable: If include browseable category product sets into the list of inclusions -->
<!-- psMark: The token used to replace to the entitlement SQLs -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]
	base_table=CATENTRY
	className=com.ibm.commerce.catalog.facade.server.services.dataaccess.db.jdbc.EntitledCatalogEntriesSQLComposer 
	param=accessProfile_IBM_Store
	param=includeBrowseable_false
	param=psMark_AndPSAgreements	
	sql=
		SELECT 
			CATENTRY_ID_1
		FROM 
		(
		  SELECT 
		  		CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM 
		  		CATENTRY
		  WHERE 
		  		CATENTRY.CATENTRY_ID IN (?UniqueID?)  AND 
				CATENTRY.MARKFORDELETE = 0 AndPSAgreements
		) T1
		WHERE EXISTS 
		( 
		  SELECT 
		  		1 
		  FROM 
		  		STORECENT 
		  WHERE 
		  		CATENTRY_ID_1 = STORECENT.CATENTRY_ID AND 
		  		STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
		)

END_XPATH_TO_SQL_STATEMENT

<!-- =================================================================================================================================== -->
<!-- This SQL will return the current page merchandising associations owned by given store of the current page for the Catalog Entry     -->
<!-- =================================================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[Association[Attributes[@storeID=]] and CatalogEntryIdentifier[UniqueID=]]/Association
	base_table=CATENTRY
	param=versionable
    sql=
		  SELECT 
		  		DISTINCT MASSOCCECE.CATENTRY_ID_FROM, MASSOCCECE.$COLS:MASSOCCECE_ID$, MASSOCCECE.RANK
		  FROM 
		  		MASSOCCECE
		  WHERE 
		  		MASSOCCECE.CATENTRY_ID_FROM=?UniqueID? AND 
			  	MASSOCCECE.STORE_ID=?storeID?
		  ORDER BY 
		  	  	MASSOCCECE.RANK, MASSOCCECE.MASSOCCECE_ID
		    
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================================================================================================================== -->
<!-- This SQL will return the current page merchandising associations in store path but exclude the relationship owned by the given store for the Catalog Entry     -->
<!-- ============================================================================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[Association[Attributes[@storeID!=]] and CatalogEntryIdentifier[UniqueID=]]/Association
	base_table=CATENTRY

    sql=

		  SELECT 
		  		DISTINCT MASSOCCECE.CATENTRY_ID_FROM, MASSOCCECE.$COLS:MASSOCCECE_ID$, MASSOCCECE.RANK
		  FROM 
		  		MASSOCCECE
		  WHERE 
		  		MASSOCCECE.CATENTRY_ID_FROM=?UniqueID? AND 
				MASSOCCECE.STORE_ID IN ( $STOREPATH:catalog$ ) AND
				MASSOCCECE.STORE_ID!=?storeID?
		  ORDER BY 
		  	  	MASSOCCECE.RANK, MASSOCCECE.MASSOCCECE_ID
		    
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================================= -->
<!-- This SQL will return the local merchandising associations of the current page for the Catalog Entry     -->
<!-- ================================================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[Association[Attributes[@storeID=]] and CatalogEntryIdentifier[ExternalIdentifier[PartNumber=]]]/Association
	base_table=CATENTRY
    sql=
    
		  SELECT DISTINCT
		  		CATENTRY.CATENTRY_ID, MASSOCCECE.MASSOCCECE_ID, MASSOCCECE.RANK
		  FROM 
		  		CATENTRY, MASSOCCECE
		  WHERE 
		  		CATENTRY.PARTNUMBER =?PartNumber? AND
				CATENTRY.CATENTRY_ID=MASSOCCECE.CATENTRY_ID_FROM AND
				MASSOCCECE.STORE_ID=?storeID?
		  ORDER BY 
		  	  MASSOCCECE.RANK, MASSOCCECE.MASSOCCECE_ID
		
		    
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================================= -->
<!-- This SQL will return the inherited merchandising associations of the current page for the Catalog Entry     -->
<!-- ================================================================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[Association[Attributes[@storeID!=]] and CatalogEntryIdentifier[ExternalIdentifier[PartNumber=]]]/Association
	base_table=CATENTRY
    sql=
    
		SELECT DISTINCT
		  		CATENTRY.CATENTRY_ID, MASSOCCECE.MASSOCCECE_ID, MASSOCCECE.RANK
		  FROM 
		  		CATENTRY, MASSOCCECE
		  WHERE 
		  		CATENTRY.PARTNUMBER =?PartNumber? AND 
				CATENTRY.CATENTRY_ID=MASSOCCECE.CATENTRY_ID_FROM AND
				MASSOCCECE.STORE_ID IN ( $STOREPATH:catalog$ ) AND
				MASSOCCECE.STORE_ID!=?storeID?
		  ORDER BY 
		  	  	MASSOCCECE.RANK, MASSOCCECE.MASSOCCECE_ID
		
		    
END_XPATH_TO_SQL_STATEMENT

<!-- ===================================================================================================== -->
<!-- This SQL will return the classic descriptive attributes of the current page for the Catalog Entry     -->
<!-- ===================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryAttributes[Attributes[(@usage=)]] and CatalogEntryIdentifier[UniqueID=]]/CatalogEntryAttributes
	base_table=CATENTRY
	param=versionable

    sql=
		SELECT 
			    DISTINCT ATTRIBUTE.CATENTRY_ID, ATTRIBUTE.$COLS:ATTRIBUTE_ID$, ATTRIBUTE.SEQUENCE	    					
		FROM
				ATTRIBUTE			
		WHERE
				ATTRIBUTE.USAGE in (?usage?) AND
				ATTRIBUTE.CATENTRY_ID=?UniqueID?
	    ORDER BY 
	    		ATTRIBUTE.SEQUENCE, ATTRIBUTE.ATTRIBUTE_ID 
END_XPATH_TO_SQL_STATEMENT

<!-- ================================================================================================================== -->
<!-- This SQL will return the attribute dictionary descriptive attributes of the current page for the Catalog Entry     -->
<!-- ================================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryAttributes[Attributes[(@usage=) and AttributeIdentifier]] and CatalogEntryIdentifier[UniqueID=]]/CatalogEntryAttributes
	base_table=CATENTRY
	
    sql=
		  SELECT 
		  		DISTINCT CATENTRYATTR.$COLS:CATENTRY_ID$, CATENTRYATTR.ATTR_ID, CATENTRYATTR.SEQUENCE
		  FROM 
		  		CATENTRYATTR, ATTR
		  WHERE 
		  		CATENTRYATTR.CATENTRY_ID=?UniqueID? AND 
				CATENTRYATTR.USAGE in (?usage?) AND
				CATENTRYATTR.ATTR_ID = ATTR.ATTR_ID AND 
				ATTR.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
		  ORDER BY 
		  	  	CATENTRYATTR.SEQUENCE, CATENTRYATTR.ATTR_ID
    
END_XPATH_TO_SQL_STATEMENT

<!-- =================================================================================================================================== -->
<!-- This SQL will return the attribute dictionary attributes other than a specified usage of the current page for the Catalog Entry     -->
<!-- =================================================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryAttributes[Attributes[(@usage!=) and AttributeIdentifier]] and CatalogEntryIdentifier[UniqueID=]]/CatalogEntryAttributes
	base_table=CATENTRY
	param=versionable
	
    sql=
		  SELECT 
		  		DISTINCT CATENTRYATTR.$COLS:CATENTRY_ID$, CATENTRYATTR.ATTR_ID, CATENTRYATTR.SEQUENCE
		  FROM 
		  		CATENTRYATTR, ATTR
		  WHERE 
		  		CATENTRYATTR.CATENTRY_ID=?UniqueID? AND 
				CATENTRYATTR.USAGE not in (?usage?) AND
				CATENTRYATTR.ATTR_ID = ATTR.ATTR_ID AND 
				ATTR.STOREENT_ID IN ( $STOREPATH:catalog$ )
		  ORDER BY 
		  	  	CATENTRYATTR.SEQUENCE, CATENTRYATTR.ATTR_ID
    
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun   -->
<!-- given the specified part number.                              -->
<!-- Multiple results are returned if multiple part numbers are    -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- className: specifies the class name of the entitlement SQL composer -->
<!-- accessProfile: specifies the access profile pattern which needs to do entitlement check -->
<!-- for examaple, accessProfile_IBM_Store means all access profiles with name containing "IBM_Store" will enable entitlement check. -->
<!-- like "IBM_Store_CatalogEntryAttributes" or "IBM_Store_CatalogEntryAttributesParent".
<!-- includeBrowseable: If include browseable category product sets into the list of inclusions -->
<!-- psMark: The token used to replace to the entitlement SQLs -->
<!-- @param PartNumber - The part num(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[ExternalIdentifier[(PartNumber=)]]]
	base_table=CATENTRY
	className=com.ibm.commerce.catalog.facade.server.services.dataaccess.db.jdbc.EntitledCatalogEntriesSQLComposer 
	param=accessProfile_IBM_Store
	param=includeBrowseable_false
	param=psMark_AndPSAgreements	
	sql=

		SELECT 
			CATENTRY_ID_1
		FROM 
		(
		  SELECT 
		  		CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM 
		  		CATENTRY
		  WHERE 
		  		CATENTRY.PARTNUMBER IN (?PartNumber?) AND 
				CATENTRY.MARKFORDELETE = 0 AndPSAgreements
		) T1
		WHERE EXISTS 
		( 
		  SELECT 
		  		1 
		  FROM 
		  		STORECENT 
		  WHERE 
		  		CATENTRY_ID_1 = STORECENT.CATENTRY_ID AND 
		  		STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
		)

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun   -->
<!-- given the specified part number and member id.                -->
<!-- Multiple results are returned if multiple input params are    -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- className: specifies the class name of the entitlement SQL composer -->
<!-- accessProfile: specifies the access profile pattern which needs to do entitlement check -->
<!-- for examaple, accessProfile_IBM_Store means all access profiles with name containing "IBM_Store" will enable entitlement check. -->
<!-- like "IBM_Store_CatalogEntryAttributes" or "IBM_Store_CatalogEntryAttributesParent".
<!-- includeBrowseable: If include browseable category product sets into the list of inclusions -->
<!-- psMark: The token used to replace to the entitlement SQLs -->
<!-- @param PartNumber - The part num(s) for which to retrieve     -->
<!-- @param ownerID -    The owner Id(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[ExternalIdentifier[(@ownerID= and PartNumber=)]]]
	base_table=CATENTRY
	className=com.ibm.commerce.catalog.facade.server.services.dataaccess.db.jdbc.EntitledCatalogEntriesSQLComposer 
	param=accessProfile_IBM_Store
	param=includeBrowseable_false
	param=psMark_AndPSAgreements	
	sql=
		SELECT 
			CATENTRY_ID_1
		FROM 
		(
		  SELECT 
		  		CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM 
		  		CATENTRY
		  WHERE 
               CATENTRY.PARTNUMBER = ?PartNumber? AND
               CATENTRY.MEMBER_ID = ?ownerID? AND
			   CATENTRY.MARKFORDELETE = 0 AndPSAgreements
		) T1
		WHERE EXISTS 
		( 
		  SELECT 
		  		1 
		  FROM 
		  		STORECENT 
		  WHERE 
		  		CATENTRY_ID_1 = STORECENT.CATENTRY_ID AND 
		  		STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
		)

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun   -->
<!-- given the specified parent catalog group unique identifier.   -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!--                                                               -->
<!-- The SQL key processor 'CatalogEntryFilterKeyProcessor' calls  -->
<!-- SQL statement 'IBM_Get_FilteredCatalogEntryIDs' defined in    --> 
<!-- wc-query-utilties.tpl to filter out the catalog entries which -->
<!-- are marked for deleting or not in the current store path.     -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[ParentCatalogGroupIdentifier[(UniqueID=)]]
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor
	base_table=CATENTRY
	sql=

			SELECT 
				CATENTRY_ID_1,
				SEQUENCE
			FROM 
			(
				SELECT 
					CATGPENREL.CATENTRY_ID CATENTRY_ID_1,
					CATGPENREL.SEQUENCE SEQUENCE
				FROM 
					CATGPENREL 
				WHERE 
					CATGPENREL.CATGROUP_ID IN (?UniqueID?) AND 
					CATGPENREL.CATALOG_ID =  $CTX:CATALOG_ID$
			) T1 
			WHERE NOT EXISTS 
			(
				SELECT 1 FROM 
					CATENTREL 
				WHERE 
					CATENTREL.CATENTRY_ID_CHILD = CATENTRY_ID_1 AND 
					CATENTREL.CATRELTYPE_ID = 'PRODUCT_ITEM'
			)
			ORDER BY 
				SEQUENCE

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun   -->
<!-- given the specified parent catalog group identifier.          -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param GroupIdentifier - The identifier(s) for which to       -->
<!--        retrieve.                                              --> 
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!--                                                               -->
<!-- The SQL key processor 'CatalogEntryFilterKeyProcessor' calls  -->
<!-- SQL statement 'IBM_Get_FilteredCatalogEntryIDs' defined in    --> 
<!-- wc-query-utilties.tpl to filter out the catalog entries which -->
<!-- are marked for deleting or not in the current store path.     -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[ParentCatalogGroupIdentifier[ExternalIdentifier[(GroupIdentifier=)]]]
	base_table=CATENTRY
	sql=
			SELECT 
	     				CATENTRY.$COLS:CATENTRY_ID$
	     	FROM
	     				CATENTRY
	     				 JOIN 
	     				CATGPENREL ON 
	     					(CATGPENREL.CATENTRY_ID = CATENTRY.CATENTRY_ID AND
	     					 CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$)
	     				 JOIN
						STORECENT ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
							  STORECENT.STOREENT_ID IN ($STOREPATH:catalog$))
						 JOIN
						CATGROUP ON
							(CATGPENREL.CATGROUP_ID = CATGROUP.CATGROUP_ID AND
							 CATGROUP.IDENTIFIER IN (?GroupIdentifier?) AND
							 CATGROUP.MARKFORDELETE = 0)
						 LEFT OUTER JOIN
						CATENTREL ON
							(CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID AND
							 CATENTREL.CATRELTYPE_ID = 'PRODUCT_ITEM')							 
	     	WHERE
						CATENTRY.MARKFORDELETE = 0 
						AND NOT 
								(
									CATENTRY.CATENTTYPE_ID = 'ItemBean' AND
									CATENTREL.CATENTRY_ID_CHILD IS NOT NULL
								)
			ORDER BY
						CATGPENREL.SEQUENCE						
						
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun(s)-->
<!-- given the specified search criteria.                          -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param catalogEntryTypeCode - The catentry type(s) for which  -->
<!--        to retrieve.                                           --> 
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryTypeCode=) and search()]
	base_table=CATENTRY
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=Description/Name:128
	param=CatalogEntryIdentifier/ExternalIdentifier/PartNumber:64
	
	sql=
		SELECT DISTINCT CATENTRY.$COLS:CATENTRY_ID$
	FROM
  		CATENTRY
  		 JOIN
		STORECENT ON
 			(CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
			 STORECENT.STOREENT_ID IN ($STOREPATH:catalog$))
  		,$ATTR_TBLS$
	WHERE
		CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND		  
		CATENTRY.MARKFORDELETE = 0 AND 	
		( $ATTR_CNDS$ ) 
	ORDER BY
			CATENTRY.CATENTRY_ID $DB:UNCOMMITTED_READ$		
	
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun(s)-->
<!-- starting with the specified part number or name.           -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- @param catalogEntryTypeCode - The catentry type(s) for which  -->
<!--        to retrieve.                                           --> 
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- @param Description/Name - The name of the catalog entry       -->
<!-- @param CatalogEntryIdentifier/ExternalIdentifier/PartNumber   -->
<!--        - The part number of the catalog entry                 -->
<!-- ============================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryTypeCode=) and search(starts-with(CatalogEntryIdentifier/ExternalIdentifier/PartNumber,) or starts-with(Description/Name,))]
	base_table=CATENTRY
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=Description/Name:128
	param=CatalogEntryIdentifier/ExternalIdentifier/PartNumber:64
	
	dbtype=any 
	sql=
		SELECT CATENTRY_ID_1
		FROM (
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY, CATENTDESC
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( CATENTRY.CATENTRY_ID=CATENTDESC.CATENTRY_ID 
		          AND UPPER(CATENTDESC.NAME) LIKE UPPER(?Description/Name?) ESCAPE '+')
		  UNION 
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY 
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( UPPER(CATENTRY.PARTNUMBER) LIKE UPPER(?CatalogEntryIdentifier/ExternalIdentifier/PartNumber?) ESCAPE '+')
		) T1
		WHERE EXISTS ( 
		  SELECT 1 FROM STORECENT 
		  WHERE CATENTRY_ID_1 = STORECENT.CATENTRY_ID 
		  AND STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
		  ) $DB:UNCOMMITTED_READ$	

	dbtype=db2
	sql=	
		SELECT CATENTRY_ID_1
		FROM (
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY, CATENTDESC
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( CATENTRY.CATENTRY_ID=CATENTDESC.CATENTRY_ID 
		          AND UPPER(CATENTDESC.NAME) LIKE UPPER(CAST(?Description/Name? AS VARCHAR(128))) ESCAPE '+')
		  UNION 
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY 
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( UPPER(CATENTRY.PARTNUMBER) LIKE UPPER(CAST(?CatalogEntryIdentifier/ExternalIdentifier/PartNumber? AS VARCHAR(64))) ESCAPE '+')
		) T1
		WHERE EXISTS ( 
		  SELECT 1 FROM STORECENT 
		  WHERE CATENTRY_ID_1 = STORECENT.CATENTRY_ID 
		  AND STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
		  ) $DB:UNCOMMITTED_READ$
	
	cm
	dbtype=db2
	sql=	  
		SELECT CATENTRY_ID_1 
		FROM ( 
			SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1 
			FROM 
				(SELECT $CM:BASE$.CATENTRY.CATENTRY_ID, $CM:BASE$.CATENTRY.CATENTTYPE_ID, $CM:BASE$.CATENTRY.MARKFORDELETE 
					FROM $CM:BASE$.CATENTRY 
					WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATENTRY WHERE $CM:BASE$.CATENTRY.CATENTRY_ID = $CM:WRITE$.CATENTRY.CATENTRY_ID)
					UNION ALL 
					SELECT $CM:WRITE$.CATENTRY.CATENTRY_ID, $CM:WRITE$.CATENTRY.CATENTTYPE_ID, $CM:WRITE$.CATENTRY.MARKFORDELETE 
					FROM $CM:WRITE$.CATENTRY
				) 
				CATENTRY,
				(SELECT $CM:BASE$.CATENTDESC.CATENTRY_ID, $CM:BASE$.CATENTDESC.NAME 
					FROM $CM:BASE$.CATENTDESC 
					WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATENTDESC WHERE $CM:BASE$.CATENTDESC.CATENTRY_ID = $CM:WRITE$.CATENTDESC.CATENTRY_ID) 
					UNION ALL 
					SELECT $CM:WRITE$.CATENTDESC.CATENTRY_ID, $CM:WRITE$.CATENTDESC.NAME FROM $CM:WRITE$.CATENTDESC
				) 
				CATENTDESC
					WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND 
					CATENTRY.MARKFORDELETE = 0 AND (CATENTRY.CATENTRY_ID=CATENTDESC.CATENTRY_ID AND UPPER(CATENTDESC.NAME) LIKE UPPER(CAST(?Description/Name? AS VARCHAR(128))) ESCAPE '+')
			UNION 
			SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1 
			FROM  
				(SELECT $CM:BASE$.CATENTRY.CATENTRY_ID, $CM:BASE$.CATENTRY.CATENTTYPE_ID, $CM:BASE$.CATENTRY.MARKFORDELETE, $CM:BASE$.CATENTRY.PARTNUMBER 
					FROM $CM:BASE$.CATENTRY 
					WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATENTRY WHERE $CM:BASE$.CATENTRY.CATENTRY_ID = $CM:WRITE$.CATENTRY.CATENTRY_ID)
					UNION ALL 
					SELECT $CM:WRITE$.CATENTRY.CATENTRY_ID, $CM:WRITE$.CATENTRY.CATENTTYPE_ID, $CM:WRITE$.CATENTRY.MARKFORDELETE, $CM:WRITE$.CATENTRY.PARTNUMBER 
					FROM $CM:WRITE$.CATENTRY
				) 
				CATENTRY 
				WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND 
				CATENTRY.MARKFORDELETE = 0 AND ( UPPER(CATENTRY.PARTNUMBER) LIKE UPPER(CAST(?CatalogEntryIdentifier/ExternalIdentifier/PartNumber? AS VARCHAR(64))) ESCAPE '+' ) 
		) T1 
		WHERE EXISTS ( SELECT 1 FROM STORECENT WHERE CATENTRY_ID_1 = STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) ) $DB:UNCOMMITTED_READ$
		
	
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun(s)-->
<!-- containing the specified part number or name.           -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- @param catalogEntryTypeCode - The catentry type(s) for which  -->
<!--        to retrieve.                                           --> 
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- @param Description/Name - The name of the catalog entry       -->
<!-- @param CatalogEntryIdentifier/ExternalIdentifier/PartNumber   -->
<!--        - The part number of the catalog entry                 -->
<!-- ============================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryTypeCode=) and search(contains(CatalogEntryIdentifier/ExternalIdentifier/PartNumber,) or contains(Description/Name,))]
	base_table=CATENTRY
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=Description/Name:128
	param=CatalogEntryIdentifier/ExternalIdentifier/PartNumber:64
		  
	dbtype=any 
	sql=
		SELECT CATENTRY_ID_1
		FROM (
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY, CATENTDESC
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( CATENTRY.CATENTRY_ID=CATENTDESC.CATENTRY_ID 
		          AND UPPER(CATENTDESC.NAME) LIKE UPPER(?Description/Name?) ESCAPE '+')
		  UNION 
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY 
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( UPPER(CATENTRY.PARTNUMBER) LIKE UPPER(?CatalogEntryIdentifier/ExternalIdentifier/PartNumber?) ESCAPE '+')
		) T1
		WHERE EXISTS ( 
		  SELECT 1 FROM STORECENT 
		  WHERE CATENTRY_ID_1 = STORECENT.CATENTRY_ID 
		  AND STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
		  ) $DB:UNCOMMITTED_READ$		

	dbtype=db2
	sql=	
		SELECT CATENTRY_ID_1
		FROM (
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY, CATENTDESC
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( CATENTRY.CATENTRY_ID=CATENTDESC.CATENTRY_ID 
		          AND UPPER(CATENTDESC.NAME) LIKE UPPER(CAST(?Description/Name? AS VARCHAR(128))) ESCAPE '+')
		  UNION 
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY 
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( UPPER(CATENTRY.PARTNUMBER) LIKE UPPER(CAST(?CatalogEntryIdentifier/ExternalIdentifier/PartNumber? AS VARCHAR(64))) ESCAPE '+')
		) T1
		WHERE EXISTS ( 
		  SELECT 1 FROM STORECENT 
		  WHERE CATENTRY_ID_1 = STORECENT.CATENTRY_ID 
		  AND STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
		  ) $DB:UNCOMMITTED_READ$
	
	cm
	dbtype=db2
	sql=	  
		SELECT CATENTRY_ID_1 
		FROM ( 
			SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1 
			FROM 
				(SELECT $CM:BASE$.CATENTRY.CATENTRY_ID, $CM:BASE$.CATENTRY.CATENTTYPE_ID, $CM:BASE$.CATENTRY.MARKFORDELETE 
					FROM $CM:BASE$.CATENTRY 
					WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATENTRY WHERE $CM:BASE$.CATENTRY.CATENTRY_ID = $CM:WRITE$.CATENTRY.CATENTRY_ID)
					UNION ALL 
					SELECT $CM:WRITE$.CATENTRY.CATENTRY_ID, $CM:WRITE$.CATENTRY.CATENTTYPE_ID, $CM:WRITE$.CATENTRY.MARKFORDELETE 
					FROM $CM:WRITE$.CATENTRY
				) 
				CATENTRY,
				
				(SELECT $CM:BASE$.CATENTDESC.CATENTRY_ID, $CM:BASE$.CATENTDESC.NAME 
					FROM $CM:BASE$.CATENTDESC 
					WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATENTDESC WHERE $CM:BASE$.CATENTDESC.CATENTRY_ID = $CM:WRITE$.CATENTDESC.CATENTRY_ID) 
					UNION ALL 
					SELECT $CM:WRITE$.CATENTDESC.CATENTRY_ID, $CM:WRITE$.CATENTDESC.NAME FROM $CM:WRITE$.CATENTDESC
				) 
				CATENTDESC
				 
					WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND 
					CATENTRY.MARKFORDELETE = 0 AND (CATENTRY.CATENTRY_ID=CATENTDESC.CATENTRY_ID AND UPPER(CATENTDESC.NAME) LIKE UPPER(CAST(?Description/Name? AS VARCHAR(128))) ESCAPE '+')
			UNION 
			SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1 
			FROM  
				(SELECT $CM:BASE$.CATENTRY.CATENTRY_ID, $CM:BASE$.CATENTRY.CATENTTYPE_ID, $CM:BASE$.CATENTRY.MARKFORDELETE, $CM:BASE$.CATENTRY.PARTNUMBER 
					FROM $CM:BASE$.CATENTRY 
					WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATENTRY WHERE $CM:BASE$.CATENTRY.CATENTRY_ID = $CM:WRITE$.CATENTRY.CATENTRY_ID)
					UNION ALL 
					SELECT $CM:WRITE$.CATENTRY.CATENTRY_ID, $CM:WRITE$.CATENTRY.CATENTTYPE_ID, $CM:WRITE$.CATENTRY.MARKFORDELETE, $CM:WRITE$.CATENTRY.PARTNUMBER 
					FROM $CM:WRITE$.CATENTRY
				) 
				CATENTRY 
				
				WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND 
				CATENTRY.MARKFORDELETE = 0 AND ( UPPER(CATENTRY.PARTNUMBER) LIKE UPPER(CAST(?CatalogEntryIdentifier/ExternalIdentifier/PartNumber? AS VARCHAR(64))) ESCAPE '+' ) 
		) T1 
		WHERE EXISTS ( SELECT 1 FROM STORECENT WHERE CATENTRY_ID_1 = STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) ) $DB:UNCOMMITTED_READ$
	
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun(s)-->
<!-- with given part number or name.                               -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- @param catalogEntryTypeCode - The catentry type(s) for which  -->
<!--        to retrieve.                                           --> 
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- @param Description/Name - The name of the catalog entry       -->
<!-- @param CatalogEntryIdentifier/ExternalIdentifier/PartNumber   -->
<!--        - The part number of the catalog entry                 -->
<!-- ============================================================= -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryTypeCode=) and search(CatalogEntryIdentifier/ExternalIdentifier/PartNumber= or Description/Name=)]
	base_table=CATENTRY
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=Description/Name:128
	param=CatalogEntryIdentifier/ExternalIdentifier/PartNumber:64

  dbtype=any
	sql=
		SELECT CATENTRY_ID_1
		FROM (
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY, CATENTDESC 
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( CATENTRY.CATENTRY_ID=CATENTDESC.CATENTRY_ID 
		          AND UPPER(CATENTDESC.NAME) = UPPER(?Description/Name?) )
		  UNION 
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY 
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( UPPER(CATENTRY.PARTNUMBER) = UPPER(?CatalogEntryIdentifier/ExternalIdentifier/PartNumber?) )
		) T1
		WHERE EXISTS ( 
		  SELECT 1 FROM STORECENT 
		  WHERE CATENTRY_ID_1 = STORECENT.CATENTRY_ID 
		  AND STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
		  ) $DB:UNCOMMITTED_READ$

	dbtype=db2
	sql=
		SELECT CATENTRY_ID_1
		FROM (
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY, CATENTDESC 
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( CATENTRY.CATENTRY_ID=CATENTDESC.CATENTRY_ID 
		          AND UPPER(CATENTDESC.NAME) = UPPER(CAST(?Description/Name? AS VARCHAR(128))) )
		  UNION 
		  SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1
		  FROM CATENTRY 
		  WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) 
		    AND CATENTRY.MARKFORDELETE = 0 
		    AND ( UPPER(CATENTRY.PARTNUMBER) = UPPER(CAST(?CatalogEntryIdentifier/ExternalIdentifier/PartNumber? AS VARCHAR(64))) )
		) T1
		WHERE EXISTS ( 
		  SELECT 1 FROM STORECENT 
		  WHERE CATENTRY_ID_1 = STORECENT.CATENTRY_ID 
		  AND STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) 
		  ) $DB:UNCOMMITTED_READ$

	cm
	dbtype=db2
	sql=	  
		SELECT CATENTRY_ID_1 
		FROM ( 
			SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1 
			FROM 
				(SELECT $CM:BASE$.CATENTRY.CATENTRY_ID, $CM:BASE$.CATENTRY.CATENTTYPE_ID, $CM:BASE$.CATENTRY.MARKFORDELETE 
					FROM $CM:BASE$.CATENTRY 
					WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATENTRY WHERE $CM:BASE$.CATENTRY.CATENTRY_ID = $CM:WRITE$.CATENTRY.CATENTRY_ID)
					UNION ALL 
					SELECT $CM:WRITE$.CATENTRY.CATENTRY_ID, $CM:WRITE$.CATENTRY.CATENTTYPE_ID, $CM:WRITE$.CATENTRY.MARKFORDELETE 
					FROM $CM:WRITE$.CATENTRY
				) 
				CATENTRY,
				
				(SELECT $CM:BASE$.CATENTDESC.CATENTRY_ID, $CM:BASE$.CATENTDESC.NAME 
					FROM $CM:BASE$.CATENTDESC 
					WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATENTDESC WHERE $CM:BASE$.CATENTDESC.CATENTRY_ID = $CM:WRITE$.CATENTDESC.CATENTRY_ID) 
					UNION ALL 
					SELECT $CM:WRITE$.CATENTDESC.CATENTRY_ID, $CM:WRITE$.CATENTDESC.NAME FROM $CM:WRITE$.CATENTDESC
				) 
				CATENTDESC
				 
					WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND 
					CATENTRY.MARKFORDELETE = 0 AND (CATENTRY.CATENTRY_ID=CATENTDESC.CATENTRY_ID AND UPPER(CATENTDESC.NAME) = UPPER(CAST(?Description/Name? AS VARCHAR(128))))
			UNION 
			SELECT CATENTRY.CATENTRY_ID CATENTRY_ID_1 
			FROM  
				(SELECT $CM:BASE$.CATENTRY.CATENTRY_ID, $CM:BASE$.CATENTRY.CATENTTYPE_ID, $CM:BASE$.CATENTRY.MARKFORDELETE, $CM:BASE$.CATENTRY.PARTNUMBER 
					FROM $CM:BASE$.CATENTRY 
					WHERE NOT EXISTS (SELECT '1' FROM $CM:WRITE$.CATENTRY WHERE $CM:BASE$.CATENTRY.CATENTRY_ID = $CM:WRITE$.CATENTRY.CATENTRY_ID)
					UNION ALL 
					SELECT $CM:WRITE$.CATENTRY.CATENTRY_ID, $CM:WRITE$.CATENTRY.CATENTTYPE_ID, $CM:WRITE$.CATENTRY.MARKFORDELETE, $CM:WRITE$.CATENTRY.PARTNUMBER 
					FROM $CM:WRITE$.CATENTRY
				) 
				CATENTRY 
				
				WHERE CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND 
				CATENTRY.MARKFORDELETE = 0 AND ( UPPER(CATENTRY.PARTNUMBER) = UPPER(CAST(?CatalogEntryIdentifier/ExternalIdentifier/PartNumber? AS VARCHAR(64)))) 
		) T1 
		WHERE EXISTS ( SELECT 1 FROM STORECENT WHERE CATENTRY_ID_1 = STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID IN ( $STOREPATH:catalog$ ) ) $DB:UNCOMMITTED_READ$

END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) which refer TO the given catalog entry (unique        -->
<!-- identifier) through a merchandising association.              -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[Association[CatalogEntryReference[CatalogEntryIdentifier[(UniqueID=)]]]]
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor	
	base_table=CATENTRY
	sql=
		SELECT 
				MASSOCCECE.$COLS:CATENTRY_ID_FROM$

		FROM
				MASSOCCECE
		WHERE
				MASSOCCECE.STORE_ID IN ($STOREPATH:catalog$) AND
				MASSOCCECE.CATENTRY_ID_TO IN (?UniqueID?)
		ORDER BY
				MASSOCCECE.CATENTRY_ID_FROM
	
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) which refer TO the given catalog entry (unique        -->
<!-- identifier) through a Bundle/Kit association.                 -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param catalogEntryTypeCode - The catentry type for which     -->
<!--        to retrieve. Can be 'BundleBean' or 'DynamicKitBean'   -->
<!--        for bundle and kits respectively.                      -->     
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[KitComponent[CatalogEntryReference[CatalogEntryIdentifier[(@catalogEntryTypeCode= and UniqueID=)]]]]
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor	
	base_table=CATENTRY
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$
		FROM
				CATENTRY
				JOIN 
				CATENTREL ON
					(CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_PARENT)
		WHERE
               CATENTREL.CATENTRY_ID_CHILD IN (?UniqueID?) AND
               CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?)
		ORDER BY
				CATENTRY.CATENTRY_ID               
         
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun(s)-->
<!-- given the specified search criteria.                          -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param GroupIdentifier - The parent catgrouo identifier       -->
<!--        for which to retrieve.                                 -->
<!-- @param catalogEntryTypeCode - The catentry type(s) for which  -->
<!--        to retrieve.                                           --> 
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryTypeCode=) and ParentCatalogGroupIdentifier[ExternalIdentifier[GroupIdentifier=]] and search()]
	base_table=CATENTRY
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=GroupIdentifier:254
	
	sql=
		SELECT DISTINCT CATENTRY.$COLS:CATENTRY_ID$
	FROM
  		CATENTRY
  		 JOIN
		STORECENT ON
 			(CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
			 STORECENT.STOREENT_ID IN ($STOREPATH:catalog$))
		 LEFT OUTER JOIN
		CATGPENREL ON
			(CATGPENREL.CATENTRY_ID = CATENTRY.CATENTRY_ID)
		 LEFT OUTER JOIN
		CATGROUP ON
			(CATGPENREL.CATGROUP_ID = CATGROUP.CATGROUP_ID) 	 
  		,$ATTR_TBLS$
	WHERE
		CATENTRY.MARKFORDELETE = 0 AND 	
		CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND
		1 = 
			CASE
				WHEN (CAST (?GroupIdentifier? AS VARCHAR(254)) = '' OR
					  CAST (?GroupIdentifier? AS VARCHAR(254)) IS NULL
					 )
					 THEN 1
				WHEN (
				 	  UPPER(CATGROUP.IDENTIFIER) LIKE UPPER(CAST (?GroupIdentifier? AS VARCHAR(254)))
				 	 ) 
				 	 THEN 1					 
				ELSE 0
			END
		 AND
		(
			CATGPENREL.CATALOG_ID IS NULL OR
			CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$
		)			
		AND
		( $ATTR_CNDS$ ) 
	ORDER BY
		CATENTRY.CATENTRY_ID $DB:UNCOMMITTED_READ$		
		
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun(s)-->
<!-- given the specified search criteria and catalog entry type as well as the category level SKUs    -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param catalogEntryTypeCode - The catentry type(s) for which  -->
<!--        to retrieve.                                           --> 
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryTypeCode=) and CategoryItem and search()]
	base_table=CATENTRY
	sql=
		SELECT DISTINCT CATENTRY.$COLS:CATENTRY_ID$
	FROM
  		CATENTRY
  		 JOIN
		STORECENT ON
 			(CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
			 STORECENT.STOREENT_ID IN ($STOREPATH:catalog$))
		 LEFT OUTER JOIN
		CATGPENREL ON
			(CATGPENREL.CATENTRY_ID = CATENTRY.CATENTRY_ID)
  		,$ATTR_TBLS$
	WHERE
		CATENTRY.MARKFORDELETE = 0 AND 	
		CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND
		NOT EXISTS (SELECT 1 FROM CATENTREL WHERE CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID AND CATRELTYPE_ID = 'PRODUCT_ITEM') AND
		(
			CATGPENREL.CATALOG_ID IS NULL OR
			CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$
		)			
		AND
		( $ATTR_CNDS$ ) 
	ORDER BY
		CATENTRY.CATENTRY_ID $DB:UNCOMMITTED_READ$		
		
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun(s)-->
<!-- given the specified search criteria for the parent catggroup. -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param GroupIdentifier - The parent catgrouo identifier       -->
<!--        for which to retrieve.                                 -->
<!-- @param catalogEntryTypeCode - The catentry type(s) for which  -->
<!--        to retrieve.                                           --> 
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryTypeCode=) and ParentCatalogGroupIdentifier[ExternalIdentifier[GroupIdentifier=]]]
	base_table=CATENTRY
	sql=
		SELECT DISTINCT CATENTRY.$COLS:CATENTRY_ID$
	FROM
  		CATENTRY
  		 JOIN
		STORECENT ON
 			(CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
			 STORECENT.STOREENT_ID IN ($STOREPATH:catalog$))
		 LEFT OUTER JOIN
		CATGPENREL ON
			(CATGPENREL.CATENTRY_ID = CATENTRY.CATENTRY_ID)
		 LEFT OUTER JOIN
		CATGROUP ON
			(CATGPENREL.CATGROUP_ID = CATGROUP.CATGROUP_ID) 	 
	WHERE
		CATENTRY.MARKFORDELETE = 0 AND 	
		CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND
		1 = 
			CASE
				WHEN (CAST (?GroupIdentifier? AS VARCHAR(254)) = '' OR
					  CAST (?GroupIdentifier? AS VARCHAR(254)) IS NULL
					 )
					 THEN 1
				WHEN (
				 	  UPPER(CATGROUP.IDENTIFIER) LIKE UPPER(CAST (?GroupIdentifier? AS VARCHAR(254)))
				 	 ) 
				 	 THEN 1					 
				ELSE 0
			END
		 AND
		(
			CATGPENREL.CATALOG_ID IS NULL OR
			CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$
		)	
	ORDER BY
		CATENTRY.CATENTRY_ID $DB:UNCOMMITTED_READ$		
		
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) which are parents the given catalog entry (unique     -->
<!-- identifier) through a 'PRODUCT_ITEM' association.             -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param type - The type of relationship for which to retrieve. -->
<!--        Should always be 'child'.                              -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[NavigationRelationship[CatalogEntryReference[CatalogEntryIdentifier[(@type= and (UniqueID=))]]]]
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor
	base_table=CATENTRY
	sql=
		SELECT 
				CATENTREL.$COLS:CATENTRY_ID_PARENT$
		FROM
				CATENTREL
		WHERE
				CATENTREL.CATENTRY_ID_CHILD IN (?UniqueID?) AND
	       		CATENTREL.CATRELTYPE_ID='PRODUCT_ITEM' AND ?type?='child'

END_XPATH_TO_SQL_STATEMENT



<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) which are parents the given catalog entry (unique     -->
<!-- identifier) through a 'PACKAGE_COMPONENT','BUNDLE_COMPONENT'  -->
<!-- or 'DYNAMIC_KIT_COMPONENT' association.                       -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[KitComponent[CatalogEntryReference[CatalogEntryIdentifier[(UniqueID=)]]]]
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor
	base_table=CATENTRY
	sql=
		SELECT 
				CATENTREL.$COLS:CATENTRY_ID_PARENT$
		FROM
				CATENTREL
		WHERE
               CATENTREL.CATENTRY_ID_CHILD IN (?UniqueID?) AND
	           CATENTREL.CATRELTYPE_ID IN ('PACKAGE_COMPONENT','BUNDLE_COMPONENT','DYNAMIC_KIT_COMPONENT')

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) which are parents the given catalog entry (part       -->
<!-- number) through a 'PRODUCT_ITEM' association.                 -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param type - The type of relationship for which to retrieve. -->
<!--        Should always be 'child'.                              -->
<!-- @param PartNumber - The part num(s) for which to retrieve.    -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[NavigationRelationship[CatalogEntryReference[CatalogEntryIdentifier[ExternalIdentifier[(@type= and (PartNumber=))]]]]]
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor
	base_table=CATENTRY
	sql=
		SELECT 
				CATENTREL.$COLS:CATENTRY_ID_PARENT$
		FROM
				CATENTREL
				 JOIN
					CATENTRY ON
						(CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_CHILD AND
						 CATENTRY.PARTNUMBER IN (?PartNumber?) AND
						 CATENTRY.MARKFORDELETE = 0)		  
				
		WHERE
	       	   CATENTREL.CATRELTYPE_ID='PRODUCT_ITEM' AND ?type?='child'

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) which are parents the given catalog entry (part       -->
<!-- number) through a 'PACKAGE_COMPONENT','BUNDLE_COMPONENT'      -->
<!-- or 'DYNAMIC_KIT_COMPONENT' association.                       -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param PartNumber - The part num(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[KitComponent[CatalogEntryReference[CatalogEntryIdentifier[ExternalIdentifier[(PartNumber=)]]]]]
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor
	base_table=CATENTRY
	sql=
		SELECT 
				CATENTREL.$COLS:CATENTRY_ID_PARENT$
		FROM
				CATENTREL	
				JOIN
				    CATENTRY ON
						(CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_CHILD AND
						 CATENTRY.PARTNUMBER IN (?PartNumber?) AND
						 CATENTRY.MARKFORDELETE = 0)		  
				
		WHERE
	           CATENTREL.CATRELTYPE_ID IN ('PACKAGE_COMPONENT','BUNDLE_COMPONENT','DYNAMIC_KIT_COMPONENT')

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) in the store which do not belong to any category.     -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor
	base_table=CATENTRY
	dbtype=db2
	sql=
			SELECT  
					CATENTRY.$COLS:CATENTRY_ID$ 
			FROM 
					CATENTRY 
			EXCEPT 
					SELECT CATGPENREL.CATENTRY_ID FROM CATGPENREL

	dbtype=oracle
	sql=
			SELECT 
	     				CATENTRY.$COLS:CATENTRY_ID$
	     	FROM
	     				CATENTRY
	     	WHERE
						NOT EXISTS 
						(
							SELECT 1 
							FROM CATGPENREL
							WHERE CATGPENREL.CATENTRY_ID = CATENTRY.CATENTRY_ID
						)
	sql=
			SELECT 
	     				CATENTRY.$COLS:CATENTRY_ID$
	     	FROM
	     				CATENTRY
	     	WHERE
						NOT EXISTS 
						(
							SELECT 1 
							FROM CATGPENREL
							WHERE CATGPENREL.CATENTRY_ID = CATENTRY.CATENTRY_ID
						)
						

END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) which are children of the given catalog entry (unique -->
<!-- identifier)                                                   -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The identifier(s) for which to retrieve.    -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[ParentCatalogEntryIdentifier[(UniqueID=)]]
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor
	base_table=CATENTRY
	sql=
	
			SELECT 
     				CATENTREL.$COLS:CATENTRY_ID_CHILD$
	     	FROM
     				CATENTREL
	     	WHERE
					CATENTREL.CATENTRY_ID_PARENT IN (?UniqueID?)
			ORDER BY
					CATENTREL.SEQUENCE						

						
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) which are children of the given catalog entry (part   -->
<!-- number)                                                       -->
<!-- Multiple results are returned if multiple part numbers are    -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param PartNumber - The part num(s) for which to retrieve.    -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[ParentCatalogEntryIdentifier[ExternalIdentifier[(PartNumber=)]]]
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor	
	base_table=CATENTRY
	sql=
			SELECT 
	     				CATENTREL.$COLS:CATENTRY_ID_CHILD$
	     	FROM
	     				CATENTREL,
					    CATENTRY
	     	WHERE
						CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_PARENT AND
					 	CATENTRY.PARTNUMBER IN (?PartNumber?) AND
					 	CATENTRY.MARKFORDELETE = 0
			ORDER BY
						CATENTREL.SEQUENCE						
						
END_XPATH_TO_SQL_STATEMENT

<!-- ====================================================================== 
	Get catalog entry display page name based on catentry id, or the default catentry id.
	@param UniqueId The catentry id of the catalog entry
	@param Context:STORE_ID The store for which to retrieve the catalog entry . This parameter is retrieved from within the business context.      
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryDisplayPageName[(UniqueId=)]]+IBM_Admin_CatalogEntryDisplayPage_Get
	base_table=DISPENTREL
	sql=
		SELECT 
	     				DISPENTREL.$COLS:DISPENTREL$
	     	FROM
	     						DISPENTREL			  
	     	WHERE
						DISPENTREL.CATENTRY_ID in (?UniqueId?) OR DISPENTREL.CATENTRY_ID =0
						 AND DISPENTREL.STOREENT_ID IN ($STOREPATH:catalog$) 
    	
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the catalog entries to which the         -->
<!-- specified attachment is associated.                           -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_CatalogEntryDescription  			   -->
<!-- IBM_Admin_CatalogEntryAttachmentReference                     -->
<!-- @param UniqueID The identifier of the attachment              -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	      the business context.           	                     -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[AttachmentReference[AttachmentIdentifier[(UniqueID=)]]]
	base_table=CATENTRY	
	sql=
		SELECT 
				DISTINCT(CATENTRY.$COLS:CATENTRY_ID$)
		FROM
				CATENTRY
						JOIN STORECENT ON STORECENT.CATENTRY_ID=CATENTRY.CATENTRY_ID 
							AND STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
				    JOIN ATCHREL ON ATCHREL.BIGINTOBJECT_ID = CATENTRY.CATENTRY_ID
				    JOIN ATCHOBJTYP ON (ATCHREL.ATCHOBJTYP_ID = ATCHOBJTYP.ATCHOBJTYP_ID AND ATCHOBJTYP.IDENTIFIER = 'CATENTRY')
    WHERE
        CATENTRY.MARKFORDELETE = 0 AND ATCHREL.ATCHTGT_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT



<!-- ============================================================= -->
<!-- This is a helper SQL used for getting a catentry noun   	   -->
<!-- for loading catalog entry breadcrumb locations.          	   -->
<!-- This SQL will return the base elements of the Catalog Entry   -->
<!-- noun given the specified unique identifier.                   -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profile that applies to this SQL:                  -->
<!-- IBM_Admin_CatalogEntryLocations				   -->
<!--  			                                           -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[(UniqueID=)]]+IBM_Admin_CatalogEntryLocations
	base_table=CATENTRY
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$
		FROM
				CATENTRY
		WHERE
                		CATENTRY.CATENTRY_ID IN (?UniqueID?)    	
                		AND CATENTRY.MARKFORDELETE = 0
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun(s)-->
<!-- given the specified search criteria for the parent catgroup.  -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The parent catgrouop unique identifier.     -->
<!-- @param catalogEntryTypeCode - The catentry type(s) for which  -->
<!--        to retrieve.                                           --> 
<!-- @param STOREPATH:catalog- The catalog storepath               -->
<!-- @param CTX:CATALOG_ID - The catalog for which to retrieve     -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryTypeCode=) and ParentCatalogGroupIdentifier[(UniqueID=)]]
	base_table=CATENTRY
	sql=
		SELECT DISTINCT CATENTRY.$COLS:CATENTRY_ID$
	FROM
  		CATENTRY
  		 JOIN
		STORECENT ON
 			(CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
			 STORECENT.STOREENT_ID IN ($STOREPATH:catalog$))
		 LEFT OUTER JOIN
		CATGPENREL ON
			(CATGPENREL.CATENTRY_ID = CATENTRY.CATENTRY_ID)
		 LEFT OUTER JOIN
		CATGROUP ON
			(CATGPENREL.CATGROUP_ID = CATGROUP.CATGROUP_ID) 	 
	WHERE
		CATENTRY.MARKFORDELETE = 0 AND 	
		CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AND
		CATGROUP.CATGROUP_ID IN (?UniqueID?) AND
		(
			CATGPENREL.CATALOG_ID IS NULL OR
			CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$
		)				
		
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun   -->
<!-- given the specified part number.                              -->
<!-- Multiple results are returned if multiple part numbers are    -->
<!-- specified.	  
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param PartNumber - The part number(s) of the catalog entries to retrieve     -->
<!-- @param GroupIdentifier - The parent catalog group identifier       -->
<!--        for which to retrieve.                                 -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[ExternalIdentifier[(PartNumber=)]] and ParentCatalogGroupIdentifier[ExternalIdentifier[GroupIdentifier=]]]
	base_table=CATENTRY
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=GroupIdentifier:254
	sql=

		SELECT DISTINCT CATENTRY.$COLS:CATENTRY_ID$
	FROM
  		CATENTRY
  		 JOIN
		STORECENT ON
 			(CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
			 STORECENT.STOREENT_ID IN ($STOREPATH:catalog$))
		 LEFT OUTER JOIN
		CATGPENREL ON
			(CATGPENREL.CATENTRY_ID = CATENTRY.CATENTRY_ID)
			LEFT OUTER JOIN
		CATGROUP ON
			(CATGPENREL.CATGROUP_ID = CATGROUP.CATGROUP_ID) 	 			
		 
	WHERE
		CATENTRY.PARTNUMBER IN (?PartNumber?)  AND 
		CATENTRY.MARKFORDELETE = 0 AND
		1 = 
			CASE
				WHEN (CAST (?GroupIdentifier? AS VARCHAR(254)) = '' OR
					  CAST (?GroupIdentifier? AS VARCHAR(254)) IS NULL
					 )
					 THEN 1
				WHEN (
				 	  CATGROUP.IDENTIFIER LIKE CAST (?GroupIdentifier? AS VARCHAR(254))
				 	 ) 
				 	 THEN 1					 
				ELSE 0
			END
		 AND
		(
			CATGPENREL.CATALOG_ID IS NULL OR
			CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$
		)					 
	ORDER BY
		CATENTRY.CATENTRY_ID 
		

END_XPATH_TO_SQL_STATEMENT




<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry noun   -->
<!-- given the specified part number of the parent catalog entries.                              -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- @param PartNumber - The part number(s) of the parent catalog entries of the catalog entries to retrieve     -->
<!-- @param GroupIdentifier - The parent catalog group identifier       -->
<!--        for which to retrieve.                                 -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        child catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- @param Context:CatalogID - The catalog for which to retrieve  -->
<!--        the child catalog entry. This parameter is retrieved from    -->
<!--	    within the business context.           	               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[ParentCatalogEntryIdentifier[ExternalIdentifier[(PartNumber=)]] and ParentCatalogGroupIdentifier[ExternalIdentifier[GroupIdentifier=]]]
	base_table=CATENTRY
	className=com.ibm.commerce.foundation.server.services.dataaccess.db.jdbc.VarcharParametersTrimProcessor 
	param=GroupIdentifier:254
	sql=

		SELECT DISTINCT CATENTRY.$COLS:CATENTRY_ID$
	FROM
  		CATENTRY
  		 JOIN
		STORECENT ON
 			(CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND
			 STORECENT.STOREENT_ID IN ($STOREPATH:catalog$))
		JOIN
				CATENTREL ON
					(CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID)
		JOIN CATENTRY CATENTRYPARENT ON
					(CATENTREL.CATENTRY_ID_PARENT = CATENTRYPARENT.CATENTRY_ID)
							 	 			 
		LEFT OUTER JOIN
				CATGPENREL ON
					(CATGPENREL.CATENTRY_ID = CATENTRY.CATENTRY_ID)
		LEFT OUTER JOIN
				CATGROUP ON
					(CATGPENREL.CATGROUP_ID = CATGROUP.CATGROUP_ID) 	 
		 								
		 
	WHERE
		CATENTRYPARENT.PARTNUMBER IN (?PartNumber?) AND
		CATENTRY.MARKFORDELETE = 0 AND
		1 = 
			CASE
				WHEN (CAST (?GroupIdentifier? AS VARCHAR(254)) = '' OR
					  CAST (?GroupIdentifier? AS VARCHAR(254)) IS NULL
					 )
					 THEN 1
				WHEN (
				 	  CATGROUP.IDENTIFIER LIKE CAST (?GroupIdentifier? AS VARCHAR(254))
				 	 ) 
				 	 THEN 1					 
				ELSE 0
			END
		 AND
		(
			CATGPENREL.CATALOG_ID IS NULL OR
			CATGPENREL.CATALOG_ID = $CTX:CATALOG_ID$
		)					 
	ORDER BY
		CATENTRY.CATENTRY_ID 
		

END_XPATH_TO_SQL_STATEMENT



<!-- ====================================================================== 
	Get dynamic kit configuration base information based on catentry id.
	@param UniqueId The catentry id of the dynamic kit.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryConfigInfo[(UniqueID=)]]+IBM_Admin_DynamicKitConfigInfo_Get
	base_table=CATENTRY
	param=versionable
	sql=
		SELECT 
							CATENTRY.$COLS:CATENTRY$,		
	     				CATCONFINF.$COLS:CATCONFINF$,
	     				DKPDCCATENTREL.$COLS:DKPDCCATENTREL$,
	     				DKPREDEFCONF.$COLS:DKPREDEFCONF$
	     	FROM
	     	
					CATENTRY
		      	LEFT OUTER JOIN CATCONFINF ON (CATENTRY.CATENTRY_ID = CATCONFINF.CATENTRY_ID) 			     	
	     			LEFT OUTER JOIN DKPDCCATENTREL ON (CATENTRY.CATENTRY_ID = DKPDCCATENTREL.CATENTRY_ID AND DKPDCCATENTREL.SEQUENCE=0)
	     			LEFT OUTER JOIN DKPREDEFCONF ON (DKPDCCATENTREL.DKPREDEFCONF_ID = DKPREDEFCONF.DKPREDEFCONF_ID) 		 						  
	     	WHERE
						CATENTRY.CATENTRY_ID in (?UniqueID?)
						
    
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get dynamic kit configuration base and component information based on catentry id.
	@param UniqueId The catentry id of the dynamic kit.
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryConfigInfo[(UniqueID=)]]+IBM_Admin_DynamicKitConfigComponent_Get
	base_table=CATENTRY
	param=versionable
	sql=
		SELECT 
							CATENTRY.$COLS:CATENTRY$,		
	     				CATCONFINF.$COLS:CATCONFINF$,
	     				DKPDCCATENTREL.$COLS:DKPDCCATENTREL$,
	     				DKPREDEFCONF.$COLS:DKPREDEFCONF$,
	     				DKPDCCOMPLIST.$COLS:DKPDCCOMPLIST$,
	     				CHILD_CATENTRY.$COLS:CATENTRY$,
	     				CHILD_CATENTDESC.$COLS:CATENTDESC$,
	     				CHILD_STORECENT.$COLS:STORECENT$
	     	FROM
	     	
					CATENTRY
		      	LEFT OUTER JOIN CATCONFINF ON (CATENTRY.CATENTRY_ID = CATCONFINF.CATENTRY_ID)	     	
	     			LEFT OUTER JOIN DKPDCCATENTREL ON (CATENTRY.CATENTRY_ID = DKPDCCATENTREL.CATENTRY_ID AND DKPDCCATENTREL.SEQUENCE=0)
	     			LEFT OUTER JOIN DKPREDEFCONF ON (DKPDCCATENTREL.DKPREDEFCONF_ID = DKPREDEFCONF.DKPREDEFCONF_ID) 		 		
	     			LEFT OUTER JOIN DKPDCCOMPLIST ON (DKPDCCOMPLIST.DKPREDEFCONF_ID = DKPDCCATENTREL.DKPREDEFCONF_ID)	
	     			LEFT OUTER JOIN CATENTRY CHILD_CATENTRY ON (CHILD_CATENTRY.CATENTRY_ID = DKPDCCOMPLIST.CATENTRY_ID)					 
	     			LEFT OUTER JOIN CATENTDESC CHILD_CATENTDESC ON (CHILD_CATENTDESC.CATENTRY_ID = CHILD_CATENTRY.CATENTRY_ID AND CHILD_CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
	     			LEFT OUTER JOIN STORECENT CHILD_STORECENT ON (CHILD_STORECENT.CATENTRY_ID = CHILD_CATENTRY.CATENTRY_ID AND CHILD_STORECENT.STOREENT_ID IN ($STOREPATH:catalog$) )

	     	WHERE
						CATENTRY.CATENTRY_ID in (?UniqueID?)
						
    
END_XPATH_TO_SQL_STATEMENT


<!-- ====================================================================== 
	Get dynamic kit configuration base and component information based on catentry id.
	This query will be used to retrieve information under the content version.
	@param UniqueId The catentry id of the dynamic kit.
=========================================================================== -->

BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryConfigInfo[(UniqueID=)]]+IBM_Admin_DynamicKitConfigComponent_Get_Version
	base_table=CATENTRY
	param=versionable
	sql=
	SELECT 
					$VERSION$.CATENTRY.$COLS:CATENTRY$,		
	     				$VERSION$.CATCONFINF.$COLS:CATCONFINF$,
	     				$VERSION$.DKPDCCATENTREL.$COLS:DKPDCCATENTREL$,
	     				$VERSION$.DKPREDEFCONF.$COLS:DKPREDEFCONF$,
	     				$VERSION$.DKPDCCOMPLIST.$COLS:DKPDCCOMPLIST$,
	     				CHILD_CATENTRY.$COLS:CATENTRY$,
	     				CHILD_CATENTDESC.$COLS:CATENTDESC$,
	     				CHILD_STORECENT.$COLS:STORECENT$

	     	FROM
	     	
					$VERSION$.CATENTRY
					
		      	LEFT OUTER JOIN $VERSION$.CATCONFINF ON ($VERSION$.CATENTRY.CMVERSNINFO_ID = $VERSION$.CATCONFINF.CMVERSNINFO_ID AND $VERSION$.CATENTRY.CATENTRY_ID = $VERSION$.CATCONFINF.CATENTRY_ID)	     	
	     			LEFT OUTER JOIN $VERSION$.DKPDCCATENTREL ON ($VERSION$.CATENTRY.CMVERSNINFO_ID = $VERSION$.DKPDCCATENTREL.CMVERSNINFO_ID AND $VERSION$.CATENTRY.CATENTRY_ID = $VERSION$.DKPDCCATENTREL.CATENTRY_ID AND $VERSION$.DKPDCCATENTREL.SEQUENCE=0)
	     			LEFT OUTER JOIN $VERSION$.DKPREDEFCONF ON ($VERSION$.CATENTRY.CMVERSNINFO_ID = $VERSION$.DKPREDEFCONF.CMVERSNINFO_ID AND $VERSION$.DKPDCCATENTREL.DKPREDEFCONF_ID = $VERSION$.DKPREDEFCONF.DKPREDEFCONF_ID) 		 		
	     			LEFT OUTER JOIN $VERSION$.DKPDCCOMPLIST ON ($VERSION$.CATENTRY.CMVERSNINFO_ID = $VERSION$.DKPDCCOMPLIST.CMVERSNINFO_ID AND  $VERSION$.DKPDCCOMPLIST.DKPREDEFCONF_ID =  $VERSION$.DKPDCCATENTREL.DKPREDEFCONF_ID)	
	     			LEFT OUTER JOIN CATENTRY CHILD_CATENTRY ON (CHILD_CATENTRY.CATENTRY_ID = $VERSION$.DKPDCCOMPLIST.CATENTRY_ID)					 
	     			LEFT OUTER JOIN CATENTDESC CHILD_CATENTDESC ON (CHILD_CATENTDESC.CATENTRY_ID = CHILD_CATENTRY.CATENTRY_ID AND CHILD_CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
	     			LEFT OUTER JOIN STORECENT CHILD_STORECENT ON (CHILD_STORECENT.CATENTRY_ID = CHILD_CATENTRY.CATENTRY_ID AND CHILD_STORECENT.STOREENT_ID IN ($STOREPATH:catalog$) )
	     			
	     	WHERE
						$VERSION$.CATENTRY.CATENTRY_ID in (?UniqueID?) AND $VERSION$.CATENTRY.CMVERSNINFO_ID = $VERSION_ID$

    
END_XPATH_TO_SQL_STATEMENT



<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) in the store.                                         -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_DataExtract					   					   -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[ExternalIdentifier[StoreIdentifier[(UniqueID=)]]]]
	base_table=CATENTRY
	className=com.ibm.commerce.catalogentry.facade.server.services.dataaccess.db.jdbc.CatalogEntryDataExtractSQLComposer
	sql=
			SELECT 
	     				CATENTRY.$COLS:CATENTRY_ID$
	     	FROM
	     				CATENTRY 
					JOIN
					STORECENT ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID)
					
			WHERE
					CATENTRY.CATENTTYPE_ID != 'ItemBean' AND CATENTRY.CATENTTYPE_ID != 'BundleBean'
					AND CATENTRY.BUYABLE=1 AND 
					CATENTRY.MARKFORDELETE=0 AND
					STORECENT.STOREENT_ID IN (?UniqueID?)		
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) which refer to the given catalog entry (unique        -->
<!-- identifier) through a Bundle/Kit association.                 -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_Details, IBM_Admin_Summary, IBM_Admin_All and all other catalog entry -->
<!-- profiles.				                                       -->
<!-- dkMark: The token used to replace the dynamic kit related SQLs.  -->
<!-- @param catalogEntryTypeCode - The catentry type for which     -->
<!--        to retrieve. Can be 'BundleBean' or 'DynamicKitBean'   -->
<!--        for bundle and kits respectively.                      -->     
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[(@catalogEntryTypeCode=) and KitComponent[CatalogEntryReference[CatalogEntryIdentifier[(UniqueID=)]]]]
	sql_key_processor=com.ibm.commerce.catalog.facade.server.services.dataaccess.processor.CatalogEntryFilterKeyProcessor	
	className=com.ibm.commerce.catalog.facade.server.services.dataaccess.db.jdbc.KitComponentReferenceSQLComposer 
	base_table=CATENTRY
	param=dkMark_AddDynamikKitRelatedQuery	
	sql=
	
	SELECT CATENTRY_ID FROM
  (

		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$
		FROM
				CATENTRY
				JOIN 
				CATENTREL ON
					(CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_PARENT)
		WHERE
               CATENTREL.CATENTRY_ID_CHILD IN (?UniqueID?) AND
               CATENTRY.CATENTTYPE_ID IN (?catalogEntryTypeCode?) AddDynamikKitRelatedQuery
	) T1 ORDER BY T1.CATENTRY_ID               
         
END_XPATH_TO_SQL_STATEMENT

<!-- ============================================================= -->
<!-- This SQL will return the elements of the Catalog Entry        -->
<!-- noun(s) including the category level SKUs in the store.                                         -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_DataExtract					   					   -->
<!-- @param Context:StoreID - The store for which to retrieve the  -->
<!--        catalog entry. This parameter is retrieved from within -->
<!--	    the business context.           	                   -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[ExternalIdentifier[StoreIdentifier[(UniqueID=)]]] and IncludeCategoryLevelSKU]
	base_table=CATENTRY
	className=com.ibm.commerce.catalogentry.facade.server.services.dataaccess.db.jdbc.CatalogEntryDataExtractSQLComposer
	sql=
                   SELECT 
                         CATENTRY.$COLS:CATENTRY_ID$
                   FROM
                         CATENTRY 
                   JOIN
                         STORECENT ON (CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID IN (?UniqueID?))
                                        
                   WHERE NOT EXISTS 
                         (SELECT 1 FROM CATENTREL WHERE CATENTREL.CATENTRY_ID_CHILD = CATENTRY.CATENTRY_ID AND CATENTREL.CATRELTYPE_ID = 'PRODUCT_ITEM') AND 
                         CATENTRY.CATENTTYPE_ID != 'BundleBean' AND 
                         CATENTRY.BUYABLE=1 AND 
                         CATENTRY.MARKFORDELETE=0       	
END_XPATH_TO_SQL_STATEMENT


<!-- ============================================================= -->
<!-- This SQL will return the catalog entries to which the         -->
<!-- specified attribute is associated.                            -->
<!-- Multiple results are returned if multiple identifiers are     -->
<!-- specified.	                                                   -->
<!-- The access profiles that apply to this SQL are:               -->
<!-- IBM_Admin_CatalogEntryAttributeReference 					   -->
<!-- profiles.				                                       -->
<!-- @param UniqueID - The identifier(s) for which to retrieve     -->
<!-- @param Context:StoreId - The store for which the attribute    -->
<!--        and catalog entries belong. This parameter is          -->
<!--        retrieved from within the business context.            -->
<!--                                                               -->
<!-- ============================================================= -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryAttributes[AttributeIdentifier[(UniqueID=)]]]
	base_table=CATENTRY	
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$,
				CATENTRYATTR.$COLS:CATENTRYATTR$	
		FROM
				CATENTRY
					JOIN STORECENT ON STORECENT.CATENTRY_ID=CATENTRY.CATENTRY_ID 
							AND STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
				    JOIN CATENTRYATTR ON CATENTRYATTR.CATENTRY_ID = CATENTRY.CATENTRY_ID
 				    
    WHERE
        CATENTRY.MARKFORDELETE = 0 AND CATENTRYATTR.ATTR_ID IN (?UniqueID?)

END_XPATH_TO_SQL_STATEMENT


<!-- =================================================================================================================================== -->
<!-- This SQL will return the merchandising associations for the Catalog Entry     -->
<!-- 	This query will be used to retrieve information under the content version.   -->
<!-- 	@param UniqueId The unique id of the catalog entry which has merchandising associations to be returned.						 -->
<!-- =================================================================================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryIdentifier[UniqueID=]]/Association+IBM_Admin_CatalogEntryMerchandisingAssociations_Get_Version
	base_table=CATENTRY
	param=versionable
    sql=

		SELECT 
					$VERSION$.CATENTRY.$COLS:CATENTRY$,		
	     		$VERSION$.MASSOCCECE.$COLS:MASSOCCECE$,
	     		TO_CATENTRY.$COLS:CATENTRY$,
	     		TO_CATENTDESC.$COLS:CATENTDESC$,
	     		TO_STORECENT.$COLS:STORECENT$

		FROM
	     	
				$VERSION$.CATENTRY
					
		      LEFT OUTER JOIN $VERSION$.MASSOCCECE ON 		
		      	($VERSION$.MASSOCCECE.CMVERSNINFO_ID = $VERSION_ID$ AND	
        			$VERSION$.MASSOCCECE.CATENTRY_ID_FROM = $VERSION$.CATENTRY.CATENTRY_ID AND
							$VERSION$.MASSOCCECE.STORE_ID IN ($STOREPATH:catalog$) )	     	
	     				
	     		LEFT OUTER JOIN CATENTRY TO_CATENTRY ON 
						(TO_CATENTRY.CATENTRY_ID = $VERSION$.MASSOCCECE.CATENTRY_ID_TO AND
						 TO_CATENTRY.MARKFORDELETE = 0)			
	     		LEFT OUTER JOIN CATENTDESC TO_CATENTDESC ON 
	     			(TO_CATENTDESC.CATENTRY_ID = TO_CATENTRY.CATENTRY_ID AND TO_CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
	     		LEFT OUTER JOIN STORECENT TO_STORECENT ON 
	     			(TO_STORECENT.CATENTRY_ID = TO_CATENTRY.CATENTRY_ID AND TO_STORECENT.STOREENT_ID IN ($STOREPATH:catalog$) )						 
	     			
	     	WHERE
						$VERSION$.CATENTRY.CATENTRY_ID in (?UniqueID?) 

				ORDER BY
        	$VERSION$.MASSOCCECE.RANK	

END_XPATH_TO_SQL_STATEMENT



<!-- ========================================================================= -->
<!-- =============================ASSOCIATION QUERIES========================= -->
<!-- ========================================================================= -->

<!-- =============================================================================
     Adds store identifier (STORECENT table) of catalog entry to the 
     resultant data graph.                                                 
     ============================================================================= -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryStoreIdentifier
	base_table=STORECENT
	param=versionable
	sql=

		SELECT 
			STORECENT.$COLS:STORECENT:CATENTRY_ID$,
			STORECENT.$COLS:STORECENT:STOREENT_ID$
		FROM 
			STORECENT 
		WHERE 
			STORECENT.CATENTRY_ID IN ($UNIQUE_IDS$) AND
			STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
END_ASSOCIATION_SQL_STATEMENT			
<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info 				                   -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntry
	base_table=CATENTRY
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY$
		FROM
				CATENTRY
		WHERE
                CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentry descrition Info 				               -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDescription
	base_table=CATENTDESC
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATENTDESC.$COLS:CATENTDESC$
		FROM
				CATENTDESC
				        	
		WHERE
                CATENTDESC.CATENTRY_ID IN ($UNIQUE_IDS$) AND CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
END_ASSOCIATION_SQL_STATEMENT
<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info with description                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntryWithDescription
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY$,
				CATENTDESC.$COLS:CATENTDESC$
		FROM
				CATENTRY
				        LEFT OUTER JOIN CATENTDESC ON CATENTDESC.CATENTRY_ID = CATENTRY.CATENTRY_ID 
				        	AND CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Item Info                                       -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntryWithBaseItem
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
		        CATENTRY.$COLS:CATENTRY_ID$,
		        CATENTRY.$COLS:CATENTRY:BASEITEM_ID$,
			BASEITEM.$COLS:BASEITEM$,
			ITEMVERSN.$COLS:ITEMVERSN$,
			STOREITEM.$COLS:STOREITEM$,
                	BASEITMDSC.$COLS:BASEITMDSC$
		FROM
			CATENTRY
			        JOIN BASEITEM ON CATENTRY.BASEITEM_ID = BASEITEM.BASEITEM_ID 
			        JOIN ITEMVERSN ON ITEMVERSN.BASEITEM_ID = BASEITEM.BASEITEM_ID
			        JOIN STOREITEM ON STOREITEM.BASEITEM_ID= BASEITEM.BASEITEM_ID
			            AND STOREITEM.STOREENT_ID IN ($STOREPATH:catalog$)
			        JOIN BASEITMDSC ON BASEITMDSC.BASEITEM_ID =BASEITEM.BASEITEM_ID AND
			            BASEITMDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		WHERE
			CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Item Spc Info                                   -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntryWithItemSpc
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 		                 
		        CATENTRY.$COLS:CATENTRY_ID$,
		        CATENTRY.$COLS:CATENTRY:ITEMSPC_ID$,
		        BASEITEM.$COLS:BASEITEM$,
			ITEMSPC.$COLS:ITEMSPC$,
			VERSIONSPC.$COLS:VERSIONSPC$,
			STOREITEM.$COLS:STOREITEM$

		FROM
			CATENTRY
			        JOIN ITEMSPC ON CATENTRY.ITEMSPC_ID  = ITEMSPC.ITEMSPC_ID  
			        JOIN VERSIONSPC ON VERSIONSPC.ITEMSPC_ID= ITEMSPC.ITEMSPC_ID
			        JOIN BASEITEM ON BASEITEM.BASEITEM_ID = ITEMSPC.BASEITEM_ID
			        JOIN STOREITEM ON STOREITEM.BASEITEM_ID= ITEMSPC.BASEITEM_ID
			            AND STOREITEM.STOREENT_ID IN ($STOREPATH:catalog$)
				       
		WHERE
			CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info with summary                      -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_RootCatalogEntryWithSummary
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$, CATENTRY.$COLS:CATENTRY:PARTNUMBER$, 
				CATENTRY.$COLS:CATENTRY:MEMBER_ID$, CATENTRY.$COLS:CATENTRY:CATENTTYPE_ID$,
				CATENTDESC.$COLS:CATENTDESC:CATENTRY_ID$, CATENTDESC.$COLS:CATENTDESC:LANGUAGE_ID$,
				CATENTDESC.$COLS:CATENTDESC:NAME$, CATENTDESC.$COLS:CATENTDESC:SHORTDESCRIPTION$,
				CATENTDESC.$COLS:CATENTDESC:THUMBNAIL$
		FROM
				CATENTRY
				 LEFT OUTER JOIN
				CATENTDESC ON 
					(CATENTDESC.CATENTRY_ID = CATENTRY.CATENTRY_ID 	AND 
					 CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentry summary                                     -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntrySummary
	base_table=CATENTDESC
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATENTDESC.$COLS:CATENTDESC:CATENTRY_ID$, CATENTDESC.$COLS:CATENTDESC:LANGUAGE_ID$,
				CATENTDESC.$COLS:CATENTDESC:NAME$, CATENTDESC.$COLS:CATENTDESC:SHORTDESCRIPTION$,
				CATENTDESC.$COLS:CATENTDESC:THUMBNAIL$
		FROM
				CATENTDESC
		WHERE
                CATENTDESC.CATENTRY_ID IN ($UNIQUE_IDS$) AND
                CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
                
END_ASSOCIATION_SQL_STATEMENT


<!-- =============================================================================
     Adds classic defining attributes (ATTRIBUTE table) of catalog entries to the 
     resultant data graph.                                                 
     ============================================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeSchema_Defining
	base_table=ATTRIBUTE
	param=versionable
	sql=
	
		SELECT 
				ATTRIBUTE.$COLS:ATTRIBUTE$
		FROM
				ATTRIBUTE
        WHERE
				ATTRIBUTE.CATENTRY_ID IN ($UNIQUE_IDS$) AND
				(ATTRIBUTE.USAGE = '1' OR ATTRIBUTE.USAGE IS NULL ) AND
            	ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
        ORDER BY
        		ATTRIBUTE.SEQUENCE
        	
END_ASSOCIATION_SQL_STATEMENT



<!-- =============================================================================
     Adds the schemas of classic defining attributes to the resultant data graph.                                                 
     ============================================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeSchema_Defining
	base_table=ATTRIBUTE
	sql=
		SELECT 
			ATTRIBUTE.$COLS:ATTRIBUTE$ 
		FROM 
			ATTRIBUTE  
		WHERE
			ATTRIBUTE.ATTRIBUTE_ID IN ($UNIQUE_IDS$) AND
			(ATTRIBUTE.USAGE = '1' OR ATTRIBUTE.USAGE IS NULL ) AND
			ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRIBUTE.SEQUENCE

END_ASSOCIATION_SQL_STATEMENT





<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds merchandising associations info                      -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryMerchandisingAssociations
	base_table=MASSOCCECE
	additional_entity_objects=true
	sql=
		SELECT 
			MASSOCCECE.$COLS:MASSOCCECE$
		FROM
			MASSOCCECE
	    WHERE
        	MASSOCCECE.CATENTRY_ID_FROM IN ($UNIQUE_IDS$) AND
        	MASSOCCECE.STORE_ID IN ($STOREPATH:catalog$)
        ORDER BY
        	MASSOCCECE.RANK	
	               	
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL with noun parts paging:               -->
<!-- Adds merchandising associations info of current page      -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryMerchandisingAssociations_Paging
	base_table=MASSOCCECE
	param=versionable
	sql=
		SELECT 
			MASSOCCECE.$COLS:MASSOCCECE$
		FROM
			MASSOCCECE
 			JOIN
					CATENTRY ON
						(CATENTRY.CATENTRY_ID = MASSOCCECE.CATENTRY_ID_TO AND
						 CATENTRY.MARKFORDELETE = 0)		 			
			
	    WHERE
	    	MASSOCCECE.MASSOCCECE_ID IN ($SUBENTITY_PKS$) AND
        	MASSOCCECE.CATENTRY_ID_FROM IN ($UNIQUE_IDS$) AND
        	MASSOCCECE.STORE_ID IN ($STOREPATH:catalog$)
        ORDER BY
        	MASSOCCECE.RANK	
	               	
END_ASSOCIATION_SQL_STATEMENT


<!-- =============================================================================
     Adds classic attributes (ATTRIBUTE table) of catalog entries to the 
     resultant data graph.                                                 
     ============================================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeSchema_Paging
	param=versionable
	base_table=ATTRIBUTE
	sql=
	
		SELECT 
			ATTRIBUTE.$COLS:ATTRIBUTE$
		FROM
			ATTRIBUTE
		WHERE
			ATTRIBUTE.CATENTRY_ID IN ($UNIQUE_IDS$) AND		
			ATTRIBUTE.ATTRIBUTE_ID IN ($SUBENTITY_PKS$) AND
			ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRIBUTE.SEQUENCE, ATTRIBUTE.ATTRIBUTE_ID
        	
END_ASSOCIATION_SQL_STATEMENT


BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeAttributeValue_Paging
	base_table=ATTRVALUE
	param=versionable
	sql=
		SELECT 
				ATTRVALUE.$COLS:ATTRVALUE$
		FROM
				ATTRVALUE 
        WHERE
                ATTRVALUE.CATENTRY_ID IN ($UNIQUE_IDS$) AND
                ATTRVALUE.ATTRIBUTE_ID IN ($SUBENTITY_PKS$) AND
                ATTRVALUE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
        ORDER BY
        	    ATTRVALUE.SEQUENCE, ATTRVALUE.ATTRVALUE_ID    
                
END_ASSOCIATION_SQL_STATEMENT

<!-- ===================================================================== 
     Adds sumary description (CATENTDESC) of associated catalog entries 
     to the resultant data graph.                               
     ================================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AssociatedCatalogEntrySummary
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$, CATENTRY.$COLS:CATENTRY:MEMBER_ID$,
				CATENTRY.$COLS:CATENTRY:ITEMSPC_ID$, CATENTRY.$COLS:CATENTRY:CATENTTYPE_ID$,
				CATENTRY.$COLS:CATENTRY:PARTNUMBER$,
				CATENTDESC.$COLS:CATENTDESC$,
				STORECENT.$COLS:STORECENT:CATENTRY_ID$,
				STORECENT.$COLS:STORECENT:STOREENT_ID$
				
		FROM
				STORECENT, CATENTRY
				LEFT OUTER JOIN
					CATENTDESC ON 
						(CATENTDESC.CATENTRY_ID = CATENTRY.CATENTRY_ID 	AND 
					 	CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
		WHERE
               CATENTRY.CATENTRY_ID IN ($UNIQUE_IDS$) AND 
               CATENTRY.MARKFORDELETE = 0 AND
               CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND 
               STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds child catentry info                                  -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryChildrenRelationships
	base_table=CATENTREL
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
			CATENTREL.$COLS:CATENTREL$
		FROM
			CATENTREL  
		WHERE
        		CATENTREL.CATENTRY_ID_PARENT IN ($UNIQUE_IDS$)  
		ORDER BY

        		CATENTREL.SEQUENCE	
        		
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds parent catgroup info                                 -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryToCatalogGroupRelationship
	base_table=CATGPENREL
	param=versionable
	sql=
		SELECT 
				CATGPENREL.$COLS:CATGPENREL$
		FROM
				CATGPENREL
        WHERE
        		CATGPENREL.CATENTRY_ID IN ($UNIQUE_IDS$)
                
END_ASSOCIATION_SQL_STATEMENT



<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info with price                        -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryPriceAssocSQL
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY$,
				LISTPRICE.$COLS:LISTPRICE$
		FROM
				CATENTRY
				 LEFT OUTER JOIN
				LISTPRICE ON (CATENTRY.CATENTRY_ID = LISTPRICE.CATENTRY_ID) 
		WHERE
               	CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info with summary and price            -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntrySummaryWithPriceAssocSQL
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$, CATENTRY.$COLS:CATENTRY:PARTNUMBER$, 
				CATENTRY.$COLS:CATENTRY:MEMBER_ID$, CATENTRY.$COLS:CATENTRY:CATENTTYPE_ID$,
				CATENTDESC.$COLS:CATENTDESC:CATENTRY_ID$, CATENTDESC.$COLS:CATENTDESC:LANGUAGE_ID$,
				CATENTDESC.$COLS:CATENTDESC:NAME$, CATENTDESC.$COLS:CATENTDESC:SHORTDESCRIPTION$,
				CATENTDESC.$COLS:CATENTDESC:THUMBNAIL$,CATENTDESC.$COLS:CATENTDESC:PUBLISHED$,
				LISTPRICE.$COLS:LISTPRICE$
		FROM
				CATENTRY
				 LEFT OUTER JOIN
				CATENTDESC ON 
					(CATENTDESC.CATENTRY_ID = CATENTRY.CATENTRY_ID 	AND 
					 CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				LISTPRICE ON 
					(CATENTRY.CATENTRY_ID = LISTPRICE.CATENTRY_ID)
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info with description and price        -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDescriptionWithPriceAssocSQL
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY$,
				CATENTDESC.$COLS:CATENTDESC$,
				LISTPRICE.$COLS:LISTPRICE$
		FROM
				CATENTRY
				 LEFT OUTER JOIN
				CATENTDESC ON 
					(CATENTDESC.CATENTRY_ID = CATENTRY.CATENTRY_ID 	AND 
					 CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				LISTPRICE ON 
					(CATENTRY.CATENTRY_ID = LISTPRICE.CATENTRY_ID)
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ============================================================ -->
<!-- This associated SQL:                                         -->
<!-- Adds Base Catentry Info with description,price and shipment  -->
<!-- to the resultant data graph.                                 -->
<!-- ============================================================ -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDescriptionWithPriceWithShipmentAssocSQL
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY$,
				CATENTDESC.$COLS:CATENTDESC$,
				LISTPRICE.$COLS:LISTPRICE$,
				CATENTSHIP.$COLS:CATENTSHIP$
		FROM
				CATENTRY
				 LEFT OUTER JOIN
				CATENTDESC ON 
					(CATENTDESC.CATENTRY_ID = CATENTRY.CATENTRY_ID 	AND 
					 CATENTDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
				 LEFT OUTER JOIN
				LISTPRICE ON 
					(CATENTRY.CATENTRY_ID = LISTPRICE.CATENTRY_ID)
				 LEFT OUTER JOIN
				CATENTSHIP ON
					(CATENTSHIP.CATENTRY_ID = CATENTRY.CATENTRY_ID) 
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds list price (LISTPRICE) of catalog entries 
     to the resultant data graph.                               
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryShipment
	base_table=CATENTSHIP
	sql=

		SELECT 
			CATENTSHIP.$COLS:CATENTSHIP$
		FROM 
			CATENTSHIP 
		WHERE 
			CATENTSHIP.CATENTRY_ID IN ($UNIQUE_IDS$)
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================ -->
<!-- This associated SQL:                                         -->
<!-- Adds Attachment Reference Description Info                   -->
<!-- to the resultant data graph.                                 -->
<!-- ============================================================ -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttachmentReferenceDescription
	base_table=CATENTRY
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY_ID$, 
				CATENTRY.$COLS:CATENTRY:CATENTTYPE_ID$,
				ATCHREL.$COLS:ATCHREL$, 
				ATCHRLUS.$COLS:ATCHRLUS$, 
				ATCHRELDSC.$COLS:ATCHRELDSC$
		FROM
				CATENTRY
				JOIN ATCHREL ON ATCHREL.BIGINTOBJECT_ID = CATENTRY.CATENTRY_ID
				JOIN ATCHRLUS ON ATCHREL.ATCHRLUS_ID = ATCHRLUS.ATCHRLUS_ID
				JOIN ATCHOBJTYP ON (ATCHREL.ATCHOBJTYP_ID = ATCHOBJTYP.ATCHOBJTYP_ID AND ATCHOBJTYP.IDENTIFIER = 'CATENTRY')
				LEFT OUTER JOIN ATCHRELDSC ON (ATCHREL.ATCHREL_ID = ATCHRELDSC.ATCHREL_ID AND ATCHRELDSC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$))
		WHERE
		        CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$) 
  
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Base Catentry Info with descriptions in all          -->
<!-- languages to the resultant data graph.                    -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryWithAllDescriptions
	base_table=CATENTRY
	additional_entity_objects=true
	sql=
		SELECT 
				CATENTRY.$COLS:CATENTRY$,
				CATENTDESC.$COLS:CATENTDESC$
		FROM
				CATENTRY
				 LEFT OUTER JOIN
				CATENTDESC ON 
					(CATENTDESC.CATENTRY_ID = CATENTRY.CATENTRY_ID) 
		WHERE
               CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT





<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentry description Info (all languages)            -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDescriptionAllLanguages
	base_table=CATENTDESC
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATENTDESC.$COLS:CATENTDESC$
		FROM
				CATENTDESC
				        	
		WHERE
                CATENTDESC.CATENTRY_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT 



<!-- ========================================================== 
     Adds identifiers (CATGROUP, STORECGRP) of catalog groups 
     to the resultant data graph.                               
     ========================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT     
    name=IBM_CatalogGroupIdentifier
	base_table=CATGROUP
	param=versionable
	sql=
	
		SELECT 
			CATGROUP.$COLS:CATGROUP_ID$,
			CATGROUP.$COLS:CATGROUP:MEMBER_ID$,
			CATGROUP.$COLS:CATGROUP:IDENTIFIER$,
			STORECGRP.$COLS:STORECGRP:CATGROUP_ID$,
			STORECGRP.$COLS:STORECGRP:STOREENT_ID$
		FROM 
			CATGROUP,STORECGRP 
		WHERE 
			CATGROUP.CATGROUP_ID IN ($UNIQUE_IDS$) AND CATGROUP.MARKFORDELETE = 0 AND 
			CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND STORECGRP.STOREENT_ID IN ($STOREPATH:catalog$)

END_ASSOCIATION_SQL_STATEMENT

<!-- ============================================================== -->
<!-- This associated SQL:                                           -->
<!-- Adds parent info of a SKU or a PDK (PRODUCT_ITEM or DK_PDK relationship)  -->
<!-- to the resultant data graph.                                   -->
<!-- ============================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_ParentCatalogEntryForRootRelationships
	base_table=CATENTREL
	param=versionable
	sql=
		SELECT 
				CATENTREL.$COLS:CATENTREL$
		FROM
				CATENTREL
		WHERE
				CATENTREL.CATENTRY_ID_CHILD IN ($UNIQUE_IDS$) AND
				CATENTREL.CATRELTYPE_ID IN( 'PRODUCT_ITEM','DK_PDK')
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds identifiers (CATENTRY, STORECENT) of catalog entries 
     to the resultant data graph.                               
     ========================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryIdentifier
	base_table=CATENTRY
	sql=

		SELECT 
			CATENTRY.$COLS:CATENTRY_ID$,
			CATENTRY.$COLS:CATENTRY:MEMBER_ID$,
			CATENTRY.$COLS:CATENTRY:PARTNUMBER$,
			CATENTRY.$COLS:CATENTRY:ITEMSPC_ID$,
			CATENTRY.$COLS:CATENTRY:CATENTTYPE_ID$,			
			STORECENT.$COLS:STORECENT:CATENTRY_ID$,
			STORECENT.$COLS:STORECENT:STOREENT_ID$
		FROM 
			CATENTRY, STORECENT 
		WHERE 
			CATENTRY.CATENTRY_ID IN ($UNIQUE_IDS$) AND CATENTRY.MARKFORDELETE = 0 AND 
			CATENTRY.CATENTRY_ID = STORECENT.CATENTRY_ID AND STORECENT.STOREENT_ID IN ($STOREPATH:catalog$)

END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds list price (LISTPRICE) of catalog entries 
     to the resultant data graph.                               
     ========================================================== -->
     
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryListPrice
	base_table=LISTPRICE
	param=versionable
	sql=

		SELECT 
			LISTPRICE.$COLS:LISTPRICE$
		FROM 
			LISTPRICE 
		WHERE 
			LISTPRICE.CATENTRY_ID IN ($UNIQUE_IDS$)
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentsubs Info 				               							 -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntrySubscription
	base_table=CATENTSUBS
	param=versionable
	sql=
		SELECT 
				CATENTSUBS.$COLS:CATENTSUBS$
		FROM 
				CATENTSUBS 
		WHERE 
        CATENTSUBS.CATENTRY_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Adds base attributes information of catalog entry         -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
       name=IBM_CatalogEntryBaseAttributes
       base_table=CATENTRY
       additional_entity_objects=false
       sql=
              SELECT 
                            CATENTRY.$COLS:CATENTRY_BASE_ATTRS$
              FROM
                            CATENTRY
              WHERE
                            CATENTRY.CATENTRY_ID IN ($ENTITY_PKS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== -->
<!-- Adds base attributes information of catalog entry's        -->
<!-- parent to the resultant data graph.                        -->
<!-- ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
       name=IBM_ExistingCatalogEntryParentBaseAttributes
       base_table=CATENTRY
       additional_entity_objects=false
       sql=
              SELECT 
                            CATENTRY.$COLS:CATENTRY_BASE_ATTRS$
              FROM
                            CATENTRY,CATENTREL              
              WHERE
							CATENTREL.CATENTRY_ID_CHILD IN ($ENTITY_PKS$) AND
							CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_PARENT AND
							CATENTRY.MARKFORDELETE = 0
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== -->
<!-- Adds base attributes information of catalog entry's        -->
<!-- children to the resultant data graph.                      -->
<!-- ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
       name=IBM_ExistingCatalogEntryChildBaseAttributes
       base_table=CATENTRY
       additional_entity_objects=false
       sql=
              SELECT 
                            CATENTRY.$COLS:CATENTRY_BASE_ATTRS$
              FROM
                            CATENTRY,CATENTREL              
			  WHERE
							CATENTREL.CATENTRY_ID_PARENT IN ($ENTITY_PKS$) AND
							CATENTRY.CATENTRY_ID = CATENTREL.CATENTRY_ID_CHILD AND
							CATENTRY.MARKFORDELETE = 0
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== -->
<!-- Adds classic attributes (ATTRIBUTE table) of               -->
<!-- catalog entries to the resultant data graph.               -->
<!-- ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
		name=IBM_CatalogEntryAttributeSchema
		base_table=ATTRIBUTE
		sql=	
			  SELECT 
							ATTRIBUTE.$COLS:ATTRIBUTE$
			  FROM
							ATTRIBUTE
			  WHERE
							ATTRIBUTE.CATENTRY_ID IN ($UNIQUE_IDS$) AND
							ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
			  ORDER BY
							ATTRIBUTE.SEQUENCE        	
END_ASSOCIATION_SQL_STATEMENT

<!-- =============================================================================
     Adds allowed values of classic attributes (ATTRVALUE table) to the 
     resultant data graph.                                                 
     ============================================================================= -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeAllowedValue
	base_table=ATTRVALUE
	param=versionable
	sql=
		SELECT 
			ATTRVALUE.$COLS:ATTRVALUE$ 
		FROM 
			ATTRVALUE  
		WHERE
			ATTRVALUE.ATTRIBUTE_ID IN ($UNIQUE_IDS$) AND
			ATTRVALUE.CATENTRY_ID = 0 AND
			ATTRVALUE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRVALUE.SEQUENCE
				
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== -->
<!-- Adds the catalog entry and attribute dictionary            -->
<!-- attribute relationship (CATENTRYATTR table)                -->                                
<!-- to the resultant data graph.                               --> 
<!-- ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
		name=IBM_CatalogEntryAttributeDictionaryAttribute
		base_table=CATENTRYATTR
		sql=
			  SELECT 
							CATENTRYATTR.$COLS:CATENTRYATTR$
			  FROM
							CATENTRYATTR
			  WHERE
							CATENTRYATTR.CATENTRY_ID IN ($UNIQUE_IDS$)
			  ORDER BY
							CATENTRYATTR.SEQUENCE
END_ASSOCIATION_SQL_STATEMENT

<!-- =========================================================== --> 
<!-- Adds the base information of attribute dictionary           -->
<!-- attributes (ATTR table) to the resultant data graph.        -->                    
<!-- =========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
		name=IBM_AttributeDictionaryAttributeSchema
		base_table=ATTR
		sql=
			  SELECT 
							ATTR.$COLS:ATTR$, FACET.$COLS:FACET$
			  FROM
							ATTR
							LEFT OUTER JOIN FACET ON ATTR.ATTR_ID=FACET.ATTR_ID
			  WHERE
							ATTR.ATTR_ID IN ($UNIQUE_IDS$) AND 
							ATTR.STOREENT_ID IN ($STOREPATH:catalog$)
			
END_ASSOCIATION_SQL_STATEMENT

<!-- =========================================================== --> 
<!-- Adds the description of attribute dictionary attributes     -->   
<!-- (ATTRDESC table) to the resultant data graph.               -->           
<!-- =========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
		name=IBM_AttributeDictionaryAttributeSchemaDescription
		base_table=ATTRDESC
		sql=
			  SELECT 
							ATTRDESC.$COLS:ATTRDESC$
			  FROM
							ATTRDESC
			  WHERE		
							ATTRDESC.ATTR_ID IN ($UNIQUE_IDS$) AND
							ATTRDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the allowed values of attribute dictionary 
     attributes (ATTRVAL table) to the
      resultant data graph.                               
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchemaAllowedValue
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$							
		FROM
				ATTRVAL 
        WHERE
				ATTRVAL.ATTR_ID IN ($UNIQUE_IDS$) AND
				ATTRVAL.VALUSAGE is NOT NULL AND
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)
			
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds the description of the allowed values of attribute dictionary 
     attributes (ATTRVALDESC table) to the
      resultant data graph.                               
     ========================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
	base_table=ATTRVALDESC
	sql=
		SELECT 
				ATTRVALDESC.$COLS:ATTRVALDESC$
							
		FROM
				ATTRVALDESC
		WHERE
	        	ATTRVALDESC.ATTRVAL_ID IN ($UNIQUE_IDS$) AND
			    ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
				ATTRVALDESC.SEQUENCE				
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds classic attribute values (ATTRVALUE table) of catalog entries     -->
<!-- to the resultant data graph.                                           -->
<!-- ====================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeValue
	base_table=ATTRVALUE
	sql=
		SELECT 
				ATTRVALUE.$COLS:ATTRVALUE$
		FROM
				ATTRVALUE 
        WHERE
                ATTRVALUE.CATENTRY_ID IN ($UNIQUE_IDS$) AND
                ATTRVALUE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
                
END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the schemas of classic attributes to the resultant data graph.    -->
<!-- ====================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeSchema
	base_table=ATTRIBUTE
	sql=
		SELECT 
			ATTRIBUTE.$COLS:ATTRIBUTE$ 
		FROM 
			ATTRIBUTE  
		WHERE
			ATTRIBUTE.ATTRIBUTE_ID IN ($UNIQUE_IDS$) AND
			ATTRIBUTE.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
		ORDER BY
			ATTRIBUTE.SEQUENCE

END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the values of attribute dictionary attributes 					-->
<!-- (ATTRVAL table) to the resultant data graph.             				-->                  
<!-- ====================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeValue
	base_table=ATTRVAL
	param=versionable
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$
		FROM
				ATTRVAL
        WHERE
		        ATTRVAL.ATTRVAL_ID IN ($UNIQUE_IDS$) AND 
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$)

END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the description for the values of attribute dictionary attributes -->
<!-- (ATTRVALDESC table) to the resultant data graph.                       -->       
<!-- ====================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeValueDescription
	base_table=ATTRVALDESC
	param=versionable
	sql=
		SELECT 
				ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				ATTRVALDESC
		WHERE
				ATTRVALDESC.ATTRVAL_ID IN ($UNIQUE_IDS$) AND
				ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)

END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the values of attribute dictionary attributes 					-->
<!-- (ATTRVAL table) to the resultant data graph.             				-->                  
<!-- ====================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeAllowedValue
	base_table=ATTRVAL
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$
		FROM
				ATTRVAL
    WHERE
		    ATTRVAL.ATTRVAL_ID IN ($UNIQUE_IDS$) AND 
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$) AND
				ATTRVAL.VALUSAGE IS NOT NULL

END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the values of attribute dictionary attributes 					-->
<!-- (ATTRVAL table) to the resultant data graph.             				-->                  
<!-- ====================================================================== -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeAssignedValue
	base_table=ATTRVAL
	param=versionable
	sql=
		SELECT 
				ATTRVAL.$COLS:ATTRVAL$
		FROM
				ATTRVAL
    WHERE
		    ATTRVAL.ATTRVAL_ID IN ($UNIQUE_IDS$) AND 
				ATTRVAL.STOREENT_ID IN ($STOREPATH:catalog$) AND
				ATTRVAL.VALUSAGE IS NULL
				
END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the description for the values of attribute dictionary attributes -->
<!-- (ATTRVALDESC table) to the resultant data graph.                       -->       
<!-- ====================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeAllowedValueDescription
	base_table=ATTRVALDESC
	sql=
		SELECT 
				ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				ATTRVALDESC
		WHERE
				ATTRVALDESC.ATTRVAL_ID IN ($UNIQUE_IDS$) AND
				ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) AND
				ATTRVALDESC.VALUSAGE IS NOT NULL

END_ASSOCIATION_SQL_STATEMENT

<!-- ====================================================================== -->
<!-- Adds the description for the values of attribute dictionary attributes -->
<!-- (ATTRVALDESC table) to the resultant data graph.                       -->       
<!-- ====================================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_AttributeDictionaryAttributeAssignedValueDescription
	base_table=ATTRVALDESC
	param=versionable
	sql=
		SELECT 
				ATTRVALDESC.$COLS:ATTRVALDESC$
		FROM
				ATTRVALDESC
		WHERE
				ATTRVALDESC.ATTRVAL_ID IN ($UNIQUE_IDS$) AND
				ATTRVALDESC.LANGUAGE_ID IN ($CONTROL:LANGUAGES$) AND
				ATTRVALDESC.VALUSAGE IS NULL 

END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the catalog entry and of attribute dictionary attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeDictionaryAttribute_Paging
	base_table=CATENTRYATTR
	param=versionable
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$
		FROM
				CATENTRYATTR
		WHERE
				CATENTRYATTR.CATENTRY_ID IN ($UNIQUE_IDS$) AND
		        CATENTRYATTR.ATTR_ID IN ($SUBENTITY_PKS$)
        ORDER BY
        		CATENTRYATTR.SEQUENCE, CATENTRYATTR.ATTR_ID
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL: -->
<!-- Adds list price for a given currency -->
<!-- to the resultant data graph. -->
<!-- #### Asociated SQL to DataExtract the listprice #### -->
<!-- ========================================================= -->    
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryListPriceForCurrency
	base_table=LISTPRICE
	param=versionable
	sql=

		SELECT 
			LISTPRICE.$COLS:LISTPRICE$
		FROM 
			LISTPRICE 
		WHERE 
			LISTPRICE.CATENTRY_ID IN ($UNIQUE_IDS$) AND LISTPRICE.CURRENCY IN ($CTX:CURRENCY$)
			
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL: -->
<!-- Adds offer price for a given currency -->
<!-- to the resultant data graph. -->
<!-- #### Asociated SQL to DataExtract the offerprice #### -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryOfferPriceForCurrency
	base_table=OFFER
	param=versionable
	sql=
		SELECT 
				OFFER.$COLS:OFFER$,OFFERPRICE.$COLS:OFFERPRICE$
		FROM
				OFFER,OFFERPRICE
		WHERE
        		OFFER.CATENTRY_ID IN ($UNIQUE_IDS$) AND OFFER.OFFER_ID = OFFERPRICE.OFFER_ID AND OFFERPRICE.CURRENCY IN ($CTX:CURRENCY$) AND 
			OFFER.TRADEPOSCN_ID IN (
				SELECT CATGRPTPC.TRADEPOSCN_ID 
				FROM CATGRPTPC 
				WHERE CATGRPTPC.CATALOG_ID = $CTX:CATALOG_ID$ AND CATGRPTPC.CATGROUP_ID = 0 AND 
				( CATGRPTPC.STORE_ID IN ($STOREPATH:catalog$) OR CATGRPTPC.STORE_ID = 0 ))

END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================== 
     Adds the catalog entry of attribute dictionary defining attribute 
     relationship (CATENTRYATTR table) to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryAttributeDictionaryAttribute_Defining
	base_table=CATENTRYATTR
	param=versionable
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$
		FROM
				CATENTRYATTR
		WHERE
		          	CATENTRYATTR.CATENTRY_ID IN ($UNIQUE_IDS$) AND
		          	CATENTRYATTR.USAGE = '1'
        	ORDER BY
        			CATENTRYATTR.SEQUENCE
END_ASSOCIATION_SQL_STATEMENT

<!-- ==========================================================
     Adds calculation codes (CATENCALCD) of catalog entries
     to the resultant data graph.
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryCalculationCode
	base_table=CATENCALCD
	sql=
		SELECT
			CATENCALCD.$COLS:CATENCALCD$, CALCODE.$COLS:CALCODE$
		FROM
			CATENCALCD, CALCODE
		WHERE
			CALCODE.CALCODE_ID = CATENCALCD.CALCODE_ID AND
			CATENCALCD.STORE_ID = $CTX:STORE_ID$ AND
			CATENCALCD.CATENTRY_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- This associated SQL:                                      -->
<!-- Adds Catentry descrition Override Info 				               -->
<!-- to the resultant data graph.                              -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryDescriptionOverride
	base_table=CATENTDESCOVR
	additional_entity_objects=true
	param=versionable
	sql=
		SELECT 
				CATENTDESCOVR.$COLS:CATENTDESCOVR$
		FROM
				CATENTDESCOVR
				JOIN CATOVRGRP ON CATENTDESCOVR.CATOVRGRP_ID=CATOVRGRP.CATOVRGRP_ID 
							AND CATOVRGRP.STOREENT_ID=$CTX:STORE_ID$ 		        	
		WHERE
                CATENTDESCOVR.CATENTRY_ID IN ($UNIQUE_IDS$) AND CATENTDESCOVR.LANGUAGE_ID IN ($CONTROL:LANGUAGES$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================== 
     Adds the attribute dictionary attribute relationship (CATENTRYATTR table)
     for a specific attribute to the resultant data graph.                               
     ========================================================== -->

BEGIN_ASSOCIATION_SQL_STATEMENT
    className=com.ibm.commerce.catalog.facade.server.services.dataaccess.db.jdbc.CatalogEntryAttributeReferenceSQLComposer
	name=IBM_CatalogEntryAttributeReferences
	base_table=CATENTRYATTR
	sql=
		SELECT 
				CATENTRYATTR.$COLS:CATENTRYATTR$
		FROM
				CATENTRYATTR
		WHERE
		        CATENTRYATTR.ATTR_ID=AttributeId AND
		        CATENTRYATTR.CATENTRY_ID IN ($UNIQUE_IDS$)
       	ORDER BY
        		CATENTRYATTR.SEQUENCE
END_ASSOCIATION_SQL_STATEMENT



<!-- ========================================================= -->
<!-- This associated SQL: -->
<!-- Adds offer prices
<!-- to the resultant data graph. -->
<!-- This is used by the REST service. -->
<!-- 
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
	name=IBM_CatalogEntryStandardOfferPrice
	base_table=OFFER
	param=versionable
	sql=
		SELECT 
				OFFER.$COLS:OFFER$,OFFERPRICE.$COLS:OFFERPRICE$
		FROM
				OFFER,OFFERPRICE
		WHERE
 			OFFER.CATENTRY_ID IN ($UNIQUE_IDS$) AND OFFER.OFFER_ID = OFFERPRICE.OFFER_ID AND
			OFFER.TRADEPOSCN_ID IN (
				SELECT CATGRPTPC.TRADEPOSCN_ID 
				FROM CATGRPTPC 
				WHERE CATGRPTPC.CATALOG_ID IN (SELECT CATALOG_ID FROM STORECAT WHERE STOREENT_ID IN ($STOREPATH:catalog$) AND MASTERCATALOG='1' ) 
					AND CATGRPTPC.CATGROUP_ID = 0 AND 
					( CATGRPTPC.STORE_ID IN ($STOREPATH:catalog$) OR CATGRPTPC.STORE_ID = 0 ))

END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Fetches external-content relationship for given catentry  -->
<!--   within current store into resultant graph               -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
  name=IBM_CatalogEntryExternalContentRel
  base_table=CATENTRY_EXTERNAL_CONTENT_REL
  additional_entity_objects=true
  param=versionable
  sql=SELECT CATENTRY_EXTERNAL_CONTENT_REL.$COLS:CATENTRY_EXTERNAL_CONTENT_REL:CE_EXTERNAL_CONTENT_REL_ID$,
 				CATENTRY_EXTERNAL_CONTENT_REL.$COLS:CATENTRY_EXTERNAL_CONTENT_REL:CATENTRY_ID$,
 				CATENTRY_EXTERNAL_CONTENT_REL.$COLS:CATENTRY_EXTERNAL_CONTENT_REL:CATOVRGRP_ID$,
				CATENTRY_EXTERNAL_CONTENT_REL.$COLS:CATENTRY_EXTERNAL_CONTENT_REL:LANGUAGE_ID$,
				CATENTRY_EXTERNAL_CONTENT_REL.$COLS:CATENTRY_EXTERNAL_CONTENT_REL:CONTENT_ID$,
				CATENTRY_EXTERNAL_CONTENT_REL.$COLS:CATENTRY_EXTERNAL_CONTENT_REL:TYPE$,
				CATENTRY_EXTERNAL_CONTENT_REL.$COLS:CATENTRY_EXTERNAL_CONTENT_REL:FIELD1$,
				CATENTRY_EXTERNAL_CONTENT_REL.$COLS:CATENTRY_EXTERNAL_CONTENT_REL:FIELD2$,
				CATENTRY_EXTERNAL_CONTENT_REL.$COLS:CATENTRY_EXTERNAL_CONTENT_REL:FIELD3$,
				CATENTRY_EXTERNAL_CONTENT_REL.$COLS:CATENTRY_EXTERNAL_CONTENT_REL:OPTCOUNTER$
      FROM   CATENTRY_EXTERNAL_CONTENT_REL
				JOIN STORECATOVRGRP ON CATENTRY_EXTERNAL_CONTENT_REL.CATOVRGRP_ID=STORECATOVRGRP.CATOVRGRP_ID 
							AND STORECATOVRGRP.STOREENT_ID IN ($STOREPATH:catalog$)
				JOIN STORELANG ON CATENTRY_EXTERNAL_CONTENT_REL.LANGUAGE_ID=STORELANG.LANGUAGE_ID AND STORELANG.STOREENT_ID=$CTX:STORE_ID$
     WHERE  CATENTRY_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Fetches external-content into resultant graph             -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
  name=IBM_ExternalContent
  base_table=EXTERNAL_CONTENT
  additional_entity_objects=true
  param=versionable
  sql=SELECT $COLS:EXTERNAL_CONTENT$
      FROM   EXTERNAL_CONTENT
      WHERE  CONTENT_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT

<!-- ========================================================= -->
<!-- Fetches external-content assets into resultant graph      -->
<!-- ========================================================= -->
BEGIN_ASSOCIATION_SQL_STATEMENT
  name=IBM_ExternalContentAssets
  base_table=EXTERNAL_CONTENT_ASSET
  additional_entity_objects=true
  param=versionable
  sql=SELECT $COLS:EXTERNAL_CONTENT_ASSET$
      FROM   EXTERNAL_CONTENT_ASSET
      WHERE  CONTENT_ID IN ($UNIQUE_IDS$)
END_ASSOCIATION_SQL_STATEMENT


<!-- ========================================================================= -->
<!-- =============================PROFILE DEFINITIONS========================= -->
<!-- ========================================================================= -->

<!-- ========================================================= -->
<!-- Catalog Entry Price Access Profile.                       -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry price.                                -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryPrice
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer	  
      associated_sql_statement=IBM_CatalogEntryPriceAssocSQL
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier      
    END_ENTITY
END_PROFILE

BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryFulfillmentProperties
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryDescription	  
            
      associated_sql_statement=IBM_RootCatalogEntryWithBaseItem
      associated_sql_statement=IBM_RootCatalogEntryWithItemSpc
    END_ENTITY
END_PROFILE






<!-- ========================================================= -->
<!-- Catalog Entry All Details Access Profile.                 -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry price.                                -->
<!-- 	3) Catalog Entry shipment.                             -->
<!-- 	4) Catalog Entry children.                             -->
<!-- 	5) Catalog Entry parent catalog group.                 -->
<!-- 	6) Catalog Entry merchandising associations.           -->
<!-- 	7) Catalog Entry attributes.                           -->
<!-- 	8) Catalog Entry parent catalog entry.                 -->
<!-- 	9) Catalog Entry base item.                            -->
<!-- 	10) Catalog Entry item spc.                            -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_All
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryDescription	  

      associated_sql_statement=IBM_CatalogEntryListPrice 
      associated_sql_statement=IBM_CatalogEntryShipment
      associated_sql_statement=IBM_CatalogEntryChildrenRelationships
      associated_sql_statement=IBM_CatalogEntryIdentifier
      associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogEntryMerchandisingAssociations
      associated_sql_statement=IBM_AssociatedCatalogEntrySummary

<!-- === Following SQL statements retrieves classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictonary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema
      associated_sql_statement=IBM_AttributeAllowedValue
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema
            
<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription

      associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
      associated_sql_statement=IBM_CatalogEntryIdentifier
      associated_sql_statement=IBM_RootCatalogEntryWithBaseItem
      associated_sql_statement=IBM_RootCatalogEntryWithItemSpc
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Entry Merchandising Associations Access Profile.  -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry merchandising associations.           -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryMerchandisingAssociations
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer	  
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  	associated_sql_statement=IBM_CatalogEntryDescription
			associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship      	  	  
      associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
      associated_sql_statement=IBM_CatalogEntryMerchandisingAssociations
      associated_sql_statement=IBM_AssociatedCatalogEntrySummary      
    END_ENTITY
END_PROFILE

<!-- ================================================================================================ -->
<!-- Catalog Entry Merchandising Associations Access Profile with merchandising association paging.  -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry merchandising associations.           -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryMerchandisingAssociations_Paging
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer	  
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryDescription	  
      associated_sql_statement=IBM_CatalogEntryMerchandisingAssociations_Paging
      associated_sql_statement=IBM_AssociatedCatalogEntrySummary      
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Entry Components Access Profile.                  -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry children.                             -->
<!-- 	3) Catalog Entry parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryComponents
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryDescription	  
      
      associated_sql_statement=IBM_CatalogEntryChildrenRelationships
      associated_sql_statement=IBM_CatalogEntryIdentifier
      associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
      associated_sql_statement=IBM_CatalogGroupIdentifier      
    END_ENTITY
END_PROFILE

<!-- ================================================================================================================ -->
<!-- ==== Catalog Entry Attributes Access Profile                                                                     -->
<!-- This profile consists of the following assoicated SQLs:                                                          -->
<!-- 	1) IBM_RootCatalogEntryWithDescription - returns catalog entry description                                    -->
<!-- 	2) IBM_CatalogEntryAttributeSchema - returns classic attribute schemas (definitions)                          -->
<!-- 	3) IBM_CatalogEntryAttributeValue - returns classic attribute values                                          -->
<!-- 	4) IBM_CatalogEntryAttributeDictionaryAttributeSchema - returns attribute dictionary attribute schemas.       -->
<!-- 	5) IBM_CatalogEntryAttributeDictionaryAttributeValue - returns new attribute dictionary attribute values.     -->
<!-- ================================================================================================================ -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryAttributes
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
      
<!-- === Following SQL statements retrieves classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictonary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema
      associated_sql_statement=IBM_AttributeAllowedValue
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema
            
<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
	  associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      
	  

    END_ENTITY
END_PROFILE

<!-- === Following access profile returns the current page classic descriptive attributes and values of a product or SKU  -->

BEGIN_PROFILE
	name=IBM_Admin_CatalogEntryDescriptiveAttributes_Paging
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
      associated_sql_statement=IBM_CatalogEntryAttributeSchema_Paging
      associated_sql_statement=IBM_CatalogEntryAttributeAttributeValue_Paging
    END_ENTITY
END_PROFILE

<!-- === Following access profile returns the classic defining attributes, allowed values and values of a product or SKU  -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryDefiningAttributes
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
      associated_sql_statement=IBM_CatalogEntryAttributeSchema_Defining
      associated_sql_statement=IBM_AttributeAllowedValue
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema_Defining
    END_ENTITY
END_PROFILE

<!-- === Following access profile returns the attribute dictionary descriptive attributes and values of a product or SKU  -->
BEGIN_PROFILE
	name=IBM_Admin_CatalogEntryAttrDictDescriptiveAttributes_Paging
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute_Paging
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
	  associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      
    END_ENTITY
END_PROFILE

<!-- === Following access profile returns the attribute dictionary defining attributes, allowed values and values of a product or SKU  -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryAttrDictDefiningAttributes
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute_Defining
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
	  associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      
    END_ENTITY
END_PROFILE

<!-- === Following access profile returns the classic and attribute dictionary defining attributes, allowed values and values of a product or SKU  -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryAllDefiningAttributes
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
      <!-- Get Classic Defining Attributes --> 
      associated_sql_statement=IBM_CatalogEntryAttributeSchema_Defining
      associated_sql_statement=IBM_AttributeAllowedValue
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema_Defining
	  <!-- Get Attribute Dictionary Defining Attributes -->
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute_Defining
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
	  associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      

    END_ENTITY
END_PROFILE






<!-- ========================================================= -->
<!-- Catalog Entry Sales Catalog References Access Profile.    -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description summary.             -->
<!-- 	2) Catalog Entry sales catalog references.             -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntrySalesCatalogReference
	BEGIN_ENTITY 
	  base_table=CATENTRY
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer	  
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntrySummary      
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Entry Descriptions Access Profile.                -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with all descriptions.                -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryAllDescriptions
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer	  
      associated_sql_statement=IBM_CatalogEntryWithAllDescriptions
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier      
    END_ENTITY
END_PROFILE




<!-- ========================================================= -->
<!-- Catalog Entry Attachment References Access Profile.       -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with attachment reference.              -->
<!-- 	2) Catalog Entry with attachment reference description.  -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryAttachmentReference
	BEGIN_ENTITY 
	  base_table=CATENTRY
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry      
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
  
      associated_sql_statement=IBM_CatalogEntryAttachmentReferenceDescription
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Entry Summary Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description summary.             -->
<!-- 	2) Catalog Entry price.                                -->
<!-- 	3) Catalog Entry parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE
  name=IBM_Admin_Summary
  BEGIN_ENTITY
    base_table=CATENTRY
    className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
    associated_sql_statement=IBM_RootCatalogEntry
    associated_sql_statement=IBM_CatalogEntryStoreIdentifier
    associated_sql_statement=IBM_CatalogEntryDescription
    associated_sql_statement=IBM_CatalogEntryListPrice
    associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
    associated_sql_statement=IBM_CatalogGroupIdentifier
    associated_sql_statement=IBM_CatalogEntrySubscription
    associated_sql_statement=IBM_CatalogEntryCalculationCode
    associated_sql_statement=IBM_CatalogEntryDescriptionOverride
    associated_sql_statement=IBM_CatalogEntryExternalContentRel
    associated_sql_statement=IBM_ExternalContent
    associated_sql_statement=IBM_ExternalContentAssets
  END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Entry Details Access Profile.                     -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry price.                                -->
<!-- 	3) Catalog Entry parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE
  name=IBM_Admin_Details
  BEGIN_ENTITY
    base_table=CATENTRY
    className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
    associated_sql_statement=IBM_RootCatalogEntry
    associated_sql_statement=IBM_CatalogEntryStoreIdentifier
    associated_sql_statement=IBM_CatalogEntryDescription
    associated_sql_statement=IBM_CatalogEntryListPrice
    associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
    associated_sql_statement=IBM_CatalogGroupIdentifier
    associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
    associated_sql_statement=IBM_CatalogEntryIdentifier
    associated_sql_statement=IBM_CatalogEntrySubscription
    associated_sql_statement=IBM_CatalogEntryCalculationCode
    associated_sql_statement=IBM_CatalogEntryDescriptionOverride
    associated_sql_statement=IBM_CatalogEntryExternalContentRel
    associated_sql_statement=IBM_ExternalContent
    associated_sql_statement=IBM_ExternalContentAssets
  END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- ==== Catalog Entry SKUs Access Profile      			   ===== -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                    	 -->
<!-- 	2) Catalog Entry price.                              		 -->
<!-- 	3) Catalog Entry Attribute Values.                       -->
<!-- 	4) Catalog Entry Attributes.                             -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntrySKUs
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryDescription	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier      
      associated_sql_statement=IBM_CatalogEntryListPrice 
      associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
      associated_sql_statement=IBM_CatalogEntryIdentifier
      associated_sql_statement=IBM_CatalogEntrySubscription
      associated_sql_statement=IBM_CatalogEntryCalculationCode
<!-- === Following SQL statements retrieves classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictonary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema
      associated_sql_statement=IBM_AttributeAllowedValue
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema
<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR/ATTRVAL tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription

    END_ENTITY
END_PROFILE

<!-- ====================================================================================================================================================== 
  Catalog Entry Attributes Access Profile for promotion validation (returns the attribute names of product, its parent and children.)
  This profile consists of the following associated SQLs:                       
  1) IBM_CatalogEntryBaseAttributes - returns root catalog entry with catalog entry id and base attributes
  2) IBM_ExistingCatalogEntryParentBaseAttributes - returns parent catalog entry of the root catalog entry and base attributes.
  3) IBM_ExistingCatalogEntryChildBaseAttributes - returns children catalog entries of the root catalog entry and base attributes.
  4) IBM_CatalogEntryAttributeSchema - returns classic attribute schemas (definitions) of the catalog entry.         
  5) IBM_CatalogEntryAttributeDictionaryAttribute - returns relationship between catalog entry and attribute dictionary attribute. 
  6) IBM_AttributeDictionaryAttributeSchema - returns schema of attribute dictionary attribute.                                  
  7) IBM_AttributeDictionaryAttributeSchemaDescription  - returns description of attribute dictionary attribute.
  8) IBM_CatalogEntryAttributeValue - returns the values of the classic attribute of a catalog entry.
  9) IBM_AttributeSchema = returns the attribute dictionary attribute schema (definition) of the catalong entry.
 10) IBM_AttributeDictionaryAttributeValue - returns the attribute dictionary attribute values of a catalog entry.
 11) IBM_AttributeDictionaryAttributeValueDescription - returns the attribute dictionary attribute value description of a catalog entry.
============================================================================================================================================================ -->

BEGIN_PROFILE 
       name=IBM_Admin_CatalogEntryAttributeNameValues
       BEGIN_ENTITY 
       base_table=CATENTRY 
			className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
					associated_sql_statement=IBM_CatalogEntryBaseAttributes
					associated_sql_statement=IBM_ExistingCatalogEntryParentBaseAttributes
					associated_sql_statement=IBM_ExistingCatalogEntryChildBaseAttributes       
					associated_sql_statement=IBM_CatalogEntryAttributeSchema                    		 
					associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
					associated_sql_statement=IBM_AttributeDictionaryAttributeSchema          
					associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription               
					associated_sql_statement=IBM_CatalogEntryAttributeValue
					associated_sql_statement=IBM_AttributeSchema
					associated_sql_statement=IBM_AttributeDictionaryAttributeValue
					associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription		 
	   END_ENTITY
END_PROFILE

<!-- === Following access profile returns the attribute dictionary descriptive attributes of a catalog entry. Allowed values are not returned-->
BEGIN_PROFILE
	name=IBM_Admin_CatalogEntryAttrDictDescriptiveAttributesWithoutAllowedValue_Paging
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute_Paging
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
	  associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      
    END_ENTITY
END_PROFILE

BEGIN_PROFILE
	name=IBM_Admin_CatalogEntryAttrDictDescriptiveAttributesWithoutAllowedValue_Paging_Version
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryVersionGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute_Paging
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeAssignedValue
	  associated_sql_statement=IBM_AttributeDictionaryAttributeAllowedValueDescription      
	  associated_sql_statement=IBM_AttributeDictionaryAttributeAssignedValueDescription      
    END_ENTITY
END_PROFILE

<!-- === The IBM_Admin_Minimal returns the basic CatalogEntry information (Id, partnumber, owner) -->
BEGIN_PROFILE 
	name=IBM_Admin_Minimal
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	        
	  associated_sql_statement=IBM_CatalogEntryStoreIdentifier	        
	  associated_sql_statement=IBM_CatalogEntrySubscription
    END_ENTITY
END_PROFILE


<!-- === The IBM_Admin_SEO returns the basic CatalogEntry information (Id, partnumber, owner) PLUS SEO information -->
BEGIN_PROFILE 
	name=IBM_Admin_SEO
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	        
	  associated_sql_statement=IBM_CatalogEntryStoreIdentifier	
        associated_sql_statement=IBM_CatalogEntryDescription           
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Entry Data Extract Access Profile.                -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry parent catalog group.                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_DataExtract
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier    
      associated_sql_statement=IBM_CatalogEntryDescription      
      associated_sql_statement=IBM_CatalogEntryListPriceForCurrency
      associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription
      associated_sql_statement=IBM_CatalogEntryOfferPriceForCurrency
    END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Entry Data Extract Access Profile with price rule.-->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry parent catalog group.                 -->
<!-- 	3) Catalog Entry with offer price from price rules.    -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_DataExtract_with_PriceRule
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier    
      associated_sql_statement=IBM_CatalogEntryDescription      
      associated_sql_statement=IBM_CatalogEntryListPriceForCurrency
      associated_sql_statement=IBM_CatalogEntryToCatalogGroupRelationship
      associated_sql_statement=IBM_CatalogGroupIdentifier
      associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaAllowedValueDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription
    END_ENTITY
END_PROFILE

<!-- === Following access profile returns the attribute dictionary defining attributes, without allowed values for a product or SKU  -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryAttrDictDefiningAttributesWithoutAllowedValues
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute_Defining
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
	  associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription      
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!--      Catalog Entry SKUs Access Profile                    -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry price.                                -->
<!-- 	3) Catalog Entry Classic Attribute Values.             -->
<!-- 	4) Catalog Entry Attributes.                           -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntrySKUsWithoutADAllowedValues
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
      associated_sql_statement=IBM_CatalogEntryDescription	  
      associated_sql_statement=IBM_CatalogEntryListPrice 
      associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
      associated_sql_statement=IBM_CatalogEntryIdentifier
      associated_sql_statement=IBM_CatalogEntrySubscription
      associated_sql_statement=IBM_CatalogEntryExternalContentRel
      associated_sql_statement=IBM_ExternalContent
      associated_sql_statement=IBM_ExternalContentAssets      
      
<!-- === Following SQL statements retrieves classic attributes (ATTRIBUTE/ATTRVALUE tables) for catalog entry -->
<!-- === They can be commented out to improve performance if you only use attribute dictonary attributes (ATTR/ATTRVAL tables) and do not use the classic attributes -->
      associated_sql_statement=IBM_CatalogEntryAttributeSchema
      associated_sql_statement=IBM_AttributeAllowedValue
      associated_sql_statement=IBM_CatalogEntryAttributeValue
      associated_sql_statement=IBM_AttributeSchema
            
<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
      associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription


    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Entry Descriptions Access Profile.                -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with descriptions for languages.      -->
<!-- 	   passes in the control parameter 'LANGUAGES'.        -->
<!-- ========================================================= -->
BEGIN_PROFILE
  name=IBM_Admin_CatalogEntryDescription
  BEGIN_ENTITY
    base_table=CATENTRY
    className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
    associated_sql_statement=IBM_RootCatalogEntry
    associated_sql_statement=IBM_CatalogEntryStoreIdentifier
    associated_sql_statement=IBM_CatalogEntryDescription
    associated_sql_statement=IBM_CatalogEntryListPrice
    associated_sql_statement=IBM_CatalogEntryDescriptionOverride
    associated_sql_statement=IBM_CatalogEntryExternalContentRel
    associated_sql_statement=IBM_ExternalContent
    associated_sql_statement=IBM_ExternalContentAssets
  END_ENTITY
END_PROFILE

<!-- ========================================================= -->
<!-- Catalog Entry Attribute Reference Access Profile.         -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry parent product relationship.          -->
<!-- 	3) Catalog Entry with attribute information for the    -->
<!--	specific attribute(s).								   -->
-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryAttributeReference
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	  associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
	  associated_sql_statement=IBM_CatalogEntryDescription	  
      associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
      associated_sql_statement=IBM_CatalogEntryAttributeReferences
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription
    END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!--      Catalog Entry PDKs Access Profile                    -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry with description.                     -->
<!-- 	2) Catalog Entry price.                                -->
<!-- 	3) Catalog Entry Classic Attribute Values.             -->
<!-- 	4) Catalog Entry Attributes.                           -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryPDKsWithoutADAllowedValues
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
      associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier
      associated_sql_statement=IBM_CatalogEntryDescription	  
      associated_sql_statement=IBM_CatalogEntryListPrice 
      associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
      associated_sql_statement=IBM_CatalogEntryIdentifier
      associated_sql_statement=IBM_CatalogEntrySubscription

<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR tables) for catalog entry  -->
<!-- === They can be commented out to improve performance if you only use classic attributes (ATTRIBUTE/ATTRVALUE tables) -->
      associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription

    END_ENTITY
END_PROFILE

<!-- ====================================================================== 
	Get dynamic kit or Predefined Kit configuration base information based on catentry id.
	@param UniqueId The catentry id of the dynamic kit or PreDefined Kit
=========================================================================== -->
BEGIN_XPATH_TO_SQL_STATEMENT
	name=/CatalogEntry[CatalogEntryConfigInfo[(UniqueID=)]]+IBM_Admin_DynamicKitOrPDKConfigInfo_Get
	base_table=CATENTRY
	param=versionable
	sql=
		SELECT 
							CATENTRY.$COLS:CATENTRY$,		
	     				CATCONFINF.$COLS:CATCONFINF$
	     	FROM
	     	
					CATENTRY
		      	LEFT OUTER JOIN CATCONFINF ON (CATENTRY.CATENTRY_ID = CATCONFINF.CATENTRY_ID) 			     		 						  
	     	WHERE
						CATENTRY.CATENTRY_ID in (?UniqueID?)
						
    
END_XPATH_TO_SQL_STATEMENT


<!-- ========================================================= -->
<!-- Catalog Entry Access Profile used by Rest service.                -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry base information with description                    -->
<!-   2) Catalog entry with standard offer price                 -->
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_StandardOfferPrice
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
		associated_sql_statement=IBM_RootCatalogEntry	  
		associated_sql_statement=IBM_CatalogEntryStoreIdentifier    
		associated_sql_statement=IBM_CatalogEntryDescription            
		associated_sql_statement=IBM_CatalogEntryStandardOfferPrice
     
            
     END_ENTITY
END_PROFILE


<!-- ========================================================= -->
<!-- Catalog Entry Access Profile used by Rest service.                -->
<!-- This profile returns the following info:                  -->
<!-- 	1) Catalog Entry base information with description                  -->
<!-- 	2) parent Catalog Entry information                   -->
<!-- 	3) Catalog Entry defining attributes
<!-- ========================================================= -->
BEGIN_PROFILE 
	name=IBM_Admin_CatalogEntryDefiningAttributeDictionaryAttribute
	BEGIN_ENTITY 
	  base_table=CATENTRY 
	  className=com.ibm.commerce.catalog.facade.server.services.dataaccess.graphbuilderservice.CatalogEntryGraphComposer
	    associated_sql_statement=IBM_RootCatalogEntry	  
      associated_sql_statement=IBM_CatalogEntryStoreIdentifier    
      associated_sql_statement=IBM_CatalogEntryDescription            
      associated_sql_statement=IBM_ParentCatalogEntryForRootRelationships
      associated_sql_statement=IBM_CatalogEntryIdentifier
      
                 
<!-- === Following SQL statements are used to retrieve attribute dictionary attributes (ATTR tables) for catalog entry  -->
      associated_sql_statement=IBM_CatalogEntryAttributeDictionaryAttribute_Defining
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchema
      associated_sql_statement=IBM_AttributeDictionaryAttributeSchemaDescription
      associated_sql_statement=IBM_AttributeDictionaryAttributeValue
      associated_sql_statement=IBM_AttributeDictionaryAttributeValueDescription            
      
     END_ENTITY
END_PROFILE




<!-- ========================================================= -->
<!-- Catalog Entry Access Profile Alias definition             -->
<!--                                                            -->
<!-- ========================================================= -->

BEGIN_PROFILE_ALIASES
  base_table=CATENTRY
  IBM_CatalogEntryPrice=IBM_Admin_CatalogEntryPrice  
  IBM_Summary=IBM_Admin_Summary
  IBM_Details=IBM_Admin_Details
  IBM_CatalogEntryMerchandisingAssociations=IBM_Admin_CatalogEntryMerchandisingAssociations
  IBM_CatalogEntryComponents=IBM_Admin_CatalogEntryComponents
  IBM_All=IBM_Admin_All
  IBM_CatalogEntryAttributes=IBM_Admin_CatalogEntryAttributes
  IBM_CatalogEntrySKUs=IBM_Admin_CatalogEntrySKUs
  IBM_CatalogEntrySalesCatalogReference=IBM_Admin_CatalogEntrySalesCatalogReference
  IBM_CatalogEntryAllDescriptions=IBM_Admin_CatalogEntryAllDescriptions
  IBM_CatalogEntryDescription=IBM_Admin_CatalogEntryDescription
  IBM_CatalogEntryFulfillmentProperties=IBM_Admin_CatalogEntryFulfillmentProperties
END_PROFILE_ALIASES

BEGIN_PROFILE_ALIASES
  base_table=DISPENTREL
  IBM_CatalogEntryDisplayPage_Get=IBM_Admin_CatalogEntryDisplayPage_Get
END_PROFILE_ALIASES

<!-- ===================================================================================== -->
<!-- ================================ GET CATENTRY ENDS ================================== -->
<!-- ===================================================================================== -->
