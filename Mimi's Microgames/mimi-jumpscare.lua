return Def.ActorFrame{
    Def.Sprite{
       Texture="mimi.png",
       OnCommand=function(self)
          self:Center():FullScreen():diffusealpha(1)
       end
    },
    Def.Sound{
       File="vineboom.ogg",
       OnCommand=function(self)
          self:play()
       end
    }
 }
 