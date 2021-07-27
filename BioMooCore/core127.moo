$Header: /repo/public.cvs/app/BioGate/BioMooCore/core127.moo,v 1.1 2021/07/27 06:44:28 bruce Exp $

>@dump #127 with create
@create $thing named generic external file handler:generic external file handler,gefh
;;#127.("aliases") = {"generic external file handler", "gefh"}
;;#127.("description") = "A file handler. Type 'help file_handler' for more information."
;;#127.("object_size") = {3687, 1577149628}

@verb #127:"allows" this none this rx #2
@program #127:allows
return $perm_utils:controls(args[1], this);
.

@verb #127:"write append" this none this rx #2
@program #127:write
args = $file_handler:fix_length(@args);
l = length(args);
if (l < 2)
  return E_ARGS;
elseif (!this:allows(caller_perms(), verb, @args))
  return E_PERM;
endif
path = tostr("handlers/", this);
name = args[1];
text = args[2];
limits = args[3..l];
if ($file_utils:free_quota(this.owner) > 0)
  oldsize = filesize(path, name);
  if (typeof(oldsize) != NUM)
    oldsize = 0;
  endif
  if (verb == "write")
    result = filewrite(path, name, text, @limits);
  elseif (verb == "append")
    result = fileappend(path, name, text);
  else
    result = E_VERBNF;
  endif
  newsize = filesize(path, name);
  if (typeof(newsize) != NUM)
    newsize = 0;
    this:remove_owned_file(name);
  else
    this:add_owned_file(name);
  endif
  if (typeof(result) != ERR)
    $file_utils:update_quota(this.owner, newsize - oldsize);
  endif
  return (result == 0) ? 1 | result;
else
  return E_QUOTA;
endif
.

@verb #127:"read length size exists files grep extract rename" this none this rx #2
@program #127:read
args = $file_handler:fix_length(@args);
if (!this:allows(caller_perms(), verb, @args))
  return E_PERM;
elseif (!args[1])
  return E_INVARG;
endif
path = "handlers/" + tostr(this);
if (verb == "read")
  return fileread(path, @args);
elseif (verb == "length")
  return filelength(path, @args);
elseif (verb == "size")
  return filesize(path, @args);
elseif (verb == "exists")
  return fileexists(path, @args);
elseif (verb == "files")
  return filelist(path, @args)[1];
elseif (verb == "grep")
  return filegrep(path, @args);
elseif (verb == "extract")
  return fileextract(path, @args);
else
  return E_VERBNF;
endif
.

@verb #127:"delete" this none this rx #2
@program #127:delete
args = $file_handler:fix_length(@args);
l = length(args);
if (!l)
  return E_ARGS;
elseif (!this:allows(caller_perms(), verb, @args))
  return E_PERM;
endif
path = "handlers/" + tostr(this);
name = args[1];
oldsize = filesize(path, name);
if (typeof(oldsize) != NUM)
  oldsize = 0;
endif
result = filedelete(path, name);
newsize = filesize(path, name);
if (typeof(newsize) != NUM)
  newsize = 0;
endif
if (typeof(result) != ERR)
  $file_utils:update_quota(this.owner, newsize - oldsize);
endif
return (result == 0) ? 1 | result;
.

@verb #127:"version error" this none this rx #2
@program #127:version
if (verb == "version")
  return fileversion();
elseif (verb == "error")
  return fileerror();
endif
.

@verb #127:"fix_length" this none this rx #2
@program #127:fix_length
for i in [1..length(args)]
  what = args[i];
  if ((typeof(what) == STR) && (length(what) > 1020))
    args[i] = what[1..1020];
  endif
endfor
return args;
.

"***finished***
