$Header: /repo/public.cvs/app/BioGate/BioMooCore/core105.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #105 with create
@create $generic_utils named webMOO code utilities:webMOO code utilities,web_utils
@prop #105."html_entity_subs" {} r
;;#105.("html_entity_subs") = {{"<", "&lt;"}, {">", "&gt;"}, {"&", "&amp;"}}
@prop #105."entity_subs" {} r
;;#105.("entity_subs") = {"-", "<", ">", "&"}
@prop #105."entity_codes" {} r
;;#105.("entity_codes") = {"lt", "gt", "amp"}
@prop #105."encoding_data" {} r
;;#105.("encoding_data") = {{"A", "0"}, {"B", "1"}, {"C", "2"}, {"D", "3"}, {"E", "4"}, {"F", "5"}, {"G", "6"}, {"H", "7"}, {"I", "8"}, {"J", "9"}, {"K", "10"}, {"L", "11"}, {"M", "12"}, {"N", "13"}, {"O", "14"}, {"P", "15"}, {"Q", "16"}, {"R", "17"}, {"S", "18"}, {"T", "19"}, {"U", "20"}, {"V", "21"}, {"W", "22"}, {"X", "23"}, {"Y", "24"}, {"Z", "25"}, {"a", "26"}, {"b", "27"}, {"c", "28"}, {"d", "29"}, {"e", "30"}, {"f", "31"}, {"g", "32"}, {"h", "33"}, {"i", "34"}, {"j", "35"}, {"k", "36"}, {"l", "37"}, {"m", "38"}, {"n", "39"}, {"o", "40"}, {"p", "41"}, {"q", "42"}, {"r", "43"}, {"s", "44"}, {"t", "45"}, {"u", "46"}, {"v", "47"}, {"w", "48"}, {"x", "49"}, {"y", "50"}, {"z", "51"}, {"0", "52"}, {"1", "53"}, {"2", "54"}, {"3", "55"}, {"4", "56"}, {"5", "57"}, {"6", "58"}, {"7", "59"}, {"8", "60"}, {"9", "61"}, {"+", "62"}, {"/", "63"}}
@prop #105."decoding_data" {} r
;;#105.("decoding_data") = {{"0", "A"}, {"1", "B"}, {"2", "C"}, {"3", "D"}, {"4", "E"}, {"5", "F"}, {"6", "G"}, {"7", "H"}, {"8", "I"}, {"9", "J"}, {"10", "K"}, {"11", "L"}, {"12", "M"}, {"13", "N"}, {"14", "O"}, {"15", "P"}, {"16", "Q"}, {"17", "R"}, {"18", "S"}, {"19", "T"}, {"20", "U"}, {"21", "V"}, {"22", "W"}, {"23", "X"}, {"24", "Y"}, {"25", "Z"}, {"26", "a"}, {"27", "b"}, {"28", "c"}, {"29", "d"}, {"30", "e"}, {"31", "f"}, {"32", "g"}, {"33", "h"}, {"34", "i"}, {"35", "j"}, {"36", "k"}, {"37", "l"}, {"38", "m"}, {"39", "n"}, {"40", "o"}, {"41", "p"}, {"42", "q"}, {"43", "r"}, {"44", "s"}, {"45", "t"}, {"46", "u"}, {"47", "v"}, {"48", "w"}, {"49", "x"}, {"50", "y"}, {"51", "z"}, {"52", "0"}, {"53", "1"}, {"54", "2"}, {"55", "3"}, {"56", "4"}, {"57", "5"}, {"58", "6"}, {"59", "7"}, {"60", "8"}, {"61", "9"}, {"62", "+"}, {"63", "/"}}
@prop #105."page_banner" "<p><img src=\"http://aslweb.mayfield.hp.com/~bruce/image/logo_goes.gif\" alt=\"Global Online Education Support, an HP Education server\" align=bottom border=0></p>" r
@prop #105."headers" {} ""
@prop #105."MOO_home_page" "http://aslweb.mayfield.hp.com/~bruce/refdesk/muve" r
@prop #105."uparrow_icon" "[Top of Page] " r
@prop #105."std_bkgnd" "" r
@prop #105."std_bgcolor" "white" r
@prop #105."std_textcolor" "" r
@prop #105."std_linkcolor" "" r
@prop #105."std_vlinkcolor" "" r
@prop #105."std_alinkcolor" "" r
@prop #105."eol" "<EOL>" ""
@prop #105."interior_rooms" {} r
;;#105.("interior_rooms") = {#121}
@prop #105."web_helppage" "/view/193#focus" r
;;#105.("help_msg") = {"Plain text to HTML text", "", "Many of these accept a text of type STR or type LIST and return a modified text of the same type as the submitted one.", "", "  :html_entity_sub(text LIST or STR ,[suspended BOOL]) -> HTML text LIST or STR", "Uses the values in this.html_entity_sub to replace characters with", "HTML entity codes.", "  :add_linebreaks(text LIST or STR [, paragraphs BOOL]) -> HTML text LIST or STR", "Adds the <BR> tag to the end of a string or each string in a list of", "strings.", "  :blockquote*_tabbed_lines(text LIST or STR) -> html text LIST or STR", "Looks for lines that start with five or more spaces and surrounds", "that line with HTML blockquote tags.", "  :format_tab*bed(text LIST or STR) -> HTML text LIST or STR", "Finds lines with five or more spaces at their start and adds", "<PRE></PRE> tags around each.", "  :blankline_to_linebreak(text LIST or STR) -> HTML text LIST or STR", "Searches for lines with no text and inserts a <BR> tag there", "  :insert_line_tag(text LIST or STR [, tag STR]) -> HTML text LIST or STR", "Adds the HTML tag <LI> in front of each line of text, by default.", "Will use 'tag' instead of one is given.", "  :preformat(text LIST, width NUM [,line break STR]) -> html text LIST", "Preformats the text to the given width.  Breaks lines at spaces if", "possible. Uses the given line break string or defaults to <BR>", "  :substitute_suspended(string,{{redex1,repl1},{redex2,repl2},{redex3,repl3}...}[,case])", "Same as $string_utils:substitute but may suspend.", "", "WebMOO text processing", "", "  :webMOO_to_html(text LIST or STR) -> HTML text LIST or STR", "Converts text in \"webMOO\" format into HTML text.", "  :webMOO_to_text(HTML text LIST or STR) -> text LIST or STR", "Converts text in \"webMOO\" format into plain text.", "", "Special webapp result processing", "", "  :format_webapp_result_to_html(header-footer LIST, body-text STR or LIST) -> HTML document", "Accepts the result of a webapp call and processes it to HTML text.", "", "Build URL-containg tags", "  :english_list_with_urls(text STR) -> HTML text STR", "Like $string_utils:english_list but converts objects to their names and adds the associated URL if needed.", "  :build_MIME(url STR) -> HTML text LIST", "Takes a string, presumed to be a URL, and tries to make it into the", "proper HTML text based on the file extension.", "", "Webapp specification", "", "  :user_webviewer(who OBJ) -> webapp OBJ;", "Returns the default webviewer for user 'who'", "  :rtn_to_viewer([who OBJ] [, text link STR]) -> HTML fragment STR", "Returns a string with a hyperlink to the user's default web viewer", "webapp.", "  :get_webcode() -> STR", "Returns the webcode of the webapp first contacted in a web transaction.", "", "Image maps and forms", "", "  :interpret_map(click LIST, {{regiontype STR, point LIST, ...}, ...} -> region NUM", "Determines if the 'click' {X-value NUM, Y-value NUM} is in any of the", "defined regions.", "  :parse_form(data stream STR [, format NUM) -> form data LIST", "Accepts a string encoding a web form, and extracts out the fields as", "list elements.  'format' determines the result format.", "", "Security", "", "  :access_security() -> {level NUM, description STR}", "Reports the web security level of the current task.", "  :is_webcall() -> STR", "Returns true if the current task is a web transaction.", "  :mmdecode(encoded STR) -> decoded STR", "Performs mmdecoding (RFC-1113).", "  :url_decode( STR data) -> STR decoded", "Accepts a URL-encoded string and returns plain text.", "  :url_encode( STR data) -> STR encoded", "Replaces characters not permitted in URLs with escaped ASCII number", "equivalents."}
;;#105.("aliases") = {"webMOO code utilities", "web_utils"}
;;#105.("description") = {"  This is the webMOO code utilities object.  Try 'help <this object>'", "for a detailed list of what functions it can perform."}
;;#105.("object_size") = {44904, 937987203}

