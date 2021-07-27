$Header: /repo/public.cvs/app/BioGate/BioMooCore/core101.moo,v 1.1 2021/07/27 06:44:25 bruce Exp $

>@dump #101 with create
@create $thing named general teleporter object:general teleporter object,teleporter object,genteleporter,$teleporter
@prop #101."trusted_callers" {} r #95
;;#101.("trusted_callers") = {#117}
@prop #101."image_map" "http://hppsda.mayfield.hp.com/image/goesmapcrop.gif" r #95
@prop #101."imagemap_regions" {} r #95
;;#101.("imagemap_regions") = {{"rect", {2, 2}, {55, 80}}, {"rect", {60, 26}, {121, 82}}, {"rect", {11, 86}, {85, 159}}, {"rect", {90, 111}, {135, 151}}, {"rect", {140, 95}, {176, 137}}, {"rect", {180, 81}, {267, 160}}, {"rect", {185, 41}, {221, 76}}, {"rect", {185, 2}, {222, 36}}, {"rect", {234, 51}, {266, 70}}}
@prop #101."imagemap_rooms" {} r #95
;;#101.("imagemap_rooms") = {#347, #350, #341, #342, #201, #195, #62, #182, #337}
@prop #101."central_room" #341 r #95
@prop #101."default_mapsize" {} r #95
;;#101.("default_mapsize") = {266, 161}
@prop #101."made_maps" {} rc
;;#101.("made_maps") = {"000000", "000001", "000002", "000010", "000011", "000020", "000021", "000100", "000110", "000120", "000200", "001000", "001001", "001010", "001020", "001100", "002000", "002001", "002010", "002100", "003000", "010000", "010010", "010020", "011000", "012000", "020000", "021000", "022000", "100000", "100001", "100010", "100020", "100100", "101000", "101001", "101010", "101100", "102000", "110000", "111000", "200000", "201000", "300000", "X00000", "00X000", "103000", "002110", "002101", "003100", "001101", "011010", "001110", "002200", "001200", "011100", "001011", "000012", "003010", "102010", "301000", "211000", "310000", "300001", "300010", "300100", "210000", "200100", "110100", "100200", "100101", "100110", "201100", "101110", "201010", "111010", "101020", "101011", "202000", "102100", "101200", "00X100", "01X000", "10X000", "00X010", "00X001", "003001", "013000", "00X020", "010100", "000101", "003110", "003020", "00X030", "002011", "003030", "10X010", "01X010", "00X110", "002020", "001030", "002030", "103030", "00X120", "00X021", "0030X0", "00X022"}
@prop #101."needed_maps" {} rc
;;#101.("aliases") = {"general teleporter object", "teleporter object", "genteleporter", "$teleporter"}
;;#101.("description") = "You see nothing special.  Don't be deceived."
;;#101.("object_size") = {20436, 937987203}
;;#101.("web_calls") = 1029

@verb #101:"teleport_user" this none this rx #95
@program #101:teleport_user
"This is a general tool for teleporting users within the MOO. It requires:";
"args[1] - person to be moved";
"args[2] - place to move them to";
"It can take as additional arguments:";
"  args[3] - leave_succeeded_msg";
"  args[4] - oleave_succeeded_msg";
"  args[5] - leave_failed_msg";
"  args[6] - oleave_failed_msg";
"  args[7] - arrive_msg";
"  args[8] - oarrive_msg";
"If any of these optional arguments is empty, then the default is used.";
"If it is '$' however, that message is not displayed.  The default for";
"oleave_failed_msg and arrive_msg is no message displayed,";
"but all the other messages have suitable texts assigned as defaults.";
"  For purposes of the usual pronoun substitutions, 'thing' is the";
"destination, and 'location' is the origin.  The direct and indirect";
"objects are undefined.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
orig = who.location;
dest = args[2];
if (who.wizard && (!((caller in this.trusted_callers) || caller_perms().wizard)))
  return E_PERM;
elseif (!$object_utils:isa(dest, $room))
  return E_INVARG;
elseif (!is_player(who))
  return E_INVARG;
elseif (who.location == dest)
  who:tell("You are already there.");
  return 1;
elseif ($object_utils:isa(dest, $generic_editor))
  who:tell("Sorry, you can't enter an editor this way.");
  return E_INVARG;
endif
leave_succeeded_msg = args[3] || this:leave_succeeded_msg(who, dest);
oleave_succeeded_msg = args[4] || this:oleave_succeeded_msg(who, dest);
leave_failed_msg = args[5] || this:leave_failed_msg(who, dest);
oleave_failed_msg = args[6] || this:oleave_failed_msg(who, dest);
arrive_msg = args[7] || this:arrive_msg(who, dest);
oarrive_msg = args[8] || this:oarrive_msg(who, dest);
dest:bless_for_entry(who);
if (!dest:accept(who))
  who:tell("Sorry, but ", dest:name(1), " appears to be locked.  You can't go there.");
  if (oleave_failed_msg && (oleave_failed_msg != "$"))
    orig:announce_all_but({who}, who:name(), " ", $string_utils:pronoun_sub(oleave_failed_msg, who, dest, orig));
  endif
  return 0;
