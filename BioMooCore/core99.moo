$Header: /repo/public.cvs/app/BioGate/BioMooCore/core99.moo,v 1.1 2021/07/27 06:44:37 bruce Exp $

>@dump #99 with create
@create $webapp named Viewer Customiser:Viewer Customiser,wcu
;;#99.("code") = "vcst"
;;#99.("available") = 1
;;#99.("aliases") = {"Viewer Customiser", "wcu"}
;;#99.("object_size") = {4090, 937987203}
;;#99.("web_calls") = 89

@verb #99:"method_get" this none this rx #95
@program #99:method_get
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((caller != $http_handler) && (caller != this))
  return E_PERM;
elseif (player == $no_one)
  return {"Customize", "<HR>Sorry, you have to have a parallel telnet/client connection open to use the viewer which this form works with."};
elseif (!(player in connected_players()))
  return {"Customize", "<HR>Sorry, you have to have a parallel telnet/client connection open to use this web device."};
endif
this.web_calls = this.web_calls + 1;
wo = $web_options;
text = {tostr("<H1>", $network.MOO_name, "'s web interface customising form.</H1>")};
text = {@text, "<P><FORM METHOD=\"POST\" ACTION=\"vcst\">"};
for prop in (properties(wo))
  if (index(prop, "show_") == 1)
    blah = wo.(prop);
    name = prop[6..length(prop)];
    value = name in player.web_options;
    text = {@text, ((((("<INPUT TYPE=\"radio\" NAME=\"" + name) + "\" VALUE=\"yes\"") + (value ? "" | " CHECKED")) + ">") + blah[1]) + "<BR>"};
    text = {@text, ((((("<INPUT TYPE=\"radio\" NAME=\"" + name) + "\" VALUE=\"no\"") + (value ? " CHECKED" | "")) + ">") + blah[2]) + "<P>"};
  endif
endfor
text = {@text, "<INPUT TYPE=\"submit\" VALUE=\"Save these options\">", ", ", $web_utils:rtn_to_viewer(), ", or", "<INPUT TYPE=\"reset\" VALUE=\"clear changes\">", "</FORM>"};
text = {@text, "<FORM METHOD=\"POST\" ACTION=\"vcst\">", "<INPUT TYPE=\"submit\" VALUE=\"Reset options to default\">", "</FORM>"};
return {"Customize viewer", text};
"Last modified Tue Nov  7 20:13:11 1995 IST by EricM (#3264).";
.

@verb #99:"method_post" this none this rx #95
@program #99:method_post
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != $http_handler)
  return E_PERM;
elseif (player == $no_one)
  return {"Customize", "<HR>Sorry, you have to have a parallel telnet/client connection open to use the viewer that this form works with."};
elseif (!(player in connected_players()))
  return {"Customize", "<HR>Sorry, you have to have a parallel telnet/client connection open to use this web device."};
endif
this.web_calls = this.web_calls + 1;
if (player == $no_one)
  return {"Uh, what are you trying to customize..?"};
endif
data = $web_utils:parse_form(args[5]);
if (!data)
  clear_property(player, "web_options");
else
  for field in (data)
    if (field[2] == "yes")
      player.web_options = setremove(player.web_options, field[1]);
    else
      player.web_options = setadd(player.web_options, field[1]);
    endif
  endfor
endif
return this:method_get(@args);
"Last modified Tue Nov  7 20:13:27 1995 IST by EricM (#3264).";
.

@verb #99:"available" this none this rx #95
@program #99:available
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return args[1] != $no_one;
"Last modified Fri Nov 25 22:11:10 1994 IST by Gustavo (#2).";
.

@verb #99:"get_code" this none this rxd #95
@program #99:get_code
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return this.code;
"Last modified Sun Aug  6 11:46:06 1995 IDT by EricM (#3264).";
.

"***finished***
