local gameState = {
    t = 0,
}

local main = Def.ActorFrame{
    InitCommand=function(self)
        self:SetUpdateFunction(function (a,delta)
            gameState.t = gameState.t + delta
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
    Texture="mimi.png",
    InitCommand=function(self)
        self:name("dog")
        self.isJumping = false
        self.jumpTimer = 0
    end,
    OnCommand=function(self)
        self:Center():FullScreen():diffusealpha(1)
    end,
    StepMessageCommand=function(self, params)
        if params.PlayerNumber == 'PlayerNumber_P1' then
            self.isJumping = true;
            self.jumpTimer = 0;
        else
            --SM( 'p2 ' .. params.Column )
        end
   end,
    CustomUpdateCommand=function(self)
        if(self.isJumping) then
            self:xy(0, self.jumpTimer)
        else 
            self:xy(0, 0)
        end
        self.jumpTimer = self.jumpTimer + 1;
    end,
}

-- keep-alive Actor
main[#main+1] = Def.Actor{ InitCommand=function(self) self:sleep(999) end }

return main;
