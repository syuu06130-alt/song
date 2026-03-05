-- ============================================================
--   Virtual Piano Player
--   曲リスト:
--     1. Libra Heart       (imaizumi)
--     2. どんぐりころころ   (日本童謡 / MIDIより変換)
--     3. トルコ行進曲      (W.A. Mozart K.331)
--     4. Last Christmas    (George Michael)
--   UI: Rayfield
-- ============================================================

local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

-- ============================================================
--  キーマッピング (Roblox Virtual Piano, 半音階)
--  C4=1 C#4=2 D4=3 D#4=4 E4=5 F4=6 F#4=7 G4=8 G#4=9 A4=0
--  A#4=q B4=w C5=e C#5=r D5=t D#5=y E5=u F5=i F#5=o G5=p
--  G#5=a A5=s A#5=d B5=f C6=g C#6=h D6=j D#6=k E6=l F6=;
--  F#6=z G6=x G#6=c A6=v A#6=b B6=n C7=m
-- ============================================================

-- ============================================================
--  曲1: Libra Heart  (作者: imaizumi / 計401音)
-- ============================================================
local notes_libraHeart = {
    {time = 0.000, key = "q"},{time = 0.011, key = "2"},{time = 0.011, key = "4"},
    {time = 0.117, key = "r"},{time = 0.360, key = "w"},{time = 0.360, key = "w"},
    {time = 0.617, key = "7"},{time = 0.918, key = "w"},{time = 1.093, key = "f"},
    {time = 1.348, key = "d"},{time = 1.348, key = "i"},{time = 1.348, key = "2"},
    {time = 1.359, key = "2"},{time = 1.603, key = "r"},{time = 1.615, key = "9"},
    {time = 1.858, key = "2"},{time = 1.870, key = "2"},{time = 2.079, key = "d"},
    {time = 2.116, key = "6"},{time = 2.347, key = "7"},{time = 2.359, key = "7"},
    {time = 2.486, key = "2"},{time = 2.498, key = "a"},{time = 2.835, key = "o"},
    {time = 2.847, key = "r"},{time = 2.858, key = "6"},{time = 2.870, key = "6"},
    {time = 3.357, key = "4"},{time = 3.439, key = "o"},{time = 3.624, key = "i"},
    {time = 3.624, key = "q"},{time = 3.880, key = "2"},{time = 4.346, key = "w"},
    {time = 4.346, key = "w"},{time = 4.613, key = "7"},{time = 4.845, key = "d"},
    {time = 4.856, key = "w"},{time = 4.868, key = "w"},{time = 5.355, key = "z"},
    {time = 5.355, key = "2"},{time = 5.368, key = "o"},{time = 5.368, key = "2"},
    {time = 5.623, key = "9"},{time = 5.704, key = "a"},{time = 5.867, key = "r"},
    {time = 5.867, key = "2"},{time = 5.867, key = "2"},{time = 6.100, key = "6"},
    {time = 6.344, key = "q"},{time = 6.344, key = "7"},{time = 6.355, key = "7"},
    {time = 6.367, key = "o"},{time = 6.367, key = "7"},{time = 6.646, key = "z"},
    {time = 6.854, key = "o"},{time = 6.867, key = "a"},{time = 6.867, key = "9"},
    {time = 6.867, key = "6"},{time = 6.867, key = "6"},{time = 7.354, key = "o"},
    {time = 7.354, key = "q"},{time = 7.366, key = "4"},{time = 7.366, key = "4"},
    {time = 7.551, key = ";"},{time = 7.621, key = "q"},{time = 7.655, key = "i"},
    {time = 7.865, key = "2"},{time = 8.366, key = "w"},{time = 8.366, key = "w"},
    {time = 8.609, key = "7"},{time = 8.853, key = "7"},{time = 8.853, key = "w"},
    {time = 8.865, key = "w"},{time = 9.085, key = "w"},{time = 9.097, key = "w"},
    {time = 9.120, key = "f"},{time = 9.352, key = "2"},{time = 9.364, key = "2"},
    {time = 9.607, key = "2"},{time = 9.607, key = "9"},{time = 9.619, key = "2"},
    {time = 9.630, key = "r"},{time = 9.863, key = "2"},{time = 9.874, key = "r"},
    {time = 9.874, key = "2"},{time = 10.364, key = "7"},{time = 10.364, key = "7"},
    {time = 10.596, key = "a"},{time = 10.840, key = "o"},{time = 10.851, key = "6"},
    {time = 10.979, key = "6"},{time = 11.095, key = "r"},{time = 11.106, key = "a"},
    {time = 11.142, key = "6"},{time = 11.350, key = "q"},{time = 11.350, key = "4"},
    {time = 11.361, key = "o"},{time = 11.618, key = "q"},{time = 11.861, key = "r"},
    {time = 11.873, key = "2"},{time = 11.954, key = "q"},{time = 12.083, key = "2"},
    {time = 12.095, key = "q"},{time = 12.118, key = "o"},{time = 12.350, key = "w"},
    {time = 12.361, key = "w"},{time = 12.373, key = "o"},{time = 12.420, key = "4"},
    {time = 12.605, key = "7"},{time = 12.605, key = "w"},{time = 12.826, key = "w"},
    {time = 12.838, key = "d"},{time = 12.849, key = "w"},{time = 13.128, key = "w"},
    {time = 13.128, key = "w"},{time = 13.360, key = "q"},{time = 13.372, key = "2"},
    {time = 13.442, key = "o"},{time = 13.604, key = "o"},{time = 13.708, key = "2"},
    {time = 13.720, key = "w"},{time = 13.859, key = "w"},{time = 13.871, key = "2"},
    {time = 14.010, key = "o"},{time = 14.197, key = "2"},{time = 14.336, key = "7"},
    {time = 14.336, key = "7"},{time = 14.359, key = "o"},{time = 14.476, key = "7"},
    {time = 14.882, key = "6"},{time = 14.882, key = "2"},{time = 15.115, key = "7"},
    {time = 15.358, key = "4"},{time = 15.440, key = "2"},{time = 15.591, key = "4"},
    {time = 16.115, key = "9"},{time = 16.289, key = "4"},{time = 16.381, key = "w"},
    {time = 16.404, key = "7"},{time = 16.659, key = "2"},{time = 16.973, key = "w"},
    {time = 17.043, key = "4"},{time = 17.112, key = "w"},{time = 17.379, key = "2"},
    {time = 17.449, key = "2"},{time = 17.705, key = "9"},{time = 17.844, key = "2"},
    {time = 17.868, key = "2"},{time = 18.077, key = "7"},{time = 18.379, key = "7"},
    {time = 18.449, key = "q"},{time = 18.600, key = "7"},{time = 18.832, key = "9"},
    {time = 18.832, key = "6"},{time = 18.972, key = "6"},{time = 19.343, key = "7"},
    {time = 19.390, key = "2"},{time = 19.505, key = "4"},{time = 20.146, key = "q"},
    {time = 20.250, key = "4"},{time = 20.366, key = "q"},{time = 20.900, key = "4"},
    {time = 20.900, key = "w"},{time = 20.923, key = "7"},{time = 20.934, key = "w"},
    {time = 21.387, key = "q"},{time = 21.446, key = "2"},{time = 21.724, key = "6"},
    {time = 21.724, key = "q"},{time = 21.736, key = "2"},{time = 22.062, key = "9"},
    {time = 22.097, key = "7"},{time = 22.376, key = "q"},{time = 22.399, key = "7"},
    {time = 22.852, key = "9"},{time = 22.864, key = "w"},{time = 22.968, key = "6"},
    {time = 23.015, key = "6"},{time = 23.385, key = "q"},{time = 23.606, key = "4"},
    {time = 23.746, key = "q"},{time = 24.362, key = "w"},{time = 24.362, key = "4"},
    {time = 24.408, key = "w"},{time = 24.595, key = "7"},{time = 24.920, key = "q"},
    {time = 24.931, key = "w"},{time = 25.082, key = "w"},{time = 25.128, key = "w"},
    {time = 25.454, key = "2"},{time = 25.755, key = "2"},{time = 25.825, key = "2"},
    {time = 25.849, key = "2"},{time = 26.152, key = "7"},{time = 26.360, key = "7"},
    {time = 26.407, key = "7"},{time = 26.442, key = "q"},{time = 26.859, key = "9"},
    {time = 26.987, key = "6"},{time = 27.116, key = "7"},{time = 27.405, key = "q"},
    {time = 27.452, key = "7"},{time = 27.858, key = "q"},{time = 28.103, key = "q"},
    {time = 28.277, key = "4"},{time = 28.358, key = "w"},{time = 28.928, key = "w"},
    {time = 28.928, key = "7"},{time = 29.078, key = "w"},{time = 29.114, key = "w"},
    {time = 29.590, key = "2"},{time = 29.717, key = "7"},{time = 29.879, key = "2"},
    {time = 30.322, key = "7"},{time = 30.346, key = "7"},{time = 30.520, key = "7"},
    {time = 30.554, key = "7"},{time = 30.856, key = "7"},{time = 31.007, key = "6"},
    {time = 31.355, key = "4"},{time = 31.436, key = "7"},{time = 31.506, key = "4"},
    {time = 31.727, key = "q"},{time = 31.808, key = "2"},{time = 32.089, key = "9"},
    {time = 32.134, key = "4"},{time = 32.251, key = "4"},{time = 32.344, key = "7"},
    {time = 32.367, key = "w"},{time = 32.935, key = "w"},{time = 33.005, key = "4"},
    {time = 33.086, key = "w"},{time = 33.342, key = "2"},{time = 33.504, key = "2"},
    {time = 33.714, key = "2"},{time = 33.725, key = "4"},{time = 33.760, key = "9"},
    {time = 33.913, key = "2"},{time = 34.132, key = "q"},{time = 34.132, key = "6"},
    {time = 34.202, key = "7"},{time = 34.400, key = "q"},{time = 34.574, key = "6"},
    {time = 34.899, key = "9"},{time = 35.003, key = "6"},{time = 35.352, key = "7"},
    {time = 35.468, key = "4"},{time = 35.515, key = "4"},{time = 35.573, key = "2"},
    {time = 36.131, key = "4"},{time = 36.143, key = "q"},{time = 36.340, key = "4"},
    {time = 36.944, key = "7"},{time = 36.967, key = "7"},{time = 37.002, key = "w"},
    {time = 37.048, key = "w"},{time = 37.350, key = "q"},{time = 37.361, key = "6"},
    {time = 37.431, key = "2"},{time = 37.594, key = "2"},{time = 37.710, key = "7"},
    {time = 37.908, key = "2"},{time = 38.106, key = "9"},{time = 38.141, key = "7"},
    {time = 38.373, key = "q"},{time = 38.860, key = "9"},{time = 38.907, key = "6"},
    {time = 38.942, key = "w"},{time = 39.011, key = "6"},{time = 39.372, key = "4"},
    {time = 39.395, key = "q"},{time = 39.557, key = "4"},{time = 39.731, key = "q"},
    {time = 39.860, key = "2"},{time = 40.104, key = "q"},{time = 40.278, key = "4"},
    {time = 40.395, key = "q"},{time = 40.871, key = "q"},{time = 41.091, key = "w"},
    {time = 41.115, key = "w"},{time = 41.347, key = "q"},{time = 41.485, key = "2"},
    {time = 41.636, key = "2"},{time = 41.742, key = "6"},{time = 41.847, key = "2"},
    {time = 41.858, key = "r"},{time = 41.870, key = "2"},{time = 42.021, key = "7"},
    {time = 42.357, key = "7"},{time = 42.393, key = "q"},{time = 42.869, key = "9"},
    {time = 42.984, key = "6"},{time = 43.112, key = "7"},{time = 43.460, key = "q"},
    {time = 43.530, key = "4"},{time = 43.623, key = "4"},{time = 43.845, key = "q"},
    {time = 44.402, key = "4"},{time = 44.914, key = "7"},{time = 44.948, key = "w"},
    {time = 45.110, key = "w"},{time = 45.146, key = "w"},{time = 45.378, key = "q"},
    {time = 45.482, key = "2"},{time = 45.622, key = "2"},{time = 45.715, key = "7"},
    {time = 45.867, key = "2"},{time = 46.145, key = "7"},{time = 46.157, key = "9"},
    {time = 46.343, key = "7"},{time = 46.528, key = "7"},{time = 46.598, key = "4"},
    {time = 46.958, key = "6"},{time = 46.958, key = "6"},{time = 47.365, key = "7"},
    {time = 47.446, key = "4"},{time = 47.620, key = "q"},{time = 47.819, key = "6"},
    {time = 47.911, key = "2"},{time = 48.399, key = "2"},{time = 48.410, key = "w"},
    {time = 48.620, key = "7"},{time = 48.968, key = "w"},{time = 48.968, key = "w"},
    {time = 49.119, key = "4"},{time = 49.362, key = "2"},{time = 49.525, key = "2"},
    {time = 49.606, key = "9"},{time = 49.781, key = "9"},{time = 49.794, key = "9"},
    {time = 49.862, key = "2"},{time = 50.130, key = "q"},{time = 50.339, key = "q"},
    {time = 50.362, key = "7"},{time = 50.362, key = "7"},{time = 50.595, key = "w"},
    {time = 50.861, key = "6"},{time = 50.873, key = "6"},{time = 50.884, key = "4"},
    {time = 51.117, key = "6"},{time = 51.384, key = "4"},{time = 51.396, key = "7"},
    {time = 51.616, key = "q"},{time = 51.861, key = "2"},{time = 52.140, key = "7"},
    {time = 52.314, key = "7"},{time = 52.349, key = "w"},{time = 52.476, key = "9"},
    {time = 52.732, key = "7"},{time = 52.848, key = "w"},{time = 52.871, key = "w"},
    {time = 53.103, key = "9"},{time = 53.382, key = "9"},{time = 53.382, key = "2"},
    {time = 53.509, key = "q"},{time = 53.730, key = "9"},{time = 54.033, key = "7"},
    {time = 54.870, key = "6"},{time = 55.102, key = "6"},{time = 55.357, key = "7"},
    {time = 55.450, key = "4"},{time = 55.531, key = "4"},{time = 55.869, key = "2"},
    {time = 56.112, key = "6"},{time = 56.264, key = "4"},{time = 56.357, key = "4"},
    {time = 56.915, key = "7"},{time = 57.077, key = "w"},{time = 57.100, key = "4"},
    {time = 57.518, key = "2"},{time = 57.669, key = "2"},{time = 57.868, key = "2"},
    {time = 58.123, key = "w"},{time = 58.367, key = "7"},{time = 58.367, key = "7"},
    {time = 58.401, key = "7"},{time = 58.831, key = "6"},{time = 58.877, key = "4"},
    {time = 59.098, key = "6"},{time = 59.353, key = "7"},{time = 59.540, key = "4"},
    {time = 60.132, key = "7"},{time = 60.342, key = "9"},{time = 60.365, key = "w"},
    {time = 60.446, key = "4"},{time = 60.736, key = "7"},{time = 60.899, key = "w"},
    {time = 60.922, key = "w"},{time = 61.073, key = "w"},{time = 61.108, key = "9"},
    {time = 61.433, key = "2"},{time = 61.515, key = "q"},{time = 61.596, key = "2"},
    {time = 61.748, key = "2"},{time = 61.771, key = "9"},{time = 62.050, key = "7"},
    {time = 62.386, key = "7"},{time = 62.421, key = "7"},{time = 62.700, key = "q"},
    {time = 62.851, key = "q"},{time = 63.001, key = "6"},
}

