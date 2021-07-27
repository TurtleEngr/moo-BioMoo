$Header: /repo/public.cvs/app/BioGate/BioMooCore/core11.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #11 with create
@create $root_class named Player Last_huh Verbs:Player Last_huh Verbs
;;#11.("aliases") = {"Player Last_huh Verbs"}
;;#11.("description") = "A repository of last-resort player verbs to be called by $player:last_huh"
;;#11.("object_size") = {4694, 1577149623}

@verb #11:"@*" this none this
@program #11:@
"{last_huh}  @<msg_name> <object> is [<text>]";
"If <text> is given calls <object>:set_message(<msg_name>,<text>),";
"otherwise prints the value of the specified message property";
set_task_perms(caller_perms());
nargs = length(args);
pos = "is" in args;
if (pos == 1)
  player:notify(tostr("Usage:  ", verb, " <object> is <message>"));
  return;
endif
dobjstr = $string_utils:from_list(args[1..pos - 1], " ");
message = $string_utils:from_list(args[pos + 1..nargs], " ");
msg_name = verb[2..$];
dobj = player:my_match_object(dobjstr);
if ($command_utils:object_match_failed(dobj, dobjstr))
  "... oh well ...";
elseif (pos == nargs)
  if (E_PROPNF == (get = `dobj.(msg_name + "_msg") ! ANY'))
    player:notify(tostr(dobj.name, " (", dobj, ") has no \"", msg_name, "\" message."));
  elseif (typeof(get) == ERR)
    player:notify(tostr(get));
  elseif (!get)
    player:notify("Message is not set.");
  else
    player:notify(tostr("The \"", msg_name, "\" message of ", dobj.name, " (", dobj, "):"));
    player:notify(tostr(get));
  endif
else
  set = dobj:set_message(msg_name, message);
  if (set)
    if (typeof(set) == STR)
      player:notify(set);
    else
      player:notify(tostr("You set the \"", msg_name, "\" message of ", dobj.name, " (", dobj, ")."));
    endif
  elseif (set == E_PROPNF)
    player:notify(tostr(dobj.name, " (", dobj, ") has no \"", msg_name, "\" message to set."));
  elseif (typeof(set) == ERR)
    player:notify(tostr(set));
  else
    player:notify(tostr("You clear the \"", msg_name, "\" message of ", dobj.name, " (", dobj, ")."));
  endif
endif
.

@verb #11:"give hand" this none this
@program #11:give
"{last_huh}  give any to any";
"a give \"verb\" that works for non-$things.";
set_task_perms(caller_perms());
if (((verb == "give") && (dobjstr == "up")) && (!prepstr))
  player:tell("Try this instead: @quit");
elseif (dobj == $nothing)
  player:tell("What do you want to give?");
elseif (iobj == $nothing)
  player:tell("To whom/what do you want to give it?");
elseif ($command_utils:object_match_failed(dobj, dobjstr) || $command_utils:object_match_failed(iobj, iobjstr))
  "...lose...";
elseif (dobj.location != player)
  player:tell("You don't have that!");
elseif (iobj.location != player.location)
  player:tell("I don't see ", iobj.name, " here.");
else
  dobj:moveto(iobj);
  if (dobj.location == iobj)
    player:tell("You give ", dobj:title(), " to ", iobj.name, ".");
    iobj:tell(player.name, " gives you ", dobj:title(), ".");
  else
    player:tell("Either that doesn't want to be given away or ", iobj.name, " doesn't want it.");
  endif
endif
.

@verb #11:"get take" this none this
@program #11:get
"{last_huh}  get/take any";
"a take \"verb\" that works for non-$things.";
set_task_perms(caller_perms());
if (dobj == $nothing)
  player:tell(verb, " what?");
elseif ($command_utils:object_match_failed(dobj, dobjstr))
  "...lose...";
elseif (dobj.location == player)
  player:tell("You already have that!");
elseif (dobj.location != player.location)
  player:tell("I don't see that here.");
else
  dobj:moveto(player);
  if (dobj.location == player)
    player:tell("Taken.");
    player.location:announce(player.name, " takes ", dobj.name, ".");
  else
    player:tell("You can't pick that up.");
  endif
endif
.

@verb #11:"drop throw" this none this
@program #11:drop
"{last_huh}  drop/throw any";
"a drop \"verb\" that works for non-$things.";
set_task_perms(caller_perms());
if (dobj == $nothing)
  player:tell(verb, " what?");
elseif ($command_utils:object_match_failed(dobj, dobjstr))
  "...lose...";
elseif (dobj.location != player)
  player:tell("You don't have that.");
elseif (!player.location:acceptable(dobj))
  player:tell("You can't drop that here.");
else
  dobj:moveto(player.location);
  if (dobj.location == player.location)
    player:tell_lines((verb[1] == "d") ? "Dropped." | "Thrown.");
    player.location:announce(player.name, (verb[1] == "d") ? " dropped " | " threw away ", dobj.name, ".");
  else
    player:tell_lines("You can't seem to drop that here.");
  endif
endif
.

"***finished***
