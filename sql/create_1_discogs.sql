-- SQL statements for creating all discogs-related CrateDig DB tables.
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
-- github:kevindamm/cratedigdb/sql/create_1_discogs.sql

-- 
-- Database TABLE and INDEX definitions for reflecting the CC0 data of Discogs.
--
--   [---------]
--   | Artists ]
--   [---------]                            [--------]
--     * A   A                              | Labels |
--     | |   |  N..N  [----------]          [--------]
--     | |   '--------| Releases |               A 1..1
--     | |            [----------]               |
--     | | N..N            A                     |
--     | |                 | 1..N       [-----------------]
--     | '-----------------+============| ReleaseVersions |
--     |                                [-----------------]
--     | N..1             N..1              *        *  *
--     '-------[ Tracks ]-------------------/        |  |
--                                                   |  |
--                                      [ Genres ]---/  |
--                                         [ Styles ]---/           
--
-- The tables are grouped in the following order:
--   Enumerationss & Assets
--   Artists
--   Labels
--   Releases
--   ReleaseVersions
--
-- These tables are in SQLite3 syntax/semantics, that is the flavor imposed by
-- Cloudflare D1 (as RDBMS for Workers) and easily interfaced with using golang.
-- 
-- Because of that, each table has an implicit _ROWID_ column:
-- https://www.sqlite.org/lang_createtable.html#rowid
-- In tables where the rowid is used as the parent column of a FOREIGN KEY
-- relationship, a named column is created which acts as an alias for it.
--

--
-- ENUMERATIONS
--
-- Data Quality, Genres, Styles
--

-- An enum table for the latest status of voting on data quality
-- for artist profiles, releases, release versions and labels.
CREATE TABLE IF NOT EXISTS "DataQuality" (
    "dqID"     INTEGER
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

-- Enumeration of media formats, attributed to releases.
-- The Primary Key is arbitrary, it matches insertion order.
CREATE TABLE IF NOT EXISTS "MediaFormats" (
    "formatID"  INTEGER
      PRIMARY KEY
  , "format"    TEXT
      NOT NULL
);

-- Enumeration of genres, attributed to releases.
-- The Primary Key is arbitrary, it matches insertion order.
CREATE TABLE IF NOT EXISTS "Genres" (
    "genreID"  INTEGER
      PRIMARY KEY
  , "genre"    TEXT
      NOT NULL
);

-- Enumeration of styles, attributed to releases and individual tracks.
-- The Primary Key is arbitrary, it matches insertion order.
CREATE TABLE IF NOT EXISTS "Styles" (
    "styleID"  INTEGER
      PRIMARY KEY
  , "style"    TEXT
      NOT NULL
);

--
-- ASSETS
--

-- ImageData reflects a path to where the asset can be found and some metadata.
-- The ID of this record is used to add images to artists, labels and releases.
CREATE TABLE IF NOT EXISTS "ImageData" (
    "imageID"   INTEGER
      PRIMARY KEY
  , "obj_path"  TEXT         -- path in object storage, e.g. R2, GCS or S3
      NOT NULL               -- relative to the bucket where images are stored
      CHECK (obj_path <> "") -- must be non-null and non-empty.
  , "obj_sha1"  BINARY(20)   -- indexed, but uniqueness is enforced via review.

  , "filetype"  TEXT
  , "width"     INTEGER
      CHECK (width is NULL OR width > 0)
  , "height"    INTEGER
      CHECK (height is NULL OR height > 0)
);

CREATE INDEX IF NOT EXISTS "Image__SHA1"
  ON ImageData (obj_sha1)
  WHERE (obj_sha1 IS NOT NULL)
  ;

--
-- ARTISTS AND GROUPS
--
--             *artistID
--   [---------]          [--------------------]    +index[GroupMember__Group]
--   | Artists |==========| Artist_GroupMember |---|
--   [---------]    N..N  [--------------------]    +index[GroupMember__Member]
--       |                                +name
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


-- An artist may be a group or an individual, or an individual in a group.
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

  , PRIMARY KEY ("group_artistID", "member_artistID")
) WITHOUT ROWID;

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
  ON Artist_Alias (artistID)
  ;


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
  
  , PRIMARY KEY ("artistID", "imageID")
) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "Avatar__Artist"
  ON Artist_Avatars (artistID)
  ;

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
      CHECK (name <> "")
  
  , "contact"       TEXT
  , "profile"       TEXT

  , "parentID"      INTEGER
      REFERENCES      Labels (labelID)
      DEFERRABLE      INITIALLY DEFERRED
      ON DELETE       CASCADE
      ON UPDATE       RESTRICT
  , "parent_name"   TEXT

  , "data_quality"  INTEGER
      NOT NULL        DEFAULT 0
      REFERENCES      DataQuality (dqID)
      ON DELETE       RESTRICT
      ON UPDATE       RESTRICT
);

