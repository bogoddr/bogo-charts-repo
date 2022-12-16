
-- a Lua file can only return one Actor
-- so the common strategy is to return one ActorFrame that contains many sub-Actors
return Def.ActorFrame{
   -- keep-alive Actor
   -- this will allow the file to persist for 999 seconds
   -- (or, until the end of the stepchart)
   Def.Actor{ OnCommand=function(self) self:sleep(999) end },

   -- the Sprite Actor
   Def.Sprite{
      Texture="mimi.png",
      OnCommand=function(self)
         self:Center():FullScreen():diffusealpha(1)
      end
   },

   Def.Sound{
      -- Note that you must tell the sound actor to play()
      File="vineboom.ogg",

      OnCommand=function(self)
         self:play()
      end
   }
}
