$Header: /repo/public.cvs/app/BioGate/BioMooCore/core70.moo,v 1.1 2021/07/27 06:44:34 bruce Exp $

>@dump #70 with create
@create $mail_recipient named Site-Locks:Site-Locks
;;#70.("last_msg_date") = 884979861
;;#70.("moderated") = 1
;;#70.("mail_notify") = {#2}
;;#70.("mail_forward") = {}
;;#70.("last_used_time") = 884979861
;;#70.("messages") = {{1, {884826359, "Adric (#178)", "*Site-Locks (#70)", "@toad testplayer (#325)", "", "", "test"}}, {2, {884826501, "Adric (#178)", "*Site-Locks (#70)", "@toad testplayer (#326)", "", "", "testing"}}, {3, {884979861, "Adric (#178)", "*Site-Locks (#70)", "@toad chtest (#332)", "", "", "testing"}}}
;;#70.("aliases") = {"Site-Locks"}
;;#70.("description") = "Notes on annoying sites."
;;#70.("object_size") = {2174, 1577149627}

@verb #70:"init_for_core" this none this
@program #70:init_for_core
if (caller_perms().wizard)
  pass();
  "this:rm_message_seq({1, 1 + this:length_all_msgs()})";
  "this:expunge_rmm()";
  for p in (properties(this))
    $command_utils:suspend_if_needed(0);
    if (p && (p[1] == " "))
      delete_property(this, p);
    endif
  endfor
  while ("secret_SHHH" in verbs(this))
    delete_verb(this, "secret_SHHH");
  endwhile
  this.messages = this.messages_going = {};
  this.mail_forward = {};
  this.mail_notify = {player};
  player.current_message = {@player.current_message, {this, 0, 0}};
  for p in ({"moderator_forward", "moderator_notify", "writers", "readers", "expire_period", "last_used_time"})
    this.(p) = $mail_recipient.(p);
  endfor
  this.moderated = 1;
else
  return E_PERM;
endif
.

"***finished***
