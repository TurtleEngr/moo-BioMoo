$Header: /repo/public.cvs/app/BioGate/BioMooCore/core44.moo,v 1.1 2021/07/27 06:44:32 bruce Exp $

>@dump #44 with create
@create $generic_help named Editor Help:Editor Help
@prop #44."summary" {} rc
;;#44.("summary") = {"You are inside an editor.  Do", "", "look          -- for list of commands", "what          -- to find out what you're editing.", "list          -- to list out some portion of the text", "say / emote   -- to add new text to whatever you're editing", "", "help edit-index -- for a full list of editor help topics", "help editors    -- for a general discussion about editors", "help moo        -- for the general MOO help summary (i.e., what you get by ", "                   typing `help' with no arguments from outside the editor)."}
@prop #44."edit-index" {} rc
;;#44.("edit-index") = {"*index*", "Editor Help Topics"}
@prop #44."emote" {} rc
;;#44.("emote") = {"Syntax: emote <text>", "        :<text>", "", "(EDITOR)", "Appends <text> to the end of the line before the insertion point.", "The second form is equivalent to the first except that it doesn't strip leading blanks off of <text> (just as with the normal `emote' and `:' commands).", "The insertion point is left unmoved.", "", "    >list .", "    _37_ Hello there", "    ^38^ Oh, I'm fine.", "    >:, how are you", "    Appended to line 37.", "    >:?", "    Appended to line 37.", "    >list .", "    _37_ Hello there, how are you?", "    ^38^ Oh, I'm fine.", ""}
@prop #44."say" {} rc
;;#44.("say") = {"Syntax: say <text>", "        \"<text>", "", "(EDITOR)", "Adds <text> to whatever you are editing.", "The second form is equivalent to the first except in that it doesn't strip leading blanks off of <text> (just as with the normal `say' and `\"' commands).", "", "The added text appears as a new line at the insertion point.  The insertion point, in turn, gets moved so as to be after the added text.  For example:", "", "    >\"first line", "    Line 1 added.", "    >\"  second line\"", "    Line 2 added.", "    >list", "      1: first line", "    __2_   second line\"", "    ^^^^"}
@prop #44."delete" {} rc
;;#44.("delete") = {"Syntax:  del*ete [<range>] ", "", "(EDITOR)", "Deletes the specified range of lines", "<range> defaults to the line *before* the current insertion point."}
@prop #44."insert" {} rc
;;#44.("insert") = {"Syntax:  ins*ert [<ins>] [\"<text>]", "         .                    (`.' == `insert' without arguments)", "", "(EDITOR)", "Many editor commands refer to an \"insertion point\" which is (usually) the place right below where the most recent line was inserted.  The insertion point should really be thought of as sitting *between* lines.  In listings, the line above the insertion point is marked with `_' while the one below is marked with `^'.", "", "The `insert' command, when given an argument, sets the insertion point.", "If <text> is provided, a new line will be created and inserted as with `say'.", "<ins>, both here and in other commands that require specifying an insertion point (e.g., copy/move), can be one of", "          ", "    ^n   above line n", "     n   above line n", "    _n   below line n", "     $   at the end", "    ^$   before the last line", "   n^$   n lines before the end", "     .   the current insertion point  (i.e., `insert .' is a no-op)", "    +n   n lines below the current insertion point.", "    -n   n lines above the current insertion point.", "", "For the truly perverse, there are other combinations that also work due to artifacts of the parsing process, but these might go away..."}
@prop #44."view" {} rc
;;#44.("view") = {"Syntax:  view <player> [<range>] [nonum]", "         view", "", "Prints some subset of the specified player's text.", "Said player must have previously made his text readable with `publish'.", "<ranges> are specified as in other commands (see `help ranges').", "References to the insertion point refer to wherever the other player has set his/her insertion point; you have no control over it.", "The default range is as in list.", "", "If no arguments are given, this lists all of the players that have published anything in this editor."}
@prop #44."depublish" {} rc
;;#44.("depublish") = {"*forward*", "unpublish"}
@prop #44."perish" {} rc
;;#44.("perish") = {"*forward*", "unpublish"}
@prop #44."unpublish" {} rc
;;#44.("unpublish") = {"Syntax:  unpub*lish", "         depub*lish", "         perish", "", "This command reverses the effects of `publish', making your text readable only by you."}
@prop #44."publish" {} rc
;;#44.("publish") = {"Syntax:  pub*lish", "", "By default, only you (and wizards) can read the text you are editing.", "This command makes your text readable by the entire world (see `help view').", "This is useful if you need help from someone or if you just want to show off your programming acumen.", "Use `unpublish' to make your text private again."}
@prop #44."mode" {} rc
;;#44.("mode") = {"(NOTE EDITOR)", "Syntax:  mode", "         mode string", "         mode list", "         ", "There are (currently) two modes the note editor can be in.", "One is string mode, in which if the text being edited is one line or less, ", "it will be saved as a single string (or an empty string) rather than as a list.", "The other is list mode, in which text is always saved as a list of strings.", "The mode is set when the text is first loaded (string mode if the text is a string, list mode otherwise), but can be changed using this command.", "", "The first form above (i.e., without any arguments) reports the current mode."}
@prop #44."enter" {} rc
;;#44.("enter") = {"Syntax:  enter", "", "(EDITOR)", "Enters a sequence of lines at the insertion point (see `help insert').", "This is similar to .program in that every line you type after the `enter' command is inserted verbatim into the text until you type a line with a single period (`.') on it.  This command is essentially for if you don't like the idea of putting \" at the beginning of each line you type.  The only exceptions, i.e., lines that are not entered verbatim (aside from the `.' line), are", "", " - If you type a line whose sole text is `@abort', ", "   that aborts this command without making any changes to the text.  ", " - Any line whose first nonblank character is `.' and has additional text", "   is entered but with its first `.' stripped off.  ", "", "Thus, to enter a line whose text is `@abort', you could enter it as `.@abort'."}
@prop #44."quit" {} rc
;;#44.("quit") = {"Syntax:  q*uit", "         done", "         pause  ", "", "(EDITOR)", "Leaves the editor.  If you have unsaved text it will be there when you return (and in fact you will not be able to do anything else with this editor until you 'abort' or save the text).", ""}
@prop #44."unsubscribe" {} rc
;;#44.("unsubscribe") = {"Syntax: unsubscribe from <list-name>", "        unsubscribe <name>... from <list-name>", "", "(MAILROOM)", "Remove yourself from the given mailing list.", "The second form removes arbitrary people from a mailing list.", "You can only do this if you own whatever is being removed or you own the list.", "", "Use the `who' command to determine if you are on a given mailing list."}
@prop #44."subscribe" {} rc
;;#44.("subscribe") = {"Syntax: subscribe to <list-name>", "        subscribe [<name>...] to <list-name>", "", "(MAILROOM)", "Add yourself to the given mailing list.  ", "The second form adds arbitrary people to a mailing list.", "You can only do this if you own the list or if it is listed as [Public] and you own whatever is being added.", "", "The first form of this command is probably obsolete since if <list-name> is public, you can already read it via `@mail on *<list-name>' and it's much better for the MOO if you do so.  `@mail-option +sticky' makes this even easier.", "", "Use the `who' command to determine if you are on a given mailing list."}
@prop #44."reply-to" {} rc
;;#44.("reply-to") = {"Syntax:  reply-to [<recipients>]", "", "(MAIL ROOM)", "Reports the current contents of the Reply-to: field of your message.", "With arguments, adds (or changes) the Reply-to: field.", "", "When someone @answers a message, the Reply-to: field is checked first when determining to whom the reply should be sent --- see `help @answer'.", "", "To clear the Reply-to: field, do", "", "         reply-to \"\""}
@prop #44."moo" {} rc
;;#44.("moo") = {"*pass*", ""}
@prop #44."find" {} rc
;;#44.("find") = {"Syntax:  f*ind  /<str>[/[c][<ins>]]", "         /<str>[/[c][<ins>]]", "", "Searches for the first line after <ins> containing <str>.  <ins> defaults to  the current insertion point (see `help insert' for how to specify other places).  With the first form, any character (not just `/') may be used as a delimiter.", "For the second form, you must use '/'.", "", "The 'c' flag, if given, indicates that case is to be ignored while searching.", "", "[Bug: With the second form, there are problems if the search string contains quotes, backslashes or a run of spaces.  The first whitespace will always be treated as a single space.  Likewise, quotes and backslashes occuring in the first word of the command (i.e., the \"verb\") need to be escaped with `\\'.  Unfortunately it will not be possible to fix this until we get a new command parser.]"}
@prop #44."edit" {} rc
;;#44.("edit") = {"(VERB EDITOR)", "Syntax:  edit <object>:<verb>", "", "Changes what verb you are editing and loads the code for that verb", "into the editor. ", "Equivalent to @edit <object>:<verb>.", "", "(NOTE EDITOR)", "Syntax:  edit <note-object>", "         edit <object>.<property>", "", "Changes to a different note or a different object text property and ", "loads its text into the editor.", "These are equivalent to @notedit <note> or @notedit <object>.<property>", "respectively.", "", "For both the verb-editor and note-editor commands, <object> will match on the room you came from, though if the room you came from was another editor, then all bets are off..."}
@prop #44."compile" {} rc
;;#44.("compile") = {"Syntax:  compile [as <object>:<verb>]", "", "(VERB EDITOR)", "Installs the new program into the system if there are no syntax errors.", "If a new object:verb is specified and actually turns out to exist, that <object>:<verb> becomes the default for subsequent compilations."}
@prop #44."save" {} rc
;;#44.("save") = {"Syntax:  save [<note-object>]", "         save [<object>.<property>]", "", "(NOTE EDITOR)", "Installs the freshly edited text.  If <note> or <object>.<property> is specified, text is installed on that note or property instead of the original one.  In addition the new note or property becomes the default for future save commands."}
@prop #44."showlists" {} rc
;;#44.("showlists") = {"Syntax:  showlists", "", "(MAIL ROOM)", "Print a list of the publically available mailing lists/archives and other non-player entities that can receive mail."}
@prop #44."subject" {} rc
;;#44.("subject") = {"Syntax:  subj*ect [<text>]", "", "(MAIL ROOM)", "Specifies a Subject: line for your message.  If <text> is \"\", the Subject: line is removed."}
@prop #44."to" {} rc
;;#44.("to") = {"Syntax:  to [<recipients>]", "", "(MAIL ROOM)", "Specifies a new set of recipients (the To: line) for your message.", "Recipient names not beginning with * are matched against the list of players.", "Recipient names beginning with * are interpreted as mailing-lists/archives/other types of non-person addresses and are matched against all such publically available objects (see `help showlists').  If the list you want to use isn't in the database (i.e., isn't located in the database ($mail_agent)) you need to refer to it by object id."}
@prop #44."also-to" {} rc
;;#44.("also-to") = {"Syntax:  also-to [<recipients>]", "", "Synonym: cc", "", "(MAIL ROOM)", "Adds additional recipients to the To: line of your message.", "Same rules apply as for the `to' command."}
@prop #44."who" {} rc
;;#44.("who") = {"Syntax:  who ", "         who <rcpt>...", "", "(MAIL ROOM)", "Invokes $mail_agent's mail-forwarding tracer and determines who (or what) is actually going to receive your message.  The resulting list will not include destinations that will simply forward the message without :receive_message()'ing a copy for themselves.", "", "The second form expands an arbitrary list of recipients, for if e.g., you're curious about the members of particular mailing list."}
@prop #44."print" {} rc
;;#44.("print") = {"Syntax:  pri*nt", "", "Display your text without line numbers.", "", "(MAIL ROOM)", "Display your message including headers."}
@prop #44."send" {} rc
;;#44.("send") = {"Syntax:  send", "", "(MAIL ROOM)", "Send the message, then exit the mail room if all of the addresses on the To: line turn out to be valid and usable (you can use the `who' command to check these in advance, though the status of recipients may change without warning).", "If the To: line turns out to contain invalid recipients or recipients that are not usable by you, the message will not be sent and you will remain in the mail room.", "It may be, however, that valid addresses on your To: line will forward to other addresses that are bogus; you'll receive warnings about these, but in this case your message will still be delivered to those addresses that are valid.", "", "Note that there may be particularly long delays when sending to recipients with large forwarding/notification lists or when sending on occasions when the MOO is heavily loaded in general.  In such a case, it is possible to continue editing the message while the send is in progress; any such edits affect only the text in the editor.  In particular, the text of the message currently being sent remains as it was when you first typed the send command.  However, any editing will mark the text as \"changed\" meaning that you will need to explicitly `abort' or `quit' in order to leave the mail room even if the send concludes successfully."}
@prop #44."list" {} rc
;;#44.("list") = {"Syntax:  lis*t [<range>] [nonum]", "", "Prints some subset of the current verb text.", "The default range is some reasonable collection of lines around the current insertion point:  currently this is 8_-8^, ie., 8 lines above the insertion point to 8 lines below it unless this runs up against the beginning or end of file, in which case we just take the first or last 16 lines, or just 1-$ if there aren't that many.  (See `help ranges' for how to specify line numbers and ranges.)", "", "`nonum' prints without line numbers.", "", "Yes, window heights will be customizable some day."}
@prop #44."next" {} rc
;;#44.("next") = {"Syntax:  n*ext [n] [\"<text>]", "", "Moves the insertion point down n lines.  If <text> is provided, inserts a new line there just like `say'.", "Equivalent to `insert +n'.  As one might expect, n defaults to 1."}
@prop #44."prev" {} rc
;;#44.("prev") = {"Syntax:  p*rev [n] [\"<text>]", "", "Moves the insertion point up n lines.  If <text> is provided, a new line is inserted as with `say'.", "Equivalent to `insert -n'.  As one might expect, n defaults to 1."}
@prop #44."subst" {} rc
;;#44.("subst") = {"Syntax:  s*ubst/<str1>/<str2>[/[g][c][<range>]]", "", "Substitutes <str2> for <str1>, in all of the lines of <range>.", "Any character (not just `/') may be used to delimit the strings. ", "If <str1> is blank, <str2> is inserted at the beginning of the line.  ", "(For inserting a string at the end of a line use emote/:).", "", "Normally, only one substitution is done per line in the specified range, but if the 'g' flag is given, *all* instances of <str1> are replaced.", "The 'c' flag indicates that case is not significant when searching for substitution instances.", "<range> defaults to the line *before* the insertion point.", "", "You do *not* need a space between the verb and the delimeter before <str1>.", "[Bug: If you omit the space and the first whitespace in <str1> is a run of more than one space, those spaces get treated as one.  Likewise, quotes and backslashes occuring in the first word of the command (i.e., the \"verb\") need to be escaped with `\\'.  The fix on this will have to wait for a new command parser.]"}
@prop #44."join" {} rc
;;#44.("join") = {"Syntax:  join        [<range>]", "         joinliteral [<range>]", "", "combines the lines in the specified range.  Normally, spaces are inserted and double space appears after periods and colons, but 'joinliteral' (abbreviates to 'joinl') supresses this and joins the lines as is.  <range> defaults to the two lines surrounding the insertion point."}
@prop #44."fill" {} rc
;;#44.("fill") = {"Syntax:  fill [<range>] [@ c]", "", "combines the specified lines as in join and then splits them so that no line is more than c characters (except in cases of pathological lines with very long words).  c defaults to 70.  <range> defaults to the single line preceding the insertion point."}
@prop #44."move" {} rc
;;#44.("move") = {"Syntax:  m*ove [<range>] to <ins>", "", "Moves the range of lines to place specified by <ins>.", "If <ins> happens to be the current insertion point, the insertion point is moved to the end of the freshly moved lines.  If the range of lines contains the insertion point, the insertion point is carried over to the range's new location.", "", "See `help insert' for a list of possibilities for <ins>."}
@prop #44."copy" {} rc
;;#44.("copy") = {"Syntax:  c*opy [<range>] to <ins>", "", "Copies the specified range of lines to place given by <ins>.", "If <ins> happens to be the current insertion point, the insertion ", "point moves to the end of the inserted lines.", "", "See `help insert' for a list of possibilities for <ins>."}
@prop #44."what" {} rc
;;#44.("what") = {"Syntax:  w*hat", "", "Prints information about the editing session."}
@prop #44."abort" {} rc
;;#44.("abort") = {"Syntax:  abort", "", "Abandons this editing session and any changes."}
@prop #44."done" {} rc
;;#44.("done") = {"*forward*", "quit"}
@prop #44."pause" {} rc
;;#44.("pause") = {"*forward*", "quit"}
@prop #44."ranges" {} rc
;;#44.("ranges") = {"Most editor commands act upon a particular range of lines.", "Essentially, one needs to specify a first line and a last line.", "Line numbers may be given in any of the following forms", "  ", "  n      (i.e., the nth line of text)", "  n^     n-th line after/below  the current insertion point", "  n_     n-th line before/above the current insertion point", "  n$     n-th line before the end.", "", "In the latter three, n defaults to 1, so that `^' by itself refers to the line below the current (i.e., the line that gets `^' printed before it), and likewise for `_' while `$' refers to the last line.  Note that the usage depends on whether you are specifying a line or an insertion point (space between lines). `^5' is the space above/before line 5, while `5^' is the fifth line after/below the current insertion point.", "", "Ranges of lines may be specified in any of the", "following ways:", "", "  <line>                  just that line", "  from <line> to <line>   what it says; the following two forms are equivalent:", "  <line>-<line>            ", "  <line> <line>", "", "With the `from l to l' form, either the from or the to can be left off and it will default to whatever is usual for that command (usually a line above or below the insertion point).  Actually I was thinking of punting the `from'/`to' specifications entirely because they're so verbose.  Opinions?"}
@prop #44."cc" {} rc
;;#44.("cc") = {"*forward*", "also-to"}
@prop #44."uncc" {} rc
;;#44.("uncc") = {"*forward*", "not-to"}
@prop #44."not-to" {} rc
;;#44.("not-to") = {"Syntax:  not-to [<recipients>]", "", "Synonym: uncc", "", "(MAIL ROOM)", "Removes the specified recipients from the To: line of your message."}
;;#44.("index_cache") = {"edit-index"}
;;#44.("aliases") = {"Editor Help"}
;;#44.("description") = 0
;;#44.("object_size") = {21182, 855068591}

"***finished***
