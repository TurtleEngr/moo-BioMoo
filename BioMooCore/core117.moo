$Header: /repo/public.cvs/app/BioGate/BioMooCore/core117.moo,v 1.1 2021/07/27 06:44:27 bruce Exp $

>@dump #117 with create
@create $webapp named <B>Standard Web Viewer</B>:<B>Standard Web Viewer</B>,standard viewer,standard web viewer,web viewer,standard_webviewer,webviewer
@prop #117."find_clients_text" {} rc
;;#117.("find_clients_text") = {"An <A HREF=\"http://www.math.okstate.edu/~jds/mudfaq-p2.html\">extensive", "FAQ about MUD/MOO clients</A> is availabe, or check out this shorter", "<A HREF=\"http://bioinformatics.weizmann.ac.il/BioMOO/reference/Clients.FAQ\">recommended", "clients list.</A>", "<P>"}
@prop #117."no_anonymous_txt" {} rc
;;#117.("no_anonymous_txt") = {"Sorry, you have to also have open a parallel telnet/client connection to the MOO to use the Standard Viewer.", "You can connect by <A HREF=\"telnet://{MOO_site}:{MOO_port}\">telnet</A> into <B>{MOO_name}</B>, but it is recommended that you get a better client program.<P>"}
;;#117.("code") = "view"
;;#117.("available") = 1
;;#117.("aliases") = {"<B>Standard Web Viewer</B>", "standard viewer", "standard web viewer", "web viewer", "standard_webviewer", "webviewer"}
;;#117.("description") = {"  This is the primary tool for seeing into the MOO via the web.", "Although any user can create a webapp which can serve as a viewer,", "this one is provided as the default for all users.  It handles", "information (telling the user what's around them; allowing them to", "look at objects), and some limited actions (movement from room to", "room via exits, and teleporting)."}
;;#117.("object_size") = {20043, 937987203}

@verb #117:"available" this none this rx
@program #117:available
"available(who OBJ) -> BOOLEAN";
"Don't add the standard viewer to the list of webapps for anonymous";
"web calls.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return args[1] != $no_one;
"  Note that non-connected, registered users will see this";
"webapp on their list, even though they won't be able to connect to";
"it. They can then connect and select this webapp.";
"Last modified Tue Aug  1 03:03:46 1995 IDT by EricM (#3264).";
.

@verb #117:"generate_exitlist" this none this rx #95
@program #117:generate_exitlist
"generate_exitlist() -> html text STR";
"Creates a string of hyperlinked exit names for player.location";
"This verb mostly just collects the exits and sends the list to";
"$web_utils:english_list_wth_urls";
"WIZARDLY to enable setting task perms to caller_perms()";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((caller != this) && (!caller_perms().wizard))
  return E_PERM;
endif
code = this.code;
set_task_perms(caller_perms());
where = $object_utils:isa(args[1], $room) ? args[1] | player.location;
if (!valid(where))
  return {"No exits could be found ($standard_webviewer:generate_exitlist was sent an invalid `where' value)."};
endif
link1 = ("<A HREF=\"&LOCAL_LINK;/" + code) + "/";
link2 = "\">";
link3 = "</A>";
line = "";
if ((inside = $set_utils:intersection($object_utils:ancestors(where), $web_utils.interior_rooms) && $object_utils:isa(where.location, $room)) || (exits = where:obvious_exits()))
  "Must be either inside an interior_room that's itself in a $room, or be in a place with obvious exits";
  if (inside)
    "in an interior_room";
    exits = where:obvious_exits();
    "add the 'out' exit";
    line = tostr(link1, tonum(where), "/exit#focus", link2, "out", ("exitdetails" in player.web_options) ? (" (to " + where.location:title(1)) + ")" | "", link3);
    if (exits)
      if (length(exits) == 1)
        "save ticks and do it here";
        toroom = ("exitdetails" in player.web_options) ? tostr(" (to ", exits[1].dest:title(1), ")") | "";
        line = tostr(line, " and ", link1, tonum(exits[1]), "#focus", link2, exits[1]:title(0), toroom, link3, ".");
      else
        line = ((line + ", ") + $web_utils:english_list_with_urls(player, code, exits, "none")) + ".";
      endif
    else
      line = line + ".";
    endif
  else
    "in a $room";
    line = $web_utils:english_list_with_urls(player, code, exits, "none") + ".";
  endif
