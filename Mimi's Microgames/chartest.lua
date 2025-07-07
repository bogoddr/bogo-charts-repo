local gameState = {
    t = 0,
    tick = 0,
    player1 = {
        -- todo
    },
    player2 = {
        -- todo
    }
}

local main = Def.ActorFrame{
    InitCommand=function(self)
        self:SetUpdateFunction(function (a,delta)
            gameState.tick = gameState.tick + 1
            gameState.t = gameState.t + delta
            if (gameState.t < 0) then
                gameState.t = 0
            end
            if (gameState.t > 1) then
                gameState.t = math.mod(gameState.tick, 1)
                local coachleft = self:GetChild( "coachleft" )
                coachleft:queuecommand( "SyncAnimation" ) 
            end
            --if (math.mod(gameState.tick, 1) == 0) then
                local lineStrip = self:GetChild( "LineStrip" )
                lineStrip:queuecommand( "CustomUpdate" ) 
            --end
        end)
    end,
    StepMessageCommand=function(self, params)
        
    end,
}

-- keep-alive Actor
main[#main+1] = Def.Actor{ InitCommand=function(self) self:sleep(999) end }

main[#main+1] = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback( function( event )
            --SM(event.type)
            --if event.type ~= "InputEventType_Release" then
            --	SM( event.GameButton )
            --end
            return false
        end )
	end
}

main[#main+1] = Def.Sprite{
   Texture="bg.png",
   OnCommand=function(self)
      self:Center():FullScreen():diffusealpha(1)
   end
}

main[#main+1] = Def.Sprite{
    Name="Player1",
    Texture="char 5x1.png",
    InitCommand=function(self)
        local duration_between_frames = 0.2
        self.isJumping = false
        self.jumpTimer = 0;
        self:SetStateProperties({
            { Frame=0,  Delay=duration_between_frames},
            { Frame=1,  Delay=duration_between_frames},
            { Frame=0,  Delay=duration_between_frames},
            { Frame=2,  Delay=duration_between_frames}
        })
    end,
    OnCommand=function(self)
        self:Center():diffusealpha(1)
    end,
    StepMessageCommand=function(self, params)
        self:queuecommand( "Jump" ) 
    end,
    JumpCommand=function(self, params)
        self.isJumping = true;
        self.jumpTimer = 0;
        self:decelerate( 1 ):y( _screen.h/2 - 100 )
        self:accelerate( 1 ):y( _screen.h/2 )
        self.isJumping = false;
    end
}

main[#main+1] = Def.Sprite{
    Name="coachleft",
    Texture="coach 6x1.png",
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X-100, SCREEN_CENTER_Y)
        self:queuecommand('SyncAnimation')
    end,
    SyncAnimationCommand=function(self,params)
        local duration_between_frames = 1 / 10
        self:SetStateProperties({
            { Frame=0,  Delay=duration_between_frames},
            { Frame=1,  Delay=duration_between_frames},
            { Frame=2,  Delay=duration_between_frames},
            { Frame=3,  Delay=duration_between_frames},
            { Frame=4,  Delay=duration_between_frames},
            { Frame=5,  Delay=duration_between_frames},
            { Frame=4,  Delay=duration_between_frames},
            { Frame=3,  Delay=duration_between_frames},
            { Frame=2,  Delay=duration_between_frames},
            { Frame=1,  Delay=duration_between_frames}
        })
        self:SetSecondsIntoAnimation(0)
    end
}

main[#main+1] = Def.Sound{
   File="PikaPika.ogg",
   SupportRateChanging=true,
   OnCommand=function(self)
      --self:play()
      self.currSoundRate = 1.0;
   end,
   StepMessageCommand=function(self, params)
        if params.PlayerNumber == 'PlayerNumber_P1' then
            self.currSoundRate = self.currSoundRate + 0.1
            self:get():speed(self.currSoundRate)
        else
            SM( 'p2 ' .. params.Column )
        end
   end,
}

local numVerts = 10
local function calcVertPosition(i) 
    return {i * 30, gameState.t * 3 * (5-math.abs(i - (numVerts / 2))), 0}
end
local function linestrip_demo(x, y)
	
	local verts = {}
    local colors = {Color.Red, Color.Orange, Color.Green, Color.Blue, Color.Purple}
    for i=1,numVerts do
        table.insert(verts, {calcVertPosition(i), colors[math.mod(i, #colors)+1]})
    end

	return Def.ActorMultiVertex{
		Name= "LineStrip",
		InitCommand=
			function(self)
				self:visible(false)
				self:xy(x, y)
				self:SetDrawState{Mode="DrawMode_LineStrip"}

				self:visible(true)
                self:SetLineWidth(1)
				self:SetDrawState{First= 1, Num= -1}
                
				self:SetLineWidth(10)
				self:SetVertices(verts)
				self:finishtweening()
			end,
        CustomUpdateCommand=
            function(self)
                --SM(gameState.tick)
                --verts[1][1][2] = gameState.t * 100
                for i=1,numVerts do
                    local p = calcVertPosition(i);
                    verts[i][1][1] = p[1]
                    verts[i][1][2] = p[2]
                end
                self:linear(0.01)
                self:SetVertices(verts)
            end,
	}
end

main[#main+1] = linestrip_demo(400,400);

return main;
