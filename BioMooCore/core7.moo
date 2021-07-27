$Header: /repo/public.cvs/app/BioGate/BioMooCore/core7.moo,v 1.1 2021/07/27 06:44:34 bruce Exp $

>@dump #7 with create
@create $root_class named generic exit:generic exit
@prop #7."obvious" 1 rc
@prop #7."source" #-1 rc
@prop #7."dest" #-1 rc
@prop #7."nogo_msg" 0 rc
@prop #7."onogo_msg" 0 rc
@prop #7."arrive_msg" 0 rc
@prop #7."oarrive_msg" 0 rc
@prop #7."oleave_msg" 0 rc
@prop #7."leave_msg" "You move %t." rc
;;#7.("aliases") = {"generic exit"}
;;#7.("object_size") = {12810, 1577149623}
;;#7.("vrml_desc") = {"Translation { translation 0 -.25 0 }", "Material { diffuseColor 0 0 1 } Cube {width 1.2 height 2.0 depth 0.05 } #frame", "Texture2 {filename \"http://hppsda.mayfield.hp.com/image/maple.gif\" }", "Transform { translation 0 -0.07 0 } Material {diffuseColor 1 1 1 shininess 0}", "Cube {width 1 height 1.9 depth 0.1} # door opening"}

@verb #7:"invoke" this none this
@program #7:invoke
set_task_perms(caller_perms());
this:move(player);
.

@verb #7:"move" this none this
@program #7:move
set_task_perms(caller_perms());
what = args[1];
"if ((what.location != this.source) || (!(this in this.source.exits)))";
"  player:tell(\"You can't go that way.\");";
"  return;";
"endif";
unlocked = this:is_unlocked_for(what);
if (unlocked)
  this.dest:bless_for_entry(what);
endif
if (unlocked && this.dest:acceptable(what))
  start = what.location;
  if (msg = this:leave_msg(what))
    what:tell_lines(msg);
  endif
  what:moveto(this.dest);
  if (what.location != start)
    "Don't print oleave messages if WHAT didn't actually go anywhere...";
    this:announce_msg(start, what, (this:oleave_msg(what) || this:defaulting_oleave_msg(what)) || "has left.");
  endif
  if (what.location == this.dest)
    "Don't print arrive messages if WHAT didn't really end up there...";
    if (msg = this:arrive_msg(what))
      what:tell_lines(msg);
    endif
    this:announce_msg(what.location, what, this:oarrive_msg(what) || "has arrived.");
  endif
else
  if (msg = this:nogo_msg(what))
    what:tell_lines(msg);
  else
    what:tell("You can't go that way.");
  endif
  if (msg = this:onogo_msg(what))
    this:announce_msg(what.location, what, msg);
  endif
endif
.

@verb #7:"recycle" this none this
@program #7:recycle
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  try
    this.source:remove_exit(this);
    this.dest:remove_entrance(this);
  except id (ANY)
  endtry
  return pass(@args);
else
  return E_PERM;
endif
.

@verb #7:"leave_msg oleave_msg arrive_msg oarrive_msg nogo_msg onogo_msg" this none this
@program #7:leave_msg
msg = this.(verb);
return msg ? $string_utils:pronoun_sub(msg, @args) | "";
.

