$Header: /repo/public.cvs/app/BioGate/BioMooCore/core113.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #113 with create
@create $webapp named <I><B>Be our Ghost! </B></I> - anonymous web viewer:<I><B>Be our Ghost! </B></I> - anonymous web viewer,anonview
@prop #113."max_lag" 10 rc
@prop #113."ghost_home" #341 r
;;#113.("code") = "anonview"
;;#113.("aliases") = {"<I><B>Be our Ghost! </B></I> - anonymous web viewer", "anonview"}
;;#113.("object_size") = {18717, 937987203}
;;#113.("web_calls") = 2380

@verb #113:"generate_exitlist" this none this rx
@program #113:generate_exitlist
"generate_exitlist() -> html text STR";
"Creates a string of hyperlinked exit names for player.location";
"This verb mostly just collects the exits and sends the list to";
"$web_utils:english_list_wth_urls";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((caller != this) && (!caller_perms().wizard))
  return E_PERM;
endif
code = this:get_code();
where = $object_utils:isa(args[1], $room) ? args[1] | this:closest_room(args[1]);
link1 = ("<A HREF=\"&LOCAL_LINK;/" + code) + "/";
link2 = "\">";
link3 = "</A>";
eol = "<P>";
line = "";
set_task_perms(player);
if ((inside = $set_utils:intersection($object_utils:ancestors(where), $web_utils.interior_rooms) && $object_utils:isa(where.location, $room)) || (exits = where:obvious_exits()))
  "Must be either inside an interior_room that's itself in a $room, or be in a place with obvious exits";
  if (inside)
    "in an interior_room";
    exits = where:obvious_exits();
    "add the 'out' exit";
    line = tostr("<B>The ", (length(exits) > 1) ? "exits are" | "exit is", ":</B> ", link1, tonum(where.location), link2, "out ", ("exitdetails" in player.web_options) ? (" (to " + where.location:title(1)) + ")" | "", link3);
    if (exits)
      if (length(exits) == 1)
        "only one exit so save ticks and do it here";
        toroom = ("exitdetails" in player.web_options) ? tostr(" (to ", exits[1].dest:title(1), ")") | "";
        line = tostr(line, " and ", link1, tonum(exits[1].dest), "#focus", link2, exits[1]:title(0), toroom, link3, ".");
      else
        line = ((line + ", ") + this:exitlist_with_urls(player, code, exits, "none")) + ".";
      endif
    else
      line = line + ".";
    endif
  else
    "in a $room";
    if (length(exits) == 1)
      "only one exit so save ticks and do it here";
      toroom = ("exitdetails" in player.web_options) ? tostr(" (to ", exits[1].dest:title(1), ")") | "";
      line = tostr("<B>The exit is:</B> ", link1, tonum(exits[1].dest), "#focus", link2, exits[1]:title(0), toroom, link3, ".");
    else
      line = tostr("<B>The exits are</B> ", this:exitlist_with_urls(player, code, exits, "none"), ".", eol);
    endif
  endif
  line = line + eol;
endif
return line;
"Last modified Mon Aug 26 15:50:20 1996 IDT by EricM (#3264).";
.

@verb #113:"get_code" this none this rx #95
@program #113:get_code
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return pass(@args);
"Last modified Tue Sep 26 15:26:33 1995 IST by EricM (#3264).";
.

@verb #113:"method_get method_post" this none this rx #95
@program #113:method_get
"method_get(who, what OBJ, rest STR, search STR) -> html text";
"method_post(who, what OBJ, rest STR, search STR, form STR) -> html";
"text";
"Allow anonymous browsing of the MOO.  At this time, it does";
"not permit web ghosts to see people or be seen, or to otherwise";
"communicate with them.  No interaction with MOO objects is permitted,";
"and in no <object>:html() is ever called.";
"WIZARDLY to set task perms to caller_perms()";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != $http_handler)
  return E_PERM;
elseif (length(args) < 3)
  return E_ARGS;
