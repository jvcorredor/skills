---
name: go-tool
description: Use when working with Go projects - building, testing, profiling, debugging, or setting up new Go modules. Triggers on "go test", "go build", "coverage", "pprof", "benchmark", or Go project questions.
tools: Bash, Read, Write, Glob, Grep
---

# Go Tool

## When to Use

- User asks about Go commands or workflows
- Running, debugging, or writing Go tests
- Performance profiling or optimization
- Setting up a new Go project
- Module or dependency issues
- Building or cross-compiling Go binaries

## Quick Reference

### Testing

```bash
go test ./...                    # Run all tests
go test -v ./...                 # Verbose output
go test -run TestName ./...      # Run specific test
go test -run TestName/SubTest    # Run specific subtest
go test -short ./...             # Skip long-running tests
go test -race ./...              # Enable race detector
go test -count=1 ./...           # Disable test caching
```

**Coverage:**
```bash
go test -cover ./...                                    # Coverage summary
go test -coverprofile=coverage.out ./...                # Generate profile
go tool cover -html=coverage.out -o coverage.html      # HTML report
go tool cover -func=coverage.out                        # Per-function coverage
```

**Benchmarks:**
```bash
go test -bench=. ./...                    # Run all benchmarks
go test -bench=BenchmarkName ./...        # Run specific benchmark
go test -bench=. -benchmem ./...          # Include memory stats
go test -bench=. -count=5 ./...           # Multiple runs for stability
```

See `references/testing.md` for testing patterns and best practices.

### Building

```bash
go build ./...                            # Build all packages
go build -o bin/app ./cmd/app             # Output to specific path
go build -ldflags="-s -w" ./...           # Strip debug info (smaller binary)
go build -ldflags="-X main.version=1.0"   # Inject build-time variables
go install ./...                          # Install to $GOBIN
```

**Static/Cross-compilation:**
```bash
CGO_ENABLED=0 go build ./...                          # Static binary (no CGO)
GOOS=linux GOARCH=amd64 go build ./...                # Linux AMD64
GOOS=linux GOARCH=arm64 go build ./...                # Linux ARM64
GOOS=darwin GOARCH=arm64 go build ./...               # macOS Apple Silicon
GOOS=windows GOARCH=amd64 go build ./...              # Windows
```

### Modules

```bash
go mod init github.com/user/repo    # Initialize new module
go mod tidy                         # Add missing, remove unused deps
go mod download                     # Download deps to cache
go mod vendor                       # Copy deps to vendor/
go mod verify                       # Verify deps match go.sum
go mod why <package>                # Explain why package is needed
go mod graph                        # Print dependency graph
```

**Updating dependencies:**
```bash
go get -u ./...                     # Update all deps (minor/patch)
go get -u=patch ./...               # Update patch versions only
go get package@latest               # Update specific package
go get package@v1.2.3               # Pin to specific version
```

**Private modules:**
```bash
export GOPRIVATE=github.com/myorg/*
export GONOSUMDB=github.com/myorg/*
```

### Code Quality

```bash
go fmt ./...                        # Format code
gofmt -s -w .                       # Format with simplification
go vet ./...                        # Static analysis
go vet -vettool=$(which shadow) ./...  # Check for shadowed variables
```

**With golangci-lint:**
```bash
golangci-lint run                   # Run all enabled linters
golangci-lint run --fix             # Auto-fix where possible
golangci-lint run --enable-all      # Enable all linters
golangci-lint linters               # List available linters
```

**Code generation:**
```bash
go generate ./...                   # Run all //go:generate directives
```

### Profiling & Debugging

```bash
# Generate profiles
go test -cpuprofile=cpu.out -bench=. ./...
go test -memprofile=mem.out -bench=. ./...
go test -trace=trace.out ./...

# Analyze profiles
go tool pprof cpu.out               # Interactive CLI
go tool pprof -http=:8080 cpu.out   # Web UI
go tool trace trace.out             # Trace viewer
```

**Common pprof commands:**
```
top                    # Top functions by resource usage
top -cum               # Top by cumulative usage
list FuncName          # Show annotated source
web                    # Open graph in browser
pdf > profile.pdf      # Export to PDF
```

See `references/profiling.md` for detailed profiling guide.

### Project Setup

New project checklist:
1. `go mod init github.com/user/project`
2. Create directory structure (see `references/project-layout.md`)
3. Add `.gitignore` for Go
4. Set up Makefile with common targets
5. Configure golangci-lint (`.golangci.yml`)

**Minimal .gitignore for Go:**
```
# Binaries
*.exe
*.exe~
*.dll
*.so
*.dylib
bin/

# Test
*.test
coverage.out
coverage.html

# Profiles
*.out
*.prof

# Vendor (if not committing)
# vendor/

# IDE
.idea/
.vscode/
*.swp
```

## Decision Tree

**"Tests are failing"**
1. Run with `-v` for verbose output
2. Run specific test with `-run TestName`
3. Check for race conditions with `-race`
4. Disable caching with `-count=1`

**"Need to optimize performance"**
1. Write benchmarks first
2. Profile CPU: `-cpuprofile=cpu.out`
3. Profile memory: `-memprofile=mem.out`
4. Analyze with `go tool pprof`

**"Dependency issues"**
1. Run `go mod tidy`
2. Check `go mod why <package>`
3. Verify with `go mod verify`
4. Clear cache: `go clean -modcache`
