$Header: /repo/public.cvs/app/BioGate/BioMooCore/core3.moo,v 1.1 2021/07/27 06:44:30 bruce Exp $

>@dump #3 with create
@create $root_class named generic room:generic room
@prop #3."who_location_msg" "%T" rc
@prop #3."free_home" 0 rc
@prop #3."victim_ejection_msg" "You have been expelled from %i by %n." rc
@prop #3."ejection_msg" "You expel %d from %i." rc
@prop #3."oejection_msg" "%N unceremoniously %{!expels} %d from %i." rc
@prop #3."residents" {} rc
@prop #3."free_entry" 1 rc
@prop #3."entrances" {} c
@prop #3."blessed_object" #-1 rc
@prop #3."blessed_task" 0 rc
@prop #3."exits" {} c
@prop #3."dark" 0 rc
@prop #3."ctype" 3 rc
@prop #3."vrml_interior_desc" {} rc
;;#3.("vrml_interior_desc") = {"# starry skyy", "DEF BackgroundImage Info {string \"http://hppsda.mayfield.hp.com/image/sky_stars.gif\"}", "# room should be arrayed so that the floor is about 1.5 meters below the origin plane", "# objects at the origin should be at chest level or so", "Material {diffuseColor .6 .38 .16} Transform {translation 0 -1.35 0}", "Cylinder {height .05 radius 50}", "Material {diffuseColor .0 .0 .0 ambientColor .0 .0 .0} Transform {translation 0 .05 0}", "Cylinder {height .05 radius 15}", "Material { diffuseColor .7 .7 .7 } Transform { translation 0 .05 0 }", "DEF floor Separator {", "        Texture2Transform { scaleFactor 4 4 }", "        Texture2 { filename \"http://hppsda.mayfield.hp.com/image/woodfloor3.gif\"}", "        Cube { width 10 height 0.1 depth 10 }", "}", "DEF wall_struts Separator {", "	Material { ambientColor .2 .2 .1 diffuseColor .6 .6 .3 }", "Separator { #1", "	Transform { translation 0 3.95 4.95 }", "	Cube { width 10 height 0.1 depth 0.1 }", "}", "Separator { #2", "	Transform { translation 4.95 3.95 0 }", "	Cube { width 0.1 height 0.1 depth 10 }", "}", "Separator { #3", "	Transform { translation 0 3.95 -4.95 }", "	Cube { width 10 height 0.1 depth 0.1 }", "}", "Separator { #4", "	Transform { translation -4.95 3.95 0 }", "	Cube { width 0.1 height 0.1 depth 10 }", "}", "Separator { #5", "	Transform { translation 4.95 1.95 4.95 }", "	Cube { width 0.1 height 4 depth 0.1 }", "}", "Separator { #6", "	Transform { translation 4.95 1.95 -4.95 }", "	Cube { width 0.1 height 4 depth 0.1 }", "}", "Separator { #7", "	Transform { translation -4.95 1.95 -4.95 }", "	Cube { width 0.1 height 4 depth 0.1 }", "}", "Separator { #8", "	Transform { translation -4.95 1.95 4.95 }", "	Cube { width 0.1 height 4 depth 0.1 }", "}", "	Transform { translation 0 0 -1.5 }", "}", "Material {diffuseColor 0 0 0 ambientColor 0 0 0 specularColor 0 0 0}"}
;;#3.("aliases") = {"generic room"}
;;#3.("object_size") = {36675, 1577149622}

@verb #3:"confunc" this none this
@program #3:confunc
if ((((cp = caller_perms()) == player) || $perm_utils:controls(cp, player)) || (caller == this))
  "Need the first check because guests don't control themselves";
  this:look_self(player.brief);
  this:announce($string_utils:pronoun_sub("%N %<has> connected.", player));
endif
.

