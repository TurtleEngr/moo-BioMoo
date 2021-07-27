$Header: /repo/public.cvs/app/BioGate/BioMooCore/core290.moo,v 1.1 2021/07/27 06:44:30 bruce Exp $

>@dump #290 with create
@create $generic_utils named Local Utilities:Local Utilities,local
@prop #290."new_player_message" {} rc
;;#290.("new_player_message") = {"", "To login to the Global Online Education Server (GOES), from the web, go", "to URL: http://hpsdce.mayfield.hp.com:8000 and follow the directions on", "this web page.", "", "If you get a proxy error, you will need to configure your browser so", "that your site's proxy is not used to access hpsdce.mayfield.hp.com.", "Here are the directions for the, one time change, to the PC version of", "Netscape 3.03:", "", "Go to the Netscape menu: Option, Network Preferences..., Proxies tab.", "Select, Manual Proxy, View, and add: hpsdce.mayfield.hp.com", "", "Note: Do NOT select the \"No Proxies\" option or you will not be able to", "access non-HP web pages."}
@prop #290."newbie_tutorial" #291 r #179
;;#290.("aliases") = {"Local Utilities", "local"}
;;#290.("description") = "This is a placeholder parent for all the $..._utils packages, to more easily find them and manipulate them. At present this object defines no useful verbs or properties. (Filfre.)"
;;#290.("object_size") = {2463, 937987203}

@verb #290:"announce_player" this none this
@program #290:announce_player
user = args[1];
if (user in {#2, #177, #178, #179, #180, #233})
  return;
endif
site = $string_utils:connection_hostname(connection_name(user));
#179:tell(((((("(Auto) " + user.name) + " pages, \"") + user.name) + " has connected from site:  ") + site) + "\"");
#180:tell(((((("(Auto) " + user.name) + " pages, \"") + user.name) + " has connected from site:  ") + site) + "\"");
#233:tell(((((("(Auto) " + user.name) + " pages, \"") + user.name) + " has connected from site:  ") + site) + "\"");
"12/4/97";
"removed :receive_page, becuase of answering machines [wsk:8301.0451PST]";
.

@verb #290:"denounce_player" this none this rxd #177
@program #290:denounce_player
user = args[1];
if (user in {#2, #177, #178, #179, #178, #180, #233})
  return;
endif
#179:receive_page(((("(Auto-off) " + user.name) + " pages, \"") + user.name) + " has disconnected.\"");
#180:receive_page(((("(Auto-off) " + user.name) + " pages, \"") + user.name) + " has disconnected.\"");
#233:receive_page(((("(Auto-off) " + user.name) + " pages, \"") + user.name) + " has disconnected.\"");
"1/7/98";
.

"***finished***
