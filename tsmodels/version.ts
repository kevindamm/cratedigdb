// Copyright (c) 2025, Kevin Damm
// All Rights Reserved.
// MIT License:
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
// github:kevindamm/cratedigdb/tsmodels/version.ts

import { z } from "zod"
import { ArtistInfo } from "./artist"
import { ImageInfo } from "./image"
import { RecordLabelInfo } from "./label"
import { TrackInfo } from "./track"

export type MediaFormatType = (
    'Box Set'
  | 'Cassette'
  | 'CD'
  | 'File'
  | 'Vinyl'
)

export const MediaFormats = [
  'Box Set',
  'Cassette',
  'CD',
  'File',
  'Vinyl',
] as const satisfies MediaFormatType[]

// A simplified ReleaseVersion representation, typically used when embedded in a resource.
export const ReleaseVersionInfo = z.object({
  artists: z.array(ArtistInfo),
  title: z.string(),
  featured: z.array(ArtistInfo),
  labels: z.array(RecordLabelInfo),
  formats: z.array(z.enum(MediaFormats)),
  images: z.array(ImageInfo),
  genres: z.array(z.string()),
  styles: z.array(z.string()),
  country: z.string(),
  released: z.string(),
  notes: z.string().optional(),
  tracklist: z.array(TrackInfo),
})

// A ReleaseVersion representation with details and related info.
export const ReleaseVersionResource = z.object({
  // TODO
})
