# Go Makefile

```Makefile
-include artifacts/make/go/Makefile

artifacts/make/%:
	curl -sf https://make-files.github.io/fetch | bash /dev/stdin $*
```
