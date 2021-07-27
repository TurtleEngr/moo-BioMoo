$Header: /repo/public.cvs/app/BioGate/BioMooCore/core108.moo,v 1.1 2021/07/27 06:44:26 bruce Exp $

>@dump #108 with create
@create $generic_utils named VRML Utilities:VRML Utilities,vrml_utils
@prop #108."test_collisions" 0 r
@prop #108."trnsln_matrix" {} r
@prop #108."link_to_web" {} r
;;#108.("link_to_web") = {"WWWInline { name \"http://hppsda.mayfield.hp.com/image/web.wrl\" }"}
@prop #108."std_outlink" {} r
;;#108.("std_outlink") = {"Transform { translation 2 0 0 scaleFactor .7 .7 .7 }", "WWWInline { name \"http://hppsda.mayfield.hp.com/image/nested_boxes.wrl\" }"}
@prop #108."std_linkzone" {} r
;;#108.("std_linkzone") = {"Transform { translation -6 3 -12 }"}
@prop #108."std_roomlights" {} r
;;#108.("std_roomlights") = {"DirectionalLight {on TRUE intensity .4 color .8 .8 .8 direction .75 -1 0}", "DirectionalLight {on TRUE intensity .7 color .8 .8 .8 direction -.75 -1 -.5}", "DirectionalLight {on TRUE intensity .7 color .8 .8 .8 direction 0 0 1}"}
;;#108.("aliases") = {"VRML Utilities", "vrml_utils"}
;;#108.("description") = "This is a placeholder parent for all the $..._utils packages, to more easily find them and manipulate them. At present this object defines no useful verbs or properties. (Filfre.)"
;;#108.("object_size") = {16566, 937987203}

@verb #108:"generate_random_shape" this none this
@program #108:generate_random_shape
"generate_random_shape([shape STR [, material STR]]) -> random shape of random color and size LIST";
"If a 'shape' is given and one of the simple types it's used. If any second argument is given, it's used as the 'material'";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (args && (args[1] in {"Cone", "Cube", "Cylinder", "Sphere"}))
  shape = args[1];
else
  shape = {"Cone", "Cube", "Cylinder", "Sphere"}[random(4)];
endif
material = (length(args) > 1) ? args[2] | tostr("Material {diffuseColor 0.", random(99), " 0.", random(99), " 0.", random(99), "}");
if (shape == "sphere")
  return {material, tostr("Sphere { radius 0.", 19 + random(80), "}")};
elseif (shape == "cube")
  return {material, tostr("Cube {width 0.", 19 + random(80), " height 0.", 19 + random(80), " depth 0.", 19 + random(80), "}")};
elseif (shape == "cylinder")
  return {material, tostr("Cylinder {radius 0.", 19 + random(80), " height 0.", 19 + random(80), "}")};
elseif (shape = "cone")
  return {material, tostr("Cone {height 0.", 19 + random(80), " bottomRadius 0.", 19 + random(80), "}")};
endif
"Last modified Tue Nov 21 09:36:41 1995 IST by EricM (#3264).";
.

@verb #108:"div_by_thousand" this none this
@program #108:div_by_thousand
"Accepts either a number or a list of numbers, and returns string or list of strings, respectively";
"Number values are replaced by strings that represent the number divided by one thousand";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
if (typeof(what) == NUM)
  return tostr((what < 0) ? "-" | "", abs(what) / 1000, ".", tostr((abs(what) % 1000) + 1000)[2..$]);
elseif (typeof(what) != LIST)
  return E_INVARG;
endif
for i in [1..length(what)]
  what[i] = tostr((what[i] < 0) ? "-" | "", abs(what[i]) / 1000, ".", tostr((abs(what[i]) % 1000) + 1000)[2..$]);
endfor
return what;
"Last modified Thu Aug 29 00:00:47 1996 IDT by EricM (#3264).";
.

@verb #108:"make_SFVec3f" this none this
@program #108:make_SFVec3f
"make_SFVec3f(1000* float NUM, 1000*float NUM, 100*float NUM) -> SFVec3f STR";
"Takes a 3D vector of 1000*floating point values and converts them into a string";
"containing the proper floats";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
what = $vrml_utils:div_by_thousand(what);
return tostr(what[1], " ", what[2], " ", what[3]);
"Last modified Tue Nov 21 12:04:12 1995 IST by EricM (#3264).";
.

