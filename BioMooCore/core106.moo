$Header: /repo/public.cvs/app/BioGate/BioMooCore/core106.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #106 with create
@create $thing named Generic HTTP/1.0 Port Listener:Generic HTTP/1.0 Port Listener,listener
@prop #106."handles_port" 8000 r
@prop #106."listening" 0 r
@prop #106."print_messages" 0 rc
@prop #106."timeout_msg" E_NONE rc
@prop #106."recycle_msg" E_NONE rc
@prop #106."boot_msg" E_NONE rc
@prop #106."redirect_from_msg" E_NONE rc
@prop #106."redirect_to_msg" E_NONE rc
@prop #106."create_msg" E_NONE rc
@prop #106."connect_msg" E_NONE rc
@prop #106."server_full_msg" {} rc
;;#106.("server_full_msg") = {"HTTP/1.0 503 Server too busy. Please try again in a few minutes."}
@prop #106."server_options" #106 rc
@prop #106."connect_timeout" 120 rc
@prop #106."authentication_method" "cookies" rc
;;#106.("aliases") = {"Generic HTTP/1.0 Port Listener", "listener"}
;;#106.("description") = {"  This object uses multiple port listen to check for HTTP/1.x", "connections. It accepts them, passes the accepted data to", "$http_handler:handle_http10, and returns the resulting information.", "Settings for this.authentication_method are one of:", "  webpass, web-authentication, cookies"}
;;#106.("object_size") = {9267, 937987203}

@verb #106:"do_login_command" this none this rx #95
@program #106:do_login_command
"do_login_command([args STR, ...]) -> 0";
"Accepts the first line from an HTTP connection, parses it to";
"determine the protocol version, and directs the transaction to the";
"appropriate verb on $http_handler";
"Performs appropriate connection entry updating on $network.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
net = $network;
login = $login;
if (callers())
  return E_PERM;
