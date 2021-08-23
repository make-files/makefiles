package go1_test

import "testing"
import . "github.com/make-files/test"

func Test(t *testing.T) {
	Global = &TestMessage{}
}
