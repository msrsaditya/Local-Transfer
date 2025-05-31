# Local-Transfer
The fastest way to transfer files over a local network. Speeds are rate limited by physics and common sense.

## Usage

### Receiver
```bash
bash get.sh "/path/to/folder"
```

For example
```bash
bash get.sh "~/storage/shared/Download/"
```

### Sender
```bash
bash send.sh "/path/to/file[OR]folder/" <IP_ADDRESS>
```

For example
```bash
bash send.sh "~/Documents/file.pdf" 192.168.29.14
```

- To share files to and from your smartphone, install and set up Termux with these scripts.
- TIP: Use your smartphone hotspot while running the script as routers are usually slow.

# Benchmarks

- We can consistently get >103 MBps under "ideal" conditions with these scripts on a gigabit network.
- This is >95% of iPerf3 speeds (106-108 MBps) on the same device under the same conditions.
- This is >90% of modern ethernet speeds (110-115 MBps).
- This is >82% of the theoretical maximum speeds (125 MBps) of the gigabit network itself.

- The 5% overhead compared to iPerf3 is the unavoidable overhead from TCP and other tools, such as tar, pv, and bash.
- This is as good as it can get. We're testing the limits of physics here.
- Fun question: Why use ethernet? You're getting 90% of ethernet speeds wirelessly. Ethernet is for losers :p

# Tradeoffs

- Many features have been intentionally removed to reduce the overhead of the file transfer as much as possible.
- The code itself is very optimized and lean.
- Time and space complexity analysis tells us that everything is O(1) except for network and disk which are unavoidably O(n).
- Removed/Avoided features:

1. Authentication & Authorization
2. Encryption
3. Pause/Resume
4. Partial file handling
5. Temp file creation
6. Compression
7. Checksum verification
8. Extensive error handling
9. Config files
10. Logging

and many many more.

- Only use this if you are ready to accept these tradeoffs.

# Micro-optimizations

- The goal is not just to build a highly optimized solution, it's to build the simplest possible highly optimized solution.
- What is the simplest solution one can create that can maximize speed/performance/throughput/latency as much as possible? This is what we're aiming for.
- We can always add a niche platform-specific CPU optimization that's going to save us 0.0000002 ms in latency but drastically reduce the readability, maintainability, and simplicity of our scripts.
- For context, if we transfer a 100 GB file (a file so big that most people won't transfer usually), then it would take 
16.57 minutes with 103 MBps (our script) compared to 13.65 minutes with 125 MBps (theoretical limit).
- This means we'll roughly save around ~3 minutes at max on a very massive file occasionally at best. Note that this much savings can never be achieved, because 125 MBps is impossible practically. It is the max that we can achieve, that's all (Not worth it IMHO).

# Workflow
![](Diagram.svg)