@verb #105:"html_entity_sub entity_sub" this none this
@program #105:html_entity_sub
"html_entity_sub(text LIST or STR [, suspended BOOLEAN}) -> LIST or STR";
"Uses the values in this.html_entity_sub to perform substitutions of";
"html entities for text in the string or list of strings that it's";
"sent.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
text = args[1];
susp = (length(args) > 1) ? args[2] | 0;
if (typeof(text) == STR)
  return $string_utils:substitute_suspended(text, this.html_entity_subs);
endif
result = {};
for line in (text)
  result = {@result, $string_utils:substitute_suspended(line, this.html_entity_subs)};
  (susp && ((seconds_left() < 2) || (ticks_left() < 6000))) ? suspend(1) | 0;
endfor
return result;
"Last modified Tue Aug 27 21:57:21 1996 IDT by EricM (#3264).";
.

@verb #105:"add_linebreaks*_suspended" this none this
@program #105:add_linebreaks_suspended
"Adds the text '<BR>' to the end of a string, or to the end of each";
"string in a list of strings.  Returns a value of the same type as";
"it's sent.  If a second argument is present and true, then if the";
"next line in a list begins with two or more spaces, a <P> is";
"substituted instead of a <BR>.";
"The verb called with `suspended' may suspend.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
text = args[1];
suspend_ok = index(verb, "add_linebreaks_s");
if (typeof(text) == STR)
  return text + "<BR>";
endif
result = {};
if (((length(args) > 1) && args[2]) && (length(text) > 1))
  textlen = length(text);
  for line in [1..textlen]
    if (((line < textlen) && (length(text[line + 1]) > 1)) && (text[line + 1][1..2] == "  "))
      result = {@result, text[line] + "<P>"};
    else
      result = {@result, text[line] + "<BR>"};
    endif
    if (suspend_ok && $command_utils:running_out_of_time())
      suspend(1);
    endif
  endfor
else
  for line in [1..length(text)]
    result = {@result, text[line] + "<BR>"};
    if (suspend_ok && $command_utils:running_out_of_time())
      suspend(1);
    endif
  endfor
endif
return result;
"Last modified Tue Oct  1 03:46:47 1996 IST by EricM (#3264).";
.

@verb #105:"plaintext_to_html" this none this
@program #105:plaintext_to_html
"Takes a string or list of strings, performs html entity substitutions,";
"adds a '<BR>' to the end of every string, and returns a list of strings";
"If a second argument is included, and is true, lines after the first";
"that begin with two or more spaces are preceeded with a <P> instead";
"of a <BR>";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
text = args[1];
p = (length(args) > 1) ? !(!args[2]) | 0;
text = this:add_linebreaks_suspended(this:html_entity_sub(text), p);
return (typeof(text) == STR) ? {text} | text;
"Last modified Tue Oct  1 03:40:36 1996 IST by EricM (#3264).";
.

