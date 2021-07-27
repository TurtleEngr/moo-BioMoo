$Header: /repo/public.cvs/app/BioGate/BioMooCore/core341.moo,v 1.1 2021/07/27 06:44:31 bruce Exp $

>@dump #341 with create
@create $room named Courtyard:Courtyard
;;#341.("entrances") = {#344, #349, #352}
;;#341.("blessed_task") = 1163372797
;;#341.("exits") = {#343, #348, #351}
;;#341.("vrml_interior_desc") = {"# starry skyy", "DEF BackgroundImage Info {string \"http://hppsda.mayfield.hp.com/image/sky_stars.gif\"}", "# room should be arrayed so that the floor is about 1.5 meters below the origin plane", "# objects at the origin should be at chest level or so", "Material {diffuseColor .6 .38 .16} Transform {translation 0 -1.35 0}", "Cylinder {height .05 radius 50}", "Material {diffuseColor .0 .0 .0 ambientColor .0 .0 .0} Transform {translation 0 .05 0}", "Cylinder {height .05 radius 15}", "Material { diffuseColor .7 .7 .7 } Transform { translation 0 .05 0 }", "DEF floor Separator {", "        Texture2Transform { scaleFactor 5 5 }", "        Texture2 { filename \"http://hpsdce.mayfield.hp.com/image/artbeat1.jpg\"}", "        Cube { width 10 height 0.1 depth 10 }", "}", "DEF wall Separator {", "	Transform { translation -4.85 .5 0 }", "        Texture2Transform { scaleFactor 10 1 }", "        Texture2 { filename \"http://hpsdce.mayfield.hp.com/image/stonewal.gif\"}", "	Cube { width .3 height 1 depth 10 }", "}", "Separator {", "	Transform { rotation 0 1 0 1.57 }", "        USE wall", "}", "DEF wall_struts Separator {", "	Material { ambientColor .2 .2 .1 diffuseColor .6 .6 .3 }", "Separator { #1", "	Transform { translation 0 3.95 4.95 }", "	Cube { width 10 height 0.1 depth 0.1 }", "}", "Separator { #2", "	Transform { translation 4.95 3.95 0 }", "	Cube { width 0.1 height 0.1 depth 10 }", "}", "Separator { #3", "	Transform { translation 0 3.95 -4.95 }", "	Cube { width 10 height 0.1 depth 0.1 }", "}", "Separator { #4", "	Transform { translation -4.95 3.95 0 }", "	Cube { width 0.1 height 0.1 depth 10 }", "}", "Separator { #5", "	Transform { translation 4.95 1.95 4.95 }", "	Cube { width 0.1 height 4 depth 0.1 }", "}", "Separator { #6", "	Transform { translation 4.95 1.95 -4.95 }", "	Cube { width 0.1 height 4 depth 0.1 }", "}", "Separator { #7", "	Transform { translation -4.95 1.95 -4.95 }", "	Cube { width 0.1 height 4 depth 0.1 }", "}", "Separator { #8", "	Transform { translation -4.95 1.95 4.95 }", "	Cube { width 0.1 height 4 depth 0.1 }", "}", "	Transform { translation 0 0 -1.5 }", "}", "Material {diffuseColor 0 0 0 ambientColor 0 0 0 specularColor 0 0 0}"}
;;#341.("aliases") = {"Courtyard"}
;;#341.("description") = "You are in the central area of the GOES Cutomer Education help system.  You see entrances to the Burgundy and Azure conference rooms to the northwest and northeast, and a support center to the east.  The ground here is fertile, covered with rich looking grass.  A stone wall runs along the west and south of this area."
;;#341.("object_size") = {8181, 937987212}
;;#341.("web_calls") = 543
;;#341.("url") = {"<img src=\"http://hppsda.mayfield.hp.com/image/webbie.gif\" height=\"48\" width=\"64\" align=\"right\"><p>", "What can you do here?  Look at the interaction frame at the bottom of the page.  You can talk to others by typing in the field at the very bottom of the page.  Also you can move to different rooms.  Scroll to the bottom of this frame to see a map of some rooms.<p>"}

