$Header: /repo/public.cvs/app/BioGate/BioMooCore/core73.moo,v 1.1 2021/07/27 06:44:34 bruce Exp $

>@dump #73 with create
@create $root_class named Generic BigList Resident:biglist,resident,gblr
@prop #73."_genprop" "a" rc
@prop #73."mowner" #36 rc
@prop #73."_mgr" #13 rc
;;#73.("aliases") = {"biglist", "resident", "gblr"}
;;#73.("description") = {"This is the object you want to use as a parent in order to @create a place for your biglists to live.  Suitably sick souls may wish to reimplement :_genprop and :_kill to reclaim unused properties (this :_kill just throws them away and this :_genprop just relentlessly advances....  who cares).  Anyway, you'll need to look at $biglist before this will make sense."}
;;#73.("object_size") = {3517, 855068591}

@verb #73:"_make" this none this rxd #2
@program #73:_make
":_make(...) => new node with value {...}";
if (!(caller in {this._mgr, this}))
  return E_PERM;
endif
prop = this:_genprop();
add_property(this, prop, args, {$generic_biglist_home.owner, ""});
return prop;
.

@verb #73:"_kill" this none this rxd #2
@program #73:_kill
":_kill(node) destroys the given node.";
if (!(caller in {this, this._mgr}))
  return E_PERM;
endif
delete_property(this, args[1]);
.

@verb #73:"_get" this none this
@program #73:_get
return (caller == this._mgr) ? this.(args[1]) | E_PERM;
.

@verb #73:"_put" this none this
@program #73:_put
return (caller == this._mgr) ? this.(args[1]) = listdelete(args, 1) | E_PERM;
.

@verb #73:"_genprop" this none this
@program #73:_genprop
gp = this._genprop;
ngp = "";
for i in [1..length(gp)]
  if (gp[i] != "z")
    ngp = (ngp + "bcdefghijklmnopqrstuvwxyz"[strcmp(gp[i], "`")]) + gp[i + 1..$];
    return " " + (this._genprop = ngp);
  endif
  ngp = ngp + "a";
endfor
return " " + (this._genprop = ngp + "a");
.

@verb #73:"_ord" this none this
@program #73:_ord
"this is a dummy. You have to decide what your leaves are going to look like and then write this verb accordingly.  It should, given a leaf/list-element, return the corresponding key value.  So for an ordinary alist, where all of the leaves are of the form {key,datum}, you want:";
return args[1][1];
.

@verb #73:"init_for_core" this none this rxd #2
@program #73:init_for_core
if (!caller_perms().wizard)
  return E_PERM;
endif
this.mowner = $hacker;
this._mgr = $biglist;
.

"***finished***
