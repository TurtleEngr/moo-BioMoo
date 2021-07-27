$Header: /repo/public.cvs/app/BioGate/BioMooCore/core109.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #109 with create
@create $thing named Generic JavaClient Handler:Generic JavaClient Handler,gjh
@prop #109."client_name" "" rc
@prop #109."default_preload_page" {} rc
;;#109.("default_preload_page") = {"<HTML>", "<HEAD><TITLE>Welcome!</TITLE></HEAD>", "<BODY>", "", "<CENTER", "<FONT size=+3><B>The integrated telnet/web system is loading...</B></FONT><BR>", "(this page is displayed until the telnet client issues a command to display a fresh page)", "</CENTER></P>", "", "Guests may need to finish answering any questions in the interaction window below to complete their live connection to the MOO.  Once the live connection to the MOO has been established, this page should be replaced by the entry view's web page.<P>", "</BODY></HTML>"}
@prop #109."client_windowname" "interaction_frame" rc
@prop #109."html_windowname" "html_frame" rc
@prop #109."float_client_frame" 0 rc
;;#109.("aliases") = {"Generic JavaClient Handler", "gjh"}
;;#109.("object_size") = {11885, 937987203}

@verb #109:"make_applet_html" this none this
@program #109:make_applet_html
"make_applet_html(form fields LIST, form values LIST) -> html doc LIST";
"Create an HTML page that will run the client applet This is the HTML";
"document that will be loaded into the frame or window containing the";
"telnet Java applet, and should have the <APPLET> tag and such.  Use";
"the values in the given fields for appropriate settings.  Note that";
"these fields come straight from the original form, except the";
"password field value has been replaced with a temporary password.";
"Note that the password sent to this verb is a dummy, and will be";
"replaced by the real password.  This is the default client handler,";
"designed for the Cup O'MUD client, but should work with any MCP";
"compliant applet that accepts `display-url' commands.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
fields = args[1];
values = args[2];
username = values["user_name" in fields];
if (username in {"", "anonymous"})
  username = "guest";
endif
who = $string_utils:match_player(username);
password = values["password" in fields];
echo = (i = "echo" in fields) && (values[i] == "on");
MCP_on = (i = "MCP_on" in fields) && (values[i] == "on");
prefix = (echo && (i = "prefix" in fields)) ? values[i] | "";
interaction_frame_height = ((i = "interaction_frame_height" in fields) && $string_utils:is_numeric(values[i])) ? tonum(values[i]) - 8 | 192;
fontspec = (i = "font" in fields) ? values[i] | "";
output_bgcolor = (i = "output_bgcolor" in fields) ? values[i] | "";
output_fgcolor = (i = "output_fgcolor" in fields) ? values[i] | "";
input_fgcolor = (i = "input_fgcolor" in fields) ? values[i] | "";
debug = (i = "debug" in fields) && (values[i] == "on");
if (valid(who))
  MOO_site = ("use_ip" in who.web_options) ? $network.numeric_address | $network.site;
else
  MOO_site = $network.site;
endif
input_bgcolor = (i = "input_bgcolor" in fields) ? values[i] | "";
codebase = tostr("http://", MOO_site, $http_handler.javaclient_codebase);
code = this.client_name;
if (idx = rindex(this.client_name, "/"))
  "if this.client_name has a backslash, move the stuff before the class file's actual name onto the codebase";
  codebase = codebase + code[1..idx];
  code = code[idx + 1..length(code)];
  "Trim off the '.class' extension if it's there. The code below will add one.";
  code = strsub(code, ".class", "");
endif
debug ? codebase = codebase + "debug/" | 0;
waitfor = (i = "waitfor" in fields) ? values[i] | "";
bodytag = "<BODY BGCOLOR=\"#888888\">";
text = {};
text = {@text, tostr("<HTML><TITLE>Client Frame</TITLE>", bodytag, "<CENTER>")};
headers = $http_handler:retrieve_taskprop("headers");
agent = (headers && (line = $string_utils:find_prefix("User-Agent:", headers))) && headers[line];
if (agent && index(agent, "MSIE"))
  "Stupid Internet Explorer 3.0 won't take percentages for applet size";
  text = {@text, tostr("<APPLET CODEBASE=\"", codebase, "\" CODE=\"", code, ".class\" NAME=\"telnet_applet\" ALIGN=\"TOP\" HSPACE=0 VSPACE=0 HEIGHT=130 WIDTH=600>")};