endif
if (leave_succeeded_msg && (leave_succeeded_msg != "$"))
  who:tell_lines($string_utils:pronoun_sub(leave_succeeded_msg, who, dest, orig));
endif
who:moveto(dest);
if (who.location != dest)
  if (leave_failed_msg && (leave_failed_msg != "$"))
    who:tell_lines($string_utils:pronoun_sub(leave_failed_msg, who, dest, orig));
  endif
  if (oleave_failed_msg && (oleave_failed_msg != "$"))
    orig:announce_all_but({who}, $string_utils:pronoun_sub(oleave_failed_msg, who, dest, orig));
  endif
  return 0;
endif
if (oleave_succeeded_msg && (oleave_succeeded_msg != "$"))
  orig:announce_all($string_utils:pronoun_sub(oleave_succeeded_msg, who, dest, orig));
endif
if (arrive_msg && (arrive_msg != "$"))
  who:tell_lines($string_utils:pronoun_sub(arrive_msg, who, dest, orig));
endif
if (oarrive_msg && (oarrive_msg != "$"))
  dest:announce_all_but({who}, $string_utils:pronoun_sub(oarrive_msg, who, dest, orig));
endif
return 1;
"Last modified Mon Nov  6 01:21:50 1995 IST by EricM (#3264).";
.

@verb #101:"leave_succeeded_msg" this none this rxd #95
@program #101:leave_succeeded_msg
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return ("You go to " + args[2]:name(1)) + ".";
"Last modified Mon Mar 11 00:14:12 1996 IST by EricM (#3264).";
.

@verb #101:"oleave_succeeded_msg" this none this rx #95
@program #101:oleave_succeeded_msg
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
return $string_utils:substitute(who.odepart_msg, {{"%T", "%N"}, {"%t", "%n"}}) || tostr(who:name(), " finds ", who.gender.pp || who.pp, " way out.");
"Last modified Tue Sep 19 16:14:58 1995 IST by Gustavo (#2).";
.

@verb #101:"leave_failed_msg" this none this rxd #95
@program #101:leave_failed_msg
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return ("It appears " + args[2]:name(1)) + " won't let you in.";
"Last modified Tue Dec  6 11:42:11 1994 IST by EricM (#3264).";
.

@verb #101:"oleave_failed_msg" this none this rxd #95
@program #101:oleave_failed_msg
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return "";
"Last modified Tue Dec  6 11:44:01 1994 IST by EricM (#3264).";
.

@verb #101:"arrive_msg" this none this rxd #95
@program #101:arrive_msg
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return "";
"Last modified Tue Dec  6 11:45:13 1994 IST by EricM (#3264).";
.

@verb #101:"oarrive_msg" this none this rx #95
@program #101:oarrive_msg
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
return $string_utils:substitute(who.oarrive_msg, {{"%T", "%N"}, {"%t", "%n"}}) || tostr(who:name(), " finds ", who.gender.pp || who.pp, " way in.");
"Last modified Tue Sep 19 16:16:07 1995 IST by Gustavo (#2).";
.

@verb #101:"move_user_for_web" this none this rxd #95
@program #101:move_user_for_web
"move_user_for_web(who OBJ, where OBJ) -> none";
"does the actual user movement for $teleporter:html and the VRML system";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
where = args[2];
if (!(((caller in {this, $std_vrml10viewer}) || caller_perms().wizard) || $perm_utils:controls(caller_perms(), who)))
  return E_PERM;
endif
if (exit = where in who.location.exits)
  who.location.exits[exit]:invoke();
  return;
elseif ((valid(who.location.location) && (where == who.location.location)) && $set_utils:intersection($object_utils:ancestors(who.location), $web_utils.interior_rooms))
  who.location:out();
  return;
elseif (!$object_utils:isa(where, $room))
  who:tell(where:namec(1), " is not a place you can go to.");
  return;
elseif (where == who.location)
  who:tell("You are already there!");
  return;
elseif ($object_utils:isa(where, $generic_editor))
  who:tell("Sorry, you can't enter an editor this way.");
  return;
endif
old_loc = who.location;
who:moveto(where);
if (who.location != old_loc)
  old_loc:announce($string_utils:pronoun_sub(this:odepart_msg(who), who, who, old_loc));
  who.location:announce_all_but({who}, $string_utils:pronoun_sub(this:oarrive_msg(who), who, who, who.location));
  who:tell($string_utils:pronoun_sub(this:leave_succeeded_msg(who, where)));
