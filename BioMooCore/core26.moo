$Header: /repo/public.cvs/app/BioGate/BioMooCore/core26.moo,v 1.1 2021/07/27 06:44:29 bruce Exp $

>@dump #26 with create
@create $generic_utils named Math Utilities:Math Utilities,Math_Utils,trigonometric utilites,trig_utils
@prop #26."base_alphabet" "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" rc
@prop #26."tangents" {} rc
;;#26.("tangents") = {174, 349, 524, 699, 874, 1051, 1227, 1405, 1583, 1763, 1943, 2125, 2308, 2493, 2679, 2867, 3057, 3249, 3443, 3639, 3838, 4040, 4244, 4452, 4663, 4877, 5095, 5317, 5543, 5773, 6008, 6248, 6494, 6745, 7002, 7265, 7535, 7812, 8097, 8390, 8692, 9004, 9325, 9656, 10000}
@prop #26."factor" 10000 rc
@prop #26."taylor" 100 rc
@prop #26."and" {} rc
;;#26.("and") = {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1}, {0, 0, 2, 2, 0, 0, 2, 2, 0, 0, 2, 2, 0, 0, 2, 2}, {0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3}, {0, 0, 0, 0, 4, 4, 4, 4, 0, 0, 0, 0, 4, 4, 4, 4}, {0, 1, 0, 1, 4, 5, 4, 5, 0, 1, 0, 1, 4, 5, 4, 5}, {0, 0, 2, 2, 4, 4, 6, 6, 0, 0, 2, 2, 4, 4, 6, 6}, {0, 1, 2, 3, 4, 5, 6, 7, 0, 1, 2, 3, 4, 5, 6, 7}, {0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8}, {0, 1, 0, 1, 0, 1, 0, 1, 8, 9, 8, 9, 8, 9, 8, 9}, {0, 0, 2, 2, 0, 0, 2, 2, 8, 8, 10, 10, 8, 8, 10, 10}, {0, 1, 2, 3, 0, 1, 2, 3, 8, 9, 10, 11, 8, 9, 10, 11}, {0, 0, 0, 0, 4, 4, 4, 4, 8, 8, 8, 8, 12, 12, 12, 12}, {0, 1, 0, 1, 4, 5, 4, 5, 8, 9, 8, 9, 12, 13, 12, 13}, {0, 0, 2, 2, 4, 4, 6, 6, 8, 8, 10, 10, 12, 12, 14, 14}, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}}
@prop #26."xor" {} rc
;;#26.("xor") = {{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}, {1, 0, 3, 2, 5, 4, 7, 6, 9, 8, 11, 10, 13, 12, 15, 14}, {2, 3, 0, 1, 6, 7, 4, 5, 10, 11, 8, 9, 14, 15, 12, 13}, {3, 2, 1, 0, 7, 6, 5, 4, 11, 10, 9, 8, 15, 14, 13, 12}, {4, 5, 6, 7, 0, 1, 2, 3, 12, 13, 14, 15, 8, 9, 10, 11}, {5, 4, 7, 6, 1, 0, 3, 2, 13, 12, 15, 14, 9, 8, 11, 10}, {6, 7, 4, 5, 2, 3, 0, 1, 14, 15, 12, 13, 10, 11, 8, 9}, {7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8}, {8, 9, 10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5, 6, 7}, {9, 8, 11, 10, 13, 12, 15, 14, 1, 0, 3, 2, 5, 4, 7, 6}, {10, 11, 8, 9, 14, 15, 12, 13, 2, 3, 0, 1, 6, 7, 4, 5}, {11, 10, 9, 8, 15, 14, 13, 12, 3, 2, 1, 0, 7, 6, 5, 4}, {12, 13, 14, 15, 8, 9, 10, 11, 4, 5, 6, 7, 0, 1, 2, 3}, {13, 12, 15, 14, 9, 8, 11, 10, 5, 4, 7, 6, 1, 0, 3, 2}, {14, 15, 12, 13, 10, 11, 8, 9, 6, 7, 4, 5, 2, 3, 0, 1}, {15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0}}
@prop #26."sines" {} rc
;;#26.("sines") = {175, 349, 523, 698, 872, 1045, 1219, 1392, 1564, 1736, 1908, 2079, 2250, 2419, 2588, 2756, 2924, 3090, 3256, 3420, 3584, 3746, 3907, 4067, 4226, 4384, 4540, 4695, 4848, 5000, 5150, 5299, 5446, 5592, 5736, 5878, 6018, 6157, 6293, 6428, 6561, 6691, 6820, 6947, 7071, 7193, 7314, 7431, 7547, 7660, 7771, 7880, 7986, 8090, 8192, 8290, 8387, 8480, 8572, 8660, 8746, 8829, 8910, 8988, 9063, 9135, 9205, 9272, 9336, 9397, 9455, 9511, 9563, 9613, 9659, 9703, 9744, 9781, 9816, 9848, 9877, 9903, 9925, 9945, 9962, 9976, 9986, 9994, 9998, 10000, 9998, 9994, 9986, 9976, 9962, 9945, 9925, 9903, 9877, 9848, 9816, 9781, 9744, 9703, 9659, 9613, 9563, 9511, 9455, 9397, 9336, 9272, 9205, 9135, 9063, 8988, 8910, 8829, 8746, 8660, 8572, 8480, 8387, 8290, 8192, 8090, 7986, 7880, 7771, 7660, 7547, 7431, 7314, 7193, 7071, 6947, 6820, 6691, 6561, 6428, 6293, 6157, 6018, 5878, 5736, 5592, 5446, 5299, 5150, 5000, 4848, 4695, 4540, 4384, 4226, 4067, 3907, 3746, 3584, 3420, 3256, 3090, 2924, 2756, 2588, 2419, 2250, 2079, 1908, 1736, 1564, 1392, 1219, 1045, 872, 698, 523, 349, 175, 0, -175, -349, -523, -698, -872, -1045, -1219, -1392, -1564, -1736, -1908, -2079, -2250, -2419, -2588, -2756, -2924, -3090, -3256, -3420, -3584, -3746, -3907, -4067, -4226, -4384, -4540, -4695, -4848, -5000, -5150, -5299, -5446, -5592, -5736, -5878, -6018, -6157, -6293, -6428, -6561, -6691, -6820, -6947, -7071, -7193, -7314, -7431, -7547, -7660, -7771, -7880, -7986, -8090, -8192, -8290, -8387, -8480, -8572, -8660, -8746, -8829, -8910, -8988, -9063, -9135, -9205, -9272, -9336, -9397, -9455, -9511, -9563, -9613, -9659, -9703, -9744, -9781, -9816, -9848, -9877, -9903, -9925, -9945, -9962, -9976, -9986, -9994, -9998, -10000, -9998, -9994, -9986, -9976, -9962, -9945, -9925, -9903, -9877, -9848, -9816, -9781, -9744, -9703, -9659, -9613, -9563, -9511, -9455, -9397, -9336, -9272, -9205, -9135, -9063, -8988, -8910, -8829, -8746, -8660, -8572, -8480, -8387, -8290, -8192, -8090, -7986, -7880, -7771, -7660, -7547, -7431, -7314, -7193, -7071, -6947, -6820, -6691, -6561, -6428, -6293, -6157, -6018, -5878, -5736, -5592, -5446, -5299, -5150, -5000, -4848, -4695, -4540, -4384, -4226, -4067, -3907, -3746, -3584, -3420, -3256, -3090, -2924, -2756, -2588, -2419, -2250, -2079, -1908, -1736, -1564, -1392, -1219, -1045, -872, -698, -523, -349, -175, 0, 175}
;;#26.("help_msg") = {"Trigonometric/Exponential functions:", "  sin(a),cos(a),tan(a) -- returns 10000*(the value of the corresponding", "       trigonometric function) angle a is in degrees.", "  arctan([x,]y) -- returns arctan(y/x) in degrees in the range -179..180.", "       x defaults to 10000.  Quadrant is that of (x,y).", "  exp(x[,n]) -- calculates e^x with an nth order taylor polynomial", "  aexp(x) -- calculates 10000 e^(x/10000)", "", "Statistical functions:", "  combinations(n,r) -- returns the number of combinations given n objects", "       taken r at a time.", "  permutations(n,r) -- returns the number of permutations possible given", "       n objects taken r at a time.", "", "Number decomposition:", "  div(n,d) -- correct version of / (handles negative numbers correctly)", "  mod(n,d) -- correct version of % (handles negative numbers correctly)", "  divmod(n,d) -- {div(n,d),mod(n,d)}", "  parts(n,q[,i]) -- returns a list of two elements {integer,decimal fraction}", "", "Other math functions:", "  sqrt(x)      -- returns the largest integer n <= the square root of x", "  pow(x,n)     -- returns x^n", "  factorial(x) -- returns x!", "  norm(a,b,c,d,...) -- returns sqrt(a^2+b^2+c^2+...)", "  sum(a,b,c,d,...) -- returns the sum of all arguments.", "", "Series:", "  fibonacci(n) -- returns the 1st n fibonacci numbers in a list", "  geometric(x,n) -- returns the value of the nth order geometric series at x", "", "Integer Properties:", "  gcd(a,b) -- find the greatest common divisor of the two numbers", "  lcm(a,b) -- find the least common multiple of the two numbers", "  are_relatively_prime(a,b) -- return 1 if a and b are relatively prime", "  is_prime(n) -- returns 1 if the number is a prime and 0 otherwise", "  ", "Miscellaneous:", "  random(n) -- returns a random number from 0..n if n > 0 or n..0 if n < 0", "  random_range(n[,mean]) -- returns a random number from mean - n..mean + n", "      with mean defaulting to 0", "  simpson({a,b},{f(a),f((a+b)/2),f(b)}) -- returns the numerical", "      approximation of an integral using simpson's rule", "  base_conversion(num|string, oldbase, newbase [,sens]) -- converts the number", "      given as first arg from oldbase to the newbase.", "", "Bitwise Arithmetic:", "  AND(x,y) -- returns x AND y", "  OR(x,y) -- returns x OR y", "  XOR(x,y) -- returns x XOR y (XOR is the exclusive-or function)", "  NOT(x) -- returns the complement of x", "      All bitwise manipulation is of 32-bit values.", "", "Bitwise Conversions:", "  BlFromInt(d) -- converts a decimal number d to a list of 1's and 0's, 32-bit", "  IntFromBl(b) -- converts a list of 1's and 0's (any precision) to decimal"}
;;#26.("aliases") = {"Math Utilities", "Math_Utils", "trigonometric utilites", "trig_utils"}
;;#26.("description") = {"This is the Math Utilities utility package.  See `help $math_utils' for more details."}
;;#26.("object_size") = {32040, 855068591}

