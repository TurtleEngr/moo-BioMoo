$Header: /repo/public.cvs/app/BioGate/BioMooCore/core121.moo,v 1.1 2021/07/27 06:44:27 bruce Exp $

>@dump #121 with create
@create $orig_interior_room named generic portable room:generic portable room,gpr
@prop #121."visible_props" {} ""
;;#121.("visible_props") = {"move_ok"}
@prop #121."move_ok" {} ""
@prop #121."motile" 1 rc
@prop #121."silent_actions" {} ""
@prop #121."outside_msg" "outside" rc
@prop #121."listen" "on" r
@prop #121."teleport_outside_msg" "" rc
@prop #121."oteleport_outside_msg" "" rc
@prop #121."leave_outside_msg" "" rc
@prop #121."arrive_outside_msg" "" rc
@prop #121."oarrive_succeeded_msg" "" rc
@prop #121."arrive_succeeded_msg" "" rc
@prop #121."oleave_failed_msg" "" rc
@prop #121."leave_failed_msg" "" rc
@prop #121."oleave_succeeded_msg" "" rc
@prop #121."leave_succeeded_msg" "" rc
@prop #121."oarrive_failed_msg" "" rc
@prop #121."arrive_failed_msg" "" rc
@prop #121."odrop_failed_msg" "" rc
@prop #121."drop_failed_msg" "" rc
@prop #121."odrop_succeeded_msg" "" rc
@prop #121."drop_succeeded_msg" "" rc
@prop #121."teleport_msg" "" rc
@prop #121."accept_key" 0 ""
@prop #121."otake_failed_msg" "" rc
@prop #121."take_failed_msg" "" rc
@prop #121."take_succeeded_msg" "" rc
@prop #121."otake_succeeded_msg" "" rc
@prop #121."$nothing_msg" "Nothing undescribable in twenty words or less contemplates enlightenment." r
;;#121.("inside_description") = "This is the interior of the generic portable room."
;;#121.("aliases") = {"generic portable room", "gpr"}
;;#121.("description") = "This is a generic portable room. It is most unassuming."
;;#121.("object_size") = {0, 0}

@verb #121:"l*ook" any any any rxd
@program #121:look
name = this:outside_msg();
if (((!prepstr) && (dobj == $failed_match)) && index(name, dobjstr))
  this:look_outside();
else
  pass(@args);
endif
.

@verb #121:"location" this none this
@program #121:location
if (!valid(this.location))
  return $nothing;
elseif (is_player(this.location))
  return this.location.location;
else
  return this.location;
endif
.

