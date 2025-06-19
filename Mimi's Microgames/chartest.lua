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
        if params.PlayerNumber == 'PlayerNumber_P1' then
            SM( 'p1 ' .. params.Column )
        else
            SM( 'p2 ' .. params.Column )
        end
   end,
}

main[#main+1] = Def.Sprite{
    Name="Player1",
    Texture="wily 6x1.png",
    InitCommand=function(self)
        self:name("dog")
        self.isJumping = false
        self.jumpHeight = 0
        self.jumpVelocity = 0;
        local duration_between_frames = 0.15
        self:SetStateProperties({
            { Frame=0,  Delay=duration_between_frames},
            { Frame=1,  Delay=duration_between_frames},
            { Frame=2,  Delay=duration_between_frames},
            { Frame=3,  Delay=duration_between_frames}
        })
    end,
    OnCommand=function(self)
        --self:Center():diffusealpha(1)
    end,
    StepMessageCommand=function(self, params)
        if params.PlayerNumber == 'PlayerNumber_P1' then
            self.isJumping = true;
            self.jumpHeight = 0;
            self.jumpVelocity = 10;
        else
            --SM( 'p2 ' .. params.Column )
        end
    end,
    CustomUpdateCommand=function(self)
        self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - self.jumpHeight)
        self.jumpHeight = self.jumpHeight + (self.jumpVelocity * gameState.lastDelta * 10)
        self.jumpVelocity = self.jumpVelocity - gameState.lastDelta * 10
        if self.jumpHeight < 0 then
            self.isJumping = false
            self.jumpHeight = 0
        end
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
