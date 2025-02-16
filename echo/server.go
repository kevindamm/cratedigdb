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
// github:kevindamm/cratedig/service/server.go

package echo

import (
	"fmt"
	"html/template"
	"io"
	"log"
	"net/http"
	"time"

	"github.com/kevindamm/cratedigdb/schema"
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

type Server interface {
	RegisterAPIRoutes()
	ServeLocalhost(int) error
	ServeTLS(string, string) error
}

type server struct {
	*http.Server
	port int

	echos *echo.Echo
	debug bool

	// naive DB tables while routes, etc. defined
	artists_table  map[uint64]*schema.Artist
	labels_table   map[uint64]*schema.Label
	releases_table map[uint64]*schema.Release
	versions_table map[uint64]*schema.ReleaseVersion
	vinyl_table    map[uint64]*schema.Vinyl
	listings_table map[uint64]*schema.Listing
}

func NewInMemoryHandler(port int, debug bool) *server {
	server := new(server)
	server.port = port
	if debug {
		log.Printf("Listening on port %d", port)
		server.debug = true
	}

	server.Server = &http.Server{
		Addr:         fmt.Sprintf(":%d", server.port),
		IdleTimeout:  time.Minute,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 30 * time.Second,
	}

	server.echos = echo.New()
	server.echos.Use(middleware.Logger())
	server.echos.Use(middleware.Recover())
	//qps.echo.Pre(middleware.HTTPSRedirect())
	//qps.echo.Pre(middleware.RemoveTrailingSlash())

	server.echos.Renderer = NewRenderer()
	server.Handler = server.echos

	return server
}

func (handler *server) RegisterAPIRoutes() {
	handler.echos.GET("/artist/:artist_id", handler.getArtist)
	handler.echos.POST("/artist/:artist_id", handler.addArtist)
}

func (server *server) ServeLocalhost(port int) error {
	url := fmt.Sprintf(":%d", port)
	return server.echos.Start(url)
}

func (server *server) ServeTLS(crt_path, key_path string) error {
	url := "cratedig3000.kevindamm.com:443"
	return server.echos.StartTLS(url, crt_path, key_path)
}

func NewRenderer() echo.Renderer {
	return TemplateRenderer{
		//templates: template.Must(template.ParseGlob("templates/*.ht_")),
	}
}

type TemplateRenderer struct {
	templates *template.Template
}

func (site TemplateRenderer) Render(w io.Writer, name string, data interface{}, ctx echo.Context) error {
	return site.templates.ExecuteTemplate(w, name, data)
}
