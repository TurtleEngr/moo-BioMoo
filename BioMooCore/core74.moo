$Header: /repo/public.cvs/app/BioGate/BioMooCore/core74.moo,v 1.1 2021/07/27 06:44:34 bruce Exp $

>@dump #74 with create
@create $thing named Generic Feature Object:Generic Feature Object,Generic .Features_Huh Object,Feature Object,.Features_Huh Object
@prop #74."warehouse" #84 r
@prop #74."help_msg" "The Generic Feature Object--not to be used as a feature object." rc
@prop #74."feature_verbs" {} r
;;#74.("feature_verbs") = {"Using"}
@prop #74."feature_ok" 1 r
;;#74.("aliases") = {"Generic Feature Object", "Generic .Features_Huh Object", "Feature Object", ".Features_Huh Object"}
;;#74.("description") = "This is the Generic Feature Object.  It is not meant to be used as a feature object itself, but is handy for making new feature objects."
;;#74.("object_size") = {6847, 855068591}

@verb #74:"help_msg" this none this
@program #74:help_msg
all_help = this.help_msg;
if (typeof(all_help) == STR)
  all_help = {all_help};
endif
helpless = {};
for vrb in (this.feature_verbs)
  if (loc = $object_utils:has_verb(this, vrb))
    loc = loc[1];
    help = $code_utils:verb_documentation(loc, vrb);
    if (help)
      all_help = {@all_help, "", tostr(loc, ":", verb_info(loc, vrb)[3]), @help};
    else
      helpless = {@helpless, vrb};
    endif
  endif
endfor
if (helpless)
  all_help = {@all_help, "", ("No help found on " + $string_utils:english_list(helpless, "nothing", " or ")) + "."};
endif
return {@all_help, "----"};
.

@verb #74:"look_self" this none this
@program #74:look_self
"Definition from #1";
desc = this:description();
if (desc)
  player:tell_lines(desc);
else
  player:tell("You see nothing special.");
endif
player:tell("Please type \"help ", this, "\" for more information.");
.

@verb #74:"using this" this none this
@program #74:using
"Proper usage for the Generic Feature Object:";
"";
"First of all, the Generic Feature Object is constructed with the idea";
"that its children will be @moved to #24300, which is kind of a warehouse";
"for feature objects.  If there's enough interest, I'll try to make the";
"stuff that works with that in mind optional.";
"";
"Make a short description.  This is so I can continue to have looking at";
"#24300 give the descriptions of each of the objects in its .contents.";
"The :look_msg automatically includes a pointer to `help <this object>',";
"so you don't have to.";
"";
"Put a list of the commands you want people to use in";
"<this object>.feature_verbs.  (You need to use the :set_feature_verbs";
"verb to do this.)";
"";
"When someone types `help <this object>', they will be told the comment";
"strings from each of the verbs named in .feature_verbs.";
.

@verb #74:"examine_commands_ok" this none this rxd #2
@program #74:examine_commands_ok
return this in args[1].features;
.

@verb #74:"set_feature_ok" this none this
@program #74:set_feature_ok
if ($perm_utils:controls(caller_perms(), this) || (caller == this))
  return this.feature_ok = args[1];
else
  return E_PERM;
endif
.

@verb #74:"hidden_verbs" this none this
@program #74:hidden_verbs
"Can't see `get' unless it's in the room; can't see `drop' unless it's in the player.  Should possibly go on $thing.";
"Should use :contents, but I'm in a hurry.";
hidden = pass(@args);
if (this.location != args[1])
  hidden = setadd(hidden, {$thing, verb_info($thing, "drop")[3], {"this", "none", "none"}});
  hidden = setadd(hidden, {$thing, verb_info($thing, "give")[3], {"this", "at/to", "any"}});
endif
if (this.location != args[1].location)
  hidden = setadd(hidden, {$thing, verb_info($thing, "get")[3], {"this", "none", "none"}});
endif
return hidden;
.

@verb #74:"set_feature_verbs" this none this
@program #74:set_feature_verbs
if ($perm_utils:controls(caller_perms(), this) || (caller == this))
  return this.feature_verbs = args[1];
else
  return E_PERM;
endif
.

@verb #74:"initialize" this none this
@program #74:initialize
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  pass(@args);
  this.feature_verbs = {};
else
  return E_PERM;
endif
.

@verb #74:"init_for_core" this none this rxd #2
@program #74:init_for_core
if (($code_utils:verb_location() == this) && caller_perms().wizard)
  this.warehouse = $feature_warehouse;
  `delete_property(this, "guest_ok") ! ANY';
  `delete_verb(this, "set_ok_for_guest_use") ! ANY';
endif
.

@verb #74:"feature_remove" this none this rxd #2
@program #74:feature_remove
"This is just a blank verb definition to encourage others to use this verb name if they care when a user is no longer using that feature.";
.

"***finished***
