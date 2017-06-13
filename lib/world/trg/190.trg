#19000
Swamp Hut passive~
2 bw 5
~
switch %random.4%
  case 1
    %echo% You swat at a mosquito as it bites into your arm.
  break
  case 2
    %echo% The hut seems to sway in the wind.
  break
  case 3
    %echo% The floorboards creak beneath your feet.
  break
  case 4
    %echo% You hold your nose as a new stench emanates from the hut.
  break
done
~
#19001
Swamp Hag 2.0: Summon Allies~
0 k 100
~
if %self.cooldown(19001)%
  halt
end
* Clear blind just in case...
if %self.affect(BLIND)%
  %echo% %self.name%'s eyes flash blue, and %self.hisher% vision clears!
  dg_affect %self% BLIND off 1
end
eval room %self.room%
eval person %room.people%
while %person%
  if %person.vnum% == 19001 || %person.vnum% == 19002
    * Rat already present
    halt
  end
  eval person %person.next_in_room%
done
nop %self.set_cooldown(19001, 30)%
eval heroic_mode %self.mob_flagged(GROUP)%
%echo% %self.name% reaches under the bed and opens a cage.
wait 1 sec
if %heroic_mode%
  %load% mob 19002 ally
else
  %load% mob 19001 ally
end
eval room %self.room%
eval summon %room.people%
if %summon%
  %echo% %summon.name% scurries out from a cage!
  %force% %summon% %aggro% %actor%
end
~
#19002
Swamp Hag 2.0: Pestle Smash~
0 k 20
~
if %self.cooldown(19001)%
  halt
end
nop %self.set_cooldown(19001, 30)%
eval heroic_mode %self.mob_flagged(GROUP)%
%send% %actor% %self.name% swings %self.hisher% pestle into the side of your head!
%echoaround% %actor% %self.name% swings %self.hisher% pestle into the side of %actor.name%'s head!
if %heroic_mode%
  dg_affect #19002 %actor% STUNNED on 10
end
%damage% %actor% 100
~
#19003
Swamp Hag 2.0: Voodoo Dolls~
0 k 40
~
if %self.cooldown(19001)%
  halt
end
nop %self.set_cooldown(19001, 30)%
eval heroic_mode %self.mob_flagged(GROUP)%
if !%heroic_mode%
  %echo% %self.name% grabs a doll off a nearby shelf...
  %send% %actor% The doll looks like you!
  %echoaround% %actor% The doll looks like %actor.name%!
  wait 2 sec
  %echo% %self.name% starts stabbing needles into the doll!
  %send% %actor% You feel stabbing pains in your limbs!
  %echoaround% %actor% %actor.name% winces in pain.
  dg_affect #19003 %actor% SLOW on 30
  %dot% #19003 %actor% 50 30 magical 1
else
  %echo% %self.name% grabs a handful of needles!
  wait 2 sec
  %echo% %self.name% starts rapidly stabbing needles into the dolls on the nearby shelves!
  %echo% You feel stabbing pains in your limbs!
  eval room %self.room%
  eval person %room.people%
  while %person%
    eval test %%self.is_enemy(%person%)%%
    if %test%
      dg_affect #19003 %person% SLOW on 45
      %dot% #19003 %person% 75 45 magical 1
    end
    eval person %person.next_in_room%
  done
end
~
#19004
Swamp Hag 2.0: Insect Swarm~
0 k 60
~
if %self.cooldown(19001)%
  halt
end
nop %self.set_cooldown(19001, 30)%
eval heroic_mode %self.mob_flagged(GROUP)%
%echo% %self.name% throws open a small window.
wait 3 sec
%echo% A swarm of biting insects fills the room!
if %heroic_mode%
  %echo% Everyone is blinded and stung by the insects!
else
  %echo% Everyone is bitten and stung by the insects!
end
eval room %self.room%
if %heroic_mode%
  eval person %room.people%
  while %person%
    if %person.is_pc%
      dg_affect #19004 %person% BLIND on 20
    end
    eval person %person.next_in_room%
  done
  %aoe% 100 physical