@verb #108:"make_SFRotation" this none this
@program #108:make_SFRotation
"make_SFRotation(1000* float NUM, 1000*float NUM, 100*float NUM) -> SFRotation STR";
"Takes a set of 1000*floats and makes them into a SFRotation spec";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = $vrml_utils:div_by_thousand(args[1]);
return tostr("1 0 0 ", what[1], " 0 1 0 ", what[2], " 0 0 1 ", what[3]);
"Last modified Tue Nov 21 12:12:46 1995 IST by EricM (#3264).";
.

@verb #108:"causes_collision" this none this
@program #108:causes_collision
"causes_collision(what OBJ, direction NUM, amount NUM) -> 0 or {dist moved NUM, object bumped OBJ}";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
return 0;
"no test at this time";
"Last modified Thu Nov 23 00:19:38 1995 IST by EricM (#3264).";
.

@verb #108:"trans*late" this none this rxd #95
@program #108:translate
"translate(what OBJ, amount NUM, dir NUM) -> 0 or error STR";
"Move what, amount millimeters";
"direction is compass abbreviation, u or d (down)";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
{what, amount, dir} = args;
if (!$perm_utils:controls(caller_perms(), what))
  return "Sorry, you don't have permission to move that.";
endif
set_task_perms(caller_perms());
locn = what:get_vrml_translation();
trnsln_matrix = this:calc_trnsln_matrix(amount, dir);
if (typeof(trnsln_matrix) != LIST)
  return ("Sorry, but I don't know what direction " + dir) + " is in.";
endif
for coord in [1..length(trnsln_matrix)]
  locn[coord] = locn[coord] + trnsln_matrix[coord];
endfor
if (what:set_vrml_translation(locn) != locn)
  return "For some reason, you can't seem to move that there.";
endif
"Last modified Mon Oct 21 01:19:58 1996 IST by EricM (#3264).";
.

@verb #108:"calc_trnsln_matrix" this none this
@program #108:calc_trnsln_matrix
"calc_trnsln_matrix(amount INT, dir STR) -> {X-trnsln, Y-trnsln, Z-trnsln}";
"Given the amount to move an object (in millimeters), and a direction";
"(arbitrary word from recognized list), how much in each coord must";
"object be moved";
"Recognized: n, s, e, w, ne, se, sw, nw, u, d";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
orthog = {"n", "e", "s", "w", "u", "d"};
angled = {"ne", "se", "sw", "nw"};
amount = args[1];
dir = args[2];
if (idx = dir in orthog)
  mult = {{0, 0, -1}, {1, 0, 0}, {0, 0, 1}, {-1, 0, 0}, {0, 1, 0}, {0, -1, 0}}[idx];
elseif (idx = dir in angled)
  mult = {{1, 0, -1}, {1, 0, 1}, {-1, 0, 1}, {-1, 0, -1}}[idx];
  amount = toint(sqrt(tofloat(amount ^ 2) / 2.0));
else
  return E_INVARG;
endif
for i in [1..3]
  mult[i] = mult[i] * amount;
endfor
return mult;
"Last modified Fri Jun  7 19:36:34 1996 IDT by EricM (#3264).";
.

@verb #108:"distance_in_mm" this none this
@program #108:distance_in_mm
"distance_in_mm(distance NUM, units STR) -> amount NUM";
"Return the number of millimeters equivalent to 'distance' 'units'";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
distance = args[1];
units = args[2];
if (length(units) > 2)
  units = (units[length(units)] == "s") ? units | (units + "s");
endif
unitnames = {"mm", "millimeters", "m", "meters", "km", "kilometers", "in", "inches", "ft", "feet", "yd", "yards", "cm", "centimeters"};
if (!(idx = units in unitnames))
  return E_INVARG;
endif
unitvals = {10, 10, 10000, 10000, 10000000, 10000000, 254, 254, 3048, 3048, 9144, 9144, 100, 100};
return (distance * unitvals[idx]) / 10;
"Last modified Sat Mar 23 08:16:30 1996 IDT by EricM (#3264).";
.

