-- ============================================================
-- Piano Player v5.2  [+50曲追加パック]
-- 既存v5.1のノートデータの後・UIの前に挿入してください
-- または単体ファイルとして使用可能
-- ============================================================

-- ============================================================
-- KEY REFERENCE:
--   Lower: 8=C4 9=D4 0=E4 q=F4 w=G4 e=A4 r=B4
--   Upper: t=C5 y=D5 u=E5 i=F5 o=G5 p=A5 a=B5 s=C6 d=D6 f=E6 g=F6 h=G6
--   Sharp: *=C#4 (=D#4 Q=F#4 W=G#4 E=A#4
--          T=C#5 Y=D#5 I=F#5 O=G#5 P=A#5 S=C#6 D=D#6
-- ============================================================

-- ============================================================
-- WESTERN / POP
-- ============================================================

-- 1. Let It Go (Frozen) - Key: D major, 72 BPM
local notes_let_it_go = {
    -- Verse "The snow glows white on the mountain tonight"
    {time=0.000,key="w"},{time=0.417,key="w"},{time=0.833,key="e"},
    {time=1.250,key="w"},{time=1.667,key="Q"},{time=2.083,key="0"},
    {time=3.333,key="9"},{time=3.750,key="9"},{time=4.167,key="0"},
    {time=4.583,key="9"},{time=5.000,key="8"},{time=5.833,key="9"},
    -- "Not a footprint to be seen"
    {time=6.667,key="w"},{time=7.083,key="w"},{time=7.500,key="e"},
    {time=7.917,key="w"},{time=8.333,key="Q"},{time=8.750,key="w"},
    {time=9.583,key="t"},{time=10.000,key="y"},{time=10.417,key="y"},
    {time=10.833,key="u"},{time=11.250,key="y"},{time=11.667,key="t"},
    {time=12.083,key="r"},{time=12.917,key="t"},
    -- Pre-chorus "Don't let them in"
    {time=13.750,key="u"},{time=14.167,key="u"},{time=14.583,key="i"},
    {time=15.000,key="o"},{time=15.417,key="p"},{time=15.833,key="p"},
    {time=16.250,key="o"},{time=16.667,key="i"},{time=17.083,key="u"},
    {time=17.917,key="u"},{time=18.333,key="i"},{time=18.750,key="o"},
    {time=19.167,key="i"},{time=19.583,key="u"},
    {time=20.000,key="o"},{time=20.417,key="o"},{time=20.833,key="p"},
    {time=21.250,key="o"},{time=21.667,key="i"},{time=22.083,key="o"},
    {time=22.500,key="t"},{time=23.333,key="d"},{time=23.750,key="S"},
    {time=24.167,key="a"},{time=24.583,key="p"},
    -- Chorus "Let it go, let it go"
    {time=26.667,key="p"},{time=27.083,key="o"},{time=27.500,key="u"},
    {time=29.583,key="p"},{time=30.000,key="o"},{time=30.417,key="y"},
    -- "Can't hold it back anymore"
    {time=31.250,key="y"},{time=31.667,key="u"},{time=32.083,key="p"},
    {time=32.500,key="y"},{time=32.917,key="a"},{time=33.333,key="p"},
    -- "Let it go, let it go"
    {time=35.000,key="p"},{time=35.417,key="o"},{time=35.833,key="u"},
    {time=37.917,key="p"},{time=38.333,key="o"},{time=38.750,key="y"},
    -- "Turn away and slam the door"
    {time=39.583,key="y"},{time=40.000,key="u"},{time=40.417,key="p"},
    {time=40.833,key="y"},{time=41.250,key="a"},{time=41.667,key="p"},
    {time=42.083,key="o"},{time=42.500,key="u"},
    -- "I don't care what they're going to say"
    {time=43.333,key="p"},{time=43.750,key="a"},{time=44.167,key="S"},
    {time=44.583,key="d"},{time=46.667,key="S"},{time=47.083,key="a"},
    {time=47.500,key="p"},{time=48.750,key="a"},{time=49.167,key="S"},
    {time=49.583,key="d"},
    -- "Let the storm rage on"
    {time=51.667,key="d"},{time=52.083,key="S"},{time=52.500,key="a"},
    {time=52.917,key="p"},
    -- "The cold never bothered me anyway"
    {time=54.167,key="p"},{time=54.583,key="p"},{time=55.000,key="a"},
    {time=55.417,key="a"},{time=55.833,key="S"},{time=56.250,key="d"},
    {time=57.917,key="S"},{time=58.333,key="a"},{time=58.750,key="p"},
    {time=60.000,key="a"},{time=60.417,key="S"},{time=60.833,key="d"},
}

-- 2. Shape of You (Ed Sheeran) - Key: A minor, 96 BPM
local notes_shape_of_you = {
    -- Intro riff (ascending scale)
    {time=0.000,key="t"},{time=0.313,key="r"},{time=0.625,key="e"},
    {time=0.938,key="w"},{time=1.250,key="q"},{time=1.563,key="0"},
    {time=1.875,key="q"},{time=2.188,key="w"},{time=2.813,key="t"},
    {time=3.125,key="r"},{time=3.438,key="e"},{time=3.750,key="w"},
    {time=4.063,key="q"},{time=4.375,key="0"},{time=4.688,key="q"},
    {time=5.000,key="w"},
    -- Verse
    {time=6.250,key="p"},{time=6.563,key="o"},{time=6.875,key="i"},
    {time=7.188,key="u"},{time=7.500,key="o"},{time=7.813,key="i"},
    {time=8.125,key="u"},{time=8.750,key="t"},
    {time=9.375,key="p"},{time=9.688,key="o"},{time=10.000,key="i"},
    {time=10.313,key="u"},{time=10.625,key="o"},{time=10.938,key="i"},
    {time=11.250,key="u"},{time=11.875,key="t"},
    -- Pre-chorus
    {time=12.500,key="u"},{time=12.813,key="i"},{time=13.125,key="o"},
    {time=13.750,key="p"},{time=14.375,key="o"},{time=14.688,key="i"},
    {time=15.000,key="u"},{time=15.313,key="o"},{time=15.625,key="i"},
    {time=15.938,key="u"},{time=16.563,key="t"},
    -- Chorus "I'm in love with your body" x3
    {time=17.500,key="p"},{time=17.813,key="o"},{time=18.125,key="i"},
    {time=18.438,key="u"},{time=18.750,key="p"},{time=19.063,key="o"},
    {time=19.375,key="i"},{time=19.688,key="u"},{time=20.000,key="y"},
    {time=20.313,key="u"},
    {time=20.625,key="p"},{time=20.938,key="o"},{time=21.250,key="i"},
    {time=21.563,key="u"},{time=21.875,key="p"},{time=22.188,key="o"},
    {time=22.500,key="i"},{time=22.813,key="u"},{time=23.125,key="y"},
    {time=23.438,key="u"},
    {time=23.750,key="p"},{time=24.063,key="o"},{time=24.375,key="i"},
    {time=24.688,key="u"},{time=25.000,key="t"},{time=25.313,key="y"},
    {time=25.625,key="u"},{time=25.938,key="i"},
    -- "I'm in love with the shape of you"
    {time=26.250,key="p"},{time=26.563,key="p"},{time=26.875,key="o"},
    {time=27.188,key="i"},{time=27.500,key="p"},{time=27.813,key="o"},
    {time=28.125,key="i"},{time=28.438,key="u"},
    -- Repeat chorus
    {time=30.000,key="p"},{time=30.313,key="o"},{time=30.625,key="i"},
    {time=30.938,key="u"},{time=31.250,key="p"},{time=31.563,key="o"},
    {time=31.875,key="i"},{time=32.188,key="u"},{time=32.500,key="y"},
    {time=32.813,key="u"},
    {time=33.125,key="p"},{time=33.438,key="o"},{time=33.750,key="i"},
    {time=34.063,key="u"},{time=34.375,key="p"},{time=34.688,key="o"},
    {time=35.000,key="i"},{time=35.313,key="u"},{time=35.625,key="y"},
    {time=35.938,key="u"},
    {time=36.250,key="p"},{time=36.563,key="o"},{time=36.875,key="i"},
    {time=37.188,key="u"},{time=37.500,key="t"},{time=37.813,key="y"},
    {time=38.125,key="u"},{time=38.438,key="i"},
    {time=38.750,key="p"},{time=39.063,key="p"},{time=39.375,key="o"},
    {time=39.688,key="i"},{time=40.000,key="p"},{time=40.313,key="o"},
    {time=40.625,key="i"},{time=40.938,key="u"},
}

