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
// github:kevindamm/cratedig/worker/models/releases.ts

import { Int, DateTime } from "chanfana"
import { z } from "zod"
import { DataQuality } from "./types"

export const Release = z.object({
  id: Int().gt(0),
  data_quality: DataQuality,

  title: z.string(),
  thumb: z.string().url(),
  year: z.string(),  // pattern: \d{4}

  country: z.string(),
  tracklist: z.array(z.string()),  // TODO type this out
  artists: z.array(Int()),
  credits: z.array(Int()),
  notes: z.string(),
})

export const ReleaseVersion = z.object({
  id: Int().gt(0),
  data_quality: DataQuality,
  main_release: Int().gt(0),

  title: z.string(),
  when: DateTime(),
  notes: z.string(),
})
