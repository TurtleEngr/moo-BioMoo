$Header: /repo/public.cvs/app/BioGate/BioMooCore/core115.moo,v 1.1 2021/07/27 06:44:27 bruce Exp $

>@dump #115 with create
@create $webapp named HTTP Handler:HTTP Handler,http_handler,HTTP_hndlr
@prop #115."task_details" {} ""
@prop #115."task_index" {} ""
@prop #115."total_webcalls" 15708 r
@prop #115."webpass_handler" #97 r
@prop #115."gateway_html" {} r
;;#115.("gateway_html") = {"This is the text in $http_handler.identify_html.<P>", " If you're reading this, then the FUP system is not working and the administrators of this MOO should either fix it or add a real MOO web gateway page here.<P>", " A typical web gateway page will include at least something like the following:<P>", "<H3>Welcome to our little hovel!</H3>", "Please enter the name and password of your character at our MOO, or enter the name \"anonymous\" if you don't have a character here.<P>", "<FORM METHOD=\"POST\" ACTION=\"/\">", "<DL>", "<DT><INPUT TYPE=\"TEXT\" NAME=\"user_name\"> <B>Your character's name</B><P>", " <DT><INPUT TYPE=\"PASSWORD\" NAME=\"password\"> <B>Your character's password</B><P>", "<DT><INPUT TYPE=\"SUBMIT\" VALUE=\"open a web window into the MOO\">", "</DL>", "</FORM>"}
@prop #115."wizwebpass_disallowed" 1 ""
@prop #115."version" "1.4b" r
@prop #115."output_timeout" 180 r
@prop #115."password_failed_text" {} r
;;#115.("password_failed_text") = {"<H2>Sorry!</H2>", "<B>Either your password is incorrect (if you just entered one) or your web token has expired (if you disconnected since last using the web system).<P>", "Please return to the web gateway page, and reenter your password.</B>"}
@prop #115."exempt_from_pads" {} r
@prop #115."anon_access_limits" {} r
;;#115.("anon_access_limits") = {5, 10}
@prop #115."lag_meter" #132 r
@prop #115."too_much_load_text" {} r
;;#115.("too_much_load_text") = {"<B>SORRY!</B> There's too much load on this server at the moment, and anonymous connections are being restricted.  Please try again in a while."}
@prop #115."login_is_http09" 0 r
@prop #115."port_handlers" {} r
;;#115.("port_handlers") = {#128, #129}
@prop #115."robots_txt" {} r
;;#115.("robots_txt") = {"# this is the text sent in response to the URL /robots.txt", "# it tells web spiders to not try to access every page in the site", "", "User-agent: *", "Disallow: /"}
@prop #115."java_clients" {} r
;;#115.("java_clients") = {#110}
@prop #115."javaclient_codebase" "/DECORE/java/" r
;;#115.("code") = "applist"
;;#115.("aliases") = {"HTTP Handler", "http_handler", "HTTP_hndlr"}
;;#115.("description") = {"The primary webapp for HTTP tasks. It catches web calls, does the", "initial interpretation of their meaning, and calls the appropriate", "web-related verbs on user webapps, like the Standard Viewer or the", "Object Browser/Editor.  It also handles all security aspects of the", "web connections."}
;;#115.("object_size") = {52575, 937987203}
;;#115.("web_calls") = 1

@verb #115:"handle_http09" this none this rx #95
@program #115:handle_http09
"handle(player OBJ, method STR, url STR, protocol STR) -> html doc LIST";
"verb = 'get' or 'post', url = path string";
"Read the HTTP request, and form data if posted.  Record task";
"details, parse the path string.  If invalid webpass, send out MOO web";
"gateway page. Otherwise, call this:process() to decide what webapp to";
"call, etc.  Take the resulting list of string, replace occurrences of";
"'&LOCAL_LINK;' with 'host:post:/xxwebpass', and send it all to the open";
"connection.  If no text is returned, send the MOO web gateway page.";
"NOTE: the only way for an HTTP/0.9 browser to get issued a webpass is";
"to solicit one with a request in the form";
"'http://moo.place.edu/?<webpass>' where <webpass> has been previously";
"set with the $player:@webpass command.  The sample web gateway page";
"(in $http_handler.gateway_html) doesn't have a search field for";
"entering a webpass, which is what HTTP/0.9 browsers need.";
"WIZARDLY to enable notify() on open connections";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller in this.port_handlers) || caller_perms().wizard))
  return E_PERM;
  "expects call from $login:\"GET POST\"";
