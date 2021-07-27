$Header: /repo/public.cvs/app/BioGate/BioMooCore/core1.moo,v 1.1 2021/07/27 06:44:25 bruce Exp $

>@dump #1 with create
@create $nothing named Root Class:
@prop #1."key" 0 c
@prop #1."aliases" {} rc
@prop #1."description" "" rc
@prop #1."object_size" {} r #36
;;#1.("object_size") = {48635, 1577149621}
@prop #1."web_calls" 0 r #95
@prop #1."icon" "" r #95
@prop #1."url" "" r #95
@prop #1."web_settings" {} r #96
;;#1.("web_settings") = {{}, {}}
@prop #1."vrml_coords" {} r #96
;;#1.("vrml_coords") = {{0, 0, 0}, {0, 0, 0}, {1000, 1000, 1000}}
@prop #1."vrml_desc" {} rc
@prop #1."vrml_settings" {} r #96
;;#1.("vrml_settings") = {{}, {}}

@verb #1:"initialize" this none this
@program #1:initialize
if (typeof(this.owner.owned_objects) == LIST)
  this.owner.owned_objects = setadd(this.owner.owned_objects, this);
endif
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  if (is_clear_property(this, "object_size"))
    "If this isn't clear, then we're being hacked.";
    this.object_size = {0, 0};
  endif
  this.key = 0;
else
  return E_PERM;
endif
.

@verb #1:"recycle" this none this
@program #1:recycle
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  try
    if ((typeof(this.owner.owned_objects) == LIST) && (!is_clear_property(this.owner, "owned_objects")))
      this.owner.owned_objects = setremove(this.owner.owned_objects, this);
      $recycler.lost_souls = setadd($recycler.lost_souls, this);
    endif
  except (ANY)
    "Oy, doesn't have a .owned_objects??, or maybe .owner is $nothing";
    "Should probably do something...like send mail somewhere.";
  endtry
else
  return E_PERM;
endif
.

@verb #1:"set_name" this none this
@program #1:set_name
"set_name(newname) attempts to change this.name to newname";
"  => E_PERM   if you don't own this or aren't its parent, or are a player trying to do an end-run around $player_db...";
if ((!caller_perms().wizard) && (is_player(this) || ((caller_perms() != this.owner) && (this != caller))))
  return E_PERM;
