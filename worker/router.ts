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
import { WorkerContext } from './context'

//import {
//  AddVinylRecord,
//	RemoveVinylRecord,
//	FetchVinylRecord
//} from './api/vinyl'
//import {
//	CreateVinylListing,
//	FetchVinylListing,
//	ListVinylListings,
//	UpsertVinylListing,
//	DeleteVinylListing
//} from './api/listing'
//import {
//	AddVinylCrate,
//	RemoveVinylCrate,
//	ListVinylCrate
//} from './api/crate'
import { DiscogsSearch } from './api/search'
import { homepage } from './homepage'

// Start a Hono app
const app = new Hono()

// Setup OpenAPI registry
const openapi = fromHono(app, {
  docs_url: '/docs',
})

// OpenAPI endpoints
openapi.get('/search', DiscogsSearch)
//openapi.get('/artist', ListArtists)
//openapi.get('/artist/:artistID', GetArtist)
//openapi.post('/artist/:artistID', UpsertArtist)
//openapi.delete('/artist/:artistID', DeleteArtist)

//openapi.get('/release', ListReleases)
//openapi.get('/release/:releaseID', GetRelease)
//openapi.post('/release/:releaseID', UpsertRelease)
//openapi.delete('/release/:releaseID', DeleteRelease)

//openapi.get('/record', ListReleases)
//openapi.get('/record/:releaseID', GetRelease)
//openapi.post('/record/:releaseID', UpsertRelease)
//openapi.delete('/record/:releaseID', DeleteRelease)

//openapi.get('/vinyl/:username', ListCollection)
//openapi.post('/vinyl/:username/:versionID', AddVinylRecord)
//openapi.post('/vinyl/:username/:versionID/:item', AddVinylRecord)

// Middleware and non-API paths.
app.get('/', homepage)

// The Hono app fully implements the Workers API.
export default app
