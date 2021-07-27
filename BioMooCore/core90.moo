$Header: /repo/public.cvs/app/BioGate/BioMooCore/core90.moo,v 1.1 2021/07/27 06:44:36 bruce Exp $

>@dump #90 with create
@create $mail_recipient_class named Frand's player class:Frand's player class,player class
@prop #90."at_room_width" 30 rc
@prop #90."at_number" 0 rc
@prop #90."join_msg" "You join %n." rc
@prop #90."object_port_msg" "teleports you." rc
@prop #90."victim_port_msg" "teleports you." rc
@prop #90."thing_arrive_msg" "%T teleports %n in." rc
@prop #90."othing_port_msg" "%T teleports %n out." rc
@prop #90."thing_port_msg" "You teleport %n." rc
@prop #90."player_arrive_msg" "%T teleports %n in." rc
@prop #90."oplayer_port_msg" "%T teleports %n out." rc
@prop #90."player_port_msg" "You teleport %n." rc
@prop #90."self_arrive_msg" "%<teleports> in." rc
@prop #90."oself_port_msg" "%<teleports> out." rc
@prop #90."self_port_msg" "" rc
@prop #90."rooms" {} r
@prop #90."refused_origins" {} r
@prop #90."refused_extra" {} r
@prop #90."default_refusal_time" 604800 r
@prop #90."report_refusal" 0 r
@prop #90."refused_actions" {} r
@prop #90."refused_until" {} r
@prop #90."page_refused" 0 r
@prop #90."page_refused_msg" "%N refuses your page." rc
@prop #90."whisper_refused_msg" "%N refuses your whisper." rc
@prop #90."mail_refused_msg" "%N refuses your mail." rc
;;#90.("features") = {#92, #91, #132}
;;#90.("help") = #86
;;#90.("home") = #62
;;#90.("size_quota") = {50000, 0, 0, 1}
;;#90.("web_options") = {{"telnet_applet", #110}, "applinkdown", "exitdetails", "map", "embedVRML", "separateVRML"}
;;#90.("aliases") = {"Frand's player class", "player class"}
;;#90.("description") = "You see a player who should type '@describe me as ...'."
;;#90.("object_size") = {63570, 855069281}
;;#90.("vrml_desc") = {"WWWInline {name \"http://hppsda.mayfield.hp.com/image/body.wrl\"}", ""}

@verb #90:"@rooms" none none none rxd
@program #90:@rooms
"'@rooms' - List the rooms which are known by name.";
line = "";
for item in (this.rooms)
  line = (((line + item[1]) + "(") + tostr(item[2])) + ")   ";
endfor
player:tell(line);
.

@verb #90:"names_of" this none this
@program #90:names_of
"Return a string giving the names of the objects in a list. Now on $string_utils";
return $string_utils:names_of(@args);
.

@verb #90:"@go" any none none rxd
@program #90:@go
"'@go <place>' - Teleport yourself somewhere. Example: '@go liv' to go to the living room.";
dest = this:lookup_room(dobjstr);
if (dest == $failed_match)
  player:tell("There's no such place known.");
else
  this:teleport(player, dest);
endif
.

@verb #90:"lookup_room" this none this
@program #90:lookup_room
"Look up a room in your personal database of room names, returning its object number. If it's not in your database, it checks to see if it's a number or a nearby object.";
room = args[1];
if (room == "home")
  return player.home;
elseif (room == "me")
  return player;
elseif (room == "here")
  return player.location;
elseif (!room)
  return $failed_match;
endif
index = this:index_room(room);
if (index)
  return this.rooms[index][2];
else
  return this:my_match_object(room);
  "old code no longer used, 2/11/96 Heathcliff";
  source = player.location;
  if (!(valid(source) && ($room in $object_utils:ancestors(source))))
    source = $room;
  endif
  return source:match_object(room);
endif
.

@verb #90:"teleport" this none this
@program #90:teleport
"Teleport a player or object. For printing messages, there are three cases: (1) teleport self (2) teleport other player (3) teleport object. There's a spot of complexity for handling the invalid location #-1.";
{thing, dest} = args;
source = thing.location;
if (valid(dest))
  dest_name = dest.name;
else
  dest_name = tostr(dest);
endif
if (source == dest)
  player:tell(thing.name, " is already at ", dest_name, ".");
  return;
endif
thing:moveto(dest);
if (thing.location == dest)
  tsd = {thing, source, dest};
  if (thing == player)
    this:teleport_messages(@tsd, this:self_port_msg(@tsd), this:oself_port_msg(@tsd), this:self_arrive_msg(@tsd), "");
  elseif (is_player(thing))
    this:teleport_messages(@tsd, this:player_port_msg(@tsd), this:oplayer_port_msg(@tsd), this:player_arrive_msg(@tsd), this:victim_port_msg(@tsd));
  else
    this:teleport_messages(@tsd, this:thing_port_msg(@tsd), this:othing_port_msg(@tsd), this:thing_arrive_msg(@tsd), this:object_port_msg(@tsd));
  endif
elseif (thing.location == source)
  if ($object_utils:contains(thing, dest))
    player:tell("Ooh, it's all twisty. ", dest_name, " is inside ", thing.name, ".");
  else
    if ($object_utils:has_property(thing, "po"))
      pronoun = thing.po;
    else
      pronoun = "it";
    endif
    player:tell("Either ", thing.name, " doesn't want to go, or ", dest_name, " didn't accept ", pronoun, ".");
  endif
else
  thing_name = (thing == player) ? "you" | thing.name;
  player:tell("A strange force deflects ", thing_name, " from the destination.");
endif
.

@verb #90:"teleport_messages" this none this
@program #90:teleport_messages
"Send teleport messages. There's a slight complication in that the source and dest need not be valid objects.";
{thing, source, dest, pmsg, smsg, dmsg, tmsg} = args;
if (pmsg)
  "The player's own message.";
  player:tell(pmsg);
endif
if (smsg && valid(source))
  "A message to the victim's original location, if it is a room.";
  if ($object_utils:has_callable_verb(source, "announce_all_but"))
    source:announce_all_but({thing, player}, smsg);
  endif
endif
if (dmsg && valid(dest))
  "A message to the destination, if it is a room.";
  if ($object_utils:has_callable_verb(dest, "announce_all_but"))
    dest:announce_all_but({thing, player}, dmsg);
  endif
endif
if (tmsg)
  "A message to the victim being teleported.";
  thing:tell(tmsg);
endif
.

@verb #90:"@move" any any any rxd
@program #90:@move
"'@move <object> to <place>' - Teleport an object. Example: '@move trash to #11' to move trash to the closet.";
here = player.location;
if ((prepstr != "to") || (!iobjstr))
  player:tell("Usage: @move <object> to <location>");
  return;
endif
if ((!dobjstr) || (dobjstr == "me"))
  thing = this;
else
  if (valid(here) && $object_utils:has_callable_verb(here, "match_object"))
    thing = here:match_object(dobjstr);
  endif
  if (thing == $failed_match)
    thing = player:my_match_object(dobjstr);
  endif
endif
if ($command_utils:object_match_failed(thing, dobjstr))
  return;
endif
if ((!player.programmer) && ((thing.owner != player) && (thing != player)))
  player:tell("You can only move your own objects.");
  return;
