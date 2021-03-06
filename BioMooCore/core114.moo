$Header: /repo/public.cvs/app/BioGate/BioMooCore/core114.moo,v 1.1 2021/07/27 06:44:27 bruce Exp $

>@dump #114 with create
@create $webapp named Mail Browser:Mail Browser,mb
@prop #114."headerlist_len" 50 rc
@prop #114."guest_subscribed_folders" {} rc
;;#114.("code") = "mail_browser"
;;#114.("available") = 1
;;#114.("aliases") = {"Mail Browser", "mb"}
;;#114.("object_size") = {29923, 937987203}

@verb #114:"method_get" this none this rx #95
@program #114:method_get
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != $http_handler)
  return E_PERM;
endif
who = player;
what = args[2];
if (((cp = caller_perms()) == $no_one) || $object_utils:isa(cp, $guest))
  set_task_perms($hacker);
  "$no_one and $guest's don't own themselves, $hacker does.";
else
  set_task_perms(cp);
endif
valid_folder = (who == what) || $object_utils:isa(what, $mail_recipient);
rest = args[3];
search = args[4];
if (!((what || rest) || search))
  return this:basic_webpage(who);
elseif (rest == "list_all_folders")
  return this:list_all_folders(who);
elseif ((rest == "browse_folder") && valid_folder)
  return this:browse_folder(who, what, search);
elseif ((rest == "next_unread") && valid_folder)
  return this:next_unread(who, what);
elseif ((rest == "read_message") && valid_folder)
  return this:read_message(who, what, search);
elseif ((rest == "subscribe") && valid_folder)
  return this:subscribe(who, what, rest);
elseif ((rest == "unsubscribe") && valid_folder)
  return this:unsubscribe(who, what, rest);
endif
return {"Mail Browser", {"<H2>Sorry</H2><B>The Mail Browser doesn't understand what you've requested."}};
"Last modified Sun Apr  7 23:10:20 1996 IDT by EricM (#3264).";
.

@verb #114:"basic_webpage" this none this rx #95
@program #114:basic_webpage
"basic_webpage(who OBJ) -> {title STR, html doc LIST}";
"the default web page shown when someone links to the Mail Browser";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
who = args[1];
set_task_perms(caller_perms());
linkback = this:basic_header();
text = {"<H1 ALIGN=CENTER>Mail Browser - Main Page</H1>", "<HR>", linkback, "<HR>", "<P>"};
text = {@text, "<P>", @this:list_subscribed_folders(who), "<P>"};
return {"Mail Browser - Main Page", {@text, "<HR>", linkback, "<HR>"}};
"Last modified Sun Apr  7 21:04:05 1996 IDT by EricM (#3264).";
.

@verb #114:"list_all_folders" this none this rx #95
@program #114:list_all_folders
"list_all_folders(who OBJ) -> html doc";
"Returns a page listing all mail folders in the Mail Distribution Center ($mail_agent)";
"Includes links/buttons for subscribing, unsubscribing, and browsing";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
who = args[1];
text = {"<H2>Full Mail Folder Listing</H2>", "<DL>"};
ml = (length(who.current_message) > 2) ? $list_utils:slice(who.current_message[3..length(who.current_message)]) | {};
$command_utils:suspend_if_needed(0);
ml = $list_utils:remove_duplicates({@ml, @$mail_agent.contents, @who.mail_lists});
for folder in (ml)
  ((seconds_left() < 2) || (ticks_left() < 4000)) ? $command_utils:suspend_if_needed(1) | 0;
  if ($object_utils:isa(folder, $mail_recipient) && (folder:is_usable_by(who) || folder:is_readable_by(who)))
    text = {@text, @this:folder_description(who, folder)};
  endif
endfor
text = {@text, "</DL><HR>", tostr(this:subscribed_folders_link(), " ", $web_utils:rtn_to_viewer())};
return {"Mail Browser - All Mail Folders", text};
"Last modified Fri Feb 21 02:43:15 1997 IST by EricM (#3264).";
.

