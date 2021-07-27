$Header: /repo/public.cvs/app/BioGate/BioMooCore/core91.moo,v 1.1 2021/07/27 06:44:36 bruce Exp $

>@dump #91 with create
@create $feature named Stage-Talk Feature:Stage-Talk Feature
;;#91.("help_msg") = {"This feature contains various verbs used in stage talk, which allows players to describe their actions in terms of stage directions instead of prose."}
;;#91.("feature_verbs") = {"`", "[", "]", "-", "<"}
;;#91.("aliases") = {"Stage-Talk Feature"}
;;#91.("description") = {"This feature contains various verbs used in stage talk, which allows players to describe their actions in terms of stage directions instead of prose."}
;;#91.("object_size") = {3875, 855069281}

@verb #91:"stage `*" any any any rxd
@program #91:stage
"Say something out loud, directed at someone or something.";
"Usage:";
"  `target message";
"Example:";
"  Munchkin is talking to Kenneth, who's in the same room with him.  He types:";
"      `kenneth What is the frequency?";
"  The room sees:";
"       Munchkin [to Kenneth]: What is the frequency?";
name = verb[2..$];
who = player.location:match_object(name);
if ($command_utils:object_match_failed(who, name))
  return;
endif
player.location:announce_all(player.name, " [to ", who.name, "]: ", argstr);
.

@verb #91:"stage [*" any any any rxd
@program #91:stage
"Say something out loud, in some specific way.";
"Usage:";
"  [how]: message";
"Example:";
"  Munchkin decideds to sing some lyrics.  He types:";
"      [sings]: I am the eggman";
"  The room sees:";
"      Munchkin [sings]: I am the eggman";
player.location:announce_all((((player.name + " ") + verb) + " ") + argstr);
.

@verb #91:"stage ]*" any any any rxd
@program #91:stage
"Perform some physical, non-verbal, action.";
"Usage:";
"  ]third person action";
"Example:";
"  Munchkin has annoyed some would-be tough guy.  He types:";
"      ]hides behind the reactor.";
"  The room sees:";
"      [Munchkin hides behind the reactor.]";
player.location:announce_all("[", (((player.name + " ") + verb[2..$]) + (argstr ? " " + argstr | "")) + "]");
.

@verb #91:"-*" any any any rxd
@program #91:-
"This is the same as `*";
name = verb[2..$];
who = player.location:match_object(name);
argstr = $code_utils:argstr(verb, args, argstr);
if (!valid(who))
  player.location:announce_all(player.name, " [", name, "]: ", argstr);
else
  player.location:announce_all(player.name, " [to ", who.name, "]: ", argstr);
endif
.

@verb #91:"stage <*" any any any rxd
@program #91:stage
"Point to yourself.";
"Usage:";
"  <message";
"Example:";
"  Muchkin decides he's being strange. He types:";
"    <being strange.";
"  The room sees:";
"    Munchkin <- being strange.";
player.location:announce_all((((player.name + " <- ") + verb[2..$]) + " ") + argstr);
.

"***finished***
