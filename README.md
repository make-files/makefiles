# Go Makefile

[![Build Status](http://img.shields.io/travis/com/make-files/make-go1/master.svg)](https://travis-ci.com/make-files/make-go1)

This repository contains a Makefile for the Go programming language.

## Usage

```Makefile
-include .makefiles/go1/v1/Makefile

.makefiles/%:
	curl -sfL https://fetch.makefiles.dev/v1 | bash /dev/stdin "$@"
```