@verb #114:"list_subscribed_folders" this none this rx #95
@program #114:list_subscribed_folders
"list_subscribed_folders(who) -> html doc";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
set_task_perms(caller_perms());
prefix = tostr("<A HREF=\"&LOCAL_LINK;/", this:get_code(), "/");
if (!(which = this:subscribed_folders(who)))
  text = {"<P><B>You are not subscribed to any mail folders</B><P>"};
else
  text = {"<UL>"};
  for w in (which)
    append = w[2] ? tostr(" - <B>[ ", prefix, tonum(w[1]), "/next_unread\">", w[2], " unread ", (w[2] == 1) ? "message" | "messages", "</A> ]</B>") | "";
    folder = tostr(prefix, tonum(w[1]), "/browse_folder\">", $mail_agent:name(w[1]), "</A>");
    text = {@text, tostr("<LI>", folder, append)};
  endfor
  text = {@text, "</UL>"};
endif
return text;
"Last modified Sun Apr  7 21:04:05 1996 IDT by EricM (#3264).";
.

@verb #114:"subscribed_folders" this none this rx #95
@program #114:subscribed_folders
"subscribed_folders(who OBJ [, folders_only BOOL]) -> { {folder OBJ, new_msgs NUM},...}";
"                                -> {folder OBJ, ...}";
"Lifted from $player:@subscribed";
"If the second arg is present and true, list is just folders w/o new_msgs";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
who = args[1];
folders_only = {@args, 0}[2];
set_task_perms(caller_perms());
if ((player == $no_one) || $object_utils:isa(player, $guest))
  if (folders_only)
    return this.guest_subscribed_folders;
  else
    result = {};
    for folder in (this.guest_subscribed_folders)
      result = {@result, {folder, 0}};
    endfor
    return result;
  endif
endif
cm = who.current_message;
cm[1..2] = {{who, @cm[1..2]}};
which = {};
for n in (cm)
  rcpt = n[1];
  if ($mail_agent:is_recipient(rcpt))
    which = folders_only ? {@which, n[1]} | {@which, {n[1], n[1]:length_date_gt(n[3])}};
  else
    if (0)
      "removed for now";
      player:notify(tostr("Bogus recipient ", rcpt, " removed from .current_message."));
      who.current_message = setremove(who.current_message, n);
    endif
  endif
  $command_utils:suspend_if_needed(0);
endfor
return which;
"Last modified Sun Apr  7 21:04:05 1996 IDT by EricM (#3264).";
.

@verb #114:"browse_folder" this none this rx #95
@program #114:browse_folder
"browse_folder(who OBJ, folder OBJ) -> html doc";
"Returns a list of messages from a specified mail folder";
"The list is centered on the user's current message for that folder";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
who = args[1];
set_task_perms(caller_perms());
folder = args[2];
search = {@args, {}}[3];
if (search && $string_utils:is_numeric(search))
  current = tonum(search);
elseif (!(current = who:current_message(folder) || 0))
  "person isn't subscribed; show headers from end (most recent)";
  current = folder:length_all_msgs();
endif
spec = {tostr(i = max(current - (this.headerlist_len / 2), 1), "-", i + this.headerlist_len)};
msg_seq = folder:parse_message_seq(spec, current);
return this:show_headers(who, folder, msg_seq, current);
"Last modified Tue Oct 15 22:13:45 1996 IST by EricM (#3264).";
.

@verb #114:"next_unread" this none this rx #95
@program #114:next_unread
"next_unread(who OBJ, folder OBJ) -> html doc";
"Returns the text of the next unread message on the specified folder";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
who = args[1];
folder = args[2];
set_task_perms(caller_perms());
current = who:current_message(folder) || 0;
msg_seq = folder:parse_message_seq({"new"}, current);
return this:show_message(who, folder, msg_seq);
"Last modified Wed Oct 30 21:26:43 1996 IST by EricM (#3264).";
.

