itemList = { 
	['fuelcans'] = "fuel can",
	['drug.marijuana'] = "Marijuana",
	['drug.lsd'] = "LSD",
	['health_packs'] = "Health Pack"
}

itemPrices = { 
	['fuelcans'] = {
		min = 1,
		max = 20
	},

	['drug.marijuana'] = {
		min = 5,
		max = 20
	},

	['drug.lsd'] = {
		min = 10,
		max = 30
	},

	['health_packs'] = {
		min = 10,
		max = 1000
	}
}

 
function table.len ( tb )
	local c = 0
	for i, v in pairs ( tb ) do
		c = c + 1
	end
	return c
 end