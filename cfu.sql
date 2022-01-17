SELECT		
	distinct wo.id "WOID",	
	wo.email__c "Email",	
	--CONVERT_TIMEZONE('UTC', oh.timezone,wo.startdate) "WO Start Date",	
	CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) "SA Sch ST",	
	--sa.schedstarttimelocal__c "SA Sch STL",	
	wo.status "Status",	
	wo.workorder_toplevelterritoryname__c "ST",	
	wo.fulfilled_by_dfos__c "By DFOS",	
	wo.x3pl_provider__c "Provider",	
	sr.resource_provider__c "Usual Van Provider",	
	--sa.toplevelterritoryname__c "FSL Warehouse",	
	--st.name "FSL Zone Name",	
	wt.name "WT Work Type",	
	wo.total_bike_count__c "Bike C" ,	
	wo.total_tread_count__c "Tread",	
	wo.total_bike_plus_count__c "Bike + C",	
	wo.total_tread_plus_count__c "Tread + C",	
	sr.name "Van Name"	
		
FROM		
	sd_salesforce2.workorder wo	
		
RIGHT JOIN		
	sd_salesforce2_fieldservice.serviceappointment sa ON wo.id = sa.parentrecordid	
RIGHT JOIN		
	sd_salesforce2_fieldservice.serviceresource sr ON sa.service_resource_name__c = sr.name	
INNER JOIN		
	sd_salesforce2_fieldservice.serviceterritory st ON sa.serviceterritoryid = st.id	
INNER JOIN		
	sd_salesforce2_fieldservice.worktype wt ON sa.worktypeid = wt.id	
LEFT JOIN		
	sd_salesforce2_fieldservice.workorderlineitem woli ON woli.workorderid = wo.id	
RIGHT JOIN		
	ods_ecomm_daily.postalcode pc ON pc.code = sa.postalcode AND pc.country = sa.countrycode	
INNER JOIN		
	ods_ecomm_daily.warehouse w ON pc.warehouse_id = w.pk	
INNER JOIN		
	sd_salesforce2_fieldservice.operatinghours oh ON st.operatinghoursid = oh.id	
		
WHERE		
	workorder_toplevelterritoryname__c like '%Waukegan%'	
	-- workorder_toplevelterritoryname__c like '% Cranberry%' -- Cranberry	
	-- workorder_toplevelterritoryname__c like '%Hazelwood%' --Hazelwood	
		
	AND	
		CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) >= (timestamp '2021-06-29')
		-- CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) >= (timestamp '2021-01-28') -- Cranberry
		-- CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) >= (timestamp '2021-02-11') --Hazelwood
	AND	
		CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) < (timestamp '2021-06-30')
		-- CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) < (timestamp '2021-01-29') -- Cranberry
		-- CONVERT_TIMEZONE('UTC', oh.timezone,sa.schedstarttime) < (timestamp '2021-02-12') --Hazelwood
