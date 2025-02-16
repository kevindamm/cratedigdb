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
import { DataQuality } from "./data_quality"

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
  releaseID: z.number().positive().int(),
  versionID: z.number().positive().int(),
  data_quality: DataQuality,

  title: z.string(),
  release_date: z.string().date(),
})

// A ReleaseVersion representation with details and related info.
export const ReleaseVersionResource = ReleaseVersionInfo.extend({
  artists: ArtistInfo.array(),
  featured: ArtistInfo.array(),
  labels: RecordLabelInfo.array(),
  formats: z.enum(MediaFormats).array(),
  images: ImageInfo.array(),
  genres: z.string().array(),
  styles: z.string().array(),
  country: z.string().optional(),
  notes: z.string().optional(),
  tracklist: TrackInfo.array(),
})
