$Header: /repo/public.cvs/app/BioGate/BioMooCore/core100.moo,v 1.1 2021/07/27 06:44:25 bruce Exp $

>@dump #100 with create
@create $webapp named Who's On-line (HTML 3.0):Who's On-line (HTML 3.0),wwt
;;#100.("code") = "who"
;;#100.("available") = 1
;;#100.("aliases") = {"Who's On-line (HTML 3.0)", "wwt"}
;;#100.("description") = "An HTML who listing that uses HTML 3.0 tables."
;;#100.("object_size") = {10626, 937987203}

@verb #100:"url_who_listing" this none this rx
@program #100:url_who_listing
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
output = {tostr("<b>[ ", $web_utils:rtn_to_viewer("To the Viewer"), " ]</b>")};
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
  output = {@output, "<h2>Who's On-Line?</h2>"};
  line = tostr("<i>There ", (yesconn == 1) ? "is " | "are ", yescon, " connected user", (yescon == 1) ? "" | "s", " on ", tu:gmt() || ctime(), "</i><p>");
  output = {@output, line};
  output = {@output, "<table border=0><tr align=left><th>Name</th> <th width=10%>Time</th> <th width=10%>Idle</th> <th>Location (click to join)</th></tr>"};
  for pl in (conlist)
    cu:suspend_if_needed(random(2) - 1);
    "name = pl[1]:namec(1)";
    name = this:title_with_url(pl[1]);
    conn = tu:short_time(pl[2]);
    idle = tu:short_time(pl[3]);
    loca1 = pl[1].location == #-1;
    loca2 = ou:has_verb(pl[1].location, "who_location_msg");
    loca = loca1 ? "** Nowhere **" | (loca2 ? pl[1].location:who_location_msg(pl[1]) | pl[1].location.name);
    if ((who.location != pl[1].location) && (!pl[1]:web_join_hidden()))
      if (player != $no_one)
        loca = tostr("<A HREF=\"&LOCAL_LINK;/", $web_utils:user_webviewer():get_code(), "/", tonum($teleporter), "/teleport?", tonum(pl[1].location), "#focus\">", loca, "</A>");
      else
        loca = tostr("<A HREF=\"&LOCAL_LINK;/", $web_utils:user_webviewer():get_code(), "/", tonum(pl[1].location), "#focus\">", loca, "</A>");
      endif
    endif
    line = tostr("<tr valign=top><td>", name, "</td><td>", conn, "</td><td>", idle, "</td><td>", loca, "</td></tr>");
    output = {@output, line};
  endfor
endif
output = {@output, "</table><hr>"};
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
    loca = tostr(loca, " (", loc, ")");
    line = tostr(name, " ", conn, " ", last, "  ", loca);
    output = {@output, line};
  endfor
  output = {@output, "-----"};
  output = {@output, tostr(su:right(notcon, 6), " disconnected user", (notcon == 1) ? "" | "s", ".")};
endif
return {@output};
"Last modified Mon Apr 29 06:40:11 1996 IDT by EricM (#3264).";
.

@verb #100:"method_get" this none this rx
@program #100:method_get
"Copied from General Info Provider (#3394):provide_output by Windward (#301) Fri May  5 01:47:31 1995 IDT";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != $http_handler)
  return E_PERM;
endif
this.web_calls = this.web_calls + 1;
who = args[1];
what = args[2];
rest = args[3];
return {$network.MOO_name + " - Who's On-Line?", this:url_who_listing(who, connected_players())};
"Last modified Sat Nov 11 07:39:54 1995 IST by EricM (#3264).";
.

@verb #100:"method_post" this none this rx
@program #100:method_post
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((caller != this) && (caller != $http_handler))
  return E_PERM;
endif
this.web_calls = this.web_calls + 1;
what = $web_utils:parse_form(args[5]);
if (!args[3])
  if (who = $list_utils:assoc("who", what))
    if (!who[2])
      return {"<P>You could enter some name to search for..."};
    endif
    who = $player_db:find_all(who[2]);
    if (!who)
      return {"<P>Sorry, no such user."};
    endif
    return {"User list...", this:url_who_listing(player, who)};
  elseif (valid($research_dir) && (research = $list_utils:assoc("research", what)))
    dobjstr = research[2];
    people = $research_dir:_find()[1];
    if (!people)
      return {("<P>Sorry, I found nobody interested in <B>" + dobjstr) + "</B>.<BR>", "Try using shorter keywords."};
    endif
    return {"Research findings...", this:url_who_listing(player, people)};
  endif
