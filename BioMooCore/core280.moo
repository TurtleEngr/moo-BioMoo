$Header: /repo/public.cvs/app/BioGate/BioMooCore/core280.moo,v 1.1 2021/07/27 06:44:30 bruce Exp $

>@dump #280 with create
@create $command_utils_core named command utils (user):command utils (user)
;;#280.("feature_task") = {1789409464, "out", {}, "", #-1, "", "", #-1, ""}
;;#280.("help_msg") = {"$command_utils is the repository for verbs that are of general usefulness to authors of all sorts of commands.  For more details about any of these verbs, use `help $command_utils:<verb-name>'.", "", "Detecting and Handling Failures in Matching", "-------------------------------------------", ":object_match_failed(match_result, name)", "    Test whether or not a :match_object() call failed and print messages if so.", ":player_match_failed(match_result, name)", "    Test whether or not a :match_player() call failed and print messages if so.", ":player_match_result(match_results, names)", "    ...similar to :player_match_failed, but does a whole list at once.", "", "Reading Input from the Player", "-----------------------------", ":read()         -- Read one line of input from the player and return it.", ":yes_or_no([prompt])", "                -- Prompt for and read a `yes' or `no' answer.", ":read_lines()   -- Read zero or more lines of input from the player.", ":dump_lines(lines) ", "                -- Return list of lines quoted so that feeding them to ", "                   :read_lines() will reproduce the original lines.", ":read_lines_escape(escapes[,help])", "                -- Like read_lines, except you can provide more escapes", "                   to terminate the read.", "", "Utilities for Suspending", "------------------------", ":running_out_of_time()", "                -- Return true if we're low on ticks or seconds.", ":suspend_if_needed(time)", "                -- Suspend (and return true) if we're running out of time.", "", "Client Support for Lengthy Commands", "-----------------------------------", ":suspend(args)  -- Handle PREFIX and SUFFIX for clients in long commands."}
;;#280.("aliases") = {"command utils (user)"}
;;#280.("description") = {"This is the command utilities utility package.  See `help $command_utils' for more details."}
;;#280.("object_size") = {1977, 1577149628}

@verb #280:"do_huh" this none this rx
@program #280:do_huh
"Copied from command utilities (#56):do_huh by Wizard (#2) Mon Nov 24 15:12:21 1997 PST";
":do_huh(verb,args)  what :huh should do by default.";
{verb, args} = args;
this.feature_task = {task_id(), verb, args, argstr, dobj, dobjstr, prepstr, iobj, iobjstr};
set_task_perms(cp = caller_perms());
notify = $perm_utils:controls(cp, player) ? "notify" | "tell";
if (player:my_huh(verb, args))
  "... the player found something funky to do ...";
elseif (caller:here_huh(verb, args))
  "... the room found something funky to do ...";
elseif (player:last_huh(verb, args))
  "... player's second round found something to do ...";
elseif (dobj == $ambiguous_match)
  if (iobj == $ambiguous_match)
    player:(notify)(tostr("I don't understand that (\"", dobjstr, "\" and \"", iobjstr, "\" are both ambiguous names)."));
  else
    player:(notify)(tostr("I don't understand that (\"", dobjstr, "\" is an ambiguous name)."));
  endif
elseif (iobj == $ambiguous_match)
  player:(notify)(tostr("I don't understand that (\"", iobjstr, "\" is an ambiguous name)."));
else
  "Handle stray text";
  if (((verb[1] != "@") && $object_utils:has_callable_verb(player.location, "say")) && (!(player in {#177, #179})))
    argstr = (verb + (argstr ? " " | "")) + argstr;
    player.location:say(verb);
  else
    player:(notify)("I don't understand that.  For help, type: help");
    player:my_explain_syntax(caller, verb, args) || (caller:here_explain_syntax(caller, verb, args) || this:explain_syntax(caller, verb, args));
  endif
endif
.

"***finished***