CREATE INDEX IF NOT EXISTS "Label__Parent"
  ON Labels (parentID);


CREATE TABLE IF NOT EXISTS "Label_URLs" (
    "labelID"   INTEGER
      NOT NULL
      REFERENCES  Labels (labelID)
      ON DELETE   CASCADE
  , "url"       TEXT
      NOT NULL
);

CREATE INDEX IF NOT EXISTS "URL__Label"
  ON Label_URLs (labelID);


CREATE TABLE IF NOT EXISTS "Label_Avatars" (
    "labelID"   INTEGER
      NOT NULL
      REFERENCES  Labels (labelID)
      ON DELETE   CASCADE
  , "imageID"   INTEGER
      NOT NULL
      REFERENCES  ImageData (imageID)
      ON DELETE   CASCADE

  , PRIMARY KEY ("labelID", "imageID")
) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "Label_Avatar__Label"
  ON Label_Avatars (labelID)
  ;
CREATE INDEX IF NOT EXISTS "Label_Avatar__Image"
  ON Label_Avatars (imageID)
  ;


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
--       |                    +index[Artist__Release]
--       |---[Release_Artist] +index[Release__Artist]
--       |
--       |----[Release_Video] +index[Video__Release]
--       |                    +index[Release_Genre]
--       |----[Release_Genre] +index[Genre__Release]
--       |                    +index[Release_Style]
--       \----[Release_Style] +index[Style__Release]
--

CREATE TABLE IF NOT EXISTS "Releases" (
    "releaseID"     INTEGER
      PRIMARY KEY

  , "title"         TEXT
      NOT NULL
      CHECK (title <> "")
  , "year"          INTEGER
  , "main_version"  INTEGER
      NOT NULL        DEFAULT 0
      -- (FK defined below, after ReleaseVersions table is created)
      -- REFERENCES   ReleaseVersions (versionID)

  , "data_quality"  INTEGER
      NOT NULL        DEFAULT 0
      REFERENCES      DataQuality (dqID)
      ON DELETE       RESTRICT
      ON UPDATE       RESTRICT
);

CREATE TABLE IF NOT EXISTS "Release_Artists" (
    "releaseID"    INTEGER
      NOT NULL
      REFERENCES     Releases (releaseID)
  , "artistID"     INTEGER
      NOT NULL
      REFERENCES     Artists (artistID)

  , "ordering"     INTEGER
  , "artist_name"  TEXT
  , "role"         TEXT

  , PRIMARY KEY ("releaseID", "artistID")
) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "Artist__Release"
  ON Release_Artists (releaseID)
  ;
CREATE INDEX IF NOT EXISTS "Release__Artist"
  ON Release_Artists (artistID)
  ;


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
  ON Release_Genres (releaseID)
  ;
CREATE INDEX IF NOT EXISTS "Release__Genre"
  ON Release_Genres (genreID)
  ;


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
  ON Release_Styles (releaseID)
  ;
CREATE INDEX IF NOT EXISTS "Release__Style"
  ON Release_Styles (styleID)
  ;


--
-- RELEASE VERSIONS
--
--                     *versionID
--   [-----------------]
--   | ReleaseVersions |-------------\
--   [-----------------]             |
--       |       |                   |     *releaseID
--       |       |               [ Release ]--- +index[ReleaseVersion__Release]
--       |       |
--       |   [ Tracks ]--- +index[ReleaseVersion__TrackNumber]
--       |       |
--       |       \--------[ TrackArtists ]
--       |
--       |                                +index[ReleaseVersion__Artist]
--       |-------[ReleaseVersion_Artists] +index[Artist__ReleaseVersion]
--       |                                +index[ReleaseVersion__Label]
--       |--------[ReleaseVersion_Labels] +index[Label__ReleaseVersion]
--       |
--       |--------[ReleaseVersion_Genres] +index[Genre__ReleaseVersion]
--       |-------[ReleaseVersion_Formats] +index[Format__ReleaseVersion]
--       \------[ReleaseVersion_CoverArt] +index[unique(releaseID, imageID)]
--

