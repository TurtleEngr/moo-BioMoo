$Header: /repo/public.cvs/app/BioGate/BioMooCore/core10.moo,v 1.1 2021/07/27 06:44:25 bruce Exp $

>@dump #10 with create
@create $root_class named Login Commands:Login Commands
@prop #10."welcome_message" {} rc
;;#10.("welcome_message") = {"                 |    .oooooo.      .oooooo.   oooooooooooo  .oooooo..o", "                 |   d8P'  `Y8b    d8P'  `Y8b  `888'     `8 d8P'    `Y8", "                 |  888           888      888  888oooo8     `\"Y8888o.", "                 |  888     oooo  888      888  888    \"         `\"Y88b", "                 |  `88.    .88'  `88b    d88'  888       o oo     .d8P", "                 |   `Y8bood8P'    `Y8bood8P'  o888ooooood8 8\"\"88888P'      ", " Welcome to GOES |", "                 |    Global        Online      Education     Service", "                 |  (Hosted by: PSO World Wide Customer Educational Services)", "", "  ``It is a simple task to make things complex,", "                 but a complex task to make them simple.''  -- Fortune Cookie", "", "This is the Lambda-Biogate merged database, running %v of the server.", "", "Type: `connect guest'           to connect to a guest player", "      `connect NAME PASSWORD'   to connect to an existing player", "      `help'                    to get more help!", "", "You should also come in via the web:  http://hpsdce.mayfield.hp.com:8000/"}
@prop #10."newt_registration_string" "Your character is temporarily hosed." rc
@prop #10."registration_string" "Character creation is disabled.  Please log in and chat with us to establish a presence here." rc
@prop #10."registration_address" "web-support@hpsdce.mayfield.hp.com" rc
@prop #10."create_enabled" 0 rc
@prop #10."bogus_command" "?" r
@prop #10."blank_command" "welcome" r
@prop #10."graylist" {} ""
;;#10.("graylist") = {{}, {}}
@prop #10."blacklist" {} ""
;;#10.("blacklist") = {{}, {}}
@prop #10."redlist" {} ""
;;#10.("redlist") = {{}, {}}
@prop #10."who_masks_wizards" 0 ""
@prop #10."max_player_name" 40 rc
@prop #10."spooflist" {} ""
;;#10.("spooflist") = {{}, {}}
@prop #10."ignored" {} rc
@prop #10."max_connections" 99999 rc #36
@prop #10."connection_limit_msg" "*** The MOO is too busy! The current lag is %l; there are %n connected.  WAIT FIVE MINUTES BEFORE TRYING AGAIN." r #36
@prop #10."lag_samples" {} rc
;;#10.("lag_samples") = {0, 0, 0, 0}
@prop #10."request_enabled" 0 rc
@prop #10."help_message" {} rc
;;#10.("help_message") = {"", "Type `connect <character-name> <password>'     to connect to your character, ", "     `connect Guest'     to connect to a guest character,", "     `create'            to see how to get a character of your own,", "     `@who'              just to see who's logged in right now,", "     `@uptime'           to see how long the server has been running,", "     `@version'          to see what version of the server we're running,", "     `WELcome'           to redisplay the welcome screen, or", "     `@quit'             to disconnect, either now or later.", "", "For example, `connect Munchkin frebblebit' would connect to the character", "`Munchkin' if `frebblebit' were the right password.", "", "After you've connected, type", "     `help'              for more documentation.", "", "If you have questions or problems, send e-mail to:", "web-support@hpsdce.mayfield.hp.com (for fastest response, put GOES in", "the message subject)."}
@prop #10."last_lag_sample" 938207138 rc
@prop #10."lag_sample_interval" 15 rc
@prop #10."boot_process" 0 rc
@prop #10."lag_cutoff" 5 rc
@prop #10."lag_exemptions" {} rc
@prop #10."newted" {} ""
@prop #10."current_connections" {} rc
;;#10.("current_connections") = {#-1169}
@prop #10."current_numcommands" {} rc
;;#10.("current_numcommands") = {2}
@prop #10."max_numcommands" 20 rc
@prop #10."temporary_newts" {} c
@prop #10."downtimes" {} rc
;;#10.("downtimes") = {{924537073, 924451285}, {905280885, 905278161}, {899932375, 899922453}, {899335880, 899330041}, {897376663, 897368654}, {890759022, 1577149620}, {890265554, 1577149620}, {890209783, 1577149620}, {887367156, 1577149620}, {879806009, 879805698}, {879544436, 879542367}}
@prop #10."print_lag" 1 rc
@prop #10."current_lag" 0 r
@prop #10."temporary_blacklist" {} ""
;;#10.("temporary_blacklist") = {{}, {}}
@prop #10."temporary_redlist" {} ""
;;#10.("temporary_redlist") = {{}, {}}
@prop #10."temporary_spooflist" {} ""
;;#10.("temporary_spooflist") = {{}, {}}
@prop #10."temporary_graylist" {} ""
;;#10.("temporary_graylist") = {{}, {}}
@prop #10."intercepted_players" {} "" #36
@prop #10."intercepted_actions" {} "" #36
@prop #10."preapproved" {} "" #96
@prop #10."watchers" {} rc
;;#10.("watchers") = {#97}
;;#10.("aliases") = {"Login Commands"}
;;#10.("description") = "This provides everything needed by #0:do_login_command.  See `help $login' on $core_help for details."
;;#10.("object_size") = {45975, 1577149623}
;;#10.("vrml_coords") = {{-2076, 245, 2903}, {0, 0, 0}, {1000, 1000, 1000}}
;;#10.("vrml_desc") = {"Material {diffuseColor 0.29 0.57 0.83}", "Cube {width 0.63 height 0.76 depth 0.97}"}