@verb #108:"relative_loc*ation" this none this
@program #108:relative_location
"relative_location(what OBJ, other OBJ) -> {distance NUM, horiz angle NUM, vert angle NUM}";
"Returns the relative location of 'other' from what, in vector form, as 'distance' distance";
"(in millimeters), and at the given horizontal and vertical angles (in radians)";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
other = args[2];
if (what.location != other.location)
  return E_INVARG;
  "Can't calculate this until we know the bounding box of each object, at which point";
  "the fractally developed distances become calculable.";
endif
what_coords = what:get_vrml_translation(@args);
other_coords = other:get_vrml_translation(@args);
return this:vector_between(what_coords, other_coords);
"Last modified Thu Nov 23 03:23:39 1995 IST by EricM (#3264).";
.

@verb #108:"vector_between" this none this
@program #108:vector_between
"vector_between( first vector LIST, second vector LIST) -> vector LIST";
"Each input vector is in the form {X-displacement INT, Y-displacement INT, Z-displacement INT}";
"And return vector is in the form {distance INT, Y-rotation FLOAT in radians, XZ-plane inclination FLOAT in radians}";
"Calculates the vector between two points described by translations from a common origin";
"Takes and returns vectors of the form {distance, horiz angle, and vert angle},";
"where angle is in milliradians.";
"** Requires at least LambdaMOO server version 1.8.0 **";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
vect1 = args[1];
vect2 = args[2];
dX = tofloat(vect2[1]) - tofloat(vect1[1]);
dY = tofloat(vect2[2]) - tofloat(vect1[2]);
dZ = tofloat(vect2[3]) - tofloat(vect1[3]);
dist = sqrt(((dX ^ 2) * (dY ^ 2)) * (dZ ^ 2));
XZinclination = asin(dY / dist);
Yrotation = asin(dX / sqrt((dX ^ 2) + (dZ ^ 2)));
return {dist, Yrotation, XZinclination};
"Last modified Fri May 17 09:56:19 1996 IDT by EricM (#3264).";
.

@verb #108:"parse_scale_spec" this none this
@program #108:parse_scale_spec
"parse_scale_spec(scaling specifier STR or LIST) -> {result type 1 or ERR, result LIST or STR}";
"Takes a scaling specifier and converts it into number times 1000 format";
"Examples: 50%->500, 2x->2000, 3->3000";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
scaling = args[1];
if (typeof(args[1]) == LIST)
  "process each axis given in the list";
  for axis in [1..length(scaling)]
    if (typeof((result = this:parse_scale_spec(scaling[axis]))[1]) == ERR)
      return result;
    else
      scaling[axis] = result[2];
    endif
  endfor
  scaling = {1, scaling};
else
  "spec is a single string";
  if (index(scaling, "%") == (len = length(scaling)))
    if ((len == 1) || (!$string_utils:is_numeric(scaling = scaling[1..len - 1])))
      return {E_INVARG, tostr("\"", scaling, "%\" is not an integer percentage")};
    elseif (!tonum(scaling))
      return {E_INVARG, "The scaling ratio may not be zero."};
    else
      scaling = {1, tonum(scaling) * 10};
    endif
  else
    "trim off the trailing 'x' if any";
    scaling = ((index(scaling, "x") == (len = length(scaling))) && (len > 1)) ? scaling[1..len - 1] | scaling;
    scaling = (scaling == " ") ? "1" | scaling;
    if ($string_utils:is_numeric(scaling))
      if (!tonum(scaling))
        return {E_INVARG, "The scaling ratio may not be zero."};
      endif
      scaling = {1, tonum(scaling) * 1000};
    else
      scaling = {E_INVARG, tostr("\"", args[1], "\" is not an integer multiplier")};
    endif
  endif
endif
return scaling;
"Last modified Fri Apr  5 23:15:40 1996 IDT by EricM (#3264).";
.

@verb #108:"init_for_core" this none this
@program #108:init_for_core
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
if (!((caller == this) || caller_perms().wizard))
  return E_PERM;
