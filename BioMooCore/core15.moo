$Header: /repo/public.cvs/app/BioGate/BioMooCore/core15.moo,v 1.1 2021/07/27 06:44:28 bruce Exp $

>@dump #15 with create
@create $root_class named Limbo:The Body Bag
;;#15.("aliases") = {"The Body Bag"}
;;#15.("object_size") = {2239, 1577149623}

@verb #15:"acceptable" this none this
@program #15:acceptable
what = args[1];
return is_player(what) && (!(what in connected_players()));
.

@verb #15:"confunc" this none this
@program #15:confunc
if (caller != #0)
  return E_PERM;
endif
who = args[1];
this:eject(who);
"if (((!$recycler:valid(who.home)) || (!who.home:acceptable(who))) || (typeof(move(who, who.home)) == ERR))";
"  move(who, $player_start);";
"endif";
who.home:announce_all_but({who}, who.name, " has connected.");
.

@verb #15:"who_location_msg" this none this rxd #36
@program #15:who_location_msg
return $player_start:who_location_msg(@args);
.

@verb #15:"moveto" this none this rxd #36
@program #15:moveto
"Don't go anywhere.";
.

@verb #15:"eject" this none this
@program #15:eject
if ($perm_utils:controls(caller_perms(), this))
  if ((what = args[1]).wizard && (what.location == this))
    move(what, what.home);
  else
    return pass(@args);
  endif
endif
.

"***finished***
