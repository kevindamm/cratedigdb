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
// github:kevindamm/cratedig/service/albums.go

package service

import (
	"fmt"
	"net/http"

	"github.com/kevindamm/cratedigdb/schema"
	"github.com/labstack/echo"
)

func (server *server) getRelease(ctx echo.Context) error {
	id := ctx.Param("releaseID")
	release, found := server.releases_table[id]
	if !found {
		return echo.NewHTTPError(http.StatusNotFound,
			fmt.Sprintf("release %s not found", id))
	}
	return ctx.JSON(http.StatusOK, release)
}

func (server *server) addRelease(ctx echo.Context) error {
	release := new(schema.Release)
	if err := ctx.Bind(release); err != nil {
		return err
	}

	server.releases_table[release.ReleaseID] = release
	return ctx.JSON(http.StatusCreated, release)
}
