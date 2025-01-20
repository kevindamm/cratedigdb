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
// github:kevindamm/cratedig/worker/models/artists.ts

import { Int, Str } from "chanfana"
import { z } from "zod"

export const Artist = z.object({
  id: Int().gt(0),
  data_quality: Str(),  // TODO make this an enum

  name: Str(),
  real_name: Str(),
  profile: Str(),
  anv: z.array(Str()),
  aliases: z.array(Str()),
  urls: z.array(Str().url()),

  masters: z.array(Str()),
  releases: z.array(Str()),
  category: Str(),

  groups: z.array(Str()),
  members: z.array(Str()),
})