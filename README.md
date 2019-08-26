# Go Makefile

## Usage

```Makefile
-include artifacts/make/go/Makefile

artifacts/make/%:
	curl -sfL https://fetch.makefiles.dev/v1 | bash /dev/stdin $*
```
