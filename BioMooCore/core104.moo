$Header: /repo/public.cvs/app/BioGate/BioMooCore/core104.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #104 with create
@create $generic_options named WWW Options:WWW Options,weboptions
@prop #104."show_inv" {} r
;;#104.("show_inv") = {"Don't show carried objects (inventory).", "Show carried objects (inventory)."}
@prop #104."show_map" {} r
;;#104.("show_map") = {"Don't show the teleport map.", "Show the teleport map."}
@prop #104."show_hideicons" {} r
;;#104.("show_hideicons") = {"Show the icons.", "Don't show the icons."}
@prop #104."show_hidebanner" {} r
;;#104.("show_hidebanner") = {"Show the banner.", "Don't show the banner."}
@prop #104."show_exitdetails" {} r
;;#104.("show_exitdetails") = {"Don't show destination of exits along with their name.", "Show destination of exits along with their name."}
@prop #104."show_markURL" {} r
;;#104.("show_markURL") = {"Don't specially mark objects that have an associated URL or HTML document.", "Mark objects that have an associated URL or HTML document with a (*)."}
@prop #104."show_commandform" {} r
;;#104.("show_commandform") = {"Don't include a command form in the web page.", "Include a command form in the web page."}
@prop #104."show_nopage" {} r
;;#104.("show_nopage") = {"Include the command for paging people in the command form", "Don't include the command for paging people in the command form"}
@prop #104."show_nogo" {} r
;;#104.("show_nogo") = {"Include the command for teleporting between rooms in the command form", "Don't include the command for teleporting between rooms in the command form"}
@prop #104."type_viewer" {} r
;;#104.("type_viewer") = {1}
@prop #104."type_background" {} r
;;#104.("type_background") = {2}
@prop #104."type_bgcolor" {} r
;;#104.("type_bgcolor") = {2}
@prop #104."show_nobackgrounds" {} r
;;#104.("show_nobackgrounds") = {"Allow MOO objects to set your web page's background image and color", "Don't allow MOO objects to set your web page's background image and color"}
@prop #104."type_linkcolor" {} r
;;#104.("type_linkcolor") = {2}
@prop #104."type_vlinkcolor" {} r
;;#104.("type_vlinkcolor") = {2}
@prop #104."type_alinkcolor" {} r
;;#104.("type_alinkcolor") = {2}
@prop #104."type_textcolor" {} r
;;#104.("type_textcolor") = {2}
@prop #104."show_applinkdown" {} r
;;#104.("show_applinkdown") = {"Put the link to the applications list at the top of the web page.", "Put the link to the applications list at the bottom of the web page."}
@prop #104."show_ghosts" {} r
;;#104.("show_ghosts") = {"Don't detect or communicate with web ghost users.", "Detect and communicate with web ghost users."}
@prop #104."show_use_ip" {} r
;;#104.("show_use_ip") = {"Use domain name for URLs", "Use i.p. address for URLs"}
@prop #104."show_tight_link" {} r
;;#104.("show_tight_link") = {"DON'T require that web connections come from the same computer as the open telnet connection (if any)", "Require that web connections come from the same computer as the open telnet connection (if any)"}
@prop #104."show_embedVRML" {} rc
;;#104.("show_embedVRML") = {"Don't embed a VRML link in the web page.", "Embed a VRML image in the web page."}
@prop #104."show_separateVRML" {} r
;;#104.("show_separateVRML") = {"A VRML window replaces the web window when needed.", "A new window is launched when a VRML view is requested."}
@prop #104."type_telnet_applet" {} r
;;#104.("type_telnet_applet") = {1}
@prop #104."show_no_cookies" {} rc
;;#104.("show_no_cookies") = {"Use web cookies to store authentication information.", "Embed authentication in the URL instead of using web cookies"}
;;#104.("names") = {"inv", "map", "hideicons", "hidebanner", "exitdetails", "markURL", "commandform", "nogo", "nopage", "viewer", "background", "bgcolor", "nobackgrounds", "textcolor", "linkcolor", "vlinkcolor", "alinkcolor", "applinkdown", "ghosts", "webediting", "use_ip", "tight_link", "embedVRML", "separateVRML", "telnet_applet", "no_cookies"}
;;#104.("_namelist") = "!inv!map!hideicons!hidebanner!exitdetails!markURL!commandform!nogo!nopage!viewer!background!bgcolor!nobackgrounds!textcolor!linkcolor!vlinkcolor!alinkcolor!applinkdown!ghosts!webediting!use_ip!tight_link!embedVRML!separateVRML!telnet_applet!no_cookies!"
;;#104.("namewidth") = 21
;;#104.("aliases") = {"WWW Options", "weboptions"}
;;#104.("description") = "an option package in need of a description.  See `help $generic_option'..."
;;#104.("object_size") = {10614, 937987203}

@verb #104:"parse_viewer" this none this rx #95
@program #104:parse_viewer
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
oname = args[1];
raw = args[2];
if (typeof(raw) == LIST)
  if (length(raw) > 1)
    return "Too many arguments.";
  endif
  raw = raw[1];
elseif (typeof(raw) == OBJ)
  return {oname, (raw == $standard_webviewer) ? 0 | raw};