endif
this.std_outlink = {"Transform { translation 2 0 0 scaleFactor .7 .7 .7 }", "Cone { }"};
this.link_to_web = {"Cube { }"};
return pass(@args);
"Last modified Wed Aug 21 23:43:05 1996 IDT by EricM (#3264).";
.

@verb #108:"init_object_locn" this none this rxd #95
@program #108:init_object_locn
"init_object_locn(object) -> {X, Y, Z translation} LIST";
"Place an object randomly in a room";
"(C) Copyright 1996 BioGate Partners; All rights reserved.";
what = args[1];
if (!$perm_utils:controls(caller_perms = caller_perms(), what))
  return E_PERM;
endif
set_task_perms(caller_perms);
if ($object_utils:isa(what, $player))
  "don't make people float or sink";
  what:set_vrml_translation({random(8000) - 4000, 0, random(8000) - 4000});
else
  what:set_vrml_translation({random(8000) - 4000, random(1000) - 750, random(8000) - 4000});
endif
return what:get_vrml_translation();
"Last modified Sat Mar 23 01:10:17 1996 IDT by EricM (#3264).";
.

@verb #108:"rotate" this none this rxd #95
@program #108:rotate
"Copied from VRML Utilities (#13263):trans by Jeanne (#2) Wed Mar 20 20:21:20 1996 EST";
"translate(what OBJ, amount NUM, dir STR) -> 0 or error message STR";
"Move what, amount millimeters dir";
"amount in millimeters";
"direction is compass abbreviation, cw or ccw (counter-clockwise)";
what = args[1];
if (!$perm_utils:controls(caller_perms(), what))
  return "Sorry, you don't have permission to move that.";
endif
amount = args[2];
dir = args[3];
set_task_perms(caller_perms());
rotn = what:get_vrml_rotation();
rotn_matrix = this:calc_rotn_matrix(amount, dir);
if (typeof(rotn_matrix) != LIST)
  return ("Sorry, but I don't know what direction " + dir) + " is in.";
endif
for coord in [1..length(rotn_matrix)]
  rotn[coord] = rotn[coord] + rotn_matrix[coord];
endfor
if (what:set_vrml_rotation(rotn) != rotn)
  return "For some reason, you can't seem to move that there.";
endif
"Last modified Wed Mar 20 20:59:06 1996 EST by EricM (#5058@DU_MainMOO).";
.

@verb #108:"angle_in_radians" this none this
@program #108:angle_in_radians
"angle_in_radians (angle NUM, units STR) -> ERR or angle STR";
"interprets the given angle in terms of the given units, returning radians";
"return angle in radians times 10^3";
"round to third decimal place";
angle = args[1];
units = args[2];
unitnames = {"radians", "radian", "degrees", "degree"};
if (!(idx = units in unitnames))
  return E_INVARG;
endif
factor = {1000, 1000, 1745329, 1745329};
return (angle * factor[idx]) / 100000;
"Last modified Wed Mar 20 22:22:36 1996 EST by EricM (#5058@DU_MainMOO).";
.

@verb #108:"calc_rotn_matrix" this none this
@program #108:calc_rotn_matrix
"calc_rotn_matrix(amount NUM, dir STR) -> {X-rotn, Y-rotn, Z-rotn}";
"Given the amount to rotate an object (in radians), and a direction";
"(arbitrary word from recognized list), how much must object be rotated";
"around each axis";
"Recognized: n, s, e, w, ne, se, sw, nw, cw, ccw";
orthog = {"n", "e", "s", "w", "cw", "ccw"};
angled = {"ne", "se", "sw", "nw"};
amount = args[1];
dir = args[2];
if (idx = dir in orthog)
  mult = {{-1, 0, 0}, {0, 0, 1}, {1, 0, 0}, {0, 0, -1}, {0, -1, 0}, {0, 1, 0}}[idx];
elseif (idx = dir in angled)
  mult = {{1, 0, -1}, {1, 0, 1}, {-1, 0, 1}, {-1, 0, -1}}[idx];
  amount = sqrt((amount * amount) / 2);
else
  return E_INVARG;
endif
for i in [1..3]
  mult[i] = mult[i] * amount;
endfor
return mult;
"Last modified Sat Mar 23 04:21:56 1996 EST by EricM (#5058@DU_MainMOO).";
.

"***finished***
