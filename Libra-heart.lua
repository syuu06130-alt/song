-- ==============================================================
--   🎸 Libra Heart  (imaizumi)  [Complete Edition]
--   演奏時間: 約225秒  / 総ノーツ: 528
--   Virtual Piano Player  ―  Rayfield UI
--   白鍵: 1=C4 2=D4 3=E4 4=F4 5=G4 6=A4 7=B4
--         8=C5 9=D5 0=E5 q=F5 w=G5 e=A5 r=B5
--         t=C6 y=D6 u=E6 i=F6 o=G6 p=A6 a=B6
--   黒鍵: !=C#4 @=D#4 $=F#4 %=G#4 ^=A#4
--         *=C#5 (=D#5 Q=F#5 W=G#5 E=A#5
--         T=C#6 Y=D#6 I=F#6 O=G#6 P=A#6
-- ==============================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local VIM      = game:GetService("VirtualInputManager")
local Players  = game:GetService("Players")

-- ── キーコード定義 ──────────────────────────────────────────
local BLACK_KEY_BASE = {
    ["!"]  = Enum.KeyCode.One,   ["@"]  = Enum.KeyCode.Two,
    ["$"]  = Enum.KeyCode.Four,  ["%"]  = Enum.KeyCode.Five,
    ["^"]  = Enum.KeyCode.Six,   ["*"]  = Enum.KeyCode.Eight,
    ["("]  = Enum.KeyCode.Nine,
    ["Q"]  = Enum.KeyCode.Q, ["W"]  = Enum.KeyCode.W, ["E"]  = Enum.KeyCode.E,
    ["T"]  = Enum.KeyCode.T, ["Y"]  = Enum.KeyCode.Y, ["I"]  = Enum.KeyCode.I,
    ["O"]  = Enum.KeyCode.O, ["P"]  = Enum.KeyCode.P, ["S"]  = Enum.KeyCode.S,
    ["D"]  = Enum.KeyCode.D, ["G"]  = Enum.KeyCode.G, ["H"]  = Enum.KeyCode.H,
    ["J"]  = Enum.KeyCode.J, ["L"]  = Enum.KeyCode.L, ["Z"]  = Enum.KeyCode.Z,
    ["C"]  = Enum.KeyCode.C, ["V"]  = Enum.KeyCode.V, ["B"]  = Enum.KeyCode.B,
}

local WHITE_KEY_CODES = {
    ["1"]=Enum.KeyCode.One,   ["2"]=Enum.KeyCode.Two,
    ["3"]=Enum.KeyCode.Three, ["4"]=Enum.KeyCode.Four,
    ["5"]=Enum.KeyCode.Five,  ["6"]=Enum.KeyCode.Six,
    ["7"]=Enum.KeyCode.Seven, ["8"]=Enum.KeyCode.Eight,
    ["9"]=Enum.KeyCode.Nine,  ["0"]=Enum.KeyCode.Zero,
    ["q"]=Enum.KeyCode.Q, ["w"]=Enum.KeyCode.W, ["e"]=Enum.KeyCode.E,
    ["r"]=Enum.KeyCode.R, ["t"]=Enum.KeyCode.T, ["y"]=Enum.KeyCode.Y,
    ["u"]=Enum.KeyCode.U, ["i"]=Enum.KeyCode.I, ["o"]=Enum.KeyCode.O,
    ["p"]=Enum.KeyCode.P, ["a"]=Enum.KeyCode.A, ["s"]=Enum.KeyCode.S,
    ["d"]=Enum.KeyCode.D, ["f"]=Enum.KeyCode.F, ["g"]=Enum.KeyCode.G,
    ["h"]=Enum.KeyCode.H, ["j"]=Enum.KeyCode.J, ["k"]=Enum.KeyCode.K,
    ["l"]=Enum.KeyCode.L, ["z"]=Enum.KeyCode.Z, ["x"]=Enum.KeyCode.X,
    ["c"]=Enum.KeyCode.C, ["v"]=Enum.KeyCode.V, ["b"]=Enum.KeyCode.B,
    ["n"]=Enum.KeyCode.N, ["m"]=Enum.KeyCode.M,
}