elseif (typeof(raw) == NUM)
  return "Expected syntax: viewer=#foo, where #foo is the object number of a web viewer.";
elseif ($string_utils:is_numeric(raw))
  raw = "#" + raw;
elseif ((raw[1] == "$") && (value = tostr(#0.(raw[2..length(raw)]))))
  raw = (value == "Property not found") ? raw | value;
endif
if (((value = $code_utils:toobj(raw)) == E_TYPE) || (!$object_utils:isa(value, $webapp)))
  return tostr("`", raw, "'?  Object number of a web viewer expected.");
endif
return {oname, (value == $standard_webviewer) ? 0 | value};
"Last modified Mon Dec 23 10:11:16 1996 IST by Gustavo (#2).";
.

@verb #104:"set" this none this rx #95
@program #104:set
"Modified from Page Options (#217):set by EricM (#3264) Fri Jun  2 13:29:25 1995 IDT";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
opts = args[1];
option = args[2];
value = args[3];
if (option == "viewer")
  for opt in (opts)
    if ((opt == "viewer") || ((typeof(opt) == LIST) && (opt[1] == "viewer")))
      opts = setremove(opts, opt);
    endif
  endfor
  if (value == 1)
    opts = {"viewer", @opts};
  elseif (valid(value) && $object_utils:isa(value, $webapp))
    opts = {{"viewer", value}, @opts};
  endif
  return opts;
else
  return pass(@args);
endif
"Last modified Fri Jun  2 14:21:31 1995 IDT by EricM (#3264).";
.

@verb #104:"show_viewer" this none this rx #95
@program #104:show_viewer
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
viewer = this:get(player.web_options, "viewer");
return {viewer, {valid(viewer) ? tostr("Use ", viewer:name(1), " as default viewer when connecting by web") | "Use the standard web viewer when connecting by web"}};
"Last modified Mon Jul 31 02:44:44 1995 IDT by EricM (#3264).";
.

@verb #104:"parse_background" this none this rxd #95
@program #104:parse_background
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return args[2] ? {args[1], tostr(args[2])} | 0;
"Last modified Sun Aug  6 16:21:06 1995 IDT by EricM (#3264).";
.

@verb #104:"show_background show_bgcolor show_fgcolor show_textcolor show_linkcolor show_alinkcolor show_vlinkcolor" this none this rxd #95
@program #104:show_background
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
type = strsub(verb, "show_", "");
value = this:get(player.web_options, type);
return {value, {value ? tostr("  Use \"", value, "\" as the web page's ", type, " value") | tostr("Let the MOO set your web page's ", type, " value")}};
"Last modified Sun Aug  6 16:23:13 1995 IDT by EricM (#3264).";
.

@verb #104:"parse_bgcolor parse_textcolor parse_linkcolor parse_acolor parse_vlinkcolor" this none this rxd #95
@program #104:parse_bgcolor
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
oname = args[1];
raw = args[2];
if ((raw in {"", "#"}) || (typeof(raw) != STR))
  mode = strsub(verb, "parse_", "");
  return tostr("Set this value with a command in the form \"@weboption ", mode, "=FFFFFF\" where \"FFFFFF\" is the hexadecimal equivalent of the color. You can clear your setting with: @weboption -", mode);
endif
if (raw[1] == "#")
  raw = raw[2..length(raw)];
endif
len = length(raw);
if (len > 6)
  return "The value must be a six digit hexidecimal number.";
endif
raw = ("000000" + tostr(raw))[len + 1..len + 6];
if (!match(raw, "[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]"))
  return "The value must be a six digit hexadecimal number.";
endif
return {oname, raw};
"Last modified Thu May  2 14:32:07 1996 IDT by EricM (#3264).";
.

@verb #104:"show_telnet_applet" this none this rxd #95
@program #104:show_telnet_applet
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
applet = this:get(player.web_options, "telnet_applet");
return {applet, {`valid(applet) ! E_TYPE' ? tostr("Use ", applet:name(1), " for telnet Java applets.") | "You are using the default telnet Java applet."}};
"Last modified Tue Oct  8 17:17:33 1996 IST by EricM (#3264).";
.

@verb #104:"parse_telnet_applet" this none this rxd #95
@program #104:parse_telnet_applet
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
oname = args[1];
raw = args[2];
if (typeof(raw) == LIST)
  if (length(raw) > 1)
    return "Too many arguments.";
  endif
  raw = raw[1];
elseif (typeof(raw) == OBJ)
  if ($object_utils:isa(raw, $jclient_handler))
    return {oname, raw};
  else
    return tostr("`", raw, "'?  Object number of a Java client handler expected.");
  endif
elseif ($string_utils:is_numeric(raw))
  raw = "#" + raw;
elseif ((raw[1] == "$") && (value = tostr(#0.(raw[2..length(raw)]))))
  raw = (value == "Property not found") ? raw | value;
endif
if (((value = $code_utils:toobj(raw)) == E_TYPE) || (!$object_utils:isa(value, $jclient_handler)))
  return tostr("`", raw, "'?  Object number of a Java client handler expected.");
endif
return {oname, (value == $standard_webviewer) ? 0 | value};
"Last modified Fri Sep 27 03:30:42 1996 IST by EricM (#3264).";
.

"***finished***
