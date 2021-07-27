$Header: /repo/public.cvs/app/BioGate/BioMooCore/core31.moo,v 1.1 2021/07/27 06:44:30 bruce Exp $

>@dump #31 with create
@create $frand_class named Generic Guest:Generic Guest
@prop #31."default_gender" "either" r
@prop #31."default_description" {} r
;;#31.("default_description") = {"By definition, guests appear nondescript."}
@prop #31."request" 0 "" #2
@prop #31."extra_confunc_msg" "" rc
@prop #31."free_to_use" 1 r
;;#31.("mail_forward") = "%t (%[#t]) is a guest character."
;;#31.("features") = {#92, #91, #132}
;;#31.("linelen") = 79
;;#31.("lines") = 30
;;#31.("pq") = "his/hers"
;;#31.("pqc") = "His/Hers"
;;#31.("gender") = "either"
;;#31.("prc") = "(Him/Her)self"
;;#31.("ppc") = "His/Her"
;;#31.("poc") = "Him/Her"
;;#31.("psc") = "S/He"
;;#31.("pr") = "(him/her)self"
;;#31.("pp") = "his/her"
;;#31.("po") = "him/her"
;;#31.("ps") = "s/he"
;;#31.("password") = 0
;;#31.("paranoid") = 1
;;#31.("size_quota") = {0, 0, 0, 0}
;;#31.("web_options") = {{"telnet_applet", #110}, "applinkdown", "exitdetails", "map", "embedVRML", "separateVRML"}
;;#31.("aliases") = {"Generic Guest"}
;;#31.("description") = {"By definition, guests appear nondescript."}
;;#31.("object_size") = {12731, 855068591}
;;#31.("vrml_desc") = {"WWWInline {name \"http://hppsda.mayfield.hp.com/image/body.wrl\"}", ""}

@verb #31:"boot" this none this rxd #2
@program #31:boot
if (!caller_perms().wizard)
  return;
endif
player = this;
this:notify(tostr("Sorry, but you've been here for ", $string_utils:from_seconds(connected_seconds(this)), " and someone else wants to be a guest now.  Feel free to come back", @$login:player_creation_enabled(player) ? {" or even create your own character if you want..."} | {" or type `create' to learn more about how to get a character of your own."}));
"boot_player(this)";
return;
"See #0:user_reconnected.";
.