@verb #105:"webMOO_to_html" this none this
@program #105:webMOO_to_html
"Substitutes normal HTML code for webMOO code.  This involves";
"replacing all the escape codes ($<$, $>$, $&$) with dollar sign-less";
"equivalents to make valid HTML code.  Takes a string or a list of";
"strings and returns a value of the same form.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (typeof(text = args[1]) == STR)
  return $string_utils:substitute_suspended(text, {{"$<$", "<"}, {"$>$", ">"}, {"$&$", "&"}, {"$&lt;$", "<"}, {"$&gt;$", ">"}, {"$&amp;$", "&"}, {"$&quot;$", "\""}});
elseif (typeof(text) != LIST)
  return E_INVARG;
endif
temptxt = {};
for l in [1..length(text)]
  if (!(l % 5))
    $command_utils:suspend_if_needed(1);
  endif
  temptxt = {@temptxt, $string_utils:substitute_suspended(text[l], {{"$<$", "<"}, {"$>$", ">"}, {"$&$", "&"}, {"$&lt;$", "<"}, {"$&gt;$", ">"}, {"$&amp;$", "&"}, {"$&quot;$", "\""}})};
  if (!(l % 10))
    $command_utils:suspend_if_needed(1);
  endif
endfor
return temptxt;
"Last modified Tue Aug 27 21:56:41 1996 IDT by EricM (#3264).";
.

@verb #105:"blockquote*_tabbed_lines" this none this
@program #105:blockquote_tabbed_lines
"This looks for lines that start with five or more spaces and tags them as";
"<blockquotes>.  It's not perfect, but it's the easiest way to simulate";
"a tabbed line in an html document.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (typeof(text = args[1]) == STR)
  return ((length(text) > 5) && (text[1..5] == "     ")) ? ("<BLOCKQUOTE>" + text) + "</BLOCKQUOTE>" | text;
endif
for line in [1..length(text)]
  if ((length(text[line]) > 5) && (text[line][1..5] == "     "))
    text[line] = ("<BLOCKQUOTE>" + text[line]) + "</BLOCKQUOTE>";
  endif
  ((seconds_left() < 2) || (ticks_left() < 4000)) ? suspend(1) | 0;
endfor
return text;
"Last modified Sat Sep 30 07:31:03 1995 IST by EricM (#3264).";
.

@verb #105:"format_tab*bed" this none this
@program #105:format_tabbed
"format_tab(text STR or LIST) -> html text STR or LIST";
"This looks for lines that start with five or more spaces and tags them as";
"preformatted text with the <PRE> html tag.";
"It's another way to try to make ordinary MOO text appear as acceptable html text.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (typeof(text = args[1]) == STR)
  return ((length(text) > 5) && (text[1..5] == "     ")) ? ("<PRE>" + text) + "</PRE>" | text;
endif
for line in [1..length(text)]
  if ((length(text[line]) > 5) && (text[line][1..5] == "     "))
    text[line] = ("<PRE>" + text[line]) + "</PRE>";
  endif
  ((seconds_left() < 2) || (ticks_left() < 4000)) ? suspend(1) | 0;
endfor
return text;
"Last modified Sat Sep 30 07:38:53 1995 IST by EricM (#3264).";
.

@verb #105:"blankline_to_linebreak" this none this
@program #105:blankline_to_linebreak
"This searches for lines with no text, and inserts a <BR> (linebreak) there.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (typeof(text = args[1]) == STR)
  return (length(text) == 0) ? "<BR>" | text;
endif
for line in [1..length(text)]
  if (length(text[line]) == 0)
    text[line] = "<BR>";
  endif
  ((seconds_left() < 2) || (ticks_left() < 4000)) ? suspend(1) | 0;
endfor
return text;
"Last modified Sat Sep 30 07:41:16 1995 IST by EricM (#3264).";
.

@verb #105:"insert_line_tag" this none this
@program #105:insert_line_tag
"insert_line_tag(text LIST or STR [, tag STR]) -> LIST or STR";
"This adds the HTML tag <LI> in front of each string in the argument, by default.";
"If a second arg is given, that string is used instead.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
tag = (length(args) > 1) ? args[2] | "<LI>";
if (typeof(text = args[1]) == STR)
  return tag + text;
endif
for line in [1..length(text)]
  text[line] = tag + text[line];
endfor
return text;
"Last modified Thu Aug  3 02:03:26 1995 IDT by EricM (#3264).";
.

@verb #105:"parse_form" this none this rx #95
@program #105:parse_form
":parse_form(STR data stream [,NUM return format])";
"Accepts a data stream consisting of a STR encoding a web form, and extracts";
"the various fields as list elements.  Uses 'return format' to determine";
"what format the result should be in, with '1' as the default.";
"Return formats:";
"  1 {{field1, value1}, {field2, value2}, ...} (default)";
"  2 {{field1, field2, ...}, {value1, value2, ...}}";
"WIZARDLY to allow access to $string_utils.full_ascii";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!args)
  return E_ARGS;
elseif (typeof(line = args[1]) != STR)
  return E_INVARG;
