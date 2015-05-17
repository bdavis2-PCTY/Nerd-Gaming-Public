------------------------------------------
-- 				  SRNCore				--
------------------------------------------
-- Developer: Braydon Davis				--
-- File: math.lua						--
-- Copywrite 2013 (C) Braydon Davis		--
-- All rights reserved.					--
------------------------------------------	
local isMathQuestion = false
function createMathProblem ( p )
	if p and not exports["NGAdministration"]:isPlayerStaff ( p ) then return false end
	if not isMathQuestion then
		local n1 = math.random ( 50, 90 )
		local n2 = math.random ( 20, 45 )
		local n3 = math.random ( 1000, 9000 )
		local reward = math.random ( 300, 600 )
		local question = n1.." - "..n2.." + "..n3
		outputDebugString ( "MATH: Question "..question.." has been generated with an answer of "..n1 - n2 + n3 )
		outputChatBox ( "#DF743F[MATH QUESTION]#ffffff First Person To Answer #ffff00"..question.."#ffffff will win #00ff00$"..reward.."#ffffff (Use /result [ANSWER])", getRootElement ( ), 0, 0, 0, true ) 
		
		mathTable = {
			reward = reward,
			question = n1.." - "..n2.." + "..n3,
			answer = n1 - n2 + n3
		}
		
		isMathQuestion = true
		return true
	else
		isMathQuestion = false
		mathTable = nil
		createMathProblem ( )
	end
end 
setTimer ( createMathProblem, 900000, 0 )
addCommandHandler ( "math", createMathProblem )

addCommandHandler ( "result", function ( p, cmd, answer )
	if ( isMathQuestion ) then
		if ( tonumber ( answer ) == tonumber ( mathTable.answer ) ) then
			outputChatBox ( "#DF743F[MATH QUESTION] #ff0000"..getPlayerName ( p ).."#ffffff was first to answer #0000ff"..mathTable.answer.."#ffffff and won #00ff00$"..mathTable.reward, root, 0, 0, 0, true )
			givePlayerMoney ( p, mathTable.reward )
			isMathQuestion = false
			mathTable = nil
			return true
		else
			outputChatBox ( "#DF743F[MATH QUESTION] #ffffffSorry, #ffff00"..getPlayerName ( p ).." #ffffffbut that #ff0000isn't#ffffff correct answer.", p, 255, 0, 0, true )
			return false
		end
	else
		outputChatBox ( "#DF743F[MATH QUESTION] #ffffffThere aren't any questions available right now. Try again later.", p, 255, 0, 0, true )
		return false
	end
end )

function getRunningMathEquation ( )
	if ( mathTable ) then
		return mathTable.question
	end
	return false
end