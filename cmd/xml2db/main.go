// Copyright (c) 2025 Kevin Damm
// All rights reserved.
// MIT License
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
// github:kevindamm/cratedig/cmd/xml2db/main.go

package main

import (
	"compress/gzip"
	"fmt"
	"io"
	"log"
	"os"
	"path"
)

func data_path(folder, datestr, category string) string {
	return path.Join(folder,
		fmt.Sprintf("discogs_%s_%s.xml.gz", datestr, category))
}

func main() {
	datestr := "20250101"
	data_folder := "../../discogs"
	for _, filename := range []string{
		data_path(data_folder, datestr, "artists"),
		data_path(data_folder, datestr, "labels"),
		data_path(data_folder, datestr, "masters"),
		data_path(data_folder, datestr, "releases"),
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
		count := 10
		for count > 0 {
			n, err := reader.Read(buffer)
			if err != nil && err != io.EOF {
				log.Fatal(err)
			}
			fmt.Println(string(buffer[:n]))

			count--
		}

		fmt.Println("done")
	}
}
