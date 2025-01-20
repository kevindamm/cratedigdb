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

import { DateTime, Int, Str } from "chanfana"
import { z } from "zod"

// A single instance of a musical release,
// typically a vinyl record, specified in media_format.
export const Record = z.object({
  id: Int().gt(0),

  user_id: Int().gt(0),
  folder_id: Str().optional(),
  release_id: Str(),
  media_format: z.enum(["Vinyl", "CD", "Laserdisc", "Tape", "Floppy", "Download"]),

  when: DateTime(),
  media_grade: z.enum(["Mint", "M-", "NM", "VG+", "Good", "Fair", "Poor"]).optional(),
  sleeve_grade: z.enum(["Mint", "M-", "NM", "VG+", "Good", "Fair", "Poor"]).optional(),
  notes: Str(),
})
