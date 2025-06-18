function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local counter = 0

local MyUpdateFunction = function (a, delta)
   SM("hello hello" .. delta)
   counter = counter + 1
end

-- main FGChange ActorFrame
local af = Def.ActorFrame{
   InitCommand=function(self)
      self:SetUpdateFunction(MyUpdateFunction)
   end,
   StepMessageCommand=function(self, params)
      if params.PlayerNumber == 'PlayerNumber_P1' then
         -- SCREENMAN:SystemMessage( 'p1 ' .. params.Column )
         SCREENMAN:SystemMessage("" .. counter)
         counter = counter + 1
      else
         SCREENMAN:SystemMessage( 'p2 ' .. params.Column )
      end
   end,
}

-- keep-alive Actor
af[#af+1] = Def.Actor{ InitCommand=function(self) self:sleep(999) end }

af[#af+1] = Def.Sprite{
   Texture="mimi.png",
   InitCommand=function(self)
      SCREENMAN:SystemMessage( 'hi hi hi' )
   end,
   OnCommand=function(self)
      self:Center():FullScreen():diffusealpha(1)
      self:linear(3):zoom(2)
   end
}

af[#af+1] = Def.Sound{
   File="vineboom.ogg",
   OnCommand=function(self)
      self:play()
   end
}

return af;
