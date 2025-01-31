-- database: /path/to/database.db
-- SQL statements for creating all tables in the cratedig database
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
-- github:kevindamm/cratedigdb/sql/create_orders.sql

-- 
-- Database TABLE and INDEX definitions for reflecting the CC0 data of Discogs.
--
--   [---------]
--   | Artists ]
--   [---------]                            [--------]
--        |                                 | Labels |
--        |     N..N  [----------]          [--------]
--        \-----------| Releases |               | 1..1
--                    [----------]               |
--                         |                     |
--                         |      1..N  [-----------------]
--                         \------------| ReleaseVersions |
--                                      [-----------------]
--                                                     |
--                                                     \------[ Tracks ]
--
--
-- These tables are in SQLite3 syntax/semantics, that is the flavor imposed by
-- Cloudflare D1 (as RDBMS for Workers) and easily interfaced with using golang.
-- 
-- Because of that, each table has an implicit _ROWID_ column:
-- https://www.sqlite.org/lang_createtable.html#rowid
-- In tables where the rowid is used as the parent column of a FOREIGN KEY
-- relationship, a named column is created which acts as an alias for it.
--

-- An enum table for the latest status of voting on data quality
-- for artist profiles, releases, release versions and labels.
CREATE TABLE IF NOT EXISTS "DataQuality" (
    "dqID"    INTEGER
      PRIMARY KEY

  -- These values are constant and defined in ./*basedata.sql
  , "quality"  TEXT
      CHECK (quality IN ("Needs Vote"
                       , "Entirely Incorrect"
                       , "Entirely Incorrect Edit"
                       , "Needs Major Changes"
                       , "Needs Minor Changes"
                       , "Correct"
                       , "Disagreement"
                       , "Complete And Correct"
           ))
  , "summary"  TEXT
      NOT NULL
);

-- ImageData reflects a path to where the asset can be found and some metadata.
-- The ID of this record is used to add images to artists, labels and releases.
CREATE TABLE IF NOT EXISTS "ImageData" (
    "imageID"   INTEGER
      PRIMARY KEY
  , "filepath"  TEXT
      NOT NULL

  , "filetype"  TEXT
  , "width"     INTEGER
      CHECK (width is NULL OR width > 0)
  , "height"    INTEGER
      CHECK (height is NULL OR height > 0)
);

CREATE TABLE IF NOT EXISTS "Genres" (
    "genreID"  INTEGER
      PRIMARY KEY
  , "genre"    TEXT
      NOT NULL
);

CREATE TABLE IF NOT EXISTS "Styles" (
    "styleID"  INTEGER
      PRIMARY KEY
  , "style"    TEXT
      NOT NULL
);


--
-- ARTISTS AND GROUPS
--
--             *artistID
--   [---------]          [--------------------]    +index[GroupMember__Group]
--   | Artists |==========| Artist_GroupMember |---|
--   [---------]    N..N  [--------------------]    +index[GroupMember__Member]
--       |                                 +name
--       |
--       |-------[Artist_URLs] +index[URL__Artist]
--       |
--       |------[Artist_Names] +index[Name__Artist]
--       |
--       |------[Artist_Alias] +index[Alias__Artist]
--       |
--       \----[Artist_Avatars]
--

CREATE TABLE IF NOT EXISTS "Artists" (
    "artistID"      INTEGER
      PRIMARY KEY
  , "name"          TEXT  
      NOT NULL  -- Artist name variations (ANV) are found in Artist_Names
  , "realname"      TEXT
    -- If NULL, real name is unknown or artist is not an individual.

  , "profile"       TEXT
      NOT NULL    DEFAULT ""

  , "data_quality"  INTEGER
      NOT NULL    DEFAULT 0
      REFERENCES  DataQuality (dqID)
      ON DELETE   RESTRICT
      ON UPDATE   RESTRICT
);


CREATE TABLE IF NOT EXISTS "Artist_GroupMembers"(
    "group_artistID"   INTEGER
      NOT NULL
      REFERENCES  Artists (artistID)
      ON DELETE   CASCADE
  , "member_artistID"  INTEGER
      NOT NULL
      REFERENCES  Artists (artistID)
      ON DELETE   CASCADE

  , "member_name"      TEXT
      NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS "GroupMembers__Unique"
  ON Artist_GroupMembers (group_artistID, member_artistID);

CREATE INDEX IF NOT EXISTS "GroupMember__Group"
  ON Artist_GroupMembers (group_artistID);
CREATE INDEX IF NOT EXISTS "GroupMember__Member"
  ON Artist_GroupMembers (member_artistID);


-- There may be zero, one or many URLs associated with an artist ID.
CREATE TABLE IF NOT EXISTS "Artist_URLs" (
    "artistID"  INTEGER
      NOT NULL
      REFERENCES  Artists (artistID)
      ON DELETE   CASCADE
  , "url"       TEXT
      NOT NULL
);

CREATE INDEX IF NOT EXISTS "URL__Artist"
  ON Artist_URLs (artistID);


-- ANVs are about naming confusions (or conventions), as opposed to aliases.
CREATE TABLE IF NOT EXISTS "Artist_Names" (
    "artistID"  INTEGER
      NOT NULL
      REFERENCES  Artists (artistID)
      ON DELETE   CASCADE
  , "name"      TEXT
      NOT NULL
);

CREATE INDEX IF NOT EXISTS "Name__Artist"
  ON Artist_Names (artistID);


-- Aliases are about performers who intentionally go by different identities.
CREATE TABLE IF NOT EXISTS "Artist_Alias" (
    "artistID"         INTEGER
      NOT NULL
      REFERENCES  Artists (artistID)
      ON DELETE   CASCADE
  , "alias_name"       TEXT
      NOT NULL

  , "alias_artist_id"  INTEGER
      -- aliases may also link artists across artist IDs
      REFERENCES  Artists (artistID)
);

CREATE INDEX IF NOT EXISTS "Alias__Artist"
  ON Artist_Alias (artistID);


-- Gives the path, type and size of an artist's profile picture.
CREATE TABLE IF NOT EXISTS "Artist_Avatars" (
    "artistID"  INTEGER
      NOT NULL
      REFERENCES  Artists (artistID)
      ON DELETE   CASCADE
  , "imageID"   INTEGER
      NOT NULL
      REFERENCES  ImageData (imageID)
      ON DELETE   CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "Artist_Avatar__Unique"
  ON Artist_Avatars (artistID, imageID);


--
-- RECORD LABELS
--
--            *labelID
--   [--------]
--   | Labels |----- +index[Label__Parent]
--   [--------]
--       |
--       |-------[Label_URLs] +index[URL__Label]
--       |
--       \----[Label_Avatars] +unique[labelID, imageID]
--

CREATE TABLE IF NOT EXISTS "Labels" (
    "labelID"       INTEGER
      PRIMARY KEY
  , "name"          TEXT
      NOT NULL
      CHECK       (name <> "")
  
  , "contact"       TEXT
  , "profile"       TEXT

  , "parentID"      INTEGER
      REFERENCES  Labels (labelID)
      ON DELETE   CASCADE
  , "parent_name"   TEXT

  , "data_quality"  INTEGER
      NOT NULL    DEFAULT 0
      REFERENCES  DataQuality (dqID)
      ON DELETE   RESTRICT
      ON UPDATE   RESTRICT
);

CREATE INDEX IF NOT EXISTS "Label__Parent"
  ON Labels (parentID);


CREATE TABLE IF NOT EXISTS "Label_URLs" (
    "labelID"  INTEGER
      NOT NULL
      REFERENCES  Labels (labelID)
      ON DELETE   CASCADE
  , "url"      TEXT
      NOT NULL
);

CREATE INDEX IF NOT EXISTS "URL__Label"
  ON Label_URLs (labelID);


CREATE TABLE IF NOT EXISTS "Label_Avatars" (
    "labelID"  INTEGER
      NOT NULL
      REFERENCES  Labels (labelID)
      ON DELETE   CASCADE
  , "imageID"  INTEGER
      NOT NULL
      REFERENCES  ImageData (imageID)
);

CREATE UNIQUE INDEX IF NOT EXISTS "Label_Avatar__Unique"
  ON Label_Avatars (labelID, imageID);


--
-- RELEASES
--
--              *releaseID
--   [----------]
--   | Releases |-----\ *main_version
--   [----------]     |
--       |            \---[ ReleaseVersions ]
--       |             
--       |
--       |                    +index[Release__Artist]
--       |---[Release_Artist] +index[Artist__Release]
--       |
--       |----[Release_Video] +index[Video__Release]
--       |
--       |----[Release_Genre] +index[Genre__Release]
--       |
--       \----[Release_Style] +index[Style__Release]
--

CREATE TABLE IF NOT EXISTS "Releases" (
    "releaseID"     INTEGER
      PRIMARY KEY

  , "title"         TEXT
      NOT NULL
  , "year"          INTEGER
  , "main_version"  INTEGER
      NOT NULL    DEFAULT 0
      -- (defined below, after ReleaseVersions table is created)
      -- REFERENCES    ReleaseVersions (versionID)

  , "data_quality"  INTEGER
      NOT NULL    DEFAULT 0
      REFERENCES  DataQuality (dqID)
      ON DELETE   RESTRICT
      ON UPDATE   RESTRICT
);

CREATE TABLE IF NOT EXISTS "Release_Artists" (
    "releaseID"    INTEGER
      NOT NULL
      REFERENCES Releases (releaseID)
  , "artistID"     INTEGER
      NOT NULL
      REFERENCES Artists (artistID)

  , "artist_name"  TEXT
  , "anv"          TEXT
  
  , "index"        INTEGER
  , "role"         TEXT
);

CREATE INDEX IF NOT EXISTS "Artist__Release"
  ON Release_Artists (releaseID);
CREATE INDEX IF NOT EXISTS "Release__Artist"
  ON Release_Artists (artistID);


CREATE TABLE IF NOT EXISTS "Release_Videos" (
    "releaseID"    INTEGER
      NOT NULL
      REFERENCES  Releases (releaseID)
  , "url"          TEXT
      NOT NULL

  , "duration_s"   INTEGER
  , "title"        TEXT
  , "description"  TEXT
);

CREATE INDEX IF NOT EXISTS "Video__Release"
  ON Release_Videos (releaseID);


CREATE TABLE IF NOT EXISTS "Release_Genres" (
    "releaseID"  INTEGER
      NOT NULL
      REFERENCES   Releases (releaseID)
  , "genreID"    INTEGER
      NOT NULL
      REFERENCES   Genres (genreID)

  , PRIMARY KEY ("releaseID", "genreID")
) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "Genre__Release"
  ON Release_Genres (releaseID);


CREATE TABLE IF NOT EXISTS "Release_Styles" (
    "releaseID"  INTEGER
      NOT NULL
      REFERENCES   Releases (releaseID)
  , "styleID"    INTEGER
      NOT NULL
      REFERENCES   Styles (styleID)

  , PRIMARY KEY ("releaseID", "styleID")
) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "Style__Release"
  ON Release_Styles (releaseID);


CREATE TABLE IF NOT EXISTS "Release_CoverArt" (
    "releaseID"  INTEGER
      NOT NULL
      REFERENCES   Releases (releaseID)
  , "imageID"    INTEGER
      NOT NULL
      REFERENCES   Images (imageID)

  , PRIMARY KEY ("releaseID", "imageID")
) WITHOUT ROWID;

CREATE UNIQUE INDEX IF NOT EXISTS "Release_CoverArt__Unique"
  ON Release_CoverArt (releaseID, imageID);

--
-- RELEASE VERSIONS
--
--                     *versionID
--   [-----------------]
--   | ReleaseVersions |-------------\
--   [-----------------]             |
--       |       |                   |     *releaseID
--       |       |               [ Release ]
--       |       |
--       |   [ Tracks ]--- +index[ReleaseVersion__TrackNumber]
--       |       |
--       |       \--------[ TrackArtists ]
--       |
--       |                                +index[ReleaseVersion__Artist]
--       |-------[ReleaseVersion_Artists] +index[Artist__ReleaseVersion]
--       |                                +index[ReleaseVersion__Label]
--       |--------[ReleaseVersion_Labels] +index[Label__ReleaseVersion]
--       |                                +index[ReleaseVersion__Company]
--       |-----[ReleaseVersion_Companies] +index[Company__ReleaseVersion]
--       |
--       |--------[ReleaseVersion_Genres] +index[Genre__ReleaseVersion]
--       |--------[ReleaseVersion_Styles] +index[Style__ReleaseVersion]
--       |-------[ReleaseVersion_Formats] +index[Format__ReleaseVersion]
--       |---[ReleaseVersion_Identifiers] +index[Identifier__ReleaseVersion]
--       |--------[ReleaseVersion_Videos] +index[Video__ReleaseVersion]
--       \------[ReleaseVersion_CoverArt] +index[unique(releaseID, imageID)]
--

CREATE TABLE IF NOT EXISTS "ReleaseVersions" (
    "versionID"     INTEGER
      PRIMARY KEY
  , "releaseID"     INTEGER
      NOT NULL
      REFERENCES  Releases (releaseID)
      ON DELETE   CASCADE

  --TODO

  , "data_quality"  INTEGER
      NOT NULL    DEFAULT 0
      REFERENCES  DataQuality (dqID)
      ON DELETE   RESTRICT
      ON UPDATE   RESTRICT
);

-- Add the FK relation for each release's main version.
ALTER TABLE Releases
  ADD CONSTRAINT "releases_fk_main_version"
  FOREIGN KEY (main_version)
  REFERENCES ReleaseVersions (versionID)
  ;

CREATE INDEX IF NOT EXISTS "ReleaseVersion__Release"
  ON ReleaseVersions (releaseID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Artists" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "Artist__ReleaseVersion"
  ON ReleaseVersion_Artists (versionID);
CREATE INDEX IF NOT EXISTS "ReleaseVersion__Artist"
  ON ReleaseVersion_Artists (artistID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Labels" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "Label__ReleaseVersion"
  ON ReleaseVersion_Labels (versionID);
CREATE INDEX IF NOT EXISTS "ReleaseVersion__Label"
  ON ReleaseVersion_Labels (labelID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Genres" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "Genre__ReleaseVersion"
  ON ReleaseVersion_Genres (versionID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Styles" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "Style__ReleaseVersion"
  ON ReleaseVersion_Styles (versionID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Formats" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "Format__ReleaseVersion"
  ON ReleaseVersion_Formats (versionID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Tracks" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "Track__ReleaseVersion"
  ON ReleaseVersion_Tracks (versionID);
CREATE INDEX IF NOT EXISTS "Track__Tracklist"
  ON ReleaseVersion_Tracks (sequenceID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_TrackArtists" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "TrackArtist__ReleaseVersion"
  ON ReleaseVersion_TrackArtists (versionID);
CREATE INDEX IF NOT EXISTS "TrackArtist__Track"
  ON ReleaseVersion_TrackArtists (trackID);
CREATE INDEX IF NOT EXISTS "TrackArtist__Tracklist"
  ON ReleaseVersion_TrackArtists (tracklist);
CREATE INDEX IF NOT EXISTS "TrackArtist__Artist"
  ON ReleaseVersion_TrackArtists (artistID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Identifiers" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "Identifier__ReleaseVersion"
  ON ReleaseVersion_Identifiers (versionID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Videos" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "Video__ReleaseVersion"
  ON ReleaseVersion_Videos (versionID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Companies" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "Company__ReleaseVersion"
  ON ReleaseVersion_Companies (versionID);
CREATE INDEX IF NOT EXISTS "ReleaseVersion__Company"
  ON ReleaseVersion_Companies (companyID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_CoverArt" (
  --TODO
);

CREATE INDEX IF NOT EXISTS "ReleaseVersion_CoverArt__Unique"
  ON ReleaseVersion_CoverArt (releaseID, imageID)
