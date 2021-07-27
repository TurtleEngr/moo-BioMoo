$Header: /repo/public.cvs/app/BioGate/BioMooCore/core54.moo,v 1.1 2021/07/27 06:44:32 bruce Exp $

>@dump #54 with create
@create $note named generic letter:generic letter
@prop #54."oburn_succeeded_msg" "stares at %t; %[tps] bursts into flame and disappears, leaving no ash." rc
@prop #54."oburn_failed_msg" 0 rc
@prop #54."burn_failed_msg" "%T might be damp.  In any case, %[tps] won't burn." rc
@prop #54."burn_succeeded_msg" "%T burns with a smokeless flame and leaves no ash." rc
;;#54.("take_failed_msg") = "This is a private letter."
;;#54.("aliases") = {"generic letter"}
;;#54.("description") = "Some writing on the letter explains that you should 'read letter', and when you've finished, 'burn letter'."
;;#54.("object_size") = {2686, 1577149626}
;;#54.("icon") = "http://hppsda.mayfield.hp.com/image/letter.gif"
;;#54.("vrml_desc") = {"WWWInline {name \"http://hppsda.mayfield.hp.com/image/letter.wrl\"}"}

@verb #54:"burn" this none none
@program #54:burn
who = valid(caller_perms()) ? caller_perms() | player;
if ($perm_utils:controls(who, this) || this:is_readable_by(who))
  result = this:do_burn();
else
  result = 0;
endif
player:tell(result ? this:burn_succeeded_msg() | this:burn_failed_msg());
if (msg = result ? this:oburn_succeeded_msg() | this:oburn_failed_msg())
  player.location:announce(player.name, " ", msg);
endif
.

@verb #54:"burn_succeeded_msg oburn_succeeded_msg burn_failed_msg oburn_failed_msg" this none this
@program #54:burn_succeeded_msg
return (msg = this.(verb)) ? $string_utils:pronoun_sub(msg) | "";
.

@verb #54:"do_burn" this none this
@program #54:do_burn
if ((this != $letter) && ((caller == this) || $perm_utils:controls(caller_perms(), this)))
  fork (0)
    $recycler:_recycle(this);
  endfork
  return 1;
else
  return E_PERM;
endif
.

"***finished***
