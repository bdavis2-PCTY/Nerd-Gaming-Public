------------------------------
-- Gui Elements				--
------------------------------
sx_, sy_ = guiGetScreenSize ( )
sx, sy = sx_ / 1280, sy_ / 720
local group = nil 
local gList = nil

function createGroupGui ( )
	exports.ngmessages:sendClientMessage ( "Loading interface, please wait...", 255, 255, 0 );

	gui = { 
		main ={ }, 
		info = { create = { }, invites = { }, motd = { } }, 
		list = { }, 
		admin = { 
			admin = { },
			info = { },
			members = { },
			ranks = { },
			logs = { }
		},
		my = { 
			basic = { },
			logs_ = { },
			bank_ = { },
			members_ = { },
			ranks_ = { },
			motd = { }
		} 
	}

	-- main
	local sx__, sy__ = sx, sy
	local sx, sy = 1, 1
	gui.main.window = guiCreateWindow((sx_/2-(sx*660)/2), (sy_/2-(sy*437)/2), sx*660, sy*437, "Group system", false)
	gui.main.info = guiCreateButton(sx*10, sy*26, sx*128, sy*40, "Information", false, gui.main.window)
	gui.main.list = guiCreateButton(sx*148, sy*26, sx*128, sy*40, "Group list", false, gui.main.window)
	gui.main.my = guiCreateButton(sx*286, sy*26, sx*128, sy*40, "My group", false, gui.main.window)
	gui.main.admin = guiCreateButton(sx*500, sy*26, sx*128, sy*40, "Groups Manager", false, gui.main.window)
	gui.main.line = guiCreateLabel(0, 74, sx*660, 24, string.rep ( "_", 200 ), false, gui.main.window)  
	
	gui.main.admin.visible = ( getElementData ( localPlayer, "staffLevel" ) or 0 ) > 2
	
	guiWindowSetSizable(gui.main.window, false)
	
	-- information
	gui.info.account = guiCreateLabel(sx*42, sy*136, sx*269, sy*20, "Account name: none", false, gui.main.window)
	gui.info.group = guiCreateLabel(sx*42, sy*156, sx*269, sy*20, "Group name: none", false, gui.main.window)
	gui.info.rank = guiCreateLabel(sx*42, sy*176, sx*269, sy*20, "Your group rank: none", false, gui.main.window)
	gui.info.create_ = guiCreateButton ( sx*42, sy*280, sx*130, sy*40, "Create a group", false, gui.main.window )
	gui.info.mInvites = guiCreateButton ( 180, 280, 130, 40, "My Invites", false, gui.main.window )
	gui.info.gMotd = guiCreateButton ( 318, 280, 130, 40, "Group MOTD", false, gui.main.window )  
		-- info -> create
		gui.info.create.window = guiCreateWindow(sx*383, sy*227, sx*500, sy*283, "Create Group", false)
		guiWindowSetSizable(gui.info.create.window, false)
		gui.info.create.l1 = guiCreateLabel(sx*22, sy*40, sx*184, sy*20, "Group Name:", false, gui.info.create.window)
		gui.info.create.name = guiCreateEdit(sx*207, sy*40, sx*219, sy*20, "", false, gui.info.create.window)
		gui.info.create.l2 = guiCreateLabel(sx*22, sy*78, sx*184, sy*20, "Group Color:", false, gui.info.create.window)
		gui.info.create.cr = guiCreateEdit(sx*207, sy*78, sx*54, sy*20, "0", false, gui.info.create.window)
		gui.info.create.cg = guiCreateEdit(sx*261, sy*78, sx*54, sy*20, "0", false, gui.info.create.window)
		gui.info.create.cb = guiCreateEdit(sx*315, sy*78, sx*54, sy*20, "0", false, gui.info.create.window)
		gui.info.create.cpick = guiCreateButton(sx*370, sy*78, sx*56, sy*20, "cpicker", false, gui.info.create.window)
		gui.info.create.l3 = guiCreateLabel(sx*23, sy*122, sx*184, sy*20, "Group Type:", false, gui.info.create.window)
		gui.info.create.type = guiCreateComboBox(sx*204, sy*122, sx*216, sy*93, "", false, gui.info.create.window)
		gui.info.create.create = guiCreateButton(sx*333, sy*215, sx*87, sy*27, "Create", false, gui.info.create.window)
		gui.info.create.close = guiCreateButton(sx*238, sy*215, sx*87, sy*27, "Close", false, gui.info.create.window)
		guiEditSetReadOnly(gui.info.create.cb, true)
		guiEditSetReadOnly(gui.info.create.cr, true)
		guiEditSetReadOnly(gui.info.create.cg, true)
		guiComboBoxAddItem(gui.info.create.type, "Gang")
		guiComboBoxAddItem(gui.info.create.type, "Service")
		guiComboBoxAddItem(gui.info.create.type, "Group")
		-- info -> my invites
		gui.info.invites.window = guiCreateWindow(345, 146, 640, 378, "My group invites", false)
		guiWindowSetSizable(gui.info.invites.window, false)
		gui.info.invites.label = guiCreateLabel(38, 33, 504, 21, "My group invites", false, gui.info.invites.window)
		gui.info.invites.list = guiCreateGridList(21, 54, 599, 267, false, gui.info.invites.window)
		guiGridListAddColumn(gui.info.invites.list, "Group", 0.3)
		guiGridListAddColumn(gui.info.invites.list, "Time", 0.3)
		guiGridListAddColumn(gui.info.invites.list, "From", 0.3)
		guiGridListSetSortingEnabled ( gui.info.invites.list, false )
		gui.info.invites.accept = guiCreateButton(21, 331, 117, 31, "Accept", false, gui.info.invites.window)
		gui.info.invites.deny = guiCreateButton(140, 331, 117, 31, "Deny", false, gui.info.invites.window)
		gui.info.invites.close = guiCreateButton(503, 331, 117, 31, "Close", false, gui.info.invites.window )
		-- info -> motd
		gui.info.motd.window = guiCreateWindow(392, 169, 528, 410, "Group MOTD", false)
		guiWindowSetSizable(gui.info.motd.window, false)
		gui.info.motd.motd = guiCreateMemo(9, 26, 509, 340, "", false, gui.info.motd.window)
		gui.info.motd.cancel = guiCreateButton(374, 370, 144, 30, "Close", false, gui.info.motd.window)

	-- list
	gui.list.list = guiCreateGridList(sx*10, sy*108, sx*640, sy*319, false, gui.main.window)
	guiGridListAddColumn(gui.list.list, "Group", 0.32)
	guiGridListAddColumn(gui.list.list, "Group founder", 0.32)
	guiGridListAddColumn(gui.list.list, "Group type", 0.15)
	guiGridListAddColumn(gui.list.list, "Members", 0.1)
	guiGridListSetSortingEnabled ( gui.list.list, false )

	-- my
	gui.my.info = guiCreateButton(10, 120, 128, 40, "Basic information", false, gui.main.window)
	gui.my.members = guiCreateButton(147, 122, 128, 40, "Members", false, gui.main.window)
	gui.my.ranks = guiCreateButton(285, 122, 128, 40, "Ranks", false, gui.main.window)
	gui.my.bank = guiCreateButton(424, 122, 128, 40, "Bank", false, gui.main.window)
	gui.my.logs = guiCreateButton(10, 170, 128, 40, "Logs", false, gui.main.window)   
	gui.my.modColor = guiCreateButton(147, 170, 128, 40, "Change Color", false, gui.main.window) 
	gui.my.modMotd = guiCreateButton(285, 170, 128, 40, "Change MOTD", false, gui.main.window)  
	gui.my.leave = guiCreateButton(10, 270, 128, 40, "Leave Group", false, gui.main.window) 
	gui.my.delete = guiCreateButton(147, 270, 128, 40, "Delete Group", false, gui.main.window) 
		-- my -> Basic information
		gui.my.basic.window = guiCreateWindow(509, 233, 317, 160, "Group Information", false)
		guiWindowSetSizable(gui.my.basic.window, false)
		gui.my.basic.group = guiCreateLabel(15, 31, 241, 19, "Group: none", false, gui.my.basic.window)
		gui.my.basic.founder = guiCreateLabel(15, 51, 241, 19, "Origianl founder: none", false, gui.my.basic.window)
		gui.my.basic.founded = guiCreateLabel(15, 71, 241, 19, "Founded on: none", false, gui.my.basic.window)
		gui.my.basic.close = guiCreateButton(15, 100, 91, 32, "Close", false, gui.my.basic.window)
		-- my -> Logs
		gui.my.logs_.window = guiCreateWindow(341, 142, 634, 392, "Group Logs", false)
		guiWindowSetSizable(gui.my.logs_.window, false)
		gui.my.logs_.list = guiCreateGridList(9, 25, 615, 311, false, gui.my.logs_.window)
		guiGridListAddColumn(gui.my.logs_.list, "Time", 0.28)
		guiGridListAddColumn(gui.my.logs_.list, "Account", 0.2)
		guiGridListAddColumn(gui.my.logs_.list, "Log", 0.7)
		guiGridListSetSortingEnabled ( gui.my.logs_.list, false )
		gui.my.logs_.close = guiCreateButton(488, 346, 136, 33, "Close", false, gui.my.logs_.window)
		gui.my.logs_.clear = guiCreateButton(342, 346, 136, 33, "Clear", false, gui.my.logs_.window)
		-- my -> Bank
		gui.my.bank_.window = guiCreateWindow(481, 270, 306, 141, "Group Bank", false)
		guiWindowSetSizable(gui.my.bank_.window, false)
		gui.my.bank_.balance = guiCreateLabel(14, 26, 372, 24, "Group Bank: $0", false, gui.my.bank_.window)
		gui.my.bank_.amount = guiCreateEdit(14, 55, 120, 23, "0", false, gui.my.bank_.window)
		gui.my.bank_.dep = guiCreateRadioButton(144, 40, 75, 23, "Deposit", false, gui.my.bank_.window)
		guiRadioButtonSetSelected(gui.my.bank_.dep, true)
		gui.my.bank_.go = guiCreateButton(16, 88, 120, 28, "Go", false, gui.my.bank_.window)
		gui.my.bank_.close = guiCreateButton(140, 88, 120, 28, "Close", false, gui.my.bank_.window)
		gui.my.bank_.with = guiCreateRadioButton(144, 63, 75, 23, "Withdraw", false, gui.my.bank_.window)
		-- my -> Ranks
		gui.my.ranks_.window = guiCreateWindow(551, 195, 378, 387, "Group Rank Manager", false)
		guiWindowSetSizable(gui.my.ranks_.window, false)
		gui.my.ranks_.lbl_1 = guiCreateLabel(21, 30, 220, 22, "Rank Name:", false, gui.my.ranks_.window)
		gui.my.ranks_.name = guiCreateEdit(21, 55, 282, 25, "", false, gui.my.ranks_.window)
		gui.my.ranks_.name.setMaxLength = 35
		gui.my.ranks_.scroll = guiCreateScrollPane(28, 93, 313, 238, false, gui.my.ranks_.window)
		gui.my.ranks_.lbl_2 = guiCreateLabel(8, 9, 248, 17, "Members", false, gui.my.ranks_.scroll)
		guiSetFont(gui.my.ranks_.lbl_2, "default-bold-small")
		gui.my.ranks_['perm_member_invite'] = guiCreateCheckBox(17, 28, 273, 15, "Invite Members", false, false, gui.my.ranks_.scroll)
		gui.my.ranks_['perm_member_kick'] = guiCreateCheckBox(17, 43, 273, 15, "Kick Players", false, false, gui.my.ranks_.scroll)
		gui.my.ranks_['perm_member_setrank'] = guiCreateCheckBox(17, 58, 273, 15, "Set Members Ranks", false, false, gui.my.ranks_.scroll)
		gui.my.ranks_['perm_member_viewlog'] = guiCreateCheckBox(17, 73, 273, 15, "View Player Group Logs", false, false, gui.my.ranks_.scroll)
		gui.my.ranks_.lbl_3 = guiCreateLabel(10, 88, 248, 17, "Group Bank", false, gui.my.ranks_.scroll)
		guiSetFont(gui.my.ranks_.lbl_3, "default-bold-small")
		gui.my.ranks_['perm_bank_withdraw'] = guiCreateCheckBox(17, 105, 273, 15, "Withdraw from bank", false, false, gui.my.ranks_.scroll )
		gui.my.ranks_['perm_bank_deposit'] = guiCreateCheckBox(17, 120, 273, 15, "Deposit to bank", true, false, gui.my.ranks_.scroll)
		gui.my.ranks_.lbl_4 = guiCreateLabel(10, 135, 248, 17, "Group Logs", false, gui.my.ranks_.scroll )
		guiSetFont(gui.my.ranks_.lbl_4, "default-bold-small")
		gui.my.ranks_['perm_logs_view'] = guiCreateCheckBox(17, 152, 273, 15, "View group logs", true, false, gui.my.ranks_.scroll)
		gui.my.ranks_['perm_logs_clear'] = guiCreateCheckBox(17, 167, 273, 15, "Clear group logs", false, false, gui.my.ranks_.scroll)
		gui.my.ranks_.lbl_5 = guiCreateLabel(10, 182, 248, 17, "Group Ranks", false, gui.my.ranks_.scroll)
		guiSetFont(gui.my.ranks_.lbl_5, "default-bold-small")
		gui.my.ranks_['perm_ranks_create'] = guiCreateCheckBox(17, 199, 273, 15, "Create Ranks", false, false, gui.my.ranks_.scroll)
		gui.my.ranks_['perm_ranks_delete'] = guiCreateCheckBox(17, 214, 273, 15, "Delete Ranks", false, false, gui.my.ranks_.scroll)
		gui.my.ranks_.lbl_6 = guiCreateLabel(10, 229, 248, 17, "Group Settings", false, gui.my.ranks_.scroll)
		guiSetFont(gui.my.ranks_.lbl_6, "default-bold-small")
		gui.my.ranks_['perm_group_modify_color'] = guiCreateCheckBox(20, 246, 273, 15, "Modify Group MOTD", false, false, gui.my.ranks_.scroll)
		gui.my.ranks_['perm_group_modify_motd'] = guiCreateCheckBox(20, 261, 273, 15, "Modify Group Color", false, false, gui.my.ranks_.scroll)
		gui.my.ranks_.add = guiCreateButton(241, 341, 99, 28, "Add Rank", false, gui.my.ranks_.window)
		gui.my.ranks_.close = guiCreateButton(132, 341, 99, 28, "Cancel", false, gui.my.ranks_.window)
		-- my -> Members
		gui.my.members_.window = guiCreateWindow(345, 146, 640, 378, "My group members", false)
		guiWindowSetSizable(gui.my.members_.window, false)
		gui.my.members_.label = guiCreateLabel(38, 33, 504, 21, "My group members", false, gui.my.members_.window)
		gui.my.members_.list = guiCreateGridList(21, 54, 599, 267, false, gui.my.members_.window)
		guiGridListAddColumn(gui.my.members_.list, "Username", 0.3)
		guiGridListAddColumn(gui.my.members_.list, "Rank", 0.3)
		guiGridListAddColumn(gui.my.members_.list, "Online", 0.3)
		guiGridListSetSortingEnabled ( gui.my.members_.list, false )
		gui.my.members_.log = guiCreateButton(21, 331, 117, 31, "This Players Log", false, gui.my.members_.window)
		gui.my.members_.srank = guiCreateButton(140, 331, 117, 31, "Set Rank", false, gui.my.members_.window)
		gui.my.members_.kick = guiCreateButton(259, 331, 117, 31, "Kick", false, gui.my.members_.window)
		gui.my.members_.invite = guiCreateButton(378, 331, 117, 31, "Invite", false, gui.my.members_.window)
		gui.my.members_.close = guiCreateButton(503, 331, 117, 31, "Close", false, gui.my.members_.window )
			--> my -> Members -> Player Log
			gui.my.members_.lWindow = guiCreateWindow(341, 142, 634, 392, "Player Log", false)
			guiWindowSetSizable(gui.my.members_.window, false)
			gui.my.members_.lList = guiCreateGridList(9, 25, 615, 311, false, gui.my.members_.lWindow)
			guiGridListAddColumn(gui.my.members_.lList, "Time", 0.28)
			guiGridListAddColumn(gui.my.members_.lList, "Account", 0.2)
			guiGridListAddColumn(gui.my.members_.lList, "Log", 0.7)
			guiGridListSetSortingEnabled ( gui.my.members_.lList, false )
			gui.my.members_.lClose = guiCreateButton(488, 346, 136, 33, "Close", false, gui.my.members_.lWindow)
			-- my -> Members -> Set rank
			gui.my.members_.rWindow = guiCreateWindow(502, 128, 266, 414, "Group Rank", false)
			guiWindowSetSizable(gui.my.members_.rWindow, false)
			gui.my.members_.rRanks = guiCreateComboBox(14, 66, 236, 304, "", false, gui.my.members_.rWindow)
			gui.my.members_.rUpdate = guiCreateButton(18, 35, 113, 25, "Update", false, gui.my.members_.rWindow)
			gui.my.members_.rClose = guiCreateButton(137, 35, 113, 25, "Cancel", false, gui.my.members_.rWindow)
			-- my -> Members -> Invite
			gui.my.members_.iWindow = guiCreateWindow(339, 162, 611, 296, "Invite Players", false)
			guiWindowSetSizable(gui.my.members_.iWindow, false)
			gui.my.members_.iList = guiCreateGridList(9, 22, 592, 223, false, gui.my.members_.iWindow)
			guiGridListAddColumn(gui.my.members_.iList, "Player", 0.9)
			gui.my.members_.iLabel = guiCreateLabel(16, 254, 102, 27, "Search Player:", false, gui.my.members_.iWindow)
			guiLabelSetVerticalAlign(gui.my.members_.iLabel, "center")
			gui.my.members_.iFilter = guiCreateEdit(118, 253, 184, 28, "", false, gui.my.members_.iWindow)
			gui.my.members_.iClose = guiCreateButton(531, 255, 70, 25, "Close", false, gui.my.members_.iWindow)
			gui.my.members_.iInvite = guiCreateButton(451, 256, 70, 25, "Invite", false, gui.my.members_.iWindow)
		-- my -> change motd
		gui.my.motd.window = guiCreateWindow(392, 169, 528, 410, "", false)
		guiWindowSetSizable(gui.my.motd.window, false)
		gui.my.motd.motd = guiCreateMemo(9, 26, 509, 340, "", false, gui.my.motd.window)
		gui.my.motd.update = guiCreateButton(374, 370, 144, 30, "Update", false, gui.my.motd.window)
		gui.my.motd.cancel = guiCreateButton(220, 370, 144, 30, "Cancel", false, gui.my.motd.window)

	
	-- Administration Panel (NG 1.1.4)
	gui.admin.window = guiCreateWindow(386, 123, 608, 421, "NG Group Manager (Staff)", false)
	guiWindowSetSizable(gui.admin.window, false)

	gui.admin.admin.groupList = guiCreateGridList(9, 21, 401, 390, false, gui.admin.window)
	guiGridListSetSortingEnabled ( gui.admin.admin.groupList, false );
	guiGridListAddColumn ( gui.admin.admin.groupList, "Group", 0.5 );
	guiGridListAddColumn ( gui.admin.admin.groupList, "Founder", 0.3 );
	guiGridListAddColumn ( gui.admin.admin.groupList, "Members", 0.15 );
	
	gui.admin.admin.groupInfo = guiCreateButton(412, 26, 186, 29, "Basic Information", false, gui.admin.window)
	gui.admin.admin.groupMembers = guiCreateButton(412, 65, 186, 29, "Members", false, gui.admin.window)
	gui.admin.admin.groupRanks = guiCreateButton(412, 104, 186, 29, "Ranks", false, gui.admin.window)
	gui.admin.admin.groupLogs = guiCreateButton(412, 143, 186, 29, "Logs", false, gui.admin.window)
	gui.admin.admin.closeWindow = guiCreateButton(412, 382, 186, 29, "Close", false, gui.admin.window)
	gui.admin.admin.deleteGroup = guiCreateButton(412, 182, 186, 29, "Delete Group", false, gui.admin.window)
	guiSetProperty(gui.admin.admin.deleteGroup, "NormalTextColour", "FFFF0000")
		-- manager->Basic Information
		gui.admin.info.window = guiCreateWindow(445, 148, 559, 399, "Group Information", false)
		guiWindowSetSizable(gui.admin.info.window, false)
		gui.admin.info.list = guiCreateGridList(9, 29, 540, 314, false, gui.admin.info.window)
		guiGridListAddColumn(gui.admin.info.list, "Data Set", 0.4)
		guiGridListAddColumn(gui.admin.info.list, "Value", 0.5)
		gui.admin.info.close = guiCreateButton(10, 353, 164, 36, "Close", false, gui.admin.info.window)
		-- manager->members
		gui.admin.members.window = guiCreateWindow(445, 148, 559, 399, "Group Members", false)
		guiWindowSetSizable(gui.admin.members.window, false)
		gui.admin.members.list = guiCreateGridList(9, 29, 540, 314, false, gui.admin.members.window)
		guiGridListAddColumn(gui.admin.members.list, "Account", 0.3)
		guiGridListAddColumn(gui.admin.members.list, "Rank", 0.3)
		guiGridListAddColumn(gui.admin.members.list, "Joined", 0.3)
		gui.admin.members.close = guiCreateButton(10, 353, 164, 36, "Close", false, gui.admin.members.window)
		-- manager->ranks 
		gui.admin.ranks.window = guiCreateWindow(445, 148, 559, 399, "Group Members", false)
		guiWindowSetSizable(gui.admin.ranks.window, false)
		gui.admin.ranks.list = guiCreateGridList(9, 29, 540, 314, false, gui.admin.ranks.window)
		guiGridListAddColumn(gui.admin.ranks.list, "Permission", 0.5)
		guiGridListAddColumn(gui.admin.ranks.list, "Access", 0.4)
		gui.admin.ranks.close = guiCreateButton(10, 353, 164, 36, "Close", false, gui.admin.ranks.window)
		-- manager->logs 
		gui.admin.logs.window = guiCreateWindow(445, 148, 559, 399, "Group Logs", false)
		guiWindowSetSizable(gui.admin.logs.window, false)
		gui.admin.logs.list = guiCreateGridList(9, 29, 540, 314, false, gui.admin.logs.window)
		guiGridListAddColumn(gui.admin.logs.list, "Account", 0.25)
		guiGridListAddColumn(gui.admin.logs.list, "Time", 0.25)
		guiGridListAddColumn(gui.admin.logs.list, "Log", 0.8)
		gui.admin.logs.close = guiCreateButton(10, 353, 164, 36, "Close", false, gui.admin.logs.window)
		
	
	
	local sx, sy = sx__, sy__
	local doElements = { }
	for i, v in pairs ( gui ) do 
		if ( type ( v ) ~= "table" ) then
			table.insert ( doElements, v )
		else 
			for i, v in pairs ( v ) do 
				if ( type ( v ) ~= "table" ) then
					table.insert ( doElements, v )
				else
					for i, v in pairs ( v ) do
						if ( type ( v ) ~= "table" ) then
							table.insert ( doElements, v )
						end
					end
				end
			end
		end
	end

	-- Window Visibilities
	guiSetVisible ( gui.my.basic.window , false )
	guiSetVisible ( gui.my.logs_.window, false )
	guiSetVisible ( gui.info.create.window, false )
	guiSetVisible ( gui.my.bank_.window, false )
	guiSetVisible ( gui.my.members_.window, false )
	gui.my.members_.lWindow.visible = false
	gui.my.members_.rWindow.visible = false
	gui.my.members_.iWindow.visible = false
	gui.info.invites.window.visible = false
	gui.my.ranks_.window.visible = false
	gui.my.motd.window.visible = false
	gui.info.motd.window.visible = false
	gui.admin.window.visible = false
	gui.admin.info.window.visible = false
	gui.admin.members.window.visible = false
	gui.admin.ranks.window.visible = false
	gui.admin.logs.window.visible = false

	-- reposition and resize
	for i, v in pairs ( doElements ) do 
		local t = getElementType ( v )
		local x, y = guiGetPosition ( v, false )
		local w, h = guiGetSize ( v, false )
		--guiSetSize ( v, sx*w, sx*h, false )
		local w, h = guiGetSize ( v, false )
		if ( t == "gui-window" ) then 
			x, y = ( sx_/2-w/2 ), ( sy_/2-h/2 )
		end
		guiSetPosition ( v, x, y, false )
		x, y, w, h, t = nil, nil, nil, nil, nil
	end

	showCursor ( true )
	doElements = nil
	triggerServerEvent ( "NGGroups->Events:onClientRequestGroupList", localPlayer )
	guiSetInputMode ( "no_binds_when_editing" )
