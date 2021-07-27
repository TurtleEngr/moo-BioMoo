$Header: /repo/public.cvs/app/BioGate/BioMooCore/core130.moo,v 1.1 2021/07/27 06:44:28 bruce Exp $

>@dump #130 with create
@create $thing named generic handy thing:generic handy thing,ght
@prop #130."hand_msg" "%N %<hands> %t to %i." rc
@prop #130."give_msg" "You hand %t to %i." rc
@prop #130."receive_msg" "%N hands %t to you." rc
@prop #130."ogive_msg" "%N hands %t to %i." rc
@prop #130."ght" #130 rc
@prop #130."ght_help_msg" {} rc
;;#130.("ght_help_msg") = {"This item is like $thing, except that when you hand it to someone, everyone else in the room can see you doing so.", "", "The text seen is in <thing>.hand_msg.  The code uses $you:say_action, so one message does all the work.  Thus, if this is a hot potato, and Frebblebit gives it to Munchkin, and the .hand_msg is, \"%N %<hands> %t to %i\"...", "", "Frebblebit sees:    You hand a hot potato to Munchkin.", "Munchkin sees:      Frebblebit hands a hot potato to you.", "Everyone else sees: Frebblebit hands a hot potato to Munchkin.", "", "The .hand_msg takes priority.  If it is set to the null string, then the following are used, if present:", "", "  <thing>.give_msg    -- told to giver", "  <thing>.receive_msg -- told to recipient", "  <thing>.ogive_msg   -- told to others in the room", ""}
;;#130.("aliases") = {"generic handy thing", "ght"}
;;#130.("description") = "Just like a $thing, except that when you hand it to someone else, the room gets notified, too."
;;#130.("object_size") = {0, 0}

@verb #130:"gi*ve ha*nd" this to any rxd
@program #130:give
if (this.location != player)
  player:tell("You don't have that!");
elseif (!valid(player.location))
  player:tell("I see no \"", iobjstr, "\" here.");
elseif ($command_utils:object_match_failed(who = player.location:match_object(iobjstr), iobjstr))
elseif (who.location != player.location)
  player:tell("I see no \"", iobjstr, "\" here.");
elseif (who == player)
  player:tell("Give it to yourself?");
else
  this:moveto(who);
  if (this.location == who)
    if (message = this:hand_msg())
      $you:say_action(message);
    else
      "Do the ordinary thing, but with messages.";
      if (message = this:give_msg())
        player:tell(message);
      endif
      if (message = this:receive_msg())
        who:tell(message);
      endif
      if (message = this:ogive_msg())
        player.location:announce_all_but({player, who}, message);
      endif
    endif
  else
    player:tell(who:titlec(), " ", $gender_utils:get_conj("does/do", who), " not want that item.");
  endif
endif
.

@verb #130:"hand_msg" this none this
@program #130:hand_msg
return this.(verb);
.

@verb #130:"give_msg receive_msg ogive_msg" this none this
@program #130:give_msg
return $string_utils:pronoun_sub(this.(verb));
.

@verb #130:"help_msg" this none this
@program #130:help_msg
"So that other things with existing .help_msg properties can @chparent to this.";
if (this == this.ght)
  result = this.ght_help_msg;
else
  result = $object_utils:has_property(this, "help_msg") ? this.(verb) | "";
endif
return result;
.

"***finished***
