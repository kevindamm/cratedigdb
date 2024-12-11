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
// github:kevindamm/cratedig/service/routes.go

package service

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/kevindamm/cratedig"
)

func DefineRoutes(router *gin.Engine) error {
	//router.StaticFile("/favicon.ico", "./service/resources/favicon.ico")
	router.LoadHTMLGlob("./templates/*.html")

	router.GET("/records", getAlbums)
	router.GET("/records/:id/", getAlbumById)
	router.POST("/records/:id/add", addToCollection)

	return nil
}

// Some test data just to get started.
var albums = []cratedig.Release{
	{
		DiscogsID: 1001,
		Title:     "Blue Train",
		Artists: []cratedig.Artist{{
			Name: "John Coltrane",
		}},
	},
	{
		DiscogsID: 1002,
		Title:     "Jeru",
		Artists: []cratedig.Artist{{
			Name: "Gerry Mulligan",
		}},
	},
	{
		DiscogsID: 1003,
		Title:     "Sarah Vaughan and Clifford Brown",
		Artists: []cratedig.Artist{{
			Name: "Sarah Vaughan",
		}},
	},
	{
		DiscogsID: 1004,
		Title:     "Set Yourself on Fire",
		Artists: []cratedig.Artist{{
			Name: "Stars",
		}},
	},
}

func getAlbums(c *gin.Context) {
	c.IndentedJSON(http.StatusOK, albums)
}

func getAlbumById(c *gin.Context) {
	request_id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		panic(err)
	}
	for _, v := range albums {
		if v.DiscogsID == request_id {
			c.IndentedJSON(http.StatusOK, v)
			return
		}
	}
	c.IndentedJSON(http.StatusNotFound, gin.H{"message": "record by that ID not found"})
}

func addToCollection(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"todo": "todo"})
}
