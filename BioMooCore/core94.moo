$Header: /repo/public.cvs/app/BioGate/BioMooCore/core94.moo,v 1.1 2021/07/27 06:44:36 bruce Exp $

>@dump #94 with create
@create $root_class named Generic Gendered Object:Generic Gendered Object
@prop #94."gender" "neuter" rc
@prop #94."pqc" "its" rc
@prop #94."pq" "its" rc
@prop #94."ppc" "Its" rc
@prop #94."pp" "its" rc
@prop #94."prc" "Itself" rc
@prop #94."pr" "itself" rc
@prop #94."poc" "It" rc
@prop #94."po" "it" rc
@prop #94."psc" "It" rc
@prop #94."ps" "it" rc
;;#94.("aliases") = {"Generic Gendered Object"}
;;#94.("object_size") = {1787, 1577149627}

@verb #94:"set_gender" this none this
@program #94:set_gender
"set_gender(newgender) attempts to change this.gender to newgender";
"  => E_PERM   if you don't own this or aren't its parent";
"  => Other return values as from $gender_utils:set.";
if (!($perm_utils:controls(caller_perms(), this) || (this == caller)))
  return E_PERM;
else
  result = $gender_utils:set(this, args[1]);
  this.gender = (typeof(result) == STR) ? result | args[1];
  return result;
endif
.

@verb #94:"@gen*der" this is any
@program #94:@gender
if (player.wizard || (player == this.owner))
  player:tell(this:set_gender(iobjstr) ? "Gender and pronouns set." | "Gender set.");
else
  player:tell("Permission denied.");
endif
.

"***finished***
