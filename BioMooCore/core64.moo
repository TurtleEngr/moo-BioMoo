$Header: /repo/public.cvs/app/BioGate/BioMooCore/core64.moo,v 1.1 2021/07/27 06:44:34 bruce Exp $

>@dump #64 with create
@create $nothing named Generic Garbage Object:garbage
@prop #64."aliases" {} r
;;#64.("aliases") = {"garbage"}

@verb #64:"description" this none this rxd #2
@program #64:description
return ("Garbage object " + tostr(this)) + ".";
.

@verb #64:"look_self" this none this rxd #2
@program #64:look_self
player:tell(this:description());
.

@verb #64:"title titlec" this none this rxd #2
@program #64:title
return tostr("Recyclable ", this);
.

@verb #64:"tell" this none this rxd #2
@program #64:tell
return;
.

"***finished***
