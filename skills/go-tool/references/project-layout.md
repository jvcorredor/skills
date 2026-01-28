# Go Project Layout

## Standard Layout

```
project/
├── cmd/                    # Main applications
│   ├── app/
│   │   └── main.go
│   └── cli/
│       └── main.go
├── internal/               # Private packages (not importable externally)
│   ├── config/
│   ├── database/
│   └── service/
├── pkg/                    # Public packages (importable by others)
│   └── client/
├── api/                    # API definitions (OpenAPI, protobuf, etc.)
│   └── v1/
├── web/                    # Web assets (templates, static files)
├── scripts/                # Build/CI scripts
├── deployments/            # Deployment configs (k8s, docker-compose)
├── test/                   # Additional test data and e2e tests
│   └── testdata/
├── docs/                   # Documentation
├── go.mod
├── go.sum
├── Makefile
└── README.md
```

## When to Use Each Directory

### cmd/

- One subdirectory per binary
- Keep main.go minimal - parse flags, call into internal/
- Name matches the binary name

```go
// cmd/myapp/main.go
package main

import (
    "github.com/user/project/internal/app"
)

func main() {
    if err := app.Run(); err != nil {
        log.Fatal(err)
    }
}
```

### internal/

- Private to your module - Go enforces this
- Cannot be imported by other projects
- Use for all your business logic
- Safe to refactor without breaking external users

### pkg/

- Public, importable packages
- Only use if you intend others to import your code
- Many projects skip this entirely
- If in doubt, start with internal/

## Minimal Project Layout

For small projects, you don't need all directories:

```
project/
├── main.go           # Single binary project
├── handler.go
├── handler_test.go
├── go.mod
└── README.md
```

Or:

```
project/
├── cmd/
│   └── app/
│       └── main.go
├── app.go            # Package-level code in root
├── app_test.go
├── go.mod
└── README.md
```

## Example Makefile

```makefile
.PHONY: build test lint clean

# Build variables
BINARY_NAME := myapp
VERSION := $(shell git describe --tags --always --dirty)
LDFLAGS := -ldflags="-s -w -X main.version=$(VERSION)"

# Default target
all: lint test build

build:
	go build $(LDFLAGS) -o bin/$(BINARY_NAME) ./cmd/$(BINARY_NAME)

build-all:
	GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o bin/$(BINARY_NAME)-linux-amd64 ./cmd/$(BINARY_NAME)
	GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o bin/$(BINARY_NAME)-darwin-arm64 ./cmd/$(BINARY_NAME)

test:
	go test -race -cover ./...

test-coverage:
	go test -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

lint:
	golangci-lint run

fmt:
	go fmt ./...
	gofmt -s -w .

vet:
	go vet ./...

tidy:
	go mod tidy
	go mod verify

clean:
	rm -rf bin/
	rm -f coverage.out coverage.html

run: build
	./bin/$(BINARY_NAME)

install:
	go install $(LDFLAGS) ./cmd/$(BINARY_NAME)
```

## Example .golangci.yml

```yaml
run:
  timeout: 5m

linters:
  enable:
    - errcheck
    - govet
    - ineffassign
    - staticcheck
    - unused
    - gosimple
    - gocritic
    - gofmt
    - goimports
    - misspell
    - unconvert
    - unparam
    - prealloc

linters-settings:
  errcheck:
    check-type-assertions: true
  gocritic:
    enabled-tags:
      - diagnostic
      - style
      - performance
  goimports:
    local-prefixes: github.com/user/project

issues:
  exclude-rules:
    - path: _test\.go
      linters:
        - errcheck
        - gocritic
```

## Package Naming

- Short, lowercase, single-word names
- Avoid stuttering: `http.HTTPServer` -> `http.Server`
- Package name is part of the API: `json.Marshal` not `json.JSONMarshal`

**Good:**
```
package user     // user.Service
package config   // config.Load
package http     // http.Handler
```

**Bad:**
```
package userService   // userService.Service (stutters)
package httpHandlers  // multi-word
package util          // too generic
```

## File Organization

- One file per major type or concept
- Group related functionality
- Test files next to implementation: `foo.go` + `foo_test.go`

```
internal/user/
├── user.go          # User type definition
├── user_test.go
├── store.go         # UserStore interface + implementations
├── store_test.go
├── service.go       # UserService business logic
└── service_test.go
```

## Dependency Injection Pattern

```go
// internal/service/user.go
package service

type UserStore interface {
    Get(id string) (*User, error)
    Save(u *User) error
}

type UserService struct {
    store UserStore
    log   *slog.Logger
}

func NewUserService(store UserStore, log *slog.Logger) *UserService {
    return &UserService{store: store, log: log}
}
```

```go
// cmd/app/main.go
func main() {
    logger := slog.Default()
    db := database.New(os.Getenv("DATABASE_URL"))
    store := postgres.NewUserStore(db)
    svc := service.NewUserService(store, logger)
    // ...
}
```
