$Header: /repo/public.cvs/app/BioGate/BioMooCore/core284.moo,v 1.1 2021/07/27 06:44:30 bruce Exp $

>@dump #284 with create
@create $frand_class named Generic GOES Citizen:Generic DECORE Citizen
@prop #284."displays" {} rc
@prop #284."quiet" 0 r #178
@prop #284."say_buffer" {} r #178
@prop #284."respond_to" {} c
;;#284.("respond_to") = {{#-1, 0}, {#-1, 0}}
@prop #284."page_notify" 0 rc
@prop #284."last_paged" #-1 r
@prop #284."timezone" 7 rc
@prop #284."pp_prefix_msg" "(from %l)" rc
@prop #284."connections" {} rc
;;#284.("features") = {#92, #91, #132}
;;#284.("help") = {#285}
;;#284.("home") = #62
;;#284.("size_quota") = {50000, 0, 0, 1}
;;#284.("web_options") = {{"telnet_applet", #110}, "applinkdown", "exitdetails", "map", "embedVRML", "separateVRML"}
;;#284.("aliases") = {"Generic DECORE Citizen"}
;;#284.("description") = "You see a player who should type '@describe me as ...'."
;;#284.("object_size") = {19433, 937987203}
;;#284.("vrml_desc") = {"WWWInline {name \"http://hppsda.mayfield.hp.com/image/body.wrl\"}", ""}

@verb #284:"@tutorial" none none none rd #179
@program #284:@tutorial
"Enter the newbie Tutorial. This verb originally came from Michele (#50607).";
$local.newbie_tutorial:(verb)(@args);
"Last modified Sat Oct 12 17:22:16 1996 PDT by Amalgam, #115@GOES.";
.

