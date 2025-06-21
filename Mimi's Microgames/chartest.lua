local gameState = {
    tick = 0,
    lastDelta = 0,
}

local main = Def.ActorFrame{
    InitCommand=function(self)
        self:SetUpdateFunction(function (a,delta)
            gameState.lastDelta = delta
            gameState.tick = gameState.tick + 1
            self:RunCommandsOnChildren( function(child) 
                if(child:GetCommand("CustomUpdate")) then
                    child:queuecommand( "CustomUpdate" )
                end
            end)
        end)
    end,
    StepMessageCommand=function(self, params)
        
    end,
}

main[#main+1] = Def.Sprite{
   Texture="bg.png",
   OnCommand=function(self)
      self:Center():FullScreen():diffusealpha(1)
   end
}

local duration_between_frames = 0.2
main[#main+1] = Def.Sprite{
    Name="Player1",
    Texture="char 5x1.png",
    InitCommand=function(self)
        self.isJumping = false
        self.jumpHeight = 0
        self.jumpVelocity = 0;
        self:SetStateProperties({
            { Frame=0,  Delay=duration_between_frames},
            { Frame=1,  Delay=duration_between_frames},
            { Frame=0,  Delay=duration_between_frames},
            { Frame=2,  Delay=duration_between_frames}
        })
    end,
    OnCommand=function(self)
        --self:Center():diffusealpha(1)
    end,
    StepMessageCommand=function(self, params)
        if params.PlayerNumber == 'PlayerNumber_P1' and params.Column == 2 and not self.isJumping then
            self.isJumping = true;
            self.jumpHeight = 0;
            self.jumpVelocity = 50;
        else
            --SM( 'p2 ' .. params.Column )
        end
    end,
    CustomUpdateCommand=function(self)
        self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - self.jumpHeight)
        if self.isJumping then
            self:SetStateProperties({
                { Frame=self.jumpVelocity > 0 and 3 or 4,  Delay=0},
            })
            self.jumpHeight = self.jumpHeight + (self.jumpVelocity * gameState.lastDelta * 10)
            self.jumpVelocity = self.jumpVelocity - gameState.lastDelta * 120
        end
        if self.jumpHeight < 0 and self.isJumping then
            self.isJumping = false
            self.jumpHeight = 0
            self:SetStateProperties({
                { Frame=0,  Delay=duration_between_frames},
                { Frame=1,  Delay=duration_between_frames},
                { Frame=0,  Delay=duration_between_frames},
                { Frame=2,  Delay=duration_between_frames}
            })
        end
    end,
}

main[#main+1] = Def.Sprite{
    Name="coachleft",
    Texture="coach 6x1.png",
    InitCommand=function(self)
        local duration_between_frames = 0.2
        self:SetStateProperties({
            { Frame=0,  Delay=duration_between_frames},
            { Frame=1,  Delay=duration_between_frames},
            { Frame=2,  Delay=duration_between_frames},
            { Frame=3,  Delay=duration_between_frames},
            { Frame=4,  Delay=duration_between_frames},
            { Frame=5,  Delay=duration_between_frames}
        })
    end,
    CustomUpdateCommand=function(self)
        self:xy(SCREEN_CENTER_X-100, SCREEN_CENTER_Y)
    end,
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

local InputHandler = function( event )
    SM(event)
	-- do something cool with the event table in here :)
	-- the details of the event table are documented below

	-- example:
	-- show the GameButton that was most recently pressed/held
	if event.type ~= "InputEventType_Release" then
		SM( event.GameButton )
	end

	return false
end

main[#main+1] = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback( InputHandler )
	end
}

-- keep-alive Actor
main[#main+1] = Def.Actor{ InitCommand=function(self) self:sleep(999) end }

local function linestrip_demo(x, y)
	-- Minimum verts: 2
	-- Verts per group: 1
	-- Vert diagram:
	-- 1 - 2 - 3
	--         |
	-- 8       4
	-- |       |
	-- 7 - 6 - 5
	local verts= {
		{{-40, -40, 0}, Color.Red},
		{{0, -40, 0}, Color.Orange},
		{{40, -40, 0}, Color.Yellow},
		{{40, 0, 0}, Color.Green},
		{{40, 40, 0}, Color.Blue},
		{{0, 40, 0}, Color.Purple},
	}
	return Def.ActorMultiVertex{
		Name= "AMV_LineStrip",
		InitCommand=
			function(self)
				self:visible(false)
				self:xy(x, y)
				self:SetDrawState{Mode="DrawMode_LineStrip"}

				self:visible(true)
                self:SetLineWidth(1)
				self:SetDrawState{First= 1, Num= -1}
				--verts[1][1][2]= -40
				--verts[4][1][1]= 40
				--verts[6][1][2]= 40
				--verts[8][1][1]= -40
                
				self:SetLineWidth(10)
				self:SetVertices(verts)
				self:finishtweening()
				--self:queuecommand("FirstMove")
				--self:queuecommand("SecondMove")
			end,
		FirstMoveCommand=
			function(self)
				self:linear(1)
				verts[1][1][2]= verts[1][1][2]+20
				verts[4][1][1]= verts[4][1][1]+20
				verts[6][1][2]= verts[6][1][2]-10
				verts[8][1][1]= verts[8][1][1]+10
				self:SetLineWidth(20)
				self:SetVertices(verts)
			end,
		SecondMoveCommand=
			function(self)
				self:linear(1)
				self:SetDrawState{First= 3, Num= 4}
			end,
        CustomUpdateCommand=
            function(self)
                if gameState.tick % 60 == 0 then
				    self:linear(1)
                    verts[1][1][2] = gameState.tick
				    self:SetVertices(verts)
                end
            end,
	}
end

main[#main+1] = linestrip_demo(400,400);

return main;
