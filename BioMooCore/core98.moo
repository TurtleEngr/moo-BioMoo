$Header: /repo/public.cvs/app/BioGate/BioMooCore/core98.moo,v 1.1 2021/07/27 06:44:37 bruce Exp $

>@dump #98 with create
@create $thing named generic WWW application:generic WWW application,gwa,webapp,$webapp
@prop #98."code" "" "" #95
@prop #98."available" 0 rc
;;#98.("aliases") = {"generic WWW application", "gwa", "webapp", "$webapp"}
;;#98.("object_size") = {3455, 937987203}

@verb #98:"method_get" this none this rx #95
@program #98:method_get
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return {this:namec(1), "(Nothing available here.)"};
"Last modified Tue Apr 18 13:24:43 1995 IDT by Gustavo (#2).";
.

@verb #98:"available" this none this rxd #95
@program #98:available
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
"if this.available is a list, return true if 'player' is in the list";
return (typeof(available = this.available) == LIST) ? `args[1] ! E_RANGE => player' in available | available;
"Last modified Mon Feb 10 18:10:04 1997 IST by EricM (#3264).";
.

@verb #98:"set_code" this none this rx #95
@program #98:set_code
":set_code(application code). The application won't work without this.";
"returns E_PERM if you don't control it, E_INVARG if it's not a good code";
"no argument will cause the code to be cleared.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
elseif (!args)
  return clear_property(this, "code");
elseif (!match(args[1], "^%w+$"))
  return E_INVARG;
else
  code = args[1];
  apps = children(parent(this));
  i = 1;
  while ((i <= length(apps)) && ((apps[i].code != code) || (apps[i] == this)))
    i = i + 1;
  endwhile
  if (i > length(apps))
    return this.code = code;
  else
    return E_INVARG;
  endif
endif
"Last modified Sun Aug 28 10:36:31 1994 IST by Gustavo (#2).";
.

@verb #98:"get_code" this none this rx #95
@program #98:get_code
"note that this can optionally be protected, but is public by default.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return this.code;
"Last modified Thu Aug 15 02:38:51 1996 IDT by EricM (#3264).";
.

@verb #98:"method_post" this none this rx #95
@program #98:method_post
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return {this:namec(1), "(Nothing available here (post).)"};
"Last modified Tue Oct  1 03:50:23 1996 IST by EricM (#3264).";
.

"***finished***