@verb #114:"basic_header" this none this rx #95
@program #114:basic_header
"basic_header() -> html doc";
"returns a link to the viewer and a link to 'list all folders'";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return tostr("[<A HREF=\"&LOCAL_LINK;/", this:get_code(), "/show_info/list_all_folders\">List all mail folders</A>] [", $web_utils:rtn_to_viewer(), "]");
"Last modified Tue Oct 15 22:15:10 1996 IST by EricM (#3264).";
.

@verb #114:"show_message" this none this rx #95
@program #114:show_message
"show_message(who OBJ, folder OBJ, msg_seq LIST)";
"Shows the text of the message specified by 'msg_seq' from the 'folder'";
"The msg_seq should be in typical $mail_recipient/$mail_agent format";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
who = args[1];
folder = args[2];
msg_seq = args[3];
set_task_perms(caller_perms());
foldername = $mail_agent:name(folder);
header = this:basic_header();
who:set_current_folder(folder);
text = {};
msgnum = -1;
((seconds_left() < 2) || (ticks_left() < 4000)) ? $command_utils:suspend_if_needed(1) | 0;
if (typeof(msg_seq) == STR)
  if (folder == who)
    subst = {{"%f's", "Your"}, {"%f", "You"}, {"%<has>", "have"}};
  elseif (is_player(folder))
    subst = {{"%f", folder.name}, {"%<has>", $gender_utils:get_conj("has", folder)}};
  else
    subst = {{"%f", $mail_agent:name(folder)}, {"%<has>", "has"}};
  endif
  msg_seq = $string_utils:substitute(msg_seq, {@subst, {"%%", "%"}});
  text = {@text, "<H3>", msg_seq, "</H3>"};
elseif (typeof(msg_seq) == ERR)
  text = {@text, "<H3>Sorry! This mail folder isn't readable by you.</H3>"};
else
  msg = folder:messages_in_seq(@msg_seq);
  if (!msg)
    text = {@text, "<H3>Sorry, but that doesn't appear to be a proper message to select.</H3>"};
  else
    if (typeof(msg[1]) == LIST)
      msg = msg[1];
    endif
    msgnum = msg[1];
    date = msg[2][1];
    from = msg[2][2];
    to = msg[2][3];
    "hunt for subject";
    if (strsub(msg[2][4], " ", ""))
      subject = msg[2][4];
      msgtext = msg[2][5..length(msg[2])];
    else
      subject = "(None.)";
      msgtext = msg[2][4..length(msg[2])];
    endif
    "strip off leading vertical space";
    while (msgtext && (!strsub(msgtext[1], " ", "")))
      msgtext = listdelete(msgtext, 1);
    endwhile
    text = {@text, tostr("<H3>Message ", msgnum, " on ", $mail_agent:name(folder), "</H3>")};
    text = {@text, tostr("<B>Date:</B> ", ctime(date), "<BR>"), tostr("<B>From:</B> ", from, "<BR>"), tostr("<B>To:</B> ", to, "<BR>")};
    if (subject)
      text = {@text, tostr("<B>Subject:</B> ", subject, "<P>")};
    endif
    text = {@text, @$web_utils:plaintext_to_html(msgtext)};
    if ((folder in this:subscribed_folders(who, 1)) && (typeof(msgnum) == INT))
      who:set_current_message(folder, msgnum, date);
    endif
  endif
endif
text = {@text, tostr("<CENTER><FORM METHOD=\"GET\" ACTION=\"&LOCAL_LINK;/", this:get_code(), "/", tonum(folder), "/read_message\"><B>Read message number:</B> <INPUT name=\"\" size=\"5\"></FORM></CENTER>")};
text = {@text, tostr("<P><HR>", this:next_msg_link(folder, msgnum), " ", this:prev_msg_link(folder, msgnum))};
text = {@text, tostr(this:browse_folder_link(folder, msgnum), " ", this:subscribed_folders_link()), header, "<HR>"};
return {tostr("Mail Browser - ", foldername), text};
"Last modified Thu Oct 31 00:50:39 1996 IST by EricM (#3264).";
.