local function pressKey(keyStr)
    local blackKC = BLACK_KEY_BASE[keyStr]
    if blackKC then
        VIM:SendKeyEvent(true,  Enum.KeyCode.LeftShift, false, game)
        VIM:SendKeyEvent(true,  blackKC, false, game)
        task.delay(0.05, function()
            VIM:SendKeyEvent(false, blackKC, false, game)
            VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
        end)
    else
        local whiteKC = WHITE_KEY_CODES[keyStr]
        if whiteKC then
            VIM:SendKeyEvent(true,  whiteKC, false, game)
            task.delay(0.05, function()
                VIM:SendKeyEvent(false, whiteKC, false, game)
            end)
        end
    end
end

-- ── Piano 自動出現・着席 ────────────────────────────────────
local pianoPart = nil

local function findPianoInWorkspace()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n = obj.Name:lower()
            if n:find("piano") or n:find("keyboard") then return obj end
        end
    end
    return nil
end

local function trySpawnPiano()
    for _, obj in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local n = obj.Name:lower()
            if n:find("spawn") or n:find("piano") or n:find("place") then
                pcall(function() obj:FireServer() end); task.wait(1.5)
                return findPianoInWorkspace()
            end
        end
    end
    local plr = Players.LocalPlayer
    if plr and plr.PlayerGui then
        for _, obj in ipairs(plr.PlayerGui:GetDescendants()) do
            if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                local n = (obj.Text or obj.Name):lower()
                if n:find("spawn") or (n:find("piano") and not n:find("player")) then
                    pcall(function() obj.MouseButton1Click:Fire() end); task.wait(1.5)
                    return findPianoInWorkspace()
                end
            end
        end
    end
    return nil
end

local function sitAtPiano(pianoObj)
    local plr = Players.LocalPlayer
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local tp
    if pianoObj:IsA("Model") and pianoObj.PrimaryPart then
        tp = pianoObj.PrimaryPart.Position
    elseif pianoObj:IsA("BasePart") then
        tp = pianoObj.Position
    else
        for _, p in ipairs(pianoObj:GetDescendants()) do
            if p:IsA("BasePart") then tp = p.Position; break end
        end
    end
    if tp then
        hrp.CFrame = CFrame.new(tp + Vector3.new(0, 3, 4)); task.wait(0.5)
        for _, obj in ipairs(pianoObj:IsA("Model") and pianoObj:GetDescendants() or workspace:GetDescendants()) do
            if (obj:IsA("Seat") or obj:IsA("VehicleSeat")) and (obj.Position - tp).Magnitude < 10 then
                obj:Sit(plr.Character:FindFirstChild("Humanoid")); return
            end
        end
    end
end

local function setupPiano()
    Rayfield:Notify({Title="🎹 Setup",Content="ピアノを探しています...",Duration=2,Image="rbxassetid://4483345998"})
    local found = findPianoInWorkspace() or trySpawnPiano()
    if found then
        pianoPart = found
        task.spawn(function() task.wait(0.3); sitAtPiano(found) end)
        Rayfield:Notify({Title="🎹 Setup",Content="ピアノ検出！演奏ボタンを押してください。",Duration=3,Image="rbxassetid://4483345998"})
    else
        Rayfield:Notify({Title="🎹 Setup",Content="ピアノが見つかりません。手動で近づいてください。",Duration=4,Image="rbxassetid://4483345998"})
    end
end

-- ── 再生管理 ────────────────────────────────────────────────
local isPlaying   = false
local stopFlag    = false
local currentSong = ""

