$Header: /repo/public.cvs/app/BioGate/BioMooCore/core116.moo,v 1.1 2021/07/27 06:44:27 bruce Exp $

>@dump #116 with create
@create $webapp named User Information Customiser:User Information Customiser,info_cstm
;;#116.("code") = "char"
;;#116.("available") = 1
;;#116.("aliases") = {"User Information Customiser", "info_cstm"}
;;#116.("object_size") = {5535, 937987203}
;;#116.("web_calls") = 55

@verb #116:"method_get" this none this rx #95
@program #116:method_get
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((caller != $http_handler) && (caller != this))
  return E_PERM;
elseif (player == $no_one)
  return {"User information...", "<HR>Uh, you're connecting <B>anonymously</B>. What exactly do you want to customize?"};
  "elseif (!(player in connected_players()))";
  "return {\"User information...\", \"<HR>Sorry, but you must have a parallel telnet/client connection open to use this web device.\"};";
endif
this.web_calls = this.web_calls + 1;
who = args[1];
what = args[2];
rest = args[3];
text = {"<CENTER><FONT SIZE=+2>Customisable information</FONT><BR>", "To modify any item of the following, just enter the new values and click on the 'update data' button.</CENTER>"};
text = {@text, "<FORM METHOD=\"POST\" ACTION=\"char\">", tostr("Your character <B>name</B>: <INPUT TYPE=\"text\" NAME=\"name\" VALUE=\"", player.name, "\" SIZE=\"30\" MAXLENGTH=\"50\">")};
text = {@text, tostr("Your <B>gender</B>: <SELECT NAME=\"gender\" SIZE = \"1\">", tostr("<OPTION SELECTED>", player.gender.name || player.gender))};
if (valid($gender))
  "use BioMOO style children of generic gender object";
  genders = $list_utils:map_prop(children($gender), "name");
else
  "use LambdaCore system";
  genders = $gender_utils.genders;
endif
for gender in (setremove(genders, player.gender.name || player.gender))
  text = {@text, tostr("<OPTION>", gender)};
endfor
text = {@text, "</SELECT>"};
if (`typeof(player.title_msg) == STR ! E_PROPNF')
  text = {@text, tostr("<BR>Your <B>title</B> message: <INPUT TYPE=\"text\" NAME=\"title\" VALUE=\"", player.title_msg, "\" SIZE=\"60\" MAXLENGTH=\"100\">")};
endif
if (is_clear_property(player, "description"))
  desc = {""};
else
  desc = player.description;
  if (typeof(desc) != LIST)
    desc = {tostr(desc)};
  endif
endif
text = {@text, tostr("<BR>Your <B>description</B>: <TEXTAREA NAME=\"description\" ROWS=", max(3, length(desc)), " COLS=80>", desc[1]), @desc[2..length(desc)], "</TEXTAREA>"};
"MOOs can use this:local_get to add their own MOO-specific character into to this form";
text = (local = this:local_get(@args)) ? {@text, @local} | text;
text = {@text, "<HR><CENTER><INPUT TYPE=\"submit\" VALUE=\"Update data\">", "<INPUT TYPE=\"reset\" VALUE=\"Clear changes\">", "</CENTER></FORM>"};
text = {@text, tostr("<B>", $web_utils:rtn_to_viewer(), "</B>")};
return {"User information...", text || {"Oops, this is broken.."}};
"Last modified Wed Oct  9 20:58:49 1996 IST by EricM (#3264).";
.

@verb #116:"method_post" this none this rx #95
@program #116:method_post
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((caller != this) && (caller != $http_handler))
  return E_PERM;
elseif (player == $no_one)
  return {"User information...", "<HR>Uh, you're connecting <B>anonymously</B>. What exactly do you want to customize?"};
  "elseif (!(player in connected_players()))";
  "return {\"User information...\", \"<HR>Sorry, but you must have a parallel telnet/client connection open to use this web device.\"};";
endif
what = $web_utils:parse_form(args[5]);
for couple in (what)
  item = couple[1];
  value = couple[2];
  todo = {};
  if (item == "name")
    if (value != player.name)
      todo = {player, "set_name", value};
    endif
    what = setremove(what, couple);
  elseif (item == "description")
    while (pos = "" in value)
      value = listdelete(value, pos);
    endwhile
    if (!value)
      clear_property(player, "description");
    elseif (value != player.description)
      todo = {player, "set_description", value};
    endif
    what = setremove(what, couple);
  elseif (item == "gender")
    if (value != (player.gender.name || player.gender))
      todo = {player, "set_gender", value};
    endif
    what = setremove(what, couple);
  elseif (item == "title")
    if (!value)
      clear_property(player, "title_msg");
    elseif (value != player.title_msg)
      todo = {player, "set_message", "title", value};
    endif
    what = setremove(what, couple);
  endif
  $wiz_utils:call_verb_with_other_perms(player, @todo);
endfor
suspend(0);
"MOOs can process their local character information with a call to this:local_post";
this:local_post(what);
return this:method_get(args[1..3]);
"Last modified Sun Aug 25 21:40:54 1996 IDT by EricM (#3264).";
.

@verb #116:"available" this none this rx #95
@program #116:available
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return args[1] != $no_one;
"Last modified Fri Aug 16 02:07:18 1996 IDT by EricM (#3264).";
.

@verb #116:"get_code" this none this rx #95
@program #116:get_code
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return this.code;
"Last modified Sun Aug  6 11:51:36 1995 IDT by EricM (#3264).";
.

"***finished***
