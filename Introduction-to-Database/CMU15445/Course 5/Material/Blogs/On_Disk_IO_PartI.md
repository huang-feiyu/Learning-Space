If you like this story, check out my [upcoming book on Database Internals](https://www.databass.dev/)!

Series consist of 5 pieces:

- [Flavors of IO](https://medium.com/@ifesdjeen/on-disk-io-part-1-flavours-of-io-8e1ace1de017): Page Cache, Standard IO, O_DIRECT
- [More Flavors of IO](https://medium.com/@ifesdjeen/on-disk-io-part-2-more-flavours-of-io-c945db3edb13): mmap, fadvise, AIO
- [LSM Trees](https://medium.com/@ifesdjeen/on-disk-io-part-3-lsm-trees-8b2da218496f)
- [Access Patterns in LSM Trees](https://medium.com/@ifesdjeen/on-disk-io-access-patterns-in-lsm-trees-2ba8dffc05f9)
- [B-Trees and RUM Conjecture](https://medium.com/@ifesdjeen/on-disk-storage-part-4-b-trees-30791060741)

New series on [Distributed System concepts in Databases](https://medium.com/databasss/on-ways-to-agree-part-1-links-and-flp-impossibility-f6bd8a6a0980) can be found here.

Knowing how IO works and understanding use-cases and trade-offs of algorithms and storage systems can make lives of developers and operators much better: they will be able to make better choices upfront (based on what’s under the hood of the database they’re evaluating), troubleshoot performance issues when database misbehaves (by comparing their workloads to the ones the database of their choice is intended to be used for) and tune their stack (by balancing load, switching to a different medium, file system, operating system, or picking a different index type).

![img](https://miro.medium.com/max/60/1*KgIeSAawkjFDCiT9AxrVJg.jpeg?q=20)

![img](https://miro.medium.com/max/4608/1*KgIeSAawkjFDCiT9AxrVJg.jpeg)

Flavours of IO, according to Wikipedia

While the Network IO is frequently discussed and talked about, Filesystem IO gets much less attention. Partly, the reason is that Network IO has many more features and implementation details, varying from one operating system to another, while Filesystem IO has a much smaller set of tools. Also, in modern systems people mostly use *databases* as storage means, so applications communicate with them through the drivers over the network and Filesystem IO is left for database developers to understand and take care of. I still believe it is important to understand how data is written on disk and read from it.

There are several “flavors” of IO (some functions omitted for brevity):

- Syscalls: [open](http://man7.org/linux/man-pages/man2/open.2.html), [write](http://man7.org/linux/man-pages/man2/write.2.html), [read](http://man7.org/linux/man-pages/man2/read.2.html), [fsync](http://man7.org/linux/man-pages/man2/fsync.2.html), [sync](http://man7.org/linux/man-pages/man2/sync.2.html), [close](http://man7.org/linux/man-pages/man2/close.2.html)
- Standard IO: [fopen](https://linux.die.net/man/3/fopen), [fwrite](https://linux.die.net/man/3/fwrite), [fread](https://linux.die.net/man/3/fread), [fflush](https://linux.die.net/man/3/fflush), [fclose](https://linux.die.net/man/3/fclose)
- Vectored IO: [writev](https://linux.die.net/man/2/writev), [readv](https://linux.die.net/man/2/readv)
- Memory mapped IO: [open](http://man7.org/linux/man-pages/man2/open.2.html), [mmap](http://man7.org/linux/man-pages/man2/mmap.2.html), [msync](http://man7.org/linux/man-pages/man2/msync.2.html), [munmap](http://man7.org/linux/man-pages/man2/munmap.2.html)

Let’s start by discussing Standard IO combined and some “userland” optimizations as this is the what application developers end up using the most.

## Buffered IO

There’s a bit of confusion in terms of “buffering” when talking about *stdio.h* functions. When using the Standard IO, it is possible to choose between [full and line buffering or opt out from any buffering whatsoever](https://linux.die.net/man/3/setvbuf). This [“user space” buffering](https://github.com/lattera/glibc/blob/master/libio/fileops.c#L1298-L1380) has nothing to do with Kernel buffering (Page Cache) which we will discuss later in this article. You can also think about as a distinction between “buffering” and “caching” which might draw a clear distinction between these concepts.

## Sector/Block/Page

*Block Device* is a special file type providing buffered access to hardware devices such as HDDs or SSDs. Block Devices work act upon *sectors,* group of adjacent bytes. Most disk devices have a sector size of 512 bytes. Sector is the smallest unit of data transfer for block device, it is not possible to transfer less than one sector worth of data. However, often it is possible to fetch multiple adjacent segments at a time. The smallest addressable unit of *File System* is *block.* Block is a group of multiple adjacent sectors requested by a device driver. Typical block sizes are 512, 1024, 2048 and 4096 bytes. Usually IO is done through the Virtual Memory, which caches requested filesystem blocks in memory and serves as a buffer for intermediate operations. Virtual Memory works with pages, which map to filesystem blocks. Typical page size is 4096 bytes.

In summary, Virtual Memory *pages* map to Filesystem *blocks*, which map to Block Device *sectors.*

# Standard IO

Standard IO uses *read()* and *write()* syscalls for performing IO operations. When reading the data, Page Cache is addressed first. If the data is absent, the *Page Fault* is triggered and contents are paged in. This means that reads, performed against the currently unmapped area will take longer, as caching layer is transparent to user.

During writes, buffer contents are first written to Page Cache. This means that data does not reach the disk right away. The actual hardware write is done when Kernel decides it’s time to perform a *writeback* of the *dirty page*.

![img](https://miro.medium.com/max/60/1*BIhWPv9P-ePgQX5Ien1AQA.png?q=20)

![img](https://miro.medium.com/max/1797/1*BIhWPv9P-ePgQX5Ien1AQA.png)

Standard IO takes a user space buffer and then copies it’s content to the page cache. When the O_DIRECT flag is used, the buffer is written directly to the block device.

## Page Cache

[*Page Cache*](https://github.com/torvalds/linux/blob/master/include/linux/buffer_head.h) stores the recently accessed fragments of files that are more likely to be accessed in the nearest time. When working with disk files, *read()* and *write()* calls do not initiate disk accesses directly and go through Page Cache instead.

![img](https://miro.medium.com/max/60/1*yl8Rdk17NtAtpYndh3XFQw.png?q=20)

![img](https://miro.medium.com/max/914/1*yl8Rdk17NtAtpYndh3XFQw.png)

How Buffered IO works: Applications perform reads and writes through the Kernel Page Cache, which allows sharing pages processes, serving reads from cache and throttling writes to reduce IO.

When the *read* operation is performed, the Page Cache is consulted first. If the data is already loaded in the Page Cache, it is simply copied out for the user: no disk access is performed and read is served entirely from memory. Otherwise file contents are loaded in Page Cache and then returned to the user. If Page Cache is full, least recently used pages are flushed on disk and evicted from cache to free space for new pages.

*write()* call simply copies user-space buffer to kernel Page Cache, marking the written page as *dirty*. Later, kernel writes modifications on disk in a process called *flush* or *writeback*. Actual IO normally does not happen immediately. Meanwhile, *read()* will supply data from the Page Cache instead of reading (now outdated) disk contents. As you can see, Page Cache is loaded both on reads and writes.

Pages marked *dirty* will be *flushed* to disk as since their cached representation is now different from the one on disk. This process is called *writeback*. writeback might have potential drawbacks, such as queuing up IO requests, so it’s worth understanding thresholds and ratios that used for writeback when it’s in use and check queue depths to make sure you can avoid throttling and high latencies. You can find more information on tuning Virtual Memory in [Linux Kernel Documentation](https://www.kernel.org/doc/Documentation/sysctl/vm.txt).

Logic behind Page Cache is explained by *Temporal locality* principle, that states that recently accessed pages will be accessed again at some point in nearest future.

Another principle, *Spatial Locality*, implies that the elements physically located nearby have a good chance of being located close to each other. This principle is used in a process called “prefetch” that loads file contents ahead of time anticipating their access and amortizing some of the IO costs.

Page Cache also improves IO performance by delaying writes and coalescing adjacent reads.

Disambiguation: Buffer Cache and Page Cache: previously entirely separate concepts, [got unified in 2.4 Linux kernel](https://lwn.net/Articles/712467/). Right now it’s mostly referred to as Page Cache, but some people people still use term Buffer Cache, which became synonymous.

Page Cache, depending on the access pattern, holds file chunks that were recently accessed or may be accessed soon (prefetched or marked with [fadvise](https://medium.com/@ifesdjeen/on-disk-io-part-2-more-flavours-of-io-c945db3edb13)). Since all IO operations are happening through Page Cache, operations sequences such as *read-write-read* can be served from memory, without subsequent disk accesses.

## Delaying Errors

When performing a write that’s backed by the kernel and/or a library buffer, it is important to make sure that the data actually reaches the disk, since it might be buffered or cached somewhere. The errors will appear when the data is flushed to disk, which can be while *fsync*ing or closing the file. If you would like to learn more about it, check out LWN article [Ensuring Data Reaches the Disk](https://lwn.net/Articles/457667/).

## Direct IO

There are situations when it’s undesirable to use the Kernel Page Cache to perform IO. In such cases, one can use [O_DIRECT](https://ext4.wiki.kernel.org/index.php/Clarifying_Direct_IO's_Semantics) flag when opening a file. It instructs the Operating Systems to bypass the *Page Cache*, avoid storing extra copy of data and perform IO operations directly against the block device. This means that buffers are flushed directly on disk, without copying their contents to the corresponding cached page first and waiting for the Kernel to trigger a writeback.

For a “traditional” application using Direct IO will most likely cause a performance degradation rather than the speedup, but in the right hands it can help to gain a fine-grained control over IO operations and improve performance. Usually applications using this type of IO implement their own application-specific caching layer.

![img](https://miro.medium.com/max/60/1*Zj8_whEZm_AEaBXBtqdiBw.png?q=20)

![img](https://miro.medium.com/max/887/1*Zj8_whEZm_AEaBXBtqdiBw.png)

How Direct IO works: Application bypasses the Page Cache, so the writes are made towards the hardware storage right away. This might result into performance degradation, since the Kernel buffers and caches the writes, sharing the cache contents between application. When used well, can result into major performance gains and improved memory usage.

Using Direct IO is often frowned upon by the Kernel developers. It goes so far, that Linux man page quotes Linus Torwalds: “[The thing that has always disturbed me about O_DIRECT is that the whole interface is just stupid](http://yarchive.net/comp/linux/o_direct.html)”.

However, databases such as [PostgreSQL](https://www.postgresql.org/message-id/529F7D58.1060301%40agliodbs.com) and [MySQL](https://dev.mysql.com/doc/refman/5.5/en/optimizing-innodb-diskio.html) use Direct IO for a reason. Developers can ensure fine-grained control over the data access , possibly using a custom IO Scheduler and an application-specific Buffer Cache. For example, PostgreSQL uses Direct IO for [WAL](https://www.postgresql.org/docs/9.5/static/runtime-config-wal.html) (write-ahead-log), since they have to perform writes as fast as possible while ensuring its durability and can use this optimization since they know for sure that the data won’t be immediately reused, so writing it bypassing Page Cache won’t cause performance degradation.

It is discouraged to open the same file with Direct IO and Page Cache simultaneously, since direct operations will be performed against disk device even if the data is in Page Cache, which may lead to undesired results.

## Block Alignment

Because Direct IO involves direct access to backing store, bypassing intermediate buffers in Page Cache, it is required that all operations are aligned to sector boundary.

![img](https://miro.medium.com/max/60/1*7MM3iNFLcQnUc9wZ8aISRw.png?q=20)

![img](https://miro.medium.com/max/1230/1*7MM3iNFLcQnUc9wZ8aISRw.png)

Examples of unaligned writes (highlighted). Left to right: the write neither starts, nor ends on the block boundary; the write starts on the block boundary, but the write size isn’t a multiple of the block size; the write doesn’t start on the block boundary.

In other words, every operation has to have a starting offset of a multiple of 512 and a buffer size has to be a multiple of 512 as well. When using Page Cache, because writes first go to memory, alignment is not important: when actual block device write is performed, Kernel will make sure to split the page into parts of the right size and perform aligned writes towards hardware.

![img](https://miro.medium.com/max/60/1*ZiSuwydbAZpuqcUW4puaHw.png?q=20)

![img](https://miro.medium.com/max/1230/1*ZiSuwydbAZpuqcUW4puaHw.png)

Examples of aligned writes (highlighted). Left to right: the write starts and ends on the block boundary and is exactly the size of the block; the write starts and ends on the block boundary and has a size that is a multiple of the block size.

For example, RocksDB is making sure that the operations are block-aligned [by checking it upfront](https://github.com/facebook/rocksdb/blob/master/env/io_posix.cc#L312-L316) (older versions were allowing unaligned access by aligning in the background).

Whether or not O_DIRECT flag is used, it is always a good idea to make sure your reads and writes are block aligned. Crossing segment boundary will cause multiple sectors to be loaded from (or written back on) disk as shown on images above. Using the block size or a value that fits neatly inside of a block guarantees block-aligned I/O requests, and prevents extraneous work inside the kernel.

## Nonblocking Filesystem IO

I’m adding this part here since I very often hear “nonblocking” in the context of Filesystem IO. It’s quite normal, since most of the programming interface for Network and Filesystem IO is the same. But it’s worth mentioning that there’s [no true “nonblocking” Filesystem IO](https://www.remlab.net/op/nonblock.shtml), which can be understood in the same sense.

O_NONBLOCK is generally ignored for regular files, because block device operations are considered non-blocking (unlike socket operations, for example). Filesystem IO delays are not taken into account by the system. Possibly this decision was made because there’s a more or less hard time bound on operation completion.

For same reason, something you would usually use in Network context, like *select* and *epoll*, does not allow monitoring and/or checking status of regular files.

## Closing Words

Today we’ve discussed Page Cache, Standard IO and usage of the O_DIRECT flag, an optimization often used by the database developers in order to gain control over the buffer caches that Standard IO delegates to the Kernel and discussed where it’s used, how it works, where it can be useful and what downsides it has.

The next post will be featuring [Memory Mapping, Vectored IO and Page Cache Optimisations](https://medium.com/@ifesdjeen/on-disk-io-part-2-more-flavours-of-io-c945db3edb13).s