
-- a Lua file can only return one Actor
-- so the common strategy is to return one ActorFrame that contains many sub-Actors
return Def.ActorFrame{
   -- keep-alive Actor
   -- this will allow the file to persist for 999 seconds
   -- (or, until the end of the stepchart)
   Def.Actor{
      OnCommand=function(self)
         self:sleep(999) 
      end,
      JudgmentMessageCommand=function(self, params)
         -- Note that JudgementMessages will be broadcast for any human players,
         -- but to keep this example simple, we'll limit it to PLAYER_1.
         if params.Player == PLAYER_1 then
   
            -- This SystemMessage will display each judgment in string
            -- form at the top of the screen as it occurs.
            -- So, if a note passes and the player misses it,
            -- "TapNoteScore_Miss"  would be displayed at the
            -- top of the screen.
            --
            -- A W1 judgment (Marvelous in DDR, Fantastic in ITG, etc.)
            -- would display "TapNoteScore_W1".
            -- (Note that the "W" is for window, as in "timing window.")
            --
            -- Hold notes have their own, separate judgment system.
            -- So, when a hold note is judged, a JudgmentMessage will be
            -- broadcast, but the TapNoteScore parameter will be nil.
            -- Account for that here with a logical or statement that tries
            -- params.HoldNoteScore if params.TapNoteScore is nil.
            SCREENMAN:SystemMessage( params.TapNoteScore or params.HoldNoteScore )
         end
      end,
      StepMessageCommand=function(self, params)
         SCREENMAN:SystemMessage( params.Column )
         --if ACTIVE and params.PlayerNumber == player then

            --ExtendLine(params.Column + 1)
            -- print_matrix(incorrect_spots)

            --self:SetNumVertices(#verts)
               --:SetVertices(verts)
         --end
      end,
   },

   

   --StepMessageCommand=function(self, params)
   --   SCREENMAN:SystemMessage( params.TapNoteScore or params.HoldNoteScore )

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
