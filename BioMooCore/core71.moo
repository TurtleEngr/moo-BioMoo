$Header: /repo/public.cvs/app/BioGate/BioMooCore/core71.moo,v 1.1 2021/07/27 06:44:34 bruce Exp $

>@dump #71 with create
@create $prog named housekeeper:housekeeper
@prop #71."recycle_bins" {} rc
@prop #71."owners" {} rc
;;#71.("owners") = {#2}
@prop #71."cleaning" #-1 rc
@prop #71."litter" {} rc
@prop #71."eschews" {} rc
@prop #71."public_places" {} rc
@prop #71."task" 242203005 rc
@prop #71."requestors" {} rc
@prop #71."destination" {} rc
@prop #71."clean" {} r
@prop #71."testing" 0 rc
@prop #71."player_queue" {} r
@prop #71."take_away_msg" "%[tpsc] arrives to cart %n off to bed." rc
@prop #71."drop_off_msg" "%[tpsc] arrives to drop off %n, who is sound asleep." rc
@prop #71."move_player_task" 1065205209 r
@prop #71."moveto_task" 78256513 rc
@prop #71."cleaning_index" 0 rc
;;#71.("respond_to") = {{#-1, 0}, {#177, 896405954}}
;;#71.("mail_forward") = {#2}
;;#71.("owned_objects") = {#71}
;;#71.("linelen") = -80
;;#71.("page_absent_msg") = "The housekeeper is too busy putting away all of the junk all over LambdaMoo that there isn't time to listen to pages and stuff like that so your page isn't listened to, too bad."
;;#71.("pq") = "hers"
;;#71.("pqc") = "Hers"
;;#71.("ownership_quota") = -9993
;;#71.("gender") = "female"
;;#71.("prc") = "'Self"
;;#71.("ppc") = "The housekeeper's"
;;#71.("poc") = "The housekeeper"
;;#71.("psc") = "The housekeeper"
;;#71.("pr") = "'self"
;;#71.("pp") = "the housekeeper's"
;;#71.("po") = "the housekeeper"
;;#71.("ps") = "the housekeeper"
;;#71.("first_connect_time") = 0
;;#71.("size_quota") = {183000, 21165, 938160000, 0}
;;#71.("web_options") = {{"telnet_applet", #110}, "applinkdown", "exitdetails", "map", "embedVRML", "separateVRML"}
;;#71.("aliases") = {"housekeeper"}
;;#71.("description") = "A very clean, neat, tidy person who doesn't mind lugging players and their gear all over the place."
;;#71.("object_size") = {21165, 1577149628}
;;#71.("vrml_desc") = {"WWWInline {name \"http://hppsda.mayfield.hp.com/image/body.wrl\"}", ""}

@verb #71:"look_self" this none this
@program #71:look_self
player:tell_lines(this:description());
player:tell($string_utils:pronoun_sub("%S %<is> moving around from room to room, cleaning up.", this));
.

@verb #71:"cleanup" this none this
@program #71:cleanup
"$housekeeper:cleanup([insist]) => clean up player's objects. Argument is 'up' or 'up!' for manually requested cleanups (notify player differently)";
if (caller_perms() != this)
  return E_PERM;
endif
for object in (this.clean)
  x = object in this.clean;
  if (this.requestors[x] == player)
    if (result = this:replace(object, @args))
      player:tell(result, ".");
    endif
  endif
  $command_utils:suspend_if_needed(0);
endfor
player:tell("The housekeeper has finished cleaning up your objects.");
.

@verb #71:"replace" this none this
@program #71:replace
"replace the object given to its proper spot (if there is one).";
{object, ?insist = 0} = args;
i = object in this.clean;
if (!i)
  return tostr(object, " is not on the ", this.name, "'s cleanup list");