else
  return (typeof(e = `this.name = args[1] ! ANY') != ERR) || e;
endif
.

@verb #1:"title name" this none this
@program #1:title
return this.name;
.

@verb #1:"titlec namec" this none this
@program #1:titlec
return $object_utils:has_property(this, "namec") ? this.namec | $string_utils:capitalize(this:title());
.

@verb #1:"set_aliases" this none this
@program #1:set_aliases
"set_aliases(alias_list) attempts to change this.aliases to alias_list";
"  => E_PERM   if you don't own this or aren't its parent";
"  => E_TYPE   if alias_list is not a list";
"  => E_INVARG if any element of alias_list is not a string";
"  => 1        if aliases are set exactly as expected (default)";
"  => 0        if aliases were set differently than expected";
"              (children with custom :set_aliases should be aware of this)";
if (!($perm_utils:controls(caller_perms(), this) || (this == caller)))
  return E_PERM;
elseif (typeof(aliases = args[1]) != LIST)
  return E_TYPE;
else
  for s in (aliases)
    if (typeof(s) != STR)
      return E_INVARG;
    endif
  endfor
  this.aliases = aliases;
  return 1;
endif
.

@verb #1:"match" this none this
@program #1:match
c = this:contents();
return $string_utils:match(args[1], c, "name", c, "aliases");
.

@verb #1:"match_object" this none this
@program #1:match_object
":match_object(string [,who])";
args[2..1] = {this};
return $string_utils:match_object(@args);
.

@verb #1:"set_description" this none this
@program #1:set_description
"set_description(newdesc) attempts to change this.description to newdesc";
"  => E_PERM   if you don't own this or aren't its parent";
if (!($perm_utils:controls(caller_perms(), this) || (this == caller)))
  return E_PERM;
elseif (typeof(desc = args[1]) in {LIST, STR})
  this.description = desc;
  return 1;
else
  return E_TYPE;
endif
.

@verb #1:"description" this none this
@program #1:description
return this.description;
.

@verb #1:"look_self" this none this
@program #1:look_self
desc = this:description();
if (desc)
  player:tell_lines(desc);
else
  player:tell("You see nothing special.");
endif
.

@verb #1:"notify" this none this
@program #1:notify
if (is_player(this))
  notify(this, args[1]);
endif
.

@verb #1:"tell" this none this
@program #1:tell
this:notify(tostr(@args));
.

@verb #1:"tell_lines" this none this
@program #1:tell_lines
lines = args[1];
if (typeof(lines) == LIST)
  for line in (lines)
    this:tell(line);
  endfor
else
  this:tell(lines);
endif
.

@verb #1:"accept" this none this
@program #1:accept
set_task_perms(caller_perms());
return this:acceptable(@args);
.

@verb #1:"moveto" this none this
@program #1:moveto
set_task_perms(this.owner);
return `move(this, args[1]) ! ANY';
.

@verb #1:"eject eject_nice eject_basic" this none this
@program #1:eject
"eject(victim) --- usable by the owner of this to remove victim from this.contents.  victim goes to its home if different from here, or $nothing or $player_start according as victim is a player.";
"eject_basic(victim) --- victim goes to $nothing or $player_start according as victim is a player; victim:moveto is not called.";
what = args[1];
nice = verb != "eject_basic";
perms = caller_perms();
if ((!perms.wizard) && (perms != this.owner))
  return E_PERM;
elseif ((!(what in this.contents)) || what.wizard)
  return 0;
endif
if ((((nice && $object_utils:has_property(what, "home")) && (typeof(where = what.home) == OBJ)) && (where != this)) && (is_player(what) ? `where:accept_for_abode(what) ! ANY' | `where:acceptable(what) ! ANY'))
  "where = what.home";
else
  where = is_player(what) ? $player_start | $nothing;
endif
if (nice)
  fork (0)
    "...Some objects like to know they've been moved...";
    "... this is the best we can do.  Remember :moveto() may be broken.";
    `what:moveto(where) ! ANY => 0';
  endfork
endif
return `move(what, where) ! ANY => 1';
.

@verb #1:"is_unlocked_for" this none this
@program #1:is_unlocked_for
return (this.key == 0) || $lock_utils:eval_key(this.key, args[1]);
.

@verb #1:"huh" this none this
@program #1:huh
set_task_perms((caller_perms() != #-1) ? caller_perms() | player);
$command_utils:do_huh(verb, args);
.

@verb #1:"set_message" this none this
@program #1:set_message
":set_message(msg_name,new_value)";
"Does the actual dirty work of @<msg_name> object is <new_value>";
"changing the raw value of the message msg_name to be new_value.";
"Both msg_name and new_value should be strings, though their interpretation is up to the object itself.";
" => error value (use E_PROPNF if msg_name isn't recognized)";
" => string error message if something else goes wrong.";
" => 1 (true non-string) if the message is successfully set";
" => 0 (false non-error) if the message is successfully `cleared'";
if (!((caller == this) || $perm_utils:controls(caller_perms(), this)))
  return E_PERM;
else
  return `this.(args[1] + "_msg") = args[2] ! ANY' && 1;
endif
.

@verb #1:"do_examine" this none this
@program #1:do_examine
"do_examine(examiner)";
"the guts of examine";
"call a series of verbs and report their return values to the player";
who = args[1];
"if (caller == this || caller == who)";
if (caller == who)
  "set_task_perms();";
  who:notify_lines(this:examine_names(who) || {});
  "this:examine_names(who);";
  who:notify_lines(this:examine_owner(who) || {});
  "this:examine_owner(who);";
  who:notify_lines(this:examine_desc(who) || {});
  "this:examine_desc(who);";
  who:notify_lines(this:examine_key(who) || {});
  "this:examine_key(who);";
  who:notify_lines(this:examine_contents(who) || {});
  who:notify_lines(this:examine_verbs(who) || {});
else
  return E_PERM;
endif
.

@verb #1:"examine_key" this none this
@program #1:examine_key
"examine_key(examiner)";
"return a list of strings to be told to the player, indicating what the key on this type of object means, and what this object's key is set to.";
"the default will only tell the key to a wizard or this object's owner.";
who = args[1];
if (((caller == this) && $perm_utils:controls(who, this)) && (this.key != 0))
  return {tostr("Key:  ", $lock_utils:unparse_key(this.key))};
endif
.

@verb #1:"examine_names" this none this
@program #1:examine_names
"examine_names(examiner)";
"Return a list of strings to be told to the player, indicating the name and aliases (and, by default, the object number) of this.";
return {tostr(this.name, " (aka ", $string_utils:english_list({tostr(this), @this.aliases}), ")")};
.

@verb #1:"examine_desc" this none this
@program #1:examine_desc
"examine_desc(who) - return the description, probably";
"who is the player examining";
"this should probably go away";
desc = this:description();
if (desc)
  if (typeof(desc) != LIST)
    desc = {desc};
  endif
  return desc;
else
  return {"(No description set.)"};
endif
.

@verb #1:"examine_contents" this none this
@program #1:examine_contents
"examine_contents(examiner)";
"by default, calls :tell_contents.";
"Should probably go away.";
who = args[1];
if (caller == this)
  try
    this:tell_contents(this.contents, this.ctype);
  except (ANY)
    "Just ignore it. We shouldn't care about the contents unless the object wants to tell us about them via :tell_contents ($container, $room)";
  endtry
endif
.

@verb #1:"examine_verbs" this none this
@program #1:examine_verbs
"Return a list of strings to be told to the player.  Standard format says \"Obvious verbs:\" followed by a series of lines explaining syntax for each usable verb.";
if (caller != this)
  return E_PERM;
endif
who = args[1];
name = dobjstr;
vrbs = {};
commands_ok = `this:examine_commands_ok(who) ! ANY => 0';
dull_classes = {$root_class, $room, $player, $prog, $builder};
what = this;
hidden_verbs = this:hidden_verbs(who);
while (what != $nothing)
  $command_utils:suspend_if_needed(0);
  if (!(what in dull_classes))
    for i in [1..length(verbs(what))]
      $command_utils:suspend_if_needed(0);
      info = verb_info(what, i);
      syntax = verb_args(what, i);
      if (this:examine_verb_ok(what, i, info, syntax, commands_ok, hidden_verbs))
        {dobj, prep, iobj} = syntax;
        if (syntax == {"any", "any", "any"})
          prep = "none";
        endif
        if (prep != "none")
          for x in ($string_utils:explode(prep, "/"))
            if (length(x) <= length(prep))
              prep = x;
            endif
          endfor
        endif
        "This is the correct way to handle verbs ending in *";
        vname = info[3];
        while (j = index(vname, "* "))
          vname = tostr(vname[1..j - 1], "<anything>", vname[j + 1..$]);
        endwhile
        if (vname[$] == "*")
          vname = vname[1..$ - 1] + "<anything>";
        endif
        vname = strsub(vname, " ", "/");
        rest = "";
        if (prep != "none")
          rest = " " + ((prep == "any") ? "<anything>" | prep);
          if (iobj != "none")
            rest = tostr(rest, " ", (iobj == "this") ? name | "<anything>");
          endif
        endif
        if (dobj != "none")
          rest = tostr(" ", (dobj == "this") ? name | "<anything>", rest);
        endif
        vrbs = setadd(vrbs, ("  " + vname) + rest);
      endif
    endfor
  endif
  what = parent(what);
endwhile
if ($code_utils:verb_or_property(this, "help_msg"))
  vrbs = {@vrbs, tostr("  help ", dobjstr)};
endif
return vrbs && {"Obvious verbs:", @vrbs};
.

@verb #1:"get_message" this none this
@program #1:get_message
":get_message(msg_name)";
"Use this to obtain a given user-customizable message's raw value, i.e., the value prior to any pronoun-substitution or incorporation of any variant elements --- the value one needs to supply to :set_message().";
"=> error (use E_PROPNF if msg_name isn't recognized)";
"=> string or list-of-strings raw value";
"=> {2, @(list of {msg_name_n,rawvalue_n} pairs to give to :set_message)}";
"=> {1, other kind of raw value}";
"=> {E_NONE, error message} ";
if (!((caller == this) || $perm_utils:controls(caller_perms(), this)))
  return E_PERM;
elseif (((t = typeof(msg = `this.(args[1] + "_msg") ! ANY')) in {ERR, STR}) || (((t == LIST) && msg) && (typeof(msg[1]) == STR)))
  return msg;
else
  return {1, msg};
endif
.

@verb #1:"room_announce*_all_but" this none this
@program #1:room_announce_all_but
try
  this.location:(verb)(@args);
except (ANY)
endtry
.

@verb #1:"init_for_core" this none this
@program #1:init_for_core
if (caller_perms().wizard)
  vnum = 1;
  while (vnum <= length(verbs(this)))
    $command_utils:suspend_if_needed(0);
    info = verb_info(this, vnum)[3];
    if (index(info, "(old)"))
      delete_verb(this, vnum);
    else
      vnum = vnum + 1;
    endif
  endwhile
  if (this == $root_class)
    set_verb_code(this, "initialize", verb_code(this, "initialize(core)"));
    delete_verb(this, "initialize(core)");
  endif
endif
.

@verb #1:"contents" this none this rxd #36
@program #1:contents
"Returns a list of the objects that are apparently inside this one.  Don't confuse this with .contents, which is a property kept consistent with .location by the server.  This verb should be used in `VR' situations, for instance when looking in a room, and does not necessarily have anything to do with the value of .contents (although the default implementation does).  `Non-VR' commands (like @contents) should look directly at .contents.";
return this.contents;
.

@verb #1:"examine_verb_ok" this none this
@program #1:examine_verb_ok
"examine_verb_ok(loc, index, info, syntax, commands_ok, hidden_verbs)";
"loc is the object that defines the verb; index is which verb on the object; info is verb_info; syntax is verb_args; commands_ok is determined by this:commands_ok, probably, but passed in so we don't have to calculate it for each verb.";
"hidden_verbs is passed in for the same reasons.  It should be a list, each of whose entries is either a string with the full verb name to be hidden (e.g., \"d*rop th*row\") or a list of the form {verb location, full verb name, args}.";
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  {loc, index, info, syntax, commands_ok, hidden_verbs} = args;
  vname = info[3];
  return (((((syntax[2..3] != {"none", "this"}) && (!index(vname, "("))) && (commands_ok || ("this" in syntax))) && `verb_code(loc, index) ! ANY') && (!(vname in hidden_verbs))) && (!({loc, vname, syntax} in hidden_verbs));
else
  return E_PERM;
endif
.

@verb #1:"is_listening" this none this
@program #1:is_listening
"return 1 if the object can hear a :tell, or cares. Useful for active objects that want to stop when nothing is listening.";
return 0;
.

@verb #1:"hidden_verbs" this none this
@program #1:hidden_verbs
"hidden_verbs(who)";
"returns a list of verbs on this that should be hidden from examine";
"the player who's examining is passed in, so objects can hide verbs from specific players";
"verbs are returned as {location, full_verb_name, args} or just full_verb_name.  full_verb name is what shows up in verb_info(object, verb)[2], for example \"d*op th*row\".";
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  hidden = {};
  what = this;
  while (what != $nothing)
    for i in [1..length(verbs(what))]
      info = verb_info(what, i);
      if (!index(info[2], "r"))
        hidden = setadd(hidden, {what, info[3], verb_args(what, i)});
      endif
    endfor
    what = parent(what);
  endwhile
  return hidden;
else
  return E_PERM;
endif
.

@verb #1:"examine_owner" this none this
@program #1:examine_owner
"examine_owner(examiner)";
"Return a list of strings to be told to the player, indicating who owns this.";
return {tostr("Owned by ", this.owner.name, ".")};
.

@verb #1:"announce*_all_but" this none this
@program #1:announce_all_but
return;
.

@verb #1:"tell_lines_suspended" this none this
@program #1:tell_lines_suspended
lines = args[1];
if (typeof(lines) == LIST)
  for line in (lines)
    this:tell(line);
    $command_utils:suspend_if_needed(0);
  endfor
else
  this:tell(lines);
endif
.

@verb #1:"acceptable" this none this
@program #1:acceptable
return 0;
"intended as a 'quiet' way to determine if :accept will succeed. Currently, some objects have a noisy :accept verb since it is the only thing that a builtin move() call is guaranteed to call.";
"if you want to tell, before trying, whether :accept will fail, use :acceptable instead. Normally, they'll do the same thing.";
.

@verb #1:"html do_post" this none this rx #95
@program #1:html
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (typeof(html = this:url()) == STR)
  html = $web_utils:build_MIME(html);
endif
html = listappend(html, "");
desc = (desc = this:description()) ? desc | {"You see nothing special."};
desc = (typeof(desc) == LIST) ? desc | {desc};
"make sure the angle brackets in text are preserved";
desc = $web_utils:html_entity_sub(desc);
"";
if (this:get_web_setting("preformatted"))
  desc = {"<BR CLEAR=\"RIGHT\"><PRE>", @desc, "</PRE>"};
else
  "This is a test, to see if it improves the look of the web descriptions.";
  desc = $web_utils:add_linebreaks(desc);
endif
"";
dobjstr = dobjstr || this:name(1);
return {@html, @desc, @this:more_info_for_web(@args), @this:verbs_for_web(@args)};
"Last modified Sat Aug 10 20:26:58 1996 IDT by EricM (#3264).";
.

@verb #1:"more_info_for_web" this none this rx #95
@program #1:more_info_for_web
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return {};
"Last modified Sat Oct  1 20:39:45 1994 IST by Gustavo (#2).";
.

@verb #1:"verbs_for_web" this none this rx #95
@program #1:verbs_for_web
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return {};
"Return a list of strings to be told to the player.  Standard format says \"Obvious verbs:\" followed by a series of lines explaining syntax for each usable verb.";
if ((caller != this) && (!$perm_utils:controls(caller_perms(), this)))
  return E_PERM;
endif
who = args[1];
name = dobjstr;
vrbs = {};
commands_ok = this:examine_commands_ok(who);
dull_classes = {$root_class, $room, $player, $prog, $builder};
what = this;
hidden_verbs = this:hidden_verbs(who);
while (what != $nothing)
  $command_utils:suspend_if_needed(0);
  if (!(what in dull_classes))
    for i in [1..length(verbs(what))]
      $command_utils:suspend_if_needed(0);
      info = verb_info(what, i);
      syntax = verb_args(what, i);
      if (this:verb_ok_for_web(what, i, info, syntax, commands_ok, hidden_verbs))
        dobj = syntax[1];
        prep = syntax[2];
        iobj = syntax[3];
        if (syntax == {"any", "any", "any"})
          prep = "none";
        endif
        if (prep != "none")
          for x in ($string_utils:explode(prep, "/"))
            if (length(x) <= length(prep))
              prep = x;
            endif
          endfor
        endif
        "This is the correct way to handle verbs ending in *";
        vname = info[3];
        while (i = index(vname, "* "))
          vname = tostr(vname[1..i - 1], "<anything>", vname[i + 1..length(vname)]);
        endwhile
        if (vname[i = length(vname)] == "*")
          vname = vname[1..i - 1] + "<anything>";
        endif
        vname = strsub(vname, " ", "/");
        rest = "";
        if (prep != "none")
          rest = " " + ((prep == "any") ? "<anything>" | prep);
          if (iobj != "none")
            rest = tostr(rest, " ", (iobj == "this") ? name | "<anything>");
          endif
        endif
        if (dobj != "none")
          rest = tostr(" ", (dobj == "this") ? name | "<anything>", rest);
        endif
        if (p = index(vname, "/"))
          vname = vname[1..p - 1];
        endif
        vname = strsub(vname, "*", "");
        vname = tostr("<A HREF=\"&LOCAL_LINK;/", "view", "/", tonum(this), "/", vname, "\">", vname, "</A>");
        vrbs = setadd(vrbs, tostr("  ", vname, rest, "<BR>"));
      endif
    endfor
  endif
  what = parent(what);
endwhile
if ($code_utils:verb_or_property(this, "help_msg"))
  vrbs = {@vrbs, tostr("  help ", dobjstr)};
endif
return vrbs && {"<P><B>Actions:</B><BR>", @vrbs};
"Last modified Thu Aug 15 07:59:22 1996 IDT by EricM (#3264).";
.

@verb #1:"object_edit_for_web" this none this rx #95
@program #1:object_edit_for_web
"object_edit_for_web(what OBJ) -> LIST";
"";
"Form field names: objname, objaliases, objdesc, objarttype, isURL, objURL, objHTML";
"  change_name, change_aliases, change_arttype, change_url, change_message";
"  change_lock, objlock";
"";
"  This verb returns an HTML form that can be used to edit the 'basic' properties of";
"the object. Basic properties are ones that commonly need to be or should be customized";
"by the object's owner using commands defined on the object.  Properties set with @set";
"are handled by the object web-editor 'edit advanced characteristics' option.";
"  Start your verb with the permissions test used below. The caller must be either 'this'";
"or the $object_browser";
"  The first thing in the returned HTML document should be <HR><HR> followed by something";
"like '<H3> Characteristics for (something)s: (object name and number></H3>' and then";
"a form header with METHOD=POST and ACTION=";
"   <A HREF=&LOCAL_LINK;/,$web_utils:get_webcode(),/,tonum(what),/,$code_utils:verb_location(),>";
"Note that 'what' is the object being edited, and 'rest' is the generic this form is for";
"  The (something) describes the essential nature of the object, and is generally derived";
"from it's name.  For example, the $note adds 'Characteristics for Notes:....' to indicate";
"that this form (i.e. this section of the web page the user sees) is for editing things";
"associated with the fact that the object is a $note (eg. the 'text' of the note).";
"  The line that immediately follows MUST be the SUBMIT and RESET buttons for the";
"form, so the user properly associates those buttons with the section's title immediately";
"above them.";
"  The rest of the verb builds the body of the form itself.  This is usually done by";
"starting with 'form={}' and adding lines 'form={@form,<more text>};', etc.";
"The only other item you must include somewhere in the form is a hidden tag:";
"    <INPUT TYPE=\"HIDDEN\" NAME=\"action\" VALUE=\"do_edit_object\">";
"  Finally, the verb should end with 'return {@form, @pass(@args)}' where 'form' is the";
"form built up by the verb.";
"  Note that you must add a verb named 'edit_object_by_web' to your object, which will";
"receive, interpret, and act on the form data.  See 'help #1:edit_object_by_web' for";
"details of how to correctly write that verb.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!(caller in {this, $object_browser}))
  return E_PERM;
endif
set_task_perms(who = caller_perms());
what = args[1];
form = {tostr("<A NAME=\"BasicTop\"><H3>Common Characteristics for: ", what:namec(1), " (", tostr(what), ")</H3></A>")};
form = {@form, tostr("<FORM METHOD=POST ACTION=\"&LOCAL_LINK;/", $object_browser:get_code(), "/", tonum(what), "/", tonum($code_utils:verb_location()), "\">")};
form = {@form, "<INPUT TYPE=\"SUBMIT\" VALUE=\"Update Common Characteristics\"><INPUT TYPE=\"RESET\" VALUE=\"Clear changes to this section\"><P>"};
form = {@form, "<INPUT TYPE=\"HIDDEN\" NAME=\"action\" VALUE=\"do_edit_object\">"};
form = {@form, "To use this section of the page, edit the fields associated with the characteristics you wish to change, <STRONG>mark the checkbox to the left of any changed characteristic's names to indicate that you've edited them</STRONG>, and submit the form by selecting the Update Common Characteristics button.<P>"};
form = {@form, tostr("Jump in this section to: [ <A HREF=\"#msged\">messages</A> | <A HREF=\"#htmled\">URL/HTML</A> ]<P>")};
form = {@form, tostr("<INPUT TYPE=\"CHECKBOX\" NAME=\"change_name\"><B>Name:</B> ", ("<INPUT NAME=\"objname\" SIZE=35 VALUE=\"" + what.name) + "\">") + "<BR>"};
if (length(what.aliases) == 1)
  aliases = what.aliases[1];
elseif (length(what.aliases) == 2)
  aliases = (what.aliases[1] + ", ") + what.aliases[2];
else
  aliases = $string_utils:english_list(what.aliases, " none ", " ");
endif
form = {@form, tostr("<INPUT TYPE=\"CHECKBOX\" NAME=\"change_aliases\"><B>Aliases:</B> ", tostr("<INPUT NAME=\"objaliases\" SIZE=67 VALUE=\"", aliases, "\"><P>"))};
form = {@form, "<INPUT TYPE=\"CHECKBOX\" NAME=\"change_desc\"><B>Description: </B><BR>"};
desc = (typeof(d = what.description) == STR) ? {d} | d;
form = {@form, "<BR><TEXTAREA NAME=\"objdesc\" ROWS=10 COLS=69>", @desc, "</TEXTAREA><P><HR>"};
"";
if (typeof(what.art_type) != ERR)
  "NOTE: The next line (art_type) only applys if the BioMOO grammar system is installed";
  form = {@form, tostr("<INPUT TYPE=\"CHECKBOX\" NAME=\"change_arttype\"><B>Object's article type:</B> <INPUT TYPE=\"RADIO\" NAME=\"objarttype\" VALUE=\"1\" ", (what.art_type == 1) ? "CHECKED" | "", ">Normal (\"an object\", \"the object\") <INPUT TYPE=\"RADIO\" NAME=\"objarttype\" VALUE=\"0\" ", (what.art_type == 0) ? "CHECKED" | "", ">None (\"object\") <INPUT TYPE=\"RADIO\" NAME=\"objarttype\" VALUE=\"2\" ", (what.art_type == 2) ? "CHECKED" | "", ">Owned (\"Jane's object\")<BR>")};
endif
"-- is object locked and to what";
if (what.key == 0)
  lock = 0;
elseif (what.key == what.location)
  lock = 1;
else
  lock = 2;
endif
form = {@form, tostr("<INPUT TYPE=\"CHECKBOX\" NAME=\"change_lock\"><B>Object</B> <INPUT TYPE=\"RADIO\" NAME=\"objlock\" VALUE=\"0\"", (!lock) ? " CHECKED" | "", ">is unlocked <INPUT TYPE=\"RADIO\" NAME=\"objlock\" VALUE=\"", tostr(what.location), "\"", (lock == 1) ? " CHECKED" | "", ">is locked to its current location", (lock == 2) ? "<B> ** is locked and has a specially set key expression</B>" | "")};
"-- object messages section";
form = {@form, "<A NAME=\"msged\"></A>"};
if (props = $object_utils:owned_properties(what, who.wizard ? what.owner | who))
  prop_fields = {};
  for prop in (props)
    if ((4 < (len = length(prop))) && (prop[len - 3..len] == "_msg"))
      if (typeof(what.(prop)) != STR)
        "doesn't support type LIST yet";
      else
        prop_fields = {@prop_fields, tostr("<LI><INPUT TYPE=\"CHECKBOX\" NAME=\"change_message\"> ", prop[1..len - 4], " <INPUT NAME=\"", prop, "\" SIZE=55 VALUE=\"", what.(prop), "\">")};
      endif
    endif
  endfor
  if (prop_fields)
    form = {@form, "<P><B>Object's messages</B> (the \"%\" indicates <A HREF=\"&LOCAL_LINK;/objbrowser/objbrowser/help_pronouns/\">pronoun substitutions</A>):<UL>", @prop_fields, "</UL>"};
  endif
endif
form = {@form, "<A NAME=\"htmled\"><HR></A>"};
form = {@form, ("<INPUT TYPE=\"CHECKBOX\" NAME=\"change_icon\"><B>Object's associated icon URL</B><INPUT NAME=\"objicon\" SIZE=50 VALUE=\"" + what:get_icon()) + "\"><P>"};
form = {@form, "<INPUT TYPE=\"CHECKBOX\" NAME=\"change_url\"><B>Object's associated URL or HTML document</B><P>"};
if (typeof(url = what:get_url()) == STR)
  form = {@form, ("<INPUT TYPE=\"RADIO\" NAME=\"isURL\" VALUE=\"url\" CHECKED><B>URL:</B> <INPUT NAME=\"objURL\" SIZE=60 VALUE=\"" + url) + "\">", "<P>"};
  form = {@form, "<INPUT TYPE=\"RADIO\" NAME=\"isURL\" VALUE=\"html\"><B>HTML Document:</B>"};
  form = {@form, "<BR><TEXTAREA NAME=\"objHTML\" ROWS=10 COLS=69></TEXTAREA><P>"};
else
  form = {@form, "<INPUT TYPE=\"RADIO\" SIZE=60 VALUE=\"url\" NAME=\"isURL\"><B>URL:</B><INPUT NAME=\"objURL\" SIZE=60><P>"};
  form = {@form, "<INPUT TYPE=\"RADIO\" NAME=\"isURL\" VALUE=\"html\" CHECKED><B>HTML Document:</B>"};
  form = {@form, tostr("<BR><TEXTAREA NAME=\"objHTML\" ROWS=10 COLS=69>", @url, "</TEXTAREA><P>")};
endif
form = {@form, "<BR><A HREF=\"#BasicTop\">Go to top of Basic Characteristics section</A>"};
form = {@form, "</FORM>"};
return {"BasicTop", form};
"Last modified Mon Aug 26 17:48:46 1996 IDT by EricM (#3264).";
.

@verb #1:"edit_object_by_web" this none this rxd #95
@program #1:edit_object_by_web
"edit_object_by_web(what OBJ, field_names LIST, field_values LIST) -> 0=no change, 1=updated, STR=error";
"where 'what' is the object to be edited, and field_names and field_values are linked lists";
"derived from the form data";
"  field_names={name1,name2....}, field_values={value1,value2....}";
"";
"Form field names: objname, objaliases, objdesc, objarttype, isURL, objURL, objHTML";
"    change_name, change_aliases, change_arttype, change_url, change_message";
"    change_lock, objlock, change_icon, objicon";
"";
"  This verb performs object editing for web calls with the appropriate perms.";
"  Otherwise, this verb analyzes the form data, and determines if any changes";
"have been requested.  If none are requested, it should return the value of 'result'";
"(the value passed back to it from pass(@args)).  Otherwise, it should perform the";
"changes requested, and return a value of one.";
"Return values: a string = an error message of some sort";
"               0 = no error, and no changes made";
"               1 = no error, and changes to the object were made";
"  Basically, it just checks the form data for each of the fields it can recognize";
"and makes the appropriate changes specified.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
perms = caller_perms();
if ((caller != $object_browser) && (!$perm_utils:controls(perms, $code_utils:verb_perms())))
  "Accept calls only from $object_browser and the owner of the the person who wrote this (usually the owner of the generic object it's defined on).";
  return E_PERM;
elseif (!$perm_utils:controls(perms, what))
  return "Sorry, only this object's owner can edit it.";
endif
set_task_perms(perms);
field_names = args[2];
field_values = args[3];
changed = 0;
if (("change_name" in field_names) && (what.name != (objname = field_values["objname" in field_names])))
  what:set_name(objname);
  changed = 1;
endif
if ("change_aliases" in field_names)
  objaliases = field_values["objaliases" in field_names];
  objaliases = $string_utils:explode(objaliases, ",");
  objaliases = $list_utils:map_arg($string_utils, "trim", objaliases);
  if (objaliases != what.aliases)
    what:set_aliases(objaliases);
    changed = 1;
  endif
endif
if (("change_desc" in field_names) && (what.description != (objdesc = field_values["objdesc" in field_names])))
  what:set_description(objdesc);
  changed = 1;
endif
if (("change_arttype" in field_names) && (what.art_type != (objarttype = tonum(field_values["objarttype" in field_names]))))
  what.art_type = objarttype;
  changed = 1;
endif
if ("change_icon" in field_names)
  objicon = field_values["objicon" in field_names];
  what:set_icon(objicon);
  changed = 1;
endif
if ("change_url" in field_names)
  isURL = field_values["isURL" in field_names];
  if (isURL == "url")
    objURL = field_values["objURL" in field_names];
    if (what:url() != objURL)
      what:set_url(objURL);
      changed = 1;
    endif
  else
    "it's an HTML doc";
    objHTML = field_values["objHTML" in field_names];
    if (what:url() != objHTML)
      objHTML = (typeof(objHTML) == LIST) ? objHTML | {objHTML};
      what:set_url(objHTML);
      changed = 1;
    endif
  endif
endif
if ("change_lock" in field_names)
  objlock = field_values["objlock" in field_names];
  what.key = (objlock == "0") ? 0 | toobj(objlock);
  changed = 1;
endif
if ("change_message" in field_names)
  for name in (field_names)
    if (((4 < (len = length(name))) && (name[len - 3..len] == "_msg")) && (what.(name) != (new_msg = field_values[name in field_names])))
      "next line depends on verb being !d";
      if (parent(what).(name) == new_msg)
        clear_property(what, name);
      else
        what.(name) = new_msg;
      endif
      changed = 1;
    endif
  endfor
endif
return changed;
"Last modified Thu Aug 15 09:13:05 1996 IDT by EricM (#3264).";
.

@verb #1:"set_icon" this none this rx #95
@program #1:set_icon
"set_icon(url) -> url";
"sets the url for the object's icon";
"note that setting it to an empty string clears the property, while setting";
"it to zero, for instance, means 'return no icon'";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
elseif (!args)
  return E_ARGS;
elseif (args[1] == "")
  clear_property(this, "icon");
else
  this.icon = args[1];
endif
return this.icon;
"Last modified Sun Nov  5 22:31:03 1995 IST by EricM (#3264).";
.

@verb #1:"get_icon" this none this rx #95
@program #1:get_icon
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return this.icon || "";
"Last modified Sun Nov  5 22:31:34 1995 IST by EricM (#3264).";
.

@verb #1:"get_url get_html" this none this rx #95
@program #1:get_url
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return this:url();
"Last modified Wed Oct  5 09:34:42 1994 IST by Gustavo (#2).";
.

@verb #1:"url" this none this rx #95
@program #1:url
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (caller != this)
  return E_PERM;
elseif (args)
  if (args[1] == "")
    clear_property(this, "url");
  else
    this.url = args[1];
  endif
  return this.url;
else
  return this.url || "";
endif
"Last modified Sun Nov  5 22:36:39 1995 IST by EricM (#3264).";
.

@verb #1:"set_url set_html" this none this rx #95
@program #1:set_url
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif
return this:url(args[1]);
"Last modified Wed Oct  5 09:34:42 1994 IST by Gustavo (#2).";
.

@verb #1:"has_url really_has_url" this none this rx #95
@program #1:has_url
"Takes no args and returns a boolean value.";
"has_url() - Returns true if the object has any info associated with it that";
"gets displayed for a web call, even just a description.  This is used when";
"creating hyperlinked object name lists, to indicate the name of this object";
"should by hyperlinked since if the person selects it,they'll see something.";
"Objects without even a description (ie. all the really have is a name), shouldn't";
"be hyperlinked.";
"really_has_url() - There is a URL address or HTML document associated with the object";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return (!(!this:url())) || ((verb == "has_url") && (!(!this.description)));
"Last modified Thu Aug 15 07:25:19 1996 IDT by EricM (#3264).";
.

@verb #1:"tell_contents_for_web" this none this rx #95
@program #1:tell_contents_for_web
"tell_contents_for_web(contents LIST [, ctype NUM]) -> html text frg LIST";
"Generate HTML text showing object's contents, if appropriate";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return {};
"Last modified Tue Nov 14 23:13:17 1995 IST by EricM (#3264).";
.

@verb #1:"get_vrml" this none this rxd #96
@program #1:get_vrml
"get_vrml(who [, rest STR [, search STR [, form STR]]]) -> VRML file frg LIST";
"Returns the VRML nodes appropriate for this object";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
vrml = {" Transform {"};
if (vrml_desc = this:get_vrml_desc(@args))
  "--object translation";
  transl = $vrml_utils:div_by_thousand(this:get_vrml_translation(@args));
  vrml = {@vrml, tostr("  translation ", transl[1], " ", transl[2], " ", transl[3])};
  "--object rotation";
  rotn = $vrml_utils:div_by_thousand(raw_rotn = this:get_vrml_rotation(@args));
  rotn_lines = {};
  "can make axis_spec more general for use with an unlimited set of axes sometime";
  "at the cost of efficiency";
  for axis in [1..length(rotn)]
    if (raw_rotn[axis])
      axis_spec = {"1 0 0 ", "0 1 0 ", "0 0 1 "}[axis];
      vrml = {@vrml, tostr("  rotation ", axis_spec, rotn[axis])};
    endif
  endfor
  "--object scale";
  scale = $vrml_utils:div_by_thousand(this:get_vrml_scale(@args));
  vrml = {@vrml, tostr("  scaleFactor ", scale[1], " ", scale[2], " ", scale[3])};
  vrml = {@vrml, " }"};
else
  vrml_desc = {"Material {diffuseColor 0 0 1} Sphere {radius 0.3} # blue sphere default"};
endif
"--object's vrml shape nodes (plus others that happen to have been defined)";
return {@vrml, @vrml_desc};
"Last modified Mon Mar 11 11:08:26 1996 IST by EricM (#3264).";
.

@verb #1:"get_vrml_translation get_vrml_rotation get_vrml_scale set_vrml_translation set_vrml_rotation set_vrml_scale" this none this rxd #96
@program #1:get_vrml_translation
"get_vrml_translation get_vrml_rotation get_vrml_scale set_vrml_translation set_vrml_rotation set_vrml_scale(none)";
"  -> {x-axis value NUM, y-axis value NUM, z-axis value NUM} LIST";
"Gets or sets the values for VRML translation, rotation, or scale";
"The saved number is 1000 times the actual VRML value";
"Note that the former two indicate a value relative to the origin of the object containing this one, while scale is independent and specific for this object";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
spec = verb[10] in {"t", "r", "s"};
if (this in {$root_class, $thing, $room, $exit, $player, $container, $note, $letter})
  return this.vrml_coords[spec];
  "moving something this basic usually makes a mess of things";
endif
if (verb[1..3] == "set")
  value = args[1];
  if (!((caller == this) || $perm_utils:controls(caller_perms(), this)))
    return E_PERM;
  elseif ((typeof(value) != LIST) || (length(value) != 3))
    return E_INVARG;
    "reject the most obvious bad settings";
  endif
  this.vrml_coords[spec] = value;
endif
return this.vrml_coords[spec];
"Last modified Thu Aug 15 07:34:22 1996 IDT by EricM (#3264).";
.

@verb #1:"get_vrml_desc set_vrml_desc" this none this rxd #95
@program #1:get_vrml_desc
"get_vrml_desc(none) -> vrml file frg LIST";
"set_vrml_desc(desc LIST) -> resulting value LIST";
"get or set the VRML description for an object; the VRML node that describes it";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (verb[1..3] == "set")
  desc = args[1];
  if (!((caller == this) || $perm_utils:controls(caller_perms(), this)))
    return E_PERM;
  elseif (typeof(desc) != LIST)
    return E_INVARG;
    "reject most obviously bad values";
  endif
  this.vrml_desc = desc;
endif
if (!this.vrml_desc)
  "If object has no VRML description, create a random one for it";
  "There really should be no invisible objects (can't totally prevent it though)";
  this:set_vrml_desc($vrml_utils:generate_random_shape());
endif
if ((this:get_vrml_translation() == {0, 0, 0}) && is_clear_property(this, "vrml_coords"))
  "object has never been placed in a room before";
  "put it somewhere in the room randomly";
  $vrml_utils:init_object_locn(this);
endif
if (link = this:get_vrml_hyperlink(@args))
  "add the object's associated hyperlink, if any";
  return {@link, @this.vrml_desc, " }"};
  "note that the final brace gets added here to close the hyperlink";
endif
return this.vrml_desc;
"Last modified Mon Apr  1 10:09:36 1996 IDT by EricM (#3264).";
.

@verb #1:"get_vrml_hyperlink" this none this rxd #96
@program #1:get_vrml_hyperlink
"get_vrml_hyperlink(none) -> WWWAnchor node opening without closing brace LIST";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (($standard_webviewer == (viewer = $web_utils:user_webviewer())) && (!(player in connected_players())))
  viewer = $anon_webviewer;
endif
return {tostr(" WWWAnchor {name \"&LOCAL_LINK;/", viewer:get_code(), "/", tonum(this), "#focus\" description \"", this.name, "\"")};
"Last modified Thu Aug 29 16:59:06 1996 IDT by EricM (#3264).";
.

@verb #1:"get_web_setting set_web_setting clear_web_setting get_vrml_setting set_vrml_setting clear_vrml_setting" this none this rxd #96
@program #1:get_web_setting
"get_web_setting(setting name STR) -> E_INVARG or setting value ANY";
"set_web_setting(setting name STR, setting value) -> new value ANY";
"clear_web_setting(setting name STR) -> 0 or E_INVARG";
"get, set or clear a web characteristic associated with this object";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (typeof(setting = args[1]) != STR)
  return E_INVARG;
elseif ((verb[1..3] in {"set", "cle"}) && (!((caller == this) || $perm_utils:controls(caller_perms(), this))))
  return E_PERM;
endif
prop = {"web_settings", "vrml_settings"}[(!(!index(verb, "vrml"))) + 1];
if (verb[1..5] == "clear")
  if (idx = setting in this.(prop)[1])
    this.(prop)[1] = listdelete(this.(prop)[1], idx);
    this.(prop)[2] = listdelete(this.(prop)[2], idx);
    return;
  else
    return E_INVARG;
  endif
elseif (verb[1..3] == "set")
  value = args[2];
  if (idx = setting in this.(prop)[1])
    this.(prop)[2][idx] = value;
  else
    this.(prop)[1] = {@this.(prop)[1], setting};
    this.(prop)[2] = {@this.(prop)[2], value};
  endif
elseif (((prop == "web_settings") && ((setting == "bodytag_attributes") && (!`this.(prop)[2][setting in this.(prop)[1]] ! E_RANGE'))) && ((!$object_utils:isa(this, $room)) || (player.location != this)))
  "The bodytag_attribute is special in that if none is set for a non-room object, it takes on the web page body attributes of the room that encloses it";
  "This insures that when a person is in a room, looking at objects inside won't cause the background to shift";
  if (valid(this.location) && (bodytag_attributes = this.location:get_web_setting("bodytag_attributes")))
    return bodytag_attributes;
    "note that if this.location isn't a room, it'll pass the buck to IT'S location, until a room with a bodytag_attributes is found, or E_INVARG is returned";
  endif
endif
return `this.(prop)[2][setting in this.(prop)[1]] ! E_RANGE, E_PROPNF => E_INVARG';
"Last modified Wed Oct  9 17:59:56 1996 IST by EricM (#3264).";
.

@verb #1:"long_title" this none this rxd #177
@program #1:long_title
return this:title();
.

"***finished***