-- ============================================================
--  曲2: どんぐりころころ (日本童謡, MIDIより変換)
-- ============================================================
local notes_donguri = {
    {time = 0.000, key = "p"},{time = 0.455, key = "u"},{time = 0.682, key = "u"},
    {time = 0.909, key = "i"},{time = 1.136, key = "u"},{time = 1.364, key = "t"},
    {time = 1.591, key = "e"},{time = 1.818, key = "p"},{time = 2.045, key = "i"},
    {time = 2.273, key = "u"},{time = 2.500, key = "t"},{time = 2.727, key = "e"},
    {time = 2.955, key = "w"},{time = 3.182, key = "0"},{time = 3.409, key = "8"},
    {time = 3.636, key = "8"},{time = 4.091, key = "5"},{time = 4.318, key = "5"},
    {time = 4.545, key = "6"},{time = 4.773, key = "5"},{time = 5.000, key = "3"},
    {time = 5.227, key = "1"},{time = 5.455, key = "8"},{time = 5.909, key = "5"},
    {time = 6.136, key = "5"},{time = 6.364, key = "3"},{time = 7.273, key = "5"},
    {time = 7.500, key = "5"},{time = 7.727, key = "8"},{time = 7.955, key = "8"},
    {time = 8.182, key = "0"},{time = 8.409, key = "0"},{time = 8.864, key = "0"},
    {time = 9.091, key = "e"},{time = 9.545, key = "5"},{time = 9.773, key = "5"},
    {time = 10.000, key = "8"},{time = 10.909, key = "8"},{time = 11.136, key = "8"},
    {time = 11.364, key = "5"},{time = 11.591, key = "5"},{time = 11.818, key = "6"},
    {time = 12.045, key = "5"},{time = 12.273, key = "3"},{time = 12.500, key = "1"},
    {time = 12.727, key = "8"},{time = 13.182, key = "5"},{time = 13.409, key = "5"},
    {time = 13.636, key = "3"},{time = 14.545, key = "8"},{time = 15.000, key = "5"},
    {time = 15.455, key = "0"},{time = 15.909, key = "8"},{time = 16.136, key = "8"},
    {time = 16.364, key = "0"},{time = 16.591, key = "0"},{time = 16.818, key = "w"},
    {time = 17.045, key = "w"},{time = 17.273, key = "e"},
    {time = 18.182, key = "p"},{time = 18.636, key = "u"},{time = 18.864, key = "u"},
    {time = 19.091, key = "i"},{time = 19.318, key = "u"},{time = 19.545, key = "t"},
    {time = 19.773, key = "e"},{time = 20.000, key = "p"},{time = 20.227, key = "i"},
    {time = 20.455, key = "u"},{time = 20.682, key = "t"},{time = 20.909, key = "e"},
    {time = 21.136, key = "w"},{time = 21.364, key = "0"},{time = 21.591, key = "8"},
    {time = 21.818, key = "8"},{time = 22.273, key = "5"},{time = 22.500, key = "5"},
    {time = 22.727, key = "6"},{time = 22.955, key = "5"},{time = 23.182, key = "3"},
    {time = 23.409, key = "1"},{time = 23.636, key = "8"},{time = 24.091, key = "5"},
    {time = 24.318, key = "5"},{time = 24.545, key = "3"},{time = 25.455, key = "5"},
    {time = 25.682, key = "5"},{time = 25.909, key = "8"},{time = 26.136, key = "8"},
    {time = 26.364, key = "0"},{time = 26.591, key = "0"},{time = 27.045, key = "0"},
    {time = 27.273, key = "e"},{time = 27.727, key = "5"},{time = 27.955, key = "5"},
    {time = 28.182, key = "8"},{time = 29.091, key = "8"},{time = 29.318, key = "8"},
    {time = 29.545, key = "5"},{time = 29.773, key = "5"},{time = 30.000, key = "6"},
    {time = 30.227, key = "5"},{time = 30.455, key = "3"},{time = 30.682, key = "1"},
    {time = 30.909, key = "8"},{time = 31.364, key = "5"},{time = 31.591, key = "5"},
    {time = 31.818, key = "3"},{time = 32.727, key = "8"},{time = 33.182, key = "5"},
    {time = 33.636, key = "0"},{time = 34.091, key = "8"},{time = 34.318, key = "8"},
    {time = 34.545, key = "0"},{time = 34.773, key = "0"},{time = 35.000, key = "w"},
    {time = 35.227, key = "w"},{time = 35.455, key = "e"},
}

