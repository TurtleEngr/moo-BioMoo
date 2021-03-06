$Header: /repo/public.cvs/app/BioGate/BioMooCore/core111.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #111 with create
@create $webapp named Frame Manager:Frame Manager,frame_mgr
@prop #111."bad_form_txt" {} r
;;#111.("bad_form_txt") = {"<HTML><TITLE>Bad web connect form</TITLE><BODY><H2>Sorry!</H2>The form you are trying to use to connect seems to be broken or misformed. Please let the appropriate people know.</BODY></HTML>"}
@prop #111."bad_values_txt" {} r
;;#111.("bad_values_txt") = {"<HTML><TITLE>Bad form values</TITLE>", "<BODY><H2>Sorry!</H2>One or more of the values you entered is not valid. Please back up, check your values, and resubmit the form.</BODY><HTML>"}
@prop #111."updated_webframes" {} r
;;#111.("updated_webframes") = {{2072718947}, {{""}}}
;;#111.("code") = "frame_mgr"
;;#111.("aliases") = {"Frame Manager", "frame_mgr"}
;;#111.("object_size") = {13328, 937987203}

@verb #111:"available" this none this
@program #111:available
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return $web_utils:get_webcode() == this:get_code();
"return true if this is NOT a request for the list of webapps";
"Last modified Mon Apr  1 10:17:55 1996 IDT by EricM (#3264).";
.

@verb #111:"get_jclient_html" this none this rx
@program #111:get_jclient_html
"get_jclient_html(what STR, search STR) -> html doc";
"Figures which client handler is being used and calls it to retrieve the";
"HTML file containing an <APPLET> section to invoke the client";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
client = args[1];
form = args[2];
form = $web_utils:parse_form(form, 2);
fields = form[1];
values = form[2];
username = (i = "user_name" in fields) ? values[i] | "";
password = (i = "password" in fields) ? values[i] | "";
if ((!username) || (!password))
  if (username in {"guest", "anonymous", ""})
    "use the password they gave, else it's blank";
    username = "guest";
    password = i ? password | "";
  elseif (username && (!password))
    "Only `guest' or `anonymous' are allowed to have user names but no passwords";
    "bad username or password, so don't try to connect";
    return this.bad_values_txt;
  endif
endif
if (!valid(client))
  client = (i = "client" in fields) ? values[i] | (tostr(tonum($http_handler.java_clients[1])) || "");
  client = ($string_utils:is_numeric(client) && valid(client = toobj(client))) || #-1;
endif
if (!(client in $http_handler.java_clients))
  "the form didn't specify a valid java client handler";
  return this.bad_form_txt;
endif
if (has_pword = "password" in fields)
  "replace password with dummy";
  dummy_pword = tostr($string_utils.alphabet[random(26)], 90000000 + random(410065408));
  values[has_pword] = dummy_pword;
endif
"get an HTML page from the client handler";
text = client:make_applet_html(fields, values);
"put the real password back in";
if (has_pword)
  for i in [1..length(text)]
    text[i] = strsub(text[i], dummy_pword, password);
  endfor
endif
return text;
"Last modified Tue Aug 27 16:32:22 1996 IDT by EricM (#3264).";
.

@verb #111:"method_get method_post" this none this
@program #111:method_get
"method_get(who, what OBJ, rest STR, search STR, line STR) -> html doc";
"Figure what sort of frame management-related command is being invoked and do it";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != $http_handler)
  return E_PERM;
endif
who = args[1];
what = args[2];
rest = command = args[3];
search = args[4];
line = args[5];
"-- extract command name";
if (idx = index(rest, "/"))
  command = rest[1..idx - 1];
  rest = strsub(rest, command + "/", "");
endif
"-- fulfill the appropriate command";
if (command == "frameset")
  return this:make_frameset(line);
elseif (command == "javaclient")
  "transaction is a request for an HTML doc with a Java client <APPLET> call";
  return this:get_jclient_html(what, search);
elseif (command == "preload")
  preload = what:preload_page();
  return (typeof(preload) == LIST) ? preload | {tostr("<B>Sorry</B><P> This client's in-MOO handler seems to be broken (it's preload_page verb is not returning a LIST).  It is owned by ", what.owner, ".")};
endif
"-- unrecognized command";
return this.bad_form_text;
"Last modified Fri Sep 27 03:11:24 1996 IST by EricM (#3264).";
.

