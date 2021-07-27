$Header: /repo/public.cvs/app/BioGate/BioMooCore/core45.moo,v 1.1 2021/07/27 06:44:32 bruce Exp $

>@dump #45 with create
@create $root_class named Generic Mail Recipient:Generic Mail Recipient
@prop #45."moderator_notify" {} rc
@prop #45."last_msg_date" 0 r
@prop #45."messages_going" {} ""
@prop #45."moderated" {} rc
@prop #45."moderator_forward" "%n (%#) can't send to moderated list %t (%[#t]) directly." rc
@prop #45."writers" {} rc
@prop #45."readers" {} rc
@prop #45."mail_notify" {} r
@prop #45."mail_forward" "%t (%[#t]) is a generic recipient." r
@prop #45."expire_period" 2592000 r
@prop #45."last_used_time" 0 r
@prop #45."messages" {} ""
@prop #45."rmm_own_msgs" 1 rc
@prop #45."guests_can_send_here" 0 rc
@prop #45."names" {} r
@prop #45."accept_subname" 1 rc
@prop #45."messages_kept" {} r
@prop #45."registered_email" "" ""
@prop #45."email_validated" 1 ""
@prop #45."validation_password" "" ""
;;#45.("aliases") = {"Generic Mail Recipient"}
;;#45.("description") = "This can either be a mailing list or a mail folder, depending on what mood you're in..."
;;#45.("object_size") = {33998, 855068591}

@verb #45:"set_aliases" this none this
@program #45:set_aliases
"For changing mailing list aliases, we check to make sure that none of the aliases match existing mailing list aliases.  Aliases containing spaces are not used in addresses and so are not subject to this restriction ($mail_agent:match will not match on them, however, so they only match if used in the immediate room, e.g., with match_object() or somesuch).";
"  => E_PERM   if you don't own this";
if ((caller != this) && (!$perm_utils:controls(caller_perms(), this)))
  return E_PERM;
elseif (this.location != $mail_agent)
  "... we don't care...";
  return pass(@args);