end
~
#19005
Swamp Hag 2.0 Diff Select~
1 c 4
difficulty~
if !%arg%
  %send% %actor% You must specify a level of difficulty.
  return 1
  halt
end
* TODO: Check nobody's in the adventure before changing difficulty
if normal /= %arg%
  %echo% Setting difficulty to Normal...
  eval difficulty 1
elseif hard /= %arg%
  %echo% Setting difficulty to Hard...
  eval difficulty 2
elseif group /= %arg%
  %echo% Setting difficulty to Group...
  eval difficulty 3
elseif boss /= %arg%
  %echo% Setting difficulty to Boss...
  eval difficulty 4
else
  %send% %actor% That is not a valid difficulty level for this adventure.
  halt
  return 1
end
* Clear existing difficulty flags and set new ones.
eval vnum 19000
while %vnum% <= 19000
  eval mob %%instance.mob(%vnum%)%%
  if !%mob%
    * This was for debugging. We could do something about this.
    * Maybe just ignore it and keep on setting?
  else
    nop %mob.remove_mob_flag(HARD)%
    nop %mob.remove_mob_flag(GROUP)%
    if %difficulty% == 1
      * Then we don't need to do anything
    elseif %difficulty% == 2
      nop %mob.add_mob_flag(HARD)%
    elseif %difficulty% == 3
      nop %mob.add_mob_flag(GROUP)%
    elseif %difficulty% == 4
      nop %mob.add_mob_flag(HARD)%
      nop %mob.add_mob_flag(GROUP)%
    end
  end
  eval vnum %vnum% + 1
done
%send% %actor% You tug on a hanging rope, and a rope ladder unfolds and drops from the ceiling...
%echoaround% %actor% %actor.name% tugs on a hanging rope, and a rope ladder unfolds and drops from the ceiling...
eval newroom i19001
eval exitroom %instance.location%
if %exitroom%
  %door% %exitroom% %exitroom.enter_dir% room %newroom%
  %door% %newroom% %exitroom.exit_dir% room %exitroom%
end
eval room %self.room%
eval person %room.people%
while %person%
  eval next_person %person.next_in_room%
  %teleport% %person% %newroom%
  eval person %next_person%
done
otimer 24
~
#19006
Swamp Hag delayed despawn~
1 f 0
~
%adventurecomplete%
~
#19007
Swamp Hag load BoP->BoE~
1 n 100
~
eval actor %self.carried_by%
if !%actor%
  eval actor %self.worn_by%
end
if !%actor%
  halt
end
if %actor% && %actor.is_pc%
  * Item was crafted
  if %self.is_flagged(BOP)%
    nop %self.flag(BOP)%
  end
  if !%self.is_flagged(BOE)%
    nop %self.flag(BOE)%
  end
  * Default flag is BOP so need to unbind when setting BOE
  nop %self.bind(nobody)%
else
  * Item was probably dropped
  if !%self.is_flagged(BOP)%
    nop %self.flag(BOP)%
  end
  if %self.is_flagged(BOE)%
    nop %self.flag(BOE)%
  end
end
~
#19008
Swamp Hag 2.0 Death~
0 f 100
~
* Crystal ball
%load% obj 19000
eval item %room.contents%
%echo% As %self.name% falls to the ground, %self.heshe% pulls a cloth off the table, revealing a crystal ball!
* Mark the adventure as complete
%adventurecomplete%
* For each player in the room (on hard+ only):
if %self.mob_flagged(HARD)% || %self.mob_flagged(GROUP)%
  eval room_var %self.room%
  eval ch %room_var.people%
  while %ch%
    if %ch.is_pc%
      * Token reward
      eval token_amount 1
      if %self.mob_flagged(GROUP)%
        eval token_amount %token_amount% * 2
        if %self.mob_flagged(HARD)%
          eval token_amount %token_amount% * 2
        end
      end
      if %token_amount% > 1
        eval string %token_amount% %currency.19000(2)%
        set pronoun them
      else
        eval string a %currency.19000(1)%
        set pronoun it
      end
      %send% %ch% Searching the room, you find %string%! You take %pronoun%.
      eval tokens %%ch.give_currency(19000, %token_amount%)%%
      nop %tokens%
      * Random item is handled by the loot replacer.
    end
    eval ch %ch.next_in_room%
  done
