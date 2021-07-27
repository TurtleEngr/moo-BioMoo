$Header: /repo/public.cvs/app/BioGate/BioMooCore/core34.moo,v 1.1 2021/07/27 06:44:30 bruce Exp $

>@dump #34 with create
@create $mail_recipient named Quota-Log:Quota-Log,Quota_Log,QL,Quota
;;#34.("last_msg_date") = 884919287
;;#34.("moderated") = 1
;;#34.("mail_notify") = {#2}
;;#34.("mail_forward") = {}
;;#34.("last_used_time") = 884919287
;;#34.("messages") = {{1, {878865926, "Wizard (#2)", "*Quota-Log (#34)", "@quota BioGate_wizard (#95) 100000 (from 50000)", "", "Reason for quota increase: (none)."}}, {2, {878865933, "Wizard (#2)", "*Quota-Log (#34)", "@quota BioGate_owner (#96) 100000 (from 50000)", "", "Reason for quota increase: (none)."}}, {3, {879818983, "Amalgam (#177)", "*Quota-Log (#34)", "@quota BioGate_owner (#96) 500000 (from 100000)", "", "Reason for quota increase: (none)."}}, {4, {880392306, "Adric (#178)", "*Quota-Log (#34)", "@quota Bruce (#180) 150000 (from 50000)", "", "Reason for quota increase: (none)."}}, {5, {884919269, "Amalgam (#177)", "*Quota-Log (#34)", "@quota Bill (#179) 1000000 (from 50000)", "", "Reason for quota increase: (none)."}}, {6, {884919287, "Amalgam (#177)", "*Quota-Log (#34)", "@quota Bruce (#180) 1000000 (from 150000)", "", "Reason for quota increase: (none)."}}}
;;#34.("aliases") = {"Quota-Log", "Quota_Log", "QL", "Quota"}
;;#34.("description") = "Record of whose quota has been messed with and why."
;;#34.("object_size") = {2876, 1577149625}

@verb #34:"init_for_core" this none this
@program #34:init_for_core
if (caller_perms().wizard)
  pass();
  delete_verb(this, "is_readable_by");
  delete_verb(this, "is_usable_by");
  delete_verb(this, "mail_notify");
  "...remove references to ARB...";
  this:rm_message_seq({1, 1 + this:length_all_msgs()});
  this:expunge_rmm();
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
