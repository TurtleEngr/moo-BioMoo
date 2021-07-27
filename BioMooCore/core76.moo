$Header: /repo/public.cvs/app/BioGate/BioMooCore/core76.moo,v 1.1 2021/07/27 06:44:35 bruce Exp $

>@dump #76 with create
@create $generic_options named Programmer Options:Programmer Options
@prop #76."show_eval_time" {} rc
;;#76.("show_eval_time") = {"eval does not show ticks/seconds consumed.", "eval shows ticks/seconds consumed."}
@prop #76."show_list_all_parens" {} rc
;;#76.("show_list_all_parens") = {"@list shows only necessary parentheses by default", "@list shows all parentheses by default"}
@prop #76."show_list_no_numbers" {} rc
;;#76.("show_list_no_numbers") = {"@list gives line numbers by default", "@list omits line numbers by default"}
@prop #76."show_copy_expert" {} rc
;;#76.("show_copy_expert") = {"@copy prints warning message.", "@copy omits warning message."}
@prop #76."type_@prop_flags" {} rc
;;#76.("type_@prop_flags") = {2}
;;#76.("names") = {"list_all_parens", "list_no_numbers", "eval_time", "copy_expert", "verb_args", "@prop_flags"}
;;#76.("_namelist") = "!list_all_parens!list_no_numbers!eval_time!copy_expert!list_numbers!verb_args!@prop_flags!"
;;#76.("extras") = {"list_numbers"}
;;#76.("aliases") = {"Programmer Options"}
;;#76.("description") = {"Option package for $prog commands.  See `help @prog-options'."}
;;#76.("object_size") = {4674, 855068591}

@verb #76:"actual" this none this
@program #76:actual
if (i = args[1] in {"list_numbers"})
  return {{{"list_no_numbers"}[i], !args[2]}};
else
  return {args};
endif
.

@verb #76:"show" this none this
@program #76:show
if (o = (name = args[2]) in {"list_numbers"})
  args[2] = {"list_no_numbers"}[o];
  return {@pass(@args), tostr("(", name, " is a synonym for -", args[2], ")")};
else
  return pass(@args);
endif
.

@verb #76:"show_verb_args" this none this
@program #76:show_verb_args
if (value = this:get(@args))
  return {value, {tostr("Default args for @verb:  ", $string_utils:from_list(value, " "))}};
else
  return {0, {"Default args for @verb:  none none none"}};
endif
.

@verb #76:"check_verb_args" this none this
@program #76:check_verb_args
value = args[1];
if (typeof(value) != LIST)
  return "List expected";
elseif (length(value) != 3)
  return "List of length 3 expected";
elseif (!(value[1] in {"this", "none", "any"}))
  return tostr("Invalid dobj specification:  ", value[1]);
elseif (!((p = $code_utils:short_prep(value[2])) || (value[2] in {"none", "any"})))
  return tostr("Invalid preposition:  ", value[2]);
elseif (!(value[3] in {"this", "none", "any"}))
  return tostr("Invalid iobj specification:  ", value[3]);
else
  if (p)
    value[2] = p;
  endif
  return {value};
endif
.

@verb #76:"parse_verb_args" this none this
@program #76:parse_verb_args
{oname, raw} = args;
if (typeof(raw) == STR)
  raw = $string_utils:explode(raw, " ");
elseif (typeof(raw) == INT)
  return raw ? {oname, {"this", "none", "this"}} | {oname, 0};
endif
value = $code_utils:parse_argspec(@raw);
if (typeof(value) != LIST)
  return tostr(value);
elseif (value[2])
  return tostr("I don't understand \"", $string_utils:from_list(value[2], " "), "\"");
else
  value = {@value[1], "none", "none", "none"}[1..3];
  return {oname, (value == {"none", "none", "none"}) ? 0 | value};
endif
.

@verb #76:"show_@prop_flags" this none this
@program #76:show_@prop_flags
value = this:get(@args);
if (value)
  return {value, {tostr("Default permissions for @property=`", value, "'.")}};
else
  return {0, {"Default permissions for @property=`rc'."}};
endif
.

@verb #76:"check_@prop_flags" this none this rxd #2
@verb #76:"parse_@prop_flags" this none this rxd #2
@program #76:parse_@prop_flags
{oname, raw} = args;
if (typeof(raw) != STR)
  return "Must be a string composed of the characters `rwc'.";
endif
len = length(raw);
for x in [1..len]
  if (!(raw[x] in {"r", "w", "c"}))
    return "Must be a string composed of the characters `rwc'.";
  endif
endfor
return {oname, raw};
.

"***finished***
