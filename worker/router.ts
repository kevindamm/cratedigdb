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
// github:kevindamm/cratedig/worker/router.ts

import { fromHono } from 'chanfana'
import { Hono } from 'hono'
import { WorkerContext } from './api/request'
import {
	AddVinylRecord,
	RemoveVinylRecord,
	FetchVinylRecord } from './api/vinyl'
import {
	AddVinylCrate,
	RemoveVinylCrate,
	ListVinylCrate } from './api/crate'
import { SearchForm, SearchResults } from './api/search'

// Start a Hono app
const app = new Hono()

// Setup OpenAPI registry
const openapi = fromHono(app, {
  docs_url: '/spec',
})

// Register OpenAPI endpoints
openapi.get('/search', SearchResults)
openapi.get('/vinyl', ListVinylCrate)

// Specify middleware and non-API paths.
function homepage(): (c: WorkerContext) => Promise<Response> {
	const HOME_HTML = 'hola htmx!'
	return async (c: WorkerContext) => {
		return c.html(HOME_HTML)
	}
}
app.get('/', homepage())

// Export the Hono app
export default app
