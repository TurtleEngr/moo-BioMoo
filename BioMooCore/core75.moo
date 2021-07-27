$Header: /repo/public.cvs/app/BioGate/BioMooCore/core75.moo,v 1.1 2021/07/27 06:44:35 bruce Exp $

>@dump #75 with create
@create $root_class named Gopher utilities:Gopher utilities
@prop #75."cache_requests" {} r
@prop #75."cache_times" {} r
@prop #75."cache_values" {} r
@prop #75."limit" 2000 rc
@prop #75."cache_timeout" 900 r
;;#75.("aliases") = {"Gopher utilities"}
;;#75.("description") = {"An interface to Gopher internet services.", "Copyright (c) 1992,1993 Grump,JoeFeedback@LambdaMOO.", "", "This object contains just the raw verbs for getting data from gopher servers and parsing the results. Look at #50122 (Generic Gopher Slate) on LambdaMOO for one example of a user interface. ", "", ":get(site, port, selection)", "  Get data from gopher server: returns a list of strings, or an error if it couldn't connect. Results are cached.", "", ":get_now(site, port, selection)", "  Used by $gopher:get. Arguments are the same: this actually gets the ", "  data without checking the cache. (Don't call this, since the", "  caching is important to reduce lag.)", "  ", ":show_text(who, start, end, site, port, selection)", "  Requires wiz-perms to call.", "  like who:notify_lines($gopher:get(..node..)[start..end])", "", ":clear_cache()", "  Erase the gopher cache.", "", ":parse(string)", "  Takes a directory line as returned by $gopher:get, and return a list", "  {host, port, selector, label}", "   host, port, and selector are what you send to :get.", "  label is a string, where the first character is the type code.", "", ":type(char)", "   returns the name of the gopher type indicated by the character, e.g.", "   $gopher:type(\"I\") => \"image\"", ""}
;;#75.("object_size") = {13232, 1577149627}

@verb #75:"get_now" this none this
@program #75:get_now
"Usage:  get_now(site, port, message)";
"Returns a list of strings, or an error if we couldn't connect.";
{host, port, message, ?extra = {0}} = args;
if (!this:trusted(caller_perms()))
  return E_PERM;
elseif ((!match(host, $network.valid_host_regexp)) && (!match(host, "[0-9]+%.[0-9]+%.[0-9]+%.[0-9]+")))
  "allow either welformed internet hosts or explicit IP addresses.";
  return E_INVARG;
elseif ((port < 100) && (!(port in {70, 80, 81, 79})))
  "disallow connections to low number ports; necessary?";
  return E_INVARG;
endif
opentime = time();
con = $network:open(host, port);
opentime = time() - opentime;
if (typeof(con) == ERR)
  return con;
endif
notify(con, message);
results = {};
count = this.limit;
"perhaps this isn't necessary, but if a gopher source is slowly spewing things, perhaps we don't want to hang forever -- perhaps this should just fork a process to close the connection instead?";
now = time();
timeout = 30;
end = "^%.$";
if (extra[1] == "2")
  end = "^[2-9]";