endif
cu = $command_utils;
{conn, verb, url, protocol} = args;
"This port can handle only HTTP/0.9...";
http_version = "0.9";
"no headers in HTTP/0.9";
headers = {};
"but suck up any headers the browser might spew";
while (line = `read(conn) ! E_INVARG => ""')
endwhile
if (!`idle_seconds(conn) + 1 ! ANY')
  "The client closed connection - forget about it.";
  return;
endif
if (url in {"", "/"})
  return this:tell_quick_and_die(conn, this:provide_identify());
  "user called with no request path, so return the MOO's web gateway page";
elseif (url in {"robots.txt", "/robots.txt"})
  "tell web spiders to scat";
  return this:tell_quick_and_die(conn, this.robots_txt);
endif
"parse the path string, into {webpass, webappcode, what, rest, search}";
{pass, webcode, what, rest, search} = this:parse_line(url);
player = this.webpass_handler:check_candidate(pass);
"note: object 'player' doesn't have to have player bit set :)";
if ((player == $no_one) && ((length(this.task_index) > this.anon_access_limits[1]) || (this.lag_meter.samples[this.lag_meter.sample_count] > this.anon_access_limits[2])))
  return this:tell_quick_and_die(conn, this.too_much_load_text);
  "note: if you've added $no_one (Everyman, usually #40) to the webpass handler with the webpass 'anon' or 'anonymous' this enables anonymous connections through the HTTP/0.9 port.";
  "$http_handler.anon_access_limits is set to {max anonymous tasks, max server lag load}";
  "The latter uses the standard sort of lag meter found in most MOOs.";
elseif ((typeof(player) != OBJ) || (player.wizard && this.wizwebpass_disallowed))
  return this:tell_quick_and_die(conn, this.password_failed_text);
  "user doesn't have a registered webpass, gave a bad one, or is a wizard. Send the MOO gateway web page";
  "force wizen to use the more secure authentication system, if $http_handler.wizwebpass_disallowed";
elseif (("tight_link" in player.web_options) && (player in connected_players()))
  "require web connection to be from same machine as telnet connection if any";
  telnet_conn = substitute("%1", match(connection_name(player), "from %([^ ,]*%)"));
  web_conn = substitute("%1", match(connection_name(conn), "from %([^ ,]*%)"));
  if (telnet_conn != web_conn)
    return this:tell_quick_and_die(conn, this.password_failed_text);
  endif
endif
"tell the user a webpass access from the web gateway page has occurred";
if ((pass && (!what)) && (!webcode))
  player:tell("You open a web window into ", $network.MOO_name, ".");
endif
"add web transaction info to task record";
this:init_taskprop(webcode, player, {"headers", "http_version", "connection_source", "port_handler"}, {headers, http_version, conn, (caller == this) ? $login | caller});
task = task_id();
"";
fork wait_task (this.output_timeout)
  "this will run if the web task dies; it cleans up after it, and sends an apology to the user";
  this:webtask_timedout(conn, task);
endfork
"";
text = this:process(verb, webcode, what, rest, search);
"web call ran successfully; kill the backup fork";
kill_task(wait_task);
if (text)
  "send out the web text over the open connection, and close it";
  return this:tell_quick_and_die(conn, text, pass);
else
  "no text returned, so send MOO web gateway page and close the connection";
  return this:tell_quick_and_die(conn, this:provide_identify());
endif
this:webtask_cleanup();
"Last modified Wed Sep 18 20:50:47 1996 IST by Gustavo (#2).";
.

@verb #115:"provide_menu method_get method_post" this none this rx #95
@program #115:provide_menu
"provide_menu(who OBJ) -> {webpage title STR, html text LIST}";
"Generates a hyperlinked list of web applications available to user 'who'";
"Some webapps may restrict who uses them.  This is implemented by a";
"call to :available() on each webapp (which by default just returns";
"the value of this.available).  This can serve as one level of";
"security to keep unauthorized users from the webapp. Note that users";
"can still reach the webapp directly if they know its webcode, and";
"additional security on the webapp is needed.";
"WIZARDLY to set task perms to player";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
set_task_perms(player);
who = args[1];
using_cookies = `$http_handler:retrieve_taskprop("port_handler").authentication_method == "cookies" ! E_PROPNF => 0';
if ("clear_authentication" == {@args, "", ""}[3])
  "a request to clear web cookie and/or webpass";
  this:submit_taskprop("set-cookie", tostr("webpass=", $http_handler.webpass_handler:webpass_for(who), "; path=/; expires=Thu, 01-Jan-1970 00:00:01 GMT"));
  if (who != $no_one)
    "fork it so the web transaction can complete with a valid webpass";
    fork (0)
      $http_handler.webpass_handler:remove_webpass(who);
    endfork
  endif
  return {tostr("Clear ", $network.MOO_name, "Authentication"), {"<H2>Authentication cleared.</H2>", "<FORM METHOD=\"POST\" ACTION=\"&LOCAL_LINK;/\"><INPUT TYPE=\"SUBMIT\" VALUE=\"Continue...\">"}};
endif
MOO_site = ("use_ip" in player.web_options) ? $network.numeric_address | $network.site;
text = {"<P>Select an application from the following:<P>"};
apps = $object_utils:descendants($webapp);
if ($standard_webviewer in apps)
  apps = {$standard_webviewer, @setremove(apps, $standard_webviewer)};
endif
ap = 1;
for app in (apps)
  if (app:available(who))
    text = {@text, tostr($string_utils:right(ap, 3), ") <A HREF=\"&LOCAL_LINK;/", app:get_code(), "/\">", app:namec(1), "</A><BR>")};
    ap = ap + 1;
  endif
endfor
security = {"<P>Current access is: " + $web_utils:access_security()[2]};
if (using_cookies)
  security = {@security, tostr("<FORM METHOD=\"POST\" ACTION=\"&LOCAL_LINK;/", this:get_code(), "/0/clear_authentication\"><INPUT TYPE=\"SUBMIT\" VALUE=\"clear authentication certificate\"></FORM>")};
endif
homepage = $web_utils.MOO_home_page ? tostr("<A HREF=\"", $web_utils.MOO_home_page, "\">", $network.MOO_name, "'s home page</A>, or to ") | "";
return {"Applications list", {@text, @security, tostr("<P>Return to ", homepage, "the <A HREF=\"http://", MOO_site, ":", `$http_handler:retrieve_taskprop("port_handler").handles_port ! E_PROPNF, E_TYPE => $network.port', "\">MOO's web gateway page</A>.")}};
"Last modified Thu Jan  2 18:27:38 1997 IST by Gustavo (#2).";
.

@verb #115:"handle_BioSat use" this none this x #95
@program #115:handle_BioSat
"use handle_BioSat( webstring STR ) -> html doc LIST";
"serves the same function as this:handle, but for web transactions";
"coming in via a MOOSat.";
"This verb handles HTTP/1.0 connections (like this:handle does for HTTP/0.9 ones)";
"but specifically those coming in from BioSat satellite MOOs.";
"Note that the MOO can handle HTTP/1.0 itself using multiple port listen";
"WIZARDLY to permit examination of user passwords";
if ((!(caller in this.port_handlers)) && (!caller_perms().wizard))
  return E_PERM;
endif
MOOlink = caller;
trans = args[1];
"extract transaction number";
t = trans[1..index(trans, "-") - 1];
trans = trans[length(t) + 2..length(trans)];
if (stuff = match(trans, "^%([0-9]+%)-%([0-9]+%)%(G%|P%)%([0-9]%.[0-9]%)?-"))
  "extract field lengths";
  keylen = tonum(substitute("%1", stuff));
  whatlen = tonum(substitute("%2", stuff));
  "determine transaction type";
  mode = {"GET", "POST"}[substitute("%3", stuff) in {"G", "P"}];
  "determine protocol";
  protocol = substitute("%4", stuff) || "0.9";
  rest = trans[stuff[3][4][2] + 2..length(trans)];
  "extract authentication key";
  key = rest[1..keylen];
  "extract path string";
  what = rest[keylen + 1..keylen + whatlen];
  "extract form data string";
  line = rest[(keylen + whatlen) + 1..length(rest)];
  if (what == "robots.txt")
    return this:return_html_to_BioSat(this.robots_txt, t, MOOlink);
  elseif ((anon = index(what, "anon")) && (anon < 4))
    "anonymous web call.";
    candidate = $no_one;
  elseif (stuff = match(key, "^%([^:]+%):%(.*%)"))
    "recognise user";
    userid = substitute("%1", stuff);
    password = substitute("%2", stuff);
    candidate = $string_utils:match_player(userid);
  else
    "authentication key missing, and not anonymous. request another attempt";
    candidate = $nothing;
  endif
  if (candidate == $no_one)
    if ((length(this.task_index) > this.anon_access_limits[1]) || (this.lag_meter.samples[this.lag_meter.sample_count] > this.anon_access_limits[2]))
      text = {tostr(player:namec(), " in ", $network.MOO_name, " (", what:name() || ctime(), ")"), "<B>SORRY!</B> There's too much load on this server at the moment, and anonymous connections are being restricted.  Please try again in a while."};
      return this:return_html_to_BioSat(text, t, MOOlink);
      "$http_handler.anon_access_limits is set to {max anonymous tasks, max server lag load}";
    endif
  elseif (!((is_player(candidate) && (typeof(candidate.password) == STR)) && $perm_utils:password_ok(candidate.password, password)))
    "authentication failed, request another attempt";
    return this:return_html_to_BioSat({}, t, MOOlink);
  endif
  player = candidate;
  "parse path string into {passwrd STR, webappcode STR, what STR, rest STR, search STR}";
  what = this:parse_line(what);
  "add web transaction info to task record";
  this:init_taskprop(what[2], player, {"http_version", "port_handler"}, {protocol, (caller == this) ? $login | caller});
  "call the verb that will determine the webapp, and do the real stuff";
  text = this:process(mode, @what[2..length(what)], line);
  "delete task from details list";
  if (ERR != typeof(newdetails = listdelete(this.task_details, (task = task_id()) in this.task_index)))
    this.task_details = newdetails;
    this.task_index = setremove(this.task_index, task);
  endif
else
  "ouch, we received a garbled transmission";
  text = {"<B>SORRY!</B> There's some server problem right now. Please report to <a href=\"mailto:Gustavo@bioinfo.weizmann.ac.il\">Gustavo</a>. Thanks!"};
endif
this:return_html_to_BioSat(text, t, MOOlink);
"Last modified Thu Jan 23 20:00:29 1997 IST by Gustavo (#2).";
.

@verb #115:"parse_line" this none this
@program #115:parse_line
"parse_line(path STR) -> {pass STR, code STR, what, rest STR, search STR}";
"Parses the path (HTTP method 'GET') into: pass, password; code, webcode; what, object; rest, the rest of the path specification except for; search, stuff after a question mark.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
"Extract PASSWORD";
cont = index(what, "/");
if (what && (what[1] == "?"))
  "a password presentation (domain:port/?password)";
  "if correct, leads to webapp list (or default), else leads to authentication";
  pass = what[2..length(what)];
  what = "";
elseif (!cont)
  "a  passworded path with no further arguments (domain:port/xxpassword)";
  "if correct, leads to webapp list (or default), else leads to authentication";
  if ((length(what) > 1) && (what[1] == "~"))
    "special case of a request for a user's home page";
    who = $string_utils:match_player(what[2..length(what)]);
    pass = "anon";
    what = tostr($web_geninfo:get_code(), "/", tonum(who), "/info");
  elseif (`what[1..2] ! E_RANGE => ""' && (!$string_utils:is_numeric(what[1..2])))
    "has a webapp code instead of a webpass field";
    pass = "anon";
    what = what;
  else
    pass = what[3..length(what)];
    what = "";
  endif
else
  "a passworded path with useful arguments (domain:port/xxpass/morestuff...)";
  if ($string_utils:is_numeric(what[1..2]) || (what[1..2] == "xx"))
    pass = what[3..cont - 1];
    "trim 'what' and continue";
    what = what[cont + 1..length(what)];
  else
    "is a 'webpass-less' URL so assign it to Anonymous";
    pass = "anon";
    "leave 'what' unchanged";
  endif
endif
"Extract SEARCH";
if (quest = index(what, "?"))
  search = what[quest + 1..length(what)];
  "trim off search string";
  what = what[1..quest - 1];
else
  search = "";
endif
"Extract CODE";
rest = code = "";
if (cont = index(what, "/"))
  "webcode specified (domain:port/xxpass/code/morestuff...)";
  "leads to call to the associated webapp";
  code = what[1..cont - 1];
  what = what[cont + 1..length(what)];
else
  "webcode is last arg in path (domain:port/xxpass/code)";
  "leads to call to the associated webapp";
  code = what;
  what = "";
endif
"Extract REST";
if (cont = index(what, "/"))
  "anything left in the path is 'rest'";
  rest = what[cont + 1..length(what)];
  what = what[1..cont - 1];
endif
return {pass, code, what, rest, $web_utils:substitute_escapes(search)};
"Last modified Sun Aug 25 09:33:57 1996 IDT by Gustavo (#2).";
.

@verb #115:"process" this none this x #95
@program #115:process
"process(method STR, webcode STR[, what OBJ[, rest STR[, search STR[, form STR]]]]) => LIST";
"Where 'method' should be either 'get' or 'post'; other fields with their usual meaning.";
"This verb takes the information that's been dissected from the URL";
"path, and determines if the user should get either the list of";
"webapps (no webcode specified and no default viewer set), the user's";
"default viewer (no webcode, but user has set default viewer in web";
"options), or the result of a well-defined webapp call (a webcode was";
"specified).  The appropriate verb on the webapp is called depending on";
"if the process is a standard http call (GET) or a form submission of";
"method 'POST'.";
"The returned value is a list of strings comprising the html document";
"to be returned to the user.";
"WIZARDLY to enable setting task perms to player";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || caller_perms().wizard))
  return E_PERM;
endif
method = args[1];
webcode = args[2];
title = body = stuff = {};
"";
"Determine if either a webapp was specified via webcode or the person has a default one";
webapps = $object_utils:descendants($webapp);
if (webcode == "gateway.html")
  "specifically wants the gateway page";
  "clear web cookie";
  if (webpass = $http_handler.webpass_handler:webpass_for(player))
    this:submit_taskprop("set-cookie", tostr("webpass=", webpass, "; path=/; expires=Thu, 01-Jan-1970 00:00:01 GMT"));
  endif
  return this:provide_identify();
elseif (webcode == this.code)
  "user specifically wants list of webapps";
  "need this here since the $http_handler is by default not available as a webapp";
  viewer = this;
elseif ((webcode && (i = webcode in $list_utils:map_prop(webapps, "code"))) && webapps[i]:available())
  "set 'viewer' to the appropriate webapp";
  viewer = webapps[i];
elseif (valid((0 == (viewer = $web_options:get(player.web_options, "viewer"))) ? viewer = $standard_webviewer | viewer) && (parent(viewer) == $webapp))
  "No webcode specified, but the user has a default webapp, so use that";
  "note that if they haven't set a viewer, $web_options returns zero and the $standard_viewer is used.";
  if ((viewer == $standard_webviewer) && (!(player in connected_players())))
    "person isn't connected, so make it the WebGhost Viewer";
    viewer = $anon_webviewer;
  endif
  "Set the webcode in the task details list";
  idx = task_id() in this.task_index;
  this.task_details[idx][2] = viewer.code;
else
  "The person hasn't selected a valid webapp, so present the list of available ones";
  viewer = this;
endif
"";
"if no object to focus on was specified in the path, set it to user's location";
if (((1 == index(args[3], "$")) && (length(args[3]) > 1)) && $recycler:valid(focus = #0.(args[3][2..length(args[3])])))
  "the focus object can be a #0-based pointer";
  args[3] = focus;
elseif (match(args[3], "^[0-9]+$"))
  args[3] = toobj(args[3]);
else
  args[3] = player.location;
endif
"";
"record total web usage; since Apr 19, 1995";
this.total_webcalls = this.total_webcalls + 1;
"finally, call the webapp";
set_task_perms(player);
stuff = viewer:("method_" + method)(player, @args[3..length(args)]);
"";
if (viewer in {$frame_manager, $std_vrml10viewer, @this.exempt_from_pads})
  "Don't add the extra header and footer info appropriate for things to be displayed as HTML pages by a web viewer";
  html = stuff;
else
  "Build the html page header and footer...";
  "link to the page this object generates";
  if (applinkdown = `$web_options:get(player.web_options, "applinkdown") ! E_TYPE')
    stdbodyhead = {"<A NAME=\"header\"></A>"};
    stdbodyfoot = (viewer != this) ? {tostr("<BR>Go to the list of <A HREF=\"&LOCAL_LINK;/", this:get_code(), "\">applications</A>.")} | {};
  else
    stdbodyhead = {"<A NAME=\"header\"></A>" + ((viewer != this) ? tostr("Go to the list of <A HREF=\"&LOCAL_LINK;/", this:get_code(), "\">applications</A>.<BR>") | "")};
    stdbodyfoot = {};
  endif
  if (((!(banner = $web_utils.page_banner)) || $http_handler:retrieve_taskprop("hide_banner")) || $web_options:get(player.web_options, "hidebanner"))
    stdbodyhead = {@stdbodyhead};
  else
    stdbodyhead = {@stdbodyhead, banner};
  endif
  html = $web_utils:format_webapp_result_to_html({stdbodyhead, stdbodyfoot}, stuff);
endif
return html;
"Last modified Thu Jan  2 18:27:43 1997 IST by Gustavo (#2).";
.

@verb #115:"server_started" this none this rx
@program #115:server_started
"Clean out the web task details lists";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != #0)
  return E_PERM;
endif
this.task_index = {};
this.task_details = {};
"Last modified Sun Jul 30 16:58:54 1995 IDT by EricM (#3264).";
.

@verb #115:"wait_for_output" this none this rx #95
@program #115:wait_for_output
"wait_for_output(try NUM, conn OBJ) -> none";
"Wait for the output buffer to empty. Close the connection to 'conn'";
"when either buffer is empty or 'try' seconds have elapsed.";
"WIZARDLY to enable boot_player";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
try_ = args[1];
conn = args[2];
while (buffered_output_length(conn) && try_)
  try_ = try_ - 1;
  suspend(1);
endwhile
boot_player(conn);
"Last modified Sat Apr 27 18:26:41 1996 IDT by Gustavo (#2).";
.

@verb #115:"submit_taskprop" this none this rx
@program #115:submit_taskprop
"submit_taskprop(propname STR, propvalue <any type>) -> 0 or E_INVARG";
"Add a property to the web transaction's task stack, with a name";
"propname and a value propvalue.  Has no effect if there is no stack";
"record for the calling task";
"Inserts the next prop at the head of the submitted props";
"These taskprop values can only be set with wiz-perms: set-cookie";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
{propname, propvalue} = args;
restricted = {"set-cookie"};
if (idx = task_id() in this.task_index)
  if ((propname in restricted) && (!(caller_perms().wizard || (caller == this))))
    return E_PERM;
  endif
  tasklist = this.task_details[idx];
  this.task_details[idx][4] = {propname, @this.task_details[idx][4]};
  this.task_details[idx][5] = {propvalue, @this.task_details[idx][5]};
endif
"Last modified Wed Aug 21 17:23:30 1996 IDT by EricM (#3264).";
.

@verb #115:"retrieve_taskprop" this none this rx
@program #115:retrieve_taskprop
"retrieve_taskprop(propname STR, all BOOL)->E_NONE or <any type>";
"Retrieves the value of the web transaction stack property named propname.";
"If args[2] is present and true, returns all pushed task properties with";
"that name, else only the last one pushed";
"Some examples are: ";
"  headers - the list of header strings (wiz access only)";
"  hide_banner - supress the banner display";
"  bodytag_attributes - insert this text into the <BODY> tag when building the page";
"  http_version - the version in X.Y format (eg. 1.0)";
"  connection_name - the connection name's domain or i.p. (wiz access only)";
"  port_handler - the object that called $http_handler and is reading the MOO port (either $login or an MPL port object)";
"  cache_OK - indicates that this page may be cached by proxy servers (ie. it doesn't change)";
"  Content-Type - the value to be used in the returned page's header ('text/html' is default)";
"  set-cookie - used to add a web cookie to the generated page's header lines.  Only wiz-perms can set it";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
propname = args[1];
restricted = {"headers", "connection_name", "set-cookie"};
if (!(task = task_id() in this.task_index))
  return;
elseif ((propname in restricted) && (!(caller_perms().wizard || (caller == this))))
  "only wiz-perms can retrieve the raw header or connection source";
  return E_PERM;
endif
if (!args[2])
  return (prop = propname in this.task_details[task][4]) ? this.task_details[task][5][prop] | E_NONE;
endif
values = {};
propnames = this.task_details[task][4];
propvals = this.task_details[task][5];
while (idx = propname in propnames)
  values = {@values, propvals[idx]};
  propnames = propnames[idx + 1..l = length(propnames)];
  propvals = propvals[idx + 1..l];
endwhile
return values || E_NONE;
"Last modified Wed Aug 21 17:20:39 1996 IDT by EricM (#3264).";
.

@verb #115:"provide_identify" this none this rx #95
@program #115:provide_identify
"provide_identify(who OBJ) -> none";
"Generates the MOO's WEB GATEWAY PAGE, which should have instructions";
"on how to connect via the web system, and appropriate fields for";
"appropriate authentication entries";
"If FUP is installed, uses the text of 'web/gateway.html' or";
"'misc/gateway.html' otherwise uses $http_handler.gateway_html text";
"WIZARDLY to use the FUP utilities directly";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
if (file = `call_function("fileread", "web", "gateway.html") ! E_INVARG' || `call_function("fileread", "misc", "gateway.html") ! E_INVARG')
  "FUP system installed";
  ident = file;
elseif (typeof(this.gateway_html) == LIST)
  "Use text from $http_handler.gateway_html";
  ident = this.gateway_html;
else
  ident = {"<H2>SORRY!</H2> This MOO doesn't appear to have a proper gateway page set up."};
endif
return ident;
"Last modified Mon Aug 26 17:37:43 1996 IDT by EricM (#3264).";
.

@verb #115:"init_taskprop" this none this rx
@program #115:init_taskprop
"init_taskprop(webcode STR, player OBJ, propnames LIST, propvals LIST)";
"Set up the task property list for this web transaction";
"this.task_index is just a list of task ids, but is indexed to this.task_detail";
"this.task details has the structure: {task_id, webcode used in path,";
"initial perms of web task, list {of names of additional task";
"properties}, {list of values of additional task properties}}";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
webcode = args[1];
who = valid(args[2]) ? args[2] | $no_one;
propnames = (typeof(args[3]) == LIST) ? args[3] | ({args[3]} || {});
propvals = (typeof(args[4]) == LIST) ? args[4] | ({args[4]} || {});
if (length(propnames) != length(propvals))
  $error:raise(E_INVARG);
  "never allow the taskprop indexing to get screwed up";
endif
this.task_index = {task = task_id(), @this.task_index};
this.task_details = {{task, webcode, who, propnames, propvals}, @this.task_details};
"Last modified Sat Sep 30 07:02:20 1995 IST by EricM (#3264).";
.

@verb #115:"make_headerlist" this none this rx
@program #115:make_headerlist
"make_headers() -> HTTP header lines LIST";
"Returns the HTTP header line list for prepending onto the returned text";
"Note that HTTP/0.9 doesn't support this and such requests should only get HTML text";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || caller_perms().wizard))
  return E_PERM;
endif
headers = {};
headers = {@headers, tostr("Server: BioWeb/", $http_handler.version)};
if (!(mimespec = $http_handler:retrieve_taskprop("Content-Type")))
  "assume ordinary HTML file if nobody said otherwise";
  mimespec = "text/html";
endif
headers = {@headers, "Content-Type: " + mimespec};
if (!$http_handler:retrieve_taskprop("cache_OK"))
  headers = {@headers, "Pragma: no-cache"};
endif
if (!`"no_cookies" in player.web_options ! ANY')
  "insert a cookie to verify browser can handle them";
  headers = {@headers, "Set-Cookie: cookies-ok=true; path=/"};
  "then comes a webpass cookie, if any needs to be set";
  if (cookie = $http_handler:retrieve_taskprop("set-cookie"))
    headers = {@headers, "Set-Cookie: " + cookie};
  endif
endif
return {@headers, ""};
"Last modified Thu Feb 27 00:52:28 1997 IST by EricM (#3264).";
.

@verb #115:"get_code" this none this rx
@program #115:get_code
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return pass(@args);
"Last modified Wed Sep 27 05:02:28 1995 IST by EricM (#3264).";
.

@verb #115:"tell_quick_and_die" this none this rx #95
@program #115:tell_quick_and_die
"tell_quick_and_die(who OBJ, text LIST} -> none";
"Sends HTML document to 'who' converting &LOCAL_LINK; appropriately";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
who = player;
if (typeof(args[1]) == OBJ)
  player = args[1];
endif
text = args[2];
pass = {@args, ""}[3];
port = ((handler = this:retrieve_taskprop("port_handler")) == $login) ? $network.port | handler.handles_port;
link = tostr("http://", ("use_ip" in who.web_options) ? $network.numeric_address | $network.site, ":", port, "/", random(90) + 9, pass);
for line in (text)
  ((seconds_left() < 2) || (ticks_left() < 4000)) ? suspend(1) | 0;
  while (buffered_output_length(player) > 4000)
    suspend(1);
  endwhile
  notify(player, strsub(line, "&LOCAL_LINK;", link));
endfor
"delete task from details list";
this:delete_webtask();
"wait for output to end, then kill the connection";
this:wait_for_output(30, player);
"Last modified Sat Aug 17 03:53:02 1996 IDT by EricM (#3264).";
.

@verb #115:"handle_http10" this none this rx #95
@program #115:handle_http10
"handle_http10(conn OBJ, method STR, URL STR, http_version STR) -> result LIST";
"Handles HTTP/1.0 calls that are coming in from non-telnet ports via multiple port listen";
"Or the standard telnet port, but without web authentication";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
port_handler = caller;
if (!((port_handler in this.port_handlers) || caller_perms().wizard))
  return E_PERM;
endif
{conn, method, URL, http_version} = args;
"Read the header lines, if any, and store them to the task property list";
headers = {};
while (line = read(conn))
  headers = {@headers, line};
endwhile
"Read the entity body if it's a method POST request";
if (method == "POST")
  line = read(conn);
else
  line = "";
endif
authentication = 0;
if ((URL in {"", "/"}) && `port_handler.authentication_method != "web-authentication" ! E_PROPNF')
  if (line)
    "if it's got a form attached and no URL, it's probably an authentication request";
    authentication = 1;
    "do special pre-processing of URL based on authentication info";
    {URL, headers, line} = this:preprocess_url(URL, headers, line);
  else
    return this:tell_quick_and_die(conn, {@(port_handler == $login) ? {} | {"HTTP/1.0 200 OK"}, @this:make_headerlist(), @this:provide_identify()});
    "user called with no request path, so return the MOO's web gateway page";
  endif
elseif (URL in {"robots.txt", "/robots.txt"})
  "tell web spiders to scat";
  headerlist = {@(port_handler == $login) ? {} | {"HTTP/1.0 200 OK"}, "Content-type: text/plain", ""};
  return this:tell_quick_and_die(conn, {@headerlist, @this.robots_txt});
endif
{pass, webcode, what, rest, search} = this:parse_line(URL);
set_cookie = "";
if (`port_handler.authentication_method == "web-authentication" ! E_PROPNF')
  if (!valid(candidate = this:web_authenticate(conn, headers, port_handler)))
    return;
  endif
  player = candidate;
elseif (`port_handler.authentication_method == "cookies" ! E_PROPNF => !this.login_is_http09')
  "use web cookie protocol";
  "Note that if connection is through $login it won't have an 'authentication_method' property, and web cookie authentication is then assumed unless $login is specifically designated as an HTTP/0.9 port (cookies aren't supported by that version of the protocol).";
  {candidate, pass, ?set_cookie = ""} = this:cookie_authenticate(conn, pass, headers, port_handler, line, URL);
  if (!valid(candidate))
    return;
  endif
  player = candidate;
else
  player = this.webpass_handler:check_candidate(pass);
  "note: object 'player' doesn't have to have player bit set :)";
  if ((typeof(player) != OBJ) || ((player.wizard && this.wizwebpass_disallowed) && (!(port_handler in this.auth_ports))))
    return this:tell_quick_and_die(conn, {@(port_handler == $login) ? {} | {"HTTP/1.0 200 OK"}, @this:make_headerlist(), @this.password_failed_text});
    "user doesn't have a registered webpass, gave a bad one, or is a wizard. Send the MOO gateway web page";
    "force wizen to use the more secure authentication system, if $http_handler.wizwebpass_disallowed";
  endif
endif
if ((player == $no_one) && ((length(this.task_index) > this.anon_access_limits[1]) || (this.lag_meter.samples[this.lag_meter.sample_count] > this.anon_access_limits[2])))
  this:tell_quick_and_die(conn, {@(port_handler == $login) ? {} | {"HTTP/1.0 200 OK"}, @this:make_headerlist(), @this.too_much_load_text});
  return;
  "note: if you've added $no_one (Everyman, usually #40) to the webpass handler with the webpass 'anon' or 'anonymous' this enables anonymous connections through the HTTP/0.9 port.";
  "$http_handler.anon_access_limits is set to {max anonymous tasks, max server lag load}";
  "The latter uses the standard sort of lag meter found in most MOOs.";
endif
if (authentication && line)
  "if this transaction is an authentication, remove the password from the associated form, if any";
  if (index(line, "password") == 1)
    pword_match = match(line, "%(.*%)%(password=[^&]*%)&?%(.*%)");
  else
    pword_match = match(line, "%(.*%)%(&password=[^&]*%)%(.*%)");
  endif
  if (pword_match)
    line = strsub(substitute("%1%3", pword_match), "&&", "&");
  endif
endif
"tell the user an original web access from the web gateway page has occurred";
if (((pass || set_cookie) && (!what)) && (!webcode))
  player:tell("You open a web window into ", $network.MOO_name, ".");
endif
"add web transaction info to task record";
this:init_taskprop(webcode, player, {"headers", "http_version", "connection_name", "port_handler", "set-cookie"}, {headers, http_version, connection_name(conn), (port_handler == this) ? $login | port_handler, set_cookie});
task = task_id();
"";
fork wait_task (this.output_timeout)
  "this will run if the web task dies; it cleans up after it, and sends an apology to the user";
  this:webtask_timedout(conn, task);
endfork
"";
"FINALLY, do the next major call";
text = this:process(method, webcode, what, rest, search, line);
"";
"kill the backup fork";
kill_task(wait_task);
"add headers";
headerlist = this:make_headerlist();
"MOO's main telnet port is forced to already include a status line in welcome message";
status = (port_handler == $login) ? {} | {"HTTP/1.0 200 OK"};
if (text)
  "send out the web text over the open connection, and close it";
  text = {@status, @headerlist, @text};
  this:tell_quick_and_die(conn, text, pass);
else
  "no text returned, so send MOO web gateway page and close the connection";
  this:tell_quick_and_die(conn, {@status, @headerlist, @this:provide_identify()});
endif
"Last modified Sun Oct 13 15:47:28 1996 IST by EricM (#3264).";
.

@verb #115:"clear_taskprop_list" this none this rx #95
@program #115:clear_taskprop_list
"clear_taskprop_list() -> none";
"Does what it says";
"Call this if for some reason the taskprop list is a mess";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!caller_perms().wizard)
  return E_PERM;
endif
this.task_details = {};
this.task_index = {};
"Last modified Tue Feb 20 13:28:45 1996 IST by EricM (#3264).";
.

@verb #115:"webtask_cleanup" this none this rx
@program #115:webtask_cleanup
"webtask_cleanup() -> cleaned up a dead task BOOL";
"Does minor cleanup after a web task";
"make sure task prop values aren't corrupt";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((typeof(this.task_index) != LIST) || (typeof(this.task_details) != LIST))
  this.task_index = {};
  this.task_details = {};
endif
"hunt randomly for a dead task and clean it up";
if ((t_index = this.task_index) && (!$code_utils:task_valid(idx = t_index[random(length(t_index))])))
  this:delete_webtask(idx);
  return 1;
endif
"Last modified Wed Mar 20 19:31:39 1996 IDT by EricM (#3264).";
.

@verb #115:"delete_webtask" this none this rx
@program #115:delete_webtask
"delete_webtask(task NUM) -> failed BOOL";
"Delete the task as specified by task_id.  Return true if task not found";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || caller_perms().wizard))
  return E_PERM;
