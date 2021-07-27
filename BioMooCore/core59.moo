$Header: /repo/public.cvs/app/BioGate/BioMooCore/core59.moo,v 1.1 2021/07/27 06:44:33 bruce Exp $

>@dump #59 with create
@create $generic_utils named code utilities:code,utils
@prop #59."_version" "1.8.0r5" rc
@prop #59."_multi_preps" {} rc
;;#59.("_multi_preps") = {"off", "from", "out", "on", "on top", "in", "in front"}
@prop #59."_other_preps_n" {} rc
;;#59.("_other_preps_n") = {1, 2, 4, 4, 5, 5, 5, 6, 6, 9, 9, 12, 15}
@prop #59."_other_preps" {} rc
;;#59.("_other_preps") = {"using", "at", "inside", "into", "on top of", "onto", "upon", "out of", "from inside", "underneath", "beneath", "about", "off of"}
@prop #59."_short_preps" {} rc
;;#59.("_short_preps") = {"with", "to", "in front of", "in", "on", "from", "over", "through", "under", "behind", "beside", "for", "is", "as", "off"}
@prop #59."_all_preps" {} rc
;;#59.("_all_preps") = {"with", "using", "at", "to", "in front of", "in", "inside", "into", "on top of", "on", "onto", "upon", "out of", "from inside", "from", "over", "through", "under", "underneath", "beneath", "behind", "beside", "for", "about", "is", "as", "off", "off of"}
@prop #59."builtin_props" {} r #2
;;#59.("builtin_props") = {"name", "r", "w", "f", "programmer", "wizard", "owner", "location", "contents"}
@prop #59."error_names" {} rc
;;#59.("error_names") = {"E_NONE", "E_TYPE", "E_DIV", "E_PERM", "E_PROPNF", "E_VERBNF", "E_VARNF", "E_INVIND", "E_RECMOVE", "E_MAXREC", "E_RANGE", "E_ARGS", "E_NACC", "E_INVARG", "E_QUOTA", "E_FLOAT"}
@prop #59."error_list" {} rc
;;#59.("error_list") = {E_NONE, E_TYPE, E_DIV, E_PERM, E_PROPNF, E_VERBNF, E_VARNF, E_INVIND, E_RECMOVE, E_MAXREC, E_RANGE, E_ARGS, E_NACC, E_INVARG, E_QUOTA, E_FLOAT}
@prop #59."prepositions" {} rc
;;#59.("prepositions") = {"with/using", "at/to", "in front of", "in/inside/into", "on top of/on/onto/upon", "out of/from inside/from", "over", "through", "under/underneath/beneath", "behind", "beside", "for/about", "is", "as", "off/off of"}
;;#59.("help_msg") = {"parse_propref(\"foo.bar\")  => {\"foo\",\"bar\"} (or 0 if arg. isn't a property ref.)", "parse_verbref(\"foo:bar\")  => {\"foo\",\"bar\"} (or 0 if arg. isn't a verb ref.)", "parse_argspec(\"any\",\"in\",\"front\",\"of\",\"this\",\"baz\"...)", "                          => {{\"any\", \"in front of\", \"this\"},{\"baz\"...}} ", "                                           (or string if args don't parse)", "", "toint(string)           => integer (or E_TYPE if string is not a integer)", "toobj(string)           => object (or E_TYPE if string is not an object)", "toerr(integer or string) => error value (or 1 if out of range or unrecognized)", "error_name(error value) => name of error (e.g., error_name(E_PERM) => \"E_PERM\")", "", "verb_perms()      => the current task_perms (as set by set_task_perms()).", "verb_location()   => the object where the current verb is defined.", "verb_frame()      => callers()-style frame for the current verb.", "verb_all_frames() => entire callers() stack including current verb.", "verb_usage([object,verbname]) => returns first line of verb doc, usually usage", "verb_documentation([object,verbname]) => documentation at beginning of", "           verb code, if any -- default is the calling verb", "set_verb_documentation(object,verbname,text) => sets text at beginning of verb", "", "   Preposition routines", "", "prepositions()     => full list of prepostions", "full_prep (\"in\")   => \"in/inside/into\"", "short_prep(\"into\") => \"in\"", "short_prep(\"in/inside/into\") => \"in\"", "get_prep  (\"off\", \"of\", \"the\", \"table\") => {\"off of\", \"the\", \"table\"}", "", "   Verb routines", "", "verbname_match (fullname,name) => can `name' be used to call `fullname'", "find_verb_named          (object,name[,n]) => verb number or 0 if not found", "find_last_verb_named     (object,name[,n]) => verb number of last verb match", "find_callable_verb_named (object,name[,n]) => verb number or 0 if not found", "find_verbs_containing (pattern[,object|objlist]) => does work for @grep", "find_verbs_matching (pattern[,object|objlist]) => does work for @egrep", "move_verb (from obj,name,to obj[,newname]) => move a verb from object to object", "", "move_prop (from obj,name,to obj[,newname]) => move a property to another object", "", "   Verbs that do the actual dirty work for command lines verbs:", "", "@show           => show_object  (object)", "                   show_property(object,propname)", "                   show_verbdef (object,verbname)", "explain_syntax  => explain_verb_syntax(thisname,verbname,@verbargs)", "eval*-d         => eval_d(code)", "help            => help_db_list([player])", "                   help_db_search(string topic, dblist)", "@who            => show_who_listing(players [,more_players])", "@check-full     => display_callers([callers() output])", "", "   Random but useful verbs", "", "verb_or_property(object,name[,@args]) => result of verb or property call,", "                                         or E_PROPNF", "corify_object(object)     => if the object is corified, returns $<name>", "task_valid(INT task_id)   => returns true if task_id is currently running.", "task_owner(INT task_id)   => returns owner of task_id, if running", "owns_task(OBJ who,INT task_id) => returns whether who owns task_id (if running)", "argstr(verb,args[,argstr] => returns a corrected argstr (see full verb help)", "substitute(string,subs)   => subs in form {{\"target\", \"sub\"}, {...}, ...}"}
;;#59.("aliases") = {"code", "utils"}
;;#59.("description") = {"This is the code utilities utility package.  See `help $code_utils' for more details."}
;;#59.("object_size") = {53707, 855068591}

@verb #59:"eval_d" any any any rx #2
@program #59:eval_d
":eval_d(code...) => {compiled?,result}";
"This works exactly like the builtin eval() except that the code is evaluated ";
"as if the d flag were unset.";
code = {"set_verb_code(this,\"eval_d_util\",{\"\\\"Do not remove this verb!  This is an auxiliary verb for :eval_d().\\\";\"});", "dobj=iobj=this=#-1;", "dobjstr=iobjstr=prepstr=argstr=verb=\"\";", tostr("caller=", caller, ";"), "set_task_perms(caller_perms());", @args};
if (!caller_perms().programmer)
  return E_PERM;
