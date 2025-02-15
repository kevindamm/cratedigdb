# TypeScript and Zod types for CrateDig DB

Used by both the backend (Workers) and frontend (Vue3 + TS) to represent vinyl
records, their abstract release, user accounts, the existence in a user's
collection (i.e., "crates") and listings on a marketplace.

Data Quality of the metadata and Grading of the physical copies are also
detailed here in types and value constraints.

## Reuse with alternative clients

If you want to build your own frontend interface to the same CrateDig backend
(or your own instance of this project in Workers, or self-hosted) you can use
these types (install `@cratedigdb/types`) in your frontend as a basic interlingua,
and the openapi spec as reference for the protocol definition.
