// Copyright (c) 2024 Kevin Damm
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
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// github:kevindamm/cratedig/cmd/server/main.go

package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os/signal"
	"path"
	"syscall"
	"time"

	"github.com/kevindamm/cratedig/service"
)

func main() {
	port := flag.Int("port", 0,
		"server port to listen on (0 uses default 80/443 ports)")
	cert_path := flag.String("cert_path", "",
		"path where server.crt and server.key can be found (for this environment)")
	debug := flag.Bool("debug", false, "enable debug mode and debug logging")
	flag.Parse()

	if *port == 0 {
		*port = 80
		if len(*cert_path) > 0 {
			*port = 443
		}
	}

	server := service.NewInMemoryHandler(*port, *debug)
	server.RouteAPI()
	// TODO other routes

	// Create a done channel to signal when the shutdown is complete
	done := make(chan bool, 1)
	// Run graceful shutdown in a separate goroutine that exits after timeout.
	go graceful_shutdown(server.Server, done, 5)

	var err error
	if len(*cert_path) > 0 {
		crt_path := path.Join(*cert_path, "server.crt")
		key_path := path.Join(*cert_path, "server.key")
		err = server.ServeTLS(crt_path, key_path)
	} else {
		// Serve without HTTPS if the certificates path is empty.
		err = server.ServeLocalhost(*port)
	}
	if err != nil && err != http.ErrServerClosed {
		panic(fmt.Sprintf("httpserver error: %s", err))
	}

	// Wait for the graceful shutdown to complete
	<-done
	log.Println("graceful shutdown complete")
}

// Calls the server's [Shutdown()] when
// Runs in a goroutine alongside the server handler, the [done] channel runs the
// remainder of main() (after blocking on a channel following server startup).
// This gives a convenient place to
func graceful_shutdown(https_server *http.Server, done chan<- bool, timeout_seconds int) {
	// Listen for the interrupt signal or termination from the OS.
	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()
	<-ctx.Done()
	log.Println("shutting down gracefully, press Ctrl+C again to force")

	// Notify the server with a 5 second timeout so that current handlers can finish.
	timeout := time.Duration(timeout_seconds) * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()
	log.Println("Graceful Shutdown: server exiting in", timeout_seconds, "...")
	if err := https_server.Shutdown(ctx); err != nil {
		log.Printf("Server forced to shutdown with error: %v", err)
	}

	// Shutdown is complete, safely notify the code execution of main().
	done <- true
}
