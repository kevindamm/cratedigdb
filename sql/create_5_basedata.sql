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
-- github:kevindamm/cratedigdb/sql/create_5_basedata.sql

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

-- These format values and their descriptions are based on the Formats List at
-- https://www.discogs.com/help/formatslist, accompanying Description keywords
-- and commetns are also defined there.
INSERT INTO MediaFormatEnum
         ("format_abbr",        "format",             "comments")
  VALUES ("Vinyl",              "Vinyl",              "")
       , ("Cass",               "Cassette",           "Compact Cassette, often referred to as audio cassette, cassette tape, or simply cassette, the most widespread and successful magnetic tape sound recording format. 0.15&quot; wide, plays at 1 7/8 ips. Has two sets of stereo tracks, the tape is turned over to access the second side.")
       , ("CD",                 "CD",                 "Compact Disc")
       , ("CDr",                "CDr",                "Recordable Compact Disc")
       , ("File",               "File",               "For any listed computer file based format description.")
       , ("Acetate",            "Acetate",            "Only to be used for production runs, not for one offs.")
       , ("Flexi",              "Flexi-disc",         "Also known as sound-sheets (sono shito) in Japan.")
       , ("Lathe",              "Lathe Cut",          "Only to be used for production runs, not for one offs.")
       , ("Shellac",            "Shellac",            "")
       , ("Mighty Tiny",        "Mighty Tiny",        "2.25 &quot; discs with proprietary features that make them unplayable on any other plays except the ones made by the company. ")
       , ("Sopic",              "Sopic",              "Drink coaster sized records that are recessed and designed for a unique player to index on top them.")
       , ("Pathé Disc",         "Pathé Disc",         "Pathé discs were unlike any others. The grooves were cut vertically into the discs, rather than the more common lateral method. The grooves were wider than that used by any other company, requiring a special ball-shaped .005&quot;-radius (0.13 mm) stylus to track them. The discs rotated at 90 rpm, rather than 78 or 80. The recordings started on the inside near the center of the disc, spiralling out to the edge rather than vice-versa.")
       , ("Edison Disc",        "Edison Disc",        "(also 'Diamond Disc') A type of record marketed by Edison Records from 1912 to 1929. The 10&quot; disc play at 80 RPM, weigh ten ounces, and are 1/4&quot; thick.")
       , ("Cyl",                "Cylinder",           "")
       , ("CDV",                "CDV",                "CD Video, a hybrid format. LaserDisc-format video with CD-format audio on the same side of a single disc. Not the same as Video CD!")
       , ("DVD",                "DVD",                "")
       , ("DVDr",               "DVDr",               "Recordable DVD")
       , ("HD DVD",             "HD DVD",             "The HD DVD disc was designed to be the successor to the standard DVD format. It can store about three times as much data as its predecessor (15 GB per layer instead of 4.7 GB)")
       , ("HD DVD-R",           "HD DVD-R",           "")
       , ("Blu-ray",            "Blu-ray",            "The name Blu-ray Disc is derived from the blue-violet laser used to read and write this type of disc. Because of its shorter wavelength, substantially more data can be stored on a Blu-ray Disc than on the DVD format. A Blu-ray Disc can store 25 GB on each layer, as opposed to a DVD's 4.7 GB.")
       , ("Blu-ray-R",          "Blu-ray-R",          "See Blu-ray")
       , ("Ultra HD Blu-ray",   "Ultra HD Blu-ray",   "")
       , ("SACD",               "SACD",               "Super Audio CD")
       , ("4-Trk",              "4-Track Cartridge",  "")
       , ("8-Trk",              "8-Track Cartridge",  "")
       , ("DC-International",   "DC-International",   "Short-lived audio cassette format developed by Teldec, Germany")
       , ("Elcaset",            "Elcaset",            "")
       , ("PlayTape",           "PlayTape",           "Two track tape cartridge using &frac18;&quot; tape")
       , ("RCA Tape Cartridge", "RCA Tape Cartridge", "Early 5 &times; 7.125&quot; tape cartridge format developed by RCA which was on the market approximately from 1958 to 1964.")
       , ("DAT",                "DAT",                "Digital Audio Tape")
       , ("DCC",                "DCC",                "Digital Compact Cassette")
       , ("M/cass",             "Microcassette",      "")
       , ("NT",                 "NT Cassette",        "Digital micro cassette format introduced by Sony in 1992")
       , ("Pocket Rocker",      "Pocket Rocker",      "Small cartridge format with 2 tracks on an infinite loop")
       , ("Revere Magnetic Stereo Tape Ca", "Revere Magnetic Stereo Tape Ca", "A short lived (1962- approx 1965) tape cartridge format for the 3M Revere M-2 tape cartridge machine - https://obsoletemedia.org/revere-stereo-tape-cartridge/")
       , ("Tefifon",            "Tefifon",            "")
       , ("Reel",               "Reel-To-Reel",       "")
       , ("Sabamobil",          "Sabamobil",          "Early German tape cartridge format introduced by Saba in 1964 intended for automotive use.")
       , ("Betacam",            "Betacam",            "")
       , ("Betacam SP",         "Betacam SP",         "")
       , ("Beta",               "Betamax",            "")
       , ("Cartrivision",       "Cartrivision",       "An analog videocassette format introduced in 1972, and the first format to offer feature films for consumer rental.")
       , ("MiniDV",             "MiniDV",             "(a.k.a. S-size or small cassettes) Intended for amateur use, but became accepted in professional productions as well. MiniDV cassettes are used for recording baseline DV, DVCAM as well as HDV.")
       , ("S-VHS",              "Super VHS",          "")
       , ("Umatic",             "U-matic",            "An analog recording videocassette format, among the first video formats to contain the videotape inside a cassette. Originally intended to be a consumer format, but wasn't successful. It was picked up for use in professional applications such as TV.")
       , ("VHS",                "VHS",                "")
       , ("V2000",              "Video 2000",         "")
       , ("Video8",             "Video8",             "Video8 was launched in the 1980s, into a market dominated by the VHS-C and Betamax formats. Video8 had one major advantage over the full-size competition. Thanks to their compact size, Video8 camcorders were small enough to hold in the palm of the user's hand. pre-recorded &quot;Video 8&quot; tapes were made by Sony in the '80s/'90s ")
       , ("Film",               "Film Reel",          "")
       , ("HitClips",           "HitClips",           "")
       , ("Laserdisc",          "Laserdisc",          "")
       , ("S/Vision",           "SelectaVision",      "A video playback system developed by RCA using specialized Capacitance Electronic Disc (CED) media, in which video and audio could be played back on a TV using a special analog needle and high-density groove system similar to phonograph records. The format was commonly known as &quot;videodisc&quot;, leading to much confusion with Laserdisc format, which is mutually incompatible with this format.")
       , ("TeD",                "TeD",                "Television Disc - Video disc format released by Telefunken in 1975")
       , ("VHD",                "VHD",                "A videodisc format which was marketed predominantly in Japan by JVC, abbreviated from &quot;Video High Density&quot;. They are 25 cm discs enclosed in a plastic caddy, with up to 60 minutes of video per side. At the end of the side, the disc can be turned over.")
       , ("Wire",               "Wire Recording",     "Early recording format where audio is magnetically recorded to a metal wire.")
       , ("MD",                 "Minidisc",           "")
       , ("MVD",                "MVD",                "Multimedia Versatile Disc. Short lived optical disc format launched in Korea around 2002.")
       , ("UMD",                "UMD",                "Universal Media Disc. An optical disc medium developed by Sony for use on the PlayStation Portable. It can hold up to 1.8 gigabytes of data, which can include games, movies, music, or a combination thereof.")
       , ("Floppy",             "Floppy Disk",        "")
       , ("Zip Disk",           "Zip Disk",           "Floppy disk format available in 100, 250, and 750mb capacities.")
       , ("M/Stick",            "Memory Stick",       "Used at Discogs as a generic term, mostly found as USB 'flash drive'.")
       , ("Hybrid",             "Hybrid",             "For formats that combine two or more basic formats")
       , ("",                   "All Media",          "Used to add further descriptions to a multi-media release, for example:<br><br>CD<br>2 &times; 12&quot;<br>All Media, Promo<br><br>This tag is not needed when 'Box Set' is used, as the descriptions can be added to the 'Box Set' format in this instance.")
       , ("Box",                "Box Set",            "To note that all media are enclosed in extra packaging. Like &quot;All Media&quot;, Box Set goes on it's own line:<br><br>  5 x LP<br> Box Set")
       ;

