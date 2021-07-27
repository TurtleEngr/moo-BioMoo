$Header: /repo/public.cvs/app/BioGate/BioMooCore/core123.moo,v 1.1 2021/07/27 06:44:27 bruce Exp $

>@dump #123 with create
@create $thing named generic bulletin board:generic bulletin board
@prop #123."mail_recipient" #-1 rc
@prop #123."dates" {} r
;;#123.("aliases") = {"generic bulletin board"}
;;#123.("object_size") = {0, 0}
;;#123.("icon") = "http://hppsda.mayfield.hp.com/image/bboard.gif"
;;#123.("vrml_coords") = {{3604, -304, -3244}, {0, 0, 0}, {1000, 1000, 1000}}
;;#123.("vrml_desc") = {"Material {diffuseColor 0.75 0.5 0.0}", "Cube {width 1.73 height 1 depth 0.1}"}

@verb #123:"post stick" any on this rxd
@program #123:post
this:add_note(dobj);
.

@verb #123:"add attach" any to this rxd
@program #123:add
this:add_note(dobj);
.

@verb #123:"add_note" this none this
@program #123:add_note
if ((dobj == $nothing) || (dobj == $failed_match))
  player:tell("I see no \"", dobjstr, "\" here.");
elseif (dobj == $ambiguous_match)
  player:tell("I don't know which \"", dobjstr, "\" you mean.");
elseif (!($note in $object_utils:ancestors(dobj)))
  player:tell("That doesn't look like a note to me ...");
else
  dobj:moveto(this);
  if (dobj.location != this)
    player:tell("That note doesn't seem to want to be posted here...");
    return;
  endif
  player:tell("You post the note on ", this.name, ".");
  player.location:announce(player.name, " posts a note on ", this.name, ".");
endif
.

@verb #123:"remove take" any from this rxd
@program #123:remove
index = tonum(dobjstr);
if (((tostr(index) != dobjstr) || (index < 1)) || (index > length(this.contents)))
  player:tell("I couldn't understand which note you wanted to remove from ", this.name, ".  Please specify it by number (type 'look ", this:alias(), "').");
  return;
endif
note = this.contents[index];
if (!$perm_utils:controls(player, note))
  player:tell("Sorry, but that note is not yours to remove.");
  return;
endif
note:moveto(player);
if (note.location != player)
  player:tell("That note doesn't seem to want to be removed by you.");
  return;
endif
player:tell("You have taken note ", index, " from ", this.name, ".");
player.location:announce(player.name, " has taken note ", index, " from ", this.name, ".");
.

@verb #123:"read" any on this rxd
@program #123:read
index = $code_utils:tonum(dobjstr);
if (index == E_TYPE)
  object = this:match(dobjstr);
  if (object == $ambiguous_match)
    player:tell("There multiple possibilities matching `", dobjstr, "'.  Please try again, using more characters of the name, or specifying it by number.");
    return;
  elseif (!valid(object))
    player:tell("I couldn't understand which note on ", this.name, " you wanted to read.  Please specify it by number or by name (type 'look ", this:alias(), "').");
    return;
  endif
elseif ((index < 1) || (index > length(this.contents)))
  player:tell("I couldn't understand which note on ", this.name, " you wanted to read, your number was either too big or too small.");
  return;
else
  object = this.contents[index];
endif
object:read();
(this.location == player.location) && player.location:announce(player.name, " peruses the fine literature posted on ", this.name, ".");
.

@verb #123:"acceptable" this none this
@program #123:acceptable
return $note in $object_utils:ancestors(args[1]);
.

@verb #123:"look_self" this none this
@program #123:look_self
pass();
this:list_notes();
.

@verb #123:"list_notes" this none this
@program #123:list_notes
if (this.contents == {})
  player:tell("There aren't any notes on ", this.name, ".");
else
  for i in [1..length(this.contents)]
    $command_utils:suspend_if_needed(0);
    player:tell($string_utils:right(tostr(i), 5), " - ", this.contents[i].owner.name, ":  ", this.contents[i].name);
  endfor
endif
player:tell("---");
.

@verb #123:"alias" this none this
@program #123:alias
if ((typeof(this.aliases) != LIST) || (this.aliases == {}))
  return this.name;
else
  return this.aliases[1];
endif
.

@verb #123:"enterfunc" this none this
@program #123:enterfunc
object = args[1];
this.dates = {@this.dates, {object, time(), @(player == object.owner) ? {} | {player}}};
if ($object_utils:has_callable_verb(this.mail_recipient, "contents_added"))
  this.mail_recipient:contents_added(object);
endif
.

@verb #123:"exitfunc" this none this
@program #123:exitfunc
object = args[1];
if ($object_utils:has_callable_verb(this.mail_recipient, "contents_removed"))
  this.mail_recipient:contents_removed(object);
endif
this.dates = setremove(this.dates, $list_utils:assoc(object, this.dates));
.

@verb #123:"more_info_for_web" this none this rx #95
@program #123:more_info_for_web
"more_info_for_web( ) -> HTML doc LIST";
"Generates an HTML doc fragment with a hyperlinked list of all notes posted";
"to the bulletin board.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
text = {"<P>"};
if (this.contents == {})
  text = {@text, this:no_notes_posted_msg()};
else
  for i in [1..length(this.contents)]
    content = this.contents[i];
    text = {@text, (((((($string_utils:right(tostr(i), 5) + " - ") + $string_utils:left(content.owner:namec(1) + ":  ", 15)) + "<A HREF=\"&LOCAL_LINK;/view/") + tostr(tonum(content))) + "/read#focus\">") + content:namec()) + "</A><BR>"};
  endfor
endif
return text;
"Last modified Wed Jul 12 09:24:27 1995 IDT by EricM (#3264).";
.

"***finished***
