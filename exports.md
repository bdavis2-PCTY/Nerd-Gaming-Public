Below is a list of exports and what they do for Nerd Gaming V1.1.3
<br /><br />

<strong>NGAdministration</strong>
<ul>
    <li><strong>Client</strong>
        <ul>
            <li>nil openBanWindow( string account ): <em>Opens the user ban window to the desired account</em></li>
        </ul>
    </li>
    
    <li>
        <strong>Server</strong>
        <ul>
            <li>table getAllStaff ( ): <em>Returns a table of all the online staff, the table index is their rank (Eg. Level 1, Level 2, etc...)</em></li>
            <li>boolean isPlayerStaff ( player thePlayer ): <em>Check to see if the player is in any of the staff ACLs</em></li>
            <li>boolean isPlayerInACL ( player thePlayer, string aclGroup ): <em>Check if the player is in the ACL group</em></li>
            <li>table getOnlineStaff ( ): <em>Returns a table containing all the oline staff, no matter what level</em></li>
            <li>var getPlayerStaffLevel ( player thePlayer [, type=nil ] ): <em>Returns the player staff level. If type is string, it returns Level x (eg. Level 1) - If set to int, it returns their level as an integer (Eg. 1, 2, etc..) - If not set, it returns String Level, Int Levl</em></li>
            <li>nil removeAccount( string account [, player source] ): <em>*http* Removes a player account from the server and MySQL databsae</em></li>
      </ul>
    </li>
</ul>


<br /><br />
<strong>NGAmmunation</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
      </ul>
    </li>
</ul>


<br /><br />
<strong>NGAntiRestart</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    
    <li>
        <strong>Server</strong>
        <ul>
            <li>vehicle createPlayerVehicle ( player thePlayer, int vehicleID, marker sourceMarker [, boolean doWarp=false] ) <em>: Creates a player vehicle that will be destroyed when this function is called for the player again, or the player disconnects - Used by the Vehicle spawners</em></li>
      </ul>
    </li>
</ul>