@verb #26:"xsin" this none this
@program #26:xsin
"xsin(INT x) -- calculates the taylor approximation for the sine function";
if (typeof(x = args[1]) != INT)
  return E_TYPE;
endif
if ((x * x) > this.taylor)
  return ((this:xsin(x / 2) * this:xcos((x + 1) / 2)) + (this:xsin((x + 1) / 2) * this:xcos(x / 2))) / 10000;
else
  return (x * (17453000 - ((x * x) * 886))) / 100000;
endif
.

@verb #26:"xcos" this none this
@program #26:xcos
"xcos(INT x) -- calculates the taylor approximation for the cosine function";
if (typeof(x = args[1]) != INT)
  return E_TYPE;
endif
if ((x * x) > this.taylor)
  return ((this:xcos(x / 2) * this:xcos((x + 1) / 2)) - (this:xsin(x / 2) * this:xsin((x + 1) / 2))) / 10000;
else
  return (1000000000 - ((x * x) * (152309 + ((4 * x) * x)))) / 100000;
endif
.

@verb #26:"factorial" this none this
@program #26:factorial
"factorial(INT n) -- returns n factorial for 0 <= n (<= 12).";
if ((number = args[1]) < 0)
  return E_INVARG;
elseif (typeof(number) != INT)
  return E_TYPE;
