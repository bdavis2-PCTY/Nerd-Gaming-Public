local btn = dxButton:create ( 0, 0, 100, 25, "Sample", nil);

btn.func = function ( )
	outputChatBox ( "Test" );
end 

for i, v in pairs ( btn ) do 
	outputChatBox ( "[" .. tostring ( i ).."] = " .. tostring ( v ) );
end 