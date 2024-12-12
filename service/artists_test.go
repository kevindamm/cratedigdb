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
// github:kevindamm/cratedig/service/artists_test.go

package service

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/kevindamm/cratedig"
	"github.com/labstack/echo"
	"github.com/stretchr/testify/assert"
)

func TestGetArtist(t *testing.T) {
	// Setup
	echos := echo.New()
	recorder := httptest.NewRecorder()
	request := httptest.NewRequest(http.MethodGet, "/", nil)
	ctx := echos.NewContext(request, recorder)
	artist := cratedig.Artist{}
	artistJSON, _ := json.Marshal(artist)

	// Assert
	handler := TestHandler()
	if assert.NoError(t, handler.getArtist(ctx)) {
		assert.Equal(t, http.StatusOK, recorder.Code)
		assert.Equal(t, artistJSON, recorder.Body.String())
	}
}

func TestAddArtist(t *testing.T) {
	// Setup
	echos := echo.New()
	recorder := httptest.NewRecorder()
	request := httptest.NewRequest(http.MethodPost, "/", strings.NewReader(ahhMayZing))
	request.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	ctx := echos.NewContext(request, recorder)

	// Assert
	handler := TestHandler()
	if assert.NoError(t, handler.addArtist(ctx)) {
		assert.Equal(t, http.StatusCreated, recorder.Code)
		assert.Equal(t, ahhMayZing+"\n", recorder.Body.String())
	}
}

var ahhMayZing = `{"id":"1234","name":"ahhMayZing","profile":"aspiring DJ, sharing my journey with anyone willing to listen 💙"}`