endif
mode = args[2] || 1;
eol = $string_utils.full_ascii[13] || this.eol;
eollen = length(eol);
set_task_perms(caller_perms());
line = this:substitute_escapes(line, 1);
if (mode == 1)
  fields = {};
  while (stuff = match(line, "^%([^=&]+%)=%([^&]*%)&"))
    fields = {@fields, {substitute("%1", stuff), strsub(substitute("%2", stuff), "%26", "&")}};
    line = line[stuff[3][2][2] + 2..length(line)];
  endwhile
  if (line && (stuff = match(line, "^%([^=]+%)=")))
    fields = {@fields, {substitute("%1", stuff), strsub(line[stuff[3][1][2] + 2..length(line)], "%26", "&")}};
  endif
  for i in [1..length(fields)]
    newfield = {};
    line = fields[i][2];
    while (p = index(line, eol))
      newfield = {@newfield, line[1..p - 1]};
      line = line[p + eollen..length(line)];
    endwhile
    if (!newfield)
      "leave it as it is";
    elseif (line)
      fields[i][2] = {@newfield, line};
    else
      fields[i][2] = newfield;
    endif
  endfor
elseif (mode == 2)
  fields = {{}, {}};
  while (stuff = match(line, "^%([^=&]+%)=%([^&]*%)&"))
    fields[1] = {@fields[1], substitute("%1", stuff)};
    fields[2] = {@fields[2], strsub(substitute("%2", stuff), "%26", "&")};
    line = line[stuff[3][2][2] + 2..length(line)];
  endwhile
  if (line && (stuff = match(line, "^%([^=]+%)=")))
    fields[1] = {@fields[1], substitute("%1", stuff)};
    fields[2] = {@fields[2], strsub(line[stuff[3][1][2] + 2..length(line)], "%26", "&")};
  endif
  for i in [1..length(fields[2])]
    newfield = {};
    line = fields[2][i];
    while (p = index(line, eol))
      newfield = {@newfield, line[1..p - 1]};
      line = line[p + eollen..length(line)];
    endwhile
    if (!newfield)
      "leave it as it is";
    elseif (line)
      fields[2][i] = {@newfield, line};
    else
      fields[2][i] = newfield;
    endif
  endfor
else
  return E_RANGE;
endif
return fields;
"Last modified Tue May  7 19:40:43 1996 IDT by Gustavo (#2).";
.

@verb #105:"encode" this none this
@program #105:encode
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return $string_utils:substitute_suspended(args[1], this.encoding_data, 1);
"Last modified Tue Aug 27 21:55:46 1996 IDT by EricM (#3264).";
.

@verb #105:"webMOO_to_text" this none this
@program #105:webMOO_to_text
":webMOO_to_text(HTML text LIST or STR) -> text LIST or STR";
"Accepts text in 'webMOO format', where the characters <, >, and & are";
"surrounded by dollar signs ($<$, $>$, $&$) to indicate they are part";
"of HTML tags or entities.  This verb identifies webMOO HTML tags";
"($<$tagtext$>$) and entities ($&$xx;).  The HTML tags are removed,";
"and the entities are replaced with their corresponding plain text.";
"This verb needs to be modified to make the changes simultaneously";
"throughout the line, instead of incrementally. Sometime....";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (typeof(text = args[1]) == STR)
  while (subs = match(text, "%(.*%)%$[<>&]%$%(.*%)%$[<>&]%$%(.*%)"))
    text = substitute("%1%3", subs);
  endwhile
  return text;
endif
result = {};
for line in (text)
  while (subs = match(line, "%$[<>&]%$%$[<>&]%$%(.*%)"))
    line = line[1..match[1] - 1] + line[match[2] + 1..$];
  endwhile
  result = {@result, line};
endfor
return result;
"Last modified Tue Jul  1 20:03:16 1997 IDT by EricM (#3264).";
.

@verb #105:"format_webapp_result_to_html" this none this rx
@program #105:format_webapp_result_to_html
":format_webapp_result_to_html(header-footer LIST, body-text STR or LIST) -> HTML document";
"Accepts the result of a webapp call and processes it to HTML text.";
"Args[1] is a two-element list, whose  first element is a list of";
"strings to be prepended to the body text, and whosesecond element is";
"a list to be appended to the foot.";
"STR  body text";
"LIST  {webapp result} (recursive)";
"LIST  {title STR, body LIST or STR}";
"LIST  {header/footer LIST, body LIST or STR}";
"Other types are transformed to STR; further args are ignored.  The";
"concept is that args[1] is always the same from a particular webapp,";
"but can be modified by the contents of args[2]";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
stdbody = args[1];
stuff = args[2];
l = length(stuff);
if (typeof(stuff) == STR)
  body = {stuff};
elseif (typeof(stuff) != LIST)
  body = {tostr(stuff)};
elseif (l == 0)
  body = {};
elseif (l == 1)
  return this:(verb)(stdbody, stuff[1]);
elseif (l == 2)
  if (typeof(stuff[1]) != LIST)
    head = {"<TITLE>", tostr(stuff[1]), "</TITLE>"};
  else
    head = stuff[1];
  endif
  if (typeof(stuff[2]) != LIST)
    body = {tostr(stuff[2])};
  else
    body = stuff[2];
  endif
else
  "more than two sections... use only the first 2 for the time being.";
  return this:(verb)(stdbody, stuff[1..2]);
endif
"Set BACKGROUND, BGCOLOR, LINK, VLINK, and ALINK values for the BODY tag";
if ("nobackgrounds" in player.web_options)
  "user specifically refuses backgrounds";
  bodytag = "<BODY>";