endif
fact = 1;
for i in [2..number]
  fact = fact * i;
endfor
return fact;
.

@verb #26:"pow" this none this
@program #26:pow
"pow(INT|FLOAT x,(INT)|(INT|FLOAT) n) -- returns x raised to the nth power. n must be >= 0. If x is an integer, n must be an integer. If x is a floating point number, n can be either.";
{x, n} = args;
if (n < 0)
  return E_INVARG;
elseif ((typeof(x) == INT) && (typeof(n) == FLOAT))
  return E_TYPE;
endif
return x ^ n;
"old code below";
n = args[1];
if (power % 2)
  ret = n;
else
  ret = 1;
endif
while (power = power / 2)
  n = n * n;
  if (power % 2)
    ret = ret * n;
  endif
endwhile
return ret;
.

@verb #26:"fibonacci" this none this
@program #26:fibonacci
"fibonacci(INT n) -- calculates the fibonacci numbers to the nth term";
"and returns them in a list. n must be >= 0.";
if (typeof(n) != INT)
  return E_TYPE;
elseif ((n = args[1]) < 0)
  return E_INVARG;
elseif (n == 0)
  return {0};
else
  x = {0, 1};
  for i in [2..n]
    x = {@x, x[$ - 1] + x[$]};
  endfor
  return x;
