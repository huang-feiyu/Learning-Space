### [Fibonacci Hashing: The Optimization that the World Forgot (or: a Better Alternative to Integer Modulo)](https://probablydance.com/2018/06/16/fibonacci-hashing-the-optimization-that-the-world-forgot-or-a-better-alternative-to-integer-modulo/)

#### by Malte Skarupke

**The Website is good to read this blog.**

I recently posted a blog post about a new hash table, and whenever I do something like that, I learn at least one new thing from my comments. In my last comment section Rich Geldreich talks about his hash table which uses “Fibonacci Hashing”, which I hadn’t heard of before. I have worked a lot on hash tables, so I thought I have at least heard of all the big important tricks and techniques, but I also know that there are so many small tweaks and improvements that you can’t possibly know them all. I thought this might be another neat small trick to add to the collection.

Turns out I was wrong. This is a big one. And everyone should be using it. Hash tables should not be prime number sized and they should not use an integer modulo to map hashes into slots. Fibonacci hashing is just better. Yet somehow nobody is using it and lots of big hash tables (including all the big implementations of std::unordered_map) are much slower than they should be because they don’t use Fibonacci Hashing. So let’s figure this out.



First of all how do we find out what this Fibonacci Hashing is? Rich Geldreich called it “Knuth’s multiplicative method,” but before looking it up in The Art of Computer Programming, I tried googling for it. The top result right now is [this page](http://book.huihoo.com/data-structures-and-algorithms-with-object-oriented-design-patterns-in-c++/html/page214.html) which is old, with a copyright from 1997. Fibonacci Hashing is not mentioned on Wikipedia. You will find a few more pages mentioning it, mostly from universities who present this in their “introduction to hash tables” material.

From that I thought it’s one of those techniques that they teach in university, but that nobody ends up using because it’s actually more expensive for some reason. There are plenty of those in hash tables: Things that get taught because they’re good in theory, but they’re bad in practice so nobody uses them.

Except somehow, on this one, the wires got crossed. Everyone uses the algorithm that’s unnecessarily slow and leads to more problems, and nobody is using the algorithm that’s faster while at the same time being more robust to problematic patterns. Knuth talked about Integer Modulo and about Fibonacci Hashing, and everybody should have taken away from that that they should use Fibonacci Hashing, but they didn’t and everybody uses integer modulo.

Before diving into this, let me just show you the results of a simple benchmark: Looking up items in a hash table:

![unordered_map_comparison_larger_font](https://probablydance.files.wordpress.com/2018/06/unordered_map_comparison_larger_font.png?w=650)

In this benchmark I’m comparing various unordered_map implementations. I’m measuring their lookup speed when the key is just an integer. On the X-axis is the size of the container, the Y-axis is the time to find one item. To measure that, the benchmark is just spinning in a loop calling find() on this container, and at the end I divide the time that the loop took by the number of iterations in the loop. So on the left hand side, when the table is small enough to fit in cache, lookups are fast. On the right hand side the table is too big to fit in cache and lookups become much slower because we’re getting cache misses for most lookups.

But the main thing I want to draw attention to is the speed of ska::unordered_map, which uses Fibonacci hashing. Otherwise it’s a totally normal implementation of unordered_map: It’s just a vector of linked lists, with every element being stored in a separate heap allocation. On the left hand side, where the table fits in cache, ska::unordered_map can be more than twice as fast as the Dinkumware implementation of std::unordered_map, which is the next fastest implementation. (this is what you get when you use Visual Studio)

So if you use std::unordered_map and look things up in a loop, that loop could be twice as fast if the hash table used Fibonacci hashing instead of integer modulo.

### How it works

So let me explain how Fibonacci Hashing works. It’s related to the golden ratio ![\phi=1.6180339...](https://s0.wp.com/latex.php?latex=%5Cphi%3D1.6180339...&bg=fff&fg=444444&s=0&c=20201002) which is related to the Fibonacci numbers, hence the name. One property of the Golden Ratio is that you can use it to subdivide any range roughly evenly without ever looping back to the starting position. What do I mean by subdividing? For example if you want to divide a circle into 8 sections, you can just make each step around the circle be an angle of ![360^\circ/8](https://s0.wp.com/latex.php?latex=360%5E%5Ccirc%2F8&bg=fff&fg=444444&s=0&c=20201002) degrees. And after eight steps you’ll be back at the start. And for any ![n](https://s0.wp.com/latex.php?latex=n&bg=fff&fg=444444&s=0&c=20201002) number of steps you want to take, you can just change the angle to be ![360^\circ/n](https://s0.wp.com/latex.php?latex=360%5E%5Ccirc%2Fn&bg=fff&fg=444444&s=0&c=20201002). But what if you don’t know ahead of time how many steps you’re going to take? What if the ![n](https://s0.wp.com/latex.php?latex=n&bg=fff&fg=444444&s=0&c=20201002) value is determined by something you don’t control? Like maybe you have a picture of a flower, and you want to implement “every time the user clicks the mouse, add a petal to the flower.” In that case you want to use the golden ratio: Make the angle from one petal to the next ![360^\circ/\phi](https://s0.wp.com/latex.php?latex=360%5E%5Ccirc%2F%5Cphi&bg=fff&fg=444444&s=0&c=20201002) and you can loop around the circle forever, adding petals, and the next petal will always fit neatly into the biggest gap and you’ll never loop back to your starting position. Vi Hart has a good video about the topic:



(The video is part two of a three-part series, part one is [here](https://www.youtube.com/watch?v=ahXIMUkSXX0))

I knew about that trick because it’s useful in procedural content generation: Any time that you want something to look randomly distributed, but you want to be sure that there are no clusters, you should at least try to see if you can use the golden ratio for that. (if that doesn’t work, Halton Sequences are also worth trying before you try random numbers) But somehow it had never occurred to me to use the same trick for hash tables.

So here’s the idea: Let’s say our hash table is 1024 slots large, and we want to map an arbitrarily large hash value into that range. The first thing we do is we map it using the above trick into the full 64 bit range of numbers. So we multiply the incoming hash value with ![2^{64}/\phi \approx 11400714819323198485](https://s0.wp.com/latex.php?latex=2%5E%7B64%7D%2F%5Cphi+%5Capprox+11400714819323198485&bg=fff&fg=444444&s=0&c=20201002). (the number 11400714819323198486 is closer but we don’t want multiples of two because that would throw away one bit) Multiplying with that number will overflow, but just as we wrapped around the circle in the flower example above, this will wrap around the whole 64 bit range in a nice pattern, giving us an even distribution across the whole range from ![0](https://s0.wp.com/latex.php?latex=0&bg=fff&fg=444444&s=0&c=20201002) to ![2^{64}](https://s0.wp.com/latex.php?latex=2%5E%7B64%7D&bg=fff&fg=444444&s=0&c=20201002). To illustrate, let’s just look at the upper three bits. So we’ll do this:

```
size_t fibonacci_hash_3_bits(size_t hash)
{
    return (hash * 11400714819323198485llu) >> 61;
}
```

This will return the upper three bits after doing the multiplication with the magic constant. And we’re looking at just three bits because it’s easy to see how the golden ratio wraparound behaves when we just look at the top three bits. If we pass in some small numbers for the hash value, we get the following results from this:

fibonacci_hash_3_bits(0) == 0
fibonacci_hash_3_bits(1) == 4
fibonacci_hash_3_bits(2) == 1
fibonacci_hash_3_bits(3) == 6
fibonacci_hash_3_bits(4) == 3
fibonacci_hash_3_bits(5) == 0
fibonacci_hash_3_bits(6) == 5
fibonacci_hash_3_bits(7) == 2
fibonacci_hash_3_bits(8) == 7
fibonacci_hash_3_bits(9) == 4
fibonacci_hash_3_bits(10) == 1
fibonacci_hash_3_bits(11) == 6
fibonacci_hash_3_bits(12) == 3
fibonacci_hash_3_bits(13) == 0
fibonacci_hash_3_bits(14) == 5
fibonacci_hash_3_bits(15) == 2
fibonacci_hash_3_bits(16) == 7

This gives a pretty even distribution: The number 0 comes up three times, all other numbers come up twice. And every number is far removed from the previous and the next number. If we increase the input by one, the output jumps around quite a bit. So this is starting to look like a good hash function. And also a good way to map a number from a larger range into the range from 0 to 7.

In fact we already have the whole algorithm right here. All we have to do to get an arbitrary power of two range is to change the shift amount. So if my hash table is size 1024, then instead of just looking at the top 3 bits I want to look at the top 10 bits. So I shift by 54 instead of 61. Easy enough.

Now if you actually run a full hash function analysis on this, you find that it doesn’t make for a great hash function. It’s not terrible, but you will quickly find patterns. But if we make a hash table with a STL-style interface, we don’t control the hash function anyway. The hash function is being provided by the user. So we will just use Fibonacci hashing to map the result of the hash function into the range that we want.

### The problems with integer modulo

So why is integer modulo bad anyways? Two reasons: 1. It’s slow. 2. It can be real stupid about patterns in the input data. So first of all how slow is integer modulo? If you’re just doing the straightforward implementation like this:

```
size_t hash_to_slot(size_t hash, size_t num_slots)
{
    return hash % num_slots;
}
```

Then this is real slow. It takes roughly 9 nanoseconds on my machine. Which, if the hash table is in cache, is about five times longer than the rest of the lookup takes. If you get cache misses then those dominate, but it’s not good that this integer modulo is making our lookups several times slower when the table is in cache. Still the GCC, LLVM and boost implementations of unordered_map use this code to map the hash value to a slot in the table. And they are really slow because of this. The Dinkumware implementation is a little bit smarter: It takes advantage of the fact that when the table is sized to be a power of two, you can do an integer modulo by using a binary and:

```
size_t hash_to_slot(size_t hash, size_t num_slots_minus_one)
{
    return hash & num_slots_minus_one;
}
```

Which takes roughly 0 nanoseconds on my machine. Since num_slots is a power of two, this just chops off all the upper bits and only keeps the lower bits. So in order to use this you have to be certain that all the important information is in the lower bits. Dinkumware ensures this by using a more complicated hash function than the other implementations use: For integers it uses a FNV1 hash. It’s much faster than a integer modulo, but it still makes your hash table twice as slow as it could be since FNV1 is expensive. And there is a bigger problem: If you provide your own hash function because you want to insert a custom type into the hash table, you have to know about this implementation detail.

We have been bitten by that implementation detail several times at work. For example we had a custom ID type that’s just a wrapper around a 64 bit integer which is composed from several sources of information. And it just so happens that that ID type has really important information in the upper bits. It took surprisingly long until someone noticed that we had a slow hash table in our codebase that could literally be made a hundred times faster just by changing the order of the bits in the hash function, because the integer modulo was chopping off the upper bits.

Other tables, like google::dense_hash_map also use a power of two hash size to get the fast integer modulo, but it doesn’t provide it’s own implementation of std::hash<int> (because it can’t) so you have to be real careful about your upper bits when using dense_hash_map.

Talking about google::dense_hash_map, integer modulo brings even more problems with it for open addressing tables it. Because if you store all your data in one array, patterns in the input data suddenly start to matter more. For example google::dense_hash_map gets really, really slow if you ever insert a lot of sequential numbers. Because all those sequential numbers get assigned slots right next to each other, and if you’re then trying to look up a key that’s not in the table, you have to probe through a lot of densely occupied slots before you find your first empty slot. You will never notice this if you only look up keys that are actually in the map, but unsuccessful lookups can be dozens of times slower than they should be.

Despite these flaws, all of the fastest hash table implementations use the “binary and” approach to assign a hash value to a slot. And then you usually try to compensate for the problems by using a more complicated hash function, like FNV1 in the Dinkumware implementation.

### Why Fibonacci Hashing is the Solution

Fibonacci hashing solves both of these problems. 1. It’s really fast. It’s a integer multiplication followed by a shift. It takes roughly 1.5 nanoseconds on my machine, which is fast enough that it’s getting real hard to measure. 2. It mixes up input patterns. It’s like you’re getting a second hashing step for free after the first hash function finishes. If the first hash function is actually just the identity function (as it should be for integers) then this gives you at least a little bit of mixing that you wouldn’t otherwise get.

But really it’s better because it’s faster. When I worked on hash tables I was always frustrated by how much time we are spending on the simple problem of “map a large number to a small number.” It’s literally the slowest operation in the hash table. (outside of cache misses of course, but let’s pretend you’re doing several lookups in a row and the table is cached) And the only alternative was the “power of two binary and” version which discards bits from the hash function and can lead to all kinds of problems. So your options are either slow and safe, or fast and losing bits and getting potentially many hash collisions if you’re ever not careful. And everybody had this problem. I googled a lot for this problem thinking “surely somebody must have a good method for bringing a large number into a small range” but everybody was either doing slow or bad things. For example [here](https://github.com/lemire/fastrange) is an approach (called “fastrange”) that almost re-invents Fibonacci hashing, but it exaggerates patterns where Fibonacci hashing breaks up patterns. It’s the same speed as Fibonacci hashing, but when I’ve tried to use it, it never worked for me because I would suddenly find patterns in my hash function that I wasn’t even aware of. (and with fastrange your subtle patterns suddenly get exaggerated to be huge problems) Despite its problems it is being used in Tensorflow, because everybody is desperate for a faster solution of this the problem of mapping a large number into a small range.

### If Fibonacci Hashing is so great, why is nobody using it?

That’s a tricky question because there is so little information about Fibonacci hashing on the Internet, but I think it has to do with a historical misunderstanding. In The Art of Computer Programming, Knuth introduces three hash functions to use for hash tables:

1. Integer Modulo
2. Fibonacci Hashing
3. Something related to CRC hashes

The inclusion of the integer modulo in this list is a bit weird from today’s perspective because it’s not much of a hash function. It just maps from a larger range into a smaller range, and doesn’t otherwise do anything. Fibonacci hashing is actually a hash function, not the greatest hash function, but it’s a good introduction. And the third one is too complicated for me to understand. It’s something about coming up with good coefficients for a CRC hash that has certain properties about avoiding collisions in hash tables. Probably very clever, but somebody else has to figure that one out.

So what’s happening here is that Knuth uses the term “hash function” differently than we use it today. Today the steps in a hash table are something like this:

1. Hash the key
2. Map the hash value to a slot
3. Compare the item in the slot
4. If it’s not the right item, repeat step 3 with a different item until the right one is found or some end condition is met

We use the term “hash function” to refer to step 1. But Knuth uses the term “hash function” to refer to something that does both step 1 and step 2. So when he refers to a hash function, he means something that both hashes the incoming key, and assigns it to a slot in the table. So if the table is only 1024 items large, the hash function can only return a value from 0 to 1023. This explains why “integer modulo” is a hash function for Knuth: It doesn’t do anything in step 1, but it does work well for step 2. So if those two steps were just one step, then integer modulo does a good job at that one step since it does a good job at our step 2. But when we take it apart like that, we’ll see that Fibonacci Hashing is an improvement compared to integer modulo in both steps. And since we’re only using it for step 2, it allows us to use a faster implementation for step 1 because the hash function gets some help from the additional mixing that Fibonacci hashing does.

But this difference in terms, where Knuth uses “hash function” to mean something different than “hash function” means for std::unordered_map, explains to me why nobody is using Fibonacci hashing. When judged as a “hash function” in today’s terms, it’s not that great.

After I found that Fibonacci hashing is not mentioned anywhere, I did more googling and was more successful searching for “multiplicative hashing.” Fibonacci hashing is just a simple multiplicative hash with a well-chosen magic number. But the language that I found describing multiplicative hashing explains why nobody is using this. For example Wikipedia has [this](https://en.wikipedia.org/wiki/Hash_function#Multiplicative_hashing) to say about multiplicative hashing:

> Multiplicative hashing is a simple type of hash function often used by teachers introducing students to hash tables. Multiplicative hash functions are simple and fast, but have higher collision rates in hash tables than more sophisticated hash functions.

So just from that, I certainly don’t feel encouraged to check out what this “multiplicative hashing” is. Or to get a feeling for how teachers introduce this, [here](https://www.youtube.com/watch?v=0M_kIqhwbFo) is MIT instructor Erik Demaine (who’s videos I very much recommend) introducing hash functions, and he says this:

> I’m going to give you three hash functions. Two of which are, let’s say common practice, and the third of which is actually theoretically good. So the first two are not good theoretically, you can prove that they’re bad, but at least they give you some flavor.

Then he talks about integer modulo, multiplicative hashing, and a combination of the two. He doesn’t mention the Fibonacci hashing version of multiplicative hashing, and the introduction probably wouldn’t inspire people to go seek out more information it.

So I think people just learn that multiplicative hashing is not a good hash function, and they never learn that multiplicative hashing is a great way to map large values into a small range.

Of course it could also be that I missed some unknown big downside to Fibonacci hashing and that there is a real good reason why nobody is using this, but I didn’t find anything like that. But it could be that I didn’t find anything bad about Fibonacci hashing simply because it’s hard to find anything at all about Fibonacci hashing, so let’s do our own analysis:

### Analyzing Fibonacci Hashing

So I have to confess that I don’t know much about analyzing hash functions. It seems like the best test is to see how close a hash function gets to the [strict avalanche criterion](https://en.wikipedia.org/wiki/Avalanche_effect) which “is satisfied if, whenever a single input bit is changed, each of the output bits changes with a 50% probability.”

To measure that I wrote a small program that takes a hash ![H](https://s0.wp.com/latex.php?latex=H&bg=fff&fg=444444&s=0&c=20201002), and runs it through Fibonacci hashing to get a slot in the hash table ![S](https://s0.wp.com/latex.php?latex=S&bg=fff&fg=444444&s=0&c=20201002). Then I change a single bit in ![H](https://s0.wp.com/latex.php?latex=H&bg=fff&fg=444444&s=0&c=20201002), giving me ![H'](https://s0.wp.com/latex.php?latex=H%27&bg=fff&fg=444444&s=0&c=20201002), and after I run that through Fibonacci hashing I get a slot ![S'](https://s0.wp.com/latex.php?latex=S%27&bg=fff&fg=444444&s=0&c=20201002). Then I measure depending on which bit I changed in ![H'](https://s0.wp.com/latex.php?latex=H%27&bg=fff&fg=444444&s=0&c=20201002), which bits are likely to change in ![S'](https://s0.wp.com/latex.php?latex=S%27&bg=fff&fg=444444&s=0&c=20201002) compared to ![S](https://s0.wp.com/latex.php?latex=S&bg=fff&fg=444444&s=0&c=20201002) and which bits are unlikely to change.

I then run that same test every time after I doubled a hash table, because with different size hash tables there are more bits in the output: If the hash table only has four slots, there are only two bits in the output. If the hash table has 1024 slots, there are ten bits in the output. Finally I color code the result and plot the whole thing as a picture that looks like this:

![Avalanche_fibonacci.png](https://probablydance.files.wordpress.com/2018/06/avalanche_fibonacci1.png?w=650)

Let me explain this picture. Each row of pixels represents one of the 64 bits of the input hash. The bottom-most row is the first bit, the topmost row is the 64th bit. Each column represents one bit in the output. The first two columns are the output bits for a table of size 4, the next three columns are the output bits for a table of size 8 etc. until the last 23 bits are for a table of size eight million. The color coding means this:

- A black pixel indicates that when the input pixel for that row changes, the output pixel for that column has a 50% chance of changing. (this is ideal)
- A blue pixel means that when the input pixel changes, the ouput pixel has a 100% chance of changing.
- A red pixel means that when the input pixel changes, the output pixel has a 0% chance of changing.

For a really good hash function the entire picture would be black. So Fibonacci hashing is not a really good hash function.

The worst pattern we can see is at the top of the picture: The last bit of the input hash (the top row in the picture) can always only affect the last bit of the output slot in the table. (the last column of each section) So if the table has 1024 slots, the last bit of the input hash can only determine the bit in the output slot for the number 512. It will never change any other bit in the output. Lower bits in the input can affect more bits in the output, so there is more mixing going on for those.

Is it bad that the last bit in the input can only affect one bit in the output? It would be bad if we used this as a hash function, but it’s not necessarily bad if we just use this to map from a large range into a small range. Since each row has at least one blue or black pixel in it, we can be certain that we don’t lose information, since every bit from the input will be used. What would be bad for mapping from a large range into a small range is if we had a row or a column that has only red pixels in it.

Let’s also look at what this would look like for integer modulo, starting with integer modulo using prime numbers:

![Avalanche_prime.png](https://probablydance.files.wordpress.com/2018/06/avalanche_prime1.png?w=650)

This one has more randomness at the top, but a clearer pattern at the bottom. All that red means that the first few bits in the input hash can only determine the first few bits in the output hash. Which makes sense for integer modulo. A small number modulo a large number will never result in a large number, so a change to a small number can never affect the later bits.

This picture is still “good” for mapping from a large range into a small range because we have that diagonal line of bright blue pixels in each block. To show a bad function, here is integer modulo with a power of two size:

![Avalanche_power_of_two.png](https://probablydance.files.wordpress.com/2018/06/avalanche_power_of_two1.png?w=650)

This one is obviously bad: The upper bits of the hash value have completely red rows, because they will simply get chopped off. Only the lower bits of the input have any effect, and they can only affect their own bits in the output. This picture right here shows why using a power of two size requires that you are careful with your choice of hash function for the hash table: If those red rows represent important bits, you will simply lose them.

Finally let’s also look at the “fastrange” algorithm that I briefly mentioned above. For power of two sizes it looks really bad, so let me show you what it looks like for prime sizes:

![Avalanche_fastrange_prime.png](https://probablydance.files.wordpress.com/2018/06/avalanche_fastrange_prime.png?w=650)

What we see here is that fastrange throws away the lower bits of the input range. It only uses the upper bits. I had used it before and I had noticed that a change in the lower bits doesn’t seem to make much of a difference, but I had never realized that it just completely throws the lower bits away. This picture totally explains why I had so many problems with fastrange. Fastrange is a bad function to map from a large range into a small range because it’s throwing away the lower bits.

Going back to Fibonacci hashing, there is actually one simple change you can make to improve the bad pattern for the top bits: Shift the top bits down and xor them once. So the code changes to this:

```
size_t index_for_hash(size_t hash)
{
    hash ^= hash >> shift_amount;
    return (11400714819323198485llu * hash) >> shift_amount;
}
```

It’s almost looking more like a proper hash function, isn’t it? This makes the function two cycles slower, but it gives us the following picture:

![Avalanche_fibxor](https://probablydance.files.wordpress.com/2018/06/avalanche_fibxor.png?w=650)

This looks a bit nicer, with the problematic pattern at the top gone. (and we’re seeing more black pixels now which is the ideal for a hash function) I’m not using this though because we don’t really need a good hash function, we need a good function to map from a large range into a small range. And this is on the critical path for the hash table, before we can even do the first comparison. Any cycle added here makes the whole line in the graph above move up.

So I keep on saying that we need a good function to map from a large range into a small range, but I haven’t defined what “good” means there. I don’t know of a proper test like the avalanche analysis for hash functions, but my first attempt at a definition for “good” would be that every value in the smaller range is equally likely to occur. That test is very easy to fulfill though: all of the methods (including fastrange) fulfill that criteria. So how about we pick a sequence of values in the input range and check if every value in the output is equally likely. I had given the examples for numbers 0 to 16 above. We could also do multiples of 8 or all powers of two or all prime numbers or the Fibonacci numbers. Or let’s just try as many sequences as possible until we figure out the behavior of the function.

Looking at the above list we see that there might be a problematic pattern with multiples of 4: fibonacci_hash_3_bits(4) returned 3, for fibonacci_hash_3_bits(8) returned 7, fibonacci_hash_3_bits(12) returned 3 again and fibonacci_hash_3_bits(16) returned 7 again. Let’s see how this develops if we print the first sixteen multiples of four:

Here are the results:

0 -> 0
4 -> 3
8 -> 7
12 -> 3
16 -> 7
20 -> 2
24 -> 6
28 -> 2
32 -> 6
36 -> 1
40 -> 5
44 -> 1
48 -> 5
52 -> 1
56 -> 4
60 -> 0
64 -> 4

Doesn’t look too bad actually: Every number shows up twice, except the number 1 shows up three times. What about multiples of eight?

0 -> 0
8 -> 7
16 -> 7
24 -> 6
32 -> 6
40 -> 5
48 -> 5
56 -> 4
64 -> 4
72 -> 3
80 -> 3
88 -> 3
96 -> 2
104 -> 2
112 -> 1
120 -> 1
128 -> 0

Once again doesn’t look too bad, but we are definitely getting more repeated numbers. So how about multiples of sixteen?

0 -> 0
16 -> 7
32 -> 6
48 -> 5
64 -> 4
80 -> 3
96 -> 2
112 -> 1
128 -> 0
144 -> 7
160 -> 7
176 -> 6
192 -> 5
208 -> 4
224 -> 3
240 -> 2
256 -> 1

This looks a bit better again, and if we were to look at multiples of 32 it would look better still. The reason why the number 8 was starting to look problematic was not because it’s a power of two. It was starting to look problematic because it is a Fibonacci number. If we look at later Fibonacci numbers, we see more problematic patterns. For example here are multiples of 34:

0 -> 0
34 -> 0
68 -> 0
102 -> 0
136 -> 0
170 -> 0
204 -> 0
238 -> 0
272 -> 0
306 -> 0
340 -> 1
374 -> 1
408 -> 1
442 -> 1
476 -> 1
510 -> 1
544 -> 1

That’s looking bad. And later Fibonacci numbers will only look worse. But then again how often are you going to insert multiples of 34 into a hash table? In fact if you had to pick a group of numbers that’s going to give you problems, the Fibonacci numbers are not the worst choice because they don’t come up that often naturally. As a reminder, here are the first couple Fibonacci numbers: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584… The first couple numbers don’t give us bad patterns in the output, but anything bigger than 13 does. And most of those are pretty harmless: I can’t think of any case that would give out multiples of those numbers. 144 bothers me a little bit because it’s a multiple of 8 and you might have a struct of that size, but even then your pointers will just be eight byte aligned, so you’d have to get unlucky for all your pointers to be multiples of 144.

But really what you do here is that you identify the bad pattern and you tell your users “if you ever hit this bad pattern, provide a custom hash function to the hash table that fixes it.” I mean people are happy to use integer modulo with powers of two, and for that it’s ridiculously easy to find bad patterns: Normal pointers are a bad pattern for that. Since it’s harder to come up with use cases that spit out lots of multiples of Fibonacci numbers, I’m fine with having “multiples of Fibonacci numbers” as bad patterns.

So why are Fibonacci numbers a bad pattern for Fibonacci hashing anyways? It’s not obvious if we just have the magic number multiplication and the bit shift. First of all we have to remember that the magic constant came from dividing by the golden ratio: ![2^{64}/\phi \approx 11400714819323198485](https://s0.wp.com/latex.php?latex=2%5E%7B64%7D%2F%5Cphi+%5Capprox+11400714819323198485&bg=fff&fg=444444&s=0&c=20201002). And then since we are truncating the result of the multiplication before we shift it, there is actually a hidden modulo by ![2^{64}](https://s0.wp.com/latex.php?latex=2%5E%7B64%7D&bg=fff&fg=444444&s=0&c=20201002) in there. So whenever we are hashing a number ![x](https://s0.wp.com/latex.php?latex=x&bg=fff&fg=444444&s=0&c=20201002) the slot is actually determined by this:

![slot\_before\_shift(x) = (x * 2^{64}/\phi) \% 2^{64}](https://s0.wp.com/latex.php?latex=slot%5C_before%5C_shift%28x%29+%3D+%28x+%2A+2%5E%7B64%7D%2F%5Cphi%29+%5C%25+2%5E%7B64%7D&bg=fff&fg=444444&s=0&c=20201002)

I’m leaving out the shift at the end because that part doesn’t matter for figuring out why Fibonacci numbers are giving us problems. In the example of stepping around a circle (from the Vi Hart video above) the equation would look like this:

![angle\_for\_leaf(x) = (x * 360/\phi) \% 360](https://s0.wp.com/latex.php?latex=angle%5C_for%5C_leaf%28x%29+%3D+%28x+%2A+360%2F%5Cphi%29+%5C%25+360&bg=fff&fg=444444&s=0&c=20201002)

This would give us an angle from 0 to 360. These functions are obviously similar. We just replaced ![2^{64}](https://s0.wp.com/latex.php?latex=2%5E%7B64%7D&bg=fff&fg=444444&s=0&c=20201002) with ![360](https://s0.wp.com/latex.php?latex=360&bg=fff&fg=444444&s=0&c=20201002). So while we’re in math-land with infinite precision, we might as well make the function return something in the range from 0 to 1, and then multiply the constant in afterwards:

![hash\_0\_to\_1(x) = frac(x/\phi)](https://s0.wp.com/latex.php?latex=hash%5C_0%5C_to%5C_1%28x%29+%3D+frac%28x%2F%5Cphi%29&bg=fff&fg=444444&s=0&c=20201002)

Where ![frax(x)](https://s0.wp.com/latex.php?latex=frax%28x%29&bg=fff&fg=444444&s=0&c=20201002) returns the fractional part of a number. So ![frax(1.1) = 0.1](https://s0.wp.com/latex.php?latex=frax%281.1%29+%3D+0.1&bg=fff&fg=444444&s=0&c=20201002). In this last formulation it’s easy to find out why Fibonacci numbers give us problems. Let’s try putting in a few Fibonacci numbers:

![hash\_0\_to\_1(144) = frac(144/\phi) \approx frac(89) = 0](https://s0.wp.com/latex.php?latex=hash%5C_0%5C_to%5C_1%28144%29+%3D+frac%28144%2F%5Cphi%29+%5Capprox+frac%2889%29+%3D+0&bg=fff&fg=444444&s=0&c=20201002)
![hash\_0\_to\_1(1587) = frac(1597/\phi) \approx frac(987) = 0](https://s0.wp.com/latex.php?latex=hash%5C_0%5C_to%5C_1%281587%29+%3D+frac%281597%2F%5Cphi%29+%5Capprox+frac%28987%29+%3D+0&bg=fff&fg=444444&s=0&c=20201002)
![hash\_0\_to\_1(8) = frac(8/\phi) \approx frac(4.94) = 0.94](https://s0.wp.com/latex.php?latex=hash%5C_0%5C_to%5C_1%288%29+%3D+frac%288%2F%5Cphi%29+%5Capprox+frac%284.94%29+%3D+0.94&bg=fff&fg=444444&s=0&c=20201002)

What we see here is that if we divide a Fibonacci number by the golden ratio, we just get the previous Fibonacci number. There is no fractional part so we always end up with 0. So even if we multiply the full range of ![2^{64}](https://s0.wp.com/latex.php?latex=2%5E%7B64%7D&bg=fff&fg=444444&s=0&c=20201002) back in, we still get 0. But for smaller Fibonacci numbers there is some imprecision because the Fibonacci sequence is just an integer approximation of golden ratio growth. That approximation gets more exact the further along we get into the sequence, but for the number 8 it’s not that exact. That’s why 8 was not a problem, 34 started to look problematic, and 144 is going to be real bad.

Except that when we talk about badness, we also have to consider the size of the hash table. It’s really easy to find bad patterns when the table only has eight slots. If the table is bigger and has, say 64 slots, suddenly multiples of 34 don’t look as bad:

0 -> 0
34 -> 0
68 -> 1
102 -> 2
136 -> 3
170 -> 4
204 -> 5
238 -> 5
272 -> 6
306 -> 7
340 -> 8
374 -> 9
408 -> 10
442 -> 10
476 -> 11
510 -> 12
544 -> 13

And if the table has 1024 slots we get all the multiples nicely spread out:

0 -> 0
34 -> 13
68 -> 26
102 -> 40
136 -> 53
170 -> 67
204 -> 80
238 -> 94
272 -> 107
306 -> 121
340 -> 134
374 -> 148
408 -> 161
442 -> 175
476 -> 188
510 -> 202
544 -> 215

At size 1024 even the multiples of 144 don’t look scary any more because they’re starting to be spread out now:

0 -> 0
144 -> 1020
288 -> 1017
432 -> 1014
576 -> 1011
720 -> 1008
864 -> 1004
1008 -> 1001
1152 -> 998

So the bad pattern of multiples of Fibonacci numbers goes away with bigger hash tables. Because Fibonacci hashing spreads out the numbers, and the bigger the table is, the better it gets at that. This doesn’t help you if your hash table is small, or if you need to insert multiples of a larger Fibonacci number, but it does give me confidence that this “bad pattern” is something we can live with.

So I am OK with living with the bad pattern of Fibonacci hashing. It’s less bad than making the hash table a power of two size. It can be slightly more bad than using prime number sizes, as long as your prime numbers are well chosen. But I still think that on average Fibonacci hashing is better than prime number sized integer modulo, because Fibonacci hashing mixes up sequential numbers. So it fixes a real problem I have run into in the past while introducing a theoretical problem that I am struggling to find real examples for. I think that’s a good trade.

Also prime number integer modulo can have problems if you choose bad prime numbers. For example boost::unordered_map can choose size 196613, which is 0b110000000000000101 in binary, which is a pretty round number in the same way that 15000005 is a pretty round number in decimal. Since this prime number is “too round of a number” this causes lots of hash collisions in one of my benchmarks, and I didn’t set that benchmark up to find bad cases like this. It was totally accidental and took lots of debugging to figure out why boost::unordered_map does so badly in that benchmark. (the benchmark in question was set up to find problems with sequential numbers) But I won’t go into that and will just say that while prime numbers give fewer problematic patterns than Fibonacci hashing, you still have to choose them well to avoid introducing hash collisions.

### Conclusion

Fibonacci hashing may not be the best hash function, but I think it’s the best way to map from a large range of numbers into a small range of numbers. And we are only using it for that. When used only for that part of the hash table, we have to compare it against two existing approaches: Integer modulo with prime numbers and Integer modulo with power of two sizes. It’s almost as fast as the power of two size, but it introduces far fewer problems because it doesn’t discard any bits. It’s much faster than the prime number size, and it also gives us the bonus of breaking up sequential numbers, which can be a big benefit for open addressing hash tables. It does introduce a new problem of having problems with multiples of large Fibonacci numbers in small hash tables, but I think those problems can be solved by using a custom hash function when you encounter them. Experience will tell how often we will have to use this.

All of my hash tables now use Fibonacci hashing by default. For my flat_hash_map the property of breaking up sequential numbers is particularly important because I have had real problems caused by sequential numbers. For the others it’s just a faster default. It might almost make the option to use the power of two integer modulo unnecessary.

It’s surprising that the world forgot about this optimization and that we’re all using primer number sized hash tables instead. (or use Dinkumware’s solution which uses a power of two integer modulo, but spends more time on the hash function to make up for the problems of the power of two integer modulo) Thanks to Rich Geldreich for writing a hash table that uses this optimization and for mentioning it in my comments. But this is an interesting example because academia had a solution to a real problem in existing hash tables, but professors didn’t realize that they did. The most likely reason for that is that it’s not well known how big the problem of “mapping a large number into a small range” is and how much time it takes to do an integer modulo.

For future work it might be worth looking into Knuth’s third hash function: The one that’s related to CRC hashes. It seems to be a way to construct a good CRC hash function if you need a n-bit output for a hash table. But it was too complicated for me to look into, so I’ll leave that as an exercise to the reader to find out if that one is worth using.

Finally [here](https://github.com/skarupke/flat_hash_map/blob/master/unordered_map.hpp) is the link to my implementation of unordered_map. My other two hash tables are also there: flat_hash_map has very fast lookups and bytell_hash_map is also very fast but was designed more to save memory compared to flat_hash_map.