else
  "highest priority=user settings, then MOO object set values, finally the MOO default";
  ((seconds_left() < 2) || (ticks_left() < 4000)) ? suspend(1) | 0;
  bodytag = "";
  "check for user settings";
  webops = player.web_options;
  background = $web_options:get(webops, "background");
  bgcolor = $web_options:get(webops, "bgcolor");
  textcolor = $web_options:get(webops, "textcolor");
  linkcolor = $web_options:get(webops, "linkcolor");
  vlinkcolor = $web_options:get(webops, "vlinkcolor");
  alinkcolor = $web_options:get(webops, "alinkcolor");
  if (((((background || bgcolor) || textcolor) || linkcolor) || vlinkcolor) || alinkcolor)
    "user has set one of these values";
  elseif (bodytag_attributes = $http_handler:retrieve_taskprop("bodytag_attributes"))
    "no user settings, but an object has set them";
    bodytag = tostr("<BODY ", bodytag_attributes, ">");
  endif
  if (!bodytag)
    background = (background = background || $web_utils.std_bkgnd) ? tostr(" BACKGROUND=\"", background, "\"") | "";
    bgcolor = (bgcolor = bgcolor || $web_utils.std_bgcolor) ? tostr(" BGCOLOR=\"", bgcolor, "\"") | "";
    textcolor = (textcolor = textcolor || $web_utils.std_textcolor) ? tostr(" TEXT=\"", textcolor, "\"") | "";
    linkcolor = (linkcolor = linkcolor || $web_utils.std_linkcolor) ? tostr(" LINK=\"", linkcolor, "\"") | "";
    vlinkcolor = (vlinkcolor = vlinkcolor || $web_utils.std_vlinkcolor) ? tostr(" VLINK=\"", vlinkcolor, "\"") | "";
    alinkcolor = (alinkcolor = alinkcolor || $web_utils.std_alinkcolor) ? tostr(" ALINK=\"", alinkcolor, "\"") | "";
    bodytag = tostr("<BODY", bgcolor || background, textcolor, linkcolor, vlinkcolor, alinkcolor, ">");
  endif
endif
return {"<HTML><HEAD>", @head || {}, "</HEAD>", bodytag, @stdbody[1] || {}, @body || {}, @stdbody[2] || {}, "</BODY></HTML>"};
"Last modified Sat Aug 17 01:34:57 1996 IDT by EricM (#3264).";
.

@verb #105:"build_MIME" this none this rx
@program #105:build_MIME
"build_MIME(url STR) -> html doc  LIST";
"  Takes a string, presumed to be a URL, and tries to make it into the";
"proper sort of HTML doc fragment (a list of strings), based on the";
"specified file's extension.";
"  If no MIME type is matched, returns the string embedded as a one element list.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
if (match(what, "^%(http%|gopher%|ftp%)://[^: ]+%(:[0-9]+%)?%(/[^ ]*%)*$"))
  if ((extn = what[rindex(what, ".")..length(what)]) in {".gif", ".jpeg", ".jpg"})
    "it's a gif or jpeg image to be 'in-lined'";
    return {("<IMG SRC=\"" + what) + "\"><BR>"};
  elseif (extn in {".html", ".htm"})
    "it's an HTML document";
    return {tostr("Link to web page at: <A HREF=\"", what, "\" onClick=\"alert('A new window is being opened for your selection.  Your window into ", $network.MOO_name, " will remain.')\" TARGET=\"accessory_frame\">", what, "</A>")};
  elseif (rindex(what, "/") == length(what))
    "it's either a directory or a pointer to a default http file";
    return {tostr("Link to web page at: <A HREF=\"", what, "\" onClick=\"alert('A new window is being opened for your selection.  Your window into ", $network.MOO_name, " will remain.')\" TARGET=\"accessory_frame\">", what, "</A>")};
  endif
  "it's probably a link to a file directory of some sort or an unknown MIME type";
  return {tostr("Link to: <A HREF=\"", what, "\" onClick=\"alert('A new window is being opened for your selection.  Your window into ", $network.MOO_name, " will remain.')\" TARGET=\"accessory_frame\">", what, "</A>")};
else
  return {what};
endif
"Last modified Tue Aug 27 16:17:56 1996 IDT by EricM (#3264).";
.

@verb #105:"interpret_map" this none this
@program #105:interpret_map
"interpret_map(click LIST, { {regiontype STR, point LIST,....}, ....}) -> region NUM";
"  The verb determines if a selected point is in any of a set of";
"defined regions.  It's used to process HTML imagemaps.  It takes two";
"arguments, each of which is a list.  The first is the X,Y coordinate";
"of the selection, and the second is a list of map regions.  This";
"second list consists of lists with the information needed to divide";
"the map into regions, and are any of:";
"  {'rect', {x1,y1}, {x2,y2} }";
"  {'circ', {centerX, centerY}, radius}";
"  {'poly', {x1,y1}, {x2,y2}, ....}";
"  For rectangular regions, (X1,Y1)  and (X2,Y2) define a diagonal";
"across the rectangle.  For circular regions, (centerX,centerY) is the";
"circle's center, and radius is ... its radius.";
"Polygons must be 'convex', meaning that none of the vertices of";
"the polygon fall in any triangle defined by any three points of the";
"polygon. Or to put it another way, polygons can't have dents. :) In";
"addition, the specified polygon vertices must be in order, travelling";
"around the polygon.";
"  The verb returns the index of the first region it finds that covers";
"the selected area or zero.  An example argument is:";
"( {4,8}, { {'rect',{1,3},{4,7}}, {'circ',{5,5},3} } )";
"The origin (0,0) is assumed to lie at the top left corner of the";
"image.  All units are in pixels, and are positive.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
click = args[1];
regions = args[2];
"";
"Go through the list of regions and return the index of the first one";
"the selected point is within";
for region in (regions)
  "";
  "if the region is a rectangle";
  if (region[1] == "rect")
    if ((((click[1] >= region[2][1]) && (click[1] <= region[3][1])) && (click[2] >= region[2][2])) && (click[2] <= region[3][2]))
      return region in regions;
    endif
    "";
    "if the region is a circle";
  elseif (region[1] == "circ")
    "is the distance from the selection to the circle's center larger than the circle's radius?";
    region_radius = region[3];
    click_radius = ((i = region[2][1] - click[1]) * i) + ((j = region[2][2] - click[2]) * j);
    if (click_radius <= region_radius)
      return region in regions;
    endif
    "";
    "if region is a polygon";
  elseif (region[1] == "poly")
    if (length(region) < 5)
      if (this:inside_triangle(click, @region[2..4]))
        "Only three points specified so it's a triangle)";
        return region in regions;
      endif
    else
      "Divide the convex polygon into triangles using the first vertex of";
      "the polygon as a common vertex for all the triangles. Check for the";
      "click in each triangle.";
      for vertex in [3..length(region) - 1]
        if (this:inside_triangle(click, region[2], region[vertex], region[vertex + 1]))
          return region in regions;
        endif
      endfor
    endif
  endif
