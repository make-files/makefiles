package go1_test

import "testing"
import . "github.com/make-files/make-go1"

func Test(t *testing.T) {
	Global = &TestMessage{}
}
