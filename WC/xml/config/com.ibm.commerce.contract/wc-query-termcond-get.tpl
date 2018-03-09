
BEGIN_SQL_STATEMENT
      base_table=SRCHTERMASSOC
	name=IBM_LOAD_TCSUBTYPE_HAS_TCLEVELPARTICIPANT
	dbtype=any
	sql=
	     SELECT 
	         TCSUBTYPE_ID 
	         FROM TERMCOND  T1 
	         WHERE T1.TCSUBTYPE_ID IN (
	          'ProductSetTCCustomInclusion', 'ProductSetTCCustomExclusion',  'ProductSetTCInclusion', 'ProductSetTCExclusion',
				    'PriceTCPriceListWithSelectiveAdjustment',  'PriceTCConfigBuildBlock', 'PriceTCPriceListWithOptionalAdjustment',
				    'PriceTCMasterCatalogWithOptionalAdjustment', 'PriceTCMasterCatalogWithFiltering',  'PriceTCCustomPriceList', 'CatalogFilterTC') 
				    AND TRADING_ID= ?TRADING_ID? AND 
				     (termcond_id in 
				          (select termcond_id from participnt where trading_id is null and termcond_id is not null))
	
END_SQL_STATEMENT