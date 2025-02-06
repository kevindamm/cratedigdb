-- SQL statements for populating all initial values in cratedigdb tables.
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
-- github:kevindamm/cratedigdb/sql/create_basedata.sql

-- BASE DATA
-- Contains INSERT statements for initial records and relations.
--
-- ASSUMES TABLES HAVE BEEN CREATED; run other create_*.sql scrpts beforehand.


-- These values based, in part, on the Goldmine Grading Guide at discogs:
-- https://www.discogs.com/selling/resources/how-to-grade-items/
-- except quality, my own approximation based on aggregate calculations, and
-- these quality values may be subject to change, as the algorithm is tuned.
INSERT INTO Grading
         ("gradeID", "grade", "name",    "quality")
  VALUES (0,         "",      "UNKNOWN",        50)
       , (1,         "M",     "Mint",          100)
       , (2,         "NM",    "Near Mint",      90)
       , (3,         "VG+",   "Very Good Plus", 70)
       , (4,         "VG",    "Very Good",      45)
       , (5,         "G+",    "Good Plus",      35)
       , (6,         "G",     "Good",           30)
       , (7,         "F",     "Fair",           10)
       , (8,         "P",     "Poor",            5)
       ;

-- TODO Formats

-- These values are based on the Voting Guidelines for data quality
-- https://www.discogs.com/help/voting-guidelines.html
-- with the numbering of dqID arbitrarily selected by me,
-- the zero-value being chosen intentionally as the sensible default.
--
-- There is an additional entry for submissions with conflicting votes.
-- The summary values (excepting this new entry) are from the above URL.
INSERT INTO DataQuality
    ("dqID", "quality",                 "summary")
  VALUES (0, "Needs Vote",              "There have not been any votes made on the quality of this artist, release or label data.")
	     , (1, "Entirely Incorrect",      "For release, artist or label data that is totally incorrect, or so incomplete or badly entered as to be impossible to judge.")
	     , (2, "Entirely Incorrect Edit", "For updates to the release, artist, or label data that are totally incorrect, or so incomplete or badly entered as to be impossible to judge.")
	     , (3, "Needs Major Changes",     "For release, artist or label data that need some large or important changes to make it correct.")
	     , (4, "Needs Minor Changes",     "For release, artist or label data that needs some small changes to make it correct.")
	     , (5, "Correct",                 "For release, artist or label data that contains good and correct information, up to the minimum standard set in the guidelines.")
	     , (6, "Disagreement",            "Recent conflicting votes about the data quality (Incorrect and Correct), needs consensus.  Does not include requests for edits that arise from changes in the world.")
	     , (7, "Complete And Correct",    "For release, artist or label data that is exemplary.")
       ;

-- These values are based on the Discogs support article about status meanings:
-- https://support.discogs.com/hc/en-us/articles/360007525494
-- with additional entry "Confirmed" for when a shipped item has been received.
--
-- The summaries here are from my paraphrasing of the content there.
-- They have been ordered arbitrarily, but this ordering does typically happen
-- in the sequential order defined here.
INSERT INTO OrderStatus
    ("statusID", "status", "summary")
  VALUES (    0, "Invoice Sent"  -- the default value
               , "An order was made but the buyer has not completed the checkout process and payment has not been sent.")
       , (    1, "Payment Pending"
               , "A payment has been sent but has not yet cleared.  This may depend on the underlying payment method taking some time to clear.")
       , (    2, "Payment Received"
               , "The buyer has made a payment and the payment has cleared with the bank.")
       , (    3, "In Progress"
               , "The seller has received the payment and is preparing the order for shipment.")
       , (    4, "Shipped"
               , "The seller has shipped the order to the buyer.")
       , (    5, "Merged"
               , "This order has been merged with one or more orders with the same buyer.")
       , (    6, "Refund Pending"
               , "The seller has submitted a refund, but the refunded payment is still pending")
       , (    7, "Confirmed"
               , "An item which had been shipped has been confirmed as received by the buyer.")
       , (    8, "Cancelled"
               , "The order has been cancelled, either by the seller or automatically after not receiving a payment.")
       ;


-- "UNKNOWN" representations

INSERT INTO UserProfiles
    ("userID", "username",     "fullname", "date_banned")
  VALUES (  0,  "unknown", "UNKNOWN USER",  "2025-01-23");

INSERT INTO Artists
    ("artistID",    "name", "data_quality")
  VALUES (    0, "unknown",              5);

INSERT INTO Artist_GroupMembers
    ("group_artistID", "member_artistID", "member_name")
  VALUES (          0,                 0,     "unknown");

INSERT INTO Labels
    ("labelID",    "name", "parentID", "data_quality")
  VALUES (   0, "unknown",          0,              5);

INSERT INTO Releases
    ("releaseID",   "title", "data_quality")
  VALUES (     0, "unknown",              5);

INSERT INTO ReleaseVersions
    ("versionID", "releaseID", "title", "data_quality")
  VALUES (     0,           0, "unknown",            5);

INSERT INTO ImageData
    ("imageID", "obj_path")
  VALUES (   0,  "unknown");

-- The folder with crateID=0 is the catch-all which everyone implicitly has,
-- but the vinyl table constraint keeps any item from being explicitly in it.
-- Having it reified here can make client state & some queries a little simpler.
INSERT INTO Crates
    ("crateID", "userID", "name", "slug", "visible")
  VALUES (   0,        0,  "ALL",  "all",      TRUE);