@verb #114:"show_headers" this none this rx #95
@program #114:show_headers
"show_headers(who OBJ, folder OBJ, msg_seq LIST [, current NUM]) -> none";
"Show list of message headers on 'folder' given the specified 'msg_seq'";
"Format of 'msg_seq' is typical for $mail_recipient/$mail_agent";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
who = args[1];
folder = args[2];
msg_seq = args[3];
readable = folder:is_readable_by(who);
set_task_perms(caller_perms());
foldername = $mail_agent:name(folder);
if (readable)
  current_msg = (length(args) > 3) ? args[4] | who:current_message(folder);
  who:set_current_folder(folder);
endif
last_old = $maxint;
webcode = $web_utils:get_webcode();
text = {};
if (typeof(msg_seq) == STR)
  firstread = 1;
  lastread = 1;
  if (folder == who)
    subst = {{"%f's", "Your"}, {"%f", "You"}, {"%<has>", "have"}};
  elseif (is_player(folder))
    subst = {{"%f", folder.name}, {"%<has>", $gender_utils:get_conj("has", folder)}};
  else
    subst = {{"%f", $mail_agent:name(folder)}, {"%<has>", "has"}};
  endif
  msg_seq = $string_utils:substitute(msg_seq, {@subst, {"%%", "%"}});
  text = {@text, "<H3>", msg_seq, "</H3>"};
elseif (typeof(msg_seq) == ERR)
  text = {@text, "<H3>Sorry! This mail folder isn't readable by you.</H3>"};
elseif (typeof(msg_seq) == LIST)
  text = {tostr("<H2>Messages ", is_player(folder) ? "for " | "on ", foldername, "</H2>"), "<PRE>"};
  "--get list of messages and build each header line";
  msgs = folder:messages_in_seq(msg_seq[1]);
  firstread = msgs ? msgs[1][1] | 1;
  msg = {};
  for msg in (msgs)
    date = ctime(msg[2][1])[5..16];
    from = msg[2][2];
    body = ("" in {@msg[2], ""}) + 1;
    if (strsub(msg[2][4], " ", ""))
      subject = msg[2][4];
    else
      subject = "(None.)";
    endif
    subject = tostr("<A HREF=\"&LOCAL_LINK;/", webcode, "/", tonum(folder), "/read_message?", msg[1], "\">", subject, "</A>");
    line = tostr(date, "   ", $string_utils:left(from, 20), "   ", subject);
    line = tostr($string_utils:right(msg[1], 4, (current_msg == msg[1]) ? ">" | " "), (msg[2][1] > last_old) ? ":+ " | ":  ", line);
    text = {@text, line};
    if ((ticks_left() < 500) || (seconds_left() < 2))
      suspend(1);
    endif
  endfor
  text = {@text, "</PRE>"};
  lastread = msg ? msg[1] | firstread;
else
  text = {@text, "<H3>Sorry! There seems to be a problem with the mail folder. Please notify an administrator.</H3>"};
endif
if (readable)
  "-- show some folder stats";
  totalmsgs = folder:length_all_msgs();
  if (typeof(parsed = folder:parse_message_seq({"last"})) == LIST)
    lastmsg = folder:messages_in_seq(parsed[1])[1][1];
    text = {@text, tostr("Total messages: ", totalmsgs, ", Last message number: ", lastmsg)};
    "-- links to jump within the headers list";
    text = {@text, tostr("<HR><CENTER>", this:folder_navigation_links(who, folder, firstread, lastread), "<P>")};
    text = {@text, @this:build_search_fields(folder), "<P>"};
    text = {@text, tostr("<FORM METHOD=\"GET\" ACTION=\"&LOCAL_LINK;/", this:get_code(), "/", tonum(folder), "/read_message\"><B>Read message number:</B>  <INPUT name=\"\" size=\"5\"></FORM>"), this:subUnsubscribe_tag(folder)};
  endif