-- A specific variation or edition or pressing of a release.
CREATE TABLE IF NOT  EXISTS "ReleaseVersions" (
    "versionID"      INTEGER
      PRIMARY KEY
  , "releaseID"      INTEGER
      NOT NULL
      REFERENCES       Releases (releaseID)
      ON DELETE        CASCADE

  , "title"          TEXT
      NOT NULL
  , "year_released"  NUMBER  -- year of release
  , "country"        TEXT    -- country this version was released in
  , "notes"          TEXT

  , "data_quality"   INTEGER
      NOT NULL         DEFAULT 0 -- "needs vote"
      REFERENCES       DataQuality (dqID)
      ON DELETE        RESTRICT
      ON UPDATE        RESTRICT
);

-- Add the FK relation for each Release's main version.
ALTER TABLE Releases
  ADD CONSTRAINT "releases_fk_main_version"
  FOREIGN KEY (main_version)
  REFERENCES ReleaseVersions (versionID)
  DEFERRABLE  INITIALLY DEFERRED
  ;

CREATE INDEX IF NOT EXISTS "ReleaseVersion__Release"
  ON ReleaseVersions (releaseID)
  ;

CREATE INDEX IF NOT EXISTS "ReleaseVersion__Year"
  ON ReleaseVersions (year_released)
  ;

-- Many-to-many relation for ReleaseVersions and Artists.
CREATE TABLE IF NOT EXISTS "ReleaseVersion_Artists" (
    "versionID"    INTEGER
      NOT NULL
      REFERENCES     ReleaseVersions (versionID)
  , "artistID"     INTEGER
      NOT NULL
      REFERENCES     Artists (artistID)
  , "is_extra"     BOOLEAN
      NOT NULL       DEFAULT FALSE

  , "ordering"     INTEGER
  , "artist_name"  TEXT
  , "role"         TEXT
  , "tracks"       TEXT
);

CREATE INDEX IF NOT EXISTS "Artist__ReleaseVersion"
  ON ReleaseVersion_Artists (versionID);
CREATE INDEX IF NOT EXISTS "ReleaseVersion__Artist"
  ON ReleaseVersion_Artists (artistID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Labels" (
    "versionID"   INTEGER
      NOT NULL
      REFERENCES    ReleasesVersions (versionID)
      ON DELETE     CASCADE
  , "labelID"     INTEGER
      NOT NULL
      REFERENCES    Labels (labelID)
      ON DELETE     CASCADE
  
  , "label_name"  TEXT  -- this may differ by release versions
      NOT NULL          -- while still being the same label ID
  , "catalog_id"  TEXT  -- (SKU) according to the inventory system of the label
);

CREATE INDEX IF NOT EXISTS "Label__ReleaseVersion"
  ON ReleaseVersion_Labels (versionID);
CREATE INDEX IF NOT EXISTS "ReleaseVersion__Label"
  ON ReleaseVersion_Labels (labelID);


CREATE TABLE IF NOT EXISTS "ReleaseVersion_Genres" (
    "versionID"     INTEGER
      NOT NULL
      REFERENCES  ReleasesVersions (versionID)
      ON DELETE   CASCADE
  , "genreID"       INTEGER
      NOT NULL
      REFERENCES  Genres (genreID)
      ON DELETE   RESTRICT
      ON UPDATE   RESTRICT
  
  , PRIMARY KEY ("versionID", "genreID")
 ) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "Genre__ReleaseVersion"
  ON ReleaseVersion_Genres (versionID);


-- The media format
CREATE TABLE IF NOT EXISTS "ReleaseVersion_Formats" (
    "versionID"    INTEGER
      NOT NULL
      REFERENCES     ReleasesVersions (versionID)
      ON DELETE      CASCADE
  , "formatID"     INTEGER
      NOT NULL
      REFERENCES     Formats (formatID)

  , "quantity"     INTEGER
  , "notes"        TEXT
  , "description"  TEXT
  
  , PRIMARY KEY ("versionID", "formatID")
) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "Format__ReleaseVersion"
  ON ReleaseVersion_Formats (versionID);