end
return 0
~
#19009
Swamp Hag 2.0 group: Bind ~
0 k 100
~
if %self.cooldown(19001)%
  halt
end
eval heroic_mode %self.mob_flagged(GROUP)%
if !%heroic_mode%
  halt
end
* Find a non-bound target
eval target %actor%
eval room %self.room%
eval person %room.people%
eval target_found 0
eval no_targets 0
while %target.affect(19009)% && %person%
  eval test %%person.is_enemy(%self%)%%
  if %person.is_pc% && %test%
    eval target %person%
  end
  eval person %person.next_in_room%
done
if !%target%
  * Sanity check
  halt
end
if %target.affect(19009)%
  * No valid targets
  halt
end
* Valid target found, start attack
nop %self.set_cooldown(19001, 30)%
%send% %target% %self.name% grabs a murky green potion off a nearby shelf and takes aim at you...
%echoaround% %target% %self.name% grabs a murky green potion off a nearby shelf and takes aim at %target.name%...
wait 3 sec
%send% %target% %self.name% throws the murky potion at you!
%echoaround% %target% %self.name% throws the murky potion at %target.name%!
wait 3 sec
%send% %target% The potion bottle shatters, and tendrils of dark energy lash out to bind your limbs!
%echoaround% %target% The potion bottle shatters, and tendrils of dark energy lash out to bind %target.name%'s limbs!
%send% %target% Type 'struggle' to break free!
dg_affect #19009 %actor% STUNNED on 75
~
#19010
Swamp Hag bind struggle~
0 c 0
struggle~
eval break_free_at 3
if !%actor.affect(19009)%
  return 0
  halt
end
if %actor.cooldown(19010)%
  %send% %actor% You need to gather your strength.
  halt
end
nop %actor.set_cooldown(19010, 3)%
if !%actor.varexists(struggle_counter)%
  eval struggle_counter 0
  remote struggle_counter %actor.id%
else
  eval struggle_counter %actor.struggle_counter%
end
eval struggle_counter %struggle_counter% + 1
if %struggle_counter% >= %break_free_at%
  %send% %actor% You break free of your bindings!
  %echoaround% %actor% %actor.name% breaks free of %actor.hisher% bindings!
  dg_affect #19009 %actor% off
  rdelete struggle_counter %actor.id%
  halt
else
  %send% %actor% You struggle against your bindings, but fail to break free.
  %echoaround% %actor% %actor.name% struggles against %actor.hisher% bindings!
  remote struggle_counter %actor.id%
  halt
end
~
#19011
Swamp hag bind fallback~
2 c 0
struggle~
* Only if the hag is dead.
if %instance.mob(19000)%
  return 0
  halt
end
if !%actor.affect(19009)%
  return 0
  halt
end
%send% %actor% You break free of your bindings!
%echoaround% %actor% %actor.name% breaks free of %actor.hisher% bindings!
dg_affect #19009 %actor% off
if %actor.varexists(struggle_counter)%
  rdelete struggle_counter %actor.id%
  halt
end
~
#19012
Hag difficulty select: wrong command~
1 c 4
up climb~
%send% %actor% You can't climb up the rope. Select a difficulty level first.
return 1
~
#19013
Swamp Rat Combat 2.0~
0 k 100
~
* Scale up (group only)
if %self.vnum% == 19002
  if %self.varexists(enrage_counter)%
    eval enrage_counter %self.enrage_counter%
  else
    eval enrage_counter 0
  end
  eval enrage_counter %enrage_counter% + 1
  dg_affect #19014 %self% off
  eval amount %enrage_counter% * 1
  dg_affect #19014 %self% BONUS-PHYSICAL %amount% -1
  remote enrage_counter %self.id%
  if %random.4% == 4
    %echo% %self.name% seems to grow slightly!
  end
  if %enrage_counter% == 100
    eval master %self.master%
    if %master%
      %force% %master% shout Magic wand, make my monster groooooooow!
      %echo% %master.name% smacks %self.name% with her pestle.
    end
  end
