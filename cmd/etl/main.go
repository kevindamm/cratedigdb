package main

import (
	"compress/gzip"
	"encoding/xml"
	"fmt"
	"io"
	"log"
	"os"
)

type Release struct {
	XMLName  xml.Name `xml:"release"`
	Style    []string `xml:"styles>style"`
	Genre    []string `xml:"genres>genre"`
	Label    Label    `xml:"labels>label"`
	Track    []Track  `xml:"tracklist>track"`
	RelTitle string   `xml:"title"`
	MasterID int      `xml:"master_id"`
	ID       int      `xml:"id,attr"`
	Country  string   `xml:"country"`
	Released string   `xml:"released"`
	Artist   string   `xml:"artists>artist>name"`
}

type Label struct {
	Name  string `xml:"name,attr"`
	Catno string `xml:"catno,attr"`
	ID    int    `xml:"id,attr"`
}

type Track struct {
	Position string `xml:"position"`
	Title    string `xml:"title"`
	Duration string `xml:"duration"`
}

func main() {
	for _, filename := range []string{
		"discogs/discogs_20240701_artists.xml.gz",
		"discogs/discogs_20240701_labels.xml.gz",
		"discogs/discogs_20240701_masters.xml.gz",
		"discogs/discogs_20240701_releases.xml.gz",
	} {
		fmt.Println()
		fmt.Printf("head -n 4k %s\n", filename)

		file, err := os.Open(filename)
		if err != nil {
			log.Fatal(err)
		}
		defer file.Close()

		reader, err := gzip.NewReader(file)
		if err != nil {
			log.Fatal(err)
		}
		defer reader.Close()

		buffer := make([]byte, 4096)
		n, err := reader.Read(buffer)
		if err != nil && err != io.EOF {
			log.Fatal(err)
		}

		fmt.Println(string(buffer[:n]))

	}
}
