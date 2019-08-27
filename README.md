# Go Makefile

This repository contains a Makefile for the Go programming language.

## Usage

```Makefile
-include artifacts/make/lang-go1/v1/Makefile

artifacts/make/%:
	curl -sfL https://fetch.makefiles.dev/v1 | bash /dev/stdin $*
```