else
  who:tell($string_utils:pronoun_sub(this:leave_failed_msg(who, where)));
endif
if (who.location != where)
  who:tell("Hmmm... Looks like you haven't arrived at ", where:name(1), " after all.");
  if (msg = this:oleave_failed_msg(who, where))
    who.location:announce_all_but({who}, who:name(), " ", $string_utils:pronoun_sub(msg));
  endif
endif
"Last modified Mon Apr  8 07:48:28 1996 IDT by EricM (#3264).";
.

@verb #101:"html" this none this rx #95
@program #101:html
"html(who, rest STR, search STR) -> $nothing or an HTML frg LIST";
"This verb performs a variety of functions involving user teleporting via the web system";
"The results of various URL specs are as follows:";
"rest='home' send user to player.home";
"rest='central_room' send user to this.central_room";
"rest='teleport' search='object' send user to 'object'";
"rest='object' return imagemap associated with 'object";
"rest='object' search='X,Y' teleport user based on imagemap associated with 'object' to coord 'X,Y'";
"rest='' search='X,Y' teleport user based on imagemap associated with player.location, to coord 'X,Y'";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((player.wizard && (!(caller in {$standard_webviewer, $web_geninfo, @this.trusted_callers}))) && (!caller_perms().wizard))
  return E_PERM;
  "note that move restrictions are only imposed on moving wizard characters";
endif
who = player;
rest = args[2];
search = args[3];
"First check if it's a web request to teleport the user, apart from any imagemap stuff";
if (rest == "home")
  player:home();
  return $nothing;
elseif (rest == "central_room")
  this:move_user_for_web(who, this.central_room);
  return $nothing;
elseif ((rest == "teleport") && valid(where = toobj(search)))
  "it's a @go request via the web";
  "if path has form '.../teleport?9999' then teleport to object 9999";
  this:move_user_for_web(who, where);
  return $nothing;
endif
set_task_perms(caller_perms());
if ((rest && valid(container = toobj(rest))) && (map = container.image_map))
  "use image map associated with object specified by 'rest' if valid";
  rooms = container.imagemap_rooms;
  regions = container.imagemap_regions;
elseif (rest && (!(valid(container) && container.image_map)))
  player:tell("There seems to be an error in the teleporter map you selected. You don't move anywhere.");
  return $nothing;
else
  "Find the appropriate image map for the user, by starting from player.location";
  "and working outward until a container/room with an .image_map property is found";
  container = player.location;
  while (valid(container) && (!container.image_map))
    container = container.location;
  endwhile
  if (!valid(container))
    "use the MOO's default image map";
    map = this.image_map;
    container = this;
  endif
endif
if (container != this)
  "only set map if we haven't just set it the line before....";
  map = container.image_map;
endif
rooms = container.imagemap_rooms;
regions = container.imagemap_regions;
if (!search)
  "return HTML frg for inserting MOO's default teleport map";
  "note that if no value for $teleporter.default_mapsize is given, no size is specified for the browser, which may delay pasteup of the web page; however, if you give a map size, all maps must be that size or the region mapping will be off";
  mapsize_spec = this.default_mapsize ? tostr(" WIDTH=", this.default_mapsize[1], " HEIGHT=", this.default_mapsize[2]) | "";
  return map ? {tostr("<TABLE BORDER=5><TR><TD><A HREF=\"&LOCAL_LINK;/view/", tonum(this), "/", tonum(container), "\"><IMG SRC=\"", map, "\"", mapsize_spec, " ismap></A></TD></TR></TABLE>")} | {};
endif
"This call is an image map selection requesting the user be teleported";
coord = {tonum(search[1..(idx = index(search, ",")) - 1]), tonum(search[idx + 1..length(search)])};
idx = $web_utils:interpret_map(coord, regions);
if ((!idx) || (!valid(loc = rooms[idx])))
  player:tell("You selected a point on the map not assigned to any place.");
  return $nothing;
endif
this:move_user_for_web(who, loc);
return $nothing;
"Last modified Tue Jul  1 19:51:21 1997 IDT by EricM (#3264).";
.

@verb #101:"odepart_msg" this none this rx #95
@program #101:odepart_msg
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
return $string_utils:substitute(who.odepart_msg, {{"%T", "%N"}, {"%t", "%n"}}) || tostr(who:name(), " finds ", who.gender.pp || who.pp, " way out.");
"Last modified Tue Sep 19 16:16:38 1995 IST by Gustavo (#2).";
.

@verb #101:"init_for_core" this none this
@program #101:init_for_core
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || caller_perms().wizard))
  return E_PERM;
