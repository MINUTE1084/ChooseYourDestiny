local mod = RegisterMod("Choose Your Destiny Challenge", 1)
local game = Game()
local cahllengeEasy = Isaac.GetChallengeIdByName("Choose your destiny (Easy)")
local cahllengeNormal = Isaac.GetChallengeIdByName("Choose your destiny (Normal)")
local cahllengeHard = Isaac.GetChallengeIdByName("Choose your destiny (Hard)")
local cahllengeInsane = Isaac.GetChallengeIdByName("Choose your destiny (Insane)")
local cahllengeImpossible = Isaac.GetChallengeIdByName("Choose your destiny (Impossible)")

function mod:InitalizeChallenge(isContinue)
	if((game.Challenge == cahllengeEasy or game.Challenge == cahllengeNormal or game.Challenge == cahllengeHard or game.Challenge == cahllengeInsane or game.Challenge == cahllengeImpossible) and 
	isContinue == false) then 
		gameState = 0 
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.InitalizeChallenge, isContinue)

function mod:UseGenesis()
	local currentRoom = game:GetLevel():GetCurrentRoomIndex()
	local startingRoom = game:GetLevel():GetStartingRoomIndex()

	if currentRoom ~= startingRoom and gameState == 0 then
		gameState = 1
		
		local itemCount = 0
		if(game.Challenge == cahllengeEasy or game.Challenge == cahllengeImpossible) then itemCount = 40 
		elseif(game.Challenge == cahllengeNormal) then itemCount = 30 
		elseif(game.Challenge == cahllengeHard) then itemCount = 25 
		elseif(game.Challenge == cahllengeInsane) then itemCount = 15
		else return 0 end
		
		local player = Isaac.GetPlayer(0)
		for i = 1, itemCount do player:AddCollectible(1) end
		player:UseActiveItem(CollectibleType.COLLECTIBLE_GENESIS, false, true, true, true)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.UseGenesis)

function mod:RemoveCollectibles(pickup)
	if (pickup.Variant == 100 and not (pickup.SubType == 626 or pickup.SubType == 627 or pickup.SubType == 688) and
	(game.Challenge == cahllengeEasy or game.Challenge == cahllengeNormal or game.Challenge == cahllengeHard or game.Challenge == cahllengeInsane or game.Challenge == cahllengeImpossible)) then 
		if (game:GetLevel():GetStage() ~= LevelStage.STAGE1_1 or game:GetRoom():GetType() ~= RoomType.ROOM_ISAACS) then 
			pickup:Remove() 
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.RemoveCollectibles, pickup)