@verb #7:"set_name" this none this
@program #7:set_name
if ($perm_utils:controls(cp = caller_perms(), this) || (valid(this.source) && (this.source.owner == cp)))
  return (typeof(e = `this.name = args[1] ! ANY') != ERR) || e;
else
  return E_PERM;
endif
.

@verb #7:"set_aliases" this none this
@program #7:set_aliases
if ($perm_utils:controls(cp = caller_perms(), this) || (valid(this.source) && (this.source.owner == cp)))
  if (typeof(e = `this.aliases = args[1] ! ANY') == ERR)
    return e;
  else
    return 1;
  endif
else
  return E_PERM;
endif
.

@verb #7:"announce_all_but" this none this
@program #7:announce_all_but
"This is intended to be called only by exits, for announcing various oxxx messages.  First argument is room to announce in.  Second argument is as in $room:announce_all_but's first arg, who not to announce to.  Rest args are what to say.  If the final arg is a list, prepends all the other rest args to the first line and emits the lines separately.";
where = args[1];
whobut = args[2];
last = args[$];
if (typeof(last) == LIST)
  where:announce_all_but(whobut, @args[3..$ - 1], last[1]);
  for line in (last[2..$])
    where:announce_all_but(whobut, line);
  endfor
else
  where:announce_all_but(@args[3..$]);
endif
.

@verb #7:"defaulting_oleave_msg" this none this
@program #7:defaulting_oleave_msg
for k in ({this.name, @this.aliases})
  if (k in {"east", "west", "south", "north", "northeast", "southeast", "southwest", "northwest", "out", "up", "down", "nw", "sw", "ne", "se", "in"})
    return ("goes " + k) + ".";
  elseif (k in {"leave", "out", "exit"})
    return "leaves";
  endif
endfor
if ((index(this.name, "an ") == 1) || (index(this.name, "a ") == 1))
  return ("leaves for " + this.name) + ".";
else
  return ("leaves for the " + this.name) + ".";
endif
.

@verb #7:"moveto" this none this
@program #7:moveto
if ((caller in {this, this.owner}) || $perm_utils:controls(caller_perms(), this))
  return pass(@args);
else
  return E_PERM;
endif
.

@verb #7:"examine_key" this none this
@program #7:examine_key
"examine_key(examiner)";
"return a list of strings to be told to the player, indicating what the key on this type of object means, and what this object's key is set to.";
"the default will only tell the key to a wizard or this object's owner.";
who = args[1];
if (((caller == this) && $perm_utils:controls(who, this)) && (this.key != 0))
  return {tostr(this:title(), " will only transport objects matching this key:"), tostr("  ", $lock_utils:unparse_key(this.key))};
endif
.

@verb #7:"announce_msg" this none this
@program #7:announce_msg
":announce_msg(place, what, msg)";
"  announce msg in place (except to what). Prepend with what:title if it isn't part of the string";
msg = args[3];
what = args[2];
title = what:titlec();
if (!$string_utils:index_delimited(msg, title))
  msg = tostr(title, " ", msg);
endif
args[1]:announce_all_but({what}, msg);
.

@verb #7:"html" this none this rx #95
@program #7:html
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
set_task_perms(caller_perms());
this:move(player);
return $nothing;
"Last modified Mon Nov  6 01:57:49 1995 IST by EricM (#3264).";
.

@verb #7:"has_url" this none this rx #95
@program #7:has_url
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return 1;
"Last modified Wed Aug 17 15:51:08 1994 IDT by Gustavo (#2).";
.

@verb #7:"get_vrml_desc" this none this rxd #96
@program #7:get_vrml_desc
"get_vrml_desc(none) -> VRML frg LIST";
"Exits get linked to new room, and non-obvious exits are transparent";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
vrml_desc = pass(@args);
if (!this.obvious)
  "A colorless transparent 1 meter square panel with center origin; Scale sets the true size";
  vrml_desc = {"Material { diffuseColor 1 1 1 shininess 0 transparency 1 } Cube { width 1 height 1 depth 0.1}"};
endif
return vrml_desc;
"Last modified Mon Apr  1 10:06:47 1996 IDT by EricM (#3264).";
.

@verb #7:"get_vrml_translation get_vrml_rotation" this none this rxd #95
@program #7:get_vrml_translation
"get_vrml_translation get_vrml_rotation(none) -> VRML frg LIST";
"If settings are default, apply a reasonable method to place the exit in the right general direction.";
"Assumes that the Z-axis points north";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
exits = $object_utils:isa(this.source, $room) ? this.source:exits() | {};
set_task_perms(($perm_utils:controls(cp = caller_perms(), this) || (caller in {this, $std_vrml10viewer})) ? this.owner | cp);
abbrev_dirs = {"n", "ne", "e", "se", "s", "sw", "w", "nw"};
dirs = {"north", "northeast", "east", "southeast", "south", "southwest", "west", "northwest"};
if ((vrml_desc = pass(@args)) != {0, 0, 0})
  return vrml_desc;
  "User or previous call has set it";
endif
if (idx = (this.name in abbrev_dirs) || (this.name in dirs))
  "twist so it faces in the direction it leads";
else
  "they didn't use a direction name, so they get a randomly facing exit";
  exits = $list_utils:map_prop(exits, "name");
  idx = length(dirs);
  while ((idx > 0) && (!((dirs[idx] in exits) || (abbrev_dirs[idx] in exits))))
    idx = idx - 1;
  endwhile
  "if couldn't assign it, pick one randomly; note it's rot'n will probably be non-standard for that direction, so it'll be visible over the correct exit there";
  idx = idx ? idx | random(length(dirs));
endif
if (verb[10..14] == "rotat")
  "--Rotate exit";
  rotn = (idx = idx - 1) ? 62832 - (idx * 785) | 0;
  return this:set_vrml_rotation({0, rotn, 0});
endif
"Translate the exit so it's not too close to the center of the room";
transl_table = {{0, 0, -5000}, {4000, 0, -4000}, {5000, 0, 0}, {4000, 0, 4000}, {0, 0, 5000}, {-4000, 0, 4000}, {-5000, 0, 0}, {-4000, 0, -4000}};
return this:set_vrml_translation(transl_table[idx]);
"Last modified Wed Apr 10 06:56:56 1996 IDT by EricM (#3264).";
.

@verb #7:"get_vrml_hyperlink" this none this rxd #96
@program #7:get_vrml_hyperlink
"get_vrml_hyperlink(none) -> VRML frg LIST";
"Exits have hyperlinks leading to their destination room";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((valid(dest = this.dest) && $object_utils:isa(dest, $room)) && dest:is_unlocked_for(player))
  if (!("embedVRML" in player.web_options))
    "person is seeing this with a VRML browser and not within a web window";
    link = {tostr(" WWWAnchor {description \"", this.name, " to ", this.dest.name, "\" name \"&LOCAL_LINK;/", $web_utils:get_webcode(), "/", tonum(this.dest), "/moveto/room.wrl\" ")};
    "also, move them to the new room if possible and appropriate";
  else
    "person's seeing this in a web window; show them another web window";
    code = (typeof(viewer = $web_options:get(player.web_options, "viewer")) == OBJ) ? viewer:get_code() | $standard_webviewer:get_code();
    link = {tostr(" WWWAnchor {description \"", this.name, ", to ", this.dest.name, "\" name \"&LOCAL_LINK;/", code, "/", tonum(this), "#focus\" ")};
  endif
else
  link = pass(@args);
endif
return link;
"Last modified Thu Aug 15 02:45:48 1996 IDT by EricM (#3264).";
.

"***finished***
