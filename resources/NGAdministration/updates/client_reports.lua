report = { create = {}, staff={check={}} }
report.create.window = guiCreateWindow((sx/2-(rSX*340)/2), (sy/2-(rSY*360)/2), rSX*340, rSY*360, "Report A Bug", false)
report.create.priority = guiCreateComboBox(rSX*129, rSY*30, rSX*162, rSY*81, "Low", false, report.create.window)
report.create.title = guiCreateEdit(rSX*125, rSY*70, rSX*200, rSY*30, "", false, report.create.window)
report.create.desc = guiCreateMemo(rSX*9, rSY*135, rSX*316, rSY*141, "", false, report.create.window)
report.create.submit = guiCreateButton(rSX*204, rSY*280, rSX*121, rSY*33, "Submit", false, report.create.window)
report.create.cancel = guiCreateButton(rSX*73, rSY*280, rSX*121, rSY*33, "Cancel", false, report.create.window)
guiComboBoxAddItem(report.create.priority, "High")
guiComboBoxAddItem(report.create.priority, "Medium")
guiComboBoxAddItem(report.create.priority, "Low")
guiCreateLabel(rSX*16, rSY*30, rSX*115, rSY*18, "Priority:", false, report.create.window)
guiCreateLabel(rSX*14, rSY*76, rSX*115, rSY*18, "Title:", false, report.create.window)
guiCreateLabel(rSX*10, rSY*120, rSY*115, rSY*18, "Description:", false, report.create.window)
guiWindowSetSizable(report.create.window, false)
guiSetVisible ( report.create.window, false )
guiEditSetMaxLength  ( report.create.title, 50 )
guiLabelSetHorizontalAlign(guiCreateLabel(rSX*4, rSY*325, rSX*331, rSY*22, "(Mis-use of this panel will have consequences)", false, report.create.window), "center", false)

function updates_openReportWindow ( )
	if ( not exports.NGLogin:isClientLoggedin ( ) ) then return end
	guiSetVisible ( report.create.window, true )
	showCursor ( true )
	guiSetInputMode ( "no_binds_when_editing" )
	addEventHandler ( "onClientGUIClick", report.create.submit, updates_report_event_onClientGUIClick )
	addEventHandler ( "onClientGUIClick", report.create.cancel, updates_report_event_onClientGUIClick )
	addEventHandler ( "onClientGUIChanged", report.create.desc, updates_report_event_onClientGUIChanged )
end

function updates_report_closeWindow ( )
	guiSetVisible ( report.create.window, false )
	showCursor ( false )
	removeEventHandler ( "onClientGUIClick", report.create.submit, updates_report_event_onClientGUIClick )
	removeEventHandler ( "onClientGUIClick", report.create.cancel, updates_report_event_onClientGUIClick )
	removeEventHandler ( "onClientGUIChanged", report.create.desc, updates_report_event_onClientGUIChanged )
end

function updates_report_event_onClientGUIClick ( ) 
	if ( source == report.create.window ) then return end
	if ( source == report.create.cancel ) then
		updates_report_closeWindow ( )
	elseif ( source == report.create.submit ) then
		local title = guiGetText ( report.create.title )
		local desc = guiGetText ( report.create.desc )
		if ( title:gsub ( " ", "" ) == "" ) then
			return exports.NGMessages:sendClientMessage ( "Invalid title", 255, 255, 255 )
		end if ( desc:gsub ( " ", "" ) == "" ) then
			return exports.NGMessages:sendClientMessage ( "Invalid description", 255, 255, 255 )
		end
		updates_report_submitReport ( )
		exports.NGMessages:sendClientMessage ( "Your report has been submitted. Thank you.", 0, 255, 0 )
		updates_report_closeWindow ( )
		guiSetText ( report.create.title, "" )
		guiSetText ( report.create.desc, "" )
	end
end

function updates_report_submitReport ( )
	local prior = guiGetText ( report.create.priority )
	local title = guiGetText ( report.create.title )
	local desc = guiGetText ( report.create.desc )
	triggerServerEvent ( "NGAdmin:Reports:onClientSubmitReport", localPlayer, prior, title, desc )
end

function updates_report_event_onClientGUIChanged ( )
	if ( source == report.create.desc ) then
		local text = guiGetText ( source )
		local length = text:len ( )
		if ( length > 700 ) then
			guiSetText ( source, string.sub ( text, 1, 699 ) )
			--exports.NGMessages:sendClientMessage ( "Descritpion is at max length", 255, 255, 255 )
		end
	end
end
addCommandHandler ( 'report', updates_openReportWindow )




