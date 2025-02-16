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
// github:kevindamm/cratedigdb/tsmodels/release.ts

import { z } from "zod"

export const DataQuality = z.enum([
  "New Submission",
  "Recently Edited",
  "Correct",
  "Needs Vote",
  "Needs Major Changes",
  "Needs Minor Changes",
  "Entirely Incorrect",
])

export const ReleaseInfo = z.object({
  releaseiD: z.number().positive().int(),
  title: z.string().nonempty(),
  year: z.string(),
})

export const ReleaseResource = z.object({
  releaseID: z.number().positive().int(),
  data_quality: DataQuality,

  title: z.string().nonempty(),
  thumb: z.string().url(),
  year: z.string(),  // pattern: \d{4}

  tracklist: z.array(z.string()),  // TODO type this out
  artist_ids: z.array(z.number().positive().int()),
  credit_ids: z.array(z.number().positive().int()),
  notes: z.string(),
})