<br /><br />
<strong>NGBank</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    
    <li>
        <strong>Server</strong>
        <ul>
            <li>boolean doesBankAccountExist ( string accountName ): <em>Returns if the account name is registered in the accounts table</em></li>
			<li>boolean createBankAccount ( string accountName ): <em>Adds the account to the accounts table and bank_accounts SQL table</em></li>
			<li>nil saveBankAccounts ( ): <em>Saves all the bank accounts to the NG database</em></li>
			<li>table getBankAccounts ( ): <em>Returns all the accounts with their balances</em></li>
			<li>boolean withdraw ( player thePlayer, int amount ): <em>Takes money from player bank account (THIS WILL STILL WORK WITH INSIGNIFICANT FUNDS)</em></li>
			<li>boolean deposit ( player thePlayer, int amount ): <em>Adds money to the players bank account (THIS WILL STILL WORK WITH INSIGNIFICANT FUNDS)</em></li>
			<li>int getPlayerBank ( player thePlayer ): <em>Returns the players bank account balance</em></li>
			<li>int getAccountBalance ( string theAccount ): <em>Returns the account balance</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGBans</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    
    <li>
        <strong>Server</strong>
        <ul>
            <li>nil banAccount ( string accountName [, int unbanDay=1, int unbanMonth=1, int unbanYear=9999, string reason="Not defined", string banner="Server" ] ): <em>Bans a user account, serial, and IP address</em></li>
			<li>int saveBans ( ): <em>Saves the bans to the database, returns the number of server bans</em></li>
			<li>boolean unbanAccount ( string account ): <em>Removes a ban from the server database, returns if the unban was successful</em></li>
			<li>boolean isSerialBanned ( string serial ): <em>Returns if the serial is banned</em></li>
			<li>nil loadBanScreenForPlayer ( player thePlayer ): <em>Loads the banned message for a banned player</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGChat</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    
    <li>
        <strong>Server</strong>
        <ul>
            <li>nil outputLawMessage ( string message [, int r=255, int g=255, int b=255, boolean useHex=false] ): <em>Outputs a message to all law enforcement players</em></li>
			<li>string getChatLine ( player thePlayer, string message): <em>Returns how the chat line should be to output for a player with a message</em></li>
			<li>string getPlayerTags ( player thePlayer ): <em>returns a string of tags to display before the player name</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGDrugs</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li>nil/boolean useDrug ( string drug, int amount ): <em>Enable drug effects for localplayer</em></li>
        </ul>
    </li>
    
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGEvents</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    
    <li>
        <strong>Server</strong>
        <ul>
            <li>boolean isPlayerInEvent ( player thePlayer ): <em>Returns if the player is in the current event</em></li>
            <li>table getEventInfo ( ): <em>Returns a table containing all event information</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGFPS</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGGamemode</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGGroups</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    
    <li>
        <strong>Server</strong>
        <ul>
            <li>boolean doesGroupExist ( string group ): <em>Returns if the group already exists on the server</em></li>
            <li>boolean isRankInGroup ( string group, string rankName ): <em>Returns if the rank is in the group</em></li>
			<li>nil saveGroups ( ): <em>Saves all groups to the server database</em></li>
			<li>table getGroups ( ): <em>Returns a table with all groups and all their information</em></li>
			<li>int, int, int getGroupColor ( string group ): <em>Returns the group color in an RGB format</em></li>
			<li>boolean createGroup ( string name, table color, string type, string owner ): <em>Creates a group on the server, if all the information is valid</em></li>
			<li>boolean deleteGroup ( string group ): <em>Deletes a group the server and the server SQL</em></li>
			<li>boolean setAccountRank ( string group, string account, string newrank ): <em>Sets the rank for an account within a group</em></li>
			<li>boolean setPlayerGroup ( player thePlayer, string group ): <em>Sets the group of a player</em></li>
			<li>int getGroupBank ( string group ): <em>Returns the bank balance of a group</em></li>
			<li>boolean setGroupBank ( string group, int amount ): <em>Sets the bank balance of a group</em></li>
			<li>boolean groupClearLog ( string group ): <em>Clears the logs of a group</em></li>
			<li>nil outputGroupLog ( string group, string log [, player responsiblePlayer ] ): <em>Logs an action to a group</em></li>
			<li>table getGroupLog ( string group ): <em>Returns a table containing all the logs of a group</em></li>
			<li>boolean isRankInGroup ( string group, string rank ): <em>Returns if a group contains a rank</em></li>
			<li>nil/string getPlayerGroup ( player thePlayer ): <em>Returns the group name of a player</em></li>
			<li>nil outputGroupMessage ( string message, string group [, boolean blockTag ] ): <em>Outputs a message to all online members of a group</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGGym</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGHealthPacks</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li>boolean useHealthPack ( ): <em>Uses a player health pack, if their health is less than 90%</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>boolean useHealthPack ( player thePlayer ): <em>Uses a player health pack, if their health is less than 90%</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGHospitals</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li>boolean isClientDead ( ): <em>Returns if the player is dead</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGInformation</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGInventory</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGJobs</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li>boolean create3DText ( string text, table position, table color [, element parent=nil, table settings={} ] ): <em>Creates a 3D text element that will be rendered in the GTA world</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>boolean addPlayerToJobDatabase ( player thePlayer ): <em>Adds a player account to th SQL jobdata table</em></li>
			<li>boolean updateJobColumn ( string account, string column, string updateTo ): <em>Updates a players job data column information. If updateTo is "AddOne", it will add 1 to the existing value</em></li>
			<li>nil setPlayerJob ( player thePlayer, string theJob ): <em>Sets the players job</em></li>
			<li>boolean create3DText ( string text, table position, table color [, element parent=nil, table settings={} ] ): <em>Creates a 3D text element that will be rendered in the GTA world</em></li>
			<li>nil updateRank ( player thePlayer, string theJob ): <em>Useless function</em></li>
			<li>table getJobRankTable ( ): <em>Returns a table containing all the jobs, their ranks, and requirements</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGLogin</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li>boolean isClientLoggedin ( ): <em>Returns if the client is logged into the server</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGLogin</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li>boolean isClientLoggedin ( ): <em>Returns if the client is logged into the server</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGLogs</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>nil outputPunishLog ( player thePlayer, var responsibleElement, string log ): <em>Outputs to the NG punishment log, responsibleElement can be either a string or player element</em></li>
			<li>nil outputActionLog ( string log ): <em>Outputs a message to the server action log</em></li>
			<li>nil outputChatLog ( string chat, string log ): <em>Outputs a message to the specified chat (action, punish, chat, server, sql)</em></li>
			<li>nil outputServerLog ( string log ): <em>Outputs a message to the server log</em></li>
			<li>nil outputSQLLog ( string log ): <em>Outputs a message to the SQL log</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGLottery</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>timer getLotteryTimer ( ): <em>Returns the lottery timer element</em></li>
            <li>nil generateNextLottery ( ): <em>Generates the next winning number, prize, and resets the lottery timer</em></li>
            <li>int getLotteryWinningNumber ( ): <em>Returns the winning lottery number</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGMessages</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li>boolean sendClientMessage ( string message [, int r=255, int g=255, b=255 ] ): <em>Sends a notification to the player through the top message bar</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>boolean sendClientMessage ( string message, player/root thePlayer [, int r=255, int g=255, b=255 ] ): <em>Sends a notification to the player through the top message bar</em></li>
        </ul>
    </li>
