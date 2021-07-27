$Header: /repo/public.cvs/app/BioGate/BioMooCore/core87.moo,v 1.1 2021/07/27 06:44:36 bruce Exp $

>@dump #87 with create
@create $root_class named FTP utilities:FTP utilities
@prop #87."trusted" 1 rc
@prop #87."port" 21 rc
@prop #87."connections" {} ""
;;#87.("aliases") = {"FTP utilities"}
;;#87.("object_size") = {9147, 1577149627}

@verb #87:"open" this none this
@program #87:open
if (!this:trusted(caller_perms()))
  return E_PERM;
endif
{host, ?user = "", ?pass = ""} = args;
if (typeof(conn = $network:open(host, this.port)) == ERR)
  return {"Unable to connect to host."};
endif
this.connections = {@this.connections, {conn, caller_perms(), {}, 0, {}}};
if (((!this:wait_for_response(conn)) || (user && (!this:do_command(conn, "USER " + user)))) || (pass && (!this:do_command(conn, "PASS " + pass))))
  messages = this:get_messages(conn);
  this.connections = listdelete(this.connections, $list_utils:iassoc(conn, this.connections));
  $network:close(conn);
  return messages;
endif
return conn;
.

@verb #87:"close" this none this
@program #87:close
conn = args[1];
if (!this:controls(caller_perms(), conn))
  return E_PERM;
endif
this:do_command(conn, "QUIT");
info = $list_utils:assoc(conn, this.connections);
this.connections = setremove(this.connections, info);
$network:close(conn);
if ($network:is_open(info[4]))
  $network:close(info[4]);
endif
return info[3];
.

@verb #87:"do_command" this none this
@program #87:do_command
{conn, cmd, ?nowait = 0} = args;
if (!this:controls(caller_perms(), conn))
  return E_PERM;
endif
$network:notify(conn, cmd);
return nowait ? 1 | this:wait_for_response(conn);
.

@verb #87:"wait_for_response" this none this
@program #87:wait_for_response
{conn, ?first_only = 0} = args;
if (!this:controls(caller_perms(), conn))
  return E_PERM;
endif
matchstr = first_only ? "^[1-9][0-9][0-9] " | "^[2-9][0-9][0-9] ";
messages = {};
result = "";
while ((typeof(result) == STR) && (!match(result, matchstr)))
  result = $network:read(conn);
  messages = {@messages, result};
endwhile
i = $list_utils:iassoc(conn, this.connections);
this.connections[i][3] = {@this.connections[i][3], @messages};
if (typeof(result) == STR)
  if (result[1] in {"4", "5"})
    player:tell(result);
    return E_NONE;
  else
    return 1;
  endif
else
  return result;
endif
.

@verb #87:"controls" this none this
@program #87:controls
return args[1].wizard || ({@$list_utils:assoc(args[2], this.connections), 0, 0}[2] == args[1]);
.

@verb #87:"get_messages" this none this
@program #87:get_messages
{conn, ?keep = 0} = args;
if (!this:controls(caller_perms(), conn))
  return E_PERM;
endif
i = $list_utils:iassoc(conn, this.connections);
messages = this.connections[i][3];
if (!keep)
  this.connections[i][3] = {};
endif
return messages;
.

@verb #87:"open_data" this none this
@program #87:open_data
conn = args[1];
if (!this:controls(caller_perms(), conn))
  return E_PERM;
endif
i = $list_utils:iassoc(conn, this.connections);
if (!$network:is_open(this.connections[i][4]))
  this:do_command(conn, "PASV");
  msg = (msg = this:get_messages(conn, 1))[$];
  if (msg[1..3] != "227")
    return E_TYPE;
  elseif (!(match = match(msg, "(%([0-9]+%),%([0-9]+%),%([0-9]+%),%([0-9]+%),%([0-9]+%),%([0-9]+%))")))
    return E_TYPE;
  elseif (typeof(dconn = $network:open(substitute("%1.%2.%3.%4", match), (toint(substitute("%5", match)) * 256) + toint(substitute("%6", match)))) == ERR)
    return dconn;
  else
    this.connections[i][4] = dconn;
  endif
  this.connections[i][5] = E_INVARG;
  set_task_perms(caller_perms());
  fork (0)
    this:listen(conn, dconn);
  endfork
endif
return 1;
.

@verb #87:"get_data" this none this
@program #87:get_data
{conn, ?nowait = 0} = args;
if (!this:controls(caller_perms(), conn))
  return E_PERM;
endif
i = $list_utils:iassoc(conn, this.connections);
while ((!nowait) && (this.connections[i][5] == E_INVARG))
  suspend(0);
endwhile
return this.connections[i][5];
.

@verb #87:"put_data" this none this
@program #87:put_data
{conn, data} = args;
if (!this:controls(caller_perms(), conn))
  return E_PERM;
endif
i = $list_utils:iassoc(conn, this.connections);
dconn = this.connections[i][4];
if (!$network:is_open(dconn))
  return E_INVARG;
else
  for line in (data)
    notify(dconn, line);
    $command_utils:suspend_if_needed(0);
  endfor
  this:close_data(conn);
  this.connections[i][4] = 0;
endif
.

@verb #87:"trusted" this none this
@program #87:trusted
return args[1].wizard || ((typeof(this.trusted) == LIST) ? args[1] in this.trusted | this.trusted);
.

@verb #87:"listen" this none this
@program #87:listen
if (caller != this)
  return E_PERM;
endif
{conn, dconn} = args;
data = {};
line = `read(dconn) ! ANY';
while (typeof(line) == STR)
  data = {@data, line};
  line = read(dconn);
  $command_utils:suspend_if_needed(0);
endwhile
if (i = $list_utils:iassoc(conn, this.connections))
  this.connections[i][5] = data;
endif
.

@verb #87:"close_data" this none this
@program #87:close_data
conn = args[1];
if (!this:controls(caller_perms(), conn))
  return E_PERM;
endif
if (!$network:is_open(dconn = $list_utils:assoc(conn, this.connections)[4]))
  return E_INVARG;
else
  $network:close(dconn);
  "...let the reading task come to terms with its abrupt superfluousness...";
  suspend(0);
  return 1;
endif
.

@verb #87:"get" this none this
@program #87:get
":get(host, username, password, filename)";
if (!this:trusted(caller_perms()))
  return E_PERM;
endif
if (typeof(conn = this:open(@args[1..3])) != OBJ)
  return E_NACC;
else
  result = (this:open_data(conn) && this:do_command(conn, "RETR " + args[4])) && this:get_data(conn);
  this:close(conn);
  return result;
endif
.

@verb #87:"init_for_core" this none this
@program #87:init_for_core
if (caller_perms().wizard)
  this.connections = {};
  this.trusted = 1;
  pass(@args);
endif
.

@verb #87:"put" this none this
@program #87:put
":put(host, username, password, filename, data)";
if (!this:trusted(caller_perms()))
  return E_PERM;
endif
if (typeof(conn = this:open(@args[1..3])) != OBJ)
  return E_NACC;
else
  result = (this:open_data(conn) && this:do_command(conn, "STOR " + args[4], 1)) && this:put_data(conn, args[5]);
  this:close(conn);
  return result;
endif
.

@verb #87:"data_connection" this none this
@program #87:data_connection
"return the data connection associated with the control connection args[1]";
conn = args[1];
i = $list_utils:iassoc(conn, this.connections);
return this.connections[i][4];
.

"***finished***