@verb #111:"make_frameset" this none this rxd #95
@program #111:make_frameset
"make_frameset(form STR) -> html doc LIST";
"Checks the submitted web form for valid user name and password information";
"Creates an HTML doc with appropriate <FRAMESET> and <FRAME> tags to set up page";
"Includes a URL for the opening of a Java-based client in the interaction_frame frame";
"Recognizes the fields echo, MCP_on, width and height.";
"Passes the values (appropriately changed for password) to the java client URL-encoded as a 'search' string";
"If `player' is set to $no_one, then guest access is created.";
"Otherwise, authentication is assumed to have been performed by the";
"$http_handler, and the value of `player' is the person issuing the";
"transaction.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
endif
{fields, values} = $web_utils:parse_form(form = args[1], 2);
bad_form = this.bad_form_txt;
bad_values = this.bad_values_txt;
if (!((i = "client" in fields) && (client = values[i])))
  return bad_form;
elseif (!($string_utils:is_numeric(client) && (toobj(client) in $http_handler.java_clients)))
  return bad_form;
endif
"find web option settings, if any";
"note that these have to be set AFTER login, so they can be applied to guests too";
options = {};
if ((i = "embedVRML" in fields) && (embedVRML = values[i]))
  options = {@options, {"embedVRML", 1}};
else
  options = {@options, {"embedVRML", 0}};
endif
port = `$http_handler:retrieve_taskprop("port_handler").handles_port ! E_PROPNF, E_TYPE => $network.port';
if (player == $no_one)
  "transaction is for guest access";
  username = "guest";
  who = $guest;
  password = $login:accept_preapproval(who, options);
else
  "transaction has been authenticated";
  who = player;
  username = who.name;
  password = $login:accept_preapproval(who, options);
endif
"tack the temporary password onto the form data for the java applet to use";
form = tostr("password=", password, "&", form);
"Don't force 'Pragma: nocache' since the frameset page is pretty stable";
$http_handler:submit_taskprop("cache_OK", 1);
if (toobj(client):float_client_frame(who, form))
  "client in independent frame, so minimize applet frame";
  interaction_frame_height = "1%";
else
  "Use applet box height to estimate proper frame height";
  interaction_frame_height = ((i = "interaction_frame_height" in fields) && $string_utils:is_numeric(values[i])) ? tonum(values[i]) | 40;
  interaction_frame_height = tostr(interaction_frame_height, "%");
endif
URLprefix = tostr("http://", ("use_ip" in who.web_options) ? $network.numeric_address | $network.site, ":", `$http_handler:retrieve_taskprop("port_handler").handles_port ! E_PROPNF, E_TYPE => $network.port');
javaclientURL = tostr(URLprefix, "/", random(90) + 9, "anon/frame_mgr/", tonum(client), "/javaclient", form ? "?" + form | "", "#telnet_applet");
client_windowname = toobj(client).client_windowname;
html_windowname = toobj(client).html_windowname;
if (typeof(javaclient_preload_page = toobj(client):preload_page()) == LIST)
  "jclient handler supplies its own preload page, not just the URL for one";
  javaclient_preload_page = tostr(URLprefix, "/", random(90) + 9, "anon/frame_mgr/", tonum(client), "/preload");
endif
text = {};
text = {@text, tostr("<FRAMESET ROWS=\"*,", interaction_frame_height, "\">")};
text = {@text, tostr("<FRAME SRC=\"", javaclient_preload_page, "\" NAME=\"", html_windowname, "\">")};
text = {@text, tostr("<FRAME SCROLLING=NO MARGINHEIGHT=0 MARGINWIDTH=0 HMARGIN=0 VMARGIN=0 SRC=\"", javaclientURL, "\" NAME=\"", client_windowname, "\">")};
"note that MARGINHEIGHT and MARGINWIDTH are netscape attributes, but HMARGIN and VMARGIN are the correct ones in HTML 3.2";
text = {@text, tostr("<NOFRAMES><H2>Sorry!</H2> If you are reading this, your web browser doesn't support frames and you'll have to use another access method for ", $network.MOO_name, "'s web interface, or upgrade to a better web browser (Netscape Navigator 3.0 and Internet Explorer 3.0 are recommended).</NOFRAMES>")};
text = {@text, "</FRAMESET>"};
text = {"<HTML>", tostr("<HEAD><TITLE>Welcome to ", $network.MOO_name, "</TITLE></HEAD>"), @text, "</HTML>"};
return text;
"Last modified Sat Nov  2 20:56:11 1996 IST by EricM (#3264).";
.

