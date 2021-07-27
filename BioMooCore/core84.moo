$Header: /repo/public.cvs/app/BioGate/BioMooCore/core84.moo,v 1.1 2021/07/27 06:44:35 bruce Exp $

>@dump #84 with create
@create $container named Feature Warehouse:Feature Warehouse,warehouse
;;#84.("dark") = 0
;;#84.("opened") = 1
;;#84.("aliases") = {"Feature Warehouse", "warehouse"}
;;#84.("object_size") = {1488, 855068591}

@verb #84:"list" any in this rxd
@program #84:list
"Copied from Features Feature Object (#24300):list by Joe (#2612) Mon Oct 10 21:07:35 1994 PDT";
if (this.contents)
  player:tell(".features objects:");
  player:tell("----------------------");
  first = 1;
  for thing in (this.contents)
    $command_utils:kill_if_laggy(10, "Sorry, the MOO is very laggy, and there are too many feature objects in here to list!");
    $command_utils:suspend_if_needed(0);
    if (!first)
      player:tell();
    endif
    player:tell(thing.name, ":");
    thing:look_self();
    first = 0;
  endfor
  player:tell("----------------------");
else
  player:tell("No objects in ", this.name, ".");
endif
.

"***finished***
