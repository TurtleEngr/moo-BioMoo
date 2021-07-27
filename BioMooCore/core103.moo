$Header: /repo/public.cvs/app/BioGate/BioMooCore/core103.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #103 with create
@create $feature named Assorted Web Commands:Assorted Web Commands,web commands,webFO
;;#103.("help_msg") = {">> Quick Summary for Adding Images and Links to Objects <<", "", "When you attach an image to your object, or link to some other", "outside resource like an HTML page, you must specify an internet", "address (<URL>).  When specifying a URL, enclose it in double quotes", "(e.g. \"http://here.org/doc.html\"). Omit the single quotes and angle", "brackets used to delineate the examples below.", "", "--To add an image to your object, use '@url <object> is <URL>'", "--To determine the URL of an image on an object, use '@url for <object>'", "--To add to your object some text that serves as a hyperlink to an", "image or HTML document, use:", "    @weblink <object> to <URL> (you'll be asked what the text should be)", "--To add an image to an object, where the image is itself a hyperlink", "to an image or HTML file, use:", "    @url <object> is <URL of image to appear on the object>", "then:", "    @weblink <object> to <URL of file your object's image links to>", "--To add an HTML document directly to your object, use '@url <object> is'", "and don't specify a URL, or to use an editor, type '@url-edit <object>'", "--To read an HTML document on an object, use '@url for <object>'", "Note that the command '@url' has a synonym '@html'.", "--To add an icon to your object, type '@icon <object> is <URL>'", "--To determine the URL of an object's icon, use '@icon for <URL>'", "_______________________", "", "@webcalls", "  Usage:  @webcalls for <object>", "          @webcalls", "Reports approximately how many times an object has been viewed via", "the web.  Omitting the object give just the total web calls for the", "whole MOO since the BioWeb system was installed.", "", "_______________________", "Less useful and probably can be deleted:", "", "@url-external", "  Usage:  @url-ex <object> with <quoted text>", "  This converts the already set URL for <object> to be external", "instead of in-line on the person's web page, and uses <quoted text>", "as the hyperlink that appears on the web browser's page."}
;;#103.("feature_verbs") = {}
;;#103.("aliases") = {"Assorted Web Commands", "web commands", "webFO"}
;;#103.("description") = "This is the Generic Feature Object.  It is not meant to be used as a feature object itself, but is handy for making new feature objects."
;;#103.("object_size") = {4930, 937987203}

@verb #103:"@URL-ex*ternal" any with any rxd #95
@program #103:@URL-external
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if ($command_utils:object_match_failed(dobj, dobjstr))
  return;
elseif ((!(old_URL = dobj:get_url())) || (!dobj:really_has_url()))
  player:tell("There is no URL set for ", dobj:name(1), ".");
  return;
elseif (!$perm_utils:controls(caller_perms(), dobj))
  player:tell("Sorry, but you can only manipulate the URL of objects you own.");
  return;
elseif (!iobjstr)
  player:tell("You must specify some sort of text to serve as the hypertext linked to ", dobj:name(1), ".");
  return;
elseif (typeof(old_URL) != STR)
  player:tell("The presently set URL for ", dobj:name(1), " is not a simple URL (a string).  Using this command on it would make no sense.");
  return;
endif
dobj:set_url({((("<A HREF=\"" + old_URL) + "\">") + iobjstr) + "</A>"});
player:tell("URL for ", dobj:name(1), " is now external with associated hypertext '", iobjstr, "'.");
"Last modified Thu Aug 15 02:43:08 1996 IDT by EricM (#3264).";
.

@verb #103:"webcalls @webcalls" any any any rxd
@program #103:webcalls
"Usage: @webcalls for <object>";
"Reports approximately how many times an object has been viewed via the web";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (args)
  if ($command_utils:object_match_failed(iobj, iobjstr))
    return;
  endif
  player:tell(iobj:namec(1), " has been viewed via the web ", iobj.web_calls, (iobj.web_calls == 1) ? " time." | " times.");
endif
player:tell("Total overall MOO web usage to date: ", $http_handler.total_webcalls, " connections");
"Last modified Sun Apr 28 21:43:05 1996 IDT by EricM (#3264).";
.

"***finished***
