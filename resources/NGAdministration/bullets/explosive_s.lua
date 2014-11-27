addEvent ( "NGAdmin:Modules->ExplosiveBullets:onClientWithBulletsFire", true )
addEventHandler ( "NGAdmin:Modules->ExplosiveBullets:onClientWithBulletsFire", root, function ( x, y, z )
	createExplosion ( x, y, z, 2 )
end )