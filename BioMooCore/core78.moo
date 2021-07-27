$Header: /repo/public.cvs/app/BioGate/BioMooCore/core78.moo,v 1.1 2021/07/27 06:44:35 bruce Exp $

>@dump #78 with create
@create $generic_db named Mail Name DB:Mail Name DB
;;#78.("aliases") = {"Mail Name DB"}
;;#78.("description") = "... for doing mail-recipient name lookups."
;;#78.("object_size") = {5626, 855068591}

@verb #78:"add" this none this
@program #78:add
":add(object,parent,name[,is_alias])";
"returns 1 if successful";
"        #o if #o already has that parent/name pair";
if (!(caller in {this, $mail_agent}))
  return E_PERM;
endif
{object, parent, name, ?is_alis = 0} = args;
pn = {parent, name};
if (oops = this:insert(tostr(parent, ":", name), object))
  if (oops[1] != object)
    return oops[1];
  endif
elseif (olist = this:insert(colon_name = ":" + name, {object}))
  "...there was already a list of objects for this name.";
  "...reinsert them.";
  this:insert(colon_name, setadd(olist[1], object));
endif
if (!(i = pn in object.names))
  object.names = is_alias ? {@object.names, pn} | {pn, @object.names};
  "...maybe fix capitalization...";
elseif (strcmp(object.names[i][2], name) != 0)
  object.names[i][2] = name;
endif
return 1;
.

@verb #78:"remove" this none this
@program #78:remove
":remove(object,parent,name)";
"removes {parent,name}.";
if (!(caller in {this, $mail_agent}))
  return E_PERM;
endif
{object, parent, name} = args;
object.names = setremove(object.names, {parent, name});
this:delete2(tostr(parent, ":", name), object);
if ($list_utils:assoc(name, object.names, 2))
  "...object still uses this name under other parents...";
elseif (others = this:delete2(colon_name = ":" + name, {object}))
  "...other objects still use this name...";
  this:insert(colon_name, setremove(others[1], object));
endif
.

@verb #78:"load" this none this rxd #2
@program #78:load
if (!caller_perms().wizard)
  return E_PERM;
endif
for m in ($object_utils:descendents($mail_recipient))
  for n in (m.names || {})
    if (typeof(n) != LIST)
      player:notify(tostr(o:mail_name(), "n=", n));
    elseif (o = this:add(m, @n))
    else
      player:notify(tostr(m:mail_name(), " ", n[1], ":", n[2], " ", o));
    endif
    $command_utils:suspend_if_needed(0);
  endfor
endfor
.

@verb #78:"init_for_core" this none this rxd #2
@program #78:init_for_core
if (caller_perms().wizard)
  pass();
  this:clearall();
  this:load();
endif
.

"***finished***