endif
.

@verb #26:"geometric" this none this
@program #26:geometric
"geometric(INT|FLOAT x [,INT n]) -- calculates the value of the geometric series at x to the nth term. i.e., approximates 1/(1-x) when |x| < 1. This, of course, is impossible in MOO, but someone may find it useful in some way.";
"n defaults to 5. n must be >= 0.";
{n, ?order = 5} = args;
if ((!(typeof(n) in {INT, FLOAT})) || (typeof(order) != INT))
  return E_TYPE;
elseif (order <= 0)
  return E_INVARG;
endif
x = 1;
for i in [1..order]
  x = x + (n ^ i);
endfor
return x;
.

@verb #26:"divmod" this none this
@program #26:divmod
"divmod(INT n, INT d) => {q,r} such that n = dq + r";
"  handles negative numbers correctly   0<=r<d if d>0, -d<r<=0 if d<0.";
{n, d} = args;
if ((typeof(n) != INT) && (typeof(d) != INT))
  return E_TYPE;
endif
r = ((n % d) + d) % d;
q = (n - r) / d;
return {q, r};
.

@verb #26:"combinations" this none this
@program #26:combinations
"combinations(INT n, INT r) -- returns the number of ways one can choose r";
"objects from n distinct choices.";
"C(n,r) = n!/[r!(n-r)!]";
"  overflow may occur if n>29...";
{n, r} = args;
if ((typeof(n) != INT) && (typeof(r) != INT))
  return E_TYPE;
endif
if (0 > (r = min(r, n - r)))
  return 0;
else
  c = 1;
  n = n + 1;
  for i in [1..r]
    c = (c * (n - i)) / i;
  endfor
  return c;
endif
.

@verb #26:"permutations" this none this
@program #26:permutations
"permutations(INT n, INT r) -- returns the number of ways possible for one to";
"order r distinct objects given n locations.";
"P(n,r) = n!/(n-r)!";
{n, r} = args;
if ((typeof(n) != INT) && (typeof(r) != INT))
  return E_TYPE;
endif
if ((r < 1) || ((diff = n - r) < 0))
  return 0;
else
  p = n;
  for i in [diff + 1..n - 1]
    p = p * i;
  endfor
  return p;
endif
.