@verb #3:"disfunc" this none this
@program #3:disfunc
if ((((cp = caller_perms()) == player) || $perm_utils:controls(cp, player)) || (caller == this))
  this:announce($string_utils:pronoun_sub("%N %<has> disconnected.", player));
  "need the first check since guests don't control themselves";
  if ((this != player.home) && (!$object_utils:isa(player, $guest)))
    "guest disfuncs are handled by $guest:disfunc. Don't add them here";
    $housekeeper:move_players_home(player);
  endif
endif
.

@verb #3:"say" any any any rx
@program #3:say
try
  player:tell("You say, \"", argstr, "\"");
  this:announce(player.name, " ", $gender_utils:get_conj("says", player), ", \"", argstr, "\"");
except (ANY)
  "Don't really need to do anything but ignore the idiot who has a bad :tell";
endtry
.

@verb #3:"emote" any any any rxd
@program #3:emote
if ((argstr != "") && (argstr[1] == ":"))
  this:announce_all(player.name, argstr[2..length(argstr)]);
else
  this:announce_all(player.name, " ", argstr);
endif
.

@verb #3:"announce" this none this
@program #3:announce
for dude in (setremove(this:contents(), player))
  try
    dude:tell(@args);
  except (ANY)
    "Just skip the dude with the bad :tell";
    continue dude;
  endtry
endfor
.

@verb #3:"match_exit" this none this
@program #3:match_exit
what = args[1];
if (what)
  yes = $failed_match;
  for e in (this.exits)
    if (valid(e) && (what in {e.name, @e.aliases}))
      if (yes == $failed_match)
        yes = e;
      elseif (yes != e)
        return $ambiguous_match;
      endif
    endif
  endfor
  return yes;
else
  return $nothing;
endif
.

@verb #3:"add_exit" this none this
@program #3:add_exit
set_task_perms(caller_perms());
return `this.exits = setadd(this.exits, args[1]) ! E_PERM' != E_PERM;
.

@verb #3:"tell_contents" this none this
@program #3:tell_contents
{contents, ctype} = args;
if ((!this.dark) && (contents != {}))
  if (ctype == 0)
    player:tell("Contents:");
    for thing in (contents)
      player:tell("  ", thing:title());
    endfor
  elseif (ctype == 1)
    for thing in (contents)
      if (is_player(thing))
        player:tell($string_Utils:pronoun_sub("%n ", $gender_utils:get_conj("is", thing), " here.", thing));
      else
        player:tell("You see ", thing:title(), " here.");
      endif
    endfor
  elseif (ctype == 2)
    player:tell("You see ", $string_utils:title_list(contents), " here.");
  elseif (ctype == 3)
    players = things = {};
    for x in (contents)
      if (is_player(x))
        players = {@players, x};
      else
        things = {@things, x};
      endif
    endfor
    if (things)
      player:tell("You see ", $string_utils:title_list(things), " here.");
    endif
    if (players)
      player:tell($string_utils:title_listc(players), (length(players) == 1) ? " " + $gender_utils:get_conj("is", players[1]) | " are", " here.");
    endif
  endif
endif
.

@verb #3:"@exits" none none none rxd
@program #3:@exits
if (!$perm_utils:controls(valid(caller_perms()) ? caller_perms() | player, this))
  player:tell("Sorry, only the owner of a room may list its exits.");
elseif (this.exits == {})
  player:tell("This room has no conventional exits.");
else
  try
    for exit in (this.exits)
      try
        player:tell(exit.name, " (", exit, ") leads to ", valid(exit.dest) ? exit.dest.name | "???", " (", exit.dest, ") via {", $string_utils:from_list(exit.aliases, ", "), "}.");
      except (ANY)
        player:tell("Bad exit or missing .dest property:  ", $string_utils:nn(exit));
        continue exit;
      endtry
    endfor
  except (E_TYPE)
    player:tell("Bad .exits property. This should be a list of exit objects. Please fix this.");
  endtry
endif
.

@verb #3:"look_self" this none this
@program #3:look_self
{?brief = 0} = args;
player:tell(this:title());
if (!brief)
  pass();
endif
this:tell_contents(setremove(this:contents(), player), this.ctype);
.

@verb #3:"acceptable" this none this
@program #3:acceptable
what = args[1];
return this:is_unlocked_for(what) && (((this:free_entry(@args) || ((what == this.blessed_object) && (task_id() == this.blessed_task))) || (what.owner == this.owner)) || ((typeof(this.residents) == LIST) && (what in this.residents)));
.

@verb #3:"add_entrance" this none this
@program #3:add_entrance
set_task_perms(caller_perms());
return `this.entrances = setadd(this.entrances, args[1]) ! E_PERM' != E_PERM;
.