endif
text = {@text, "<HR>", this:subscribed_folders_link(), this:basic_header(), "</CENTER><HR>"};
return {tostr("Mail Browser - ", foldername), text};
"Last modified Thu Oct 31 01:12:53 1996 IST by EricM (#3264).";
.

@verb #114:"read_message" this none this rx #95
@program #114:read_message
"read_message(who OBJ, folder OBJ, msgnum STR) -> html doc";
"Read a message as specified by it's message number";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
who = args[1];
folder = args[2];
"remove '=' from GET form posting to make it look like ISINDEX";
msgnum = strsub(args[3], "=", "");
set_task_perms(caller_perms());
current = who:current_message(folder);
msg_seq = folder:parse_message_seq({msgnum}, current);
return this:show_message(who, folder, msg_seq);
"Last modified Tue Oct 15 22:16:22 1996 IST by EricM (#3264).";
.

@verb #114:"browse_folder_link" this none this rx #95
@program #114:browse_folder_link
"browse_folder_link (folder OBJ) -> html link STR";
"Returns a string to serve as a hyperlink for browsing the folder";
"If 'selected' is provided and true, it's used as the msg number to center the header listing on";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
folder = args[1];
selected = tostr({@args, ""}[2]);
webcode = $web_utils:get_webcode();
return tostr("[<A HREF=\"&LOCAL_LINK;/", webcode, "/", tonum(folder), "/browse_folder", selected ? "?" + selected | "", "\">Browse ", $mail_agent:name(folder), "</A>]");
"Last modified Tue Oct 15 22:16:53 1996 IST by EricM (#3264).";
.

@verb #114:"subscribed_folders_link" this none this rx #95
@program #114:subscribed_folders_link
"subscribed_folders_link() -> link STR";
"Returns a string that serves as a hyperlink to the subscribed folders listing";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return tostr("[<A HREF=\"&LOCAL_LINK;/", this:get_code(), "\">List subscribed folders</A>]");
"Last modified Tue Oct 15 22:17:14 1996 IST by EricM (#3264).";
.

@verb #114:"get_code" this none this rx #95
@program #114:get_code
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return pass(@args);
"Last modified Tue Oct 15 22:17:33 1996 IST by EricM (#3264).";
.

@verb #114:"next_msg_link prev_msg_link" this none this rx #95
@program #114:next_msg_link
"next_msg_link(folder, msgnum) -> link STR";
"prev_msg_link(folder, msgnum) -> link STR";
"Returns a string that serves as a link the the next/prev message after msgnum";
"Returns an empty string if there is no next/prev message";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
folder = args[1];
msgnum = args[2];
verb = verb[1..4];
if ((msgnum < 1) || (typeof(folder:parse_message_seq({verb}, msgnum)) != LIST))
  return "";
endif
return tostr("[<A HREF=\"&LOCAL_LINK;/", $web_utils:get_webcode(), "/", tonum(folder), "/read_message?", verb, "\">", (verb == "next") ? "Next" | "Previous", " message</A>]");
"Last modified Tue Oct 15 22:18:06 1996 IST by EricM (#3264).";
.

