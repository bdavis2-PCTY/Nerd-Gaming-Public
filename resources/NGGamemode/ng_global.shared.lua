local isClient = ( _G['triggerServerEvent'] ~= nil )

NG = { }
NG.SERVER = { }
NG.MIX = { }
NG.CLIENT = { }

if ( isClient ) then
	
elseif ( not isClient ) then  
	NG.SERVER.VERSION = getResourceInfo ( getThisResource(), "version" );
	NG.SERVER.VERSION_HASH = md5 ( NG.SERVER.VERSION )
	
	NG.SERVER.NOTIFY = function ( msg ) print ( msg ) outputDebugString ( msg ) end
end 
 
NG.MIX.TOBOOL = function(v)local v=tostring(v):lower() if(v=="false"or v=="nil")then return false else return true end end