endif
place = this.destination[i];
if (!(($recycler:valid(object) && ($recycler:valid(place) || (place == #-1))) && (!(object.location in this.recycle_bins))))
  "object no longer valid (recycled or something), remove it.";
  this.clean = listdelete(this.clean, i);
  this.requestors = listdelete(this.requestors, i);
  this.destination = listdelete(this.destination, i);
  return tostr(object) + " is no longer valid, removed from cleaning list";
endif
oldloc = loc = object.location;
if (object.location == place)
  "already in its place";
  return "";
endif
requestor = this.requestors[i];
if (insist != "up!")
  if ($code_utils:verb_or_property(object, "in_use"))
    return ("Not returning " + object.name) + " because it claims to be in use";
  endif
  for thing in (object.contents)
    if (thing:is_listening())
      return ((("Not returning " + object.name) + " because ") + thing.name) + " is inside";
    endif
    $command_utils:suspend_if_needed(0);
  endfor
  if (valid(loc) && (loc != $limbo))
    if (loc:is_listening())
      return ((("Not returning " + object.name) + " because ") + loc.name) + " is holding it";
    endif
    for y in (loc:contents())
      if ((y != object) && y:is_listening())
        return (((("Not returning " + object.name) + " because ") + y.name) + " is in ") + loc.name;
      endif
      $command_utils:suspend_if_needed(0);
    endfor
  endif
endif
if (valid(place) && (!place:acceptable(object)))
  return (place.name + " won't accept ") + object.name;
endif
try
  requestor:tell("As you requested, the housekeeper tidies ", $string_utils:nn(object), " from ", $string_utils:nn(loc), " to ", $string_utils:nn(place), ".");
  if ($object_utils:has_verb(loc, "announce_all_but"))
    loc:announce_all_but({requestor, object}, "At ", requestor.name, "'s request, the ", this.name, " sneaks in, picks up ", object.name, " and hurries off to put ", ($object_utils:has_property(object, "po") && (typeof(object.po) == STR)) ? object.po | "it", " away.");
  endif
except (ANY)
  "Ignore errors";
endtry
this:moveit(object, place, requestor);
if ((loc = object.location) == oldloc)
  return (object.name + " wouldn't go; ") + ((!place:acceptable(object)) ? (" perhaps " + $string_utils:nn(place)) + " won't let it in" | ((" perhaps " + $string_utils:nn(loc)) + " won't let go of it"));
endif
try
  object:tell("The housekeeper puts you away.");
  if ($object_utils:isa(loc, $room))
    loc:announce_all_but({object}, "At ", requestor.name, "'s request, the housekeeper sneaks in, deposits ", object:title(), " and leaves.");
  else
    loc:tell("You notice the housekeeper sneak in, give you ", object:title(), " and leave.");
  endif
except (ANY)
  "Ignore errors";
endtry
return "";
.

@verb #71:"cleanup_list" any none none rxd
@program #71:cleanup_list
if (args)
  if (!valid(who = args[1]))
    return;
  endif
  player:tell(who.name, "'s personal cleanup list:");
else
  who = 0;
  player:tell("Housekeeper's complete cleanup list:");
endif
player:tell("------------------------------------------------------------------");
printed_anything = 0;
objs = this.clean;
reqs = this.requestors;
dest = this.destination;
for i in [1..length(objs)]
  $command_utils:suspend_if_needed(2);
  req = reqs[i];
  ob = objs[i];
  place = dest[i];
  if (((who == 0) || (req == who)) || (ob.owner == who))
    if (!valid(ob))
      player:tell($string_utils:left(tostr(ob), 7), $string_utils:left("** recycled **", 50), "(", req.name, ")");
    else
      player:tell($string_utils:left(tostr(ob), 7), $string_utils:left(ob.name, 26), "=>", $string_utils:left(tostr(place), 7), place.name || "nowhere", " (", req.name, ")");
    endif
    printed_anything = 1;
  endif
endfor
if (!printed_anything)
  player:tell("** The housekeeper has nothing in the cleanup list.");
endif
player:tell("------------------------------------------------------------------");
.

@verb #71:"add_cleanup" any any any rxd
@program #71:add_cleanup
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif
{what, ?who = player, ?where = what.location} = args;
if ((what < #1) || (!valid(what)))
  return "invalid object";
endif
if ($object_utils:isa(who, $guest))
  return tostr("Guests can't use the ", this.name, ".");
endif
if (!is_player(who))
  return tostr("Non-players can't use the ", this.name, ".");
endif
if (!valid(where))
  return tostr("The ", this.name, "doesn't know how to find ", where, " in order to put away ", what.name, ".");
endif
if (is_player(what))
  return ("The " + this.name) + " doesn't do players, except to cart them home when they fall asleep.";
endif
for x in (this.eschews)
  if ($object_utils:isa(what, x[1]))
    ok = 0;
    for y in [3..length(x)]
      if ($object_utils:isa(what, x[y]))
        ok = 1;
      endif
    endfor
    if (!ok)
      return tostr("The ", this.name, " doesn't do ", x[2], "!");
    endif
  endif
endfor
if ($object_utils:has_callable_verb(where, "litterp") ? where:litterp(what) | ((where in this.public_places) && (!(what in where.residents))))
  return tostr("The ", this.name, " won't litter ", where.name, "!");
endif
if (i = what in this.clean)
  if ((!this:controls(i, who)) && valid(this.destination[i]))
    return tostr(this.requestors[i].name, " already asked that ", what.name, " be kept at ", this.destination[i].name, "!");
  endif
  this.requestors[i] = who;
  this.destination[i] = where;
else
  this.clean = {what, @this.clean};
  this.requestors = {who, @this.requestors};
  this.destination = {where, @this.destination};
endif
return tostr("The ", this.name, " will keep ", what.name, " (", what, ") at ", valid(where) ? ((where.name + " (") + tostr(where)) + ")" | where, ".");
.

@verb #71:"remove_cleanup" any none none rxd
@program #71:remove_cleanup
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif
{what, ?who = player} = args;
if (i = what in this.clean)
  if (!this:controls(i, who))
    return tostr("You may remove an object from ", this.name, " list only if you own the object, the place it is kept, or if you placed the original cleaning order.");
  endif
  this.clean = listdelete(this.clean, i);
  this.destination = listdelete(this.destination, i);
  this.requestors = listdelete(this.requestors, i);
  return tostr(what.name, " (", what, ") removed from cleanup list.");
else
  return tostr(what.name, " not in cleanup list.");
endif
.

@verb #71:"controls" this none this
@program #71:controls
"does player control entry I?";
{i, who} = args;
if ((who in {this.owner, @this.owners}) || who.wizard)
  return "Yessir.";
endif
cleanable = this.clean[i];
if (this.requestors[i] == who)
  return "you asked for the previous result, you can change this one.";
elseif (((who == cleanable.owner) || (!valid(dest = this.destination[i]))) || (who == dest.owner))
  return "you own the object or the place where it is being cleaned to, or the destination is no longer valid.";
else
  return "";
endif
.

@verb #71:"continuous" this none this
@program #71:continuous
"start the housekeeper cleaning continuously. Kill any previous continuous";
"task. Not meant to be called interactively.";
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif
if ($code_utils:task_valid(this.task))
  taskn = this.task;
  this.task = 0;
  kill_task(taskn);
endif
fork taskn (0)
  while (1)
    index = 1;
    while (index < length(this.clean))
      x = this.clean[index];
      index = index + 1;
      try
        this:replace(x);
      except id (ANY)
      endtry
      suspend(this.testing ? 2 | this:time());
    endwhile
    suspend(5);
    this:litterbug();
  endwhile
endfork
this.task = taskn;
.

@verb #71:"litterbug" this none this
@program #71:litterbug
for room in (this.public_places)
  for thingy in (room.contents)
    suspend(10);
    if (((thingy.location == room) && this:is_litter(thingy)) && (!this:is_watching(thingy, $nothing)))
      "if it is litter and no-one is watching";
      fork (0)
        this:send_home(thingy);
      endfork
      suspend(0);
    endif
  endfor
endfor
.

@verb #71:"is_watching" this none this
@program #71:is_watching
return valid(thing = args[1]) && thing:is_listening();
.

@verb #71:"send_home" this none this
@program #71:send_home
if (caller != this)
  return E_PERM;
endif
litter = args[1];
littering = litter.location;
this:ejectit(litter, littering);
home = litter.location;
if ($object_utils:isa(home, $room))
  home:announce_all("The ", this.name, " sneaks in, deposits ", litter:title(), " and leaves.");
else
  home:tell("You notice the ", this.name, " sneak in, give you ", litter:title(), " and leave.");
endif
if ($object_utils:has_callable_verb(littering, "announce_all_but"))
  littering:announce_all_but({litter}, "The ", this.name, " sneaks in, picks up ", litter:title(), " and rushes off to put it away.");
endif
.

@verb #71:"moveit" this none this rxd #2
@program #71:moveit
"Wizardly verb to move object with requestor's permission";
if (caller != this)
  return E_PERM;
else
  set_task_perms(player = args[3]);
  return args[1]:moveto(args[2]);
endif
.

@verb #71:"ejectit" this none this rxd #2
@program #71:ejectit
"this:ejectit(object,room): Eject args[1] from args[2].  Callable only by housekeeper's quarters verbs.";
if (caller == this)
  args[2]:eject(args[1]);
endif
.

@verb #71:"is_object_cleaned" this none this
@program #71:is_object_cleaned
what = args[1];
if (!(where = what in this.clean))
  return 0;
else
  return {this.destination[where], this.requestors[where]};
endif
.

@verb #71:"is_litter" this none this
@program #71:is_litter
thingy = args[1];
for x in (this.litter)
  if ($object_utils:isa(thingy, x[1]) && (!$object_utils:isa(thingy, x[2])))
    return 1;
  endif
endfor
return 0;
.

@verb #71:"init_for_core" this none this rxd #2
@program #71:init_for_core
if (caller_perms().wizard)
  this.password = "Impossible password to type";
  this.last_password_time = 0;
  this.litter = {};
  this.public_places = {};
  this.requestors = {};
  this.destination = {};
  this.clean = {};
  this.eschews = {};
  this.recycle_bins = {};
  this.cleaning = #-1;
  this.task = 0;
  this.owners = {#2};
  this.mail_forward = {#2};
  this.player_queue = {};
  this.move_player_task = 0;
  this.moveto_task = 0;
  pass(@args);
endif
.

@verb #71:"clean_status" this none this
@program #71:clean_status
count = 0;
for i in (this.requestors)
  if (i == player)
    count = count + 1;
  endif
  $command_utils:suspend_if_needed(1);
endfor
player:tell("Number of items in cleanup list: ", tostr(length(this.clean)));
player:tell("Number of items you requested to be tidied: ", tostr(count));
player:tell("Number of requestors: ", tostr(length($list_utils:remove_duplicates(this.requestors))));
player:tell("Time to complete one cleaning circuit: ", $time_utils:english_time(length(this.clean) * this:time()));
.

@verb #71:"is_cleaning" this none this
@program #71:is_cleaning
"return a string status if the hosuekeeper is cleaning this object";
cleanable = args[1];
info = this:is_object_cleaned(cleanable);
if (info == 0)
  return tostr(cleanable.name, " is not cleaned by the ", this.name, ".");
else
  return tostr(cleanable.name, " is kept tidy at ", info[1].name, " (", info[1], ") at ", info[2].name, "'s request.");
endif
.

@verb #71:"time" this none this
@program #71:time
"Returns the amount of time to suspend between objects while continuous cleaning.";
"Currently set to try to complete cleaning circuit in one hour, but not exceed one object every 20 seconds.";
return max(20 + $login:current_lag(), length(this.clean) ? 3600 / length(this.clean) | 0);
.

@verb #71:"acceptable" this none this rxd #2
@program #71:acceptable
return caller == this;
.

@verb #71:"move_players_home" this none this rxd #2
@program #71:move_players_home
if (!$perm_utils:controls(caller_perms(), this))
  "perms don't control the $housekeeper; probably not called by $room:disfunc then. Used to let args[1] call this. No longer.";
  return E_PERM;
endif
this.player_queue = {@this.player_queue, {args[1], time() + 300}};
if ($code_utils:task_valid(this.move_player_task))
  "the move-players-home task is already running";
  return;
endif
fork tid (10)
  while (this.player_queue)
    if ((mtime = this.player_queue[1][2]) < (time() + 10))
      if ((is_player(who = this.player_queue[1][1]) && (!$object_utils:connected(who))) && (who.location != who.home))
        "Make sure it's a player. Somehow non-player objects have gotten in the queue";
        player = who;
        this:move_em(who);
      endif
      this.player_queue = listdelete(this.player_queue, 1);
    else
      suspend(mtime - time());
    endif
    $command_utils:suspend_if_needed(1);
  endwhile
endfork
this.move_player_task = tid;
.

@verb #71:"move_em" this none this rxd #2
@program #71:move_em
if (caller == this)
  who = args[1];
  set_task_perms(who);
  fork (0)
    fork (0)
      "This is forked so that it's protected from aborts due to errors in the player's :moveto verb.";
      if (who.location != who.home)
        "Unfortunately, if who is -already- at $player_start, move() won't call :enterfunc and the sleeping body never goes to $limbo. Have to call explicitly for that case. Ho_Yan 11/2/95";
        if (who.location == $player_start)
          $player_start:enterfunc(who);
        else
          move(who, $player_start);
        endif
      endif
    endfork
    start = who.location;
    this:set_moveto_task();
    who:moveto(who.home);
    if (who.location != start)
      start:announce(this:take_away_msg(who));
    endif
    if (who.location == who.home)
      who.home:announce(this:drop_off_msg(who));
    endif
  endfork
else
  return E_PERM;
endif
.

@verb #71:"take_away_msg drop_off_msg" this none this
@program #71:take_away_msg
return $string_utils:pronoun_sub(this.(verb), args[1], this);
.

@verb #71:"set_moveto_task" this none this
@program #71:set_moveto_task
"sets $housekeeper.moveto_task to the current task_id() so player:moveto's can check for validity.";
if (caller != this)
  return E_PERM;
endif
this.moveto_task = task_id();
.

"***finished***
