package service

import (
	"fmt"
	"net/http"

	"github.com/kevindamm/cratedig"
	"github.com/labstack/echo"
)

func (server *server) getArtist(ctx echo.Context) error {
	artist_id := ctx.Param("artist_id")
	artist, found := server.artists_table[artist_id]
	if !found {
		return echo.NewHTTPError(http.StatusNotFound,
			fmt.Sprintf("artist %s not found", artist_id))
	}
	return ctx.JSON(http.StatusOK, artist)
}

func (server *server) addArtist(ctx echo.Context) error {
	artist := new(cratedig.Artist)
	if err := ctx.Bind(artist); err != nil {
		return err
	}

	// TODO pre-check whether artist has already been added.
	server.artists_table[artist.DiscogsID] = artist

	return ctx.JSON(http.StatusCreated, artist)
}