endif
task = {@args, task_id()}[1];
if (idx = task in this.task_index)
  this.task_details = listdelete(this.task_details, idx);
  this.task_index = listdelete(this.task_index, idx);
  this:webtask_cleanup();
  return;
endif
return 1;
"Last modified Fri Aug 16 22:18:36 1996 IDT by EricM (#3264).";
.

@verb #115:"webtask_timedout" this none this rx #95
@program #115:webtask_timedout
"webtask_timedout(conn OBJ, task NUM) -> none";
"Kills an open web task that's timed out, presumably due to a traceback somewhere";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
conn = args[1];
task = args[2];
if (idle_seconds(conn))
  notify(conn, "<P><P>Output timed out. If you can, please report your current location to an administrator. Thanks!<P>");
  boot_player(conn);
  "delete task from details list";
  this:delete_webtask(task);
endif
"Last modified Mon Dec 16 17:39:28 1996 IST by Gustavo (#2).";
.

@verb #115:"user_autoconnected" this none this rx #95
@program #115:user_autoconnected
"user_autoconnected(who {OBJ}, port_handler NUM [,options LIST]) -> none";
"Called when a user connects with a preapproved JavaClient password";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
{who, port_handler, ?options = {}} = args;
if (!(caller_perms().wizard || (caller in {$login, @this.port_handlers})))
  return E_PERM;
