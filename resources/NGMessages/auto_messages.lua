local messages = { 
	"Enjoy your stay here at Nerd Gaming RPG!",
	"If you find a bug, please use our in-game report system, /report.",
	"If you're bugged, please try reconnecting before asking staff",
	"If you get DM'ed, our staff won't do anything (unless they see it) -- report it on forum",
	"Have a suggestion? Tell us about it on the forum! We'll be glad to hear it.",
	"Use F3 -> Settings to customize your gameplay",
	"Want to help us and get rich? Donate!",
	"Use F3 -> Music to listen to epic tunes while you crash into walls",
	"Please be sure to read F1 before taking any gameplay",
	"Don't ask for money, it's very annoying!!",
	"If your gameplay has lag, try changing your settings to performance mode in F3 -> Settings",
	"Use the bank to save your cash",
	"Don't even think of hacking! We can check all your stats (: "
}

local lastI = 0
function sendNextAutomatedMessage (  )
	lastI = lastI + 1
	if ( lastI > #messages ) then
		lastI = 1
	end
	
	sendClientMessage ( messages [ lastI ], root, math.random ( 150, 255 ), math.random ( 150, 255 ), math.random ( 150, 255 ) )
	setTimer ( sendNextAutomatedMessage, 500000, 1 )
end
setTimer ( sendNextAutomatedMessage, 200, 1 )