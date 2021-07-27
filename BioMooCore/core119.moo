$Header: /repo/public.cvs/app/BioGate/BioMooCore/core119.moo,v 1.1 2021/07/27 06:44:27 bruce Exp $

>@dump #119 with create
@create $generic_editor named HTML Editor:HTML Editor,HTMLeditor,html_editor
@prop #119."strmode" {} r
@prop #119."objects" {} r
;;#119.("commands2") = {{"say", "emote", "lis*t", "ins*ert", "n*ext,p*rev", "enter", "del*ete", "f*ind", "s*ubst", "m*ove,c*opy", "join*l", "fill"}, {"w*hat", "mode", "e*dit", "save", "abort", "q*uit,done,pause"}}
;;#119.("commands") = {{"e*dit", "<text>"}, {"save", "[<text>]"}, {"mode", "[URL|HTML]"}}
;;#119.("previous_session_msg") = "You need to ABORT or SAVE this URL or HTML document before editing any other."
;;#119.("stateprops") = {{"objects", 0}, {"strmode", 0}, {"texts", 0}, {"changes", 0}, {"inserting", 1}, {"readable", 0}}
;;#119.("depart_msg") = "%N disappears into the URL/HTML editor."
;;#119.("return_msg") = "%N reappears from the URL/HTML editor."
;;#119.("no_littering_msg") = {"Partially edited text will be here when you get back.", "To return, give the `@URL-edit' command with no arguments.", "Please come back and SAVE or ABORT if you don't intend to be working on this text in the immediate future.  Keep Our MOO Clean!  No Littering!"}
;;#119.("nothing_loaded_msg") = "You're not currently editing any object's URL or HTML document."
;;#119.("who_location_msg") = "%L [editing HTML documents or URLs]"
;;#119.("blessed_task") = 1397392137
;;#119.("aliases") = {"HTML Editor", "HTMLeditor", "html_editor"}
;;#119.("description") = {}
;;#119.("object_size") = {12186, 937987203}
;;#119.("web_calls") = 1

@verb #119:"save" any none none
@program #119:save
"modified from $note_editor:save";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!(who = this:loaded(player)))
  player:tell(this:nothing_loaded_msg());
  return;
endif
if (!dobjstr)
  note = this.objects[who];
elseif (1 == (note = this:note_match_failed(dobjstr)))
  return;
else
  this.objects[who] = note;
endif
text = this:text(who);
strmode = (length(text) <= 1) && this.strmode[who];
if (strmode)
  text = text ? text[1] | "";
endif
if (ERR == typeof(result = this:set_note_text(note, text)))
  player:tell("Text not saved to ", this:working_on(who), ":  ", result);
  if ((result == E_TYPE) && (typeof(note) == OBJ))
    player:tell("Do `mode HTML' and try saving again.");
  elseif (!dobjstr)
    player:tell("Use `save' with an argument to save the text elsewhere.");
  endif
else
  if (text)
    player:tell(strmode ? "URL" | "HTML document", " written to ", this:working_on(who), strmode ? " as a simple URL." | ".");
  else
    player:tell("The URL for ", this:working_on(who), " is now cleared.");
  endif
  this:set_changed(who, 0);
endif
"Last modified Fri Aug 16 00:59:57 1996 IDT by EricM (#3264).";
.

@verb #119:"e*dit" any none none
@program #119:edit
"Copied from the Note Editor (#49):e by Eric (#1425) Tue Oct  4 05:28:02 1994 IST";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (this:changed(who = player in this.active))
  player:tell("You are still editing a URL or HTML document for ", this:working_on(who), ".  Please type ABORT or SAVE first.");
elseif (spec = this:parse_invoke(dobjstr, verb))
  this:init_session(who, @spec);
endif
"Last modified Tue Oct  4 07:47:42 1994 IST by Raton (#3264).";
.

@verb #119:"init_session" this none this
@program #119:init_session
"modified from $note_editor:init_session";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (this:ok(who = args[1]))
  this.strmode[who] = strmode = typeof(text = args[3]) == STR;
  this:load(who, strmode ? text ? {text} | {} | text);
  this.objects[who] = args[2];
  player:tell("Now editing ", this:working_on(who), ".", strmode ? "  [URL mode]" | "");
endif
"Last modified Fri Aug 16 01:02:27 1996 IDT by EricM (#3264).";
.

@verb #119:"working_on" this none this
@program #119:working_on
"Copied from the Note Editor (#49):working_on by Eric (#1425) Tue Oct  4 05:28:22 1994 IST";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!(who = args[1]))
  return "????";
endif
spec = this.objects[who];
if (typeof(spec) == LIST)
  object = spec[1];
  prop = spec[2];
else
  object = spec;
  prop = 0;
endif
return valid(object) ? tostr("\"", object.name, "\"(", object, ")", prop ? "." + prop | "") | tostr(prop ? ("." + prop) + " on " | "", "invalid object (", object, ")");
.

@verb #119:"parse_invoke" this none this
@program #119:parse_invoke
":parse_invoke(string,verb)";
" string is the actual commandline string indicating what we are to edit";
" verb is the command verb that is attempting to invoke the editor";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!(string = args[1]))
  player:tell_lines({("Usage:  " + args[2]) + " <object>   (where <object> is some object)", ("        " + args[2]) + "          (continues editing an unsaved URL or HTML attached to an object)"});