@verb #114:"folder_description" this none this rx #95
@program #114:folder_description
"folder_description(folder OBJ [, no_tags BOOL]) -> { header STR, descrption STR}";
"Returns a compact description of the specified folder";
"The default is to return a <DT>/<DD> pair for inclusion in a <DL> listing.";
"If a second argument is present and true, the <DT>/<DD> tags are supressed";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
folder = args[2];
no_tags = {@args, 0}[3];
text = {};
prelink = tostr("<A HREF=\"&LOCAL_LINK;/", this:get_code(), "/", tonum(folder), "/browse_folder\">");
namelist = tostr("<B>", prelink, "*", (names = folder:mail_names()) ? $string_utils:from_list(names, ", *") | tostr(folder), "</A></B>");
"the following code mostly lifted from '@subscribe'";
if (typeof(fwd = folder:mail_forward()) != LIST)
  fwd = {};
endif
if (folder:is_writable_by(player))
  if (player in fwd)
    read = " [Writable/Subscribed]";
  else
    read = " [Writable]";
  endif
elseif (typeof(folder.readers) != LIST)
  read = tostr(" [Public", (who in fwd) ? "/Subscribed]" | "]");
elseif (who in fwd)
  read = " [Subscribed]";
elseif (folder:is_readable_by(who))
  read = " [Readable]";
else
  read = "";
endif
if (folder:is_usable_by($no_one))
  mod = "";
elseif (folder:is_usable_by(who))
  mod = " [Approved]";
else
  mod = " [Moderated]";
endif
msgs = tostr(" - ", folder:length_all_msgs(), " messages");
header = tostr(namelist, " (", folder, ")", read, mod, msgs);
desc = folder:description();
if (typeof(desc) != STR)
  desc = $string_utils:from_list(desc, " ");
endif
if (no_tags)
  return {header, desc};
endif
return {"<DT>" + header, "<DD>" + desc};
"Last modified Sun Apr  7 22:46:32 1996 IDT by EricM (#3264).";
.

@verb #114:"folder_navigation_links" this none this rx #95
@program #114:folder_navigation_links
"folder OBJ_navigation_links(who OBJ, folder, firstmsg NUM, lastmsg NUM)";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
who = args[1];
folder = args[2];
"firstread is index of first msg number listed";
firstread = folder:exists_num_eq(args[3]);
"listread is index of last msg number listed";
lastread = folder:exists_num_eq(args[4]);
"lastmsg is index of last msg in folder";
lastmsg = folder:length_all_msgs();
"lines is number of lines of header to display by default";
lines = this.headerlist_len;
"lastMsgNum is actual number of last msg in folder";
lastMsgNum = folder:messages_in_seq(folder:parse_message_seq({"last"})[1])[1][1];
text = "";
webcode = this:get_code();
if (firstread > (lines / 2))
  text = tostr("[<A HREF=\"&LOCAL_LINK;/", webcode, "/", tonum(folder), "/browse_folder?1\">Jump to start</A>] ");
endif
if ((lines * 2) <= (lastmsg - lines))
  text = tostr(text, "[Jump to ");
  i = lines / 2;
  break_ = 0;
  while ((i + lines) < (lastmsg - lines))
    if ((break_ = break_ + 1) >= 15)
      text = text + "<BR>";
      break_ = 0;
    endif
    text = tostr(text, " <A HREF=\"&LOCAL_LINK;/", webcode, "/", tonum(folder), "/browse_folder?", i = i + lines, "\">", i, "</A>");
  endwhile
  if ((lastMsgNum - lastmsg) > 74)
    text = tostr(text, " <A HREF=\"&LOCAL_LINK;/", webcode, "/", tonum(folder), "/browse_folder?", i = lastmsg + ((lastMsgNum - lastmsg) / 2), "\">", i, "</A>");
  endif
  text = tostr(text, "]");
endif
if ((lastread + (lines / 2)) <= (lastmsg + 20))
  text = tostr(text, " [<A HREF=\"&LOCAL_LINK;/", webcode, "/", tonum(folder), "/browse_folder?", lastMsgNum, "\">Jump to end</A>] ");
endif
return text;
"Last modified Sun Apr  7 22:46:32 1996 IDT by EricM (#3264).";
.

@verb #114:"method_post" this none this rx #95
@program #114:method_post
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != $http_handler)
  return E_PERM;