else
  who = args[2];
  message = $list_utils:assoc("thepage", what);
  if (message && message[2])
    text = message[2];
    text = tostr($string_utils:pronoun_sub(($string_utils:index_delimited(header, player:name(1)) ? "%S" | "%N") + " %<pages>, \""), text, "\"");
    header = player:page_origin_msg();
    result = who:receive_page(header, text);
    if (result == 2)
      "not connected";
      return {(typeof(msg = who:page_absent_msg()) == STR) ? msg | $string_utils:pronoun_sub("%n is not currently logged in.", who)};
    else
      return {who:page_echo_msg()};
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
      return {("Your MOOmail was sent to " + who:name(1)) + " successfully."};
    else
      return {"Your MOOmail wasn't sent for some reason."};
    endif
  endif
endif
return {"No action taken."};
"Last modified Sun Oct 13 01:43:41 1996 IST by EricM (#3264).";
.

@verb #100:"user_info" this none this
@program #100:user_info
"Copied from General Info Provider (#3394):user_info by Windward (#301) Fri May  5 01:47:47 1995 IDT";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
what = args[2];
what_name1 = what:name(1);
what_namec1 = what:namec(1);
rest = args[3];
email = $registration_db:ema(what);
output = {};
code = this.code;
set_task_perms(caller_perms());
url = what:get_url(who);
if (!url)
  url = {};
elseif (typeof(url) == STR)
  url = {("<IMG SRC=\"" + url) + "\">"};
elseif ((typeof(url) == LIST) && url[1])
else
  url = {};
endif
output = {@url, "<P>"};
if ($object_utils:isa(what, $guest))
  output = {@output, what_namec1 + ((title = what.title_msg) ? (" has provided " + title) + " as a name." | " hasn't provided a real name.")};
else
  output = {@output, (what_namec1 + "'s real name is <B>") + what.real_name};
endif
if ((!(real_work = what.real_work)) || (length(real_work) < 2))
  real_work = {"", ""};
endif
output = {@output, "</B><BR>Institution: <B>" + (real_work[1] || "Not provided.")};
output = {@output, "</B><BR>Occupation: <B>" + (real_work[2] || "Not provided.")};
output = {@output, "</B><BR>Email address: " + (email ? ((("<A HREF=\"mailto:" + email) + "\">") + email) + "</A>" | "None.")};
output = {@output, "<P>Research interests:<BR>"};
output = {@output, @what:get_research(), "<HR>"};
line = tostr("<HR><B>", what_name1, " is ", (connected = what in connected_players()) ? "currently connected" | "not currently connected");
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
    output = {@output, ("<FORM METHOD=\"POST\" ACTION=\"" + code) + "\">", ("<INPUT TYPE=\"submit\" VALUE=\"Page\"> <B>" + what_name1) + "</B>:<BR>", "<INPUT TYPE=\"text\" NAME=\"thepage\" SIZE=\"80\" MAXLENGTH=\"200\">", "<INPUT TYPE=\"reset\" VALUE=\"Clear the message to page\">", "</FORM>"};
  endif
  output = {@output, ("<FORM METHOD=\"POST\" ACTION=\"" + code) + "\">", ("<INPUT TYPE=\"submit\" VALUE=\"MOOmail message\"> to <B>" + what_name1) + "</B>:<BR>", "Title: ", "<INPUT TYPE=\"text\" NAME=\"title\" SIZE=\"50\" MAXLENGTH=\"80\">", "<TEXTAREA NAME=\"thepost\" ROWS=8 COLS=80>", "</TEXTAREA>", "<INPUT TYPE=\"reset\" VALUE=\"Clear the message to post\">", "</FORM>"};
endif
return {(what_namec1 + "'s home page in ") + $network.MOO_name, @output};
"Last modified Sun Apr 30 15:49:37 1995 IDT by EricM (#3264).";
.

@verb #100:"title_with_url" this none this
@program #100:title_with_url
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
dude = args[1];
msg = "";
dudelink = ((((("<A HREF=\"&LOCAL_LINK;/" + "info") + "/") + tostr(tonum(dude))) + "/info\">") + dude:namec(1)) + "</a>";
if (($object_utils:has_property(dude, "title_msg") && (tm = (typeof(dude.title_msg) == LIST) ? $string_utils:english_list(dude.title_msg, "") | tostr(dude.title_msg))) && (tm != ""))
  msg = msg ? (msg + ", ") + tm | tm;
endif
return dudelink + (msg ? (" (" + msg) + ")" | "");
"Last modified Sun Oct 13 01:44:07 1996 IST by EricM (#3264).";
.

@verb #100:"get_code" this none this rxd #95
@program #100:get_code
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return this.code;
"Last modified Sun Aug  6 11:58:32 1995 IDT by EricM (#3264).";
.

"***finished***
