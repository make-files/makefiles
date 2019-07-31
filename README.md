# Go Makefile

```Makefile
-include artifacts/make/go/Makefile

artifacts/make/%:
	curl -sfL https://makefiles.dev/fetch | bash /dev/stdin $*
```
