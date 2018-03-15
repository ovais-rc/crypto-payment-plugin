====================================
Query ACP policy
====================================

insert into acrescgry (ACRESCGRY_ID,RESCLASSNAME) values
((select counter from keys where tablename='acrescgry'),'com.royalcyber.dataFeed.commands.DataFeedCmd');

insert into acresact (ACRESCGRY_ID, ACACTION_ID) values ((select counter from keys where tablename='acrescgry'),(select ACACTION_ID from acaction where action='Execute'));

insert into acresgpres (ACRESGRP_ID, ACRESCGRY_ID)  values ((select ACRESGRP_ID from acresgrp where MEMBER_ID in
(select orgentity_id from orgentity where orgentityname='Root Organization') and GRPNAME='AllSiteUserCmdResourceGroup'),
(select counter from keys where tablename='acrescgry'));

UPDATE KEYS SET COUNTER = COUNTER+1 WHERE TABLENAME = 'acrescgry';




====================================
Query for XDATAFEEDLOG.. 
====================================


CREATE TABLE XDATAFEEDLOG (
    "PROCESSCOUNTER" INTEGER , 
    "STATUS" VARCHAR(3000)  , 
    "ERRORMSG" VARCHAR(3000) , 
    "LASTUPDATED" TIMESTAMP , 
    "OPTCOUNTER" SMALLINT )
	

====================================
Query for XDATAFEED.. 
====================================

	CREATE TABLE XDATAFEED (
    "PROCESSFLAG" VARCHAR(3000) NOT NULL , 
    "LASTPROCESSCOUNTER" INTEGER , 
    "LASTUPDATED" TIMESTAMP , 
    "OPTCOUNTER" SMALLINT , 
    "STOREENT_ID" BIGINT , 
    "MSG" LONG VARCHAR )   
   IN "USERSPACE1" ;
	
====================================
Queries for CSV Columns.. 
====================================



insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Local Directory', 'DataFeedEnabled','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Local Directory'),10501,'FeatureEnabled','false'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';


insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'FTP Location', 'DataFeedEnabled','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='FTP Location'),10501,'FeatureEnabled','false'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';



insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Unique ID', 'DataFeedEnabledM','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Unique ID'),10501,'FeatureEnabled','true'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';


insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Name', 'DataFeedEnabledM','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Name'),10501,'FeatureEnabled','true'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';



insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Description', 'DataFeedEnabledM','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Description'),10501,'FeatureEnabled','true'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';



insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Price', 'DataFeedEnabledM','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Price'),10501,'FeatureEnabled','true'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';


insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Merchant Category', 'DataFeedEnabledM','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Merchant Category'),10501,'FeatureEnabled','true'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';


insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'URL', 'DataFeedEnabledM','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='URL'),10501,'FeatureEnabled','true'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';


insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Image URL', 'DataFeedEnabledM','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Image URL'),10501,'FeatureEnabled','true'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';



insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Manufacturer', 'DataFeedEnabledM','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Manufacturer'),10501,'FeatureEnabled','true'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';


insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Manufacturer Part Number', 'DataFeedEnabledM','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Manufacturer Part Number'),10501,'FeatureEnabled','true'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';



insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Brand', 'DataFeedEnabledM','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Brand'),10501,'FeatureEnabled','true'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';



insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Keywords', 'DataFeedEnabled','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Keywords'),10501,'FeatureEnabled','false'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';


insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Shipping Price', 'DataFeedEnabled','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Shipping Price'),10501,'FeatureEnabled','false'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';



insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Quantity', 'DataFeedEnabled','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Quantity'),10501,'FeatureEnabled','false'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';



insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Weight', 'DataFeedEnabled','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Weight'),10501,'FeatureEnabled','false'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';


insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Condition', 'DataFeedEnabled','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Condition'),10501,'FeatureEnabled','false'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';


insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'UPC', 'DataFeedEnabled','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='UPC'),10501,'FeatureEnabled','false'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';



insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Sale Price', 'DataFeedEnabled','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Sale Price'),10501,'FeatureEnabled','false'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';

insert into EMSPOT(EMSPOT_ID,STOREENT_ID,NAME,DESCRIPTION,USAGETYPE) VALUES((select max(emspot_id)+1 from emspot), 10501, 'Availability', 'DataFeedEnabled','STOREFEATURE');

insert into DMEMSPOTDEF(DMEMSPOTDEF_ID,EMSPOT_ID,STOREENT_ID,CONTENTTYPE,CONTENT) VALUES ((select counter+1 from KEYS where tablename='dmemspotdef'),(select emspot_id from emspot where name='Availability'),10501,'FeatureEnabled','false'); 

UPDATE KEYS SET COUNTER=(SELECT COUNTER+1 FROM KEYS WHERE TABLENAME='dmemspotdef') WHERE TABLENAME = 'dmemspotdef';