else
  for a in (aliases = args[1])
    if (index(a, " "))
      "... we don't care...";
    elseif (rp = $mail_agent:reserved_pattern(a))
      player:tell("Mailing list name \"", a, "\" uses a reserved pattern: ", rp[1]);
      aliases = setremove(aliases, a);
    elseif (valid(p = $mail_agent:match(a, #-1)) && ((p != this) && (a in p.aliases)))
      player:tell("Mailing list name \"", a, "\" in use on ", p.name, "(", p, ")");
      aliases = setremove(aliases, a);
    endif
  endfor
  if (aliases)
    return pass(aliases);
  else
    return 1;
  endif
endif
.

@verb #45:"look_self" this none this
@program #45:look_self
"Returns full name and mail aliases for this list, read and write status by the player, and a short description. Calling :look_self(1) will omit the description.";
{?brief = 0} = args;
namelist = "*" + ((names = this:mail_names()) ? $string_utils:from_list(names, ", *") | tostr(this));
if (typeof(fwd = this:mail_forward()) != LIST)
  fwd = {};
endif
if (this:is_writable_by(player))
  if (player in fwd)
    read = " [Writable/Subscribed]";
  else
    read = " [Writable]";
  endif
elseif (this.readers == 1)
  read = tostr(" [Public", (player in fwd) ? "/Subscribed]" | "]");
elseif (player in fwd)
  read = " [Subscribed]";
elseif (this:is_readable_by(player))
  read = " [Readable]";
else
  read = "";
endif
if (this:is_usable_by($no_one))
  mod = "";
elseif (this:is_usable_by(player))
  mod = " [Approved]";
else
  mod = " [Moderated]";
endif
player:tell(namelist, "  (", this, ")", read, mod);
if (!brief)
  d = this:description();
  if (typeof(d) == STR)
    d = {d};
  endif
  for l in (d)
    if (length(l) <= 75)
      ls = {l};
    else
      ls = $generic_editor:fill_string(l, 76);
    endif
    for line in (ls)
      player:tell("    ", line);
      $command_utils:suspend_if_needed(0);
    endfor
  endfor
endif
.

@verb #45:"is_writable_by" this none this
@program #45:is_writable_by
return $perm_utils:controls(who = args[1], this) || `who in this.writers ! E_TYPE';
.

@verb #45:"is_readable_by" this none this
@program #45:is_readable_by
return (typeof(this.readers) != LIST) || (((who = args[1]) in this.readers) || (this:is_writable_by(who) || $mail_agent:sends_to(1, this, who)));
.

@verb #45:"is_usable_by" this none this
@program #45:is_usable_by
who = args[1];
if (this.moderated)
  return `who in this.moderated ! E_TYPE' || (this:is_writable_by(who) || who.wizard);
else
  return this.guests_can_send_here || (!$object_utils:isa(who, $guest));
endif
.

@verb #45:"mail_notify" this none this
@program #45:mail_notify
if ((args && (!this:is_usable_by(args[1]))) && (!args[1].wizard))
  return this:moderator_notify(@args);
else
  return this.(verb);
endif
.

@verb #45:"mail_forward" this none this
@program #45:mail_forward
if ((args && (!this:is_usable_by(args[1]))) && (!args[1].wizard))
  return this:moderator_forward(@args);
elseif (typeof(mf = this.(verb)) == STR)
  return $string_utils:pronoun_sub(mf, @args);
else
  return mf;
endif
.

@verb #45:"moderator_forward" this none this
@program #45:moderator_forward
if (typeof(mf = this.(verb)) == STR)
  return $string_utils:pronoun_sub(mf, args ? args[1] | $player);
else
  return mf;
endif
.

@verb #45:"add_forward" this none this
@program #45:add_forward
":add_forward(recip[,recip...]) adds new recipients to this list.  Returns a string error message or a list of results (recip => success, E_PERM => not allowed, E_INVARG => not a valid recipient, string => other kind of failure)";
if (caller == $mail_editor)
  perms = player;
else
  perms = caller_perms();
endif
result = {};
forward_self = (!this.mail_forward) || (this in this.mail_forward);
for recip in (args)
  if ((!valid(recip)) || ((!is_player(recip)) && (!($mail_recipient in $object_utils:ancestors(recip)))))
    r = E_INVARG;
  elseif ($perm_utils:controls(perms, this) || ((typeof(this.readers) != LIST) && $perm_utils:controls(perms, recip)))
    this.mail_forward = setadd(this.mail_forward, recip);
    r = recip;
  else
    r = E_PERM;
  endif
  result = listappend(result, r);
endfor
if ((length(this.mail_forward) > 1) && ($nothing in this.mail_forward))
  this.mail_forward = setremove(this.mail_forward, $nothing);
endif
if (forward_self)
  this.mail_forward = setadd(this.mail_forward, this);
endif
return result;
.

@verb #45:"delete_forward" this none this
@program #45:delete_forward
":delete_forward(recip[,recip...]) removes recipients to this list.  Returns a list of results (E_PERM => not allowed, E_INVARG => not on list)";
if (caller == $mail_editor)
  perms = player;
else
  perms = caller_perms();
endif
result = {};
forward_self = (!this.mail_forward) || (this in this.mail_forward);
for recip in (args)
  if (!(recip in this.mail_forward))
    r = E_INVARG;
  elseif (((!valid(recip)) || $perm_utils:controls(perms, recip)) || $perm_utils:controls(perms, this))
    if (recip == this)
      forward_self = 0;
    endif
    this.mail_forward = setremove(this.mail_forward, recip);
    r = recip;
  else
    r = E_PERM;
  endif
  result = listappend(result, r);
endfor
if (!(forward_self || this.mail_forward))
  this.mail_forward = {$nothing};
elseif (this.mail_forward == {this})
  this.mail_forward = {};
endif
return result;
.

@verb #45:"add_notify" this none this
@program #45:add_notify
":add_notify(recip[,recip...]) adds new notifiees to this list.  Returns a list of results (recip => success, E_PERM => not allowed, E_INVARG => not a valid recipient)";
if (caller == $mail_editor)
  perms = player;
else
  perms = caller_perms();
endif
result = {};
for recip in (args)
  if ((!valid(recip)) || (recip == this))
    r = E_INVARG;
  elseif ($perm_utils:controls(perms, this) || (this:is_readable_by(perms) && $perm_utils:controls(perms, recip)))
    this.mail_notify = setadd(this.mail_notify, recip);
    r = recip;
  else
    r = E_PERM;
  endif
  result = listappend(result, r);
endfor
return result;
.

@verb #45:"delete_notify" this none this
@program #45:delete_notify
":delete_notify(recip[,recip...]) removes notifiees from this list.  Returns a list of results (E_PERM => not allowed, E_INVARG => not on list)";
if (caller == $mail_editor)
  perms = player;
else
  perms = caller_perms();
endif
result = {};
rmthis = 0;
for recip in (args)
  if (!(recip in this.mail_notify))
    r = E_INVARG;
  elseif ((!valid(recip)) || ($perm_utils:controls(perms, recip) || $perm_utils:controls(perms, this)))
    if (recip == this)
      rmthis = 1;
    endif
    this.mail_notify = setremove(this.mail_notify, recip);
    r = recip;
  else
    r = E_PERM;
  endif
  result = listappend(result, r);
endfor
return result;
.

@verb #45:"receive_message" this none this
@program #45:receive_message
if (!this:ok_write(caller, caller_perms()))
  return E_PERM;
else
  this.messages = {@this.messages, {new = this:new_message_num(), args[1]}};
  this.last_msg_date = args[1][1];
  this.last_used_time = time();
  return new;
endif
.

@verb #45:"ok" this none this
@program #45:ok
":ok(caller,callerperms) => true iff caller can do read operations";
return (args[1] in {this, $mail_agent}) || (args[2].wizard || this:is_readable_by(args[2]));
.

@verb #45:"ok_write" this none this
@program #45:ok_write
":ok_write(caller,callerperms) => true iff caller can do write operations";
return (args[1] in {this, $mail_agent}) || (args[2].wizard || this:is_writable_by(args[2]));
.

@verb #45:"parse_message_seq from_msg_seq %from_msg_seq to_msg_seq %to_msg_seq subject_msg_seq body_msg_seq kept_msg_seq unkept_msg_seq display_seq_headers display_seq_full messages_in_seq list_rmm new_message_num length_num_le length_date_le length_all_msgs exists_num_eq msg_seq_to_msg_num_list msg_seq_to_msg_num_string" this none this
@program #45:parse_message_seq
":parse_message_seq(strings,cur) => {msg_seq,@unused_strings} or string error";
"";
":from_msg_seq(olist)     => msg_seq of messages from those people";
":%from_msg_seq(strings)  => msg_seq of messages with strings in the From: line";
":to_msg_seq(olist)       => msg_seq of messages to those people";
":%to_msg_seq(strings)    => msg_seq of messages with strings in the To: line";
":subject_msg_seq(target) => msg_seq of messages with target in the Subject:";
":body_msg_seq(target)    => msg_seq of messages with target in the body";
":new_message_num()    => number that the next incoming message will receive.";
":length_num_le(num)   => number of messages in folder numbered <= num";
":length_date_le(date) => number of messages in folder dated <= date";
":length_all_msgs()    => number of messages in folder";
":exists_num_eq(num)   => index of message in folder numbered == num, or 0";
"";
":display_seq_headers(msg_seq[,cur])   display message summary lines";
":display_seq_full(msg_seq[,preamble]) display entire messages";
"            => number of final message displayed";
":list_rmm() displays contents of .messages_going.";
"            => the number of messages in .messages_going.";
"";
":messages_in_seq(msg_seq) => list of messages in msg_seq on folder";
"";
"See the corresponding routines on $mail_agent for more detail.";
return this:ok(caller, caller_perms()) ? $mail_agent:(verb)(@args) | E_PERM;
.

@verb #45:"length_date_gt" this none this
@program #45:length_date_gt
":length_date_le(date) => number of messages in folder dated > date";
"";
if (this:ok(caller, caller_perms()))
  date = args[1];
  return (this.last_msg_date <= date) ? 0 | $mail_agent:(verb)(date);
else
  return E_PERM;
endif
.

@verb #45:"rm_message_seq" this none this
@program #45:rm_message_seq
":rm_message_seq(msg_seq) removes the given sequence of from folder";
"               => string giving msg numbers removed";
"See the corresponding routine on $mail_agent.";
if (this:ok_write(caller, caller_perms()))
  return $mail_agent:(verb)(@args);
elseif (this:ok(caller, caller_perms()) && (seq = this:own_messages_filter(caller_perms(), @args)))
  return $mail_agent:(verb)(@listset(args, seq, 1));
else
  return E_PERM;
endif
.

@verb #45:"undo_rmm expunge_rmm renumber keep_message_seq" this none this
@program #45:undo_rmm
":rm_message_seq(msg_seq) removes the given sequence of from folder";
"               => string giving msg numbers removed";
":list_rmm()    displays contents of .messages_going.";
"               => number of messages in .messages_going.";
":undo_rmm()    restores previously deleted messages from .messages_going.";
"               => msg_seq of restored messages";
":expunge_rmm() destroys contents of .messages_going once and for all.";
"               => number of messages in .messages_going.";
":renumber([cur])  renumbers all messages";
"               => {number of messages,new cur}.";
"";
"See the corresponding routines on $mail_agent.";
return this:ok_write(caller, caller_perms()) ? $mail_agent:(verb)(@args) | E_PERM;
.

@verb #45:"own_messages_filter" this none this
@program #45:own_messages_filter
":own_messages_filter(who,msg_seq) => subsequence of msg_seq consisting of those messages that <who> is actually allowed to remove (on the assumption that <who> is not one of the allowed writers of this folder.";
if (!this.rmm_own_msgs)
  return E_PERM;
elseif ((typeof(seq = this:from_msg_seq({args[1]}, args[2])) != LIST) || (seq != args[2]))
  return {};
else
  return seq;
endif
.

@verb #45:"messages" this none this
@program #45:messages
"NOTE:  this routine is obsolete, use :messages_in_seq()";
":messages(num) => returns the message numbered num.";
":messages()    => returns the entire list of messages (can be SLOW).";
if (!this:ok(caller, caller_perms()))
  return E_PERM;
elseif (!args)
  return this:messages_in_seq({1, this:length_all_msgs() + 1});
elseif (!(n = this:exists_num_eq(args[1])))
  return E_RANGE;
else
  return this:messages_in_seq(n)[2];
endif
.

@verb #45:"date_sort" this none this
@program #45:date_sort
if (!this:ok_write(caller, caller_perms()))
  return E_PERM;
endif
date_seq = {};
for msg in (this.messages)
  date_seq = {@date_seq, msg[2][1]};
endfor
msg_order = $list_utils:sort($list_utils:range(n = length(msgs = this.messages)), date_seq);
newmsgs = {};
for i in [1..n]
  if ($command_utils:suspend_if_needed(0))
    player:tell("...", i);
  endif
  newmsgs = {@newmsgs, {i, msgs[msg_order[i]][2]}};
endfor
if (length(this.messages) != n)
  "...shit, new mail received,... start again...";
  fork (0)
    this:date_sort();
  endfork
else
  this.messages = newmsgs;
  this.last_used_time = newmsgs[$][2][1];
endif
.

@verb #45:"_fix_last_msg_date" this none this
@program #45:_fix_last_msg_date
mlen = this:length_all_msgs();
this.last_msg_date = mlen && this:messages_in_seq(mlen)[2][1];
.

@verb #45:"moderator_notify" this none this
@program #45:moderator_notify
return this.(verb);
.

@verb #45:"msg_summary_line" this none this
@program #45:msg_summary_line
return $mail_agent:msg_summary_line(@args);
.

@verb #45:"__check" this none this
@program #45:__check
for m in (this.messages)
  $mail_agent:__convert_new(@m[2]);
  $command_utils:suspend_if_needed(0);
endfor
.

@verb #45:"__fix" this none this rxd #2
@program #45:__fix
if (!this:ok_write(caller, caller_perms()))
  return E_PERM;
endif
msgs = {};
i = 1;
for m in (oldmsgs = this.messages)
  msgs = {@msgs, {m[1], $mail_agent:__convert_new(@m[2])}};
  if ($command_utils:running_out_of_time())
    player:notify(tostr("...", i, " ", this));
    suspend(0);
    if (oldmsgs != this.messages)
      return 0;
    endif
  endif
  i = i + 1;
endfor
this.messages = msgs;
return 1;
.

@verb #45:"init_for_core" this none this rxd #2
@program #45:init_for_core
if (caller_perms().wizard)
  pass();
  if (!(this in {$mail_recipient, $big_mail_recipient}))
    "...generic mail recipients stay in #-1...";
    move(this, $mail_agent);
    this:_fix_last_msg_date();
    "Since the mail_name_db name hierarchy stuff is mostly incomplete..";
    this.names = {};
  endif
endif
.

@verb #45:"initialize" this none this rxd #2
@program #45:initialize
if ($perm_utils:controls(caller_perms(), this))
  this.mail_forward = {};
  return pass(@args);
endif
.

@verb #45:"mail_name_old mail_name short_mail_name" this none this
@program #45:mail_name_old
return "*" + this.aliases[1];
.

@verb #45:"mail_names" this none this
@program #45:mail_names
names = {};
for a in (this.aliases)
  if (!index(a, " "))
    names = setadd(names, strsub(a, "_", "-"));
  endif
endfor
return names;
.

@verb #45:"expire_old_messages" this none this
@program #45:expire_old_messages
if (this:ok_write(caller, caller_perms()))
  "Passed security check...";
  if (this.expire_period && (rmseq = $seq_utils:remove(this:unkept_msg_seq(), 1 + this:length_date_le(time() - this.expire_period))))
    "... i.e., everything not marked kept that is older than expire_period";
    if (this.registered_email && this.email_validated)
      format = this.owner:format_for_netforward(this:messages_in_seq(rmseq), " expired from " + $mail_agent:name(this));
      $network:sendmail(this.registered_email, @{format[2], @format[1]});
      "Do nothing if it bounces, etc.";
    endif
    this:rm_message_seq(rmseq);
    return this:expunge_rmm();
  else
    return 0;
  endif
else
  return E_PERM;
endif
.

@verb #45:"moveto" this none this
@program #45:moveto
if (this:is_writable_by(caller_perms()) || this:is_writable_by(caller))
  pass(@args);
else
  return E_PERM;
endif
.

@verb #45:"accept_subname" this none this
@program #45:accept_subname
":accept_subname(object,name,perms)";
"is <perms> allowed to make <object> mail subname of this with the given <name>?";
object = args[1];
accept = this.accept_subname;
if (!valid(object))
  return E_INVARG;
elseif ((accept && (typeof(accept) != LIST)) || (this:is_writable_by(object.owner) || this:is_writable_by(perms = args[3])))
  "...writers can do anything...";
  "... .accept_subname==1 => anyone can do anything...";
  return 1;
elseif (accept && ((object in accept) || ({object, args[2]} in accept)))
  "... object/name is explicitly sanctioned";
  return 1;
elseif (object in $mail_name_db:find_all(tostr(this, ":")))
  "...object is already a subname...";
  "...allow name change unless .accept_subname specifies a name";
  return !(accept && (a = $list_utils:assoc(object, accept)));
else
  return 0;
endif
.

@verb #45:"mail_name_new mail_name" this none this
@program #45:mail_name_new
return (!(names = this.names)) ? "" | (((name = names[1])[1] == #-1) ? "*" + name[2] | tostr(is_player(name[1]) ? name[1].name | ("*" + name[1]:(verb)()), ":", name[2]));
.

@verb #45:"@mail-n*ame" this is any
@program #45:@mail-name
"@mail_name <this> is whatever";
if (!this:is_writable_by(player))
  player:tell(E_PERM);
  return;
endif
if (h = rindex(iobjstr, ":"))
  if ($mail_agent:match_failed(head = $mail_agent:match_new(iobjstr[1..h]), iobjstr[1..h]))
    return;
  elseif (!(name = iobjstr[h + 1..$]))
    player:tell("Recipient cannot have a blank name.");
    return;
  endif
elseif (this.names && $object_utils:isa(head = this.names[1][1], $mail_recipient))
  name = iobjstr;
else
  player:tell("No names have yet been given to this recipient.");
  player:tell("You need to specify a full path.");
  return;
endif
if (e = $mail_agent:set_mail_name(this, head, name))
  player:tell("Name set to ", this:mail_name_new(), ".");
elseif (e == E_NACC)
  player:tell(head:mail_name_new(), " does not want ", this, " to be a subname.");
elseif (e == E_RECMOVE)
  player:tell(head:mail_name_new(), " is a name-descendant of ", this, ".");
elseif (e == E_INVARG)
  player:tell("Name must contain no parentheses, colons or stars.");
else
  player:tell(e);
endif
.

@verb #45:"@rm-mail-n*ame @remove-mail-n*ame" any from this
@program #45:@rm-mail-name
"@rm-mail-name whatever from <this>";
if (!this:is_writable_by(player))
  player:tell(E_PERM);
  return;
elseif (!this.names)
  player:tell("This recipient has no names.");
  return;
endif
if (h = rindex(dobjstr, ":"))
  if ($mail_agent:match_failed(head = $mail_agent:match_new(dobjstr[1..h]), dobjstr[1..h]))
    return;
  endif
  name = dobjstr[h + 1..$];
  nlist = this.names;
  while ((i = $list_utils:iassoc(head, nlist)) && (name && (name != nlist[i][2])))
    nlist[1..i] = {};
  endwhile
  if (i)
    "...no problem...";
  elseif (name)
    player:tell("Recipient does not have that name");
    return;
  else
    player:tell("Recipient does not have any names under ", head:mail_name_new(), ": (", head, ").");
    return;
  endif
  name = nlist[i][2];
elseif (a = $list_utils:assoc(name = dobjstr, this.names, 2))
  head = a[1];
else
  player:tell("Recipient does not have that name");
  return;
endif
if (e = $mail_agent:remove_mail_name(this, head, name))
  player:tell("Removed name ", head:mail_name_new(), ":", name, " from ", this:mail_name_new(), " (", this, ").");
else
  player:tell(e);
endif
.

@verb #45:"@add-mail-n*ame" any to this
@program #45:@add-mail-name
"@add-mail-name whatever to <this>";
if (!this:is_writable_by(player))
  player:tell(E_PERM);
  return;
endif
if (h = rindex(dobjstr, ":"))
  if ($mail_agent:match_failed(head = $mail_agent:match_new(dobjstr[1..h]), dobjstr[1..h]))
    return;
  elseif (!(name = dobjstr[h + 1..$]))
    player:tell("Recipient cannot have a blank name.");
    return;
  endif
elseif (this.names && $object_utils:isa(head = this.names[1][1], $mail_recipient))
  name = dobjstr;
else
  player:tell("No names have yet been given to this recipient.");
  player:tell("You need to specify a full path.");
  return;
endif
if (e = $mail_agent:add_mail_name(this, head, name))
  player:tell("Added name ", head:mail_name_new(), ":", name, " to ", $mail_agent:name_new(this), ".");
elseif (e == E_NACC)
  player:tell(head:mail_name_new(), " does not want ", this, " to be a subname.");
elseif (e == E_RECMOVE)
  player:tell(head:mail_name_new(), " is a name-descendant of ", this, ".");
elseif (e == E_INVARG)
  player:tell("Name must contain no parentheses, colons or stars.");
else
  player:tell(e);
endif
.

@verb #45:"msg_full_text" this none this
@program #45:msg_full_text
":msg_full_text(@msg) => list of strings.";
"msg is a mail message (in the usual transmission format).";
"display_seq_full calls this to obtain the actual list of strings to display.";
return player:msg_text(@args);
"default is to leave it up to the player how s/he wants it to be displayed.";
.

@verb #45:"@set_expire" this to any rxd
@program #45:@set_expire
"Syntax:  @set_expire <recipient> to <time>";
"         @set_expire <recipient> to";
"";
"Allows the list owner to set the expiration period of this mail recipient. This is the time messages will remain before they are removed from the list. The <time> given can be in english terms (e.g., 2 months, 45 days, etc.).";
"Non-wizard mailing list owners are limited to a maximum expire period of 180 days. They are also prohibited from setting the list to non-expiring.";
"Wizards may set the expire period to 0 for no expiration.";
"The second form, leaving off the time specification, will tell you what the recipient's expire period is currently set to.";
if ((caller_perms() != #-1) && (caller_perms() != player))
  return player:tell(E_PERM);
elseif (!this:is_writable_by(player))
  return player:tell(E_PERM);
elseif (!iobjstr)
  return player:tell(this.expire_period ? tostr("Messages will automatically expire from ", this:mail_name(), " after ", $time_utils:english_time(this.expire_period), ".") | tostr("Messages will not expire from ", this:mail_name()));
elseif (typeof(time = $time_utils:parse_english_time_interval(iobjstr)) == ERR)
  return player:tell(time);
elseif ((time == 0) && (!player.wizard))
  return player:tell("Only wizards may set a mailing list to not expire.");
elseif ((time > (180 * 86400)) && (!player.wizard))
  return player:tell("Only a wizard may set the expiration period on a mailing list to greater than 180 days.");
endif
this.expire_period = time;
player:tell("Messages will ", (time != 0) ? tostr("automatically expire from ", this:mail_name(), " after ", $time_utils:english_time(time)) | tostr("not expire from ", this:mail_name()), ".");
.

@verb #45:"@register @netregister" this to any rxd #2
@program #45:@register
"Syntax:   @register <recipient> to <email-address>";
"alias     @netregister <recipient> to <email-address>";
"          @register <recipient> to";
"";
"The list owner may use this command to set a registered email address for the mail recipient. When set, mail messages that expire off of the mail recipient will be mailed to that address.";
"If you leave the email address off of the command, it will return the current registration and expiration information for that recipient if you own it.";
"The owner may register a mail recipient to any email address. However, if the address does not match his registered email address, then a password will be generated and sent to the address specified when this command is used. Then, the owner may retrieve that password and verify the address with the command:";
"";
"  @validate <recipient> with <password>";
"";
"See *B:MailingListReform #98087 for full details.";
if ((caller_perms() != #-1) && (caller_perms() != player))
  return player:tell(E_PERM);
elseif (!$perm_utils:controls(player, this))
  return player:tell(E_PERM);
elseif (!iobjstr)
  if (this.registered_email)
    player:tell(this:mail_name(), " is registered to ", this.registered_email, ". Messages will be sent there when they expire after ", (this.expire_period == 0) ? "never" | $time_utils:english_time(this.expire_period), ".");
  else
    player:tell(this:mail_name(), " is not registered to any address. Messages will be deleted when they expire after ", (this.expire_period == 0) ? "never" | $time_utils:english_time(this.expire_period), ".");
    player:tell("Usage:  @register <recipient> to <email-address>");
  endif
  return;
elseif (iobjstr == player.email_address)
  this.registered_email = player.email_address;
  this.email_validated = 1;
  player:tell("Messages expired from ", this:mail_name(), " after ", (this.expire_period == 0) ? "never" | $time_utils:english_time(this.expire_period), " will be emailed to ", this.registered_email, " (which is your registered email address).");
elseif (reason = $network:invalid_email_address(iobjstr))
  return player:tell(reason, ".");
elseif (!$network.active)
  return player:tell("The network is not up at the moment. Please try again later or contact a wizard for help.");
else
  password = $wiz_utils:random_password(5);
  result = $network:sendmail(iobjstr, tostr($network.MOO_Name, " mailing list verification"), @$generic_editor:fill_string(tostr("The mailing list ", this:mail_name(), " on ", $network.MOO_Name, " has had this address designated as the recipient of expired mail messages. If this is not correct, then you need do nothing but ignore this message. If this is correct, you must log into the MOO and type:  `@validate ", this:mail_name(), " with ", password, "' to start receiving expired mail messages."), 75));
  if (result != 0)
    return player:tell("Mail sending did not work: ", result, ". Address not set.");
  endif
  this.registered_email = iobjstr;
  this.email_validated = 0;
  this.validation_password = password;
  player:tell("Registration complete. Password sent to the address you specified. When you receive the email, log back in to validate it with the command:  @validate <recipient> with <password>. If you do not receive the password email, try again or notify a wizard if this is a recurring problem.");
endif
.

@verb #45:"@validate" this with any rxd
@program #45:@validate
"Syntax:  @validate <recipient> with <password>";
"";
"This command is used to validate an email address set to receive expired messages that did not match the list owner's registered email address. When using the @register command, a password was sent via email to the address specified. This command is to verify that the password was received properly.";
if ((caller_perms() != #-1) && (caller_perms() != player))
  return player:tell(E_PERM);
elseif (!$perm_utils:controls(player, this))
  return player:tell(E_PERM);
elseif (!this.registered_email)
  return player:tell("No email address has even been set for ", this:mail_name(), ".");
elseif (this.email_validated)
  return player:tell("The email address for ", this:mail_name(), " has already been validated.");
elseif (!iobjstr)
  return player:tell("Usage:  @validate <recipient> with <password>");
elseif (iobjstr != this.validation_password)
  return player:tell("That is not the correct password.");
else
  this.email_validated = 1;
  player:tell("Password validated. Messages that expire after ", (this.expire_period == 0) ? "never" | $time_utils:english_time(this.expire_period), " from ", this:mail_name(), " will be emailed to ", this.registered_email, ".");
endif
.

"***finished***
