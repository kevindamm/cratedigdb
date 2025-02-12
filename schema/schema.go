// Copyright (c) 2025 Kevin Damm
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
// github:kevindamm/cratedigdb/schema/schema.go

package schema

import (
	"embed"
	"io"
	"log"
)

//go:embed *.cue
var cueSchema embed.FS

type JsonParser[T Resource] func(json string, value *T) error

var artistParser JsonParser[Artist]
var labelParser JsonParser[Label]
var listingParser JsonParser[Listing]
var releaseParser JsonParser[Release]
var versionParser JsonParser[ReleaseVersion]
var vinylParser JsonParser[Vinyl]

func init() {
	artistParser = NewArtistParser(must_read_cue("artist.cue"))
	labelParser = NewLabelParser(must_read_cue("label.cue"))
	listingParser = NewListingParser(must_read_cue("listing.cue"))
	releaseParser = NewReleaseParser(must_read_cue("release.cue"))
	versionParser = NewReleaseVersionParser(must_read_cue("version.cue"))
	vinylParser = NewVinylParser(must_read_cue("vinyl.cue"))

}

func must_read_cue(path string) string {
	reader, err := cueSchema.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	bytes, err := io.ReadAll(reader)
	if err != nil {
		log.Fatal(err)
	}
	return string(bytes)
}
