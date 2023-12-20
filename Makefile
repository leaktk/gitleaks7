.PHONY: test test-cover build release-builds

VERSION := 2.0.0
PKG=github.com/zricethezav/gitleaks
LDFLAGS=-ldflags "-X=github.com/leaktk/gitleaks7/v2/version.Version=$(VERSION)"
_LDFLAGS="github.com/leaktk/gitleaks7/v2/version.Version=$(VERSION)"
COVER=--cover --coverprofile=cover.out
PREFIX := /usr
INSTALL := install

all: clean build

clean:
	if [[ -e .git ]]; then git clean -Xfd; fi

test-cover:
	go test ./... --race $(COVER) $(PKG) -v
	go tool cover -html=cover.out

format:
	go fmt ./...

test: format
	go mod tidy
	go get golang.org/x/lint/golint
	go vet ./...
	golint ./...
	go test ./... --race $(PKG) -v
	go mod tidy

build: format
	golint ./...
	go vet ./...
	go mod tidy
	go build $(LDFLAGS) -o gitleaks7

release-builds:
	rm -rf build
	mkdir build
	env GOOS="windows" GOARCH="amd64" go build -o "build/gitleaks7-windows-amd64.exe" $(LDFLAGS)
	env GOOS="windows" GOARCH="386" go build -o "build/gitleaks7-windows-386.exe" $(LDFLAGS)
	env GOOS="linux" GOARCH="amd64" go build -o "build/gitleaks7-linux-amd64" $(LDFLAGS)
	env GOOS="linux" GOARCH="arm" go build -o "build/gitleaks7-linux-arm" $(LDFLAGS)
	env GOOS="linux" GOARCH="mips" go build -o "build/gitleaks7-linux-mips" $(LDFLAGS)
	env GOOS="linux" GOARCH="mips" go build -o "build/gitleaks7-linux-mips" $(LDFLAGS)
	env GOOS="darwin" GOARCH="amd64" go build -o "build/gitleaks7-darwin-amd64" $(LDFLAGS)

install:
	$(INSTALL) -D ./gitleaks7 $(DESTDIR)$(PREFIX)/bin/gitleaks7