endif
return {"<B>Obvious exits:</B>", (exits || inside) ? tostr("<!--BLOCKQUOTE-->", line, "<!--/BLOCKQUOTE-->") | " (none)"};
return line;
"Last modified Wed Oct 30 17:24:40 1996 IST by EricM (#3264).";
.

@verb #117:"command_form" this none this rx
@program #117:command_form
"command_form() -> html text LIST";
"Generates the command form for inclusion in the standard web page";
"This includes various common MOO commands, presented in a web form";
"format.  The web-option switch 'commandform' determines if the form";
"will be included, and various other switches determine what should";
"appear in the form.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
webops = player.web_options;
"the 'checked' function allows earlier lines of the form to claim precendence as commands that are preselected";
checked = 0;
text = {tostr("<FORM ACTION=\"&LOCAL_LINK;/", this:get_code(), "/", tonum(this), "\" METHOD=POST>")};
"-- say, emote, and other 'in room' communication commands";
if (!("nosay" in webops))
  text = {@text, tostr("<INPUT TYPE=\"submit\" VALUE=\"Do command\"><INPUT TYPE=\"radio\" NAME=\"action\" VALUE=\"say\" ", checked ? "" | "CHECKED", ">")};
  text = {@text, "<SELECT NAME=\"saytype\"><OPTION VALUE=\"say\">say <OPTION VALUE=\"emote\">emote"};
  "--can add more 'social verb' options here";
  text = {@text, "<OPTION VALUE=\"smiles\">smile <OPTION VALUE=\"grins\">grin"};
  text = {@text, "<OPTION VALUE=\"waves\">wave <OPTION VALUE=\"bows\">bow"};
  text = {@text, "<OPTION VALUE=\"laughes\">laugh <OPTION VALUE=\"giggles\">giggle"};
  text = {@text, "<OPTION VALUE=\"chuckles\">chuckle <OPTION VALUE=\"winks\">wink"};
  text = {@text, "<OPTION VALUE=\"frowns\">frown <OPTION VALUE=\"gasps\">gasp"};
  text = {@text, "<OPTION VALUE=\"moans\">moan <OPTION VALUE=\"sobs\">sob"};
  "-- end of additional social verbs list";
  text = {@text, "</SELECT><INPUT NAME=\"saytext\" SIZE=40><BR>"};
  checked = 1;
endif
"-- page, @join, and @info options";
if (length(setremove(cp = connected_players(), player)))
  if (!("nopage" in webops))
    "include 'page' button";
    text = {@text, "<INPUT TYPE=\"radio\" NAME=\"action\" VALUE=\"page\">Page "};
  endif
  text = {@text, "<INPUT TYPE=\"radio\" NAME=\"action\" VALUE=\"join\">Join <INPUT TYPE=\"radio\" NAME=\"action\" VALUE=\"info\" ", checked ? "" | "CHECKED", ">Info about"};
  text = {@text, "<SELECT NAME=\"who\">"};
  "collect names of connected players for option list";
  for person in (cp)
    text = {@text, tostr(("<OPTION VALUE=\"" + tostr(tonum(person))) + "\">", person:name(1), ", at ", person.location:name(1))};
  endfor
  text = {@text, "</SELECT>"};
  if (!("nopage" in webops))
    "include 'page' text field";
    text = {@text, "<BR>Page message: <INPUT NAME=\"pagetext\" SIZE=50>"};
  endif
endif
"--@go option";
if (!("nogo" in webops))
  "include '@go' command";
  text = {@text, "<BR><INPUT TYPE=\"radio\" NAME=\"action\" VALUE=\"go\">Go to <INPUT NAME=\"where\" SIZE=20>"};
  roomlist = {};
  if ($local.default_rooms)
    roomlist = {@roomlist, @$local.default_rooms};
  endif
  if (player.rooms)
    roomlist = {@roomlist, @player.rooms};
  endif
  if (roomlist)
    text = {@text, "<SELECT NAME=\"room\">"};
    text = {@text, "<OPTION VALUE=\"\">(or choose from this list)"};
    for room in (roomlist)
      text = {@text, tostr("<OPTION VALUE=\"", tonum(room[2]), "\">", room[1])};
    endfor
    text = {@text, "</SELECT>"};
  endif
endif
text = (length(text) < 2) ? {} | {@text, "<INPUT TYPE=\"submit\" VALUE=\"Do command\"></FORM>"};
return text;
"Last modified Wed Oct  9 21:19:06 1996 IST by EricM (#3264).";
.