-- Staff Window 
local updateList = nil
local ViewingReportData = nil
report.staff.window = guiCreateWindow(397, 276, 534, 479, "View Player Reports", false)
report.staff.reports = guiCreateGridList(9, 28, 515, 383, false, report.staff.window)
report.staff.exit = guiCreateButton(385, 421, 139, 38, "Exit", false, report.staff.window)
report.staff.check['open'] = guiCreateCheckBox(14, 419, 57, 17, "Open", true, false, report.staff.window)
report.staff.check['closed'] = guiCreateCheckBox(14, 436, 57, 17, "Closed", false, false, report.staff.window)
report.staff.check['on hold'] = guiCreateCheckBox(14, 436+(436-419), 71, 17, "On Hold", true, false, report.staff.window)
report.staff.check['priority_high'] = guiCreateCheckBox(200, 419, 57, 17, "High", true, false, report.staff.window)
report.staff.check['priority_medium'] = guiCreateCheckBox(200, 436, 57, 17, "Medium", true, false, report.staff.window)
report.staff.check['priority_low'] = guiCreateCheckBox(200, 436+(436-419), 71, 17, "Low", true, false, report.staff.window)
guiGridListAddColumn(report.staff.reports, "Title", 0.25)
guiGridListAddColumn(report.staff.reports, "From", 0.25)
guiGridListAddColumn(report.staff.reports, "Status", 0.17)
guiGridListAddColumn(report.staff.reports, "Priority", 0.17)
guiGridListAddColumn(report.staff.reports, "Date", 0.17)
guiGridListSetSortingEnabled ( report.staff.reports, false )
guiWindowSetSizable(report.staff.window, false)
guiSetVisible ( report.staff.window, false )
-- view window
report.staff.view_window = guiCreateWindow((sx/2-369/2), (sy/2-402/2), 369, 402, "View Report", false)
guiWindowSetSizable(report.staff.view_window, false)
guiSetVisible ( report.staff.view_window, false )
report.staff.view_title = guiCreateLabel(22, 36, 329, 24, "Title: n/a", false, report.staff.view_window)
report.staff.view_id = guiCreateLabel(22, 60, 329, 24, "Report ID: #0", false, report.staff.view_window)
report.staff.view_subOn = guiCreateLabel(22, 84, 329, 24, "Submitted by: N/A", false, report.staff.view_window)
report.staff.view_priority = guiCreateLabel(22, 108, 329, 24, "Priority: n/a", false, report.staff.view_window)
report.staff.view_status = guiCreateLabel(22, 132, 329, 24, "Status: n/a", false, report.staff.view_window)
report.staff.view_desc = guiCreateMemo(23, 165, 328, 179, "", false, report.staff.view_window)
guiMemoSetReadOnly(report.staff.view_desc, true)
report.staff.view_update_status = guiCreateComboBox(224, 108, 133, 102, "", false, report.staff.view_window)
guiComboBoxAddItem(report.staff.view_update_status, "Open")
guiComboBoxAddItem(report.staff.view_update_status, "Closed")
guiComboBoxAddItem(report.staff.view_update_status, "On Hold")
report.staff.view_update = guiCreateButton(225, 134, 132, 21, "Update", false, report.staff.view_window)
report.staff.view_back = guiCreateButton(23, 354, 132, 25, "Back", false, report.staff.view_window)
report.staff.view_del = guiCreateButton(225, 354, 132, 25, "Dump Report", false, report.staff.view_window)