end
* Bite deep
if %random.6% == 6
  wait 1
  %echo% %self.name% bites deep!
  %send% %actor% You don't feel so good...
  %echoaround% %actor% %actor.name% doesn't look so good...
  %dot% #19013 %actor% 50 30 physical 4
end
~
#19014
Rat despawn~
0 n 100
~
wait 30 sec
%purge% %self% $n scurries into a crack in the floor.
~
#19015
Swamp Hag 2.0 loot replacer~
1 n 100
~
eval actor %self.carried_by%
if %actor%
  if %actor.mob_flagged(HARD)% || %actor.mob_flagged(GROUP)%
    * Swamp water
    %load% obj 19001 %actor% inv
    * Roll for drop
    eval percent_roll %random.100%
    if %percent_roll% <= 2
      * Minipet
      eval vnum 19007
    else
      eval percent_roll %percent_roll% - 2
      if %percent_roll% <= 2
        * Land mount
        eval vnum 19008
      else
        eval percent_roll %percent_roll% - 2
        if %percent_roll% <= 2
          * Sea mount
          eval vnum 19009
        else
          eval percent_roll %percent_roll% - 2
          if %percent_roll% <= 1
            * Flying mount
            eval vnum 19010
          else
            eval percent_roll %percent_roll% - 1
            if %percent_roll% <= 1
              * Morpher
              eval vnum 19040
            else
              eval percent_roll %percent_roll% - 1
              if %percent_roll% <= 1
                * Seed
                eval vnum 19041
              else
                eval percent_roll %percent_roll% - 1
                if %percent_roll% <= 1
                  * Coffee
                  eval vnum 19048
                else
                  eval percent_roll %percent_roll% - 1
                  if %percent_roll% <= 1
                    * Feathers
                    eval vnum 19004
                  else
                    eval percent_roll %percent_roll% - 1
                    if %percent_roll% <= 1
                      * Clothing
                      eval vnum 19006
                    else
                      eval percent_roll %percent_roll% - 1
                      if %percent_roll% <= 1
                        * Shoes
                        eval vnum 19038
                      else
                        * Nothing
                        eval vnum -1
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if %vnum% > 0
      if %self.level%
        eval level %self.level%
      else
        eval level 100
      end
      eval room %self.room%
      eval person %room.people%
      while %person%
        if %person.is_pc%
          %load% obj %vnum% %actor% inv %level%
          eval item %%actor.inventory(%vnum%)%%
          if %item.is_flagged(BOP)%
            eval bind %%item.bind(%self%)%%
            nop %bind%
          end
        end
        eval person %person.next_in_room%
      done
    end
  end
end
%purge% %self%
~
#19047
Walking Hut setup~
5 n 100
~
eval inter %self.interior%
if (!%inter%)
  halt
end
if (!%inter.fore%)
  %door% %inter% fore add 19048
end
detach 19047 %self.id%
~
#19048
Swamp hag hut: Fill with Coffee~
2 c 0
fill~
eval liquid_num 19048
set name hag's coffee
if !%arg%
  * Fill what?
  return 0
  halt
end
eval target %%actor.obj_target(%arg%)%%
if %target.type% != DRINKCON
  * You can't fill [item]!
  return 0
  halt
end
if %target.val1% >= %target.val0%
  %send% %actor% There is no room for more.
  halt
end
if %target.val1% > 0 && %target.val2% != %liquid_num%
  %send% %actor% There is already another liquid in it. Pour it out first.
  halt
end
%send% %actor% You fill %target.shortdesc% with %name%.
%echoaround% %actor% %actor.name% fills %target.shortdesc% with %name%.
eval set_type %%target.val2(%liquid_num%)%%
eval set_quantity %target.val1(%target.val0%)%%
nop %set_type%
nop %set_quantity%
~
$