endfor
"couldn't find a matching region";
return 0;
"Last modified Wed Oct 16 19:59:24 1996 IST by EricM (#3264).";
.

@verb #105:"inside_triangle" this none this
@program #105:inside_triangle
"inside_triangle(clickpoint, vertex1, vertex2, vertex3) -> BOOLEAN";
"where arg is a list {x, y} giving the coordinates of a point.";
"Returns 1 if the clickpoint can be found in the triangle defined";
"by the three vertices.";
"Method is to check the line formed by each triangle's side to see";
"if the third vertex and the click point are on the same side of that";
"line.  If it's true for all three sides, the click must be inside";
"Based on an idea by Arizona @ Sprawl";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
click = args[1];
verts = {args[2], args[3], args[4], args[2], args[3]};
if (click in verts)
  "person clicked on a corner of the triangle";
  return 1;
endif
line = {0, 0};
for v in [1..3]
  "determine standard line (y=ix+j) for segment verts[v]_verts[v+1] -> {10000*i,10000*j}";
  "Use method of $math_utils:div to preserve correct sign.";
  if (!(k = verts[v][1] - verts[v + 1][1]))
    "line is vertical";
    if (((click[1] > verts[v][1]) && (verts[v + 2][1] < verts[v][1])) || ((click[1] < verts[v][1]) && (verts[v + 2][1] > verts[v][1])))
      return 0;
    endif
  else
    line[1] = ((j = 10000 * (verts[v][2] - verts[v + 1][2])) - (((j % k) + k) % k)) / k;
    line[2] = (10000 * verts[v][2]) - (line[1] * verts[v][1]);
    if ((adjclickY = click[2] * 10000) == (clickpredY = (line[1] * click[1]) + line[2]))
      "click is on the line";
    else
      "calc 3rd vert's place rel. to line";
      v3predY = (line[1] * verts[v + 2][1]) + line[2];
      if ((((i = verts[v + 2][2] * 10000) > v3predY) && (adjclickY < clickpredY)) || ((adjclickY > clickpredY) && (i < v3predY)))
        "click is on opp. side of line from 3rd vert";
        return 0;
      endif
    endif
  endif
endfor
return 1;
"Last modified Thu Aug 15 21:23:33 1996 IDT by EricM (#3264).";
.

@verb #105:"preformat nonprop_font" this none this rx
@program #105:preformat
"preformat(text LIST, width NUM [, line break STR]) -> html text LIST";
"Preformat the text to the given width. Breaks lines at spaces if possible";
"Uses the given line break string or defaults to nothing appended to each line.";
"If verb is 'preformat' then use <PRE> tags, else <TT> tags";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
text = args[1] || {};
width = args[2] || 79;
if ((length(args) > 2) && (typeof(args[3]) == STR))
  lbr = args[3];
else
  lbr = "";
endif
newtext = {};
cu = $command_utils;
for line in (text)
  while (length(line) > width)
    cu:suspend_if_needed(0);
    frag = line[1..width];
    space = rindex(frag, " ");
    if (space)
      newtext = {@newtext, line[1..space - 1]};
      line = line[space + 1..length(line)];
    else
      newtext = {@newtext, line[1..width] + lbr};
      line = line[width + 1..length(line)];
    endif
  endwhile
  newtext = {@newtext, line + lbr};
  if (!(random(10) - 1))
    cu:suspend_if_needed(0);
  endif
endfor
tag = (verb == "preformat") ? "PRE" | "TT";
return {tostr("<", tag, ">"), @newtext, tostr("</", tag, ">")};
"Last modified Thu Aug 15 20:49:24 1996 IDT by EricM (#3264).";
.

@verb #105:"user_webviewer" this none this rx
@program #105:user_webviewer
"user_webviewer(who OBJ) -> webapp OBJ";
"Returns the default web viewer object number for 'who'.";
"Returns WebGhost Viewer if the person isn't connected.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1] || player;
return ((viewer = $web_options:get(who.web_options, "viewer")) == 0) ? $standard_webviewer | viewer;
"Last modified Wed Aug 21 18:54:23 1996 IDT by EricM (#3264).";
.

@verb #105:"access_security" this none this rx
@program #105:access_security
"access_security() -> {level NUM, level description STR}";
"Determines the current status of their web and telnet connections";
"The highest access is {0, \"complete\"} meaning wizardly";
"Owned by BioWeb manager in order to access the task property list directly";
"  0 = complete (wizardly)";
"  1 = confirmed (non-guest with parallel telnet connection";
"  2 = guest (guest with parallel telnet connection)";
"  3 = not confirmed by telnet/client connection";
"  4 = anonymous (connected with $no_one's webpass)";
"  5 = not as a person (connected with invalid id)";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = $http_handler.task_details[task_id() in $http_handler.task_index][3];
if (!valid(who))
  return {6, "invalid"};
