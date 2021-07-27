$Header: /repo/public.cvs/app/BioGate/BioMooCore/core82.moo,v 1.1 2021/07/27 06:44:35 bruce Exp $

>@dump #82 with create
@create $generic_utils named Object Quota Utilities:Object Quota Utilities
@prop #82."byte_based" 0 rc
;;#82.("help_msg") = "This is the default package that interfaces to the $player/$prog quota manipulation verbs."
;;#82.("aliases") = {"Object Quota Utilities"}
;;#82.("description") = {"This is the Object Quota Utilities utility package.  See `help $object_quota_utils' for more details."}
;;#82.("object_size") = {6479, 855068591}

@verb #82:"initialize_quota" this none this
@program #82:initialize_quota
if (!caller_perms().wizard)
  return E_PERM;
else
  args[1].ownership_quota = $wiz_utils.default_player_quota;
endif
.

@verb #82:"init_for_core" this none this rxd #2
@program #82:init_for_core
if (!caller_perms().wizard)
  return E_PERM;
else
  $quota_utils = this;
endif
.

@verb #82:"adjust_quota_for_programmer" this none this
@program #82:adjust_quota_for_programmer
if (!caller_perms().wizard)
  return E_PERM;
else
  victim = args[1];
  oldquota = victim.ownership_quota;
  if ($object_utils:has_property($local, "second_char_registry") && $local.second_char_registry:is_second_char(victim))
    "don't increment quota for 2nd chars when programmering";
    victim.ownership_quota = oldquota;
  else
    victim.ownership_quota = oldquota + ($wiz_utils.default_programmer_quota - $wiz_utils.default_player_quota);
  endif
endif
.

@verb #82:"bi_create" this none this rxd #2
@program #82:bi_create
"Calls built-in create.";
set_task_perms(caller_perms());
return `create(@args) ! ANY';
.

@verb #82:"creation_permitted" this none this
@program #82:creation_permitted
$recycler:check_quota_scam(args[1]);
return args[1].ownership_quota > 0;
.

@verb #82:"verb_addition_permitted property_addition_permitted" this none this
@program #82:verb_addition_permitted
return 1;
.

@verb #82:"display_quota" this none this
@program #82:display_quota
who = args[1];
if (caller_perms() == who)
  q = who.ownership_quota;
  total = (typeof(who.owned_objects) == LIST) ? length(setremove(who.owned_objects, who)) | 0;
  if (q == 0)
    player:tell(tostr("You can't create any more objects", (total < 1) ? "." | tostr(" until you recycle some of the ", total, " you already own.")));
  else
    player:tell(tostr("You can create ", q, " new object", (q == 1) ? "" | "s", (total == 0) ? "." | tostr(" without recycling any of the ", total, " that you already own.")));
  endif
else
  if ($perm_utils:controls(caller_perms(), who))
    player:tell(tostr(who.name, "'s quota is currently ", who.ownership_quota, "."));
  else
    player:tell("Permission denied.");
  endif
endif
.

@verb #82:"get_quota quota_remaining" this none this
@program #82:get_quota
if ($perm_utils:controls(caller_perms(), args[1]) || (caller == this))
  return args[1].ownership_quota;
else
  return E_PERM;
endif
.

@verb #82:"charge_quota" this none this
@program #82:charge_quota
"Charge args[1] for the quota required to own args[2]";
{who, what} = args;
if ((caller == this) || caller_perms().wizard)
  who.ownership_quota = who.ownership_quota - 1;
else
  return E_PERM;
endif
.

@verb #82:"reimburse_quota" this none this
@program #82:reimburse_quota
"Reimburse args[1] for the quota required to own args[2]";
{who, what} = args;
if ((caller == this) || caller_perms().wizard)
  who.ownership_quota = who.ownership_quota + 1;
else
  return E_PERM;
endif
.

@verb #82:"set_quota" this none this
@program #82:set_quota
"Set args[1]'s quota to args[2]";
{who, quota} = args;
if (caller_perms().wizard || (caller == this))
  return who.ownership_quota = quota;
else
  return E_PERM;
endif
.

@verb #82:"preliminary_reimburse_quota" this none this
@program #82:preliminary_reimburse_quota
return 0;
.

@verb #82:"can_peek" this none this
@program #82:can_peek
"Is args[1] permitted to examine args[2]'s quota information?";
return $perm_utils:controls(args[1], args[2]);
.

@verb #82:"can_touch" this none this
@program #82:can_touch
"Is args[1] permitted to examine args[2]'s quota information?";
return args[1].wizard;
.

"***finished***