</ul>


<br /><br />
<strong>NGMessages</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li>boolean sendClientMessage ( string message [, int r=255, int g=255, b=255 ] ): <em>Sends a notification to the player through the top message bar</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>boolean sendClientMessage ( string message, player/root thePlayer [, int r=255, int g=255, b=255 ] ): <em>Sends a notification to the player through the top message bar</em></li>
        </ul>
    </li>
</ul>


<br /><br />
<strong>NGPeak</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGPhone</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
            <li>string getSetting ( string setting ): <em>Returns the user setting value for the specified setting</em></li>
            <li>boolean updateSetting ( string setting, string value ): <em>Updates a specified user setting</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGPlayerFunctions</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
			<li>string getToday ( ): <em>Returns a string of the current date in YYYY-MM-DD (Ex. 2015-05-10)</em></li>
            <li>boolean isClientCursorShowing ( ): <em>Returns if the clients cursor is visible</em></li>
			<li>boolean outputDxLog ( string message ): <em>Outputs to the side DX message bar (Will only be visible if the users setting is enabled)</em></li>
			<li>boolean createWaypointLoc ( float x, float y, float z ): <em>Locates a specific location on the users minimap</em></li>
			<li>boolean waypointUnlocate ( ): <em>Unlocates a location, if the users has one located</em></li>
			<li>boolean waypointIsTracking ( ): <em>Returns if the client is currently tracking something</em></li>
			<li>boolean setWaypointAttachedToElement ( element trackingElement ): <em>Attaches the waypoint blip to the tracking element</em></li>
		</ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>int getPlayerPlaytime ( player thePlayer ): <em>Returns the player play-time in milliseconds</em></li>
            <li>boolean setPlayerPlaytime ( player thePlayer, int time ): <em>Sets a users play-time, with time being milliseconds</em></li>
            <li>boolean deletePlayerPlaytime ( player thePlayer ): <em>Removes a players play-time from the server</em></li>
            <li>boolean setTeam ( player thePlayer, string teamName ): <em>Sets the players team</em></li>
			<li>boolean isLawTeam ( string team ): <em>Returns if the team is a law-enforcement team</em></li>
			<li>player/boolean getPlayerFromNamePart ( string partName ): <em>Returns a player based on a part of their name - if more than 2 players have the part it will return false</em></li>
			<li>player/boolean getPlayerFromAccount ( string accountName ): <em>Returns the player with the account name, or false</em></li>
			<li>string getRunningMathEquation ( ): <em>Returns a string of the current math equation </em></li>
			<li>string getToday ( ): <em>Returns a string of the current date in YYYY-MM-DD (Ex. 2015-05-10)</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGPolice</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
			<li>boolean outputDispatchMessage ( string message ): <em>Send a dispatch message to the client</em></li>
			<li>boolean isPlayerJailed ( ): <em>Returns if the client is in jail</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>boolean jailPlayer ( player thePlayer, int duration [, boolean announce=false, element responsibleElement=nil, string reason="Classified" ] ): <em>Puts a player in jail</em></li>
			<li>boolean unjailPlayer ( player thePlayer [, boolean triggerClient=false ] ): <em>Releases a player from jail</em></li>
			<li>boolean isPlayerJailed ( player thePlayer ): <em>Returns if a player is currently in jail</em></li>
			<li>table getJailedPlayers ( ): <em>Returns a table containing all jailed players</em></li>
			<li>boolean outputDispatchMessage ( string message ): <em>Send a dispatch message to all law-enforcement players</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGPunishPanel</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
			<li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>boolean outputPlayerPunishLog ( player thePlayer [, string admin="Server", string log="nil" ] ): <em>Adds a log to the players punishment panel</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGShops</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
			<li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGSpawners</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
			<li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGSQL</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
			<li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>table db_query ( string query, ... ): <em>Returns a table with the results of the query</em></li>
            <li>boolean db_exec ( string query, ... ): <em>Returns a boolean if the exec was successful</em></li>
            <li>boolean createAccount ( string accountName ): <em>Adds an account to the servers SQL database</em></li>
            <li>boolean/table account_exist ( string accountName ): <em>Returns false if the account doesn't exist, or returns a table with all the account information if it does</em></li>
            <li>boolean saveAllData ( [ boolean useTime=true ] ): <em>Manually saves all the server data</em></li>
            <li>boolean savePlayerData ( player thePlayer [, boolean logMsg=true, boolean deletePlaytime=false] ): <em>Saves all the account information for a specific account</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGTurf</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
			<li><em>None</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>table turfLocs( ): <em>Returns a table with all the turf locations</em></li>
            <li>boolean setTurfOwner ( int turfId, string owner ): <em>Sets a specific turf owner</em></li>
			<li>boolean saveTurfs ( ): <em>Saves all the turfs and their information</em></li>
			<li>boolean updateTurfGroupColor ( group ): <em>Updates the color of turfs when a group changes their color</em></li>
        </ul>
    </li>
