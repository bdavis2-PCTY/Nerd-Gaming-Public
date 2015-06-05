
addEvent( "onVehicleMod" )

modShops = {  }

local modshopPositions = {
	{ 1928.92, -2294.31, 13.55 },
	{ 1041.46, -1016.23, 32.11 },
	{ 2645.03, -2044.31, 13.64 },
	{ -1297.07, -240.16, 14.14 },
	{ -2723.11, 217.24, 4.48 },
	{ -1787.24, 1215.26, 25.13 },
	{ -1936.64, 246.25, 34.46 },
	{ 1329.75, 1487.58, 10.82 },
	{ 2386.67, 1052.13, 10.82 },
	{ 356.63, 2540.61, 16.71 },
}

for i, v in ipairs ( modshopPositions ) do
	modShops [ i ] = { }
	modShops [ i ].veh = false
	local x, y, z = unpack ( v )
	modShops [ i ].marker = createMarker ( x, y, z-1, "cylinder", 4, 255, 255, 0, 100 )
	--modShops [ i ].blip = createBlip ( x, y, z, 27, 2, 255, 255, 255, 255, 0, 450 )
	modShops [ i ].name = "Modshop " .. tostring ( i ) 
end

addEventHandler ( "onPlayerLogin", root, function ( )
	triggerClientEvent ( source, "NGModshop:sendClientShopLocations", source, modshopPositions );
end );

addEventHandler ( "onResourceStart", resourceRoot, function ( )
	setTimer ( function ( )
		for i, source in pairs ( getElementsByType ( "player" ) ) do 
			triggerClientEvent ( source, "NGModshop:sendClientShopLocations", source, modshopPositions );
		end 
	end, 3000, 1 );
end );


local TIME_IN_MODSHOP = 3 -- 3 minutes

local moddedVehicles = { }
local timers = { }
local timersClient = { }


addEventHandler( "onPlayerQuit", getRootElement( ),
    function( )
        local veh = getPedOccupiedVehicle( source )
        if veh then
            local driver = getVehicleController( veh )
            if driver == source then
                if getVehicleModShop( veh ) then
                    unfreezeVehicleInModShop( veh )
                end
            end
        end
    end
)


addEventHandler( "onResourceStop", getResourceRootElement( getThisResource( ) ),
    function( )
        for k,veh in pairs( getElementsByType( "vehicle" ) ) do
            if moddedVehicles[ k ] then
                for i, modid in pairs( getVehicleUpgrades( veh ) ) do
                    removeVehicleUpgrade( veh, modid )
                    setVehiclePaintjob( veh, 3 )
                end
            end
            if isVehicleInModShop( veh ) then unfreezeVehicleInModShop( veh ) end
        end
    end, false
)



addEventHandler( "onMarkerHit", getResourceRootElement( getThisResource( ) ),
    function( player, dimension )
        if dimension and getElementType( player ) == "player" then
            local vehicle = getPedOccupiedVehicle( player )
            if vehicle then
                local driver = getVehicleController( vehicle )
                if driver == player and not getVehicleInModShop( source ) then
                    for k,v in ipairs( modShops ) do
                        if modShops[ k ].marker == source and getElementType( vehicle ) == "vehicle" then
                            timers[ vehicle ] = setTimer( unfreezeVehicleInModShop, 60000 * TIME_IN_MODSHOP, 1, vehicle )
                            timersClient[ vehicle ] = setTimer( triggerClientEvent, 60000 * TIME_IN_MODSHOP - 200, 1, driver, "modShop_clientResetVehicleUpgrades", driver )
                            setModShopBusy( source, vehicle )
                            freezVehicleInModShop( vehicle, modShops[ k ].marker )
                            triggerClientEvent( driver, "onClientPlayerEnterModShop", player, vehicle, getPlayerMoney( player ), modShops[ k ].name )
                        end
                    end
                end
            end
        end
    end
)

addEvent( "modShop_playerLeaveModShop", true )
addEventHandler( "modShop_playerLeaveModShop", getRootElement( ),
    function( vehicle, itemsCost, upgrades, colors, paintjob, shopName )
        local pMoney = getPlayerMoney( source )
        if pMoney >= itemsCost then
            modTheVehicle( vehicle, upgrades, colors, paintjob, shopName )
            takePlayerMoney( source, itemsCost )
            triggerClientEvent( source, "modShop_moddingConfirmed", source )
        else
            outputChatBox( "#FF0000Inufficient founds! #00FF00Your pocket shows $"..tostring( getPlayerMoney( source ) )..".#FFFFFF Uninstall some upgrades.", source, 0,0,0,true)
        end
    end
)