@verb #117:"do_post" this none this rx #95
@program #117:do_post
"do_post(who OBJ, rest STR, search STR, form STR) -> html text LIST";
"Catches posts from the optional command form section of the standard";
"viewer's page.  Handles commands for go, page, join, and info.";
"WIZARDLY to enable setting task perms to caller_perms()";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
set_task_perms(caller_perms());
who = args[1];
rest = args[2];
search = args[3];
"parse form into {{fields},{values}} format";
form = $web_utils:parse_form(args[4], 2);
fields = form[1];
if (form[2]["action" in fields] == "say")
  saytype = form[2]["saytype" in fields];
  saytext = form[2]["saytext" in fields];
  if (saytype == "say")
    if (argstr = saytext)
      player.location:say($string_utils:explode(saytext));
    else
      player:tell("You start to speak, but stay silent instead.");
    endif
  elseif (saytype == "emote")
    if (argstr = saytext)
      player.location:emote($string_utils:explode(saytext));
    else
      player:tell("You keep your feelings to yourself.");
    endif
  else
    "user can prefix what they enter with ':' to make it into an emotional emote";
    if (saytext in {"", ":", "::"})
      saytext = "";
    elseif (saytext[1] == ":")
      saytext = saytext[2..length(saytext)];
      saytext = (saytext[1] == ":") ? saytext[2..length(saytext)] | (" " + saytext);
    else
      saytext = tostr(" and says, \"", saytext, "\"");
    endif
    argstr = tostr(player:verb_sub(saytype), saytext);
    player.location:emote($string_utils:explode(argstr));
  endif
  return $nothing;
elseif (form[2]["action" in fields] == "info")
  "command form request for 'info <user>'";
  text = (person = toobj(form[2]["who" in fields])):description();
  text = (typeof(text) == STR) ? {text} | text;
  return {@text, @$web_geninfo:short_user_info(who, person)};
elseif (form[2]["action" in fields] == "join")
  "command form request to 'join <user>'";
  dobj = toobj(form[2]["who" in fields]);
  dobjstr = dobj.name;
  player:_join(dobj);
  return $nothing;
elseif (form[2]["action" in fields] == "page")
  "command form request to 'page <user> <msg>";
  pagetext = form[2]["pagetext" in fields];
  args = {toobj(form[2]["who" in fields]).name, @$string_utils:explode(pagetext)};
  player:page(@args);
  return $nothing;
elseif (form[2]["action" in fields] == "go")
  "command form request to @go <room>";
  where = form[2]["where" in fields];
  if (((!where) && (room = form[2]["room" in fields])) && $string_utils:is_numeric(room))
    "user selected a room from their @rooms listing";
    where = tostr(toobj(room));
  endif
  "This next section is copied from $player:@go";
  if (!where)
    player:tell("No place specified to go to.");
    return $nothing;
  elseif (valid(player.location:match_exit(where)))
    player.location:walk(where);
    return $nothing;
  elseif ((where in {"out", "outside"}) && $set_utils:intersection($object_utils:ancestors(player.location), $web_utils.interior_rooms))
    player.location:out();
    return $nothing;
  endif
  if ((room = player:match_room(where)) != E_VERBNF)
    "MOO uses a BioCore $player:match_room system";
    if ((typeof(room) != LIST) || (length(room) < 2))
      return player:tell("Either your $player:match_room verb is buggy, or your MOO hasn't implemented room name matching. Please see one of the MOO administrators.");
    elseif (!room[1])
      player:tell_lines(room[2..length(room)]);
      return $nothing;
    endif
    room = room[2];
  elseif ((room = player:lookup_room(where)) != E_VERBNF)
    "MOO has a Diversity University style room system";
    if (!valid(room))
      player:tell("Sorry, but \"", where, "\" doesn't seem to match any room you know.");
      return $nothing;
    endif
  else
    player:tell("Sorry, your MOO doesn't appear to support teleporting via this web form.  Please see one of the MOO administrators.");
    return $nothing;
  endif
  if (valid(room))
    if ($object_utils:isa(room, $garbage))
      player:tell("It looks like the place you're trying to get to has been recycled!");
      return $nothing;
    elseif (!$object_utils:isa(room, $room))
      player:tell(room:namec(1), " is not a room.");
      return $nothing;
    elseif (room == player.location)
      player:tell("You are already there!");
      return $nothing;
    endif
    $teleporter:teleport_user(player, room);
    return $nothing;
  else
    return $nothing;
  endif
endif
return pass(@args);
"Last modified Wed Oct  9 21:24:17 1996 IST by EricM (#3264).";
.

@verb #117:"closest_room" this none this rx
@program #117:closest_room
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

