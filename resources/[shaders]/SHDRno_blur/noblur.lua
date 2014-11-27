--////////////////////////////[[The following is On Join]]\\\\\\\\\\\\\\\\\\\\\\\\\\\--

function changeBlurLevel()
    setPlayerBlurLevel ( source, 0 )
end

addEventHandler ( "onPlayerJoin", getRootElement(), changeBlurLevel )

--//////////////[[The following is On Resource Start (This Resource)]]\\\\\\\\\\\\\\\--
 
function scriptStart()
    setPlayerBlurLevel ( getRootElement(), 0)
end

addEventHandler ("onResourceStart",getResourceRootElement(getThisResource()),scriptStart)

--//////////////[[The following is On Resource Start (EVERY resource)]]\\\\\\\\\\\\\\--
--//////////////[[The following is the 1.0 Upate.]]\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--

function scriptRestart()
	setTimer ( scriptStart, 4000, 1 )
end

addEventHandler("onResourceStart",getRootElement(),scriptRestart)

---------------------------------------------------------------------------------------