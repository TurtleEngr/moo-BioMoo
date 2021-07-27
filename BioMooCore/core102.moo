$Header: /repo/public.cvs/app/BioGate/BioMooCore/core102.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #102 with create
@create $webapp named General Info Provider:General Info Provider,gip
@prop #102."generalinfo_html" {} r
;;#102.("generalinfo_html") = {"<UL>", "<LI>See <A HREF=\"&LOCAL_LINK;/info/0/who\">who</A>'s logged in.", "<LI><FORM METHOD=\"POST\" ACTION=\"info\">", "<INPUT TYPE=\"submit\" VALUE=\"Check\"> whether", "<INPUT TYPE=\"text\" NAME=\"who\" SIZE=\"30\" MAXLENGTH=\"50\">", " is connected.", "</FORM>"}
;;#102.("code") = "info"
;;#102.("available") = 1
;;#102.("aliases") = {"General Info Provider", "gip"}
;;#102.("object_size") = {13485, 937987203}
;;#102.("web_calls") = 175

@verb #102:"method_get" this none this rx #95
@program #102:method_get
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != $http_handler)
  return E_PERM;
endif
this.web_calls = this.web_calls + 1;
who = caller_perms();
what = args[2];
rest = args[3];
if (rest == "who")
  return {"Who's around", this:url_who_listing(who, connected_players())};
elseif ((rest == "info") || ((!rest) && $object_utils:isa(what, $player)))
  output = {};
  if ($object_utils:isa(what, $player))
    set_task_perms(player);
    output = this:user_info(@args);
  else
    output = {"<H2>Sorry!</H2> There isn't anyone here with that name."};
    output = {@output, tostr("<P>Go to <A HREF=\"", $web_utils.MOO_home_page, "\">", $network.MOO_name, "'s home page</A><BR>")};
  endif
  return {(what:namec(1) + "'s home page in ") + $network.MOO_name, output};
else
  return {"Information", $code_utils:eval_d("return fileread(\"misc\", \"generalinfo.html\");")[2] || this.generalinfo_html};
endif
return {};
"Last modified Mon Jun 30 00:26:47 1997 IDT by EricM (#3264).";
.

@verb #102:"url_who_listing" this none this rx #95
@program #102:url_who_listing
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
output = {tostr("Return to the ", $web_utils:rtn_to_viewer("Viewer"), ", or to the <A HREF=\"&LOCAL_LINK;/info\">General Info Provider</A>.")};
who = args[1];
players = args[2];
notcon = 0;
yescon = 0;
lu = $list_utils;
cu = $command_utils;
su = $string_utils;
tu = $time_utils;
ou = $object_utils;
linelist = dislist = conlist = {};
for individual in (players)
  cu:suspend_if_needed(random(2) - 1);
  if (is_player(individual))
    if (individual in connected_players())
      yescon = yescon + 1;
      conlist = setadd(conlist, {individual, connected_seconds(individual), idle_seconds(individual), individual.location});
      linelist = setadd(linelist, {individual, connected_seconds(individual), idle_seconds(individual), individual.location});
    else
      notcon = notcon + 1;
      linelist = setadd(linelist, {individual, individual.last_disconnect_time - individual.last_connect_time, time() - individual.last_disconnect_time, individual.location});
      dislist = setadd(dislist, {individual, individual.last_disconnect_time - individual.last_connect_time, time() - individual.last_disconnect_time, individual.location});
    endif
  else
    output = {@output, tostr(individual:namec(1), " (", individual, ") is not a user.")};
  endif
endfor
conlist = lu:sort_alist(conlist, 3);
dislist = lu:sort_alist(dislist, 3);
if (args[2] == "name")
  conlist = lu:sort_alist(conlist, 1);
  dislist = lu:sort_alist(dislist, 1);
elseif (args[2] == "loc")
  conlist = lu:sort_alist(conlist, 4);
  dislist = lu:sort_alist(dislist, 4);
