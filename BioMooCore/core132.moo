$Header: /repo/public.cvs/app/BioGate/BioMooCore/core132.moo,v 1.1 2021/07/27 06:44:28 bruce Exp $

>@dump #132 with create
@create $magnetic_thing named lag meter:lag meter,meter
@prop #132."about" {} rc
;;#132.("about") = {"The meter makes a rough real-time measurement of the MOO server lag. Server lag happens when there are many player commands and many background tasks to be processed, and the MOO can't keep up with them all. The meter does not measure network lag. If you have a bad network connection, your total lag may be much greater than the server lag.", "", "    read meter                        - see the one-line meter display", "    lags on meter                     - see the sampled lags, in seconds", "    turn meter on                     - turn on the meter", "    turn meter off                    - turn off the meter", "    reset meter                       - zap the meter's stats, and start over", "    reset meter to <time> <samples>   - change the meter's averaging behavior", "", "The <time> is a number of seconds, the time interval over which the meter calculates the average lag. <Samples> is the number of samples the meter takes over that interval. If <time> is small, like 60 seconds, the meter is very sensitive to rapid fluctuations in the lag.", "", "The meter is also a feature object. Do '@add-feature #35368' and you get:", "", "    @lag                              - see the one-line meter display", "    @lags                             - see the sampled lags, in seconds"}
@prop #132."reset_usage_msg" "Usage: 'reset meter', 'reset meter to <time> <samples>', where <time> is a duration in seconds and <samples> is the number of samples to take over that time." rc
@prop #132."cycles" 1367423 r
@prop #132."cycle_scheduled" 938212793 rc
@prop #132."total" 0 r
@prop #132."samples" {} r
;;#132.("samples") = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
@prop #132."sample_count" 60 rc
@prop #132."cycle_time" 10 rc
@prop #132."active" 1 rc
@prop #132."feature_ok" 1 rc
@prop #132."feature_verbs" {} rc
;;#132.("feature_verbs") = {"@lag", "@lags"}
;;#132.("time_interval") = 600
;;#132.("aliases") = {"lag meter", "meter"}
;;#132.("description") = "This meter takes a rough measurement of the server lag, that is, how much delay the MOO itself is causing because of everything that's happening. Type 'about meter' for instructions."
;;#132.("object_size") = {0, 0}
;;#132.("web_calls") = 37
;;#132.("vrml_coords") = {{-3776, -742, 1893}, {0, 0, 0}, {1000, 1000, 1000}}
;;#132.("vrml_desc") = {"Material {diffuseColor 0.30 0.30 0.41}", "Sphere { radius 0.71}"}

@verb #132:"description" this none this
@program #132:description
"'description ()' - Return the meter's display.";
this:touch1();
settings = (((((((" The meter is adjusted to report the average lag over " + tostr(this.sample_count * this.cycle_time)) + " seconds") + " by taking ") + tostr(this.sample_count)) + " samples,") + " one each ") + tostr(this.cycle_time)) + " seconds.";
desc = {this.description + settings, this:reading()};
if (this.active && (this.cycles < this.sample_count))
  desc = {@desc, "The meter is still warming up. Its display may be off."};
endif
return desc;
.

@verb #132:"about" this none none rxd
@program #132:about
"'about meter' - Tell about the lag meter.";
this:touch1();
player:tell_lines(this.about);
.

@verb #132:"turn" any any any
@program #132:turn
"'turn meter on', 'turn meter off', 'turn on meter', 'turn off meter' - Turn the meter on or off. When things are very lagged, you might want to turn it off to keep it from making the situation worse.";
this:touch1();
if (prepstr == "on")
  if (this.active)
    player:tell("The meter is already on. If it's not working, turn it off, wait at least ", this.cycle_time, " seconds for it to cool down, and turn it back on again.");
  else
    this:startup();
    player:tell("You turn on the meter. It will take about ", this.cycle_time * this.sample_count, " seconds to warm up fully.");
    this.location:announce(player.name, " turns on the lag meter.");
  endif
elseif (prepstr == "off")
  if (this.active)
    this.active = 0;
    player:tell("You turn off the meter.");
    this.location:announce(player.name, " turns off the lag meter.");
  else
    player:tell("The meter is already off.");
  endif
else
  player:tell("Usage: 'turn meter on', 'turn meter off'.");
endif
.

@verb #132:"startup" this none this
@program #132:startup
"'startup ()' - Start the meter up.";
this:initialize();
this.active = 1;
this.cycle_scheduled = time() + this.cycle_time;
fork (this.cycle_time)
  this:lag_cycle();
endfork
.

@verb #132:"lag_cycle" this none this
@program #132:lag_cycle
"'lag_cycle ()' - Collect statistics.";
if (caller != this)
  return E_PERM;
endif
while (this.active)
  lag = time() - this.cycle_scheduled;
  i = this:first_index();
  this.total = (this.total + lag) - this.samples[i];
  this.samples[i] = lag;
  this.cycles = this.cycles + 1;
  "Start the next cycle.";
  this.cycle_scheduled = time() + this.cycle_time;
  suspend(this.cycle_time);
endwhile
.

@verb #132:"initialize" this none this
@program #132:initialize
"'initialize ()' - Clear the meter's data statistics to zero. The length of the .samples list depends on the current .sample_count, so this verb should be called every time .sample_count changes.";
pass(@args);
this.cycles = 1;
this.total = 0;
this.samples = $list_utils:make(this.sample_count, 0);
.