endif
folder = args[2];
function = args[3];
search = args[4];
form = $web_utils:parse_form(args[5], 2);
field_names = form[1];
field_values = form[2];
if (((cp = caller_perms()) == $no_one) || $object_utils:isa(cp, $guest))
  set_task_perms($hacker);
  "$no_one and $guest's don't own themselves, $hacker does.";
else
  set_task_perms(cp);
endif
if (!function)
  "can't find call's function";
  return {"Mail Browser - Search", {"<H2>Sorry!</H2> There seems to be a problem with the Mail Browser.  Please let an administrator know."}};
endif
if (function == "search")
  return {@this:search_mail(folder, search, field_names, field_values)};
elseif (function == "read")
  return {@this:read_by_post(folder, search, field_names, field_values)};
endif
"ran out of known functions";
return {"Mail Browser - Search", {"<H2>Sorry!</H2> There seems to be a problem with the Mail Browser.  Please let an administrator know."}};
"Last modified Sun Apr  7 22:46:32 1996 IDT by EricM (#3264).";
.

@verb #114:"search_mail" this none this rx #95
@program #114:search_mail
"search_mail(folder, search, field_names, field_values) -> html doc";
"field name for function: search";
"Other fields: range_start, range_end, before, after, since, until, from, to, subject, body, first, last";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
who = caller_perms();
folder = args[1];
field_names = args[3];
field_values = args[4];
set_task_perms(who);
search_spec = {};
if ((i = "range_start" in field_names) && (range_start = field_values[i]))
  range_end = (i = "range_end" in field_names) && field_values[i];
  search_spec = {@search_spec, tostr(range_start, range_end ? "-" + range_end | "")};
endif
for part in [1..2]
  if ((i = tostr("param", part) in field_names) && (param_name = field_values[i]))
    if ((i = tostr("value", part) in field_names) && (param_value = field_values[i]))
      search_spec = {@search_spec, tostr(param_name, ":", param_value)};
    endif
  endif
endfor
current = who:current_message(folder) || 0;
msg_seq = folder:parse_message_seq(search_spec, current);
result = this:show_headers(who, folder, msg_seq, current);
result[2][1] = tostr(result[2][1], " <B>Search [", $string_utils:from_list(search_spec, " "), "] - ", ((typeof(msg_seq) == LIST) && msg_seq) ? folder:seq_size(msg_seq[1]) | 0, " messages found</B>");
return result;
"Last modified Sun Apr  7 22:46:33 1996 IDT by EricM (#3264).";
.

@verb #114:"build_search_fields" this none this rx #95
@program #114:build_search_fields
"build_search_fields(folder) -> html form";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
folder = args[1];
form = {};
form = {tostr("<FORM METHOD=\"POST\" ACTION=\"&LOCAL_LINK;/", this:get_code(), "/", tonum(folder), "/search\">")};
form = {@form, tostr("<B>SEARCH ", $mail_agent:name(folder), "</B><BR>")};
form = {@form, " From msg# <INPUT name=\"range_start\" size=5> To msg# <INPUT name=\"range_end\" size=5><BR>"};
searchlist = {"before", "after", "since", "until", "from", "to", "body", "subject"};
for part in [1..2]
  form = {@form, tostr("<SELECT name=\"param", part, "\"><OPTION value=\"\">")};
  options = "";
  for field in (searchlist)
    options = tostr(options, "<OPTION value=\"", field, "\">", field);
  endfor
  form = {@form, options, tostr("</SELECT><INPUT name=\"value", part, "\" size=20>")};
