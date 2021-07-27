$Header: /repo/public.cvs/app/BioGate/BioMooCore/core9.moo,v 1.1 2021/07/27 06:44:36 bruce Exp $

>@dump #9 with create
@create $thing named generic note:generic note
@prop #9."writers" {} rc
@prop #9."encryption_key" 0 c
@prop #9."text" {} c
@prop #9."content_type" "TEXT/PLAIN" rc
@prop #9."erasers" {} rc
@prop #9."path" "notes" ""
@prop #9."external" 1 r #36
;;#9.("aliases") = {"generic note"}
;;#9.("description") = "There appears to be some writing on the note ..."
;;#9.("object_size") = {20797, 1577149623}
;;#9.("icon") = "http://hppsda.mayfield.hp.com/image/note.gif"
;;#9.("vrml_desc") = {"WWWInline {name \"http://hppsda.mayfield.hp.com/image/note.wrl\"}"}

@verb #9:"r*ead" this none none rxd
@program #9:read
if (!this:is_readable_by(valid(caller_perms()) ? caller_perms() | player))
  player:tell("Sorry, but it seems to be written in some code that you can't read.");
else
  this:look_self();
  player:tell();
  player:tell_lines_suspended(this:text());
  player:tell();
  player:tell("(You finish reading.)");
endif
.

@verb #9:"er*ase" this none none rxd
@program #9:erase
if (this:is_erasable_by(valid(caller_perms()) ? caller_perms() | player))
  this:set_text({});
  player:tell("Note erased.");
else
  player:tell("You can't erase this note.");
endif
.