@verb #117:"get_code" this none this rx
@program #117:get_code
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return pass(@args);
"Last modified Tue Sep 26 14:34:01 1995 IST by EricM (#3264).";
.

@verb #117:"method_get method_post" this none this rx #95
@program #117:method_get
"method_get(who, what OBJ, rest STR, search STR) -> html text";
"method_post(who, what OBJ, rest STR, search STR, form STR) -> html text";
"Builds the actually web page, including calls for determining what";
"objects are present, what exits are available, and also calls the";
"'focus' object and includes the result in the focus area of the";
"page.";
"WIZARDLY to set task perms to caller_perms()";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != $http_handler)
  return E_PERM;
elseif (length(args) < 3)
  return E_INVARG;
endif
code = this.code;
MOO_site = ("use_ip" in player.web_options) ? $network.numeric_address | $network.site;
browser_code = $object_browser.code;
"args[1] isn't used at this time";
junk = args[1];
if (!(player in connected_players()))
  text = this.no_anonymous_txt;
  for line in [1..length(text)]
    text[line] = $string_utils:substitute(text[line], {{"{MOO_name}", $network.MOO_name}, {"{MOO_site}", tostr($network.site)}, {"{MOO_port}", tostr($network.port)}});
  endfor
  return {tostr(player:name(), " in ", $network.MOO_name), {@text, @this.find_clients_text}};
endif
where = player.location;
what = args[2];
rest = args[3];
"<obj>.web_calls records how many times an object has had its html or do_post verb called by the Standard Viewer, from Apr 19, 1994";
valid(what) ? what.web_calls = what.web_calls + 1 | "";
set_task_perms(player);
"DEAL WITH TOGGLES";
"('+<option>+' anywhere in 'rest')";
args[3] = rest = this:webop_changes(rest);
"GET AN OBJECT'S HTML+DESCRIPTION";
"Call what:html or do_post, but allow a few redirections.";
redir = 4;
sendargs = listdelete(args, 2);
while ((redir = redir - 1) > 0)
  html = what:((verb != "method_get") ? "do_post" | "html")(@sendargs);
  ((seconds_left() < 2) || (ticks_left() < 4000)) ? suspend(1) | 0;
  if ((valid(html[1]) && valid(html[2])) && $object_utils:isa(html[1], $room))
    "object specifically requests a redirection to a new 'where' and 'what' by returning a list of two objects: {where, what}";
    where = html[1];
    what = html[2];
    verb = "method_get";
    sendargs = {sendargs[1]};
  elseif (html == $nothing)
    "If the object specifically requests it by returning $nothing, then a fresh web page for user location is created";
    what = where = player.location;
    verb = "method_get";
    sendargs = {sendargs[1]};
  else
    "was a standard response (hopefully), so move on";
    redir = 1;
  endif
endwhile
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
  ((seconds_left() < 2) || (ticks_left() < 4000)) ? suspend(1) | 0;
endfor
"SET-UP GENERAL PAGE ATTRIBUTES";
if (bodytag_attributes = what:get_web_setting("bodytag_attributes"))
  $http_handler:submit_taskprop("bodytag_attributes", bodytag_attributes);
endif
if (what:get_web_setting("hide_banner"))
  $http_handler:submit_taskprop("hide_banner", 1);
endif
"finished working - prepare output";
link1 = ("<A HREF=\"&LOCAL_LINK;/" + code) + "/";
link2 = "\">";
link3 = "</A>";
eol = "<P>";
options = player.web_options;
"BUTTON BAR";
buttons = player:web_viewer_buttons(code, what);
"MAP(S)";
if ("map" in options)
  map = $teleporter:html(args[1], 0, 0);
else
  map = {};
endif
"WHO AND WHERE";
you_icon = player.icon ? tostr("<IMG SRC=\"", player.icon, "\" WIDTH=32 HEIGHT=32 BORDER=0>") | "";
roomicon = where.icon ? tostr("<IMG SRC=\"", where.icon, "\" WIDTH=32 HEIGHT=32>") | "";
you_are = {tostr(eol, link1, tonum(player), "#focus", "\" NAME=\"focus", link2, you_icon, "You", link3, " are at ", roomicon, " <A HREF=\"&LOCAL_LINK;/", browser_code, "/browse_or_edit/browse/", tonum(where), "\"><B><FONT SIZE=+2>", where:namec(1), "</FONT></B></A>")};
if (what != where)
  whaticon = what.icon ? tostr("<IMG SRC=\"", what.icon, "\" WIDTH=32 HEIGHT=32 BORDER=0>") | "";
  you_are = {@you_are, tostr("<BR>................examining ", whaticon, " <A HREF=\"&LOCAL_LINK;/", browser_code, "/browse_or_edit/browse/", tonum(what), "\"><B><FONT SIZE=+1>", what:namec(1), "</FONT></B></A>")};