endif
this.trusted_callers = {};
this.imape_mag = "";
this.imagemap_regions = {};
this.imagemap_rooms = {};
return pass(@args);
"Last modified Wed Aug 21 22:44:52 1996 IDT by EricM (#3264).";
.

@verb #101:"pp people_in" this none this rxd #177
@program #101:pp
"Do only 6 rooms of the map.  Make the nice graphic specifier string.";
mag = "";
for room in ($teleporter.imagemap_rooms[1..6])
  mag = mag + tostr(((ln = length($set_utils:intersection(room.contents, connected_players()))) < 4) ? ln | "X");
endfor
if (!(mag in this.made_maps))
  this.needed_maps = setadd(this.needed_maps, mag);
  #179:receive_page((("Map pages, \"Need map `" + "goesmapcrop") + mag) + "'\"");
else
  #179:tell("[+][Helpers] Doit: /bin/cp /home/wsk/master_images/map/goesmapcrop", mag, ".gif /home/wsk/master_images/map/goesmapcrop.gif");
endif
return mag;
.

@verb #101:"html(ori)" this none this rx #95
@program #101:html(ori)
"Copied from general teleporter object (#101):html by BioGate_wizard (#95) Sun Mar  1 02:06:33 1998 PST";
"html(who, rest STR, search STR) -> $nothing or an HTML frg LIST";
"This verb performs a variety of functions involving user teleporting via the web system";
"The results of various URL specs are as follows:";
"rest='home' send user to player.home";
"rest='central_room' send user to this.central_room";
"rest='teleport' search='object' send user to 'object'";
"rest='object' return imagemap associated with 'object";
"rest='object' search='X,Y' teleport user based on imagemap associated with 'object' to coord 'X,Y'";
"rest='' search='X,Y' teleport user based on imagemap associated with player.location, to coord 'X,Y'";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((player.wizard && (!(caller in {$standard_webviewer, $web_geninfo, @this.trusted_callers}))) && (!caller_perms().wizard))
  return E_PERM;
  "note that move restrictions are only imposed on moving wizard characters";
endif
who = player;
rest = args[2];
search = args[3];
"First check if it's a web request to teleport the user, apart from any imagemap stuff";
if (rest == "home")
  player:home();
  return $nothing;
elseif (rest == "central_room")
  this:move_user_for_web(who, this.central_room);
  return $nothing;
elseif ((rest == "teleport") && valid(where = toobj(search)))
  "it's a @go request via the web";
  "if path has form '.../teleport?9999' then teleport to object 9999";
  this:move_user_for_web(who, where);
  return $nothing;
endif
set_task_perms(caller_perms());
if ((rest && valid(container = toobj(rest))) && (map = container.image_map))
  "use image map associated with object specified by 'rest' if valid";
  rooms = container.imagemap_rooms;
  regions = container.imagemap_regions;
elseif (rest && (!(valid(container) && container.image_map)))
  player:tell("There seems to be an error in the teleporter map you selected. You don't move anywhere.");
  return $nothing;
else
  "Find the appropriate image map for the user, by starting from player.location";
  "and working outward until a container/room with an .image_map property is found";
  container = player.location;
  while (valid(container) && (!container.image_map))
    container = container.location;
  endwhile
  if (!valid(container))
    "use the MOO's default image map";
    map = this.image_map;
    container = this;
  endif
endif
map = container.image_map;
rooms = container.imagemap_rooms;
regions = container.imagemap_regions;
if (!search)
  "return HTML frg for inserting MOO's default teleport map";
  "note that if no value for $teleporter.default_mapsize is given, no size is specified for the browser, which may delay pasteup of the web page; however, if you give a map size, all maps must be that size or the region mapping will be off";
  mapsize_spec = this.default_mapsize ? tostr(" WIDTH=", this.default_mapsize[1], " HEIGHT=", this.default_mapsize[2]) | "";
  return map ? {tostr("<CENTER><TABLE BORDER=8><TR><TD><A HREF=\"&LOCAL_LINK;/view/", tonum(this), "/", tonum(container), "\"><IMG SRC=\"", map, "\"", mapsize_spec, " ismap></A></TD></TR></TABLE></CENTER>")} | {};
endif
"This call is an image map selection requesting the user be teleported";
coord = {tonum(search[1..(idx = index(search, ",")) - 1]), tonum(search[idx + 1..length(search)])};
idx = $web_utils:interpret_map(coord, regions);
if ((!idx) || (!valid(loc = rooms[idx])))
  player:tell("You selected a point on the map not assigned to any place.");
  return $nothing;
endif
this:move_user_for_web(who, loc);
return $nothing;
"Last modified Tue Jul  1 19:51:21 1997 IDT by EricM (#3264).";
.

"***finished***
