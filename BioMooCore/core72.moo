$Header: /repo/public.cvs/app/BioGate/BioMooCore/core72.moo,v 1.1 2021/07/27 06:44:34 bruce Exp $

>@dump #72 with create
@create $root_class named Network Utilities:Network Utilities
@prop #72."site" "hpsdce.mayfield.hp.com" r
@prop #72."large_domains" {} r
;;#72.("large_domains") = {"ac.uk", "edu.au", "com.au", "org.au", "co.uk", "ac.il", "bc.ca", "ab.ca", "co.il", "ac.il", "oz.au", "co.za", "ac.za"}
@prop #72."connect_connections_to" {} ""
@prop #72."postmaster" "web-support@hpsdce.mayfield.hp.com" rc
@prop #72."port" 8888 rc
@prop #72."MOO_name" "GOES" rc
@prop #72."valid_host_regexp" "^%([-_a-z0-9]+%.%)+%(gov%|edu%|com%|org%|int%|mil%|net%|%nato%|arpa%|[a-z][a-z]%)$" rc
@prop #72."maildrop" "localhost" rc
@prop #72."trusts" {} r
;;#72.("trusts") = {#36}
@prop #72."reply_address" "web-support@hpsdce.mayfield.hp.com" rc
@prop #72."active" 1 rc
@prop #72."valid_email_regexp" "^[-a-z0-9_!.%+$'=/]*[-a-z0-9_!%+$'=]$" rc
@prop #72."invalid_userids" {} rc
;;#72.("invalid_userids") = {"", "sysadmin", "root", "postmaster", "system", "operator", "bin"}
@prop #72."debugging" 0 rc
@prop #72."errors_to_address" "web-support@hpsdce.mayfield.hp.com" rc
@prop #72."suspicious_userids" {} rc
;;#72.("suspicious_userids") = {"", "sysadmin", "root", "postmaster", "bin", "SYSTEM", "OPERATOR", "guest", "me", "mailer-daemon", "webmaster", "sysop"}
@prop #72."usual_postmaster" "web-support@hpsdce.mayfield.hp.com" rc
@prop #72."password_postmaster" "web-support@hpsdce.mayfield.hp.com" rc
@prop #72."queued_mail" {} "" #36
@prop #72."queued_mail_task" 1213365816 r #36
@prop #72."envelope_from" "web-support@hpsdce.mayfield.hp.com" rc
@prop #72."blank_envelope" 0 rc
;;#72.("aliases") = {"Network Utilities"}
;;#72.("description") = {"Utilities for dealing with network connections", "---------------", "Creating & tracking hosts:", "", ":open(host, port [, connect-connection-to]) => connection", "    open a network connection (using open_network_connection).", "    If 'connect-connection-to' is a player object, the", "    connection will be connected to that object when it", "    gets the first line of input.", "", ":close(connection)", "     closes the connection & cleans up data", "", "------------------", "Parsing network things:", "", ":invalid_email_address(email)", "     return \"\" or string saying why 'email' is invalid.", "     uses .valid_email_regexp", "", ":invalid_hostname(host)", "     return \"\" or string saying why 'host' doesn't look", "     like a valid internet host name", "", ":local_domain(host)", "     returns the 'important' part of a host name, e.g.", "     golden.parc.xerox.com => parc.xerox.com", "", "-------------------", "Sending mail", "", ":sendmail(to, subject, @lines)", "     send mail to the email address 'to' with indicated subject.", "     header fields like 'from', 'date', etc. are filled in.", "     lines can start with additional header lines.", "", ":raw_sendmail(to, @lines)", "     used by :sendmail. Send mail to given user at host, just", "     as specified, no error checking.", "", "================================================================", "Parameters:", "", ".active If 0, disabled sending of mail.", "", ".site   Where does this MOO run?", "        (Maybe MOOnet will use it later).", "", ".port   The network port this MOO listens on.", "", ".large_domains ", "        A list of sites where more than 2 levels of host name are", "        significant, e.g., if you want 'parc.xerox.com' to be", "        different than 'cinops.xerox.com', put \"xerox.com\" as an", "        element in .large_domains.", "", ".postmaster", "        Email address to which problems with MOO mail should", "        go. This should be a real email address that someone reads.", "", ".maildrop", "        Hostname to connect to for dropping off mail. Usually can", "        just be \"localhost\".", "", ".reply_address", "        If a MOO character sends email, where does a reply go?", "        Inserted in 'From:' for mail from characters without", "        registration addresses.        ", "", ".trusts", "        List of (non-wizard) programmers who can call", "        :open, :sendmail, :close", "", "                "}
;;#72.("object_size") = {22359, 1577149627}

