$Header: /repo/public.cvs/app/BioGate/BioMooCore/core42.moo,v 1.1 2021/07/27 06:44:31 bruce Exp $

>@dump #42 with create
@create $generic_utils named permissions utilities:Generic Utilities Package
;;#42.("help_msg") = {"Miscellaneous routines for permissions checking", "", "For a complete description of a given verb, do `help $perm_utils:verbname'", "", ":controls(who,what) -- can who write on object what", ":controls_property(who,what,propname) -- can who write on what.propname", "These routines check write flags and also the wizardliness of `who'.", "", "(these last two probably belong on $code_utils)", "", ":apply(permstring,mods)", "  -- used by @chmod to apply changes (e.g., +x) ", "     to a given permissions string", "", ":caller()", "  -- returns the first caller in the callers() stack distinct from `this'"}
;;#42.("aliases") = {"Generic Utilities Package"}
;;#42.("description") = {"This is the permissions utilities utility package.  See `help $perm_utils' for more details."}
;;#42.("object_size") = {3998, 1577149625}

@verb #42:"controls" this none this
@program #42:controls
"$perm_utils:controls(who, what)";
"Is WHO allowed to hack on WHAT?";
return (args[1] == args[2].owner) || args[1].wizard;
.

@verb #42:"apply" this none this rxd #36
@program #42:apply
":apply(permstring,mods) => new permstring.";
"permstring is a permissions string, mods is a concatenation of strings of the form +<letters>, !<letters>, or -<letters>, where <letters> is a string of letters as might appear in a permissions string (`+' adds the specified permissions, `-' or `!' removes them; `-' and `!' are entirely equivalent).";
{perms, mods} = args;
if ((!mods) || (!index("!-+", mods[1])))
  return mods;
endif
i = 1;
while (i <= length(mods))
  if (mods[i] == "+")
    while (((i = i + 1) <= length(mods)) && (!index("!-+", mods[i])))
      if (!index(perms, mods[i]))
        perms = perms + mods[i];
      endif
    endwhile
  else
    "mods[i] must be ! or -";
    while (((i = i + 1) <= length(mods)) && (!index("!-+", mods[i])))
      perms = strsub(perms, mods[i], "");
    endwhile
  endif
endwhile
return perms;
.

@verb #42:"caller" this none this
@program #42:caller
stage = 1;
{?lineno = 0} = args;
c = callers(lineno);
while (((stage = stage + 1) < length(c)) && (c[stage][1] == c[1][1]))
endwhile
return c[stage];
.

@verb #42:"controls_prop*erty controls_verb" this none this
@program #42:controls_property
"Syntax:  controls_prop(OBJ who, OBJ what, STR propname)   => 0 | 1";
"         controls_verb(OBJ who, OBJ what, STR verbname)   => 0 | 1";
"";
"Is WHO allowed to hack on WHAT's PROPNAME? Or VERBNAME?";
{who, what, name} = args;
bi = (verb == "controls_verb") ? "verb_info" | "property_info";
return who.wizard || (who == call_function(bi, what, name)[1]);
.

@verb #42:"password_ok" this none this rxd #95
@program #42:password_ok
"password_ok(crypted STR, teststr STR) -> matches BOOL";
"Returns true if `teststr' matches `crypted' using the MOO's standard";
"crypted checking algorithm.";
{crypted, teststr} = args;
return (((typeof(crypted) == STR) && (typeof(teststr) == STR)) && (length(crypted) > 2)) && (!strcmp(crypted, crypt(teststr, crypted[1..2])));
"Last modified Fri Feb 14 05:35:33 1997 IST by EricM (#3264).";
.

"***finished***
