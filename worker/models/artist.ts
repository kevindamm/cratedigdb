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
// github:kevindamm/cratedig/worker/models/artist.ts

import { z } from "zod"
import { ImageInfo } from "./image"
import { DataQuality } from "./data_quality"

export const ArtistInfo = z.object({
  id: z.coerce.number().positive(),
  active: z.boolean(),
  name: z.string().nonempty(),
  resource_url: z.string().url(),
})

export const ArtistResource = z.object({
  id: z.coerce.number().positive(),
  resource_url: z.string().url(),
  namevariations: z.array(z.string()),
  releases_url: z.string().url(),

  profile: z.string().optional(),
  uri: z.string().url().optional(),
  urls: z.array(z.string().url()),

  images: z.array(ImageInfo),
  members: z.array(ArtistInfo),
  data_quality: DataQuality,
})
