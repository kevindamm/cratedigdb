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
// github:kevindamm/cratedigdb/worker/api/crate/add.ts

import { Bool, Num, OpenAPIRoute, Str } from 'chanfana'
import { z } from 'zod'
import { VinylRecord } from '../../models'
import { WorkerContext } from '../../context'

export class AddVinylRecord extends OpenAPIRoute {
	schema = {
		tags: ['Vinyl', 'Crate'],
		summary: "INSERT or UPDATE a VinylRecord in DJ's collection",
		request: {
			params: z.object({
				userID: Num(),
				versionID: Num(),
				item: Num().optional(),
			})},
		responses: {
			"200": {
				description: "Returns the added vinyl to the user's collection",
				content: {
					"application/json": {
						description: "A success JSON response with the collection item's metadata.",
						schema: z.object({
              success: Bool(),
              vinyl: VinylRecord,
						}),
					"text/html": {
						description: "HTMX fragment for success adding a vinyl record " +
							"to the user's collection.",
						schema: Str(),
					}
        }},
			"404": {
				description: "The user or release version could not be found, " +
					"nothing was added to the collection.",
				content: {
					schema: Str().describe("HTMX fragment with error message")
				}},
		}}}

	async handle(c: WorkerContext) {
		const data = await this.getValidatedData<typeof this.schema>();
		const { userID, versionID, item } = data.params;
		
		// Retrieve the validated request body
		const vinylToAdd = {};

		// Return the newly added vinyl record.
		return {
			success: true,
			userID: userID,
			versionID: versionID,
			item: item,
      vinyl: vinylToAdd,
		};
	}
}