addEvent ( "NGAdmin:Reports:onStaffViewReportsList", true )
addEventHandler ( "NGAdmin:Reports:onStaffViewReportsList", root, function ( list, delAccess )
	ViewingReportData = nil
	if ( guiGetVisible ( report.staff.window ) ) then
		reports_Staff_closeWindow()
	end
	
	guiSetVisible ( report.staff.window, true )
	showCursor ( true )
	guiGridListClear ( report.staff.reports )
	updateList = list
	reports_refreshReportsList ( )
	guiSetEnabled ( report.staff.view_del , delAccess )
	for i, v in pairs ( report.staff.check ) do
		addEventHandler ( "onClientGUIClick", v, reports_Staff_onClientGUIClick )
	end
	addEventHandler ( "onClientGUIClick", report.staff.exit, reports_Staff_onClientGUIClick )
	addEventHandler ( "onClientGUIDoubleClick", report.staff.reports, reports_staff_onClientGUIDoubleClick )
	addEventHandler ( "onClientGUIClick", report.staff.view_update, reports_Staff_onClientGUIClick )
	addEventHandler ( "onClientGUIClick", report.staff.view_back, reports_Staff_onClientGUIClick )
	addEventHandler ( "onClientGUIClick", report.staff.view_del, reports_Staff_onClientGUIClick )
	
	if ( #list == 0 ) then
		guiGridListSetItemText ( report.staff.reports, guiGridListAddRow(report.staff.reports), 1, "No reports found", true, true )
	end
	
end )

function reports_Staff_onClientGUIClick ( )
	for i, v in pairs ( report.staff.check ) do
		if ( source == v ) then
			reports_refreshReportsList()
			return
		end
	end
	if ( source == report.staff.exit ) then
		reports_Staff_closeWindow()
	elseif ( source == report.staff.view_back ) then
		guiSetVisible ( report.staff.view_window, false )
	elseif ( source == report.staff.view_update ) then
		local prior = tostring ( guiGetText ( report.staff.view_update_status ) ):lower ( )
		local inf = ViewingReportData
		if not inf then
			return exports.NGMessages:sendClientMessage ( "Failed to load information. Try to re-open the report.", 255, 0, 0 )
		end
		if ( inf.status == prior ) then
			return exports.NGMessages:sendClientMessage ( "Report #"..inf.id.." is already on the "..prior.." status.", 0, 255, 255 )
		end
		exports.NGMessages:sendClientMessage ( "Updating report #"..inf.id..": "..inf.status.." -> "..prior.."!", 255, 255, 0 )
		triggerServerEvent ( "NGAdmin:Module->Report:UpdateReportInformation", localPlayer, inf.id, "status", prior )
	elseif ( source == report.staff.view_del ) then
		if ( not ViewingReportData ) then
			return exports.NGMessages:sendClientMessage ( "Failed to load information. Try to re-open the report.", 255, 0, 0 )
		end
		askConfirm ( "Are you sure you want to delete report #"..tostring(ViewingReportData.id).."?", function ( x ) 
			if not x then return end
			if ( not ViewingReportData ) then
				return exports.NGMessages:sendClientMessage ( "Failed to load information. Try to re-open the report.", 255, 0, 0 )
			end
			triggerServerEvent ( "NGAdmin:Module->reports:DumpReport", localPlayer, ViewingReportData.id )
		end )
	end
end

function reports_staff_onClientGUIDoubleClick ( )
	if ( source == report.staff.reports ) then
		local r, _ = guiGridListGetSelectedItem ( source )
		if ( r == -1 ) then return end
		guiSetVisible ( report.staff.view_window, true )
		guiBringToFront ( report.staff.view_window )
		
		local data = guiGridListGetItemData ( source, r, 1 )
		guiSetText ( report.staff.view_title, "Title: "..tostring(data.title) )
		guiSetText ( report.staff.view_id, "Report ID: #"..tostring(data.id) )
		guiSetText ( report.staff.view_subOn, "Reported By: ".. tostring(data.user_from) .."  <--> ".. tostring(data.submittedon) )
		guiSetText ( report.staff.view_priority, "Priority: ".. tostring(data.priority) )
		guiSetText ( report.staff.view_update_status, firstToUpper(tostring(data.status)) )
		guiSetText ( report.staff.view_status, "Status: "..firstToUpper(tostring(data.status)) )
		guiSetText ( report.staff.view_desc, tostring(data.description) )
		ViewingReportData = data
	end
end

function reports_Staff_closeWindow ( )
	guiSetVisible ( report.staff.window, false )
	guiSetVisible ( report.staff.view_window, false )
	showCursor ( false )
	for i, v in pairs ( report.staff.check ) do
		removeEventHandler ( "onClientGUIClick", v, reports_Staff_onClientGUIClick )
	end
	removeEventHandler ( "onClientGUIClick", report.staff.exit, reports_Staff_onClientGUIClick )
	removeEventHandler ( "onClientGUIDoubleClick", report.staff.reports, reports_staff_onClientGUIDoubleClick )
	removeEventHandler ( "onClientGUIClick", report.staff.view_update, reports_Staff_onClientGUIClick )
	removeEventHandler ( "onClientGUIClick", report.staff.view_back, reports_Staff_onClientGUIClick )
	removeEventHandler ( "onClientGUIClick", report.staff.view_del, reports_Staff_onClientGUIClick )
end

function reports_refreshReportsList ( )
	guiGridListClear ( report.staff.reports )
	local priorityColors = { 
		['High'] = { 255, 0, 0 },
		['Medium'] = { 255, 140, 0 },
		['Low'] = { 255, 255, 0 }
	}
	
	for i, v in pairs ( updateList ) do
		local stat = tostring ( v.status )
		local prior = tostring ( v.priority )
		if ( guiCheckBoxGetSelected(report.staff.check[stat:lower()]) and guiCheckBoxGetSelected(report.staff.check["priority_"..prior:lower()] ) ) then
			local row = guiGridListAddRow ( report.staff.reports )
			guiGridListSetItemText(report.staff.reports,row,1,tostring(v.title),false,false)
			guiGridListSetItemText(report.staff.reports,row,2,tostring(v.user_from),false,false)
			guiGridListSetItemText(report.staff.reports,row,3,tostring(stat),false,false)
			guiGridListSetItemText(report.staff.reports,row,4,tostring(prior),false,false)
			guiGridListSetItemText(report.staff.reports,row,5,tostring(v.submittedon),false,false)
			for i=1, guiGridListGetColumnCount ( report.staff.reports ) do
				local r, g, b = unpack ( priorityColors [ prior ] )
				guiGridListSetItemColor ( report.staff.reports, row, i, r, g, b )
			end
			guiGridListSetItemData(report.staff.reports,row,1,v,false,false)
		end
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end