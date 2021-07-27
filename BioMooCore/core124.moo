$Header: /repo/public.cvs/app/BioGate/BioMooCore/core124.moo,v 1.1 2021/07/27 06:44:27 bruce Exp $

>@dump #124 with create
@create $mail_recipient named Generic Bulletin-Board Mail Recipient:Generic Bulletin-Board Mail Recipient
@prop #124."board" #-1 rc
@prop #124."delivery_msg" "David Brin's post-apocalypse Postman arrives and tapes a bright, blue and orange EXPRESS MAIL envelope to %i." rc
@prop #124."current_object" #-1 r
@prop #124."note_created_msg" "A note (%[#d]) containing your message has been attached to %i (%[#i])." rc
;;#124.("mail_forward") = {}
;;#124.("expire_period") = 0
;;#124.("aliases") = {"Generic Bulletin-Board Mail Recipient"}
;;#124.("description") = "This can either be a mailing list or a mail folder, depending on what mood you're in..."
;;#124.("object_size") = {0, 0}

@verb #124:"receive_message" this none this rx #2
@program #124:receive_message
"WIZARDLY";
"... creates a note actually owned by the sender...";
if (caller != $mail_agent)
  return E_PERM;
endif
msg = args[1];
from = args[2];
if (" " == (subject = msg[4]))
  subject = "";
endif
body_start = "" in msg;
if (!(valid(from) && is_player(from)))
  return E_INVARG;
elseif (typeof(note = $recycler:_create($note, from)) == ERR)
  return note;
else
  this.current_object = note;
  note.description = "*** A bright, blue and orange EXPRESS MAIL envelope. ***";
  note.name = subject || (msg[body_start + 1] + " ...");
  note.aliases = {note.name, @setremove($string_utils:explode(note.name), "..."), "note"};
  note:set_text(msg[body_start + 1..length(msg)]);
  note:moveto(this.board);
  dobj = note;
  iobj = this.board;
  this.board.location:announce_all($string_utils:pronoun_sub(this.delivery_msg, this.board));
  from:tell($string_utils:pronoun_sub(this.note_created_msg));
  return length(this.board.contents);
endif
.

@verb #124:"renumber" this none this
@program #124:renumber
return {length(this.board.contents), args ? args[1] | 0};
.

@verb #124:"list_rmm expunge_rmm undo_rmm" this none this
@program #124:list_rmm
return (verb == "undo_rmm") ? {} | 0;
.

@verb #124:"length_all_msgs" this none this
@program #124:length_all_msgs
if (valid(this.board))
  return length(this.board.contents);
else
  return 0;
endif
.

@verb #124:"length_date_le" this none this
@program #124:length_date_le
return $list_utils:iassoc_sorted(args[1], this.board.dates, 2);
.

@verb #124:"length_date_gt" this none this
@program #124:length_date_gt
date = args[1];
return (this.last_msg_date <= date) ? 0 | (length(this.board.contents) - $list_utils:iassoc_sorted(args[1], this.board.dates, 2));
.

@verb #124:"length_num_le" this none this
@program #124:length_num_le
return max(0, min(args[1], length(this.board.contents)));
.

@verb #124:"exists_num_eq" this none this
@program #124:exists_num_eq
return ((n = args[1]) > 0) && ((n <= length(this.board.contents)) && n);
.

@verb #124:"new_message_num" this none this
@program #124:new_message_num
return length(this.board.contents) + 1;
.

@verb #124:"messages" this none this
@program #124:messages
":messages(num) => returns the text of the message numbered num.";
":messages()    => returns the entire list of messages (can be SLOW).";
if (args)
  if (((n = args[1]) < 1) || (n > length(this.board.contents)))
    return E_RANGE;
  else
    this:_message_text(n);
  endif
else
  msgs = {};
  for i in [1..length(this.board.contents)]
    msgs = {@msgs, {i, this:_message_text(i)}};
  endfor
  return msgs;
endif
.

@verb #124:"messages_in_seq" this none this
@program #124:messages_in_seq
":messages_in_seq(msg_seq) => list of messages in msg_seq on folder (caller)";
if (typeof(seq = args[1]) != LIST)
  return {seq, this:_message_text(seq)};
else
  if (length(seq) % 2)
    seq = {@seq, length(this.board.contents)};
  endif
  msgs = {};
  for i in [1..length(seq) / 2]
    for j in [seq[i]..seq[i + 1] - 1]
      msgs = {@msgs, {j, this:_message_text(j)}};
    endfor
  endfor
  return msgs;
endif
.

@verb #124:"_message_text" this none this
@program #124:_message_text
note = this.board.contents[n = args[1]];
date = this.board.dates[n][2];
poster = {@this.board.dates[n], 1}[3];
return {date, $mail_agent:name(note.owner), $mail_agent:name(this), note.name, @poster ? {} | {"Reply-To: " + $mail_agent:name(poster)}, "", @note:text()};
.

@verb #124:"rm_message_seq" this none this
@program #124:rm_message_seq
return E_NACC;
.

@verb #124:"contents_added contents_removed" this none this
@program #124:contents_added
":contents_added(object)   called by this.board:enterfunc";
":contents_removed(object) called by this.board:exitfunc";
if (caller != this.board)
  return E_PERM;
else
  object = args[1];
  this:_fix_last_msg_date();
  if ((verb == "contents_added") && (object != this.current_object))
    "... someone just posted by hand...";
    for who in (this:mail_notify())
      who:tell("A note by ", valid(object.owner) ? object.owner.name + " (" | "(", object.owner, ") has been posted on ", this.name, " [see ", $mail_agent:name(this), "].");
    endfor
  endif
  this.current_object = #-1;
endif
.

"***finished***