@verb #341:"disfunc" this none this rxd #2
@program #341:disfunc
"Copied from The First Room (#62):disfunc by Wizard (#2) Tue Feb 10 05:59:28 1998 PST";
"Copied from The Coat Closet (#11):disfunc by Haakon (#2) Mon May  8 10:41:04 1995 PDT";
if ((((cp = caller_perms()) == (who = args[1])) || $perm_utils:controls(cp, who)) || (caller == this))
  "need the first check since guests don't control themselves";
  if (who.home == this)
    move(who, $limbo);
    this:announce("You hear a quiet popping sound; ", who.name, " has disconnected.");
  else
    pass(who);
  endif
endif
.

@verb #341:"enterfunc" this none this rxd #2
@program #341:enterfunc
"Copied from The First Room (#62):enterfunc by Wizard (#2) Tue Feb 10 05:59:44 1998 PST";
"Copied from The Coat Closet (#11):enterfunc by Haakon (#2) Mon May  8 10:41:38 1995 PDT";
who = args[1];
if ($limbo:acceptable(who))
  move(who, $limbo);
else
  pass(who);
endif
.

@verb #341:"match" this none this rxd #36
@program #341:match
"Copied from The First Room (#62):match by Hacker (#36) Tue Feb 10 05:59:55 1998 PST";
"Copied from The Coat Closet (#11):match by Lambda (#50) Mon May  8 10:42:01 1995 PDT";
m = pass(@args);
if (m == $failed_match)
  "... it might be a player off in the body bag...";
  m = $string_utils:match_player(args[1]);
  if (valid(m) && (!(m.location in {this, $limbo})))
    return $failed_match;
  endif
endif
return m;
.

@verb #341:"keep_clean" this none this rxd #2
@program #341:keep_clean
"Copied from The First Room (#62):keep_clean by Wizard (#2) Tue Feb 10 06:00:11 1998 PST";
"Copied from The Coat Closet (#11):keep_clean by Haakon (#2) Mon May  8 10:47:08 1995 PDT";
if ($perm_utils:controls(caller_perms(), this))
  junk = {};
  while (1)
    for x in (junk)
      $command_utils:suspend_if_needed(0);
      if (x in this.contents)
        "This is old junk that's still around five minutes later.  Clean it up.";
        if (!valid(x.owner))
          move(x, $nothing);
          #2:tell(">**> Cleaned up orphan object `", x.name, "' (", x, "), owned by ", x.owner, ", to #-1.");
        elseif (!$object_utils:contains(x, x.owner))
          move(x, x.owner);
          x.owner:tell("You shouldn't leave junk in ", this.name, "; ", x.name, " (", x, ") has been moved to your inventory.");
          #2:tell(">**> Cleaned up `", x.name, "' (", x, "), owned by `", x.owner.name, "' (", x.owner, "), to ", x.owner, ".");
        endif
      endif
    endfor
    junk = {};
    for x in (this.contents)
      if ((seconds_left() < 2) || (ticks_left() < 1000))
        suspend(0);
      endif
      if (!is_player(x))
        junk = {@junk, x};
      endif
    endfor
    suspend(5 * 60);
  endwhile
endif
.

@verb #341:"init_for_core" this none this rxd #2
@program #341:init_for_core
"Copied from The First Room (#62):init_for_core by Wizard (#2) Tue Feb 10 06:01:41 1998 PST";
"Copied from The Coat Closet (#11):init_for_core by Nosredna (#2487) Mon May  8 10:42:52 1995 PDT";
if (!caller_perms().wizard)
  return E_PERM;
endif
for v in ({"announce*", "emote", "button", "knob"})
  if (`verb_info($player_start, v) ! E_VERBNF => 0')
    delete_verb($player_start, v);
  endif
endfor
for p in ({"out", "quiet", "button"})
  if (p in properties($player_start))
    delete_property($player_start, p);
  endif
endfor
for p in ($object_utils:all_properties($room))
  clear_property($player_start, p);
endfor
$player_start.name = "The First Room";
$player_start.aliases = {};
$player_start.description = "This is all there is right now.";
$player_start.exits = $player_start.entrances = {};
.

"***finished***
