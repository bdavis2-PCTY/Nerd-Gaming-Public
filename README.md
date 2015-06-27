<img src='http://i60.tinypic.com/2jw7cn.png' /><br />
<i>An MTA RPG base gamemode</i>
<br/>
<br />
<h3>NG:Installation (<a href='https://www.youtube.com/watch?v=_959whBQcdI' target=_blank>YouTube</a> | <a href='https://vimeo.com/131475853' target=_blank>Vimeo</a>)</h3>
	- Download the Nerd-Gaming-Public repository from GitHub (Download ZIP towards mid-right of the page)
	- Navigate to your  MTA server folder {mta_installation_directory}/mods/deathmatch
	- Extract the downloaded files into this folder (acl.xml, mtaserver.conf, resources folder)
	- Override any existing files
	- If exists, delete internal.db, registry.db, settings.xml 
	- Navigate to the NGSQL resource: {mta_installation_directory}/mods/deathmatch/resources/NGSQL
	- Open meta.xml with any text editor (<a href='http://notepad-plus-plus.org/'>Notepad++</a> prefered)
	- If you have an SQL server, modify the DATABASE_NAME, MYSQL_HOST, MYSQL_PORT, MYSQL_USER, and MYSQL_PASS setting values to your connection information
	- If you don't have an SQL server, change the CONNECTION_TYPE setting value to "sqlite"
<br/><br />
<h3>NG:Access Control List (ACL)</h3>
<strong>Default:</strong> Ever player and resource is in this ACL by default - no special permissions<br />
<strong>Level 1:</strong> New staff, extremely limited special permissions<br />
<strong>Level 2:</strong> Junior staff, still extremely limited speical permissions, but more than Level 1.<br />
<strong>Level 3:</strong> Full staff, limited special permissions, but mostly given<br />
<strong>Level 4:</strong> Administrator, very few restricted permissions<br />
<strong>Level 5:</strong> Owner, no restrictions <br />
<i>For anymore information on the ACLs, please see <a href='https://github.com/braydondavis/Nerd-Gaming-Public/edit/master/acl.xml'>acl.xml</a></i>
<br /><br />
<h3>NG:Commands</h3>
<h5>Global Commands</h5>
/report: Report an issue, bug, or player <br />
/updates: View a list of server updates <br />
/getpos [=yes/no]: Get your position, copies to clipboard<br />
/LocalChat [msg]: Outputs a message to nearby players<br />
/r [msg]: Outputs a message to law-enforcement chat<br />
/joinevent: Join a pending event<br />
/leaveevent: Leave an event that you are in<br />
/eventhelp: Display event commands with information<br />
/glue: Glue yourself to a vehicle<br />
/unglue: Unglue yourself from a vehicle<br />
/gc: Display a message to your group members<br />
/resign: Quit your job<br />
/net: View your net as a fisherman<br />
/release [player]: Release a player that you have arrested<br />
/peak: View the server peak<br />
/re [msg], /reply [msg]: Reply to the last person that messaged you via the phone<br />
/kill: Kill yourself<br />
/eject [player]: Eject a player from your vehicle<br />
/result [answer]: Answer a pending math question<br />
/playtime: Display your play time in minutes<br />
/punishments: View a panel with your punishmetns by account or serial<br />
/lock: Lock your vehicle that is nearest to you<br />
/cc [msg]: Send a message to people in a vehicle with your<br />
/hideall: Hide all your visible vehicles<br />
/reload: Reload your weapon<br />
/ngdownload: Copy NG GitHub link to clipboard<br />
/ngver: View NG server version<br />
<br />
<h5>VIP Players</h5>
/laser: Enable/disable weapon laser<br />
/lasercolor: Open an interface to modify laser color<br />
/vipchat [msg]: Chat with other VIP members<br />
<br />
<h5>Staff Commands</h5>
Level 1-5 - /jail [player] [seconds] [reason]: Jail a player<br />
Level 1-5 - /unjail [player]: Unjail a jailed player<br />
Level 1-5 - /math: Create a math question<br />
Level 1-5 - /reports: View a list of reports, from the /report command<br />
Level 1-5 - /staff: Go staff mod<br />
Level 2-5 - /makeevent [event]: Create an event<br />
Level 2-5 - /stopevent: End a current event<br />
Level 3-5 - /spawners: Open interface to create spawners<br />
Level 4-5 - /addupdate: Add a server update to the /updates list <br />
Level 4-5 - /am: Account manager<br />
level 4-5 - /ngupdate: Check for NG Gamemode update<br />
<br />
<h5>Development Commands</h5>
<em>For these commands, NG.IS_IN_DEVELOPMENT in resources/NGGamemode/ng_development.shared.lua must be set to true and your username must be defined as a key in the NG.DEVELOPOERS table in resources/NGGamemode/ng_development.shared.lua)</em><br/>
<br />
/devsetpos: Save your current position, interior and dimension <br/>
/devgopos: Goto your last saved position, interior and dimension <br />
<br/>
<h3>Bugs</h3>
<em>Currently none known</em>
<br /><br />
If you find any bugs, please report them to me.<br />
Add me on Skype: Madex-MTA<br />
Message me on the MTA Forum: <a href='http://forum.mtasa.com/memberlist.php?mode=viewprofile&u=65297'>xXMADEXx</a>
<br />
<br />
<i>(All bugs will be fixed in future versions of NG)</i>
