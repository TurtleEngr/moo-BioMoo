$Header: /repo/public.cvs/app/BioGate/BioMooCore/core97.moo,v 1.1 2021/07/27 06:44:37 bruce Exp $

>@dump #97 with create
@create $root_class named Webpass handler:Webpass handler,webpassHandler
@prop #97."anon" #38 ""
@prop #97."anonymous" #38 ""
@prop #97."user_list" {} ""
;;#97.("user_list") = {#38, #38, #278, #319, #233}
@prop #97."webpass_list" {} ""
;;#97.("webpass_list") = {"anon", "anonymous", "940506", "046683", "604268"}
@prop #97."940506" #278 ""
@prop #97."046683" #319 ""
@prop #97."604268" #233 ""
;;#97.("aliases") = {"Webpass handler", "webpassHandler"}
;;#97.("object_size") = {8118, 937987203}

@verb #97:"set_password" this none this rx
@program #97:set_password
"set_password(who OBJ [, new STR]) -> new or ERR";
"Accepts a new webpass (new) from user (who).  Webpass is added as a";
"property to this, with the value 'new'. Old webpass, if any, is deleted.";
"If no webpass is provided, a random 6-digit one is created. If one is";
"provided but can't be used (illegal or already in use), a random one is";
"generated as well.";
"Returns a value of type ERR a new password couldn't be set.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
perms = caller_perms();
new = 0;
if (!args)
  return E_ARGS;
elseif (!((((caller == $http_handler) || (perms == who)) || $perm_utils:controls(perms, this)) || $perm_utils:controls(perms, who)))
  return E_PERM;
elseif (length(args) > 1)
  if (match(args[2], "^%w+$"))
    "only alphanumeric characters allowed";
    new = args[2];
  endif
endif
"if the indexed lists are corrupted, rebuild them";
if ((!this.user_list) || (length(this.user_list) != length(this.webpass_list)))
  this:reconstruct_lists();
endif
pp = properties(this);
while (this.(new) != E_PROPNF)
  new = "";
  "invent a 6 digit webpass";
  for i in [1..6]
    new = tostr(new, random(10) - 1);
  endfor
endwhile
"Delete old webpass, if any";
for p in (pp)
  if (this.(p) == who)
    delete_property(this, p);
    "update parallel indexed lists";
    if (idx = who in this.user_list)
      this.user_list = listdelete(this.user_list, idx);
      this.webpass_list = listdelete(this.webpass_list, idx);
    endif
  endif