</ul>


<br /><br />
<strong>NGVehicles</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
			<li>int getVehicleSpeed ( vehicle theVehicle [, string speedType="kph" ] ): <em>Returns the vehicle speed</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>boolean showVehicle ( int vehicleId, boolean state [, player thePlayer, string message ] ): <em>Shows or hides a vehicle owned by a player</em></li>
			<li>table getAccountVehicles ( string account ): <em>Returns a table of all the account vehicles</em></li>
			<li>table getAllAccountVehicles ( string account ): <em>Same as getAccountVehicles</em></li>
			<li>boolean warpVehicleToPlayer ( int vehicleId, player thePlayer ): <em>Warps an owned vehicle to a player</em></li>
			<li>boolean recoverVehicle ( player source, int vehicleId ): <em>Used by the NG phone, used to recover a vehicle</em></li>
			<li>boolean sellVehicle ( player source, int vehicleId ): <em>Used by the NG phone, used to sell a vehicle</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGVIP</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
			<li>boolean isPlayerVIP ( ): <em>Returns if the player is a VIP member</em></li>
			<li>int getVipLevelFromName ( string level ): <em>Returns an integer representing the VIP level</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li>boolean checkPlayerVipTime ( player thePlayer ): <em>Checks the players VIP time to see if it is expired</em></li>
			<li>boolean isDatePassed ( string date ): <em>Checks to see if a date has passed (Input format: YYYY-MM-DD)</em></li>
			<li>int getVipPayoutTimerDetails ( ): <em>Returns the next VIP payout time in milliseconds</em></li>
			<li>int getVipLevelFromName ( string level ): <em>Returns an integer representing the VIP level</em></li>
			<li>boolean isPlayerVIP ( player thePlayer ): <em>Returns if the player is a VIP member</em></li>
		</ul>
    </li>
</ul>


<br /><br />
<strong>NGWarpManager</strong>
<ul>
    <li>
        <strong>Client</strong>
        <ul>
			<li>boolean makeWarp ( table inputData ): <em>Creates a warping point</em></li>
        </ul>
    </li>
    <li>
        <strong>Server</strong>
        <ul>
            <li><em>None</em></li>
		</ul>
    </li>
</ul>