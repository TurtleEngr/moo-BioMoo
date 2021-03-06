$Header: /repo/public.cvs/app/BioGate/BioMooCore/core112.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #112 with create
@create $thing named MCP Utilities:MCP Utilities,mcp
@prop #112."initial_session_info" {} rc
;;#112.("initial_session_info") = {E_NONE, "", "1.0", "", 0, {}}
@prop #112."announce_version" "1.0" rc
@prop #112."unconnected_ok" {} rc
;;#112.("unconnected_ok") = {"ping", "multiline-test", "authentication-key"}
@prop #112."escape_chars" "\" " rc
@prop #112."reading" {} "" #95
;;#112.("reading") = {0}
@prop #112."reading_data" {} "" #95
;;#112.("reading_data") = {0}
@prop #112."suspend_during_multiline" 1 rc
@prop #112."sessions" {} "" #95
;;#112.("sessions") = {#233}
@prop #112."session_infos" {} "" #95
;;#112.("session_infos") = {{1, "0.9725259116141947", "1.0", "1.0", 0, {}}}
@prop #112."initiate_on_connect" 0 rc
@prop #112."session_cns" {} "" #95
;;#112.("session_cns") = {"port 8888 from dhcpik0775.mayfield.hp.com, port 1133"}
;;#112.("aliases") = {"MCP Utilities", "mcp"}
;;#112.("object_size") = {22535, 937987203}

@verb #112:"user_connected" this none this rxd #95
@program #112:user_connected
"$mcp:user_connected(who) - called when a user connects to the MOO. ";
"Initializes the user's session info and prints the initial MCP announcement (if they have \"mcp\" enabled in their @user-options).";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (this.initiate_on_connect)
  this:initiate_mcp(who);
endif
if (!valid(who = args[1]))
  this:sweep();
  return;
elseif (!$perm_utils:controls(caller_perms(), who))
  return E_PERM;
endif
if (i = connection_name(who) in this.session_cns)
  this.sessions[i] = who;