elseif (svc = set_verb_code(this, "eval_d_util", code))
  lines = {};
  for line in (svc)
    if ((index(line, "Line ") == 1) && (n = toint(line[6..(colon = index(line + ":", ":")) - 1])))
      lines = {@lines, tostr("Line ", n - 5, line[colon..$])};
    else
      lines = {@lines, line};
    endif
  endfor
  return {0, lines};
else
  set_task_perms(caller_perms());
  return {1, this:eval_d_util()};
endif
.

@verb #59:"toint tonum" this none this
@program #59:toint
":toint(STR)";
"=> toint(s) if STR is numeric";
"=> E_TYPE if it isn't";
return match(s = args[1], "^ *[-+]?[0-9]+ *$") ? toint(s) | E_TYPE;
.

@verb #59:"toobj" this none this
@program #59:toobj
":toobj(objectid as string) => objectid";
return match(s = args[1], "^ *#[-+]?[0-9]+ *$") ? toobj(s) | E_TYPE;
.

@verb #59:"toerr" this none this
@program #59:toerr
"toerr(n), toerr(\"E_FOO\"), toerr(\"FOO\") => E_FOO.";
if (typeof(s = args[1]) != STR)
  n = toint(s) + 1;
  if (n > length(this.error_list))
    return 1;
  endif
elseif (!(n = (s in this.error_names) || (("E_" + s) in this.error_names)))
  return 1;
endif
return this.error_list[n];
.

@verb #59:"error_name" this none this
@program #59:error_name
"error_name(E_FOO) => \"E_FOO\"";
return toliteral(@args);
return this.error_names[toint(args[1]) + 1];
.

@verb #59:"show_object" this none this rxd #2
@program #59:show_object
set_task_perms(caller_perms());
{object, ?what = {"props", "verbs"}} = args;
player:notify(tostr("Object ID:  ", object));
player:notify(tostr("Name:       ", object.name));
names = {"Parent", "Location", "Owner"};
vals = {parent(object), object.location, object.owner};
for i in [1..length(vals)]
  if (!valid(vals[i]))
    val = "*** NONE ***";
  else
    val = ((vals[i].name + " (") + tostr(vals[i])) + ")";
  endif
  player:notify(tostr(names[i], ":      "[1..12 - length(names[i])], val));
endfor
line = "Flags:     ";
if (is_player(object))
  line = line + " player";
endif
for flag in ({"programmer", "wizard", "r", "w", "f"})
  if (object.(flag))
    line = (line + " ") + flag;
  endif
endfor
player:notify(line);
if (player.programmer && ((player.wizard || (player == object.owner)) || object.r))
  if (("verbs" in what) && (vs = verbs(object)))
    player:notify("Verb definitions:");
    for v in (vs)
      $command_utils:suspend_if_needed(0);
      player:notify(tostr("    ", v));
    endfor
  endif
  if ("props" in what)
    if (ps = properties(object))
      player:notify("Property definitions:");
      for p in (ps)
        $command_utils:suspend_if_needed(0);
        player:notify(tostr("    ", p));
      endfor
    endif
    all_props = $object_utils:all_properties(object);
    if (all_props != {})
      player:notify("Properties:");
      for p in (all_props)
        $command_utils:suspend_if_needed(0);
        strng = `toliteral(object.(p)) ! E_PERM => "(Permission denied.)"';
        player:notify(tostr("    ", p, ": ", strng));
      endfor
    endif
  endif
elseif (player.programmer)
  player:notify("** Can't list properties or verbs: permission denied.");
endif
if (object.contents)
  player:notify("Contents:");
  for o in (object.contents)
    $command_utils:suspend_if_needed(0);
    player:notify(tostr("    ", o.name, " (", o, ")"));
  endfor
endif
.

@verb #59:"show_property" this none this rxd #2
@program #59:show_property
set_task_perms(caller_perms());
{object, pname} = args;
if (pname in this.builtin_props)
  player:notify(tostr(object, ".", pname));
  player:notify("Built-in property.");
else
  try
    {owner, perms} = property_info(object, pname);
  except error (ANY)
    player:notify(error[2]);
    return;
  endtry
  player:notify(tostr(object, ".", pname));
  player:notify(tostr("Owner:        ", valid(owner) ? tostr(owner.name, " (", owner, ")") | "*** NONE ***"));
  player:notify(tostr("Permissions:  ", perms));
endif
player:notify(tostr("Value:        ", $string_utils:print(object.(pname))));
.

@verb #59:"show_verbdef" this none this rxd #2
@program #59:show_verbdef
set_task_perms(caller_perms());
{object, vname} = args;
if (!(hv = $object_utils:has_verb(object, vname)))
  player:notify("That object does not define that verb.");
  return;
elseif (hv[1] != object)
  player:notify(tostr("Object ", object, " does not define that verb, but its ancestor ", hv[1], " does."));
  object = hv[1];
endif
try
  {owner, perms, names} = verb_info(object, vname);
except error (ANY)
  player:notify(error[2]);
  return;
endtry
arg_specs = verb_args(object, vname);
player:notify(tostr(object, ":", names));
player:notify(tostr("Owner:            ", valid(owner) ? tostr(owner.name, " (", owner, ")") | "*** NONE ***"));
player:notify(tostr("Permissions:      ", perms));
player:notify(tostr("Direct Object:    ", arg_specs[1]));
player:notify(tostr("Preposition:      ", arg_specs[2]));
player:notify(tostr("Indirect Object:  ", arg_specs[3]));
.

@verb #59:"explain_verb_syntax" this none this rxd #2
@program #59:explain_verb_syntax
if (args[4..5] == {"none", "this"})
  return 0;
endif
{thisobj, verb, adobj, aprep, aiobj} = args;
prep_part = (aprep == "any") ? "to" | this:short_prep(aprep);
".........`any' => `to' (arbitrary),... `none' => empty string...";
if ((adobj == "this") && (dobj == thisobj))
  dobj_part = dobjstr;
  iobj_part = ((!prep_part) || (aiobj == "none")) ? "" | ((aiobj == "this") ? dobjstr | iobjstr);
elseif ((aiobj == "this") && (iobj == thisobj))
  dobj_part = (adobj == "any") ? dobjstr | ((adobj == "this") ? iobjstr | "");
  iobj_part = iobjstr;
elseif (!("this" in args[3..5]))
  dobj_part = (adobj == "any") ? dobjstr | "";
  iobj_part = (prep_part && (aiobj == "any")) ? iobjstr | "";
else
  return 0;
endif
return tostr(verb, dobj_part ? " " + dobj_part | "", prep_part ? " " + prep_part | "", iobj_part ? " " + iobj_part | "");
.

@verb #59:"verb_p*erms verb_permi*ssions" this none this rxd #2
@program #59:verb_perms
"returns the permissions of the current verb (either the owner or the result of the most recent set_task_perms()).";
return caller_perms();
.

@verb #59:"verb_loc*ation" this none this
@program #59:verb_location
"returns the object where the current verb is defined.";
return callers()[1][4];
.

@verb #59:"verb_documentation" this none this rxd #2
@program #59:verb_documentation
":verb_documentation([object,verbname]) => documentation at beginning of verb code, if any";
"default is the calling verb";
set_task_perms(caller_perms());
c = callers()[1];
{?object = c[4], ?vname = c[2]} = args;
try
  code = verb_code(object, vname);
except error (ANY)
  return error[2];
endtry
doc = {};
for line in (code)
  if (match(line, "^\"%([^\\\"]%|\\.%)*\";$"))
    "... now that we're sure `line' is just a string, eval() is safe...";
    doc = {@doc, $no_one:eval("; return " + line)[2]};
  else
    return doc;
  endif