-- Each release version can have a few images of pre-defined views:
-- Any or all of {front_sleeve, back_sleeve, media_A, media_B}.
-- Some records could easily have two or three times this many but
-- consider these images as visual assistance, not archival representation.
CREATE TABLE IF NOT EXISTS "ReleaseVersion_CoverArt" (
    "versionID"     INTEGER
      NOT NULL
      CHECK           (versionID <> 0)
      REFERENCES      ReleaseVersions (versionID)
      ON DELETE       CASCADE
  , "front_sleeve"  INTEGER
      NOT NULL
      CHECK           (front_sleeve <> 0)
      REFERENCES      Images (imageID)

  , "back_sleeve"   INTEGER
      REFERENCES      Images (imageID)
  , "media_A"       INTEGER
      REFERENCES      Images (imageID)
  , "media_B"       INTEGER
      REFERENCES      Images (imageID)

  , PRIMARY KEY ("versionID", "front_sleeve")
) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "CoverArt__Version"
  ON ReleaseVersion_CoverArt (versionID)
  ;
CREATE INDEX IF NOT EXISTS "CoverArt__FrontSleeve"
  ON ReleaseVersion_CoverArt (front_sleeve)
  ;
CREATE INDEX IF NOT EXISTS "CoverArt__BackSleeve"
  ON ReleaseVersion_CoverArt (back_sleeve)
  WHERE (back_sleeve <> 0)
  ;
CREATE INDEX IF NOT EXISTS "CoverArt__MediaA"
  ON ReleaseVersion_CoverArt (media_A)
  WHERE (media_A <> 0)
  ;
CREATE INDEX IF NOT EXISTS "CoverArt__MediaB"
  ON ReleaseVersion_CoverArt (media_B)
  WHERE (media_B <> 0)
  ;


--
-- TRACKS AND TRACKLISTS
--
-- Tracks have two relational tables -- one for the Release tracklists and one
-- for the ReleaseVersion tracklists.  These can also be copied into a user's
-- playlist which has a similar structure with an extra `userID` parameter.
--
-- While populating the DB, the release playlist is the main version's playlist
-- and duplicate lists are allowed.  The redundancies can be cleaned up in an
-- offline batch process that looks at each release's versions' tracklists.

CREATE TABLE IF NOT EXISTS "Tracks" (
    "trackID"       INTEGER
      PRIMARY KEY
  , "versionID"     INTEGER
      NOT NULL
      REFERENCES      ReleaseVersions (versionID)
      ON DELETE       CASCADE
  , "track_number"  INTEGER
      NOT NULL

  , "title"         TEXT
      NOT NULL
      CHECK (title <> "")
  , "duration"      TEXT
);

CREATE UNIQUE INDEX IF NOT EXISTS "Track__Unique"
  ON ReleaseVersion_Tracks (versionID, track_number)
  ;
CREATE INDEX IF NOT EXISTS "Track__Tracklist"
  ON ReleaseVersion_Tracks (versionID)
  ;


-- There may be multiple artists for a specific track.
-- These may repeat some of the artists of the release.
CREATE TABLE IF NOT EXISTS "Track_Artists" (
    "trackID"       INTEGER
      NOT NULL
      REFERENCES      Tracks (trackID)
      ON DELETE       CASCADE
  , "artistID"      INTEGER
      NOT NULL
      REFERENCES      Artists (artistID)
      ON DELETE       CASCADE
  , "is_extra"      BOOLEAN
      NOT NULL        DEFAULT FALSE

  , "name"          TEXT
  , "role"          TEXT

  , PRIMARY KEY ("trackID", "artistID")
) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "Arist__Track"
  ON Track_Artists (trackID)
  ;
CREATE INDEX IF NOT EXISTS "Track__Artist"
  ON Track_Artists (artistID)
  ;

-- A track may have additional styles that the release on a whole does not have.
CREATE TABLE IF NOT EXISTS "Track_Styles" (
    "trackID"       INTEGER
      NOT NULL
      REFERENCES      Tracks (trackID)
      ON DELETE       CASCADE
  , "styleID"       INTEGER
      NOT NULL
      REFERENCES      Styles (styleID)
      ON DELETE       RESTRICT

  , PRIMARY KEY ("trackID", "styleID")
) WITHOUT ROWID;

CREATE INDEX IF NOT EXISTS "Track__Style"
  ON Track_Styles (styleID)
  ;
CREATE INDEX IF NOT EXISTS "Style__Track"
  ON Track_Styles (trackID)
  ;
