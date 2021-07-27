$Header: /repo/public.cvs/app/BioGate/BioMooCore/core63.moo,v 1.1 2021/07/27 06:44:33 bruce Exp $

>@dump #63 with create
@create $thing named Recycling Center:Recycling Center,Center
@prop #63."orphans" {} r
@prop #63."announce_removal_msg" "" rc
@prop #63."nhist" 50 ""
@prop #63."history" {} ""
;;#63.("history") = {{#95, #130}, {#95, #131}, {#180, #199}, {#180, #201}, {#180, #212}, {#180, #226}, {#179, #226}, {#177, #284}, {#180, #214}, {#178, #325}, {#178, #326}, {#180, #291}, {#178, #332}, {#340, #342}, {#231, #295}, {#178, #295}, {#180, #383}, {#180, #383}, {#180, #368}, {#178, #394}, {#180, #496}, {#180, #497}, {#180, #512}, {#179, #514}, {#180, #518}, {#180, #519}, {#180, #518}, {#180, #395}, {#179, #463}, {#179, #529}, {#179, #529}, {#179, #463}, {#179, #530}, {#179, #536}, {#177, #538}, {#179, #540}, {#180, #543}, {#179, #562}, {#179, #562}, {#180, #579}, {#180, #584}, {#180, #584}, {#180, #584}, {#180, #588}, {#180, #589}, {#180, #587}, {#180, #584}, {#180, #585}, {#180, #586}, {#180, #552}, {#180, #366}, {#180, #602}}
@prop #63."lost_souls" {} rc
;;#63.("aliases") = {"Recycling Center", "Center"}
;;#63.("description") = "Object reuse. Call $recycler:_create() to create an object (semantics the same as create()), $recycler:_recycle() to recycle an object. Will create a new object if nothing available in its contents. Note underscores, to avoid builtin :recycle() verb called when objects are recycled. Uses $building_utils:recreate() to prepare objects."
;;#63.("object_size") = {10680, 855339336}