@verb #121:"enter" this none none rxd #2
@program #121:enter
set_task_perms((caller_perms() == #-1) ? player | caller_perms());
loc = player.location;
if (loc == this)
  player:tell("You're already inside ", this:title(), ".");
else
  if (this:accept(player))
    player:tell(this:arrive_succeeded_msg() || (("You enter " + this:title()) + "."));
    player:moveto(this);
    fail = 0;
  else
    fail = 1;
  endif
  if (player.location != this)
    fail = 1;
  else
    this:announce(player:title() + " ", this:oarrive_succeeded_msg() || "enters.");
    loc:announce_all_but({this}, player:title() + " ", this:arrive_outside_msg() || (("disappears into " + this:title()) + "."));
  endif
  if (fail)
    player:tell(this:arrive_failed_msg() || (("Unfortunately, " + this:title()) + " doesn't let you enter."));
    if (omsg = this:oarrive_failed_msg())
      loc:announce(player:title(), " ", omsg);
    endif
  endif
endif
.

@verb #121:"g*et t*ake" this none none rxd
@program #121:get
if (this.location == player)
  player:tell("You already have that!");
elseif (this.location != player.location)
  player:tell("I don't see that here.");
else
  this:moveto(player);
  if (this.location == player)
    player:tell(this:take_succeeded_msg() || "Taken.");
    player.location:announce(player.name, " ", this:otake_succeeded_msg() || tostr("picks up ", this.name, "."));
  else
    player:tell(this:take_failed_msg() || "You can't pick that up.");
    if (msg = this:otake_failed_msg())
      player.location:announce(player.name, " ", msg);
    endif
  endif
endif
.

@verb #121:"d*rop th*row" this none none rxd
@program #121:drop
if (this.location != player)
  player:tell("You don't have that.");
elseif (!player.location:accept(this))
  player:tell("You can't drop that here.");
else
  this:moveto(player.location);
  if (this.location == player.location)
    player:tell(this:drop_succeeded_msg() || "Dropped.");
    player.location:announce(player.name, " ", this:odrop_succeeded_msg() || (("drops " + this.name) + "."));
  else
    player:tell(this:drop_failed_msg() || "You can't seem to drop that here.");
    player.location:announce(player.name, " ", this:odrop_failed_msg() || (("tries to drop " + this.name) + " but fails!"));
  endif
endif
.

@verb #121:"take_succeeded_msg otake_succeeded_msg take_failed_msg otake_failed_msg drop_succeeded_msg odrop_succeeded_msg drop_failed_msg odrop_failed_msg arrive_outside_msg leave_outside_msg arrive_succeeded_msg oarrive_succeeded_msg arrive_failed_msg oarrive_failed_msg leave_succeeded_msg oleave_succeeded_msg leave_failed_msg oleave_failed_msg teleport_outside_msg oteleport_outside_msg teleport_msg" this none this rx
@program #121:take_succeeded_msg
"_msg(conversion strings): converts messages into amenable formats";
"conversion strings should be of the form '{str1,val1},{str2,val2}'";
string = this.(verb);
location = args ? args[1] | this.location;
return $string_utils:pronoun_sub(string, player, this, location);
.

@verb #121:"moveto" this none this
@program #121:moveto
to = args[1];
from = this.location;
if ((((!valid(to)) || this:is_unlocked_for(to)) && this:move_ok()) && (typeof(pass(to)) != ERR))
  this:announce_move(from, to);
endif
.

@verb #121:"is_unlocked_for" this none this
@program #121:is_unlocked_for
if (callers()[1][2] == "acceptable")
  return (this.accept_key == 0) || $lock_utils:eval_key(this.accept_key, args[1]);
else
  return pass(@args);
endif
.

@verb #121:"@lock_entry" this with any rxd
@program #121:@lock_entry
if ($perm_utils:controls(player, this))
  key = $lock_utils:parse_keyexp(iobjstr, player);
  if (typeof(key) == STR)
    player:tell("That key expression is malformed:");
    player:tell("  ", key);
  else
    res = this.accept_key = key;
    if (typeof(res) == ERR)
      player:tell(res, ".");
    else
      player:tell("Locked entrance of ", this.name, " with this key:");
      player:tell("  ", $lock_utils:unparse_key(key));
    endif
  endif
else
  player:tell("Permission denied.");
endif
.

@verb #121:"@unlock_entry" this none none rxd
@program #121:@unlock_entry
if (player == this.owner)
  res = dobj.accept_key = 0;
  if (typeof(res) == ERR)
    player:tell(res, ".");
  else
    player:tell("Unlocked ", dobj.name, " for entrance.");
  endif
else
  player:tell("Permission denied.");
endif
.

@verb #121:"exit leave out" none none none rxd #2
@program #121:exit
set_task_perms((caller_perms() == #-1) ? player | caller_perms());
if ((loc = this:location()) == $nothing)
  player:tell("There's nothing out there.");
  return;
endif
if (player.location == this)
  if (loc:accept(player))
    player:tell(this:leave_succeeded_msg() || "You exit.");
    player:moveto(loc);
    fail = 0;
  else
    fail = 1;
  endif
  if (player.location != loc)
    fail = 1;
  else
    this:announce(player:title() + " ", this:oleave_succeeded_msg() || "vanishes.");
    loc:announce_all_but({this, player}, player:title() + " ", this:leave_outside_msg() || (("appears after exiting " + this:title()) + "."));
  endif
  if (fail)
    player:tell(this:leave_failed_msg() || "You can't seem to leave.");
    if (msg = this:oleave_failed_msg())
      this:announce(player:title() + " ", msg);
    endif
  endif
else
  player:tell("You're not in ", this:title(), ".");
endif
.

@verb #121:"look_outside" this none this
@program #121:look_outside
"Definition from #6145";
if (args)
  player = args[1];
endif
player:tell($string_utils:capitalize(this:outside_msg() + " "), this.name, ", you see:");
player:tell("");
where = this.location;
if (where == $nothing)
  player:tell(this:("$nothing_msg")());
  return;
endif
if ((loc = this:location()) != where)
  player:tell(where:title(), " holding ", this:title(), " in...");
endif
"this is totally bogus. reassigning player should work!";
"#4290:tell(\"calling :look_self with player=\",player)";
"loc:look_self()";
if (args)
  player:tell_lines(where:title());
  player:tell_lines(where:description());
else
  loc:look_self();
endif
.

@verb #121:"announce_move" this none this
@program #121:announce_move
"announce_move(from,to): does general announcements when the generic";
"portable room moves.";
from = args[1];
to = args[2];
this:announce_all(this:teleport_msg() || (this:title() + " moves."));
if (room = $object_utils:isa(to, $room))
  for person in (this.contents)
    if (is_player(person))
      this:look_outside(person);
    endif
  endfor
endif
if (!(callers()[2][2] in this.silent_actions))
  speak = $object_utils:isa(from, $room) ? "announce_all" | "tell";
  if (msg = this:teleport_outside_msg(from))
    from:(speak)(msg);
  endif
  speak = room ? "announce_all" | "tell";
  if (msg = this:oteleport_outside_msg(to))
    msg = index(msg, this.name) ? msg | ((this:title() + " ") + msg);
    to:(speak)(msg);
  endif
endif
.

@verb #121:"yell" any any any rxd
@program #121:yell
"yell -- yells a message to the outside world.";
stuff = "";
if (player.location == this)
  if (this.location == $nothing)
    stuff = "For some reason, nobody outside seems to hear.";
  else
    this.location:announce_all_but({this}, player:title(), " yells from inside ", this:title(), ", \"", argstr, "\"");
  endif
  player:tell("You yell, \"", argstr, "\"");
  this:announce(player:title(), " yells, \"", argstr, "\"");
  if (stuff)
    this:announce_all(stuff);
  endif
endif
.

@verb #121:"@listen" any any any rxd
@program #121:@listen
"@listen -- enables the portable room to hear the outside environment.";
"possible arguments: \"on\" or \"off\"";
choices = {"on", "off"};
if (!argstr)
  player:tell("listen is currently ", this.listen, ".");
  return;
endif
if (!(argstr in choices))
  player:tell("Usage: @listen on|off");
else
  this.listen = argstr;
  player:tell("listen is now ", this.listen, ".");
endif
.

@verb #121:"tell" this none this
@program #121:tell
if (this.listen != "off")
  this:announce_all("Outside: ", tostr(@args));
endif
.

@verb #121:"outside_msg" this none this
@program #121:outside_msg
return this.(verb);
.

@verb #121:"journey" any none none rxd
@program #121:journey
if (!args)
  player:tell("Usage: move/go <direction>");
elseif (!$object_utils:isa(this.location, $room))
  player:tell(this:title(), " isn't in a room!");
else
  exit = this.location:match_exit(args[1]);
  if (exit == $failed_match)
    player:tell("I don't understand that.");
  elseif (exit == $ambiguous_match)
    player:tell("I don't know which direction you mean.");
  elseif ($object_utils:has_verb(exit, "move"))
    exit:move(this);
  else
    player:tell("That's an unusual direction.");
  endif
endif
.

@verb #121:"move_ok" this none this
@program #121:move_ok
"okay to move if .motile != 0 or player is in a verified list";
if (this.motile)
  return 1;
endif
movable = {this.owner, @this.move_ok};
if (valid(this.location))
  movable = {this.location.owner, @movable};
endif
if (player in movable)
  return 1;
else
  return 0;
endif
.

@verb #121:"@move_ok" any any any rxd
@program #121:@move_ok
"add players to the .move_ok list";
if (!this:secure(player))
  player:tell("You can't do that.");
  return;
endif
if (dobjstr == "list")
  this:(dobjstr + "_prop")(verb[2..length(verb)]);
elseif ((length(args) == 2) && (args[1] in {"add", "delete"}))
  if (((personobj = toobj(args[2])) > #0) || ((personobj = this:match(args[2])) >= $player))
    this:(args[1] + "_prop")(verb[2..length(verb)], personobj);
  else
    player:tell(args[2], " wasn't matched.");
  endif
else
  player:tell("Usage: @move_ok add|delete|list <player>");
endif
.

@verb #121:"add_prop" this none this
@program #121:add_prop
if (this:secure() && (args[1] in this.visible_props))
  this.(args[1]) = setadd(this.(args[1]), args[2]);
  player:tell(args[2], " added to .", args[1], " property.");
endif
.

@verb #121:"delete_prop" this none this
@program #121:delete_prop
if (this:secure() && (args[1] in this.visible_props))
  this.(args[1]) = setremove(this.(args[1]), args[2]);
  player:tell(args[2], " deleted from .", args[1]);
  return 1;
endif
.

@verb #121:"list_prop" this none this
@program #121:list_prop
if (this:secure() && (args[1] in this.visible_props))
  player:tell(args[1], ": ", $string_utils:print(this.(args[1])));
  return 1;
endif
.

@verb #121:"secure" this none this
@program #121:secure
if (player == this.owner)
  return 1;
else
  return 0;
endif
.

@verb #121:"$nothing_msg" this none this
@program #121:$nothing_msg
return $string_utils:pronoun_sub(this.("$nothing_msg"));
.

@verb #121:"sweep_msg" this none this
@program #121:sweep_msg
if (!($object_utils:has_callable_verb(this, "tell")[1] in {#6145, #26152, #1150}))
  return 0;
endif
if (this.listen == "off")
  return "is not listening now but could";
endif
note = {};
for x in (this.contents)
  if (is_player(x))
    note = {@note, x.name + ((x in connected_players()) ? " (awake)" | " (asleep)")};
  elseif ($object_utils:has_callable_verb(x, "sweep_msg"))
    note = {@note, ((x.name + " (") + (x:sweep_msg() || "is listening")) + ")"};
  else
    tellwhere = $object_utils:has_verb(x, "tell");
    notewhere = $object_utils:has_verb(x, "notify");
    if ((tellwhere && (!tellwhere[1].owner.wizard)) || (notewhere && (!notewhere[1].owner.wizard)))
      note = {@note, $string_utils:nn(x)};
    endif
  endif
endfor
return note ? "forwards to " + $string_utils:english_list(note) | "contains no listeners now";
.

@verb #121:"go" any any any rxd
@program #121:go
if (args && (args[1] == "out"))
  this:exit();
  if (args = listdelete(args, 1))
    "Now give objects in the room we just passed through a chance to act.";
    suspend(0);
    player.location:go(@args);
  endif
else
  pass(@args);
endif
.

@verb #121:"@about" this none none
@program #121:@about
player:tell("The Generic Portable Room");
player:tell("-------------------------");
player:tell("The generic portable room is a combination of a $thing");
player:tell("and a $room with additional functionality resulting as");
player:tell("a consequence of the merger.");
player:tell();
player:tell("visual verbs:");
player:tell("@describe_inside: describes the inside of the room");
player:tell("@opacity:         toggles viewing the inside from the outside");
player:tell();
player:tell("audio verbs:");
player:tell("yell:             yell a message to the outside");
player:tell("@listen:          toggles listening to the outside from the");
player:tell("                  inside");
player:tell();
player:tell("movement verbs:");
player:tell("enter:            enter the room");
player:tell("exit/leave/out:   exit the room");
player:tell("@lock_entry:      lock entry to the room");
player:tell("@unlock_entry:    unlock entry to the room");
player:tell("journey:          move the room in the given direction");
player:tell("enter:            enter the room.");
player:tell("@move_ok:         control what that can move the room");
.

@verb #121:"html" this none this rx #95
@program #121:html
"Uses 'rest' to determine the webcall's function. Various rest values:";
"  exit or out -> exit the room";
"  enter -> enter the room";
"  any other value -> pass(@args) [look at the room]";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
rest = args[2];
search = args[3];
set_task_perms(caller_perms());
if (rest in {"exit", "out"})
  this:exit(player);
  return $nothing;
elseif (rest == "enter")
  this:enter(player);
  return $nothing;
endif
return pass(@args);
"Last modified Mon Apr  8 05:43:54 1996 IDT by EricM (#3264).";
.

@verb #121:"verbs_for_web" this none this rxd #95
@program #121:verbs_for_web
"verbs_for_web( ) -> HTML doc LIST";
"If player isn't in the room, offer them a hyperlinked 'enter' command.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (player.location != this)
  return {"<P><B>Actions:</B><BR>", ((((("<A HREF=\"&LOCAL_LINK;/" + "view") + "/") + tostr(tonum(this))) + "/enter#focus\">Enter</A> ") + this:name(1)) + "<BR>"};
endif
return {};
"Last modified Sat Aug 12 17:37:01 1995 IDT by EricM (#3264).";
.

@verb #121:"has_url" this none this rxd #95
@program #121:has_url
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return 1;
"Last modified Sun Aug 27 04:48:11 1995 IDT by EricM (#3264).";
.

"***finished***