elseif (!is_player(who))
  return {5, "not as a person"};
elseif (who == $no_one)
  return {4, "anonymous"};
elseif (!$object_utils:connected(who))
  return {3, "not confirmed by telnet/client connection"};
elseif (who.wizard)
  return {0, "complete"};
elseif ($object_utils:isa(who, $guest))
  return {2, "as a connected guest"};
endif
return {1, "confirmed"};
"Last modified Sat Aug 17 03:13:17 1996 IDT by EricM (#3264).";
.

@verb #105:"is_webcall get_webcode" this none this rx
@program #105:is_webcall
"get_webcode() -> STR";
"is_webcall() -> STR";
"If the task originated from a web link, via a webapp with a valid web";
"CODE, returns the value of that code, else an empty string.";
"Returns the string ERRinWebtasklist if the web task stack is corrupt";
"The get_webcode function is essentially a security hole we're";
"allowing for now.  In the future, verbs will have to get the code";
"themselves from the webapp (but will be able to use";
"$web_utils:user_webviewer to find out what viewer the web task";
"used.). They'll be doing it on their own perms, of course.";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!(idx = (task = task_id()) in $http_handler.task_index))
  "couldn't find the task in the web task index";
  return "";
elseif (task == $http_handler.task_details[idx][1])
  "found it where it was supposed to be";
  return $http_handler.task_details[idx][2];
endif
return "ERRinWebtasklist";
"Last modified Sat Sep 30 08:04:14 1995 IST by EricM (#3264).";
.

@verb #105:"english_list_with_urls list_english_list_with_urls" this none this rx
@program #105:english_list_with_urls
"Like $string_utils:english_list, but it converts objects to their names and adds url if needed";
"If called as 'list_english_list_with_urls' returns in <special format>";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
who = args[1];
code = args[2];
args = args[3..length(args)];
link1 = ("<A HREF=\"&LOCAL_LINK;/" + code) + "/";
link2 = "#focus\">";
link3 = "</A>";
things = args[1];
showicons = !("hideicons" in player.web_options);
showdest = "exitdetails" in player.web_options;
for i in [1..length(things)]
  $command_utils:suspend_if_needed(0);
  object = things[i];
  if ((showdest && $object_utils:isa(object, $exit)) && valid(object.dest))
    additional_text = tostr(" (to ", object.dest:title(1), ")");
  elseif (("markURL" in player.web_options) && object:really_has_url(who))
    additional_text = "*";
  else
    additional_text = "";
  endif
  if ((showicons && (icon = object:get_icon())) && (typeof(icon) == STR))
    icon = ("<img src=\"" + icon) + "\" alt=\"\" align=\"center\" WIDTH=\"32\" HEIGHT=\"32\" BORDER=\"0\"> ";
  else
    icon = "";
  endif
  if (object:has_url(who))
    things[i] = (((((link1 + tostr(tonum(object))) + link2) + icon) + object:title(0)) + additional_text) + link3;
  else
    things[i] = (icon + object:title(0)) + additional_text;
  endif
endfor
if (verb[1..4] != "list")
  args[1] = things;
  return $string_utils:english_list(@args);
endif
nthings = length(things);
if (length(args) > 1)
  nothingstr = args[2];
else
  nothingstr = "nothing";
endif
if (length(args) > 2)
  andstr = args[3];
else
  andstr = " and ";
endif
if (length(args) > 3)
  commastr = args[4];
else
  commastr = ", ";
endif
if (length(args) > 4)
  finalcommastr = args[5];
else
  finalcommastr = ",";
endif
if (nthings == 0)
  return {nothingstr};
elseif (nthings == 1)
  return {tostr(things[1])};
elseif (nthings == 2)
  return {tostr(things[1], andstr, things[2])};
else
  ret = {};
  for k in [1..nthings - 1]
    if (k == (nthings - 1))
      commastr = finalcommastr;
    endif
    ret = {@ret, tostr(things[k], commastr)};
  endfor
  return {@ret, tostr(andstr, things[nthings])};
endif
"Last modified Wed Aug 28 23:15:37 1996 IDT by EricM (#3264).";
.

@verb #105:"rtn_to_viewer return_to_viewer" this none this rx #95
@program #105:rtn_to_viewer
"rtn_to_viewer([who OBJ] [, link text STR]) -> hyperlinked text STR";
"  Provides a string that can be incorporated into an HTML document and";
"provides the user with a link to their default web viewer web";
"application.  If 'who' is not provided, 'player' is used.  If a text";
"string is not provided, then 'Return to the Viewer' is used.";
"  If caller has insufficient perms to retrieve viewer's web code, an";
"empty list is returned";
"WIZARDLY to use set_task_perms";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
text = args[1] || "Return to the Viewer";
who = args[2] || player;
set_task_perms(caller_perms());
viewer = $web_utils:user_webviewer(who);
if ((viewer == $standard_webviewer) && (!(who in connected_players())))
  viewer = $anon_webviewer;
endif
return (code = viewer:get_code()) ? tostr("<A HREF=\"&LOCAL_LINK;/", code, "\">", text, "</A>") | "";
"Last modified Wed Aug 21 19:17:25 1996 IDT by EricM (#3264).";
.