@verb #3:"bless_for_entry" this none this
@program #3:bless_for_entry
if (caller in {@this.entrances, this})
  this.blessed_object = args[1];
  this.blessed_task = task_id();
endif
.

@verb #3:"@entrances" none none none
@program #3:@entrances
if (!$perm_utils:controls(valid(caller_perms()) ? caller_perms() | player, this))
  player:tell("Sorry, only the owner of a room may list its entrances.");
elseif (this.entrances == {})
  player:tell("This room has no conventional entrances.");
else
  try
    for exit in (this.entrances)
      try
        player:tell(exit.name, " (", exit, ") comes from ", valid(exit.source) ? exit.source.name | "???", " (", exit.source, ") via {", $string_utils:from_list(exit.aliases, ", "), "}.");
      except (ANY)
        player:tell("Bad entrance object or missing .source property: ", $string_utils:nn(exit));
        continue exit;
      endtry
    endfor
  except (E_TYPE)
    player:tell("Bad .entrances property. This should be a list of exit objects. Please fix this.");
  endtry
endif
.

@verb #3:"go" any any any rxd
@program #3:go
if ((!args) || (!(dir = args[1])))
  player:tell("You need to specify a direction.");
  return E_INVARG;
elseif (valid(exit = player.location:match_exit(dir)))
  exit:invoke();
  if (length(args) > 1)
    old_room = player.location;
    "Now give objects in the room we just entered a chance to act.";
    suspend(0);
    if (player.location == old_room)
      "player didn't move or get moved while we were suspended";
      player.location:go(@listdelete(args, 1));
    endif
  endif
elseif (exit == $failed_match)
  player:tell("You can't go that way (", dir, ").");
else
  player:tell("I don't know which direction `", dir, "' you mean.");
endif
.

@verb #3:"l*ook ls" any any any rxd
@program #3:look
if ((dobjstr == "") && (!prepstr))
  this:look_self();
elseif ((prepstr != "in") && (prepstr != "on"))
  if ((!dobjstr) && (prepstr == "at"))
    dobjstr = iobjstr;
    iobjstr = "";
  else
    dobjstr = dobjstr + (prepstr && ((dobjstr && " ") + prepstr));
    dobjstr = dobjstr + (iobjstr && ((dobjstr && " ") + iobjstr));
  endif
  dobj = this:match_object(dobjstr);
  if (!$command_utils:object_match_failed(dobj, dobjstr))
    dobj:look_self();
  endif
elseif (!iobjstr)
  player:tell(verb, " ", prepstr, " what?");
else
  iobj = this:match_object(iobjstr);
  if (!$command_utils:object_match_failed(iobj, iobjstr))
    if (dobjstr == "")
      iobj:look_self();
    elseif ((thing = iobj:match(dobjstr)) == $failed_match)
      player:tell("I don't see any \"", dobjstr, "\" ", prepstr, " ", iobj.name, ".");
    elseif (thing == $ambiguous_match)
      player:tell("There are several things ", prepstr, " ", iobj.name, " one might call \"", dobjstr, "\".");
    else
      thing:look_self();
    endif
  endif
endif
.

@verb #3:"announce_all" this none this
@program #3:announce_all
for dude in (this:contents())
  try
    dude:tell(@args);
  except (ANY)
    "Just ignore the dude with the stupid :tell";
    continue dude;
  endtry
endfor
.