@verb #9:"wr*ite" any on this rx
@program #9:write
"$focus_utils:set_focus(player, this)";
out = this.external;
if (!this:is_writable_by((caller_perms() != #-1) ? caller_perms() | player))
  return player:tell(("You can't write on " + this:name(1)) + ".");
elseif (out && ($file_utils:free_quota(this.owner) <= 0))
  return player:tell(("Sorry, " + ((this.owner == player) ? "you have" | (this.owner:namec(1) + " has"))) + " no disk quota left.");
endif
if (dobjstr == "")
  dobjstr = $command_utils:read_lines();
else
  dobjstr = {dobjstr};
endif
if (out)
  path = this.path;
  name = tostr(this);
  oldsize = filesize(path, name);
  if (typeof(oldsize) != NUM)
    oldsize = 0;
  endif
  if ((typeof(result = fileappend(path, name, dobjstr)) != ERR) && (typeof(newsize = filesize(path, name)) == NUM))
    $file_utils:update_quota(this.owner, newsize - oldsize);
  endif
else
  this:set_text({@this:text(), @dobjstr});
endif
l = length(dobjstr);
player:tell((((($string_utils:capitalize($string_utils:english_number(l)) + " line") + ((l == 1) ? "" | "s")) + " added to ") + this:name(1)) + ".");
.

@verb #9:"del*ete rem*ove" any from this rx
@program #9:delete
"$focus_utils:set_focus(player, this)";
if (!this:is_erasable_by((caller_perms() != #-1) ? caller_perms() | player))
  return player:tell("You can't modify this note.");
elseif (!dobjstr)
  return player:tell("You must tell me which line to delete.");
endif
if (this.external)
  path = this.path;
  name = tostr(this);
  line = tonum(dobjstr);
  length = filelength(path, name);
  if (((typeof(length) != NUM) || (line <= 0)) || (line > length))
    player:tell("Line out of range.");
  else
    oldsize = filesize(path, name);
    if (typeof(oldsize) != NUM)
      oldsize = 0;
    endif
    if ((typeof(result = filewrite(path, name, {}, line, line)) != ERR) && (typeof(newsize = filesize(path, name)) == NUM))
      $file_utils:update_quota(this.owner, newsize - oldsize);
    endif
    player:tell(("Line " + ((typeof(result) == NUM) ? "" | "not ")) + "deleted.");
  endif
else
  line = tonum(dobjstr);
  text = this:text();
  if ((line < 1) || (line > length(text)))
    player:tell("Line out of range.");
  else
    this:set_text(listdelete(text, line));
    player:tell("Line deleted.");
  endif
endif
.

@verb #9:"encrypt" this with any r
@program #9:encrypt
set_task_perms(player);
key = $lock_utils:parse_keyexp(iobjstr, player);
if (typeof(key) == STR)
  player:tell("That key expression is malformed:");
  player:tell("  ", key);
else
  try
    this.encryption_key = key;
    player:tell("Encrypted ", this.name, " with this key:");
    player:tell("  ", $lock_utils:unparse_key(key));
  except error (ANY)
    player:tell(error[2], ".");
  endtry
endif
.

@verb #9:"decrypt" this none none r
@program #9:decrypt
set_task_perms(player);
try
  dobj.encryption_key = 0;
  player:tell("Decrypted ", dobj.name, ".");
except error (ANY)
  player:tell(error[2], ".");
endtry
.

@verb #9:"text get_text" this none this rx
@program #9:text
":text([start] [,end]";
"start defaults to 1, the beginning of the text.";
"end defaults to the end of the text.";
cp = caller_perms();
file = {this.path, tostr(this)};
start = args[1] || 1;
end = args[2] || 0;
block = this:blocksize() || 100;
if ((!$perm_utils:controls(cp, this)) && (!this:is_readable_by(cp)))
  return E_PERM;
elseif (!this.external)
  return this.text[start..end || length(this.text)];
elseif (!fileexists(@file))
  return {};
endif
len = filelength(@file);
len = (end = min(end || len, len)) - start;
if (len < block)
  return fileread(@file, start, end);
endif
text = {};
for i in [0..len / block]
  $command_utils:suspend_if_needed(1);
  text = {@text, @fileread(@file, start + (block * i), ((start + (block * i)) + block) - 1)};
endfor
return text;
.

@verb #9:"is_readable_by" this none this
@program #9:is_readable_by
key = this.encryption_key;
return (key == 0) || $lock_utils:eval_key(key, args[1]);
.

@verb #9:"set_text" this none this rx
@program #9:set_text
cp = caller_perms();
newtext = args[1];
if ((!$perm_utils:controls(cp, this)) && (!this:is_writable_by(cp)))
  return E_PERM;
elseif (typeof(newtext) == STR)
  newtext = {newtext};
elseif (typeof(newtext) != LIST)
  return E_TYPE;
endif
if (this.external)
  temp = tostr(random(1000));
  while (filesize("temp", temp) != E_INVARG)
    temp = tostr(random(1000));
  endwhile
  filewrite("temp", temp, newtext);
  size = filesize("temp", temp);
  filedelete("temp", temp);
  path = this.path;
  name = tostr(this);
  oldsize = filesize(path, name);
  if (typeof(oldsize) != NUM)
    oldsize = 0;
  endif
  if ($file_utils:free_quota(this.owner) < (size - oldsize))
    return E_QUOTA;
  elseif ((typeof(result = filewrite(path, name, newtext)) != ERR) && (typeof(newsize = filesize(path, name)) == NUM))
    $file_utils:update_quota(this.owner, newsize - oldsize);
  endif
  return result;
else
  return this.text = newtext;
endif
.

@verb #9:"is_writable_by" this none this
@program #9:is_writable_by
who = args[1];
wr = this.writers;
if ($perm_utils:controls(who, this))
  return 1;
elseif (typeof(wr) == LIST)
  return who in wr;
else
  return wr;
endif
.

@verb #9:"mailme @mailme" this none none
@program #9:mailme
"Usage:  mailme <note>";
"  uses $network to sends the text of this note to your REAL internet email address.";
"$focus_utils:set_focus(player, this)";
set_task_perms(player);
{success, message} = this:do_mailme();
player:tell(message);
.

@verb #9:"html" this none this rx #95
@program #9:html
"html(who, what, rest, search) -> HTML doc LIST";
"If rest='read' then returns the note's text, otherwise pass(@args)";
"which should return it's description.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
rest = args[2];
search = args[3];
set_task_perms(caller_perms().wizard ? player | caller_perms());
"if the webcall has no command, quickly pass back a result";
if ((!rest) && (!search))
  return pass(@args);
endif
text = {};
if (rest == "read")
  text = (typeof(text = this:text() || "(the note is blank)") == LIST) ? text | {text};
  "should support other MIME types at some point";
  if (this.content_type in {E_PROPNF, "TEXT/PLAIN"})
    text = $web_utils:preformat($web_utils:entity_sub(text));
  endif
  if ("embedVRML" in player.web_options)
    text = {"<BR CLEAR=\"RIGHT\">", @text};
  endif
endif
return text;
"Last modified Thu Aug 15 09:24:51 1996 IDT by EricM (#3264).";
.

@verb #9:"verbs_for_web" this none this rx #95
@program #9:verbs_for_web
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return {"<P><B>Actions:</B><BR>", ((((("<A HREF=\"&LOCAL_LINK;/" + "view") + "/") + tostr(tonum(this))) + "/read#focus\">Read</A> ") + this:name(1)) + "<BR>"};
"Last modified Sat May  6 18:54:34 1995 IDT by Gustavo (#2).";
.

@verb #9:"object_edit_for_web" this none this rxd #95
@program #9:object_edit_for_web
"Return a web form for editing the note";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!(caller in {this, $object_browser}))
  return E_PERM;
endif
what = args[1];
form = {tostr("<A NAME=\"#NoteTop\"><H3>", "<IMAGE SRC=\"http://hppsda.mayfield.hp.com/image/note.gif\">", "Characteristics for Notes: ", what:name(), " (", what, ")</H3></A>")};
if (!what:is_writable_by(player))
  return {@form, "<B>This note is not writable by you.</B>"};
endif
form = {@form, tostr("<FORM METHOD=\"POST\" ACTION=\"&LOCAL_LINK;/", $object_browser:get_code(), "/", tonum(what), "/", tonum($code_utils:verb_location()), "\">")};
form = {@form, "<INPUT TYPE=\"HIDDEN\" NAME=\"action\" VALUE=\"do_edit_object\">"};
form = {@form, "<INPUT TYPE=\"SUBMIT\" VALUE=\"Update note text\"><INPUT TYPE=\"RESET\" VALUE=\"Restore original note text\"><P>"};
form = {@form, "<H2>Text of note:</H2>"};
form = {@form, "<TEXTAREA NAME=\"note_text\" ROWS=15 COLS=74>"};
form = {@form, @what:text(), "</TEXTAREA></FORM>"};
return {"NoteTop", form};
"Last modified Thu Aug 15 09:36:31 1996 IDT by EricM (#3264).";
.

@verb #9:"edit_object_by_web" this none this rd #95
@program #9:edit_object_by_web
"edit_object_by_web(what OBJ, form field names LIST, form field values LIST) -> NUM or STR";
"Takes web form data and extracts out the field 'note_text' which";
"is used to set the note's text. Edits values on object 'what' according to form values.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
perms = caller_perms();
if ((caller != $object_browser) && (!$perm_utils:controls(perms, $code_utils:verb_perms())))
  "Accept calls only from $object_browser and the owner of the the person who wrote this (usually the owner of the generic object it's defined on).";
  return E_PERM;
elseif (!what:is_writable_by(perms))
  return "Sorry, you don't have permission to write text to this note.";
endif
set_task_perms(perms);
field_names = args[2];
field_values = args[3];
if (i = "note_text" in field_names)
  result = what:set_text(field_values[i]);
  result = (typeof(result) == NUM) ? !result | tostr(result);
endif
return result;
"Last modified Thu Aug 15 09:46:09 1996 IDT by EricM (#3264).";
.

@verb #9:"get_icon" this none this rx #95
@program #9:get_icon
"Return the 'note' icon if there is any text on the note, any args have been given, or a non-generic icon has been specified, else none.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return (((!is_clear_property(this, "icon")) || this:has_text()) || args) ? pass(@args) | "";
"Last modified Thu Aug 15 09:22:19 1996 IDT by EricM (#3264).";
.

@verb #9:"has_text" this none this rx #95
@program #9:has_text
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
cp = caller_perms();
if ((!$perm_utils:controls(cp, this)) && (!this:is_readable_by(cp)))
  return E_PERM;
elseif (this.text)
  "shouldn't have to read the text to determine if there is any";
  return 1;
elseif (this.external)
  return !(!`call_function("fileread", this.path, tostr(this), 1, 1) ! ANY');
else
  return !(!length(this:text()));
endif
"Last modified Tue Jul  1 20:01:31 1997 IDT by EricM (#3264).";
.

@verb #9:"has_url" this none this rx #95
@program #9:has_url
"Return 1 if note has text and is readable, else 0";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return pass(@args) || (this:is_readable_by(player) && this:has_text());
"Last modified Thu Aug 15 09:17:38 1996 IDT by EricM (#3264).";
.

@verb #9:"find*-regexp" any in this rxd
@program #9:find-regexp
"find <search-string> in <note>";
"find-*regexp <search-regexp> in <note>";
"$focus_utils:set_focus(player, this)";
if (!this:is_readable_by((caller_perms() != #-1) ? caller_perms() | player))
  player:tell("Sorry, but it seems to be written in some code that you can't read.");
  return;
endif
found = `filegrep("notes", tostr(this), (length(verb) > 4) ? dobjstr | $string_utils:regexp_quote(dobjstr), "sn") ! E_INVARG';
if (typeof(found) != LIST)
  return player:tell("The note has no text.");
endif
for i in [1..length(found[2])]
  player:tell($string_utils:right(found[2][i], 4), ": ", found[1][i]);
endfor
player:tell("---Done searching for ", dobjstr, " in ", this:name(1), ".");
.

@verb #9:"description" this none this
@program #9:description
desc = pass(@args);
if (typeof(desc) != LIST)
  desc = {desc};
endif
return {@desc, tostr(this:namec(1), " has ", this:has_text() ? tostr(this:text_length(), " lines of") | "no", " text.")};
.

@verb #9:"recycle" this none this rx
@program #9:recycle
if (!caller_perms().wizard)
  return E_PERM;
elseif (!this.external)
  return pass(@args);
endif
path = this.path;
name = tostr(this);
oldsize = filesize(path, name);
if (typeof(oldsize) != NUM)
  oldsize = 0;
endif
if (typeof(result = filedelete(path, name)) != ERR)
  $file_utils:update_quota(this.owner, -oldsize);
endif
return pass(@args);
.

@verb #9:"externalize internalize externalise internalise" this none this rx
@program #9:externalize
out = verb[1] == "e";
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
elseif ((out + this.external) != 1)
  return E_NACC;
endif
text = this:text();
text = (typeof(text) != LIST) ? {text} | text;
oldsize = filesize(this.path, tostr(this));
if (typeof(oldsize) != NUM)
  oldsize = 0;
endif
if (out)
  if ($file_utils:free_quota(this.owner) <= 0)
    return E_QUOTA;
  endif
  result = filewrite(this.path, tostr(this), text);
  if (typeof(result) == ERR)
    return result;
  elseif (fileread(this.path, tostr(this)) != text)
    return E_INVARG;
  else
    clear_property(this, "text");
  endif
else
  result = this.text = text;
  if (typeof(result) == ERR)
    return result;
  else
    filedelete(this.path, tostr(this));
  endif
endif
newsize = filesize(this.path, tostr(this));
if (typeof(newsize) != NUM)
  newsize = 0;
endif
$file_utils:update_quota(this.owner, newsize - oldsize);
this.external = out;
return 1;
.

@verb #9:"add_text" this none this rx
@program #9:add_text
"this:add_text(<list of strings>);";
"Appends a list of strings to the end of the note's current text.";
"Returns E_TYPE if you feed it just a string.";
cp = caller_perms();
newtext = args[1];
if ((!$perm_utils:controls(cp, this)) && (!this:is_writable_by(cp)))
  return E_PERM;
elseif (typeof(newtext) != LIST)
  return E_TYPE;
elseif (this.external)
  temp = tostr(random(1000));
  while (filesize("temp", temp) != E_INVARG)
    temp = tostr(random(1000));
  endwhile
  fileappend("temp", temp, newtext);
  size = filesize("temp", temp);
  filedelete("temp", temp);
  path = this.path;
  name = tostr(this);
  oldsize = filesize(path, name);
  if (typeof(oldsize) != NUM)
    oldsize = 0;
  endif
  if ($file_utils:free_quota(this.owner) < (size - oldsize))
    return E_QUOTA;
  elseif ((typeof(result = fileappend(path, name, newtext)) != ERR) && (typeof(newsize = filesize(path, name)) == NUM))
    $file_utils:update_quota(this.owner, newsize - oldsize);
  endif
  return result;
else
  this.text = {@this.text, @newtext};
endif
.

@verb #9:"hidden_verbs" this none this
@program #9:hidden_verbs
hidden = pass(@args);
if (this != $note)
  if (this:text())
    if (!this:is_readable_by(player))
      hidden = {@hidden, "r*ead", "find*regexp", "mailme @mailme"};
    elseif ($object_utils:isa(player, $guest))
      hidden = {@hidden, "mailme @mailme"};
    endif
    if (!this:is_erasable_by(player))
      hidden = {@hidden, "er*ase", "del*ete rem*ove"};
    endif
  else
    hidden = {@hidden, "r*ead", "find*-regexp", "mailme @mailme", "er*ase", "del*ete rem*ove"};
  endif
  if (!this:is_writable_by(player))
    hidden = {@hidden, "wr*ite"};
  endif
  if (!$perm_utils:controls(player, this))
    hidden = {@hidden, "encrypt", "decrypt"};
  elseif (!this.encryption_key)
    hidden = {@hidden, "decrypt"};
  endif
endif
return hidden;
.

@verb #9:"text_length" this none this rx
@program #9:text_length
cp = caller_perms();
if ((!$perm_utils:controls(cp, this)) && (!this:is_readable_by(cp)))
  return E_PERM;
elseif (this.external)
  return filelength(this.path, tostr(this));
else
  return length(this:text());
endif
.

@verb #9:"do_mailme" this none this rx
@program #9:do_mailme
who = caller_perms();
if ((who.wizard && (typeof(args[1]) == OBJ)) && $recycler:valid(args[1]))
  who = args[1];
endif
if (!this:is_readable_by(who))
  return {0, "Sorry, but it seems to be written in some code that you can't read."};
elseif (!who.email_address)
  return {0, "Sorry, you don't have a registered email address."};
elseif (!$network.active)
  return {0, "Sorry, internet mail is disabled."};
elseif (!(text = this:text()))
  return {1, $string_utils:pronoun_sub("%T is empty -- there wouldn't be any point to mailing it.")};
else
  suspend(0);
  $network:sendmail(who.email_address, this:titlec(1), "", @text);
  return {1, tostr("Mailed ", this:title(1), " to ", who.email_address, ".  (", length(text), " lines)")};
endif
.

@verb #9:"is_erasable_by" this none this
@program #9:is_erasable_by
who = args[1];
wr = this.erasers;
if ($perm_utils:controls(who, this))
  return 1;
elseif (typeof(wr) == LIST)
  return who in wr;
else
  return wr;
endif
.

@verb #9:"wr*ite newwrite" any to this rx
@program #9:write
"Copied from generic note (#9):wr by Wizard (#2) Tue Apr 28 15:47:20 1998 PDT";
"$focus_utils:set_focus(player, this)";
out = this.external;
if (!this:is_writable_by((caller_perms() != #-1) ? caller_perms() | player))
  return player:tell(("You can't write on " + this:name(1)) + ".");
elseif (out && ($file_utils:free_quota(this.owner) <= 0))
  return player:tell(("Sorry, " + ((this.owner == player) ? "you have" | (this.owner:namec(1) + " has"))) + " no disk quota left.");
endif
if (dobjstr == "")
  dobjstr = $command_utils:read_lines();
else
  dobjstr = {dobjstr};
endif
if (out)
  path = this.path;
  name = tostr(this);
  oldsize = filesize(path, name);
  if (typeof(oldsize) != NUM)
    oldsize = 0;
  endif
  if ((typeof(result = fileappend(path, name, dobjstr)) != ERR) && (typeof(newsize = filesize(path, name)) == NUM))
    $file_utils:update_quota(this.owner, newsize - oldsize);
  endif
else
  this:set_text({@this:text(), @dobjstr});
endif
l = length(dobjstr);
player:tell((((($string_utils:capitalize($string_utils:english_number(l)) + " line") + ((l == 1) ? "" | "s")) + " added to ") + this:name(1)) + ".");
.

"***finished***
