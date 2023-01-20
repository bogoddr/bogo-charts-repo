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

-- main FGChange ActorFrame
local af = Def.ActorFrame{
   StepMessageCommand=function(self, params)
      if params.PlayerNumber == 'PlayerNumber_P1' then
         SCREENMAN:SystemMessage( 'p1 ' .. params.Column )
      else
         SCREENMAN:SystemMessage( 'p2 ' .. params.Column )
      end
   end,
}

-- keep-alive Actor
af[#af+1] = Def.Actor{ InitCommand=function(self) self:sleep(999) end }

af[#af+1] = Def.Sprite{
   Texture="mimi.png",
   OnCommand=function(self)
      self:Center():FullScreen():diffusealpha(1)
   end
}

af[#af+1] = Def.Sound{
   File="vineboom.ogg",
   OnCommand=function(self)
      self:play()
   end
}

return af;
