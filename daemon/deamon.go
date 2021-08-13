// Copyright © 2020 Servian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

package daemon

import (
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"

	"github.com/servian/TechChallengeApp/ui"
)

// Config - configuration for daemon package
type Config struct {
	ListenSpec string

	UI ui.Config
}

// Run - starts the daemon
func Run(cfg *Config) error {
	log.Printf("Starting HTTP server on: %s\n", cfg.ListenSpec)

	listener, err := net.Listen("tcp", cfg.ListenSpec)
	if err != nil {
		log.Printf("Error creating listener - %v\n", err)
	}

	ui.Start(cfg.UI, listener)

	waitForSignal()

	return nil
}

func waitForSignal() {
	xsig := make(chan os.Signal)
	signal.Notify(xsig, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)
	hsig := make(chan os.Signal)
	signal.Notify(hsig, syscall.SIGHUP)
	for {
		select {
		case s := <-xsig:
			log.Fatalf("Got signal: %v, exiting.", s)
		case s := <-hsig:
			log.Printf("Got signal: %v, continue.", s)
		}
	}
}