else
  text = {@text, tostr("<A NAME=\"telnet_applet\"></A><APPLET CODEBASE=\"", codebase, "\" CODE=\"", code, ".class\" NAME=\"cupOmud\" HEIGHT=100% WIDTH=100% HSPACE=0 VSPACE=0>")};
  "text = {@text, tostr(\\\"<A NAME=\\\"applet\\\"></A><APPLET CODEBASE=\\\"\", codebase, \"\\\" CODE=\\\"\", code, \".class\\\" HEIGHT=\", interaction_frame_height, \" WIDTH=100%>\")};";
  "I wish the user could set the height but it's a hassle to encode.  Next version...";
endif
text = {@text, "<B>If you are seeing this text, your web browser does not support Java.  You'll have to run a non-integrated telnet/client program alongside the web browser.</B><HR>"};
text = {@text, tostr("<PARAM NAME=\"host\" VALUE=\"", MOO_site, "\">")};
text = output_fgcolor ? {@text, tostr("<PARAM NAME=\"output_fgcolor\" VALUE=\"", output_fgcolor, "\">")} | text;
text = output_bgcolor ? {@text, tostr("<PARAM NAME=\"output_bgcolor\" VALUE=\"", output_bgcolor, "\">")} | text;
text = input_bgcolor ? {@text, tostr("<PARAM NAME=\"input_bgcolor\" VALUE=\"", input_bgcolor, "\">")} | text;
text = input_fgcolor ? {@text, tostr("<PARAM NAME=\"input_fgcolor\" VALUE=\"", input_fgcolor, "\">")} | text;
text = (username && waitfor) ? {@text, tostr("<PARAM NAME=\"waitfor\" VALUE=\"", waitfor, "\">")} | text;
text = {@text, tostr("<PARAM NAME=\"port\" VALUE=\"", $network.port, "\">")};
text = {@text, tostr("<PARAM NAME=\"sysname\" VALUE=\"", $network.MOO_name, "\">")};
text = {@text, tostr("<PARAM NAME=\"MCP\" VALUE=\"", MCP_on, "\">")};
if (echo)
  text = {@text, tostr("<PARAM NAME=\"echo\" VALUE=\"", prefix, "\">")};
endif
text = fontspec ? {@text, tostr("<PARAM NAME=\"font\" VALUE=\"", fontspec, "\">")} | text;
text = {@text, "<PARAM NAME=\"URLtarget\" VALUE=\"html_frame\">"};
if (username)
  text = {@text, tostr("<PARAM NAME=\"COMMAND\" VALUE=\"preapproved ", username, " ", password, "\">")};
endif
text = {@text, "</APPLET></CENTER></BODY></HTML>"};
return text;
"Last modified Tue Jul  1 20:21:42 1997 IDT by EricM (#3264).";
.

@verb #109:"update_webframe" this none this rxd #95
@program #109:update_webframe
"update_webframe (who {OBJ}, url {STR}[, frame {STR}]) -> succeeds {BOOL}";
"Sends the message to user:tell that is recognized by the telnet";
"applet as an `update web page' command.  By default, the applet is";
"assumed to be MCP compliant, and recognizes the `display-url'";
"command.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
{who, url, ?frame = ""} = args;
set_task_perms(caller_perms());
if (!$mcp:confirmed(who))
  return 0;
endif
if (frame)
  $mcp:display_url(who, url, frame);
else
  $mcp:display_url(who, url);
endif
return 1;
"Last modified Tue Aug 20 21:38:13 1996 IDT by EricM (#3264).";
.

