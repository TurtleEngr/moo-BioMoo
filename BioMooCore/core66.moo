$Header: /repo/public.cvs/app/BioGate/BioMooCore/core66.moo,v 1.1 2021/07/27 06:44:34 bruce Exp $

>@dump #66 with create
@create $generic_options named Edit Options:Edit Options
@prop #66."show_quiet_insert" {} rc
;;#66.("show_quiet_insert") = {"Report line numbers on insert or append.", "No echo on insert or append."}
@prop #66."show_eval_subs" {} rc
;;#66.("show_eval_subs") = {"Ignore .eval_subs when compiling verbs.", "Use .eval_subs when compiling verbs."}
@prop #66."show_local" {} rc
;;#66.("show_local") = {"Use in-MOO text editors.", "Ship text to client for local editing."}
@prop #66."show_no_parens" {} rc
;;#66.("show_no_parens") = {"include all parentheses when fetching verbs.", "includes only necessary parentheses when fetching verbs."}
;;#66.("names") = {"quiet_insert", "eval_subs", "local", "no_parens"}
;;#66.("_namelist") = "!quiet_insert!eval_subs!local!no_parens!parens!noisy_insert!"
;;#66.("extras") = {"parens", "noisy_insert"}
;;#66.("namewidth") = 20
;;#66.("aliases") = {"Edit Options"}
;;#66.("description") = "an option package in need of a description.  See `help $generic_option'..."
;;#66.("object_size") = {1832, 855068591}

@verb #66:"actual" this none this
@program #66:actual
if (i = args[1] in {"parens", "noisy_insert"})
  return {{{"no_parens", "quiet_insert"}[i], !args[2]}};
else
  return {args};
endif
.

@verb #66:"show" this none this
@program #66:show
if (o = (name = args[2]) in {"parens", "noisy_insert"})
  args[2] = {"no_parens", "quiet_insert"}[o];
  return {@pass(@args), tostr("(", name, " is a synonym for -", args[2], ")")};
else
  return pass(@args);
endif
.

"***finished***