elseif (login:redlisted($string_utils:connection_hostname(connection_name(player))))
  notify(#2, tostr("<< REDLISTED >> ", connection_name(player), " port:", this.handles_port));
  boot_player(player);
  return 0;
elseif (player in net.open_connections)
  if (i = $list_utils:iassoc(player, net.connect_connections_to))
    what = net.connect_connections_to[i][2];
    net.connect_connections_to = listdelete(net.connect_connections_to, i);
    net.open_connections = setremove(net.open_connections, player);
    return 0;
  endif
endif
if ((0 && ($mcp:is_reading(player) == 1)) && $mcp:process_reading_line(player, argstr))
  "commented out until $mcp is installed";
  return 0;
endif
if (args && (stuff = match(argstr, "^%(GET%|POST%) /%([^ ]*%)%( HTTP/%(.*%)%)?")))
  method = substitute("%1", stuff);
  uri = substitute("%2", stuff);
  protocol = substitute("%4", stuff) || "0.9";
  if ((method == "GET") && (protocol[1] == "0"))
    "HTTP/0.9 can only handle method GET transactions.";
    handler = "handle_http09";
  elseif (protocol[1] == "1")
    handler = "handle_http10";
  else
    "this is a unrecognized call, but send it to $http_handler:handle_http10 and hope for the best";
    handler = "handle_http10";
  endif
  return $http_handler:(handler)(player, method, uri, protocol);
endif
"Last modified Sun Oct  6 01:44:37 1996 IST by EricM (#3264).";
.

@verb #106:"unlisten" this none this rxd #95
@program #106:unlisten
"unlisten() -> result INT or error STR";
"tells the listener to stop listening from it's port";
"returns the result of unlisten()";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
set_task_perms(caller_perms());
if (!(portspec = $list_utils:assoc(this, listeners())))
  this.listening = 0;
  return tostr(this:name(), " isn't listening to any port.");
endif
if ((result = unlisten(portspec[2])) == 0)
  this.listening = 0;
endif
return result;
"Last modified Sun Aug 25 16:41:25 1996 IDT by Gustavo (#2).";
.

@verb #106:"listen server_started" this none this rxd #95
@program #106:listen
"listen() -> canon_desc INT or error STR";
"tells the listener to start listening; returns result of listen() ";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (this.handles_port < 1)
  return E_INVARG;
endif
if (portspec = $list_utils:assoc(this, listeners()))
  result = tostr(this:name(), " is already listening on port ", portspec[2], ".");
else
  set_task_perms(caller_perms());
  try
    if (result = listen(this, this.handles_port, this.print_messages))
      this.listening = 1;
    endif
  except (E_PERM, E_QUOTA)
    result = tostr("Permission denied (try using `@set <port>.handles_port <number>' to set the port to a different number).");
  endtry
endif
return result;
"Last modified Wed Aug 21 18:19:55 1996 IDT by EricM (#3264).";
.

@verb #106:"init_for_core" this none this rx
@program #106:init_for_core
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((caller == this) || caller_perms().wizard)
  this.server_options = this;
  return pass(@args);
endif
"Last modified Wed Aug 21 00:35:54 1996 IDT by EricM (#3264).";
.

@verb #106:"@start*listening @stop*listening" none on this rd #95
@program #106:@startlistening
"Usage: @startlistening on <port handler>";
"       @stoplistening on <port handler>";
"Start or stop listening on port `<handler>.handles_port'";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!$perm_utils:controls((caller_perms() == #-1) ? player | caller_perms(), this))
  return player:tell(E_PERM);
endif
if (verb[1..5] == "@stop")
  if (typeof(result = this:unlisten()) == STR)
    player:tell(result);
  elseif (!result)
    player:tell("The MOO is no longer listening on port ", this.handles_port, ".");
  else
    player:tell("Unlisten attempt failed.");
  endif
else
  if (typeof(result = this:listen()) == STR)
    player:tell(result);
  elseif (result)
    player:tell("The MOO is now listening on port ", this.handles_port, ".");
  else
    player:tell("Listen command failed.");
  endif
endif
"Last modified Tue Jul  1 20:15:40 1997 IDT by EricM (#3264).";
.

@verb #106:"initialize" this none this rxd #95
@program #106:initialize
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || $perm_utils:controls(caller_perms(), this)))
  return E_PERM;
endif
this.server_options = this;
this.listening = 0;
set_task_perms(caller_perms());
return pass(@args);
"Last modified Fri Sep 27 16:30:54 1996 IST by EricM (#3264).";
.

@verb #106:"set_port" this none this rxd #95
@program #106:set_port
"set_port(port NUM) -> newport NUM";
"Sets the port at which the port listening device listens";
"Requires the caller perms to be wizardly, else E_PERM";
"Requires that the device not be currently listening to its old port, else E_PERM";
"Requires args[1] to be an integer, else E_INVARG";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
newport = args[1];
if (!caller_perms().wizard)
  return E_PERM;
elseif (typeof(newport) != NUM)
  return E_INVARG;
elseif (this.listening)
  return E_PERM;
endif
return this.handles_port = newport;
"Last modified Fri Sep 27 16:28:21 1996 IST by EricM (#3264).";
.

@verb #106:"@set-port" any on this rd #95
@program #106:@set-port
"Usage: @set-port <port number> on <port listener>";
"";
"Sets the port on which the port listener object will listen.  Only";
"wizards may set this.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!player.wizard)
  return player:tell(E_PERM);
elseif (!$string_utils:is_integer(dobjstr))
  return player:tell("The port specification you give must be an integer number.");
elseif (this.listening)
  return player:tell("You can't change the port setting on this device while it is actively listening at its old port.");
endif
newport = toint(dobjstr);
if (newport == this:set_port(newport))
  player:tell(this:name(1), " is now set to start listening on port ", newport, ".");
else
  player:tell("The port setting could not be set, possibly because some other device is listening to that port or because the server refuses to grant that port to the MOO.");
endif
"Last modified Fri Sep 27 16:26:15 1996 IST by EricM (#3264).";
.

"***finished***
