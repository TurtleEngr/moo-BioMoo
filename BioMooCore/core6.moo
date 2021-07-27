$Header: /repo/public.cvs/app/BioGate/BioMooCore/core6.moo,v 1.1 2021/07/27 06:44:33 bruce Exp $

>@dump #6 with create
@create $root_class named generic player:generic player
@prop #6."features" {} r #36
@prop #6."previous_connection" 0 ""
@prop #6."email_address" "" ""
@prop #6."last_disconnect_time" 0 r
@prop #6."help" 0 rc
@prop #6."more_msg" "*** More ***  %n lines left.  Do @more [rest|flush] for more." rc
@prop #6."linetask" {} r #36
;;#6.("linetask") = {0, 0}
@prop #6."linesleft" 0 r #36
@prop #6."linebuffer" {} "" #36
@prop #6."pagelen" 0 r #36
@prop #6."owned_objects" {} r
@prop #6."linelen" -79 r #36
@prop #6."current_folder" 1 c
@prop #6."all_connect_places" {} ""
@prop #6."last_connect_place" "?" ""
@prop #6."dict" {} rc
@prop #6."brief" 0 rc
@prop #6."lines" 0 c
@prop #6."page_absent_msg" "%N is not currently logged in." rc
@prop #6."pq" "its" rc
@prop #6."pqc" "Its" rc
@prop #6."page_origin_msg" "You sense that %n is looking for you in %l." rc
@prop #6."page_echo_msg" "Your message has been sent." rc
@prop #6."edit_options" {} rc
@prop #6."last_connect_time" 0 r
@prop #6."ownership_quota" 0 "" #36
@prop #6."gender" "neuter" rc
@prop #6."prc" "Itself" rc
@prop #6."ppc" "Its" rc
@prop #6."poc" "It" rc
@prop #6."psc" "It" rc
@prop #6."pr" "itself" rc
@prop #6."pp" "its" rc
@prop #6."po" "it" rc
@prop #6."ps" "it" rc
@prop #6."home" #341 rc
@prop #6."password" "impossible password to type" ""
@prop #6."gaglist" {} rc
@prop #6."paranoid" 0 rc
@prop #6."display_options" {} rc
@prop #6."verb_subs" {} rc
@prop #6."first_connect_time" 2147483647 r
@prop #6."size_quota" {} "" #36
@prop #6."last_password_time" 0 ""
@prop #6."last_connect_attempt" 0 ""
@prop #6."page_count_start_time" 799707307 r
@prop #6."web_options" {} rc
;;#6.("web_options") = {"applinkdown", "exitdetails", "map"}
@prop #6."mcp_session_info" {} c
;;#6.("mcp_session_info") = {0, "", "1.0", "", {}}
@prop #6."disk_quota" {} rc
;;#6.("disk_quota") = {50000, 0}
;;#6.("aliases") = {"generic player"}
;;#6.("description") = "You see a player who should type '@describe me as ...'."
;;#6.("object_size") = {123609, 1577149623}
;;#6.("vrml_desc") = {"WWWInline {name \"http://hppsda.mayfield.hp.com/image/body.wrl\"}", ""}

@verb #6:"init_for_core" this none this
@program #6:init_for_core
if (caller_perms().wizard)
  pass();
  this.home = (this in {$no_one, $hacker}) ? $nothing | $player_start;
  if (a = $list_utils:assoc(this, {{$prog, {$prog_help, $builtin_function_help, $verb_help, $core_help}}, {$wiz, $wiz_help}}))
    this.help = a[2];
  else
    this.help = 0;
  endif
  if (this != $player)
    for p in ({"last_connect_place", "all_connect_places", "features"})
      clear_property(this, p);
    endfor
  endif
endif
.

