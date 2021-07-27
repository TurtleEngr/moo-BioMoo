$Header: /repo/public.cvs/app/BioGate/BioMooCore/core126.moo,v 1.1 2021/07/27 06:44:28 bruce Exp $

>@dump #126 with create
@create $generic_utils named File Utilities:File Utilities
;;#126.("aliases") = {"File Utilities"}
;;#126.("description") = "This is a placeholder parent for all the $..._utils packages, to more easily find them and manipulate them. At present this object defines no useful verbs or properties. (Filfre.)"
;;#126.("object_size") = {0, 0}

@verb #126:"disk_quota" this none this
@program #126:disk_quota
return args[1].disk_quota[1];
.

@verb #126:"free_quota" this none this
@program #126:free_quota
quota = args[1].disk_quota;
return quota[1] - quota[2];
.

@verb #126:"update_quota change_quota*_to" this none this rx
@program #126:update_quota
if (!caller_perms().wizard)
  return E_PERM;
elseif (length(args) < 2)
  return E_ARGS;
elseif (((typeof(who = args[1]) != OBJ) || (typeof(change = args[2]) != NUM)) || (typeof(quota = who.disk_quota) != LIST))
  return E_INVARG;
endif
what = verb[1] in {"c", "u"};
return who.disk_quota[what] = ((verb[length(verb)] == "a") ? quota[what] | 0) + change;
.

@verb #126:"display_quota" this none this rx #2
@program #126:display_quota
who = args[1];
quota = this:disk_quota(who);
free = this:free_quota(who);
player:tell("Disk quota statistics: ", quota, " bytes allocated, ", quota - free, " (", (100 * (quota - free)) / quota, "%) in use.");
.

@verb #126:"used_quota" this none this
@program #126:used_quota
return args[1].disk_quota[2];
.

"***finished***