endif
while ((((typeof(string = `read(con) ! ANY') == STR) && (!match(string, end))) && ((count = count - 1) > 0)) && ((now + timeout) > (now = time())))
  if (string && (string[1] == "."))
    string = string[2..$];
  endif
  results = {@results, string};
endwhile
$network:close(con);
if (opentime > 0)
  "This is to keep repeated calls to $network:open to 'slow responding hosts' from totally spamming.";
  suspend(0);
endif
return results;
.

@verb #75:"parse" this none this
@program #75:parse
"parse gopher result line:";
"return {host, port, tag, label}";
"host/port/tag are what you send to the gopher server to get that line";
"label is <type>/human readable entry";
{string} = args;
tab = index(string, "	");
label = string[1..tab - 1];
string = string[tab + 1..$];
tab = index(string, "	");
tag = string[1..tab - 1];
string = string[tab + 1..$];
tab = index(string, "	");
host = string[1..tab - 1];
if (host[$] == ".")
  host = host[1..$ - 1];
endif
string = string[tab + 1..$];
tab = index(string, "	");
port = toint(tab ? string[1..tab - 1] | string);
return {host, port, tag, label};
"ignore extra material after port, if any";
.

@verb #75:"show_text" this none this
@program #75:show_text
"$gopher:show_text(who, start, end, ..node..)";
"like who:notify_lines($gopher:get(..node..)[start..end]), but pipelined";
if (!caller_perms().wizard)
  return E_PERM;
endif
{who, start, end, @args} = args;
con = $network:open(who, start);
if (typeof(con) == ERR)
  player:tell("Sorry, can't get this information now.");
  return;
endif
notify(con, end);
line = 0;
sent = 0;
end = end || this.limit;
while (((string = `read(con) ! ANY') != ".") && (typeof(string) == STR))
  line = line + 1;
  if ((line >= start) && ((!end) || (line <= end)))
    sent = sent + 1;
    if (valid(who))
      if (string && (string[1] == "."))
        string = string[2..$];
      endif
      who:notify(string);
    else
      notify(who, string);
    endif
  endif
endwhile
$network:close(con);
return sent;
.

@verb #75:"type" this none this
@program #75:type
type = args[1];
if (type == "1")
  return "menu";
elseif (type == "?")
  return "menu?";
elseif (type == "0")
  return "text";
elseif (type == "7")
  return "search";
elseif (type == "9")
  return "binary";
elseif (type == "2")
  return "phone directory";
elseif (type == "4")
  return "binhex";
elseif (type == "8")
  return "telnet";
elseif (type == "I")
  return "image";
elseif (type == " ")
  "not actually gopher protocol: used by 'goto'";
  return "";
else
  return "unknown";
endif
"not done, need to fill out";
.

@verb #75:"summary" this none this
@program #75:summary
"return a 'nice' string showing the information in a gopher node";
if (typeof(parse = args[1]) == STR)
  parse = this:parse(parse);
endif
if (parse[1] == "!")
  return {"[remembered set]", "", ""};
endif
if (length(parse) > 3)
  label = parse[4];
  if (label)
    type = $gopher:type(label[1]);
    label = label[2..$];
    if (type == "menu")
    elseif (type == "search")
      label = (("<" + parse[3][rindex(parse[3], "	") + 1..$]) + "> ") + label;
    else
      label = (type + ": ") + label;
    endif
  else
    label = "(top)";
  endif
else
  label = parse[3] + " (top)";
endif
port = "";
if (parse[2] != 70)
  port = tostr(" ", parse[2]);
endif
return {tostr("[", parse[1], port, "]"), label, parse[3]};
.

@verb #75:"get" this none this
@program #75:get
"Usage: get(site, port, selection)";
"returns a list of strings, or an error if it couldn't connect. Results are cached.";
request = args[1..3];
while ((index = request in this.cache_requests) && (this.cache_times[index] > time()))
  if (typeof(result = this.cache_values[index]) != INT)
    return result;
  endif
  if ($code_utils:task_valid(result))
    "spin, let other process getting same data win, or timeout";
    suspend(1);
  else
    "well, other process crashed, or terminated, or whatever.";
    this.cache_times[index] = 0;
  endif
endwhile
if (!this:trusted(caller_perms()))
  return E_PERM;
endif
while (this.cache_times && (this.cache_times[1] < time()))
  $command_utils:suspend_if_needed(0);
  this.cache_times = listdelete(this.cache_times, 1);
  this.cache_values = listdelete(this.cache_values, 1);
  this.cache_requests = listdelete(this.cache_requests, 1);
  "caution: don't want to suspend between test and removal";
endwhile
$command_utils:suspend_if_needed(0);
this:cache_entry(@request);
value = this:get_now(@args);
$command_utils:suspend_if_needed(0);
index = this:cache_entry(@request);
this.cache_times[index] = time() + ((typeof(value) == ERR) ? 120 | 1800);
this.cache_values[index] = value;
return value;
.

@verb #75:"clear_cache" this none this
@program #75:clear_cache
if (!this:trusted(caller_perms()))
  return E_PERM;
endif
if (!args)
  this.cache_values = this.cache_times = this.cache_requests = {};
elseif (index = args[1..3] in this.cache_requests)
  this.cache_requests = listdelete(this.cache_requests, index);
  this.cache_times = listdelete(this.cache_times, index);
  this.cache_values = listdelete(this.cache_values, index);
endif
.

@verb #75:"unparse" this none this
@program #75:unparse
"unparse(host, port, tag, label) => string";
{host, port, tag, label} = args;
if (tab = index(tag, "	"))
  "remove search terms from search nodes";
  tag = tag[1..tab - 1];
endif
return tostr(label, "	", tag, "	", host, "	", port);
.

@verb #75:"interpret_error" this none this
@program #75:interpret_error
"return an explanation for a 'false' $gopher:get result";
value = args[1];
if (value == E_INVARG)
  return "That gopher server is not reachable or is not responding.";
elseif (value == E_QUOTA)
  return "Gopher connections cannot be made at this time because of system resource limitations!";
elseif (typeof(value) == ERR)
  return tostr("The gopher request results in an error: ", value);
else
  return "The gopher request has no results.";
endif
.

@verb #75:"trusted" this none this
@program #75:trusted
"default -- gopher trusts everybody";
return 1;
.

@verb #75:"_textp" this none this
@program #75:_textp
"_textp(parsed node)";
"Return true iff the parsed info points to a text node.";
return index("02", args[1][4][1]);
.

@verb #75:"_mail_text" this none this
@program #75:_mail_text
"_mail_text(parsed node)";
"Return the text to be mailed out for the given node.";
where = args[1];
if (this:_textp(where))
  return $gopher:get(@where);
else
  text = {};
  for x in ($gopher:get(@where))
    parse = $gopher:parse(x);
    sel = parse[4];
    text = {@text, "Type=" + sel[1], "Name=" + sel[2..$], "Path=" + parse[3], "Host=" + parse[1], "Port=" + tostr(parse[2]), "#"};
  endfor
  return text;
endif
.

@verb #75:"init_for_core" this none this
@program #75:init_for_core
if (caller_perms().wizard)
  this:clear_cache();
  pass(@args);
endif
.

@verb #75:"display_cache" this none none rxd
@program #75:display_cache
"Just for debugging -- shows what's in the gopher cache";
req = this.cache_requests;
tim = this.cache_times;
val = this.cache_values;
"save values in case cache changes while printing";
player:tell("size -- expires -- host (port) ------ selector ------------");
for i in [1..length(req)]
  re = req[i];
  host = $string_utils:left(re[1] + ((re[2] == 70) ? "" | tostr(" (", re[2], ")")), 24);
  expires = $string_utils:right($time_utils:dhms(tim[i] - time()), 8);
  va = val[i];
  if (typeof(va) == LIST)
    va = length(va);
  elseif (typeof(va) == ERR)
    va = toliteral(va);
  else
    va = tostr(va);
  endif
  selector = re[3];
  if (length(selector) > 40)
    selector = "..." + selector[$ - 37..$];
  endif
  player:tell($string_utils:right(va, 8), expires, " ", host, selector);
endfor
player:tell("--- end cache display -------------------------------------");
.

@verb #75:"get_cache" this none this
@program #75:get_cache
"Usage: get_cache(site, port, selection)";
"return current cache";
request = args[1..3];
if (index = request in this.cache_requests)
  if (this.cache_times[index] > now)
    return this.cache_values[index];
  endif
endif
return 0;
.

@verb #75:"cache_entry" this none this
@program #75:cache_entry
if (index = args in this.cache_requests)
  return index;
else
  this.cache_times = {@this.cache_times, time() + 240};
  this.cache_values = {@this.cache_values, task_id()};
  this.cache_requests = {@this.cache_requests, args};
  return length(this.cache_requests);
endif
.

@verb #75:"help_msg" this none this
@program #75:help_msg
return this:description();
.

"***finished***
