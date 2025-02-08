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
// github:kevindamm/cratedig/worker/models/records.ts

import { z } from "zod"

export const Grading = z.enum([
  "",    // 0 (UNKNOWN)
  "M",   // 1
  "NM",  // 2
  "VG+", // 3
  "VG",  // 4
  "G+",  // 5
  "G",   // 6
  "F",   // 7
  "P",   // 8
])

// A single instance of a musical release,
// typically a vinyl record, specified in media_format.
export const VinylRecord = z.object({
  userID: z.number().positive().int(),
  releaseID: z.number().positive().int(),
  versionID: z.number().positive().int(),
  item: z.number().int(),

  crateID: z.string().optional(),

  date_added: z.string().date().nonempty(),
  date_graded: z.string().date().optional(),
  date_sold: z.string().date().optional(),
  date_traded: z.string().date().optional(),

  media_grade: Grading.optional(),
  sleeve_grade: Grading.optional(),

  tags: z.set(z.string().nonempty()),
  notes: z.string().optional(),
})