-- ============================================================
--  曲3: トルコ行進曲 (W.A. Mozart K.331, Rondo alla Turca)
--  BPM≈130  8分音符≈0.231s  パブリックドメイン
-- ============================================================
local notes_turkish = {
    -- === Bセクション (Aマイナー) ===
    -- フレーズ1: E5 D#5 E5 D#5 E5 B4 D5 C5 | A4.. A4 C5 E5 A5 |
    {time=0.000,key="u"},{time=0.231,key="y"},{time=0.462,key="u"},
    {time=0.692,key="y"},{time=0.923,key="u"},{time=1.154,key="w"},
    {time=1.385,key="t"},{time=1.615,key="e"},
    {time=1.846,key="0"},{time=2.308,key="0"},{time=2.538,key="e"},
    {time=2.769,key="u"},{time=3.000,key="s"},
    -- フレーズ2: B4 C5 D5 E5 | E5 F5 E5 D5 C5 B4 A4 |
    {time=4.154,key="w"},{time=4.385,key="e"},{time=4.615,key="t"},
    {time=4.846,key="u"},
    {time=5.769,key="u"},{time=6.000,key="i"},{time=6.231,key="u"},
    {time=6.462,key="t"},{time=6.692,key="e"},{time=6.923,key="w"},
    {time=7.154,key="0"},
    -- リピート フレーズ1
    {time=8.077,key="u"},{time=8.308,key="y"},{time=8.538,key="u"},
    {time=8.769,key="y"},{time=9.000,key="u"},{time=9.231,key="w"},
    {time=9.462,key="t"},{time=9.692,key="e"},
    {time=9.923,key="0"},{time=10.385,key="0"},{time=10.615,key="e"},
    {time=10.846,key="u"},{time=11.077,key="s"},
    -- リピート フレーズ2
    {time=12.231,key="w"},{time=12.462,key="e"},{time=12.692,key="t"},
    {time=12.923,key="u"},
    {time=13.846,key="u"},{time=14.077,key="i"},{time=14.308,key="u"},
    {time=14.538,key="t"},{time=14.769,key="e"},{time=15.000,key="w"},
    {time=15.231,key="0"},
    -- === Cセクション (Cメジャー) ===
    -- E5 D5 E5 D5 E5 C5 E5 D5 | C5.. C5 E5 G5 C6 |
    {time=16.154,key="u"},{time=16.385,key="t"},{time=16.615,key="u"},
    {time=16.846,key="t"},{time=17.077,key="u"},{time=17.308,key="e"},
    {time=17.538,key="u"},{time=17.769,key="t"},
    {time=18.000,key="e"},{time=18.462,key="e"},{time=18.692,key="u"},
    {time=18.923,key="p"},{time=19.154,key="g"},
    -- F5 E5 F5 E5 F5 C5 F5 E5 | C5.. C5 E5 G5 C6 |
    {time=20.308,key="i"},{time=20.538,key="u"},{time=20.769,key="i"},
    {time=21.000,key="u"},{time=21.231,key="i"},{time=21.462,key="e"},
    {time=21.692,key="i"},{time=21.923,key="u"},
    {time=22.154,key="e"},{time=22.615,key="e"},{time=22.846,key="u"},
    {time=23.077,key="p"},{time=23.308,key="g"},
    -- ランニングパッセージ: G5 F5 E5 D5 C5 B4 A4 G4 | A4 ...
    {time=24.462,key="p"},{time=24.692,key="i"},{time=24.923,key="u"},
    {time=25.154,key="t"},{time=25.385,key="e"},{time=25.615,key="w"},
    {time=25.846,key="0"},{time=26.077,key="8"},
    {time=26.308,key="0"},{time=26.769,key="0"},{time=27.000,key="e"},
    {time=27.231,key="u"},{time=27.462,key="s"},
    -- === Bセクション 再現 (Aマイナー) ===
    {time=28.615,key="u"},{time=28.846,key="y"},{time=29.077,key="u"},
    {time=29.308,key="y"},{time=29.538,key="u"},{time=29.769,key="w"},
    {time=30.000,key="t"},{time=30.231,key="e"},
    {time=30.462,key="0"},{time=30.923,key="0"},{time=31.154,key="e"},
    {time=31.385,key="u"},{time=31.615,key="s"},
    {time=32.769,key="w"},{time=33.000,key="e"},{time=33.231,key="t"},
    {time=33.462,key="u"},
    {time=34.385,key="u"},{time=34.615,key="i"},{time=34.846,key="u"},
    {time=35.077,key="t"},{time=35.308,key="e"},{time=35.538,key="w"},
    {time=35.769,key="0"},
    -- リピート最終
    {time=36.692,key="u"},{time=36.923,key="y"},{time=37.154,key="u"},
    {time=37.385,key="y"},{time=37.615,key="u"},{time=37.846,key="w"},
    {time=38.077,key="t"},{time=38.308,key="e"},
    {time=38.538,key="0"},{time=39.000,key="0"},{time=39.231,key="e"},
    {time=39.462,key="u"},{time=39.692,key="s"},
    {time=40.846,key="w"},{time=41.077,key="e"},{time=41.308,key="t"},
    {time=41.538,key="u"},
    {time=42.462,key="u"},{time=42.692,key="i"},{time=42.923,key="u"},
    {time=43.154,key="t"},{time=43.385,key="e"},{time=43.615,key="w"},
    {time=43.846,key="0"},{time=44.308,key="1"},
}

