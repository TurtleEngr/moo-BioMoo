$Header: /repo/public.cvs/app/BioGate/BioMooCore/core29.moo,v 1.1 2021/07/27 06:44:30 bruce Exp $

>@dump #29 with create
@create $mail_recipient named New-Prog-Log:New-Prog-Log,New_Prog_Log,NPL
@prop #29."keyword" "PROGRAMMER" rc
;;#29.("last_msg_date") = 936908292
;;#29.("moderated") = 1
;;#29.("mail_notify") = {#2}
;;#29.("mail_forward") = {}
;;#29.("last_used_time") = 936908292
;;#29.("messages") = {{1, {878864008, #2, #95, "BioGate_wizard"}}, {2, {878865584, #2, #96, "BioGate_owner"}}, {3, {879548437, #2, #177, "Amalgam"}}, {4, {879548489, #2, #178, "Adric"}}, {5, {879548609, #2, #179, "Sleeper"}}, {6, {879548652, #2, #180, "Stainless"}}, {7, {879548917, #2, #181, "Victim"}}, {8, {882576144, #2, #294, "Michael"}}, {9, {884920793, #177, #331, "Help"}}, {10, {887116077, #177, #340, "UnderGroundsKeeper"}}, {11, {929482090, #178, #591, "Chong"}}, {12, {936908292, #178, #601, "Ahmed"}}}
;;#29.("aliases") = {"New-Prog-Log", "New_Prog_Log", "NPL"}
;;#29.("description") = "Record of who's been made a @programmer."
;;#29.("object_size") = {7066, 1577149625}

@verb #29:"init_for_core" this none this
@program #29:init_for_core
if (caller_perms().wizard)
  pass();
  this:rm_message_seq({1, 1 + this:length_all_msgs()});
  this:expunge_rmm();
  this.mail_forward = {};
  this.mail_notify = {player};
  player.current_message = {@player.current_message, {this, 0, 0}};
  for p in ({"moderator_forward", "writers", "readers", "expire_period", "last_used_time"})
    clear_property(this, p);
  endfor
  this.moderated = 1;
else
  return E_PERM;
endif
.

@verb #29:"receive_message" this none this
@program #29:receive_message
if (!this:is_writable_by(caller_perms()))
  return E_PERM;
else
  if (msgs = this.messages)
    new = msgs[$][1] + 1;
  else
    new = 1;
  endif
  if (rmsgs = this.messages_going)
    lbrm = rmsgs[$][2];
    new = max(new, lbrm[$][1] + 1);
  endif
  m = args[1];
  if (index(m[4], "@programmer ") == 1)
    m = {m[1], toobj(args[2]), o = toobj(m[4][index(m[4], "(") + 1..index(m[4], ")") - 1]), o.name};
  endif
  this.messages = {@msgs, {new, m}};
  this.last_msg_date = m[1];
  this.last_used_time = time();
  return new;
endif
.

@verb #29:"display_seq_headers display_seq_full" this none this
@program #29:display_seq_headers
":display_seq_headers(msg_seq[,cur])";
":display_seq_full(msg_seq[,cur]) => {cur}";
if (!this:ok(caller, caller_perms()))
  return E_PERM;
endif
{msg_seq, ?cur = 0, ?read_date = $maxint} = args;
last = ldate = 0;
player:tell("       WHEN           ", $string_utils:left(this.keyword, -30), "BY");
for x in (msgs = this:messages_in_seq(args[1]))
  msgnum = $string_utils:right(last = x[1], 4, (cur == x[1]) ? ">" | " ");
  ldate = x[2][1];
  if (typeof(x[2][2]) != OBJ)
    hdr = this:msg_summary_line(@x[2]);
  else
    if (ldate < (time() - 31536000))
      c = player:ctime(ldate);
      date = c[5..11] + c[21..25];
    else
      date = player:ctime(ldate)[5..16];
    endif
    hdr = tostr(ctime(ldate)[5..16], "   ", $string_utils:left(tostr(x[2][4], " (", x[2][3], ")"), 30), valid(w = x[2][2]) ? w.name | "??", " (", x[2][2], ")");
  endif
  player:tell(msgnum, (ldate > read_date) ? ":+ " | ":  ", hdr);
  $command_utils:suspend_if_needed(0);
endfor
if (verb == "display_seq_full")
  return {last, ldate};
else
  player:tell("----+");
endif
.

@verb #29:"from_msg_seq" this none this
@program #29:from_msg_seq
":from_msg_seq(object or list[,mask])";
" => msg_seq of messages from any of these senders";
if (!this:ok(caller, caller_perms()))
  return E_PERM;
endif
{plist, ?mask = {1}} = args;
if (typeof(plist) != LIST)
  plist = {plist};
endif
i = 1;
fseq = {};
for msg in (this.messages)
  if ((!mask) || (i < mask[1]))
  elseif ((length(mask) < 2) || (i < mask[2]))
    if (msg[2][2] in plist)
      fseq = $seq_utils:add(fseq, i, i);
    endif
  else
    mask = mask[3..$];
  endif
  i = i + 1;
  $command_utils:suspend_if_needed(0);
endfor
return fseq || ("%f %<has> no messages from " + $string_utils:english_list($list_utils:map_arg(2, $string_utils, "pronoun_sub", "%n (%#)", plist), "no one", " or "));
.

@verb #29:"to_msg_seq" this none this
@program #29:to_msg_seq
":to_msg_seq(object or list[,mask]) => msg_seq of messages to those people";
if (!this:ok(caller, caller_perms()))
  return E_PERM;
endif
{plist, ?mask = {1}} = args;
if (typeof(plist) != LIST)
  plist = {plist};
endif
i = 1;
fseq = {};
for msg in (this.messages)
  if ((!mask) || (i < mask[1]))
  elseif ((length(mask) < 2) || (i < mask[2]))
    if (msg[2][3] in plist)
      fseq = $seq_utils:add(fseq, i, i);
    endif
  else
    mask = mask[3..$];
  endif
  i = i + 1;
  $command_utils:suspend_if_needed(0);
endfor
return fseq || ("%f %<has> no messages about @programmer'ing " + $string_utils:english_list(plist, "no one", " or "));
.

@verb #29:"%to_msg_seq subject_msg_seq" this none this
@program #29:%to_msg_seq
":%to_msg_seq/subject_msg_seq(string or list of strings[,mask])";
" => msg_seq of messages containing one of strings in the to line";
if (!this:ok(caller, caller_perms()))
  return E_PERM;
endif
{nlist, ?mask = {1}} = args;
if (typeof(nlist) != LIST)
  nlist = {nlist};
endif
i = 1;
fseq = {};
for msg in (this.messages)
  if ((!mask) || (i < mask[1]))
  elseif ((length(mask) < 2) || (i < mask[2]))
    if (msg[2][4] in nlist)
      fseq = $seq_utils:add(fseq, i, i);
    endif
  else
    mask = mask[3..$];
  endif
  i = i + 1;
  $command_utils:suspend_if_needed(0);
endfor
return fseq || ("%f %<has> no messages about @programmer'ing " + $string_utils:english_list(nlist, "no one", " or "));
.

@verb #29:"%from_msg_seq" this none this
@program #29:%from_msg_seq
return this.name + " doesn't understand %%from:";
.

"***finished***