elseif (!(valid(who) && $object_utils:isa(who, $player)))
  return E_INVARG;
endif
"initialize various settings";
for option in (options)
  if (typeof(result = $web_options:set(who.web_options, option[1], option[2])) == LIST)
    who.web_options = result;
  else
    who:tell("Web form error: ", tostr(result));
  endif
endfor
"note the port being used for web transactions";
who:set_web_setting("webport_handler", port_handler);
"send initial web page display instruction";
if (!valid(handler = $web_options:get(who.web_options, "telnet_applet") && $http_handler.java_clients))
  "the first java client in the list serves as the default one";
  handler = $http_handler.java_clients[1];
endif
if ((typeof(handler) == OBJ) && $object_utils:isa(handler, $jclient_handler))
  handler:user_autoconnected(who, port_handler);
endif
"Last modified Wed Oct  9 17:34:25 1996 IST by EricM (#3264).";
.

@verb #115:"return_html_to_BioSat" this none this rx #95
@program #115:return_html_to_BioSat
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
text = args[1];
t = args[2];
MOOlink = args[3];
"send the html doc, w/lines prefixed by the transaction number";
MOOlink:send("web", tostr(t, " ", length(text) || "-1"));
for line in [1..length(text)]
  ((seconds_left() < 2) || (ticks_left() < 4000)) ? suspend(1) | 0;
  MOOlink:send("web", tostr(t, " ", text[line]));