endif
if (conlist)
  output = {@output, "<HR><B>Connected users:</B><P>"};
  output = {@output, "Name                      Conn  Idle  Location (click to join)"};
  output = {@output, "------------------------  ----  ----  ------------------------"};
  if (($standard_webviewer == (viewer = $web_utils:user_webviewer())) && (!(player in connected_players())))
    webcode = $anon_webviewer:get_code();
  else
    webcode = viewer:get_code();
  endif
  for pl in (conlist)
    cu:suspend_if_needed(random(2) - 1);
    name = pl[1]:namec(1);
    name = (length(name) > 25) ? name[1..25] | name;
    len = length(name);
    name = tostr("<A HREF=\"&LOCAL_LINK;/", this.code, "/", tonum(pl[1]), "/info\">", name, "</A>", su:space(25 - len));
    conn = su:right(tu:short_time(pl[2]), 4);
    idle = su:right(tu:short_time(pl[3]), 5);
    loca1 = pl[1].location == #-1;
    loca2 = ou:has_verb(pl[1].location, "who_location_msg");
    loca = loca1 ? "** Nowhere **" | (loca2 ? pl[1].location:who_location_msg(pl[1]) | pl[1].location.name);
    (length(loca) > 30) ? loca = loca[1..27] + "..." | "";
    loca = tostr(loca, " (", pl[1].location, ")");
    if (!pl[1]:web_join_hidden())
      if (!(who in connected_players()))
        "this also covers anonymous transactions";
        loca = tostr("<A HREF=\"&LOCAL_LINK;/", webcode, "/", tonum(pl[1].location), "#focus\">", loca, "</A>");
      elseif (who.location != pl[1].location)
        loca = tostr("<A HREF=\"&LOCAL_LINK;/", webcode, "/$teleporter/teleport?", tonum(pl[1].location), "#focus\">", loca, "</A>");
      endif
    endif
    line = tostr(name, " ", conn, " ", idle, "  ", loca);
    output = {@output, line};
  endfor
  output = {@output, "-----"};
  output = {@output, tostr(su:right(yescon, 6), " connected user", (yescon == 1) ? "" | "s", " at ", tu:gmt() || ctime())};