end

function isset ( f ) 
	if ( f ) then
		return true
	end
	return false
end 

function loadGroupPage ( p, AllowElementsToStay, arg1 )
	if ( not AllowElementsToStay ) then
		if ( not gui ) then 
			return exports.ngmessages:sendClientMessage ( "Please allow the GUI to finish loading...", 255, 255, 0 );
		end 
	
		for i, t in pairs ( gui ) do 
			for _, v in pairs ( t ) do 
				if ( type ( v ) ~= "table" ) then
					if ( i ~= "main" and isElement ( v ) ) then 
						guiSetVisible ( v, false )
					end
				end
			end
		end
	end

	-- core features
	if ( p == "core.admin" ) then 
		gui.admin.window.visible = true;
		gui.admin.window:bringToFront();
		guiGridListClear ( gui.admin.admin.groupList );
		
		for gName, info in pairs ( gList ) do 
			local row = guiGridListAddRow ( gui.admin.admin.groupList );
			if ( not r ) then r = 255; end 
			if ( not g ) then g = 255; end
			if ( not b ) then b = 255; end
			guiGridListSetItemText ( gui.admin.admin.groupList, row, 1, tostring ( gName ), false, false );
			guiGridListSetItemText ( gui.admin.admin.groupList, row, 2, tostring ( info.info.founder ), false, false );
			guiGridListSetItemText ( gui.admin.admin.groupList, row, 3, table.len ( info.members ), false, false );
			for i=1,3 do 
				guiGridListSetItemColor ( gui.admin.admin.groupList, row, i, info.info.color.r, info.info.color.g, info.info.color.b );
			end 
		end
	elseif ( p == "core.info" ) then 
		for i, v in pairs ( gui.info ) do 
			if ( v and isElement ( v ) ) then
				guiSetVisible ( v, true )
			end
		end

		local acc = tostring ( getElementData ( localPlayer, "AccountData:Username" ) or "none" )
		guiSetText ( gui.info.account, "Your Account: "..acc )
		guiSetText ( gui.info.group, "Your group: "..tostring ( group or "None" ) )
		guiSetText ( gui.info.rank, "Your Rank: "..tostring ( rank or "None" ) )

		local group = tostring ( group )
		if ( group and gList and gList [ group ] ) then
		else
			if ( group and group:lower() ~= "none" ) then
				setElementData ( localPlayer, "Group", "None" )
				setElementData ( localPlayer, "Group Rank", "None")
				group = nil
				rank = nil
			end 
		end

		-- Button locked permissions
		guiSetEnabled ( gui.main.my, isset ( group ) )
		gui.info.gMotd.enabled = isset ( group )
		guiSetEnabled ( gui.info.create_, not isset ( group ) )
		if ( group and group:lower() ~= "none" ) then
			guiSetEnabled ( gui.my.members_.kick, gList[group].ranks[rank].member_kick or false )
			guiSetEnabled ( gui.my.members_.srank, gList[group].ranks[rank].member_setrank or false )
			guiSetEnabled ( gui.my.members_.log, gList[group].ranks[rank].member_viewlog or false )
			gui.my.members_.invite.enabled = gList[group].ranks[rank].member_invite or false
			gui.my.delete.enabled = ( rank == "Founder" )
			gui.my.leave.enabled = ( rank ~= "Founder" )
			gui.my.logs.enabled = gList[group].ranks[rank].logs_view or false
			gui.my.logs_.clear.enabled = gList[group].ranks[rank].logs_clear or false
			gui.my.modColor.enabled = gList[group].ranks[rank].group_modify_color or false
			gui.my.modMotd.enabled = gList[group].ranks[rank].group_modify_motd or false
		end
	elseif ( p == "core.list" ) then 
		guiGridListClear ( gui.list.list )
		guiSetVisible ( gui.list.list, true )
		local total = 0
		for name, v in pairs ( gList ) do
			if ( table.len ( v.members ) ~= 0 ) then
				local r, g, b = v.info.color.r, v.info.color.g, v.info.color.b
				local ro = guiGridListAddRow ( gui.list.list )
				guiGridListSetItemText ( gui.list.list, ro, 1, tostring ( name ), false, false )
				guiGridListSetItemText ( gui.list.list, ro, 2, tostring ( v.info.founder ), false, false )
				guiGridListSetItemText ( gui.list.list, ro, 3, tostring ( v.info.type ), false, false )
				guiGridListSetItemText ( gui.list.list, ro, 4, tostring ( table.len ( v.members ) ), false, false  )
				for i=1, 4 do
					guiGridListSetItemColor ( gui.list.list, ro, i, r, g, b )
				end 
				r, g, b, ro = nil, nil, nil, nil
				total = 1
			else
				triggerServerEvent ( "NGGroups->Modules->Gangs->Force->DeleteGroup", resourceRoot, tostring ( name ) )
			end 
		end 

		if ( total == 0 ) then
			guiGridListSetItemText ( gui.list.list, guiGridListAddRow ( gui.list.list ), 1, "There's currently no groups", true, true )
		end 
	elseif ( p == "core.my" ) then 
		for i, v in pairs ( gui.my ) do
			if ( type ( v ) ~= "table"  and isElement ( v ) ) then
				guiSetVisible ( v, true ) 
			end
		end
	elseif ( p == "core.myInvites" ) then
		gui.info.invites.window.visible = true
		guiBringToFront(  gui.info.invites.window )
		guiGridListClear ( gui.info.invites.list )
		
		for i, v in pairs ( gList ) do 
			if ( #v.pendingInvites > 0 ) then
				for index, info in pairs ( v.pendingInvites ) do 
					if ( info.to == getElementData ( localPlayer, "AccountData:Username" ) ) then
						local r = guiGridListAddRow ( gui.info.invites.list )
						guiGridListSetItemText ( gui.info.invites.list, r, 1, tostring ( i ), false, false )
						guiGridListSetItemText ( gui.info.invites.list, r, 2, tostring ( info.time ), false, false )
						guiGridListSetItemText ( gui.info.invites.list, r, 3, tostring ( info.inviter ), false, false )
					end
				end
			end 
		end 
		

	elseif ( p == "my.basicInfo" ) then
		guiSetVisible ( gui.my.basic.window, true )
		guiBringToFront ( gui.my.basic.window )
		guiSetText ( gui.my.basic.group, "Group: ".. tostring ( group or "none" ) )
		if ( gList and group and gList[group] ) then
			guiSetText ( gui.my.basic.founder, "Original founder: "..tostring ( gList[group].info.founder or "none" ) )
			guiSetText ( gui.my.basic.founded, "Founded on: "..tostring ( gList[group].info.founded_time or "unknown" ))
		else
			guiSetText ( gui.my.basic.founder, "Original founder: none" )
			guiSetText ( gui.my.basic.founded, "Founded on: unknown")
		end
	elseif ( p == "my.logs" ) then
		guiSetVisible ( gui.my.logs_.window, true )
		guiBringToFront ( gui.my.logs_.window )
		guiGridListClear ( gui.my.logs_.list )

		for i, v in ipairs ( gList[group].log ) do 
			local r = guiGridListAddRow ( gui.my.logs_.list )
			guiGridListSetItemText ( gui.my.logs_.list, r, 1, tostring ( v.time ), false, false  )
			guiGridListSetItemText ( gui.my.logs_.list, r, 2, tostring ( v.account ), false, false )
			guiGridListSetItemText ( gui.my.logs_.list, r, 3, tostring ( v.log ), false, false )
		end 
	elseif ( p == "my.bank" ) then
		guiSetVisible ( gui.my.bank_.window, true )
		guiSetEnabled ( gui.my.bank_.amount, false )
		guiSetEnabled ( gui.my.bank_.go, false )
		guiSetEnabled ( gui.my.bank_.with, false )
		guiSetEnabled ( gui.my.bank_.dep, false )
		guiSetText ( gui.my.bank_.balance, "Group Balance: Loading..." )
		triggerServerEvent ( "NGGroups:Module->Bank:returnBankBalanceToClient", localPlayer, group )
		guiBringToFront ( gui.my.bank_.window )
	elseif ( p == "core.create" ) then
		guiSetVisible ( gui.info.create.window, true )
		guiBringToFront ( gui.info.create.window )
	elseif ( p == "my.members" ) then
		gui.my.members_.window.visible = true
		gui.my.members_.list.clear ( gui.my.members_.list )
		for i, v in pairs ( gList [ group ].members ) do 
			local r = guiGridListAddRow ( gui.my.members_.list )
			gui.my.members_.list.setItemText ( gui.my.members_.list, r, 1, tostring ( i ), false, false )
			gui.my.members_.list.setItemText ( gui.my.members_.list, r, 2, tostring ( v.rank ), false, false )
			local online = "No"
			for _, k in pairs ( getElementsByType ( "player" ) ) do 
				local acc = getElementData ( k, "AccountData:Username" )
				if ( acc and acc == i ) then
					online = "Yes"
					break
				end
			end 
			gui.my.members_.list.setItemText ( gui.my.members_.list, r, 3, tostring ( online ), false, false )
			for k=1, 3 do 
				local r, g, b = 0, 255, 0
				if ( online == "No" ) then
					r, g, b = 255, 0, 0
				end
				guiGridListSetItemColor ( gui.my.members_.list, r, k, r, g, b )
			end 
		end 
	end
end

function onClientGuiClick ( )
	-- core buttons
	if ( source == gui.main.info ) then 
		loadGroupPage ( "core.info" )
	elseif ( source == gui.main.list ) then 
		loadGroupPage ( "core.list" )
	elseif ( source == gui.main.my ) then
		loadGroupPage ( "core.my" ) 
	elseif ( source == gui.main.admin ) then 
		loadGroupPage ( "core.admin", true );
		
	-- Group administration (Staff)
	elseif ( source == gui.admin.admin.closeWindow ) then 
		gui.admin.window.visible = false;
	elseif ( source == gui.admin.info.close ) then 
		gui.admin.info.window.visible = false;
	elseif ( source == gui.admin.members.close ) then 
		gui.admin.members.window.visible = false;
	elseif ( source == gui.admin.ranks.close ) then 
		gui.admin.ranks.window.visible = false;
	elseif ( source == gui.admin.logs.close ) then 
		gui.admin.logs.window.visible = false;
	elseif ( source == gui.admin.admin.groupInfo ) then 
		local r, c = guiGridListGetSelectedItem ( gui.admin.admin.groupList );
		if ( r == -1 ) then return exports.ngmessages:sendClientMessage ( "No group is selected", 255, 255, 255 ); end
		gui.admin.info.window.visible = true;
		gui.admin.info.window:bringToFront ( );
		guiGridListClear ( gui.admin.info.list );
		for index, value in pairs ( gList [ guiGridListGetItemText ( gui.admin.admin.groupList, r, 1 ) ].info ) do 
			local r = guiGridListAddRow ( gui.admin.info.list );
			guiGridListSetItemText ( gui.admin.info.list, r, 1, tostring ( index ), false, false )
			if ( index == "color" ) then value = table.concat ( { value.r, value.g, value.b }, ", " );end
			guiGridListSetItemText ( gui.admin.info.list, r, 2, tostring ( value ), false, false )
		end 
	elseif ( source == gui.admin.admin.groupMembers ) then 
		local r, c = guiGridListGetSelectedItem ( gui.admin.admin.groupList );
		if ( r == -1 ) then return exports.ngmessages:sendClientMessage ( "No group is selected", 255, 255, 255 ); end
		gui.admin.members.window.visible = true;
		gui.admin.members.window:bringToFront ( );
		guiGridListClear ( gui.admin.members.list );
		for member, info in pairs ( gList [ guiGridListGetItemText ( gui.admin.admin.groupList, r, 1 ) ].members ) do 
			local r = guiGridListAddRow ( gui.admin.members.list );
			guiGridListSetItemText ( gui.admin.members.list, r, 1, tostring ( member ), false, false )
			guiGridListSetItemText ( gui.admin.members.list, r, 2, tostring ( info.rank ), false, false )
			guiGridListSetItemText ( gui.admin.members.list, r, 3, tostring ( info.joined ), false, false )
		end 
	elseif ( source == gui.admin.admin.groupRanks ) then 
		local r, c = guiGridListGetSelectedItem ( gui.admin.admin.groupList );
		if ( r == -1 ) then return exports.ngmessages:sendClientMessage ( "No group is selected", 255, 255, 255 ); end
		gui.admin.ranks.window.visible = true;
		gui.admin.ranks.window:bringToFront ( );
		guiGridListClear ( gui.admin.ranks.list );
		for rank, permissions in pairs ( gList [ guiGridListGetItemText ( gui.admin.admin.groupList, r, 1 ) ].ranks ) do 
			guiGridListSetItemText ( gui.admin.ranks.list, guiGridListAddRow ( gui.admin.ranks.list ), 1, tostring ( rank ), true, true );
			for permission, access in pairs ( permissions ) do 
				local r = guiGridListAddRow ( gui.admin.ranks.list );
				local sAccess = ( access and "Yes" ) or "No";
				guiGridListSetItemText ( gui.admin.ranks.list, r, 1, tostring ( permission ), false, false );
				guiGridListSetItemText ( gui.admin.ranks.list, r, 2, sAccess, false, false );
				if ( sAccess == "Yes" ) then 
					guiGridListSetItemColor ( gui.admin.ranks.list, r, 1, 0, 255, 0 );
					guiGridListSetItemColor ( gui.admin.ranks.list, r, 2, 0, 255, 0 );
				else 
					guiGridListSetItemColor ( gui.admin.ranks.list, r, 1, 255, 0, 0 );
					guiGridListSetItemColor ( gui.admin.ranks.list, r, 2, 255, 0, 0 );
				end
			end 
		end 
	elseif ( source == gui.admin.admin.groupLogs ) then 
		local r, c = guiGridListGetSelectedItem ( gui.admin.admin.groupList );
		if ( r == -1 ) then return exports.ngmessages:sendClientMessage ( "No group is selected", 255, 255, 255 ); end
		gui.admin.logs.window.visible = true;
		gui.admin.logs.window:bringToFront ( );
		guiGridListClear ( gui.admin.logs.list );
		for _, log in pairs ( gList [ guiGridListGetItemText ( gui.admin.admin.groupList, r, 1 ) ].log ) do 
			local r = guiGridListAddRow ( gui.admin.logs.list );
			guiGridListSetItemText ( gui.admin.logs.list, r, 1, tostring ( log.account ), false, false );
			guiGridListSetItemText ( gui.admin.logs.list, r, 2, tostring ( log.time ), false, false );
			guiGridListSetItemText ( gui.admin.logs.list, r, 3, tostring ( log.log ), false, false );
		end 
	elseif ( source == gui.admin.admin.deleteGroup ) then 
		local r, c = guiGridListGetSelectedItem ( gui.admin.admin.groupList );
		if ( r == -1 ) then return exports.ngmessages:sendClientMessage ( "No group is selected", 255, 255, 255 ); end
		
		local group = tostring ( guiGridListGetItemText ( gui.admin.admin.groupList, r, 1 ) );
		
		askConfirm ( "Are you really sure you want to delete this group?", function ( done, group )
			if ( not done )then return end 
			triggerServerEvent ( "NGGroups->GroupStaff:OnAdminDeleteGroup", localPlayer, group );
		end, group )
	
	-- my buttons
	elseif ( source == gui.my.info ) then 
		loadGroupPage ( "my.basicInfo", true )
	elseif ( source == gui.my.basic.close ) then
		guiSetVisible ( gui.my.basic.window, false )

	elseif ( source == gui.my.logs ) then
		loadGroupPage ( "my.logs", true )
	elseif ( source == gui.my.logs_.close ) then
		guiSetVisible ( gui.my.logs_.window, false )
	elseif ( source == gui.my.logs_.clear ) then
		askConfirm ( "Are you sure you would like to clear your group logs?", function ( v )
			if ( not v ) then return end
			triggerServerEvent ( "NGGroups->GEvents:onPlayerClearGroupLog", localPlayer, group )
			gui.my.logs_.window.visible = false
		end )

	-- Create window
	elseif ( source == gui.info.create_ ) then
		loadGroupPage ( "core.create", true )
	elseif ( source == gui.info.create.close ) then
		guiSetVisible ( gui.info.create.window, false )
	elseif ( source == gui.info.create.cpick ) then
		exports.cpicker:openPicker ( "GroupColorPicker", { 
			r=tonumber(guiGetText(gui.info.create.cr)),
			g=tonumber(guiGetText(gui.info.create.cg)),
			b=tonumber(guiGetText(gui.info.create.cb)),
			a=255
		}, "Group Color Picker" )
	elseif ( source == gui.info.create.create ) then
		local name = tostring ( guiGetText ( gui.info.create.name ) )
		local r=tonumber(guiGetText(gui.info.create.cr))
		local g=tonumber(guiGetText(gui.info.create.cg))
		local b=tonumber(guiGetText(gui.info.create.cb))
		local tp = tostring ( guiGetText ( gui.info.create.type ) )

		if ( name:gsub ( " ", "" ) == "" ) then
			return exports.ngmessages:sendClientMessage ( "You need to enter a name", 255, 255, 0 )
		end

		if ( tp:gsub ( " ", "" ) == "" ) then
			return exports.ngmessages:sendClientMessage ( "Please select a group type", 255, 255, 0 )
		end

		if ( not r or not g or not b ) then
			return exports.ngmessages:sendClientMessage ( "Please select a group color", 255, 255, 0 )
		end

		local color = { 
			r = r, 
			g = g, 
			b = b 
		}

		triggerServerEvent ( "NGGroups->GEvents:onPlayerAttemptGroupMake", localPlayer, { name=name, type = tp, color=color } )
	-- invites 
	elseif ( source == gui.info.mInvites ) then
		loadGroupPage ( "core.myInvites", true )
	elseif ( source == gui.info.invites.close ) then
		gui.info.invites.window.visible = false
	elseif ( source == gui.info.invites.deny ) then
		local r, c = guiGridListGetSelectedItem ( gui.info.invites.list )
		if ( r == -1 ) then
			return exports.ngmessages:sendClientMessage ( "No group selected", 255, 0, 0 )
		end
		exports.ngmessages:sendClientMessage("You denied the invite to "..guiGridListGetItemText ( gui.info.invites.list, r, 1 ) )
		triggerServerEvent ( "NGGroups->Modules->Groups->Invites->OnPlayerDeny", localPlayer, guiGridListGetItemText ( gui.info.invites.list, r, 1 ) )
	elseif ( source == gui.info.invites.accept ) then
		local r, c = guiGridListGetSelectedItem ( gui.info.invites.list )
		if ( r == -1 ) then
			return exports.ngmessages:sendClientMessage ( "No group selected", 255, 0, 0 )
		elseif ( group and group:lower() ~= "none" ) then
			return exports.ngmessages:sendClientMessage ( "You need to leave your group before joining another one.", 255, 255, 0 )
		end 
		triggerServerEvent ( "NGGroups->Modules->Groups->Invites->OnPlayerAccept", localPlayer, guiGridListGetItemText ( gui.info.invites.list, r, 1 ) )

	-- bank
	elseif ( source == gui.my.bank ) then
		loadGroupPage ( "my.bank", true );
	elseif ( source == gui.my.bank_.close ) then
		gui.my.bank_.window.visible = false
	elseif ( source == gui.my.bank_.go ) then
		local a = tonumber ( gui.my.bank_.amount.text );
		if ( not a ) then
			return exports.ngmessages:sendClientMessage ( "Invalid cash amount", 255, 0, 0 );
		end

		local a = math.floor ( a )
		if ( a <= 0 ) then
			return exports.ngmessages:sendClientMessage ( "Please enter a number greater than 0", 255, 0, 0 )
		end

		-- run this to check if they have access
		if ( gui.my.bank_.with.selected ) then
			triggerServerEvent ( "NGGroups:Modules->BankSys:onPlayerAttemptWithdawl", localPlayer, group, a )
			gui.my.bank_.window.visible = false
		elseif ( gui.my.bank_.dep.selected ) then
			triggerServerEvent ( "NGGroups:Modules->BankSys:onPlayerAttemptDeposit", localPlayer, group, a )
			gui.my.bank_.window.visible = false
		else
			return exports.ngmessages:sendClientMessage ( "Please select your method (Deposit/Withdraw)", 255, 255, 0 )
		end

	-- delete
	elseif ( source == gui.my.delete ) then
		askConfirm ( "Are you sure you want to delete your gang? You will not be able to get it back.", function ( x )
			if ( not x ) then return end
			triggerServerEvent ( "NGGroups->gEvents:onPlayerDeleteGroup", localPlayer, group, a )
		end )
	-- leave
	 elseif ( source == gui.my.leave ) then
	 	askConfirm ( "Are you sure you want to leave "..tostring(group).."?", function ( x )
	 		if ( not x ) then return end
	 		triggerServerEvent ( "NGGroups->Modules->Groups->OnPlayerLeave", localPlayer,  group )
	 	end )


	-- Members window
	elseif ( source == gui.my.members ) then
		loadGroupPage ( "my.members", true )
		gui.main.window.visible = false
	elseif ( source == gui.my.members_.close ) then
		gui.my.members_.window.visible = false
		gui.main.window.visible = true
		if ( gui.my.members_.lWindow.visible ) then
			gui.my.members_.lWindow.visible = false
		end if ( isElement( gui.my.members_.iWindow ) ) then
			destroyElement ( gui.my.members_.iWindow )
		end
	elseif ( source == gui.my.members_.log ) then
		local r, c = guiGridListGetSelectedItem ( gui.my.members_.list )
		if ( r == -1 ) then 
			return exports.ngmessages:sendClientMessage ( "You need to select an account", 255, 0, 0 )
		end
		guiGridListClear ( gui.my.members_.lList )
		gui.my.members_.viewingPlayer = guiGridListGetItemText ( gui.my.members_.list, r, 1 )
		gui.my.members_.lWindow.visible = true;
		gui.my.members_.lWindow.text = "Player Group Log - ".. tostring ( gui.my.members_.viewingPlayer )
		gui.my.members_.lWindow.bringToFront ( gui.my.members_.lWindow )
		local sum = 0
		for i, v in ipairs ( gList [ group ].log ) do
			if ( v.account == gui.my.members_.viewingPlayer ) then
				sum = sum + 1
				local r = guiGridListAddRow ( gui.my.members_.lList )
				guiGridListSetItemText ( gui.my.members_.lList, r, 1, v.time, false, false )
				guiGridListSetItemText ( gui.my.members_.lList, r, 2, v.account, false, false )
				guiGridListSetItemText ( gui.my.members_.lList, r, 3, v.log, false, false )
			end 
		end 
		if ( sum == 0 ) then
			guiGridListSetItemText ( gui.my.members_.lList, guiGridListAddRow ( gui.my.members_.lList ), 1, "This player has no logs", true, true )
		end 
	elseif ( source == gui.my.members_.lClose ) then
		gui.my.members_.viewingPlayer = nil
		gui.my.members_.lWindow.visible = false
		gui.my.members_.rWindow.visible = false
	elseif ( source == gui.my.members_.kick ) then
		local r, c = guiGridListGetSelectedItem ( gui.my.members_.list )
		if ( r == -1 ) then 
			return exports.ngmessages:sendClientMessage ( "You need to select an account", 255, 0, 0 )
		end
		local a = guiGridListGetItemText ( gui.my.members_.list, r, 1 )
		askConfirm ( "Are you sure you want to kick \"".. a .."\"?", function ( x )
			if ( not x ) then return end

			if ( gList [ group ].members [ a ].rank == "Founder" ) then
				return exports.ngmessages:sendClientMessage ( "You cannot kick the gang founder", 255, 0, 0 )
			elseif( a == getElementData ( localPlayer, "AccountData:Username" ) ) then
				return exports.ngmessages:sendClientMessage ( "You can't kick yourself from the gang", 255, 0, 0 )
			end

			triggerServerEvent ( "NGGroups->Modules->Gangs->kickPlayer", localPlayer, group, a )
		end )
	elseif ( source == gui.my.members_.srank ) then
		local r, c = guiGridListGetSelectedItem ( gui.my.members_.list )
		if ( r == -1 ) then 
			return exports.ngmessages:sendClientMessage ( "You need to select an account", 255, 0, 0 )
		end
		local a = guiGridListGetItemText ( gui.my.members_.list, r, 1 )
		gui.my.members_.viewingPlayer1 = a
		gui.my.members_.rWindow.visible = true
		guiBringToFront ( gui.my.members_.rWindow )
		guiComboBoxClear ( gui.my.members_.rRanks )
		for i, v in pairs ( gList[group].ranks ) do
			local f = guiComboBoxAddItem ( gui.my.members_.rRanks, tostring ( i ) )
			if ( tostring ( i ) == gList[group].members[a].rank ) then
				guiComboBoxSetSelected  ( gui.my.members_.rRanks, f )
			end
		end 
	elseif ( source == gui.my.members_.rUpdate ) then
		local nrank =  guiComboBoxGetItemText (  gui.my.members_.rRanks, guiComboBoxGetSelected ( gui.my.members_.rRanks ) )
		askConfirm ( "Are you sure you want to change "..gui.my.members_.viewingPlayer1.."'s rank to from "..gList[group].members[gui.my.members_.viewingPlayer1].rank.." to "..nrank.."?", function ( x, nrank )
			if ( not x ) then return end

			gui.my.members_.rWindow.visible = false
			if ( gui.my.members_.viewingPlayer1 == getElementData ( localPlayer, "AccountData:Username" ) ) then
				return exports.ngmessages:sendClientMessage ( "You cannot change your own rank.", 255, 0, 0 )
			elseif ( gList[group].members[gui.my.members_.viewingPlayer1].rank == "Founder" ) then
				return exports.ngmessages:sendClientMessage ( "You cannot change the founders rank", 255, 0, 0 )
			elseif ( nrank:lower ( ) == "founder" ) then
				return exports.ngmessages:sendClientMessage ( "You cannot set players rank to 'founder'", 255, 255, 0 )
			end

			triggerServerEvent ( "NGGroups->Modules->Gangs->Ranks->UpdatePlayerrank", localPlayer, group, gui.my.members_.viewingPlayer1, nrank );
			gui.my.members_.viewingPlayer1 = false
		end, nrank )
	elseif ( source == gui.my.members_.rClose ) then
		gui.my.members_.rWindow.visible = false


	-- Invite Window
	elseif ( source == gui.my.members_.invite ) then
		gui.my.members_.iWindow.visible = true
		guiBringToFront ( gui.my.members_.iWindow )
		guiGridListClear ( gui.my.members_.iList )
		gui.my.members_.iFilter.text = "";
		for i,v in ipairs ( getElementsByType ( "player" ) ) do
			guiGridListSetItemText ( gui.my.members_.iList, guiGridListAddRow ( gui.my.members_.iList ), 1, v.name, false, false )
		end 
	elseif ( source == gui.my.members_.iClose ) then
		gui.my.members_.iWindow.visible = false
	elseif ( source == gui.my.members_.iInvite ) then 
		local r, c = guiGridListGetSelectedItem ( gui.my.members_.iList )
		if ( r == -1 ) then
			return exports.ngmessages:sendClientMessage ( "No player selected", 255, 0, 0 )
		end

		local name = guiGridListGetItemText ( gui.my.members_.iList, r, 1 )
		if ( not getPlayerFromName ( name ) ) then
			return exports.ngmessages:sendClientMessage ( "Sorry, this player is no longer on the server, or has changed their nickname", 255, 0, 0 )
		end

		local plr = getPlayerFromName ( name )
		if ( tostring ( plr.getData ( plr, "Group" ) ):lower ( ) == group:lower ( ) ) then
			return exports.ngmessages:sendClientMessage ( "This player is already in your group", 255, 0, 0 )
		end

		triggerServerEvent ( "NGGroups->Modules->Groups->InvitePlayer", localPlayer, group, plr )
		gui.my.members_.iWindow.visible = false;
	
	-- Ranks
	elseif ( source == gui.my.ranks ) then
		gui.my.ranks_.window.visible = true
		guiBringToFront ( gui.my.ranks_.window )
		guiSetInputMode ( "no_binds_when_editing" )
	elseif ( source == gui.my.ranks_.close) then
		gui.my.ranks_.window.visible = false
	elseif ( source == gui.my.ranks_.add ) then
		local name = gui.my.ranks_.name.text;

		if ( name:gsub ( " ", "" ) == "") then
			return exports.ngmessages:sendClientMessage ( "Invalid rank name.", 255, 255, 0  )
		end

		for i, v in pairs ( gList[group].ranks ) do
			if ( tostring ( i ):lower ( ) == name:lower ( ) ) then
				return exports.ngmessages:sendClientMessage ( "This rank already exists in your group", 255, 255, 0 )
			end 
		end 

		askConfirm ( "Are you sure you want to add '"..name.."' to the group?", function ( x, name )
			if ( not x ) then return end 

			local permTable = { }
			for i, v in pairs ( gui.my.ranks_ ) do
				if ( tostring ( i ):sub ( 0, 5 ) == "perm_" ) then
					permTable [ tostring(i):sub(6,tostring(i):len()) ] = v.selected
				end 
			end 

			triggerServerEvent ( "NGGroups->Modules->Groups->Ranks->AddRank", localPlayer, group, name, permTable )
		end, name )

		-- change group color
	elseif ( source == gui.my.modColor ) then
		exports.cpicker:openPicker ( "changeGroupColorPicker", { 
			r = 0, g = 0, b = 0, a = 0
		}, "Group Color" )
	elseif ( source == gui.my.modMotd ) then
		guiSetInputMode ( "no_binds_when_editing" )
		gui.my.motd.window.visible = true
		gui.my.motd.motd.text = gList[group].info.desc or ""
		guiBringToFront( gui.my.motd.window )
		guiSetInputMode(  "no_binds_when_editing" )
	elseif ( source == gui.my.motd.cancel ) then
		gui.my.motd.window.visible = false
	elseif( source == gui.my.motd.update ) then
		askConfirm ( "Are you sure you want to change the group MOTD?", function ( x )
			if not x then return end
			local t = gui.my.motd.motd.text;
			triggerServerEvent ( "NGGroups->Modules->Groups->MOTD->Update", localPlayer, group, t )
		end )

	-- motd window
	elseif ( source == gui.info.gMotd ) then
		gui.info.motd.window.visible = true
		local desk = gList[group].info.desc
		if ( not desk or desk:gsub ( " ", "" ) == "" ) then
			desk = "None"
		end
		gui.info.motd.motd.text = tostring ( desk )
		guiBringToFront ( gui.info.motd.window )
	elseif ( source == gui.info.motd.cancel ) then
		gui.info.motd.window.visible = false
	end
end

function onClientGuiChanged ( )
	if ( gui and gui.my and gui.my.members_ and gui.my.members_.iFilter and source == gui.my.members_.iFilter ) then
		local t = source.text:lower();
		guiGridListClear ( gui.my.members_.iList )
		for i, v in ipairs ( getElementsByType ( "player" ) ) do 
			if ( v.name:lower():find ( t ) ) then
				guiGridListSetItemText ( gui.my.members_.iList, guiGridListAddRow ( gui.my.members_.iList ), 1, v.name, false, false )
			end 
		end 
	elseif ( gui and gui.my and gui.my.name_ and gui.my.ranks_.name ) then
		local t = source.text();
		if ( t ~= "" ) then
			local tmp = t
			tmp = tmp:gsub ( "%p", "" );
			source.text = tmp
		end 
	end 
end 

addEvent ( "onColorPickerOK", true )
addEventHandler ( "onColorPickerOK", root, function ( id, _, r, g, b )
	if ( id == "GroupColorPicker" ) then
		guiSetText ( gui.info.create.cr, tostring ( r ) )
		guiSetText ( gui.info.create.cg, tostring ( g ) )
		guiSetText ( gui.info.create.cb, tostring ( b ) )
	elseif ( id == "changeGroupColorPicker" ) then
		askConfirm ( "Are you sure you want to change the group color?", function ( x, r, g, b )
			if ( not x ) then return x end
			triggerServerEvent ( "NGGroups->Modules->Groups->Colors->UpdateColor", localPlayer, group, r, g, b )
		end, r, g, b )
	end 
end )


function onPlayerOpenPanel ( )
	if ( not exports.nglogin:isClientLoggedin ( ) ) then return end
	
	if ( gui and isElement ( gui.main.window ) ) then

		if ( isElement ( gui.my.members_.window ) and guiGetVisible ( gui.my.members_.window ) ) then
			return false
		end

		removeEventHandler ( "onClientGUIClick", root, onClientGuiClick )
		removeEventHandler ( "onClientGUIChanged", root, onClientGuiChanged )

		destroyElement ( gui.main.window ) 
		if ( isElement ( gui.my.info_window ) ) then
			destroyElement ( gui.my.info_window )
		end if ( isElement ( gui.my.basic.window ) ) then
			destroyElement ( gui.my.basic.window )
		end if ( isElement ( gui.my.logs_.window ))  then
			destroyElement ( gui.my.logs_.window )
		end if ( isElement ( gui.info.create.window ) ) then
			destroyElement ( gui.info.create.window )
		end if ( isElement ( gui.my.bank_.window ) ) then
			destroyElement ( gui.my.bank_.window )
		end if ( isElement ( gui.my.members_.window ) ) then
			destroyElement ( gui.my.members_.window )
		end if ( isElement ( gui.my.members_.rWindow ) ) then
			destroyElement ( gui.my.members_.rWindow )
		end if ( isElement ( gui.my.members_.lWindow ) ) then
			destroyElement ( gui.my.members_.lWindow )
		end if ( isElement ( gui.my.members_.iWindow ) ) then
			destroyElement ( gui.my.members_.iWindow )
		end if ( isElement ( gui.info.invites.window ) ) then
			destroyElement ( gui.info.invites.window )
		end if ( isElement ( gui.my.ranks_.window ) ) then
			destroyElement( gui.my.ranks_.window )
		end if ( isElement ( gui.my.motd.window ) ) then
			destroyElement ( gui.my.motd.window )
		end if ( isElement ( gui.info.motd.window ) ) then
			destroyElement ( gui.info.motd.window )
		end if ( isElement ( gui.admin.window ) ) then 
			destroyElement ( gui.admin.window )
		end if ( isElement ( gui.admin.info.window ) ) then 
			destroyElement ( gui.admin.info.window )
		end if ( isElement ( gui.admin.members.window ) ) then 
			destroyElement ( gui.admin.members.window )
		end if ( isElement ( gui.admin.ranks.window ) ) then 
			destroyElement ( gui.admin.ranks.window )
		end if ( isElement ( gui.admin.logs.window ) ) then 
			destroyElement ( gui.admin.logs.window )
		end

		showCursor ( false )
		gui = nil
	else
		group = getElementData ( localPlayer, "Group" ) or nil
		rank = getElementData ( localPlayer, "Group Rank" ) or nil
		if ( tostring ( group ):lower ( ) == "none" ) then
			group = nil
			rank = nil
		end

		createGroupGui ( )
	end
end
bindKey ( "F2", "down", onPlayerOpenPanel )



-- List the group
addEvent ( "NGGroups->onServerSendClientGroupList", true )
addEventHandler ( "NGGroups->onServerSendClientGroupList", root, function ( g ) 
	gList = g
	loadGroupPage ( "core.info" ) 
	
	addEventHandler ( "onClientGUIClick", root, onClientGuiClick )
	addEventHandler ( "onClientGUIChanged", root, onClientGuiChanged )
	
	-- Bugged, not sure why 
	-- Removed NG 1.1.3
	
	--[[ Make sure the users group is valid
	if ( group and not gList [ group ] ) then
		group = nil
		rank = nil
		setElementData ( localPlayer, "Group", "None" )
		setElementData ( localPlayer, "Group Rank", "None")
		onPlayerOpenPanel ( )
		onPlayerOpenPanel ( )
		return false;
	elseif ( group and not gList [ group ].members [ getElementData(localPlayer,"AccountData:Username") ] ) then
		group = nil
		rank = nil
		setElementData ( localPlayer, "Group", "None" )
		setElementData ( localPlayer, "Group Rank", "None")
		onPlayerOpenPanel ( )
		onPlayerOpenPanel ( )
		return false
	end ]]


end )

function table.len ( t ) 
	local c = 0
	for i, v in pairs ( t ) do 
		c = c + 1
	end
	return c
end

addEvent ( "NGGroups->pEvents:onPlayerRefreshPanel", true )
addEventHandler ( "NGGroups->pEvents:onPlayerRefreshPanel", root, function ( )
	if ( gui and isElement ( gui.main.window ) ) then
		gui.my.members_.window.visible  = false

		onPlayerOpenPanel ( )
		onPlayerOpenPanel ( )
	end
end )

addEvent ( "NGGroups:Module->Bank:onServerSendClientBankLevel", true )
addEventHandler ( "NGGroups:Module->Bank:onServerSendClientBankLevel", root, function ( m )
	guiSetText ( gui.my.bank_.balance, "Group Balance: $"..tostring ( m ) )
	guiSetEnabled ( gui.my.bank_.amount, true )
	guiSetEnabled ( gui.my.bank_.go, true )
	guiSetEnabled ( gui.my.bank_.with, gList[group].ranks[rank].bank_withdraw )
	guiSetEnabled ( gui.my.bank_.dep, gList[group].ranks[rank].bank_deposit )
end )