elseif (1 == (note = this:note_match_failed(string)))
elseif (ERR == typeof(text = this:note_text(note)))
  player:tell("Couldn't retrieve URL or HTML doc:  ", text);
else
  return {note, text};
endif
return 0;
"Last modified Wed Dec 14 05:41:54 1994 IST by EricM (#3264).";
.

@verb #119:"note_match_failed" this none this
@program #119:note_match_failed
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (pp = $code_utils:parse_propref(string = args[1]))
  object = pp[1];
  prop = pp[2];
else
  object = string;
  prop = 0;
endif
if ($command_utils:object_match_failed(note = player:my_match_object(object, this:get_room(player)), object))
elseif (prop)
  if (!$object_utils:has_property(note, prop))
    player:tell(object, " has no \".", prop, "\" property.");
  else
    return {note, prop};
  endif
else
  return note;
endif
return 1;
"Last modified Wed Dec 14 05:41:21 1994 IST by EricM (#3264).";
.

@verb #119:"w*hat" none none none rd #95
@program #119:what
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!(this:ok(who = player in this.active) && (typeof(this.texts[who]) == LIST)))
  player:tell(this:nothing_loaded_msg());
else
  player:tell("You are editing the ", (mode = this.strmode[who]) ? "URL" | "HTML document", " associated with ", this:working_on(who), ".");
  player:tell("Your insertion point is ", (this.inserting[who] > length(this.texts[who])) ? "after the last line: next line will be #" | "before line ", this.inserting[who], ".");
  player:tell(this.changes[who] ? this:change_msg() | this:no_change_msg());
  if (this.readable[who])
    player:tell("Your text is globally readable.");
  endif
endif
if (this:loaded(player) && mode)
  player:tell("Text will be stored as a simple URL instead of an HTML document when possible.");
endif
"Last modified Wed Dec 14 20:25:15 1994 IST by EricM (#3264).";
.

@verb #119:"local_editing_info" this none this
@program #119:local_editing_info
"modified from $note_editor:local_editing_info to use @htmml (is any is) instead of @set-note-text";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
text = args[2];
name = (typeof(what) == OBJ) ? what.name | tostr(what[1].name, ".", what[2]);
note = (typeof(what) == OBJ) ? what | tostr(what[1], ".", what[2]);
cmd = tostr("@html ", note, " is ");
return {name, text, cmd};
"Last modified Fri Aug 16 01:11:36 1996 IDT by EricM (#3264).";
.

@verb #119:"note_text" this none this rx #95
@program #119:note_text
"WIZARDLY";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((caller != $html_editor) || (caller_perms() != $html_editor.owner))
  return E_PERM;
elseif ((typeof(spec = args[1]) == OBJ) && (!$perm_utils:controls(player, spec.owner)))
  player:tell("Sorry, only it's owner can do that.");
  return E_PERM;
elseif ((typeof(spec) != OBJ) && (!$perm_utils:controls(player, property_info(spec[1], spec[2])[2])))
  player:tell("Sorry, only it's owner can do that.");
  return E_PERM;
endif
set_task_perms(player);
text = (typeof(spec) == OBJ) ? spec:get_url() | spec[1].(spec[2]);
if (((tt = typeof(text)) in {ERR, STR}) || ((tt == LIST) && ((!text) || (typeof(text[1]) == STR))))
  return text;
else
  return E_TYPE;
endif
"Last modified Tue Aug  8 04:01:11 1995 IDT by EricM (#3264).";
.

@verb #119:"set_note_text" this none this rx #95
@program #119:set_note_text
"Copied from the Note Editor (#49):set_note_text by Eric (#1425) Tue Oct  4 05:29:35 1994 IST";
"WIZARDLY";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ((caller != $html_editor) || (caller_perms() != $html_editor.owner))
  return E_PERM;
elseif ((typeof(spec = args[1]) == OBJ) && (!$perm_utils:controls(player, spec.owner)))
  player:tell(E_PERM);
  return E_PERM;
elseif ((typeof(spec) != OBJ) && (!$perm_utils:controls(player, property_info(spec[1], spec[2])[2])))
  player:tell(E_PERM);
  return E_PERM;
endif
set_task_perms(player);
return (typeof(spec) == OBJ) ? spec:set_url(args[2]) | (spec[1].(spec[2]) = args[2]);
"Last modified Tue Aug  8 04:13:05 1995 IDT by EricM (#3264).";
.

@verb #119:"mode" any none none
@program #119:mode
"mode [string|list]";
"modified from $note_editor:mode";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!(who = this:loaded(player)))
  player:tell(this:nothing_loaded_msg());
  return;
endif
if (dobjstr)
  if (index("URL", dobjstr) == 1)
    this.strmode[who] = mode = 1;
    player:tell("Now in simple URL mode:");
  elseif (index("HTML", dobjstr) == 1)
    this.strmode[who] = mode = 0;
    player:tell("Now in HTML document mode:");
  else
    player:tell("Unrecognized mode:  ", dobjstr);
    player:tell("Should be one of `URL' or `HTML'");
    return;
  endif
else
  player:tell("Currently in ", (mode = this.strmode[who]) ? "simple URL " | "HTML document ", "mode:");
endif
if (mode)
  player:tell("  store text as a simple URL instead of an HTML document when possible.");
else
  player:tell("  always store text as an HTML document.");
endif
"Last modified Fri Aug 16 00:52:51 1996 IDT by EricM (#3264).";
.

"***finished***