@verb #72:"parse_address" this none this
@program #72:parse_address
"Given an email address, return {userid, site}.";
"Valid addresses are of the form `userid[@site]'.";
"At least for now, if [@site] is left out, site will be returned as blank.";
"Should be a default address site, or something, somewhere.";
address = args[1];
return (at = index(address, "@")) ? {address[1..at - 1], address[at + 1..$]} | {address, ""};
.

@verb #72:"local_domain" this none this
@program #72:local_domain
"given a site, try to figure out what the `local' domain is.";
"if site has a @ or a % in it, give up and return E_INVARG.";
"blank site is returned as is; try this:local_domain(this.localhost) for the answer you probably want.";
site = args[1];
if (index(site, "@") || index(site, "%"))
  return E_INVARG;
elseif (match(site, "^[0-9.]+$"))
  return E_INVARG;
elseif (!site)
  return "";
elseif (!(dot = rindex(site, ".")))
  dot = rindex(site = this.site, ".");
endif
if ((!dot) || (!(dot = rindex(site[1..dot - 1], "."))))
  return site;
else
  domain = site[dot + 1..$];
  site = site[1..dot - 1];
  while (site && (domain in this.large_domains))
    if (dot = rindex(site, "."))
      domain = tostr(site[dot + 1..$], ".", domain);
      site = site[1..dot - 1];
    else
      return tostr(site, ".", domain);
    endif
  endwhile
  return domain;
endif
.

@verb #72:"open" this none this
@program #72:open
":open(address, port, [connect-connection-to])";
"Open a network connection to address/port.  If the connect-connection-to is passed, then the connection will be connected to that object when $login gets ahold of it.  If not, then the connection is just ignored by $login, i.e. not bothered by it with $welcome_message etc.";
"The object specified by connect-connection-to has to be a player (though it need not be a $player).";
"Returns the (initial) connection or an error, as in open_network_connection";
if (!this:trust(caller_perms()))
  return E_PERM;
endif
address = args[1];
port = args[2];
if (length(args) < 3)
  connect_to = $nothing;
elseif ((typeof(connect_to = args[3]) == OBJ) && (valid(connect_to) && is_player(connect_to)))
  if (!$perm_utils:controls(caller_perms(), connect_to))
    return E_PERM;
  endif
else
  return E_INVARG;
