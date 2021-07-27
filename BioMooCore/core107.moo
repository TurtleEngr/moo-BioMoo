$Header: /repo/public.cvs/app/BioGate/BioMooCore/core107.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #107 with create
@create $webapp named Standard VRML/1.0 Viewer:Standard VRML/1.0 Viewer,vrml_view
;;#107.("code") = "vrml10"
;;#107.("aliases") = {"Standard VRML/1.0 Viewer", "vrml_view"}
;;#107.("object_size") = {4641, 937987203}

@verb #107:"get_code" this none this
@program #107:get_code
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return pass(@args);
"Last modified Tue Nov 21 09:33:00 1995 IST by EricM (#3264).";
.

@verb #107:"method_get" this none this rx #95
@program #107:method_get
"method_post method_get(who, what OBJ, rest STR, search STR, form STR) -> VRML doc frg LIST";
"Returns the VRML file section associated with the object 'what'";
"Expects people to access the MOO's VRML interface with URLs of the general form:";
"  http://mo.du.org:8888/xxWebpass/vrml/room_objnum/room.wrl    ";
"Note that the 'room.wrl' is a dummy to trigger extension recognition by the browser";
"Since the Content-type is specified in the header lines under HTTP/1.0, this";
"should not in theory be needed.";
"However, future development will allow for more than just the room to be specified";
"  Current system only supports browsing, but should eventually work much like the web";
"interface.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == $http_handler) || $perm_utils:controls(caller_perms(), this)))
  return E_PERM;
elseif (!valid(what = args[2]))
  return {};
endif
$http_handler:submit_taskprop("Content-Type", "x-world/x-vrml");
set_task_perms(who = caller_perms());
rest = $string_utils:explode(args[3], "/");
if (!valid(what))
  "'what' is junky; select central room for anon users, else character's loc'n";
  what = (player == $no_one) ? $teleporter.central_room | what;
elseif ($object_utils:isa(what, $player))
  "assume person wants to see place where character is located";
  what = what.location;
endif
if (((rest && (rest[1] == "moveto")) && (who in connected_players())) && $object_utils:isa(what, $room))
  "call is also a request to move the user to the new room";
  $teleporter:move_user_for_web(who, what);
  if (who.location != what)
    who:tell("You try to move to the room \"", what.name, "\" but can't get there.");
    what = who.location;
  endif
endif
"-get room or other object's vrml data";
vrml = what:get_vrml(@listdelete(args, 2)) || {};
if (!("embedVRML" in player.web_options))
  "--add a web link if what isn't already embedded in a web page";
  vrml = {@vrml, "DEF Home_Page_Link Separator {"};
  "--find out where the room wants standard link icons to go";
  linkzone = (typeof(linkzone = what:get_vrml_setting("linkzone") || $vrml_utils.std_linkzone) == STR) ? {linkzone} | linkzone;
  vrml = {@vrml, @linkzone};
  link_to = (player == $no_one) ? tonum(what) | "";
  vrml = {@vrml, tostr(" WWWAnchor { description \"Link to web\" name \"&LOCAL_LINK;/", $web_utils:user_webviewer():get_code(), "/", link_to, "#focus\"")};
  vrml = {@vrml, @$vrml_utils.link_to_web};
  "--close off the WWWAnchor and the Home_PageLink Separator";
  vrml = {@vrml, " }", "}"};
endif
"--send if off";
return {"#VRML V1.0 ascii", "", tostr("#created by ", $network.MOO_name, " at ", ctime()), "", "Separator {", @vrml, "}"};
"Last modified Thu Aug 15 02:05:57 1996 IDT by EricM (#3264).";
.

@verb #107:"available" this none this
@program #107:available
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return $web_utils:get_webcode() == this:get_code();
"return true if this is NOT a request for the list of webapps";
"Last modified Sat Mar 23 09:18:02 1996 IDT by EricM (#3264).";
.

"***finished***
