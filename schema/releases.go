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
// github:kevindamm/cratedig/releases.go

package schema

import "encoding/xml"

type ReleaseParams struct {
	ReleaseID int          `param:"releaseID"`
	Currency  CurrencyEnum `param:"curr"`
}

// A Release describes all related ReleaseVersions.
type Release struct {
	ReleaseID string `json:"id"`
	Title     string `json:"title"`

	Artists []Artist `json:"artists"`
	Country string   `json:"country"`
}

// Statistics about a release.
type ReleaseStats struct {
	CountHave uint `json:"num_have"`
	CountWant uint `json:"num_want"`
}

type XmlLabel struct {
	Name  string `xml:"name,attr"`
	Catno string `xml:"catno,attr"`
	ID    int    `xml:"id,attr"`
}

type XmlRelease struct {
	ID       int        `xml:"id,attr"`
	XMLName  xml.Name   `xml:"release"`
	Style    []string   `xml:"styles>style"`
	Genre    []string   `xml:"genres>genre"`
	Label    XmlLabel   `xml:"labels>label"`
	Track    []XmlTrack `xml:"tracklist>track"`
	RelTitle string     `xml:"title"`
	MasterID int        `xml:"master_id"`
	Country  string     `xml:"country"`
	Released string     `xml:"released"`
	Artist   string     `xml:"artists>artist>name"`
}

type XmlTrack struct {
	ID       int
	Position string `xml:"position"`
	Title    string `xml:"title"`
	Duration string `xml:"duration"`
}