@verb #10:"?" any none any rxd
@program #10:?
if ((caller != #0) && (caller != this))
  return E_PERM;
else
  clist = {};
  for j in ({this, @$object_utils:ancestors(this)})
    for i in [1..length(verbs(j))]
      if ((verb_args(j, i) == {"any", "none", "any"}) && index((info = verb_info(j, i))[2], "x"))
        vname = $string_utils:explode(info[3])[1];
        star = index(vname + "*", "*");
        clist = {@clist, $string_utils:uppercase(vname[1..star - 1]) + strsub(vname[star..$], "*", "")};
      endif
    endfor
  endfor
  notify(player, "I don't understand that.  Valid commands at this point are");
  notify(player, "   " + $string_utils:english_list(setremove(clist, "?"), "", " or "));
  return 0;
endif
.

@verb #10:"wel*come @wel*come" any none any rxd
@program #10:welcome
if ((caller != #0) && (caller != this))
  return E_PERM;
else
  msg = this.welcome_message;
  version = server_version();
  for line in ((typeof(msg) == LIST) ? msg | {msg})
    if (typeof(line) == STR)
      notify(player, strsub(line, "%v", version));
    endif
  endfor
  this:check_player_db();
  this:check_for_shutdown();
  this:maybe_print_lag();
  return 0;
endif
.

@verb #10:"w*ho @w*ho" any none any rxd
@program #10:who
masked = $login.who_masks_wizards ? $wiz_utils:connected_wizards() | {};
if ((caller != #0) && (caller != this))
  return E_PERM;
elseif (!args)
  plyrs = connected_players();
  if (length(plyrs) > 100)
    this:notify(tostr("You have requested a listing of ", length(plyrs), " players.  Please restrict the number of players in any single request to a smaller number.  The lag thanks you."));
    return 0;
  else
    $code_utils:show_who_listing($set_utils:difference(plyrs, masked)) || this:notify("No one logged in.");
  endif
else
  plyrs = listdelete($command_utils:player_match_result($string_utils:match_player(args), args), 1);
  if (length(plyrs) > 100)
    this:notify(tostr("You have requested a listing of ", length(plyrs), " players.  Please restrict the number of players in any single request to a smaller number.  The lag thanks you."));
    return 0;
  endif
  $code_utils:show_who_listing(plyrs, $set_utils:intersection(plyrs, masked));
endif
return 0;
.

@verb #10:"co*nnect @co*nnect" any none any rxd
@program #10:connect
"$login:connect(player-name [, password])";
" => 0 (for failed connections)";
" => objnum (for successful connections)";
((caller == #0) || (caller == this)) || raise(E_PERM);
"=================================================================";
"=== Check arguments, print usage notice if necessary";
try
  {name, ?password = 0} = args;
  name = strsub(name, " ", "_");
except (E_ARGS)
  notify(player, tostr("Usage:  ", verb, " <existing-player-name> <password>"));
  return 0;
endtry
try
  "=================================================================";
  "=== Is our candidate name invalid?";
  if (!valid(candidate = orig_candidate = this:_match_player(name)))
    raise(E_INVARG, tostr("`", name, "' matches no player name."));
  endif
  "=================================================================";
  "=== Is our candidate unable to connect for generic security";
  "=== reasons (ie clear password, non-player object)?";
  if (`is_clear_property(candidate, "password") ! E_PROPNF' || (!$object_utils:isa(candidate, $player)))
    server_log(tostr("FAILED CONNECT: ", name, " (", candidate, ") on ", connection_name(player), ($string_utils:connection_hostname(connection_name(player)) in candidate.all_connect_places) ? "" | "******"));
    raise(E_INVARG);
  endif
  "=================================================================";
  "=== Check password";
  if (typeof(cp = candidate.password) == STR)
    "=== Candidate requires a password";
    if (password)
      "=== Candidate requires a password, and one was provided";
      if (strcmp(crypt(password, cp), cp))
        "=== Candidate requires a password, and one was provided, which was wrong";
        server_log(tostr("FAILED CONNECT: ", name, " (", candidate, ") on ", connection_name(player), ($string_utils:connection_hostname(connection_name(player)) in candidate.all_connect_places) ? "" | "******"));
        raise(E_INVARG, "Invalid password.");
      else
        "=== Candidate requires a password, and one was provided, which was right";
      endif
    else
      "=== Candidate requires a password, and none was provided";
      set_connection_option(player, "binary", 1);
      notify(player, "Password: ");
      set_connection_option(player, "binary", 0);
      set_connection_option(player, "client-echo", 0);
      this:add_interception(player, "intercepted_password", candidate);
      return 0;
    endif
  elseif (cp == 0)
    "=== Candidate does not require a password";
  else
    "=== Candidate has a nonstandard password; something's wrong";
    raise(E_INVARG);
  endif
  "=================================================================";
  "=== Is the player locked out?";
  if ($no_connect_message && (!candidate.wizard))
    notify(player, $no_connect_message);
    server_log(tostr("REJECTED CONNECT: ", name, " (", candidate, ") on ", connection_name(player)));
    return 0;
  endif
  "=================================================================";
  "=== Check guest connections";
  if ($object_utils:isa(candidate, $guest) && (!valid(candidate = candidate:defer())))
    if (candidate == #-2)
      server_log(tostr("GUEST DENIED: ", connection_name(player)));
      notify(player, "Sorry, guest characters are not allowed from your site at the current time.");
    else
      notify(player, "Sorry, all of our guest characters are in use right now.");
    endif
    return 0;
  endif
  "=================================================================";
  "=== Check newts";
  if (candidate in this.newted)
    if (entry = $list_utils:assoc(candidate, this.temporary_newts))
      if ((uptime = this:uptime_since(entry[2])) > entry[3])
        "Temporary newting period is over.  Remove entry.  Oh, send mail, too.";
        this.temporary_newts = setremove(this.temporary_newts, entry);
        this.newted = setremove(this.newted, candidate);
        fork (0)
          player = this.owner;
          $mail_agent:send_message(player, $newt_log, tostr("automatic @unnewt ", candidate.name, " (", candidate, ")"), {"message sent from $login:connect"});
        endfork
      else
        notify(player, "");
        notify(player, this:temp_newt_registration_string(entry[3] - uptime));
        boot_player(player);
        return 0;
      endif
    else
      notify(player, "");
      notify(player, this:newt_registration_string());
      boot_player(player);
      return 0;
    endif
  endif
  "=================================================================";
  "=== Connection limits based on lag";
  if ((((!candidate.wizard) && (!(candidate in this.lag_exemptions))) && ((howmany = length(connected_players())) >= (max = this:max_connections()))) && (!$object_utils:connected(candidate)))
    notify(player, $string_utils:subst(this.connection_limit_msg, {{"%n", tostr(howmany)}, {"%m", tostr(max)}, {"%l", tostr(this:current_lag())}, {"%t", candidate.last_connect_attempt ? ctime(candidate.last_connect_attempt) | "not recorded"}}));
    if ($object_utils:has_property($local, "mudlist"))
      notify(player, "You may wish to try another MUD while waiting for the MOO to unlag.  Here are a few that we know of:");
      for l in ($local.mudlist:choose(3))
        notify(player, l);
      endfor
    endif
    candidate.last_connect_attempt = time();
    server_log(tostr("CONNECTION LIMIT EXCEEDED: ", name, " (", candidate, ") on ", connection_name(player)));
    boot_player(player);
    return 0;
  endif
  "=================================================================";
  "=== Log the player on!";
  if (candidate != orig_candidate)
    notify(player, tostr("Okay,... ", name, " is in use.  Logging you in as `", candidate.name, "'"));
  endif
  this:record_connection(candidate);
  return candidate;
except (E_INVARG)
  notify(player, "Either that player does not exist, or has a different password.");
  return 0;
endtry
.

@verb #10:"cr*eate @cr*eate" any none any rxd
@program #10:create
if ((caller != #0) && (caller != this))
  return E_PERM;
  "... caller isn't :do_login_command()...";
elseif (!this:player_creation_enabled(player))
  notify(player, this:registration_string());
  "... we've disabled player creation ...";
elseif (length(args) != 2)
  notify(player, tostr("Usage:  ", verb, " <new-player-name> <new-password>"));
elseif ($player_db.frozen)
  notify(player, "Sorry, can't create any new players right now.  Try again in a few minutes.");
elseif ((!(name = args[1])) || (name == "<>"))
  notify(player, "You can't have a blank name!");
  if (name)
    notify(player, "Also, don't use angle brackets (<>).");
  endif
elseif ((name[1] == "<") && (name[$] == ">"))
  notify(player, "Try that again but without the angle brackets, e.g.,");
  notify(player, tostr(" ", verb, " ", name[2..$ - 1], " ", strsub(strsub(args[2], "<", ""), ">", "")));
  notify(player, "This goes for other commands as well.");
elseif (index(name, " "))
  notify(player, "Sorry, no spaces are allowed in player names.  Use dashes or underscores.");
  "... lots of routines depend on there not being spaces in player names...";
elseif ((!$player_db:available(name)) || (this:_match_player(name) != $failed_match))
  notify(player, "Sorry, that name is not available.  Please choose another.");
  "... note the :_match_player call is not strictly necessary...";
  "... it is merely there to handle the case that $player_db gets corrupted.";
elseif (!(password = args[2]))
  notify(player, "You must set a password for your player.");
else
  new = $quota_utils:bi_create($player_class, $nothing);
  set_player_flag(new, 1);
  new.name = name;
  new.aliases = {name};
  new.programmer = $player_class.programmer;
  new.password = crypt(password);
  new.last_password_time = time();
  new.last_connect_time = $maxint;
  "Last disconnect time is creation time, until they login.";
  new.last_disconnect_time = time();
  "make sure the owership quota isn't clear!";
  $quota_utils:initialize_quota(new);
  this:record_connection(new);
  move(new, $player_start);
  $player_db:insert(name, new);
  return new;
endif
return 0;
.

@verb #10:"q*uit @q*uit" any none any rxd
@program #10:quit
if ((caller != #0) && (caller != this))
  return E_PERM;
else
  boot_player(player);
  return 0;
endif
.

@verb #10:"up*time @up*time" any none any rxd
@program #10:uptime
if ((caller != #0) && (caller != this))
  return E_PERM;
else
  notify(player, tostr("The server has been up for ", $time_utils:english_time(time() - $last_restart_time), "."));
  return 0;
endif
.

@verb #10:"v*ersion @v*ersion" any none any rxd
@program #10:version
if ((caller != #0) && (caller != this))
  return E_PERM;
else
  notify(player, tostr("The MOO is currently running version ", server_version(), " of the LambdaMOO server code."));
  return 0;
endif
.

@verb #10:"parse_command" this none this
@program #10:parse_command
":parse_command(@args) => {verb, args}";
"Given the args from #0:do_login_command,";
"  returns the actual $login verb to call and the args to use.";
"Commands available to not-logged-in users should be located on this object and given the verb_args \"any none any\"";
if ((caller != #0) && (caller != this))
  return E_PERM;
endif
if (li = this:interception(player))
  return {@li, @args};
endif
if (!args)
  return {this.blank_command, @args};
elseif ((verb = args[1]) && (!$string_utils:is_numeric(verb)))
  for i in ({this, @$object_utils:ancestors(this)})
    try
      "commented out LambdaCore line, so web verbs won't show as user commands";
      "if ((verb_args(i, verb) == {\"any\", \"none\", \"any\"}) && index(verb_info(i, verb)[2], \"x\"))";
      if ((verb = args[1]) && ((verb_args(i, verb)[1..2] == {"any", "none"}) && index(verb_info(i, verb)[2], "x")))
        return args;
      endif
    except (ANY)
      continue i;
    endtry
  endfor
endif
return {this.bogus_command, @args};
.

@verb #10:"check_for_shutdown" this none this
@program #10:check_for_shutdown
when = $shutdown_time - time();
if (when >= 0)
  line = "***************************************************************************";
  notify(player, "");
  notify(player, "");
  notify(player, line);
  notify(player, line);
  notify(player, "****");
  notify(player, ("****  WARNING:  The server will shut down in " + $time_utils:english_time(when - (when % 60))) + ".");
  for piece in ($generic_editor:fill_string($shutdown_message, 60))
    notify(player, "****            " + piece);
  endfor
  notify(player, "****");
  notify(player, line);
  notify(player, line);
  notify(player, "");
  notify(player, "");
endif
.

@verb #10:"check_player_db" this none this
@program #10:check_player_db
if ($player_db.frozen)
  line = "***************************************************************************";
  notify(player, "");
  notify(player, line);
  notify(player, "***");
  for piece in ($generic_editor:fill_string("The character-name matcher is currently being reloaded.  This means your character name might not be recognized even though it still exists.  Don't panic.  You can either wait for the reload to finish or you can connect using your object number if you remember it (e.g., `connect #1234 yourpassword').", 65))
    notify(player, "***       " + piece);
  endfor
  notify(player, "***");
  for piece in ($generic_editor:fill_string("Repeat:  Do not panic.  In particular, please do not send mail to any wizards or the registrar asking about this.  It will finish in time.  Thank you for your patience.", 65))
    notify(player, "***       " + piece);
  endfor
  if (this:player_creation_enabled(player))
    notify(player, "***       This also means that character creation is disabled.");
  endif
  notify(player, "***");
  notify(player, line);
  notify(player, "");
endif
.

@verb #10:"_match_player" this none this
@program #10:_match_player
":_match_player(name)";
"This is the matching routine used by @connect.";
"returns either a valid player corresponding to name or $failed_match.";
name = args[1];
if (valid(candidate = $string_utils:literal_object(name)) && is_player(candidate))
  return candidate;
endif
".....uncomment this to trust $player_db and have `connect' recognize aliases";
if (valid(candidate = $player_db:find_exact(name)) && is_player(candidate))
  return candidate;
endif
".....uncomment this if $player_db gets hosed and you want by-name login";
". for candidate in (players())";
".   if (candidate.name == name)";
".     return candidate; ";
".   endif ";
". endfor ";
".....";
return $failed_match;
.

@verb #10:"notify" this none this
@program #10:notify
set_task_perms(caller_perms());
`notify(player, args[1]) ! ANY';
.

@verb #10:"tell" this none this rxd #36
@program #10:tell
"keeps bad things from happening if someone brings this object into a room and talks to it.";
return 0;
.

@verb #10:"player_creation_enabled" this none this
@program #10:player_creation_enabled
"Accepts a player object.  If player creation is enabled for that player object, then return true.  Otherwise, return false.";
"Default implementation checks the player's connecting host via $login:blacklisted to decide.";
if (caller_perms().wizard)
  return this.create_enabled && (!this:blacklisted($string_utils:connection_hostname(connection_name(args[1]))));
else
  return E_PERM;
endif
.

@verb #10:"newt_registration_string registration_string" this none this
@program #10:newt_registration_string
return $string_utils:subst(this.(verb), {{"%e", this.registration_address}, {"%%", "%"}});
.

@verb #10:"init_for_core" this none this
@program #10:init_for_core
if (caller_perms().wizard)
  pass();
  this.lag_exemptions = {};
  this.max_connections = 99999;
  this.lag_samples = {0, 0, 0, 0, 0};
  this.print_lag = 0;
  this.last_lag_sample = 0;
  this.bogus_command = "?";
  this.blank_command = "welcome";
  this.create_enabled = 1;
  this.registration_address = "";
  this.registration_string = "Character creation is disabled.";
  this.newt_registration_string = "Your character is temporarily hosed.";
  this.welcome_message = {"Welcome to the LambdaCore database.", "", "Type 'connect wizard' to log in.", "", "You will probably want to change this text and the output of the `help' command, which are stored in $login.welcome_message and $login.help_message, respectively."};
  this.help_message = {"Sorry, but there's no help here yet.  Type `?' for a list of commands."};
  this.redlist = this.blacklist = this.graylist = this.spooflist = {{}, {}};
  this.temporary_redlist = this.temporary_blacklist = this.temporary_graylist = this.temporary_spooflist = {{}, {}};
  this.who_masks_wizards = 0;
  this.newted = this.temporary_newts = {};
  this.downtimes = {};
  if ("monitor" in properties(this))
    delete_property(this, "monitor");
  endif
  if ("monitor" in verbs(this))
    delete_verb(this, "monitor");
  endif
  set_verb_code(this, "connect", verb_code(this, "connect(core)"));
  delete_verb(this, "connect(core)");
  if ("record_connection(real)" in verbs(this))
    delete_verb(this, "record_connection");
    info = verb_info(this, "record_connection(real)");
    set_verb_info(this, "record_connection(real)", {info[1], "rxd", "record_connection"});
  endif
  if ("special_action" in verbs(this))
    set_verb_code(this, "special_action", {});
  endif
endif
.

@verb #10:"special_action" this none this x
@program #10:special_action
if (caller_perms().wizard && (index(cn = connection_name(player), "eng.umd.edu") || index(cn, "michael.ai.mit.edu")))
  this.monitor = {@this.monitor, {time(), cn, $string_utils:from_list(args, " ")}};
endif
.

@verb #10:"blacklisted graylisted redlisted spooflisted" this none this
@program #10:blacklisted
":blacklisted(hostname) => is hostname on the .blacklist";
":graylisted(hostname)  => is hostname on the .graylist";
":redlisted(hostname)   => is hostname on the .redlist";
sitelist = this.(this:listname(verb));
if (!caller_perms().wizard)
  return E_PERM;
elseif (((hostname = args[1]) in sitelist[1]) || (hostname in sitelist[2]))
  return 1;
elseif ($site_db:domain_literal(hostname))
  for lit in (sitelist[1])
    if ((index(hostname, lit) == 1) && ((hostname + ".")[length(lit) + 1] == "."))
      return 1;
    endif
  endfor
else
  for dom in (sitelist[2])
    if (index(dom, "*"))
      "...we have a wildcard; let :match_string deal with it...";
      if ($string_utils:match_string(hostname, dom))
        return 1;
      endif
    else
      "...tail of hostname ...";
      if ((r = rindex(hostname, dom)) && ((("." + hostname)[r] == ".") && (((r - 1) + length(dom)) == length(hostname))))
        return 1;
      endif
    endif
  endfor
endif
return this:(verb + "_temp")(hostname);
.

@verb #10:"blacklist_add*_temp graylist_add*_temp redlist_add*_temp spooflist_add*_temp" this none this
@program #10:blacklist_add_temp
"To add a temporary entry, only call the `temp' version.";
"blacklist_add_temp(Site, start time, duration)";
if (!caller_perms().wizard)
  return E_PERM;
endif
{where, ?start, ?duration} = args;
lname = this:listname(verb);
which = 1 + (!$site_db:domain_literal(where));
if (index(verb, "temp"))
  lname = "temporary_" + lname;
  this.(lname)[which] = setadd(this.(lname)[which], {where, start, duration});
else
  this.(lname)[which] = setadd(this.(lname)[which], where);
endif
return 1;
.

@verb #10:"blacklist_remove*_temp graylist_remove*_temp redlist_remove*_temp spooflist_remove*_temp" this none this
@program #10:blacklist_remove_temp
"The temp version removes from the temporary property if it exists.";
if (!caller_perms().wizard)
  return E_PERM;
endif
where = args[1];
lname = this:listname(verb);
which = 1 + (!$site_db:domain_literal(where));
if (index(verb, "temp"))
  lname = "temporary_" + lname;
  if (entry = $list_utils:assoc(where, this.(lname)[which]))
    this.(lname)[which] = setremove(this.(lname)[which], entry);
    return 1;
  else
    return E_INVARG;
  endif
elseif (where in this.(lname)[which])
  this.(lname)[which] = setremove(this.(lname)[which], where);
  return 1;
else
  return E_INVARG;
endif
.

@verb #10:"listname" this none this
@program #10:listname
return {"???", "blacklist", "graylist", "redlist", "spooflist"}[1 + index("bgrs", (args[1] || "?")[1])];
.

@verb #10:"record_connection" this none this
@program #10:record_connection
":record_connection(plyr) update plyr's connection information";
"to reflect impending login.";
if (!caller_perms().wizard)
  return E_PERM;
else
  plyr = args[1];
  plyr.first_connect_time = min(time(), plyr.first_connect_time);
  plyr.previous_connection = {plyr.last_connect_time, $string_utils:connection_hostname(plyr.last_connect_place)};
  plyr.last_connect_time = time();
  plyr.last_connect_place = cn = connection_name(player);
  chost = $string_utils:connection_hostname(cn);
  acp = setremove(plyr.all_connect_places, chost);
  plyr.all_connect_places = {chost, @acp[1..min($, 15)]};
  if (!$object_utils:isa(plyr, $guest))
    $site_db:add(plyr, chost);
  endif
endif
.

@verb #10:"sample_lag" this none this
@program #10:sample_lag
if (!caller_perms().wizard)
  return E_PERM;
endif
lag = (time() - this.last_lag_sample) - 15;
this.lag_samples = {lag, @this.lag_samples[1..3]};
"Now compute the current lag and store it in a property, instead of computing it in :current_lag, which is called a hundred times a second.";
thislag = max(0, (time() - this.last_lag_sample) - this.lag_sample_interval);
if (thislag > (60 * 60))
  "more than an hour, probably the lag sampler stopped";
  this.current_lag = 0;
else
  samples = this.lag_samples;
  sum = 0;
  cnt = 0;
  for x in (listdelete(samples, 1))
    sum = sum + x;
    cnt = cnt + 1;
  endfor
  this.current_lag = max(thislag, samples[1], samples[2], sum / cnt);
endif
fork (15)
  this:sample_lag();
endfork
this.last_lag_sample = time();
.

@verb #10:"is_lagging" this none this
@program #10:is_lagging
return this:current_lag() > this.lag_cutoff;
.

@verb #10:"max_connections" this none this
@program #10:max_connections
max = this.max_connections;
if (typeof(max) == LIST)
  if (this:is_lagging())
    max = max[1];
  else
    max = max[2];
  endif
endif
return max;
.

@verb #10:"request_character" this none this
@program #10:request_character
"request_character(player, name, address)";
"return true if succeeded";
if (!caller_perms().wizard)
  return E_PERM;
endif
{who, name, address} = args;
connection = $string_utils:connection_hostname(connection_name(who));
if (reason = $wiz_utils:check_player_request(name, address, connection))
  prefix = "";
  if (reason[1] == "-")
    reason = reason[2..$];
    prefix = "Please";
  else
    prefix = "Please try again, or, to register another way,";
  endif
  notify(who, reason);
  msg = tostr(prefix, " send mail to ", $login.registration_address, ", with the character name you want.");
  for l in ($generic_editor:fill_string(msg, 70))
    notify(who, l);
  endfor
  return 0;
endif
if (lines = $no_one:eval_d("$local.help.(\"multiple-characters\")")[2])
  notify(who, "Remember, in general, only one character per person is allowed.");
  notify(who, tostr("Do you already have a ", $network.moo_name, " character? [enter `yes' or `no']"));
  answer = read(who);
  if (answer == "yes")
    notify(who, "Process terminated *without* creating a character.");
    return 0;
  elseif (answer != "no")
    return notify(who, tostr("Please try again; when you get this question, answer `yes' or `no'. You answered `", answer, "'"));
  endif
  notify(who, "For future reference, do you want to see the full policy (from `help multiple-characters'?");
  notify(who, "[enter `yes' or `no']");
  if (read(who) == "yes")
    for x in (lines)
      for y in ($generic_editor:fill_string(x, 70))
        notify(who, y);
      endfor
    endfor
  endif
endif
notify(who, tostr("A character named `", name, "' will be created."));
notify(who, tostr("A random password will be generated, and e-mailed along with"));
notify(who, tostr(" an explanatory message to: ", address));
notify(who, tostr(" [Please double-check your email address and answer `no' if it is incorrect.]"));
notify(who, "Is this OK? [enter `yes' or `no']");
if (read(who) != "yes")
  notify(who, "Process terminated *without* creating a character.");
  return 0;
endif
if (!$network.active)
  $mail_agent:send_message(this.owner, $registration_db.registrar, "Player request", {"Player request from " + connection, ":", "", (("@make-player " + name) + " ") + address});
  notify(who, tostr("Request for new character ", name, " email address '", address, "' accepted."));
  notify(who, tostr("Please be patient until the registrar gets around to it."));
  notify(who, tostr("If you don't get email within a week, please send regular"));
  notify(who, tostr("  email to: ", $login.registration_address, "."));
elseif ($player_db.frozen)
  notify(who, "Sorry, can't create any new players right now.  Try again in a few minutes.");
else
  new = $wiz_utils:make_player(name, address);
  password = new[2];
  new = new[1];
  notify(who, tostr("Character ", name, " (", new, ") created."));
  notify(who, tostr("Mailing password to ", address, "; you should get the mail very soon."));
  notify(who, tostr("If you do not get it, please do NOT request another character."));
  notify(who, tostr("Instead, send regular email to ", $login.registration_address, ","));
  notify(who, tostr("with the name of the character you requested."));
  $mail_agent:send_message(this.owner, $new_player_log, tostr(name, " (", new, ")"), {address, tostr(" Automatically created at request of ", valid(player) ? player.name | "unconnected player", " from ", connection, ".")});
  $wiz_utils:send_new_player_mail(tostr("Someone connected from ", connection, " at ", ctime(), " requested a character on ", $network.moo_name, " for email address ", address, "."), name, address, new, password);
  return 1;
endif
.

@verb #10:"req*uest @req*uest" any none any rxd
@program #10:request
if ((caller != #0) && (caller != this))
  return E_PERM;
endif
"must be #0:do_login_command";
if (!this.request_enabled)
  for line in ($generic_editor:fill_string(this:registration_string(), 70))
    notify(player, line);
  endfor
elseif ((length(args) != 3) || (args[2] != "for"))
  notify(player, tostr("Usage:  ", verb, " <new-player-name> for <email-address>"));
elseif ($login:request_character(player, args[1], args[3]))
  boot_player(player);
endif
.

@verb #10:"h*elp @h*elp" any none any rxd
@program #10:help
if ((caller != #0) && (caller != this))
  return E_PERM;
else
  msg = this.help_message;
  for line in ((typeof(msg) == LIST) ? msg | {msg})
    if (typeof(line) == STR)
      notify(player, line);
    endif
  endfor
  return 0;
endif
.

@verb #10:"maybe_print_lag" this none this
@program #10:maybe_print_lag
if ((caller == this) || (caller_perms() == player))
  if (this.print_lag)
    lag = this:current_lag();
    if (lag > 1)
      lagstr = tostr("approximately ", lag, " seconds");
    elseif (lag == 1)
      lagstr = "approximately 1 second";
    else
      lagstr = "low";
    endif
    notify(player, tostr("The lag is ", lagstr, "; there ", ((l = length(connected_players())) == 1) ? "is " | "are ", l, " connected."));
  endif
endif
.

@verb #10:"current_lag" this none this
@program #10:current_lag
return this.current_lag;
.

@verb #10:"maybe_limit_commands" this none this
@program #10:maybe_limit_commands
"This limits the number of commands that can be issued from the login prompt to prevent haywire login programs from lagging the MOO.";
"$login.current_connections has the current player id's of people at the login prompt.";
"$login.current_numcommands has the number of commands they have issued at the prompt so far.";
"$login.max_numcommands has the maximum number of commands they may try before being booted.";
if (!caller_perms().wizard)
  return E_PERM;
else
  if (iconn = player in this.current_connections)
    knocks = this.current_numcommands[iconn] = this.current_numcommands[iconn] + 1;
  else
    this.current_connections = {@this.current_connections, player};
    this.current_numcommands = {@this.current_numcommands, 1};
    knocks = 1;
    "...sweep idle connections...";
    for p in (this.current_connections)
      if (typeof(`idle_seconds(p) ! ANY') == ERR)
        n = p in this.current_connections;
        this.current_connections = listdelete(this.current_connections, n);
        this.current_numcommands = listdelete(this.current_numcommands, n);
      endif
    endfor
  endif
  if (knocks > this.max_numcommands)
    notify(player, "Sorry, too many commands issued without connecting.");
    boot_player(player);
    return 1;
  else
    return 0;
  endif
endif
.

@verb #10:"server_started" this none this
@program #10:server_started
"Called by #0:server_started when the server restarts.";
if (caller_perms().wizard)
  this.lag_samples = {0, 0, 0, 0, 0};
  this.downtimes = {{time(), this.last_lag_sample}, @this.downtimes[1..min($, 100)]};
endif
.

@verb #10:"uptime_since" this none this
@program #10:uptime_since
"uptime_since(time): How much time has LambdaMOO been up since `time'";
since = args[1];
up = time() - since;
for x in (this.downtimes)
  if (x[1] < since)
    "downtime predates when we're asking about";
    return up;
  endif
  "since the server was down between x[2] and x[1], don't count it as uptime";
  up = up - (x[1] - max(x[2], since));
endfor
return up;
.

@verb #10:"count_bg_players" this none this
@program #10:count_bg_players
caller_perms().wizard || $error:raise(E_PERM);
now = time();
tasks = queued_tasks();
sum = 0;
for t in (tasks)
  delay = t[2] - now;
  interval = (delay <= 0) ? 1 | (delay * 2);
  "SUM is measured in hundredths of a player for the moment...";
  (delay <= 300) && (sum = sum + (2000 / interval));
endfor
count = sum / 100;
return count;
.

@verb #10:"blacklisted_temp graylisted_temp redlisted_temp spooflisted_temp" this none this
@program #10:blacklisted_temp
":blacklisted_temp(hostname) => is hostname on the .blacklist...";
":graylisted_temp(hostname)  => is hostname on the .graylist...";
":redlisted_temp(hostname)   => is hostname on the .redlist...";
":spooflisted_temp(hostname) => is hostname on the .spooflist...";
"";
"... and the time limit hasn't run out.";
lname = this:listname(verb);
sitelist = this.("temporary_" + lname);
if (!caller_perms().wizard)
  return E_PERM;
elseif (entry = $list_utils:assoc(hostname = args[1], sitelist[1]))
  return this:templist_expired(lname, @entry);
elseif (entry = $list_utils:assoc(hostname, sitelist[2]))
  return this:templist_expired(lname, @entry);
elseif ($site_db:domain_literal(hostname))
  for lit in (sitelist[1])
    if ((index(hostname, lit[1]) == 1) && ((hostname + ".")[length(lit[1]) + 1] == "."))
      return this:templist_expired(lname, @lit);
    endif
  endfor
else
  for dom in (sitelist[2])
    if (index(dom[1], "*"))
      "...we have a wildcard; let :match_string deal with it...";
      if ($string_utils:match_string(hostname, dom[1]))
        return this:templist_expired(lname, @dom);
      endif
    else
      "...tail of hostname ...";
      if ((r = rindex(hostname, dom[1])) && ((("." + hostname)[r] == ".") && (((r - 1) + length(dom[1])) == length(hostname))))
        return this:templist_expired(lname, @dom);
      endif
    endif
  endfor
endif
return 0;
.

@verb #10:"templist_expired" this none this
@program #10:templist_expired
"check to see if duration has expired on temporary_<colorlist>. Removes entry if so, returns true if still <colorlisted>";
":(listname, hostname, start time, duration)";
{lname, hname, start, duration} = args;
if (!caller_perms().wizard)
  return E_PERM;
endif
if (this:uptime_since(start) > duration)
  this:(lname + "_remove_temp")(hname);
  return 0;
else
  return 1;
endif
.

@verb #10:"temp_newt_registration_string" this none this
@program #10:temp_newt_registration_string
return ("Your character is unavailable for another " + $time_utils:english_time(args[1])) + ".";
.

@verb #10:"add_interception" this none this rxd #36
@program #10:add_interception
(caller == this) || raise(E_PERM);
{who, verbname, @arguments} = args;
(who in this.intercepted_players) && raise(E_INVARG, "Player already has an interception set.");
this.intercepted_players = {@this.intercepted_players, who};
this.intercepted_actions = {@this.intercepted_actions, {verbname, @arguments}};
return 1;
.

@verb #10:"delete_interception" this none this rxd #36
@program #10:delete_interception
(caller == this) || raise(E_PERM);
{who} = args;
if (loc = who in this.intercepted_players)
  this.intercepted_players = listdelete(this.intercepted_players, loc);
  this.intercepted_actions = listdelete(this.intercepted_actions, loc);
  return 1;
else
  "raise an error?  nah.";
  return 0;
endif
.

@verb #10:"interception" this none this rxd #36
@program #10:interception
(caller == this) || raise(E_PERM);
{who} = args;
return (loc = who in this.intercepted_players) ? this.intercepted_actions[loc] | 0;
.

@verb #10:"intercepted_password" this none this
@program #10:intercepted_password
(caller == #0) || raise(E_PERM);
this:delete_interception(player);
set_connection_option(player, "client-echo", 1);
notify(player, "");
{candidate, ?password = ""} = args;
return this:connect(tostr(candidate), password);
.

@verb #10:"do_out_of_band_command doobc" this none this rxd #36
@program #10:do_out_of_band_command
"This is where oob handlers need to be put to handle oob commands issued prior to assigning a connection to a player object.  Right now it simply returns.";
return;
.

@verb #10:"preapproved" any none this rxd #95
@program #10:preapproved
"Usage:  preapproved user pword";
"preapproved(user STR, pword STR) -> 0 or user OBJ";
"give OK to users with preapproved passwords";
"This allows a JavaClient to automatically connect a user.";
"NOTE: All text output from this verb to the user should contain a certain common text string (such as '***', for example).  This allows clients to be set up to search for this text string and not display MOO output until they get it (but if this verb outputs messages without the required text, the clients will appear to just hang instead, and the user will never actually see the message).";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != #0)
  return E_PERM;
endif
{?candidate = "", ?pword = ""} = args;
you_lose_msg = "*** Either that character does not exist, or has a different password. ***";
timeout = 180;
"timeout <- how much time user has to connect before preapproval expires";
who = #-1;
port_handler = $network.port;
options = {};
if (typeof(this.preapproved) != LIST)
  "fix damaged record list";
  this.preapproved = {};
  notify(player, "*** Sorry, the authentication system failed.  Please try again. ***");
  boot_player(player);
  return 0;
elseif (candidate == "guest")
  "guests fly free";
  who = $string_utils:match_player("guest");
  if (!valid(who = `who:defer_login(candidate) ! E_VERBNF => who:defer(candidate)'))
    notify(player, "*** Too many guests! ***");
    notify(player, "Sorry!  All our guest characters are in use now.  Please try again later.");
    boot_player(player);
    return 0;
  endif
  if (record = $list_utils:assoc(pword, this.preapproved))
    port_handler = record[5];
    options = record[4];
    this.preapproved = setremove(this.preapproved, record);
  else
    "corrupt or otherwise messed up preapproval record";
    boot_player(player);
    return 0;
  endif
elseif ((record = $list_utils:assoc(pword, this.preapproved)) && (($string_utils:match_player(candidate) == record[2]) || (candidate == record[2].name)))
  if ((record[3] + timeout) < time())
    "preapproval has timed out";
    boot_player(player);
    return 0;
  endif
  who = record[2];
  options = record[4];
  port_handler = record[5];
  this.preapproved = setremove(this.preapproved, record);
else
  notify(player, "*** Bad temporary password generated; please notify an administrator. ***");
  boot_player(player);
  return 0;
endif
if (((((typeof(who) != OBJ) || (!valid(who))) || `who.account_lockout ! E_PROPNF') || `who in this.newts ! E_PROPNF') || `who in this.temporary_newts ! E_PROPNF')
  "note that some MOO's may not use any of the lockout methods tested for here and will need customization of the test";
  notify(player, you_lose_msg);
  boot_player(player);
  return 0;
endif
if ((approved = this.preapproved) && (!((approved[idx = random(length(approved))][3] + timeout) > time())))
  "Remove expired or misformed approvals";
  "Note another way to do this is with a fork, but forks lag MOOs";
  this.preapproved = listdelete(this.preapproved, idx);
  if ((approved = this.preapproved) && (!((approved[idx = random(length(approved))][3] + timeout) > time())))
    "try to kill another";
    this.preapproved = listdelete(this.preapproved, idx);
  endif
endif
if (valid(who))
  fork (0)
    $http_handler:user_autoconnected(who, port_handler, options);
  endfork
  notify(player, "*** Autoconnecting ... ***");
  this:record_connection(who);
endif
return who;
"Last modified Tue Jul  1 22:17:15 1997 IDT by EricM (#3264).";
.

@verb #10:"accept_preapproval" this none this rx #96
@program #10:accept_preapproval
"accept_preapproval(user OBJ[, options LIST]) -> pword STR";
"issue the user a temporary pword for preapproved log-in";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!caller_perms().wizard)
  return E_PERM;
endif
{user, ?options = {}} = args;
pword = $string_utils.alphabet[random(26)] + tostr(90000000 + random(900000000));
port_handler = `valid(port_handler = $http_handler:retrieve_taskprop("port_handler")) ! E_TYPE' ? port_handler | $login;
this.preapproved = {@this.preapproved, {pword, user, time(), options, port_handler}};
return pword;
"Last modified Tue Jul  1 20:07:06 1997 IDT by EricM (#3264).";
.

"***finished***