endif
if ((length($http_handler.task_index) > 5) || ($lag_meter.samples[$lag_meter.sample_count] > this.max_lag))
  return {tostr(player:namec(1), " in ", $network.MOO_name, " (", what:name() || ctime(), ")"), "<B>SORRY!</B> There's too much load on this server at the moment. Please try again in a while."};
  "Don't let anonymous users burden the web system; priority goes to people with a telnet connection too";
endif
"Increment this object's web_calls to see how many time's it's been used (since 9/13/95)";
this.web_calls = this.web_calls + 1;
set_task_perms(caller_perms());
code = this:get_code();
browser_code = $object_browser:get_code();
who = args[1];
what = args[2];
rest = args[3] || "";
search = args[4] || "";
errmsg = "";
if (1 == index(rest, "teleport"))
  if ((!index(search, ",")) && $string_utils:is_integer(search))
    "a direct command to teleport";
    what = toobj(search);
  else
    "user selected a teleportation imagemap";
    mapobj = toobj(strsub(rest, "teleport/", ""));
    mapobj = (mapobj == this) ? $teleporter | mapobj;
    coord = {tonum(search[1..(idx = index(search, ",")) - 1]), tonum(search[idx + 1..length(search)])};
    if (typeof(result = this:interpret_teleport(mapobj, coord)) == OBJ)
      what = result;
    else
      errmsg = result;
    endif
  endif
endif
what = (valid(what) && (what != $limbo)) ? what | this.ghost_home;
"<obj>.web_calls records how many times an object has had its html or do_post verb called by the Standard Viewer, from Apr 19, 1994";
valid(what) ? what.web_calls = what.web_calls + 1 | "";
if ($object_utils:isa(what, $room))
  where = what;
elseif ($object_utils:isa(where = this:closest_room(what), $room))
  "valid non-room object selected";
else
  where = what = this.ghost_home;
  errmsg = "You selected an invalid object. Sending you home....";
endif
set_task_perms($no_one);
"";
"Use object's URL/HTML plus description to create the focus area text";
"This section essentially copied from #1:html";
preformatted = what:get_web_setting("preformatted");
if (typeof(html = what:get_url()) == STR)
  html = $web_utils:build_MIME(html);