@verb #26:"simpson" this none this
@program #26:simpson
"simpson({a,b},{f(a),f((a+b)/2),f(b)} [,INT ret-float])";
" -- given two endpoints, a and b, and the functions value at a, (a+b)/2, and b, this will calculate a numerical approximation of the integral using simpson's rule.";
"Entries can either be all INT or all FLOAT. Don't mix!";
"If the optional 3rd argument is provided and true, the answer is returned as a floating point regardless of what the input was. Otherwise, if the input was all INT, the answer is returned as {integer,fraction}";
{point, fcn, ?retfloat = 0} = args;
if ((!retfloat) && (typeof(point[1]) == INT))
  numer = (point[2] - point[1]) * ((fcn[1] + (4 * fcn[2])) + fcn[3]);
  return this:parts(numer, 6);
else
  numer = tofloat(point[2] - point[1]) * ((tofloat(fcn[1]) + (4.0 * tofloat(fcn[2]))) + tofloat(fcn[3]));
  return numer / 6.0;
endif
.

@verb #26:"parts" this none this
@program #26:parts
"parts(INT n, INT q [,INT i]) -- returns a decomposition of n by q into integer and floating point parts with i = the number of digits after the decimal.";
"i defaults to 5.";
"warning: it is quite easy to hit maxint which results in unpredictable";
"         results";
{n, q, ?i = 5} = args;
if (((typeof(n) != INT) && (typeof(q) != INT)) && (typeof(i) != INT))
  return E_TYPE;
endif
parts = {n / q, n % q};
return {parts[1], (parts[2] * (10 ^ i)) / q};
.

@verb #26:"sqrt" this none this
@program #26:sqrt
"sqrt(INT|FLOAT n) => largest integer <= square root of n. Returns the same type as the input. (Backwards compatibility)";
n = args[1];
return (typeof(n) == INT) ? toint(sqrt(tofloat(n))) | sqrt(n);
"Old code. Newton's method";
if (n < 0)
  return E_RANGE;
elseif (n)
  x1 = n;
  while (x1 > (x2 = (x1 + (n / x1)) / 2))
    x1 = x2;
  endwhile
  return x1;
else
  return 0;
endif
.

@verb #26:"div" this none this
@program #26:div
"div(INT n, INT d) => q such that n = dq + r and  (0<=r<d if d>0, -d<r<=0 if d<0).";
return this:divmod(@args)[1];
.

@verb #26:"mod" this none this
@program #26:mod
"A correct mod function.";
"mod(INT n, INT d) => r such that n = dq + r and (0<=r<d if d>0 or -d<r<=0 if d<0).";
{n, d} = args;
if ((typeof(n) != INT) && (typeof(d) != INT))
  return E_TYPE;
endif
return ((n % d) + d) % d;
.

@verb #26:"exp" this none this
@program #26:exp
"exp(INT|FLOAT x[,INT n]) -- calculates an nth order taylor approximation for e^x.";
"n defaults to 5. Any n given must be >= 0. you need to divide the result";
"the answer will be returned as {integer part,fractional part} if the input x was an integer. If it is floating point, so will the answer (and this uses the builtin function.)";
{x, ?n = 5} = args;
if (typeof(x) == FLOAT)
  return exp(x);
elseif ((typeof(x) != INT) && (typeof(n) != INT))
  return E_TYPE;
endif
ex = nfact = 1;
for i in [0..n - 1]
  j = n - i;
  ex = (ex * x) + (nfact = nfact * j);
endfor
return this:parts(ex, nfact);
.

@verb #26:"aexp" this none this
@program #26:aexp
"returns 10000 exp (x/10000)";
"The accuracy seems to be ~0.1% for 0<x<4";
x = args[1];
if (x < 0)
  z = this:(verb)(-x);
  return (100000000 + (z / 2)) / z;
elseif (x > 1000)
  z = this:(verb)(x / 2);
  if (z > 1073741823)
    return $maxint;
    "maxint for overflows";
  elseif (z > 460000)
    z = ((z + 5000) / 10000) * z;
  elseif (z > 30000)
    z = ((((z + 50) / 100) * z) + 50) / 100;
  else
    z = ((z * z) + 5000) / 10000;
  endif
  if (x % 2)
    return z + ((z + 5000) / 10000);
  else
    return z;
  endif
