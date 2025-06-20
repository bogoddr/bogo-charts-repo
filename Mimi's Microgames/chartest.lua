local gameState = {
    t = 0,
    lastDelta = 0,
}

local main = Def.ActorFrame{
    InitCommand=function(self)
        self:SetUpdateFunction(function (a,delta)
            gameState.lastDelta = delta
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

-- keep-alive Actor
main[#main+1] = Def.Actor{ InitCommand=function(self) self:sleep(999) end }

return main;