@verb #109:"user_autoconnected" this none this rxd #95
@program #109:user_autoconnected
"user_autoconnected(who OBJ, port_handler NUM) -> none";
"This is called when a person first connects using the Java applet";
"handled by this object.  Mostly, it needs to issue any appropriate";
"initial client out-of-band commands, like instructions to load the";
"first web page.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
{who, port_handler} = args;
if (!(caller_perms().wizard || (caller == $http_handler)))
  return E_PERM;
elseif (!valid(who))
  return E_INVARG;
endif
MOO_site = ("use_ip" in who.web_options) ? $network.numeric_address | $network.site;
"timeout is how many seconds they have to connect and get out of the login chamber";
"after that, the server gives up on sending the web frame autoupdate-on-connect command";
timeout = 360;
if (who in connected_players())
  suspend(1);
  attempt = timeout / 3;
  "give them 6 minutes to connect and get out of the login chamber";
  while (((attempt > 0) && (who.location == `$login_chamber ! E_PROPNF')) && (who in connected_players()))
    "If DU style $login_chamber exists, wait for user to get out of it";
    "Other MOOs might have some other room where people sit before actually connecting (sometimes $limbo)";
    "probably a guest or user connecting for the first time";
    suspend(3);
    attempt = attempt - 1;
  endwhile
  if ((who.location != `$login_chamber ! E_PROPNF') && (who in connected_players()))
    webpass = $http_handler.webpass_handler:set_password(who);
    "If it works with the autologin system, it should also support MCP";
    $mcp:initiate_mcp(who);
    viewercode = `valid(viewer = $web_options:get(who.web_options, "viewer")) ! E_TYPE' ? viewer:get_code() | $standard_webviewer:get_code();
    url = tostr("http://", MOO_site, ":", `port_handler.handles_port ! E_TYPE, E_PROPNF => $network.port', "/?", webpass);
    "wait for confirmation that mcp-aware telnet client is listening";
    attempt = 10;
    "$mcp:confirmed returning zero means confirmation request was sent,";
    "but no response yet, but returning an ERR means no session was initiated ";
    while ((attempt > 0) && ((confirmation = $mcp:confirmed(who)) == 0))
      suspend(1);
      attempt = attempt - 1;
    endwhile
    "set the frame if the mcp connection was confirmed";
    if (attempt > 0)
      $mcp:display_url(who, url, "html_frame");
    elseif (typeof(confirmation) == ERR)
      notify(who, "*** Your client doesn't appear to support MCP confirmation.  Continuing...");
    endif
  endif
endif
if (STR == typeof(result = $web_options:set(who.web_options, "telnet_applet", this)))
  who:tell("Error initializing telnet applet option: ", result);
else
  who.web_options = result;
endif
"Last modified Tue Jul  1 22:42:00 1997 IDT by EricM (#3264).";
.

@verb #109:"preload_page" this none this
@program #109:preload_page
"preload_page(none) -> url STR or html LIST";
"Returns either the body text of an HTML page or a URL, to use in the";
"top frame of a Java telnet client window for display while the client";
"loads and before the first real page gets loaded.";
"If this object's 'default_preload_page' is a URL, then the URL is";
"returns (type STR), or if it's an HTML doc then that is returned";
"(type LIST).";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!(caller in {this, $http_handler, $frame_manager}))
  return E_PERM;
endif
if (!(preload = this.default_preload_page))
  "use the MOO's web gateway page";
  port = `$http_handler:retrieve_taskprop("port_handler").handles_port ! E_PROPNF, E_TYPE => $network.port' || $network.port;
  return tostr("http://", $network.site, ":", port);
endif
return preload;
"Last modified Wed Sep 25 23:09:52 1996 IST by EricM (#3264).";
.

@verb #109:"float_client_frame" this none this rxd #95
@program #109:float_client_frame
"float_client_frame(who OBJ, form STR) -> float BOOL";
"Returns true if the client will be in an independent floating frame";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return this.float_client_frame;
"Last modified Sat Nov  2 20:57:44 1996 IST by EricM (#3264).";
.

"***finished***
