defaultMusic = {
    { "Hip Hop Radio", "http://mp3uplink.duplexfx.com:8054/listen.pls" },
    { "A horse with no name", "http://netanimations.net/A-Horse-With-No-Name.mp3" },
    { "I'm from Holland", "http://users.telenet.be/melissaris/holland.mp3" },
    { "Eminem", "http://1cd.palco.fm/1/c/3/b/beltrao-eminem-the-real-slim-shady.mp3" },
    { "Funk soul brother", "http://brunodilucca.com/transfer/casamento/musicasok/Fatboy%20Slim%20%20%20Funk%20Soul%20Brother.mp3" },
    { "Hey Ya", "http://junkyarddawgs.us/media/Out_Kast_-_Hey_Ya.mp3" },
    { "Gangnam style", "http://a.tumblr.com/tumblr_m8nexkKWB61qlpz0ko1.mp3" },
    { "Hardcore", "http://www.hardcoreradio.nl/hr.asx" },
    { "Swedish House Mafia", "http://www.vincesteven.com/IMG/mp3_Swedish_House_Mafia_-_Greyhound_Original-Mix_.mp3" },
    { "Hitradio 181", "http://www.181.fm/winamp.pls?station=181-power&amp;style=mp3&amp;description=Power%20181%20(Top%2040)&amp;file=181-power.pls" },
    { "100Hitz - Top 40", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1475160" },
    { "Dubstep", "http://72.232.40.182:80" },
    { "Drum and Bass", "http://95.168.216.197:8555" },
    { "Drumstep", "http://193.34.51.81:80" },
    { "Techno/Dance", "http://37.58.52.41:80" },
    { "Pop/Dance", "http://95.141.24.41:80" },
    { "Electo", "http://stream.electroradio.ch:26630/" },
    { "Reggae", "http://184.107.197.154:8002" },
    { "Rap", "http://173.245.71.186:80" },
    { "Trance", "http://stream-134.shoutcast.com:80/vocaltrance_difm_mp3_96kbps" },
    { "Pop Rock", "http://listen.rockradio.com/public3/poprock.pls" },
    { "Metal", "http://listen.rockradio.com/public3/metal.pls" },
    { "Heavy Metal", "http://listen.rockradio.com/public3/heavymetal.pls" },
    { "Modern Rock", "http://listen.rockradio.com/public3/modernrock.pls" },
    { "Hard Rock", "http://listen.rockradio.com/public3/hardrock.pls" },
    { "Harder Rock", "http://listen.rockradio.com/public3/harderrock.pls" },
    { "Classic Rock", "http://listen.rockradio.com/public3/classicrock.pls" },
    { "Classic Metal", "http://listen.rockradio.com/public3/classicmetal.pls" },
    { "Grunge", "http://bigrradio.com/asx/grunge.asx" },
    { "90's Rock", "http://listen.rockradio.com/public3/90srock.pls" },
    { "80's Rock", "http://listen.rockradio.com/public3/80srock.pls" },
    { "Beatles Tribute", "http://listen.rockradio.com/public3/beatlestribute.pls" }
}

function createUserMusicFile ( doReturn )
	if ( not fileExists ( "@xml/usermusic.xml" ) ) then
		local file = xmlCreateFile ( "@xml/usermusic.xml", "list" )
		for i, v in ipairs ( defaultMusic ) do 
			local child = xmlCreateChild ( file, "radio" )
			xmlNodeSetAttribute ( child, "name", v[1] )
			xmlNodeSetAttribute ( child, "url", v[2] )
		end
		xmlSaveFile ( file )
		if doReturn then
			return file
		else
			xmlUnloadFile ( file )
		end
	end
end

function getRadioStations ( )
	local data = { }
	local file = xmlLoadFile ( "@xml/usermusic.xml" ) or createUserMusicFile ( true )
	for i, v in ipairs ( xmlNodeGetChildren ( file ) ) do 
		table.insert ( data, { tostring ( xmlNodeGetAttribute ( v, "name" ) ), tostring ( xmlNodeGetAttribute ( v, "url" ) ) } )
	end
	xmlUnloadFile ( file )
	return data
end

function removeRadioStation ( name, url )
	local file = xmlLoadFile ( "@xml/usermusic.xml" ) or createUserMusicFile ( true )
	for i, v in ipairs ( xmlNodeGetChildren ( file ) ) do 
		if ( xmlNodeGetAttribute ( v, "name" ) == name and xmlNodeGetAttribute ( v, "url" ) == url ) then
			xmlDestroyNode ( v )
			xmlSaveFile ( file )
			xmlUnloadFile ( file )
			return true
		end
	end
	xmlSaveFile ( file )
	xmlUnloadFile ( file )
	return false
end

function addRadioStation ( name, url )
	local file = xmlLoadFile ( "@xml/usermusic.xml" ) or createUserMusicFile ( true )
	local child = xmlCreateChild ( file, "radio" )
	xmlNodeSetAttribute ( child, "name", name )
	xmlNodeSetAttribute ( child, "url", url )
	xmlSaveFile ( file )
	xmlUnloadFile ( file )
end
createUserMusicFile ( )