local DR_Convert_items = {
	['marijuana'] = "Drug.Marijuana",
	['lsd'] = "Drug.LSD"
}

addEvent ( "NGJobs->Criminal->DrugFactory->OnPlayerFinishProducingDrugs", true );
addEventHandler ( "NGJobs->Criminal->DrugFactory->OnPlayerFinishProducingDrugs", root, function ( drug, amount )
	
	exports.nglogs:outputActionLog ( source.name.." ("..source.account.name..") has created "..amount.." of "..drug );
	
	local rName = DR_Convert_items[drug:lower()];
	local inven = getElementData ( source, "NGUser:Items" ) or { }
	
	if ( not inven [ rName ] ) then
		inven [ rName ] = 0;
	end
	
	inven [ rName ] = inven[rName ] + amount;
	
	setElementData ( source, "NGUser:Items", inven );
	
end );