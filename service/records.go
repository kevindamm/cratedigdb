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
// github:kevindamm/cratedig/service/records.go

package service

import (
	"fmt"
	"net/http"

	"github.com/kevindamm/cratedig"
	"github.com/labstack/echo"
)

// A record is a specific album version.
// (in discogs it is either a release or a collection's item)

func (server *server) getRecord(ctx echo.Context) error {
	record_id := ctx.Param("record_id")
	record, found := server.records_table[record_id]
	if !found {
		return echo.NewHTTPError(http.StatusNotFound,
			fmt.Sprintf("record %s not found", record_id))
	}
	return ctx.JSON(http.StatusOK, record)
}

func (server *server) addRecord(ctx echo.Context) error {
	record := new(cratedig.Record)
	if err := ctx.Bind(record); err != nil {
		return err
	}

	// TODO pre-check whether record has already been added.
	server.records_table[record.DiscogsID] = record
	return ctx.JSON(http.StatusCreated, record)
}