@verb #132:"reset" this any any rxd
@program #132:reset
"'reset meter', 'reset meter to <time> <samples>' - Reset the meter, clearing its statistics. If you provide <time> and <samples>, then the meter reports the average lag over an interval of <time> seconds, as measured by taking <samples> number of samples. The meter will refuse to sample more often than once every five seconds.";
if ((prepstr && (prepstr != "to")) || (dobj != this))
  player:tell(this.reset_usage_msg);
  return;
endif
if (prepstr)
  numbers = $string_utils:explode(iobjstr, " ");
  if (((length(numbers) != 2) || (!tonum(numbers[1]))) || (!tonum(numbers[2])))
    player:tell(this.reset_usage_msg);
    return;
  endif
  interval = tonum(numbers[1]);
  sample_count = tonum(numbers[2]);
  if ((interval < 5) || (sample_count < 1))
    player:tell("The time interval must be at least 5 seconds, and the meter must take at least one sample over the interval.");
    return;
  endif
  cycle_time = interval / sample_count;
  if (cycle_time < 5)
    player:tell("That would cause the meter to sample more often than once every five seconds. Type 'about meter' for information.");
    return;
  endif
  if ((cycle_time * sample_count) != interval)
    player:tell("The numbers don't work out evenly. The meter will actually average over a time of ", cycle_time * sample_count, " seconds.");
  endif
  this.cycle_time = cycle_time;
  this.sample_count = sample_count;
endif
player:tell("You reset the meter.");
this.location:announce(player.name, " resets the lag meter.");
this:initialize();
.

@verb #132:"read" this none none rxd
@program #132:read
"'read meter' - Read the meter. This gives you the one-line display without the description.";
player:tell(this:reading());
.

@verb #132:"reading" this none this
@program #132:reading
"'reading () -> string' - Return a string, the meter's current reading. You can call this yourself, if you happen to want the reading for some other purpose.";
if (this.active)
  if (this.total == 0)
    display = "The lag is 0 seconds flat";
  else
    lag = this:decimal1(this.total, this.sample_count);
    display = (("The lag is about " + lag) + " second") + ((lag == "1.0") ? "" | "s");
  endif
  display = display + ". It is ";
  diff = this:trend();
  delta = this.total / 5;
  small = this.sample_count / 3;
  if ((diff > delta) && (diff > small))
    display = display + "getting worse";
  elseif ((diff < (-delta)) && (diff < (-small)))
    display = display + "getting better";
  elseif (diff == 0)
    display = display + "staying level";
  else
    display = display + "holding nearly even";
  endif
  display = display + ".";
else
  display = "It is turned off. The display is dark.";
endif
return display;
.

@verb #132:"decimal1" this none this
@program #132:decimal1
"'ratioX10 (a, b) -> \"n.d\"' - Return a string, the decimal expansion of a/b to one decimal place.";
s = tostr((10 * args[1]) / args[2]);
if (length(s) == 1)
  s = "0" + s;
endif
return (s[1..length(s) - 1] + ".") + s[length(s)];
.

@verb #132:"trend_of" this none this
@program #132:trend_of
"'trend_of (<samples>)' - <Samples> is a list of lag samples, in temporal order. There are at least two samples in the list. This verb returns a rough measure of the trend of the samples, up or down.";
samples = args[1];
len = length(samples);
half = len / 2;
even = !(len % 2);
trend = 0;
for i in [1..len]
  if (i <= half)
    trend = trend - samples[i];
  elseif ((i > (half + 1)) || ((i == (half + 1)) && even))
    trend = trend + samples[i];
  endif
endfor
return trend;
.

@verb #132:"trend" this none none rxd
@program #132:trend
"'trend ()' - Return a lag trend measurement.";
return this:trend_of(this:get_lags());
.

@verb #132:"@lag" none none none rxd
@program #132:@lag
"'@lag' - Report the lag.";
player:tell(this:reading());
.

@verb #132:"help_msg" this none this
@program #132:help_msg
"'help_msg ()' - Return help information.";
return this.about;
.

@verb #132:"get_lags" this none this
@program #132:get_lags
"'get_lags ()' -> {0, 3, 0, ...} - Return the list of lag samples, in seconds. ";
i = this:first_index();
return {@this.samples[i..this.sample_count], @this.samples[1..i - 1]};
.

@verb #132:"lags_reading" this none this
@program #132:lags_reading
"'lags_reading ()' -> string - Return a string, the list of lag samples.";
lags = this:get_lags();
return (("One each " + tostr(this.cycle_time)) + " seconds, oldest to newest: ") + $string_utils:english_list(lags, "none", " ", " ", "");
.

@verb #132:"lags" none on this rxd
@program #132:lags
"'lags on meter' - See the lag samples.";
this:touch1();
player:tell(this:lags_reading());
.

@verb #132:"@lags" none none none rxd
@program #132:@lags
"'@lags' - Show the lag samples.";
player:tell(this:lags_reading());
.

@verb #132:"first_index" this none this
@program #132:first_index
"'first_index ()' -> <n> - Return the index of the 'first' lag sample in the list this.samples. The first lag is the one which was measured earliest. The lags start at the first one and wrap around to the beginning of the list.";
return (this.cycles % this.sample_count) + 1;
.

"***finished***