endif
if (typeof(connection = `open_network_connection(address, port) ! ANY') != ERR)
  if (valid(connect_to))
    this.connect_connections_to = {@this.connect_connections_to, {connection, connect_to}};
  endif
endif
return connection;
.

@verb #72:"close" this none this
@program #72:close
if (!this:trust(caller_perms()))
  return E_PERM;
endif
con = args[1];
if (!index(`connection_name(con) ! ANY => ""', " to "))
  return E_INVARG;
endif
boot_player(con);
if (i = $list_utils:iassoc(con, $network.connect_connections_to))
  $network.connect_connections_to = listdelete($network.connect_connections_to, i);
endif
return 1;
.

@verb #72:"sendmail" any none none rxd
@program #72:sendmail
"sendmail(to, subject, line1, line2, ...)";
"  sends mail to internet address 'to', with given subject.";
"  It fills in various fields, such as date, from (from player), etc.";
"  the rest of the arguments are remaining lines of the message, and may begin with additional header fields.";
"  (must match RFC822 specification).";
"Requires $network.trust to call (no anonymous mail from MOO).";
"Returns 0 if successful, or else error condition or string saying why not.";
if (!this:trust(caller_perms()))
  return E_PERM;
endif
mooname = this.MOO_name;
mooinfo = tostr(mooname, " (", this.site, " ", this.port, ")");
if (reason = this:invalid_email_address(to = args[1]))
  return reason;
endif
"took out Envelope-from:  + this.errors_to_address";
return this:raw_sendmail(to, "Date: " + ctime(), "From: " + this:return_address_for(player), "To: " + to, "Subject: " + args[2], "Errors-to: " + this.errors_to_address, "X-Mail-Agent: " + mooinfo, @args[3..$]);
.

@verb #72:"trust" this none this
@program #72:trust
return (who = args[1]).wizard || (who in this.trusts);
.

@verb #72:"init_for_core" this none this
@program #72:init_for_core
if (caller_perms().wizard)
  pass(@args);
  this.active = 0;
  this.reply_address = "moomailreplyto@yourhost";
  this.errors_to_address = "moomailerrors@yourhost";
  this.site = "yoursite";
  this.postmaster = "postmastername@yourhost";
  this.usual_postmaster = "postmastername@yourhost";
  this.password_postmaster = "postmastername@yourhost";
  this.envelope_from = "postmastername@yourhost";
  this.blank_envelope = 0;
  this.MOO_name = "YourMOO";
  this.maildrop = "localhost";
  this.port = 7777;
  this.large_domains = {};
  this.trusts = {$hacker};
  this.connect_connections_to = {};
endif
.

@verb #72:"raw_sendmail" any none none rxd
@program #72:raw_sendmail
"rawsendmail(to, @lines)";
"sends mail without processing. Returns 0 if successful, or else reason why not.";
if (!caller_perms().wizard)
  return E_PERM;
endif
if (!this.active)
  return "Networking is disabled.";
endif
if (typeof(this.debugging) == LIST)
  "who to notify";
  debugging = this.debugging;
else
  "notify this owner";
  debugging = this.debugging && {this.owner};
endif
address = args[1];
body = listdelete(args, 1);
data = {"HELO " + this.site, ("MAIL FROM:<" + this.envelope_from) + ">", ("RCPT TO:<" + address) + ">", "DATA"};
blank = 0;
for x in (body)
  this:suspend_if_needed(0);
  if (!(blank || match(x, "[a-z0-9-]*: ")))
    if (x)
      data = {@data, ""};
    endif
    blank = 1;
  endif
  data = {@data, (x == ".") ? "." + x | x};
endfor
data = {@data, ".", "QUIT", ""};
suspend(0);
target = $network:open(this.maildrop, 25);
if (typeof(target) == ERR)
  "special handling for when the maildrop declines connection -- Heathcliff 3/17/96";
  if (task_id() != this.queued_mail_task)
    this:add_queued_mail(@args);
    "we'll return as normal on the assumption the mail will go later";
    return;
  else
    return tostr("Cannot open connection to maildrop ", this.maildrop, ": ", target);
  endif
endif
fork (0)
  for line in (data)
    this:suspend_if_needed(0);
    while (!notify(target, line, 1))
      suspend(0);
    endwhile
    if (debugging)
      notify(debugging[1], "SEND:" + line);
    endif
  endfor
endfork
expect = {"2", "2", "2", "2", "3", "2"};
while (expect && (typeof(line = `read(target) ! ANY') != ERR))
  if (line)
    if (debugging)
      notify(debugging[1], "GET: " + line);
    endif
    if (!index("23", line[1]))
      $network:close(target);
      return line;
      "error return";
    else
      if (line[1] != expect[1])
        expect = {@expect, "2", "2", "2", "2", "2"};
      else
        expect = listdelete(expect, 1);
      endif
    endif
  endif
endwhile
$network:close(target);
return 0;
.

@verb #72:"invalid_email_address" this none this
@program #72:invalid_email_address
"invalid_email_address(email) -- check to see if email looks like a valid email address. Return reason why not.";
address = args[1];
if (!address)
  return "no email address supplied";
endif
if (!(at = rindex(address, "@")))
  return ("'" + address) + "' doesn't look like a valid internet email address";
endif
name = address[1..at - 1];
host = address[at + 1..$];
if (match(name, "^in%%") || match(name, "^smtp%%"))
  return tostr("'", name, "' doesn't look like a valid username (try removing the 'in%' or 'smtp%')");
endif
if (!match(host, $network.valid_host_regexp))
  return tostr("'", host, "' doesn't look like a valid internet host");
endif
if (!match(name, $network.valid_email_regexp))
  return tostr("'", name, "' doesn't look like a valid user name for internet mail");
endif
return "";
.

@verb #72:"invalid_hostname" this none this
@program #72:invalid_hostname
return match(args[1], this.valid_host_regexp) ? "" | tostr("'", args[1], "' doesn't look like a valid internet host name");
.

@verb #72:"email_will_fail" this none this
@program #72:email_will_fail
":email_will_fail(email-address[, display?]) => Makes sure the email-address is one that can actually be used by $network:sendmail().";
{email, ?display = 0} = args;
reason = this:invalid_email_address(email);
if (reason && display)
  player:tell("Invalid email address: ", reason);
endif
return reason;
"following is code from OpalMOO, not used here";
"Possible situations where the address would be unusable are when the address is invalid or we can't connect to the site to send mail.";
"If <display> is true, error messages are displayed to the player and 1 is returned when address is unuable.  If <display> is false and address is unusable, the error message is returned.  If the address is usable, 0 is always returned.";
if (!this:approved_for_network(caller_perms()))
  return E_PERM;
endif
if (!this:valid_email_address(email))
  msg = tostr("Your email address (", email, ") is not a usable account.");
elseif ((result = this:verify_email_address(email)) == E_INVARG)
  msg = tostr("Unable to connect to ", this:parse_address(email)[2], ".");
elseif (typeof(result) == STR)
  msg = tostr("The site ", (parse = this:parse_address(email))[2], " does not recognize ", parse[1], " as a valid account.");
else
  return 0;
endif
if (display)
  player:tell(msg);
  return 1;
else
  return msg;
endif
"Last modified Tue Jun 15 00:19:01 1993 EDT by Ranma (#200).";
.

@verb #72:"read" this none this
@program #72:read
"for trusted players, they can read from objects they own or open connections";
if (!this:trust(caller_perms()))
  return E_PERM;
elseif (valid(x = args[1]))
  if ((x.owner == x) || (x.owner != caller_perms()))
    return E_INVARG;
  endif
elseif (!this:is_outgoing_connection(x))
  return E_PERM;
endif
return `read(x) ! ANY';
.

@verb #72:"is_open" this none this rxd #36
@program #72:is_open
":is_open(object)";
"return true if the object is somehow connected, false otherwise.";
return typeof(`idle_seconds(@args) ! ANY') == INT;
"Relies on test in idle_seconds, and the error catching";
.

@verb #72:"incoming_connection" this none this
@program #72:incoming_connection
"Peer at an incoming connection.  Decide if it should be connected to something, return that object. If it should be ignored (outbound connection), return 1. Called only by #0:do_login_command";
if (caller != #0)
  return;
endif
what = args[1];
"this code for unix servers >= 1.7.5 only";
if (index(`connection_name(what) ! ANY => ""', " to "))
  "outbound connection";
  if (ct = $list_utils:assoc(what, this.connect_connections_to))
    this.connect_connections_to = setremove(this.connect_connections_to, ct);
    return ct[2];
  else
    return 1;
  endif
else
  return 0;
endif
.

@verb #72:"return_address_for" this none this
@program #72:return_address_for
":return_address_for(player) => string of 'return address'. Currently inbound mail doesn't work, so this is a bogus address.";
who = args[1];
if (valid(who) && is_player(who))
  return tostr(toint(who), "@", this.site, " (", who.name, ")");
else
  return tostr($login.registration_address, " (non-player ", who, ")");
endif
.

@verb #72:"server_started" this none this
@program #72:server_started
"called when restarting to clean out state.";
if (caller != #0)
  return E_PERM;
endif
this.connect_connections_to = {};
.

@verb #72:"is_outgoing_connection" this none this
@program #72:is_outgoing_connection
return index(`connection_name(args[1]) ! ANY => ""', " to ");
.

@verb #72:"notify" this none this
@program #72:notify
"for trusted players, they can write to connections";
if (!this:trust(caller_perms()))
  return E_PERM;
elseif (valid(x = args[1]))
  return E_INVARG;
elseif (!this:is_outgoing_connection(x))
  return E_PERM;
endif
return notify(x, args[2]);
.

@verb #72:"suspend_if_needed" this none this
@program #72:suspend_if_needed
"$command_utils:suspend_if_needed but chowned to player";
if ($command_utils:running_out_of_time())
  set_task_perms(caller_perms().wizard ? player | caller_perms());
  return $command_utils:suspend_if_needed(@args);
endif
.

@verb #72:"error" this none this
@program #72:error
":error(ERN, host, port) interpret open_network_connection(host, port) error";
{msg, host, port} = args;
if (msg == E_PERM)
  return "Networking not enabled in server, or else user doesn't have permission to call o_n_c();";
elseif (msg == E_INVARG)
  return tostr("The host/port ", toliteral(host), "/", toliteral(port), " is invalid or is not responding.");
elseif (msg == E_QUOTA)
  return tostr("The connection to ", toliteral(host), "/", toliteral(port), " cannot be made at this time.");
else
  return tostr("Unusual error: ", toliteral(msg));
endif
.

@verb #72:"help_msg" this none this rxd #36
@program #72:help_msg
"'cause this doesn't have a $_utils name";
return this:description();
.

@verb #72:"adjust_postmaster_for_password" this none this
@program #72:adjust_postmaster_for_password
"adjust_postmaster_for_password(enter_or_exit): permits the MOO to have two different postmasters for different kinds of bounces.  If entering password (argument \"enter\"), change to $network.password_postmaster, else (argument \"exit\") change to $network.usual_postmaster.";
if (args[1] == "enter")
  $network.postmaster = $network.password_postmaster;
  $network.errors_to_address = $network.password_postmaster;
  $network.envelope_from = $network.password_postmaster;
else
  $network.postmaster = $network.usual_postmaster;
  $network.errors_to_address = $network.usual_postmaster;
  $network.envelope_from = $network.blank_envelope ? "" | $network.usual_postmaster;
endif
.

@verb #72:"add_queued_mail" this none this rxd #36
@program #72:add_queued_mail
"$network:add_queued_mail( mail message )";
"  -- where `mail message' is in the same format as passed to :raw_sendmail";
if (caller == this)
  this.queued_mail = {@this.queued_mail, {time(), args}};
  if (!$code_utils:task_valid(this.queued_mail_task))
    fork fid (3600)
      this:send_queued_mail();
    endfork
    this.queued_mail_task = fid;
  endif
  return 1;
else
  return E_PERM;
endif
.

@verb #72:"send_queued_mail" this none this
@program #72:send_queued_mail
"$network:send_queued_mail()";
"  -- tries to send the mail stored in the .queued_mail property";
while (queued_mail = this.queued_mail)
  message = queued_mail[1];
  if (!this:raw_sendmail(@message[2]))
    this.queued_mail = setremove(this.queued_mail, message);
  else
    "wait an hour";
    suspend(3600);
  endif
endwhile
.

@verb #72:"do_batch" this none this rx #177
@program #72:do_batch
":do_batch (hostname, port, data)";
"";
"This verb opens a connection to [hostname, port] and sends the data set";
"to whatever is on the other side.  It then reads any returning input";
"and passes it back to the caller as a set of strings.";
if (!(hostname = tostr(args[1])))
  return E_INVARG;
elseif (!(port = tonum(args[2])))
  return E_INVARG;
elseif (typeof(data = args[3]) != LIST)
  data = {data};
endif
target = $network:open(hostname, port);
if (typeof(target) == ERR)
  return target;
endif
for line in (data)
  notify(target, line);
endfor
output = {};
while (typeof(line = read(target)) != ERR)
  output = {@output, line};
endwhile
$network:close(target);
return output;
.

"***finished***
