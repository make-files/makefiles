package gomakefile_test

import "testing"

func Test(t *testing.T) {
	gomakefile.TestMessage = &Test{}
}