@verb #31:"disfunc" this none this rxd #2
@program #31:disfunc
if ((((valid(cp = caller_perms()) && (caller != this)) && (!$perm_utils:controls(cp, this))) && (cp != this)) && (caller != #0))
  return E_PERM;
endif
"Don't let another guest use this one until all this is done. See :defer, Ho_Yan 1/19/94";
this.free_to_use = 0;
this:log_disconnect();
this:erase_paranoid_data();
try
  if (this.location != this.home)
    this:room_announce(player.name, " has disconnected.");
    this:room_announce("The housekeeper arrives to remove ", this.name, ".");
    move(this, this.home);
    this:room_announce("The housekeeper arrives to drop off ", this.name, ".");
  endif
finally
  this:do_reset();
  this.free_to_use = 1;
endtry
.

@verb #31:"defer" this none this rxd #2
@program #31:defer
"Called by #0:connect_player when this object is about to be used as the next guest character.  Usually returns `this', but if for some reason some other guest character should be used, that player object is returned instead";
if (!caller_perms().wizard)
  "...caller is not :do_login_command; doesn't matter what we return...";
  return this;
elseif ($login:blacklisted($string_utils:connection_hostname(connection_name(player))))
  return #-2;
elseif (!(this in connected_players()))
  "...not logged in, no problemo...";
  return this;
endif
longest = 900;
"...guests get 15 minutes before they can be dislodged...";
candidate = #-1;
free = {};
for g in ($object_utils:leaves($guest))
  if (!is_player(g))
    "...a toaded guest?...";
  elseif ((!(con = g in connected_players())) && g.free_to_use)
    "...yay; found an unused guest...and their last :disfunc is complete";
    free = {@free, g};
  elseif (con && ((t = connected_seconds(g)) > longest))
    longest = t;
    candidate = g;
  endif
endfor
if (free)
  candidate = free[random($)];
elseif (valid(candidate))
  "...someone's getting bumped...";
  candidate:boot();
endif
return candidate;
.

@verb #31:"mail_catch_up" this none this rxd #2
@program #31:mail_catch_up
return;
.

@verb #31:"create" any any any
@program #31:create
if ($login:player_creation_enabled(player))
  player:tell("First @quit, then connect to the MOO again and, rather than doing `connect guest' do `create <name> <password>'");
else
  player:tell($login:registration_string());
endif
.

@verb #31:"eject" this none this
@program #31:eject
return pass(@args);
.

@verb #31:"log" this none this
@program #31:log
":log(islogin,time,where) adds an entry to the connection log for this guest.";
if (caller != this)
  return E_PERM;
elseif (length(this.connect_log) < this.max_connect_log)
  this.connect_log = {args, @this.connect_log};
else
  this.connect_log = {args, @this.connect_log[1..this.max_connect_log - 1]};
endif
.

@verb #31:"confunc" this none this rxd #2
@program #31:confunc
if ((((valid(cp = caller_perms()) && (caller != this)) && (!$perm_utils:controls(cp, this))) && (cp != this)) && (caller != #0))
  return E_PERM;
else
  $guest_log:enter(1, time(), $string_utils:connection_hostname(connection_name(this)));
  ret = pass(@args);
  this:tell_lines(this:extra_confunc_msg());
  return ret;
endif
.

@verb #31:"log_disconnect" this none this rxd #2
@program #31:log_disconnect
if (caller != this)
  return E_PERM;
else
  cname = `connection_name(this) ! ANY' || this.last_connect_place;
  $guest_log:enter(0, time(), $string_utils:connection_hostname(cname));
endif
.

@verb #31:"@last-c*onnection" any none none rxd #2
@program #31:@last-connection
if (!valid(caller_perms()))
  player:tell("Sorry, that information is not available.");
endif
.

@verb #31:"my_huh" this none this rxd #2
@program #31:my_huh
if (caller_perms() != this)
  return E_PERM;
else
  return pass(@args);
endif
.

@verb #31:"@read @peek" any any any
@program #31:@read
return pass(@args);
.

@verb #31:"set_current_folder" this none this
@program #31:set_current_folder
return pass(@args);
"only for setting permission";
.

@verb #31:"init_for_core" this none this rxd #2
@program #31:init_for_core
if (caller_perms().wizard)
  this.extra_confunc_msg = "";
  clear_property(this, "features");
  clear_property(this, "rooms");
endif
.

@verb #31:"set_name set_aliases" this none this rxd #2
@program #31:set_name
"disallow guests from setting aliases on themselves";
if ($perm_utils:controls(caller_perms(), this))
  return pass(@args);
else
  return E_PERM;
endif
.

@verb #31:"extra_confunc_msg" this none this rxd #2
@program #31:extra_confunc_msg
return $string_utils:pronoun_sub(this.(verb));
.

@verb #31:"do_reset" this none this rxd #2
@program #31:do_reset
if (!caller_perms().wizard)
  return E_PERM;
else
  flush_input(this, 0);
  for x in ({"paranoid", "lines", "responsible", "linelen", "linebuffer", "brief", "gaglist", "rooms", "pagelen", "current_message", "current_folder", "messages", "messages_going", "request", "mail_options", "edit_options", "home"})
    if ($object_utils:has_property(parent(this), x))
      clear_property(this, x);
    endif
  endfor
  this:set_description(this.default_description);
  this:set_gender(this.default_gender);
  for x in (this.contents)
    this:eject(x);
  endfor
  for x in (this.features)
    if (!(x in $guest.features))
      this:remove_feature(x);
    endif
  endfor
  for x in ($guest.features)
    if (!(x in this.features))
      this:add_feature(x);
    endif
  endfor
  for x in ($object_utils:descendants($generic_editor))
    if (loc = this in x.active)
      x:kill_session(loc);
    endif
  endfor
endif
.

@verb #31:"@request" any any any rd #2
@program #31:@request
"Copied from Generic Guest (#5678):@request by Froxx (#49853) Mon Apr  4 10:49:26 1994 PDT";
"Usage:  @request <player-name> for <email-address>";
if (player != this)
  return player:tell(E_PERM);
endif
if (this.request)
  return player:tell("Sorry, you appear to have already requested a character.");
endif
name = dobjstr;
if ((prepstr != "for") || ((!dobjstr) || index(address = iobjstr, " ")))
  return player:notify_lines($code_utils:verb_usage());
endif
if ($login:request_character(player, name, address))
  this.request = 1;
endif
.

@verb #31:"connection_name_hash" this none this rxd #2
@program #31:connection_name_hash
"Compute an encrypted hash of the guest's (last) connection, using 'crypt'. Basically, you can't tell where the guest came from, but it is unlikely that two guests will have the same hash";
"You can use guest:connection_name_hash(seed) as a string to identify whether two guests are from the same place.";
xx = $wiz_utils:connection_hash(caller_perms(), $string_utils:connection_hostname(this.last_connect_place), @args);
hash = toint(caller_perms());
host = $string_utils:connection_hostname(this.last_connect_place);
for i in [1..length(host)]
  hash = (hash * 14) + index($string_utils.ascii, host[i]);
endfor
return crypt(tostr(hash), @args);
.

"***finished***