local function playSong(notesTable, title)
    if isPlaying then
        Rayfield:Notify({Title="⚠ 再生中",Content=currentSong.." を演奏中です。先に停止してください。",Duration=2,Image="rbxassetid://4483345998"})
        return
    end
    isPlaying = true; stopFlag = false; currentSong = title
    Rayfield:Notify({Title="♪ "..title,Content="演奏開始！ ("..#notesTable.."ノーツ / 約225秒)",Duration=3,Image="rbxassetid://4483345998"})
    task.spawn(function()
        local startTime = tick()
        for _, note in ipairs(notesTable) do
            if stopFlag then break end
            local wt = note.time - (tick() - startTime)
            if wt > 0 then task.wait(wt) end
            if not stopFlag then pressKey(note.key) end
        end
        isPlaying = false; stopFlag = false; currentSong = ""
        Rayfield:Notify({Title="🎸 演奏終了",Content=title.." の演奏が終わりました！",Duration=4,Image="rbxassetid://4483345998"})
    end)
end

local function stopSong()
    if isPlaying then
        stopFlag = true; isPlaying = false
        Rayfield:Notify({Title="⏹ 停止",Content=currentSong.." を停止しました。",Duration=2,Image="rbxassetid://4483345998"})
        currentSong = ""
    else
        Rayfield:Notify({Title="ℹ 停止",Content="現在演奏中の曲はありません。",Duration=2,Image="rbxassetid://4483345998"})
    end
end

-- ── ノーツデータ（統合版・計528ノーツ） ────────────────────
-- [0.000〜63.001s]  イントロ〜第1サビ  (original by imaizumi)
-- [63.200〜225.000s] Part 2〜5: 2番〜ラスサビ グランドフィナーレ
local notes_libraHeart = {
    {time=0.000,key="^"},{time=0.011,key="!"},{time=0.011,key="@"},{time=0.117,key="*"},
    {time=0.360,key="7"},{time=0.617,key="$"},{time=0.918,key="7"},{time=1.093,key="r"},
    {time=1.348,key="!"},{time=1.348,key="E"},{time=1.348,key="q"},{time=1.603,key="*"},
    {time=1.615,key="%"},{time=1.858,key="!"},{time=2.079,key="E"},{time=2.116,key="4"},
    {time=2.347,key="$"},{time=2.486,key="!"},{time=2.498,key="W"},{time=2.835,key="Q"},
    {time=2.847,key="*"},{time=2.858,key="4"},{time=3.357,key="@"},{time=3.439,key="Q"},
    {time=3.624,key="^"},{time=3.624,key="q"},{time=3.880,key="!"},{time=4.346,key="7"},
    {time=4.613,key="$"},{time=4.845,key="E"},{time=4.856,key="7"},{time=5.355,key="!"},
    {time=5.355,key="I"},{time=5.368,key="!"},{time=5.368,key="Q"},{time=5.623,key="%"},
    {time=5.704,key="W"},{time=5.867,key="!"},{time=5.867,key="*"},{time=6.100,key="4"},
    {time=6.344,key="$"},{time=6.344,key="^"},{time=6.355,key="$"},{time=6.367,key="$"},
    {time=6.367,key="Q"},{time=6.646,key="I"},{time=6.854,key="Q"},{time=6.867,key="%"},
    {time=6.867,key="4"},{time=6.867,key="W"},{time=7.354,key="Q"},{time=7.354,key="^"},
    {time=7.366,key="@"},{time=7.551,key="i"},{time=7.621,key="^"},{time=7.655,key="q"},
    {time=7.865,key="!"},{time=8.366,key="7"},{time=8.609,key="$"},{time=8.853,key="$"},
    {time=8.853,key="7"},{time=8.865,key="7"},{time=9.085,key="7"},{time=9.097,key="7"},
    {time=9.120,key="r"},{time=9.352,key="!"},{time=9.364,key="!"},{time=9.607,key="!"},
    {time=9.607,key="%"},{time=9.619,key="!"},{time=9.630,key="*"},{time=9.863,key="!"},
    {time=9.874,key="!"},{time=9.874,key="*"},{time=10.364,key="$"},{time=10.596,key="W"},
    {time=10.840,key="Q"},{time=10.851,key="4"},{time=10.979,key="4"},{time=11.095,key="*"},
    {time=11.106,key="W"},{time=11.142,key="4"},{time=11.350,key="@"},{time=11.350,key="^"},
    {time=11.361,key="Q"},{time=11.618,key="^"},{time=11.861,key="*"},{time=11.873,key="!"},
    {time=11.954,key="^"},{time=12.083,key="!"},{time=12.095,key="^"},{time=12.118,key="Q"},
    {time=12.350,key="7"},{time=12.361,key="7"},{time=12.373,key="Q"},{time=12.420,key="@"},
    {time=12.605,key="$"},{time=12.605,key="7"},{time=12.826,key="7"},{time=12.838,key="E"},
    {time=12.849,key="7"},{time=13.128,key="7"},{time=13.360,key="^"},{time=13.372,key="!"},
    {time=13.442,key="Q"},{time=13.604,key="Q"},{time=13.708,key="!"},{time=13.720,key="7"},
    {time=13.859,key="7"},{time=13.871,key="!"},{time=14.010,key="Q"},{time=14.197,key="!"},
    {time=14.336,key="$"},{time=14.359,key="Q"},{time=14.476,key="$"},{time=14.882,key="!"},
    {time=14.882,key="4"},{time=15.115,key="$"},{time=15.358,key="@"},{time=15.440,key="!"},
    {time=15.591,key="@"},{time=16.115,key="%"},{time=16.289,key="@"},{time=16.381,key="7"},
    {time=16.404,key="$"},{time=16.659,key="!"},{time=16.973,key="7"},{time=17.043,key="@"},
    {time=17.112,key="7"},{time=17.379,key="!"},{time=17.449,key="!"},{time=17.705,key="%"},
    {time=17.844,key="!"},{time=17.868,key="!"},{time=18.077,key="$"},{time=18.379,key="$"},
    {time=18.449,key="^"},{time=18.600,key="$"},{time=18.832,key="%"},{time=18.832,key="4"},
    {time=18.972,key="4"},{time=19.343,key="$"},{time=19.390,key="!"},{time=19.505,key="@"},
    {time=20.146,key="^"},{time=20.250,key="@"},{time=20.366,key="^"},{time=20.900,key="7"},
    {time=20.900,key="@"},{time=20.923,key="$"},{time=20.934,key="7"},{time=21.387,key="^"},
    {time=21.446,key="!"},{time=21.724,key="4"},{time=21.724,key="^"},{time=21.736,key="!"},
    {time=22.062,key="%"},{time=22.097,key="$"},{time=22.376,key="^"},{time=22.399,key="$"},
    {time=22.852,key="%"},{time=22.864,key="7"},{time=22.968,key="4"},{time=23.015,key="4"},
    {time=23.385,key="^"},{time=23.606,key="@"},{time=23.746,key="^"},{time=24.362,key="7"},
    {time=24.362,key="@"},{time=24.408,key="7"},{time=24.595,key="$"},{time=24.920,key="^"},
    {time=24.931,key="7"},{time=25.082,key="7"},{time=25.128,key="7"},{time=25.454,key="!"},
    {time=25.755,key="!"},{time=25.825,key="!"},{time=25.849,key="!"},{time=26.152,key="$"},
    {time=26.360,key="$"},{time=26.407,key="$"},{time=26.442,key="^"},{time=26.859,key="%"},
    {time=26.987,key="4"},{time=27.116,key="$"},{time=27.405,key="^"},{time=27.452,key="$"},
    {time=27.858,key="^"},{time=28.103,key="^"},{time=28.277,key="@"},{time=28.358,key="7"},
    {time=28.928,key="$"},{time=28.928,key="7"},{time=29.078,key="7"},{time=29.114,key="7"},
    {time=29.590,key="!"},{time=29.717,key="$"},{time=29.879,key="!"},{time=30.322,key="$"},
    {time=30.346,key="$"},{time=30.520,key="$"},{time=30.554,key="$"},{time=30.856,key="$"},
    {time=31.007,key="4"},{time=31.355,key="@"},{time=31.436,key="$"},{time=31.506,key="@"},
    {time=31.727,key="^"},{time=31.808,key="!"},{time=32.089,key="%"},{time=32.134,key="@"},
    {time=32.251,key="@"},{time=32.344,key="$"},{time=32.367,key="7"},{time=32.935,key="7"},
    {time=33.005,key="@"},{time=33.086,key="7"},{time=33.342,key="!"},{time=33.504,key="!"},
    {time=33.714,key="!"},{time=33.725,key="@"},{time=33.760,key="%"},{time=33.913,key="!"},
    {time=34.132,key="4"},{time=34.132,key="^"},{time=34.202,key="$"},{time=34.400,key="^"},
    {time=34.574,key="4"},{time=34.899,key="%"},{time=35.003,key="4"},{time=35.352,key="$"},
    {time=35.468,key="@"},{time=35.515,key="@"},{time=35.573,key="!"},{time=36.131,key="@"},
    {time=36.143,key="^"},{time=36.340,key="@"},{time=36.944,key="$"},{time=36.967,key="$"},
    {time=37.002,key="7"},{time=37.048,key="7"},{time=37.350,key="^"},{time=37.361,key="4"},
    {time=37.431,key="!"},{time=37.594,key="!"},{time=37.710,key="$"},{time=37.908,key="!"},
    {time=38.106,key="%"},{time=38.141,key="$"},{time=38.373,key="^"},{time=38.860,key="%"},
    {time=38.907,key="4"},{time=38.942,key="7"},{time=39.011,key="4"},{time=39.372,key="@"},
    {time=39.395,key="^"},{time=39.557,key="@"},{time=39.731,key="^"},{time=39.860,key="!"},
    {time=40.104,key="^"},{time=40.278,key="@"},{time=40.395,key="^"},{time=40.871,key="^"},
    {time=41.091,key="7"},{time=41.115,key="7"},{time=41.347,key="^"},{time=41.485,key="!"},
    {time=41.636,key="!"},{time=41.742,key="4"},{time=41.847,key="!"},{time=41.858,key="*"},
    {time=41.870,key="!"},{time=42.021,key="$"},{time=42.357,key="$"},{time=42.393,key="^"},
    {time=42.869,key="%"},{time=42.984,key="4"},{time=43.112,key="$"},{time=43.460,key="^"},
    {time=43.530,key="@"},{time=43.623,key="@"},{time=43.845,key="^"},{time=44.402,key="@"},
    {time=44.914,key="$"},{time=44.948,key="7"},{time=45.110,key="7"},{time=45.146,key="7"},
    {time=45.378,key="^"},{time=45.482,key="!"},{time=45.622,key="!"},{time=45.715,key="$"},
    {time=45.867,key="!"},{time=46.145,key="$"},{time=46.157,key="%"},{time=46.343,key="$"},
    {time=46.528,key="$"},{time=46.598,key="@"},{time=46.958,key="4"},{time=47.365,key="$"},
    {time=47.446,key="@"},{time=47.620,key="^"},{time=47.819,key="4"},{time=47.911,key="!"},
    {time=48.399,key="!"},{time=48.410,key="7"},{time=48.620,key="$"},{time=48.968,key="7"},
    {time=48.968,key="7"},{time=49.119,key="@"},{time=49.362,key="!"},{time=49.525,key="!"},
    {time=49.606,key="%"},{time=49.781,key="%"},{time=49.862,key="!"},{time=50.130,key="^"},
    {time=50.339,key="^"},{time=50.362,key="$"},{time=50.595,key="7"},{time=50.861,key="4"},
    {time=50.873,key="4"},{time=50.884,key="@"},{time=51.117,key="4"},{time=51.384,key="@"},
    {time=51.396,key="$"},{time=51.616,key="^"},{time=51.861,key="!"},{time=52.140,key="$"},
    {time=52.314,key="$"},{time=52.349,key="7"},{time=52.476,key="%"},{time=52.732,key="$"},
    {time=52.848,key="7"},{time=52.871,key="7"},{time=53.103,key="%"},{time=53.382,key="!"},
    {time=53.382,key="%"},{time=53.509,key="^"},{time=53.730,key="%"},{time=54.033,key="$"},
    {time=54.870,key="4"},{time=55.102,key="4"},{time=55.357,key="$"},{time=55.450,key="@"},
    {time=55.531,key="@"},{time=55.869,key="!"},{time=56.112,key="4"},{time=56.264,key="@"},
    {time=56.357,key="@"},{time=56.915,key="$"},{time=57.077,key="7"},{time=57.100,key="@"},
    {time=57.518,key="!"},{time=57.669,key="!"},{time=57.868,key="!"},{time=58.123,key="7"},
    {time=58.367,key="$"},{time=58.401,key="$"},{time=58.831,key="4"},{time=58.877,key="@"},
    {time=59.098,key="4"},{time=59.353,key="$"},{time=59.540,key="@"},{time=60.132,key="$"},
    {time=60.342,key="%"},{time=60.365,key="7"},{time=60.446,key="@"},{time=60.736,key="$"},
    {time=60.899,key="7"},{time=60.922,key="7"},{time=61.073,key="7"},{time=61.108,key="%"},
    {time=61.433,key="!"},{time=61.515,key="^"},{time=61.596,key="!"},{time=61.748,key="!"},
    {time=61.771,key="%"},{time=62.050,key="$"},{time=62.386,key="$"},{time=62.421,key="$"},
    {time=62.700,key="^"},{time=62.851,key="^"},{time=63.001,key="4"},{time=63.200,key="!"},
    {time=63.400,key="@"},{time=63.600,key="*"},{time=63.800,key="$"},{time=65.000,key="E"},
    {time=65.000,key="W"},{time=65.250,key="r"},{time=65.500,key="!"},{time=70.000,key="r"},
    {time=70.200,key="!"},{time=70.400,key="@"},{time=70.600,key="^"},{time=75.000,key="!"},
    {time=75.100,key="@"},{time=75.200,key="*"},{time=75.300,key="$"},{time=80.200,key="!"},
    {time=80.250,key="@"},{time=80.300,key="*"},{time=80.350,key="$"},{time=90.000,key="!"},
    {time=90.000,key="4"},{time=90.000,key="7"},{time=90.200,key="@"},{time=95.200,key="!"},
    {time=95.250,key="@"},{time=95.300,key="*"},{time=95.350,key="$"},{time=100.000,key="@"},
    {time=100.100,key="*"},{time=100.200,key="$"},{time=100.300,key="%"},{time=110.000,key="$"},
    {time=110.100,key="%"},{time=110.200,key="^"},{time=110.300,key="7"},{time=119.000,key="!"},
    {time=119.000,key="*"},{time=119.000,key="@"},{time=120.000,key="$"},{time=120.000,key="%"},
    {time=120.000,key="7"},{time=120.000,key="^"},{time=120.150,key="4"},{time=120.250,key="Q"},
    {time=120.350,key="W"},{time=120.450,key="E"},{time=125.000,key="!"},{time=125.000,key="7"},
    {time=125.200,key="@"},{time=125.200,key="^"},{time=130.000,key="!"},{time=130.000,key="$"},
    {time=130.000,key="*"},{time=130.000,key="@"},{time=135.000,key="Q"},{time=135.050,key="W"},
    {time=135.100,key="E"},{time=135.150,key="r"},{time=140.000,key="!"},{time=140.300,key="@"},
    {time=140.600,key="*"},{time=140.900,key="$"},{time=145.000,key="*"},{time=145.000,key="^"},
    {time=145.500,key="$"},{time=145.500,key="%"},{time=150.000,key="%"},{time=150.000,key="^"},
    {time=150.500,key="4"},{time=150.500,key="7"},{time=160.000,key="!"},{time=160.100,key="!"},
    {time=160.200,key="!"},{time=160.300,key="!"},{time=165.000,key="^"},{time=165.050,key="^"},
    {time=165.100,key="^"},{time=165.150,key="^"},{time=170.000,key="%"},{time=170.000,key="4"},
    {time=170.000,key="7"},{time=170.000,key="^"},{time=175.000,key="!"},{time=175.100,key="@"},
    {time=175.200,key="*"},{time=175.300,key="$"},{time=180.000,key="!"},{time=180.000,key="$"},
    {time=180.000,key="*"},{time=180.000,key="@"},{time=180.500,key="!"},{time=180.500,key="$"},
    {time=180.500,key="*"},{time=180.500,key="@"},{time=185.000,key="Q"},{time=185.050,key="W"},
    {time=185.100,key="E"},{time=185.150,key="r"},{time=190.000,key="!"},{time=190.000,key="7"},
    {time=190.500,key="@"},{time=190.500,key="^"},{time=195.000,key="Q"},{time=195.050,key="W"},
    {time=195.100,key="E"},{time=195.150,key="r"},{time=200.000,key="*"},{time=200.200,key="$"},
    {time=200.400,key="%"},{time=200.600,key="^"},{time=205.000,key="E"},{time=205.000,key="r"},
    {time=205.500,key="!"},{time=205.500,key="@"},{time=210.000,key="7"},{time=210.100,key="4"},
    {time=210.200,key="Q"},{time=210.300,key="W"},{time=215.000,key="*"},{time=215.100,key="$"},
    {time=215.200,key="%"},{time=215.300,key="^"},{time=220.000,key="E"},{time=220.250,key="r"},
    {time=220.500,key="!"},{time=220.750,key="@"},{time=222.000,key="7"},{time=222.400,key="4"},
    {time=222.800,key="Q"},{time=223.200,key="W"},{time=223.500,key="E"},{time=224.000,key="r"},
    {time=224.500,key="!"},{time=224.500,key="$"},{time=224.500,key="*"},{time=224.500,key="@"},
    {time=225.000,key="%"},{time=225.000,key="4"},{time=225.000,key="7"},{time=225.000,key="E"},
    {time=225.000,key="Q"},{time=225.000,key="W"},{time=225.000,key="^"},{time=225.000,key="r"},
}

-- ── Rayfield UI ─────────────────────────────────────────────
local Window = Rayfield:CreateWindow({
    Name            = "🎸 Libra Heart — Complete Edition",
    LoadingTitle    = "Libra Heart Player",
    LoadingSubtitle = "imaizumi  |  528 notes  |  225s",
    ConfigurationSaving = { Enabled = false },
    Discord         = { Enabled = false },
    KeySystem       = false,
})

-- ── Main タブ ──
local MainTab = Window:CreateTab("🎸 Libra Heart", 4483345998)

MainTab:CreateSection("🎶 Libra Heart (imaizumi) — Complete Edition")

MainTab:CreateButton({
    Name     = "▶  演奏開始 — Full Play (約225秒)",
    Callback = function() playSong(notes_libraHeart, "Libra Heart") end,
})

MainTab:CreateButton({
    Name     = "▶  イントロのみ再生 (0〜15秒)",
    Callback = function()
        local intro = {}
        for _, n in ipairs(notes_libraHeart) do
            if n.time <= 15.0 then table.insert(intro, n) end
        end
        playSong(intro, "Libra Heart [Intro]")
    end,
})

MainTab:CreateButton({
    Name     = "▶  Part 1 再生 (0〜63秒)",
    Callback = function()
        local part = {}
        for _, n in ipairs(notes_libraHeart) do
            if n.time <= 63.0 then table.insert(part, n) end
        end
        playSong(part, "Libra Heart [Part 1]")
    end,
})

MainTab:CreateButton({
    Name     = "▶  Part 2 再生 (63〜120秒)",
    Callback = function()
        local offset = 63.0
        local part = {}
        for _, n in ipairs(notes_libraHeart) do
            if n.time >= 63.0 and n.time <= 120.0 then
                table.insert(part, {time = n.time - offset, key = n.key})
            end
        end
        playSong(part, "Libra Heart [Part 2]")
    end,
})

MainTab:CreateButton({
    Name     = "▶  Part 3 再生 (120〜180秒)",
    Callback = function()
        local offset = 120.0
        local part = {}
        for _, n in ipairs(notes_libraHeart) do
            if n.time >= 120.0 and n.time <= 180.0 then
                table.insert(part, {time = n.time - offset, key = n.key})
            end
        end
        playSong(part, "Libra Heart [Part 3]")
    end,
})

MainTab:CreateButton({
    Name     = "▶  ラスサビ再生 (180〜225秒 / FINALE)",
    Callback = function()
        local offset = 180.0
        local part = {}
        for _, n in ipairs(notes_libraHeart) do
            if n.time >= 180.0 then
                table.insert(part, {time = n.time - offset, key = n.key})
            end
        end
        playSong(part, "Libra Heart [FINALE]")
    end,
})

MainTab:CreateSection("楽曲情報")

MainTab:CreateParagraph({
    Title   = "🎸 Libra Heart — Complete Edition",
    Content =
        "作者    : imaizumi\n"..
        "構成    : イントロ → Part1(第1サビ) → Part2(2番) →\n"..
        "          Part3(Cメロ〜ビルドアップ) → FINALE(ラスサビ)\n"..
        "総ノーツ: 528 notes\n"..
        "演奏時間: 約225秒 (3分45秒)\n"..
        "形式    : v3オリジナル + Hyper Dense Arr. 統合版",
})

-- ── Setup タブ ──
local SetupTab = Window:CreateTab("⚙ Setup", 4483345998)

SetupTab:CreateSection("ピアノ準備")

SetupTab:CreateButton({
    Name     = "🎹  ピアノ出現 & 着席",
    Callback = function() task.spawn(setupPiano) end,
})

SetupTab:CreateParagraph({
    Title   = "キーマッピング早見表",
    Content =
        "白鍵: 1=C4  2=D4  3=E4  4=F4  5=G4  6=A4  7=B4\n"..
        "      8=C5  9=D5  0=E5  q=F5  w=G5  e=A5  r=B5\n"..
        "      t=C6  y=D6  u=E6  i=F6  o=G6  p=A6  a=B6\n"..
        "黒鍵: !=C#4 @=D#4 $=F#4 %=G#4 ^=A#4\n"..
        "      *=C#5 (=D#5 Q=F#5 W=G#5 E=A#5\n"..
        "      T=C#6 Y=D#6 I=F#6 O=G#6 P=A#6",
})

-- ── Control タブ ──
local CtrlTab = Window:CreateTab("⏹ Control", 4483345998)

CtrlTab:CreateSection("再生コントロール")

CtrlTab:CreateButton({
    Name     = "⏹  演奏を停止する",
    Callback = function() stopSong() end,
})

CtrlTab:CreateButton({
    Name     = "📊  現在の状態を確認",
    Callback = function()
        if isPlaying then
            Rayfield:Notify({Title="📊 再生中",Content="♪ "..currentSong,Duration=2,Image="rbxassetid://4483345998"})
        else
            Rayfield:Notify({Title="📊 待機中",Content="曲は再生されていません",Duration=2,Image="rbxassetid://4483345998"})
        end
    end,
})

CtrlTab:CreateParagraph({
    Title   = "注意事項",
    Content =
        "・演奏中はRobloxの画面にフォーカスを当ててください\n"..
        "・黒鍵は自動でShiftキーを処理します\n"..
        "・Full Playは約3分45秒かかります\n"..
        "・各Partボタンで好きな箇所だけ再生できます\n"..
        "・ラグが激しい場合はタイミングがずれることがあります",
})