@verb #284:"moveto" this none this
@program #284:moveto
pass(@args);
"save some ticks: rose:auto_rose()";
"unwound :auto_rose follows:";
"Called when players with auto-rose move.";
"Hmm.  Actually, this will also let this be used by automatically";
"by people hwo don't the feature added....";
where = player.location;
used = $list_utils:iassoc(player, #286.read);
options = used ? #286.read[used][3] | {};
rose = #286:genrose(where, options);
if (length(rose) > 30)
  suspend(0);
endif
((ticks_left() < 4000) || (seconds_left() < 3)) && suspend(1);
if ((typeof(rose) == LIST) && (player.location == where))
  for lines in (rose)
    player:tell(lines);
  endfor
endif
"Last modified Wed Oct 23 13:08:19 1996 PDT by Amalgam, #115@GOES.";
.

@verb #284:"say-quiet say emote" none none none rd #178
@program #284:say-quiet
if (args || $object_utils:isa(this.location, $generic_editor))
  this.location:(verb)();
else
  try
    this:notify(tostr("Type the line you want to ", verb));
    this.quiet = 1;
    if (typeof(tLine = `read(this) ! ANY') == ERR)
      tSay = "";
    else
      tSay = tLine;
    endif
    this.quiet = 0;
    for tLine in (this.say_buffer)
      this:notify(tLine);
    endfor
    if (tSay)
      argstr = tSay;
      this.location:(verb)();
    endif
  finally
    this.quiet = 0;
    this.say_buffer = {};
  endtry
endif
"Last modified Wed Jan 29 09:50:16 1997 PST by Adric, #117@GOES.";
.

@verb #284:"@whograph @wg" any any any r
@program #284:@whograph
"Prints out a graphic list of players, showing their relative connected and idle times.";
exceptions = {};
pinfo = {};
lname = 0;
for who in ($set_utils:difference(connected_players(), exceptions))
  pinfo = {@pinfo, {who, who.name, idle_seconds(who), connected_seconds(who)}};
  lname = max(lname, length(who.name));
endfor
pinfo = $list_utils:sort_alist(pinfo, ("name" in args) ? 2 | 4);
linelen = (player:linelen() - lname) - 4;
factor = max(@$list_utils:slice(pinfo, 4)) / linelen;
final = {tostr("Graphical @who listing of ", length(pinfo), " players"), "---"};
for who in (pinfo)
  idle = who[3] / factor;
  con = max(who[4] / factor, 1);
  final = {@final, tostr($string_utils:left(who[2], lname), "  ", $string_utils:space(con - idle, "#"), $string_utils:space(idle, "."))};
endfor
final = {@final, "---  # = active time         . = connected time", tostr("Each unit represents ", $time_utils:english_time(factor), ".")};
player:notify_lines(final);
"Last modified Fri Feb 21 02:10:19 1997 PST by Amalgam, #115@GOES.";
.

@verb #284:"notify" this none this rxd #178
@program #284:notify
if ((caller != this) && (!$perm_utils:controls(caller_perms(), this)))
  return E_PERM;
endif
if (this.quiet)
  this.say_buffer = listappend(this.say_buffer, args[1]);
  return;
else
  set_task_perms(caller_perms());
  return pass(@args);
endif
"Last modified Fri Feb 21 09:26:35 1997 PST by Adric, #117@GOES.";
.

@verb #284:"'*" any any any
@program #284:'
"Mimic res*pond's behavior";
string = verb[2..$];
if (verb == "'")
  if (typeof(who = this:kwik_page_respond_to()) == LIST)
    this:tell("Do you mean ", who[1].name, " or ", who[2].name, "?");
    return;
  elseif (!valid(who))
    this:tell("Nobody to respond to.");
    return;
  endif
else
  who = $string_utils:match_player(string);
endif
if (!$command_utils:player_match_failed(who, string))
  this:set_respond_to(who);
  this:set_last_paged(who);
  if (0)
    msgr = argstr ? tostr(player.name, " pages, \"", argstr, "\"") | tostr(player.name, " pages from ", $string_utils:nn(player.location, ""));
  endif
  msgr = argstr ? tostr(player.name, " pages, \"", argstr, "\"") | tostr("You sense that ", player.name, " is looking for you in ", player.location.name, ".");
  if (0 && this:has_perk("pageorigin SCHMOO CLASS OPTION ON LAMBDA"))
    msgr = {this:page_origin_msg(), msgr};
  else
    msgr = {msgr};
  endif
  rcvd = (result = who:receive_page(@msgr)) ? tostr(who.name, " has received your page.") | tostr(who.name, " has refused your page.");
  echo = (0 && this:has_perk("pageecho")) && "SCHMOO OPTION AGAIN";
  if (result == 2)
    player:tell($string_utils:pronoun_sub(echo ? (typeof(msg = who:page_absent_msg()) == STR) ? msg | "%n is not currently logged in." | "%n is not currently logged in.", who));
  else
    player:tell(echo ? (typeof(msg = who:page_echo_msg()) == STR) ? msg | rcvd | rcvd);
  endif
endif
"Last modified Mon May  5 15:50:36 1997 PDT by Amalgam, #115@GOES.";
.

@verb #284:"kwik_page_respond_to" this none this
@program #284:kwik_page_respond_to
"schmoo perks package, whether to respond to last paged...";
"return this:has_perk(\"lastpage\") ? this.last_paged | this:respond_to()";
return this:respond_to();
"Last modified Thu Mar 27 18:34:15 1997 PST by Amalgam, #115@GOES.";
.

@verb #284:"respond_to" this none this rx
@program #284:respond_to
"Who to respond to.";
"Return:";
"#-1 if no one to respond to.";
"{OBJ, OBJ} if someone different has paged within the last 30 seconds.";
"OBJ if unambiguous.";
who = args[1];
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  if (!valid(r = this.respond_to[2][1]))
    return #-1;
  elseif ((time() - this.respond_to[1][2]) < 30)
    return {r, this.respond_to[1][1]};
  else
    return r;
  endif
else
  return E_PERM;
endif
"Last modified Thu Mar 27 18:42:55 1997 PST by Amalgam, #115@GOES.";
.

@verb #284:"res*pond =*" any any any rxd
@program #284:respond
if (typeof(r = this:respond_to()) == LIST)
  this:tell("Do you mean ", r[1].name, " or ", r[2].name, "?");
elseif (!valid(r))
  this:tell("Nobody to respond to.");
elseif (!(r in connected_players()))
  this:tell("Don't respond to ", r.name, " now, ", r.ps, "'s asleep.");
else
  text = ((length(verb) > 1) && (verb[1] == "=")) ? verb[2..length(verb)] + (argstr ? " " + argstr | "") | argstr;
  if (text)
    if (r:receive_page(tostr(this.name, " responds, \"", text, "\"")))
      this:tell("You respond to ", r.name, ".");
    else
      this:tell("Your response to ", r.name, " was refused.");
    endif
  elseif (r in connected_players())
    this:tell("You are ready to respond to ", r.name, ".");
  else
    this:tell("You would like to respond to ", r.name, ", but ", r.ps, "'s asleep.");
  endif
endif
"Last modified Thu Mar 27 18:52:32 1997 PST by Amalgam, #115@GOES.";
.

@verb #284:"set_respond_to" this none this
@program #284:set_respond_to
who = args[1];
if ((typeof(this.respond_to) != LIST) || (length(this.respond_to) < 2))
  this.respond_to = {{$nothing, 0}, {who, time()}};
elseif (this.respond_to[2][1] == who)
  this.respond_to = {this.respond_to[1], {who, time()}};
else
  this.respond_to = {this.respond_to[2], {who, time()}};
endif
"Last modified Thu Mar 27 18:54:30 1997 PST by Amalgam, #115@GOES.";
.

@verb #284:"receive_page" this none this
@program #284:receive_page
val = pass(@args);
if (val)
  "Page received if returned 1, refused if 0.";
  this:set_respond_to(player);
  notifies = (typeof(this.page_notify) == LIST) ? this.page_notify | setremove(setremove({@this:mail_notify(), @typeof(mfd = this:mail_forward() == LIST) ? mfd | {}}, this), player);
  if (length(notifies) > $mail_agent.max_mail_notify)
    notifies = {};
  endif
  for who in (notifies)
    is = $gender_utils:get_conj("is", player);
    who:tell(player.name, " ", is, " paging ", this.name, ".");
  endfor
endif
return val;
"Last modified Wed Jul 16 10:53:58 1997 PDT by Amalgam, #115@GOES.";
.

@verb #284:"set_last_paged" this none this
@program #284:set_last_paged
if (caller != this)
  return E_PERM;
else
  this.(verb[5..length(verb)]) = args[1];
endif
"Last modified Thu Mar 27 20:18:58 1997 PST by Amalgam, #115@GOES.";
.

@verb #284:"@paste*-to @paste*to" any any any
@program #284:@paste-to
"Version 2.04a";
"Brack's vastly improved @paste verb. Allows you to paste text from your client to a bunch of other players.";
"You can paste to individual players, or rooms of players.";
"Examples:";
"@paste               - pastes to your current location";
"@paste Brack         - pastes only to Brack.";
"@paste here Snoopy   - pastes to your location and Snoopy";
"@paste #11 Bats Tapu - pastes to people in #11, Bats and Tapu.";
"@paste ;children($prog) - pastes to children of $prog who are on-line";
"@paste ;;p={}; for x in (connected_players()) x.paste&&(p={@p,x}); endfor return p; -- multi-line eval; must return a object, string to be matched, or list of same.";
"Evals are done with $no_one's permissions always, since this is a +x verb. Uses player:eval_cmd_string(), so that eval environment can be used.";
"Prompts you for input even if you're not pasting to anybody, but text is ignored.";
dudes = {};
argstr = $code_utils:argstr(verb, args, argstr);
if (argstr && (argstr[1] == ";"))
  argstr = argstr[2..$];
  args = {};
  if (!player.programmer)
    player:tell("Sorry, but you can't eval.");
  elseif (!(eval = $no_one:call_verb(player, "eval_cmd_string", {argstr, 0}))[1])
    player:tell("Error in eval: ", $string_utils:from_list(eval[2], " "));
  elseif (!(typeof(eval[2]) in {STR, LIST, OBJ}))
    player:tell("Invalid eval result: ", toliteral(eval[2]));
  else
    player:tell("Eval result: ", toliteral(eval[2]));
    args = (typeof(eval[2]) == LIST) ? eval[2] | {eval[2]};
  endif
endif
for test in (argstr ? args | {"here"})
  test = tostr(test);
  if (valid(dude = $string_utils:match_player(test)))
    dudes = {@dudes, dude};
  elseif (valid(room = player:lookup_room(test)))
    dudes = {@dudes, @room:contents()};
  endif
endfor
dudes = $set_utils:intersection($list_utils:remove_duplicates(dudes), connected_players());
player:tell("Now pasting to ", dudes ? $string_utils:title_list(dudes) | "nobody", ".");
lines = $command_utils:read_lines();
header = $string_utils:pronoun_sub_secure($code_utils:verb_or_property(player, "paste_header"), "") || $string_utils:center(player.name, 75, "-");
footer = $string_utils:pronoun_sub_secure($code_utils:verb_or_property(player, "paste_footer"), "") || $string_utils:center(player.name, 75, "-");
for who in (dudes)
  ((ticks_left() < 4000) || (seconds_left() < 2)) && suspend(0);
  who:tell_lines({header, @lines, footer});
endfor
dudes ? player:tell("Pasted to ", $string_utils:english_list($list_utils:map_prop(dudes, "name")), ".") | player:tell("Paste ignored.");
"Last modified Thu Apr 17 16:28:36 1997 PDT by Amalgam, #115@GOES.";
.

@verb #284:"+*" any any any
@program #284:+
string = verb[2..$];
"remove second + if it is there.";
if (string && (string[1] == "+"))
  string = string[2..$];
endif
"Mimic res*pond's behavior";
if (verb in {"+", "++"})
  if (typeof(who = this:kwik_page_respond_to()) == LIST)
    this:tell("Do you mean ", who[1].name, " or ", who[2].name, "?");
    return;
  elseif (!valid(who))
    this:tell("Nobody to respond to.");
    return;
  endif
else
  who = $string_utils:match_player(string);
endif
if (!$command_utils:player_match_failed(who, string))
  this:set_respond_to(who);
  this:set_last_paged(who);
  pfx = this:pp_prefix_msg() || tostr("(from ", player.location, ")");
  div = index(verb, "++") ? "" | " ";
  msg = tostr(pfx, " ", player.name, div, argstr);
  result = who:receive_page(msg);
  echo = (0 && this:has_perk("pageecho")) && "SCHMOO OPTION";
  if (result == 2)
    "Return an absent message, but not page_echo msg (elsewhere).";
    player:tell($string_utils:pronoun_sub(echo ? (typeof(pamsg = who:page_absent_msg()) == STR) ? pamsg | "%n is not currently logged in." | "%n is not currently logged in.", who));
  elseif (result == 1)
    if ((0 && player:pc_option("remote_emote_noecho")) && "PC OPTION")
      "Here's where page_echo would fit in.  Doesn't feel right for emotes.";
      player:tell(who.name, " has received your emote.");
    else
      player:tell("(private to ", who.name, ") ", player.name, div, argstr);
    endif
  else
    player:tell(who.name, " refused your emote.");
  endif
endif
.

@verb #284:"pp_prefix_msg" this none this
@program #284:pp_prefix_msg
":*_prefix_shm() => If the property is a list, will return a random element of that list.  Else it returns the property.  Either way, it's pronoun_sub'd.";
msg = ((typeof(prefix = this.(verb)) == LIST) && prefix) ? prefix[random($)] | prefix;
if (!msg)
  msg = (verb == "say_prefix_msg") ? "%t says," | ((verb == "pp_prefix_msg") ? "(from %l)" | msg);
endif
msg = $string_utils:substitute(msg, {{"%l", this.location.name}});
return $string_utils:pronoun_sub(msg, this);
.

@verb #284:"about" any none none
@program #284:about
"This verb added by blip (mjp@hplb.hpl.hp.com) Thu Jul  4 14:05:12 1991";
"It simply prints the contents of the message field 'about_msg' of this";
"object.  The 'about_msg' contains useful help text and info about the";
"object in question.";
set_task_perms(player);
object = $nothing;
if (dobjstr == "")
  player:tell("Usage:  about <object-or-$<something>>");
  return;
endif
if (((dobjstr[1] == "$") && ((pname = dobjstr[2..length(dobjstr)]) in properties(#0))) && (typeof(#0.(pname)) == OBJ))
  if (valid(object = #0.(pname)))
    "got an object to look at";
  else
    object = $nothing;
  endif
elseif (valid(object = $string_utils:match_object(dobjstr, player.location)))
  "got a thing to look at";
else
  object = $nothing;
endif
if (object == $nothing)
  $command_utils:object_match_failed(object, dobjstr);
elseif ($object_utils:has_property(object, "about_msg"))
  player:tell_lines($string_utils:pronoun_sub(object.about_msg, player, object));
else
  player:tell("No information available on this object.");
endif
.

@verb #284:"@setdisp*lay @cleardisp*lay @showdisp*lays" any any any rxd
@program #284:@setdisplay
if (verb[1..7] == "@setdis")
  port = 7780;
  name = "Default";
  host = $string_utils:connection_hostname(connection_name(player));
  if ((length(args) >= 1) && ((p = tonum(args[1])) != 0))
    port = p;
  endif
  if (length(args) >= 2)
    name = tostr(args[2]);
  endif
  if (length(args) >= 3)
    host = tostr(args[3]);
  endif
  disp = {name, host, tostr(port)};
  if (i = $list_utils:iassoc(name, this.displays))
    this.displays[i] = disp;
  else
    this.displays = {@this.displays, disp};
  endif
  this.displays = $list_utils:sort_alist(this.displays);
  player:tell("\"", name, "\" moograph output directed to ", host, " port ", port, ".");
  "forget any previous connections";
  this.connections = {};
elseif (verb[1..7] == "@cleard")
  name = "Default";
  if (length(args) >= 1)
    name = tostr(args[1]);
  endif
  if (i = $list_utils:iassoc(name, this.displays))
    this.displays = listdelete(this.displays, i);
    player:tell("\"", name, "\" moograph display cleared.");
  else
    player:tell("You don't have a display listed as \"", name, "\".");
  endif
else
  "@showdisplay";
  if (!this.displays)
    player:tell("You don't have any moograph displays set.");
    return;
  endif
  su = $string_utils;
  maxn = length(n = "Display Name");
  maxh = length(h = "Host");
  maxp = length(p = "Port");
  stuff = {{n, h, p}, {su:space(maxn, "-"), su:space(maxh, "-"), su:space(maxp, "-")}};
  for rec in (this.displays)
    maxn = max(maxn, length(name = tostr(rec[1])));
    maxh = max(maxh, length(host = tostr(rec[2])));
    maxp = max(maxp, length(port = tostr(rec[3])));
    stuff = {@stuff, {name, host, port}};
  endfor
  for rec in (stuff)
    player:tell(su:left(rec[1], maxn), "  ", su:left(rec[2], maxh), "  ", rec[3]);
  endfor
endif
.

"***finished***