endif
this:sweep();
if (`$user_options:get(who.user_options, "mcp") ! E_PROPNF')
  "initiate MCP if user has that as an option, presumably because they always connect with an MCP-aware client";
  "some MOOs might not have $user_options may want to modify this";
  this:initiate_mcp(who);
endif
"Last modified Sun Oct  6 00:56:44 1996 IST by EricM (#3264).";
.

@verb #112:"do_out_of_band_command" this none this rx #95
@program #112:do_out_of_band_command
"$mcp:do_out_of_band_command(@args) - Called by #0:do_out_of_band_command to parse an MCP request.";
"Returns true if the OOB command was taken care of, or false if it didn't appear to be an MCP command.  Arguments are the same as those to #0:do_out_of_band_command.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (!valid(player))
  return (caller == #0) ? this:do_unconnected_oob(@args) | E_PERM;
elseif (!$perm_utils:controls(caller_perms(), player))
  return E_PERM;
endif
parsed = this:parse_request(this:session_info(player)[3], args);
if (!parsed)
  return parsed;
elseif (parsed == 1)
  return 1;
elseif (typeof(parsed) != LIST)
  this:error(parsed);
  return 1;
else
  this:set_session_info(player, 1, 1);
  return this:("mcp_" + parsed[1])(@parsed[3..length(parsed)]) || 0;
endif
"Last modified Thu Aug 22 07:55:53 1996 IDT by EricM (#3264).";
.

@verb #112:"parse_request" this none this rx #95
@program #112:parse_request
":parse_request(version, words) - Parse a (possible) MCP request line into its component parts.";
"Called by $mcp:do_out_of_band_command and $mcp:do_unconnected_oob";
"If successful, returns {request-type, auth-key, data-alist}.  'words' is the result of the line in question being parsed into its separate words (of the same format as $string_utils:words). ";
"Returns 0 if line does not appear to be an MCP command, or a string value if there was an error.";
"Note:  This routine is currently pretty liberal in what it considers a possible MCP request, mainly because the issue of OOB domain-space is still being sorted out.  This may change in future depending on what's decided.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (args[1] != "1.0")
  "Version 1.0 is currently the only one supported...";
  return E_INVARG;
endif
words = args[2];
multiline = 0;
if (words[1][1..3] != "#$#")
  return 0;
else
  words[1][1..3] = "";
endif
if ((words == {"end"}) && (this:is_reading(player) == 1))
  "..special #$#END tag for a multi-line request..";
  result = this:done_reading(player);
  return {@result[1], result[2]};
elseif (!words[1])
  return 0;
elseif ((length(words) < 2) || index(words[2], ":"))
  words[2..1] = {""};
endif
reqinfo = words[1..2];
if (reqinfo[1][i = length(reqinfo[1])] == "*")
  "..multi-line request..";
  reqinfo[1][i..i] = "";
  multiline = 1;
endif
data = {};
while (words = words[3..length(words)])
  len = length(words[1]);
  if (words[1][len] != ":")
    return tostr("MCP ", reqinfo[1], ": malformed request (couldn't parse '", words[1], "').");
  elseif (length(words) < 2)
    return tostr("MCP ", reqinfo[1], ": malformed request (missing value for key '", words[1], "').");
  endif
  data = {@data, {words[1][1..len - 1], words[2]}};
endwhile
if (reqinfo[1] == "authentication-key")
  "..sigh. have to do special handling of authentication-key because MCP/1.0 doesn't follow its own rules..";
  data = {@data, {"key", reqinfo[2]}};
endif
if (multiline)
  this:set_reading(player, 1, {@reqinfo, data});
  return 1;
else
  return {@reqinfo, data};
endif
"Last modified Thu Aug 22 07:56:13 1996 IDT by EricM (#3264).";
.

@verb #112:"mcp_authentication-key" this none this rxd #95
@program #112:mcp_authentication-key
"MCP #$#authentication-key <new-key>";
" - establishes an authentication key for the session.";
"   This request type actually requires a little special processing in :parse_request because of the way the protocol works..";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
data = $list_utils:assoc("key", args[1]);
if (!data)
  this:error("MCP authentication-key:  missing required parameter ('key').");
else
  this:set_session_info(player, 2, data[2]);
endif
return 1;
"Last modified Thu Aug 22 07:56:14 1996 IDT by EricM (#3264).";
.

@verb #112:"error" this none this rxd #95
@program #112:error
":error(msg) - Report an error message.";
"Called by $mcp routines if an error occurs.  Prints the error message to the user.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
if (!valid(player))
  notify(player, tostr(@args));
else
  player:notify(tostr(@args));
endif
"Last modified Thu Aug 22 07:56:29 1996 IDT by EricM (#3264).";
.

@verb #112:"send_mcp" this none this rx #95
@program #112:send_mcp
"$mcp:send_mcp(who, request, data [,multiline-data]) - Send an MCP request to the other end.";
"'request' is the request-name, 'data' is an alist of {keyname, value} pairs. 'multiline-data' is an optional list of text lines to send in the form of a multi-line MCP request.";
"Returns:";
"  1      - successful.";
"  E_PERM - the caller is not allowed to send that request to that person.";
"  -1     - Ran out of time/network buffer space during multiline send and not allowed to suspend.  Request data was only partially sent.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (!this:allowed(caller_perms(), @args))
  return E_PERM;
endif
if (typeof(args[3]) == STR)
  data = args[3] && (" " + args[3]);
else
  data = "";
  for elem in (args[3])
    data = tostr(data, " ", elem[1], ": ", this:escape_value(elem[2]));
  endfor
endif
while ((session_info = this:session_info(who = args[1]))[5])
  suspend(0);
endwhile
if (key = session_info[2] || "")
  key = " " + key;
endif
if ((length(args) > 3) && (session_info[3] == "1.0"))
  notify(who, tostr("#$#", args[2], "*", key, data));
  bytelimit = buffered_output_length() - 10;
  if (this.suspend_during_multiline)
    this:set_session_info(who, 5, 1);
    who:hold_output();
    for line in (args[4])
      while (((ticks_left() < 4000) || (seconds_left() < 2)) || ((bib = buffered_output_length()) && ((bib + length(line)) > bytelimit)))
        suspend(0);
      endwhile
      notify(who, "@@@" + line);
    endfor
    who:release_output();
    this:set_session_info(who, 5, 0);
  else
    for line in (args[4])
      if (((ticks_left() < 4000) || (seconds_left() < 2)) || ((bib = buffered_output_length()) && ((bib + length(line)) > bytelimit)))
        notify(who, "#$#END");
        return -1;
        "..(sigh.. had to cut it short because we ran out of time/buffer.  Unfortunately there isn't any better way without suspending)..";
      endif
      notify(who, "@@@" + line);
    endfor
  endif
  notify(who, "#$#END");
else
  notify(who, tostr("#$#", args[2], key, data));
endif
return 1;
"Last modified Thu Aug 22 07:56:29 1996 IDT by EricM (#3264).";
.

@verb #112:"allowed" this none this rxd #95
@program #112:allowed
"$mcp:allowed(caller, who, type [,other args]) - Is 'caller' allowed to send 'type' requests to 'who's client?";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (!valid(args[2]))
  return args[1].wizard;
else
  return $perm_utils:controls(args[1], args[2]);
endif
"Last modified Thu Aug 22 07:56:29 1996 IDT by EricM (#3264).";
.

@verb #112:"display_url" this none this rxd #95
@program #112:display_url
"$mcp:display_url(who, url [,target]) - Send an MCP display-url request.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
set_task_perms(caller_perms());
if (length(args) > 2)
  return this:send_mcp(args[1], "display-url", {{"url", args[2]}, {"target", args[3]}});
else
  return this:send_mcp(args[1], "display-url", {{"url", args[2]}});
endif
"Last modified Thu Aug 22 07:56:44 1996 IDT by EricM (#3264).";
.

@verb #112:"confirmed" this none this rx #95
@program #112:confirmed
"$mcp:confirmed(who) - Is 'who' using MCP?";
"Returns true if we have received at least one MCP request from who's client already, indicating it's an MCP-supporting client.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
return this:session_info(args[1])[1];
"Last modified Thu Aug 22 07:56:44 1996 IDT by EricM (#3264).";
.

@verb #112:"mcp_ping" this none this rxd #95
@program #112:mcp_ping
"MCP #$#ping [seq: <sequence-id>] [data: <data>]";
" - responds with a #$#pong message, containing the same seq: and data: values as the #$#ping request.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
this:send_mcp(player, "pong", args[1]);
return 1;
"Last modified Thu Aug 22 07:56:44 1996 IDT by EricM (#3264).";
.

@verb #112:"do_unconnected_oob" this none this rx #95
@program #112:do_unconnected_oob
":do_unconnected_oob(@args) - Process OOB command for unconnected user.";
"Called by $mcp:do_out_of_band_command";
"Somewhat special processing if the OOB command is coming from an un-logged-in user, as we only allow a subset of requests.";
"Arguments and return values are the same as those for $mcp:do_out_of_band_command.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
parsed = this:parse_request("1.0", args);
if (!parsed)
  return parsed;
elseif (parsed == 1)
  return 1;
elseif (typeof(parsed) != LIST)
  this:error(parsed);
  return 1;
elseif (!(parsed[1] in this.unconnected_ok))
  this:error("MCP: ", parsed[1], " request not supported prior to login.");
  return 1;
else
  return this:("mcp_" + parsed[1])(@parsed[3..length(parsed)]) || 0;
endif
"Last modified Thu Aug 22 07:56:44 1996 IDT by EricM (#3264).";
.

@verb #112:"escape_value" this none this rxd #95
@program #112:escape_value
"$mcp:escape_value(string) - Make string into a valid MCP data string.";
"Determine whether the specified string would require escaping (being placed in quotes, etc) for sending out as a parameter value in an MCP request, and if so escape it.";
"Always returns a string which is \"clean\" for use as an MCP value.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if ((!(what = args[1])) || match(what, tostr("[", this.escape_chars, "]")))
  return $string_utils:print(what);
else
  return what;
endif
"Last modified Thu Aug 22 07:56:44 1996 IDT by EricM (#3264).";
.

@verb #112:"initiate_mcp" this none this rxd #95
@program #112:initiate_mcp
"$mcp:initiate_mcp(who) - Start an MCP session.";
"Starts an MCP session for 'who' by sending out the initial #$#mcp request.";
"Returns E_INVARG if 'who' has already had MCP initiated, 1 if successful.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (!$perm_utils:controls(caller_perms(), who = args[1]))
  return E_PERM;
elseif ((si = this:session_info(who))[4])
  return E_INVARG;
endif
this:send_mcp(who, "mcp", {{"version", this.announce_version}});
si[1] = 0;
si[4] = this.announce_version;
this:set_session_info(who, si);
return 1;
"Last modified Thu Aug 22 07:56:59 1996 IDT by EricM (#3264).";
.

@verb #112:"mcp_window-info" this none this rxd #95
@program #112:mcp_window-info
"This is just a temporary kludge for fun.. currently (as far as I know) my Cup-O MUD client is the only one which sends #$#window-info messages (even though DU currently doesn't support them), so this is just to let me know who's using my client :)";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
this.owner:tell("--- ", player.name, " has connected with Cup-O MUD ---");
player.mcp_session_info = setadd(player.mcp_session_info, "cupomud");
return 1;
"Last modified Thu Aug 22 07:56:59 1996 IDT by EricM (#3264).";
.

@verb #112:"set_reading" this none this rxd #95
@program #112:set_reading
":set_reading(who, type, data) - Begin reading multiline data for a request.";
"The following 'type's of reading are currently defined:";
"  1 - Standard MCP/1.0 multiline data (lines prefixed by \"@@@\")";
"'data' is any information to associate with the read (returned by :done_reading along with the read lines).";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if ((!(cp = caller_perms()).wizard) && (!$perm_utils:controls(cp, args[1])))
  return E_PERM;
endif
if (!(i = args[1] in this.sessions))
  i = this:new_session(args[1]);
endif
this.reading[i] = args[2];
this.reading_data[i] = {args[3], {}};
return 1;
"Last modified Thu Aug 22 07:57:00 1996 IDT by EricM (#3264).";
.

@verb #112:"done_reading" this none this rxd #95
@program #112:done_reading
":done_reading(who) - Conclude a reading session.";
"Returns {data, text}, where 'data' is the data provided in the corresponding :set_reading call, and 'text' is the multiline-data read.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if ((!(cp = caller_perms()).wizard) && (!$perm_utils:controls(cp, args[1])))
  return E_PERM;
elseif (!(i = args[1] in this.sessions))
  return E_NONE;
endif
result = this.reading_data[i];
this.reading[i] = 0;
this.reading_data[i] = 0;
return result;
"Last modified Thu Aug 22 07:57:00 1996 IDT by EricM (#3264).";
.

@verb #112:"is_reading" this none this rx #95
@program #112:is_reading
"$mcp:is_reading(who) - Is 'who' in the middle of a multiline-MCP read?";
"Returns the type of reading 'who' is currently engeged in, or 0 if 'who' is not processing a multiline MCP request.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
return this.reading[args[1] in this.sessions] || 0;
"Last modified Thu Aug 22 07:57:00 1996 IDT by EricM (#3264).";
.

@verb #112:"process_reading_line" this none this rx #95
@program #112:process_reading_line
"$mcp:process_reading_line(who, line) - take an input line and snarf it if it's an @@@ line, returning 1, or return 0 if it's just normal input.";
"This should only be called by system routines which process user input.";
"This does very little checking to make sure it's actually a valid call, so the calling routine must make sure $mcp:is_reading(player) == 1 before it calls this routine.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (!caller_perms().wizard)
  return E_PERM;
elseif ((line = args[2])[1..3] != "@@@")
  return 0;
else
  line[1..3] = "";
  i = args[1] in this.sessions;
  this.reading_data[i][2] = {@this.reading_data[i][2], line};
  return 1;
endif
"Last modified Thu Aug 22 07:57:00 1996 IDT by EricM (#3264).";
.

@verb #112:"session_info" this none this rx #95
@program #112:session_info
":session_info(who) - return MCP session information for 'who'";
"Returns {confirmed, authentication-key, current-MCP-version, announced-version, sending-multiline, mcp-options}";
"This verb is only intended for $mcp-internal use.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (caller != this)
  return E_PERM;
elseif (!(idle_seconds(who = args[1]) + 1))
  return E_INVARG;
endif
if (i = who in this.sessions)
  return this.session_infos[i];
else
  return this.initial_session_info;
endif
"Last modified Thu Aug 22 07:57:16 1996 IDT by EricM (#3264).";
.

@verb #112:"set_session_info" this none this rxd #95
@program #112:set_session_info
"   :set_session_info(who, session-info)";
"or :set_session_info(who, index, data) - Change 'who's MCP session info.";
"Replace 'who's session info with 'session-info' (first form) or replace index 'index' with 'data' (second form).";
"This verb is only intended for $mcp-internal use.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
if (!(i = args[1] in this.sessions))
  i = this:new_session(args[1]);
endif
if (typeof(args[2]) == NUM)
  this.session_infos[i][args[2]] = args[3];
  return this.session_infos[i];
else
  return this.session_infos[i] = args[2];
endif
"Last modified Thu Aug 22 07:57:16 1996 IDT by EricM (#3264).";
.

@verb #112:"new_session" this none this rxd #95
@program #112:new_session
":new_session(who) - Establish new MCP session data for 'who'";
"Returns index of 'who' in .sessions prop.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
this.sessions = {@this.sessions, args[1]};
this.session_cns = {@this.session_cns, connection_name(args[1])};
this.session_infos = {@this.session_infos, this.initial_session_info};
this.reading = {@this.reading, 0};
this.reading_data = {@this.reading_data, 0};
return length(this.sessions);
"Last modified Thu Aug 22 07:57:16 1996 IDT by EricM (#3264).";
.

@verb #112:"remove_session" this none this rxd #95
@program #112:remove_session
":remove_session(who) - Remove session data for 'who'.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
i = args[1];
this.sessions = listdelete(this.sessions, i);
this.session_cns = listdelete(this.session_cns, i);
this.session_infos = listdelete(this.session_infos, i);
this.reading = listdelete(this.reading, i);
this.reading_data = listdelete(this.reading_data, i);
return 1;
"Last modified Thu Aug 22 07:57:17 1996 IDT by EricM (#3264).";
.

@verb #112:"sweep" this none this rx #95
@program #112:sweep
":sweep() - Check for stale sessions and remove them.";
"Sweeps $mcp's session data properties and removes any data for sessions which are no longer connected.";
"(C) Copyright 1996 Alex Stewart; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
remove = {};
for i in [1..length(this.sessions)]
  if (connection_name(this.sessions[i]) != this.session_cns[i])
    remove = {i, @remove};
  endif
endfor
for i in (remove)
  this:remove_session(i);
endfor
"Last modified Thu Aug 22 07:57:37 1996 IDT by EricM (#3264).";
.

"***finished***