function modTheVehicle( vehicle, upgrades, colors, paintjob, shopName )
    if isElement( vehicle ) and getElementType( vehicle ) == 'vehicle' and type( upgrades ) == 'table' or getVehiclePaintjob( vehicle ) ~= paintjob then
        local trigger = false
        
		--outputDebugString( "Colors recieved from client: ".. colors[ 1 ] ..", "..tostring( colors[ 2 ] ) )
        local oldColor = { getVehicleColor( vehicle ) }
        local newColor = { 0, 0, 0, 0 }
        local fixVeh = false
        for i = 1, 2 do
            if oldColor[ i ] == colors[ i ] then
                newColor[ i ] = oldColor[ i ]
                colors[ i ] = false
            else 
                newColor[ i ] = colors[ i ]
                trigger = true
                fixVeh = true
            end
        end
        
        if paintjob == 255 or paintjob == getVehiclePaintjob( vehicle ) then 
            paintjob = false 
        else
            setVehiclePaintjob( vehicle, paintjob )
            trigger = true
        end
        
        local vehUpg = { getVehicleUpgrades( vehicle ) }
        local upgs = { }
        for k,v in pairs( upgrades ) do
            for i,j in pairs( vehUpg ) do
                if v ~= j then
                    addVehicleUpgrade( vehicle, v )
                    table.insert( upgs, v )
                    trigger = true
                end
            end
        end
        
        if fixVeh then
            fixVehicle( vehicle )
            setVehicleColor( vehicle, unpack( newColor ) )
			--outputDebugString( "color set: ".. tostring( newColor[ 1 ] ) .."  "..tostring( newColor[ 2 ] ) )
        end
        for _, veh in ipairs( moddedVehicles ) do
            if veh ~= vehicle then
                table.insert( moddedVehicles, veh )
            end
        end
        unfreezeVehicleInModShop( vehicle )
        if trigger then
            triggerEvent( "onVehicleMod", vehicle, upgs, colors, paintjob, shopname )
        end
		
		local rx, ry, rz = getElementRotation ( vehicle );
		setElementRotation ( vehicle, rx, ry, rz - 180 );
    end
end


function freezVehicleInModShop( vehicle, marker )
    if isElement( vehicle ) and getElementType( vehicle ) == 'vehicle' then
        local mX, mY, mZ = getElementPosition( marker )
        if mX then
            setElementPosition( vehicle, mX, mY, mZ + 1.65 )
            setElementDimension( marker, 1 )
            local _,_, rot = getVehicleRotation( vehicle )
            setVehicleRotation( vehicle, 0, 0, rot )
            setElementFrozen( vehicle, true )
            setVehicleDamageProof( vehicle, true )
            if not isVehicleLocked( vehicle ) then
                setVehicleLocked( vehicle, true )
                setElementData( vehicle, "veh.locked", true )
            end
        end
    end
end


function unfreezeVehicleInModShop( vehicle )
    if isElement( vehicle ) and getElementType( vehicle ) == 'vehicle' then
        local shop = getVehicleModShop( vehicle )
        if shop then
            setElementDimension( shop, 0 )
            setModShopBusy( shop, 0, false )
            setElementFrozen( vehicle, false )
            setVehicleDamageProof( vehicle, false )
            if isVehicleLocked( vehicle ) and getElementData( vehicle, "veh.locked" ) == true then
                setVehicleLocked( vehicle, false )
                setElementData( vehicle, "veh.locked", false )
            end
            --outputDebugString( "called" )
            if timers[ vehicle ] then
                killTimer( timers[ vehicle ] )
                killTimer( timersClient[ vehicle ] )
            end
        end
    end
end

addEvent( "modShop_unfreezVehicle", true )
addEventHandler( "modShop_unfreezVehicle", getRootElement( ),
    function( )
        unfreezeVehicleInModShop( source )
    end
)

addEventHandler( "onVehicleRespawn", getRootElement(),
    function( )
        if moddedVehicles[ source ] then
            local upgrades = getVehicleUpgrades( source )
            for k,v in pairs( upgrades ) do
                removeVehicleUpgrade( source, v )
            end
            setVehiclePaintjob( source, 3 )
            moddedVehicles[ source ] = nil
        end
    end
)

addEventHandler( "onVehicleMod", getRootElement( ), function( upgrades, colors, paintjob, shopName )
--[[
    -- this is just to see how onVehicleMod event works
        outputChatBox( "You just modded a vehicle", getVehicleController( source ) )
        for k, v in ipairs( upgrades ) do
            outputChatBox( getVehicleUpgradeSlotName( v ) .." - " .. tostring( v ) )
        end
        local str = "New colors:"
        if type( colors ) == "table" then
            for i=1,#colors do
                str = str.."  "..tostring( colors[ i ] )
            end
            outputChatBox( str )
        end
        outputChatBox( "Paintjob: "..tostring( paintjob ), getVehicleController( source ) )
]]
    end
)

addEventHandler( "onResourceStart", getResourceRootElement( getThisResource() ),
	function( )
		setGarageOpen( 15, true );
	end
)