endif
if (notcon)
  output = {@output, "<HR><B>Disconnected users:</B><P>"};
  output = {@output, "Name                      Conn   Ago  Location"};
  output = {@output, "------------------------  ----  ----  ------------------"};
  for pl in (dislist)
    cu:suspend_if_needed(random(2) - 1);
    name = pl[1]:namec(1);
    name = (length(name) > 25) ? name[1..25] | name;
    len = length(name);
    name = tostr("<A HREF=\"&LOCAL_LINK;/", this.code, "/", tonum(pl[1]), "/info\">", name, "</A>", su:space(25 - len));
    conn = (pl[2] > 0) ? tu:short_time(pl[2]) | " *Never*";
    conn = su:right(conn, 4);
    last = (pl[2] > 0) ? su:right(tu:short_time(pl[3]), 5) | " ";
    loc = pl[1].location;
    joe = pl[1];
    loca = (loc == #-1) ? "** Nowhere **" | (ou:has_verb(loc, "who_location_msg") ? loc:who_location_msg(joe) | loc.name);
    (length(loca) > 30) ? loca = loca[1..27] + "..." | "";
    loca = ((loca + " (") + tostr(loc)) + ")";
    line = tostr(name, " ", conn, " ", last, "  ", loca);
    output = {@output, line};
  endfor
  output = {@output, "-----"};
  output = {@output, tostr(su:right(notcon, 6), " disconnected user", (notcon == 1) ? "" | "s", ".")};
endif
return $web_utils:preformat(output, 200, "");
"Last modified Wed Aug 21 19:04:53 1996 IDT by EricM (#3264).";
.

@verb #102:"method_post" this none this rx #95
@program #102:method_post
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((caller != this) && (caller != $http_handler))
  return E_PERM;
endif
this.web_calls = this.web_calls + 1;
what = $web_utils:parse_form(args[5]);
if (!args[3])
  if (who = $list_utils:assoc("who", what))
    if (!who[2])
      return {$network.MOO_name, {"<P>You could enter some name to search for...<BR>", $web_utils:rtn_to_viewer()}};
    endif
    who = $player_db:find_all(who[2]);
    if (!who)
      return {$network.MOO_name, {"<P>Sorry, no such user.", "<BR>", $web_utils:rtn_to_viewer()}};
    endif
    return {$network.MOO_name, {"User list...", @this:url_who_listing(player, who), "<BR>", $web_utils:rtn_to_viewer()}};
  elseif (research = $list_utils:assoc("research", what))
    "Used by BioCore for searching user's research information";
    if (valid(research_dir = $research_dir))
      "if $research_dir returns E_PROPNF then skip all this; it won't work anyway";
      dobjstr = research[2];
      if (!dobjstr)
        return {$network.MOO_name, {"<P>You could enter some string to search for...<BR>", $web_utils:rtn_to_viewer()}};
      endif
      people = research_dir:_find()[1];
      if (!people)
        return {$network.MOO_name, {tostr("<P>Sorry, I found nobody interested in \"<B>", dobjstr, "</B>.\"<BR>"), "Try using shorter keywords.<BR>", $web_utils:rtn_to_viewer()}};
      elseif (length(people) > 50)
        return {$network.MOO_name, {tostr("<P>Sorry, I found too many people (actually ", length(people), ") interested in \"<B>", dobjstr, "</B>.\"<BR>"), "Try being more specific.<BR>", $web_utils:rtn_to_viewer()}};
      endif
      return {$network.MOO_name, {"Research findings...", @this:url_who_listing(player, people), "<BR>", $web_utils:rtn_to_viewer()}};
    endif
  endif
else
  who = args[2];
  message = $list_utils:assoc("thepage", what);
  if (message && message[2])
    text = message[2];
    header = player:page_origin_msg();
    text = tostr($string_utils:pronoun_sub(($string_utils:index_delimited(header, player:name(1)) ? "%S" | "%N") + " %<pages>, \""), text, "\"");
    result = who:receive_page(header, text);
    if (result == 2)
      "not connected";
      return {$network.MOO_name, {(typeof(msg = who:page_absent_msg()) == STR) ? msg | $string_utils:pronoun_sub("%n is not currently logged in.", who), "<BR>", $web_utils:rtn_to_viewer()}};
    else
      return {$network.MOO_name, {who:page_echo_msg(), "<BR>", $web_utils:rtn_to_viewer()}};
    endif
  endif
  message = $list_utils:assoc("thepost", what);
  if (message && (message = message[2]))
    title = $list_utils:assoc("title", what);
    if ((!title) || (!(title = title[2])))
      title = "";
    endif
    result = $mail_agent:send_message(player, {who}, title, message);
    if (result || result[1])
      return {$network.MOO_name, {("Your MOOmail was sent to " + who:name(1)) + " successfully.<BR>", $web_utils:rtn_to_viewer()}};
    else
      return {$network.MOO_name, {"Your MOOmail wasn't sent for some reason.<BR>", $web_utils:rtn_to_viewer()}};
    endif
  endif
endif
return {$network.MOO_name, {"No action taken.<BR>", $web_utils:rtn_to_viewer()}};
"Last modified Thu Aug 15 03:15:43 1996 IDT by EricM (#3264).";
.

@verb #102:"user_info" this none this rx #95
@program #102:user_info
"user_info(who_asks OBJ, whose_info OBJ) -> html text LIST";
"Generates a page of info about 'whose_info' and provides fields for";
"paging and for sending MOOmail to them";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
what = args[2];
what_name1 = what:name(1);
what_namec1 = what:namec(1);
rest = args[3];
output = {};
code = this.code;
set_task_perms(caller_perms());
if (url = what:get_url(who))
  url = (typeof(url) == LIST) ? url | $web_utils:build_MIME(url);
else
  url = {};
endif
output = {@url, "<P>"};
"-- add character description";
output = {@output, tostr($string_utils:pronoun_sub(tostr("<B>", what.name, " describes %r in ", $network.MOO_name, " as:</B><P>"), what))};
output = {@output, @(typeof(desc = what:description()) == LIST) ? desc | {desc}, "<P>"};
"-----------------";
"";
"";
"This section is MOO-specific, and depends on what info is available on your users";
"";
if (local_info = this:local_user_info(what))
  output = {@output, @local_info, "<HR>"};
endif
"";
"-----------------";
"";
line = tostr("<B>", what_name1, " is ", (connected = what in connected_players()) ? ("awake in " + $network.MOO_name) + " now" | "asleep now");
if (connected && ((idle = idle_seconds(what)) > 3599))
  line = (line + ", but has been idle for ") + ((idle > 7199) ? tostr(idle / 3600) + " hours.</B><P>" | " one hour.</B><P>");
elseif (connected && (idle_seconds(what) > 60))
  line = (line + ", but has been idle for ") + ((idle > 119) ? tostr(idle / 60) + " minutes.</B><P>" | " one minute.</B><P>");
else
  line = line + ".</B><P>";
endif
output = {@output, line};
if (player != $no_one)
  if ((what in connected_players()) || ((found = $object_utils:has_callable_verb(what, "receive_page")) && (found[1] != $player)))
    output = {@output, ("<FORM METHOD=\"POST\" ACTION=\"" + code) + "\">", ("<INPUT TYPE=\"submit\" VALUE=\"Page\"> <B>" + what_name1) + "</B>:<BR>", "<INPUT TYPE=\"text\" NAME=\"thepage\" SIZE=\"80\" MAXLENGTH=\"200\"><BR>", "<INPUT TYPE=\"reset\" VALUE=\"Clear the message to page\">", "</FORM>"};
    if (!(player in connected_players()))
      output = {@output, tostr("<B>Important Note!!</B> Since you are not connected by telnet to ", $network.MOO_name, ", people you page won't be able to page you back (and may get confused).")};
    endif
  endif
  if (what.email_address && (!$object_utils:isa(what, $guest)))
    output = {@output, ("<FORM METHOD=\"POST\" ACTION=\"" + code) + "\">", ("<INPUT TYPE=\"submit\" VALUE=\"MOOmail message\"> to <B>" + what_name1) + "</B>:<BR>", "Title: ", "<INPUT TYPE=\"text\" NAME=\"title\" SIZE=\"50\" MAXLENGTH=\"80\"><BR>", "<TEXTAREA NAME=\"thepost\" ROWS=8 COLS=80>", "</TEXTAREA><BR>", "<INPUT TYPE=\"reset\" VALUE=\"Clear the message to post\">", "</FORM>"};
  endif
endif
output = {@output, "<P>" + $web_utils:rtn_to_viewer()};
output = {@output, tostr("<BR><B>Go to ", $network.MOO_name, "'s <A HREF=\"", $web_utils.MOO_home_page, "\">Home Page</A> or <A HREF=\"http://", $network.site, ":", `$http_handler:retrieve_taskprop("port_handler").handles_port ! E_PROPNF, E_TYPE => $network.port', "\">Web Gateway Page</A>.</B>")};
if (bodytag = what:get_web_setting("bodytag_attributes"))
  $http_handler:submit_taskprop("bodytag_attributes", bodytag);
endif
$http_handler:submit_taskprop("hide_banner", 1);
output = {@output, $web_utils.page_banner, "<BR>"};
return output;
"Last modified Thu Oct 10 00:47:03 1996 IST by EricM (#3264).";
.

@verb #102:"short_user_info" this none this rx #95
@program #102:short_user_info
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
what = args[2];
output = {};
if (is_player(what))
  url = what:get_url(who);
  if (!url)
    url = {};
  elseif (typeof(url) == STR)
    url = {("<IMG SRC=\"" + url) + "\">"};
  elseif ((typeof(url) == LIST) && url[1])
    url = {@url, "<HR>"};
  else
    url = {};
  endif
  output = {@url, "<P>"};
  "-------";
  "Call this:local_info to retrieve MOO-specific info if any.";
  if (local_info = this:local_user_info(what))
    output = {@output, @local_info, "<P>"};
  endif
  "-------";
  output = {@output, tostr("See <A HREF=\"&LOCAL_LINK;/", this.code, "/", tonum(what), "/info\">complete info page</A>, including fields for paging and sending MOOmail.<HR>")};
else
  output = {@output, "You seem to have selected something that isn't a MOO user. This is probably a bug, which you should report to the MOO administrators."};
endif
if (bodytag = what:get_web_setting("bodytag_attributes"))
  $http_handler:submit_taskprop("bodytag_attributes", bodytag);
endif
return {((("<H3>" + what:namec(1)) + "'s home page in ") + $network.MOO_name) + "</H3>", output};
"Last modified Thu Aug 15 07:11:59 1996 IDT by EricM (#3264).";
.

@verb #102:"get_code" this none this rxd #95
@program #102:get_code
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return this.code;
"Last modified Sun Aug  6 11:48:00 1995 IDT by EricM (#3264).";
.

"***finished***