endfor
this:webtask_cleanup();
"Last modified Wed Apr 24 13:57:06 1996 IDT by Gustavo (#2).";
.

@verb #115:"init_for_core" this none this rx #95
@program #115:init_for_core
"init_for_core() -> none";
"set properties to default values for core extraction";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || caller_perms().wizard))
  return E_PERM;
endif
this.lag_meter = valid($lag_meter) ? $lag_meter | #-1;
this.task_details = this.task_index = {};
this.total_webcalls = 0;
this.webpass_handler = #-1;
this.gateway_html = {"This is the text in $http_handler.identify_html.<P>", " If you're reading this, then the FUP system is not working and the administrators of this MOO should either fix it or add a real MOO web gateway page here.<P>", " A typical web gateway page will include at least something like the following:<P>", "<H3>Welcome to our little hovel!</H3>", "Please enter the name and password of your character at our MOO, or enter the name \"anonymous\" if you don't have a character here.<P>", "<FORM METHOD=\"POST\" ACTION=\"/\">", "<DL>", "<DT><INPUT TYPE=\"TEXT\" NAME=\"user_name\"> <B>Your character's name</B><P>", " <DT><INPUT TYPE=\"PASSWORD\" NAME=\"password\"> <B>Your character's password</B><P>", "<DT><INPUT TYPE=\"SUBMIT\" VALUE=\"open a web window into the MOO\">", "</DL>", "</FORM>"};
this.wizwebpass_disallowed = 0;
this.exempt_from_pads = {};
this.anon_access_limits = {10, 10};
this.java_clients = {};
this.javaclient_codebase = "/java/";
this.login_is_http09 = 0;
this.port_handlers = {};
return pass(@args);
"Last modified Wed Dec 25 20:59:40 1996 IST by EricM (#3264).";
.

