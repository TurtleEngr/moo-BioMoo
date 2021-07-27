$Header: /repo/public.cvs/app/BioGate/BioMooCore/core60.moo,v 1.1 2021/07/27 06:44:33 bruce Exp $

>@dump #60 with create
@create $generic_help named Help Database:
@prop #60."@uptime" {} rc
;;#60.("@uptime") = {"Syntax:  @uptime", "", "   The @uptime command displays the amount of time since the last restart of the server.", "   Note to programmers:  The last restart time of the server is stored in $last_restart_time."}
@prop #60."wizard-list" {} rc
;;#60.("wizard-list") = {"*subst*", "", "%;this:wizard_list()", ""}
@prop #60."@wrap" {} r
;;#60.("@wrap") = {"*forward*", "@linelength"}
@prop #60."full-index" {} rc
;;#60.("full-index") = {"*full_index*"}
@prop #60." index" {} rc
;;#60.(" index") = {"*index_list*"}
@prop #60."gen-index" {} rc
;;#60.("gen-index") = {"*index*", "General Help Topics"}
@prop #60."@pagelength" {} r #2
;;#60.("@pagelength") = {"Syntax:  @pagelength <number>", "         @pagelength", "", "If the lines you see scroll off the top of your screen too quickly for you to", "read and your client program is such that any lines scrolling off the top are", "gone forever, you can use the @pagelength command to invoke page buffering to", "limit the number of lines sent at a time.  E.g., if your terminal has a 24 line", "screen, you can do @pagelength 24 and output will stop every 24 lines if you", "don't type any other commands.", "", "You will need to use the @more command to continue reading output once it ", "has been stopped.  Make sure you read `help @more' before setting @pagelength.", "", "@pagelength 0 means no page buffering will be done by the MOO.", "", "By default the MOO will assume you have an infinitely wide terminal screen, so", "you may wish to set @linelength as well, and ensure wrapping is on with @wrap", "on.  (See help @linelength and help @wrap.)  As with word wrapping, you are", "best off running a client that can do its own page buffering; the MOO server's", "page buffering is inherently slower and many MUD's do not have page buffering", "at all."}
@prop #60."@more" {} r #2
;;#60.("@more") = {"*subst*", "Syntax:  @more", "         @more rest", "         @more flush", "", "If you have @pagelength set (see `help @pagelength') and some combination of events or commands produces sufficiently many lines of output, you will see a message of the form", "", "%[strsub(player.more_msg,\"%%n\",\"37\")]", "", "indicating (in this case) 37 more lines of text waiting to be read.  ", "At this point, you should give one of the @more commands above.  ", "", "@more without arguments prints sufficiently many lines to fill your screen,", "assuming you've set @pagelength correctly, unless there are not that many", "lines left to print.", "", "@more rest will print all of the remaining lines, regardless of your @pagelength setting.  ", "", "@more flush discards all remaining lines"}
@prop #60."programming" {} rc
;;#60.("programming") = {"MOO contains a rich programming language for the creation of interesting rooms, exits, and other objects.", "", "Not every player is allowed to program in MOO, including (at the moment, anyway) you.  If you would like to be, find a wizard and convince them that you've got good ideas that the MOO needs.  Good luck!"}
@prop #60."@linelength" {} rc
;;#60.("@linelength") = {"Syntax:  @wrap <on|off>", "         @wrap", "", "         @linelength <number>", "         @linelength", "", "If the lines you see get cut off at the edge of your screen (you don't have", "word-wrap), you can get the MOO to split lines for you.  The @linelength", "command tells the MOO how many columns you have on your screen--you probably", "want @linelength 79--and \"@wrap on\" tells the MOO you want it to do word-", "wrap.", "", "It's better if you can fix this problem without the MOO's help, though,", "because the MOO's solution will be slower than a local solution, and", "because not all MUDs are willing to do word-wrap.", "", "If you don't want the MOO to split lines for you, there might still be some", "use for the @linelength command.  Certain commands, like @who and @check,", "print truncated lines so they can print in neat columns.  The default for", "these is generally about 79 columns, which looks fine if you have an", "eighty-column screen.  If your screen is a different width, though, you", "can set @linelength and some of these commands will react accordingly."}
@prop #60."@gaglist" {} rc
;;#60.("@gaglist") = {"*forward*", "@listgag"}
@prop #60."::" {} rc
;;#60.("::") = {"*forward*", "emote"}
@prop #60."@comment" {} rc
;;#60.("@comment") = {"*forward*", "@typo"}
@prop #60."" {} rc
;;#60.("") = {"*forward*", "summary", "", "Type 'help <topic>' for information on a particular topic.", ""}
@prop #60."spoofing" {} r
;;#60.("spoofing") = {"*forward*", "security"}
@prop #60."privacy" {} rc
;;#60.("privacy") = {"Some things you should be aware of:", "", " -*-*- OMNISCIENT WIZARDS AND SYSADMINS: -*-*-", "Wizards can look at absolutely *anything* in the MOO database.  ", "The arch-wizard and the sysadmin for the MOO-server host have complete access not only to the MOO database itself but to many other possibly-relevant things.", "The above mentioned parties (wizards et al), while they will endeavor to be discreet about anything incidental that turns up, nevertheless reserve the right to look at anything they want, if only for the sake of being able to resolve technical problems.", "", " -*-*- LOGGING: -*-*- ", "Some client programs (the \"client\" is the program you use to connect to the MOO, e.g., telnet, tinytalk, tinyfugue, emacs with mud.el...) are capable of logging everything that happens to the corresponding player.  In fact, with some clients this happens by default.  If a given player's client has logging enabled and said player is either in the room with you or is monitoring an object that is in the room with you, then *everything* you say and emote gets recorded.  Also, if you are in a room owned by someone else, all bets are off.  There is *no way* that the MOO server can know about what client a given player is using; thus, anyone who can hear you is a potential logger.", "", "In and of itself this would not be a problem --- indeed, logs are often useful for reference purposes.  However, there is no guarantee that the log will not end up someplace where you'd rather it didn't, e.g., posted on the rec.games.mud Usenet newsgroup.  While it is considered bad form (i.e., rude) to circulate or post a log without having the permission of at least the major participants in the activities logged, there is not a whole lot we can do on the technical side to prevent it from happening.", "", "Be aware of the problem.  The @sweep command (see `help @sweep') attempts to determine what players can be listening at any given moment.  If anything, it errs on the side of paranoia.  Even so, it doesn't cover *all* possible avenues of eavesdropping, and there's no hope for it covering the situations like the one where someone manages to convince one of the participants in your discussion who kept a log that it really doesn't need to be kept private after all.", "", "If you've got something really sensitive to discuss, you are best off doing it by encrypted email or in person."}
@prop #60."@examine" {} rc
;;#60.("@examine") = {"Syntax:  @examine <object>", "         @exam <object>", "", "Prints several useful pieces of information about the named object, including the following:", "        + its full name, aliases, and object number", "        + its owner's name and object number", "        + its description", "        + its key expression (if it is locked and if you own it)", "        + its contents and their object numbers", "        + the 'obvious' verbs defined on it", "", "[Note to programmers: the 'obvious' verbs are those that are readable and that can be invoked as commands.  To keep a verb off this list, either make it unreadable (see 'help @chmod') or, if it shouldn't be used as a command, give it 'args' of 'this none this' (see 'help @args').]"}
@prop #60."security" {} rc
;;#60.("security") = {"There are several commands available to determine the origins of messages and to check that your communications with other players are secure. Help is available on the following topics:", "", "@paranoid -- keeping a record of messages your character hears.", "@check    -- looking at that record to determine responsibility for messages.", "@sweep    -- checking who is listening in on your conversation."}
@prop #60."@sweep" {} rc
;;#60.("@sweep") = {"Syntax: @sweep", "", "Used when you wish to have a private conversation, and are concerned someone may be listening in. @sweep tries to list the avenues by which information may be leaving the room. In a manner analogous to @check, it assumes that you don't want to hear about your own verbs, or those belonging to wizards, who presumably wouldn't stoop to bugging."}
@prop #60."@paranoid" {} rc
;;#60.("@paranoid") = {"Syntax:  @paranoid", "         @paranoid off", "         @paranoid immediate", "         @paranoid <number>", "", "In immediate mode, the monitor prepends everything you hear with the name of the character it considers responsible for the message. Otherwise, it keeps records of the last <number> (defaults to 20) lines you have heard. These records can be accessed by the @check command."}
@prop #60."@check" {} rc
;;#60.("@check") = {"Syntax:   @check <options>", "", "where <options> is one or more of:", "-- the number of lines to be displayed", "-- a player's name, someone to be \"trusted\" during the assignment of responsibility for the message.", "-- a player's named prefixed by !, someone not to be \"trusted\".", "", "          @check-full <options>", "where <options is either ", "-- the number of lines to be displayed", "-- a search string: only lines containing that string will be displayed.", "", "Used when you are suspicious about the origin of some of the messages your character has just heard.", "", "Output from @check is in columns that contain, in order, the monitor's best guess as to:", "    what object the message came from,", "    what verb on that object that was responsible,", "    whose permissions that verb was running with, and", "    the beginning of the actual message.", "", "Output from @check-full is in columns that contains a description of all the verbs that were responsible for the noise heard, not just the best guess as to who was responsible.", "", "@check operates by examining the list of verbs that were involved in delivering the message, and assigning responsibility to the first owner it sees who is not \"trusted\".  By default, it trusts you and all the wizards.  It uses the records maintained by @paranoid, so you must have used that command before you received the message."}
@prop #60."@eject" {} rc
;;#60.("@eject") = {"Syntax: @eject[!] <object> [from <place>]", "", "This command is used to remove unwanted objects from places you own.  Players thus removed are unceremoniously dumped in their homes (unless that's this room, in which case they are dumped in the default player starting place).  Other kinds of objects are checked for a .home property and sent there if possible, otherwise they get thrown into #-1.  Unlike @move, @eject does *not* check to see if the object wants to be moved, and with the destination being what it is, there is no question of the destination refusing the move, either.  Generally, you should only resort to @eject if @move doesn't work.", "", "`@eject <object>' removes <object> from the current room, whereas `@eject <object> from <place>' removes the object from the specified location (in most cases, <place> will need to be specified as an object number).  In either case, this command only works if you own the room/entity from which the object is being ejected.", "", "`@eject ... from me' suffices to get rid of some unwanted object in your inventory.", "", "The verbs @eject! and @eject!! are provided for those rare situations in which @eject does not work.  @eject! does not check for .home properties, sending the offending object to #-1 immediately, but with a notification.  @eject!! is just like @eject! but provides no notification to the object.", "", "See 'help room-messages' for a list of messages one can set regarding the @eject command."}
@prop #60."@quit" {} r
;;#60.("@quit") = {"Syntax:  @quit", "", "Disconnect from the MOO.  This breaks your network connection and leaves your player sleeping.  Disconnecting in most parts of the MOO automatically returns your player to its designated home (see 'help home')."}
@prop #60."whereis" {} rc
;;#60.("whereis") = {"Syntax:  whereis [<player> [<player>...]]", "        @whereis [<player> [<player>...]]", "", "Returns the current location of each of the specified players, or of all players if not arguments given."}
@prop #60."@suggest" {} rc
;;#60.("@suggest") = {"*forward*", "@typo"}
@prop #60."@idea" {} rc
;;#60.("@idea") = {"*forward*", "@typo"}
@prop #60."@bug" {} rc
;;#60.("@bug") = {"*forward*", "@typo"}
@prop #60."@typo" {} rc
;;#60.("@typo") = {"Syntax:  @typo    [<text>]", "         @bug     [<text>]", "         @suggest [<text>]", "         @idea    [<text>]", "         @comment [<text>]", "", "If <text> is given, a one-line message is sent to the owner of the room, presumably about something that you've noticed.  If <text> is not given, we assume you have more to say than can fit comfortably on a single line; the usual mail editor is invoked.  The convention is that @typo is for typographical errors on the room or objects found therein, @bug is for anomalous or nonintuitive behaviour of some sort, @idea/@suggest for any particular brainstorms or criticisms you might happen to have, and @comment for anything else.", "", "If you're sending a bug report to someone because you got an error traceback when you used some object of theirs, please give them enough information to work on the problem.  In particular, please tell them *exactly* what you typed and *all* of the error messages that were printed to you, including the entire traceback, up to the line `(End of traceback.)'.  Without this information, it is nearly impossible for the programmer to discover, let alone fix, the problem.", "", "The usual mail editor is only invoked for this command when in rooms that allow free entry, i.e., rooms that are likely to allow you back after you are done editing your message.  Otherwise these commands will require <text> and only let you do one-line messages.  ", "Most adventuring scenario rooms fall into this latter category."}
@prop #60."@notedit" {} rc
;;#60.("@notedit") = {"Syntax:  @notedit <note-object>", "         @notedit <object>.<property>", "", "Enters the MOO Note Editor to edit the text on the named object", "For the first form, <note-object> must be a descendant of $note.  ", "For the second form, <object>.<property> can be any string-valued or text-valued (i.e., list of strings) property on any object.", "", "See 'help editors' for more detail."}
@prop #60."editors" {} rc
;;#60.("editors") = {"One can always enter an editor by teleporting to it, or you can use one of the commands provided", "", "    @edit     <object>:<verb>    invokes the Verb Editor (edits verb code)", "    @notedit  <note_object>      invokes the Note Editor (edits note text)", "    @notedit  <object>.<prop>    invokes the Note Editor (edits text property)", "    @send     <list of recipients>        invokes the Mailer (edits a mail msg)", "    @answer   [<msg_number>] [<flags>...] invokes the Mailer (edits a reply)", "", "This will transport you to one of several special rooms that have editing commands available.  These editors are admittedly not as good as EMACS, but for those with no other editing capability on their host systems, they are better than nothing.", "", "There is a generic editor that provides basic editing commands that are applicable to all editors.  Documentation for these commands can be obtained by typing `help <topic>' within the editor:", "", "    abort              emote/:            pause              send      (M) ", "    also-to (M)        fill               prev               showlists (M) ", "    compile (V)        insert             print     (M)      subject   (M) ", "    copy               join               quit               subst         ", "    delete             list               ranges             to    (M)     ", "    done               move               save      (N)      what          ", "    edit    (V,N)      next               say/\"              who   (M)     ", "", "In addition, individual editors provide their own additional commands for loading text from places, saving text to places, and various other specialized functions which are denoted in the above list with (M),(N),(V) according as they apply to the mail editor, the note editor, or the verb editor, respectively.", "", "Note that a given editor only allows you one session at a time (ie. one verb, one note, or one mail message).  If you leave an editor without either aborting or compiling/saving/sending the item you're working on, that editor remembers what you are doing next time you enter it, whether you enter it by teleporting or by using the appropriate command.  Note that editors are periodically flushed so anything left there for sufficiently long will eventually go away.", "", "A player may have his own .edit_options property which is a list containing one or more (string) flags from the following list", "", "  quiet_insert", "      suppresses those annoying \"Line n added.\" or \"Appended...\" messages", "      that one gets in response to 'say' or 'emote'.  This is useful if you're", "      entering a long list of lines, perhaps via some macro on your client,", "      and you don't want to see an equally long list of \"Line n added...\"", "      messages.  What you do want, however is some indication that this all", "      got through, which is why the \".\" command is an abbreviation for insert.", "", "  eval_subs", "      Enables the verb editor to process your eval_subs property when", "      compiling your verb.  See `help eval' for more information about", "      the eval_subs property.", "", "There will be more options, some day."}
@prop #60."@memory" {} r
;;#60.("@memory") = {"Syntax:  @memory", "", "Prints out all information available on the current memory-usage behavior of the MOO server.  Probably only a wizard, if anyone, cares about this."}
@prop #60."\"" {} r
;;#60.("\"") = {"*forward*", "say"}
@prop #60.":" {} r
;;#60.(":") = {"*forward*", "emote"}
@prop #60."@lastlog" {} r
;;#60.("@lastlog") = {"Syntax:  @lastlog", "         @lastlog <player>", "", "The first form prints out a list of all players, roughly sorted by how long it's been since that player last connected to the MOO.  For each player, the precise time of their last connection is printed.", "", "The second form only shows the last-connection time for the named player."}
@prop #60."@version" {} r
;;#60.("@version") = {"Syntax:  @version", "", "Prints out the version number for the currently-executing MOO server."}
@prop #60."miscellaneous" {} r
;;#60.("miscellaneous") = {"Here are a few commands of occasional utility that didn't fit into any of the neat categories for the rest of the help system:", "", "@version -- printing the MOO server version number", "@lastlog -- finding out when some player last connected to the MOO"}
@prop #60."insert" {} r
;;#60.("insert") = {"*forward*", "put"}
@prop #60."information" {} r
;;#60.("information") = {"*forward*", "help"}
@prop #60."?" {} r
;;#60.("?") = {"*forward*", "help"}
@prop #60."put" {} r
;;#60.("put") = {"Syntax:  put <object> into <container>", "         insert <object> in <container>", "", "Moves the named object into the named container.  Sometimes the owners of the object and/or the container will not allow you to do this."}
@prop #60."remove" {} r
;;#60.("remove") = {"*forward*", "take"}
@prop #60."burn" {} r
;;#60.("burn") = {"Syntax:  burn <letter>", "", "Destroy the named letter irretrievably.  Only players who can read the letter can do this."}
@prop #60."letters" {} r
;;#60.("letters") = {"A letter is a special kind of note (see 'help notes') with the added feature that it can be recycled by anyone who can read it.  This is often useful for notes from one player to another.  You create the letter as a child of the generic letter, $letter (see 'help @create' and 'help write'), encrypt it so that only you and the other player can read it (see 'help encrypt') and then either give it to the player in question or leave it where they will find it.  Once they've read it, they can use the 'burn' command to recycle the letter; see 'help burn' for details."}
@prop #60."decrypt" {} r
;;#60.("decrypt") = {"Syntax:  decrypt <note>", "", "Removes any restriction on who may read the named note or letter.  Only the owner of a note may do this."}
@prop #60."encrypt" {} r
;;#60.("encrypt") = {"Syntax:  encrypt <note> with <key-expression>", "", "Restricts the set of players who can read the named note or letter to those for whom the given key expression is true.  See 'help keys' for information on the syntax and semantics of key expressions.  Only the owner of a note may do this."}
@prop #60."delete" {} r
;;#60.("delete") = {"Syntax:  delete <line-number> from <note>", "", "Removes a single line of text from a note.  The first line of text is numbered 1, the second is 2, and so on.  Only the owner of a note may do this."}
@prop #60."erase" {} r
;;#60.("erase") = {"Syntax:  erase <note>", "", "Deletes all of the text written on a note or letter.  Only the owner of a note may do this."}
@prop #60."write" {} r
;;#60.("write") = {"Syntax:  write \"<any text>\" on <note>", "", "Adds a line of text to the named note or letter.  Only the owner of a note may do this."}
@prop #60."read" {} r
;;#60.("read") = {"Syntax:  read <note>", "", "Prints the text written on the named object, usually a note or letter.  Some notes are encrypted so that only certain players may read them."}
@prop #60."examine" {} r
;;#60.("examine") = {"Syntax:  examine <object>", "         exam <object>", "", "Prints several useful pieces of information about the named object, including the following:", "        + its full name, object number, and aliases", "        + its owner's name", "        + its description", "        + its key expression (if it is locked and if you own it)", "        + its contents", "        + the 'obvious' verbs defined on it"}
@prop #60."hand" {} r
;;#60.("hand") = {"*forward*", "give"}
@prop #60."throw" {} r
;;#60.("throw") = {"*forward*", "drop"}
@prop #60."take" {} r
;;#60.("take") = {"Syntax:  take <object>", "         get <object>", "         take <object> from <container>", "         get <object> from <container>", "         remove <object> from <container>", "", "The first two forms pick up the named object and place it in your inventory.  Sometimes the owner of the object won't allow it to be picked up for some reason.", "", "The remaining forms move the named object from inside the named container (see 'help containers') into your inventory.  As before, sometimes the owner of an object will not allow you to do this."}
@prop #60."@messages" {} r
;;#60.("@messages") = {"Syntax:  @messages <object>", "", "List all of the messages that can be set on the named object and their current values.  See 'help messages' for more details."}
@prop #60."pronouns" {} r
;;#60.("pronouns") = {"Some kinds of messages are not printed directly to players; they are allowed to contain special characters marking places to include the appropriate pronoun for some player.  For example, a builder might have a doorway that's very short, so that people have to crawl to get through it.  When they do so, the builder wants a little message like this to be printed:", "", "        Balthazar crawls through the little doorway, bruising his knee.", "", "The problem is the use of 'his' in the message; what if the player in question is female?  The correct setting of the 'oleave' message on that doorway is as follows:", "", "        \"crawls through the little doorway, bruising %p knee.\"", "", "The '%p' in the message will be replaced by either 'his', 'her', or 'its', depending upon the gender of the player.  ", "", "As it happens, you can also refer to elements of the command line (e.g., direct and indirect objects) the object issuing the message, and the location where this is all happening.  In addition one can refer to arbitrary string properties on these objects, or get the object numbers themselves.", "", "The complete set of substitutions is as follows:", "", "        %% => `%'  (just in case you actually want to talk about percentages).", "    Names:", "        %n => the player", "        %t => this object (i.e., the object issuing the message,... usually)", "        %d => the direct object from the command line", "        %i => the indirect object from the command line", "        %l => the location of the player", "    Pronouns:", "        %s => subject pronoun:          either `he',  `she', or `it'", "        %o => object pronoun:           either `him', `her', or `it'", "        %p => posessive pronoun (adj):  either `his', `her', or `its'  ", "        %q => posessive pronoun (noun): either `his', `hers', or `its'", "        %r => reflexive pronoun:  either `himself', `herself', or `itself'", "    General properties:", "        %(foo) => player.foo ", "        %[tfoo], %[dfoo], %[ifoo], %[lfoo]", "               => this.foo, dobj.foo, iobj.foo, and player.location.foo", "    Object numbers:", "        %#  => player's object number", "        %[#t], %[#d], %[#i], %[#l]", "            => object numbers for this, direct obj, indirect obj, and location.", "", "In addition there is a set of capitalized substitutions for use at the ", "beginning of sentences.  These are, respectively, ", "", "   %N, %T, %D, %I, %L for object names, ", "   %S, %O, %P, %Q, %R for pronouns, and", "   %(Foo), %[dFoo] (== %[Dfoo] == %[DFoo]),... for general properties", "", "Note: there is a special exception for player .name's which are assumed to", "already be capitalized as desired.", "", "There may be situations where the standard algorithm, i.e., upcasing the first letter, yields something incorrect, in which case a \"capitalization\" for a particular string property can be specified explicitly.  If your object has a \".foo\" property that is like this, you need merely add a \".fooc\" (in general .(propertyname+\"c\")) specifying the correct capitalization.  This will also work for player .name's if you want to specify a capitalization that is different from your usual .name", "", "Example:  ", "Rog makes a hand-grenade with a customizable explode message.", "Suppose someone sets grenade.explode_msg to:", "", "  \"%N(%#) drops %t on %p foot.  %T explodes.  ", "   %L is engulfed in flames.\"", "", "If the current location happens to be #3443 (\"yduJ's Hairdressing Salon\"),", "the resulting substitution may produce, eg.,", "", "  \"Rog(#4292) drops grenade on his foot.  Grenade explodes.  ", "   YduJ's Hairdressing Salon is engulfed in flames.\"", "", "which contains an incorrect capitalization.  ", "yduJ may remedy this by setting #3443.namec=\"yduJ's Hairdressing Salon\".", "", "Note for programmers:  ", " In programs, use $string_utils:pronoun_sub().", " %n actually calls player:title() while %(name) refers to player.name directly."}
@prop #60."messages" {} r
;;#60.("messages") = {"Most objects have messages that are printed when a player succeeds or fails in manipulating the object in some way.  Of course, the kinds of messages printed are specific to the kinds of manipulations and those, in turn, are specific to the kind of object.  Regardless of the kind of object, though, there is a uniform means for listing the kinds of messages that can be set and then for setting them.", "", "The '@messages' command prints out all of the messages you can set on any object you own.  Type 'help @messages' for details.", "", "To set a particular message on one of your objects use a command with this form:", "        @<message-name> <object> is \"<message>\"", "where '<message-name>' is the name of the message being set, <object> is the name or number of the object on which you want to set that message, and <message> is the actual text.", "", "For example, consider the 'leave' message on an exit; it is printed to a player when they successfully use the exit to leave a room.  To set the 'leave' message on the exit 'north' from the current room, use the command", "        @leave north is \"You wander in a northerly way out of the room.\"", "", "[Note to programmers: This class of commands automatically applies to any property whose name ends in '_msg'.  Thus, in the example above, the command is setting the 'leave_msg' property of the named exit.  You can get such a command to work on new kinds of objects simply by giving the appropriate properties names that end in '_msg'.  Additionally, in many cases the _msg property is accompanied by a _msg verb, which defaultly returns the named property, but which is available to be customized in more complex ways than allowed by simple string substitution.  You should check for the particular property you're considering whether the verb form exists (typically with @list).]", "", "The following help topics describe the uses of the various messages available on standard kinds of objects:", "", "container-messages -- the messages on objects that can contain other objects", "exit-messages -- the messages on exit objects", "thing-messages -- the messages on objects that can be taken and dropped"}
@prop #60."descriptions" {} r
;;#60.("descriptions") = {"Most objects have one or more descriptive pieces of text associated with them; these texts are printed under various circumstances depending on the kind of text.  For example, every object has a 'description' text that is printed whenever a player looks at the object.  The following help topics discuss the commands for manipulating these descriptive texts on your objects:", "", "@rename -- setting the name and aliases of your objects", "@describe -- setting what others see when they look at your objects", "messages -- listing and setting the other descriptive texts on an object"}
@prop #60."@describe" {} r
;;#60.("@describe") = {"Syntax:  @describe <object> as <description>", "", "Sets the description string of <object> to <description>.  This is the string that is printed out whenever someone uses the 'look' command on <object>.  To describe yourself, use 'me' as the <object>.", "", "Example:", "Munchkin types this:", "  @describe me as \"A very fine fellow, if a bit on the short side.\"", "People who type 'look Munchkin' now see this:", "  A very fine fellow, if a bit on the short side.", "", "Note for programmers:", "The description of an object is kept in its .description property.  ", "For descriptions of more than one paragraph, .description can be a list of strings."}
@prop #60."tinymud" {} r
;;#60.("tinymud") = {"This is yduJ's table of tinymud commands and their equivalents in LambdaMOO.  A longer document, with discussions of the different verbs and how they have changed, is available via FTP from ftp.parc.xerox.com as pub/MOO/contrib/docs/TinyMUD-LambdaMOO-equivs.  All the commands mentioned here have help nodes on LambdaMOO.", "", "The following commands are basically the same in MOO and MUD.", "", "    drop(throw), get(take), go, help, home, inventory, look, news, say (\",:)", "", "", "The following commands have no equivalent:", "", "    kill, rob, score, @force", "", "", "The following commands have the same names and do similar things, but are changed in some way (both syntactic and semantic differences, sometimes quite substantial differences):", "", "    @examine, give, page, read, whisper, @create, @dig,", "    @lock, @password, @unlock, @describe", "", "", "The following commands have rough equivalents in LambdaMOO but the name is different:", "", "    TinyMUD name            LambdaMOO name", "    ------------            --------------", "    QUIT                    @quit", "    gripe                   @gripe", "    goto/move               go", "    WHO                     @who", "    @fail                   @take_failed, @nogo, @drop_failed", "    @find                   @audit", "    @link                   @dig, @sethome, @add-exit, @add-entrance", "    @name                   @rename", "    @ofail                  @otake_failed, @onogo, @odrop_failed", "    @open                   @dig", "    @osuccess               @oleave, @oarrive, @otake_succeeded, ", "                            @odrop_succeeded", "    @success                @leave, @arrive, @take_succeeded", "                            @drop_succeeded", "    @teleport               @move", "", "", "Here are some commands for which no equivalent exists, or for which the equivalent is a complicated set of actions.", "", "    @set, @stats, @unlink", "", "", "Documentation on most of the LambdaMOO commands mentioned above can be acquired using 'help <command-name>'.  A notable exception is the commands like @oarrive and @take_failed that set textual messages on objects.  These are described under 'help messages'."}
@prop #60."@gripe" {} rc
;;#60.("@gripe") = {"Syntax:  @gripe <anything> ...", "", "Puts you into the MOO mail system to register a complaint (or, conceivably, a compliment) with the wizards.  The rest of the command line (the <anything> ... part) is used as the subject line for the message.  More information on using the MOO mail system is given once you're in it.", "", "You may hear back from the wizards eventually; see 'help @mail' for how to read their reply.", "", "Example:", "Munchkin types:", "  @gripe The little bird", "  \"How come I can't ever see the little bird in the cuckoo clock?", "  \"        -- A frustrated player", "  send", "and, somewhat later, the wizards reply with a note about being sure to look while the clock is chiming."}
@prop #60."@listgag" {} r
;;#60.("@listgag") = {"Syntax:  @listgag [all]", "         @gaglist [all]", "", "Shows you a list of the players and objects currently on your 'gag list'.  You don't see any messages that result from actions initiated by the players or objects on this list.  In particular, you will not hear them if they try to speak, emote, or whisper to you.  See 'help gagging' for an explanation of gagging in general.  With the optional \"all\" parameter it will also scan the database for players who are gagging you.  This may induce lag, so caution is advised with this option."}
@prop #60."@ungag" {} r
;;#60.("@ungag") = {"Syntax:  @ungag <player or object>", "         @ungag everyone", "", "Remove the given player or object (or, in the second form, everyone) from your 'gag list'.  You will once again see any messages that result from actions initiated by the ungagged player(s) or objects.  In particular, you will once again be able to hear them if they speak, emote, or whisper to you.  See 'help gagging' for an explanation of gagging in general.", "", "Example:", "Munchkin types:", "  @ungag Grover", "and is once again able to hear Grover's witty remarks.  Sigh..."}
@prop #60."@gag" {} r
;;#60.("@gag") = {"Syntax:  @gag <player or object> [<player or object>...]", "", "Add the given players to your 'gag list'.  You will no longer see any messages that result from actions initiated by these players.  In particular, you will not hear them if they try to speak, emote, or whisper to you.  See 'help gagging' for an explanation of gagging in general.", "", "Example:", "Munchkin types:", "  @gag Grover", "and no longer hears anything that Grover says.  What a relief!", "", "If you specify an object, then any text originating from that object will not be printed.  Example:  Noisy Robot prints \"Hi there\" every 15 seconds.   In order to avoid seeing that, Munchkin types:", "  @gag Noisy", "and no longer hears that robot!  (Munchkin must be in the same room as Noisy Robot for this to work, or know its object number.)"}
@prop #60."go" {} r
;;#60.("go") = {"Syntax: go <direction> ...", "", "Invokes the named exits in the named order, moving through many rooms in a single command.", "", "Example:", "Munchkin types:", "  go n e e u e e s e", "and moves quite rapidly from the Living Room all the way to the Bovine Illuminati Atrium, all in one command."}
@prop #60."@password" {} r
;;#60.("@password") = {"Syntax: @password <old-password> <new-password>", "", "Changes your player's password (as typed in the 'connect' command when you log in to the MOO) to <new-password>.  For security reasons, you are required to type your current (soon to be old) password as the first argument.", "", "Your password is stored in an encrypted form in the MOO database; in principle, not even the wizards can tell what it is, though they can change it, of course.  It is recommended that your password not be your name or a common word; MOO passwords have been stolen or cracked in the past and characters have been made unhappy by such theft.  Your password is your security; choose a safe one.", "", "If your character does get stolen, a wizard can change it for you and tell you the new password in secret.  You may have to provide your email address for verification.", "", "Only the first 8 characters of a password are significant."}
@prop #60."@sethome" {} r
;;#60.("@sethome") = {"Syntax: @sethome", "", "Sets your designated home (see `help home') to be the room you're in now.  If the current room wouldn't allow you to teleport in, then the `@sethome' command nicely refuses to set your home there.  This avoids later, perhaps unpleasant, surprises.  Additionally, your home must be a room that will allow you to stay there.  Rooms which you own will do this, as will rooms to which you have been added as a resident.  See the @resident command for help on adding someone as a resident to a room you own."}
@prop #60."@who" {} r
;;#60.("@who") = {"*subst*", "Syntax: @who", "        @who <player> [<player> ... ]", "", "The first form lists all of the currently-connected players, along with the amount of time they've been connected, the amount of time they've been idle, and their present location in the MOO.", "", "The second form, in which a list of player names is given, shows information for just those players.  For any listed players that are not connected, we show the last login time instead of the connect/idle times.", "", "@who refers to the @who_location message (see 'help messages') on each player's location in order to determine what should be printed in the location column.  Pronoun substitutions are done on this string in the usual manner (see 'help pronouns').  The default value is \"%[$room.who_location_msg]\" (i.e., the room name).", "", "If the list of players to display is longer than 100, this command will not show its normal output, since it can be quite expensive to compute.  In such cases, you might want to use the @users command instead; see `help @users' for more information."}
@prop #60."introduction" {} r
;;#60.("introduction") = {"LambdaMOO is a kind of virtual reality, in which players move about from place to place manipulating their environment in what we hope are amusing, entertaining, or enlightening ways.", "", "LambdaMOO is more of a pastime than a game in the usual sense; there is no `score' kept, there are no specific goals to attain in general, and there's no competition involved.  LambdaMOO participants explore the virtual world, talk to the other participants, try out the weird gadgets that others have built, and create new places and things for others to encounter and enjoy.", "", "Most commands have the form of simple English sentences:", "    <verb>", "    <verb>  <direct object>", "    <verb>  <direct object>  <preposition>  <indirect object>", "Don't use English articles (e.g. 'a', 'an', or 'the') in your commands; the MOO won't understand them.  You can refer to yourself as 'me' and the room you're in as 'here'.", "", "The first five kinds of commands you'll want to know are listed below.  Type 'help <topic-name>' for details on any of them:", "", "look -- getting a description of the current room or any other object", "say -- speaking to the other players in the same room as you", "@who -- showing which players are currently connected to the MOO", "movement -- how to move around in the MOO, from room to room", "@quit -- disconnecting from the MOO"}
@prop #60."give" {} rc
;;#60.("give") = {"Syntax:  give <object> to <player>", "         hand <object> to <player>", "", "Move an object from your contents to that of another player.  This doesn't change the ownership of the object.  Some players may refuse to accept gifts and some objects may refuse to be given."}
@prop #60."news" {} rc
;;#60.("news") = {"*subst*", "Syntax: news", "        news all", "        news new", "        news contents", "        news archive", "", "Read the latest edition of the %[$network.MOO_name] Newspaper, which carries articles concerning recent changes to the MOO server or to the main public classes, or other articles of interest to the MOO at large.", "", "The default behavior for the `news' command is to act like `news new' but this may be changed by setting the @mail-option news to one of `all' or `new' or `contents'.  `news all' displays all current news articles.  `news new' only displays articles you have not yet read.  `news contents' displays the authors and subjects of all current news.  `news archive' displays back issues of the newspaper which are deemed worth reading by every citizen at any time."}
@prop #60."gagging" {} rc
;;#60.("gagging") = {"Occasionally, you may run into a situation in which you'd rather not hear from certain other players.  It might be that they're being annoying, or just that whatever they're doing makes a lot of noise.  Gagging a player will stop you from hearing the results of any task initiated by that player.  You can also gag a specific object, if you want to hear what the owner of that object says, but not the output from their noisy robot.  The commands to use gagging are listed below; detailed help is available on each of them:", "", "@gag -- add one or more players to your gag list", "@ungag -- remove a player from your gag list", "@listgag -- list the players you currently have gagged"}
@prop #60."@move" {} rc
;;#60.("@move") = {"Syntax:  @move <thing> to <place>", "", "Move the specified object to the specified location.  This is not guaranteed to work; in particular, the object must agree to be moved and the destination must agree to allow the object in.  This is usually the case, however.  The special case where <thing> is 'me' is useful for teleporting yourself around.", "", "If @move doesn't work and you own the room where the object is located, try using @eject instead."}
@prop #60."inventory" {} rc
;;#60.("inventory") = {"Syntax:  inventory", "         i", "", "Prints a list showing every object you're carrying."}
@prop #60."@gender" {} rc
;;#60.("@gender") = {"Syntax: @gender <gender>", "        @gender", "", "The first form, with an argument, defines your player to have the gender <gender>.  If <gender> is one of the standard genders (e.g., 'male', 'female', 'neuter',...), your various pronouns will also be set appropriately, making exits and certain other objects behave more pleasantly for you.", "", "The second form tells you the current definition of your player's gender, your current pronouns, and the complete list of standard genders.", "", "It should be noted that some of the \"genders\" on the standard gender list need verb conjugation in order to work properly and much of the MOO isn't set up for this (...yet).  For example, you should expect to see `they is' a fair amount if you @gender yourself `plural'."}
@prop #60."@rename" {} rc
;;#60.("@rename") = {"Syntax: @rename <object>        to [name-and-alias],<alias>,...,<alias>", "        @rename <object>        to [name]:<alias>,...,<alias>", "        @rename <object>.<property> to <new-property-name>", "        @rename <object>:<verb-name> to <new-verb-name>", "        @rename# <object>:<verb-number> to <new-verb-name>", "", "The first two forms are used to change the name and aliases of an object. The name is what will be used in most printed descriptions of the object. The aliases are the names by which players can refer to the object in commands. Typically you want to include the name in the aliases, as the MOO parser only checks .aliases when matching, so the first syntax is generally preferred.", "", "If you leave out the \"name\" part of the list, @rename will leave the object's name as it is, and only change the aliases.", "", "Note that for renaming players, more stringent rules apply.  See `help player-names'.  Certain other kinds of objects (e.g., mail recipients) also enforce their own rules w.r.t what they can be named.", "", "Examples:", "Munchkin names his dog:", "  @rename #4237 to \"Rover the Wonder Dog\":Rover,dog", "Now we'll see 'Rover the Wonder Dog' if we're in the same room as him and we can refer to him as either 'Rover' or just 'dog' in our commands, like 'pet dog'.  Note, however, that it will be impossible to use \"Rover the Wonder Dog\" to rever to the dog: if you don't include the name in the aliases, confusion can result.  It might have been better to start off with", "  @rename #4237 to \"Rover the Wonder Dog\",Rover,dog", "", "Since he didn't, Munchkin now changes his dog's aliases:", "  @rename #4237 to ,Rover,dog,Rover the Wonder Dog", "The name remains the same--we still see 'Rover the Wonder Dog'--but now any of 'Rover', 'dog', or 'Rover the Wonder Dog' can be used to refer to him.  This can help reduce confusion.", "", "The third form of the @rename command is also for use by programmers, to change the name of a property they own to <new-property-name>.", "", "The fourth form of the @rename command is for use by programmers, to change the name of a verb they own. If the <new-verb-name> contains spaces, the verb will have multiple names, one for each space-separated word.", "", "The fifth form, @rename#, is for unambiguously referring to a verb on an object in case there is more than one with the same name. The verb number is the 1-based index of the verb as it appears in the verbs() (or @verbs) output list."}
@prop #60."notes" {} rc
;;#60.("notes") = {"Notes are objects that can have text written on them to be read later.  They are useful for leaving messages to people, or for documenting your creations.", "", "The following help topics cover verbs that can be used with notes:", "", "read -- reading the text on the note", "write -- adding text to a note", "erase -- removing all the text from a note", "delete -- deleting one line of text from a note", "", "@notedit -- general editing on the text of a note", "", "encrypt -- restricting who can read a note", "decrypt -- undoing a previous encryption", "", "You can make a note by creating a child of the standard note, $note (see 'help @create').  Note that, like most objects, only the owner of a note can recycle it.  If you'd like to make it possible for a reader of your note to destroy it (this is a common desire for notes to other individual players), then you might want to look at 'help letters'."}
@prop #60."look" {} rc
;;#60.("look") = {"Syntax: look", "        look <object>", "        look <object> in <container>", "", "Show a description of something.", "", "The first form, with no arguments, shows you the name and description of the room you're in, along with a list of the other objects that are there.", "", "The second form lets you look at a specific object.  Most objects have descriptions that may be read this way.  You can look at your own description using 'look me'.  You can set the description for an object or room, including yourself, with the 'describe' command (see 'help describe').", "", "The third form shows you the description of an object that is inside some other object, including objects being carried by another player."}
@prop #60."drop" {} rc
;;#60.("drop") = {"Syntax:  drop <object>", "         throw <object>", "", "Remove an object you are carrying from your inventory and put it in your current room.  Occasionally you may find that the owner of the room won't allow you to do this."}
@prop #60."get" {} rc
;;#60.("get") = {"*forward*", "take"}
@prop #60."manipulation" {} rc
;;#60.("manipulation") = {"Objects usually have verbs defined on them that allow players to manipulate and use them in various ways. Standard ones are:", "", "get  -- pick an object up and place it in your inventory", "drop -- remove an object from your inventory and place it in the room", "put  -- take an object from your inventory and place it in a container", "give -- hand an object to some other player", "look -- see what an object looks like", "", "You can see what objects you're carrying with the 'inventory' command; see 'help inventory' for details.", "", "Some specialized objects will have other commands. The programmer of the object will usually provide some way for you to find out what the commands are.  One way that works for most objects is the 'examine' command; see 'help examine' for details.", "", "The following specialized objects have help entries you should consult:", "", "notes -- objects that allow text to be written on them and read later", "letters -- notes that a recipient can burn after reading", "containers -- objects that may contain other objects"}
@prop #60."help" {} r
;;#60.("help") = {"Syntax:  help", "         help <topic>", "         help index", "", "Print out entries from the online documentation system.  The commands `?' and `information' (usually abbreviated `info') are synonyms for `help'.", "", "The first form prints out a summary table of contents for the entire help system.  ", "", "The second form prints out the documentation available on the given topic.  Many help system entries contain references to other entries accessible in this way.  The topic name may be abbreviated; if there is no topic exactly matching the name you give, the help system checks for topics for which the name is a prefix, perhaps with the addition or omission of an initial `@', or perhaps with some confusion beween dashes (-) and underscores (_), e.g., ", "      `bui' instead of `building', ", "      `who' instead of `@who', ", "     `@wri' instead of `write',", "  `add_ent' instead of `@add-entrance',", " `unlock-'  instead of `@unlock_for_open'", "", "If the abbreviation you give is ambiguous, you will be presented with a list of the matching complete topic names.", "", "The `help index' commands prints out a list of indices for the various help databases.  Each index gives a list of topics available on that database.  It is sometimes easier to find the topics you're interested in this way, rather than tracing through the chain of cross references."}
@prop #60."movement" {} r
;;#60.("movement") = {"The descriptions of most rooms outline the directions in which exits exist.  Typical directions include the eight compass points ('north', 'south', 'east', 'west', 'northeast', 'southeast', 'northwest', and 'southwest'), 'up', 'down', and 'out'.", "", "To go in a particular direction, simply type the name of that direction (e.g, 'north', 'up').  The name of the direction can usually be abbreviated to one or two characters (e.g., 'n', 'sw').  You can also type 'go <direction>' to move; this is particularly useful if you know you're going to type several movement commands in a row (see 'help go').", "", "In addition to such vanilla movement, some areas may contain objects allowing teleportation and almost all areas permit the use of the 'home' command to teleport you to your designated home (see 'help home' for more details)."}
@prop #60."home" {} r
;;#60.("home") = {"*subst*", "Syntax: home", "", "Instantly teleports you to your designated home room.", "Initially, this room is %[tostr($player_start.name,\" (\",$player_start,\")\")].", "You can change your designated home; see 'help @sethome' for details."}
@prop #60."say" {} r
;;#60.("say") = {"Syntax:  say <anything> ...", "         \"<anything> ...", "", "Says <anything> out loud, so that everyone in the same room hears it.  This is so commonly used that there's a special abbreviation for it: any command-line beginning with a double-quote ('\"') is treated as a 'say' command.", "", "Example:", "Munchkin types this:", "  \"This is a great MOO!", "Munchkin sees this:", "  You say, \"This is a great MOO!\"", "Others in the same room see this:", "  Munchkin says, \"This is a great MOO!\""}
@prop #60."whisper" {} r
;;#60.("whisper") = {"whisper \"<text>\" to <player>", "sends the message \"<yourname> whispers, \"<text>\" to you \" to <player>, if they are in the room."}
@prop #60."page" {} r
;;#60.("page") = {"*subst*", "Syntax:  page <player> [[with] <text>]", "", "Sends a message to a connected player, telling them your location and, optionally, <text>.", "", "Example:", "Munchkin types:", "        page Frebble with \"Where are you?\"", "Frebble sees:", "        You sense that Munchkin is looking for you in the Kitchen.", "        He pages, \"Where are you?\"", "Munchkin sees:", "        Your message has been received.", "", "Advanced Features:", "Page refers to the following messages on the players involved (see 'help messages'):", "", "@page_origin [%[$player.page_origin_msg]]", "  Determines how the recipient is told of your location.", "", "@page_echo   [%[$player.page_echo_msg]]", "  Determines the response received by anyone who pages you.", "", "@page_absent [%[$player.page_absent_msg]]", "  Determines the response received by anyone who tries to page you when you aren't connected.", "", "All of these undergo the usual pronoun substitutions (see 'help pronouns') except that in both cases the direct object (%d) refers to the recipent of the page and the indirect object (%i) refers to the sender.  You should only change these messages if you want to add to the Virtual Reality feel of the MOO for your character."}
@prop #60."emote" {} r
;;#60.("emote") = {"Syntax:  emote <anything> ...", "         :<anything> ...", "         ::<anything> ...", "", "Announces <anything> to everyone in the same room, prepending your name.  This is commonly used to express various non-verbal forms of communication.  In fact, it is so commonly used that there's a special abbreviation for it: any command-line beginning with ':' is treated as an 'emote' command.", "", "The alternate form, '::' (less commonly 'emote :'), does not insert the space between the player name and the text.", "", "Examples:", "Munchkin types this:", "  :wishes he were much taller...", "Everyone in the same room sees this:", "  Munchkin wishes he were much taller...", "", "Munchkin types this:", "  ::'s eyes are green.", "Everyone in the same room sees this:", "  Munchkin's eyes are green."}
@prop #60."players" {} r
;;#60.("players") = {"There are a number of commands for modifying various characteristics of the object representing you in the MOO, your 'player'.  Help on them is available in the following topics:", "", "@describe -- setting what others see when they look at you", "@gender -- changing your player's gender", "@password -- changing your player's password", "@sethome -- changing your designated home room", "@rename -- changing your name and/or aliases", "@linelength -- adding word-wrap to the lines you see"}
@prop #60."summary" {} rc
;;#60.("summary") = {"Help is available on the following general topics:", "", "introduction -- what's going on here and some basic commands", "index -- index into the help system", "", "players -- setting characteristics of yourself", "movement -- moving yourself between rooms", "communication -- communicating with other players", "manipulation -- moving or using other objects", "miscellaneous -- commands that don't fit anywhere else", "", "building -- extending the MOO", "programming -- writing code in the MOO programming language", "editors -- editing text and code in the MOO", "", "@pagelength -- what to do if lines scroll off your screen too fast", "@linelength -- what to do if lines are truncated", "tinymud -- a list of equivalences between MOO and TinyMUD concepts/commands"}
@prop #60."@edit-options" {} rc
;;#60.("@edit-options") = {"Syntax:  @edit-option", "         @edit-option <option>", "", "Synonym:  @editoption", "", "The edit options customize the behavior of the various editors (mail editor, verb editor, etc...) to your particular taste.  The first form of this command displays all of your edit options.  The second form displays just that one option, one of the flags listed below.", "", "The remaining forms of this command are for setting your edit options:", "", "         @edit-option +<flag>", "         @edit-option -<flag>", "         @edit-option !<flag>           (equivalent to -<flag>)", "", "These respectively set and reset the specified flag", "", "-quiet_insert    insert (\") and append (:) echo back the line numbers", "+quiet_insert    insert (\") and append (:) produce no output", "-eval_subs       (VERB EDITOR) ignore .eval_subs when compiling verbs", "+eval_subs       (VERB EDITOR) apply .eval_subs to verbs being compiled", "-local           Use in-MOO text editors.", "+local           Ship text to client for local editing.", "-no_parens       include all parentheses in verb code.", "+no_parens       include only necessary parentheses in verb code.", "", "+parens        is a synonym for -no_parens", "+noisy_insert  is a synonym for -quiet_insert"}
@prop #60."@editoptions" {} rc
;;#60.("@editoptions") = {"*forward*", "@edit-options"}
@prop #60."@add-feature" {} rc
;;#60.("@add-feature") = {"Usage:  @add-feature  <object>", " @remove-feature <object>", "", "Add or remove a feature from your list.  A feature is an object which provides additional commands you can use.  For more information, see `help features'."}
@prop #60."@remove-feature" {} rc
;;#60.("@remove-feature") = {"*forward*", "@add-feature"}
@prop #60."@features" {} rc
;;#60.("@features") = {"Usage:  @features [<name>] [for <player>]", "", "List all of <player>'s features matching <name>, or all of <player>'s features if <name> is not supplied.  <player> defaults to you.  See `help features' for more information."}
@prop #60."features" {} rc
;;#60.("features") = {"Features are objects that provide you with commands not covered by the ordinary player objects.  The advantage of using features is that you can mix and match the things you like; whereas if you like a command that's defined on a player class, you have to also get all the commands it defines, and all the commands its ancestors define.", "", "You can list your features with the @features command, and add or remove features from your list with the @add-feature and @remove-feature commands."}
@prop #60."@rmalias" {} rc
;;#60.("@rmalias") = {"Syntax: @rmalias <alias>[,...,<alias>] from <object>", "        @rmalias <alias>[,...,<alias>] from <object>:<verb-name>", "        @rmalias# <alias>[,...,<alias>] from <object>:<verb-number>", "", "The first form is used to remove aliases from an object.  If the object is a valid player, space and commas will be assumed to be separations between unwanted aliases.  Otherwise, only commas will be assumed to be separations.", "Note that @rmalias will not affect the object's name, only its aliases.", "", "The second form is for use by programmers, to remove aliases from a verb they own.  All spaces and commas are assumed to be separations between unwanted aliases.", "", "The third form, @rmalias#, is for unambiguously referring to a verb on an object that might have more than one verb with the same name. The verb-number is the 1-based index of the verb as it appears in the verb() (or @verbs) output list."}
@prop #60."@addalias" {} rc
;;#60.("@addalias") = {"Syntax: @addalias <alias>[,...,<alias>] to <object>", "        @addalias <alias>[,...,<alias>] to <object>:<verb-name>", "        @addalias# <alias>[,...,<alias>] to <object>:<verb-number>", "", "The first form is used to add aliases to an object's list of aliases.  You can separate multiple aliases with commas.  The aliases will be checked against the object's current aliases and all aliases not already in the object's list of aliases will be added.", "", "Example:", "Muchkin wants to add new aliases to Rover the Wonder Dog:", "  @addalias Dog,Wonder Dog to Rover", "Since Rover the Wonder Dog already has the alias \"Dog\" but does not have the alias \"Wonder Dog\", Munchkin sees:", "  Rover the Wonder Dog(#4237) already has the alias Dog.", "  Alias Wonder Dog added to Rover the Wonder Dog(#4237).", "", "If the object is a player, spaces will also be assumed to be separations between aliases and each alias will be checked against the Player Name Database to make sure no one else is using it. Any already used aliases will be identified.  Certain other classes of objects (e.g., mail-recipients) also enforce rules about what aliases may be given them.", "", "Example:", "Munchkin wants to add his nicknames to his own list of aliases:", "  @addalias Foobar Davey to me", "@Addalias recognizes that Munchkin is trying to add an alias to a valid player and checks the aliases against the Player Name Database.  Unfortunately, DaveTheMan is already using the alias \"Davey\" so Munchkin sees:", "  DaveTheMan(#5432) is already using the alias Davey", "  Alias Foobar added to Munchkin(#1523).", "", "The second form of the @addalias command is for use by programmers, to add aliases to a verb they own.  All commas and spaces are assumed to be separations between aliases.", "", "The third form, @addalias#, is for unambiguously referring to a verb on an object in case there are more than one with the same name. The verb number is the 1-based index of the verb as it appears in the verbs() (or @verbs) output list."}
@prop #60."commands" {} rc
;;#60.("commands") = {"*forward*", "summary", "", "Type 'help <topic>' for information on a particular topic.", ""}
@prop #60." name" {} rc
;;#60.(" name") = {"Every object (including players, rooms, exits) has a name and a set of aliases. The object name is commonly used to display an object in various contexts. The object aliases are used to refer to an object when players type commands.", "Help is available on the following commands:", "@rename -- change the names or aliases of an object or yourself.", "@addalias, @rmalias -- add and remove aliases."}
@prop #60."@request-character" {} rc
;;#60.("@request-character") = {"Usage:    @request <player-name> for <email-address>", "", "Example:  @request Munchkin for msneed@baum.edu", "", "This command is available to Guest characters only.", "", "The @request command requests a new character, registered for your email address. Please use your primary address for this, as your password will be sent to the address provided."}
@prop #60."player-names" {} rc
;;#60.("player-names") = {"*subst*", "A player name must be a single word, must not contain any spaces, backslashes, or quotes, nor can it begin with the characters #, *, (, or ).  Finally it cannot be one that is in use by any other player nor any of the words on the following list:", "", "%;;lns={};for l in ($string_utils:columnize({@$player_db.stupid_names,@$player_db.reserved},6)) lns={@lns,\"  \"+l}; endfor return lns;", "", "Note that these rules apply as well to your single-word aliases, since those can equally well be used to refer to you in commands that match on player names (@who, whereis, ...).  There are no restrictions on your multi-word aliases, however the commands that expect player names will not recognize them."}
@prop #60."@registerme" {} rc
;;#60.("@registerme") = {"  @registerme as <email-address>", "This verb changes your registered email_address property. It will modify the registration, and then, to validate the email address, it will assign a new password and mail the password to the given email_address.", "If, for some reason, this is a problem for you, contact a wizard or registrar to get your email address changed.", "", "  @registerme", "Prints your registered email address."}
@prop #60."@eject!" {} rc
;;#60.("@eject!") = {"*forward*", "@eject"}
@prop #60."gopher" {} rc
;;#60.("gopher") = {"Gopher is an internet service for information retrieval. There are many gopher servers across the internet, providing a wide variety of information of all sorts: network news, weather, and White House press releases, campus class information, and scientific papers.", "", "The programmer interface to Gopher is contained in the object $gopher (`help $gopher')."}
@prop #60."options" {} rc
;;#60.("options") = {"Options allow you to customize the behavior of various commands.  Options are grouped into separate option packages that each affects a given class of related commands.  Each has its own help topic:", "", "  @mail-options    --- mail commands (@mail, @read, @next, @prev, @send...)", "  @edit-options    --- editing commands (@edit and commands within the editor)", "  @build-options   --- building commands (@create, @dig, @recycle)"}
@prop #60."@age" {} rc
;;#60.("@age") = {"Syntax:  @age [player]", "", "Displays the MOO age of the player if the player specified first connected after initial connections were recorded.", "MOO age is computed from the moment the player first connected until the current time."}
@prop #60."@edit" {} rc
;;#60.("@edit") = {"Syntax:  @edit <object>.<property>", "         @edit <object>:<verb-name> [<dobj> [<prep> [<iobj>]]]", "         @edit <object>", "", "Enters a MOO editor, as appropriate.", "", "Chooses the MOO Note editor for the named property, or the MOO verb editor for the named verb.  If no property or verb name is given, assumes property .text for a note object, or .description for any other object.", "", "See 'help editors' for more detail."}
@prop #60."@addfeature" {} rc
;;#60.("@addfeature") = {"*forward*", "@add-feature"}
@prop #60."communication" {} rc
;;#60.("communication") = {"There are several commands available to allow you to communicate with your fellow MOOers.  Help is available on the following communication-related topics:", "", "say      -- talking to the other connected players in the room", "whisper  -- talking privately to someone in the same room", "page     -- yelling to someone anywhere in the MOO", "emote    -- non-verbal communication with others in the same room", "gagging  -- screening out noise generated by certain other players", "news     -- reading the wizards' most recent set of general announcements", "@gripe   -- sending complaints to the wizards", "@typo @bug @idea @suggest", "         -- sending complaints/ideas to the owner of the current room", "whereis  -- locating other players", "@who     -- finding out who is currently logged in", "mail     -- the MOO email system", "security -- the facilities for detecting forged messages and eavesdropping."}
@prop #60."objects" {} r
;;#60.("objects") = {"Objects are the fundamental building blocks of the MOO.  Every object has a unique number, a name, an owner, a location, and various other properties.  An object can always be referred to by its number, and sometimes by its name or one of its aliases -- if you are in the same location as the object, for example, and also in some other special cases.", "", "For help on creating an object, see 'help @create'.", "", "For help on recycling an object, see 'help @recycle'.", "", "For help on finding information about specific objects, see 'help @display', 'help @show', and 'help $object_utils'."}
@prop #60." aliases" {} r
;;#60.(" aliases") = {"Every object on the MOO (players included) has a list of aliases, or names by which it can be referred.  This is useful when an object has a nice long descriptive name that you don't want to have to type every time you refer to it.", "", "Typing `exam object' will show you its aliases.  If you are a programmer, you can type `#<object>.aliases', using an object's number, or `#Munchkin.aliases p'.  (The `p' indicates that the prefix is a player's name.)", "", "See also `help #', `help @addalias', and `help @rmalias'."}
@prop #60."@check-full" {} rc
;;#60.("@check-full") = {"*forward*", "@check"}
@prop #60."@users" {} rc
;;#60.("@users") = {"Syntax:  @users", "", "Prints out the number of users currently connected and a list of their names, in alphabetical order."}
@prop #60."alias" {} rc
;;#60.("alias") = {"*forward*", " name"}
@prop #60."@add-alias" {} rc
;;#60.("@add-alias") = {"*forward*", "@addalias"}
@prop #60."@mode" {} r
;;#60.("@mode") = {"Syntax:  @mode <brief | verbose>", "", "Sets your current mode to either brief or verbose.  In brief mode, when you enter into a room, you will not see the room's description unless you explicitly type `look'.  Verbose is the default mode."}
@prop #60."wizard-names" {} rc
;;#60.("wizard-names") = {"*forward*", "wizard-list"}
@prop #60."backspace" {} rc
;;#60.("backspace") = {"Players sometimes have difficulty getting their backspace key to work.  This is an outside-MOO problem:  Whatever access software you have determines how the line you type is edited before the MOO ever sees it.  If your backspace key won't work here, you will probably need to consult with some documentation or a guru at your end.", "", "The above notwithstanding, here are a few things to try instead of backspace:", "", "   ctrl-h            (another way of typing backspace)", "   del               (delete character)", "   ctrl-backspace    (another way of typing delete character)", "   ctrl-w            (delete word left)", "   ctrl-u            (delete entire line)", "   ctrl-r            (redraw line)"}
@prop #60."spivak" {} rc
;;#60.("spivak") = {"The spivak pronouns were developed by mathematician Michael Spivak for use in his books.  They are the most simplistic of the gender neutral pronouns (others being \"neuter\" and \"splat\") and can be easily integrated into writing.  They should be used in a generic setting where the gender of the person referred to is unknown, such as \"the reader.\"  They can also be used to describe a specific individual who has chosen not to identify emself with the traditional male or female gender.", "", "The spivak pronouns are", "E      - subjective", "Em     - objective", "Eir    - possessive (adjective)", "Eirs   - possessive (noun)", "Emself - reflexive"}
@prop #60."web" {} rc
;;#60.("web") = {"  The MOO's web access is based on the BioGate system and allows users to add and perceive multimedia information associated with MOO objects.", "", " Some commands for adding and examining web links and HTML text associated with MOO objects are:", "", "@url -- examine or add a URL link ", "@html -- examine or add an HTML document", "@icon -- examine or add an icon link", "@weblink -- link an object via a text line or an image", "@htmledit -- use the HTML editor", "@set-web -- set various web characteristics of an object", "@webpass -- get or set a web password for HTTP/0.9 access", "@web-options -- get or set various web options for your MOO character", "VRML -- about the MOO's Virtual Reality Modeling Language capabilities"}
@prop #60."@html" {} rc
;;#60.("@html") = {"*forward*", "@url"}
@prop #60."@url" {} rc
;;#60.("@url") = {"Syntax: @url <object> is <url enclosed in double quotes>", "        @url for <object>", "        @html <object> is", "        @html for <object>", "        @vrml for <object>", "", "  These let you read or set the associated URL link, in-MOO HTML", "document, or VRML description associated with an object.  The \"for\"", "forms show you the current value, while the \"is\" forms let you set a", "new value.  The @vrml command only has a \"for\" form, and you should", "use @vrmledit to set an object's VRML description. Note that the URL", "specified in the \"@url\" command should be enclosed in double quotes.", "  Objects may have either a URL associated with them (generally", "pointing to either an image or an web page outside the MOO) or can", "have the text of an HTML document.  They cannot have both, but this", "is not a limitation since you can associate an HTML document with an", "object and that can have as many links to images or outside web pages", "that you wish.  Note that the format for entering an HTML document", "will cause you to be prompted for lines of that document.", " IMPORTANT: The @vrml command will give you a room's interior VRML", "description if you're in the room at the time, else its exterior VRML", "description.", "", "Related commands:", "@htmledit -- use the HTML editor to enter an HTML document", "@weblink -- a quick way to automatically build a small HTML document", "            that uses either text or an image as the link to an", "            outside document.", "vrml -- information about the VRML system"}
@prop #60."@icon" {} rc
;;#60.("@icon") = {"Syntax: @icon <object> is <url enclosed in double quotes>", "        @icon for <object>", "", "  The command displays or sets the URL for the icon associated with", "an object.  Note that the URL must be enclosed in double quotes."}
@prop #60."@htmledit" {} rc
;;#60.("@htmledit") = {"Syntax: @htmledit <object>", "", "  Moves you to the HTML Editor, allowing you to edit the HTML", "document associated with an object.  The HTML editor is mostly like", "the Note Editor. One difference is that the modes are \"URL\" (a single", "line of text only) or \"HTML\" (an HTML document of one or more lines)."}
@prop #60."@set-web" {} rc
;;#60.("@set-web") = {"Syntax: @set-web <setting name> on <object>", "", "  Allows you to set or read various settings associated with the web", "properties of an object.  These may be MOO-wide properties or ones", "specifically associated with a particular class of object.", "  If you omit the <setting name> you'll be presented with a list of", "all the web settings on the object and their current values.  If you", "specify a web setting by name you'll be prompted for the new value", "of that setting.", "", "MOO-wide Web Settings:", "", "bodytag_attributes", "  The attributes text of the <BODY> tag, used to set the background", "and text colors for the web page associated with an object. Note that", "objects take on the web background properties of the room they're in", "unless they have their own bodytag_attributes setting. An example:", "  BGCOLOR=\"#D0D0D0\"  BACKGROUND=\"http://node.edu/images/sample.gif\"", "", "hide_banner", "  Suppresses the MOO's banner within the web page generated for the", "object.  Any non-empty value for \"hide_banner\" will work.", "", "preformatted", "  If this web setting is present and not empty, the entire text of", "the HTML document associated with the object is wrapped in <PRE> ...", "</PRE> tags, indicating it should be displayed using a", "non-proportional font.", ""}
@prop #60."@weblink" {} rc
;;#60.("@weblink") = {"Syntax: @weblink <object> to <URL>", "", "  Used to associate an outside web page with the specified object.", "If the object already has a URL with a string value (presumably", "the address of an in-line image, like a GIF format file), it assumes", "you wish that image to serve as the hyperlink to <URL>.", "  If the URL is a list (an HTML document), it warns you and asks if", "you want to clear it and enter some text to serve as the hyperlink.", "If no URL is set on the object, it asks for the text you wish to", "serve as a hyperlink to <URL>.", "  This command actually constructs a small HTML document (generally", "one or two lines) and attaches it to the object.  It uses the", "information already associated with the object as described above to", "determine what sort of HTML document to construct.", "", "Related commands:", "@url -- set or read the associated URL", "@html -- set or read the associated HTML document", ""}
@prop #60."@vrmledit" {} rc
;;#60.("@vrmledit") = {"Syntax: @vrmledit <object>", "", "Moves you into the note editor and loads the VRML description text", "for the <object>.  Note that rooms have both exterior and interior", "VRMl descriptions. If you are standing in a room and use \"@vrmledit", "here\" then you'll be editing its interior description. Otherwise,", "you'll be editing its exterior one."}
@prop #60."@scale-vrml" {} rc
;;#60.("@scale-vrml") = {"Syntax: @scale-vrml <object> with <scaling specification>", "        @scalevrml <object> with <scaling specification>", "        @scale <object> with <scaling specification>", "        @scale <object> with", "        @scale <object> with 0", "", "  Shrinks or grows the object's VRML representation according to the", "scaling specification.  The cases of omitting the specification or", "specifying zero have special meanings.  Omitting the scaling", "specifications returns the current scaling. Specifying a scaling of", "zero resets the scaling to 1.0:1.0:1.0 (ie. the unmodified object", "size).", "  Scaling specifications may be a single value, in which case a", "uniform scaling is implied (applied across the X, Y, and Z-axes).", "For instance, \"@scale dog is 200%\" means increase the dog's size", "two-fold.  Two other ways of performing the same action with slightly", "different commands are \"@scale dog is 2x\" and \"@scale dog is 2\" where", "the latter implies \"fold-scaling\" and not percentage.", "  IMPORTANT! The scaling you specify is applied on top of the", "current scaling setting. If the X-axis setting was already 2.0 and", "you specify another 2.0 scaling, the result is a 4.0 X-axis scaling", "value.", "  If you specify more than one number (either comma or space", "delimited), they are applied as first X, then Y, then Z-axis", "scalings. Omitting a value implies a scaling of 1 (ie. unchanged).", "Using \"@scale dog 2, ,4\" is the same as \"@scale dog 2,1,4\" for", "instance."}
@prop #60."@webpass" {} rc
;;#60.("@webpass") = {"Syntax: @weblink <object> to <URL>", "", "  Used to associate an outside web page with the specified object.", "If the object already has a URL with a string value (presumably", "the address of an in-line image, like a GIF format file), it assumes", "you wish that image to serve as the hyperlink to <URL>.", "  If the URL is a list (an HTML document), it warns you and asks if", "you want to clear it and enter some text to serve as the hyperlink.", "If no URL is set on the object, it asks for the text you wish to", "serve as a hyperlink to <URL>.", "  This command actually constructs a small HTML document (generally", "one or two lines) and attaches it to the object.  It uses the", "information already associated with the object as described above to", "determine what sort of HTML document to construct.", "", "Related commands:", "@url -- set or read the associated URL", "@html -- set or read the associated HTML document"}
@prop #60."VRML" {} r #96
;;#60.("VRML") = {"You can generally switch from web view to VRML view by selecting the \"View VRML\" link in the web viewer's button bar.  You can get back to the web view by either selecting the \"web\" icon you'll see in the VRML view, or by selecting an object in the room.  ", "", "The VRML/1.0 system has a small number of commands that allow you to", "    1. assign a VRML description to any MOO object", "    2. move and turn MOO objects in space", "", "@vrml  -- list the VRML description lines associated with an object", "@vrmledit -- edit the VRML description on an object", "slide -- slide an object north, south, up, etc.", "twist -- twist an object clockwise (cw) or counterclockwise (ccw)", "tilt -- tilt an object toward a compass direction (tip it)", "@scale-vrml -- shrink or grow an object", "@set-vrml -- change optional VRML settings on an object", "web -- about the MOO's other web-based features"}
@prop #60."@web-options" {} r #96
;;#60.("@web-options") = {"Syntax: @web-options", "        @weboptions", "        @weboption +<option>", "        @weboption -<option>", "        @weboption <option>=<value>", "", "See current web option settings with @weboptions or @web-options.", "Set various web options on or off with the +/- forms or set a value", "(where appropriate) with the \"=\" form.  The latter set is marked", "below with (=).", "", "Options:", "", "inv - show whon the web page what you're carrying", "map - show the campus map on the page", "hideicons - you don't want to see object's icons", "hidebanner - you don't want to see the MOO's banner on every page", "exitdetails - you want to see what room each exit leads to", "markURL - add a star next to the name of object that have some novel", "    URL set", "commandform - include a command form with fields for \"say,\" @go, and", "    others", "nogo - don't include a section for @go in the command form", "nopage - don't include a section for paging in the command form", "viewer - set the object number of the viewer you wish to be your", "    default (=)", "background - set the background graphic for all your web pages (=)", "bgcolor - set the background color for all your web pages (=)", "nobackgrounds - you don't want you rweb page to have any background", "    set", "textcolor - set the color of your web page text (=)", "linkcolor - set the color of your web page's link text (=)", "vlinkcolor - set the color of your web page's visited link text (=)", "alinkcolor - set the color of your web page's active link text (=)", "applinkdown - put the link to the web applications list at the page", "    bottom", "ghosts - you want to notice when web ghosts inter the room", "use_ip - all links to the MOO on your web page should be i.p. numbers", "tight_link - require that both web and telnet/client links be from", "    the same machine", "nosay - you don't want a \"say\" field on your command form", "embedVRML - embed a VRML box in your web viewer page"}
@prop #60."@set-vrml" {} rc
;;#60.("@set-vrml") = {"Syntax: @set-vrml <setting name> on <object>", "", "  Allows you to set or read various settings associated with the VRML", "properties of an object.  These may be MOO-wide properties or ones", "specifically associated with a particular class of object.", "  If you omit the <setting name> you'll be presented with a list of", "all the VRML settings on the object and their current values.  If you", "specify a VRML setting by name you'll be prompted for the new value", "of that setting.", "  To change the value of a VRML setting, just repeat the command and", "enter the new value when prompted. To remove a setting from the list", "associated with the object, just enter an empty line for the value", "and you'll be asked if you want to clear it (say yes).", "", "lights", "  The text for the room's lights, normally retrieved from", "$vrml_utils.std_roomlights, can be overridden with this web setting.", "This is only valid for a room.", "", "linkzone", "  The place where various link objects that go in every room should", "appear (ie. the \"link to web\" object) can be overridden with this", "VRML setting.  The $vrml_utils.std_linkzone property has the default", "value.  This is only valid for a room."}
@prop #60."slide" {} rc
;;#60.("slide") = {"Syntax:", "  slide <object> <direction> <distance> <units>", "  twist <object> clockwise|counterclockwise <angle> <units>", "  tilt <object> north|south... <angle> <units>", "", "Examples: slide table north 2 meters", "          tilt candle south 45 degrees", "          twist stove clockwise 90 degrees", "", "Directions may be abbreviated:", "    n, s, e, w, se, sw, ne, nw, d, u, cw, ccw", "Angle and distance must be integer numbers (to be upgraded in a", "future release so that non-integers are allowed also).", "Distance units may be any of:", "    mm, cm, m, km, in, ft, yd", "Angle units may be any of: degree or radian", "", "  Use these commands to move MOO objects though space within a room.", "\"Slide\" objects to translate then up, down, or toward any compass", "point.  \"Twist\" objects to rotate them around the Y-axis, either", "clockwise or counterclockwise.  \"Tilt\" object to tip their tops", "toward the direction you indicate.  Tilting north eans rotating an", "object in a positive direction around the X-axis.  Note that by MOO", "convention, the north is the negative Z-axis (the ones most browsers", "will have you facing when you enter a new room) and east is the", "positive X-axis.  The Y-axis points up."}
@prop #60."twist" {} rc
;;#60.("twist") = {"*forward*", "slide"}
@prop #60."tilt" {} rc
;;#60.("tilt") = {"*forward*", "slide"}
@prop #60."@vrml" {} rc
;;#60.("@vrml") = {"*forward*", "@url"}
;;#60.("index_cache") = {"gen-index"}
;;#60.("description") = {"The object $help is the main help database.  For every help topic there is a corresponding property on $help, interpreted as follows:", "", "$help.(topic) = string           - one-line help text.", "$help.(topic) = {\"*verb*\",@args} - call this:verb(args,{}) to get text", "$help.(topic) = any other list   - multi-line help text", "", "There is also a \"\" property which applies in the case of `help' typed without any arguments.", "", "See the description of $generic_help for more detail."}
;;#60.("object_size") = {80579, 855068591}
;;#60.("web_calls") = 78
;;#60.("vrml_coords") = {{189, -353, 2651}, {0, 0, 0}, {1000, 1000, 1000}}
;;#60.("vrml_desc") = {"Material {diffuseColor 0.56 0.76 0.26}", "Cube {width 0.72 height 0.46 depth 0.95}"}