INSERT INTO MediaFormatDescriptionEnum
         ("fmt_desc_abbr",   "fmt_desc",             "comments")
  VALUES ("LP",              "LP",                   "The LP tag (used by itself) denotes a 12 inch 33 rpm long-playing record.")
       , ("16&quot;",        "16&quot;",             "Standard size for radio broadcast acetate records")
       , ("12&quot;",        "12&quot;",             "For Laserdiscs")
       , ("11&quot;",        "11&quot;",             "")
       , ("10&quot;",        "10&quot;",             "")
       , ("9&quot;",         "9&quot;",              "")
       , ("8&quot;",         "8&quot;",              "For Laserdiscs")
       , ("8&quot;",         "8&quot;",              "")
       , ("7&quot;",         "7&quot;",              "")
       , ("6&frac12;&quot;", "6&frac12;&quot;",      "")
       , ("6&quot;",         "6&quot;",              "")
       , ("5&frac12;&quot;", "5&frac12;&quot;",      "")
       , ("5&quot;",         "5&quot;",              "For Laserdiscs")
       , ("5&quot;",         "5&quot;",              "")
       , ("4&quot;",         "4&quot;",              "")
       , ("3&frac12;&quot;", "3&frac12;&quot;",      "")
       , ("3&quot;",         "3&quot;",              "")
       , ("2&quot;",         "2&quot;",              "")
       , ("1&quot;",         "1&quot;",              "")
       , ("8 &frac13; RPM",  "",                     "")
       , ("16 &frac23; RPM", "",                     "")
       , ("33 &frac13; RPM", "",                     "")
       , ("45 RPM",          "",                     "")
       , ("78 RPM",          "",                     "Earlier records may run ±15%, i.e. about 66 to 90 RPM; a record cut at a speed in this range is normally called 'a 78'.")
       , ("120 RPM",         "120 RPM",              "")
       , ("21cm",            "",                     "")
       , ("25cm",            "",                     "")
       , ("27cm",            "",                     "")
       , ("29cm",            "",                     "")
       , ("35cm",            "",                     "")
       , ("40cm",            "",                     "")
       , ("50cm",            "",                     "")
       , ("80 RPM",          "",                     "")
       , ("90 RPM",          "",                     "")
       , ("15/16 ips",       "",                     "")
       , ("80 RPM",          "80 RPM",               "")
       , ("",                "1 &frac78; ips",       "ips stands for inches per second")
       , ("",                "15 ips",               "")
       , ("",                "15/16 ips",            "")
       , ("",                "3 &frac34; ips",       "")
       , ("",                "30 ips",               "")
       , ("",                "7 &frac12; ips",       "")
       , ("",                "&frac12;&quot;",       "")
       , ("",                "&frac14;&quot;",       "The most popular open reel to reel tape size")
       , ("",                "&frac18;&quot;",       "")
       , ("2tr Mono",        "2-Track Mono",         "Tape runs in both directions, with a mono track on each side.")
       , ("2tr Stereo",      "2-Track Stereo",       "Tape runs in one direction, as a stereo track.")
       , ("4tr Mono",        "4-Track Mono",         "")
       , ("4tr Stereo",      "4-Track Stereo",       "Tape runs in both directions, with a stereo track on each side.")
       , ("10.5&quot; Reel", "10.5&quot; NAB Reel",  "A 10 &frac12;&quot; reel with a 3&quot; hole in the center that fits onto a NAB hub.")
       , ("3&quot; Reel",    "3&quot; Cine Reel",    "A 3&quot; reel with a hole for a splined &frac14;&quot; shaft in the center.")
       , ("5&quot; Reel",    "5&quot; Cine Reel",    "A 5&quot; reel with a hole for a splined &frac14;&quot; shaft in the center.")
       , ("6&quot; Reel",    "6&quot; Cine Reel",    "A 6&quot; reel with a hole for a splined &frac14;&quot; shaft in the center.")
       , ("7&quot; Reel",    "7&quot; Cine Reel",    "A 7&quot; reel with a hole for a splined &frac14;&quot; shaft in the center.")
       , ("2min",            "2 Minute",             "Oldest type of wax cylinder, with 100 threads per inch, about 4&quot; (10 cm) long, 2&frac14&quot; diameter")
       , ("3min",            "3 Minute",             "")
       , ("4min",            "4 Minute",             "Development of the original cylinder with longer playing time, due to doubling of the number of grooves to 200 threads per inch")
       , ("Concert",         "Concert",              "5&quot; diameter cylinder")
       , ("Salon",           "Salon",                "3 &frac12;&quot; x 4&quot; cylinder from French company Path&eacute;")
       , ("Mini",            "Mini",                 "A disc with a diameter of 8cm (80mm), or approx 3&quot;, can apply to CDs or DVDs.")
       , ("B/card",          "Business Card",        "A business card shaped CD")
       , ("Shape",           "Shape",                "A CD that is shaped differently from the standard circular.")
       , ("Shape",           "Shape",                "A vinyl record that is shaped differently from the standard circular.")
       , ("Minimax",         "Minimax",              "A Miniature CD single with a (usually transparent) built-in 12cm adaptor, which makes it look like a CD equivalent of a &quot;clear vinyl&quot; record, design-wise. Plays on all CD players, like a normal CD. Also called Fan Disc, AB-CD, and Semi-Substrate disc.")
       , ("Minimax",         "Minimax",              "A Miniature DVD single with a (usually transparent) built-in 12cm adaptor, which makes it look like a DVD equivalent of a &quot;clear vinyl&quot; record, design-wise. Plays on all DVD players, like a normal DVD.")
       , ("CD-ROM",          "CD-ROM",               "A CD holding computer data, as opposed to a CD holding audio data that can be played back in an ordinary CD player. Use CD, Enhanced for 'mixed mode' CDs that have both audio and data sections of the disc.")
       , ("CDi",             "CDi",                  "CD Interactive")
       , ("CD+G",            "CD+G",                 "Also known as CD+Graphics, a special audio compact disc that contains graphics data in addition to the audio data on the disc. The disc can be played on a regular audio CD player, but when played on a special CD+G player, can output a graphics signal (typically, the CD+G player is hooked up to a television set or a computer monitor).")
       , ("HDCD",            "HDCD",                 "High Definition Compatible Digital, or HDCD, is an encode-decode process. It encodes the equivalent of 20 bits worth of data in a 16-bit digital audio signal by using custom dithering, filters, and some reversible amplitude and gain encoding. There is a benefit at the expense of a minor increase in noise. HDCD encoding places a control signal in the least significant bit of a small subset of the 16-bit Red Book audio samples. If no decoder is present, the disc will be played as a regular CD.")
       , ("VCD",             "VCD",                  "Video CD or VCD, or Compact Disc digital video, is a standard digital format for storing video. View CDs, as VCDs are sometimes referred to, are playable in dedicated players, personal computers, and many DVD players. Not the same as CDV (CD Video)!")
       , ("AVCD",            "AVCD",                 "Audio Video CD. Audio tracks are playable on the regular CD player, the video tracks are playable on a VCD player, DVD player, or PC.")
       , ("SVCD",            "SVCD",                 "Super Video CD, a format used for storing video on standard compact discs. SVCD falls between Video CD and DVD in terms of technical capability and picture quality.")
       , ("XRCD",            "XRCD",                 "Extended Resolution Compact Disc")
       , ("12&quot;",        "12&quot;",             "")
       , ("5&quot;",         "5&quot;",              "")
       , ("8&quot;",         "8&quot;",              "")
       , ("4K",              "4K",                   "")
       , ("8K",              "8K",                   "")
       , ("Blu-ray-A",       "Blu-ray Audio",        "")
       , ("Multichannel",    "Multichannel",         "")
       , ("DVD-A",           "DVD-Audio",            "Only to be used when the release shows the DVD-Audio logo.")
       , ("DVD-D",           "DVD-Data",             "")
       , ("DVD-V",           "DVD-Video",            "Only to be used when the release shows the DVD-Video logo.")
       , ("Hybrid",          "Hybrid",               "A version of SACD (Super Audio CD) that contains a CD layer as well as a SACD layer, and if therefore playable on normal CD players as well as SACD players.")
       , ("Multichannel",    "Multichannel",         "")
       , ("AAC",             "AAC",                  "Advanced Audio Coding, was designed as an improved-performance codec relative to MP3")
       , ("AIFC",            "AIFC",                 "A compressed variant of AIFF, also known as AIFF-C, with various defined compression codecs.")
       , ("AIFF",            "AIFF",                 "Audio Interchange File Format (AIFF) is a uncompressed pulse-code modulation (PCM) file.")
       , ("ALAC",            "ALAC",                 "Apple Lossless (also known as Apple Lossless Encoder, ALE, or Apple Lossless Audio Codec, ALAC) is an audio codec developed by Apple Inc. for lossless data compression of digital music.  Apple Lossless data is stored within an MP4 container with the filename extension .m4a – this extension is also used by Apple for AAC audio data in an MP4 container (same container, different audio encoding). ")
       , ("AMR",             "AMR",                  "Adaptive Multi-Rate audio codec")
       , ("APE",             "APE",                  "Monkey's Audio lossless compression algorithm.")
       , ("AVI",             "AVI",                  "Audio Video Interleaved (also Audio Video Interleave), known by its initials AVI, is a multimedia container format introduced by Microsoft in November 1992 as part of its Video for Windows technology. AVI files can contain both audio and video data in a file container that allows synchronous audio-with-video playback. Like the DVD video format, AVI files support multiple streaming audio and video, although these features are seldom used. Most AVI files also use the file format extensions develop")
       , ("DFF",             "DFF",                  "Direct Stream Digital (DSD) encoded file")
       , ("Image",           "Disc Image",           "Use with the specific file type in the free text field (ex. ISO). Use for DVD-V/DVD_A/BD-V/BD-A images only.")
       , ("DSF",             "DSF",                  "Direct Stream Digital (DSD) encoded file")
       , ("FLAC",            "FLAC",                 "Free Lossless Audio Codec (FLAC) is a popular file format for audio data compression. Being a lossless compression format, FLAC does not remove information from the audio stream, as do lossy compression formats such as MP3 and AAC.")
       , ("FLV",             "FLV",                  "Flash Video is a container file format used to deliver video over the Internet. Flash Video content may also be embedded within SWF files. There are two different video file formats: FLV and F4V. The audio and video data within FLV files are encoded in the same way as they are within SWF files. The latter F4V file format is based on the ISO base media file format.")
       , ("MOV",             "MOV",                  "Apple Quicktime Movie (MOV)")
       , ("",                "MP2",                  "")
       , ("MP3",             "MP3",                  "")
       , ("MPEG Video",      "MPEG Video",           "MPEG encoded video file.")
       , ("MPEG-4 Video",    "MPEG-4 Video",         "For any video in an MPEG-4 container. For MPEG-4 audio, please see AAC and ALAC ")
       , ("ogg",             "ogg-vorbis",           "")
       , ("Opus",            "Opus",                 "")
       , ("RA",              "RA",                   "RealAudio encoded file")
       , ("RM",              "RM",                   "RealMedia encoded file.")
       , ("SHN",             "SHN",                  "Shorten file format")
       , ("SPX",             "SPX",                  "(Speex) Lossy audio compression codec specifically tuned for the reproduction of human speech.")
       , ("SWF",             "SWF",                  "(originally standing for "Small Web Format", later changed to "Shockwave Flash", then changed back to Small Web Format) (pronounced swiff or "swoof") - a partially open repository for multimedia and especially for vector graphics. Intended to be small enough for publication on the web, SWF files can contain animations or applets of varying degrees of interactivity and function.")
       , ("TTA",             "TTA",                  "True Audio (TTA) is a lossless compressor for multichannel 8, 16 and 24 bits audio data.")
       , ("WAV",             "WAV",                  "A Microsoft and IBM audio file format standard for storing audio. WAVs are compatible with Windows and Macintosh operating systems.")
       , ("WavPack",         "WavPack",              "")
       , ("WMA",             "WMA",                  "Windows Media Audio (WMA) is a proprietary compressed audio file format developed by Microsoft. It was initially a competitor to the MP3 format, but with the introduction of Apple's iTunes Music Store, it has positioned itself as a competitor to the Advanced Audio Coding format used by Apple.")
       , ("WMV",             "WMV",                  "Windows Media Video (WMV) is a compressed video file format for several proprietary codecs developed by Microsoft. The original codec, known as WMV, was originally designed for Internet streaming applications, as a competitor to RealVideo. The other codecs, such as WMV Screen and WMV Image, cater for specialized content. ")
       , ("MP3Sur",          "MP3 Surround",         "")
       , ("3,5&quot;",       "3.5&quot;",            "3.5&quot; Floppy Disk")
       , ("5.25&quot;",      "5.25&quot;",           "5.25&quot; Floppy Disk")
       , ("CD-Record",       "CD-Record",            "CDr - Lathe Cut hybrid disc.")
       , ("DualDisc",        "DualDisc",             "Features an audio layer similar to a CD  on one side and a standard DVD layer on the other.")
       , ("DVDplus",         "DVDplus",              "An optical disc storage technology that combines the technology of DVD and CD in one disc. A DVD and a CD-compatible layer are bonded together to provide a multi-format hybrid disc.")
       , ("VinylDisc",       "VinylDisc",            "A combination of a digital layer, either in CD or DVD format, and an analogue layer which is a vinyl record ")
       , ("D/Sided",         "Double Sided",         "")
       , ("S/Sided",         "Single Sided",         "For two sided tapes that only have audio on one side. Please note this tag is not to be used when the release has the same audio on both sides. In this case, please enter the tracklisting for both sides, and explain in the release notes that the audio is identical on both sides. See the <a href="http://www.discogs.com/help/submission-guidelines-release-trk.html#Same_Audio_On_Different_Sides">full guidelines here</a>.")
       , ("S/Sided",         "Single Sided",         "For cassettes that are blank on one side")
       , ("S/Sided",         "Single Sided",         "For Laserdiscs.")
       , ("S/Sided",         "Single Sided",         "")
       , ("S/Sided",         "Single Sided",         "For two sided vinyl that only have audio on one side. Please note this tag is not to be used when the release has the same audio on both sides. In this case, please enter the tracklisting for both sides, and explain in the release notes that the audio is identical on both sides. See the <a href="http://www.discogs.com/help/submission-guidelines-release-trk.html#Same_Audio_On_Different_Sides">full guidelines here</a>.")
       , ("Advance",         "Advance",              "Advance releases are sometimes issued prior to a release date to reviewers and other industry professionals. These are usually issued without artwork and are generally only feature the artist name, title, track listing, label, proposed release date, and/or promotional contact.")
       , ("Album",           "Album",                "Album tag usage has no relation to speed, media type, media item count (e.g. tracks spread over multiple 12&quot;s) or use of the Compilation tag (whether for Various or single artist releases). This tag is only to be used where it is clear the item was released as such.")
       , ("MiniAlbum",       "Mini-Album",           "Only to be used where it is clear the item was released as a Mini-Album and not for any short-form album release.")
       , ("EP",              "EP",                   "Only to be used where it is clear the item was released as an EP, regardless of number of tracks or overall length.")
       , ("Maxi",            "Maxi-Single",          "Only to be used where it is clear the item was released as a Maxi-Single.")
       , ("RSD",             "Record Store Day",     "For use with Record Store Day releases.")
       , ("Single",          "Single",               "Only to be used where it is clear the item was released as a Single.")
       , ("Comp",            "Compilation",          "")
       , ("",                "Stereo",               "Most music formats are stereo. This tag can be used for any stereo item, and must be used when the item was released in stereo and mono formats, or is otherwise necessary to point out.")
       , ("Mono",            "Mono",                 "")
       , ("Quad",            "Quadraphonic",         "A four speaker surround format. It had a number of different encoding methods, some of which were incompatible with each other. CD-4 / Compatible Discrete 4 / Quadradisc, UD-4 / UMX, Q4, Quad-8 / Quadraphonic 8-Track, SQ / Surround Quadraphonic / Stereo Quadraphonic, QS / Quadraphonic Stereo, EV / Stereo-4, DY / Dynaquad, Matrix H, Passive Pseudo Quad, Pseudo-surround sound.")
       , ("Amb",             "Ambisonic",            "")
       , ("Bioplastic",      "Bioplastic",           "For discs made from Bioplastics")
       , ("Card",            "Card Backed",          "For card and paper backed Flexi-discs")
       , ("Club",            "Club Edition",         "")
       , ("Copy Prot.",      "Copy Protected",       "For CDs")
       , ("Copy Prot.",      "Copy Protected",       "For Computer Media.")
       , ("Copy Prot.",      "Copy Protected",       "For DVDs.")
       , ("Copy Prot.",      "Copy Protected",       "For Video Tape.")
       , ("Dlx",             "Deluxe Edition",       "Only items that have this printed on them somewhere (stickers etc), or were originally marketed by the label as such, should be tagged as this.")
       , ("Enh",             "Enhanced",             "This includes formats sometimes known as &quot;Enhanced CD&quot;, &quot;Mixed Mode&quot;, and &quot;CD Extra&quot; where the music carrier (CD, vinyl, cassette, etc) also contains computer data in the form of software programs, videos, screen savers, music (tracker files, MP3s, etc), text, web links, games, and so forth.")
       , ("Etch",            "Etched",               "A record that has artwork or writing etched onto it in an artistic manner. Not to be used for the standard catalog number, matrix number, pressing plant's name, mastering engineers name, and other basic run out groove etches.")
       , ("Jukebox",         "Jukebox",              "Any item labeled as being released for the jukebox market. This item should only be used when it is clear the item was released as such, for example it is explicitly mentioned on the release, or by the label, artist, or other reliable source.")
       , ("Ltd",             "Limited Edition",      "This tag should only be used when the term &quot;limited&quot; or &quot;limited edition&quot; is specifically displayed on the release (media and/or packaging), or if this terminology is used by a reliable source in the promotion and marketing of the release. Do not use the tag &quot;Limited Edition&quot; when terms such as &quot;One-Time-Pressing&quot; or &quot;Print Run of Only xxx copies&quot; without the term &quot;Limited&quot; appear on the release or by reliable sources.")
       , ("MP",              "Mispress",             "Notes that the audio on a medium that is replicated by pressing (CD, vinyl etc) is incorrect in some way (usually, the wrong tracks). ")
       , ("M/Print",         "Misprint",             "Indicates that there is an error in the printed material on the release (labels, CD booklets etc), for example, indicating wrong track listings etc. There must be a corrected version of the release for this tag to be used.")
       , ("Mixed",           "Mixed",                "Continuous mix, DJ mix, segued audio. Use this tag if all of the tracks are mixed together into one continuous flow, for example DJ Mix CDs, mixtapes etc. Most of the time, using this tag calls for a 'DJ Mix' credit.")
       , ("Mixtape",         "Mixtape",              "Only to be used where it is clear the item was released as a mixtape.")
       , ("Num",             "Numbered",             "Only to be used where it is clear the item was released as a numbered (limited) release.")
       , ("P/Mixed",         "Partially Mixed",      "For releases that only have a part of them segued.")
       , ("P/Unofficial",    "Partially Unofficial", "To indicate that only some tracks on the release are unofficial. Use the notes to give further explanation.")
       , ("Pic",             "Picture Disc",         "For Laserdiscs.")
       , ("Pic",             "Picture Disc",         "")
       , ("Promo",           "Promo",                "Promotional copy.  Only add this tag if it is explicitly mentioned on the release. Some releases from the 60s and 70s may be marked as 'Demonstration', the Promo tag is correct to apply to these as well (but do not confuse this with 'demo' self releases by artists to demonstrate their work).")
       , ("RE",              "Reissue",              "")
       , ("RM",              "Remastered",           "This tag should only be used where it is clear the item was released as such, for example it is explicitly mentioned on the release, or by the label, artist, or other reliable source.")
       , ("RP",              "Repress",              "")
       , ("Smplr",           "Sampler",              "In English, &quot;sampler&quot; has a different meaning from &quot;Compilation&quot;, a sampler is a free or low-priced preview of a larger release(s). Although in other languages the two words may mean the same thing, in Discogs they should not be confused.")
       , ("",                "Special Cut",          "Used to denote releases with locked grooves, parallel grooves, backward grooves, &quot;banded for radio play&quot;, etc. Release notes are required to provide further information.")
       , ("S/Edition",       "Special Edition",      "Only items that have this printed on them somewhere (stickers etc), or were originally marketed by the label as such, should be tagged as &quot;Special Edition&quot;.")
       , ("Styrene",         "Styrene",              "For discs made from Styrene.")
       , ("TP",              "Test Pressing",        "Typically a limited run of a record made to test the sound quality. Only list an item as a Test Pressing if the release is clearly marked as such.")
       , ("Tour",            "Tour Recording",       "Use when there are multiple live concert recordings issued by the artist/their label recorded during the same tour. These releases may or may not be part of a series, but should have some form of thematic similarity otherwise.")
       , ("Transcription",   "Transcription",        "This tag is for releases licensed to radio stations for public broadcast which were not sold to the general public.")
       , ("Unofficial",      "Unofficial Release",   "")
       , ("W/Lbl",           "White Label",          "Center labels on a vinyl release without proper print on both sides. Additional marks with a rubber stamp, small printed sticker, or handwritten on an otherwise blank (but not necessarily white) label would still generally be considered a White Label release.")
       , ("16mm",            "16mm",                 "")
       , ("35mm",            "35mm",                 "")
       , ("Multichannel",    "Multichannel",         "Used to note any digital surround type format, use the free text to give specifics if possible.")
       , ("Multichannel",    "Multichannel",         "For CDs.")
       , ("Multichannel",    "Multichannel",         "For DVDs.")
       , ("Multichannel",    "Multichannel",         "For HD-DVD")
       , ("Multichannel",    "Multichannel",         "For Hybrids.")
       , ("Multichannel",    "Multichannel",         "For Laserdisc.")
       , ("Multichannel",    "Multichannel",         "For other video formats.")
       , ("Multichannel",    "Multichannel",         "For SelectaVision.")
       , ("Multichannel",    "Multichannel",         "For Video Tape.")
       , ("NTSC",            "NTSC",                 "For CDs.")
       , ("NTSC",            "NTSC",                 "")
       , ("NTSC",            "NTSC",                 "For DVDs.")
       , ("NTSC",            "NTSC",                 "For Hybrids.")
       , ("NTSC",            "NTSC",                 "For Laserdisc.")
       , ("NTSC",            "NTSC",                 "For other video formats.")
       , ("NTSC",            "NTSC",                 "For SelectaVision.")
       , ("NTSC",            "NTSC",                 "For Video Tape.")
       , ("PAL",             "PAL",                  "For CDs.")
       , ("PAL",             "PAL",                  "")
       , ("PAL",             "PAL",                  "For DVDs.")
       , ("PAL",             "PAL",                  "For Hybrids.")
       , ("PAL",             "PAL",                  "For Laserdisc.")
       , ("PAL",             "PAL",                  "For other video formats.")
       , ("PAL",             "PAL",                  "For SelectaVision.")
       , ("PAL",             "PAL",                  "For Video Tape.")
       , ("SECAM",           "SECAM",                "For CDs.")
       , ("SECAM",           "SECAM",                "For DVDs.")
       , ("SECAM",           "SECAM",                "For Hybrids.")
       , ("SECAM",           "SECAM",                "For Laserdisc.")
       , ("SECAM",           "SECAM",                "For other video formats.")
       , ("SECAM",           "SECAM",                "For SelectaVision.")
       , ("SECAM",           "SECAM",                "For Video Tape.")

--
-- "UNKNOWN" representations
--

INSERT INTO UserAccounts
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