else
  return ((10000 + x) + (((x * x) + 10000) / 20000)) + ((((x * x) * x) + 300000000) / 600000000);
endif
.

@verb #26:"random" this none this
@program #26:random
"random(INT n): returns a random integer in the following manner:";
"random(n > 0) will return a integer in the range 0 to n";
"random(n < 0) will return a integer in the range n to 0";
if (typeof(prob = args[1]) != INT)
  return E_TYPE;
endif
mod = (prob < 0) ? -1 | 1;
return (mod * random(abs(prob + mod))) - mod;
.

@verb #26:"random_range" this none this
@program #26:random_range
"random_range(INT range [,INT mean]): returns a random integer within the given range from the mean. if the mean isn't given, it defaults to 0";
"e.g., random_range(10) => -10..10";
"      random_range(10,4) => -6..14";
{range, ?mean = 0} = args;
if ((typeof(range) != INT) && (typeof(mean) != INT))
  return E_TYPE;
endif
return mean + (((random(2) == 1) ? -1 | 1) * this:random(range));
.

@verb #26:"is_prime" this none this
@program #26:is_prime
"is_prime(INT number) returns 1 if the number is prime or 0 if it isn't.";
"of course, only positive numbers are candidates for primality.";
if (typeof(number = args[1]) != INT)
  return E_TYPE;
endif
if (number == 2)
  return 1;
elseif ((number < 2) || ((number % 2) == 0))
  return 0;
else
  choice = 3;
  while (((denom = choice * choice) <= number) && (denom > 0))
    if ((seconds_left() < 2) || (ticks_left() < 25))
      suspend(0);
    endif
    if ((number % choice) == 0)
      return 0;
    endif
    choice = choice + 2;
  endwhile
endif
return 1;
.

@verb #26:"AND XOR" this none this
@program #26:AND
"Only useful for integer input.";
{x, y} = args;
if ((typeof(x) != INT) && (typeof(y) != INT))
  return E_TYPE;
endif
table = this.(verb);
if (xsgn = x < 0)
  x = x + $minint;
endif
if (ysgn = y < 0)
  y = y + $minint;
endif
power = 1;
z = 0;
while (x || y)
  z = z + (power * table[1 + (x % 16)][1 + (y % 16)]);
  x = x / 16;
  y = y / 16;
  power = power * 16;
endwhile
if (table[1 + xsgn][1 + ysgn])
  return z + $minint;
else
  return z;
endif
.

@verb #26:"OR" this none this
@program #26:OR
return this:NOT(this:AND(this:NOT(args[1]), this:NOT(args[2])));
.

@verb #26:"NOT" this none this
@program #26:NOT
return -(1 + args[1]);
"";
"... here's what it used to be ...";
bl1 = this:BLFromInt(args[1]);
blOut = {};
for i in [1..32]
  blOut = {@blOut, !bl1[i]};
endfor
return this:IntFromBL(blOut);
.

@verb #26:"BLFromInt" this none this
@program #26:BLFromInt
"BlFromInt(INT x) => converts the number provided into a 32 bit binary number, which is returned via a 32 element LIST of 1's and 0's. Note that this verb was originally written to be used with the $math_utils verbs: AND, NOT, OR, XOR, but has since been taken out of them.";
if (typeof(x = args[1]) != INT)
  return E_TYPE;
endif
l = {};
firstbit = x < 0;
if (firstbit)
  x = x + $minint;
endif
for i in [1..31]
  l = {x % 2, @l};
  x = x / 2;
endfor
return {firstbit, @l};
.

@verb #26:"IntFromBL" this none this
@program #26:IntFromBL
"IntFromBl(LIST of 1's and 0's) => converts the 32 bit binary representation given by the list of 1's and 0's and converts it to a normal decimal number. Note that this verb was originally written to be used with the $math_utils verbs: AND, NOT, OR, XOR, but has since been taken out of them.";
bl = args[1];
x = 0;
for l in (bl)
  x = x * 2;
  x = x + l;
