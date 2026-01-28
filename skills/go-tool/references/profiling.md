# Go Profiling Guide

## Generating Profiles

### From Tests

```bash
# CPU profile
go test -cpuprofile=cpu.out -bench=. ./...

# Memory profile (allocations)
go test -memprofile=mem.out -bench=. ./...

# Block profile (goroutine blocking)
go test -blockprofile=block.out -bench=. ./...

# Mutex profile (mutex contention)
go test -mutexprofile=mutex.out -bench=. ./...

# Execution trace
go test -trace=trace.out -bench=. ./...

# All at once
go test -cpuprofile=cpu.out -memprofile=mem.out -bench=. ./...
```

### From Running Application

Add pprof HTTP endpoints:

```go
import (
    "net/http"
    _ "net/http/pprof"
)

func main() {
    // Expose pprof on separate port
    go func() {
        http.ListenAndServe("localhost:6060", nil)
    }()
    // ... rest of application
}
```

Then fetch profiles:
```bash
# CPU profile (30 second sample)
go tool pprof http://localhost:6060/debug/pprof/profile?seconds=30

# Heap profile
go tool pprof http://localhost:6060/debug/pprof/heap

# Goroutine profile
go tool pprof http://localhost:6060/debug/pprof/goroutine

# Block profile
go tool pprof http://localhost:6060/debug/pprof/block

# Mutex profile
go tool pprof http://localhost:6060/debug/pprof/mutex
```

## Analyzing with pprof

### Interactive CLI

```bash
go tool pprof cpu.out
```

**Common commands:**
```
(pprof) top              # Top functions by flat time
(pprof) top -cum         # Top by cumulative time
(pprof) top 20           # Show top 20
(pprof) list FuncName    # Show annotated source for function
(pprof) disasm FuncName  # Show disassembly
(pprof) web              # Open call graph in browser
(pprof) pdf              # Generate PDF report
(pprof) peek FuncName    # Show callers and callees
(pprof) tree             # Show call tree
```

### Web UI

```bash
go tool pprof -http=:8080 cpu.out
```

Opens browser with:
- Flame graph
- Call graph
- Source view
- Top functions

### Comparing Profiles

```bash
# Compare two profiles
go tool pprof -base=old.out new.out

# Show difference
(pprof) top
```

## Reading pprof Output

### CPU Profile

```
      flat  flat%   sum%        cum   cum%
    1.20s 30.00% 30.00%      2.50s 62.50%  main.processData
    0.80s 20.00% 50.00%      0.80s 20.00%  runtime.mallocgc
```

- **flat**: Time spent in this function (excluding callees)
- **cum**: Time spent in this function + all its callees
- **sum%**: Cumulative percentage of flat time

### Memory Profile

```
      flat  flat%   sum%        cum   cum%
  512.50MB 40.00% 40.00%   768.75MB 60.00%  main.allocateBuffers
  256.25MB 20.00% 60.00%   256.25MB 20.00%  bytes.makeSlice
```

For memory, values are in bytes allocated (or objects with `-alloc_objects`).

**Memory profile types:**
```bash
go tool pprof -alloc_space mem.out    # Total bytes allocated (default)
go tool pprof -alloc_objects mem.out  # Number of allocations
go tool pprof -inuse_space mem.out    # Currently in-use bytes
go tool pprof -inuse_objects mem.out  # Currently in-use objects
```

## Common Bottleneck Patterns

### High CPU in runtime.mallocgc

Problem: Too many allocations

Solutions:
- Pre-allocate slices: `make([]T, 0, expectedSize)`
- Use sync.Pool for frequently allocated objects
- Reduce string concatenation (use strings.Builder)
- Use pointer receivers to avoid copying

### High CPU in runtime.gcBgMarkWorker

Problem: GC pressure from allocations

Solutions:
- Reduce allocations (see above)
- Reuse buffers
- Consider object pooling

### High CPU in runtime.chanrecv/chansend

Problem: Channel contention

Solutions:
- Use buffered channels
- Batch operations
- Consider alternative synchronization

### High Memory in specific function

Check for:
- Unbounded slice growth
- Leaking goroutines
- Large temporary allocations
- Closure captures

## Execution Trace

```bash
go test -trace=trace.out ./...
go tool trace trace.out
```

Shows:
- Goroutine activity timeline
- GC events
- Syscalls
- Blocking events
- Network activity

Useful for:
- Understanding concurrency behavior
- Finding goroutine leaks
- Analyzing latency

## Benchmark Comparison

```bash
# Run benchmarks and save
go test -bench=. -count=10 ./... > old.txt

# Make changes, then run again
go test -bench=. -count=10 ./... > new.txt

# Compare with benchstat
go install golang.org/x/perf/cmd/benchstat@latest
benchstat old.txt new.txt
```

Output:
```
name       old time/op  new time/op  delta
Process-8  1.20ms ± 2%  0.95ms ± 1%  -20.83%  (p=0.000 n=10+10)
```

## Quick Profiling Workflow

1. **Identify slow operation** - Add benchmarks if needed
2. **Generate profile** - `go test -cpuprofile=cpu.out -bench=BenchmarkSlow`
3. **Find hotspots** - `go tool pprof -http=:8080 cpu.out`
4. **Optimize** - Focus on functions with high `flat%`
5. **Verify** - Compare benchmarks with `benchstat`
6. **Repeat** - Profile again to find next bottleneck
