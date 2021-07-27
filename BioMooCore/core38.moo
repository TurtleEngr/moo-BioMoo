$Header: /repo/public.cvs/app/BioGate/BioMooCore/core38.moo,v 1.1 2021/07/27 06:44:31 bruce Exp $

>@dump #38 with create
@create $mail_recipient_class named Anonymous:Anonymous,Everyman,everyone,no_one,noone
;;#38.("mail_forward") = "Everyman ($no_one) can not receive mail."
;;#38.("email_address") = "$no_one"
;;#38.("last_disconnect_time") = 2147483647
;;#38.("help") = #86
;;#38.("page_echo_msg") = "... no one out there to see it."
;;#38.("last_connect_time") = 2147483647
;;#38.("ownership_quota") = -10000
;;#38.("home") = #-1
;;#38.("size_quota") = {0, 0, 938160000, 0}
;;#38.("web_options") = {"applinkdown", "showdest", {"viewer", #113}, "map"}
;;#38.("aliases") = {"Anonymous", "Everyman", "everyone", "no_one", "noone"}
;;#38.("description") = "The character used for \"safe\" evals."
;;#38.("object_size") = {5043, 855068591}
;;#38.("vrml_desc") = {"WWWInline {name \"http://hppsda.mayfield.hp.com/image/body.wrl\"}", ""}

@verb #38:"eval" this none this rxd #2
@program #38:eval
"eval(code)";
"Evaluate code with $no_one's permissions (so you won't damage anything).";
"If code does not begin with a semicolon, set this = caller (in the code to be evaluated) and return the value of the first `line' of code.  This means that subsequent lines will not be evaluated at all.";
"If code begins with a semicolon, set this = caller and let the code decide for itself when to return a value.  This is how to do multi-line evals.";
exp = args[1];
if (this:bad_eval(exp))
  return E_PERM;
endif
set_task_perms(this);
if (exp[1] != ";")
  return eval(tostr("this=", caller, "; return ", exp, ";"));
else
  return eval(tostr("this=", caller, ";", exp, ";"));
endif
.

@verb #38:"moveto" this none this
@program #38:moveto
return 0;
.

@verb #38:"eval_d" this none this rxd #2
@program #38:eval_d
":eval_d(code)";
"exactly like :eval except that the d flag is unset";
"Evaluate code with $no_one's permissions (so you won't damage anything).";
"If code does not begin with a semicolon, set this = caller (in the code to be evaluated) and return the value of the first `line' of code.  This means that subsequent lines will not be evaluated at all.";
"If code begins with a semicolon, set this = caller and let the code decide for itself when to return a value.  This is how to do multi-line evals.";
exp = args[1];
if (this:bad_eval(exp))
  return E_PERM;
endif
set_task_perms(this);
if (exp[1] != ";")
  return $code_utils:eval_d(tostr("this=", caller, "; return ", exp, ";"));
else
  return $code_utils:eval_d(tostr("this=", caller, ";", exp, ";"));
endif
.

@verb #38:"call_verb" this none this rxd #2
@program #38:call_verb
"call_verb(object, verb name, args)";
"Call verb with $no_one's permissions (so you won't damage anything).";
"One could do this with $no_one:eval, but ick.";
set_task_perms(this);
return args[1]:(args[2])(@args[3]);
.

@verb #38:"bad_eval" this none this rxd #2
@program #38:bad_eval
"Return 1 if this code will call fork, suspend, or eval.";
"At present it's overzealous---it should check for delimited uses of the above calls, in case someone has a variable called prevalent.";
exp = args[1];
if ((index(exp, "eval") || index(exp, "fork")) || index(exp, "suspend"))
  "Well, they had one of the evil words in here.  See if it was in a quoted string or not -- we want to permit player:tell(\"Gentlemen use forks.\")";
  for bad in ({"eval", "fork", "suspend"})
    l = index(exp, bad);
    if (l && (!$code_utils:inside_quotes(exp[1..l])))
      return 1;
    endif
  endfor
endif
return 0;
.

@verb #38:"set_*" this none this
@program #38:set_
if (!caller_perms().wizard)
  return E_PERM;
else
  return pass(@args);
endif
.

"***finished***
