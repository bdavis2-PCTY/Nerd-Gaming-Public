local files = {
	"files/lsd_1.jpg",
	"files/lsd_2.jpg",
	"files/lsd_3.jpg",
	"files/lsd_icon.png",
	"files/lsd_monster.dff",
	"files/lsd_monster.txd",
	"files/lsd_music.mp3",

	"files/weed_icon.png",
	"files/weed_music.mp3"
}

addEventHandler ( "onClientResourceStart", resourceRoot, function ( )
	for i, v in pairs ( files ) do
		downloadFile ( v )
	end 
end )