endfor
form = {@form, "<BR><INPUT type=\"reset\" value=\"Clear the fields\"><INPUT type=\"submit\" value=\"Do the search\">"};
form = {@form, "<BLOCKQUOTE>(Dates can be any of weekday, dd-Month, dd-Month-yy or dd-Month-yyyy date. 'From' and 'To' refer to people, 'Body' and 'Subject' are keyword searches targeted to those fields. Search is for items for which ALL entered values are true..)</BLOCKQUOTE></FORM>"};
return form;
"Last modified Sun Apr  7 22:46:49 1996 IDT by EricM (#3264).";
.

@verb #114:"subscribe unsubscribe" this none this rx #95
@program #114:subscribe
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return this:browse_folder(who, folder);
if (caller != this)
  return E_PERM;
endif
folder = args[2];
rest = args[3];
set_task_perms(who = caller_perms());
if (((who == folder) || (who == $no_one)) || $object_utils:isa(who, $guest))
  return this:browse_folder(who, folder);
endif
if (rest == "subscribe")
  who:make_current_message(folder);
  if ($object_utils:isa(folder, $mail_recipient) && who:mail_option("notify-all"))
    folder:add_notify(this);
  endif
elseif (rest == "unsubscribe")
  "Copied from $player:@unsubscribe";
  unsubscribed = {};
  current_folder = who:current_folder();
  for a in (args || {0})
    if (a ? $mail_agent:match_failed(folder = $mail_agent:match_recipient(a), a) | (folder = current_folder))
      "...bogus folder name, done...  No, try anyway.";
      if (who:kill_current_message(who:my_match_object(a)))
        who:notify("Invalid folder, but found it subscribed anyway.  Removed.");
      endif
    elseif (folder == who)
      who:notify(tostr("You can't unsubscribe yourself."));
    else
      if (!who:kill_current_message(folder))
        who:notify(tostr("You weren't subscribed to ", $mail_agent:name(folder)));
        if ($object_utils:isa(folder, $mail_recipient))
          result = folder:delete_notify(who);
          if ((typeof(result) == LIST) && (result[1] == who))
            who:notify("Removed you from the mail notifications list.");
          endif
        endif
      else
        unsubscribed = {@unsubscribed, folder};
        if ($object_utils:isa(folder, $mail_recipient))
          folder:delete_notify(who);
        endif
      endif
    endif
  endfor
  if (unsubscribed)
    who:notify(tostr("Forgetting about ", $string_utils:english_list($list_utils:map_arg($mail_agent, "name", unsubscribed))));
    if (current_folder in unsubscribed)
      who:set_current_folder(who);
    endif
  endif
endif
return this:browse_folder(who, folder);
"Last modified Sun Apr  7 22:49:14 1996 IDT by EricM (#3264).";
.

@verb #114:"subUnsubscribe_tag" this none this rx #95
@program #114:subUnsubscribe_tag
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return {};
if (caller != this)
  return E_PERM;
endif
folder = args[1];
who = caller_perms();
set_task_perms(who);
if (((who == folder) || (who == $no_one)) || $object_utils:isa(who, $guest))
  tag = {};
else
  webcode = this:get_code();
  folders = this:subscribed_folders(who, 1);
  if (folder in folders)
    tag = tostr("Subscribed/<A HREF=\"&LOCAL_LINK;/", webcode, "/", tonum(folder), "/", "unsubscribe\"><B>UNSUBSCRIBE</B></A> from ", $mail_agent:name(folder));
  else
    tag = tostr("Not subscribed/<A HREF=\"&LOCAL_LINK;/", webcode, "/", tonum(folder), "/", "subscribe\"><B>SUBSCRIBE</B></A> to ", $mail_agent:name(folder));
  endif
endif
return tag;
"Last modified Sun Apr  7 22:49:15 1996 IDT by EricM (#3264).";
.

@verb #114:"init_for_core" this none this rxd #95
@program #114:init_for_core
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || caller_perms().wizard))
  return E_PERM;
endif
this.guest_subscribed_folders = {};
return pass(@args);
"Last modified Tue Aug 27 17:55:20 1996 IDT by EricM (#3264).";
.

"***finished***
