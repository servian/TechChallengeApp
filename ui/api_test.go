package ui

import "testing"

func TestAdd(t *testing.T) {
	if 1+1 != 2 {
		t.Errorf("Whoa, what happened there, simple test failed")
	}
}