endfor
return x;
.

@verb #26:"gcd greatest_common_divisor" this none this
@program #26:gcd
"gcd(INT num1,INT num2): find the greatest common divisor of the two numbers";
"using the division algorithm. the absolute values of num1 and num2 are";
"used without loss of generality.";
num1 = abs(args[1]);
num2 = abs(args[2]);
max = max(num1, num2);
min = min(num1, num2);
if (r1 = max % min)
  while (r2 = min % r1)
    min = r1;
    r1 = r2;
  endwhile
  return r1;
else
  return min;
endif
.

@verb #26:"lcm least_common_multiple" this none this
@program #26:lcm
"lcm(INT num1,INT num2): find the least common multiple of the two numbers.";
"we shall use the positive lcm value without loss of generality.";
"since we have gcd already, we'll just use lcm*gcd = num1*num2";
num1 = abs(args[1]);
num2 = abs(args[2]);
return (num1 * num2) / this:gcd(num1, num2);
.

@verb #26:"are_rel_prime are_relatively_prime" this none this
@program #26:are_rel_prime
"are_rel_prime(INT num1,INT num2): returns 1 if num1 and num2 are relatively";
"prime.";
"since we have gcd, this is pretty easy.";
if (this:gcd(args[1], args[2]) == 1)
  return 1;
else
  return 0;
endif
.

@verb #26:"base_conversion" this none this
@program #26:base_conversion
"Call with first arg either a number or a string, being the number";
"desired for conversion. capital letters denote values from 10-35;";
"lowercase letters from 36 to 61. Maximal base is 62.";
"You will be unable to use the extra 26 lowercases as separate unless";
"you pass a nonzero fourth argument. Passing zero or none uses the";
"default value, which is to have AAAA=aaaa.";
"The second and third arguments should be the base of the number and";
"the base you want it in, respectively.";
"Any of the arguments can be strings or nums, but high-base numbers";
"will need to be strings. This returns a string.";
"Any problems, talk to Ozymandias.";
sensitive = 0;
if (length(args) < 3)
  return E_INVARG;
elseif (length(args) == 4)
  sensitive = toint(args[4]);
endif
result = 0;
thenum = tostr(args[1]);
origbase = toint(args[2]);
newbase = toint(args[3]);
if ((((origbase < 2) || (newbase < 2)) || (origbase > 62)) || (newbase > 62))
  return E_INVARG;
endif
for which in [1..length(thenum)]
  value = index(this.base_alphabet, thenum[which], sensitive);
  if ((!value) || (value > origbase))
    return E_INVARG;
  endif
  result = ((result * origbase) + value) - 1;
endfor
thestring = "";
if (result < 0)
  return E_INVARG;
endif
while (result)
  if ((which = (result % newbase) + 1) <= length(this.base_alphabet))
    thestring = this.base_alphabet[which] + thestring;
  else
    return E_INVARG;
  endif
  result = result / newbase;
endwhile
return thestring;
.

@verb #26:"norm" this none this
@program #26:norm
":norm(a,b,c,d...) => sqrt(a^2+b^2+c^2+...)";
m = max(max(@args), -min(@args));
logm = length(tostr(m));
if (logm <= 4)
  s = 0;
  for a in (args)
    s = s + (a * a);
  endfor
  return toint(sqrt(tofloat(s)));
else
  factor = toint("1" + "0000000"[1..logm - 4]);
  s = 0;
  for a in (args)
    a = a / factor;
    s = s + (a * a);
  endfor
  return toint(sqrt(tofloat(s))) * factor;
endif
.

@verb #26:"sum" this none this
@program #26:sum
":sum(INT|FLOAT num, num, num ...) => Total of all arguments added together.";
":sum({num, num, num, ...}) will also work.";
total = (typeof((typeof(x = args[1]) == LIST) ? x[1] | x) == INT) ? 0 | 0.0;
for number in ((typeof(x) == LIST) ? x | args)
  total = total + number;
endfor
return total;
.