-- ============================================================
--  曲4: Last Christmas (George Michael, 1984)
--  BPM≈116  8分音符≈0.259s  キー: Aメジャー相当
--  C4=1 C#4=2 D4=3 D#4=4 E4=5 F4=6 F#4=7 G4=8 G#4=9 A4=0
--  B4=w C5=e C#5=r D5=t D#5=y E5=u F5=i F#5=o G5=p
--  G#5=a A5=s
-- ============================================================
local notes_lastChristmas = {
    -- イントロ: A5 G#5 A5 | E5 D5 E5 | A5 G#5 A5 | ...
    {time=0.000,key="s"},{time=0.259,key="a"},{time=0.517,key="s"},
    {time=0.776,key="u"},{time=1.035,key="t"},{time=1.294,key="u"},
    {time=1.552,key="s"},{time=1.811,key="a"},{time=2.070,key="s"},
    {time=2.328,key="u"},{time=2.587,key="t"},{time=2.846,key="u"},
    -- ヴァース "Last Christmas":
    -- A4 A4 | G#4 A4 B4 A4 G#4 | F#4 G#4 A4 | G#4 A4 B4 A4 | G#4 |
    {time=3.622,key="0"},{time=3.881,key="0"},
    {time=4.140,key="9"},{time=4.398,key="0"},{time=4.657,key="w"},
    {time=4.916,key="0"},{time=5.175,key="9"},
    {time=5.434,key="7"},{time=5.692,key="9"},{time=5.951,key="0"},
    {time=6.728,key="9"},{time=6.986,key="0"},{time=7.245,key="w"},
    {time=7.504,key="0"},{time=7.763,key="9"},
    -- "but the very next day":
    -- A4 | C#5 B4 | C#5 B4 A4 G#4 |
    {time=8.022,key="0"},
    {time=8.539,key="r"},{time=8.798,key="w"},
    {time=9.057,key="r"},{time=9.316,key="w"},{time=9.575,key="0"},{time=9.834,key="9"},
    -- "you gave it away":
    -- A4 B4 A4 | G#4 A4 |
    {time=10.351,key="0"},{time=10.610,key="w"},{time=10.869,key="0"},
    {time=11.128,key="9"},{time=11.905,key="0"},
    -- "this year, to save me from tears":
    -- A5 G#5 A5 E5 | A5(hold) | A5 G#5 A5 F#5 | A5(hold) |
    {time=12.681,key="s"},{time=12.940,key="a"},{time=13.199,key="s"},{time=13.458,key="u"},
    {time=14.234,key="s"},
    {time=14.752,key="s"},{time=15.010,key="a"},{time=15.269,key="s"},{time=15.528,key="o"},
    {time=16.305,key="s"},
    -- "I'll give it to someone special":
    -- A4 G#4 A4 B4 | A4 G#4 A4 | G#4 A4 |
    {time=17.081,key="0"},{time=17.340,key="9"},{time=17.599,key="0"},{time=17.858,key="w"},
    {time=18.116,key="0"},{time=18.375,key="9"},{time=18.634,key="0"},
    {time=18.893,key="9"},{time=19.410,key="0"},
    -- コーラス "Once bitten and twice shy":
    -- C#5 C#5 | C#5 B4 A4 | B4 B4 B4 | B4 A4 G#4 A4 |
    {time=20.187,key="r"},{time=20.446,key="r"},
    {time=20.705,key="r"},{time=20.963,key="w"},{time=21.222,key="0"},
    {time=21.999,key="w"},{time=22.258,key="w"},
    {time=22.516,key="w"},{time=22.775,key="0"},{time=23.034,key="9"},{time=23.293,key="0"},
    -- "I keep my distance but":
    -- E5 E5 | E5 D5 C#5 D5 E5 |
    {time=24.069,key="u"},{time=24.328,key="u"},
    {time=24.587,key="u"},{time=24.846,key="t"},{time=25.104,key="r"},
    {time=25.363,key="t"},{time=25.622,key="u"},
    -- "tears still catch my eye":
    -- A5 G#5 A5 | G#5 A5 E5 |
    {time=26.140,key="s"},{time=26.399,key="a"},{time=26.657,key="s"},
    {time=26.916,key="a"},{time=27.175,key="s"},{time=27.434,key="u"},
    -- "Tell me baby, do you recognize me?":
    -- E5 D5 C#5 D5 E5 | A4 B4 C#5 | E5(hold) |
    {time=28.469,key="u"},{time=28.727,key="t"},{time=28.986,key="r"},
    {time=29.245,key="t"},{time=29.504,key="u"},
    {time=30.022,key="0"},{time=30.281,key="w"},{time=30.540,key="r"},
    {time=31.057,key="u"},
    -- "Well, it's been a year":
    -- C#5 B4 A4 G#4 A4 |
    {time=31.834,key="r"},{time=32.093,key="w"},{time=32.352,key="0"},
    {time=32.610,key="9"},{time=33.128,key="0"},
    -- "it doesn't surprise me":
    -- B4 C#5 D5 C#5 B4 | A4 |
    {time=33.646,key="w"},{time=33.904,key="r"},{time=34.163,key="t"},
    {time=34.422,key="r"},{time=34.681,key="w"},{time=35.198,key="0"},
    -- "Merry Christmas, I wrapped it up and sent it":
    -- A5 G#5 A5 E5 A5 | G#5 A5 G#5 F#5 G#5 |
    {time=35.975,key="s"},{time=36.234,key="a"},{time=36.493,key="s"},
    {time=36.751,key="u"},{time=37.010,key="s"},
    {time=37.528,key="a"},{time=37.787,key="s"},{time=38.045,key="a"},
    {time=38.304,key="o"},{time=38.563,key="a"},
    -- "with a note saying 'I love you' I meant it":
    -- A5 G#5 A5 E5 | A4 B4 C#5 E5 A5 |
    {time=39.340,key="s"},{time=39.598,key="a"},{time=39.857,key="s"},{time=40.116,key="u"},
    {time=40.634,key="0"},{time=40.893,key="w"},{time=41.151,key="r"},
    {time=41.410,key="u"},{time=41.669,key="s"},
    -- "Now I know what a fool I've been":
    -- E5 D5 C#5 B4 A4 | E5 D5 C#5 B4 A4 |
    {time=42.445,key="u"},{time=42.704,key="t"},{time=42.963,key="r"},
    {time=43.222,key="w"},{time=43.480,key="0"},
    {time=43.998,key="u"},{time=44.257,key="t"},{time=44.516,key="r"},
    {time=44.775,key="w"},{time=45.034,key="0"},
    -- "but if you kissed me now I know you'd fool me again":
    -- A4 B4 C#5 D5 E5 | A5 G#5 A5 | G#5 A5(hold) |
    {time=45.551,key="0"},{time=45.810,key="w"},{time=46.069,key="r"},
    {time=46.328,key="t"},{time=46.587,key="u"},
    {time=47.104,key="s"},{time=47.363,key="a"},{time=47.622,key="s"},
    {time=47.880,key="a"},{time=48.657,key="s"},
}

