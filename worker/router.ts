import { fromHono } from "chanfana";
import { Hono } from "hono";

// Start a Hono app
const app = new Hono();

// Setup OpenAPI registry
const openapi = fromHono(app, {
	docs_url: "/spec",
});

// TODO Register OpenAPI endpoints

// Export the Hono app
export default app;