@verb #115:"web_authenticate" this none this rx #95
@program #115:web_authenticate
"web_authenticate(conn {OBJ}, headers {LIST}, port_handler {OBJ}) -> candidate {OBJ}";
"Check headers for web authentication information, and return objnum";
"of character whose name and password matches what's found.  Return";
"request for web-authentication if info is missing or bad.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
{conn, headers, port_handler} = args;
if (caller != this)
  return E_PERM;
endif
while (headers && (!(index(authline = headers[1], "Authorization:") == 1)))
  headers = listdelete(headers, 1);
endwhile
if (headers)
  authkey = $web_utils:mmdecode($string_utils:explode(authline, " ")[$]);
  {userid, ?pword = ""} = $string_utils:explode(authkey, ":");
  candidate = $string_utils:match_player(userid);
  if (userid in {"guest", "anonymous"})
    return $no_one;
  elseif (valid(candidate) && (typeof(candidate.password) != STR))
    "OK, let people with password set to 0 come in...";
    "this:tell_quick_and_die(conn, {\"HTTP/1.0 403 Sorry, you can't use this system if you have set up a challenge-response password.\", \"\"});";
    "return $nothing;";
    "------";
    return candidate;
  elseif (((userid && pword) && valid(candidate)) && $perm_utils:password_ok(candidate.password, pword))
    return candidate;
  endif