-- ============================================================
--  仮想キー送信
-- ============================================================
local VIM = game:GetService("VirtualInputManager")

local KEY_CODES = {
    ["1"]=Enum.KeyCode.One,   ["2"]=Enum.KeyCode.Two,
    ["3"]=Enum.KeyCode.Three, ["4"]=Enum.KeyCode.Four,
    ["5"]=Enum.KeyCode.Five,  ["6"]=Enum.KeyCode.Six,
    ["7"]=Enum.KeyCode.Seven, ["8"]=Enum.KeyCode.Eight,
    ["9"]=Enum.KeyCode.Nine,  ["0"]=Enum.KeyCode.Zero,
    ["q"]=Enum.KeyCode.Q,  ["w"]=Enum.KeyCode.W,
    ["e"]=Enum.KeyCode.E,  ["r"]=Enum.KeyCode.R,
    ["t"]=Enum.KeyCode.T,  ["y"]=Enum.KeyCode.Y,
    ["u"]=Enum.KeyCode.U,  ["i"]=Enum.KeyCode.I,
    ["o"]=Enum.KeyCode.O,  ["p"]=Enum.KeyCode.P,
    ["a"]=Enum.KeyCode.A,  ["s"]=Enum.KeyCode.S,
    ["d"]=Enum.KeyCode.D,  ["f"]=Enum.KeyCode.F,
    ["g"]=Enum.KeyCode.G,  ["h"]=Enum.KeyCode.H,
    ["j"]=Enum.KeyCode.J,  ["k"]=Enum.KeyCode.K,
    ["l"]=Enum.KeyCode.L,  [";"]=Enum.KeyCode.Semicolon,
    ["z"]=Enum.KeyCode.Z,  ["x"]=Enum.KeyCode.X,
    ["c"]=Enum.KeyCode.C,  ["v"]=Enum.KeyCode.V,
    ["b"]=Enum.KeyCode.B,  ["n"]=Enum.KeyCode.N,
    ["m"]=Enum.KeyCode.M,
}