-- 3. Someone Like You (Adele) - Key: A major, 67 BPM
local notes_someone_like_you = {
    -- Piano intro arpeggios (A-E-A-C#)
    {time=0.000,key="p"},{time=0.448,key="T"},{time=0.896,key="u"},
    {time=1.345,key="p"},{time=1.793,key="a"},{time=2.241,key="u"},
    {time=2.690,key="T"},{time=3.138,key="p"},
    {time=3.586,key="p"},{time=4.034,key="T"},{time=4.483,key="u"},
    {time=4.931,key="p"},{time=5.379,key="a"},{time=5.828,key="u"},
    {time=6.276,key="T"},{time=6.724,key="p"},
    -- Verse "I heard that you're settled down"
    {time=8.069,key="T"},{time=8.517,key="u"},{time=8.966,key="p"},
    {time=9.414,key="a"},{time=9.862,key="S"},{time=10.310,key="a"},
    {time=10.759,key="p"},
    {time=11.655,key="T"},{time=12.103,key="u"},{time=12.552,key="p"},
    {time=13.000,key="a"},{time=13.448,key="S"},{time=13.897,key="a"},
    {time=14.345,key="p"},{time=14.793,key="u"},
    {time=15.690,key="T"},{time=16.138,key="T"},{time=16.586,key="u"},
    {time=17.034,key="p"},{time=17.483,key="a"},
    {time=18.379,key="S"},{time=18.828,key="a"},{time=19.276,key="p"},
    {time=19.724,key="u"},
    -- Chorus "Never mind I'll find someone like you"
    {time=21.517,key="p"},{time=21.966,key="p"},{time=22.414,key="a"},
    {time=22.862,key="p"},{time=23.310,key="O"},{time=23.759,key="p"},
    {time=24.207,key="I"},{time=24.655,key="u"},{time=25.103,key="T"},
    -- "I wish nothing but the best for you"
    {time=26.897,key="p"},{time=27.345,key="p"},{time=27.793,key="a"},
    {time=28.241,key="p"},{time=28.690,key="O"},{time=29.138,key="p"},
    {time=29.586,key="I"},{time=30.034,key="u"},{time=30.483,key="e"},
    -- "Don't forget me I beg I remember you said"
    {time=32.276,key="p"},{time=32.724,key="p"},{time=33.172,key="a"},
    {time=33.621,key="p"},{time=34.069,key="O"},{time=34.517,key="p"},
    {time=34.966,key="I"},{time=35.414,key="u"},
    -- "Sometimes it lasts in love but sometimes it hurts instead"
    {time=37.207,key="p"},{time=37.655,key="a"},{time=38.103,key="S"},
    {time=38.552,key="d"},{time=39.000,key="S"},{time=39.448,key="a"},
    {time=39.897,key="p"},{time=40.345,key="u"},{time=40.793,key="T"},
    {time=42.586,key="p"},{time=43.034,key="a"},{time=43.483,key="S"},
    {time=43.931,key="d"},{time=44.379,key="S"},{time=44.828,key="a"},
    {time=45.276,key="p"},
    -- Final "Never mind..."
    {time=47.069,key="p"},{time=47.517,key="p"},{time=47.966,key="a"},
    {time=48.414,key="p"},{time=48.862,key="O"},{time=49.310,key="p"},
    {time=49.759,key="I"},{time=50.207,key="u"},{time=50.655,key="T"},
    {time=52.448,key="p"},{time=52.897,key="p"},{time=53.345,key="a"},
    {time=53.793,key="p"},{time=54.241,key="O"},{time=54.690,key="p"},
    {time=55.138,key="I"},{time=55.586,key="u"},{time=56.034,key="e"},
}

-- 4. Rolling in the Deep (Adele) - Key: C minor, 105 BPM
local notes_rolling_in_the_deep = {
    -- Verse intro riff
    {time=0.000,key="t"},{time=0.143,key="t"},{time=0.286,key="t"},
    {time=0.429,key="Y"},{time=0.857,key="o"},{time=1.143,key="o"},
    {time=1.286,key="P"},{time=1.429,key="p"},{time=1.571,key="o"},
    {time=1.714,key="i"},{time=2.000,key="t"},
    {time=2.286,key="t"},{time=2.429,key="t"},{time=2.571,key="t"},
    {time=2.714,key="Y"},{time=3.143,key="o"},{time=3.429,key="o"},
    {time=3.571,key="P"},{time=3.714,key="p"},{time=3.857,key="o"},
    {time=4.000,key="i"},{time=4.286,key="t"},
    -- Verse melody "There's a fire starting in my heart"
    {time=5.143,key="o"},{time=5.429,key="o"},{time=5.714,key="P"},
    {time=5.857,key="p"},{time=6.000,key="o"},{time=6.286,key="i"},
    {time=6.571,key="o"},{time=7.143,key="a"},{time=7.429,key="a"},
    {time=7.714,key="s"},{time=7.857,key="a"},{time=8.000,key="p"},
    {time=8.571,key="p"},{time=8.857,key="o"},{time=9.143,key="i"},
    {time=9.714,key="o"},{time=10.286,key="P"},{time=10.571,key="p"},
    {time=10.857,key="o"},{time=11.143,key="i"},{time=11.429,key="t"},
    -- Pre-chorus "The scars of your love remind me of us"
    {time=12.000,key="o"},{time=12.286,key="p"},{time=12.571,key="a"},
    {time=12.857,key="a"},{time=13.143,key="p"},{time=13.429,key="o"},
    {time=13.714,key="i"},{time=14.286,key="o"},{time=14.571,key="p"},
    {time=14.857,key="a"},{time=15.143,key="a"},{time=15.429,key="p"},
    {time=15.714,key="o"},{time=16.000,key="Y"},
    -- Chorus "We could have had it all"
    {time=17.143,key="t"},{time=17.429,key="P"},{time=17.714,key="o"},
    {time=17.857,key="i"},{time=18.000,key="t"},
    -- "Rolling in the deep"
    {time=18.857,key="t"},{time=19.000,key="Y"},{time=19.143,key="t"},
    {time=19.571,key="t"},{time=19.714,key="P"},{time=19.857,key="o"},
    {time=20.000,key="i"},{time=20.286,key="t"},
    -- "You had my heart inside your hand"
    {time=21.143,key="o"},{time=21.429,key="p"},{time=21.714,key="a"},
    {time=22.000,key="s"},{time=22.286,key="a"},{time=22.571,key="p"},
    {time=22.857,key="o"},{time=23.143,key="i"},
    -- "And you played it to the beat"
    {time=24.000,key="o"},{time=24.286,key="i"},{time=24.571,key="o"},
    {time=24.857,key="P"},{time=25.143,key="o"},{time=25.714,key="i"},
    {time=26.000,key="Y"},
    -- Chorus repeat
    {time=27.143,key="t"},{time=27.429,key="P"},{time=27.714,key="o"},
    {time=27.857,key="i"},{time=28.000,key="t"},
    {time=28.857,key="t"},{time=29.000,key="Y"},{time=29.143,key="t"},
    {time=29.571,key="t"},{time=29.714,key="P"},{time=29.857,key="o"},
    {time=30.000,key="i"},{time=30.286,key="t"},
    {time=31.143,key="o"},{time=31.429,key="p"},{time=31.714,key="a"},
    {time=32.000,key="s"},{time=32.286,key="a"},{time=32.571,key="p"},
    {time=32.857,key="o"},{time=33.143,key="i"},
    {time=34.000,key="o"},{time=34.286,key="i"},{time=34.571,key="o"},
    {time=34.857,key="P"},{time=35.143,key="o"},{time=35.714,key="i"},
    {time=36.000,key="Y"},
    -- Bridge "Throw your soul through every open door"
    {time=37.143,key="s"},{time=37.429,key="a"},{time=37.714,key="p"},
    {time=38.000,key="o"},{time=38.286,key="i"},{time=38.571,key="Y"},
    {time=38.857,key="i"},{time=39.143,key="o"},{time=39.429,key="p"},
    {time=39.714,key="a"},{time=40.000,key="s"},
    {time=40.571,key="s"},{time=40.857,key="a"},{time=41.143,key="p"},
    {time=41.429,key="o"},{time=41.714,key="i"},{time=42.000,key="Y"},
    -- Final chorus
    {time=43.143,key="t"},{time=43.429,key="P"},{time=43.714,key="o"},
    {time=43.857,key="i"},{time=44.000,key="t"},
    {time=44.857,key="t"},{time=45.000,key="Y"},{time=45.143,key="t"},
    {time=45.571,key="t"},{time=45.714,key="P"},{time=45.857,key="o"},
    {time=46.000,key="i"},{time=46.286,key="t"},
}

-- 5. Bohemian Rhapsody (Queen) - Key: C major, 72 BPM
local notes_bohemian_rhapsody = {
    -- "Is this the real life"
    {time=0.000,key="t"},{time=0.833,key="y"},{time=1.250,key="u"},
    {time=1.667,key="i"},{time=2.083,key="u"},{time=2.500,key="y"},
    {time=2.917,key="t"},
    -- "Is this just fantasy"
    {time=3.750,key="t"},{time=4.583,key="y"},{time=5.000,key="u"},
    {time=5.417,key="i"},{time=5.833,key="u"},{time=6.250,key="y"},
    {time=6.667,key="t"},{time=7.083,key="r"},{time=7.500,key="P"},
    {time=7.917,key="p"},
    -- "Caught in a landslide no escape from reality"
    {time=9.167,key="o"},{time=9.583,key="o"},{time=10.000,key="p"},
    {time=10.417,key="o"},{time=10.833,key="p"},{time=11.250,key="p"},
    {time=11.667,key="a"},{time=12.500,key="p"},{time=12.917,key="p"},
    {time=13.333,key="a"},{time=13.750,key="p"},{time=14.167,key="a"},
    {time=14.583,key="s"},{time=15.000,key="a"},{time=15.417,key="p"},
    -- "Open your eyes look up to the skies and see"
    {time=16.667,key="o"},{time=17.083,key="p"},{time=17.500,key="o"},
    {time=17.917,key="i"},{time=18.333,key="o"},{time=18.750,key="p"},
    {time=19.167,key="a"},{time=20.000,key="s"},{time=20.417,key="a"},
    {time=20.833,key="p"},{time=21.250,key="o"},
    -- "I'm just a poor boy I need no sympathy"
    {time=22.500,key="t"},{time=22.917,key="t"},{time=23.333,key="t"},
    {time=23.750,key="t"},{time=24.167,key="o"},{time=24.583,key="o"},
    {time=25.000,key="p"},{time=25.417,key="a"},{time=25.833,key="p"},
    {time=26.250,key="o"},{time=26.667,key="o"},{time=27.083,key="o"},
    {time=27.500,key="i"},{time=27.917,key="u"},
    -- "Mama, just killed a man"
    {time=29.167,key="o"},{time=29.583,key="o"},{time=30.000,key="o"},
    {time=30.417,key="i"},{time=30.833,key="o"},{time=31.250,key="o"},
    {time=31.667,key="p"},{time=32.083,key="a"},{time=32.500,key="p"},
    {time=32.917,key="o"},
    -- "Put a gun against his head pulled my trigger now he's dead"
    {time=33.750,key="p"},{time=34.167,key="p"},{time=34.583,key="o"},
    {time=35.000,key="i"},{time=35.417,key="o"},{time=35.833,key="p"},
    {time=36.250,key="a"},{time=36.667,key="p"},{time=37.083,key="o"},
    {time=37.500,key="i"},{time=37.917,key="o"},
    -- "Mama life had just begun"
    {time=39.167,key="o"},{time=39.583,key="o"},{time=40.000,key="o"},
    {time=40.417,key="i"},{time=40.833,key="o"},{time=41.250,key="o"},
    {time=41.667,key="p"},{time=42.083,key="a"},{time=42.500,key="p"},
    {time=42.917,key="o"},
    -- "But now I've gone and thrown it all away"
    {time=43.750,key="a"},{time=44.167,key="a"},{time=44.583,key="s"},
    {time=45.000,key="a"},{time=45.417,key="p"},{time=45.833,key="o"},
    {time=46.250,key="i"},{time=46.667,key="o"},{time=47.083,key="p"},
    {time=47.500,key="a"},{time=47.917,key="s"},
    -- "Mama ooo didn't mean to make you cry"
    {time=49.167,key="a"},{time=49.583,key="s"},{time=50.000,key="a"},
    {time=50.417,key="p"},{time=50.833,key="o"},{time=51.250,key="p"},
    {time=51.667,key="a"},{time=52.083,key="s"},{time=52.500,key="a"},
    {time=52.917,key="p"},{time=53.333,key="o"},
    -- "If I'm not back again this time tomorrow"
    {time=54.167,key="p"},{time=54.583,key="a"},{time=55.000,key="s"},
    {time=55.417,key="d"},{time=55.833,key="s"},{time=56.250,key="a"},
    {time=56.667,key="p"},{time=57.083,key="o"},{time=57.917,key="p"},
    {time=58.333,key="a"},{time=58.750,key="s"},
}

-- 6. Perfect (Ed Sheeran) - Key: G major, 63 BPM
local notes_perfect = {
    -- Verse "I found a love for me"
    {time=0.000,key="o"},{time=0.952,key="o"},{time=1.905,key="p"},
    {time=2.857,key="o"},{time=3.810,key="u"},{time=4.762,key="u"},
    {time=5.714,key="I"},{time=6.667,key="u"},
    {time=8.571,key="o"},{time=9.524,key="p"},{time=10.476,key="a"},
    {time=11.429,key="p"},{time=12.381,key="o"},{time=13.333,key="u"},
    -- Pre-chorus
    {time=15.238,key="I"},{time=16.190,key="u"},{time=16.667,key="o"},
    {time=17.143,key="p"},{time=17.619,key="a"},{time=18.095,key="p"},
    {time=18.571,key="o"},{time=19.048,key="a"},{time=19.524,key="p"},
    {time=20.476,key="o"},{time=20.952,key="a"},{time=21.429,key="s"},
    {time=21.905,key="d"},{time=22.381,key="s"},{time=22.857,key="a"},
    {time=23.333,key="p"},
    -- Chorus "Baby I'm dancing in the dark"
    {time=25.714,key="o"},{time=26.190,key="o"},{time=26.667,key="o"},
    {time=27.143,key="p"},{time=27.619,key="a"},{time=28.095,key="s"},
    {time=28.571,key="a"},{time=29.048,key="s"},{time=29.524,key="d"},
    {time=30.476,key="d"},{time=30.952,key="s"},{time=31.429,key="a"},
    {time=31.905,key="p"},{time=32.381,key="o"},
    -- "With you between my arms"
    {time=33.333,key="a"},{time=33.810,key="s"},{time=34.286,key="a"},
    {time=34.762,key="p"},{time=35.238,key="o"},{time=35.714,key="a"},
    {time=36.667,key="p"},
    -- "Barefoot on the grass"
    {time=38.095,key="o"},{time=38.571,key="o"},{time=39.048,key="p"},
    {time=39.524,key="a"},{time=40.000,key="s"},{time=40.476,key="d"},
    {time=41.429,key="s"},{time=41.905,key="a"},{time=42.381,key="p"},
    -- "Listening to our favourite song"
    {time=43.333,key="o"},{time=43.810,key="o"},{time=44.286,key="p"},
    {time=44.762,key="a"},{time=45.238,key="s"},{time=45.714,key="a"},
    {time=46.190,key="p"},{time=46.667,key="o"},
    -- "When you said you looked a mess"
    {time=48.095,key="a"},{time=48.571,key="s"},{time=49.048,key="a"},
    {time=49.524,key="p"},{time=50.000,key="o"},{time=50.476,key="a"},
    {time=51.429,key="p"},
    -- "I whispered underneath my breath"
    {time=52.857,key="p"},{time=53.333,key="a"},{time=53.810,key="s"},
    {time=54.286,key="d"},{time=54.762,key="s"},{time=55.238,key="a"},
    {time=55.714,key="p"},{time=56.190,key="o"},
    -- "But you heard it darling you look perfect tonight"
    {time=57.143,key="p"},{time=57.619,key="a"},{time=58.095,key="s"},
    {time=58.571,key="a"},{time=59.048,key="p"},{time=59.524,key="o"},
    {time=60.000,key="a"},{time=60.952,key="s"},{time=61.905,key="a"},
}

-- 7. Counting Stars (OneRepublic) - Key: A minor, 122 BPM
local notes_counting_stars = {
    -- Verse "Lately I've been I've been losing sleep"
    {time=0.000,key="p"},{time=0.246,key="a"},{time=0.492,key="p"},
    {time=0.738,key="o"},{time=0.984,key="i"},{time=1.230,key="o"},
    {time=1.476,key="p"},{time=1.967,key="o"},{time=2.213,key="i"},
    {time=2.459,key="u"},{time=2.951,key="t"},
    {time=3.197,key="p"},{time=3.443,key="a"},{time=3.689,key="p"},
    {time=3.934,key="o"},{time=4.180,key="i"},{time=4.426,key="o"},
    {time=4.672,key="p"},{time=5.164,key="o"},{time=5.410,key="i"},
    {time=5.656,key="u"},{time=6.148,key="e"},
    -- "Dreaming about the things that we could be"
    {time=6.885,key="p"},{time=7.131,key="a"},{time=7.377,key="p"},
    {time=7.623,key="o"},{time=7.869,key="i"},{time=8.115,key="o"},
    {time=8.361,key="p"},{time=8.852,key="o"},{time=9.098,key="i"},
    {time=9.344,key="u"},{time=9.836,key="t"},
    {time=10.082,key="p"},{time=10.328,key="a"},{time=10.574,key="p"},
    {time=10.820,key="o"},{time=11.066,key="i"},{time=11.311,key="o"},
    {time=11.557,key="p"},{time=12.049,key="o"},{time=12.295,key="i"},
    {time=12.541,key="u"},{time=13.033,key="e"},
    -- Pre-chorus "Baby I've been I've been praying hard"
    {time=13.770,key="o"},{time=14.016,key="p"},{time=14.262,key="a"},
    {time=14.508,key="s"},{time=14.754,key="a"},{time=15.000,key="p"},
    {time=15.246,key="o"},{time=15.984,key="p"},{time=16.230,key="a"},
    {time=16.475,key="s"},{time=16.721,key="a"},{time=16.967,key="p"},
    {time=17.459,key="o"},
    -- Chorus "I see stars so bright"
    {time=18.689,key="a"},{time=19.180,key="s"},{time=19.426,key="d"},
    {time=19.672,key="s"},{time=19.918,key="a"},{time=20.164,key="p"},
    {time=20.902,key="a"},{time=21.393,key="s"},{time=21.639,key="a"},
    {time=21.885,key="p"},{time=22.131,key="o"},
    -- "Everything that kills me makes me feel alive"
    {time=22.869,key="a"},{time=23.115,key="s"},{time=23.361,key="d"},
    {time=23.607,key="s"},{time=23.852,key="a"},{time=24.098,key="p"},
    {time=24.836,key="o"},{time=25.082,key="p"},{time=25.328,key="a"},
    {time=25.574,key="p"},{time=25.820,key="o"},{time=26.066,key="i"},
    {time=26.557,key="u"},
    -- Chorus repeat
    {time=27.295,key="a"},{time=27.787,key="s"},{time=28.033,key="d"},
    {time=28.279,key="s"},{time=28.525,key="a"},{time=28.770,key="p"},
    {time=29.508,key="a"},{time=30.000,key="s"},{time=30.246,key="a"},
    {time=30.492,key="p"},{time=30.738,key="o"},
    {time=31.475,key="a"},{time=31.721,key="s"},{time=31.967,key="d"},
    {time=32.213,key="s"},{time=32.459,key="a"},{time=32.705,key="p"},
    {time=33.443,key="o"},{time=33.689,key="p"},{time=33.934,key="a"},
    {time=34.180,key="p"},{time=34.426,key="o"},{time=34.672,key="i"},
    {time=35.164,key="u"},
}

-- 8. Demons (Imagine Dragons) - Key: D major, 90 BPM
local notes_demons = {
    -- Verse "When the days are cold"
    {time=0.000,key="y"},{time=0.333,key="u"},{time=0.667,key="I"},
    {time=1.000,key="o"},{time=1.333,key="p"},{time=1.667,key="a"},
    {time=2.000,key="p"},{time=2.333,key="o"},{time=2.667,key="I"},
    {time=3.000,key="u"},{time=3.333,key="y"},
    {time=4.000,key="y"},{time=4.333,key="u"},{time=4.667,key="I"},
    {time=5.000,key="o"},{time=5.333,key="I"},{time=5.667,key="u"},
    {time=6.000,key="y"},
    -- Chorus "I want to hide the truth I want to shelter you"
    {time=8.000,key="a"},{time=8.333,key="a"},{time=8.667,key="a"},
    {time=9.000,key="p"},{time=9.333,key="o"},{time=9.667,key="I"},
    {time=10.000,key="u"},{time=10.667,key="y"},
    {time=11.333,key="a"},{time=11.667,key="a"},{time=12.000,key="a"},
    {time=12.333,key="p"},{time=12.667,key="o"},{time=13.000,key="I"},
    {time=13.333,key="u"},{time=14.000,key="y"},
    -- "But with the beast inside there's nowhere we can hide"
    {time=14.667,key="p"},{time=15.000,key="p"},{time=15.333,key="p"},
    {time=15.667,key="a"},{time=16.000,key="s"},{time=16.333,key="a"},
    {time=16.667,key="p"},{time=17.333,key="o"},
    {time=18.000,key="p"},{time=18.333,key="p"},{time=18.667,key="p"},
    {time=19.000,key="a"},{time=19.333,key="s"},{time=19.667,key="a"},
    {time=20.000,key="p"},{time=20.667,key="o"},
    -- "No matter what we breed"
    {time=21.333,key="o"},{time=21.667,key="I"},{time=22.000,key="u"},
    {time=22.333,key="y"},{time=22.667,key="u"},{time=23.000,key="I"},
    {time=23.333,key="o"},{time=24.000,key="p"},
    -- "We still are made of greed"
    {time=24.667,key="a"},{time=25.000,key="s"},{time=25.333,key="a"},
    {time=25.667,key="p"},{time=26.000,key="o"},{time=26.667,key="I"},
    -- "This is my kingdom come"
    {time=27.333,key="o"},{time=27.667,key="I"},{time=28.000,key="u"},
    {time=28.333,key="y"},{time=28.667,key="u"},{time=29.000,key="I"},
    {time=29.333,key="o"},{time=30.000,key="p"},
    -- "This is my kingdom come"
    {time=30.667,key="a"},{time=31.000,key="s"},{time=31.333,key="a"},
    {time=31.667,key="p"},{time=32.000,key="o"},{time=32.667,key="I"},
    -- "When you feel my heat look into my eyes"
    {time=34.000,key="y"},{time=34.333,key="u"},{time=34.667,key="I"},
    {time=35.000,key="o"},{time=35.333,key="p"},{time=35.667,key="a"},
    {time=36.000,key="p"},{time=36.333,key="o"},{time=36.667,key="I"},
    {time=37.000,key="u"},{time=37.333,key="y"},
    -- Repeat chorus
    {time=38.667,key="a"},{time=39.000,key="a"},{time=39.333,key="a"},
    {time=39.667,key="p"},{time=40.000,key="o"},{time=40.333,key="I"},
    {time=40.667,key="u"},{time=41.333,key="y"},
    {time=42.000,key="a"},{time=42.333,key="a"},{time=42.667,key="a"},
    {time=43.000,key="p"},{time=43.333,key="o"},{time=43.667,key="I"},
    {time=44.000,key="u"},{time=44.667,key="y"},
    {time=45.333,key="p"},{time=45.667,key="p"},{time=46.000,key="p"},
    {time=46.333,key="a"},{time=46.667,key="s"},{time=47.000,key="a"},
    {time=47.333,key="p"},{time=48.000,key="o"},
}

-- 9. Believer (Imagine Dragons) - Key: D minor, 125 BPM
local notes_believer = {
    -- Intro riff D D A G F
    {time=0.000,key="y"},{time=0.240,key="y"},{time=0.480,key="p"},
    {time=0.720,key="o"},{time=0.960,key="i"},{time=1.200,key="u"},
    {time=1.440,key="i"},{time=1.680,key="o"},
    {time=1.920,key="y"},{time=2.160,key="y"},{time=2.400,key="p"},
    {time=2.640,key="o"},{time=2.880,key="i"},{time=3.120,key="u"},
    {time=3.360,key="i"},{time=3.600,key="o"},
    -- Verse "First things first I'mma say all the words inside my head"
    {time=4.800,key="y"},{time=5.040,key="y"},{time=5.280,key="y"},
    {time=5.520,key="i"},{time=5.760,key="y"},{time=6.000,key="y"},
    {time=6.240,key="o"},{time=6.480,key="y"},{time=6.720,key="y"},
    {time=6.960,key="i"},{time=7.200,key="u"},{time=7.680,key="y"},
    {time=8.400,key="y"},{time=8.640,key="y"},{time=8.880,key="y"},
    {time=9.120,key="i"},{time=9.360,key="y"},{time=9.600,key="y"},
    {time=9.840,key="o"},{time=10.080,key="y"},{time=10.320,key="y"},
    {time=10.560,key="i"},{time=10.800,key="u"},{time=11.280,key="y"},
    -- Pre-chorus
    {time=12.480,key="o"},{time=12.720,key="o"},{time=12.960,key="p"},
    {time=13.200,key="a"},{time=13.440,key="p"},{time=13.680,key="o"},
    {time=13.920,key="i"},{time=14.400,key="u"},
    {time=14.880,key="o"},{time=15.120,key="o"},{time=15.360,key="p"},
    {time=15.600,key="a"},{time=15.840,key="p"},{time=16.080,key="o"},
    {time=16.320,key="P"},{time=16.800,key="t"},
    -- Chorus "I'm a Believer"
    {time=17.280,key="o"},{time=17.760,key="p"},{time=18.000,key="o"},
    {time=18.240,key="i"},{time=18.720,key="u"},{time=19.200,key="y"},
    {time=19.680,key="o"},{time=20.160,key="p"},{time=20.400,key="o"},
    {time=20.640,key="i"},{time=21.120,key="u"},{time=21.600,key="y"},
    {time=22.080,key="o"},{time=22.560,key="p"},{time=22.800,key="a"},
    {time=23.040,key="s"},{time=23.520,key="a"},{time=24.000,key="p"},
    {time=24.480,key="o"},{time=24.960,key="p"},{time=25.200,key="o"},
    {time=25.440,key="i"},{time=25.920,key="u"},{time=26.400,key="y"},
    -- Repeat riff
    {time=27.360,key="y"},{time=27.600,key="y"},{time=27.840,key="p"},
    {time=28.080,key="o"},{time=28.320,key="i"},{time=28.560,key="u"},
    {time=28.800,key="i"},{time=29.040,key="o"},
    {time=29.280,key="y"},{time=29.520,key="y"},{time=29.760,key="p"},
    {time=30.000,key="o"},{time=30.240,key="i"},{time=30.480,key="u"},
    {time=30.720,key="i"},{time=30.960,key="o"},
    -- Repeat chorus
    {time=32.640,key="o"},{time=33.120,key="p"},{time=33.360,key="o"},
    {time=33.600,key="i"},{time=34.080,key="u"},{time=34.560,key="y"},
    {time=35.040,key="o"},{time=35.520,key="p"},{time=35.760,key="o"},
    {time=36.000,key="i"},{time=36.480,key="u"},{time=36.960,key="y"},
    {time=37.440,key="o"},{time=37.920,key="p"},{time=38.160,key="a"},
    {time=38.400,key="s"},{time=38.880,key="a"},{time=39.360,key="p"},
}

-- 10. Shallow (Lady Gaga) - Key: G major, 95 BPM
local notes_shallow = {
    -- Verse "Tell me somethin' girl"
    {time=0.000,key="o"},{time=0.632,key="o"},{time=1.263,key="p"},
    {time=1.895,key="o"},{time=2.526,key="u"},{time=3.158,key="u"},
    {time=3.789,key="I"},{time=4.421,key="u"},
    {time=5.684,key="o"},{time=6.316,key="p"},{time=6.947,key="a"},
    {time=7.579,key="p"},{time=8.211,key="o"},{time=8.842,key="u"},
    -- "Are you happy in this modern world"
    {time=10.105,key="I"},{time=10.737,key="u"},{time=11.368,key="o"},
    {time=12.000,key="p"},{time=12.632,key="a"},{time=13.263,key="p"},
    {time=13.895,key="o"},{time=14.526,key="u"},
    -- "Or do you need more"
    {time=16.421,key="o"},{time=17.053,key="u"},{time=17.684,key="I"},
    {time=18.316,key="u"},{time=18.947,key="o"},
    -- Chorus "I'm off the deep end"
    {time=20.842,key="a"},{time=21.474,key="s"},{time=21.789,key="d"},
    {time=22.105,key="s"},{time=22.737,key="a"},{time=23.368,key="p"},
    {time=24.000,key="o"},{time=24.632,key="p"},{time=25.263,key="a"},
    {time=25.895,key="p"},{time=26.526,key="o"},
    -- "Watch as I dive in"
    {time=27.158,key="a"},{time=27.789,key="s"},{time=28.105,key="d"},
    {time=28.421,key="s"},{time=28.737,key="a"},{time=29.368,key="p"},
    {time=30.000,key="a"},{time=30.632,key="p"},{time=31.263,key="o"},
    -- "I'll never meet the ground"
    {time=31.895,key="o"},{time=32.526,key="p"},{time=33.158,key="a"},
    {time=33.789,key="p"},{time=34.421,key="o"},{time=35.053,key="u"},
    {time=36.316,key="u"},
    -- "Crash through the surface"
    {time=37.579,key="a"},{time=38.211,key="s"},{time=38.526,key="d"},
    {time=38.842,key="s"},{time=39.158,key="a"},{time=39.789,key="p"},
    {time=40.421,key="a"},{time=41.053,key="s"},{time=41.368,key="d"},
    {time=41.684,key="s"},{time=42.000,key="a"},{time=42.632,key="p"},
    -- "Where they can't hurt us"
    {time=43.263,key="o"},{time=43.895,key="p"},{time=44.526,key="a"},
    {time=45.158,key="p"},{time=45.789,key="o"},{time=46.421,key="u"},
    -- "We're far from the shallow now"
    {time=48.316,key="a"},{time=48.947,key="s"},{time=49.579,key="d"},
    {time=50.211,key="s"},{time=50.842,key="a"},{time=51.474,key="p"},
    {time=52.105,key="o"},{time=52.737,key="u"},{time=53.368,key="I"},
    {time=54.000,key="u"},{time=55.263,key="o"},
}

-- 11. Can't Help Falling in Love (Elvis Presley) - Key: D major, 68 BPM
local notes_cant_help_falling = {
    -- "Wise men say only fools rush in"
    {time=0.000,key="y"},{time=0.441,key="u"},{time=0.882,key="I"},
    {time=1.765,key="o"},{time=2.647,key="p"},{time=3.529,key="a"},
    {time=4.412,key="p"},{time=5.294,key="o"},
    -- "But I can't help falling in love with you"
    {time=6.176,key="I"},{time=7.059,key="u"},{time=7.941,key="I"},
    {time=8.824,key="o"},{time=9.706,key="p"},{time=10.588,key="I"},
    {time=11.029,key="u"},{time=11.471,key="y"},{time=12.353,key="y"},
    -- "Shall I stay"
    {time=14.118,key="y"},{time=14.559,key="u"},{time=15.000,key="I"},
    {time=15.882,key="o"},{time=16.765,key="p"},{time=17.647,key="a"},
    {time=18.529,key="p"},{time=19.412,key="o"},
    -- "Would it be a sin"
    {time=20.294,key="I"},{time=21.176,key="u"},{time=22.059,key="I"},
    {time=22.941,key="o"},{time=23.824,key="p"},{time=24.706,key="I"},
    {time=25.147,key="u"},{time=25.588,key="y"},{time=26.471,key="y"},
    -- "If I can't help falling in love with you"
    {time=28.235,key="p"},{time=28.676,key="a"},{time=29.118,key="p"},
    {time=29.559,key="o"},{time=30.000,key="I"},{time=30.441,key="o"},
    {time=30.882,key="p"},{time=31.324,key="a"},{time=31.765,key="p"},
    {time=32.206,key="o"},{time=32.647,key="I"},{time=33.088,key="u"},
    {time=33.529,key="y"},
    -- "Like a river flows surely to the sea"
    {time=35.294,key="o"},{time=35.735,key="p"},{time=36.176,key="a"},
    {time=36.618,key="p"},{time=37.059,key="o"},{time=37.500,key="I"},
    {time=37.941,key="o"},{time=38.382,key="p"},{time=38.824,key="a"},
    {time=39.265,key="p"},{time=39.706,key="a"},
    -- "Darling so it goes some things are meant to be"
    {time=41.176,key="a"},{time=41.618,key="s"},{time=42.059,key="a"},
    {time=42.500,key="p"},{time=42.941,key="o"},{time=43.382,key="p"},
    {time=43.824,key="a"},{time=44.265,key="s"},{time=44.706,key="a"},
    {time=45.147,key="p"},{time=45.588,key="a"},
    -- Final chorus
    {time=47.059,key="p"},{time=47.500,key="a"},{time=47.941,key="p"},
    {time=48.382,key="o"},{time=48.824,key="I"},{time=49.265,key="o"},
    {time=49.706,key="p"},{time=50.147,key="a"},{time=50.588,key="p"},
    {time=51.029,key="o"},{time=51.471,key="I"},{time=51.912,key="u"},
    {time=52.353,key="y"},
}

-- 12. My Heart Will Go On (Titanic/Celine Dion) - Key: E major, 60 BPM
local notes_my_heart_will_go_on = {
    -- Flute intro
    {time=0.000,key="u"},{time=0.500,key="I"},{time=1.000,key="O"},
    {time=2.000,key="p"},{time=3.000,key="O"},{time=4.000,key="u"},
    {time=5.000,key="I"},{time=6.000,key="u"},
    -- Verse "Every night in my dreams I see you I feel you"
    {time=8.000,key="u"},{time=8.500,key="I"},{time=9.000,key="O"},
    {time=9.500,key="p"},{time=10.000,key="a"},{time=10.500,key="p"},
    {time=11.000,key="O"},{time=11.500,key="u"},{time=12.000,key="I"},
    {time=13.000,key="u"},{time=14.000,key="I"},{time=14.500,key="O"},
    {time=15.000,key="p"},{time=15.500,key="a"},{time=16.000,key="p"},
    {time=16.500,key="O"},{time=17.000,key="u"},
    -- "That is how I know you go on"
    {time=18.000,key="p"},{time=18.500,key="O"},{time=19.000,key="p"},
    {time=19.500,key="a"},{time=20.000,key="p"},{time=20.500,key="O"},
    {time=21.000,key="p"},{time=22.000,key="u"},
    -- Chorus "Near far wherever you are"
    {time=24.000,key="p"},{time=24.500,key="a"},{time=25.000,key="p"},
    {time=25.500,key="O"},{time=26.000,key="p"},{time=26.500,key="a"},
    {time=27.000,key="s"},{time=28.000,key="a"},{time=28.500,key="p"},
    {time=29.000,key="a"},{time=29.500,key="p"},{time=30.000,key="O"},
    -- "I believe that the heart does go on"
    {time=31.000,key="p"},{time=31.500,key="a"},{time=32.000,key="s"},
    {time=32.500,key="d"},{time=33.000,key="s"},{time=33.500,key="a"},
    {time=34.000,key="p"},{time=34.500,key="O"},{time=35.000,key="p"},
    {time=36.000,key="u"},
    -- "Once more you open the door"
    {time=38.000,key="p"},{time=38.500,key="a"},{time=39.000,key="p"},
    {time=39.500,key="O"},{time=40.000,key="p"},{time=40.500,key="a"},
    {time=41.000,key="s"},{time=42.000,key="a"},{time=42.500,key="p"},
    {time=43.000,key="a"},{time=43.500,key="p"},{time=44.000,key="O"},
    -- "And you're here in my heart"
    {time=45.000,key="p"},{time=45.500,key="a"},{time=46.000,key="s"},
    {time=46.500,key="d"},{time=47.000,key="s"},{time=47.500,key="a"},
    {time=48.000,key="p"},{time=49.000,key="u"},
    -- "And my heart will go on and on"
    {time=51.000,key="u"},{time=51.500,key="I"},{time=52.000,key="O"},
    {time=52.500,key="p"},{time=53.000,key="O"},{time=53.500,key="I"},
    {time=54.000,key="u"},{time=55.000,key="I"},{time=56.000,key="u"},
    {time=57.000,key="I"},{time=58.000,key="O"},{time=60.000,key="u"},
}

-- 13. Thinking Out Loud (Ed Sheeran) - Key: D major, 79 BPM
local notes_thinking_out_loud = {
    -- Verse "When your legs don't work like they used to before"
    {time=0.000,key="y"},{time=0.759,key="u"},{time=1.139,key="I"},
    {time=1.519,key="o"},{time=2.278,key="p"},{time=2.658,key="o"},
    {time=3.038,key="I"},{time=3.797,key="u"},{time=4.177,key="y"},
    {time=5.316,key="y"},{time=6.076,key="u"},{time=6.456,key="I"},
    {time=6.835,key="o"},{time=7.595,key="p"},{time=7.975,key="o"},
    {time=8.354,key="I"},{time=9.114,key="u"},{time=9.494,key="y"},
    -- Chorus "Take me into your loving arms"
    {time=12.152,key="I"},{time=12.532,key="o"},{time=12.911,key="p"},
    {time=13.291,key="a"},{time=13.671,key="p"},{time=14.430,key="o"},
    {time=15.190,key="I"},{time=15.570,key="u"},{time=15.949,key="y"},
    -- "Kiss me under the light of a thousand stars"
    {time=16.709,key="I"},{time=17.089,key="o"},{time=17.468,key="p"},
    {time=17.848,key="a"},{time=18.228,key="p"},{time=18.987,key="o"},
    {time=19.747,key="I"},{time=20.127,key="u"},{time=20.506,key="y"},
    -- "Place your head on my beating heart"
    {time=21.266,key="I"},{time=21.646,key="o"},{time=22.025,key="p"},
    {time=22.405,key="a"},{time=22.785,key="p"},{time=23.544,key="o"},
    {time=24.304,key="I"},{time=24.684,key="u"},{time=25.063,key="y"},
    -- "I'm thinking out loud"
    {time=25.823,key="a"},{time=26.203,key="s"},{time=26.582,key="d"},
    {time=27.342,key="s"},{time=27.722,key="a"},{time=28.481,key="p"},
    {time=29.241,key="a"},{time=30.000,key="s"},
    -- "Maybe we found love right where we are"
    {time=31.519,key="a"},{time=31.899,key="p"},{time=32.278,key="o"},
    {time=32.658,key="I"},{time=33.038,key="u"},{time=33.418,key="y"},
    {time=34.177,key="u"},{time=34.557,key="I"},{time=34.937,key="o"},
    {time=35.316,key="I"},{time=35.696,key="u"},{time=36.456,key="y"},
    -- Repeat verse/chorus pattern
    {time=38.228,key="y"},{time=38.987,key="u"},{time=39.367,key="I"},
    {time=39.747,key="o"},{time=40.506,key="p"},{time=40.886,key="o"},
    {time=41.266,key="I"},{time=42.025,key="u"},{time=42.405,key="y"},
    {time=44.684,key="I"},{time=45.063,key="o"},{time=45.443,key="p"},
    {time=45.823,key="a"},{time=46.203,key="p"},{time=46.962,key="o"},
    {time=47.722,key="I"},{time=48.101,key="u"},{time=48.481,key="y"},
    {time=49.241,key="a"},{time=49.620,key="s"},{time=50.000,key="d"},
    {time=50.759,key="s"},{time=51.139,key="a"},{time=51.899,key="p"},
    {time=52.658,key="a"},{time=53.418,key="s"},
}

-- ============================================================
-- DISNEY / MOVIE
-- ============================================================

-- 14. Under the Sea (The Little Mermaid) - Key: C major, 160 BPM
local notes_under_the_sea = {
    -- Main Theme "The seaweed is always greener"
    {time=0.000,key="t"},{time=0.188,key="t"},{time=0.375,key="y"},
    {time=0.563,key="u"},{time=0.750,key="i"},{time=1.125,key="u"},
    {time=1.313,key="i"},{time=1.500,key="o"},{time=1.688,key="i"},
    {time=2.063,key="u"},{time=2.250,key="i"},{time=2.438,key="u"},
    {time=2.625,key="o"},{time=3.000,key="u"},{time=3.188,key="t"},
    {time=3.750,key="t"},{time=3.938,key="t"},{time=4.125,key="y"},
    {time=4.313,key="u"},{time=4.500,key="i"},{time=4.875,key="u"},
    {time=5.063,key="i"},{time=5.250,key="o"},{time=5.438,key="i"},
    {time=5.813,key="u"},{time=6.000,key="i"},{time=6.188,key="u"},
    {time=6.375,key="t"},{time=6.750,key="r"},
    -- "Under the sea, under the sea"
    {time=7.500,key="u"},{time=7.688,key="u"},{time=7.875,key="u"},
    {time=8.063,key="u"},{time=8.250,key="o"},{time=8.625,key="i"},
    {time=9.000,key="u"},{time=9.375,key="i"},{time=9.563,key="u"},
    {time=9.750,key="t"},
    {time=10.500,key="u"},{time=10.688,key="u"},{time=10.875,key="u"},
    {time=11.063,key="u"},{time=11.250,key="o"},{time=11.625,key="p"},
    {time=12.000,key="o"},{time=12.375,key="p"},{time=12.563,key="o"},
    {time=12.750,key="i"},
    -- "Darling it's better down where it's wetter"
    {time=13.500,key="a"},{time=13.688,key="a"},{time=13.875,key="s"},
    {time=14.063,key="a"},{time=14.250,key="p"},{time=14.625,key="o"},
    {time=14.813,key="p"},{time=15.000,key="o"},{time=15.188,key="i"},
    {time=15.375,key="u"},
    {time=16.125,key="a"},{time=16.313,key="a"},{time=16.500,key="s"},
    {time=16.688,key="a"},{time=16.875,key="p"},{time=17.250,key="o"},
    {time=17.438,key="i"},{time=17.625,key="u"},{time=17.813,key="t"},
    -- "Take it from me"
    {time=18.563,key="o"},{time=18.750,key="o"},{time=18.938,key="p"},
    {time=19.125,key="o"},{time=19.313,key="p"},{time=19.500,key="a"},
    {time=19.875,key="s"},{time=20.625,key="a"},
    -- "Up on the shore they work all day"
    {time=21.375,key="i"},{time=21.563,key="i"},{time=21.750,key="o"},
    {time=21.938,key="i"},{time=22.125,key="u"},{time=22.500,key="t"},
    {time=22.688,key="y"},{time=22.875,key="u"},{time=23.063,key="i"},
    {time=23.250,key="u"},
    {time=24.000,key="i"},{time=24.188,key="i"},{time=24.375,key="o"},
    {time=24.563,key="i"},{time=24.750,key="u"},{time=25.125,key="t"},
    {time=25.313,key="y"},{time=25.500,key="t"},{time=25.688,key="r"},
    {time=25.875,key="e"},
    -- Final: "Under the sea!"
    {time=27.375,key="u"},{time=27.563,key="i"},{time=27.750,key="o"},
    {time=27.938,key="i"},{time=28.125,key="u"},{time=28.313,key="i"},
    {time=28.500,key="u"},{time=28.688,key="t"},{time=29.063,key="t"},
    {time=30.375,key="u"},{time=30.563,key="i"},{time=30.750,key="o"},
    {time=30.938,key="p"},{time=31.125,key="o"},{time=31.313,key="i"},
    {time=31.500,key="u"},{time=31.875,key="u"},
}

-- 15. A Whole New World (Aladdin) - Key: D major, 80 BPM
local notes_whole_new_world = {
    -- "I can show you the world"
    {time=0.000,key="y"},{time=0.375,key="u"},{time=0.750,key="I"},
    {time=1.500,key="o"},{time=2.250,key="o"},{time=2.625,key="p"},
    {time=3.000,key="a"},{time=3.750,key="p"},
    -- "Shining shimmering splendid"
    {time=5.250,key="y"},{time=5.625,key="u"},{time=6.000,key="I"},
    {time=6.750,key="o"},{time=7.500,key="p"},{time=7.875,key="a"},
    {time=8.250,key="s"},{time=9.000,key="a"},
    -- "Tell me princess now when did you last let your heart decide"
    {time=10.500,key="y"},{time=10.875,key="u"},{time=11.250,key="I"},
    {time=12.000,key="o"},{time=12.750,key="I"},{time=13.125,key="u"},
    {time=13.500,key="y"},{time=14.250,key="u"},{time=14.625,key="I"},
    {time=15.000,key="o"},{time=15.375,key="p"},{time=15.750,key="a"},
    {time=16.500,key="p"},
    -- Chorus "A whole new world"
    {time=18.000,key="d"},{time=18.750,key="d"},{time=19.125,key="d"},
    {time=19.500,key="f"},{time=19.875,key="d"},{time=20.250,key="s"},
    {time=21.000,key="a"},{time=22.500,key="a"},
    -- "A new fantastic point of view"
    {time=23.250,key="s"},{time=24.000,key="s"},{time=24.375,key="s"},
    {time=24.750,key="d"},{time=25.125,key="s"},{time=25.500,key="a"},
    {time=26.250,key="p"},{time=27.750,key="p"},
    -- "No one to tell us no or where to go"
    {time=28.500,key="a"},{time=29.250,key="a"},{time=29.625,key="a"},
    {time=30.000,key="s"},{time=30.375,key="a"},{time=30.750,key="p"},
    {time=31.500,key="o"},{time=33.000,key="o"},
    -- "Or say we're only dreaming"
    {time=33.750,key="p"},{time=34.500,key="p"},{time=34.875,key="p"},
    {time=35.250,key="a"},{time=35.625,key="p"},{time=36.000,key="o"},
    {time=36.750,key="I"},{time=38.250,key="u"},
    -- "A whole new world"
    {time=39.000,key="d"},{time=39.750,key="d"},{time=40.125,key="d"},
    {time=40.500,key="f"},{time=40.875,key="d"},{time=41.250,key="s"},
    {time=42.000,key="a"},{time=43.500,key="a"},
    -- "A dazzling place I never knew"
    {time=44.250,key="s"},{time=45.000,key="s"},{time=45.375,key="s"},
    {time=45.750,key="d"},{time=46.125,key="s"},{time=46.500,key="a"},
    {time=47.250,key="p"},{time=48.750,key="p"},
    -- "But when I'm way up here it's crystal clear"
    {time=49.500,key="a"},{time=50.250,key="a"},{time=50.625,key="a"},
    {time=51.000,key="s"},{time=51.375,key="a"},{time=51.750,key="p"},
    {time=52.500,key="o"},{time=53.250,key="I"},
    -- "That now I'm in a whole new world with you"
    {time=54.000,key="a"},{time=54.750,key="p"},{time=55.125,key="a"},
    {time=55.500,key="p"},{time=55.875,key="o"},{time=56.625,key="I"},
    {time=57.000,key="u"},{time=58.500,key="y"},
}

-- 16. Beauty and the Beast - Key: F major, 60 BPM
local notes_beauty_and_the_beast = {
    -- "Tale as old as time"
    {time=0.000,key="i"},{time=1.000,key="o"},{time=2.000,key="p"},
    {time=3.000,key="o"},{time=4.000,key="i"},
    -- "True as it can be"
    {time=6.000,key="i"},{time=7.000,key="o"},{time=8.000,key="p"},
    {time=9.000,key="i"},{time=10.000,key="q"},
    -- "Barely even friends"
    {time=12.000,key="i"},{time=13.000,key="p"},{time=14.000,key="a"},
    {time=15.000,key="p"},{time=16.000,key="o"},
    -- "Then somebody bends"
    {time=18.000,key="o"},{time=19.000,key="p"},{time=20.000,key="a"},
    {time=21.000,key="p"},{time=22.000,key="i"},
    -- "Unexpectedly"
    {time=24.000,key="p"},{time=25.000,key="a"},{time=26.000,key="p"},
    {time=27.000,key="o"},{time=28.000,key="i"},{time=29.000,key="q"},
    -- "Just a little change"
    {time=31.000,key="p"},{time=32.000,key="a"},{time=33.000,key="s"},
    {time=34.000,key="a"},{time=35.000,key="p"},
    -- "Small to say the least"
    {time=37.000,key="p"},{time=38.000,key="o"},{time=39.000,key="i"},
    {time=40.000,key="o"},{time=41.000,key="p"},
    -- "Both a little scared"
    {time=43.000,key="a"},{time=44.000,key="s"},{time=45.000,key="a"},
    {time=46.000,key="p"},{time=47.000,key="o"},
    -- "Neither one prepared"
    {time=49.000,key="p"},{time=50.000,key="a"},{time=51.000,key="s"},
    {time=52.000,key="a"},{time=53.000,key="p"},{time=54.000,key="o"},
    -- "Beauty and the Beast"
    {time=56.000,key="i"},{time=57.000,key="o"},{time=58.000,key="p"},
    {time=59.000,key="a"},{time=60.000,key="p"},{time=62.000,key="i"},
}

-- 17. You've Got a Friend in Me (Toy Story) - Key: C major, 90 BPM
local notes_youve_got_a_friend = {
    -- Intro bounce
    {time=0.000,key="t"},{time=0.333,key="y"},{time=0.667,key="u"},
    {time=1.000,key="o"},{time=1.333,key="p"},{time=1.667,key="a"},
    {time=2.000,key="p"},{time=2.333,key="o"},
    -- "You've got a friend in me"
    {time=3.333,key="u"},{time=3.667,key="u"},{time=4.000,key="o"},
    {time=4.333,key="u"},{time=4.667,key="o"},{time=5.000,key="p"},
    {time=5.333,key="o"},{time=5.667,key="u"},{time=6.000,key="i"},
    {time=6.333,key="u"},{time=6.667,key="t"},
    -- "You've got a friend in me"
    {time=8.000,key="u"},{time=8.333,key="u"},{time=8.667,key="o"},
    {time=9.000,key="u"},{time=9.333,key="o"},{time=9.667,key="p"},
    {time=10.000,key="o"},{time=10.333,key="u"},{time=10.667,key="i"},
    {time=11.000,key="o"},{time=11.333,key="u"},
    -- "When the road looks rough ahead"
    {time=13.333,key="u"},{time=13.667,key="o"},{time=14.000,key="p"},
    {time=14.333,key="p"},{time=14.667,key="o"},{time=15.000,key="u"},
    {time=15.333,key="i"},{time=15.667,key="u"},{time=16.000,key="t"},
    -- "And you're miles and miles from your nice warm bed"
    {time=17.333,key="o"},{time=17.667,key="p"},{time=18.000,key="a"},
    {time=18.333,key="s"},{time=18.667,key="a"},{time=19.000,key="p"},
    {time=19.333,key="o"},{time=19.667,key="u"},{time=20.000,key="i"},
    {time=20.333,key="u"},
    -- "You just remember what your old pal said"
    {time=22.000,key="u"},{time=22.333,key="i"},{time=22.667,key="o"},
    {time=23.000,key="p"},{time=23.333,key="a"},{time=23.667,key="p"},
    {time=24.000,key="o"},{time=24.333,key="i"},{time=24.667,key="u"},
    {time=25.000,key="t"},
    -- "Son you've got a friend in me"
    {time=26.667,key="u"},{time=27.000,key="u"},{time=27.333,key="o"},
    {time=27.667,key="u"},{time=28.000,key="o"},{time=28.333,key="p"},
    {time=28.667,key="o"},{time=29.000,key="u"},{time=29.333,key="i"},
    {time=29.667,key="u"},{time=30.000,key="t"},
    -- Final chorus reprise
    {time=32.000,key="u"},{time=32.333,key="u"},{time=32.667,key="o"},
    {time=33.000,key="u"},{time=33.333,key="o"},{time=33.667,key="p"},
    {time=34.000,key="o"},{time=34.333,key="u"},{time=34.667,key="i"},
    {time=35.000,key="o"},{time=35.333,key="u"},
    {time=37.333,key="u"},{time=37.667,key="o"},{time=38.000,key="p"},
    {time=38.333,key="p"},{time=38.667,key="o"},{time=39.000,key="u"},
    {time=39.333,key="i"},{time=39.667,key="u"},{time=40.000,key="t"},
}

-- ============================================================
-- GAME MUSIC
-- ============================================================

-- 18. Super Mario Bros Main Theme - Key: C major, 200 BPM
local notes_super_mario = {
    -- Main theme
    {time=0.000,key="u"},{time=0.300,key="u"},{time=0.450,key="u"},
    {time=0.600,key="t"},{time=0.750,key="u"},{time=1.050,key="o"},
    {time=1.350,key="o"},
    -- "DA-DA-DA-DA-DA DA-DA..."
    {time=2.100,key="t"},{time=2.400,key="o"},{time=2.700,key="u"},
    {time=3.000,key="p"},{time=3.450,key="a"},{time=3.750,key="p"},
    {time=4.050,key="o"},
    -- "DUM DUM DUM..."
    {time=5.100,key="u"},{time=5.400,key="o"},{time=5.700,key="u"},
    {time=6.000,key="p"},{time=6.150,key="i"},{time=6.300,key="u"},
    {time=6.600,key="o"},{time=7.200,key="t"},
    -- Jump sound & repeat
    {time=8.100,key="u"},{time=8.400,key="u"},{time=8.550,key="u"},
    {time=8.700,key="t"},{time=8.850,key="u"},{time=9.150,key="o"},
    {time=9.450,key="o"},
    {time=10.200,key="t"},{time=10.500,key="o"},{time=10.800,key="u"},
    {time=11.100,key="p"},{time=11.550,key="a"},{time=11.850,key="p"},
    {time=12.150,key="o"},
    {time=13.200,key="u"},{time=13.500,key="o"},{time=13.800,key="u"},
    {time=14.100,key="p"},{time=14.250,key="i"},{time=14.400,key="u"},
    {time=14.700,key="o"},{time=15.300,key="t"},
    -- 2nd section
    {time=16.200,key="t"},{time=16.500,key="y"},{time=16.800,key="u"},
    {time=17.100,key="i"},{time=17.700,key="o"},{time=18.000,key="p"},
    {time=18.600,key="p"},{time=19.200,key="o"},
    {time=20.100,key="i"},{time=20.400,key="o"},{time=20.700,key="p"},
    {time=21.000,key="a"},{time=21.300,key="p"},{time=21.600,key="o"},
    {time=22.500,key="u"},{time=22.800,key="o"},{time=23.100,key="u"},
    {time=23.400,key="p"},{time=23.550,key="i"},{time=23.700,key="u"},
    {time=24.000,key="o"},{time=24.600,key="t"},
    -- Underground theme fragment
    {time=25.500,key="t"},{time=25.650,key="t"},{time=25.800,key="y"},
    {time=26.100,key="i"},{time=26.700,key="o"},{time=27.000,key="p"},
    {time=27.600,key="p"},{time=28.200,key="o"},
    {time=29.100,key="u"},{time=29.400,key="o"},{time=29.700,key="u"},
    {time=30.000,key="p"},{time=30.150,key="i"},{time=30.300,key="u"},
    {time=30.600,key="o"},{time=31.200,key="t"},
}

-- 19. Tetris Theme (Korobeiniki) - Key: A minor, 160 BPM
local notes_tetris = {
    -- Main A section
    {time=0.000,key="o"},{time=0.375,key="p"},{time=0.563,key="a"},
    {time=0.750,key="s"},{time=1.125,key="a"},{time=1.313,key="p"},
    {time=1.500,key="o"},{time=1.875,key="i"},{time=2.250,key="u"},
    {time=2.625,key="i"},{time=3.000,key="o"},{time=3.375,key="p"},
    {time=3.750,key="a"},
    {time=4.500,key="p"},{time=4.875,key="o"},{time=5.063,key="i"},
    {time=5.250,key="u"},{time=5.625,key="i"},
    {time=6.000,key="t"},{time=6.750,key="y"},
    {time=7.500,key="u"},{time=7.875,key="i"},{time=8.063,key="u"},
    {time=8.250,key="o"},{time=8.625,key="p"},{time=9.000,key="a"},
    {time=9.375,key="p"},{time=9.750,key="o"},{time=9.938,key="i"},
    {time=10.125,key="u"},{time=10.500,key="y"},
    -- Repeat A
    {time=11.250,key="o"},{time=11.625,key="p"},{time=11.813,key="a"},
    {time=12.000,key="s"},{time=12.375,key="a"},{time=12.563,key="p"},
    {time=12.750,key="o"},{time=13.125,key="i"},{time=13.500,key="u"},
    {time=13.875,key="i"},{time=14.250,key="o"},{time=14.625,key="p"},
    {time=15.000,key="a"},
    {time=15.750,key="p"},{time=16.125,key="o"},{time=16.313,key="i"},
    {time=16.500,key="u"},{time=16.875,key="i"},
    {time=17.250,key="t"},{time=18.000,key="y"},
    {time=18.750,key="y"},{time=19.125,key="u"},{time=19.313,key="i"},
    {time=19.500,key="u"},{time=19.875,key="t"},
    -- B section
    {time=21.000,key="s"},{time=21.375,key="s"},{time=21.750,key="d"},
    {time=22.125,key="s"},{time=22.313,key="a"},{time=22.500,key="p"},
    {time=22.875,key="o"},{time=23.250,key="i"},{time=23.625,key="u"},
    {time=24.000,key="u"},{time=24.375,key="u"},{time=24.750,key="i"},
    {time=25.125,key="o"},{time=25.500,key="p"},
    {time=26.250,key="p"},{time=26.625,key="a"},{time=26.813,key="p"},
    {time=27.000,key="o"},{time=27.375,key="i"},
    {time=27.750,key="u"},{time=28.500,key="t"},
    {time=29.250,key="s"},{time=29.625,key="s"},{time=30.000,key="d"},
    {time=30.375,key="s"},{time=30.563,key="a"},{time=30.750,key="p"},
    {time=31.125,key="o"},{time=31.500,key="i"},{time=31.875,key="u"},
    {time=32.250,key="o"},{time=32.625,key="p"},{time=33.000,key="a"},
    {time=34.500,key="o"},
}

-- 20. Legend of Zelda - Main Theme - Key: B minor, 120 BPM
local notes_zelda = {
    -- Fanfare intro
    {time=0.000,key="t"},{time=0.250,key="t"},{time=0.500,key="u"},
    {time=0.750,key="t"},{time=1.250,key="o"},{time=2.000,key="p"},
    {time=3.000,key="t"},{time=3.250,key="t"},{time=3.500,key="u"},
    {time=3.750,key="t"},{time=4.250,key="p"},{time=4.500,key="o"},
    {time=5.500,key="u"},
    -- Main melody
    {time=6.500,key="o"},{time=6.750,key="p"},{time=7.000,key="a"},
    {time=7.500,key="p"},{time=7.750,key="o"},{time=8.000,key="i"},
    {time=8.750,key="u"},{time=9.000,key="i"},{time=9.250,key="o"},
    {time=9.500,key="p"},{time=9.750,key="o"},{time=10.000,key="i"},
    {time=10.750,key="o"},
    {time=11.750,key="o"},{time=12.000,key="p"},{time=12.250,key="a"},
    {time=12.750,key="p"},{time=13.000,key="o"},{time=13.250,key="i"},
    {time=14.000,key="u"},{time=14.250,key="i"},{time=14.500,key="u"},
    {time=14.750,key="y"},{time=15.000,key="u"},{time=15.250,key="i"},
    {time=16.000,key="o"},
    -- Bridge
    {time=17.000,key="a"},{time=17.500,key="p"},{time=18.000,key="o"},
    {time=18.500,key="i"},{time=19.000,key="u"},{time=19.500,key="i"},
    {time=20.000,key="o"},{time=20.500,key="p"},{time=21.000,key="a"},
    {time=21.500,key="s"},{time=22.000,key="a"},{time=22.500,key="p"},
    {time=23.000,key="o"},
    -- Final fanfare
    {time=24.000,key="t"},{time=24.250,key="t"},{time=24.500,key="u"},
    {time=24.750,key="t"},{time=25.250,key="o"},{time=26.000,key="p"},
    {time=27.000,key="a"},{time=27.500,key="p"},{time=28.000,key="o"},
    {time=28.500,key="i"},{time=29.000,key="u"},{time=30.000,key="o"},
}

-- 21. Minecraft - Sweden (C418) - Key: A major, 70 BPM
local notes_minecraft_sweden = {
    -- Gentle intro arpeggios
    {time=0.000,key="p"},{time=0.857,key="a"},{time=1.714,key="s"},
    {time=2.571,key="a"},{time=3.429,key="p"},{time=4.286,key="o"},
    {time=5.143,key="p"},{time=6.000,key="a"},
    {time=6.857,key="p"},{time=7.714,key="a"},{time=8.571,key="s"},
    {time=9.429,key="d"},{time=10.286,key="s"},{time=11.143,key="a"},
    {time=12.000,key="p"},
    -- Melody
    {time=13.714,key="a"},{time=14.571,key="s"},{time=15.429,key="d"},
    {time=16.286,key="f"},{time=17.143,key="d"},{time=18.000,key="s"},
    {time=18.857,key="a"},{time=20.571,key="s"},
    {time=21.429,key="a"},{time=22.286,key="p"},{time=23.143,key="o"},
    {time=24.000,key="p"},{time=24.857,key="a"},{time=25.714,key="s"},
    {time=26.571,key="a"},{time=28.286,key="p"},
    -- Second phrase
    {time=30.000,key="d"},{time=30.857,key="s"},{time=31.714,key="a"},
    {time=32.571,key="p"},{time=33.429,key="o"},{time=34.286,key="p"},
    {time=35.143,key="a"},{time=36.857,key="p"},
    {time=38.571,key="a"},{time=39.429,key="s"},{time=40.286,key="a"},
    {time=41.143,key="p"},{time=42.000,key="o"},{time=42.857,key="i"},
    {time=43.714,key="u"},{time=45.429,key="y"},
    -- Closing
    {time=47.143,key="p"},{time=48.000,key="a"},{time=48.857,key="s"},
    {time=49.714,key="a"},{time=50.571,key="p"},{time=52.286,key="o"},
    {time=54.000,key="p"},{time=56.571,key="a"},
}

-- 22. Megalovania (Undertale) - Key: D minor, 120 BPM
local notes_megalovania = {
    -- Iconic opening
    {time=0.000,key="d"},{time=0.250,key="d"},{time=0.500,key="l"},
    {time=0.750,key="k"},{time=1.000,key="j"},{time=1.250,key="h"},
    {time=1.500,key="j"},{time=1.750,key="h"},
    {time=2.000,key="d"},{time=2.250,key="d"},{time=2.500,key="k"},
    {time=2.750,key="j"},{time=3.000,key="h"},{time=3.250,key="g"},
    {time=3.500,key="h"},{time=3.750,key="g"},
    {time=4.000,key="d"},{time=4.250,key="d"},{time=4.500,key="j"},
    {time=4.750,key="h"},{time=5.000,key="g"},{time=5.500,key="f"},
    {time=5.750,key="g"},
    {time=6.000,key="d"},{time=6.250,key="d"},{time=6.500,key="h"},
    {time=6.750,key="g"},{time=7.000,key="f"},{time=7.250,key="d"},
    {time=7.500,key="f"},{time=7.750,key="g"},
    -- Repeat
    {time=8.000,key="d"},{time=8.250,key="d"},{time=8.500,key="l"},
    {time=8.750,key="k"},{time=9.000,key="j"},{time=9.250,key="h"},
    {time=9.500,key="j"},{time=9.750,key="h"},
    {time=10.000,key="d"},{time=10.250,key="d"},{time=10.500,key="k"},
    {time=10.750,key="j"},{time=11.000,key="h"},{time=11.250,key="g"},
    {time=11.500,key="h"},{time=11.750,key="g"},
    {time=12.000,key="d"},{time=12.250,key="d"},{time=12.500,key="j"},
    {time=12.750,key="h"},{time=13.000,key="g"},{time=13.500,key="f"},
    {time=13.750,key="g"},
    {time=14.000,key="d"},{time=14.250,key="d"},{time=14.500,key="h"},
    {time=14.750,key="g"},{time=15.000,key="f"},{time=15.250,key="d"},
    {time=15.500,key="f"},{time=15.750,key="g"},
    -- Higher section
    {time=16.000,key="j"},{time=16.250,key="j"},{time=16.500,key="l"},
    {time=16.750,key="k"},{time=17.000,key="j"},{time=17.250,key="h"},
    {time=17.500,key="j"},{time=17.750,key="h"},
    {time=18.000,key="j"},{time=18.250,key="j"},{time=18.500,key="k"},
    {time=18.750,key="j"},{time=19.000,key="h"},{time=19.250,key="g"},
    {time=19.500,key="h"},{time=19.750,key="g"},
    {time=20.000,key="j"},{time=20.250,key="j"},{time=20.500,key="j"},
    {time=20.750,key="h"},{time=21.000,key="g"},{time=21.500,key="f"},
    {time=21.750,key="g"},
    {time=22.000,key="j"},{time=22.250,key="j"},{time=22.500,key="h"},
    {time=22.750,key="g"},{time=23.000,key="f"},{time=23.250,key="d"},
    {time=23.500,key="f"},{time=23.750,key="g"},
    -- Climax
    {time=24.000,key="j"},{time=24.500,key="h"},{time=25.000,key="j"},
    {time=25.500,key="k"},{time=26.000,key="j"},{time=26.500,key="h"},
    {time=27.000,key="g"},{time=28.000,key="f"},
    {time=28.000,key="j"},{time=28.500,key="h"},{time=29.000,key="j"},
    {time=29.500,key="k"},{time=30.000,key="l"},{time=30.500,key="k"},
    {time=31.000,key="j"},{time=32.000,key="h"},
}

-- 23. Pokemon - Main Theme - Key: C major, 120 BPM
local notes_pokemon_theme = {
    -- "I wanna be the very best"
    {time=0.000,key="o"},{time=0.500,key="p"},{time=1.000,key="o"},
    {time=1.500,key="i"},{time=2.000,key="u"},{time=2.500,key="t"},
    {time=3.500,key="t"},{time=4.000,key="t"},{time=4.500,key="y"},
    {time=5.000,key="u"},{time=5.500,key="y"},{time=6.000,key="t"},
    -- "Like no one ever was"
    {time=7.500,key="o"},{time=8.000,key="p"},{time=8.500,key="o"},
    {time=9.000,key="i"},{time=9.500,key="u"},{time=10.000,key="i"},
    {time=11.000,key="u"},
    -- "To catch them is my real test"
    {time=12.000,key="o"},{time=12.500,key="p"},{time=13.000,key="o"},
    {time=13.500,key="i"},{time=14.000,key="u"},{time=14.500,key="t"},
    {time=15.500,key="t"},{time=16.000,key="t"},{time=16.500,key="y"},
    {time=17.000,key="u"},{time=17.500,key="i"},{time=18.000,key="o"},
    -- "To train them is my cause"
    {time=19.500,key="p"},{time=20.000,key="a"},{time=20.500,key="p"},
    {time=21.000,key="o"},{time=21.500,key="i"},{time=22.000,key="u"},
    {time=23.000,key="i"},
    -- Chorus "Pokemon!"
    {time=24.000,key="p"},{time=24.500,key="a"},{time=25.000,key="s"},
    {time=25.500,key="a"},{time=26.000,key="p"},{time=27.000,key="o"},
    {time=28.000,key="p"},{time=28.500,key="a"},{time=29.000,key="s"},
    {time=29.500,key="d"},{time=30.000,key="s"},{time=30.500,key="a"},
    {time=31.000,key="p"},{time=32.000,key="o"},
    -- Bridge
    {time=33.000,key="u"},{time=33.500,key="i"},{time=34.000,key="o"},
    {time=34.500,key="p"},{time=35.000,key="o"},{time=35.500,key="i"},
    {time=36.000,key="u"},{time=37.000,key="t"},
    {time=38.000,key="u"},{time=38.500,key="i"},{time=39.000,key="o"},
    {time=39.500,key="p"},{time=40.000,key="a"},{time=40.500,key="p"},
    {time=41.000,key="o"},{time=42.000,key="i"},
}

-- ============================================================
-- K-POP
-- ============================================================

-- 24. Dynamite (BTS) - Key: F# major, 114 BPM
local notes_dynamite = {
    -- Intro "Cause I, I, I'm in the stars tonight"
    {time=0.000,key="p"},{time=0.526,key="o"},{time=1.053,key="p"},
    {time=1.579,key="a"},{time=2.105,key="p"},{time=2.632,key="o"},
    {time=3.158,key="i"},{time=3.684,key="u"},
    {time=4.211,key="p"},{time=4.737,key="a"},{time=5.263,key="s"},
    {time=5.789,key="a"},{time=6.316,key="p"},{time=7.368,key="o"},
    -- Verse
    {time=8.421,key="p"},{time=8.947,key="o"},{time=9.474,key="p"},
    {time=10.000,key="a"},{time=10.526,key="p"},{time=11.053,key="o"},
    {time=11.579,key="i"},{time=12.105,key="u"},{time=12.632,key="t"},
    {time=13.158,key="p"},{time=13.684,key="a"},{time=14.211,key="s"},
    {time=14.737,key="a"},{time=15.263,key="p"},{time=16.316,key="o"},
    -- Pre-chorus
    {time=17.368,key="o"},{time=17.895,key="p"},{time=18.421,key="a"},
    {time=18.947,key="s"},{time=19.474,key="a"},{time=20.000,key="p"},
    {time=20.526,key="o"},{time=21.053,key="i"},{time=21.579,key="u"},
    {time=22.105,key="y"},{time=22.632,key="t"},
    -- Chorus "Dy-na-mi-te"
    {time=23.684,key="a"},{time=24.211,key="s"},{time=24.737,key="d"},
    {time=25.263,key="s"},{time=25.789,key="a"},{time=26.316,key="p"},
    {time=26.842,key="o"},{time=27.895,key="p"},
    {time=28.421,key="a"},{time=28.947,key="s"},{time=29.474,key="d"},
    {time=30.000,key="f"},{time=30.526,key="d"},{time=31.053,key="s"},
    {time=31.579,key="a"},{time=32.632,key="p"},
    -- Repeat chorus
    {time=33.684,key="a"},{time=34.211,key="s"},{time=34.737,key="d"},
    {time=35.263,key="s"},{time=35.789,key="a"},{time=36.316,key="p"},
    {time=36.842,key="a"},{time=37.368,key="s"},{time=37.895,key="d"},
    {time=38.421,key="f"},{time=38.947,key="d"},{time=39.474,key="s"},
    {time=40.000,key="a"},{time=41.053,key="p"},
    -- Bridge "Life is sweet as honey"
    {time=42.105,key="p"},{time=42.632,key="a"},{time=43.158,key="p"},
    {time=43.684,key="o"},{time=44.211,key="i"},{time=44.737,key="u"},
    {time=45.263,key="y"},{time=45.789,key="t"},
    {time=46.316,key="p"},{time=46.842,key="a"},{time=47.368,key="s"},
    {time=47.895,key="a"},{time=48.421,key="p"},{time=48.947,key="o"},
}

-- 25. Boy With Luv (BTS) - Key: E major, 106 BPM
local notes_boy_with_luv = {
    {time=0.000,key="p"},{time=0.566,key="a"},{time=1.132,key="p"},
    {time=1.698,key="o"},{time=2.264,key="p"},{time=2.830,key="a"},
    {time=3.396,key="p"},{time=3.962,key="o"},
    {time=4.528,key="i"},{time=5.094,key="u"},{time=5.660,key="y"},
    {time=6.226,key="t"},{time=7.358,key="u"},
    {time=7.925,key="p"},{time=8.491,key="a"},{time=9.057,key="s"},
    {time=9.623,key="a"},{time=10.189,key="p"},{time=10.755,key="o"},
    {time=11.321,key="p"},{time=11.887,key="a"},{time=12.453,key="p"},
    {time=13.019,key="o"},{time=13.585,key="i"},{time=14.151,key="u"},
    {time=14.717,key="t"},{time=15.849,key="y"},
    -- Chorus
    {time=16.981,key="a"},{time=17.547,key="s"},{time=18.113,key="d"},
    {time=18.679,key="s"},{time=19.245,key="a"},{time=19.811,key="p"},
    {time=20.377,key="o"},{time=20.943,key="i"},{time=21.509,key="u"},
    {time=22.075,key="p"},{time=22.641,key="a"},{time=23.774,key="p"},
    {time=24.340,key="a"},{time=24.906,key="s"},{time=25.472,key="d"},
    {time=26.038,key="f"},{time=26.604,key="d"},{time=27.170,key="s"},
    {time=27.736,key="a"},{time=28.868,key="p"},
    {time=30.000,key="a"},{time=30.566,key="s"},{time=31.132,key="d"},
    {time=31.698,key="s"},{time=32.264,key="a"},{time=32.830,key="p"},
    {time=33.396,key="o"},{time=33.962,key="p"},{time=34.528,key="a"},
    {time=35.094,key="s"},{time=35.660,key="d"},{time=36.226,key="s"},
    {time=36.792,key="a"},{time=37.925,key="p"},
}

-- 26. How You Like That (BLACKPINK) - Key: G minor, 130 BPM
local notes_how_you_like_that = {
    -- Drop
    {time=0.000,key="o"},{time=0.231,key="o"},{time=0.462,key="P"},
    {time=0.692,key="o"},{time=0.923,key="i"},{time=1.154,key="u"},
    {time=1.385,key="i"},{time=1.615,key="o"},
    {time=1.846,key="o"},{time=2.077,key="o"},{time=2.308,key="P"},
    {time=2.538,key="o"},{time=2.769,key="p"},{time=3.000,key="a"},
    {time=3.462,key="o"},
    -- Verse "Look at you now look at me"
    {time=4.615,key="p"},{time=5.077,key="o"},{time=5.538,key="i"},
    {time=6.000,key="u"},{time=6.462,key="o"},{time=6.923,key="i"},
    {time=7.385,key="u"},{time=7.846,key="t"},
    {time=8.308,key="p"},{time=8.769,key="o"},{time=9.231,key="i"},
    {time=9.692,key="u"},{time=10.154,key="y"},{time=10.615,key="t"},
    -- Pre-chorus
    {time=12.923,key="a"},{time=13.385,key="p"},{time=13.846,key="o"},
    {time=14.308,key="i"},{time=14.769,key="u"},{time=15.231,key="y"},
    {time=15.692,key="t"},{time=16.615,key="u"},
    -- Chorus "How you like that"
    {time=18.462,key="o"},{time=18.923,key="P"},{time=19.385,key="o"},
    {time=19.846,key="i"},{time=20.308,key="u"},{time=20.769,key="i"},
    {time=21.231,key="o"},{time=22.154,key="p"},
    {time=22.615,key="o"},{time=23.077,key="P"},{time=23.538,key="o"},
    {time=24.000,key="p"},{time=24.462,key="a"},{time=24.923,key="p"},
    {time=25.385,key="o"},{time=26.308,key="i"},
    -- Repeat chorus
    {time=27.692,key="o"},{time=28.154,key="P"},{time=28.615,key="o"},
    {time=29.077,key="i"},{time=29.538,key="u"},{time=30.000,key="i"},
    {time=30.462,key="o"},{time=31.385,key="p"},
    {time=31.846,key="o"},{time=32.308,key="P"},{time=32.769,key="o"},
    {time=33.231,key="p"},{time=33.692,key="a"},{time=34.154,key="p"},
    {time=34.615,key="o"},{time=35.538,key="i"},
}

-- ============================================================
-- ANIME
-- ============================================================

-- 27. Naruto Main Theme - Key: D minor, 100 BPM
local notes_naruto_main = {
    -- Opening phrase
    {time=0.000,key="d"},{time=0.300,key="f"},{time=0.600,key="g"},
    {time=0.900,key="h"},{time=1.200,key="j"},{time=1.800,key="j"},
    {time=2.100,key="k"},{time=2.400,key="j"},{time=2.700,key="h"},
    {time=3.000,key="g"},{time=3.900,key="f"},
    {time=4.800,key="d"},{time=5.100,key="f"},{time=5.400,key="g"},
    {time=5.700,key="h"},{time=6.000,key="j"},{time=6.600,key="h"},
    {time=6.900,key="g"},{time=7.200,key="f"},{time=7.500,key="g"},
    {time=8.400,key="d"},
    -- Rising phrase
    {time=9.600,key="f"},{time=9.900,key="g"},{time=10.200,key="h"},
    {time=10.800,key="j"},{time=11.100,key="k"},{time=11.400,key="j"},
    {time=11.700,key="h"},{time=12.600,key="g"},
    {time=13.200,key="h"},{time=13.800,key="j"},{time=14.400,key="k"},
    {time=15.000,key="j"},{time=15.600,key="h"},{time=16.200,key="g"},
    {time=16.800,key="f"},{time=18.000,key="d"},
    -- Emotional peak
    {time=19.200,key="j"},{time=19.800,key="k"},{time=20.400,key="l"},
    {time=21.000,key="k"},{time=21.600,key="j"},{time=22.200,key="h"},
    {time=22.800,key="j"},{time=24.000,key="h"},
    {time=24.600,key="j"},{time=25.200,key="k"},{time=25.800,key="j"},
    {time=26.400,key="h"},{time=27.000,key="g"},{time=27.600,key="f"},
    {time=28.800,key="d"},
    -- Final
    {time=30.000,key="f"},{time=30.600,key="g"},{time=31.200,key="h"},
    {time=31.800,key="j"},{time=32.400,key="h"},{time=33.000,key="g"},
    {time=33.600,key="f"},{time=34.200,key="d"},
    {time=35.400,key="f"},{time=36.000,key="g"},{time=36.600,key="h"},
    {time=37.200,key="j"},{time=37.800,key="k"},{time=38.400,key="j"},
    {time=39.000,key="h"},{time=40.200,key="d"},
}

-- 28. One Piece - We Are! - Key: A major, 120 BPM
local notes_we_are = {
    -- Intro trumpet call
    {time=0.000,key="p"},{time=0.250,key="a"},{time=0.500,key="p"},
    {time=0.750,key="o"},{time=1.000,key="p"},{time=1.250,key="a"},
    {time=1.500,key="s"},{time=2.000,key="a"},
    -- Verse "We are We are on the cruise"
    {time=3.000,key="p"},{time=3.500,key="p"},{time=4.000,key="a"},
    {time=4.500,key="p"},{time=5.000,key="o"},{time=5.500,key="p"},
    {time=6.000,key="a"},{time=6.500,key="p"},{time=7.000,key="a"},
    {time=7.500,key="p"},{time=8.000,key="o"},{time=8.500,key="i"},
    {time=9.000,key="u"},
    {time=10.000,key="p"},{time=10.500,key="p"},{time=11.000,key="a"},
    {time=11.500,key="p"},{time=12.000,key="o"},{time=12.500,key="p"},
    {time=13.000,key="a"},{time=13.500,key="p"},{time=14.000,key="a"},
    {time=14.500,key="s"},{time=15.000,key="d"},{time=15.500,key="s"},
    {time=16.000,key="a"},
    -- Chorus "We are! We are!"
    {time=18.000,key="a"},{time=18.500,key="s"},{time=19.000,key="d"},
    {time=19.500,key="s"},{time=20.000,key="a"},{time=20.500,key="p"},
    {time=21.000,key="o"},{time=22.000,key="p"},
    {time=23.000,key="a"},{time=23.500,key="s"},{time=24.000,key="d"},
    {time=24.500,key="f"},{time=25.000,key="d"},{time=25.500,key="s"},
    {time=26.000,key="a"},{time=27.000,key="p"},
    -- Bridge
    {time=28.000,key="o"},{time=28.500,key="p"},{time=29.000,key="a"},
    {time=29.500,key="s"},{time=30.000,key="a"},{time=30.500,key="p"},
    {time=31.000,key="o"},{time=32.000,key="i"},
    {time=33.000,key="a"},{time=33.500,key="s"},{time=34.000,key="d"},
    {time=34.500,key="s"},{time=35.000,key="a"},{time=35.500,key="p"},
    {time=36.000,key="a"},{time=37.000,key="p"},
}

-- 29. Attack on Titan - Guren no Yumiya - Key: D minor, 138 BPM
local notes_guren_no_yumiya = {
    -- Iconic opening run
    {time=0.000,key="d"},{time=0.217,key="f"},{time=0.435,key="g"},
    {time=0.652,key="h"},{time=0.870,key="j"},{time=1.087,key="h"},
    {time=1.304,key="g"},{time=1.522,key="f"},{time=1.739,key="d"},
    {time=1.957,key="f"},{time=2.174,key="g"},{time=2.391,key="h"},
    {time=2.609,key="j"},{time=3.043,key="h"},
    -- Main riff
    {time=3.478,key="j"},{time=3.913,key="k"},{time=4.348,key="j"},
    {time=4.783,key="h"},{time=5.217,key="g"},{time=5.652,key="f"},
    {time=6.087,key="g"},{time=6.522,key="h"},{time=6.957,key="j"},
    {time=7.826,key="h"},
    {time=8.261,key="j"},{time=8.696,key="k"},{time=9.130,key="j"},
    {time=9.565,key="h"},{time=10.000,key="g"},{time=10.435,key="f"},
    {time=10.870,key="d"},{time=12.174,key="d"},
    -- Verse melody
    {time=13.043,key="j"},{time=13.478,key="j"},{time=13.913,key="k"},
    {time=14.348,key="j"},{time=14.783,key="h"},{time=15.217,key="j"},
    {time=15.652,key="h"},{time=16.522,key="g"},
    {time=17.391,key="j"},{time=17.826,key="j"},{time=18.261,key="k"},
    {time=18.696,key="j"},{time=19.130,key="h"},{time=19.565,key="g"},
    {time=20.000,key="f"},{time=21.304,key="d"},
    -- Chorus power
    {time=22.174,key="j"},{time=22.609,key="k"},{time=23.043,key="l"},
    {time=23.478,key="k"},{time=23.913,key="j"},{time=24.348,key="h"},
    {time=24.783,key="j"},{time=25.652,key="h"},
    {time=26.087,key="j"},{time=26.522,key="k"},{time=26.957,key="l"},
    {time=27.391,key="k"},{time=27.826,key="j"},{time=28.261,key="h"},
    {time=28.696,key="g"},{time=30.000,key="f"},
    -- Final run
    {time=31.304,key="d"},{time=31.522,key="f"},{time=31.739,key="g"},
    {time=31.957,key="h"},{time=32.174,key="j"},{time=32.391,key="k"},
    {time=32.609,key="l"},{time=32.826,key="k"},{time=33.043,key="j"},
    {time=33.478,key="h"},{time=33.913,key="j"},
    {time=34.348,key="k"},{time=34.783,key="j"},{time=35.217,key="h"},
    {time=35.652,key="g"},{time=36.087,key="f"},{time=37.391,key="d"},
}

-- 30. Sword Art Online - Crossing Field - Key: D major, 142 BPM
local notes_crossing_field = {
    -- Intro
    {time=0.000,key="y"},{time=0.423,key="u"},{time=0.845,key="I"},
    {time=1.268,key="o"},{time=1.690,key="p"},{time=2.113,key="a"},
    {time=2.535,key="p"},{time=2.958,key="o"},
    {time=3.380,key="y"},{time=3.803,key="u"},{time=4.225,key="I"},
    {time=4.648,key="o"},{time=5.070,key="I"},{time=5.493,key="u"},
    {time=5.915,key="y"},
    -- Verse
    {time=7.042,key="o"},{time=7.465,key="p"},{time=7.887,key="a"},
    {time=8.310,key="p"},{time=8.732,key="o"},{time=9.155,key="I"},
    {time=9.577,key="u"},{time=10.000,key="y"},
    {time=10.845,key="o"},{time=11.268,key="p"},{time=11.690,key="a"},
    {time=12.113,key="s"},{time=12.535,key="a"},{time=12.958,key="p"},
    {time=13.380,key="o"},{time=14.225,key="I"},
    -- Pre-chorus
    {time=15.070,key="p"},{time=15.493,key="a"},{time=15.915,key="s"},
    {time=16.338,key="d"},{time=16.761,key="s"},{time=17.183,key="a"},
    {time=17.606,key="p"},{time=18.028,key="o"},{time=18.451,key="I"},
    {time=18.873,key="u"},{time=19.296,key="y"},
    -- Chorus
    {time=20.423,key="a"},{time=20.845,key="s"},{time=21.268,key="d"},
    {time=21.690,key="f"},{time=22.113,key="d"},{time=22.535,key="s"},
    {time=22.958,key="a"},{time=23.803,key="p"},
    {time=24.648,key="a"},{time=25.070,key="s"},{time=25.493,key="d"},
    {time=25.915,key="f"},{time=26.338,key="g"},{time=26.761,key="f"},
    {time=27.183,key="d"},{time=27.606,key="s"},{time=28.451,key="a"},
    -- Repeat chorus
    {time=29.296,key="a"},{time=29.718,key="s"},{time=30.141,key="d"},
    {time=30.563,key="f"},{time=30.986,key="d"},{time=31.408,key="s"},
    {time=31.831,key="a"},{time=32.676,key="p"},
    {time=33.521,key="a"},{time=33.944,key="s"},{time=34.366,key="d"},
    {time=34.789,key="f"},{time=35.211,key="g"},{time=35.634,key="f"},
    {time=36.056,key="d"},{time=36.479,key="s"},{time=37.324,key="a"},
}

-- 31. Dragon Ball Z - Cha-La Head-Cha-La - Key: C major, 140 BPM
local notes_chala = {
    -- Intro
    {time=0.000,key="u"},{time=0.214,key="i"},{time=0.429,key="o"},
    {time=0.643,key="p"},{time=0.857,key="a"},{time=1.071,key="p"},
    {time=1.286,key="o"},{time=1.500,key="i"},
    {time=1.714,key="u"},{time=2.143,key="y"},{time=2.571,key="t"},
    -- Verse
    {time=3.429,key="u"},{time=3.857,key="u"},{time=4.286,key="o"},
    {time=4.714,key="u"},{time=5.143,key="o"},{time=5.571,key="p"},
    {time=6.000,key="o"},{time=6.429,key="u"},{time=6.857,key="i"},
    {time=7.286,key="u"},{time=7.714,key="t"},
    {time=8.571,key="u"},{time=9.000,key="u"},{time=9.429,key="o"},
    {time=9.857,key="u"},{time=10.286,key="o"},{time=10.714,key="p"},
    {time=11.143,key="a"},{time=11.571,key="p"},{time=12.000,key="o"},
    {time=12.429,key="i"},{time=12.857,key="u"},{time=13.714,key="y"},
    -- Chorus "Cha-La Head-Cha-La"
    {time=15.000,key="a"},{time=15.429,key="s"},{time=15.857,key="d"},
    {time=16.286,key="s"},{time=16.714,key="a"},{time=17.143,key="p"},
    {time=17.571,key="o"},{time=18.429,key="p"},
    {time=19.286,key="a"},{time=19.714,key="s"},{time=20.143,key="d"},
    {time=20.571,key="f"},{time=21.000,key="d"},{time=21.429,key="s"},
    {time=21.857,key="a"},{time=22.714,key="p"},
    -- Repeat chorus
    {time=23.571,key="a"},{time=24.000,key="s"},{time=24.429,key="d"},
    {time=24.857,key="s"},{time=25.286,key="a"},{time=25.714,key="p"},
    {time=26.143,key="a"},{time=27.000,key="s"},
    {time=27.857,key="a"},{time=28.286,key="s"},{time=28.714,key="d"},
    {time=29.143,key="f"},{time=29.571,key="g"},{time=30.000,key="f"},
    {time=30.429,key="d"},{time=30.857,key="s"},{time=31.714,key="a"},
}

-- ============================================================
-- WESTERN POP (continued)
-- ============================================================

-- 32. Hotel California (Eagles) - Key: B minor, 75 BPM
local notes_hotel_california = {
    -- Iconic guitar intro adapted for piano
    {time=0.000,key="y"},{time=0.400,key="I"},{time=0.800,key="o"},
    {time=1.200,key="p"},{time=1.600,key="O"},{time=2.000,key="p"},
    {time=2.400,key="o"},{time=2.800,key="I"},
    {time=3.200,key="u"},{time=3.600,key="y"},{time=4.000,key="I"},
    {time=4.400,key="o"},{time=4.800,key="p"},{time=5.600,key="O"},
    {time=6.400,key="p"},{time=7.200,key="o"},
    {time=8.000,key="p"},{time=8.400,key="a"},{time=8.800,key="p"},
    {time=9.200,key="o"},{time=9.600,key="I"},{time=10.400,key="u"},
    {time=11.200,key="y"},{time=12.800,key="I"},
    -- Verse "On a dark desert highway"
    {time=14.400,key="y"},{time=14.800,key="u"},{time=15.200,key="I"},
    {time=15.600,key="o"},{time=16.000,key="p"},{time=16.400,key="o"},
    {time=16.800,key="I"},{time=17.200,key="u"},{time=17.600,key="y"},
    {time=18.400,key="I"},{time=18.800,key="o"},{time=19.200,key="p"},
    {time=19.600,key="o"},{time=20.000,key="I"},{time=20.400,key="u"},
    {time=21.600,key="y"},
    -- "Cool wind in my hair"
    {time=22.400,key="u"},{time=22.800,key="I"},{time=23.200,key="o"},
    {time=23.600,key="I"},{time=24.000,key="u"},{time=24.400,key="y"},
    {time=25.600,key="t"},
    -- Chorus "Welcome to the Hotel California"
    {time=28.800,key="p"},{time=29.200,key="a"},{time=29.600,key="s"},
    {time=30.000,key="a"},{time=30.400,key="p"},{time=30.800,key="o"},
    {time=31.200,key="I"},{time=31.600,key="u"},{time=32.000,key="y"},
    {time=33.600,key="p"},{time=34.000,key="a"},{time=34.400,key="s"},
    {time=34.800,key="d"},{time=35.200,key="s"},{time=35.600,key="a"},
    {time=36.000,key="p"},{time=36.400,key="o"},
    {time=38.400,key="p"},{time=38.800,key="a"},{time=39.200,key="s"},
    {time=39.600,key="a"},{time=40.000,key="p"},{time=40.400,key="o"},
    {time=40.800,key="I"},{time=41.600,key="u"},
}

-- 33. Yesterday (Beatles) - Key: F major, 62 BPM
local notes_yesterday = {
    -- "Yesterday all my troubles seemed so far away"
    {time=0.000,key="u"},{time=0.484,key="I"},{time=0.968,key="o"},
    {time=1.452,key="I"},{time=1.935,key="u"},{time=2.419,key="y"},
    {time=2.903,key="t"},{time=4.839,key="y"},
    {time=5.323,key="u"},{time=5.806,key="I"},{time=6.290,key="o"},
    {time=6.774,key="I"},{time=7.258,key="u"},{time=8.226,key="y"},
    -- "Now it looks as though they're here to stay"
    {time=9.677,key="u"},{time=10.161,key="I"},{time=10.645,key="o"},
    {time=11.129,key="p"},{time=11.613,key="o"},{time=12.097,key="I"},
    {time=12.581,key="u"},{time=14.516,key="t"},
    -- "Oh I believe in yesterday"
    {time=16.129,key="o"},{time=16.613,key="I"},{time=17.097,key="u"},
    {time=17.581,key="I"},{time=18.065,key="o"},{time=18.548,key="p"},
    {time=19.032,key="o"},{time=19.516,key="I"},{time=20.000,key="u"},
    {time=21.935,key="y"},
    -- "Suddenly I'm not half the man I used to be"
    {time=24.194,key="u"},{time=24.677,key="I"},{time=25.161,key="o"},
    {time=25.645,key="I"},{time=26.129,key="u"},{time=26.613,key="y"},
    {time=27.097,key="t"},{time=29.032,key="y"},
    {time=29.516,key="u"},{time=30.000,key="I"},{time=30.484,key="o"},
    {time=30.968,key="I"},{time=31.452,key="u"},{time=32.419,key="y"},
    -- "There's a shadow hanging over me"
    {time=33.871,key="u"},{time=34.355,key="I"},{time=34.839,key="o"},
    {time=35.323,key="p"},{time=35.806,key="o"},{time=36.290,key="I"},
    {time=36.774,key="u"},{time=38.710,key="t"},
    -- "Oh yesterday came suddenly"
    {time=40.323,key="o"},{time=40.806,key="I"},{time=41.290,key="u"},
    {time=41.774,key="I"},{time=42.258,key="o"},{time=42.742,key="p"},
    {time=43.226,key="o"},{time=43.710,key="I"},{time=44.194,key="u"},
    {time=46.129,key="t"},
}

-- 34. Hallelujah (Leonard Cohen) - Key: C major, 52 BPM
local notes_hallelujah = {
    -- "Now I've heard there was a secret chord"
    {time=0.000,key="t"},{time=0.577,key="u"},{time=1.154,key="u"},
    {time=1.731,key="i"},{time=2.308,key="u"},{time=2.885,key="i"},
    {time=3.462,key="u"},{time=4.038,key="y"},{time=5.192,key="t"},
    {time=6.346,key="t"},{time=6.923,key="u"},{time=7.500,key="u"},
    {time=8.077,key="i"},{time=8.654,key="u"},{time=9.231,key="i"},
    {time=9.808,key="u"},{time=10.385,key="o"},{time=11.538,key="p"},
    -- "That David played and it pleased the Lord"
    {time=12.692,key="o"},{time=13.269,key="p"},{time=13.846,key="o"},
    {time=14.423,key="i"},{time=15.000,key="u"},{time=15.577,key="i"},
    {time=16.154,key="u"},{time=16.731,key="y"},{time=17.885,key="t"},
    -- Chorus "Hallelujah"
    {time=20.192,key="o"},{time=20.769,key="o"},{time=21.346,key="o"},
    {time=21.923,key="p"},{time=22.500,key="o"},{time=23.077,key="i"},
    {time=23.654,key="u"},{time=25.962,key="t"},
    {time=27.115,key="o"},{time=27.692,key="o"},{time=28.269,key="p"},
    {time=28.846,key="o"},{time=29.423,key="i"},{time=30.000,key="u"},
    {time=30.577,key="i"},{time=31.154,key="o"},{time=33.462,key="u"},
    -- Repeat "Hallelujah"
    {time=35.769,key="p"},{time=36.346,key="a"},{time=36.923,key="p"},
    {time=37.500,key="o"},{time=38.077,key="i"},{time=38.654,key="u"},
    {time=39.231,key="y"},{time=41.538,key="t"},
    {time=42.692,key="p"},{time=43.269,key="a"},{time=43.846,key="s"},
    {time=44.423,key="a"},{time=45.000,key="p"},{time=45.577,key="o"},
    {time=46.154,key="i"},{time=46.731,key="u"},{time=49.038,key="t"},
}

-- 35. All of Me (John Legend) - Key: Ab major, 63 BPM
local notes_all_of_me = {
    -- Verse "What would I do without your smart mouth"
    {time=0.000,key="p"},{time=0.476,key="o"},{time=0.952,key="p"},
    {time=1.429,key="a"},{time=1.905,key="p"},{time=2.381,key="o"},
    {time=2.857,key="i"},{time=3.333,key="u"},{time=4.762,key="y"},
    {time=5.714,key="p"},{time=6.190,key="o"},{time=6.667,key="p"},
    {time=7.143,key="a"},{time=7.619,key="p"},{time=8.095,key="o"},
    {time=8.571,key="i"},{time=9.524,key="u"},
    -- Pre-chorus
    {time=11.429,key="u"},{time=11.905,key="i"},{time=12.381,key="o"},
    {time=12.857,key="p"},{time=13.333,key="a"},{time=13.810,key="p"},
    {time=14.286,key="o"},{time=14.762,key="a"},{time=15.238,key="s"},
    {time=15.714,key="d"},{time=16.190,key="s"},{time=16.667,key="a"},
    {time=17.143,key="p"},
    -- Chorus "All of me loves all of you"
    {time=19.048,key="p"},{time=19.524,key="a"},{time=20.000,key="s"},
    {time=20.476,key="a"},{time=20.952,key="p"},{time=21.429,key="o"},
    {time=21.905,key="i"},{time=22.381,key="u"},{time=23.810,key="y"},
    {time=25.714,key="p"},{time=26.190,key="a"},{time=26.667,key="s"},
    {time=27.143,key="d"},{time=27.619,key="s"},{time=28.095,key="a"},
    {time=28.571,key="p"},{time=29.524,key="o"},
    -- "Give your all to me I'll give my all to you"
    {time=31.429,key="p"},{time=31.905,key="a"},{time=32.381,key="s"},
    {time=32.857,key="a"},{time=33.333,key="p"},{time=33.810,key="o"},
    {time=34.286,key="i"},{time=34.762,key="u"},{time=36.190,key="y"},
    -- "You're my end and my beginning"
    {time=38.095,key="p"},{time=38.571,key="a"},{time=39.048,key="s"},
    {time=39.524,key="d"},{time=40.000,key="s"},{time=40.476,key="a"},
    {time=40.952,key="p"},{time=41.905,key="o"},
    -- Final chorus
    {time=43.810,key="p"},{time=44.286,key="a"},{time=44.762,key="s"},
    {time=45.238,key="a"},{time=45.714,key="p"},{time=46.190,key="o"},
    {time=46.667,key="i"},{time=47.143,key="u"},{time=48.571,key="p"},
}

-- 36. Stay With Me (Sam Smith) - Key: C major, 105 BPM
local notes_stay_with_me = {
    -- Verse
    {time=0.000,key="o"},{time=0.571,key="p"},{time=1.143,key="o"},
    {time=1.714,key="i"},{time=2.286,key="u"},{time=2.857,key="i"},
    {time=3.429,key="u"},{time=4.000,key="t"},
    {time=4.571,key="o"},{time=5.143,key="p"},{time=5.714,key="o"},
    {time=6.286,key="i"},{time=6.857,key="u"},{time=7.429,key="y"},
    {time=8.000,key="t"},
    -- Chorus "Oh won't you stay with me"
    {time=10.286,key="a"},{time=10.857,key="s"},{time=11.429,key="a"},
    {time=12.000,key="p"},{time=12.571,key="o"},{time=13.143,key="i"},
    {time=13.714,key="u"},{time=15.429,key="y"},
    {time=16.000,key="a"},{time=16.571,key="s"},{time=17.143,key="a"},
    {time=17.714,key="p"},{time=18.286,key="a"},{time=18.857,key="s"},
    {time=19.429,key="d"},{time=21.143,key="s"},
    -- Repeat chorus
    {time=22.286,key="a"},{time=22.857,key="s"},{time=23.429,key="a"},
    {time=24.000,key="p"},{time=24.571,key="o"},{time=25.143,key="i"},
    {time=25.714,key="u"},{time=27.429,key="y"},
    {time=28.000,key="a"},{time=28.571,key="s"},{time=29.143,key="a"},
    {time=29.714,key="p"},{time=30.286,key="a"},{time=30.857,key="s"},
    {time=31.429,key="d"},{time=33.143,key="s"},
    -- Bridge
    {time=35.429,key="s"},{time=36.000,key="d"},{time=36.571,key="s"},
    {time=37.143,key="a"},{time=37.714,key="p"},{time=38.286,key="o"},
    {time=38.857,key="i"},{time=39.429,key="u"},
}

-- 37. Happy (Pharrell Williams) - Key: F minor, 160 BPM
local notes_happy = {
    -- Funky intro riff
    {time=0.000,key="u"},{time=0.375,key="y"},{time=0.750,key="u"},
    {time=0.938,key="i"},{time=1.125,key="u"},{time=1.500,key="y"},
    {time=1.875,key="t"},{time=2.250,key="r"},
    {time=2.625,key="u"},{time=3.000,key="y"},{time=3.375,key="u"},
    {time=3.563,key="i"},{time=3.750,key="u"},{time=4.125,key="y"},
    {time=4.500,key="t"},{time=5.250,key="r"},
    -- Verse "It might seem crazy what I'm about to say"
    {time=6.000,key="u"},{time=6.375,key="u"},{time=6.750,key="i"},
    {time=7.125,key="u"},{time=7.500,key="i"},{time=7.875,key="o"},
    {time=8.250,key="i"},{time=8.625,key="u"},{time=9.000,key="y"},
    {time=9.750,key="t"},
    {time=10.500,key="u"},{time=10.875,key="u"},{time=11.250,key="i"},
    {time=11.625,key="u"},{time=12.000,key="i"},{time=12.375,key="o"},
    {time=12.750,key="p"},{time=13.125,key="o"},{time=13.500,key="i"},
    {time=14.250,key="u"},
    -- Chorus "Because I'm Happy"
    {time=15.750,key="o"},{time=16.125,key="p"},{time=16.500,key="o"},
    {time=16.875,key="i"},{time=17.250,key="o"},{time=17.625,key="p"},
    {time=18.000,key="a"},{time=18.750,key="p"},
    {time=19.500,key="o"},{time=19.875,key="p"},{time=20.250,key="o"},
    {time=20.625,key="i"},{time=21.000,key="o"},{time=21.375,key="i"},
    {time=21.750,key="u"},{time=22.500,key="y"},
    -- Repeat chorus
    {time=23.250,key="o"},{time=23.625,key="p"},{time=24.000,key="o"},
    {time=24.375,key="i"},{time=24.750,key="o"},{time=25.125,key="p"},
    {time=25.500,key="a"},{time=26.250,key="p"},
    {time=27.000,key="o"},{time=27.375,key="p"},{time=27.750,key="o"},
    {time=28.125,key="i"},{time=28.500,key="o"},{time=28.875,key="i"},
    {time=29.250,key="u"},{time=30.000,key="y"},
}

-- 38. Blinding Lights (The Weeknd) - Key: F minor, 171 BPM
local notes_blinding_lights = {
    -- Synth intro
    {time=0.000,key="u"},{time=0.351,key="i"},{time=0.702,key="o"},
    {time=1.053,key="p"},{time=1.404,key="a"},{time=1.754,key="s"},
    {time=2.105,key="a"},{time=2.456,key="p"},
    {time=2.807,key="u"},{time=3.158,key="i"},{time=3.509,key="o"},
    {time=3.860,key="p"},{time=4.211,key="a"},{time=4.561,key="s"},
    {time=4.912,key="d"},{time=5.614,key="s"},
    -- Verse
    {time=7.018,key="p"},{time=7.368,key="o"},{time=7.719,key="i"},
    {time=8.070,key="u"},{time=8.421,key="y"},{time=8.772,key="u"},
    {time=9.123,key="i"},{time=9.474,key="o"},{time=9.825,key="p"},
    {time=10.526,key="a"},
    {time=11.228,key="p"},{time=11.579,key="o"},{time=11.930,key="i"},
    {time=12.281,key="u"},{time=12.632,key="y"},{time=12.982,key="u"},
    {time=13.333,key="i"},{time=13.684,key="o"},{time=14.386,key="p"},
    -- Chorus "I'm blinded by the lights"
    {time=16.491,key="p"},{time=16.842,key="a"},{time=17.193,key="s"},
    {time=17.544,key="a"},{time=17.895,key="p"},{time=18.246,key="o"},
    {time=18.596,key="p"},{time=18.947,key="a"},{time=19.298,key="s"},
    {time=19.649,key="d"},{time=20.351,key="s"},{time=20.702,key="a"},
    {time=21.053,key="p"},{time=21.404,key="o"},
    -- "No I can't sleep until I feel your touch"
    {time=22.807,key="p"},{time=23.158,key="a"},{time=23.509,key="s"},
    {time=23.860,key="a"},{time=24.211,key="p"},{time=24.561,key="o"},
    {time=24.912,key="i"},{time=25.263,key="u"},{time=26.316,key="y"},
    -- Repeat chorus
    {time=28.421,key="p"},{time=28.772,key="a"},{time=29.123,key="s"},
    {time=29.474,key="a"},{time=29.825,key="p"},{time=30.175,key="o"},
    {time=30.526,key="p"},{time=30.877,key="a"},{time=31.228,key="s"},
    {time=31.579,key="d"},{time=32.281,key="s"},{time=32.632,key="a"},
    {time=32.982,key="p"},{time=33.333,key="o"},
}

-- 39. Bad Guy (Billie Eilish) - Key: G minor, 135 BPM
local notes_bad_guy = {
    -- Minimalist verse
    {time=0.000,key="o"},{time=0.444,key="o"},{time=0.889,key="p"},
    {time=1.333,key="o"},{time=1.778,key="i"},{time=2.222,key="u"},
    {time=2.667,key="i"},{time=3.111,key="o"},
    {time=3.556,key="o"},{time=4.000,key="o"},{time=4.444,key="p"},
    {time=4.889,key="o"},{time=5.333,key="a"},{time=5.778,key="p"},
    {time=6.222,key="o"},{time=6.667,key="i"},
    -- "I like it"
    {time=8.000,key="u"},{time=8.444,key="i"},{time=8.889,key="o"},
    {time=9.333,key="p"},{time=9.778,key="o"},{time=10.222,key="i"},
    {time=10.667,key="u"},{time=11.111,key="y"},
    -- Chorus drop "duh"
    {time=12.444,key="o"},{time=12.667,key="o"},{time=12.889,key="o"},
    {time=13.111,key="p"},{time=13.333,key="o"},{time=13.556,key="i"},
    {time=13.778,key="o"},{time=14.000,key="u"},
    {time=14.222,key="o"},{time=14.444,key="o"},{time=14.667,key="o"},
    {time=14.889,key="p"},{time=15.111,key="a"},{time=15.333,key="p"},
    {time=15.556,key="o"},{time=15.778,key="i"},
    {time=16.000,key="o"},{time=16.222,key="o"},{time=16.444,key="o"},
    {time=16.667,key="p"},{time=16.889,key="o"},{time=17.111,key="i"},
    {time=17.333,key="u"},{time=17.556,key="y"},
    {time=17.778,key="o"},{time=18.000,key="o"},{time=18.222,key="o"},
    {time=18.444,key="p"},{time=18.667,key="a"},{time=18.889,key="s"},
    {time=19.111,key="a"},{time=19.556,key="p"},
    -- Bridge
    {time=21.333,key="u"},{time=21.778,key="i"},{time=22.222,key="o"},
    {time=22.667,key="p"},{time=23.111,key="a"},{time=23.556,key="s"},
    {time=24.000,key="a"},{time=24.444,key="p"},{time=24.889,key="o"},
    {time=25.778,key="i"},
}

-- 40. Uptown Funk (Bruno Mars) - Key: D minor, 115 BPM
local notes_uptown_funk = {
    -- Funky intro riff
    {time=0.000,key="d"},{time=0.261,key="f"},{time=0.522,key="g"},
    {time=0.783,key="f"},{time=1.043,key="d"},{time=1.304,key="s"},
    {time=1.565,key="d"},{time=2.087,key="f"},
    {time=2.348,key="g"},{time=2.609,key="h"},{time=2.870,key="g"},
    {time=3.130,key="f"},{time=3.391,key="d"},{time=3.913,key="s"},
    -- Verse "This hit that ice cold"
    {time=5.217,key="d"},{time=5.478,key="f"},{time=5.739,key="g"},
    {time=6.000,key="f"},{time=6.261,key="d"},{time=6.522,key="s"},
    {time=6.783,key="d"},{time=7.304,key="f"},
    {time=7.565,key="g"},{time=7.826,key="h"},{time=8.348,key="g"},
    {time=8.609,key="f"},{time=8.870,key="d"},{time=9.391,key="s"},
    -- "Uptown funk gonna give it to ya"
    {time=10.435,key="j"},{time=10.696,key="j"},{time=10.957,key="j"},
    {time=11.217,key="h"},{time=11.478,key="j"},{time=11.739,key="k"},
    {time=12.261,key="j"},{time=12.522,key="h"},{time=12.783,key="g"},
    {time=13.565,key="f"},
    {time=14.087,key="j"},{time=14.348,key="j"},{time=14.609,key="j"},
    {time=14.870,key="h"},{time=15.130,key="j"},{time=15.391,key="k"},
    {time=15.913,key="j"},{time=16.174,key="h"},{time=16.435,key="g"},
    {time=17.217,key="f"},
    -- Chorus "Don't believe me just watch"
    {time=18.261,key="k"},{time=18.783,key="j"},{time=19.043,key="h"},
    {time=19.304,key="g"},{time=19.565,key="f"},{time=20.087,key="d"},
    {time=20.609,key="f"},{time=20.870,key="g"},{time=21.130,key="h"},
    {time=21.391,key="j"},{time=22.174,key="h"},
    {time=22.696,key="k"},{time=23.217,key="j"},{time=23.478,key="h"},
    {time=23.739,key="g"},{time=24.000,key="f"},{time=24.522,key="d"},
    {time=25.043,key="f"},{time=25.304,key="g"},{time=25.565,key="h"},
    {time=25.826,key="j"},{time=26.609,key="h"},
}

-- ============================================================
-- MOVIE / CINEMATIC
-- ============================================================

-- 41. Hakuna Matata (Lion King) - Key: C major, 90 BPM
local notes_hakuna_matata = {
    -- Intro bounce
    {time=0.000,key="t"},{time=0.333,key="y"},{time=0.667,key="u"},
    {time=1.000,key="y"},{time=1.333,key="t"},{time=2.000,key="r"},
    {time=2.667,key="t"},{time=3.333,key="y"},
    -- "Hakuna Matata what a wonderful phrase"
    {time=4.000,key="u"},{time=4.333,key="i"},{time=4.667,key="u"},
    {time=5.000,key="y"},{time=5.333,key="t"},{time=6.000,key="r"},
    {time=6.667,key="t"},{time=7.333,key="y"},{time=8.000,key="u"},
    {time=8.667,key="o"},{time=9.333,key="u"},
    -- "Hakuna Matata ain't no passing craze"
    {time=10.667,key="u"},{time=11.000,key="i"},{time=11.333,key="u"},
    {time=11.667,key="y"},{time=12.000,key="t"},{time=12.667,key="r"},
    {time=13.333,key="t"},{time=14.000,key="y"},{time=14.667,key="u"},
    {time=15.333,key="i"},{time=16.000,key="o"},
    -- "It means no worries"
    {time=17.333,key="p"},{time=17.667,key="o"},{time=18.000,key="p"},
    {time=18.333,key="a"},{time=18.667,key="p"},{time=19.000,key="o"},
    {time=19.333,key="i"},{time=20.000,key="u"},
    -- "For the rest of your days"
    {time=21.333,key="i"},{time=21.667,key="o"},{time=22.000,key="i"},
    {time=22.333,key="u"},{time=22.667,key="y"},{time=23.333,key="t"},
    {time=24.000,key="r"},
    -- "It's our problem-free philosophy"
    {time=25.333,key="u"},{time=25.667,key="i"},{time=26.000,key="u"},
    {time=26.333,key="y"},{time=26.667,key="t"},{time=27.333,key="r"},
    {time=28.000,key="t"},{time=28.667,key="y"},{time=29.333,key="u"},
    -- "Hakuna Matata!"
    {time=30.667,key="p"},{time=31.000,key="a"},{time=31.333,key="p"},
    {time=31.667,key="o"},{time=32.000,key="p"},{time=32.333,key="a"},
    {time=32.667,key="s"},{time=33.333,key="a"},{time=34.000,key="p"},
}

-- 42. Circle of Life (Lion King) - Key: Bb major, 96 BPM
local notes_circle_of_life = {
    -- African chant intro
    {time=0.000,key="p"},{time=0.625,key="a"},{time=1.250,key="s"},
    {time=1.875,key="a"},{time=2.500,key="p"},{time=3.125,key="o"},
    {time=3.750,key="p"},{time=4.375,key="a"},
    -- "From the day we arrive on the planet"
    {time=6.250,key="p"},{time=6.875,key="p"},{time=7.500,key="a"},
    {time=8.125,key="p"},{time=8.750,key="o"},{time=9.375,key="i"},
    {time=10.000,key="u"},{time=10.625,key="y"},{time=11.250,key="t"},
    {time=12.500,key="p"},{time=13.125,key="p"},{time=13.750,key="a"},
    {time=14.375,key="p"},{time=15.000,key="o"},{time=15.625,key="i"},
    {time=16.250,key="u"},{time=17.500,key="y"},
    -- Chorus "It's the circle of life"
    {time=20.000,key="a"},{time=20.625,key="s"},{time=21.250,key="d"},
    {time=21.875,key="f"},{time=22.500,key="d"},{time=23.125,key="s"},
    {time=23.750,key="a"},{time=25.000,key="p"},
    {time=26.250,key="a"},{time=26.875,key="s"},{time=27.500,key="d"},
    {time=28.125,key="s"},{time=28.750,key="a"},{time=29.375,key="p"},
    {time=30.000,key="o"},{time=31.250,key="p"},
    -- "And it moves us all"
    {time=32.500,key="a"},{time=33.125,key="s"},{time=33.750,key="a"},
    {time=34.375,key="p"},{time=35.000,key="o"},{time=35.625,key="i"},
    {time=36.250,key="u"},{time=38.750,key="y"},
    -- Grand finale
    {time=40.000,key="s"},{time=40.625,key="d"},{time=41.250,key="s"},
    {time=41.875,key="a"},{time=42.500,key="p"},{time=43.125,key="o"},
    {time=43.750,key="i"},{time=44.375,key="u"},{time=46.250,key="y"},
}

-- 43. Interstellar Main Theme - Key: F major, 40 BPM
local notes_interstellar = {
    -- Organ-like slow theme
    {time=0.000,key="u"},{time=1.500,key="i"},{time=3.000,key="o"},
    {time=4.500,key="p"},{time=6.000,key="o"},{time=7.500,key="i"},
    {time=9.000,key="u"},{time=12.000,key="y"},
    {time=13.500,key="u"},{time=15.000,key="i"},{time=16.500,key="o"},
    {time=18.000,key="p"},{time=19.500,key="a"},{time=21.000,key="p"},
    {time=22.500,key="o"},{time=25.500,key="i"},
    -- Rising tension
    {time=27.000,key="o"},{time=28.500,key="p"},{time=30.000,key="a"},
    {time=31.500,key="s"},{time=33.000,key="a"},{time=34.500,key="p"},
    {time=36.000,key="o"},{time=39.000,key="p"},
    {time=40.500,key="a"},{time=42.000,key="s"},{time=43.500,key="d"},
    {time=45.000,key="s"},{time=46.500,key="a"},{time=48.000,key="p"},
    {time=49.500,key="o"},{time=52.500,key="p"},
    -- Climax
    {time=54.000,key="a"},{time=55.500,key="s"},{time=57.000,key="d"},
    {time=58.500,key="f"},{time=60.000,key="d"},{time=61.500,key="s"},
    {time=63.000,key="a"},{time=66.000,key="p"},
    {time=67.500,key="o"},{time=69.000,key="p"},{time=70.500,key="a"},
    {time=72.000,key="s"},{time=73.500,key="a"},{time=75.000,key="p"},
    {time=76.500,key="o"},{time=80.000,key="u"},
}

-- 44. See You Again (Wiz Khalifa/Charlie Puth) - Key: Db major, 88 BPM
local notes_see_you_again = {
    -- Piano intro
    {time=0.000,key="p"},{time=0.682,key="o"},{time=1.364,key="p"},
    {time=2.045,key="a"},{time=2.727,key="p"},{time=3.409,key="o"},
    {time=4.091,key="i"},{time=4.773,key="u"},{time=5.455,key="y"},
    {time=6.818,key="p"},{time=7.500,key="a"},{time=8.182,key="s"},
    {time=8.864,key="a"},{time=9.545,key="p"},{time=10.227,key="o"},
    {time=10.909,key="i"},{time=12.273,key="u"},
    -- Verse "It's been a long day without you my friend"
    {time=14.318,key="p"},{time=15.000,key="o"},{time=15.682,key="p"},
    {time=16.364,key="a"},{time=17.045,key="p"},{time=17.727,key="o"},
    {time=18.409,key="i"},{time=19.091,key="u"},{time=19.773,key="y"},
    {time=21.136,key="p"},{time=21.818,key="a"},{time=22.500,key="s"},
    {time=23.182,key="a"},{time=23.864,key="p"},{time=24.545,key="o"},
    -- Chorus "I'll tell you all about it when I see you again"
    {time=27.273,key="a"},{time=27.955,key="s"},{time=28.636,key="d"},
    {time=29.318,key="s"},{time=30.000,key="a"},{time=30.682,key="p"},
    {time=31.364,key="o"},{time=32.727,key="p"},
    {time=33.409,key="a"},{time=34.091,key="s"},{time=34.773,key="d"},
    {time=35.455,key="f"},{time=36.136,key="d"},{time=36.818,key="s"},
    {time=37.500,key="a"},{time=38.864,key="p"},
    -- Repeat chorus
    {time=40.909,key="a"},{time=41.591,key="s"},{time=42.273,key="d"},
    {time=42.955,key="s"},{time=43.636,key="a"},{time=44.318,key="p"},
    {time=45.000,key="o"},{time=46.364,key="p"},
    {time=47.045,key="a"},{time=47.727,key="s"},{time=48.409,key="d"},
    {time=49.091,key="f"},{time=49.773,key="d"},{time=50.455,key="s"},
    {time=51.136,key="a"},{time=52.500,key="p"},
}

-- ============================================================
-- CLASSICAL / INSTRUMENTAL
-- ============================================================

-- 45. River Flows in You (Yiruma) - Key: A major, 68 BPM
local notes_river_flows = {
    -- Gentle opening arpeggios
    {time=0.000,key="T"},{time=0.441,key="p"},{time=0.882,key="u"},
    {time=1.324,key="p"},{time=1.765,key="T"},{time=2.206,key="p"},
    {time=2.647,key="u"},{time=3.088,key="p"},
    {time=3.529,key="T"},{time=3.971,key="p"},{time=4.412,key="u"},
    {time=4.853,key="a"},{time=5.294,key="u"},{time=5.735,key="p"},
    {time=6.176,key="T"},{time=6.618,key="p"},
    -- Melody enters
    {time=7.059,key="a"},{time=7.500,key="s"},{time=7.941,key="a"},
    {time=8.382,key="p"},{time=8.824,key="O"},{time=9.265,key="p"},
    {time=9.706,key="u"},{time=10.588,key="T"},
    {time=11.471,key="a"},{time=11.912,key="s"},{time=12.353,key="a"},
    {time=12.794,key="p"},{time=13.235,key="u"},{time=13.676,key="T"},
    {time=14.118,key="p"},{time=15.882,key="O"},
    -- Second phrase
    {time=17.647,key="T"},{time=18.088,key="p"},{time=18.529,key="u"},
    {time=18.971,key="p"},{time=19.412,key="T"},{time=19.853,key="p"},
    {time=20.294,key="u"},{time=20.735,key="p"},
    {time=21.176,key="a"},{time=21.618,key="s"},{time=22.059,key="d"},
    {time=22.500,key="s"},{time=22.941,key="a"},{time=23.382,key="p"},
    {time=23.824,key="u"},{time=25.588,key="T"},
    -- Rising melody
    {time=27.353,key="a"},{time=27.794,key="s"},{time=28.235,key="d"},
    {time=28.676,key="f"},{time=29.118,key="d"},{time=29.559,key="s"},
    {time=30.000,key="a"},{time=30.441,key="p"},{time=30.882,key="u"},
    {time=32.647,key="T"},
    -- Final phrase
    {time=34.412,key="a"},{time=34.853,key="s"},{time=35.294,key="a"},
    {time=35.735,key="p"},{time=36.176,key="O"},{time=36.618,key="p"},
    {time=37.059,key="u"},{time=37.500,key="T"},
    {time=38.824,key="a"},{time=39.265,key="p"},{time=39.706,key="u"},
    {time=40.588,key="T"},{time=42.353,key="p"},
}

-- 46. Clair de Lune (Debussy) - Key: Db major, 44 BPM
local notes_clair_de_lune = {
    -- Opening
    {time=0.000,key="p"},{time=0.682,key="a"},{time=1.364,key="s"},
    {time=2.045,key="a"},{time=2.727,key="p"},{time=3.409,key="o"},
    {time=4.773,key="p"},
    {time=6.136,key="a"},{time=6.818,key="s"},{time=7.500,key="d"},
    {time=8.182,key="s"},{time=8.864,key="a"},{time=9.545,key="p"},
    {time=10.909,key="o"},
    -- Rising phrase
    {time=12.273,key="p"},{time=12.955,key="a"},{time=13.636,key="s"},
    {time=14.318,key="d"},{time=15.000,key="f"},{time=15.682,key="d"},
    {time=16.364,key="s"},{time=17.045,key="a"},{time=18.409,key="p"},
    {time=19.773,key="o"},{time=20.455,key="p"},{time=21.136,key="a"},
    {time=21.818,key="s"},{time=22.500,key="d"},
    -- Floating middle section
    {time=24.545,key="s"},{time=25.227,key="d"},{time=25.909,key="f"},
    {time=26.591,key="g"},{time=27.273,key="f"},{time=27.955,key="d"},
    {time=28.636,key="s"},{time=30.000,key="a"},
    {time=31.364,key="s"},{time=32.045,key="d"},{time=32.727,key="f"},
    {time=33.409,key="g"},{time=34.091,key="h"},{time=34.773,key="g"},
    {time=35.455,key="f"},{time=36.136,key="d"},{time=37.500,key="s"},
    -- Return to main theme
    {time=39.545,key="p"},{time=40.227,key="a"},{time=40.909,key="s"},
    {time=41.591,key="a"},{time=42.273,key="p"},{time=42.955,key="o"},
    {time=44.318,key="p"},
    {time=45.682,key="a"},{time=46.364,key="s"},{time=47.045,key="d"},
    {time=47.727,key="s"},{time=48.409,key="a"},{time=49.091,key="p"},
    {time=51.136,key="o"},
    -- Fade
    {time=53.182,key="p"},{time=53.864,key="o"},{time=54.545,key="i"},
    {time=55.227,key="u"},{time=56.591,key="y"},{time=58.636,key="t"},
    {time=61.364,key="p"},
}

-- 47. Moonlight Sonata (Beethoven, 1st mvt) - Key: C# minor, 58 BPM
local notes_moonlight_sonata = {
    -- Iconic triplet arpeggios
    {time=0.000,key="*"},{time=0.344,key="0"},{time=0.690,key="u"},
    {time=1.034,key="*"},{time=1.379,key="0"},{time=1.724,key="u"},
    {time=2.069,key="("},{time=2.414,key="0"},{time=2.759,key="u"},
    {time=3.103,key="("},{time=3.448,key="0"},{time=3.793,key="u"},
    -- Melody over triplets
    {time=4.138,key="i"},{time=4.483,key="*"},{time=4.828,key="0"},
    {time=5.172,key="u"},{time=5.517,key="*"},{time=5.862,key="0"},
    {time=6.207,key="u"},{time=6.552,key="p"},
    {time=6.897,key="O"},{time=7.241,key="9"},{time=7.586,key="r"},
    {time=7.931,key="O"},{time=8.276,key="9"},{time=8.621,key="r"},
    {time=8.966,key="p"},{time=9.310,key="O"},{time=9.655,key="9"},
    {time=10.000,key="r"},{time=10.345,key="0"},{time=10.690,key="9"},
    {time=11.034,key="r"},
    -- Second phrase
    {time=11.379,key="T"},{time=11.724,key="*"},{time=12.069,key="0"},
    {time=12.414,key="u"},{time=12.759,key="*"},{time=13.103,key="0"},
    {time=13.448,key="u"},{time=13.793,key="p"},
    {time=14.138,key="I"},{time=14.483,key="Q"},{time=14.828,key="0"},
    {time=15.172,key="u"},{time=15.517,key="Q"},{time=15.862,key="0"},
    {time=16.207,key="u"},{time=16.552,key="a"},
    {time=16.897,key="P"},{time=17.241,key="9"},{time=17.586,key="r"},
    {time=17.931,key="P"},{time=18.276,key="9"},{time=18.621,key="r"},
    {time=18.966,key="a"},{time=19.310,key="P"},{time=19.655,key="9"},
    {time=20.000,key="r"},
    -- Third phrase (resolution)
    {time=20.690,key="o"},{time=21.034,key="9"},{time=21.379,key="r"},
    {time=21.724,key="o"},{time=22.069,key="9"},{time=22.414,key="r"},
    {time=22.759,key="p"},{time=23.103,key="9"},{time=23.448,key="r"},
    {time=23.793,key="p"},{time=24.138,key="O"},{time=24.483,key="9"},
    {time=24.828,key="r"},{time=25.517,key="i"},
    {time=25.862,key="*"},{time=26.207,key="0"},{time=26.552,key="u"},
    {time=26.897,key="*"},{time=27.241,key="0"},{time=27.586,key="u"},
    {time=27.931,key="p"},{time=28.966,key="o"},
}

-- 48. Gymnopédie No.1 (Satie) - Key: G major, 56 BPM
local notes_gymnopedie = {
    -- Waltz-like intro (3/4)
    {time=0.000,key="o"},{time=1.071,key="p"},{time=2.143,key="a"},
    {time=3.214,key="p"},{time=4.286,key="o"},{time=5.357,key="i"},
    {time=6.429,key="u"},
    -- Melody
    {time=8.571,key="o"},{time=9.643,key="p"},{time=11.786,key="o"},
    {time=12.857,key="i"},{time=14.000,key="u"},{time=15.071,key="y"},
    {time=17.214,key="u"},{time=18.286,key="i"},{time=20.429,key="u"},
    {time=21.500,key="y"},{time=23.643,key="t"},
    -- Second phrase
    {time=25.786,key="o"},{time=26.857,key="p"},{time=29.000,key="o"},
    {time=30.071,key="i"},{time=32.214,key="o"},
    {time=33.286,key="p"},{time=35.429,key="a"},
    {time=36.500,key="p"},{time=38.643,key="o"},
    -- Flowing middle
    {time=40.786,key="p"},{time=41.857,key="a"},{time=44.000,key="s"},
    {time=45.071,key="a"},{time=47.214,key="p"},
    {time=48.286,key="a"},{time=50.429,key="s"},
    {time=51.500,key="d"},{time=53.643,key="s"},
    {time=54.714,key="a"},{time=56.857,key="p"},
    -- Return
    {time=59.000,key="o"},{time=60.071,key="p"},{time=62.214,key="o"},
    {time=63.286,key="i"},{time=65.429,key="u"},{time=66.500,key="y"},
    {time=68.643,key="u"},{time=69.714,key="i"},{time=71.857,key="u"},
    {time=72.929,key="y"},{time=75.071,key="t"},
    {time=78.214,key="o"},
}

-- 49. The Entertainer (Scott Joplin) - Key: C major, 100 BPM
local notes_entertainer = {
    -- Intro
    {time=0.000,key="s"},{time=0.150,key="d"},{time=0.300,key="f"},
    {time=0.600,key="d"},{time=0.900,key="f"},{time=1.200,key="h"},
    {time=1.800,key="g"},{time=2.400,key="f"},{time=3.000,key="d"},
    {time=3.600,key="f"},{time=4.200,key="s"},
    -- First strain A
    {time=4.800,key="s"},{time=4.950,key="d"},{time=5.100,key="f"},
    {time=5.400,key="d"},{time=5.700,key="f"},{time=6.000,key="h"},
    {time=6.600,key="g"},{time=7.200,key="f"},{time=7.800,key="d"},
    {time=8.400,key="s"},{time=9.000,key="a"},
    {time=9.600,key="p"},{time=9.750,key="a"},{time=9.900,key="s"},
    {time=10.200,key="a"},{time=10.500,key="s"},{time=10.800,key="d"},
    {time=11.400,key="f"},{time=12.000,key="d"},{time=12.600,key="s"},
    {time=13.200,key="a"},
    -- First strain B
    {time=14.400,key="s"},{time=14.550,key="d"},{time=14.700,key="f"},
    {time=15.000,key="d"},{time=15.300,key="f"},{time=15.600,key="h"},
    {time=16.200,key="g"},{time=16.800,key="f"},{time=17.400,key="g"},
    {time=18.000,key="h"},{time=18.600,key="j"},
    {time=19.200,key="j"},{time=19.350,key="h"},{time=19.500,key="g"},
    {time=19.800,key="f"},{time=20.100,key="d"},{time=20.400,key="f"},
    {time=21.000,key="s"},{time=22.200,key="s"},
    -- Second strain
    {time=22.800,key="p"},{time=22.950,key="a"},{time=23.100,key="s"},
    {time=23.400,key="d"},{time=23.700,key="s"},{time=24.000,key="a"},
    {time=24.600,key="p"},{time=25.200,key="o"},
    {time=25.800,key="p"},{time=25.950,key="a"},{time=26.100,key="s"},
    {time=26.400,key="d"},{time=26.700,key="f"},{time=27.000,key="d"},
    {time=27.600,key="s"},{time=28.200,key="a"},
    -- Trio
    {time=29.400,key="s"},{time=29.700,key="d"},{time=30.000,key="f"},
    {time=30.300,key="g"},{time=30.600,key="h"},{time=31.200,key="g"},
    {time=31.800,key="f"},{time=32.400,key="d"},{time=33.000,key="s"},
    {time=33.600,key="a"},{time=34.200,key="p"},{time=34.800,key="o"},
    {time=35.400,key="p"},{time=36.000,key="a"},{time=36.600,key="s"},
    {time=37.800,key="a"},
}

-- 50. Maple Leaf Rag (Scott Joplin) - Key: Ab major, 92 BPM
local notes_maple_leaf_rag = {
    -- A strain
    {time=0.000,key="d"},{time=0.217,key="f"},{time=0.435,key="g"},
    {time=0.652,key="f"},{time=0.870,key="d"},{time=1.087,key="s"},
    {time=1.304,key="d"},{time=1.739,key="f"},
    {time=1.957,key="d"},{time=2.174,key="s"},{time=2.391,key="a"},
    {time=2.609,key="s"},{time=2.826,key="d"},{time=3.043,key="f"},
    {time=3.478,key="g"},{time=3.913,key="f"},
    {time=4.348,key="g"},{time=4.565,key="h"},{time=4.783,key="g"},
    {time=5.000,key="f"},{time=5.217,key="d"},{time=5.652,key="s"},
    {time=6.087,key="d"},{time=6.522,key="f"},{time=6.957,key="d"},
    {time=7.391,key="s"},{time=7.826,key="a"},
    -- B strain
    {time=9.130,key="f"},{time=9.348,key="g"},{time=9.565,key="h"},
    {time=9.783,key="j"},{time=10.000,key="h"},{time=10.217,key="g"},
    {time=10.435,key="f"},{time=10.870,key="d"},
    {time=11.304,key="f"},{time=11.522,key="g"},{time=11.739,key="h"},
    {time=11.957,key="j"},{time=12.174,key="k"},{time=12.391,key="j"},
    {time=12.609,key="h"},{time=13.043,key="g"},
    {time=13.478,key="f"},{time=13.696,key="h"},{time=13.913,key="j"},
    {time=14.130,key="h"},{time=14.348,key="g"},{time=14.565,key="f"},
    {time=14.783,key="d"},{time=15.217,key="s"},
    -- C strain (Trio)
    {time=17.391,key="p"},{time=17.609,key="a"},{time=17.826,key="s"},
    {time=18.043,key="a"},{time=18.261,key="p"},{time=18.478,key="o"},
    {time=18.696,key="p"},{time=19.130,key="a"},
    {time=19.565,key="s"},{time=19.783,key="a"},{time=20.000,key="p"},
    {time=20.217,key="o"},{time=20.435,key="i"},{time=20.652,key="o"},
    {time=20.870,key="p"},{time=21.304,key="a"},
    -- D strain
    {time=21.739,key="p"},{time=21.957,key="o"},{time=22.174,key="p"},
    {time=22.391,key="a"},{time=22.609,key="s"},{time=22.826,key="a"},
    {time=23.043,key="p"},{time=23.478,key="o"},
    {time=23.913,key="i"},{time=24.130,key="o"},{time=24.348,key="p"},
    {time=24.565,key="a"},{time=24.783,key="p"},{time=25.000,key="o"},
    {time=25.217,key="i"},{time=25.652,key="u"},
    -- Final A return
    {time=26.087,key="d"},{time=26.304,key="f"},{time=26.522,key="g"},
    {time=26.739,key="f"},{time=26.957,key="d"},{time=27.174,key="s"},
    {time=27.391,key="d"},{time=27.826,key="f"},
    {time=28.261,key="d"},{time=28.478,key="s"},{time=28.696,key="a"},
    {time=28.913,key="s"},{time=29.130,key="d"},{time=29.348,key="f"},
    {time=29.783,key="g"},{time=30.217,key="f"},
    {time=30.652,key="d"},{time=31.087,key="s"},{time=31.522,key="d"},
    {time=31.957,key="f"},{time=32.391,key="d"},
}

-- ============================================================
-- RAYFIELD UI ADDITIONS
-- 以下を v5.2_pack_part1.lua の Rayfield UI セクションに追加
-- ============================================================

-- ▼ Western Pop タブを作成（songs 1-13 & 32-40）
local TabWestern = Window:CreateTab("Western Pop", 4483345998)
TabWestern:CreateButton({Name="▶ Let It Go (Frozen)",           Callback=function() playSong(notes_let_it_go,        "Let It Go",           false) end})
TabWestern:CreateButton({Name="▶ Shape of You",                 Callback=function() playSong(notes_shape_of_you,     "Shape of You",        false) end})
TabWestern:CreateButton({Name="▶ Someone Like You",             Callback=function() playSong(notes_someone_like_you, "Someone Like You",    false) end})
TabWestern:CreateButton({Name="▶ Rolling in the Deep",          Callback=function() playSong(notes_rolling_in_the_deep,"Rolling in the Deep",false) end})
TabWestern:CreateButton({Name="▶ Bohemian Rhapsody",            Callback=function() playSong(notes_bohemian_rhapsody,"Bohemian Rhapsody",   false) end})
TabWestern:CreateButton({Name="▶ Perfect (Ed Sheeran)",         Callback=function() playSong(notes_perfect,          "Perfect",             false) end})
TabWestern:CreateButton({Name="▶ Counting Stars",               Callback=function() playSong(notes_counting_stars,   "Counting Stars",      false) end})
TabWestern:CreateButton({Name="▶ Demons (Imagine Dragons)",     Callback=function() playSong(notes_demons,           "Demons",              false) end})
TabWestern:CreateButton({Name="▶ Believer (Imagine Dragons)",   Callback=function() playSong(notes_believer,         "Believer",            false) end})
TabWestern:CreateButton({Name="▶ Shallow (Lady Gaga)",          Callback=function() playSong(notes_shallow,          "Shallow",             false) end})
TabWestern:CreateButton({Name="▶ Can't Help Falling in Love",   Callback=function() playSong(notes_cant_help_falling,"Can't Help Falling",  false) end})
TabWestern:CreateButton({Name="▶ My Heart Will Go On",          Callback=function() playSong(notes_my_heart_will_go_on,"My Heart Will Go On",false) end})
TabWestern:CreateButton({Name="▶ Thinking Out Loud",            Callback=function() playSong(notes_thinking_out_loud,"Thinking Out Loud",   false) end})
TabWestern:CreateButton({Name="▶ Hotel California",             Callback=function() playSong(notes_hotel_california, "Hotel California",    false) end})
TabWestern:CreateButton({Name="▶ Yesterday (Beatles)",          Callback=function() playSong(notes_yesterday,        "Yesterday",           false) end})
TabWestern:CreateButton({Name="▶ Hallelujah",                   Callback=function() playSong(notes_hallelujah,       "Hallelujah",          false) end})
TabWestern:CreateButton({Name="▶ All of Me (John Legend)",      Callback=function() playSong(notes_all_of_me,        "All of Me",           false) end})
TabWestern:CreateButton({Name="▶ Stay With Me (Sam Smith)",     Callback=function() playSong(notes_stay_with_me,     "Stay With Me",        false) end})
TabWestern:CreateButton({Name="▶ Happy (Pharrell)",             Callback=function() playSong(notes_happy,            "Happy",               false) end})
TabWestern:CreateButton({Name="▶ Blinding Lights (Weeknd)",     Callback=function() playSong(notes_blinding_lights,  "Blinding Lights",     false) end})
TabWestern:CreateButton({Name="▶ Bad Guy (Billie Eilish)",      Callback=function() playSong(notes_bad_guy,          "Bad Guy",             false) end})
TabWestern:CreateButton({Name="▶ Uptown Funk (Bruno Mars)",     Callback=function() playSong(notes_uptown_funk,      "Uptown Funk",         false) end})

-- ▼ Disney/Movie タブ
local TabDisney = Window:CreateTab("Disney / Movie", 4483345998)
TabDisney:CreateButton({Name="▶ Under the Sea (Mermaid)",       Callback=function() playSong(notes_under_the_sea,    "Under the Sea",       false) end})
TabDisney:CreateButton({Name="▶ A Whole New World (Aladdin)",   Callback=function() playSong(notes_whole_new_world,  "A Whole New World",   false) end})
TabDisney:CreateButton({Name="▶ Beauty and the Beast",          Callback=function() playSong(notes_beauty_and_the_beast,"Beauty and Beast",  false) end})
TabDisney:CreateButton({Name="▶ You've Got a Friend in Me",     Callback=function() playSong(notes_youve_got_a_friend,"Friend in Me",       false) end})
TabDisney:CreateButton({Name="▶ Hakuna Matata (Lion King)",     Callback=function() playSong(notes_hakuna_matata,    "Hakuna Matata",       false) end})
TabDisney:CreateButton({Name="▶ Circle of Life (Lion King)",    Callback=function() playSong(notes_circle_of_life,   "Circle of Life",      false) end})
TabDisney:CreateButton({Name="▶ Interstellar Main Theme",       Callback=function() playSong(notes_interstellar,     "Interstellar",        false) end})
TabDisney:CreateButton({Name="▶ See You Again",                 Callback=function() playSong(notes_see_you_again,    "See You Again",       false) end})

-- ▼ Game Music タブ
local TabGame = Window:CreateTab("Game Music", 4483345998)
TabGame:CreateButton({Name="▶ Super Mario Bros",                Callback=function() playSong(notes_super_mario,      "Super Mario Bros",    false) end})
TabGame:CreateButton({Name="▶ Tetris Theme",                    Callback=function() playSong(notes_tetris,           "Tetris Theme",        false) end})
TabGame:CreateButton({Name="▶ Legend of Zelda",                 Callback=function() playSong(notes_zelda,            "Legend of Zelda",     false) end})
TabGame:CreateButton({Name="▶ Minecraft Sweden (C418)",         Callback=function() playSong(notes_minecraft_sweden, "Minecraft Sweden",    false) end})
TabGame:CreateButton({Name="▶ Megalovania (Undertale)",         Callback=function() playSong(notes_megalovania,      "Megalovania",         false) end})
TabGame:CreateButton({Name="▶ Pokemon Main Theme",              Callback=function() playSong(notes_pokemon_theme,    "Pokemon Theme",       false) end})

-- ▼ Anime タブ
local TabAnime = Window:CreateTab("Anime", 4483345998)
TabAnime:CreateButton({Name="▶ Naruto - Main Theme",            Callback=function() playSong(notes_naruto_main,      "Naruto Main",         false) end})
TabAnime:CreateButton({Name="▶ One Piece - We Are!",            Callback=function() playSong(notes_we_are,           "We Are! (One Piece)", false) end})
TabAnime:CreateButton({Name="▶ AOT - Guren no Yumiya",          Callback=function() playSong(notes_guren_no_yumiya,  "Guren no Yumiya",     false) end})
TabAnime:CreateButton({Name="▶ SAO - Crossing Field",           Callback=function() playSong(notes_crossing_field,   "Crossing Field",      false) end})
TabAnime:CreateButton({Name="▶ DBZ - Cha-La Head-Cha-La",       Callback=function() playSong(notes_chala,            "Cha-La Head-Cha-La",  false) end})

-- ▼ K-Pop タブ
local TabKpop = Window:CreateTab("K-Pop", 4483345998)
TabKpop:CreateButton({Name="▶ Dynamite (BTS)",                  Callback=function() playSong(notes_dynamite,         "Dynamite",            false) end})
TabKpop:CreateButton({Name="▶ Boy With Luv (BTS)",              Callback=function() playSong(notes_boy_with_luv,     "Boy With Luv",        false) end})
TabKpop:CreateButton({Name="▶ How You Like That (BLACKPINK)",   Callback=function() playSong(notes_how_you_like_that,"How You Like That",   false) end})

-- ▼ Classical タブに追加分
local TabClassical2 = Window:CreateTab("Classical+", 4483345998)
TabClassical2:CreateButton({Name="▶ River Flows in You (Yiruma)",Callback=function() playSong(notes_river_flows,    "River Flows in You",  false) end})
TabClassical2:CreateButton({Name="▶ Clair de Lune (Debussy)",   Callback=function() playSong(notes_clair_de_lune,   "Clair de Lune",       false) end})
TabClassical2:CreateButton({Name="▶ Moonlight Sonata (mvt.1)",  Callback=function() playSong(notes_moonlight_sonata,"Moonlight Sonata",    false) end})
TabClassical2:CreateButton({Name="▶ Gymnopedie No.1 (Satie)",   Callback=function() playSong(notes_gymnopedie,      "Gymnopedie No.1",     false) end})
TabClassical2:CreateButton({Name="▶ The Entertainer (Joplin)",  Callback=function() playSong(notes_entertainer,     "The Entertainer",     false) end})
TabClassical2:CreateButton({Name="▶ Maple Leaf Rag (Joplin)",   Callback=function() playSong(notes_maple_leaf_rag,  "Maple Leaf Rag",      false) end})

-- ============================================================
-- 通知: v5.2 パック読み込み完了
-- ============================================================
Rayfield:Notify({
    Title = "v5.2 +50曲パック 読み込み完了!",
    Content = "Western/Disney/Game/Anime/Kpop/Classical タブを確認してください",
    Duration = 7,
    Image = "rbxassetid://4483345998"
})
