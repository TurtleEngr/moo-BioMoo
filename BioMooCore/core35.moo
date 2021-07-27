$Header: /repo/public.cvs/app/BioGate/BioMooCore/core35.moo,v 1.1 2021/07/27 06:44:31 bruce Exp $

>@dump #35 with create
@create #94 named you:you
@prop #35."conjugations" {} r
;;#35.("conjugations") = {{"is", "are"}, {"was", "were"}, {"does", "do"}, {"has", "have"}}
@prop #35."help_msg" {} rc
;;#35.("help_msg") = {"This object is useful for announcing messages that switch between third and second person when addressed to the appropriate parties in a room.", "", "Verbs:", "", "  :verb_sub(STR verbspec) -> conjugates the given verb into singular form", "  :say_action(message [,who [,thing, [,where]]]) -> appropriately pronoun ", "      substituted message announced to where, which defaults to who.location", "      where who defaults to player.", "  Ex:  if player=#123 (Munchkin), dobj=#456 (Frebblebit), and iobj=#789", "       (Bob) and they are all in the same room,", "       $you:say_action(\"%N %<waves> happily to %d and %i.\") would do this:", "", "Munchkin sees:       You wave happily to Frebblebit and Bob.", "Frebblebit sees:     Munchkin waves happily to you and Bob.", "Bob sees:            Munchkin waves happily to Frebblebit and you.", "Everyone else sees:  Munchkin waves happily to Frebblebit and Bob."}
;;#35.("gender") = "2nd"
;;#35.("pqc") = "Yours"
;;#35.("pq") = "yours"
;;#35.("ppc") = "Your"
;;#35.("pp") = "your"
;;#35.("prc") = "Yourself"
;;#35.("pr") = "yourself"
;;#35.("poc") = "You"
;;#35.("po") = "you"
;;#35.("psc") = "You"
;;#35.("ps") = "you"
;;#35.("aliases") = {"you"}
;;#35.("description") = {"An object useful for pronoun substitution for switching between third and second person.  See `help $you' for details."}
;;#35.("object_size") = {4494, 855068591}

@verb #35:"verb_sub" this none this
@program #35:verb_sub
"$you:verb_sub(STR verbspec) -> returns verbspec conjugated for singular use as if `you' were saying it.";
return $gender_utils:get_conj(args[1], this);
x = args[1];
len = length(x);
if ((len > 3) && (rindex(x, "n't") == (len - 3)))
  return this:verb_sub(x[1..len - 3]) + "n't";
endif
for y in (this.conjugations)
  if (x == y[1])
    return y[2];
  endif
endfor
for y in ({{"ches", "ch"}, {"ies", "y"}, {"sses", "ss"}, {"shes", "sh"}, {"s", ""}})
  if ((len > length(y[1])) && (rindex(x, y[1]) == ((len - length(y[1])) + 1)))
    return x[1..len - length(y[1])] + y[2];
  endif
endfor
return x;
.

@verb #35:"say_action" this none this rx
@program #35:say_action
"$you:say_action(message [,who [,thing, [,where]]]).";
"announce 'message' with pronoun substitution as if it were just ";
"  where:announce_all($string_utils:pronoun_sub(message, who, thing, where)); ";
"except that who (player), dobj, and iobj get modified messages, with the appropriate use of 'you' instead of their name.";
"who   default player";
"thing default object that called this verb";
"where default who.location";
{msg, ?who = player, ?thing = caller, ?where = who.location} = args;
you = this;
if (typeof(msg) == LIST)
  tell = "";
  for x in (msg)
    tell = tell + ((typeof(x) == STR) ? x | x[random(length(x))]);
  endfor
else
  tell = msg;
endif
who:tell($string_utils:pronoun_sub(this:fixpos(tell, "%n"), you, thing, where));
if ($object_utils:has_callable_verb(where, "announce_all_but"))
  where:announce_all_but({dobj, who, iobj}, $string_utils:pronoun_sub(tell, who, thing, where));
endif
if (valid(dobj) && (dobj != who))
  x = dobj;
  dobj = you;
  x:tell($string_utils:pronoun_sub(this:fixpos(tell, "%d"), who, thing, where));
  dobj = x;
endif
if (valid(iobj) && (!(iobj in {who, dobj})))
  x = iobj;
  iobj = you;
  x:tell($string_utils:pronoun_sub(this:fixpos(tell, "%i"), who, thing, where));
  iobj = x;
endif
.

@verb #35:"fixpos" this none this
@program #35:fixpos
"This is horribly dwimmy.  E.g. %x's gets turned into your, %X's gets turned into Your, and %X'S gets turned into YOUR. --Nosredna";
upper = $string_utils:uppercase(args[2]);
allupper = upper + "'S";
upper = upper + "'s";
lower = $string_utils:lowercase(args[2]) + "'s";
return strsub(strsub(strsub(args[1], lower, "your", 1), upper, "Your", 1), allupper, "YOUR", 1);
.

"***finished***
