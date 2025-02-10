# [CrateDig DB](https://github.com/kevindamm/cratedigdb)

Web service for taking inventory of vinyl collections, estimating value (for tax
accounting and insurance) and interfacing with Discogs marketplace.

There are two backend implementations (one in golang using echo and one in
TypeScript for Cloudflare Workers).  They use the same SQL statements and
render the same Pug templates but independently run a router and business logic.
They are implementing the same 

This allows some portability -- the golang service can be packaged as a single
file and include the entire inventory as embedded files within the executable.
It also allows us to measure the economy of running the same workload on a
hosted service vs running with a serverless platform vs running it entirely
locally.

> [!NOTE]
> When the implementations are complete I will post some benchmarks here.


## REST Service endpoints

The Workers implementation uses Chanfana which can emit an openapi schema.

<!-- TODO: include a link to the file or endpoint with the schema -->


## Database representation

The tables are defined in `/sql` as files `create_#_*.sql` where the number
indicates the ordering in which these sets of tables should be created, and
the rest of the filename indicates the type of tables being defined.  There
are also `drop_*.sql` files for dropping the tables in a reasonable
order so that foreign key constraints are not violated, and for dropping all
indices before dropping their tables.

The file contents include detailed comments including box-and-line diagrams
depicting the overall database schema.  The discogs tables are influenced by
the structure of discogs data dumps, with stronger constraints between columns
than what the XML datatypes can represent.  The account and ledger tables are
based on personal utility, mostly, with attention to being compatible with the
metadata in discogs marketplace (especially re: grading and quality terms).
This will make it easier to add the feature of adjusting inventory whenever a
marketplace order completes, so that the local inventory remains up to date
with minimal manual interaction.

It would be possible to fork this toward monitoring discogs market rates and
availability of releases, as long as you stay within the 60 requests-per-minute
rate limiting specified by discogs.  For larger collections this will need to
be carefully managed but that's still 3600 per hour, 86400 per day.  Doable,
especially with a good filter and only checking a few hundreds-thousands of
the most likely valuable items.  Careful that you don't store the marketplace
pricing within your database, though, as only some release/artist/label data
is CC0, the rest (including marketplace data) is not licensed for use.  Any
prices you see in the ledger tables are the offer price (in Listings) and the
sale price (in Orders) of an item that has been purchased.

The release variations (such as different editions of a release or different
colorings, as well as different labels producing it and different masterings)
are normalized so that only non-optional information is in the main table,
as well as having separate tables for each 1-to-many and many-to-many relation.
There is a departure in the naming here from what Discogs uses, their 'masters'
table is represented here as `Releases` and 'releases' is `ReleaseVersions`.
`Artists` and `Labels` are the same in both, and many of the table columns have
INDEX or UNIQUE INDEX built for them.

The database is written in raw SQL rather than using an ORM because it allows
for using the exact same specification between the golang servers and Workers.
This is also why the golang implementation uses sqlite instead of a competing
SQL implementation, but the ability to backup and restore the entire database
with a single file copy makes this very easy to hand over to somebody (which
is also part of the original plan).  This makes it more difficult to perform
migrations but the schemata is pretty detailed and I don't plan on extending
it much or changing any of its existing columns.  I may add a full-text search
but that might only be for the online instance on Workers.


## Developing and deploying

<!-- TODO: include build/test/deploy instructions here. -->