@verb #111:"init_for_core" this none this rxd #95
@program #111:init_for_core
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || caller_perms().wizard))
  return E_PERM;
endif
this.bad_form_txt = {"<HTML><TITLE>Bad web connect form</TITLE><BODY><H2>Sorry!</H2>The form you are trying to use to connect seems to be broken or misformed. Please let the appropriate people know.</BODY></HTML>"};
this.bad_values_txt = {"<HTML><TITLE>Bad form values</TITLE>", "<BODY><H2>Sorry!</H2>One or more of the values you entered is not valid. Please back up, check your values, and resubmit the form.</BODY></HTML>"};
return pass(@args);
"Last modified Tue Aug 27 22:45:25 1996 IDT by EricM (#3264).";
.

@verb #111:"update_webframe" this none this rxd #95
@program #111:update_webframe
"update_webframe(who OBJ, url frag. STR, frame STR) -> succeeded BOOL";
"'who' is the person's whose web frame is to be updated, 'frame' is the name of the frame";
"'url_frg' is the portion of the URL after the webpass, or what would come after &LOCAL_LINK;";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
{who, url_frg, ?frame = ""} = args;
if (typeof(applet_handler = $web_options:get(who.web_options, "telnet_applet")) != OBJ)
  return 0;
endif
webpass = $http_handler.webpass_handler:webpass_for(who) || "";
if (length(this.updated_webframes[1]) != length(this.updated_webframes[2]))
  "fix corrupted webpage update lists";
  this.updated_webframes = {{}, {}};
endif
"remove outdated task info";
while (this.updated_webframes[1] && (!$code_utils:task_valid(kill = random(length(this.updated_webframes[1])))))
  this.updated_webframes[1] = listdelete(this.updated_webframes[1], kill);
  this.updated_webframes[2] = listdelete(this.updated_webframes[2], kill);
endwhile
if (!((who in connected_players()) && $mcp:confirmed(who)))
  return 0;
endif
"person's connected with an mcp-aware web browser; build the url";
if (!`port = $http_handler:retrieve_taskprop("port_handler").handles_port ! E_PROPNF, E_TYPE')
  port = `who:get_web_setting("webport_handler").handles_port ! E_TYPE, E_PROPNF => $network.port';
endif
if ("use_ip" in who.web_options)
  url = tostr("http://", $network.numeric_address, ":", port, "/", random(90) + 9, webpass, "/", url_frg);
else
  url = tostr("http://", $network.site, ":", port, "/", random(90) + 9, webpass, "/", url_frg);
endif
"note that this frame has been updated during this task";
if (idx = (task = task_id()) in this.updated_webframes[1])
  this.updated_webframes[2][idx] = listappend(this.updated_webframes[2][idx], frame);
else
  this.updated_webframes[1] = listappend(this.updated_webframes[1], task);
  this.updated_webframes[2] = listappend(this.updated_webframes[2], {frame});
endif
"set_task_perms(caller_perms())";
applet_handler:update_webframe(who, url, frame);
if (!($perm_utils:controls(caller_perms(), who) || (who == caller)))
  callers = callers();
  who:tell(callers[length(callers)][5].name, " updates your web browser.");
endif
return 1;
"Last modified Wed Oct  9 16:28:33 1996 IST by EricM (#3264).";
.

@verb #111:"webframe_is_updated" this none this rxd #95
@program #111:webframe_is_updated
"webframe_is_updated(frame STR [,task NUM]) -> BOOL";
"returns true if the specified web frame has already been updated during this task";
"if task number is omitted, the current task is assumed";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
frame = args[1];
task = (length(args) > 1) ? args[2] | task_id();
if ((length(this.updated_webframes) != 2) || (length(this.updated_webframes[1]) != length(this.updated_webframes[2])))
  "repair corrupted lists";
  this.updated_webframes = {{}, {}};
endif
result = (idx = task in this.updated_webframes[1]) && (frame in this.updated_webframes[2][idx]);
"try to kill off some dead task entries";
while ((this.updated_webframes[1] && ((kill = random(length(this.updated_webframes[1]))) != idx)) && (!$code_utils:task_valid(this.updated_webframes[1][kill])))
  this.updated_webframes[1] = listdelete(this.updated_webframes[1], kill);
  this.updated_webframes[2] = listdelete(this.updated_webframes[2], kill);
endwhile
return result;
"Last modified Tue Oct  8 23:03:32 1996 IST by EricM (#3264).";
.

"***finished***