@verb #26:"sin" this none this
@program #26:sin
"Copied from Trig_Utils (#25800):sin by Obvious (#54879) Fri Nov 17 06:07:39 1995 PST";
theta = args[1];
if (typeof(theta) == FLOAT)
  return sin(theta);
elseif (typeof(theta) == INT)
  degtheta = theta % 360;
  mintheta = 0;
elseif (typeof(theta) == LIST)
  degtheta = theta[1] % 360;
  mintheta = theta[2] % 60;
else
  return E_INVARG;
endif
if (mintheta < 0)
  mintheta = mintheta + 60;
  degtheta = degtheta - 1;
endif
while (degtheta < 1)
  degtheta = degtheta + 360;
endwhile
if (mintheta == 0)
  return this.sines[degtheta];
endif
lim1 = this.sines[degtheta];
lim2 = this.sines[degtheta + 1];
delta = lim2 - lim1;
result = (((delta * mintheta) + 30) / 60) + lim1;
return result;
.

@verb #26:"cos" this none this
@program #26:cos
"Copied from Trig_Utils (#25800):cos by Obvious (#54879) Fri Nov 17 06:07:50 1995 PST";
theta = args[1];
if (typeof(theta) == FLOAT)
  return cos(theta);
elseif (typeof(theta) == INT)
  degtheta = 90 - theta;
  mintheta = 0;
elseif (typeof(theta) == LIST)
  degtheta = 89 - theta[1];
  mintheta = 60 - theta[2];
else
  return;
endif
return this:sin({degtheta, mintheta});
.

@verb #26:"tan" this none this
@program #26:tan
"Copied from Trig_Utils (#25800):tan by Obvious (#54879) Fri Nov 17 06:07:53 1995 PST";
{theta} = args;
if (typeof(theta) == FLOAT)
  return tan(theta);
endif
sine = this:sin(theta);
cosine = this:cos(theta);
return ((sine * 10000) + ((cosine + 1) / 2)) / cosine;
.

@verb #26:"arcsin asin" this none this
@program #26:arcsin
"Copied from Trig_Utils (#25800):arcsin by Obvious (#54879) Fri Nov 17 06:08:01 1995 PST";
{given} = args;
if (typeof(given) == FLOAT)
  return asin(given);
endif
given = abs(given);
if (given > 10000)
  return E_RANGE;
endif
i = 1;
while (given > this.sines[i])
  i = i + 1;
endwhile
if (given == this.sines[i])
  if (args[1] < 0)
    return {-i, 0};
  else
    return {i, 0};
  endif
endif
degrees = i - 1;
if (i == 1)
  lower = 0;
else
  lower = this.sines[i - 1];
endif
upper = this.sines[i];
delta1 = given - lower;
delta2 = upper - lower;
minutes = ((delta1 * 60) + ((delta2 + 1) / 2)) / delta2;
if (args[1] < 0)
  degrees = -degrees;
  minutes = -minutes;
endif
return {degrees, minutes};
.

@verb #26:"arccos acos" this none this
@program #26:arccos
"Copied from Trig_Utils (#25800):arccos by Obvious (#54879) Fri Nov 17 06:08:08 1995 PST";
given = args[1];
if (typeof(given) == FLOAT)
  return acos(given);
endif
arcsin = this:arcsin(given);
degrees = 89 - arcsin[1];
minutes = 60 - arcsin[2];
if (minutes > 60)
  minutes = minutes - 60;
  degrees = degrees + 1;
endif
return {degrees, minutes};
.

@verb #26:"arctan atan" this none this
@program #26:arctan
"Copied from Trig_Utils (#25800):arctan by Obvious (#54879) Fri Nov 17 06:08:18 1995 PST";
given = args[1];
if (typeof(given) == FLOAT)
  return atan(given);
endif
reciprocal = ((given * given) / 10000) + 10000;
reciprocal = sqrt(reciprocal * 10000);
cosine = 100000000 / reciprocal;
return this:arccos(cosine);
.

"***finished***