local function pressKey(keyStr)
    local kc = KEY_CODES[keyStr]
    if kc then
        VIM:SendKeyEvent(true,  kc, false, game)
        task.delay(0.05, function()
            VIM:SendKeyEvent(false, kc, false, game)
        end)
    end
end

-- ============================================================
--  再生状態管理
-- ============================================================
local isPlaying = false

local function playSong(notesTable, songTitle)
    if isPlaying then
        Rayfield:Notify({
            Title = "Piano Player",
            Content = "すでに再生中です！\n先に停止してください。",
            Duration = 2,
            Image = "rbxassetid://4483345998",
        })
        return
    end
    isPlaying = true
    Rayfield:Notify({
        Title = "♪ " .. songTitle,
        Content = "再生を開始します",
        Duration = 3,
        Image = "rbxassetid://4483345998",
    })
    task.spawn(function()
        local startTime = tick()
        for _, note in ipairs(notesTable) do
            local waitTime = note.time - (tick() - startTime)
            if waitTime > 0 then task.wait(waitTime) end
            pressKey(note.key)
        end
        isPlaying = false
        Rayfield:Notify({
            Title = "♪ " .. songTitle,
            Content = "再生が終了しました",
            Duration = 3,
            Image = "rbxassetid://4483345998",
        })
    end)