@verb #60:"player_quota" this none this rxd #2
@program #60:player_quota
return $player.ownership_quota;
.

@verb #60:"prog_quota" this none this rxd #2
@program #60:prog_quota
return $prog.ownership_quota;
.

@verb #60:"get_topic" this none this rxd #2
@program #60:get_topic
text = pass(@args);
object = $string_utils:match_object(what = args[1], player.location);
if ((text != E_PROPNF) || (!valid(object)))
  return text;
elseif (ohelp = `object:help_msg() ! ANY' || `object.help_msg ! ANY')
  return {tostr(object.name, " (", object, "):"), "----", @(typeof(ohelp) == LIST) ? ohelp | {ohelp}};
else
  about = $object_utils:has_verb(object, "about");
  return {tostr("Sorry, but no help is available on ", object.name, " (", object, ")."), tostr("Try `@examine ", what, "'", @about ? {" or `about ", what, "'"} | {}, ".")};
endif
.

@verb #60:"find_topics" this none this rxd #2
@program #60:find_topics
topiclist = pass(@args);
if (topiclist || (!args))
  return topiclist;
elseif (valid(o = $string_utils:match_object(what = args[1], player.location)))
  return {what};
else
  return {};
endif
.

@verb #60:"full_index" this none this
@program #60:full_index
text = {};
for db in ($code_utils:help_db_list())
  if ($object_utils:has_callable_verb(db, "index"))
    text = {@text, @db:index({tostr(db.name, " (", db, ")")})};
  endif
endfor
return text;
.

@verb #60:"index_list" this none this
@program #60:index_list
hdr = "Available Help Indices";
text = {"", hdr, $string_utils:space(hdr, "-")};
for db in ($code_utils:help_db_list())
  try
    for p in (db:find_index_topics())
      text = {@text, tostr($string_utils:left(p, 14), " -- ", `db.(p)[2] ! ANY' || db.name, " (", db, ")")};
    endfor
  except (ANY)
    "generally it will be E_TYPE when :find_index_topics returns an ERR. Just skip";
    continue db;
  endtry
endfor
if (full = this:find_full_index_topic())
  text = {@text, "", tostr($string_utils:left(full, 14), " -- ", "EVERYTHING")};
endif
return text;
.

@verb #60:"wizard_list" this none this rxd #2
@program #60:wizard_list
wizzes = {};
for w in ($object_utils:leaves($wiz))
  if (w.wizard && (w.advertised && is_player(w)))
    wizzes = {@wizzes, w};
  endif
endfor
wizzes = {#2, @$list_utils:randomly_permute(setremove(wizzes, #2))};
numwiz = length(wizzes);
hlist = {"ArchWizard:", "Wizard" + ((numwiz == 2) ? ":" | "s:"), @$list_utils:make(max(0, numwiz - 2), "")};
slist = {};
su = $string_utils;
for i in [1..numwiz]
  wiz = wizzes[i];
  slist = {@slist, tostr(su:left(hlist[i], 13), su:left(wiz.name, 16), (wpi = `wiz.public_identity.name ! ANY') ? (" (a.k.a. " + wpi) + ")" | "")};
endfor
return slist;
.

@verb #60:"dump_topic" this none this
@program #60:dump_topic
if (((text = pass(@args)) != E_PROPNF) || ((!valid(object = $string_utils:match_object(what = args[1], player.location))) || (!$object_utils:has_property(object, "help_msg"))))
  return text;
else
  return {tostr(";;", $code_utils:corify_object(object), ".help_msg = $command_utils:read_lines()"), @$command_utils:dump_lines((typeof(text = object.help_msg) == LIST) ? text | {text})};
endif
.

@verb #60:"find_full_index_topic" this none this
@program #60:find_full_index_topic
":find_full_index_topic([search])";
"Return the *full_index* topic or 0";
"If search argument is given and true, we don't depend on cached info.";
{?search = 0} = args;
"... N.B.  There is no cached info; it turns out that";
"... full-index is near enough to the beginning of $help's property list";
"... that there's no point to doing this.  --Rog";
for p in (`properties(this) ! E_PERM => {}')
  if (`this.(p)[1] ! ANY' == "*full_index*")
    return p;
  endif
endfor
return 0;
.

@verb #60:"html" this none this rxd #95
@program #60:html
"Uses 'search' or 'rest' to determine which help topic was requested";
"If none requested, returns the text for 'summary'.";
"If the request is an ambiguous match or if the requested topic has";
"'-index' in it, returns the results in 'index' format (columnized).";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
rest = args[2];
search = args[3];
topic = (search || rest) || "summary";
help = $code_utils:help_db_search(topic, dblist = $code_utils:help_db_list());
text2 = {};
if (!help)
  text = {("Sorry, but there is no help on \"" + topic) + "\"."};
  help = {"", topic};
elseif (help[1] == $ambiguous_match)
  text = {"Sorry, but that matches more than one possible help topic:<BR>"};
  su = $string_utils;
  title = "Possible Matches";
  text = {@text, ("<BR><B>" + title) + "</B>", this:web_index(this:columnize(@this:sort_topics(help[2])))};
  help = {"", topic};
else
  dblist = dblist[1 + (help[1] in dblist)..length(dblist)];
  text = help[1]:get_topic(help[2], dblist);
  if (typeof(text) != LIST)
    text = {"<H3>Sorry!</H3> The help display seems to be broken."};
  elseif (index(topic, "-index"))
    text = this:web_index(text);
  else
    text = $web_utils:plaintext_to_html(text);
    for line in (text)
      ((seconds_left() < 2) || (ticks_left() < 4000)) ? $command_utils:suspend_if_needed(1) | 0;
      if (index(line, "Syntax: "))
        text2 = {@text2, "<B>Syntax:</B><BR>"};
        line = line[9..length(line)];
      endif
      if (mtch = $string_utils:match_string(line, "* -- *"))
        link = ((((((("<A HREF=\"&LOCAL_LINK;/" + $web_utils:get_webcode()) + "/") + tostr(tonum(this))) + "/") + strsub(mtch[1], " ", "")) + "#focus\">") + mtch[1]) + "</A>";
        text2 = {@text2, (link + " -- ") + mtch[2]};
      else
        text2 = {@text2, line};
      endif
    endfor
  endif
endif
if ((topic == "summary") && $web_utils.web_helppage)
  "  was  $web_utils.web_helppage  Set to look at info sign (#193)";
  text2 = {@text2 || text, tostr(("<P>A <A HREF=\"&LOCAL_LINK;/" + $web_utils:get_webcode()) + "/193#focus\">condensed summary of commonly used commands</A> is available.")};
endif
return {("<P><B>Help on: " + help[2]) + "</B><P>", @text2 || text, "<ISINDEX PROMPT=\"You can search the help index by entering a term here  \">"};
"Last modified Sun Aug 25 21:35:22 1996 IDT by EricM (#3264).";
.

@verb #60:"web_index" this none this rxd #95
@program #60:web_index
"web_index( text in 'index' form LIST) -> HTML doc LIST";
"Takes a list of strings in the format generated by";
"$generic_help:index and converts it into hyperlinked HTML doc form.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
link1 = ((("<A HREF=\"&LOCAL_LINK;/" + $web_utils:get_webcode()) + "/") + tostr(tonum(this))) + "/";
link2 = "#focus\">";
link3 = "</A>";
len = length(text = (typeof(args[1]) == STR) ? {args[1]} | args[1]);
for line in [1..len]
  ((seconds_left() < 2) || (ticks_left() < 4000)) ? suspend(1) | 0;
  if ((text[line] && (text[line][1] != "-")) && ((line == len) || ((!text[line + 1]) || (text[line + 1][1] != "-"))))
    commands = $string_utils:explode(text[line]);
    subline = "";
    comlen = length(commands);
    for command in [1..comlen]
      filler = ((command < comlen) && ((l = length(commands[command])) < 20)) ? $string_utils:space(20 - l, ".") | "";
      subline = (((((subline + link1) + commands[command]) + link2) + commands[command]) + link3) + filler;
    endfor
    text[line] = subline;
  endif
endfor
return {"<PRE>", @text, "</PRE>"};
"Last modified Thu Nov  2 09:00:58 1995 IST by EricM (#3264).";
.

"***finished***
