$Header: /repo/public.cvs/app/BioGate/BioMooCore/core120.moo,v 1.1 2021/07/27 06:44:27 bruce Exp $

>@dump #120 with create
@create $room named Interior Room:Interior Room
@prop #120."opaque" 0 r
@prop #120."inside_description" "" r
;;#120.("aliases") = {"Interior Room"}
;;#120.("object_size") = {0, 0}

@verb #120:"inside_description" this none this
@program #120:inside_description
return this.inside_description;
.

@verb #120:"set_inside_description" this none this
@program #120:set_inside_description
if (!((caller == this) || $perm_utils:controls(caller_perms(), this)))
  return E_PERM;
elseif (typeof(desc = args[1]) in {LIST, STR})
  this.inside_description = desc;
else
  return E_TYPE;
endif
.

@verb #120:"@describe_inside" this as any
@program #120:@describe_inside
if ($perm_utils:controls(player, this))
  this:set_inside_description(iobjstr);
  player:tell("Interior description set.");
else
  player:tell("Only the owner may modify the interior description.");
endif
.

@verb #120:"description" this none this
@program #120:description
if (player.location == this)
  return this:inside_description(@args);
else
  return pass(@args);
endif
.

@verb #120:"tell_contents" this none this
@program #120:tell_contents
if ((!this.opaque) || (player.location == this))
  pass(@args);
endif
.

@verb #120:"set_opaque" this none this
@program #120:set_opaque
if ((caller == this) || $perm_utils:controls(valid(caller_perms()) ? caller_perms() | player, this))
  return this.opaque = args[1];
else
  return E_PERM;
endif
.

@verb #120:"@opacity" this is any
@program #120:@opacity
if ($perm_utils:controls(player, this))
  n = tonum(iobjstr);
  if (tostr(n) != iobjstr)
    player:tell("That is not a number.");
  elseif ((n != 0) && (n != 1))
    player:tell("That is not a valid number for opacity.  0 or 1 please.");
  else
    this:set_opaque(n);
    player:tell("Opacity set to ", n, ".");
  endif
else
  player:tell("Only the owner may modify the opacity.");
endif
.

"***finished***