@verb #3:"announce_all_but" this none this
@program #3:announce_all_but
":announce_all_but(LIST objects to ignore, text)";
{ignore, @text} = args;
contents = this:contents();
for l in (ignore)
  contents = setremove(contents, l);
endfor
for listener in (contents)
  try
    listener:tell(@text);
  except (ANY)
    "Ignure listener with bad :tell";
    continue listener;
  endtry
endfor
.

@verb #3:"enterfunc" this none this
@program #3:enterfunc
"enterfunc(object OBJ) -> none";
"Clean up after this:bless_for_entry on $exit tasks.";
"Modified so the output of this:look_self is redirected to $no_one";
"on web calls instead of to the player's text window.";
object = args[1];
if ((valid(object) && is_player(object)) && (object.location == this))
  "Since look_self directs output to player:tell, which is redundant";
  "for a web call, direct the output to $no_one.  The viewer and";
  "object:more_info_for_web should deal with any special information the";
  "user needs besides the object's description.";
  if ($web_utils:is_webcall())
    conn = player;
    player = $no_one;
    this:look_self(object.brief);
    player = conn;
  else
    player = object;
    this:look_self(player.brief);
  endif
endif
if (object == this.blessed_object)
  this.blessed_object = #-1;
endif
.

@verb #3:"exitfunc" this none this
@program #3:exitfunc
return;
.

@verb #3:"remove_exit" this none this
@program #3:remove_exit
exit = args[1];
if (caller != exit)
  set_task_perms(caller_perms());
endif
return `this.exits = setremove(this.exits, exit) ! E_PERM' != E_PERM;
.

@verb #3:"remove_entrance" this none this
@program #3:remove_entrance
exit = args[1];
if (caller != exit)
  set_task_perms(caller_perms());
endif
return `this.entrances = setremove(this.entrances, exit) ! E_PERM' != E_PERM;
.

@verb #3:"@add-exit" any none none
@program #3:@add-exit
set_task_perms(player);
if (!dobjstr)
  player:tell("Usage:  @add-exit <exit-number>");
  return;
endif
exit = this:match_object(dobjstr);
if ($command_utils:object_match_failed(exit, dobjstr))
  return;
endif
if (!($exit in $object_utils:ancestors(exit)))
  player:tell("That doesn't look like an exit object to me...");
  return;
endif
try
  dest = exit.dest;
except (E_PERM)
  player:tell("You can't read the exit's destination to check that it's consistent!");
  return;
endtry
try
  source = exit.source;
except (E_PERM)
  player:tell("You can't read that exit's source to check that it's consistent!");
  return;
endtry
if (source != this)
  player:tell("That exit wasn't made to be attached here; it was made as an exit from ", source.name, " (", source, ").");
  return;
elseif (((typeof(dest) != OBJ) || (!valid(dest))) || (!($room in $object_utils:ancestors(dest))))
  player:tell("That exit doesn't lead to a room!");
  return;
endif
if (!this:add_exit(exit))
  player:tell("Sorry, but you must not have permission to add exits to this room.");
else
  player:tell("You have added ", exit, " as an exit that goes to ", exit.dest.name, " (", exit.dest, ") via ", $string_utils:english_list(setadd(exit.aliases, exit.name)), ".");
endif
.

@verb #3:"@add-entrance" any none none
@program #3:@add-entrance
set_task_perms(player);
if (!dobjstr)
  player:tell("Usage:  @add-entrance <exit-number>");
  return;
endif
exit = this:match_object(dobjstr);
if ($command_utils:object_match_failed(exit, dobjstr))
  return;
endif
if (!($exit in $object_utils:ancestors(exit)))
  player:tell("That doesn't look like an exit object to me...");
  return;
endif
try
  dest = exit.dest;
except (E_PERM)
  player:tell("You can't read the exit's destination to check that it's consistent!");
  return;
endtry
if (dest != this)
  player:tell("That exit doesn't lead here!");
  return;
endif
if (!this:add_entrance(exit))
  player:tell("Sorry, but you must not have permission to add entrances to this room.");