endfor
"add new webpass";
result = add_property(this, new, who, {this.owner, ""});
if (result == E_PERM)
  "might be add_property() is server protected in this MOO";
  `result = $add_property(this, new, who, {this.owner, ""}) ! ANY';
endif
if (typeof(result) == ERR)
  "couldn't add it";
  return result;
endif
"update parallel indexed lists";
this.user_list = listappend(this.user_list, who);
this.webpass_list = listappend(this.webpass_list, new);
return new;
"Last modified Tue Oct  1 19:55:37 1996 IST by EricM (#3264).";
.

@verb #97:"user_disconnected user_client_disconnected" this none this rx
@program #97:user_disconnected
"user_disconnected(who OBJ) -> NONE";
"user_client_disconnected(who OBJ) -> NONE";
"where 'who' is the user who disconnected";
"Removes user's temporary webpass (always a six digit number), or";
"any webpass if 'who' a guest.";
"Webpasses are stored as propnames, and the prop's value is the user";
"object number associated with the webpass.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller in {#0, $http_handler})
  "called by MOO's disfunc system";
  who = args[1];
elseif (caller == player)
  "probably called by $player:disfunc -> OK";
  who = caller;
else
  return E_PERM;
endif
if (guest = $object_utils:isa(who, $guest))
  clear_property(who, "web_options");
elseif (typeof($web_options:get(who.web_options, "telnet_applet")) == OBJ)
  who.web_options = $web_options:set(who.web_options, "telnet_applet", 0);
endif
pp = properties(this);
if ((!this.user_list) || (length(this.user_list) != length(this.webpass_list)))
  "indexed lists are corrupted";
  this:reconstruct_lists();
endif
for p in (pp)
  if ((this.(p) == who) && (guest || ((length(p) == 6) && match(p, "^[0-9]+$"))))
    delete_property(this, p);
    if (idx = who in this.user_list)
      this.user_list = listdelete(this.user_list, idx);
      this.webpass_list = listdelete(this.webpass_list, idx);
    endif
  endif
endfor
"Last modified Tue Oct  8 21:44:04 1996 IST by EricM (#3264).";
.

@verb #97:"remove_webpass" this none this rx
@program #97:remove_webpass
"remove_webpass(whose OBJ) -> number of webpasses removed NUM";
"where 'who' is the user who disconnected";
"Removes user's webpass.";
"Webpasses are stored as propnames, and the prop's value is the user";
"object number associated with the webpass.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif
who = args[1];
pp = properties(this);
n = 0;
if ((!this.user_list) || (length(this.user_list) != length(this.webpass_list)))
  "indexed lists are corrupted";
  this:reconstruct_lists();
endif
for p in (pp)
  if ((this.(p) == who) && (typeof(delete_property(this, p)) != ERR))
    n = n + 1;
    if (idx = who in this.user_list)
      this.user_list = listdelete(this.user_list, idx);
      this.webpass_list = listdelete(this.webpass_list, idx);
    endif
  endif
endfor
return n;
"Last modified Tue Oct  1 19:56:16 1996 IST by EricM (#3264).";
.

@verb #97:"check_candidate" this none this rx
@program #97:check_candidate
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == $http_handler) || $perm_utils:controls(caller_perms(), this)))
  return E_PERM;
endif
who = this.(args[1]);
if ((typeof(who) == OBJ) && (!$object_utils:isa(who, $player)))
  this:remove_webpass(who);
  return E_PROPNF;
elseif (random(50) == 1)
  "check every once in a while for bad webpass's stuck here";
  fork (1)
    this:check_candidate(properties(this)[random(length(properties(this)))]);
  endfork
endif
return who;
"Last modified Thu Aug 29 18:57:28 1996 IDT by EricM (#3264).";
.

@verb #97:"reconstruct_lists" this none this rx
@program #97:reconstruct_lists
"reconstruct_lists() -> none";
"rebuilts the indexed lists of webpasses";
"should only be needed if they're corrupted (eg. different lengths)";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || caller_perms().wizard))
  return E_PERM;
endif
this.webpass_list = {};
this.user_list = {};
properties = setremove(properties(this), "user_list");
properties = setremove(properties, "webpass_list");
for prop in (properties)
  this.webpass_list = listappend(this.webpass_list, prop);
  this.user_list = listappend(this.user_list, this.(prop));
  ((seconds_left() < 2) || (ticks_left() < 4000)) ? $command_utils:suspend_if_needed(1) | 0;
endfor
"Last modified Thu Aug 15 22:54:37 1996 IDT by EricM (#3264).";
.

@verb #97:"webpass_for" this none this rx
@program #97:webpass_for
"webpass_for(who OBJ) -> STR or E_INVARG";
"returns webpass for 'who' or E_INVARG if none is set";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
if (!$perm_utils:controls(caller_perms(), who))
  return E_PERM;
endif
if ((!this.user_list) || (length(this.user_list) != length(this.webpass_list)))
  "lists are corrupted";
  this:reconstruct_lists();
endif
if (idx = who in this.user_list)
  return this.webpass_list[idx];
endif
return E_INVARG;
"Last modified Tue Oct  1 19:56:30 1996 IST by EricM (#3264).";
.

@verb #97:"init_for_core" this none this rxd #95
@program #97:init_for_core
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || caller_perms().wizard))
  return E_PERM;
endif
protected = {"user_list", "webpass_list"};
for prop in (properties(this))
  if (!(prop in protected))
    delete_property(this.prop);
  endif
endfor
return pass(@args);
"Last modified Wed Aug 21 23:25:10 1996 IDT by EricM (#3264).";
.

"***finished***
