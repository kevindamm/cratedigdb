-- SQL statements for dropping all tables in the cratedig database.
-- Copyright (c) 2025, Kevin Damm
-- All rights reserved.
-- MIT License:
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--
-- github:kevindamm/cratedig/sql/drop_tables.sql

-- DROP (if exists) all TABLE definitions.
-- Drop these after dropping the indices.

-- TODO (drop ledger tables)

-- drop collection tables
DROP TABLE IF EXISTS "VinylTagging";
DROP TABLE IF EXISTS "TagNames";
DROP TABLE IF EXISTS "VinylItems";
DROP TABLE IF EXISTS "Crates";
DROP TABLE IF EXISTS "Grading";
DROP TABLE IF EXISTS "UserProfiles";

-- drop discogs tables
DROP TABLE IF EXISTS "Track_Styles";
DROP TABLE IF EXISTS "Track_Artists";
DROP TABLE IF EXISTS "Tracks";

DROP TABLE IF EXISTS "ReleaseVersion_CoverArt";
DROP TABLE IF EXISTS "ReleaseVersion_Formats";
DROP TABLE IF EXISTS "ReleaseVersion_Genres";
DROP TABLE IF EXISTS "ReleaseVersion_Labels";
DROP TABLE IF EXISTS "ReleaseVersion_Artists";
DROP TABLE IF EXISTS "ReleaseVersions";

DROP TABLE IF EXISTS "Release_Styles";
DROP TABLE IF EXISTS "Release_Genres";
DROP TABLE IF EXISTS "Release_Videos";
DROP TABLE IF EXISTS "Release_Artists";
DROP TABLE IF EXISTS "Releases";

DROP TABLE IF EXISTS "Label_Avatars";
DROP TABLE IF EXISTS "Label_URLs";
DROP TABLE IF EXISTS "Labels";

DROP TABLE IF EXISTS "Artist_Avatars";
DROP TABLE IF EXISTS "Artist_Alias";
DROP TABLE IF EXISTS "Artist_Names";
DROP TABLE IF EXISTS "Artist_URLs";
DROP TABLE IF EXISTS "Artist_GroupMembers";
DROP TABLE IF EXISTS "Artists";

DROP TABLE IF EXISTS "ImageData";
DROP TABLE IF EXISTS "Styles";
DROP TABLE IF EXISTS "Genres";
DROP TABLE IF EXISTS "MediaFormats";
DROP TABLE IF EXISTS "DataQuality";