@verb #63:"_recreate" this none this rxd #2
@program #63:_recreate
"Return a toad (child of #1, owned by $hacker) from this.contents.  Move it to #-1.  Recreate as a child of args[1], or of #1 if no args are given.  Chown to caller_perms() or args[2] if present.";
{?what = #1, ?who = caller_perms()} = args;
if (!(caller_perms().wizard || (who == caller_perms())))
  return E_PERM;
elseif (!(valid(what) && is_player(who)))
  return E_INVARG;
elseif ((((who != what.owner) && (!what.f)) && (!who.wizard)) && (!caller_perms().wizard))
  return E_PERM;
endif
for potential in (this.contents)
  if (((potential.owner == $hacker) && (parent(potential) == $garbage)) && (!children(potential)))
    return this:setup_toad(potential, who, what);
  endif
endfor
return E_NONE;
.

@verb #63:"_recycle" this none this rxd #2
@program #63:_recycle
"Take the object in args[1], and turn it into a child of #1 owned by $hacker.";
"If the object is a player, decline.";
item = args[1];
if (!$perm_utils:controls(caller_perms(), item))
  raise(E_PERM);
elseif (is_player(item))
  raise(E_INVARG);
endif
this:addhist(caller_perms(), item);
"...recreate can fail (:recycle can crash)...";
this:add_orphan(item);
$quota_utils:preliminary_reimburse_quota(item.owner, item);
$building_utils:recreate(item, $garbage);
this:remove_orphan(item);
"...";
$wiz_utils:set_owner(item, $hacker);
item.name = tostr("Recyclable ", item);
move(item, this);
.

@verb #63:"_create" this none this rxd #2
@program #63:_create
e = `set_task_perms(caller_perms()) ! ANY';
if (typeof(e) == ERR)
  return e;
else
  val = this:_recreate(@args);
  return (val == E_NONE) ? $quota_utils:bi_create(@args) | val;
endif
.

@verb #63:"addhist" this none this rxd #2
@program #63:addhist
if (caller == this)
  h = this.history;
  if ((len = length(h)) > this.nhist)
    h = h[len - this.nhist..len];
  endif
  this.history = {@h, args};
endif
.

@verb #63:"show*-history" this none none rxd #2
@program #63:show-history
if ($perm_utils:controls(valid(caller_perms()) ? caller_perms() | player, this))
  for x in (this.history)
    pname = valid(x[1]) ? x[1].name | "A recycled player";
    oname = valid(x[2]) ? x[2].name | "recycled";
    player:notify(tostr(pname, " (", x[1], ") recycled ", x[2], " (now ", oname, ")"));
  endfor
else
  player:notify("Sorry.");
endif
.

@verb #63:"request" any from this rd #2
@program #63:request
"added check that obj is already $garbage - Bits 12/16/5";
dobj = valid(dobj) ? dobj | $string_utils:match_object(dobjstr, player.location);
if (!valid(dobj))
  dobj = (n = toint(dobjstr)) ? toobj(n) | #-1;
endif
if (!valid(dobj))
  player:tell("Couldn't parse ", dobjstr, " as a valid object number.");
elseif (!(dobj in this.contents))
  player:tell("Couldn't find ", dobj, " in ", this.name, ".");
elseif (!$object_utils:isa(dobj, $garbage))
  player:tell("Sorry, that isn't recyclable.");
elseif ($object_utils:has_callable_verb(this, "request_refused") && (msg = this:request_refused(player, dobj)))
  player:tell("Sorry, can't do that:  ", msg);
else
  if (typeof(emsg = this:setup_toad(dobj, player, $root_class)) != ERR)
    dobj:moveto(player);
    dobj.aliases = {dobj.name = "Object " + tostr(dobj)};
    player:tell("You now have ", dobj, " ready for @recreation.");
    if (this.announce_removal_msg)
      player.location:announce($string_utils:pronoun_sub(this.announce_removal_msg));
    endif
  else
    player:tell(emsg);
  endif
endif
.

@verb #63:"setup_toad" this none this rxd #2
@program #63:setup_toad
"this:setup_toad(objnum,new_owner,parent)";
"Called by :_create and :request.";
if (caller != this)
  return E_PERM;
endif
{potential, who, what} = args;
if (!$quota_utils:creation_permitted(who))
  return E_QUOTA;
else
  $wiz_utils:set_owner(potential, who);
  move(potential, #-1);
  set_task_perms({@callers(), {#-1, "", player}}[2][3]);
  "... if :initialize crashes...";
  this:add_orphan(potential);
  $building_utils:recreate(potential, what);
  this:remove_orphan(potential);
  "... if we don't get this far, the object stays on the orphan list...";
  "... orphan list should be checked periodically...";
  return potential;
endif
.

@verb #63:"add_orphan" this none this
@program #63:add_orphan
if (caller == this)
  this.orphans = setadd(this.orphans, args[1]);
endif
.

@verb #63:"remove_orphan" this none this
@program #63:remove_orphan
if (caller == this)
  this.orphans = setremove(this.orphans, args[1]);
endif
.

@verb #63:"valid" this none this rxd #2
@program #63:valid
"Usage:  valid(object)";
"True if object is valid and not $garbage.";
return valid(args[1]) && (parent(args[1]) != $garbage);
.

@verb #63:"init_for_core" this none this rxd #2
@program #63:init_for_core
if (caller_perms().wizard)
  this.orphans = {};
  this.history = {};
  this.lost_souls = {};
  pass();
endif
.

@verb #63:"resurrect" this none this rxd #2
@program #63:resurrect
who = caller_perms();
if (!valid(parent = {@args, $garbage}[1]))
  return E_INVARG;
elseif (!who.wizard)
  return E_PERM;
elseif (typeof(o = renumber($quota_utils:bi_create(parent, $hacker))) == ERR)
  "..death...";
elseif (parent == $garbage)
  $recycler:_recycle(o);
else
  o.aliases = {o.name = tostr("Resurrectee ", o)};
  $wiz_utils:set_owner(o, who);
  move(o, who);
endif
reset_max_object();
return o;
.

@verb #63:"reclaim_lost_souls" this none this rxd #2
@program #63:reclaim_lost_souls
if (!caller_perms().wizard)
  raise(E_PERM);
endif
fork (1800)
  this:(verb)();
endfork
for x in (this.lost_souls)
  this.lost_souls = setremove(this.lost_souls, x);
  if ((valid(x) && (typeof(x.owner.owned_objects) == LIST)) && (!(x in x.owner.owned_objects)))
    x.owner.owned_objects = setadd(x.owner.owned_objects, x);
    $quota_utils:summarize_one_user(x.owner);
  endif
  $command_utils:suspend_if_needed(0);
endfor
.

@verb #63:"look_self" this none this
@program #63:look_self
if (prepstr in {"in", "inside", "into"})
  recycler = this;
  linelen = ((linelen = abs(player.linelen)) < 20) ? 78 | linelen;
  intercolumn_gap = 2;
  c_width = length(tostr(max_object())) + intercolumn_gap;
  n_columns = (linelen + (c_width - 1)) / c_width;
  things = $list_utils:sort_suspended(0, this.contents);
  header = tostr(this.name, " (", this, ") contains:");
  player:tell_lines({header, @$string_utils:columnize_suspended(0, things, n_columns)});
else
  return pass(@args);
endif
"This code contributed by Mickey.";
.

@verb #63:"check_quota_scam" this none this rxd #2
@program #63:check_quota_scam
who = args[1];
if ($quota_utils.byte_based && (is_clear_property(who, "size_quota") || is_clear_property(who, "owned_objects")))
  raise(E_QUOTA);
endif
cheater = 0;
other_cheaters = {};
for x in (this.lost_souls)
  if (((valid(x) && ((owner = x.owner) != $hacker)) && (typeof(owner.owned_objects) == LIST)) && (!(x in owner.owned_objects)))
    if (owner == who)
      who.owned_objects = setadd(who.owned_objects, x);
      cheater = 1;
    else
      "it's someone else's quota scam we're detecting...";
      other_cheaters = setadd(other_cheaters, owner);
      owner.owned_objects = setadd(owner.owned_objects, x);
      this.lost_souls = setremove(this.lost_souls, x);
    endif
  endif
  this.lost_souls = setremove(this.lost_souls, x);
endfor
if ($quota_utils.byte_based)
  if (cheater)
    $quota_utils:summarize_one_user(who);
  endif
  if (other_cheaters)
    fork (0)
      for x in (other_cheaters)
        $quota_utils:summarize_one_user(x);
      endfor
    endfork
  endif
endif
.

@verb #63:"gc" this none this
@program #63:gc
for x in (this.orphans)
  if ((!valid(x)) || ((x.owner != $hacker) && (x in x.owner.owned_objects)))
    this.orphans = setremove(this.orphans, x);
  endif
endfor
.

"***finished***
