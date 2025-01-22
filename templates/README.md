# HTMX Templates

HTMX pages and fragments for the client frontend, encoded as Pug.

These files describe the client UI for interacting with the service.  They are
used by both the Cloudflare Workers implementation (see [/workers](../workers))
and by the golang+Echo implementation (see [/service](../service) and [/cmd/server](../cmd/server)).

All files with the extension `.htmx` are intended to be used as fragments of
hypertext, and files with the extension `.html` are full pages or intended as
a layout definition.  Whenever either is intended for use as a template,
Jade/Pug syntax is adopted, using [Pug (js)](https://pugjs.org/) and
[Jade (golang)](https://github.com/Joker/jade) for their fast template engines.

*Note: Pug was formerly known as Jade, hence the naming confusion, but they do
inherently use the same template syntax.*


## Building

There is no build step.  The templates are interpreted at runtime, and bundled
as part of the build steps for the Workers and Echo implementations.  See their
respective READMEs for details.


## Why two consumers of the same templates?

The Workers implementation is the primary focus while I build out the tool and
register my inventory, but the golang implementation is intended as a portable
and self-hostable solution, something that may even serve a purpose in my later
years or facilitate the person resposible for that slice of my estate.  I don't
know how far into the future that might be, so I'm planning for the golang
implementation to be resilient enough to technology change, and design it to be
self-contained as a single file.

Also, in the course of evaluating different serving technologies for SaaS
hosting, I found myself implementing this basic inventory-like application,
and my vinyl collection is the most practical thing for me to be inventorying,
so it just kind of worked out that I have more than one implementation, too.

## Why Pug?

It's fast, and I wanted to be able to build out fragments of HTMX, populated
from the database or from discogs/musicbrainz/spotify search results.  I wasn't
sure that something like golang's html/template would be portable enough to use
in TypeScript and Workers, but I also didn't need heavyweight features, I would
prefer that all nontrivial logic is easier to have in the code so that it
doesn't find its way into the templates.

## Why HTMX?

This actually started as a SPA-like webapp because I wanted to learn the ropes
of React and Vue.  I'm still interested in using Vue3 but HATEOS is so much more
aligned with the functionality of CRUD apps and the manipulations of inventory,
ontology, collections, etc.  The fact that it's whitespace-driven and minimalist
in syntax wasn't a motivating factor, but it wasn't a deal-breaker either.

There is a JSON API provided by the Workers implementation, too, but even if I
take this project commercially I don't expect to provide support for that API
and am not including it in the golang/Echo implementation's design.