end

local function stopSong()
    if isPlaying then
        isPlaying = false
        Rayfield:Notify({
            Title = "Piano Player",
            Content = "再生を停止しました",
            Duration = 2,
            Image = "rbxassetid://4483345998",
        })
    end
end

-- ============================================================
--  Rayfield UI 構築
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name            = "🎹 Virtual Piano Player",
    LoadingTitle    = "Piano Player",
    LoadingSubtitle = "4曲収録",
    ConfigurationSaving = { Enabled = false },
    Discord         = { Enabled = false },
    KeySystem       = false,
})

-- ===== Songタブ =====
local SongTab = Window:CreateTab("🎵 Songs", 4483345998)

SongTab:CreateSection("曲を選んで再生ボタンを押してください")

-- 1. Libra Heart
SongTab:CreateButton({
    Name = "▶  Libra Heart  (imaizumi)",
    Callback = function()
        playSong(notes_libraHeart, "Libra Heart")
    end,
})

-- 2. どんぐりころころ
SongTab:CreateButton({
    Name = "▶  どんぐりころころ  (日本童謡)",
    Callback = function()
        playSong(notes_donguri, "どんぐりころころ")
    end,
})

-- 3. トルコ行進曲
SongTab:CreateButton({
    Name = "▶  トルコ行進曲  (Mozart K.331)",
    Callback = function()
        playSong(notes_turkish, "トルコ行進曲")
    end,
})

-- 4. Last Christmas
SongTab:CreateButton({
    Name = "▶  Last Christmas  (George Michael)",
    Callback = function()
        playSong(notes_lastChristmas, "Last Christmas")
    end,
})

-- ===== Controlタブ =====
local CtrlTab = Window:CreateTab("⚙ Control", 4483345998)

CtrlTab:CreateSection("再生コントロール")

CtrlTab:CreateButton({
    Name = "⏹  停止",
    Callback = function()
        stopSong()
    end,
})

CtrlTab:CreateParagraph({
    Title = "使い方",
    Content =
        "1. Roblox Virtual Piano を開く\n" ..
        "2. ピアノの上にカーソルを置く\n" ..
        "3. Songsタブから曲を選ぶ\n" ..
        "4. 再生中は他の操作を避ける\n" ..
        "5. 停止したい場合は⏹ボタン",
})

CtrlTab:CreateParagraph({
    Title = "収録曲",
    Content =
        "① Libra Heart (imaizumi)\n" ..
        "② どんぐりころころ (日本童謡)\n" ..
        "③ トルコ行進曲 (Mozart)\n" ..
        "④ Last Christmas (George Michael)",
})
