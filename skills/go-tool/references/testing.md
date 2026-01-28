# Go Testing Patterns

## Table-Driven Tests

The idiomatic Go pattern for testing multiple cases:

```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive", 2, 3, 5},
        {"negative", -1, -1, -2},
        {"zero", 0, 0, 0},
        {"mixed", -1, 1, 0},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%d, %d) = %d; want %d", tt.a, tt.b, result, tt.expected)
            }
        })
    }
}
```

## Subtests with t.Run()

Benefits:
- Run specific subtests: `go test -run TestAdd/positive`
- Parallel execution within subtests
- Shared setup/teardown

```go
func TestDatabase(t *testing.T) {
    // Shared setup
    db := setupTestDB(t)
    t.Cleanup(func() { db.Close() })

    t.Run("Insert", func(t *testing.T) {
        // test insert
    })

    t.Run("Query", func(t *testing.T) {
        // test query
    })

    t.Run("Delete", func(t *testing.T) {
        // test delete
    })
}
```

## Parallel Tests

```go
func TestParallel(t *testing.T) {
    tests := []struct {
        name string
        // ...
    }{
        // test cases
    }

    for _, tt := range tests {
        tt := tt // capture range variable
        t.Run(tt.name, func(t *testing.T) {
            t.Parallel() // run this subtest in parallel
            // test logic
        })
    }
}
```

## Test Fixtures

**Using testdata/ directory:**
```go
func TestParseConfig(t *testing.T) {
    // testdata/ is ignored by go build
    data, err := os.ReadFile("testdata/config.json")
    if err != nil {
        t.Fatal(err)
    }
    // ...
}
```

**Using embed for test fixtures:**
```go
//go:embed testdata/*
var testFiles embed.FS

func TestWithEmbed(t *testing.T) {
    data, _ := testFiles.ReadFile("testdata/input.txt")
    // ...
}
```

## Test Helpers

```go
// testHelper marks function as test helper - failures report caller's line
func assertEqual(t *testing.T, got, want interface{}) {
    t.Helper()
    if got != want {
        t.Errorf("got %v; want %v", got, want)
    }
}

// Cleanup runs after test completes (even on failure)
func setupTempDir(t *testing.T) string {
    t.Helper()
    dir, err := os.MkdirTemp("", "test-*")
    if err != nil {
        t.Fatal(err)
    }
    t.Cleanup(func() { os.RemoveAll(dir) })
    return dir
}
```

## Integration Tests with Build Tags

**File: integration_test.go**
```go
//go:build integration

package mypackage

func TestIntegration(t *testing.T) {
    // tests that need external services
}
```

**Running:**
```bash
go test ./...                           # skips integration tests
go test -tags=integration ./...         # includes integration tests
```

## Short Tests

```go
func TestLongRunning(t *testing.T) {
    if testing.Short() {
        t.Skip("skipping in short mode")
    }
    // long-running test
}
```

```bash
go test -short ./...    # skip long tests
```

## Mocking Strategies

**Interface-based mocking (preferred):**
```go
// Define interface for what you need
type UserStore interface {
    GetUser(id string) (*User, error)
}

// Real implementation
type PostgresUserStore struct { /* ... */ }

// Mock for testing
type MockUserStore struct {
    GetUserFunc func(id string) (*User, error)
}

func (m *MockUserStore) GetUser(id string) (*User, error) {
    return m.GetUserFunc(id)
}

func TestService(t *testing.T) {
    mock := &MockUserStore{
        GetUserFunc: func(id string) (*User, error) {
            return &User{ID: id, Name: "Test"}, nil
        },
    }
    svc := NewService(mock)
    // test svc
}
```

**Using testify/mock:**
```go
import "github.com/stretchr/testify/mock"

type MockStore struct {
    mock.Mock
}

func (m *MockStore) GetUser(id string) (*User, error) {
    args := m.Called(id)
    return args.Get(0).(*User), args.Error(1)
}

func TestWithTestify(t *testing.T) {
    m := new(MockStore)
    m.On("GetUser", "123").Return(&User{ID: "123"}, nil)
    // use mock
    m.AssertExpectations(t)
}
```

## HTTP Testing

```go
import (
    "net/http"
    "net/http/httptest"
)

func TestHandler(t *testing.T) {
    req := httptest.NewRequest("GET", "/users/123", nil)
    w := httptest.NewRecorder()

    handler := NewUserHandler()
    handler.ServeHTTP(w, req)

    if w.Code != http.StatusOK {
        t.Errorf("got status %d; want %d", w.Code, http.StatusOK)
    }
}

// Test against real server
func TestClient(t *testing.T) {
    srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.WriteHeader(http.StatusOK)
        w.Write([]byte(`{"id": "123"}`))
    }))
    defer srv.Close()

    client := NewClient(srv.URL)
    // test client
}
```

## Golden Files

For testing complex output (JSON, generated code, etc.):

```go
var update = flag.Bool("update", false, "update golden files")

func TestOutput(t *testing.T) {
    got := GenerateOutput()
    golden := filepath.Join("testdata", t.Name()+".golden")

    if *update {
        os.WriteFile(golden, got, 0644)
        return
    }

    want, _ := os.ReadFile(golden)
    if !bytes.Equal(got, want) {
        t.Errorf("output mismatch; run with -update to update golden file")
    }
}
```

```bash
go test -update ./...    # update golden files
go test ./...            # compare against golden files
```
