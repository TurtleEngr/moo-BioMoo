$Header: /repo/public.cvs/app/BioGate/BioMooCore/core36.moo,v 1.1 2021/07/27 06:44:31 bruce Exp $

>@dump #36 with create
@create $prog named Hacker:Hacker
;;#36.("mail_forward") = {#2}
;;#36.("last_disconnect_time") = 2147483647
;;#36.("owned_objects") = 0
;;#36.("pq") = "his"
;;#36.("pqc") = "His"
;;#36.("last_connect_time") = 2147483647
;;#36.("ownership_quota") = -10000
;;#36.("gender") = "male"
;;#36.("prc") = "Himself"
;;#36.("ppc") = "His"
;;#36.("poc") = "Him"
;;#36.("psc") = "He"
;;#36.("pr") = "himself"
;;#36.("pp") = "his"
;;#36.("po") = "him"
;;#36.("ps") = "he"
;;#36.("size_quota") = {100000008, -22557717, 850834254, 42249}
;;#36.("web_options") = {{"telnet_applet", #110}, "applinkdown", "exitdetails", "map", "embedVRML", "separateVRML"}
;;#36.("aliases") = {"Hacker"}
;;#36.("description") = "A system character used to own non-wizardly system verbs , properties, and objects in the core."
;;#36.("object_size") = {1678, 855068591}
;;#36.("vrml_desc") = {"WWWInline {name \"http://hppsda.mayfield.hp.com/image/body.wrl\"}", ""}

@verb #36:"init_for_core" this none this rxd #2
@program #36:init_for_core
if (caller_perms().wizard)
  pass();
  this.mail_forward = {#2};
endif
.

"***finished***