endfor
return doc;
.

@verb #59:"set_verb_documentation" this none this rxd #2
@program #59:set_verb_documentation
":set_verb_documentation(object,verbname,text)";
"  changes documentation at beginning of verb code";
"  text is either a string or a list of strings";
"  returns a non-1 value if anything bad happens...";
set_task_perms(caller_perms());
{object, vname, text} = args;
if (typeof(code = `verb_code(object, vname) ! ANY') == ERR)
  return code;
elseif (typeof(vd = $code_utils:verb_documentation(object, vname)) == ERR)
  return vd;
elseif (!(typeof(text) in {LIST, STR}))
  return E_INVARG;
else
  newdoc = {};
  for l in ((typeof(text) == LIST) ? text | {text})
    if (typeof(l) != STR)
      return E_INVARG;
    endif
    newdoc = {@newdoc, $string_utils:print(l) + ";"};
  endfor
  if (ERR == typeof(svc = `set_verb_code(object, vname, {@newdoc, @code[length(vd) + 1..$]}) ! ANY'))
    "... this shouldn't happen.  I'm not setting this code -d just yet...";
    return svc;
  else
    return 1;
  endif
endif
.

@verb #59:"parse_propref" this none this rxd #2
@program #59:parse_propref
"$code_utils:parse_propref(string)";
"Parses string as a MOO-code property reference, returning {object-string, prop-name-string} for a successful parse and false otherwise.  It always returns the right object-string to pass to, for example, this-room:match_object.";
s = args[1];
if (dot = index(s, "."))
  object = s[1..dot - 1];
  prop = s[dot + 1..$];
  if ((object == "") || (prop == ""))
    return 0;
  elseif (object[1] == "$")
    object = #0.(object[2..$]);
    if (typeof(object) != OBJ)
      return 0;
    endif
    object = tostr(object);
  endif
elseif (index(s, "$") == 1)
  object = "#0";
  prop = s[2..$];
else
  return 0;
endif
return {object, prop};
.

@verb #59:"parse_verbref" this none this rxd #2
@program #59:parse_verbref
"$code_utils:parse_verbref(string)";
"Parses string as a MOO-code verb reference, returning {object-string, verb-name-string} for a successful parse and false otherwise.  It always returns the right object-string to pass to, for example, this-room:match_object().";
s = args[1];
if (colon = index(s, ":"))
  object = s[1..colon - 1];
  verbname = s[colon + 1..$];
  if (!(object && verbname))
    return 0;
  elseif ((object[1] == "$") && 0)
    "Why was this check taking place here? -- from jhm";
    pname = object[2..$];
    if ((!(pname in properties(#0))) || (typeof(object = #0.(pname)) != OBJ))
      return 0;
    endif
    object = tostr(object);
  endif
  return {object, verbname};
else
  return 0;
endif
.

@verb #59:"parse_argspec" this none this
@program #59:parse_argspec
":parse_arg_spec(@args)";
"  attempts to parse the given sequence of args into a verb_arg specification";
"returns {verb_args,remaining_args} if successful.";
"  e.g., :parse_arg_spec(\"this\",\"in\",\"front\",\"of\",\"any\",\"foo\"..)";
"           => {{\"this\",\"in front of\",\"any\"},{\"foo\"..}}";
"returns a string error message if parsing fails.";
nargs = length(args);
if (nargs < 1)
  return {{}, {}};
elseif ((ds = args[1]) == "tnt")
  return {{"this", "none", "this"}, listdelete(args, 1)};
elseif (!(ds in {"this", "any", "none"}))
  return tostr("\"", ds, "\" is not a valid direct object specifier.");
elseif ((nargs < 2) || (args[2] in {"none", "any"}))
  verbargs = args[1..min(3, nargs)];
  rest = args[4..nargs];
elseif (!(gp = $code_utils:get_prep(@args[2..nargs]))[1])
  return tostr("\"", args[2], "\" is not a valid preposition.");
else
  verbargs = {ds, @gp[1..min(2, nargs = length(gp))]};
  rest = gp[3..nargs];
endif
if ((length(verbargs) >= 3) && (!(verbargs[3] in {"this", "any", "none"})))
  return tostr("\"", verbargs[3], "\" is not a valid indirect object specifier.");
endif
return {verbargs, rest};
.

@verb #59:"prepositions" this none this
@program #59:prepositions
if (server_version() != this._version)
  this:_fix_preps();
endif
return this.prepositions;
.

@verb #59:"short_prep" this none this
@program #59:short_prep
":short_prep(p) => shortest preposition equivalent to p";
"p may be a single word or one of the strings returned by verb_args().";
if (server_version() != this._version)
  this:_fix_preps();
endif
word = args[1];
word = word[1..index(word + "/", "/") - 1];
if (p = word in this._other_preps)
  return this._short_preps[this._other_preps_n[p]];
elseif (word in this._short_preps)
  return word;
else
  return "";
endif
.

@verb #59:"full_prep" this none this
@program #59:full_prep
if (server_version() != this._version)
  this:_fix_preps();
endif
prep = args[1];
if (p = prep in this._short_preps)
  return this.prepositions[p];
elseif (p = prep in this._other_preps)
  return this.prepositions[this._other_preps_n[p]];
else
  return "";
endif
.

@verb #59:"get_prep" this none this
@program #59:get_prep
":get_prep(@args) extracts the prepositional phrase from the front of args, returning a list consisting of the preposition (or \"\", if none) followed by the unused args.";
":get_prep(\"in\",\"front\",\"of\",...) => {\"in front of\",...}";
":get_prep(\"inside\",...)          => {\"inside\",...}";
":get_prep(\"frabulous\",...}       => {\"\", \"frabulous\",...}";
prep = "";
allpreps = {@this._short_preps, @this._other_preps};
rest = 1;
for i in [1..length(args)]
  accum = (i == 1) ? args[1] | tostr(accum, " ", args[i]);
  if (accum in allpreps)
    prep = accum;
    rest = i + 1;
  endif
  if (!(accum in this._multi_preps))
    return {prep, @args[rest..$]};
  endif
endfor
return {prep, @args[rest..$]};
.

@verb #59:"_fix_preps" this to this rxd
@program #59:_fix_preps
":_fix_preps() updates the properties on this having to do with prepositions.";
"_fix_preps should be called whenever we detect that a new server version has been installed.";
orig_args = verb_args(this, verb);
multis = nothers = others = shorts = longs = {};
i = 0;
while (typeof(`set_verb_args(this, verb, {"this", tostr(i), "this"}) ! ANY') != ERR)
  l = verb_args(this, verb)[2];
  all = $string_utils:explode(l, "/");
  s = all[1];
  for p in (listdelete(all, 1))
    if (length(p) <= length(s))
      s = p;
    endif
  endfor
  for p in (all)
    while (j = rindex(p, " "))
      multis = {p = p[1..j - 1], @multis};
    endwhile
  endfor
  longs = {@longs, l};
  shorts = {@shorts, s};
  others = {@others, @setremove(all, s)};
  nothers = {@nothers, @$list_utils:make(length(all) - 1, length(shorts))};
  i = i + 1;
endwhile
set_verb_args(this, verb, orig_args);
this.prepositions = longs;
this._short_preps = shorts;
this._other_preps = others;
this._other_preps_n = nothers;
this._multi_preps = multis;
this._version = server_version();
return;
.

@verb #59:"find_verb_named" this none this rxd #2
@program #59:find_verb_named
":find_verb_named(object,name[,n])";
"  returns the *number* of the first verb on object matching the given name.";
"  optional argument n, if given, starts the search with verb n,";
"  causing the first n verbs (1..n-1) to be ignored.";
"  0 is returned if no verb is found.";
"  This routine does not find inherited verbs.";
{object, name, ?start = 1} = args;
for i in [start..length(verbs(object))]
  verbinfo = verb_info(object, i);
  if (this:verbname_match(verbinfo[3], name))
    return i;
  endif
endfor
return 0;
.

@verb #59:"find_last_verb_named" this none this rxd #2
@program #59:find_last_verb_named
":find_last_verb_named(object,name[,n])";
"  returns the *number* of the last verb on object matching the given name.";
"  optional argument n, if given, starts the search with verb n-1,";
"  causing verbs (n..length(verbs(object))) to be ignored.";
"  -1 is returned if no verb is found.";
"  This routine does not find inherited verbs.";
{object, name, ?last = -1} = args;
if (last < 0)
  last = length(verbs(object));
endif
for i in [0..last - 1]
  verbinfo = verb_info(object, last - i);
  if (this:verbname_match(verbinfo[3], name))
    return last - i;
  endif
endfor
return -1;
.

@verb #59:"find_callable_verb_named" this none this rxd #2
@program #59:find_callable_verb_named
":find_callable_verb_named(object,name[,n])";
"  returns the *number* of the first verb on object that matches the given";
"  name and has the x flag set.";
"  optional argument n, if given, starts the search with verb n,";
"  causing the first n verbs (0..n-1) to be ignored.";
"  0 is returned if no verb is found.";
"  This routine does not find inherited verbs.";
{object, name, ?start = 1} = args;
for i in [start..length(verbs(object))]
  verbinfo = verb_info(object, i);
  if (index(verbinfo[2], "x") && this:verbname_match(verbinfo[3], name))
    return i;
  endif
endfor
return 0;
.

@verb #59:"verbname_match(new)" this none this
@program #59:verbname_match(new)
":verbname_match(fullverbname,name) => TRUE iff `name' is a valid name for a verb with the given `fullname'";
verblist = (" " + args[1]) + " ";
if (index(verblist, (" " + (name = args[2])) + " ") && (!match(name, "[ *]")))
  "Note that if name has a * or a space in it, then it can only match one of the * verbnames";
  return 1;
else
  namelen = length(name);
  while (m = match(verblist, "[^ *]*%(%*%)[^ ]*"))
    vlast = m[2];
    if ((namelen >= (m[3][1][1] - m[1])) && ((!(v = strsub(verblist[m[1]..vlast], "*", ""))) || (index(v, (verblist[vlast] == "*") ? name[1..min(namelen, length(v))] | name) == 1)))
      return 1;
    endif
    verblist = verblist[vlast + 1..$];
  endwhile
endif
return 0;
.

@verb #59:"find_verbs_containing" this none this rxd #2
@program #59:find_verbs_containing
"$code_utils:find_verbs_containing(pattern[,object|object-list])";
"";
"Print (to player) the name and owner of every verb in the database whose code contains PATTERN as a substring.  Optional second argument limits the search to the specified object or objects.";
"";
"Because it searches the entire database, this function may suspend the task several times before returning.";
"";
set_task_perms(caller_perms());
"... puts the task in a player's own job queue and prevents someone from learning about verbs that are otherwise unreadable to him/her.";
{pattern, ?where = 0} = args;
count = 0;
if (typeof(where) == INT)
  for o in [toobj(where)..max_object()]
    if (valid(o))
      count = count + this:_find_verbs_containing(pattern, o);
    endif
    if ($command_utils:running_out_of_time())
      player:notify(tostr("...", o));
      suspend(0);
    endif
  endfor
elseif (typeof(where) == LIST)
  for o in (where)
    count = count + this:_find_verbs_containing(pattern, o);
  endfor
else
  "...typeof(where) == OBJ...";
  count = this:_find_verbs_containing(pattern, where);
endif
player:notify("");
player:notify(tostr("Total: ", count, " verbs."));
.

@verb #59:"_find_verbs_containing" this none this rxd #2
@program #59:_find_verbs_containing
":_find_verbs_containing(pattern,object)";
"number of verbs in object with code having a line containing pattern";
"prints verbname and offending line to player";
set_task_perms(caller_perms());
{pattern, o} = args;
count = 0;
try
  verbs = verbs(o);
  for vnum in [1..length(verbs)]
    if (l = this:_grep_verb_code(pattern, o, vnum))
      owner = verb_info(o, vnum)[1];
      player:notify(tostr(o, ":", verbs[vnum], " [", valid(owner) ? owner.name | "Recycled Player", " (", owner, ")]:  ", l));
      count = count + 1;
    endif
    if ($command_utils:running_out_of_time())
      player:notify(tostr("...", o));
      suspend(0);
    endif
  endfor
  return count;
except e (ANY)
  player:notify(tostr("verbs(", o, ") => ", e[2]));
endtry
.

@verb #59:"find_verbs_matching" this none this rxd #2
@program #59:find_verbs_matching
"$code_utils:find_verbs_matching(pattern[,object|object-list])";
"";
"Print (to player) the name and owner of every verb in the database whose code has a substring matches the regular expression PATTERN.  Optional second argument limits the search to the specified object or objects.";
"";
"Because it searches the entire database, this function may suspend the task several times before returning.";
"";
set_task_perms(caller_perms());
"... puts the task in a player's own job queue and prevents someone from learning about verbs that are otherwise unreadable to him/her.";
{pattern, ?where = 0} = args;
count = 0;
if (typeof(where) == INT)
  for o in [toobj(where)..max_object()]
    if (valid(o))
      count = count + this:_find_verbs_matching(pattern, o);
    endif
    if ($command_utils:running_out_of_time())
      player:notify(tostr("...", o));
      suspend(0);
    endif
  endfor
elseif (typeof(where) == LIST)
  for o in (where)
    count = count + this:_find_verbs_matching(pattern, o);
  endfor
else
  count = this:_find_verbs_matching(pattern, where);
endif
player:notify("");
player:notify(tostr("Total: ", count, " verbs."));
.

@verb #59:"_find_verbs_matching" this none this rxd #2
@program #59:_find_verbs_matching
":_find_verbs_matching(regexp,object[,casematters])";
"number of verbs in object with code having a line matching regexp";
"prints verbname and offending line to player";
set_task_perms(caller_perms());
{pattern, o, ?casematters = 0} = args;
count = 0;
try
  verbs = verbs(o);
  for vnum in [1..length(verbs)]
    if (l = this:_egrep_verb_code(pattern, o, vnum, casematters))
      owner = verb_info(o, vnum)[1];
      player:notify(tostr(o, ":", verbs[vnum], " [", valid(owner) ? owner.name | "Recycled Player", " (", owner, ")]:  ", l));
      count = count + 1;
    endif
    if ($command_utils:running_out_of_time())
      player:notify(tostr("...", o));
      suspend(0);
    endif
  endfor
  return count;
except e (ANY)
  player:notify(tostr("verbs(", o, ")  => ", e[2]));
endtry
.

@verb #59:"_grep_verb_code" this none this rxd #2
@program #59:_grep_verb_code
":_grep_verb_code(pattern,object,verbname) => line number or 0";
"  returns line number on which pattern occurs in code for object:verbname";
set_task_perms(caller_perms());
pattern = args[1];
"The following gross kluge is due to Quade (#82589).  tostr is fast, and so we can check for nonexistence of a pattern very quickly this way rather than checking line by line.  MOO needs a compiler.  --Nosredna";
vc = `verb_code(@listdelete(args, 1)) ! ANY';
if ((typeof(vc) == ERR) || (!index(tostr(@vc), pattern)))
  return 0;
else
  for line in (vc)
    if (index(line, pattern))
      return line;
    endif
  endfor
  return 0;
endif
.

@verb #59:"_egrep_verb_code" this none this rxd #2
@program #59:_egrep_verb_code
":_egrep_verb_code(regexp,object,verbname[,casematters]) => 0 or line number";
"  returns line number of first line matching regexp in object:verbname code";
set_task_perms(caller_perms());
{pattern, object, vname, ?casematters = 0} = args;
for line in (vc = `verb_code(object, vname) ! ANY => {}')
  try
    if (match(line, pattern, casematters))
      return line;
    endif
  except (E_INVARG)
    raise(E_INVARG, "Malformed regular expression.");
  endtry
endfor
return 0;
.

@verb #59:"_parse_audit_args" this none this
@program #59:_parse_audit_args
"Parse [from <start>] [to <end>] [for <name>].";
"Takes a series of strings, most likely @args with dobjstr removed.";
"Returns a list {INT start, INT end, STR name}, or {} if there is an error.";
fail = length(args) % 2;
start = 0;
end = toint(max_object());
match = "";
while (args && (!fail))
  prep = args[1];
  if (prep == "from")
    if ((start = player.location:match_object(args[2])) >= #0)
      start = toint(start);
    else
      start = toint(args[2]);
    endif
  elseif (prep == "to")
    if ((end = player.location:match_object(args[2])) >= #0)
      end = toint(end);
    else
      end = toint(args[2]);
    endif
  elseif (prep == "for")
    match = args[2];
  else
    fail = 1;
  endif
  args = args[3..length(args)];
endwhile
return fail ? {} | {start, end, match};
.

@verb #59:"help_db_list" this none this rxd #2
@program #59:help_db_list
":help_db_list([player]) => list of help dbs";
"in the order that they are consulted by player";
{?who = player} = args;
olist = {who, @$object_utils:ancestors(who)};
if (valid(who.location))
  olist = {@olist, who.location, @$object_utils:ancestors(who.location)};
endif
dbs = {};
for o in (olist)
  h = `o.help ! ANY => 0';
  if (typeof(h) == OBJ)
    h = {h};
  endif
  if (typeof(h) == LIST)
    for db in (h)
      if ((typeof(db) == OBJ) && (valid(db) && (!(db in dbs))))
        dbs = {@dbs, db};
      endif
    endfor
  endif
endfor
return {@dbs, $help};
.

@verb #59:"help_db_search" this none this
@program #59:help_db_search
":help_db_search(string,dblist)";
"  searches each of the help db's in dblist for a topic matching string.";
"  Returns  {db,topic}  or  {$ambiguous_match,{topic...}}  or {}";
{what, dblist} = args;
topics = {};
help = 1;
for db in (dblist)
  $command_utils:suspend_if_needed(0);
  if ({what} == (ts = `db:find_topics(what) ! ANY => 0'))
    return {db, ts[1]};
  elseif (ts && (typeof(ts) == LIST))
    if (help)
      help = db;
    endif
    for t in (ts)
      topics = setadd(topics, t);
    endfor
  endif
endfor
if (length(topics) > 1)
  return {$ambiguous_match, topics};
elseif (topics)
  return {help, topics[1]};
else
  return {};
endif
.

@verb #59:"corify_object" this none this
@program #59:corify_object
":corify_object(object)  => string representing object";
"  usually just returns tostr(object), but in the case of objects that have";
"  corresponding #0 properties, return the appropriate $-string.";
object = args[1];
"Just in case #0 is !r on some idiot core.";
for p in (`properties(#0) ! ANY => {}')
  "And if for some reason, some #0 prop is !r.";
  if (`#0.(p) ! ANY' == object)
    return "$" + p;
  endif
endfor
return tostr(object);
.

@verb #59:"inside_quotes" this none this rxd #2
@program #59:inside_quotes
"See if the end of the string passed as args[1] ends 'inside' a doublequote.  Used by $code_utils:substitute.";
string = args[1];
quoted = 0;
for i in [1..length(string)]
  if ((string[i] == "\"") && ((!quoted) || (string[i - 1] != "\\")))
    quoted = !quoted;
  endif
endfor
return quoted;
.

@verb #59:"verb_or_property" this none this rxd #2
@program #59:verb_or_property
"verb_or_property(<obj>, <name> [, @<args>])";
"Looks for a callable verb or property named <name> on <obj>.";
"If <obj> has a callable verb named <name> then return <obj>:(<name>)(@<args>).";
"If <obj> has a property named <name> then return <obj>.(<name>).";
"Otherwise return E_PROPNF, or E_PERM if you don't have permission to read the property.";
set_task_perms(caller_perms());
{object, name, @rest} = args;
return `object:(name)(@rest) ! E_VERBNF, E_INVIND => `object.(name) ! ANY'';
.

@verb #59:"task_valid" this none this rxd #2
@program #59:task_valid
"task_valid(INT id)";
"Return true iff there is currently a valid task with the given id.";
set_task_perms($no_one);
id = args[1];
return (id == task_id()) || (E_PERM == `kill_task(id) ! ANY');
.

@verb #59:"task_owner" this none this rxd #2
@program #59:task_owner
":task_owner(INT task_id) => returns the owner of the task belonging to the id.";
if (a = $list_utils:assoc(args[1], queued_tasks()))
  return a[5];
else
  return E_INVARG;
endif
.

@verb #59:"argstr" this none this rxd #2
@program #59:argstr
":argstr(verb,args[,argstr]) => what argstr should have been.  ";
"Recall that the command line is parsed into a sequence of words; `verb' is";
"assigned the first word, `args' is assigned the remaining words, and argstr";
"is assigned a substring of the command line, which *should* be the one";
"starting first nonblank character after the verb, but is instead (because";
"the parser is BROKEN!) the one starting with the first nonblank character";
"after the first space in the line, which is not necessarily after the verb.";
"Clearly, if the verb contains spaces --- which can happen if you use";
"backslashes and quotes --- this loses, and argstr will then erroneously";
"have extra junk at the beginning.  This verb, given verb, args, and the";
"actual argstr, returns what argstr should have been.";
verb = args[1];
argstr = {@args, argstr}[3];
n = length(args = args[2]);
if (!index(verb, " "))
  return argstr;
elseif (!args)
  return "";
endif
"space in verb => two possible cases:";
"(1) first space was not in a quoted string.";
"    first word of argstr == rest of verb unless verb ended on this space.";
if ((nqargs = $string_utils:words(argstr)) == args)
  return argstr;
elseif (((nqn = length(nqargs)) == (n + 1)) && (nqargs[2..nqn] == args))
  return argstr[$string_utils:word_start(argstr)[2][1]..length(argstr)];
else
  "(2) first space was in a quoted string.";
  "    argstr starts with rest of string";
  qs = $string_utils:word_start("\"" + argstr);
  return argstr[qs[(length(qs) - length(args)) + 1][1] - 1..length(argstr)];
endif
.

@verb #59:"verbname_match" this none this
@program #59:verbname_match
":verbname_match(fullverbname,name) => TRUE iff `name' is a valid name for a verb with the given `fullname'";
verblist = (" " + args[1]) + " ";
if (index(verblist, (" " + (name = args[2])) + " ") && (!(index(name, "*") || index(name, " "))))
  "Note that if name has a * or a space in it, then it can only match one of the * verbnames";
  return 1;
else
  namelen = length(name);
  while (star = index(verblist, "*"))
    vstart = rindex(verblist[1..star], " ") + 1;
    vlast = (vstart + index(verblist[vstart..$], " ")) - 2;
    if ((namelen >= (star - vstart)) && ((!(v = strsub(verblist[vstart..vlast], "*", ""))) || (index(v, (verblist[vlast] == "*") ? name[1..min(namelen, length(v))] | name) == 1)))
      return 1;
    endif
    verblist = verblist[vlast + 1..$];
  endwhile
endif
return 0;
.

@verb #59:"substitute" this none this
@program #59:substitute
"$code_utils:substitute(string,subs) => new line";
"Subs are a list of lists, {{\"target\",\"sub\"},{...}...}";
"Substitutes targets for subs in a delimited string fashion, avoiding substituting anything inside quotes, e.g. player:tell(\"don't sub here!\")";
{s, subs} = args;
lets = "abcdefghijklmnopqrstuvwxyz0123456789";
for x in (subs)
  len = length(sub = x[1]);
  delimited = index(lets, sub[1]) && index(lets, sub[len]);
  prefix = "";
  while (i = index(s, sub))
    prefix = prefix + s[1..i - 1];
    if ((((prefix == "") || ((!delimited) || (!index(lets, prefix[$])))) && ((!delimited) || (((i + len) > length(s)) || (!index(lets, s[i + len]))))) && (!this:inside_quotes(prefix)))
      prefix = prefix + x[2];
    else
      prefix = prefix + s[i..(i + len) - 1];
    endif
    s = s[i + len..length(s)];
  endwhile
  s = prefix + s;
endfor
return s;
.

@verb #59:"show_who_listing" this none this rxd #2
@program #59:show_who_listing
":show_who_listing(players[,more_players])";
" prints a listing of the indicated players.";
" For players in the first list, idle/connected times are shown if the player is logged in, otherwise the last_disconnect_time is shown.  For players in the second list, last_disconnect_time is shown, no matter whether the player is logged in.";
{plist, ?more_plist = {}} = args;
idles = itimes = offs = otimes = {};
argstr = dobjstr = iobjstr = prepstr = "";
for p in (more_plist)
  if (!valid(p))
    caller:notify(tostr(p, " <invalid>"));
  elseif (typeof(t = `p.last_disconnect_time ! E_PROPNF') == INT)
    if (!(p in offs))
      offs = {@offs, p};
      otimes = {@otimes, {-t, -t, p}};
    endif
  elseif (is_player(p))
    caller:notify(tostr(p.name, " (", p, ") ", (t == E_PROPNF) ? "is not a $player." | "has a garbled .last_disconnect_time."));
  else
    caller:notify(tostr(p.name, " (", p, ") is not a player."));
  endif
endfor
for p in (plist)
  if (p in offs)
  elseif (!valid(p))
    caller:notify(tostr(p, " <invalid>"));
  elseif (typeof(i = `idle_seconds(p) ! ANY') != ERR)
    if (!(p in idles))
      idles = {@idles, p};
      itimes = {@itimes, {i, connected_seconds(p), p}};
    endif
  elseif (typeof(t = `p.last_disconnect_time ! E_PROPNF') == INT)
    offs = {@offs, p};
    otimes = {@otimes, {-t, -t, p}};
  elseif (is_player(p))
    caller:notify(tostr(p.name, " (", p, ") not logged in.", (t == E_PROPNF) ? "  Not a $player." | "  Garbled .last_disconnect_time."));
  else
    caller:notify(tostr(p.name, " (", p, ") is not a player."));
  endif
endfor
if (!(idles || offs))
  return 0;
endif
idles = $list_utils:sort_alist(itimes);
offs = $list_utils:sort_alist(otimes);
"...";
"... calculate widths...";
"...";
headers = {"Player name", @idles ? {"Connected", "Idle time"} | {"Last disconnect time", ""}, "Location"};
total_width = `caller:linelen() ! ANY => 0' || 79;
max_name = total_width / 4;
name_width = length(headers[1]);
names = locations = {};
for lst in ({@idles, @offs})
  $command_utils:suspend_if_needed(0);
  p = lst[3];
  namestr = tostr(p.name[1..min(max_name, $)], " (", p, ")");
  name_width = max(length(namestr), name_width);
  names = {@names, namestr};
  if (typeof(wlm = `p.location:who_location_msg(p) ! ANY') != STR)
    wlm = valid(p.location) ? p.location.name | tostr("** Nowhere ** (", p.location, ")");
  endif
  locations = {@locations, wlm};
endfor
time_width = 3 + (offs ? 12 | length("59 minutes"));
before = {0, w1 = 3 + name_width, w2 = w1 + time_width, w2 + time_width};
"...";
"...print headers...";
"...";
su = $string_utils;
tell1 = headers[1];
tell2 = su:space(tell1, "-");
for j in [2..4]
  tell1 = su:left(tell1, before[j]) + headers[j];
  tell2 = su:left(tell2, before[j]) + su:space(headers[j], "-");
endfor
caller:notify(tell1[1..min($, total_width)]);
caller:notify(tell2[1..min($, total_width)]);
"...";
"...print lines...";
"...";
active = 0;
for i in [1..total = (ilen = length(idles)) + length(offs)]
  if (i <= ilen)
    lst = idles[i];
    if (lst[1] < (5 * 60))
      active = active + 1;
    endif
    l = {names[i], su:from_seconds(lst[2]), su:from_seconds(lst[1]), locations[i]};
  else
    lct = offs[i - ilen][3].last_connect_time;
    ldt = offs[i - ilen][3].last_disconnect_time;
    ctime = `caller:ctime(ldt) ! ANY => 0' || ctime(ldt);
    l = {names[i], (lct <= time()) ? ctime | "Never", "", locations[i]};
    if ((i == (ilen + 1)) && idles)
      caller:notify(su:space(before[2]) + "------- Disconnected -------");
    endif
  endif
  tell1 = l[1];
  for j in [2..4]
    tell1 = su:left(tell1, before[j]) + l[j];
  endfor
  caller:notify(tell1[1..min($, total_width)]);
  if ($command_utils:running_out_of_time())
    if ($login:is_lagging())
      "Check lag two ways---global lag, but we might still fail due to individual lag of the queue this runs in, so check again later.";
      caller:notify(tostr("Plus ", total - i, " other players (", total, " total; out of time and lag is high)."));
      return;
    endif
    now = time();
    suspend(0);
    if ((time() - now) > 10)
      caller:notify(tostr("Plus ", total - i, " other players (", total, " total; out of time and lag is high)."));
      return;
    endif
  endif
endfor
"...";
"...epilogue...";
"...";
caller:notify("");
if (total == 1)
  active_str = ", who has" + ((active == 1) ? "" | " not");
else
  if (active == total)
    active_str = (active == 2) ? "s, both" | "s, all";
  elseif (active == 0)
    active_str = "s, none";
  else
    active_str = tostr("s, ", active);
  endif
  active_str = tostr(active_str, " of whom ha", (active == 1) ? "s" | "ve");
endif
caller:notify(tostr("Total: ", total, " player", active_str, " been active recently."));
return total;
.

@verb #59:"_egrep_verb_code_all" this none this rxd #2
@program #59:_egrep_verb_code_all
":_egrep_verb_code_all(regexp,object,verbname) => list of lines number";
"  returns list of all lines matching regexp in object:verbname code";
set_task_perms(caller_perms());
{pattern, object, vname} = args;
lines = {};
for line in (vc = `verb_code(object, vname, 1, 0) ! ANY => {}')
  if (match(line, pattern))
    lines = {@lines, line};
  endif
endfor
return lines;
.

@verb #59:"_grep_verb_code_all" this none this rxd #2
@program #59:_grep_verb_code_all
":_grep_verb_code_all(pattern,object,verbname) => list of lines";
"  returns list of lines on which pattern occurs in code for object:verbname";
set_task_perms(caller_perms());
{pattern, object, vname} = args;
lines = {};
for line in (vc = `verb_code(object, vname) ! ANY => {}')
  if (index(line, pattern))
    lines = {@lines, line};
  endif
endfor
return lines;
.

@verb #59:"verb_usage" this none this rxd #2
@program #59:verb_usage
":verb_usage([object,verbname]) => usage string at beginning of verb code, if any";
"default is the calling verb";
set_task_perms(caller_perms());
c = callers()[1];
{?object = c[4], ?vname = c[2]} = args;
if (typeof(code = `verb_code(object, vname) ! ANY') == ERR)
  return code;
else
  doc = {};
  for line in (code)
    if (match(line, "^\"%([^\\\"]%|\\.%)*\";$"))
      "... now that we're sure `line' is just a string, eval() is safe...";
      e = $no_one:eval(line)[2];
      if (subs = match(e, "^%(Usage: +%)%([^ ]+%)%(.*$%)"))
        "Server is broken, hence the next three lines:";
        if (subs[3][3][1] > subs[3][3][2])
          subs[3][3] = {0, -1};
        endif
        indent = ("^%(" + $string_utils:space(length(substitute("%1", subs)))) + " *%)%([^ ]+%)%(.*$%)";
        docverb = substitute("%2", subs);
        if (match(vname, "^[0-9]+$"))
          vname = docverb;
        endif
        doc = {@doc, (substitute("%1", subs) + vname) + substitute("%3", subs)};
      elseif (subs = match(e, indent))
        if (substitute("%2", subs) == docverb)
          doc = {@doc, (substitute("%1", subs) + vname) + substitute("%3", subs)};
        else
          doc = {@doc, e};
        endif
      elseif (indent)
        return doc;
      endif
    else
      return doc;
    endif
  endfor
  return doc;
endif
.

@verb #59:"verb_frame" this none this
@program #59:verb_frame
"returns the callers() frame for the current verb.";
return callers()[1];
.

@verb #59:"verb_all_frames" this none this
@program #59:verb_all_frames
"returns {this:verb_frame(), @callers()}.";
return callers();
.

@verb #59:"move_verb" this none this rxd #2
@program #59:move_verb
":move_verb(OBJ from, STR verb name, OBJ to, [STR new verb name]) -> Moves the specified verb from one object to another. Returns {OBJ, Full verb name} where the verb now resides if successful, error if not. To succeed, caller_perms() must control both objects and own the verb, unless called with wizard perms. Supplying a fourth argument moves the verb to a new name.";
"Should handle verbnames with aliases and wildcards correctly.";
who = caller_perms();
{from, origverb, to, ?destverb = origverb} = args;
if ((((typeof(from) != OBJ) || (typeof(to) != OBJ)) || (typeof(origverb) != STR)) || (typeof(destverb) != STR))
  "check this first so we can parse out long verb names next";
  return E_TYPE;
endif
origverb_first = strsub(origverb[1..index(origverb + " ", " ") - 1], "*", "") || "*";
destverb_first = strsub(destverb[1..index(destverb + " ", " ") - 1], "*", "") || "*";
if ((!valid(from)) || (!valid(to)))
  return E_INVARG;
elseif ((from == to) && (destverb == origverb))
  "Moving same origverb onto the same object puts the verbcode in the wrong one. Just not allow";
  return E_NACC;
elseif (((!$perm_utils:controls(who, from)) && (!from.w)) || ((!$perm_utils:controls(who, to)) && (!to.w)))
  "caller_perms() is not allowed to hack on either object in question";
  return E_PERM;
elseif (!$object_utils:defines_verb(from, origverb_first))
  "verb is not defined on the from object";
  return E_VERBNF;
elseif ((vinfo = verb_info(from, origverb_first)) && (!$perm_utils:controls(who, vinfo[1])))
  "caller_perms() is not permitted to add a verb with the existing verb owner";
  return E_PERM;
elseif (!who.programmer)
  return E_PERM;
else
  "we now know that the caller's perms control the objects or the objects are writable, and we know that the caller's perms control the prospective verb owner (by more traditional means)";
  vcode = verb_code(from, origverb_first);
  vargs = verb_args(from, origverb_first);
  vinfo[3] = (destverb == origverb) ? vinfo[3] | destverb;
  if (typeof(res = `add_verb(to, vinfo, vargs) ! ANY') == ERR)
    return res;
  else
    set_verb_code(to, destverb_first, vcode);
    delete_verb(from, origverb_first);
    return {to, vinfo[3]};
  endif
endif
.

@verb #59:"move_prop*erty" this none this rxd #2
@program #59:move_property
":move_prop(OBJ from, STR prop name, OBJ to, [STR new prop name]) -> Moves the specified property and its contents from one object to another. Returns {OBJ, property name} where the property now resides if successful, error if not. To succeed, caller_perms() must control both objects and own the property, unless called with wizard perms. Supplying a fourth argument gives the property a new name on the new object.";
who = caller_perms();
{from, origprop, to, ?destprop = origprop} = args;
if ((((typeof(from) != OBJ) || (typeof(to) != OBJ)) || (typeof(origprop) != STR)) || (typeof(destprop) != STR))
  return E_TYPE;
elseif ((!valid(from)) || (!valid(to)))
  return E_INVARG;
elseif ((from == to) && (destprop == origprop))
  "Moving same prop onto the same object puts the contents in the wrong one. Just not allow";
  return E_NACC;
elseif (((!$perm_utils:controls(who, from)) && (!from.w)) || ((!$perm_utils:controls(who, to)) && (!to.w)))
  "caller_perms() is not allowed to hack on either object in question";
  return E_PERM;
elseif (!$object_utils:defines_property(from, origprop))
  "property is not defined on the from object";
  return E_PROPNF;
elseif ((pinfo = property_info(from, origprop)) && (!$perm_utils:controls(who, pinfo[1])))
  "caller_perms() is not permitted to add a property with the existing property owner";
  return E_PERM;
elseif (!who.programmer)
  return E_PERM;
else
  "we now know that the caller's perms control the objects or the objects are writable, and we know that the caller's perms control the prospective property owner (by more traditional means)";
  pdata = from.(origprop);
  pname = (destprop == origprop) ? origprop | destprop;
  if (typeof(res = `add_property(to, pname, pdata, pinfo) ! ANY') == ERR)
    return res;
  else
    delete_property(from, origprop);
    return {to, pname};
  endif
endif
.

@verb #59:"eval_d_util" this none this rx #2
@program #59:eval_d_util
"Do not remove this verb!  This is an auxiliary verb for :eval_d().";
.

@verb #59:"display_callers" this none this rxd #2
@program #59:display_callers
":display_callers([callers() style list]) - displays the output of the given argument, assumed to be a callers() output. See `help callers()' for details. Will use callers() explicitly if no argument is passed.";
call = (caller_perms() == player) ? "notify_lines" | "tell_lines";
player:(call)(this:callers_text(@args));
.

@verb #59:"callers_text" this none this rxd #2
@program #59:callers_text
":callers_text([callers() style list]) - returns the output of the given argument, assumed to be a callers() output. See `help callers()' for details. Will use callers() explicitly if no argument is passed.";
linelen = player:linelen();
text = {};
su = $string_utils;
lu = $list_utils;
verbwidth = 0;
{?match = callers()} = args;
for verbitem in (lu:slice(match, 2))
  verbwidth = max(verbwidth, length(verbitem));
endfor
numwidth = ((linelen - verbwidth) / 4) - 1;
widths = {numwidth, verbwidth, numwidth, numwidth, numwidth};
top = l = between = "";
for x in [1..5]
  top = (top + between) + su:left({"This", "Verb", "Permissions", "VerbLocation", "Player"}[x], -widths[x]);
  l = (l + between) + su:space(widths[x], "-");
  between = " ";
endfor
text = listappend(text, top);
text = listappend(text, l);
for line in (match)
  output = {};
  for bit in [1..5]
    $command_utils:suspend_if_needed(3);
    output = {@output, su:left((typeof(word = line[bit]) == STR) ? word | tostr(word, "(", valid(word) ? lu:shortest({word.name, @word.aliases}) | ((word == $nothing) ? "invalid" | ((word == $ambiguous_match) ? "ambiguous match" | "Error")), ")"), -widths[bit]), " "};
  endfor
  text = listappend(text, su:trimr(tostr(@output)));
endfor
text = listappend(text, l);
return text;
.

@verb #59:"set_property_value set_verb_or_property" this none this rx #2
@program #59:set_property_value
":set_property_value(object, property, value)";
" set_verb_or_property(same) -- similar to `verb_or_property'";
"  -- attempts to set <object>.<property> to <value>.  If there exists <object>:set_<property>, then it is called and its returned value is returned.  If not, we try to set the property directly; the result of this is returned.";
set_task_perms(caller_perms());
if (length(args) != 3)
  return E_ARGS;
elseif (typeof(o = args[1]) != OBJ)
  return E_INVARG;
elseif (!$recycler:valid(o))
  return E_INVIND;
elseif (typeof(p = args[2]) != STR)
  return E_INVARG;
elseif ($object_utils:has_callable_verb(o, v = "set_" + p))
  return o:(v)(args[3]);
else
  return o.(p) = args[3];
endif
.

@verb #59:"owns_task" this none this rxd #2
@program #59:owns_task
"$code_utils:owns_task(who, task_id)";
"The purpose of this is to be faster than $code_utils:task_owner(task_id) in those cases where you are interested in whether a certain person owns the task rather than in determining the owner of a task where you have no preconceived notion of the owner.";
return $list_utils:assoc(args[1], $wiz_utils:queued_tasks(args[2]));
.

@verb #59:"dflag_on" this none this rxd #2
@program #59:dflag_on
"Syntax:  $code_utils:dflag_on()   => 0|1";
"";
"Returns true if the verb calling the verb that called this verb has the `d' flag set true. Returns false if it is !d. If there aren't that many callers, or the calling verb was a builtin such as eval, assume the debug flag is on for traceback purposes and return true.";
"This is useful for determining whether the calling verb should return or raise an error to the verb that called it.";
return (length(c = callers()) >= 2) ? `index(verb_info(c[2][4], c[2][2])[2], "d") && 1 ! E_INVARG => 1' | 1;
.

"***finished***