endif
html = listappend(html, "<P>");
if ($set_utils:intersection($object_utils:ancestors(what), $web_utils.interior_rooms) && ((desc = `what.interior_description ! E_PROPNF') || (desc = `what.inside_description ! E_PROPNF')))
  "show inside desc";
else
  desc = what:description();
endif
desc = (typeof(desc) == LIST) ? desc | {desc};
more = this:more_info_for_web(what);
if (desc in {{""}, {}, {"You see nothing special."}, {"no description"}})
  desc = more ? {} | {"In your anonymous, ghostlike state you can't quite make out what this is."};
endif
if ($object_utils:has_verb(what, "match_detail"))
  "it's a detailed object of somesort; let it deal with it's own text";
else
  "make sure the angle brackets in text are preserved";
  desc = $web_utils:html_entity_sub(desc);
  if (!preformatted)
    "This is a test, to see if it improves the look of the web descriptions.";
    desc = $web_utils:add_linebreaks(desc);
  endif
endif
if (is_player(what) && $object_utils:isa(what, $player))
  desc = {html ? $string_utils:pronoun_sub(tostr("<BR>", what:name(), " describes %p ", $network.MOO_name, " character as:<P>"), what) | "<HR><P>", @desc};
  html = {};
endif
html = {@html, "<hr>", @desc, "<hr>", @more};
"";
((seconds_left() < 2) || (ticks_left() < 4000)) ? suspend(1) | 0;
"Make sure the result is a list of strings";
finalhtml = {};
for line in (html)
  if ((type = typeof(line)) == LIST)
    finalhtml = {@finalhtml, @line};
  elseif (type == STR)
    finalhtml = {@finalhtml, line};
  else
    finalhtml = {@finalhtml, tostr(line)};
  endif
endfor
if (preformatted)
  finalhtml = {"<PRE>", @finalhtml, "</PRE>"};
endif
if (bodytag_attributes = what:get_web_setting("bodytag_attributes"))
  $http_handler:submit_taskprop("bodytag_attributes", bodytag_attributes);
endif
"finished working - prepare output";
link1 = ("<A HREF=\"&LOCAL_LINK;/" + code) + "/";
link2 = "\">";
link3 = "</A>";
eol = "<P>";
"BUTTONS";
buttons = this:web_viewer_buttons(where);
"MAP";
if ("map" in player.web_options)
  "get teleporter image map";
  map = this:teleporter_map(where, what);
else
  map = {};
endif
"ERROR MESSAGE FOR TELEPORTER IF ANY";
if (errmsg)
  text = {@text, tostr("<HR><B>", errmsg, "</B><HR>")};
endif
"YOU ARE WHERE";
browser_code = $object_browser:get_code();
you_are = {tostr("<A NAME=\"focus\">You</A> are a ghostly presence at <A HREF=\"&LOCAL_LINK;/", browser_code, "/browse_or_edit/browse/", tonum(where), "\"><B><FONT SIZE=+2>", where:namec(1), "</FONT></B></A>.")};
if (what != where)
  you_are = {@you_are, tostr("<BR>................examining <A HREF=\"&LOCAL_LINK;/", browser_code, "/browse_or_edit/browse/", tonum(what), "\"><B><FONT SIZE=+1>", what:namec(1), "</FONT></B></A>")};
endif
you_are[$] = you_are[$] + "<P>";
"ROOM CONTENTS";
contents = setremove(where:contents(), player);
if (length(contents) > 40)
  contents = contents[1..40];
  more = "<BR>There are many more objects or people here than you can distinguish.";
else
  more = "";
endif
people = things = {};
for item in (contents)
  if (is_player(item))
    people = {@people, item};
  else
    things = {@things, item};
  endif
endfor
if (things)
  what_here = $web_utils:list_english_list_with_urls(player, code, things);
  what_here[length(what_here)] = what_here[length(what_here)] + ".";
  what_here = {"<P><B>You see</B> ", @what_here};
else
  what_here = {};
endif
what_here = {@what_here, more};
"FIND PEOPLE";
presence = "";
clairvoyant = "";
for person in (people)
  if (person in connected_players())
    presence = "You see some people here (you can sign-in and talk to them). ";
    if ("ghosts" in person.web_options)
      person:tell(("At " + ctime()) + " you sense a web ghost.");
      clairvoyant = (clairvoyant + ", ") + person:title();
    endif
  endif
endfor
if (presence)
  who_here = {tostr(presence, clairvoyant, "<P>")};
else
  who_here = {};
endif
"EXITS";
exitlist = {"<P>", this:generate_exitlist(where)};
"WEBGHOST EXPLANATION";
ghosttext = {tostr("<P><HR>Visiting as a character and not just as a web ghost, which is what you are now, lets you talk to other people here (<B>there are ", length(connected_players()), " people connected right now</B>).  For instructions on how to do this see the <A HREF=\"http://", $network.site, ":", `$http_handler:retrieve_taskprop("port_handler").handles_port ! E_PROPNF, E_TYPE => $network.port', link2, "Web Gateway page", link3, ".  You'll need to be able to open a <A HREF=\"telnet://", $network.site, ":", $network.port, "\">telnet connection</A>.")};
ghosttext = {@ghosttext, "<BR>Web ghosts have additional limitations in that they can't see people or be seen, read signs or notes, or manipulate objects.  This is both to conserve computing resources for people actually inside, and to encourage you to come inside too and socialize.  Don't be shy!<BR>"};
ghosttext = {@ghosttext, tostr("This ghost user service has been used ", this.web_calls, " times.<HR>")};
"";
"add text of focus area and send the whole thing off";
text = {@you_are, @finalhtml, @who_here, @what_here, @exitlist, @buttons, @map, @ghosttext, "<A HREF=\"#header\"> [Top of page]</A>"};
return {tostr(player:namec(1), " in ", $network.MOO_name, " (", what:name() || ctime(), ")"), text};
"Last modified Tue Jul  1 20:22:15 1997 IDT by EricM (#3264).";
.

@verb #113:"closest_room" this none this rx
@program #113:closest_room
"Finds the first room enclosing the object";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
while (valid(what = what.location))
  if ($object_utils:isa(what, $room))
    return what;
  endif
endwhile
return what;
"Last modified Fri Aug  4 21:37:20 1995 IDT by EricM (#3264).";
.

@verb #113:"web_viewer_buttons" this none this rx
@program #113:web_viewer_buttons
"Create button bar for anonymous users";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
link0 = "<A HREF=\"&LOCAL_LINK;/";
link1 = tostr(link0, this:get_code(), "/");
link2 = "\">";
link3 = "</A>";
where = args[1];
buttons = {tostr(" [", link1, tonum(where), "#focus", link2, "<img src=\"http://hppsda.mayfield.hp.com/image/eye1.gif\" border=0><b>Look around</b>", link3, "]")};
if (where != player.home)
  buttons = {@buttons, tostr(" [", link1, tonum(player.home), "#focus", link2, "Home", link3, "]")};
endif
if (where != $teleporter.central_room)
  buttons = {@buttons, tostr(" [", link1, tonum($teleporter.central_room), "#focus", link2, $teleporter.central_room.name, link3, "]")};
endif
buttons = {@buttons, tostr(" [", "<A HREF=\"&LOCAL_LINK;/info/0/who\">Who's in ", $network.MOO_name, "?", link3, "]")};
buttons = {@buttons, tostr(" [", "<A HREF=\"http://", $network.site, ":", `$http_handler:retrieve_taskprop("port_handler").handles_port ! E_PROPNF, E_TYPE => $network.port', link2, "Web Gateway page", link3, "]")};
buttons = {@buttons, tostr(" [", "<A HREF=\"", $web_utils.MOO_home_page, link2, $network.MOO_name, " home page", link3, "]")};
buttons = {@buttons, tostr(" [", link0, $mail_browser:get_code(), link2, "Read mail", link3, "]")};
"WIZARD'S CHOICE";
if (`valid($web_utils.wizards_choice) ! E_PROPNF' && (wc_code = $web_utils.wizards_choice:get_code()))
  buttons = {@buttons, tostr("  [", "<A HREF=\"&LOCAL_LINK;/", wc_code, link2, "Wizard's Choice!", link3, "]")};
endif
if ($http_handler:retrieve_taskprop("http_version")[1] != "0")
  if (!$object_utils:isa(room = where, $room))
    while (valid(room) && (!$object_utils:isa(room = room.location, $room)))
    endwhile
    room = valid(room) ? room | where;
  endif
  buttons = {@buttons, tostr(" [<A HREF=\"&LOCAL_LINK;/", $std_vrml10viewer:get_code(), "/", tonum(room), "/room.wrl\"><B>VRML View</B></A>]")};
endif
buttons = {@buttons, " [<A HREF=\"#focus\">Focus</A>]"};
return {"<CENTER><HR>", @buttons, "<HR></CENTER>"};
"Last modified Tue Jul  1 20:26:30 1997 IDT by EricM (#3264).";
.

@verb #113:"english_list_with_urls list_english_list_with_urls exitlist_with_urls" this none this rx
@program #113:english_list_with_urls
"Modified so that the items listed get a 'the' adverb instead of 'an' or 'a'";
"Copied from webMOO code utilities (#3909):english_list_with_urls by EricM (#3264) Thu Sep 14 06:57:03 1995 IDT";
"Like $string_utils:english_list, but it converts objects to their names and adds url if needed";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
code = args[2];
args = args[3..length(args)];
link1 = ("<A HREF=\"&LOCAL_LINK;/" + code) + "/";
link2 = "#focus\">";
link3 = "</A>";
things = args[1];
showicons = !("hideicons" in player.web_options);
showdest = "exitdetails" in player.web_options;
markURL = "markURL" in player.web_options;
for i in [1..length(things)]
  object = things[i];
  if (showdest)
    additional_text = (" (to " + object.dest:title(1)) + ")";
  elseif (markURL && object:really_has_url(who))
    additional_text = "*";
  else
    additional_text = "";
  endif
  if ((showicons && (icon = object:get_icon())) && (typeof(icon) == STR))
    icon = ("<img src=\"" + icon) + "\" alt=\"\" align=\"center\" WIDTH=\"32\" HEIGHT=\"32\" BORDER=\"0\"> ";
  else
    icon = "";
  endif
  things[i] = (((((link1 + tostr(tonum(object.dest))) + link2) + icon) + object:title(1)) + additional_text) + link3;
endfor
if (verb[1..4] != "list")
  args[1] = things;
  return $string_utils:english_list(@args);
endif
nthings = length(things);
if (length(args) > 1)
  nothingstr = args[2];
else
  nothingstr = "nothing";
endif
if (length(args) > 2)
  andstr = args[3];
else
  andstr = " and ";
endif
if (length(args) > 3)
  commastr = args[4];
else
  commastr = ", ";
endif
if (length(args) > 4)
  finalcommastr = args[5];
else
  finalcommastr = ",";
endif
if (nthings == 0)
  return {nothingstr};
elseif (nthings == 1)
  return {tostr(things[1])};
elseif (nthings == 2)
  return {tostr(things[1], andstr, things[2])};
else
  ret = {};
  for k in [1..nthings - 1]
    if (k == (nthings - 1))
      commastr = finalcommastr;
    endif
    ret = {@ret, tostr(things[k], commastr)};
  endfor
  return {@ret, tostr(andstr, things[nthings])};
endif
"Last modified Sun Sep 17 08:50:24 1995 IST by EricM (#3264).";
.

@verb #113:"teleporter_map" this none this rx
@program #113:teleporter_map
"teleporter_map(where OBJ) -> html doc frg LIST";
"Create and return the teleporter map section of the web page";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
container = args[1];
oldwhat = args[2];
while (valid(container) && (!container.image_map))
  container = container.location;
endwhile
if (valid(container))
  map = container.image_map;
elseif (map = $teleporter.image_map)
  container = this;
else
  return {};
endif
return {tostr("<TABLE BORDER=5><TR><TD><A HREF=\"&LOCAL_LINK;/", this:get_code(), "/", tonum(oldwhat), "/teleport/", tonum(container), "#focus\"><IMG SRC=\"", map, "\" WIDTH=", $teleporter.default_mapsize[1], " HEIGHT=", $teleporter.default_mapsize[2], " ismap></A></TD></TR></TABLE>")};
"Last modified Mon Apr 29 06:36:34 1996 IDT by EricM (#3264).";
.

@verb #113:"interpret_teleport" this none this rx
@program #113:interpret_teleport
"interpret_teleport(mapobj OBJ, coordinated LIST) -> target OBJ or ERR";
"interpret map selection to derive target room";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
mapobj = args[1];
coords = args[2];
if (!(valid(mapobj) && (regions = mapobj.imagemap_regions)))
  return "Sorry, there seems to be a problem with the map.";
endif
idx = $web_utils:interpret_map(coords, regions);
if ((!idx) || (!valid(loc = mapobj.imagemap_rooms[idx])))
  return "You selected a point on the map not assigned to any place.";
endif
return loc;
"Last modified Mon Aug 26 15:26:31 1996 IDT by EricM (#3264).";
.

@verb #113:"more_info_for_web" this none this rx #95
@program #113:more_info_for_web
"more_info_for_web(what OBJ) -> html doc frg LIST";
"returns additional info associated with 'what' that anonymous users are allowed to see";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
info = {};
if (caller != this)
  return E_PERM;
endif
set_task_perms(perms = caller_perms());
if (is_player(what) && $object_utils:isa(what, $player))
  info = $web_geninfo:short_user_info($no_one, what);
elseif (($object_utils:has_verb(what, "read") && what:is_readable_by(perms)) && (text = what:text()))
  "note that the former tests benefit from this verb being -d";
  text = (typeof(text) == STR) ? {text} | text;
  info = {@info, tostr("<BR>The text on ", what:name(1), " reads:<P>", @$web_utils:plaintext_to_html(text))};
endif
return info;
"Last modified Sat Nov 11 11:27:57 1995 IST by EricM (#3264).";
.

@verb #113:"pp people_in" this none this rxd #177
@program #113:pp
"use the code on $teleporter";
return $teleporter:pp();
.

"***finished***