else
  player:tell("You have added ", exit, " as an entrance that gets here via ", $string_utils:english_list(setadd(exit.aliases, exit.name)), ".");
endif
.

@verb #3:"recycle" this none this
@program #3:recycle
"Make a mild attempt to keep people and objects from ending up in #-1 when people recycle a room";
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  "... first try spilling them out onto the floor of enclosing room if any";
  if (valid(this.location))
    for x in (this.contents)
      try
        x:moveto(this.location);
      except (ANY)
        continue x;
      endtry
    endfor
  endif
  "... try sending them home...";
  for x in (this.contents)
    if (is_player(x))
      if ((typeof(x.home) == OBJ) && valid(x.home))
        try
          x:moveto(x.home);
        except (ANY)
          continue x;
        endtry
      endif
      if (x.location == this)
        move(x, $player_start);
      endif
    elseif (valid(x.owner))
      try
        x:moveto(x.owner);
      except (ANY)
        continue x;
      endtry
    endif
  endfor
  pass(@args);
else
  return E_PERM;
endif
.

@verb #3:"e east w west s south n north ne northeast nw northwest se southeast sw southwest u up d down" none none none rxd
@program #3:e
set_task_perms((caller_perms() == #-1) ? player | caller_perms());
exit = this:match_exit(verb);
if (valid(exit))
  exit:invoke();
elseif (exit == $failed_match)
  player:tell("You can't go that way.");
else
  player:tell("I don't know which direction `", verb, "' you mean.");
endif
.

@verb #3:"@eject @eject! @eject!!" any none none
@program #3:@eject
set_task_perms(player);
if ($command_utils:object_match_failed(dobj, dobjstr))
  return;
elseif (dobj.location != this)
  is = $gender_utils:get_conj("is", dobj);
  player:tell(dobj.name, "(", dobj, ") ", is, " not here.");
  return;
elseif (!$perm_utils:controls(player, this))
  player:tell("You are not the owner of this room.");
  return;
elseif (dobj.wizard)
  player:tell("Sorry, you can't ", verb, " a wizard.");
  dobj:tell(player.name, " tried to ", verb, " you.");
  return;
endif
iobj = this;
player:tell(this:ejection_msg());
this:((verb == "@eject") ? "eject" | "eject_basic")(dobj);
if (verb != "@eject!!")
  dobj:tell(this:victim_ejection_msg());
endif
this:announce_all_but({player, dobj}, this:oejection_msg());
.

@verb #3:"ejection_msg oejection_msg victim_ejection_msg" this none this rxd #36
@program #3:ejection_msg
return $gender_utils:pronoun_sub(this.(verb));
.

@verb #3:"accept_for_abode" this none this
@program #3:accept_for_abode
who = args[1];
return (valid(who) && ((this.free_home || $perm_utils:controls(who, this)) || ((typeof(residents = this.residents) == LIST) ? who in this.residents | (who == this.residents)))) && this:acceptable(who);
.

@verb #3:"@resident*s" any none none
@program #3:@residents
if (!$perm_utils:controls(player, this))
  player:tell("You must own this room to manipulate the legal residents list.  Try contacting ", this.owner.name, ".");
else
  if (typeof(this.residents) != LIST)
    this.residents = {this.residents};
  endif
  if (!dobjstr)
    "First, remove !valid objects from this room...";
    for x in (this.residents)
      if ((typeof(x) != OBJ) || (!valid(x)))
        player:tell("Warning: removing ", x, ", an invalid object, from the residents list.");
        this.residents = setremove(this.residents, x);
      endif
    endfor
    player:tell("Allowable residents in this room:  ", $string_utils:english_list($list_utils:map_prop(this.residents, "name"), "no one"), ".");
    return;
  elseif (dobjstr[1] == "!")
    notflag = 1;
    dobjstr = dobjstr[2..$];
  else
    notflag = 0;
  endif
  result = $string_utils:match_player_or_object(dobjstr);
  if (!result)
    return;
  else
    "a one element list was returned to us if it won.";
    result = result[1];
    if (notflag)
      if (!(result in this.residents))
        player:tell(result.name, " doesn't appear to be in the residents list of ", this.name, ".");
      else
        this.residents = setremove(this.residents, result);
        player:tell(result.name, " removed from the residents list of ", this.name, ".");
      endif
    else
      if (result in this.residents)
        is = $gender_utils:get_conj("is", result);
        player:tell(result.name, " ", is, " already an allowed resident of ", this.name, ".");
      else
        this.residents = {@this.residents, result};
        player:tell(result.name, " added to the residents list of ", this.name, ".");
      endif
    endif
  endif
endif
.

@verb #3:"match" this none this
@program #3:match
target = {@this:contents(), @this:exits()};
return $string_utils:match(args[1], target, "name", target, "aliases");
.

@verb #3:"@remove-exit" any none none
@program #3:@remove-exit
set_task_perms(player);
if (!dobjstr)
  player:tell("Usage:  @remove-exit <exit>");
  return;
endif
exit = this:match_object(dobjstr);
if (!(exit in this.exits))
  if ($command_utils:object_match_failed(exit, dobjstr))
    return;
  endif
  player:tell("Couldn't find \"", dobjstr, "\" in the exits list of ", this.name, ".");
  return;
elseif (!this:remove_exit(exit))
  player:tell("Sorry, but you do not have permission to remove exits from this room.");
else
  name = valid(exit) ? exit.name | "<recycled>";
  player:tell("Exit ", exit, " (", name, ") removed from exit list of ", this.name, " (", this, ").");
endif
.

@verb #3:"@remove-entrance" any none none
@program #3:@remove-entrance
set_task_perms(player);
if (!dobjstr)
  player:tell("Usage:  @remove-entrance <entrance>");
  return;
endif
entrance = $string_utils:match(dobjstr, this.entrances, "name", this.entrances, "aliases");
if (!valid(entrance))
  "Try again to parse it.  Maybe they gave object number.  Don't complain if it's invalid though; maybe it's been recycled in some nefarious way.";
  entrance = this:match_object(dobjstr);
endif
if (!(entrance in this.entrances))
  player:tell("Couldn't find \"", dobjstr, "\" in the entrances list of ", this.name, ".");
  return;
elseif (!this:remove_entrance(entrance))
  player:tell("Sorry, but you do not have permission to remove entrances from this room.");
else
  name = valid(entrance) ? entrance.name | "<recycled>";
  player:tell("Entrance ", entrance, " (", name, ") removed from entrance list of ", this.name, " (", this, ").");
endif
.

@verb #3:"moveto" this none this
@program #3:moveto
if ((caller in {this, this.owner}) || $perm_utils:controls(caller_perms(), this))
  return pass(@args);
else
  return E_PERM;
endif
.

@verb #3:"who_location_msg" this none this
@program #3:who_location_msg
return (msg = `this.(verb) ! ANY') ? $string_utils:pronoun_sub(msg, args[1]) | "";
.

@verb #3:"exits entrances" this none this
@program #3:exits
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  return this.(verb);
else
  return E_PERM;
endif
.

@verb #3:"obvious_exits obvious_entrances" this none this
@program #3:obvious_exits
exits = {};
for exit in (`(verb == "obvious_exits") ? this.exits | this.entrances ! ANY => {}')
  if (`exit.obvious ! ANY')
    exits = setadd(exits, exit);
  endif
endfor
return exits;
.

@verb #3:"here_huh" this none this
@program #3:here_huh
":here_huh(verb,args)  -- room-specific :huh processing.  This should return 1 if it finds something interesting to do and 0 otherwise; see $command_utils:do_huh.";
"For the generic room, we check for the case of the caller specifying an exit for which a corresponding verb was never defined.";
set_task_perms(caller_perms());
if (args[2] || ($failed_match == (exit = this:match_exit(verb = args[1]))))
  "... okay, it's not an exit.  we give up...";
  return 0;
elseif (valid(exit))
  exit:invoke();
else
  "... ambiguous exit ...";
  player:tell("I don't know which direction `", verb, "' you mean.");
endif
return 1;
.

@verb #3:"room_announce*_all_but" this none this
@program #3:room_announce_all_but
this:(verb[6..$])(@args);
.

@verb #3:"examine_commands_ok" this none this
@program #3:examine_commands_ok
return this == args[1].location;
.

@verb #3:"examine_key" this none this
@program #3:examine_key
"examine_key(examiner)";
"return a list of strings to be told to the player, indicating what the key on this type of object means, and what this object's key is set to.";
"the default will only tell the key to a wizard or this object's owner.";
who = args[1];
if (((caller == this) && $perm_utils:controls(who, this)) && (this.key != 0))
  return {tostr(this:title(), " will accept only objects matching the following key:"), tostr("  ", $lock_utils:unparse_key(this.key))};
endif
.

@verb #3:"examine_contents" this none this
@program #3:examine_contents
"examine_contents(who)";
if (caller == this)
  this:tell_contents(this.contents, this.ctype);
endif
.

@verb #3:"free_entry" this none this rxd #36
@program #3:free_entry
return this.free_entry;
.

@verb #3:"dark" this none this
@program #3:dark
return this.(verb);
.

@verb #3:"tell_contents_for_web" this none this rx #95
@program #3:tell_contents_for_web
"tell_contents_for_web(contents LIST [, ctype NUM]) -> html text frg LIST";
"Generate HTML text showing room's contents, including people and things.";
"(note: ctype hasn't been implemented yet)";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
contents = args[1];
ctype = args[2] || 0;
text = {};
code = $web_utils:get_webcode();
eol = "<P>";
people = things = {};
for item in (contents)
  if (is_player(item))
    people = {@people, item};
  else
    things = {@things, item};
  endif
endfor
if (this.dark)
  "this section only applies to rooms with a .dark property set";
  if (people || things)
    text = {@text, tostr(things ? "There seem to be some objects about, but it's too dark to make them out." | "", people ? (things ? " " | "") + "In the darkness, you hear the faint sound of breathing." | "", eol)};
  else
    text = {@text, "The room is too dark to see much here." + eol};
  endif
else
  if (things)
    text = {@text, tostr("You see ", $web_utils:english_list_with_urls(player, code, things), "." + eol)};
  endif
  if (!$object_utils:isa(this, $generic_editor))
    "Tell who else is here, unless player's in an editor";
    stuff = $web_utils:list_english_list_with_urls(player, code, people, "nobody else");
    text = {@text, length(people) ? "<B>" | "", tostr($string_utils:capitalize(stuff[1]), @stuff[2..length(stuff)], length(people) ? "</B>" | "", (length(people) > 1) ? " are here." | " is here.", eol)};
  endif
endif
return text;
"Last modified Mon Apr 29 06:34:01 1996 IDT by EricM (#3264).";
.

@verb #3:"get_vrml" this none this rxd #95
@program #3:get_vrml
"get_vrml(who, rest STR, search STR) -> VRML nodes LIST";
"Put together all the VRML nodes for this room, including those defining the room itself";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
{?who = player, ?rest, ?search, @strays} = args;
vrml = {};
cameras = {"DEF cameras Switch {", "  whichChild 0"};
exits = this:exits();
set_task_perms(caller_perms());
if ((caller == $std_vrml10viewer) && (!(($object_utils:isoneof(this, $web_utils.interior_rooms) && valid(where = who.location)) && (where != this))))
  "--add the room's desc";
  if (!(vrml_desc = this:get_vrml_interior_desc(@args)))
    vrml_desc = {"# room should be arrayed so that the floor is about 1.5 meters below the origin plane", "# objects at the origin should be at chest level or so", "Material { diffuseColor .5 .5 .5 } Translation { translation 0 -1.25 0 } Cube { width 10 height 0.1 depth 10 }"};
  endif
  "--add node for the room itself";
  vrml = {@vrml, tostr("Separator { # Room object ", this, "@", $network.MOO_name), @vrml_desc, "}"};
  "--add node for each object in the room's contents list";
  for item in ({@this:contents(), @exits})
    $command_utils:suspend_if_needed(1);
    vrml = {@vrml, tostr("Separator { # Object ", item, "@", $network.MOO_name)};
    vrml = {@vrml, @item:get_vrml(@args), "}"};
    if ($object_utils:isa(item, $player))
      "--add a camera if 'player' is in the room";
      item_name = $string_utils:substitute(item.name, {{" ", "_"}, {"{", "_"}, {"}", "_"}, {"#", "_"}, {"\"", "_"}});
      "the `+1000' is to move the cameras back a bit";
      a = $list_utils:arrayset(a = item:get_vrml_translation(), a[3] + 1000, 3);
      "+250 to bring the camera to head height";
      a = $list_utils:arrayset(a, a[2] + 500, 2);
      camera = {tostr("DEF ", item_name, "_camera Separator {"), tostr("Transform { translation ", $vrml_utils:make_SFVec3f(a), " }")};
      " was { position 0 .75 -.5 }";
      camera = {@camera, "PerspectiveCamera { position 0 1.0 -.5 }"};
      camera = {@camera, "}"};
      cameras = {@cameras, @camera};
    endif
  endfor
  "add the cameras and close the Switch node";
  vrml = {@cameras, " }", @vrml};
  if ($set_utils:intersection($object_utils:ancestors(this), $web_utils.interior_rooms) && $object_utils:isa(this.location, $room))
    "--add link to exterior room";
    vrml = {@vrml, "DEF outlink Separator {", tostr(" WWWAnchor { description \"Out to ", this.location:name(1), "\" name \"&LOCAL_LINK;/", $web_utils:get_webcode(), "/", tonum(this.location), "/moveto/room.wrl\"")};
    linkzone = (typeof(linkzone = this:get_vrml_setting("linkzone") || $vrml_utils.std_linkzone) == STR) ? {linkzone} | linkzone;
    vrml = {@vrml, @linkzone, @$vrml_utils.std_outlink};
    "--close the WWWAnchor and the whole Separator";
    vrml = {@vrml, " }", "}"};
  endif
  "--add lights";
  if (!(lights = this:get_vrml_setting("lights")))
    lights = $vrml_utils.std_roomlights;
  endif
  vrml = {@(typeof(lights) == STR) ? {lights} | lights, "", @vrml};
  "add hint for walking";
  vrml = {"DEF Viewer Info{", "string \"walk\"", "}", @vrml};
else
  vrml = pass(@args);
endif
return vrml;
"Last modified Tue Oct  1 03:36:20 1996 IST by EricM (#3264).";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
.

@verb #3:"get_vrml_interior_desc set_vrml_interior_desc" this none this rxd #95
@program #3:get_vrml_interior_desc
"get_vrml_interior_desc(none) -> vrml file frg LIST";
"set_vrml_interior_desc(desc LIST) -> resulting value LIST";
"get or set the interior VRML description for an room; the VRML node that describes it";
"to someone standing INSIDE it";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (verb[1..3] == "set")
  desc = args[1];
  if (!((caller == this) || $perm_utils:controls(caller_perms(), this)))
    return E_PERM;
  elseif (typeof(desc) != LIST)
    return E_INVARG;
    "reject most obviously bad values";
  endif
  this.vrml_interior_desc = desc;
endif
if (link = this:get_vrml_hyperlink(@args))
  "add the object's associated hyperlink, if any";
  return {@link, @this.vrml_interior_desc, " }"};
endif
return this.vrml_interior_desc;
"Last modified Thu Nov 23 02:43:06 1995 IST by EricM (#3264).";
.

@verb #3:"reconfunc" this none this
@program #3:reconfunc
this:look_self(player.brief);
this:announce(player.name + " reconnects.");
.

"***finished***