endif
dest = this:lookup_room(iobjstr);
if ((dest == #-1) || (!$command_utils:object_match_failed(dest, iobjstr)))
  this:teleport(thing, dest);
endif
.

@verb #90:"index_room" this none this
@program #90:index_room
"'index_room (<room name>)' - Look up a room in your personal database of room names, returning its index in the list. Return 0 if it is not in the list. If the room name is the empty string, then only exact matches are considered; otherwise, a leading match is good enough.";
room = tostr(args[1]);
size = length(room);
index = 1;
match = 0;
for item in (this.rooms)
  item_name = item[1];
  if (room == item_name)
    return index;
  elseif ((size && (length(item_name) >= size)) && (room == item_name[1..size]))
    match = index;
  endif
  index = index + 1;
endfor
return match;
.

@verb #90:"@addr*oom" any none none rxd
@program #90:@addroom
"'@addroom <name> <object>', '@addroom <object> <name>', '@addroom <name>', '@addroom <object>', '@addroom' - Add a room to your personal database of teleport destinations. Example: '@addroom Kitchen #24'. Reasonable <object>s are numbers (#17) and 'here'. If you leave out <object>, the object is the current room. If you leave out <name>, the name is the specified room's name. If you leave out both, you get the current room and its name.";
if (((!caller) && (player != this)) || (caller && (callers()[1][3] != this)))
  if (!caller)
    player:tell(E_PERM);
  endif
  return E_PERM;
endif
if (!dobjstr)
  object = this.location;
  name = valid(object) ? object.name | "Nowhere";
elseif (command = this:parse_out_object(dobjstr))
  name = command[1];
  object = command[2];
else
  name = dobjstr;
  object = this.location;
endif
if (!valid(object))
  player:tell("This is not a valid location.");
  return E_INVARG;
endif
player:tell("Adding ", name, "(", tostr(object), ") to your database of rooms.");
this.rooms = {@this.rooms, {name, object}};
.

@verb #90:"@rmr*oom" any none none rxd
@program #90:@rmroom
"'@rmroom <roomname>' - Remove a room from your personal database of teleport destinations. Example: '@rmroom library'.";
if (((!caller) && (player != this)) || (caller && (callers()[1][3] != this)))
  if (!caller)
    player:tell(E_PERM);
  endif
  return E_PERM;
endif
index = this:index_room(dobjstr);
if (index)
  player:tell("Removing ", this.rooms[index][1], "(", this.rooms[index][2], ").");
  this.rooms = listdelete(this.rooms, index);
else
  player:tell("That room is not in your database of rooms. Check '@rooms'.");
endif
.

@verb #90:"@join" any none none rxd
@program #90:@join
"'@join <player>' - Teleport yourself to the location of any player, whether connected or not.";
if (dobjstr == "")
  player:tell("Usage: @join <player>. For example, '@join frand'.");
  return;
endif
target = $string_utils:match_player(dobjstr);
$command_utils:player_match_result(target, dobjstr);
if (valid(target))
  if (target == this)
    if (player == this)
      player:tell("There is little need to join yourself, unless you are split up.");
    else
      player:tell("No thank you. Please get your own join verb.");
    endif
    return;
  endif
  dest = target.location;
  msg = this:enlist(this:join_msg());
  editing = $object_utils:isa(dest, $generic_editor);
  if (editing)
    dest = dest.original[target in dest.active];
    editing_msg = "%N is editing at the moment. You can wait here until %s is done.";
    if (player.location == dest)
      msg = {editing_msg};
    else
      msg = {@msg, editing_msg};
    endif
  endif
  if (msg && ((player.location != dest) || editing))
    player:tell_lines($string_utils:pronoun_sub(msg, target));
  elseif (player.location == dest)
    player:tell("OK, you're there. You didn't need to actually move, though.");
    return;
  endif
  this:teleport(player, dest);
endif
.

@verb #90:"@find" any none none rxd
@program #90:@find
"'@find #<object>', '@find <player>', '@find :<verb>' '@find .<property>' - Attempt to locate things. Verbs and properties are found on any object in the player's vicinity, and some other places.";
if (!dobjstr)
  player:tell("Usage: '@find #<object>' or '@find <player>' or '@find :<verb>' or '@find .<property>'.");
  return;
endif
if (dobjstr[1] == ":")
  name = dobjstr[2..$];
  this:find_verb(name);
  return;
elseif (dobjstr[1] == ".")
  name = dobjstr[2..$];
  this:find_property(name);
  return;
elseif (dobjstr[1] == "#")
  target = toobj(dobjstr);
  if (!valid(target))
    player:tell(target, " does not exist.");
  endif
else
  target = $string_utils:match_player(dobjstr);
  $command_utils:player_match_result(target, dobjstr);
endif
if (valid(target))
  player:tell(target.name, " (", target, ") is at ", valid(target.location) ? target.location.name | "Nowhere", " (", target.location, ").");
endif
.

@verb #90:"find_verb" this none this
@program #90:find_verb
"'find_verb (<name>)' - Search for a verb with the given name. The objects searched are those returned by this:find_verbs_on(). The printing order relies on $list_utils:remove_duplicates to leave the *first* copy of each duplicated element in a list; for example, {1, 2, 1} -> {1, 2}, not to {2, 1}.";
name = args[1];
results = "";
objects = $list_utils:remove_duplicates(this:find_verbs_on());
for thing in (objects)
  if (valid(thing) && (mom = $object_utils:has_verb(thing, name)))
    results = ((((results + "   ") + thing.name) + "(") + tostr(thing)) + ")";
    mom = mom[1];
    if (thing != mom)
      results = ((((results + "--") + mom.name) + "(") + tostr(mom)) + ")";
    endif
  endif
endfor
if (results)
  this:tell("The verb :", name, " is on", results);
else
  this:tell("The verb :", name, " is nowhere to be found.");
endif
.

@verb #90:"@ways" any none none rxd
@program #90:@ways
"'@ways', '@ways <room>' - List any obvious exits from the given room (or this room, if none is given).";
if (dobjstr)
  room = dobj;
else
  room = this.location;
endif
if ((!valid(room)) || (!($room in $object_utils:ancestors(room))))
  player:tell("You can only pry into the exits of a room.");
  return;
endif
exits = {};
if ($object_utils:has_verb(room, "obvious_exits"))
  exits = room:obvious_exits();
endif
exits = this:checkexits(this:obvious_exits(), room, exits);
exits = this:findexits(room, exits);
this:tell_ways(exits, room);
.

@verb #90:"findexits" this none this
@program #90:findexits
"Add to the 'exits' list any exits in the room which have a single-letter alias.";
{room, exits} = args;
alphabet = "abcdefghijklmnopqrstuvwxyz0123456789";
for i in [1..length(alphabet)]
  found = room:match_exit(alphabet[i]);
  if (valid(found) && (!(found in exits)))
    exits = {@exits, found};
  endif
endfor
return exits;
.

@verb #90:"checkexits" this none this
@program #90:checkexits
"Check a list of exits to see if any of them are in the given room.";
{to_check, room, exits} = args;
for word in (to_check)
  found = room:match_exit(word);
  if (valid(found) && (!(found in exits)))
    exits = {@exits, found};
  endif
endfor
return exits;
.

@verb #90:"self_port_msg player_port_msg thing_port_msg join_msg" this none this
@program #90:self_port_msg
"This verb returns messages that go only to you. You don't need to have your name tacked on to the beginning of these. Heh.";
msg = this.(verb);
if (msg && (length(args) >= 3))
  msg = this:msg_sub(msg, @args);
endif
return msg;
.

@verb #90:"oself_port_msg self_arrive_msg oplayer_port_msg player_arrive_msg victim_port_msg othing_port_msg thing_arrive_msg object_port_msg" this none this
@program #90:oself_port_msg
"This verb returns messages that go to other players. It does pronoun substitutions; if your name is not included in the final string, it adds the name in front.";
msg = this.(verb);
if (msg && (length(args) >= 3))
  msg = this:msg_sub(msg, @args);
endif
if (msg && (!$string_utils:index_delimited(msg, player.name)))
  msg = (player.name + " ") + msg;
endif
return msg;
.

@verb #90:"msg_sub" this none this
@program #90:msg_sub
"Do pronoun and other substitutions on the teleport messages. The arguments are: 1. The original message, before any substitutions; 2. object being teleported; 3. from location; 4. to location. The return value is the final message.";
{msg, thing, from, to} = args;
msg = $string_utils:substitute(msg, $string_utils:pronoun_quote({{"%<from room>", valid(from) ? from.name | "Nowhere"}, {"%<to room>", valid(to) ? to.name | "Nowhere"}}));
msg = $string_utils:pronoun_sub(msg, thing);
return msg;
.

@verb #90:"obvious_exits" this none this
@program #90:obvious_exits
"'obvious_exits()' - Return a list of common exit names which are obviously worth looking for in a room.";
return {"n", "ne", "e", "se", "s", "sw", "w", "nw", "north", "northeast", "east", "southeast", "south", "southwest", "west", "northwest", "u", "d", "up", "down", "out", "exit", "leave", "enter"};
.

@verb #90:"tell_ways" this none this
@program #90:tell_ways
":tell_ways (<list of exits>)' - Tell yourself a list of exits, for @ways. You can override it to print the exits in any format.";
exits = args[1];
answer = {};
for e in (exits)
  answer = {@answer, ((e.name + " (") + $string_utils:english_list(e.aliases)) + ")"};
endfor
player:tell("Obvious exits: ", $string_utils:english_list(answer), ".");
.

@verb #90:"tell_obj" this none this
@program #90:tell_obj
"Return the name and number of an object, e.g. 'Root Class (#1)'.";
o = args[1];
return (((valid(o) ? o.name | "Nothing") + " (") + tostr(o)) + ")";
.

@verb #90:"parse_out_object" this none this
@program #90:parse_out_object
"'parse_out_object (<string>)' -> {<name>, <object>}, or 0. Given a string, attempt to find an object at its beginning or its end. An object can be either an object number, or 'here'. If this succeeds, return a list of the object and the unmatched part of the string, called the name. If it fails, return 0.";
words = $string_utils:words(args[1]);
if (!length(words))
  return 0;
endif
word1 = words[1];
wordN = words[$];
if (length(word1) && (word1[1] == "#"))
  start = 2;
  finish = length(words);
  what = toobj(word1);
elseif (word1 == "here")
  start = 2;
  finish = length(words);
  what = this.location;
elseif (length(wordN) && (wordN[1] == "#"))
  start = 1;
  finish = length(words) - 1;
  what = toobj(wordN);
elseif (wordN == "here")
  start = 1;
  finish = length(words) - 1;
  what = this.location;
else
  return 0;
endif
"toobj() has the nasty property that invalid strings get turned into #0. Here we just pretend that all references to #0 are actually meant for #-1.";
if (what == #0)
  what = $nothing;
endif
name = $string_utils:from_list(words[start..finish], " ");
if (!name)
  name = valid(what) ? what.name | "Nowhere";
endif
return {name, what};
.

@verb #90:"enlist" this none this
@program #90:enlist
"'enlist (<x>)' - If x is a list, just return it; otherwise, return {x}. The purpose here is to turn message strings into lists, so that lines can be added. It is not guaranteed to work for non-string non-lists.";
x = args[1];
if (!x)
  return {};
elseif (typeof(x) == LIST)
  return x;
else
  return {x};
endif
.

@verb #90:"@spellm*essages @spellp*roperties" any any any rd #2
@program #90:@spellmessages
"@spellproperties <object>";
"@spellmessages <object>";
"Spell checks the string properties of an object, or the subset of said properties which are suffixed _msg, respectively.";
set_task_perms(player);
if (!dobjstr)
  player:notify(tostr("Usage: ", verb, " <object>"));
  return;
elseif ($command_utils:object_match_failed(dobj = player:my_match_object(dobjstr), dobjstr))
  return;
elseif (typeof(props = $object_utils:all_properties(dobj)) == ERR)
  player:notify("Permission denied to read properties on that object.");
  return;
endif
props = setremove(props, "messages");
if (verb[1..7] == "@spellm")
  spell = {};
  for prop in (props)
    if ((index(prop, "_msg") == (length(prop) - 3)) && index(prop, "_msg"))
      spell = {@spell, prop};
    endif
  endfor
  props = spell;
endif
if (props == {})
  player:notify(tostr("No ", (verb[1..7] == "@spellm") ? "messages" | "properties", " found to spellcheck on ", dobj, "."));
  return;
endif
for data in (props)
  if (typeof(dd = `dobj.(data) ! ANY') == LIST)
    text = {};
    for linenum in (dd)
      text = listappend(text, linenum);
    endfor
  elseif ((((typeof(dd) == OBJ) || (typeof(dd) == INT)) || (typeof(dd) == ERR)) || (typeof(dd) == FLOAT))
    text = "";
  elseif (typeof(dd) == STR)
    text = dd;
  endif
  if (typeof(text) == STR)
    text = {text};
  endif
  linenumber = 0;
  for thisline in (text)
    $command_utils:suspend_if_needed(0);
    linenumber = linenumber + 1;
    if (((((typeof(thisline) != LIST) && (typeof(thisline) != OBJ)) && (typeof(thisline) != INT)) && (typeof(thisline) != FLOAT)) && (typeof(thisline) != ERR))
      i = $string_utils:strip_chars(thisline, "!@#$%^&*()_+1234567890={}[]<>?:;,./|\"~'");
      if (i)
        i = $string_utils:words(i);
        for ii in [1..length(i)]
          $command_utils:suspend_if_needed(0);
          if (!$spell:valid(i[ii]))
            if ((rindex(i[ii], "s") == length(i[ii])) && $spell:valid(i[ii][1..$ - 1]))
              msg = "Possible match: " + i[ii];
            elseif ((rindex(i[ii], "'s") == (length(i[ii]) - 1)) && $spell:valid(i[ii][1..$ - 2]))
              msg = "Possible match: " + i[ii];
            else
              msg = "Unknown word: " + i[ii];
            endif
            if (length(text) == 1)
              foo = ": ";
            else
              foo = (" (line " + tostr(linenumber)) + "): ";
            endif
            player:notify(tostr(dobj, ".", data, foo, msg));
          endif
        endfor
      endif
    endif
  endfor
endfor
player:notify(tostr("Done spellchecking ", dobj, "."));
.

@verb #90:"@at" any any any rxd
@program #90:@at
"'@at' - Find out where everyone is. '@at <player>' - Find out where <player> is, and who else is there. '@at <obj>' - Find out who else is at the same place as <obj>. '@at <place>' - Find out who is at the place. The place can be given by number, or it can be a name from your @rooms list. '@at #-1' - Find out who is at #-1. '@at me' - Find out who is in the room with you. '@at home' - Find out who is at your home.";
this:internal_at(argstr);
.

@verb #90:"at_players" this none this
@program #90:at_players
"'at_players ()' - Return a list of players to be displayed by @at.";
return connected_players();
.

@verb #90:"do_at_all" this none this
@program #90:do_at_all
"'do_at_all ()' - List where everyone is, sorted by popularity of location. This is called when you type '@at'.";
locations = {};
parties = {};
counts = {};
for who in (this:at_players())
  loc = who.location;
  if (i = loc in locations)
    parties[i] = setadd(parties[i], who);
    counts[i] = counts[i] - 1;
  else
    locations = {@locations, loc};
    parties = {@parties, {who}};
    counts = {@counts, 0};
  endif
endfor
locations = $list_utils:sort(locations, counts);
parties = $list_utils:sort(parties, counts);
this:print_at_items(locations, parties);
.

@verb #90:"do_at" this none this
@program #90:do_at
"'do_at (<location>)' - List the players at a given location.";
loc = args[1];
party = {};
for who in (this:at_players())
  if (who.location == loc)
    party = setadd(party, who);
  endif
endfor
this:print_at_items({loc}, {party});
.

@verb #90:"print_at_items" this none this
@program #90:print_at_items
"'print_at_items (<locations>, <parties>)' - Print a list of locations and people, for @at. Override this if you want to make a change to @at's output that you can't make in :at_item.";
{locations, parties} = args;
for i in [1..length(locations)]
  $command_utils:suspend_if_needed(0);
  player:tell_lines(this:at_item(locations[i], parties[i]));
endfor
.

@verb #90:"at_item" this none this
@program #90:at_item
"'at_item (<location>, <party>)' - Given a location and a list of the people there, return a string displaying the information. Override this if you want to change the format of each line of @at's output.";
{loc, party} = args;
su = $string_utils;
if (this.at_number)
  number = su:right(tostr(loc), 7) + " ";
else
  number = "";
endif
room = su:left(valid(loc) ? loc.name | "[Nowhere]", this.at_room_width);
if (length(room) > this.at_room_width)
  room = room[1..this.at_room_width];
endif
text = (number + room) + " ";
if (party)
  filler = su:space(length(text) - 2);
  line = text;
  text = {};
  for who in (party)
    name = " " + (valid(who) ? who.name | "[Nobody]");
    if ((length(line) + length(name)) > this:linelen())
      text = {@text, line};
      line = filler + name;
    else
      line = line + name;
    endif
  endfor
  text = {@text, line};
else
  text = text + " [deserted]";
endif
return text;
.

@verb #90:"internal_at" this none this
@program #90:internal_at
"'internal_at (<argument string>)' - Perform the function of @at. The argument string is whatever the user typed after @at. This is factored out so that other verbs can call it.";
where = $string_utils:trim(args[1]);
if (where)
  if (where[1] == "#")
    result = toobj(where);
    if ((!valid(result)) && (result != #-1))
      player:tell("That object does not exist.");
      return;
    endif
  else
    result = this:lookup_room(where);
    if (!valid(result))
      result = $string_utils:match_player(where);
      if (!valid(result))
        player:tell("That is neither a player nor a room name.");
        return;
      endif
    endif
  endif
  if (valid(result) && (!$object_utils:isa(result, $room)))
    result = result.location;
  endif
  this:do_at(result);
else
  this:do_at_all();
endif
.

@verb #90:"confunc" this none this rxd #2
@program #90:confunc
"'confunc ()' - Besides the inherited behavior, notify the player's feature objects that the player has connected.";
if ((valid(cp = caller_perms()) && (caller != this)) && (!$perm_utils:controls(cp, this)))
  return E_PERM;
endif
pass(@args);
set_task_perms(this);
for feature in (this.features)
  try
    feature:player_connected(player, @args);
  except (E_VERBNF)
    continue feature;
  except id (ANY)
    player:tell("Feature initialization failure for ", feature, ": ", id[2], ".");
  endtry
endfor
.

@verb #90:"disfunc" this none this rxd #2
@program #90:disfunc
"'disfunc ()' - Besides the inherited behavior, notify the player's feature objects that the player has disconnected.";
if ((valid(cp = caller_perms()) && (caller != this)) && (!$perm_utils:controls(cp, this)))
  return E_PERM;
endif
pass(@args);
"This is forked off to protect :disfunc from buggy :player_disconnected verbs.";
set_task_perms(this);
fork (max(0, $login:current_lag()))
  for feature in (this.features)
    try
      feature:player_disconnected(player, @args);
    except (ANY)
      continue feature;
    endtry
  endfor
endfork
.

@verb #90:"@addword @adddict" any any any rd #2
@program #90:@addword
set_task_perms(player);
if ((verb == "@adddict") && (!((player in $spell.trusted) || player.wizard)))
  player:tell("You may not add to the master dictionary. The following words will instead by put in a list of words to be approved for later addition to the dictionary. Thanks for your contribution.");
endif
if (!argstr)
  player:notify(tostr("Usage: ", verb, " one or more words"));
  player:notify(tostr("       ", verb, " object:verb"));
  player:notify(tostr("       ", verb, " object.prop"));
elseif (data = $spell:get_input(argstr))
  num_learned = 0;
  for i in [1..length(data)]
    line = $string_utils:words(data[i]);
    for ii in [1..length(line)]
      if (seconds_left() < 2)
        suspend(0);
      endif
      if (verb == "@adddict")
        result = $spell:add_word(line[ii]);
        if (result == E_PERM)
          if ($spell:find_exact(line[ii]) == $failed_match)
            player:notify(tostr("Submitted for approval:  ", line[ii]));
            $spell:submit(line[ii]);
          else
            player:notify(tostr("Already in dictionary:  " + line[ii]));
          endif
        elseif (typeof(result) == ERR)
          player:notify(tostr(result));
        elseif (result)
          player:notify(tostr("Word added:  ", line[ii]));
          num_learned = num_learned + 1;
        else
          player:notify(tostr("Already in dictionary:  " + line[ii]));
        endif
      elseif (!$spell:valid(line[ii]))
        player.dict = listappend(player.dict, line[ii]);
        player:notify(tostr("Word added:  ", line[ii]));
        num_learned = num_learned + 1;
      endif
    endfor
  endfor
  player:notify(tostr(num_learned ? num_learned | "No", " word", (num_learned != 1) ? "s " | " ", "added to ", (verb == "@adddict") ? "main " | "personal ", "dictionary."));
endif
.

@verb #90:"@spell @cspell @complete" any any any rd #2
@program #90:@spell
"@spell a word or phrase  -- Spell check a word or phrase.";
"@spell thing.prop  -- Spell check a property. The value must be a string or a list of strings.";
"@spell thing:verb  -- Spell check a verb. Only the quoted strings in the verb are checked.";
"@cspell word  -- Spell check a word, and if it is not in the dictionary, offset suggestions about what the right spelling might be. This actually works with thing.prop and thing:verb too, but it is too slow to be useful--it takes maybe 30 seconds per unknown word.";
"@complete prefix  -- List all the word in the dictionary which begin with the given prefix. For example, `@complete zoo' lists zoo, zoologist, zoology, and zoom.";
"";
"Mr. Spell was written by waffle (waffle@euclid.humboldt.edu), for use by";
"MOOers all over this big green earth. (....and other places....)";
"This monstrosity programmed Sept-Oct 1991, when I should have been studying.";
set_task_perms(player);
if (!argstr)
  if (verb == "@complete")
    player:notify(tostr("Usage: ", verb, " word-prefix"));
  else
    player:notify(tostr("Usage: ", verb, " object.property"));
    player:notify(tostr("       ", verb, " object:verb"));
    player:notify(tostr("       ", verb, " one or more words"));
  endif
elseif (verb == "@complete")
  if ((foo = $string_utils:from_list($spell:sort($spell:find_all(argstr)), " ")) == "")
    player:notify(tostr("No words found that begin with `", argstr, "'"));
  else
    player:notify(tostr(foo));
  endif
else
  "@spell or @cspell.";
  corrected_words = {};
  data = $spell:get_input(argstr);
  if (data)
    misspelling = 0;
    for i in [1..length(data)]
      line = $string_utils:words(data[i]);
      for ii in [1..length(line)]
        $command_utils:suspend_if_needed(0);
        if (!$spell:valid(line[ii]))
          if ((rindex(line[ii], "s") == length(line[ii])) && $spell:valid(line[ii][1..$ - 1]))
            msg = "Possible match: " + line[ii];
            msg = (msg + " ") + ((length(data) != 1) ? ("(line " + tostr(i)) + ")  " | "  ");
          elseif ((rindex(line[ii], "'s") == (length(line[ii]) - 1)) && $spell:valid(line[ii][1..$ - 2]))
            msg = "Possible match: " + line[ii];
            msg = (msg + " ") + ((length(data) != 1) ? ("(line " + tostr(i)) + ")  " | "  ");
          else
            misspelling = misspelling + 1;
            msg = ("Unknown word: " + line[ii]) + ((length(data) != 1) ? (" (line " + tostr(i)) + ")  " | "  ");
            if ((verb == "@cspell") && (!(line[ii] in corrected_words)))
              corrected_words = listappend(corrected_words, line[ii]);
              guesses = $string_utils:from_list($spell:guess_words(line[ii]), " ");
              if (guesses == "")
                msg = msg + "-No guesses";
              else
                msg = msg + "-Possible correct spelling";
                msg = msg + (index(guesses, " ") ? "s: " | ": ");
                msg = msg + guesses;
              endif
            endif
          endif
          player:notify(tostr(msg));
        endif
      endfor
    endfor
    player:notify(tostr("Found ", misspelling ? misspelling | "no", " misspelled word", (misspelling == 1) ? "." | "s."));
  elseif (data != $failed_match)
    player:notify(tostr("Nothing found to spellcheck!"));
  endif
endif
.

@verb #90:"@rmword" any any any rd #2
@program #90:@rmword
set_task_perms(player);
if (argstr in player.dict)
  player.dict = setremove(player.dict, argstr);
  player:notify(tostr("`", argstr, "' removed from personal dictionary."));
else
  player:notify(tostr("`", argstr, "' not found in personal dictionary."));
endif
.

@verb #90:"@rmdict" any any any rd #2
@program #90:@rmdict
set_task_perms(player);
result = $spell:remove_word(argstr);
if (result == E_PERM)
  player:notify("You may not remove words from the main dictionary. Use `@rmword' to remove words from your personal dictionary.");
elseif (typeof(result) == ERR)
  player:notify(tostr(result));
elseif (result)
  player:notify(tostr("`", argstr, "' removed."));
else
  player:notify(tostr("`", argstr, "' not found in dictionary."));
endif
.

@verb #90:"find_property" this none this
@program #90:find_property
"'find_property (<name>)' - Search for a property with the given name. The objects searched are those returned by this:find_properties_on(). The printing order relies on $list_utils:remove_duplicates to leave the *first* copy of each duplicated element in a list; for example, {1, 2, 1} -> {1, 2}, not to {2, 1}.";
name = args[1];
results = "";
objects = $list_utils:remove_duplicates(this:find_properties_on());
for thing in (objects)
  if (valid(thing) && (mom = $object_utils:has_property(thing, name)))
    results = ((((results + "   ") + thing.name) + "(") + tostr(thing)) + ")";
    mom = this:property_inherited_from(thing, name);
    if (thing != mom)
      if (valid(mom))
        results = ((((results + "--") + mom.name) + "(") + tostr(mom)) + ")";
      else
        results = results + "--built-in";
      endif
    endif
  endif
endfor
if (results)
  this:tell("The property .", name, " is on", results);
else
  this:tell("The property .", name, " is nowhere to be found.");
endif
.

@verb #90:"find_verbs_on" this none this
@program #90:find_verbs_on
"'find_verbs_on ()' -> list of objects - Return the objects that @find searches when looking for a verb. The objects are searched (and the results printed) in the order returned. Feature objects are included in the search. Duplicate entries are removed by the caller.";
return {this, this.location, @valid(this.location) ? this.location:contents() | {}, @this:contents(), @this.features};
.

@verb #90:"find_properties_on" this none this
@program #90:find_properties_on
"'find_properties_on ()' -> list of objects - Return the objects that @find searches when looking for a property. The objects are searched (and the results printed) in the order returned. Feature objects are *not* included in the search. Duplicate entries are removed by the caller.";
return {this, this.location, @valid(this.location) ? this.location:contents() | {}, @this:contents()};
.

@verb #90:"property_inherited_from" this none this
@program #90:property_inherited_from
"'property_inherited_from (<object>, <property name>)' -> object - Return the ancestor of <object> on which <object>.<property> is originally defined. If <object>.<property> is not actually defined, return 0. The property is taken as originally defined on the earliest ancestor of <object> which has it. If the property is built-in, return $nothing.";
{what, prop} = args;
if (!$object_utils:has_property(what, prop))
  return 0;
elseif (prop in $code_utils.builtin_props)
  return $nothing;
endif
ancestor = what;
while ($object_utils:has_property(parent(ancestor), prop))
  ancestor = parent(ancestor);
endwhile
return ancestor;
.

@verb #90:"@ref*use" any any any
@program #90:@refuse
"'@refuse <action(s)> [ from <player> ] [ for <time> ]' - Refuse all of a list of one or more actions. If a player is given, refuse actions from the player; otherwise, refuse all actions. If a time is specified, refuse the actions for the given amount of time; otherwise, refuse them for a week. If the actions are already refused, then the only their times are adjusted.";
if (!argstr)
  player:tell("@refuse <action(s)> [ from <player> ] [ for <time> ]");
  return;
endif
stuff = this:parse_refuse_arguments(argstr);
if (stuff)
  if (((typeof(who = stuff[1]) == OBJ) && (who != $nothing)) && (!is_player(who)))
    player:tell("You must give the name of some player.");
  else
    "'stuff' is now in the form {<origin>, <actions>, <duration>}.";
    this:add_refusal(@stuff);
    player:tell("Refusal of ", this:refusal_origin_to_name(stuff[1]), " for ", $time_utils:english_time(stuff[3]), " added.");
  endif
endif
.

@verb #90:"@unref*use @allow" any any any
@program #90:@unrefuse
"'@unrefuse <action(s)> [ from <player> ]' - Stop refusing all of a list of actions. If a player is given, stop refusing actions by the player; otherwise, stop refusing all actions of the given kinds. '@unrefuse everything' - Remove all refusals.";
if (argstr == "everything")
  if ($command_utils:yes_or_no("Do you really want to erase all your refusals?"))
    this:clear_refusals();
    player:tell("OK, they are gone.");
  else
    player:tell("OK, no harm done.");
  endif
  return;
endif
stuff = this:parse_refuse_arguments(argstr);
if (!stuff)
  return;
endif
"'stuff' is now in the form {<origin>, <actions>, <duration>}.";
origins = stuff[1];
actions = stuff[2];
if (typeof(origins) != LIST)
  origins = {origins};
endif
n = 0;
for origin in (origins)
  n = n + this:remove_refusal(origin, actions);
endfor
plural = ((n == 1) && (length(origins) == 1)) ? "" | "s";
if (n)
  player:tell("Refusal", plural, " removed.");
else
  player:tell("You have no such refusal", plural, ".");
endif
.

@verb #90:"@refusals" none any any
@program #90:@refusals
"'@refusals' - List your refusals. '@refusals for <player>' - List the given player's refusals.";
if (iobjstr)
  who = $string_utils:match_player(iobjstr);
  if ($command_utils:player_match_failed(who, iobjstr))
    return;
  endif
  if (!$object_utils:has_verb(who, "refusals_text"))
    player:tell("That player does not have the refusal facility.");
    return;
  endif
else
  who = player;
endif
who:remove_expired_refusals();
player:tell_lines(this:refusals_text(who));
.

@verb #90:"@refusal-r*eporting" any any any
@program #90:@refusal-reporting
"'@refusal-reporting' - See if refusal reporting is on. '@refusal-reporting on', '@refusal-reporting off' - Turn it on or off..";
if (!argstr)
  player:tell("Refusal reporting is ", this.report_refusal ? "on" | "off", ".");
elseif (argstr in {"on", "yes", "y", "1"})
  this.report_refusal = 1;
  player:tell("Refusals will be reported to you as they happen.");
elseif (argstr in {"off", "no", "n", "0"})
  this.report_refusal = 0;
  player:tell("Refusals will happen silently.");
else
  player:tell("@refusal-reporting on     - turn on refusal reporting");
  player:tell("@refusal-reporting off    - turn it off");
  player:tell("@refusal-reporting        - see if it's on or off");
endif
.

@verb #90:"parse_refuse_arguments" this none this
@program #90:parse_refuse_arguments
"'parse_refuse_arguments (<string>)' -> {<who>, <actions>, <duration>} - Parse the arguments of a @refuse or @unrefuse command. <who> is the player requested, or $nothing if none was. <actions> is a list of the actions asked for. <duration> is how long the refusal should last, or 0 if no expiration is given. <errors> is a list of actions (or other words) which are wrong. If there are any errors, this prints an error message and returns 0.";
words = $string_utils:explode(args[1]);
possible_actions = this:refusable_actions();
who = $nothing;
actions = {};
until = this.default_refusal_time;
errors = {};
skip_to = 0;
for i in [1..length(words)]
  word = words[i];
  if (i <= skip_to)
  elseif (which = $string_utils:find_prefix(word, possible_actions))
    actions = setadd(actions, possible_actions[which]);
  elseif ((word[$] == "s") && (which = $string_utils:find_prefix(word[1..$ - 1], possible_actions)))
    "The word seems to be the plural of an action.";
    actions = setadd(actions, possible_actions[which]);
  elseif (results = this:translate_refusal_synonym(word))
    actions = $set_utils:union(actions, results);
  elseif ((word == "from") && (i < length(words)))
    "Modified to allow refusals from all guests at once. 5-27-94, Gelfin";
    if (words[i + 1] == "guests")
      who = "all guests";
    elseif (!(typeof(who = $code_utils:toobj(words[i + 1])) == OBJ))
      who = $string_utils:match_player(words[i + 1]);
      if ($command_utils:player_match_failed(who, words[i + 1]))
        return 0;
      endif
    endif
    skip_to = i + 1;
  elseif ((word == "for") && (i < length(words)))
    n_words = this:parse_time_length(words[i + 1..$]);
    until = this:parse_time(words[i + 1..i + n_words]);
    if (!until)
      return 0;
    endif
    skip_to = i + n_words;
  else
    errors = {@errors, word};
  endif
endfor
if (errors)
  player:tell((length(errors) > 1) ? "These parts of the command were not understood: " | "This part of the command was not understood: ", $string_utils:english_list(errors, 0, " ", " ", " "));
  return 0;
endif
return {this:player_to_refusal_origin(who), actions, until};
.

@verb #90:"time_word_to_seconds" this none this
@program #90:time_word_to_seconds
"'time_word_to_seconds (<string>)' - The <string> is expected to be a time word, 'second', 'minute', 'hour', 'day', 'week', or 'month'. Return the number of seconds in that amount of time (a month is taken to be 30 days). If <string> is not a time word, return 0. This is used both as a test of whether a word is a time word and as a converter.";
return $time_utils:parse_english_time_interval("1", args[1]);
.

@verb #90:"parse_time_length" this none this
@program #90:parse_time_length
"'parse_time_length (<words>)' -> n - Given a list of words which is expected to begin with a time expression, return how many of them belong to the time expression. A time expression can be a positive integer, a time word, or a positive integer followed by a time word. A time word is anything that this:time_word_to_seconds this is one. The return value is 0, 1, or 2.";
words = {@args[1], "dummy"};
n = 0;
if (toint(words[1]) || this:time_word_to_seconds(words[1]))
  n = 1;
endif
if (this:time_word_to_seconds(words[n + 1]))
  n = n + 1;
endif
return n;
.

@verb #90:"parse_time" this none this
@program #90:parse_time
"'parse_time (<words>)' -> <seconds> - Given a list of zero or more words, either empty or a valid time expression, return the number of seconds that the time expression refers to. This is a duration, not an absolute time.";
words = args[1];
"If the list is empty, return the default refusal time.";
if (!words)
  return this.default_refusal_time;
endif
"If the list has one word, either <units> or <n>.";
"If it is a unit, like 'hour', return the time for 1 <unit>.";
"If it is a number, return the time for <n> days.";
if (length(words) == 1)
  return this:time_word_to_seconds(words[1]) || (toint(words[1]) * this:time_word_to_seconds("days"));
endif
"The list must contain two words, <n> <units>.";
return toint(words[1]) * this:time_word_to_seconds(words[2]);
.

@verb #90:"clear_refusals" this none this
@program #90:clear_refusals
"'clear_refusals ()' - Erase all of this player's refusals.";
if ((caller != this) && (!$perm_utils:controls(caller_perms(), this)))
  return E_PERM;
endif
this.refused_origins = {};
this.refused_actions = {};
this.refused_until = {};
this.refused_extra = {};
.

@verb #90:"set_default_refusal_time" this none this
@program #90:set_default_refusal_time
"'set_default_refusal_time (<seconds>)' - Set the length of time that a refusal lasts if its duration isn't specified.";
if ((caller != this) && (!$perm_utils:controls(caller_perms(), this)))
  return E_PERM;
endif
this.default_refusal_time = toint(args[1]);
.

@verb #90:"refusable_actions" this none this
@program #90:refusable_actions
"'refusable_actions ()' -> {'page', 'whisper', ...} - Return a list of the actions that can be refused. This is a verb, rather than a property, so that it can be inherited properly. If you override this verb to add new refusable actions, write something like 'return {@pass (), 'action1', 'action2', ...}'. That way people can add new refusable actions at any level of the player class hierarchy, without clobbering any that were added higher up.";
return {"page", "whisper", "move", "join", "accept", "mail"};
.

@verb #90:"translate_refusal_synonym" this none this
@program #90:translate_refusal_synonym
"'translate_refusal_synonym (<word>)' -> list - If the <word> is a synonym for some set of refusals, return the list of those refusals. Otherwise return the empty list, {}. Programmers can override this verb to provide more synonyms.";
word = args[1];
if (word == "all")
  return this:refusable_actions();
endif
return {};
.

@verb #90:"default_refusals_text_filter" this none this
@program #90:default_refusals_text_filter
"'default_refusals_text_filter (<origin>, <actions>)' - Return any actions by this <origin> which should be included in the text returned by :refusals_text. This is the default filter, which includes all actions.";
return args[2];
.

@verb #90:"refusals_text" this none this
@program #90:refusals_text
"'refusals_text (<player>, [<filter verb name>])' - Return text describing the given player's refusals. The filter verb name is optional; if it is given, this verb takes an origin and a list of actions and returns any actions which should be included in the refusals text. This verb works only if <player> is a player who has the refusals facility; it does not check for this itself.";
{who, ?filter_verb = "default_refusals_text_filter"} = args;
text = {};
for i in [1..length(who.refused_origins)]
  origin = who.refused_origins[i];
  actions = this:(filter_verb)(origin, who.refused_actions[i]);
  if (actions)
    line = "";
    for action in (actions)
      line = (line + " ") + action;
    endfor
    line = (this:refusal_origin_to_name(origin) + ": ") + line;
    line = (ctime(who.refused_until[i]) + " ") + line;
    text = {@text, line};
  endif
endfor
if (!text)
  text = {"No refusals."};
endif
return text;
.

@verb #90:"player_to_refusal_origin" this none this
@program #90:player_to_refusal_origin
"'player_to_refusal_origin (<player>)' -> <origin> - Convert a player to a unique identifier called the player's 'refusal origin'. For most players, it's just their object number. For guests, it is a hash of the site they are connecting from. Converting an origin to an origin is a safe no-op--the code relies on this.";
who = args[1];
if ((((typeof(who) == OBJ) && valid(who)) && (parent(who) == $object_utils:has_property($local, "guest"))) ? $local.guest | $guest)
  return who:connection_name_hash("xx");
else
  return who;
endif
.

@verb #90:"refusal_origin_to_name" this none this
@program #90:refusal_origin_to_name
"'refusal_origin_to_name (<origin>)' -> string - Convert a refusal origin to a name.";
origin = args[1];
if (origin in {"all guests", "everybody"})
  return origin;
elseif (typeof(origin) != OBJ)
  return "a certain guest";
elseif (origin == #-1)
  return "Everybody";
else
  return $string_utils:name_and_number(origin);
endif
.

@verb #90:"check_refusal_actions" this none this
@program #90:check_refusal_actions
"'check_refusal_actions (<actions>)' - Check a list of refusal actions, and return whether they are all legal.";
actions = args[1];
legal_actions = this:refusable_actions();
for action in (actions)
  if (!(action in legal_actions))
    return 0;
  endif
endfor
return 1;
.

@verb #90:"add_refusal" this none this
@program #90:add_refusal
"'add_refusal (<origin>, <actions> [, <duration> [, <extra>]])' - Add refusal(s) to this player's list. <Actions> is a list of the actions to be refused. The list should contain only actions, no synonyms. <Origin> is the actor whose actions are to be refused. <Until> is the time that the actions are being refused until, in the form returned by time(). It is optional; if it's not given, it defaults to .default_refusal_time. <Extra> is any extra information; it can be used for comments, or to make finer distinctions about the actions being refused, or whatever. If it is not given, it defaults to 0. The extra information is per-action; that is, it is stored separately for each action that it applies to.";
if (caller != this)
  return E_PERM;
endif
{orig, actions, ?duration = this.default_refusal_time, ?extra = 0} = args;
origins = this:player_to_refusal_origin(orig);
if (typeof(origins) != LIST)
  origins = {origins};
endif
if (typeof(actions) != LIST)
  actions = {actions};
endif
if (!this:check_refusal_actions(actions))
  return E_INVARG;
endif
until = time() + duration;
for origin in (origins)
  if (i = origin in this.refused_origins)
    this.refused_until[i] = until;
    for action in (actions)
      if (j = action in this.refused_actions[i])
        this.refused_extra[i][j] = extra;
      else
        this.refused_actions[i] = {@this.refused_actions[i], action};
        this.refused_extra[i] = {@this.refused_extra[i], extra};
      endif
    endfor
  else
    this.refused_origins = {@this.refused_origins, origin};
    this.refused_actions = {@this.refused_actions, actions};
    this.refused_until = {@this.refused_until, until};
    this.refused_extra = {@this.refused_extra, $list_utils:make(length(actions), extra)};
  endif
endfor
.

@verb #90:"remove_refusal" this none this
@program #90:remove_refusal
"'remove_refusal (<origin>, <actions>)' - Remove any refused <actions> by <origin>. The <actions> list should contain only actions, no synonyms. Return the number of such refusals found (0 if none).";
if (caller != this)
  return E_PERM;
endif
{origin, actions} = args;
if (typeof(actions) != LIST)
  actions = {actions};
endif
count = 0;
i = origin in this.refused_origins;
if (i)
  for action in (actions)
    if (j = action in this.refused_actions[i])
      this.refused_actions[i] = listdelete(this.refused_actions[i], j);
      this.refused_extra[i] = listdelete(this.refused_extra[i], j);
      count = count + 1;
    endif
  endfor
  if (!this.refused_actions[i])
    this.refused_origins = listdelete(this.refused_origins, i);
    this.refused_actions = listdelete(this.refused_actions, i);
    this.refused_until = listdelete(this.refused_until, i);
    this.refused_extra = listdelete(this.refused_extra, i);
  endif
endif
return count;
.

@verb #90:"remove_expired_refusals" this none this
@program #90:remove_expired_refusals
"'remove_expired_refusals ()' - Remove refusal entries which are past their time limits.";
origins = {};
"Before removing any refusals, figure out which ones to remove. Removing one changes the indices and invalidates the loop invariant.";
for i in [1..length(this.refused_origins)]
  if (time() >= this.refused_until[i])
    origins = {@origins, this.refused_origins[i]};
  endif
endfor
for origin in (origins)
  this:remove_refusal(origin, this:refusable_actions());
endfor
.

@verb #90:"refuses_action" this none this
@program #90:refuses_action
"'refuses_action (<origin>, <action>, ...)' - Return whether this object refuses the given <action> by <origin>. <Origin> is typically a player. Extra arguments after <origin>, if any, are used to further describe the action.";
"Modified by Diopter (#98842) at LambdaMOO";
{origin, action, @extra_args} = args;
extra_args = {origin, @extra_args};
rorigin = this:player_to_refusal_origin(origin);
if (((which = rorigin in this.refused_origins) && (action in this.refused_actions[which])) && this:("refuses_action_" + action)(which, @extra_args))
  return 1;
elseif (((((typeof(rorigin) == OBJ) && valid(rorigin)) && (which = rorigin.owner in this.refused_origins)) && (action in this.refused_actions[which])) && this:("refuses_action_" + action)(which, @extra_args))
  return 1;
elseif ((((which = $nothing in this.refused_origins) && (rorigin != this)) && (action in this.refused_actions[which])) && this:("refuses_action_" + action)(which, @extra_args))
  return 1;
elseif ((((which = "all guests" in this.refused_origins) && $object_utils:isa(origin, $guest)) && (action in this.refused_actions[which])) && this:("refuses_action_" + action)(which, @extra_args))
  return 1;
endif
return 0;
.

@verb #90:"refuses_action_*" this none this
@program #90:refuses_action_
"'refuses_action_* (<which>, <origin>, ...)' - The action (such as 'whisper' for the verb :refuses_action_whisper) is being considered for refusal. Return whether the action should really be refused. <Which> is an index into this.refused_origins. By default, always refuse non-outdated actions that get this far.";
{which, @junk} = args;
if (time() >= this.refused_until[which])
  fork (0)
    "This <origin> is no longer refused. Remove any outdated refusals.";
    this:remove_expired_refusals();
  endfork
  return 0;
else
  return 1;
endif
.

@verb #90:"report_refusal" this none this
@program #90:report_refusal
"'report_refusal (<player>, <message>, ...)' - If refusal reporting is turned on, print the given <message> to report the refusal of some action by <player>. The message may take more than one argument. You can override this verb to do more selective reporting.";
if (this.report_refusal)
  this:tell(@listdelete(args, 1));
endif
.

@verb #90:"wh*isper" any to this rxd
@program #90:whisper
"'whisper <message> to <this player>' - Whisper a message to this player which nobody else can see.";
if (this:refuses_action(player, "whisper"))
  player:tell(this:whisper_refused_msg());
  this:report_refusal(player, "You just refused a whisper from ", player.name, ".");
else
  pass(@args);
endif
.

@verb #90:"receive_page" this none this
@program #90:receive_page
"'receive_page (<message>)' - Receive a page. If the page is accepted, pass(@args) shows it to the player.";
if (this:refuses_action(player, "page"))
  this.page_refused = task_id();
  return 0;
endif
this.page_refused = 0;
return pass(@args);
.

@verb #90:"page_echo_msg" this none this
@program #90:page_echo_msg
"'page_echo_msg ()' - Return a message to inform the pager what happened to their page.";
if (task_id() == this.page_refused)
  this:report_refusal(player, "You just refused a page from ", player.name, ".");
  return this:page_refused_msg();
else
  return pass(@args);
endif
.

@verb #90:"moveto acceptable" this none this rxd #2
@program #90:moveto
"'moveto (<destination>)', 'accept (<object>)' - Check whether this :moveto or :accept is allowed or refused. If it is allowed, do it. This code is slightly modified from an original verb by Grump.  Upgraded by Bits to account for forthcoming 1.8.0 behavior of callers().";
by = callers();
"Ignore all the verbs on this.";
while (((y = by[1])[1] == this) && (y[2] == verb))
  by = listdelete(by, 1);
endwhile
act = (verb == "moveto") ? "move" | "accept";
if ((player != this) && this:refuses_action(player, act, args[1]))
  "check player";
  return 0;
endif
last = #-1;
for k in (by)
  if ((((perms = k[3]) == #-1) && (k[2] != "")) && (k[1] == #-1))
  elseif ((!perms.wizard) && (perms != this))
    if (perms != last)
      "check for possible malicious programmer";
      if (this:refuses_action(perms, act, args[1]))
        return 0;
      endif
      last = perms;
    endif
  endif
endfor
return pass(@args);
.

@verb #90:"receive_message" this none this
@program #90:receive_message
"'receive_message (<message>, <sender>)' - Receive the given mail message from the given sender. This version handles refusal of the message.";
if ((!$perm_utils:controls(caller_perms(), this)) && (caller != this))
  return E_PERM;
elseif (this:refuses_action(args[2], "mail"))
  return this:mail_refused_msg();
else
  return pass(@args);
endif
.

@verb #90:"whisper_refused_msg page_refused_msg mail_refused_msg" this none this
@program #90:whisper_refused_msg
"'whisper_refused_msg()', 'page_refused_msg()', etc. - Return a message string.";
return $string_utils:pronoun_sub(this.(verb), this);
.

@verb #90:"last_huh" this none this rxd #2
@program #90:last_huh
set_task_perms(caller_perms());
if (pass(@args))
  return 1;
endif
{verb, args} = args;
if (valid(dobj = $string_utils:literal_object(dobjstr)) && (r = $match_utils:match_verb(verb, dobj, args)))
  return r;
elseif (valid(iobj = $string_utils:literal_object(iobjstr)) && (r = $match_utils:match_verb(verb, iobj, args)))
  return r;
else
  return 0;
endif
.

@verb #90:"ping_features" this none this rxd #2
@program #90:ping_features
":ping_features()";
" -- cleans up the .features list to remove !valid objects";
" ==> cleaned-up .features list";
features = this.features;
for x in (features)
  if (!$recycler:valid(x))
    features = setremove(features, x);
  endif
endfor
return this.features = features;
.

@verb #90:"set_owned_objects" this none this rxd #2
@program #90:set_owned_objects
":set_owned_objects( LIST owned-objects list )";
"  -- set your .owned_objects, ordered as you please";
"  -- no, it will NOT let you set to to anything you want";
if ((caller == this) || $perm_utils:controls(caller_perms(), this))
  new = args[1];
  old = this.owned_objects;
  "make sure they're the same";
  if (length(new) != length(old))
    return E_INVARG;
  endif
  for i in (new)
    old = setremove(old, i);
  endfor
  if (old)
    "something's funky";
    return E_INVARG;
  endif
  return this.owned_objects = new;
else
  return E_PERM;
endif
.

@verb #90:"init_for_core" this none this rxd #2
@program #90:init_for_core
if (caller_perms().wizard)
  pass();
  if ($code_utils:verb_location() == this)
    this.rooms = {};
  else
    clear_property(this, "rooms");
  endif
  this.features = {$pasting_feature, $stage_talk};
endif
.

"***finished***
