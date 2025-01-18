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
// github:kevindamm/cratedig/worker/discogs.ts

/**
 * Constants and string messages based on Discogs API documentation & F.A.Q.
 **/

// Typical (expected) value for the `Accept:` header in requests.
const ACCEPT_V2 = 'application/vnd.discogs.v2.html+json'

// Identifying type for expected HTTP error codes in discogs API.
class ResponseStatus {
  message: string = ''

  constructor(
    readonly code: number,
    readonly name: string,
    readonly details: string
  ) {}

  is_success(): boolean {
    return this.code >= 200 && this.code <= 299
  }
}

// Standard success response code, body contains resource.
const DISCOGS_200_OK = new ResponseStatus(
  200,
  "OK",
  "The request was successful, and the requested data is provided in the response body."
)

// Find ID of newly-created resource in response body.
const DISCOGS_201_CONTINUE = new ResponseStatus(
  201,
  "Continue",
  "You've sent a POST request to a list of resources to create a new one. The ID of the newly-created resource will be provided in the body of the response."
)

// Success with empty body.
const DISCOGS_204_NO_CONTENT = new ResponseStatus(
  204,
  "No Content",
  "The request was successful, and the server has no additional information to convey, so the response body is empty."
)

// Must authenticate with OAuth first.
const DISCOGS_401_UNAUTHORIZED = new ResponseStatus(
  401,
  "Unauthorized",
  "You're attempting to access a resource that first requires authentication."
)

// Cannot access this resource, even if authenticated.
const DISCOGS_403_FORBIDDEN = new ResponseStatus(
  403,
  "Forbidden",
  "You're not allowed to access this resource. Even if you authenticated, or already have, you simply don’t have permission."
)

// The requested resource cannot be found.
const DISCOGS_404_NOT_FOUND = new ResponseStatus(
  404,
  "Not Found",
  "The resource you requested doesn't exist."
)

// HTTP method being used isn't allowed on this resource.
const DISCOGS_405_METHOD_NOT_ALLOWED = new ResponseStatus(
  405,
  "Method Not Allowed",
  "You're trying to use an HTTP verb that isn't supported by the resource."
)

// There's something missing or mis-typed in the request or resource.
const DISCOGS_422_UNPROCESSABLE_ENTITY = new ResponseStatus(
  422,
  "Unprocessable Entity",
  "Your request was well-formed, but there's something semantically wrong with the body of the request. This can be due to malformed JSON, a parameter that’s missing or the wrong type, or trying to perform an action that doesn't make any sense."
)

// Discogs had an issue, usually results in forwarding that along, but maybe not forwarding the error body.
const DISCOGS_500_INTERNAL_ERROR = new ResponseStatus(
  500,
  "Internal Server Error",
  "Something went wrong (with Discogs) while attempting to process your request."
)

// Utility function for expanding to the above response details object from the error status.
function status_from_code(code: number): ResponseStatus {
  const STATUS_FROM_CODE: Record<number, ResponseStatus> = {
    200: DISCOGS_200_OK,
    201: DISCOGS_201_CONTINUE,
    204: DISCOGS_204_NO_CONTENT,
    401: DISCOGS_401_UNAUTHORIZED,
    403: DISCOGS_403_FORBIDDEN,
    404: DISCOGS_404_NOT_FOUND,
    405: DISCOGS_405_METHOD_NOT_ALLOWED,
    422: DISCOGS_422_UNPROCESSABLE_ENTITY,
    500: DISCOGS_500_INTERNAL_ERROR,
  }
  return STATUS_FROM_CODE[code]
}