@verb #6:"confunc" this none this
@program #6:confunc
if (((valid(cp = caller_perms()) && (caller != this)) && (!$perm_utils:controls(cp, this))) && (caller != #0))
  return E_PERM;
endif
this:("@last-connection")();
$news:check();
.

@verb #6:"disfunc" this none this
@program #6:disfunc
if (((valid(cp = caller_perms()) && (caller != this)) && (!$perm_utils:controls(cp, this))) && (caller != #0))
  return E_PERM;
endif
this:expunge_rmm();
this:erase_paranoid_data();
this:gc_gaglist();
return;
.

@verb #6:"initialize" this none this
@program #6:initialize
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  this.help = 0;
  return pass(@args);
else
  return E_PERM;
endif
.

@verb #6:"acceptable" this none this
@program #6:acceptable
return !is_player(args[1]);
.

@verb #6:"my_huh" this none this
@program #6:my_huh
"Extra parsing of player commands.  Called by $command_utils:do_huh.";
"This version of my_huh just handles features.";
permissions = (((caller == this) || $perm_utils:controls(caller_perms(), this)) && $command_utils:validate_feature(@args)) ? this | $no_one;
"verb - obvious                 pass - would be args";
"plist - list of prepspecs that this command matches";
"dlist and ilist - likewise for dobjspecs, iobjspecs";
verb = args[1];
if ($code_utils:toint(verb))
  return;
endif
pass = args[2];
plist = {"any", prepstr ? $code_utils:full_prep(prepstr) | "none"};
dlist = dobjstr ? {"any"} | {"none", "any"};
ilist = iobjstr ? {"any"} | {"none", "any"};
for fobj in (this.features)
  if (!$recycler:valid(fobj))
    this:remove_feature(fobj);
  elseif (`valid(loc = $object_utils:has_callable_verb(fobj, verb)[1]) ! ANY => 0')
    vargs = verb_args(loc, verb);
    if ((vargs[2] in plist) && ((vargs[1] in dlist) && (vargs[3] in ilist)))
      "(got rid of notify_huh - should write a @which command)";
      "if (this.notify_huh)";
      "player:notify(tostr(\"Using \", what.name, \" (\", what, \")\"));";
      "endif";
      set_task_perms(permissions);
      fobj:(verb)(@pass);
      "Problem with verbs of the same name. If we use which=vrb in the loop instead, we have a problem with verbs that use the variable verb.";
      return 1;
    endif
  endif
  if ($command_utils:running_out_of_time())
    player:tell("You have too many features.  Parsing your command runs out of ticks while checking ", fobj.name, " (", fobj, ").");
    return 1;
  endif
endfor
.

@verb #6:"last_huh" this none this
@program #6:last_huh
":last_huh(verb,args)  final attempt to parse a command...";
set_task_perms(caller_perms());
{verb, args} = args;
if ((verb[1] == "@") && (prepstr == "is"))
  "... set or show _msg property ...";
  set_task_perms(player);
  $last_huh:(verb)(@args);
  return 1;
elseif (verb in {"give", "hand", "get", "take", "drop", "throw"})
  $last_huh:(verb)(@args);
  return 1;
else
  return 0;
endif
.

@verb #6:"my_match_object" this none this
@program #6:my_match_object
":my_match_object(string [,location])";
return $string_utils:match_object(@{@args, this.location}[1..2], this);
.

@verb #6:"tell_contents" this none this
@program #6:tell_contents
c = args[1];
if (c)
  longear = {};
  gear = {};
  width = player:linelen();
  half = width / 2;
  player:tell("Carrying:");
  for thing in (c)
    cx = tostr(" ", thing:title());
    if (length(cx) > half)
      longear = {@longear, cx};
    else
      gear = {@gear, cx};
    endif
  endfor
  player:tell_lines($string_utils:columnize(gear, 2, width));
  player:tell_lines(longear);
endif
.

@verb #6:"titlec" this none this
@program #6:titlec
return $object_utils:has_property(this, "namec") ? this.namec | this:title();
.

@verb #6:"notify" this none this
@program #6:notify
line = args[1];
if (this.pagelen)
  if (!(this in connected_players()))
    "...drop it on the floor...";
    return 0;
  elseif ((caller != this) && (!$perm_utils:controls(caller_perms(), this)))
    return E_PERM;
  endif
  "...need wizard perms if this and this.owner are different, since...";
  "...only this can notify() and only this.owner can read .linebuffer...";
  if ((player == this) && (this.linetask[2] != task_id()))
    "...player has started a new task...";
    "....linetask[2] is the taskid of the most recent player task...";
    if (this.linetask[2] != this.linetask[1])
      this.linesleft = this.pagelen - 2;
    endif
    this.linetask[2] = task_id();
  endif
  "... digest the current line...";
  if (this.linelen > 0)
    lbuf = {@this.linebuffer, @this:linesplit(line, this.linelen)};
  else
    lbuf = {@this.linebuffer, line};
  endif
  "... print out what we can...";
  if (this.linesleft)
    howmany = min(this.linesleft, length(lbuf));
    for l in (lbuf[1..howmany])
      notify(this, l);
    endfor
    this.linesleft = this.linesleft - howmany;
    lbuf[1..howmany] = {};
  endif
  if (lbuf)
    "...see if we need to say ***More***";
    if (this.linetask[1] != this.linetask[2])
      "....linetask[1] is the taskid of the most recent player task";
      "...   for which ***More*** was printed...";
      this.linetask[1] = this.linetask[2];
      fork (0)
        if (lb = this.linebuffer)
          notify(this, strsub(this.more_msg, "%n", tostr(length(lb))));
        endif
      endfork
    endif
    llen = length(lbuf);
    if (llen > 500)
      "...way too much saved text, flush some of it...";
      lbuf[1..llen - 100] = {"*** buffer overflow, lines flushed ***"};
    endif
  endif
  this.linebuffer = lbuf;
else
  if (caller != this)
    set_task_perms(caller_perms());
  endif
  if (this.linelen > 0)
    for l in (this:linesplit(line, this.linelen))
      notify(this, l);
    endfor
  else
    notify(this, line);
  endif
endif
.

@verb #6:"notify_lines" this none this
@program #6:notify_lines
if (($perm_utils:controls(caller_perms(), this) || (caller == this)) || (caller_perms() == this))
  set_task_perms(caller_perms());
  for line in ((typeof(lines = args[1]) != LIST) ? {lines} | lines)
    this:notify(tostr(line));
  endfor
else
  return E_PERM;
endif
.

@verb #6:"linesplit" this none this
@program #6:linesplit
":linesplit(line,len) => list of substrings of line";
"used by :notify to split up long lines if .linelen>0";
{line, len} = args;
cline = {};
while (length(line) > len)
  cutoff = rindex(line[1..len], " ");
  if (nospace = cutoff < ((4 * len) / 5))
    cutoff = len + 1;
    nospace = line[cutoff] != " ";
  endif
  cline = {@cline, line[1..cutoff - 1]};
  line = (nospace ? " " | "") + line[cutoff..$];
endwhile
return {@cline, line};
.

@verb #6:"linelen" this none this rxd #36
@program #6:linelen
return abs(this.linelen);
.

@verb #6:"@more" any none none
@program #6:@more
if (player != this)
  "... somebody's being sneaky...";
  "... Can't do set_task_perms(player) since we need to be `this'...";
  "... to notify and `this.owner' to change +c properties...";
  return;
elseif (!(lbuf = this.linebuffer))
  this.linesleft = this.pagelen - 2;
  notify(this, "*** No more ***");
elseif (index("flush", dobjstr || "x") == 1)
  this.linesleft = this.pagelen - 2;
  notify(this, tostr("*** Flushed ***  ", length(lbuf), " lines"));
  this.linebuffer = {};
elseif ((index("rest", dobjstr || "x") == 1) || (!this.pagelen))
  this.linesleft = this.pagelen - 2;
  for l in (lbuf)
    notify(this, l);
  endfor
  this.linebuffer = {};
else
  howmany = min(this.pagelen - 2, llen = length(lbuf = this.linebuffer));
  for l in (lbuf[1..howmany])
    notify(this, l);
  endfor
  this.linesleft = (this.pagelen - 2) - howmany;
  this.linebuffer = lbuf[howmany + 1..llen];
  if (howmany < llen)
    notify(this, strsub(this.more_msg, "%n", tostr(llen - howmany)));
    this.linetask[1] = task_id();
  endif
endif
this.linetask[2] = task_id();
.

@verb #6:"@wrap" none any none rd #36
@program #6:@wrap
if (player != this)
  "... someone is being sneaky...";
  "... Can't do set_task_perms(player) since we need to be `this'...";
  "... to notify and `this.owner' to change +c properties...";
  return;
endif
linelen = player.linelen;
if (!(prepstr in {"on", "off"}))
  player:notify("Usage:  @wrap on|off");
  player:notify(tostr("Word wrap is currently ", (linelen > 0) ? "on" | "off", "."));
  return;
endif
player.linelen = abs(linelen) * ((prepstr == "on") ? 1 | -1);
player:notify(tostr("Word wrap is now ", prepstr, "."));
.

@verb #6:"@linelen*gth" any none none rd #36
@program #6:@linelength
if (callers() ? (caller != this) && (!$perm_utils:controls(caller_perms(), this)) | (player != this))
  "... somebody is being sneaky ...";
  return;
endif
curlen = player.linelen;
wrap = curlen > 0;
wrapstr = wrap ? "on" | "off";
if (!dobjstr)
  player:notify(tostr("Usage:  ", verb, " <number>"));
  player:notify(tostr("Current line length is ", abs(curlen), ".  Word wrapping is ", wrapstr, "."));
  return;
endif
newlen = toint(dobjstr);
if (newlen < 0)
  player:notify("Line length can't be a negative number.");
  return;
elseif (newlen < 10)
  player:notify("You don't want your linelength that small.  Setting it to 10.");
  newlen = 10;
endif
this:set_linelength(newlen);
player:notify(tostr("Line length is now ", abs(player.linelen), ".  Word wrapping is ", wrapstr, "."));
if (!wrap)
  player:notify("To enable word wrapping, type `@wrap on'.");
endif
.

@verb #6:"@pagelen*gth" any none none
@program #6:@pagelength
"@pagelength number  -- sets page buffering to that many lines (or 0 to turn off page buffering)";
if (player != this)
  "... somebody is being sneaky ...";
  "... Can't do set_task_perms(player) since we need to be `this'...";
  "... to notify and `this.owner' to change +c properties...";
  return;
elseif (!dobjstr)
  notify(player, tostr("Usage:  ", verb, " <number>"));
  notify(player, tostr("Current page length is ", player.pagelen, "."));
  return;
elseif (0 > (newlen = toint(dobjstr)))
  notify(player, "Page length can't be a negative number.");
  return;
elseif (newlen == 0)
  player.pagelen = 0;
  notify(player, "Page buffering off.");
  if (lb = this.linebuffer)
    "queued text remains";
    this:notify_lines(lb);
    clear_property(this, "linebuffer");
  endif
elseif (newlen < 5)
  player.pagelen = 5;
  notify(player, "Too small.  Setting it to 5.");
else
  notify(player, tostr("Page length is now ", player.pagelen = newlen, "."));
endif
if (this.linebuffer)
  notify(this, strsub(this.more_msg, "%n", tostr(length(this.linebuffer))));
  player.linetask = {task_id(), task_id()};
  player.linesleft = 0;
else
  player.linetask = {0, task_id()};
  player.linesleft = player.pagelen - 2;
endif
.

@verb #6:"tell" this none this
@program #6:tell
if (this.gaglist || this.paranoid)
  "Check the above first, default case, to save ticks.  Paranoid gaggers are cost an extra three or so ticks by this, probably a net savings.";
  if (this:gag_p())
    return;
  endif
  if (this.paranoid == 1)
    $paranoid_db:add_data(this, {{@callers(), {player, "<cmd-line>", player}}, args});
  elseif (this.paranoid == 2)
    z = this:whodunnit({@callers(), {player, "", player}}, {this, $no_one}, {})[3];
    args = {"(", z.name, " ", z, ") ", @args};
  endif
endif
pass(@args);
.

@verb #6:"gag_p" this none this
@program #6:gag_p
if (player in this.gaglist)
  return 1;
elseif (gag = this.gaglist)
  for x in (callers())
    if (((x[1] == #-1) && (x[3] == #-1)) && (x[2] != ""))
    elseif ((x[1] in gag) || (x[4] in gag))
      return 1;
    endif
  endfor
endif
return 0;
"--- old definition --";
if (player in this.gaglist)
  return 1;
elseif (this.gaglist)
  for x in (callers())
    if (valid(x[1]))
      if (x[1] in this.gaglist)
        return 1;
      endif
    endif
  endfor
endif
return 0;
.

@verb #6:"set_gaglist" this none this
@program #6:set_gaglist
":set_gaglist(@newlist) => this.gaglist = newlist";
if (!((caller == this) || $perm_utils:controls(caller_perms(), this)))
  return E_PERM;
else
  return this.gaglist = args;
endif
.

@verb #6:"@gag*!" any any any
@program #6:@gag!
set_task_perms(player);
if (player != this)
  player:notify("Permission denied.");
  return;
endif
if (!args)
  player:notify(tostr("Usage:  ", verb, " <player or object> [<player or object>...]"));
  return;
endif
victims = $string_utils:match_player_or_object(@args);
changed = 0;
for p in (victims)
  if (p in player.gaglist)
    player:notify(tostr("You are already gagging ", p.name, "."));
  elseif (p == player)
    player:notify("Gagging yourself is a bad idea.");
  elseif (children(p) && (verb != "@gag!"))
    player:tell("If you really want to gag all descendents of ", $string_utils:nn(p), ", use `@gag! ", p, "' instead.");
  else
    changed = 1;
    player:set_gaglist(@setadd(this.gaglist, p));
  endif
endfor
if (changed)
  this:("@listgag")();
endif
.

@verb #6:"@listgag @gaglist @gagged" any none none rxd
@program #6:@listgag
set_task_perms(valid(caller_perms()) ? caller_perms() | player);
if (!this.gaglist)
  player:notify(tostr("You are ", callers() ? "no longer gagging anything." | "not gagging anything right now."));
else
  player:notify(tostr("You are ", callers() ? "now" | "currently", " gagging ", $string_utils:english_list($list_utils:map_arg(2, $string_utils, "pronoun_sub", "%n (%#)", this.gaglist)), "."));
endif
gl = {};
if (args)
  player:notify("Searching for players who may be gagging you...");
  for p in (players())
    if ((typeof(`p.gaglist ! E_PERM') == LIST) && (this in p.gaglist))
      gl = {@gl, p};
    endif
    $command_utils:suspend_if_needed(10, "...searching gaglist...");
  endfor
  if (gl || (!callers()))
    player:notify(tostr($string_utils:english_list($list_utils:map_arg(2, $string_utils, "pronoun_sub", "%n (%#)", gl), "No one"), " appear", (length(gl) <= 1) ? "s" | "", " to be gagging you."));
  endif
endif
.

@verb #6:"@ungag" any none none rxd
@program #6:@ungag
if ((player != this) || ((caller != this) && (!$perm_utils:controls(caller_perms(), this))))
  player:notify("Permission denied.");
elseif (dobjstr == "")
  player:notify(tostr("Usage:  ", verb, " <player>  or  ", verb, " everyone"));
elseif (dobjstr == "everyone")
  this.gaglist = {};
  player:notify("You are no longer gagging anyone or anything.");
else
  if (valid(dobj))
    match = dobj;
  elseif ((match = toobj(dobjstr)) > #0)
  else
    match = $string_utils:match(dobjstr, this.gaglist, "name", this.gaglist, "aliases");
  endif
  if (match == $failed_match)
    player:notify(tostr("You don't seem to be gagging anything named ", dobjstr, "."));
  elseif (match == $ambiguous_match)
    player:notify(tostr("I don't know which \"", dobjstr, "\" you mean."));
  else
    this.gaglist = setremove(this.gaglist, match);
    player:notify(tostr(valid(match) ? match.name | match, " removed from gag list."));
  endif
  this:("@listgag")();
endif
.

@verb #6:"whodunnit" this none this
@program #6:whodunnit
{record, trust, mistrust} = args;
s = {this, "???", this};
for w in (record)
  if (((((!valid(s[3])) || s[3].wizard) || (s[3] in trust)) && (!(s[3] in mistrust))) || (s[1] == this))
    s = w;
  else
    return s;
  endif
endfor
return s;
.

@verb #6:"@ch*eck-full" any any any
@program #6:@check-full
responsible = $paranoid_db:get_data(this);
if (length(verb) <= 6)
  "@check, not @check-full";
  n = 5;
  trust = {this, $no_one};
  "... trust no one, my friend.... no one....  --Herod";
  mistrust = {};
  for k in (args)
    if (z = $code_utils:toint(k))
      n = z;
    elseif (k[1] == "!")
      mistrust = listappend(mistrust, $string_utils:match_player(k[2..$]));
    else
      trust = listappend(trust, $string_utils:match_player(k));
    endif
  endfor
  msg_width = player:linelen() - 60;
  for q in ((n > (y = length(responsible))) ? responsible | responsible[(y - n) + 1..y])
    msg = tostr(@q[2]);
    if (length(msg) > msg_width)
      msg = msg[1..msg_width];
    endif
    s = this:whodunnit(q[1], trust, mistrust);
    text = valid(s[1]) ? s[1].name | "** NONE **";
    this:notify(tostr($string_utils:left(tostr((length(text) > 13) ? text[1..13] | text, " (", s[1], ")"), 20), $string_utils:left(s[2], 15), $string_utils:left(tostr((length(s[3].name) > 13) ? s[3].name[1..13] | s[3].name, " (", s[3], ")"), 20), msg));
  endfor
  this:notify("*** finished ***");
else
  "@check-full, from @traceback by APHiD";
  "s_i_n's by Ho_Yan 10/18/94";
  matches = {};
  if (length(match = argstr) == 0)
    player:notify(tostr("Usage: ", verb, " <string> --or-- ", verb, " <number>"));
    return;
  endif
  if (!responsible)
    player:notify("No text has been saved by the monitor.  (See `help @paranoid').");
  else
    if (typeof(x = $code_utils:toint(argstr)) == ERR)
      for line in (responsible)
        if (index(tostr(@line[$]), argstr))
          matches = {@matches, line};
        endif
      endfor
    else
      matches = responsible[($ - x) + 1..$];
    endif
    if (matches)
      for match in (matches)
        $command_utils:suspend_if_needed(3);
        text = tostr(@match[$]);
        player:notify("Traceback for:");
        player:notify(text);
        "Moved cool display code to $code_utils, 3/29/95, Ho_Yan";
        $code_utils:display_callers(listdelete(mm = match[1], length(mm)));
      endfor
      player:notify("**** finished ****");
    else
      player:notify(tostr("No matches for \"", argstr, "\" found."));
    endif
  endif
endif
.

@verb #6:"@paranoid" any any any
@program #6:@paranoid
if ((args == {}) || ((typ = args[1]) == ""))
  $paranoid_db:set_kept_lines(this, 10);
  this.paranoid = 1;
  this:notify("Anti-spoofer on and keeping 10 lines.");
elseif (index("immediate", typ))
  $paranoid_db:set_kept_lines(this, 0);
  this.paranoid = 2;
  this:notify("Anti-spoofer now in immediate mode.");
elseif (index("off", typ) || (typ == "0"))
  this.paranoid = 0;
  $paranoid_db:set_kept_lines(this, 0);
  this:notify("Anti-spoofer off.");
elseif ((tostr(y = toint(typ)) != typ) || (y < 0))
  this:notify(tostr("Usage: ", verb, " <lines to be kept>     to turn on your anti-spoofer."));
  this:notify(tostr("       ", verb, " off                    to turn it off."));
  this:notify(tostr("       ", verb, " immediate              to use immediate mode."));
else
  this.paranoid = 1;
  $paranoid_db:set_kept_lines(this, y = min(y, 30));
  this:notify(tostr("Anti-spoofer on and keeping ", y, " lines."));
endif
.

@verb #6:"@sw*eep" none none none
@program #6:@sweep
buggers = 1;
found_listener = 0;
here = this.location;
for thing in (setremove(here.contents, this))
  tellwhere = $object_utils:has_verb(thing, "tell");
  notifywhere = $object_utils:has_verb(thing, "notify");
  if (thing in connected_players())
    this:notify(tostr(thing.name, " (", thing, ") is listening."));
    found_listener = 1;
  elseif ($object_utils:has_callable_verb(thing, "sweep_msg") && (typeof(msg = thing:sweep_msg()) == STR))
    this:notify(tostr(thing.name, " (", thing, ") ", msg, "."));
    found_listener = 1;
  elseif (tellwhere && (((owner = verb_info(tellwhere[1], "tell")[1]) != this) && (!owner.wizard)))
    this:notify(tostr(thing.name, " (", thing, ") has been taught to listen by ", owner.name, " (", owner, ")"));
    found_listener = 1;
  elseif (notifywhere && (((owner = verb_info(notifywhere[1], "notify")[1]) != this) && (!owner.wizard)))
    this:notify(tostr(thing.name, " (", thing, ") has been taught to listen by ", owner.name, " (", owner, ")"));
    found_listener = 1;
  endif
endfor
buggers = {};
for v in ({"announce", "announce_all", "announce_all_but", "say", "emote", "huh", "here_huh", "huh2", "whisper", "here_explain_syntax"})
  vwhere = $object_utils:has_verb(here, v);
  if (vwhere && (((owner = verb_info(vwhere[1], v)[1]) != this) && (!owner.wizard)))
    buggers = setadd(buggers, owner);
  endif
endfor
if (buggers != {})
  if ($object_utils:has_verb(here, "sweep_msg") && (typeof(msg = here:sweep_msg()) == STR))
    this:notify(tostr(here.name, " (", here, ") ", msg, "."));
  else
    this:notify(tostr(here.name, " (", here, ") may have been bugged by ", $string_utils:english_list($list_utils:map_prop(buggers, "name")), "."));
  endif
elseif (!found_listener)
  this:notify("Communications look secure.");
endif
.

@verb #6:"wh*isper" any to this rxd
@program #6:whisper
this:tell(player.name, " whispers, \"", dobjstr, "\"");
player:tell("You whisper, \"", dobjstr, "\" to ", this.name, ".");
.

@verb #6:"page" any any any rxd
@program #6:page
nargs = length(args);
if (nargs < 1)
  player:notify(tostr("Usage: ", verb, " <player> [with <message>]"));
  return;
endif
who = $string_utils:match_player(args[1]);
if ($command_utils:player_match_result(who, args[1])[1])
  return;
elseif (who in this.gaglist)
  player:tell("You have ", who:title(), " @gagged.  If you paged ", $gender_utils:get_pronoun("o", who), ", ", $gender_utils:get_pronoun("s", who), " wouldn't be able to answer you.");
  return;
endif
"for pronoun_sub's benefit...";
dobj = who;
iobj = player;
header = player:page_origin_msg();
text = "";
if (nargs > 1)
  if ((args[2] == "with") && (nargs > 2))
    msg_start = 3;
  else
    msg_start = 2;
  endif
  msg = $string_utils:from_list(args[msg_start..nargs], " ");
  text = tostr($string_utils:pronoun_sub(($string_utils:index_delimited(header, player.name) ? "%S" | "%N") + " %<pages>, \""), msg, "\"");
endif
result = text ? who:receive_page(header, text) | who:receive_page(header);
if (result == 2)
  "not connected";
  player:tell((typeof(msg = who:page_absent_msg()) == STR) ? msg | $string_utils:pronoun_sub("%n is not currently logged in.", who));
else
  player:tell(who:page_echo_msg());
endif
.

@verb #6:"receive_page" this none this
@program #6:receive_page
"called by $player:page.  Two args, the page header and the text, all pre-processed by the page command.  Could be extended to provide haven abilities, multiline pages, etc.  Indeed, at the moment it just does :tell_lines, so we already do have multiline pages, if someone wants to take advantage of it.";
"Return codes:";
"  1:  page was received";
"  2:  player is not connected";
"  0:  page refused";
"If a specialization wants to refuse a page, it should return 0 to say it was refused.  If it uses pass(@args) it should propagate back up the return value.  It is possible that this code should interact with gagging and return 0 if the page was gagged.";
if (this:is_listening())
  this:tell_lines(args);
  return 1;
else
  return 2;
endif
.

@verb #6:"page_origin_msg page_echo_msg page_absent_msg" this none this rxd #36
@program #6:page_origin_msg
"set_task_perms(this.owner)";
return (msg = `this.(verb) ! ANY') ? $string_utils:pronoun_sub(this.(verb), this) | "";
.

@verb #6:"i inv*entory" none none none
@program #6:i
if (c = player:contents())
  this:tell_contents(c);
else
  player:tell("You are empty-handed.");
endif
.

@verb #6:"look_self" this none this
@program #6:look_self
player:tell(this:titlec());
pass();
if (!(this in connected_players()))
  player:tell($gender_utils:pronoun_sub("%{:He} %{!is} sleeping.", this));
elseif ((idle = idle_seconds(this)) < 60)
  player:tell($gender_utils:pronoun_sub("%{:He} %{!is} awake and %{!looks} alert.", this));
else
  time = $string_utils:from_seconds(idle);
  player:tell($gender_utils:pronoun_sub("%{:He} %{!is} awake, but %{!has} been staring off into space for ", this), time, ".");
endif
if (c = this:contents())
  this:tell_contents(c);
endif
.

@verb #6:"home" none none none rxd
@program #6:home
if ((caller != this) && (!$perm_utils:controls(caller_perms(), this)))
  return E_PERM;
endif
start = this.location;
if (start == this.home)
  player:tell("You're already home!");
  return;
elseif (typeof(this.home) != OBJ)
  player:tell("You've got a weird home, pal.  I've reset it to the default one.");
  this.home = $player_start;
elseif (!valid(this.home))
  player:tell("Oh no!  Your home's been recycled.  Time to look around for a new one.");
  this.home = $player_start;
else
  player:tell("You click your heels three times.");
endif
this:moveto(this.home);
if (!valid(start))
elseif (start == this.location)
  start:announce(player.name, " ", $gender_utils:get_conj("learns", player), " that you can never go home...");
else
  start:announce(player.name, " ", $gender_utils:get_conj("goes", player), " home.");
endif
if (this.location == this.home)
  this.location:announce(player.name, " ", $gender_utils:get_conj("comes", player), " home.");
elseif (this.location == start)
  player:tell("Either home doesn't want you, or you don't really want to go.");
else
  player:tell("Wait a minute!  This isn't your home...");
  if (valid(this.location))
    this.location:announce(player.name, " ", $gender_utils:get_conj("arrives", player), ", looking quite bewildered.");
  endif
endif
.

@verb #6:"@sethome" none none none
@program #6:@sethome
set_task_perms(this);
here = this.location;
if (!$object_utils:has_callable_verb(here, "accept_for_abode"))
  player:notify("This is a pretty odd place.  You should make your home in an actual room.");
elseif (here:accept_for_abode(this))
  this.home = here;
  player:notify(tostr(here.name, " is your new home."));
else
  player:notify(tostr("This place doesn't want to be your home.  Contact ", here.owner.name, " to be added to the residents list of this place, or choose another place as your home."));
endif
.

@verb #6:"g*et take" this none none rxd
@program #6:get
player:tell("This is not a pick-up joint!");
this:tell(player.name, " tried to pick you up.");
.

@verb #6:"@move @teleport" any to any rxd
@program #6:@move
"'@move <object> to <place>' - Teleport an object. Example: '@move trash to #11' to move trash to the closet.";
set_task_perms((caller == this) ? this | $no_one);
dobj = this:my_match_object(dobjstr);
iobj = this:my_match_object(iobjstr);
if ($command_utils:object_match_failed(dobj, dobjstr) || ((iobj != $nothing) && $command_utils:object_match_failed(iobj, iobjstr)))
  return;
endif
if ((!$perm_utils:controls(this, dobj)) && (this != dobj))
  player:tell("You may only @move your own things.");
  return;
endif
old_loc = dobj.location;
if (old_loc == iobj)
  player:tell(dobj.name, " is already ", valid(iobj) ? "in " + iobj.name | "nowhere", ".");
  return;
endif
dobj:moveto(iobj);
if (dobj.location == iobj)
  player:tell("Moved.");
  if (is_player(dobj))
    if (valid(old_loc))
      old_loc:announce_all(dobj.name, " disappears suddenly for parts unknown.");
      if (dobj != player)
        dobj:tell("You have been moved by ", player.name, ".");
      endif
    endif
    if (valid(dobj.location))
      dobj.location:announce(dobj.name, " materializes out of thin air.");
    endif
  endif
elseif (dobj.location == old_loc)
  if ($object_utils:contains(dobj, iobj))
    player:tell(iobj.name, " is inside of ", dobj.name, "!");
  else
    player:tell($string_utils:pronoun_sub("Either %d doesn't want to go, or %i doesn't want to accept %[dpo]."));
  endif
elseif (dobj == player)
  player:tell("You have been deflected from your original destination.");
else
  player:tell($string_utils:pronoun_sub("%D has been deflected from %[dpp] original destination."));
endif
.

@verb #6:"@eject @eject! @eject!!" any from any
@program #6:@eject
set_task_perms(player);
if (iobjstr == "here")
  iobj = player.location;
elseif (iobjstr == "me")
  iobj = player;
elseif ($command_utils:object_match_failed(iobj, iobjstr))
  return;
endif
if (!$perm_utils:controls(player, iobj))
  player:notify(tostr("You are not the owner of ", iobj.name, "."));
  return;
endif
if (dobjstr == "me")
  dobj = player;
elseif (($failed_match == (dobj = $string_utils:literal_object(dobjstr))) && $command_utils:object_match_failed(dobj = iobj:match(dobjstr), dobjstr))
  return;
endif
if (dobj.location != iobj)
  player:notify(tostr(dobj.name, "(", dobj, ") is not in ", iobj.name, "(", iobj, ")."));
  return;
endif
if (dobj.wizard)
  player:notify(tostr("Sorry, you can't ", verb, " a wizard."));
  dobj:tell(player.name, " tried to ", verb, " you.");
  return;
endif
iobj:((verb == "@eject") ? "eject" | "eject_basic")(dobj);
player:notify($object_utils:has_callable_verb(iobj, "ejection_msg") ? iobj:ejection_msg() | $room:ejection_msg());
if (verb != "@eject!!")
  dobj:tell($object_utils:has_callable_verb(iobj, "victim_ejection_msg") ? iobj:victim_ejection_msg() | $room:victim_ejection_msg());
endif
iobj:announce_all_but({player, dobj}, $object_utils:has_callable_verb(iobj, "oejection_msg") ? iobj:oejection_msg() | $room:oejection_msg());
.

@verb #6:"where*is @where*is" any any any rxd
@program #6:whereis
if (!args)
  them = connected_players();
else
  who = $command_utils:player_match_result($string_utils:match_player(args), args);
  if (length(who) <= 1)
    if (!who[1])
      player:notify("Where is who?");
    endif
    return;
  elseif (who[1])
    player:notify("");
  endif
  them = listdelete(who, 1);
endif
lmax = rmax = 0;
for p in (them)
  player:notify(tostr($string_utils:left($string_utils:nn(p), 25), " ", $string_utils:nn(p.location)));
endfor
.

@verb #6:"@who" any any any rxd
@program #6:@who
if (caller != player)
  return E_PERM;
endif
plyrs = args ? listdelete($command_utils:player_match_result($string_utils:match_player(args), args), 1) | connected_players();
if (!plyrs)
  return;
elseif (length(plyrs) > 100)
  player:tell("You have requested a listing of ", length(plyrs), " players.  Please either specify individual players you are interested in, to reduce the number of players in any single request, or else use the `@users' command instead.  The lag thanks you.");
  return;
endif
$code_utils:show_who_listing(plyrs);
.

@verb #6:"@wizards" any none none rxd
@program #6:@wizards
"@wizards [all]";
if (caller != player)
  return E_PERM;
endif
if (args)
  $code_utils:show_who_listing($wiz_utils:all_wizards());
else
  $code_utils:show_who_listing($wiz_utils:connected_wizards()) || player:notify("No wizards currently logged in.");
endif
.

@verb #6:"?* help info*rmation @help" any any any rxd
@program #6:?
set_task_perms(callers() ? caller_perms() | player);
"...this code explicitly relies on being !d in several places...";
if ((index(verb, "?") != 1) || (length(verb) <= 1))
  what = $string_utils:trimr(argstr);
elseif (argstr)
  what = tostr(verb[2..$], " ", $string_utils:trimr(argstr));
else
  what = verb[2..$];
endif
"...find a db that claims to know about `what'...";
dblist = $code_utils:help_db_list();
result = $code_utils:help_db_search(what, dblist);
if (!result)
  "... note: all of the last-resort stuff...";
  "... is now located on $help:find_topics/get_topic...";
  $wiz_utils:missed_help(what, result);
  player:notify(tostr("Sorry, but no help is available on `", what, "'."));
elseif (result[1] == $ambiguous_match)
  $wiz_utils:missed_help(what, result);
  player:notify_lines(tostr("Sorry, but the topic-name `", what, "' is ambiguous.  I don't know which of the following topics you mean:"));
  for x in ($help:columnize(@$help:sort_topics(result[2])))
    player:notify(tostr("   ", x));
  endfor
else
  {help, topic} = result;
  if (topic != what)
    player:notify(tostr("Showing help on `", topic, "':"));
    player:notify("----");
  endif
  dblist = dblist[1 + (help in dblist)..$];
  if (1 == (text = help:get_topic(topic, dblist)))
    "...get_topic took matters into its own hands...";
  elseif (text)
    "...these can get long...";
    for line in ((typeof(text) == LIST) ? text | {text})
      if (typeof(line) != STR)
        player:notify("Odd results from help -- complain to a wizard.");
      else
        player:notify(line);
      endif
      $command_utils:suspend_if_needed(0);
    endfor
  else
    player:notify(tostr("Help DB ", help, " thinks it knows about `", what, "' but something's messed up."));
    player:notify(tostr("Tell ", help.owner.wizard ? "" | tostr(help.owner.name, " (", help.owner, ") or "), "a wizard."));
  endif
endif
.

@verb #6:"display_option" this none this
@program #6:display_option
":display_option(name) => returns the value of the specified @display option";
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  return $display_options:get(this.display_options, args[1]);
else
  return E_PERM;
endif
.

@verb #6:"edit_option" this none this
@program #6:edit_option
":edit_option(name) => returns the value of the specified edit option";
if ((caller == this) || ($object_utils:isa(caller, $generic_editor) || $perm_utils:controls(caller_perms(), this)))
  return $edit_options:get(this.edit_options, args[1]);
else
  return E_PERM;
endif
.

@verb #6:"set_mail_option set_edit_option set_display_option set_web_option" this none this
@program #6:set_mail_option
":set_edit_option(oname,value)";
":set_display_option(oname,value)";
":set_mail_option(oname,value)";
"Changes the value of the named option.";
"Returns a string error if something goes wrong.";
if (!((caller == this) || $perm_utils:controls(caller_perms(), this)))
  return tostr(E_PERM);
endif
"...this is kludgy, but it saves me from writing the same verb 3 times.";
"...there's got to be a better way to do this...";
verb[1..4] = "";
foo_options = verb + "s";
"...";
if (typeof(s = #0.(foo_options):set(this.(foo_options), @args)) == STR)
  return s;
elseif (s == this.(foo_options))
  return 0;
else
  this.(foo_options) = s;
  return 1;
endif
.

@verb #6:"@mailo*ptions @mail-o*ptions @edito*ptions @edit-o*ptions @displayo*ptions @display-o*ptions @webop*tions @web-op*tions" any any any
@program #6:@mailoptions
"@<what>-option <option> [is] <value>   sets <option> to <value>";
"@<what>-option <option>=<value>        sets <option> to <value>";
"@<what>-option +<option>     sets <option>   (usually equiv. to <option>=1";
"@<what>-option -<option>     resets <option> (equiv. to <option>=0)";
"@<what>-option !<option>     resets <option> (equiv. to <option>=0)";
"@<what>-option <option>      displays value of <option>";
set_task_perms(player);
what = {"mail", "edit", "display", "web"}[index("medw", verb[2])];
options = what + "_options";
option_pkg = #0.(options);
set_option = ("set_" + what) + "_option";
if (!args)
  player:notify_lines({("Current " + what) + " options:", "", @option_pkg:show(this.(options), option_pkg.names)});
  return;
elseif (typeof(presult = option_pkg:parse(args)) == STR)
  player:notify(presult);
  return;
else
  if (length(presult) > 1)
    if (typeof(sresult = this:(set_option)(@presult)) == STR)
      player:notify(sresult);
      return;
    elseif (!sresult)
      player:notify("No change.");
      return;
    endif
  endif
  player:notify_lines(option_pkg:show(this.(options), presult[1]));
endif
.

@verb #6:"set_name" this none this
@program #6:set_name
"set_name(newname) attempts to change this.name to newname";
"  => E_PERM   if you don't own this";
"  => E_INVARG if the name is already taken or prohibited for some reason";
"  => E_NACC   if the player database is not taking new names right now.";
"  => E_ARGS   if the name is too long (controlled by $login.max_player_name)";
if (!($perm_utils:controls(caller_perms(), this) || (this == caller)))
  return E_PERM;
elseif (!is_player(this))
  "we don't worry about the names of player classes.";
  set_task_perms(caller_perms());
  return pass(@args);
elseif ($player_db.frozen)
  return E_NACC;
elseif (length(name = args[1]) > $login.max_player_name)
  return E_ARGS;
elseif (!($player_db:available(name, this) in {this, 1}))
  return E_INVARG;
else
  old = this.name;
  this.name = name;
  if ((name != old) && (!(old in this.aliases)))
    $player_db:delete(old);
  endif
  $player_db:insert(name, this);
  return 1;
endif
.

@verb #6:"set_aliases" this none this
@program #6:set_aliases
"set_aliases(alias_list)";
"For changing player aliases, we check to make sure that none of the aliases match existing player names/aliases.  Aliases containing spaces are not entered in the $player_db and so are not subject to this restriction ($string_utils:match_player will not match on them, however, so they only match if used in the immediate room, e.g., with match_object() or somesuch).";
"Also we make sure that the .name is included in the .alias list.  In any situation where .name and .aliases are both being changed, do the name change first.";
"  => 1        if successful, and aliases changed from previous setting.";
"  => 0        if resulting work didn't change aliases from previous.";
"  => E_PERM   if you don't own this";
"  => E_NACC   if the player database is not taking new aliases right now.";
"  => E_TYPE   if alias_list is not a list";
"  => E_INVARG if any element of alias_list is not a string";
if (!($perm_utils:controls(caller_perms(), this) || (this == caller)))
  return E_PERM;
elseif (!is_player(this))
  "we don't worry about the names of player classes.";
  return pass(@args);
elseif ($player_db.frozen)
  return E_NACC;
elseif (typeof(aliases = args[1]) != LIST)
  return E_TYPE;
elseif ((length(aliases = setadd(aliases, this.name)) > ($object_utils:has_property($local, "max_player_aliases") ? $local.max_player_aliases | $maxint)) && (length(aliases) >= length(this.aliases)))
  return E_INVARG;
else
  for a in (aliases)
    if (typeof(a) != STR)
      return E_INVARG;
    endif
    if ((!(index(a, " ") || index(a, "	"))) && (!($player_db:available(a, this) in {this, 1})))
      aliases = setremove(aliases, a);
    endif
  endfor
  changed = 0;
  old = this.aliases;
  this.aliases = aliases;
  for a in (old)
    if (!(a in aliases))
      $player_db:delete2(a, this);
      changed = 1;
    endif
  endfor
  for a in (aliases)
    if (!(index(a, " ") || index(a, "	")))
      $player_db:insert(a, this);
      if (!(a in old))
        changed = 1;
      endif
    endif
  endfor
  return changed;
endif
.

@verb #6:"@rename*#" any to any
@program #6:@rename#
if ((player != caller) || (player != this))
  return;
endif
set_task_perms(player);
bynumber = verb == "@rename#";
spec = $code_utils:parse_verbref(dobjstr);
if (spec)
  if (!player.programmer)
    return player:notify(tostr(E_PERM));
  endif
  object = this:my_match_object(spec[1]);
  if (!$command_utils:object_match_failed(object, spec[1]))
    vname = spec[2];
    if (bynumber)
      vname = $code_utils:toint(vname);
      if (vname == E_TYPE)
        return player:notify("Verb number expected.");
      elseif ((vname < 1) || `vname > length(verbs(object)) ! E_PERM => 0')
        return player:notify("Verb number out of range.");
      endif
    endif
    try
      info = verb_info(object, vname);
      try
        result = set_verb_info(object, vname, listset(info, iobjstr, 3));
        player:notify("Verb name changed.");
      except e (ANY)
        player:notify(e[2]);
      endtry
    except (E_VERBNF)
      player:notify("That object does not define that verb.");
    except e (ANY)
      player:notify(e[2]);
    endtry
  endif
elseif (bynumber)
  player:notify("@rename# can only be used with verbs.");
elseif (pspec = $code_utils:parse_propref(dobjstr))
  if (!player.programmer)
    return player:notify(tostr(E_PERM));
  endif
  object = this:my_match_object(pspec[1]);
  if (!$command_utils:object_match_failed(object, pspec[1]))
    pname = pspec[2];
    try
      info = property_info(object, pname);
      try
        result = set_property_info(object, pname, {@info, iobjstr});
        player:notify("Property name changed.");
      except e (ANY)
        player:notify(e[2]);
      endtry
    except (E_PROPNF)
      player:notify("That object does not define that property.");
    except e (ANY)
      player:notify(e[2]);
    endtry
  endif
else
  object = this:my_match_object(dobjstr);
  if (!$command_utils:object_match_failed(object, dobjstr))
    old_name = object.name;
    old_aliases = object.aliases;
    if (e = $building_utils:set_names(object, iobjstr))
      if (strcmp(object.name, old_name) == 0)
        name_message = tostr("Name of ", object, " (", old_name, ") is unchanged");
      else
        name_message = tostr("Name of ", object, " changed to \"", object.name, "\"");
      endif
      aliases = $string_utils:from_value(object.aliases, 1);
      if (object.aliases == old_aliases)
        alias_message = tostr(".  Aliases are unchanged (", aliases, ").");
      else
        alias_message = tostr(", with aliases ", aliases, ".");
      endif
      player:notify(name_message + alias_message);
    elseif (e == E_INVARG)
      player:notify("That particular name change not allowed (see help @rename).");
      if (object == player)
        player:notify($player_db:why_bad_name(player, iobjstr));
      endif
    elseif (e == E_NACC)
      player:notify("Oops.  You can't update that name right now; try again in a few minutes.");
    elseif (e == E_ARGS)
      player:notify(tostr("Sorry, name too long.  Maximum number of characters in a name:  ", $login.max_player_name));
    elseif (e == 0)
      player:notify("Name and aliases remain unchanged.");
    else
      player:notify(tostr(e));
    endif
  endif
endif
.

@verb #6:"@addalias*# @add-alias*#" any to any
@program #6:@addalias#
"Syntax: @addalias <alias>[,...,<alias>] to <object>";
"        @addalias <alias>[,...,<alias>] to <object>:<verb>";
"";
"The first form is used to add aliases to an object's list of aliases.  You can separate multiple aliases with commas.  The aliases will be checked against the object's current aliases and all aliases not already in the object's list of aliases will be added.";
"";
"Example:";
"Muchkin wants to add new aliases to Rover the Wonder Dog:";
"  @addalias Dog,Wonder Dog to Rover";
"Since Rover the Wonder Dog already has the alias \"Dog\" but does not have the alias \"Wonder Dog\", Munchkin sees:";
"  Rover the Wonder Dog(#4237) already has the alias Dog.";
"  Alias Wonder Dog added to Rover the Wonder Dog(#4237).";
"";
"If the object is a player, spaces will also be assumed to be separations between aliases and each alias will be checked against the Player Name Database to make sure no one else is using it. Any already used aliases will be identified.";
"";
"Example:";
"Munchkin wants to add his nicknames to his own list of aliases:";
"  @addalias Foobar Davey to me";
"@Addalias recognizes that Munchkin is trying to add an alias to a valid player and checks the aliases against the Player Name Database.  Unfortunately, DaveTheMan is already using the alias \"Davey\" so Munchkin sees:";
"  DaveTheMan(#5432) is already using the alias Davey";
"  Alias Foobar added to Munchkin(#1523).";
"";
"The second form of the @addalias command is for use by programmers, to add aliases to a verb they own.  All commas and spaces are assumed to be separations between aliases.";
if (player != this)
  return;
endif
set_task_perms(player);
bynumber = verb[$] == "#";
spec = $code_utils:parse_verbref(iobjstr);
if (spec)
  if (!player.programmer)
    return player:notify(tostr(E_PERM));
  endif
  object = player:my_match_object(spec[1]);
  if (!$command_utils:object_match_failed(object, spec[1]))
    vname = spec[2];
    if (bynumber)
      if ((vname = $code_utils:toint(vname)) == E_TYPE)
        return player:notify("Verb number expected.");
      elseif ((vname < 1) || `vname > length(verbs(object)) ! E_PERM => 0')
        return player:notify("Verb number out of range.");
      endif
    endif
    try
      info = verb_info(object, vname);
      old_aliases = $string_utils:explode(info[3]);
      used = {};
      for alias in (new_aliases = $list_utils:remove_duplicates($string_utils:explode(strsub(dobjstr, ",", " "))))
        if (alias in old_aliases)
          used = {@used, alias};
          new_aliases = setremove(new_aliases, alias);
        endif
      endfor
      if (used)
        player:notify(tostr(object.name, "(", object, "):", vname, " already has the alias", (length(used) > 1) ? "es" | "", " ", $string_utils:english_list(used), "."));
      endif
      if (new_aliases)
        info = listset(info, aliases = $string_utils:from_list({@old_aliases, @new_aliases}, " "), 3);
        try
          result = set_verb_info(object, vname, info);
          player:notify(tostr("Alias", (length(new_aliases) > 1) ? "es" | "", " ", $string_utils:english_list(new_aliases), " added to verb ", object.name, "(", object, "):", vname));
          player:notify(tostr("Verbname is now ", object.name, "(", object, "):\"", aliases, "\""));
        except e (ANY)
          player:notify(e[2]);
        endtry
      endif
    except (E_VERBNF)
      player:notify("That object does not define that verb.");
    except e (ANY)
      player:notify(e[2]);
    endtry
  endif
elseif (bynumber)
  player:notify(tostr(verb, " can only be used with verbs."));
else
  object = player:my_match_object(iobjstr);
  if (!$command_utils:object_match_failed(object, iobjstr))
    old_aliases = object.aliases;
    used = {};
    for alias in (new_aliases = $list_utils:remove_duplicates($list_utils:map_arg($string_utils, "trim", $string_utils:explode(is_player(object) ? strsub(dobjstr, " ", ",") | dobjstr, ","))))
      if (alias in old_aliases)
        used = {@used, alias};
        new_aliases = setremove(new_aliases, alias);
      elseif (is_player(object) && valid(someone = $player_db:find_exact(alias)))
        player:notify(tostr(someone.name, "(", someone, ") is already using the alias ", alias, "."));
        new_aliases = setremove(new_aliases, alias);
      endif
    endfor
    if (used)
      player:notify(tostr(object.name, "(", object, ") already has the alias", (length(used) > 1) ? "es" | "", " ", $string_utils:english_list(used), "."));
    endif
    if (new_aliases)
      if ((e = object:set_aliases(aliases = {@old_aliases, @new_aliases})) && (object.aliases == aliases))
        player:notify(tostr("Alias", (length(new_aliases) > 1) ? "es" | "", " ", $string_utils:english_list(new_aliases), " added to ", object.name, "(", object, ")."));
        player:notify(tostr("Aliases for ", $string_utils:nn(object), " are now ", $string_utils:from_value(aliases, 1)));
      elseif (e)
        player:notify("That particular name change not allowed (see help @rename or help @addalias).");
      elseif (e == E_INVARG)
        if ($object_utils:has_property(#0, "local"))
          if ($object_utils:has_property($local, "max_player_aliases"))
            max = $local.max_player_aliases;
            player:notify(("You are not allowed more than " + tostr(max)) + " aliases.");
          endif
        else
          player:notify("You are not allowed any more aliases.");
        endif
      elseif (e == E_NACC)
        player:notify("Oops.  You can't update that object's aliases right now; try again in a few minutes.");
      elseif (e == 0)
        player:notify("Aliases not changed as expected!");
        player:notify(tostr("Aliases for ", $string_utils:nn(object), " are now ", $string_utils:from_value(object.aliases, 1)));
      else
        player:notify(tostr(e));
      endif
    endif
  endif
endif
.

@verb #6:"@rmalias*# @rm-alias*#" any from any
@program #6:@rmalias#
"Syntax: @rmalias <alias>[,...,<alias>] from <object>";
"        @rmalias <alias>[,...,<alias>] from <object>:<verb>";
"";
"The first form is used to remove aliases from an object.  If the object is a valid player, space and commas will be assumed to be separations between unwanted aliases.  Otherwise, only commas will be assumed to be separations.";
"[5/10/93 Nosredna: flushed above is_player feature";
"Note that @rmalias will not affect the object's name, only its aliases.";
"";
"The second form is for use by programmers, to remove aliases from a verb they own.  All spaces and commas are assumed to be separations between unwanted aliases.";
if (player != this)
  return;
endif
set_task_perms(player);
bynumber = verb[$] == "#";
spec = $code_utils:parse_verbref(iobjstr);
if (spec)
  if (!player.programmer)
    player:notify(tostr(E_PERM));
  endif
  object = player:my_match_object(spec[1]);
  if (!$command_utils:object_match_failed(object, spec[1]))
    vname = spec[2];
    if (bynumber)
      if ((vname = $code_utils:toint(vname)) == E_TYPE)
        return player:notify("Verb number expected.");
      elseif ((vname < 1) || `vname > length(verbs(object)) ! E_PERM => 0')
        return player:notify("Verb number out of range.");
      endif
    endif
    try
      info = verb_info(object, vname);
      old_aliases = $string_utils:explode(info[3]);
      not_used = {};
      for alias in (bad_aliases = $list_utils:remove_duplicates($string_utils:explode(strsub(dobjstr, ",", " "))))
        if (!(alias in old_aliases))
          not_used = {@not_used, alias};
          bad_aliases = setremove(bad_aliases, alias);
        else
          old_aliases = setremove(old_aliases, alias);
        endif
      endfor
      if (not_used)
        player:notify(tostr(object.name, "(", object, "):", vname, " does not have the alias", (length(not_used) > 1) ? "es" | "", " ", $string_utils:english_list(not_used), "."));
      endif
      if (bad_aliases && old_aliases)
        info = listset(info, aliases = $string_utils:from_list(old_aliases, " "), 3);
        try
          result = set_verb_info(object, vname, info);
          player:notify(tostr("Alias", (length(bad_aliases) > 1) ? "es" | "", " ", $string_utils:english_list(bad_aliases), " removed from verb ", object.name, "(", object, "):", vname));
          player:notify(tostr("Verbname is now ", object.name, "(", object, "):\"", aliases, "\""));
        except e (ANY)
          player:notify(e[2]);
        endtry
      elseif (!old_aliases)
        player:notify("You have to leave a verb with at least one alias.");
      endif
    except (E_VERBNF)
      player:notify("That object does not define that verb.");
    except e (ANY)
      player:notify(e[2]);
    endtry
  endif
elseif (bynumber)
  player:notify(tostr(verb, " can only be used with verbs."));
else
  object = player:my_match_object(iobjstr);
  if (!$command_utils:object_match_failed(object, iobjstr))
    old_aliases = object.aliases;
    not_used = {};
    for alias in (bad_aliases = $list_utils:remove_duplicates($list_utils:map_arg($string_utils, "trim", $string_utils:explode(dobjstr, ","))))
      "removed is_player(object) ? strsub(dobjstr, \" \", \",\") | --Nosredna";
      if (!(alias in old_aliases))
        not_used = {@not_used, alias};
        bad_aliases = setremove(bad_aliases, alias);
      else
        old_aliases = setremove(old_aliases, alias);
      endif
    endfor
    if (not_used)
      player:notify(tostr(object.name, "(", object, ") does not have the alias", (length(not_used) > 1) ? "es" | "", " ", $string_utils:english_list(not_used), "."));
    endif
    if (bad_aliases)
      if (e = object:set_aliases(old_aliases))
        player:notify(tostr("Alias", (length(bad_aliases) > 1) ? "es" | "", " ", $string_utils:english_list(bad_aliases), " removed from ", object.name, "(", object, ")."));
        player:notify(tostr("Aliases for ", object.name, "(", object, ") are now ", $string_utils:from_value(old_aliases, 1)));
      elseif (e == E_INVARG)
        player:notify("That particular name change not allowed (see help @rename or help @rmalias).");
      elseif (e == E_NACC)
        player:notify("Oops.  You can't update that object's aliases right now; try again in a few minutes.");
      elseif (e == 0)
        player:notify("Aliases not changed as expected!");
        player:notify(tostr("Aliases for ", $string_utils:nn(object), " are ", $string_utils:from_value(object.aliases, 1)));
      else
        player:notify(tostr(e));
      endif
    endif
  endif
endif
.

@verb #6:"@desc*ribe" any as any
@program #6:@describe
set_task_perms(player);
dobj = player:my_match_object(dobjstr);
if ($command_utils:object_match_failed(dobj, dobjstr))
  "...lose...";
elseif (e = dobj:set_description(iobjstr))
  player:notify("Description set.");
else
  player:notify(tostr(e));
endif
.

@verb #6:"@mess*ages" any none none
@program #6:@messages
set_task_perms(player);
if (dobjstr == "")
  player:notify(tostr("Usage:  ", verb, " <object>"));
  return;
endif
dobj = player:my_match_object(dobjstr);
if ($command_utils:object_match_failed(dobj, dobjstr))
  return;
endif
found_one = 0;
props = $object_utils:all_properties(dobj);
if (typeof(props) == ERR)
  player:notify("You can't read the messages on that.");
  return;
endif
for pname in (props)
  len = length(pname);
  if ((len > 4) && (pname[len - 3..len] == "_msg"))
    found_one = 1;
    msg = `dobj.(pname) ! ANY';
    if (msg == E_PERM)
      value = "isn't readable by you.";
    elseif (!msg)
      value = "isn't set.";
    elseif (typeof(msg) == LIST)
      value = "is a list.";
    elseif (typeof(msg) != STR)
      value = "is corrupted! **";
    else
      value = "is " + $string_utils:print(msg);
    endif
    player:notify(tostr("@", pname[1..len - 4], " ", dobjstr, " ", value));
  endif
endfor
if (!found_one)
  player:notify("That object doesn't have any messages to set.");
endif
.

@verb #6:"@notedit" any none none rd #36
@program #6:@notedit
$note_editor:invoke(dobjstr, verb);
.

@verb #6:"@last-c*onnection" any none none rxd
@program #6:@last-connection
"@last-c           reports when and from where you last connected.";
"@last-c all       adds the 10 most recent places you connected from.";
"@last-c confunc   is like `@last-c' but is silent on first login.";
opts = {"all", "confunc"};
i = 0;
if (caller != this)
  return E_PERM;
elseif (args && ((length(args) > 1) || (!(i = $string_utils:find_prefix(args[1], opts)))))
  this:notify(tostr("Usage:  ", verb, " [all]"));
  return;
endif
opt_all = i && (opts[i] == "all");
opt_confunc = i && (opts[i] == "confunc");
if (!(prev = this.previous_connection))
  this:notify("Something was broken when you logged in; tell a wizard.");
elseif (prev[1] == 0)
  opt_confunc || this:notify("Your previous connection was before we started keeping track.");
elseif (prev[1] > time())
  this:notify("This is your first time connected.");
else
  this:notify(tostr("Last connected ", this:ctime(prev[1]), " from ", prev[2]));
  if (opt_all)
    this:notify("Previous connections have been from the following sites:");
    for l in (this.all_connect_places)
      this:notify("   " + l);
    endfor
  endif
endif
.

@verb #6:"set_gender" this none this
@program #6:set_gender
"set_gender(newgender) attempts to change this.gender to newgender";
"  => E_PERM   if you don't own this or aren't its parent";
"  => Other return values as from $gender_utils:set.";
if (!($perm_utils:controls(caller_perms(), this) || (this == caller)))
  return E_PERM;
else
  result = $gender_utils:set(this, args[1]);
  this.gender = (typeof(result) == STR) ? result | args[1];
  return result;
endif
.

@verb #6:"@gender" any none none
@program #6:@gender
set_task_perms(valid(caller_perms()) ? caller_perms() | player);
if (!args)
  player:notify(tostr("Your gender is currently ", this.gender, "."));
  player:notify($string_utils:pronoun_sub("Your pronouns:  %s,%o,%p,%q,%r,%S,%O,%P,%Q,%R"));
  player:notify(tostr("Available genders:  ", $string_utils:english_list($gender_utils.genders, "", " or ")));
else
  result = this:set_gender(args[1]);
  quote = (result == E_NONE) ? "\"" | "";
  player:notify(tostr("Gender set to ", quote, this.gender, quote, "."));
  if (typeof(result) != ERR)
    player:notify($string_utils:pronoun_sub("Your pronouns:  %s,%o,%p,%q,%r,%S,%O,%P,%Q,%R"));
  elseif (result != E_NONE)
    player:notify(tostr("Couldn't set pronouns:  ", result));
  else
    player:notify("Pronouns unchanged.");
  endif
endif
.

@verb #6:"set_brief" this none this
@program #6:set_brief
"set_brief(value)";
"set_brief(value, anything)";
"If <anything> is given, add value to the current value; otherwise, just set the value.";
if (!($perm_utils:controls(caller_perms(), this) || (this == caller)))
  return E_PERM;
else
  if (length(args) == 1)
    this.brief = args[1];
  else
    this.brief = this.brief + args[1];
  endif
endif
.

@verb #6:"@mode" any any any
@program #6:@mode
"@mode <mode>";
"Current modes are brief and verbose.";
"General verb for setting player `modes'.";
"Modes are coded right here in the verb.";
if (caller != this)
  player:tell("You can't set someone else's modes.");
  return E_PERM;
endif
modes = {"brief", "verbose"};
mode = modes[$string_utils:find_prefix(dobjstr, modes)];
if (!mode)
  player:tell("Unknown mode \"", dobjstr, "\".  Known modes:");
  for mode in (modes)
    player:tell("  ", mode);
  endfor
  return 0;
elseif (mode == "brief")
  this:set_brief(1);
elseif (mode == "verbose")
  this:set_brief(0);
endif
player:tell($string_utils:capitalize(mode), " mode set.");
return 1;
.

@verb #6:"@exam*ine" any none none rxd
@program #6:@examine
"This verb should probably go away once 'examine' is in place.";
if (dobjstr == "")
  player:notify(tostr("Usage:  ", verb, " <object>"));
  return;
endif
what = $string_utils:match_object(dobjstr, player.location);
if ($command_utils:object_match_failed(what, dobjstr))
  return;
endif
player:notify(tostr(what.name, " (", what, ") is owned by ", valid(what.owner) ? what.owner.name | "a recycled player", " (", what.owner, ")."));
player:notify(tostr("Aliases:  ", $string_utils:english_list(what.aliases)));
desc = what:description();
if (desc)
  player:notify_lines(desc);
else
  player:notify("(No description set.)");
endif
if ($perm_utils:controls(player, what))
  player:notify(tostr("Key:  ", $lock_utils:unparse_key(what.key)));
endif
contents = what.contents;
if (contents)
  player:notify("Contents:");
  for item in (contents)
    player:notify(tostr("  ", item.name, " (", item, ")"));
  endfor
endif
"Use dobjstr, not shortest alias.";
name = dobjstr;
"name = what.name;";
"if (typeof(what.aliases) == LIST && what.aliases != {})";
"for alias in (what.aliases)";
"if (length(alias) <= length(name))";
"name = alias;";
"endif";
"endfor";
"endif";
vrbs = {};
commands_ok = what in {player, player.location};
dull_classes = {$root_class, $room, $player, $prog};
what = what;
printed_working_msg = 0;
while (what != $nothing)
  if ($command_utils:running_out_of_time())
    if (!printed_working_msg)
      player:notify("Working on list of obvious verbs...");
      printed_working_msg = 1;
    endif
    suspend(0);
  endif
  if (!(what in dull_classes))
    for i in [1..length(verbs(what))]
      if ($command_utils:running_out_of_time())
        if (!printed_working_msg)
          player:notify("Working on list of obvious verbs...");
          printed_working_msg = 1;
        endif
        suspend(0);
      endif
      info = verb_info(what, i);
      syntax = verb_args(what, i);
      if ((index(info[2], "r") && ((syntax[2..3] != {"none", "this"}) && (commands_ok || ("this" in syntax)))) && verb_code(what, i))
        {dobj, prep, iobj} = syntax;
        if (syntax == {"any", "any", "any"})
          prep = "none";
        endif
        if (prep != "none")
          for x in ($string_utils:explode(prep, "/"))
            if (length(x) <= length(prep))
              prep = x;
            endif
          endfor
        endif
        "This is the correct way to handle verbs ending in *";
        vname = info[3];
        while (j = index(vname, "* "))
          vname = tostr(vname[1..j - 1], "<anything>", vname[j + 1..$]);
        endwhile
        if (vname[$] == "*")
          vname = vname[1..$ - 1] + "<anything>";
        endif
        vname = strsub(vname, " ", "/");
        rest = "";
        if (prep != "none")
          rest = " " + ((prep == "any") ? "<anything>" | prep);
          if (iobj != "none")
            rest = tostr(rest, " ", (iobj == "this") ? name | "<anything>");
          endif
        endif
        if (dobj != "none")
          rest = tostr(" ", (dobj == "this") ? name | "<anything>", rest);
        endif
        vrbs = setadd(vrbs, ("  " + vname) + rest);
      endif
    endfor
  endif
  what = parent(what);
endwhile
if (vrbs)
  player:notify("Obvious Verbs:");
  player:notify_lines(vrbs);
  printed_working_msg && player:notify("(End of list.)");
elseif (printed_working_msg)
  player:notify("No obvious verbs found.");
endif
.

@verb #6:"exam*ine" any none none
@program #6:examine
set_task_perms(player);
if (!dobjstr)
  player:notify(tostr("Usage:  ", verb, " <object>"));
  return E_INVARG;
endif
what = player.location:match_object(dobjstr);
if ($command_utils:object_match_failed(what, dobjstr))
  return;
endif
what:do_examine(player);
.

@verb #6:"add_feature" this none this rxd #36
@program #6:add_feature
"Add a feature to this player's features list.  Caller must be this or have suitable permissions (this or wizardly).";
"If this is a nonprogrammer, then ask feature if it is feature_ok (that is, if it has a verb :feature_ok which returns a true value, or a property .feature_ok which is true).";
"After adding feature, call feature:feature_add(this).";
"Returns true if successful, E_INVARG if not a valid object, and E_PERM if !feature_ok or if caller doesn't have permission.";
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  feature = args[1];
  if ((typeof(feature) != OBJ) || (!valid(feature)))
    return E_INVARG;
    "Not a valid object.";
  endif
  if ($code_utils:verb_or_property(feature, "feature_ok", this))
    "The object is willing to be a feature.";
    if (typeof(this.features) == LIST)
      "If list, we can simply setadd the feature.";
      this.features = setadd(this.features, feature);
    else
      "If not, we erase the old value and create a new list.";
      this.features = {feature};
    endif
    "Tell the feature it's just been added.";
    try
      feature:feature_add(this);
    except (ANY)
      "just ignore errors.";
    endtry
    return 1;
    "We're done.";
  else
    return E_PERM;
    "Feature isn't feature_ok.";
  endif
else
  return E_PERM;
  "Caller doesn't have permission.";
endif
.

@verb #6:"remove_feature" this none this rxd #36
@program #6:remove_feature
"Remove a feature from this player's features list.  Caller must be this, or have permissions of this, a wizard, or feature.owner.";
"Returns true if successful, E_PERM if caller didn't have permission.";
feature = args[1];
if (((caller == this) || $perm_utils:controls(caller_perms(), this)) || (caller_perms() == feature.owner))
  if (typeof(this.features) == LIST)
    "If this is a list, we can just setremove...";
    this.features = setremove(this.features, feature);
    "Otherwise, we leave it alone.";
  endif
  "Let the feature know it's been removed.";
  try
    feature:feature_remove(this);
  except (ANY)
    "just ignore errors.";
  endtry
  return 1;
  "We're done.";
else
  return E_PERM;
  "Caller didn't have permission.";
endif
.

@verb #6:"@add-feature @addfeature" any none none
@program #6:@add-feature
"Usage:";
"  @add-feature";
"  @add-feature <feature object>";
"Modified 10 Oct 94, by Michele, to check the warehouse and match.";
"Lists all features or adds an object to your features list.";
set_task_perms(player);
if (dobjstr)
  if (dobj == $failed_match)
    dobj = $feature.warehouse:match_object(dobjstr);
  endif
  if (!$command_utils:object_match_failed(dobj, dobjstr))
    if (dobj in player.features)
      player:tell(dobjstr, " is already one of your features.");
    elseif (player:add_feature(dobj))
      player:tell(dobj, " (", dobj.name, ") added as a feature.");
    else
      player:tell("You can't seem to add ", dobj, " (", dobj.name, ") to your features list.");
    endif
  endif
else
  player:tell("Usage:  @add-feature <object>");
  if (length($feature.warehouse.contents) < 20)
    player:tell("Available features include:");
    player:tell("--------------------------");
    fe = {};
    for c in ($feature.warehouse.contents)
      fe = {(c in player.features) ? c:title() + " (*)" | c:title()};
      player:tell("  " + $string_utils:english_list(fe));
    endfor
    player:tell("--------------------------");
    player:tell("A * after the feature name means that you already have that feature.");
  endif
endif
.

@verb #6:"@remove-feature @rmfeature" any none none
@program #6:@remove-feature
"Usage:  @remove-feature <feature object>";
"Remove an object from your .features list.";
set_task_perms(player);
if (dobjstr)
  features = player.features;
  if (!valid(dobj))
    dobj = $string_utils:match(dobjstr, features, "name", features, "aliases");
  endif
  if (!$command_utils:object_match_failed(dobj, dobjstr))
    if (dobj in features)
      player:remove_feature(dobj);
      player:tell(dobj, " (", dobj.name, ") removed from your features list.");
    else
      player:tell(dobjstr, " is not one of your features.");
    endif
  endif
else
  player:tell("Usage:  @remove-feature <object>");
endif
.

@verb #6:"@features" any for any rxd
@program #6:@features
"Usage:  @features [<name>] for <player>";
"List the feature objects matching <name> used by <player>.";
if (!iobjstr)
  player:tell("Usage: @features [<name>] for <player>");
  return;
elseif ($command_utils:player_match_failed(whose = $string_utils:match_player(iobjstr), iobjstr))
  return;
endif
features = {};
for feature in (whose.features)
  if (!valid(feature))
    whose:remove_feature(feature);
  elseif ((!dobjstr) || ((dobjstr in feature.aliases) || ((pref = $string_utils:find_prefix(dobjstr, feature.aliases)) || (pref == $ambiguous_match))))
    features = listappend(features, feature);
  endif
endfor
if (features)
  len = max(length("Feature"), length(tostr(max_object()))) + 1;
  player:tell($string_utils:left("Feature", len), "Name");
  player:tell($string_utils:left("-------", len), "----");
  for feature in (features)
    player:tell($string_utils:left(tostr(feature), len), feature.name);
  endfor
  player:tell($string_utils:left("-------", len), "----");
  cstr = ((tostr(length(features)) + " feature") + ((length(features) > 1) ? "s" | "")) + " found";
  if (whose != this)
    cstr = ((((cstr + " on ") + whose.name) + " (") + tostr(whose)) + ")";
  endif
  if (dobjstr)
    cstr = ((cstr + " matching \"") + dobjstr) + "\"";
  endif
  cstr = cstr + ".";
  player:tell(cstr);
elseif (dobjstr)
  player:tell("No features found on ", whose.name, " (", whose, ") matching \"", dobjstr, "\".");
else
  player:tell("No features found on ", whose.name, " (", whose, ").");
endif
.

@verb #6:"@features" any none none
@program #6:@features
"Usage:  @features [<name>]";
"List the feature objects matching <name> used by player.";
iobjstr = player.name;
iobj = player;
this:("@features")();
.

@verb #6:"@memory" none none none rd #36
@program #6:@memory
stats = memory_usage();
if (!stats)
  player:notify("Sorry, but no memory-usage statistics are available for this server.");
  return;
endif
su = $string_utils;
player:notify("Block Size   # In Use    # Free    Bytes In Use   Bytes Free");
player:notify("----------   --------   --------   ------------   ----------");
nused = nfree = bytesused = bytesfree = 0;
kilo = 1024;
meg = kilo * kilo;
for x in (stats)
  if (x[2..3] != {0, 0})
    bsize = x[1];
    if ((bsize % meg) == 0)
      bsize = tostr(bsize / meg, " M");
    elseif ((bsize % kilo) == 0)
      bsize = tostr(bsize / kilo, " K");
    endif
    bused = x[1] * x[2];
    bfree = x[1] * x[3];
    player:notify(tostr(su:left(bsize, 10), "   ", su:right(su:group_number(x[2]), 8), "   ", su:right(su:group_number(x[3]), 8), "   ", su:right(su:group_number(bused), 12), "   ", su:right(su:group_number(bfree), 10)));
    nused = nused + x[2];
    nfree = nfree + x[3];
    bytesused = bytesused + bused;
    bytesfree = bytesfree + bfree;
  endif
endfor
player:notify("");
player:notify(tostr(su:left("Totals:", 10), "   ", su:right(su:group_number(nused), 8), "   ", su:right(su:group_number(nfree), 8), "   ", su:right(su:group_number(bytesused), 12), "   ", su:right(su:group_number(bytesfree), 10)));
player:notify("");
player:notify(tostr("Total Memory Size: ", su:group_number(bytesused + bytesfree), " bytes."));
.

@verb #6:"@version" none none none rd #36
@program #6:@version
if ($object_utils:has_property($local, "server_hardware"))
  hw = (" on " + $local.server_hardware) + ".";
else
  hw = ".";
endif
player:notify(tostr("The MOO is currently running version ", server_version(), " of the LambdaMOO server code", hw));
try
  {MOOname, sversion, coretime} = $core_history[1];
  player:notify(tostr("The database was derived from a core created on ", $time_utils:time_sub("$n $t, $Y", coretime), " at ", MOOname, " for version ", sversion, " of the server."));
except (E_RANGE)
  player:notify("The database was created from scratch.");
except (ANY)
  player:notify("No information is available on the database version.");
endtry
.

@verb #6:"@uptime" none none none rd #36
@program #6:@uptime
player:notify(tostr("The server has been up for ", $time_utils:english_time(time() - $last_restart_time), "."));
.

@verb #6:"@quit" none none none
@program #6:@quit
boot_player(player);
"-- argh, let the player decide; #3:disfunc() takes care of this --Rog";
"player:moveto(player.home)";
.

@verb #6:"examine_commands_ok" this none this
@program #6:examine_commands_ok
return this == args[1];
.

@verb #6:"is_listening" this none this
@program #6:is_listening
"return true if player is active.";
return typeof(`idle_seconds(this) ! ANY') != ERR;
.

@verb #6:"moveto" this none this
@program #6:moveto
if (args[1] == #-1)
  return E_INVARG;
  this:notify("You are now in #-1, The Void.  Type `home' to get back.");
endif
set_task_perms(caller_perms());
old_loc = this.location;
pass(@args);
"  ----  ";
"update web window if one is open and html_frame hasn't been updated yet";
if (((old_loc != this.location) && (typeof($web_options:get(this.web_options, "telnet_applet")) == OBJ)) && (!$frame_manager:webframe_is_updated("")))
  $frame_manager:update_webframe(this, tostr($web_utils:user_webviewer():get_code(), "#focus"), "");
endif
"  ----  ";
"Last modified Tue Oct  8 23:09:46 1996 IST by EricM (#3264).";
.

@verb #6:"announce*_all_but" this none this
@program #6:announce_all_but
return this.location:(verb)(@args);
"temporarily let player:announce be noisy to player";
if (verb == "announce_all_but")
  if (this in args[1])
    return;
  endif
  args = args[2..$];
endif
this:tell("(from within you) ", @args);
.

@verb #6:"linewrap" this none this rxd #36
@program #6:linewrap
"Return a true value if this needs linewrapping.";
"default is true if .linelen > 0";
return this.linelen > 0;
.

@verb #6:"@set-note-string @set-note-text" any none none
@program #6:@set-note-string
"Usage:  @set-note-{string | text} {#xx | #xx.pname}";
"        ...lines of text...";
"        .";
"";
"For use by clients' local editors, to save new text for a note or object property.  See $note_editor:local_editing_info() for details.";
set_task_perms(player);
text = $command_utils:read_lines();
if ((verb == "@set-note-string") && (length(text) <= 1))
  text = text ? text[1] | "";
endif
if (spec = $code_utils:parse_propref(argstr))
  o = player:my_match_object(spec[1]);
  p = spec[2];
  if ($object_utils:has_verb(o, vb = "set_" + p) && (typeof(e = o:(vb)(text)) != ERR))
    player:tell("Set ", p, " property of ", o.name, " (", o, ") via :", vb, ".");
  elseif (text != (e = `o.(p) = text ! ANY'))
    player:tell("Error:  ", e);
  else
    player:tell("Set ", p, " property of ", o.name, " (", o, ").");
  endif
elseif (typeof(note = $code_utils:toobj(argstr)) == OBJ)
  e = note:set_text(text);
  if (typeof(e) == ERR)
    player:tell("Error:  ", e);
  else
    player:tell("Set text of ", note.name, " (", note, ").");
  endif
else
  player:tell("Error:  Malformed argument to ", verb, ": ", argstr);
endif
.

@verb #6:"verb_sub" this none this
@program #6:verb_sub
text = args[1];
if (a = `$list_utils:assoc(text, this.verb_subs) ! ANY')
  return a[2];
else
  return $gender_utils:get_conj(text, this);
endif
.

@verb #6:"ownership_quota" this none this
@program #6:ownership_quota
if ($perm_utils:controls(caller_perms(), this))
  return this.(verb);
else
  return E_PERM;
endif
.

@verb #6:"tell_lines" this none this
@program #6:tell_lines
lines = args[1];
if (typeof(lines) != LIST)
  lines = {lines};
endif
if (this.gaglist || this.paranoid)
  "Check the above first, default case, to save ticks.  Paranoid gaggers are cost an extra three or so ticks by this, probably a net savings.";
  if (this:gag_p())
    return;
  endif
  if (this.paranoid == 2)
    z = this:whodunnit({@callers(), {player, "", player}}, {this, $no_one}, {})[3];
    lines = {((("[start text by " + z.name) + " (") + tostr(z)) + ")]", @lines, ((("[end text by " + z.name) + " (") + tostr(z)) + ")]"};
  elseif (this.paranoid == 1)
    $paranoid_db:add_data(this, {{@callers(), {player, "<cmd-line>", player}}, lines});
  endif
endif
"don't gather stats for now: $list_utils:check_nonstring_tell_lines(lines)";
this:notify_lines(lines);
.

@verb #6:"@lastlog" any none none rxd
@program #6:@lastlog
"Copied from generic room (#3):@lastlog by Haakon (#2) Wed Dec 30 13:30:02 1992 PST";
if (dobjstr != "")
  dobj = $string_utils:match_player(dobjstr);
  if (!valid(dobj))
    player:tell("Who?");
    return;
  endif
  folks = {dobj};
else
  folks = players();
endif
day = week = month = ever = never = {};
a_day = (24 * 60) * 60;
a_week = 7 * a_day;
a_month = 30 * a_day;
now = time();
for x in (folks)
  when = x.last_connect_time;
  how_long = now - when;
  if ((when == 0) || (when > now))
    never = {@never, x};
  elseif (how_long < a_day)
    day = {@day, x};
  elseif (how_long < a_week)
    week = {@week, x};
  elseif (how_long < a_month)
    month = {@month, x};
  else
    ever = {@ever, x};
  endif
endfor
for entry in ({{day, "the last day"}, {week, "the last week"}, {month, "the last 30 days"}, {ever, "recorded history"}})
  if (entry[1])
    player:tell("Players who have connected within ", entry[2], ":");
    for x in (entry[1])
      player:tell("  ", x.name, " last connected ", ctime(x.last_connect_time), ".");
    endfor
  endif
endfor
if (never)
  player:tell("Players who have never connected:");
  player:tell("  ", $string_utils:english_list($list_utils:map_prop(never, "name")));
endif
.

@verb #6:"set_linelength" this none this
@program #6:set_linelength
"Set linelength.  Linelength must be an integer >= 10.";
"If wrap is currently off (i.e. linelength is less than 0), maintains sign.  That is, this function *takes* an absolute value, and coerces the sign to be appropriate.";
"If you want to override the dwimming of wrap, pass in a second argument.";
"returns E_PERM if not allowed, E_INVARG if linelength is too low, otherwise the linelength.";
if ((caller != this) && (!$perm_utils:controls(caller_perms(), this)))
  return E_PERM;
elseif (abs(len = args[1]) < 10)
  return E_INVARG;
elseif (length(args) > 1)
  this.linelen = len;
else
  "DWIM here.";
  this.linelen = (this.linelen > 0) ? len | (-len);
  return len;
endif
.

@verb #6:"set_pagelength" this none this
@program #6:set_pagelength
"Set pagelength. Must be an integer >= 5, or 0 to turn pagelength off.";
"Returns E_PERM if you shouldn't be doing this, E_INVARG if it's too low, otherwise, what it got set to.";
if ((caller != this) && (!$perm_utils:controls(caller_perms(), this)))
  return E_PERM;
elseif (((len = args[1]) < 5) && (len != 0))
  return E_INVARG;
else
  if ((this.pagelen = len) == 0)
    if (lb = this.linebuffer)
      "queued text remains";
      this:notify_lines(lb);
      clear_property(this, "linebuffer");
    endif
  endif
  return len;
endif
.

@verb #6:"set_home" this none this
@program #6:set_home
"set_home(newhome) attempts to change this.home to newhome";
"E_TYPE   if newhome doesn't have a callable :accept_for_abode verb.";
"E_INVARG if newhome won't accept you as a resident.";
"E_PERM   if you don't own this and aren't its parent.";
"1        if it works.";
newhome = args[1];
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  if ($object_utils:has_callable_verb(newhome, "accept_for_abode"))
    if (newhome:accept_for_abode(this))
      return (typeof(e = `this.home = args[1] ! ANY') != ERR) || e;
    else
      return E_INVARG;
    endif
  else
    return E_TYPE;
  endif
else
  return E_PERM;
endif
.

@verb #6:"@registerme" any any any
@program #6:@registerme
"@registerme as <email-address> -- enter a new email address for player";
"   will change the database entry, assign a new password, and mail the new password to the player at the given email address.";
if (player != this)
  return player:notify(tostr(E_PERM));
endif
who = this;
if ($object_utils:isa(this, $guest))
  who:notify("Sorry, guests should use the '@request' command to request a character.");
  return;
endif
connection = $string_utils:connection_hostname(connection_name(who));
if (!argstr)
  if (who.email_address)
    player:tell("You are currently registered as:  ", who.email_address);
  else
    player:tell("You are not currently registered.");
  endif
  player:tell("Use @registerme as <address> to change this.");
  return;
elseif (((prepstr != "as") || (!iobjstr)) || dobjstr)
  player:tell("Usage: @registerme as <address>");
  return;
endif
email = iobjstr;
if (email == this.email_address)
  who:notify("That is your current address.  Not changed.");
  return;
elseif (reason = $wiz_utils:check_reregistration(this, email, connection))
  if (reason[1] == "-")
    if (!$command_utils:yes_or_no(reason[2..$] + ". Automatic registration not allowed. Ask to be registered at this address anyway?"))
      who:notify("Okay.");
      return;
    endif
  else
    return who:notify(tostr(reason, " Please try again."));
  endif
endif
if ($network.active && (!reason))
  if (!$command_utils:yes_or_no(tostr("If you continue, your password will be changed, the new password mailed to `", email, "'. Do you want to continue?")))
    return who:notify("Registration terminated.");
  endif
  password = $wiz_utils:random_password(5);
  old = who.email_address || "[ unregistered ]";
  who:notify(tostr("Registering you, and changing your password and mailing new one to ", email, "."));
  result = $network:sendmail(email, tostr("Your ", $network.MOO_Name, " character, ", who.name), "Reply-to: " + $login.registration_address, @$generic_editor:fill_string(tostr("Your ", $network.MOO_name, " character, ", $string_utils:nn(who), " has been registered to this email address (", email, "), and a new password assigned.  The new password is `", password, "'. Please keep your password secure. You can change your password with the @password command."), 75));
  if (result != 0)
    who:notify(tostr("Mail sending did not work: ", reason, ". Reregistration terminated."));
    return;
  endif
  who:notify(tostr("Mail with your new password forwarded. If you do not get it, send regular email to ", $login.registration_address, " with your character name."));
  $mail_agent:send_message($new_player_log, $new_player_log, "reg " + $string_utils:nn(this), {email, tostr("formerly ", old)});
  $registration_db:add(this, email, "Reregistered at " + ctime());
  this.email_address = email;
  who.password = crypt(password);
  who.last_password_time = time();
else
  who:notify("No automatic reregistration: your request will be forwarded.");
  if (typeof(curreg = $registration_db:find(email)) == LIST)
    additional_info = {"Current registration information for this email address:", @$registration_db:describe_registration(curreg)};
  else
    additional_info = {};
  endif
  $mail_agent:send_message(this, $registration_db.registrar, "Registration request", {((("Reregistration request from " + $string_utils:nn(who)) + " connected via ") + connection) + ":", "", (("@register " + who.name) + " ") + email, ("@new-password " + who.name) + " is ", "", "Reason this request was forwarded:", reason, @additional_info});
endif
.

@verb #6:"ctime" this none this
@program #6:ctime
":ctime([INT time]) => STR as the function.";
"May be hacked by players and player-classes to reflect differences in time-zone.";
return ctime(@args);
.

@verb #6:"@age" any none none rd #36
@program #6:@age
if ((dobjstr == "") || (dobj == player))
  dobj = player;
else
  dobj = $string_utils:match_player(dobjstr);
  if (!valid(dobj))
    $command_utils:player_match_failed(dobj, dobjstr);
    return;
  endif
endif
time = dobj.first_connect_time;
if (time == $maxint)
  duration = time() - dobj.last_disconnect_time;
  if (duration < 86400)
    notice = $string_utils:from_seconds(duration);
  else
    notice = $time_utils:english_time((duration / 86400) * 86400);
  endif
  player:notify(tostr(dobj.name, " has never connected.  It was created ", notice, " ago."));
elseif (time == 0)
  player:notify(tostr(dobj.name, " first connected before initial connections were being recorded."));
else
  player:notify(tostr(dobj.name, " first connected on ", ctime(time)));
  duration = time() - time;
  if (duration < 86400)
    notice = $string_utils:from_seconds(duration);
  else
    notice = $time_utils:english_time((duration / 86400) * 86400);
  endif
  player:notify(tostr($string_utils:pronoun_sub("%S %<is> ", dobj), notice, " old."));
endif
.

@verb #6:"news" any none none rxd
@program #6:news
"Usage: news [contents] [articles]";
"";
"Common uses:";
"news           -- display all current news, or as @mail-options decree";
"news new       -- display articles you haven't seen yet";
"news all       -- display all current news";
"news contents  -- display headers of current news";
"news <article> -- display article";
"news archive   -- display news which has been marked as archived.";
set_task_perms(player);
cur = this:get_current_message($news) || {0, 0};
arch = 0;
if (((!args) && (o = player:mail_option("news"))) && (o != "all"))
  "no arguments, use the player's default";
  args = {o};
elseif (args == {"all"})
  args = {};
elseif (args == {"archive"})
  arch = 1;
  args = {};
endif
if (hdrs_only = args && (args[1] == "contents"))
  "Do the mail contents list";
  args[1..1] = {};
endif
if (args)
  if (typeof(seq = $news:_parse(args, @cur)) == STR)
    player:notify(seq);
    return;
  elseif (seq = $seq_utils:intersection(seq, $news.current_news))
  else
    player:notify((args == {"new"}) ? "No new news." | "None of those are current articles.");
    return;
  endif
elseif (arch && (seq = $news.archive_news))
  "yduJ hates this coding style.  Just so you know.";
elseif (seq = $news.current_news)
else
  player:notify("No news");
  return;
endif
if (hdrs_only)
  $news:display_seq_headers(seq, @cur);
else
  player:set_current_message($news, @$news:news_display_seq_full(seq));
endif
.

@verb #6:"@edit" any any any rd #36
@program #6:@edit
"Calls the verb editor on verbs, the note editor on properties, and on anything else assumes it's an object for which you want to edit the .description.";
if (!args)
  ((player in $note_editor.active) ? $note_editor | $verb_editor):invoke(dobjstr, verb);
elseif ($code_utils:parse_verbref(args[1]))
  if (player.programmer)
    $verb_editor:invoke(argstr, verb);
  else
    player:notify("You need to be a programmer to do this.");
    player:notify("If you want to become a programmer, talk to a wizard.");
    return;
  endif
else
  $note_editor:invoke(dobjstr, verb);
endif
.

@verb #6:"erase_paranoid_data" this none this
@program #6:erase_paranoid_data
if (!($perm_utils:controls(caller_perms(), this) || (this == caller)))
  return E_PERM;
else
  $paranoid_db:erase_data(this);
endif
.

@verb #6:"@move-new" any any any
@program #6:@move-new
"'@move <object> to <place>' - Teleport an object. Example: '@move trash to #11' to move trash to the closet.";
set_task_perms((caller == this) ? this | $no_one);
if ((prepstr != "to") || (!iobjstr))
  player:tell("Usage: @move <object> to <location>");
  return;
endif
if ((!dobjstr) || (dobjstr == "me"))
  dobj = this;
else
  dobj = here:match_object(dobjstr);
  if (!valid(dobj))
    dobj = player:my_match_object(dobjstr);
  endif
endif
if ($command_utils:object_match_failed(dobj, dobjstr))
  return;
endif
iobj = this:lookup_room(iobjstr);
if ((iobj != $nothing) && $command_utils:object_match_failed(iobj, iobjstr))
  return;
endif
if (((!player.programmer) && (!$perm_utils:controls(this, dobj))) && (this != dobj))
  player:tell("You may only @move your own things.");
  return;
endif
this:teleport(dobj, iobj);
.

@verb #6:"notify_lines_suspended" this none this
@program #6:notify_lines_suspended
if (($perm_utils:controls(caller_perms(), this) || (caller == this)) || (caller_perms() == this))
  set_task_perms(caller_perms());
  for line in ((typeof(lines = args[1]) != LIST) ? {lines} | lines)
    $command_utils:suspend_if_needed(0);
    this:notify(tostr(line));
  endfor
else
  return E_PERM;
endif
.

@verb #6:"_chparent" this none this
@program #6:_chparent
set_task_perms(caller_perms());
return chparent(@args);
.

@verb #6:"@users" none none none rxd #36
@program #6:@users
"Prints a count and compact list of the currently-connected players.";
cp = connected_players();
linelen = abs(player.linelen) || 79;
player:tell_lines({tostr("There are ", length(cp), " players connected:"), @$generic_editor:fill_string($string_utils:english_list($list_utils:sort_suspended(0, $list_utils:map_prop(cp, "name"))), linelen)});
.

@verb #6:"@password" any any any
@program #6:@password
if (typeof(player.password) != STR)
  if (length(args) != 1)
    return player:notify(tostr("Usage:  ", verb, " <new-password>"));
  else
    new_password = args[1];
  endif
elseif (length(args) != 2)
  player:notify(tostr("Usage:  ", verb, " <old-password> <new-password>"));
  return;
elseif (player.password != crypt(tostr(args[1]), player.password))
  player:notify("That's not your old password.");
  return;
elseif (is_clear_property(player, "password"))
  player:notify("Your password has a `clear' property.  Please refer to a wizard for assistance in changing it.");
  return;
else
  new_password = args[2];
endif
if (r = $password_verifier:reject_password(new_password, player))
  player:notify(r);
  return;
endif
player.password = crypt(tostr(new_password));
player.last_password_time = time();
player:notify("New password set.");
.

@verb #6:"recycle" this none this
@program #6:recycle
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  pass(@args);
  features = this.features;
  "Have to do this, or :feature_remove thinks you're a liar and doesn't believe.";
  this.features = {};
  for x in (features)
    try
      x:feature_remove(this);
    except (ANY)
      "Ignore errors";
    endtry
  endfor
endif
.

@verb #6:"gc_gaglist" this none this
@program #6:gc_gaglist
((caller == this) || $perm_utils:controls(caller_perms(), this)) || raise(E_PERM);
if (g = this.gaglist)
  recycler = $recycler;
  for o in (g)
    if (!recycler:valid(o))
      g = setremove(g, o);
    endif
  endfor
  this.gaglist = g;
endif
.

@verb #6:"@url @icon @html @vrml" none for any r #95
@program #6:@url
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
set_task_perms(player);
what = player:my_match_object(iobjstr, player.location);
if ($command_utils:object_match_failed(what, iobjstr))
  return;
endif
type = strsub(verb, "@", "");
if (type == "vrml")
  url = ((player.location == what) && $object_utils:isa(what, $room)) ? what.vrml_interior_desc | what.vrml_desc;
else
  url = what:("get_" + type)(player);
endif
if (!url)
  player:tell(what:namec(1) + " has no attached ", ((((type == "URL") && "URL.") || ((type == "HTML") && "HTML document.")) || ((type == "vrml") && "VRML description")) || "icon URL.");
elseif (typeof(url) == STR)
  player:tell(tostr((type != "icon") ? "URL" | "Icon URL", " for ", what:name(1), ": \"", url, "\""));
else
  if (type == "html")
    player:tell(tostr(what:namec(1), " has an associated HTML document of ", l = length(url), " line", (l > 1) ? "s" | "", "."));
  else
    player:tell(tostr(what:namec(1), " has an associated VRML description of ", l = length(url), " line", (l > 1) ? "s" | "", "."));
  endif
  if (l > 15)
    player:tell("Do you want to see it now?");
    if ($command_utils:yes_or_no())
      player:tell_lines({"------", @url, "------"});
    endif
  else
    player:tell_lines({"------", @url, "------"});
  endif
endif
"Last modified Sun Apr  7 19:59:59 1996 IDT by EricM (#3264).";
.

@verb #6:"@url @icon @html" any is any r #95
@program #6:@url
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
set_task_perms(player);
what = player:my_match_object(dobjstr, player.location);
if ($command_utils:object_match_failed(what, dobjstr))
  return;
elseif (!$perm_utils:controls(player, what))
  return player:tell("Sorry, you don't have permission to add that to that object.");
endif
type = (strsub(verb, "@", "") == "icon") ? "icon" | "url";
if ((type == "url") && (typeof(old = what:get_url()) == LIST))
  player:tell("That object has an associated HTML document of ", length(old), " lines.");
  if (!$command_utils:yes_or_no("Are you sure you want to replace it?"))
    return player:tell("No changes made.");
  endif
endif
if (!iobjstr)
  if ((length(argstr) > (i = index(argstr, " is ") + 3)) && ("\"\"" == $string_utils:trim(argstr[i..length(argstr)])))
    "clear it";
  elseif (verb == "@html")
    player:tell("Enter the lines of the HTML document to attach to ", dobj:name(1), ":");
    if (text = $command_utils:read_lines())
      dobj:set_url(text);
      player:tell("New HTML document set (", length(text), " lines).");
    else
      player:tell("No changes made.");
    endif
    return;
  else
    player:tell("To clear the ", type, " or set it to a blank value, use: @", type, " ", dobjstr, " is \"\"");
    return player:tell("To see the current value use: @", type, " for ", dobjstr);
  endif
endif
if (!(match = match(argstr, tostr($string_utils:regexp_quote(dobjstr), " +is +%(.*%)"))))
  return player:tell("Sorry, but the ", verb, " command appears to be broken. Please tell an administrator that the command's match() system is failing.");
endif
iobjstr = substitute("%1", match);
value = $string_utils:to_value(iobjstr);
if (value[1])
  result = what:("set_" + type)(value[2]);
  if (result)
    result = (((type == "url") ? "URL" | "Icon URL") + " set to: ") + $string_utils:print(result);
  elseif ((result == 0) || (result == ""))
    result = tostr((type == "url") ? "URL" | "Icon URL", " ", value[2] ? "set" | "removed", " successfully.");
  else
    result = tostr(result);
  endif
else
  result = value[2];
endif
player:tell(tostr(result));
"Last modified Thu Aug 15 10:10:06 1996 IDT by EricM (#3264).";
.

@verb #6:"@htmledit" any none none rd #95
@program #6:@htmledit
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
set_task_perms(player);
if ($command_utils:object_match_failed(dobj, dobjstr))
  return;
elseif (!$perm_utils:controls(player, dobj))
  return player:tell("Sorry, you can only edit the URL or HTML document on objects you own.");
endif
$html_editor:invoke(dobjstr, verb);
"Last modified Thu Aug 15 10:13:14 1996 IDT by EricM (#3264).";
.

@verb #6:"@weblink" any to any rd #95
@program #6:@weblink
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
text = "";
if ($command_utils:object_match_failed(dobj, dobjstr))
  return;
elseif (!$perm_utils:controls(perms = (caller_perms() == #-1) ? player | caller_perms(), dobj))
  return player:tell("Sorry, but you can only use this command with objects you own.");
endif
set_task_perms(perms);
if (typeof(old_URL = dobj:get_url()) != STR)
  player:tell("The presently set URL for ", dobj:name(1), " is not a simple URL!");
  player:tell("Do you want to clear it and set some text or an image to be the hyperlink?");
  if ($command_utils:yes_or_no())
    dobj:set_url("");
    old_URL = "";
    player:tell("...cleared...");
    player:tell();
  else
    player:tell("<finished, no changes made>");
    return;
  endif
endif
if (!old_URL)
  player:tell("There is no text or image set for ", dobj:name(1), ".");
  text = "";
  while (!text)
    player:tell("Please enter the text you wish to use as a hyperlink to the file at '", iobjstr, "'.");
    if (!(text = $command_utils:read()))
      player:tell("You must provide some text as the hyperlink to continue with this command, or enter \"@abort\" to quit.");
      player:tell();
    endif
  endwhile
  text = ("<P><B>" + text) + "</B><P>";
elseif (!$command_utils:yes_or_no("There is already a URL attached to the object, presumably for an image associated with the object. Do you want to use that image as a hyperlink (else it'll be cleared)?"))
  dobj:set_url("");
  old_URL = "";
  player:tell("Cleared...");
endif
if (!iobjstr)
  while (!iobjstr)
    player:tell("Please enter the URL of the file you wish to establish a link to:");
    iobjstr = $command_utils:read();
    if (!iobjstr)
      player:tell("You must specify a URL that the link is to lead towards to continue with this command.");
      player:tell();
    endif
  endwhile
endif
if (old_URL)
  player:tell(dobj:namec(1), "'s associated image at '", old_URL, "' is now a link to the file at \"", iobjstr, "\".");
  dobj:set_url({tostr("<A HREF=\"", iobjstr, "\" onClick=\"alert('A new window is being opened for your selection.  Your window into ", $network.MOO_name, " will remain.')\" TARGET=\"accessory_frame\"><IMG SRC=\"", old_URL, "\"></A>")});
else
  player:tell("The text '", text, "' is now a hyperlink to the file at '", iobjstr, "'.");
  dobj:set_url({tostr("<A HREF=\"", iobjstr, "\" onClick=\"alert('A new window is being opened for your selection.  Your window into ", $network.MOO_name, " will remain.')\" TARGET=\"accessory_frame\">", text, "</A>")});
endif
"Last modified Tue Aug 27 16:19:20 1996 IDT by EricM (#3264).";
.

@verb #6:"_join" this none this rx #95
@program #6:_join
"_join ([who OBJ]) -> none";
"Accepts `who' as person to join if given as args[1], else uses the value of `dobj' instead.";
if (((caller != this) && (caller_perms() != this)) && (!$perm_utils:controls(caller_perms(), this)))
  return E_PERM;
endif
destination = args ? args[1] | dobj.location;
if ($object_utils:isa(destination, $generic_editor))
  player:tell("Sorry, ", dobjstr, " is editing right now.");
  player:tell("You can't join ", dobj.gender.po, " in the editor.");
  return;
elseif (player.location == destination)
  player:tell("You're already there!");
  return;
elseif (!$object_utils:isa(destination, $room))
  player:tell("Sorry, you can't go there.");
  return;
endif
origin = player.location;
if ($object_utils:isa(origin, $generic_editor))
  player:tell("You should finish or abort your editing session first.");
  return;
endif
player:moveto(destination);
if (player.location == destination)
  player:tell("You join ", dobj:name(1), ".");
  if (valid(origin))
    origin:announce_all(player:namec(1), " disappears suddenly for parts unknown.");
  endif
  destination:announce(player:namec(1), " materializes out of thin air.");
else
  return player:tell(destination.nogo_msg || tostr("Either you don't really want to go there, or ", destination:name(1), " doesn't want to accept you."));
endif
"Last modified Wed Oct 30 16:53:00 1996 IST by EricM (#3264).";
.

@verb #6:"@join" any none none rd #95
@program #6:@join
set_task_perms((caller == this) ? this | $no_one);
dobj = $string_utils:match_player(dobjstr);
if (dobj == $failed_match)
  player:tell("There is no person named ", dobjstr, ".");
elseif (dobj == $nothing)
  player:tell("You must @join a person.");
elseif (dobj == $ambiguous_match)
  player:tell("I'm not sure which ", dobjstr, " you mean.");
else
  this:_join();
endif
"Last modified Thu Apr 20 08:22:30 1995 IDT by EricM (#3264).";
.

@verb #6:"@webpass*word" any any any r #95
@program #6:@webpassword
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
wh = $http_handler.webpass_handler;
if (prepstr == "for")
  "well, should match an object here...";
  player:tell("Sorry, not implemented yet.");
elseif (!dobjstr)
  new = wh:set_password(player);
  player:tell("Your new web password is: ", new);
elseif ($perm_utils:password_ok(player.password, dobjstr))
  player:tell("Please choose a webpass different from the password you use to connect via telnet.");
elseif (index(dobjstr, " "))
  player:tell("Please provide a new web password without spaces.");
elseif (!match(dobjstr, "^%w+$"))
  player:tell("Please include only alphanumeric characters in your webpass (letters or numbers).");
elseif (wh.(dobjstr) == player)
  player:tell("That was already your web password...");
else
  new = wh:set_password(player, dobjstr);
  if (typeof(new) != STR)
    return player:tell("Your web password couldn't be modified for some reason. Please report to an administrator.");
  elseif (dobjstr != new)
    player:tell("The password you provided wasn't good for some reason.");
  endif
  player:tell("Your web password is now: ", new);
endif
"Last modified Thu Aug 22 19:58:41 1996 IDT by EricM (#3264).";
.

@verb #6:"web_viewer_buttons" this none this rx #95
@program #6:web_viewer_buttons
"web_viewer_buttons(who, what OBJ, rest STR, search STR [line STR]) -> HTML frg LIST";
"Returns a bar of buttons bearing links that perform some commonly used commands";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
set_task_perms(caller_perms());
code = args[1];
what = args[2];
link0 = "<A HREF=\"&LOCAL_LINK;/" + code;
link1 = link0 + "/";
link1a = tostr(link1, "$teleporter/");
link2 = "\">";
link3 = "</A>";
eol = "<P>";
where = player.location;
text = {};
"";
"LOOK AROUND button";
text = {@text, tostr(" [", link0, "#focus", link2, "<img src=\"http://hppsda.mayfield.hp.com/image/eye1.gif\" border=0><B>Look around</B>", link3, "]")};
"FOCUS";
text = {@text, " [<A HREF=\"#focus\">Focus</A>]"};
"SHOW/HIDE MAP button";
if ($teleporter.image_map)
  "Assume that if a default teleporter image map is set, the MOO is supporting this feature.";
  hasmap = "map" in this.web_options;
  text = {@text, tostr(" [", link1, tonum(where), "/+map", hasmap ? "-" | "+", link2, hasmap ? "Hide map" | "Show map", link3, "]")};
endif
"GO HOME button";
text = {@text, (where != this.home) ? tostr(" [", link1a, "home#focus", link2, "Go home", link3, "]") | ""};
"CENTRAL ROOM JUMP button";
if (player.location != $teleporter.central_room)
  text = {@text, tostr(" [", link1a, "central_room#focus", link2, $teleporter.central_room.name, link3, "]")};
endif
"WHO button";
text = {@text, tostr(" [", "<A HREF=\"&LOCAL_LINK;/info/0/who\">Who's in ", $network.MOO_name, "?", link3, "]")};
"SHOW/HIDE INVENTORY button";
hasinv = "inv" in this.web_options;
text = {@text, tostr(this.contents ? tostr(" [", link1, tonum(where), "/+inv", hasinv ? "-" | "+", link2, hasinv ? "Hide inventory" | "Show inventory", link3, "]") | "")};
"CUSTOMIZE: PAGE, CHARACTER, OBJECT button";
text = {@text, tostr(" [", "Customize-<A HREF=\"&LOCAL_LINK;/vcst\">page", link3, "/<A HREF=\"&LOCAL_LINK;/char\">yourself", link3, "/<A HREF=\"&LOCAL_LINK;/", $object_browser:get_code(), link2, "objects", link3, "]")};
"MAIL button";
text = {@text, tostr(" [", "<A HREF=\"&LOCAL_LINK;/", $mail_browser:get_code(), link2, "Read mail", link3, "]")};
"WIZARD'S CHOICE";
if (`valid($web_utils.wizards_choice) ! E_PROPNF' && (wc_code = $web_utils.wizards_choice:get_code()))
  text = {@text, tostr("  [", "<A HREF=\"&LOCAL_LINK;/", wc_code, link2, "Wizard's Choice!", link3, "]")};
endif
"VRML LINK";
if ($http_handler:retrieve_taskprop("http_version")[1] != "0")
  "try to present link to room an object is located in";
  "but only if it's at least an HTTP/1.0 connection";
  if ((!$object_utils:isa(room = what, $room)) || (($object_utils:isoneof(room, $web_utils.interior_rooms) && valid(where)) && (where != what)))
    while (valid(room) && (!$object_utils:isa(room = room.location, $room)))
    endwhile
    room = valid(room) ? room | what;
  endif
  frame = ("separateVRML" in player.web_options) ? " TARGET=\"vrml_frame\"" | "";
  text = {@text, tostr(" [<A HREF=\"&LOCAL_LINK;/", $std_vrml10viewer:get_code(), "/", tonum(room), "/room.wrl\"", frame, "><IMG border=0 SRC=\"http://hppsda.mayfield.hp.com/image/vr_goggles.gif\" ALT=\"\"><B>VRML view</B></A>]")};
endif
"HELP button";
text = {@text, tostr(" [", link1, tonum($help), "#focus", link2, "Help", link3, "]")};
"";
text = {"<CENTER><!--BR CLEAR=\"RIGHT\"--><HR>", @text};
text[length(text)] = text[length(text)] + "<HR>";
text = {@text, "</CENTER>"};
return text;
"Last modified Tue Jul  1 19:44:15 1997 IDT by EricM (#3264).";
.

@verb #6:"more_info_for_web" this none this rxd #95
@program #6:more_info_for_web
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((caller != this) && (!$perm_utils:controls(caller_perms(), this)))
  return E_PERM;
endif
text = {};
if (!(this in connected_players()))
  text = {@text, "<BR>", tostr($gender_utils:pronoun_sub("%{:He} %{!is} sleeping.", this))};
elseif ((idle = idle_seconds(this)) < 60)
  text = {@text, "<BR>", tostr($gender_utils:pronoun_sub("%{:He} %{!is} awake and %{!looks} alert.", this))};
else
  time = $string_utils:from_seconds(idle);
  text = {@text, tostr("<BR>", $gender_utils:pronoun_sub("%{:He} %{!is} awake, but %{!has} been staring off into space for ", this), time, ".")};
endif
return {@text, tostr("<P>Go to ", this:name(), "'s ", $network.MOO_name, " <A HREF=\"&LOCAL_LINK;/", $web_geninfo:get_code(), "/", tonum(this), "/info\">", "home page</A><BR>")};
"Last modified Sun Jun 29 23:50:15 1997 IDT by EricM (#3264).";
.

@verb #6:"slide" any any any rxd #95
@program #6:slide
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
directions = {"n", "e", "s", "w", "ne", "se", "sw", "nw", "u", "d", "north", "east", "south", "west", "northeast", "southeast", "southwest", "northwest", "up", "down"};
if (!(this.location in {player, player.location}))
  return player:tell("You can't find that here.");
endif
words = args;
"--figure direction";
dir = "";
while (args && (!(dir = args[1] in directions)))
  args = listdelete(args, 1);
endwhile
if (!dir)
  return player:tell("Move in what direction? Some possibilities are north, south, east, west, up or down.");
endif
"--what to slide";
dobjstr = (i = index(argstr, directions[dir]) - 1) ? argstr[1..i - 1] | "";
"--how far to slide it";
distance = (length(words) > (d = directions[dir] in words)) ? words[d + 1] | "1";
if (!$string_utils:is_numeric(distance))
  if (index(distance, "."))
    player:tell("Sorry, only integer values can be used, but you can try using a smaller unit of measurement (ie. inches or centimeters).");
  else
    player:tell("Please specify a numeric, integer ", distance, " to move (not \"distance\").");
  endif
  return;
endif
amount = $vrml_utils:distance_in_mm(tonum(distance), units = (length(words) > (d + 1)) ? words[d + 2] | "meters");
"--and in what direction";
if (typeof(amount) == ERR)
  return player:tell("I don't recognize \"", units, "\" as a measure of units.");
endif
dir = (dir > 10) ? dir - 10 | dir;
if (!dobjstr)
  dobj = player;
elseif ($command_utils:object_match_failed(dobj = player:my_match_object(dobjstr), dobjstr))
  return;
elseif (!((dobj.location in {player, player.location}) || $object_utils:isa(dobj, $exit)))
  return player:tell("I don't see that here.");
elseif ((dobj != player) && $object_utils:isa(dobj, $player))
  return player:tell("Hey, how would you like it if someone pushed YOU around? Better reconsider that.");
endif
if (dobj.key && (!$perm_utils:controls(player, dobj)))
  "locked down objects can be moved only by their owners";
  return player:tell("It seems to be stuck tightly where it is.");
elseif ((result = $vrml_utils.test_collisions) && $vrml_utils:causes_collision(dobj, dir, amount))
  amount = result[1];
  bumped = ", until it bumps into " + result[2]:name(1);
else
  bumped = "";
endif
"--finally, just move it";
if (result = $vrml_utils:translate(dobj, amount, directions[dir]))
  player:tell(result);
else
  units = (units[l = length(units)] == "s") ? units[1..l - 1] | units;
  player:tell("You move ", (player == dobj) ? "" | (dobj:name(1) + " "), distance, " ", units, " ", directions[dir + 10], ".");
  player.location:announce(player.name, " moves ", (player == dobj) ? "" | (dobj:name(1) + " "), distance, " ", units, " ", directions[dir + 10], ".");
endif
"Last modified Thu Jan 23 16:25:53 1997 IST by Gustavo (#2).";
.

@verb #6:"@scale*-vrml @scale*vrml" any with any rd #95
@program #6:@scale-vrml
"Set the X, Y, and Z axis VRML scaling for an object";
"If only one number is given, assume the user means evem scaling and apply it to all 3 axes.";
"Omitting the scaling values returns the current setting.";
"Note that scale setting is RELATIVE to old scale setting, and not set to the absolute value specified by the user";
"Setting the scaling to \"0\" has the special meaning of \"resent it to 1:1:1\"";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ($command_utils:object_match_failed(dobj = player:my_match_object(dobjstr), dobjstr))
  return;
elseif (!$perm_utils:controls(player, dobj))
  return player:tell("Sorry, only it's owner can do that.");
elseif (!iobjstr)
  return player:tell("VRML scaling values (X, Y, Z-axis) for ", dobj.name, " currently set to: ", $string_utils:print($vrml_utils:div_by_thousand(dobj:get_vrml_scale())));
endif
set_task_perms(player);
if (iobjstr in {"0", " "})
  if ($command_utils:yes_or_no("Reset scaling values to 1:1:1?"))
    dobj:set_vrml_scale({1000, 1000, 1000});
    player:tell("VRML scaling values (X, Y, Z-axis) for ", dobj.name, " now set to: ", $string_utils:print($vrml_utils:div_by_thousand(dobj:get_vrml_scale())));
  else
    player:tell("VRML scaling values (X, Y, Z-axis) for ", dobj.name, " left unchanged at: ", $string_utils:print($vrml_utils:div_by_thousand(dobj:get_vrml_scale())));
  endif
  return;
endif
"parse out scaling spec";
if (index(iobjstr, ","))
  axes = $string_utils:explode(iobjstr, ",");
elseif (index(iobjstr, " "))
  axes = $string_utils:explode(iobjstr, " ");
else
  axes = {iobjstr};
endif
syntax_msg = {"Usage: @scaling-vrml <object> with <scaling specifier>", "Examples of valid scaling specifiers are:", "  10,5,3    120%    50%,30%,10%    3x, 5x", "Only whole number specifier numbers may be used and if neither \"x\" (fold ratio) or \"%\" (percentage) is given, \"fold ratio\" is assumed."};
if (length(axes) == 1)
  "equally proportional scaling";
  parsed = $vrml_utils:parse_scale_spec(axes[1]);
  if (typeof(parsed[1]) == ERR)
    player:tell(parsed[2]);
    return player:tell_lines(syntax_msg);
  endif
  axes = {parsed[2], parsed[2], parsed[2]};
else
  "non-specified axes are unchanged";
  axes = {@axes, "1", "1"}[1..3];
  parsed = $vrml_utils:parse_scale_spec(axes);
  if (typeof(parsed[1]) == ERR)
    player:tell(parsed[2]);
    return player:tell_lines(syntax_msg);
  endif
  axes = parsed[2];
endif
old_scale = dobj:get_vrml_scale();
for axis in [1..3]
  axes[axis] = (old_scale[axis] * axes[axis]) / 1000;
endfor
if ((result = dobj:set_vrml_scale(axes)) == axes)
  player:tell("New VRML scaling values (X, Y, Z-axis) for ", dobj.name, " set to: ", $string_utils:print($vrml_utils:div_by_thousand(axes)));
else
  player:tell("For some reason, the new VRML scaling values for ", dobj.name, " couldn't be set (", $string_utils:print(result), ").");
endif
"Last modified Fri Apr  5 23:09:03 1996 IDT by EricM (#3264).";
.

@verb #6:"get_vrml_desc" this none this rxd #96
@program #6:get_vrml_desc
"get_vrml_desc(none) -> vrml text LIST";
"if the person's shape is default (the dummy), then hang a";
"face in from with the person's icon if they have an icon";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
desc = pass(@args);
if (is_clear_property(this, "vrml_desc") && (icon = this:get_icon()))
  "if they have an icon, build them a face and plaster the icon onto it";
  face = {"Texture2Transform {center .5 .5 rotation 3.1416}"};
  "person hasn't customized their VRML body from the default";
  face = {@face, tostr("Texture2 {filename \"", icon, "\" wrapS CLAMP wrapT CLAMP}")};
  face = {@face, "Transform {rotation 1 0 0 -1.5709 "};
  face = {@face, "translation 0 .5 -.12  scaleFactor 1 1 1.2}"};
  face = {@face, "Cylinder { radius .13 height .005}"};
  if (desc[max = $] == " }")
    "Stick this inside the bracket -wsk";
    "for clickability";
    desc = listset(desc, "# wsk", max);
    desc = {@desc, @face, " }"};
  else
    "it changed, punt :)";
    desc = {@desc, @face};
  endif
endif
return desc;
"Last modified Mon Aug 26 17:41:21 1996 IDT by EricM (#3264).";
.

@verb #6:"do_out_of_band_command" this none this
@program #6:do_out_of_band_command
":do_out_of_band_command(@args) -> ?";
"called by #0:do_out_of_band_command to handle OOB traffic for this user.";
if (!(caller in {#0, this}))
  return E_PERM;
endif
return $mcp:do_out_of_band_command(@args);
"Last modified Wed Oct  9 00:03:09 1996 IST by EricM (#3264).";
.

@verb #6:"@set-web @set-vrml @setweb @setvrml" any on any rd #95
@program #6:@set-web
"Usage: @set-web @set-vrml <setting name> on <object>";
"Set some or vrml setting, specified by name, on the object";
"Note that while any setting name might be accepted, not all are recognized by the web system as significant";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
class = index(verb, "web") ? "web" | "vrml";
if ($command_utils:object_match_failed(iobj, iobjstr))
  return;
elseif (!$perm_utils:controls(this, iobj))
  return player:tell("Sorry, but only its owner can do that.");
elseif (!dobjstr)
  if (!iobj.(class + "_settings")[1])
    player:tell("No ", class, " settings set on ", iobj:name(1), ".");
  else
    player:tell("Web settings for ", iobj:name(1), ":");
    for setting in [1..length(iobj.(class + "_settings")[1])]
      if (typeof(iobj.(class + "_settings")[2][setting]) == LIST)
        player:tell("  ", iobj.(class + "_settings")[1][setting], " (", length(iobj.(class + "_settings")[2][setting]), " lines):");
        for line in (iobj.(class + "_settings")[2][setting])
          player:tell($string_utils:from_value(line, 0, -1));
        endfor
      else
        player:tell("  ", iobj.(class + "_settings")[1][setting], ": ", $string_utils:from_value(iobj.(class + "_settings")[2][setting], 0, -1));
      endif
    endfor
    player:tell("----");
  endif
  return;
endif
player:tell("Enter the value for the new \"", dobjstr, "\" setting on ", iobj:name(1), ":");
if ((!(value = $command_utils:read())) && $command_utils:yes_or_no("Clear the value?"))
  if (typeof(iobj:(("clear_" + class) + "_setting")(dobjstr)) == ERR)
    player:tell("Sorry, there doesn't seem to be a ", class, " setting of that name to be cleared.");
  else
    player:tell("Setting cleared.");
  endif
else
  "set non-list, non-numeric values to STR";
  if (typeof(result = iobj:(("set_" + class) + "_setting")(dobjstr, value)) != ERR)
    player:tell("Set to: ", $string_utils:from_value(result, 0, -1));
  else
    player:tell("Could not set that, for some reason.");
  endif
endif
"Last modified Sun Mar 10 11:29:10 1996 IST by EricM (#3264).";
.

@verb #6:"reconfunc" this none this
@program #6:reconfunc
this:tell("You reconnect.");
.

@verb #6:"tilt twist" any none any rd #95
@program #6:tilt
"Syntax: tilt <object> <direction> <amount> <units>";
"        twist <object> <direction> <amount> <units>";
"Example: tilt candle north 10 degrees";
"Units are assumed to be degrees, if omitted. Recognized: degrees, radians";
"Directions (abbreviations OK) may be any of: east, west, north, south, up, down ";
"Compass conventions: north = +Z axis, east = +X axis, up = +Y axis";
directions = {"n", "e", "s", "w", "ne", "se", "sw", "nw", "cw", "ccw", "north", "east", "south", "west", "northeast", "southeast", "southwest", "northwest", "clockwise", "counterclockwise"};
words = args;
if (!args)
  return player:tell("You can twist clockwise (cw) or counterclockwise (ccw), and tilt in any of the eight cardinal compass directions.");
endif
"--figure direction";
while (args && (!(dir = args[1] in directions)))
  args = listdelete(args, 1);
endwhile
if (!dir)
  if (verb == "tilt")
    return player:tell("Tilt in what direction? Some possibilities are north, south, east or west.");
  endif
  return player:tell("Twist in what direction? Possibilities are clockwise (cw) or counterclockwise (ccw).");
elseif ((verb == "tilt") && (directions[dir] in {"cw", "ccw", "clockwise", "counterclockwise"}))
  return player:tell("You can TWIST the object in that direction, but not TILT it.");
elseif ((verb == "twist") && (!(directions[dir] in {"cw", "ccw", "clockwise", "counterclockwise"})))
  "$web_utils.owner:tell(\"Direction: \", dir)";
  return player:tell("You can TILT the object in that direction, but not TWIST it.");
endif
"--what to tilt";
dobjstr = (i = index(argstr, directions[dir]) - 1) ? argstr[1..i - 1] | "";
"--how far to tilt it";
angle = (length(words) > (d = directions[dir] in words)) ? words[d + 1] | "1";
if (!$string_utils:is_numeric(angle))
  if (index(angle, "."))
    player:tell("Sorry, only integer values can be used .");
  else
    player:tell("Please specify a numeric, integer ", angle, " to tilt (not \"angle\").");
  endif
  return;
endif
amount = $vrml_utils:angle_in_radians(tonum(angle), units = (length(words) > (d + 1)) ? words[d + 2] | "degrees");
"--and in what direction";
if (typeof(amount) == ERR)
  return player:tell("I don't recognize \"", units, "\" as a measure of units.");
endif
dir = (dir > 10) ? dir - 10 | dir;
if (!dobjstr)
  dobj = player;
elseif ($command_utils:object_match_failed(dobj = player:my_match_object(dobjstr), dobjstr))
  return;
elseif (!((dobj.location in {player, player.location}) || $object_utils:isa(dobj, $exit)))
  return player:tell("I don't see that here.");
elseif ((dobj != player) && $object_utils:isa(dobj, $player))
  return player:tell("Hey, how would you like it if someone pushed YOU around? Better reconsider that.");
endif
if (dobj.key && (!$perm_utils:controls(player, dobj)))
  "locked down objects can be moved only by their owners";
  return player:tell("It seems to be stuck tightly where it is.");
endif
"--finally, just tilt it";
if (result = $vrml_utils:rotate(dobj, amount, directions[dir]))
  player:tell(result);
else
  units = (units[l = length(units)] == "s") ? units[1..l - 1] | units;
  player:tell("You ", verb, " ", (player == dobj) ? "" | (dobj:name(1) + " "), angle, " ", units, " ", directions[dir + 10], ".");
  player.location:announce(player.name, " ", verb, "s ", (player == dobj) ? "" | (dobj:name(1) + " "), angle, " ", units, " ", directions[dir + 10], ".");
endif
"Last modified Tue Jul  1 12:52:36 1997 EDT by EricM (#5058@DU_MainMOO).";
.

"***finished***
