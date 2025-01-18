# **cratedig:** Vinyl Collection 

Implemented on Cloudflare Workers + D1 + R2 + Vectorize.

A media collection index as a Cloudflare Worker with OpenAPI 3.1 using
[chanfana](https://github.com/cloudflare/chanfana) and
[Hono](https://github.com/honojs/hono).

Generates the `openapi.json` schema automatically from code and validates the
incoming request to the defined parameters or request body.

## Deploying

First, make sure you are logged into cloudflare in your terminal:

```sh
wrangler login
```

Then publish the API to Cloudflare Workers:

```sh
wrangler deploy
```

## Project structure

The router is defined in `router.ts`.

1. Each endpoint has its own file in `api/` with SQL-TypeScript adapters provided in `models/`.
2. User authentication and profiles are managed in `auth/`
3. For more information read the [chanfana documentation](https://chanfana.pages.dev/) and [Hono documentation](https://hono.dev/docs).

## Development

1. Run `wrangler dev` to start a local instance of the API.
2. Open `http://localhost:8787/` in your browser to see the Swagger interface where you can try the endpoints.
3. Changes made in the `src/` folder will automatically trigger the server to reload, you only need to refresh the Swagger interface.