endif
you_are = {@listdelete(you_are, len = length(you_are)), you_are[len] + ".<BR>"};
"ROOM CONTENTS";
in_room = where:tell_contents_for_web(setremove(where:contents(), player));
in_room = (typeof(in_room) == LIST) ? in_room | {in_room};
in_room = {"", @in_room};
"EXITS";
exitlist = this:generate_exitlist(where) || {};
exitlist = (typeof(exitlist) == LIST) ? exitlist | {exitlist};
exitlist[$] = exitlist[$] + eol;
"INVENTORY LIST";
if (("inv" in options) && (contents = player:contents()))
  carrying = $web_utils:list_english_list_with_urls(player, code, contents);
  carrying = {"You are carrying: ", @(typeof(carrying) == LIST) ? carrying | {carrying}, "." + eol};
else
  carrying = {};
endif
"COMMAND FORM";
if ("commandform" in options)
  command_form = {@this:command_form(), "<HR>"} || {};
else
  command_form = {};
endif
"EMBEDDED VRML";
if ("embedVRML" in player.web_options)
  embeddedVRML = (typeof(embeddedVRML = this:embedVRML(what)) == LIST) ? embeddedVRML | {embeddedVRML};
  if (1)
    finalhtml = {@embeddedVRML, @finalhtml};
  else
    finalhtml = {"<TABLE BORDER=0 VALIGN=\"BOTTOM\"><TR><TD>", @finalhtml, "</TD><TD>", @embeddedVRML, "</TD></TABLE><P>"};
  endif
endif
"BUILD THE PAGE";
text = {@you_are, "<hr>", @finalhtml, "<hr>", @in_room, @exitlist, @carrying, @buttons, @command_form, @map};
text = {@text, tostr("<P><A HREF=\"#header\"> [Top of page]</A>")};
return {tostr(player:namec(1), " in ", $network.MOO_name, " (", what:name() || ctime(), ")"), text};
"Last modified Wed Oct 30 17:38:15 1996 IST by EricM (#3264).";
.

@verb #117:"webop_changes" this none this rx #95
@program #117:webop_changes
"webop_changes(rest STR) -> new rest STR";
"Hunt for web option toggles ('+<option>[+-]' anywhere in 'rest')";
"Return 'rest' with toggles removed.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller_perms() == player) || $perm_utils:controls(caller_perms(), player)))
  return E_PERM;
endif
rest = args[1];
options = player.web_options;
for option in ($web_options.names)
  if (stuff = match(rest, tostr("%+", option, "[+-]")))
    if (rest[stuff[2]] == "+")
      player.web_options = options = setadd(options, option);
    else
      player.web_options = options = setremove(options, option);
    endif
    rest[stuff[1]..stuff[2]] = "";
  endif
endfor
return rest;
"Last modified Sun Aug 25 09:50:16 1996 IDT by Gustavo (#2).";
.

@verb #117:"embedVRML" this none this rx
@program #117:embedVRML
"embedVRML(what) -> html frg";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
"add an <embed> link to insert a VRML file (the room view) into the web page";
type = ($object_utils:isa(what, $room) && (!$object_utils:isoneof(what, $web_utils.interior_rooms))) ? "room" | "object";
"UNFRAMED version";
"link = tostr(\"<EMBED HSPACE=4 ALIGN=\\\"RIGHT\\\" SRC=\\\"&LOCAL_LINK;/\", $std_vrml10viewer:get_code(), \"/\", tonum(what), \"/\", type, \".wrl\\\" width=\\\"40%\\\" height=\\\"80%\\\"></EMBED>\");";
"FRAMED version";
link = tostr("<TABLE HSPACE=4 ALIGN=\"RIGHT\" BORDER=2 WIDTH=\"40%\" HEIGHT=\"80%\"><TR><TD><EMBED WIDTH=300 HEIGHT=256 ALIGN=\"CENTER\" SRC=\"&LOCAL_LINK;/", $std_vrml10viewer:get_code(), "/", tonum(what), "/", type, ".wrl\"></EMBED></TD></TR></TABLE>");
return link;
"Last modified Wed Aug 21 00:04:09 1996 IDT by EricM (#3264).";
.

"***finished***
