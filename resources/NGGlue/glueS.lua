	
function gluePlayer(slot, vehicle, x, y, z, rotX, rotY, rotZ)
	attachElements(source, vehicle, x, y, z, rotX, rotY, rotZ)
end
addEvent("gluePlayer",true)
addEventHandler("gluePlayer",getRootElement(),gluePlayer)

function ungluePlayer()
	detachElements(source)
end
addEvent("ungluePlayer",true)
addEventHandler("ungluePlayer",getRootElement(),ungluePlayer)