@verb #105:"mmdecode" this none this rx
@program #105:mmdecode
"mmdecode(encoded STR) -> decoded STR";
"Performs mmdecoding on 'encoded'";
"Code written by Alex Stewart (aka Richelieu)";
"mmdecode(text) - decode the given RFC-1113-compliant printable-encoded text line (\"base64 encoded\") and return the decoded string.  This is of somewhat limited usefulness as a general-purpose routine as it ignores linend characters completely.  All non-MOO-able character codes (codes which can't be used as input to the MOO) are skipped.  This code assumes good input.  Sending it bad (non-encoding) characters can produce undefined results.";
"NOTE:  This routine will not pass tab-characters either, despite being valid MOO input characters.  It was just easier (and more efficient) that way.";
"This verb relies on being !d";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
text = args[1];
output = "";
mmtab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
ascii = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
"..we could've used $string_utils.ascii here, but if someone changes that (for example, they add more characters (like tab) which can be used as input and update it appropriately), it could screw up this whole routine which depends on knowing the _positions_ of the characters in the string (instead of presence or relative ordering) so we hardcode it..";
pos = 1;
len = length(text) - 3;
while (pos <= len)
  i1 = index(mmtab, text[pos], 1) - 1;
  i2 = index(mmtab, text[pos + 1], 1) - 1;
  i3 = index(mmtab, c3 = text[pos + 2], 1) - 1;
  i4 = index(mmtab, c4 = text[pos + 3], 1) - 1;
  o1 = ((i1 * 4) + (i2 / 16)) - 31;
  o2 = (c3 != "=") ? (((i2 % 16) * 16) + (i3 / 4)) - 31 | 0;
  o3 = (c4 != "=") ? (((i3 % 4) * 64) + i4) - 31 | 0;
  output = tostr(output, ascii[o1] || "", ascii[o2] || "", ascii[o3] || "");
  pos = pos + 4;
endwhile
return output;
"Last modified Tue Jul  1 20:04:54 1997 IDT by EricM (#3264).";
.

@verb #105:"substitute_escapes url_decode" this none this rx #95
@program #105:substitute_escapes
"substitute_escapes(STR data [, STR EOL-replacement]";
"Accepts a string with %nn-escaped characters in it, and returns the string";
"with those characters substituted. By default, EOL characters are replaced,";
"with the string <EOL>, but if the optional second parameter is provided and";
"of type STR, it is used instead. If the calling perms are wizardly, the optional";
"parameter is provided, and it is true, EOLs are replaced with %0D.";
"WIZARDLY to allow access to $string_utils.full_ascii";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
su = $string_utils;
if (!args)
  return E_ARGS;
elseif (typeof(line = args[1]) != STR)
  return E_INVARG;
elseif (typeof(args[2]) == STR)
  eol = args[2];
elseif (args[2] && caller_perms().wizard)
  eol = su.full_ascii[13] || this.eol;
else
  eol = "<EOL>";
endif
eollen = length(eol);
fa = caller_perms().wizard ? su.full_ascii | su.ansi;
fa = fa || tostr(su:space(31), su.ascii, su:space(129));
line = strsub(line, "+", " ");
line = strsub(line, "%0D%0A", eol);
line = strsub(line, "%0A", eol);
line = strsub(line, "%0D", eol);
done = 1;
while (stuff = match(line[done..length(line)], "%%%([0-9A-F][0-9A-F]%)"))
  code = substitute("%1", stuff);
  if (code != "26")
    hexa = "0123456789ABCDEF";
    n = ((16 * (index(hexa, code[1]) - 1)) + index(hexa, code[2])) - 1;
    line = strsub(line, "%" + code, fa[n]);
  endif
  done = done + stuff[1];
endwhile
return line;
"Last modified Thu Aug 15 19:53:56 1996 IDT by EricM (#3264).";
.

@verb #105:"url_encode" this none this rx #95
@program #105:url_encode
"url_encode(STR data) -> STR encoded";
"Performs 'url-encoding' on a string, replacing characters that";
"aren't allowed in a URL with their escaped ASCII number equivalents";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!args)
  return E_ARGS;
elseif (typeof(line = args[1]) != STR)
  return E_INVARG;
endif
data = args[1];
ascii = $string_utils.full_ascii || $string_utils.ansi;
hex = "0123456789ABCDEF";
allowed = "-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstvwxyz";
encoded = "";
for idx in [1..length(data)]
  char = data[idx];
  if (index(allowed, char))
    encoded = encoded + char;
  else
    idx = index(ascii, char);
    idx = hex[(idx / 16) + 1] + hex[(idx % 16) + 1];
    encoded = tostr(encoded, "%", idx);
  endif
endfor
return encoded;
"Last modified Wed May  8 13:38:42 1996 IDT by EricM (#3264).";
.

@verb #105:"init_for_core" this none this rxd #95
@program #105:init_for_core
"init_for_core() -> none";
"initializes property data for a fresh core extraction";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || caller_perms().wizard))
  return;
endif
this.page_banner = tostr("<H1 ALIGN=\"CENTER\">", $network.MOO_name, " - New BioGate System Installed!</H1>");
this.moo_home_page = "Not_yet_set";
this.uparrow_icon = "[Top of Page] ";
"If there's something corified as 'interior_room' put that in the list.  There may be other valid interior_rooms, though.";
this.interior_rooms = {@$object_utils:has_property(#0, "interior_room") ? {$interior_room} | {}};
this.web_helppage = "";
this.std_bkgnd = this.std_bgcolor = this.std_textcolor = "";
this.std_linkcolor = this.std_vlinkcolor = this.std_alinkcolor = "";
return pass(@args);
"Last modified Wed Dec 25 20:41:17 1996 IST by EricM (#3264).";
.

"***finished***