endif
this:tell_quick_and_die(conn, {"HTTP/1.0 401 Unauthorized Please enter a valid character name and password.", tostr("WWW-Authenticate: Basic realm=\"", $network.MOO_name, "\""), ""});
"shouldn't ever get here";
return $nothing;
"Last modified Thu Aug 22 19:59:11 1996 IDT by EricM (#3264).";
.

@verb #115:"cookie_authenticate" this none this rxd #95
@program #115:cookie_authenticate
"cookie_authenticate(who {OBJ}, url_pass {STR}, headers {LIST}, port_handler {OBJ}, form {STR}, URL {STR}) -> {user {OBJ}, URL_pass {STR}, set-cookie {STR}}";
"Returns user objnum if a valid cookie_webpass is found, else displays";
"an entry form for user name and password then quits";
"Also returns a URL-embedded password to use, if any, the URL to use (may be the same as the original), and a cookie value if a new cookie is to be set.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
{who, url_pass, headers, port_handler, ?form = {}, ?URL = ""} = args;
cookie_webpass = "";
cookies_ok = 0;
if (url_pass && (url_pass in {"anon", "anonymous"}))
  "URL-embeded anon webpass overrides all others";
  return {$no_one, "anon", ""};
elseif ((url_pass && `valid(candidate = $http_handler.webpass_handler:check_candidate(url_pass)) ! E_TYPE') && ("no_cookies" in candidate.web_options))
  "person specifically wants URL-embedded authentication";
  return {candidate, url_pass, ""};
endif
"scan headers for cookie_webpass, from end of list";
while (headers && (!(cookie_webpass && cookies_ok)))
  if (1 == index(headers[$], "Cookie:"))
    if ((!cookie_webpass) && (idx = index(headers[$], "webpass=")))
      "got the cookie_webpass";
      cookie_webpass = substitute("%1", match(headers[$][idx..$], "webpass=%(%w*%)"));
      cookies_ok = 1;
    endif
    if ((!cookies_ok) && (cookies_ok = index(headers[$], "cookies-ok=")))
      "browser handles web cookies";
      cookies_ok = 1;
    endif
    headers = listdelete(headers, length(headers));
  else
    headers = listdelete(headers, length(headers));
  endif
endwhile
"have to put this after the search, since some browsers handle cookies oddly";
if ((form && (URL in {"", "/"})) || (URL[4..$] == tostr($frame_manager.code, "/0/frameset")))
  "person is reauthenticating from the gateway page, so clear old info";
  url_pass = cookie_webpass = "";
elseif (URL[1] == "?")
  "reauthenticating with URL-embedded webpass";
  cookie_webpass = "";
elseif (((!cookies_ok) && url_pass) && `valid(candidate = $http_handler.webpass_handler:check_candidate(url_pass)) ! E_TYPE')
  return {candidate, url_pass, ""};
  "probably a person whose browser can't do cookies";
endif
if (cookie_webpass)
  if (cookie_webpass == "anon")
    return {$no_one, "", ""};
  endif
  candidate = $http_handler.webpass_handler:check_candidate(cookie_webpass);
  if (!((typeof(candidate) == OBJ) && valid(candidate)))
    cookie_killer = tostr("Set-Cookie: webpass=", cookie_webpass, "; path=/; expires=Thu, 01-Jan-1970 00:00:01 GMT");
    "insert cookie_killer before the terminal empty line";
    this:tell_quick_and_die(who, {@(port_handler == $login) ? {} | {"HTTP/1.0 200 OK"}, @listinsert(newheads = this:make_headerlist(), cookie_killer, length(newheads)), @this.password_failed_text});
    return {$nothing, "", ""};
  endif
  return {candidate, "", ""};
endif
"no webpass cookie found";
if (url_pass && cookies_ok)
  "Odd. Cookies ok but got no cookie webpass. Try the cookie again";
  "This section used if person wants i.p. since the old cookie will be lost when the switch from domain name to i.p. is done.";
  if (`valid(candidate = $http_handler.webpass_handler:check_candidate(url_pass)) ! E_TYPE')
    cookie = tostr("webpass=", url_pass, "; path=/");
    return {candidate, "", cookie};
  endif
  "oops. got a pass but it's bad";
  this:tell_quick_and_die(who, {@(port_handler == $login) ? {} | {"HTTP/1.0 200 OK"}, @this:make_headerlist(), @this:provide_identify()});
elseif (!form)
  this:tell_quick_and_die(who, {@(port_handler == $login) ? {} | {"HTTP/1.0 200 OK"}, @this:make_headerlist(), @this:provide_identify()});
else
  {fields, values} = $web_utils:parse_form(form, 2);
  if (!((i = "user_name" in fields) && (username = values[i])))
    this:tell_quick_and_die(who, {@(port_handler == $login) ? {} | {"HTTP/1.0 200 OK"}, @this:make_headerlist(), @this.password_failed_text});
  elseif (username in {"guest", "anonymous"})
    if (((password = `values["password" in fields] ! E_RANGE') && `valid(candidate = this.webpass_handler:check_candidate(password)) ! E_TYPE') && $object_utils:isa(candidate, $guest))
      "a guest entered a valid webpass but not their correct guest name;  forgive them";
      return {candidate, cookies_ok ? "" | password, tostr("webpass=", password, "; path=/")};
    else
      return {$no_one, "anon", ""};
    endif
  elseif (!valid(candidate = $string_utils:match_player(username)))
    this:tell_quick_and_die(who, {@(port_handler == $login) ? {} | {"HTTP/1.0 200 OK"}, @this:make_headerlist(), @this.password_failed_text});
  elseif ($object_utils:isa(candidate, $guest))
    if (((i = "password" in fields) && (password = values[i])) && (password == $http_handler.webpass_handler:webpass_for(candidate)))
      cookie = tostr("webpass=", password, "; path=/");
      return {candidate, cookies_ok ? "" | password, cookie};
    endif
    this:tell_quick_and_die(who, {@(port_handler == $login) ? {} | {"HTTP/1.0 200 OK"}, @this:make_headerlist(), @this.password_failed_text});
  elseif (candidate == $no_one)
    return {candidate, "anon", ""};
  elseif (typeof(candidate.password) != STR)
    "this:tell_quick_and_die(who, {@port_handler == $login ? {} | {\"HTTP/1.0 200 OK\"}, @this:make_headerlist(), \"<H2>Sorry!</H2>\", \"You can't use this system if you have a challenge-response password set.\"});";
    "-------------------------------";
    "OK Big ugly hack, just take the next bloack and duplicating....";
    "Rather than munging the logic in that next block there...";
    "-------------------------------";
    "Here we go:  ";
    "person is now authenticated from gateway form";
    cookie_webpass = $http_handler.webpass_handler:set_password(candidate);
    if ("no_cookies" in candidate.web_options)
      "person specifically wants URL-embedded authentication";
      return {candidate, tostr(cookie_webpass), ""};
    endif
    "send authentication as cookie in header lines";
    domain = tostr(("use_ip" in candidate.web_options) ? $network.numeric_address | $network.site, ":", `port_handler.handles_port ! E_PROPNF, E_TYPE => $network.port');
    "if person wants i.p. instead of domain name, they'll need the webpass in the URL for one more round";
    uses_ip = ("use_ip" in candidate.web_options) ? tostr(cookie_webpass) | "";
    cookie = tostr("webpass=", cookie_webpass, "; path=/");
    return {candidate, cookies_ok ? uses_ip | tostr(cookie_webpass), cookie};
    "--------------------------------------------";
  elseif (((i = "password" in fields) && (password = values[i])) && $perm_utils:password_ok(candidate.password, password))
    "person is now authenticated from gateway form";
    cookie_webpass = $http_handler.webpass_handler:set_password(candidate);
    if ("no_cookies" in candidate.web_options)
      "person specifically wants URL-embedded authentication";
      return {candidate, tostr(cookie_webpass), ""};
    endif
    "send authentication as cookie in header lines";
    domain = tostr(("use_ip" in candidate.web_options) ? $network.numeric_address | $network.site, ":", `port_handler.handles_port ! E_PROPNF, E_TYPE => $network.port');
    "if person wants i.p. instead of domain name, they'll need the webpass in the URL for one more round";
    uses_ip = ("use_ip" in candidate.web_options) ? tostr(cookie_webpass) | "";
    cookie = tostr("webpass=", cookie_webpass, "; path=/");
    return {candidate, cookies_ok ? uses_ip | tostr(cookie_webpass), cookie};
  else
    this:tell_quick_and_die(who, {@(port_handler == $login) ? {} | {"HTTP/1.0 200 OK"}, @this:make_headerlist(), @this.password_failed_text});
  endif
endif
return {$nothing, "", ""};
"Last modified Thu Feb 27 01:11:41 1997 IST by EricM (#3264).";
.

@verb #115:"preprocess_url" this none this
@program #115:preprocess_url
"preprocess_url(url STR, headers LIST, form STR) -> new_url STR";
"perform URL substitutions based on info in the authentication form, if needed.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
{url, headers, form} = args;
if (index(form, "integrated_web_interface="))
  "form's SUBMIT button selected integrated web interface";
  url = tostr(9 + random(90), "/", $frame_manager:get_code(), "/0/frameset");
endif
return {url, headers, form};
"Last modified Tue Oct  8 16:22:24 1996 IST by EricM (#3264).";
.

@verb #115:"user_disconnected user_client_disconnected" this none this rxd #95
@program #115:user_disconnected
"user_disconnected([who OBJ]) -> none";
"user disconnected, so reset any relevent web system properties";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
{?who = caller} = args;
if (!$perm_utils:controls(caller_perms(), who))
  return E_PERM;
elseif (!(valid(who) && is_player(who)))
  return E_INVARG;
endif
this.webpass_handler:user_disconnected(who);
try
  who.web_options = $web_options:set(who.web_options, "telnet_applet", 0);
except (E_PROPNF)
  "'who' isn't a $player, probably";
endtry
"Last modified Tue Oct  8 21:55:28 1996 IST by EricM (#3264).";
.

"***finished***
