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
// github:kevindamm/cratedig/service/testutil.go

package service

import "github.com/kevindamm/cratedig"

func TestHandler() *server {
	// this will be updated as we incrementally upgrade the backing store.
	server := NewInMemoryHandler(0, true)
	server.RegisterAPIRoutes()

	server.artists_table = map[string]*cratedig.Artist{
		"1234": {
			DiscogsID: "1234",
			Name:      "ahhMayZing",
			Profile:   "aspiring DJ, sharing my journey with anyone willing to listen 💙",
		},
	}
	server.albums_table = make(map[string]*cratedig.Album)
	server.records_table = make(map[string]*cratedig.Record)

	return server
}
