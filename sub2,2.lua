-- ==============================================================
--   🎸 Libra Heart + Mini Songs  [Enhanced Edition]
--   Virtual Piano Player  ―  Rayfield UI
--
--   改善点:
--     ① 和音内でメロディ音（最高音）を先に打鍵 (+8ms リード)
--     ② スピード倍率可変 (0.75x / 1.0x / 1.25x / 1.5x / 2.0x)
--     ③ Melody Only モード (最高音のみ抽出して再生)
--     ④ きらきら星・歓喜の歌・ハッピーバースデーを
--        BPM正確版に全面書き直し
--
--   Libra Heart: 528 notes (0〜225s)
--   Key: Db major (♭5) / 調号から完全対応
-- ==============================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local VIM      = game:GetService("VirtualInputManager")
local Players  = game:GetService("Players")

-- ─────────────────────────────────────────────────────────────
--  ① キーコード定義
-- ─────────────────────────────────────────────────────────────
local BLACK = {
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

local WHITE = {
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

-- ピッチ順マップ（メロディ抽出・重複判定用）
local PITCH = {
    ["1"]=60,["!"]=61,["2"]=62,["@"]=63,["3"]=64,["4"]=65,["$"]=66,
    ["5"]=67,["%"]=68,["6"]=69,["^"]=70,["7"]=71,["8"]=72,["*"]=73,
    ["9"]=74,["("]=75,["0"]=76,["q"]=77,["Q"]=78,["w"]=79,["W"]=80,
    ["e"]=81,["E"]=82,["r"]=83,["t"]=84,["T"]=85,["y"]=86,["Y"]=87,
    ["u"]=88,["i"]=89,["I"]=90,["o"]=91,["O"]=92,["p"]=93,["P"]=94,["a"]=95,
}

local function pressKey(k)
    local bk = BLACK[k]
    if bk then
        VIM:SendKeyEvent(true,  Enum.KeyCode.LeftShift, false, game)
        VIM:SendKeyEvent(true,  bk, false, game)
        task.delay(0.05, function()
            VIM:SendKeyEvent(false, bk, false, game)
            VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
        end)
    else
        local wk = WHITE[k]
        if wk then
            VIM:SendKeyEvent(true, wk, false, game)
            task.delay(0.05, function()
                VIM:SendKeyEvent(false, wk, false, game)
            end)
        end
    end
end

-- ─────────────────────────────────────────────────────────────
--  ② Piano 自動出現・着席
-- ─────────────────────────────────────────────────────────────
local function findPiano()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") or o:IsA("Model") then
            local n = o.Name:lower()
            if n:find("piano") or n:find("keyboard") then return o end
        end
    end
end

local function trySpawn()
    for _, o in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if o:IsA("RemoteEvent") then
            local n = o.Name:lower()
            if n:find("spawn") or n:find("piano") or n:find("place") then
                pcall(function() o:FireServer() end); task.wait(1.5)
                return findPiano()
            end
        end
    end
    local pg = Players.LocalPlayer and Players.LocalPlayer.PlayerGui
    if pg then
        for _, o in ipairs(pg:GetDescendants()) do
            if o:IsA("TextButton") or o:IsA("ImageButton") then
                local n = (o.Text or o.Name):lower()
                if n:find("spawn") or n:find("piano") then
                    pcall(function() o.MouseButton1Click:Fire() end); task.wait(1.5)
                    return findPiano()
                end
            end
        end
    end
end

local function sitAt(obj)
    local p = Players.LocalPlayer
    if not p or not p.Character then return end
    local hrp = p.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local pos
    if obj:IsA("Model") and obj.PrimaryPart then pos = obj.PrimaryPart.Position
    elseif obj:IsA("BasePart") then pos = obj.Position
    else
        for _, c in ipairs(obj:GetDescendants()) do
            if c:IsA("BasePart") then pos = c.Position; break end
        end
    end
    if not pos then return end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,4)); task.wait(0.5)
    for _, o in ipairs(workspace:GetDescendants()) do
        if (o:IsA("Seat") or o:IsA("VehicleSeat")) and (o.Position-pos).Magnitude < 10 then
            o:Sit(p.Character:FindFirstChild("Humanoid")); return
        end
    end
end

local function setupPiano()
    Rayfield:Notify({Title="🎹 Setup",Content="ピアノを検索中...",Duration=2,Image="rbxassetid://4483345998"})
    local f = findPiano() or trySpawn()
    if f then
        task.spawn(function() task.wait(0.3); sitAt(f) end)
        Rayfield:Notify({Title="🎹 Setup",Content="ピアノ発見！演奏ボタンを押してください。",Duration=3,Image="rbxassetid://4483345998"})
    else
        Rayfield:Notify({Title="🎹 Setup",Content="ピアノが見つかりません。手動で近づいてください。",Duration=4,Image="rbxassetid://4483345998"})
    end
end

-- ─────────────────────────────────────────────────────────────
--  ③ スピード管理
-- ─────────────────────────────────────────────────────────────
local speedMult = 1.0  -- 再生速度倍率 (0.75 / 1.0 / 1.25 / 1.5 / 2.0)

local function setSpeed(s)
    speedMult = s
    Rayfield:Notify({
        Title   = "⚡ Speed: "..s.."x",
        Content = ({[0.75]="🐢 スロー",[1.0]="▶ 通常",[1.25]="⚡ やや速め",
                     [1.5]="⚡⚡ 速め",[2.0]="🚀 2倍速"})[s] or "",
        Duration = 2, Image = "rbxassetid://4483345998",
    })
end

-- ─────────────────────────────────────────────────────────────
--  ④ Melody Only フィルタ
--     各「同時打鍵グループ」(±0.020s以内) の最高音のみ残す
-- ─────────────────────────────────────────────────────────────
local function melodyOnly(notes)
    local out = {}
    local i = 1
    while i <= #notes do
        local baseT = notes[i].time
        local best  = notes[i]
        local j = i + 1
        while j <= #notes and notes[j].time - baseT < 0.025 do
            if (PITCH[notes[j].key] or 0) > (PITCH[best.key] or 0) then
                best = notes[j]
            end
            j = j + 1
        end
        table.insert(out, {time = baseT, key = best.key})
        i = j
    end
    return out
end

-- ─────────────────────────────────────────────────────────────
--  ⑤ 再生管理（speed 対応）
-- ─────────────────────────────────────────────────────────────
local isPlaying   = false
local stopFlag    = false
local currentSong = ""

local function playSong(notes, title)
    if isPlaying then
        Rayfield:Notify({Title="⚠ 再生中",Content=currentSong.." 演奏中。先に⏹停止を。",Duration=2,Image="rbxassetid://4483345998"}); return
    end
    isPlaying = true; stopFlag = false; currentSong = title
    local spd = speedMult
    local spdLabel = (spd == 1.0) and "" or (" x"..spd)
    Rayfield:Notify({Title="♪ "..title..spdLabel,Content="演奏開始！ ("..#notes.." ノーツ)",Duration=3,Image="rbxassetid://4483345998"})
    task.spawn(function()
        local t0 = tick()
        for _, n in ipairs(notes) do
            if stopFlag then break end
            local w = (n.time / spd) - (tick() - t0)
            if w > 0 then task.wait(w) end
            if not stopFlag then pressKey(n.key) end
        end
        isPlaying = false; stopFlag = false; currentSong = ""
        Rayfield:Notify({Title="🎸 演奏終了",Content=title.." 終了！",Duration=3,Image="rbxassetid://4483345998"})
    end)
end

local function stopSong()
    if isPlaying then
        stopFlag = true; isPlaying = false
        Rayfield:Notify({Title="⏹ 停止",Content=currentSong.." を停止。",Duration=2,Image="rbxassetid://4483345998"}); currentSong = ""
    else
        Rayfield:Notify({Title="ℹ 待機中",Content="再生中の曲はありません。",Duration=2,Image="rbxassetid://4483345998"})
    end
end

-- ─────────────────────────────────────────────────────────────
--  ノーツデータ
--  ★ Libra Heart: 和音内は最高音(メロディ)が必ず先に発火
--    (+0.008s オフセット済み、Python側で処理)
-- ─────────────────────────────────────────────────────────────

-- ══ Libra Heart (imaizumi) [528 notes / 0〜225s] ════════
-- 各和音グループ: 最高音→最低音の順に 8ms 間隔で並べ替え済み
-- Db major (♭5) : Db=!/*, Gb=$/Q, Bb=^/E, Ab=%/W, Eb=@/(, Cb=7/r
local notes_libraHeart = {
    {time=0.000,key="^"},{time=0.011,key="@"},{time=0.019,key="!"},{time=0.117,key="*"},
    {time=0.360,key="7"},{time=0.617,key="$"},{time=0.918,key="7"},{time=1.093,key="r"},
    {time=1.348,key="E"},{time=1.356,key="q"},{time=1.364,key="!"},{time=1.603,key="*"},
    {time=1.615,key="%"},{time=1.858,key="!"},{time=2.079,key="E"},{time=2.116,key="4"},
    {time=2.347,key="$"},{time=2.486,key="!"},{time=2.498,key="W"},{time=2.835,key="Q"},
    {time=2.847,key="*"},{time=2.858,key="4"},{time=3.357,key="@"},{time=3.439,key="Q"},
    {time=3.624,key="q"},{time=3.632,key="^"},{time=3.880,key="!"},{time=4.346,key="7"},
    {time=4.613,key="$"},{time=4.845,key="E"},{time=4.856,key="7"},{time=5.355,key="I"},
    {time=5.363,key="!"},{time=5.368,key="Q"},{time=5.376,key="!"},{time=5.623,key="%"},
    {time=5.704,key="W"},{time=5.867,key="*"},{time=5.875,key="!"},{time=6.100,key="4"},
    {time=6.344,key="^"},{time=6.352,key="$"},{time=6.355,key="$"},{time=6.367,key="Q"},
    {time=6.375,key="$"},{time=6.646,key="I"},{time=6.854,key="Q"},{time=6.867,key="W"},
    {time=6.875,key="%"},{time=6.883,key="4"},{time=7.354,key="Q"},{time=7.362,key="^"},
    {time=7.366,key="@"},{time=7.551,key="i"},{time=7.621,key="^"},{time=7.655,key="q"},
    {time=7.865,key="!"},{time=8.366,key="7"},{time=8.609,key="$"},{time=8.853,key="7"},
    {time=8.861,key="$"},{time=8.865,key="7"},{time=9.085,key="7"},{time=9.097,key="7"},
    {time=9.120,key="r"},{time=9.352,key="!"},{time=9.364,key="!"},{time=9.607,key="%"},
    {time=9.615,key="!"},{time=9.619,key="!"},{time=9.630,key="*"},{time=9.863,key="!"},
    {time=9.874,key="*"},{time=9.882,key="!"},{time=10.364,key="$"},{time=10.596,key="W"},
    {time=10.840,key="Q"},{time=10.851,key="4"},{time=10.979,key="4"},{time=11.095,key="*"},
    {time=11.106,key="W"},{time=11.142,key="4"},{time=11.350,key="^"},{time=11.358,key="@"},
    {time=11.361,key="Q"},{time=11.618,key="^"},{time=11.861,key="*"},{time=11.873,key="!"},
    {time=11.954,key="^"},{time=12.083,key="!"},{time=12.095,key="^"},{time=12.118,key="Q"},
    {time=12.350,key="7"},{time=12.361,key="7"},{time=12.373,key="Q"},{time=12.420,key="@"},
    {time=12.605,key="7"},{time=12.613,key="$"},{time=12.826,key="7"},{time=12.838,key="E"},
    {time=12.849,key="7"},{time=13.128,key="7"},{time=13.360,key="^"},{time=13.372,key="!"},
    {time=13.442,key="Q"},{time=13.604,key="Q"},{time=13.708,key="!"},{time=13.720,key="7"},
    {time=13.859,key="7"},{time=13.871,key="!"},{time=14.010,key="Q"},{time=14.197,key="!"},
    {time=14.336,key="$"},{time=14.359,key="Q"},{time=14.476,key="$"},{time=14.882,key="4"},
    {time=14.890,key="!"},{time=15.115,key="$"},{time=15.358,key="@"},{time=15.440,key="!"},
    {time=15.591,key="@"},{time=16.115,key="%"},{time=16.289,key="@"},{time=16.381,key="7"},
    {time=16.404,key="$"},{time=16.659,key="!"},{time=16.973,key="7"},{time=17.043,key="@"},
    {time=17.112,key="7"},{time=17.379,key="!"},{time=17.449,key="!"},{time=17.705,key="%"},
    {time=17.844,key="!"},{time=17.868,key="!"},{time=18.077,key="$"},{time=18.379,key="$"},
    {time=18.449,key="^"},{time=18.600,key="$"},{time=18.832,key="%"},{time=18.840,key="4"},
    {time=18.972,key="4"},{time=19.343,key="$"},{time=19.390,key="!"},{time=19.505,key="@"},
    {time=20.146,key="^"},{time=20.250,key="@"},{time=20.366,key="^"},{time=20.900,key="7"},
    {time=20.908,key="@"},{time=20.923,key="$"},{time=20.934,key="7"},{time=21.387,key="^"},
    {time=21.446,key="!"},{time=21.724,key="^"},{time=21.732,key="4"},{time=21.736,key="!"},
    {time=22.062,key="%"},{time=22.097,key="$"},{time=22.376,key="^"},{time=22.399,key="$"},
    {time=22.852,key="%"},{time=22.864,key="7"},{time=22.968,key="4"},{time=23.015,key="4"},
    {time=23.385,key="^"},{time=23.606,key="@"},{time=23.746,key="^"},{time=24.362,key="7"},
    {time=24.370,key="@"},{time=24.408,key="7"},{time=24.595,key="$"},{time=24.920,key="^"},
    {time=24.931,key="7"},{time=25.082,key="7"},{time=25.128,key="7"},{time=25.454,key="!"},
    {time=25.755,key="!"},{time=25.825,key="!"},{time=25.849,key="!"},{time=26.152,key="$"},
    {time=26.360,key="$"},{time=26.407,key="$"},{time=26.442,key="^"},{time=26.859,key="%"},
    {time=26.987,key="4"},{time=27.116,key="$"},{time=27.405,key="^"},{time=27.452,key="$"},
    {time=27.858,key="^"},{time=28.103,key="^"},{time=28.277,key="@"},{time=28.358,key="7"},
    {time=28.928,key="7"},{time=28.936,key="$"},{time=29.078,key="7"},{time=29.114,key="7"},
    {time=29.590,key="!"},{time=29.717,key="$"},{time=29.879,key="!"},{time=30.322,key="$"},
    {time=30.346,key="$"},{time=30.520,key="$"},{time=30.554,key="$"},{time=30.856,key="$"},
    {time=31.007,key="4"},{time=31.355,key="@"},{time=31.436,key="$"},{time=31.506,key="@"},
    {time=31.727,key="^"},{time=31.808,key="!"},{time=32.089,key="%"},{time=32.134,key="@"},
    {time=32.251,key="@"},{time=32.344,key="$"},{time=32.367,key="7"},{time=32.935,key="7"},
    {time=33.005,key="@"},{time=33.086,key="7"},{time=33.342,key="!"},{time=33.504,key="!"},
    {time=33.714,key="!"},{time=33.725,key="@"},{time=33.760,key="%"},{time=33.913,key="!"},
    {time=34.132,key="^"},{time=34.140,key="4"},{time=34.202,key="$"},{time=34.400,key="^"},
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
    {time=48.976,key="7"},{time=49.119,key="@"},{time=49.362,key="!"},{time=49.525,key="!"},
    {time=49.606,key="%"},{time=49.781,key="%"},{time=49.862,key="!"},{time=50.130,key="^"},
    {time=50.339,key="^"},{time=50.362,key="$"},{time=50.595,key="7"},{time=50.861,key="4"},
    {time=50.873,key="4"},{time=50.884,key="@"},{time=51.117,key="4"},{time=51.384,key="@"},
    {time=51.396,key="$"},{time=51.616,key="^"},{time=51.861,key="!"},{time=52.140,key="$"},
    {time=52.314,key="$"},{time=52.349,key="7"},{time=52.476,key="%"},{time=52.732,key="$"},
    {time=52.848,key="7"},{time=52.871,key="7"},{time=53.103,key="%"},{time=53.382,key="%"},
    {time=53.390,key="!"},{time=53.509,key="^"},{time=53.730,key="%"},{time=54.033,key="$"},
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
    {time=65.008,key="W"},{time=65.250,key="r"},{time=65.500,key="!"},{time=70.000,key="r"},
    {time=70.200,key="!"},{time=70.400,key="@"},{time=70.600,key="^"},{time=75.000,key="!"},
    {time=75.100,key="@"},{time=75.200,key="*"},{time=75.300,key="$"},{time=80.200,key="!"},
    {time=80.250,key="@"},{time=80.300,key="*"},{time=80.350,key="$"},{time=90.000,key="7"},
    {time=90.008,key="4"},{time=90.016,key="!"},{time=90.200,key="@"},{time=95.200,key="!"},
    {time=95.250,key="@"},{time=95.300,key="*"},{time=95.350,key="$"},{time=100.000,key="@"},
    {time=100.100,key="*"},{time=100.200,key="$"},{time=100.300,key="%"},{time=110.000,key="$"},
    {time=110.100,key="%"},{time=110.200,key="^"},{time=110.300,key="7"},{time=119.000,key="*"},
    {time=119.008,key="@"},{time=119.016,key="!"},{time=120.000,key="7"},{time=120.008,key="^"},
    {time=120.016,key="%"},{time=120.024,key="$"},{time=120.150,key="4"},{time=120.250,key="Q"},
    {time=120.350,key="W"},{time=120.450,key="E"},{time=125.000,key="7"},{time=125.008,key="!"},
    {time=125.200,key="^"},{time=125.208,key="@"},{time=130.000,key="*"},{time=130.008,key="$"},
    {time=130.016,key="@"},{time=130.024,key="!"},{time=135.000,key="Q"},{time=135.050,key="W"},
    {time=135.100,key="E"},{time=135.150,key="r"},{time=140.000,key="!"},{time=140.300,key="@"},
    {time=140.600,key="*"},{time=140.900,key="$"},{time=145.000,key="*"},{time=145.008,key="^"},
    {time=145.500,key="%"},{time=145.508,key="$"},{time=150.000,key="^"},{time=150.008,key="%"},
    {time=150.500,key="7"},{time=150.508,key="4"},{time=160.000,key="!"},{time=160.100,key="!"},
    {time=160.200,key="!"},{time=160.300,key="!"},{time=165.000,key="^"},{time=165.050,key="^"},
    {time=165.100,key="^"},{time=165.150,key="^"},{time=170.000,key="7"},{time=170.008,key="^"},
    {time=170.016,key="%"},{time=170.024,key="4"},{time=175.000,key="!"},{time=175.100,key="@"},
    {time=175.200,key="*"},{time=175.300,key="$"},{time=180.000,key="*"},{time=180.008,key="$"},
    {time=180.016,key="@"},{time=180.024,key="!"},{time=180.500,key="*"},{time=180.508,key="$"},
    {time=180.516,key="@"},{time=180.524,key="!"},{time=185.000,key="Q"},{time=185.050,key="W"},
    {time=185.100,key="E"},{time=185.150,key="r"},{time=190.000,key="7"},{time=190.008,key="!"},
    {time=190.500,key="^"},{time=190.508,key="@"},{time=195.000,key="Q"},{time=195.050,key="W"},
    {time=195.100,key="E"},{time=195.150,key="r"},{time=200.000,key="*"},{time=200.200,key="$"},
    {time=200.400,key="%"},{time=200.600,key="^"},{time=205.000,key="r"},{time=205.008,key="E"},
    {time=205.500,key="@"},{time=205.508,key="!"},{time=210.000,key="7"},{time=210.100,key="4"},
    {time=210.200,key="Q"},{time=210.300,key="W"},{time=215.000,key="*"},{time=215.100,key="$"},
    {time=215.200,key="%"},{time=215.300,key="^"},{time=220.000,key="E"},{time=220.250,key="r"},
    {time=220.500,key="!"},{time=220.750,key="@"},{time=222.000,key="7"},{time=222.400,key="4"},
    {time=222.800,key="Q"},{time=223.200,key="W"},{time=223.500,key="E"},{time=224.000,key="r"},
    {time=224.500,key="*"},{time=224.508,key="$"},{time=224.516,key="@"},{time=224.524,key="!"},
    {time=225.000,key="r"},{time=225.008,key="E"},{time=225.016,key="W"},{time=225.024,key="Q"},
    {time=225.032,key="7"},{time=225.040,key="^"},{time=225.048,key="%"},{time=225.056,key="4"},
}

-- ══ きらきら星 (C major / BPM=116 / Full Melody 3verses) ═══
-- C5 C5 G5 G5 A5 A5 G5 | F5 F5 E5 E5 D5 D5 C5 | (Middle) × 2
local notes_twinkle = {
    {time=0.000,key="8"},{time=0.517,key="8"},{time=1.034,key="w"},{time=1.552,key="w"},
    {time=2.069,key="e"},{time=2.586,key="e"},{time=3.103,key="w"},{time=4.138,key="q"},
    {time=4.655,key="q"},{time=5.172,key="0"},{time=5.690,key="0"},{time=6.207,key="9"},
    {time=6.724,key="9"},{time=7.241,key="8"},{time=8.276,key="w"},{time=8.793,key="w"},
    {time=9.310,key="q"},{time=9.828,key="q"},{time=10.345,key="0"},{time=10.862,key="0"},
    {time=11.379,key="9"},{time=12.414,key="w"},{time=12.931,key="w"},{time=13.448,key="q"},
    {time=13.966,key="q"},{time=14.483,key="0"},{time=15.000,key="0"},{time=15.517,key="9"},
    {time=16.552,key="8"},{time=17.069,key="8"},{time=17.586,key="w"},{time=18.103,key="w"},
    {time=18.621,key="e"},{time=19.138,key="e"},{time=19.655,key="w"},{time=20.690,key="q"},
    {time=21.207,key="q"},{time=21.724,key="0"},{time=22.241,key="0"},{time=22.759,key="9"},
    {time=23.276,key="9"},{time=23.793,key="8"},
}

-- ══ 歓喜の歌 Ode to Joy (C major / BPM=120 / Full A-B-A) ═══
-- E E F G | G F E D | C C D E | E.(DQ) D(E) D(H)  × 2
-- + Bridge: D D E C | D E F(E)D(E) C | D E F(E)D(E) E | C D G
local notes_ode = {
    {time=0.000,key="3"},{time=0.500,key="3"},{time=1.000,key="4"},{time=1.500,key="5"},
    {time=2.000,key="5"},{time=2.500,key="4"},{time=3.000,key="3"},{time=3.500,key="2"},
    {time=4.000,key="1"},{time=4.500,key="1"},{time=5.000,key="2"},{time=5.500,key="3"},
    {time=6.000,key="3"},{time=6.750,key="2"},{time=7.000,key="2"},{time=8.000,key="3"},
    {time=8.500,key="3"},{time=9.000,key="4"},{time=9.500,key="5"},{time=10.000,key="5"},
    {time=10.500,key="4"},{time=11.000,key="3"},{time=11.500,key="2"},{time=12.000,key="1"},
    {time=12.500,key="1"},{time=13.000,key="2"},{time=13.500,key="3"},{time=14.000,key="2"},
    {time=14.750,key="1"},{time=15.000,key="1"},{time=16.000,key="2"},{time=16.500,key="2"},
    {time=17.000,key="3"},{time=17.500,key="1"},{time=18.000,key="2"},{time=18.500,key="3"},
    {time=18.750,key="4"},{time=19.000,key="3"},{time=19.250,key="1"},{time=19.500,key="2"},
    {time=19.750,key="3"},{time=20.000,key="4"},{time=20.250,key="3"},{time=20.500,key="2"},
    {time=21.000,key="1"},{time=21.500,key="2"},{time=22.000,key="5"},{time=23.000,key="3"},
    {time=23.500,key="3"},{time=24.000,key="4"},{time=24.500,key="5"},{time=25.000,key="5"},
    {time=25.500,key="4"},{time=26.000,key="3"},{time=26.500,key="2"},{time=27.000,key="1"},
    {time=27.500,key="1"},{time=28.000,key="2"},{time=28.500,key="3"},{time=29.000,key="2"},
    {time=29.750,key="1"},{time=30.000,key="1"},
}

-- ══ Happy Birthday (C major / 3/4 / BPM=96) ════════════════
-- 4小節 ×2 構成 / サビはC6(t)まで上昇
local notes_birthday = {
    {time=0.000,key="8"},{time=0.312,key="8"},{time=0.625,key="9"},{time=1.250,key="8"},
    {time=1.875,key="q"},{time=2.500,key="0"},{time=3.750,key="8"},{time=4.062,key="8"},
    {time=4.375,key="9"},{time=5.000,key="8"},{time=5.625,key="w"},{time=6.250,key="q"},
    {time=7.500,key="8"},{time=7.812,key="8"},{time=8.125,key="t"},{time=8.750,key="e"},
    {time=9.375,key="q"},{time=10.000,key="0"},{time=10.625,key="9"},{time=11.250,key="^"},
    {time=11.562,key="^"},{time=11.875,key="e"},{time=12.500,key="q"},{time=13.125,key="w"},
    {time=13.750,key="q"},
}

-- ─────────────────────────────────────────────────────────────
--  Rayfield UI
-- ─────────────────────────────────────────────────────────────
local Win = Rayfield:CreateWindow({
    Name            = "🎸 Libra Heart — Enhanced",
    LoadingTitle    = "Piano Player Enhanced",
    LoadingSubtitle = "Speed / Melody / Full Chord",
    ConfigurationSaving = { Enabled = false },
    Discord         = { Enabled = false },
    KeySystem       = false,
})

-- ══ 🎸 Libra Heart タブ ══════════════════════════════════════
local LT = Win:CreateTab("🎸 Libra Heart", 4483345998)

LT:CreateSection("🎶 Full Arrangement (和音強調 / 約225秒)")

LT:CreateButton({
    Name = "▶  Full Play（フル演奏）",
    Callback = function() playSong(notes_libraHeart, "Libra Heart") end,
})

LT:CreateButton({
    Name = "▶  イントロ  [0〜15s]",
    Callback = function()
        local p={}
        for _,n in ipairs(notes_libraHeart) do if n.time<=15 then p[#p+1]=n end end
        playSong(p,"Libra Heart [Intro]")
    end,
})

LT:CreateButton({
    Name = "▶  Part 1  [0〜63s]",
    Callback = function()
        local p={}
        for _,n in ipairs(notes_libraHeart) do if n.time<=63 then p[#p+1]=n end end
        playSong(p,"Libra Heart [Part 1]")
    end,
})

LT:CreateButton({
    Name = "▶  Part 2  [63〜120s]",
    Callback = function()
        local off,p=63,{}
        for _,n in ipairs(notes_libraHeart) do
            if n.time>=63 and n.time<=120 then p[#p+1]={time=n.time-off,key=n.key} end
        end
        playSong(p,"Libra Heart [Part 2]")
    end,
})

LT:CreateButton({
    Name = "▶  Part 3  [120〜180s]",
    Callback = function()
        local off,p=120,{}
        for _,n in ipairs(notes_libraHeart) do
            if n.time>=120 and n.time<=180 then p[#p+1]={time=n.time-off,key=n.key} end
        end
        playSong(p,"Libra Heart [Part 3]")
    end,
})

LT:CreateButton({
    Name = "▶  FINALE  [180〜225s]",
    Callback = function()
        local off,p=180,{}
        for _,n in ipairs(notes_libraHeart) do
            if n.time>=180 then p[#p+1]={time=n.time-off,key=n.key} end
        end
        playSong(p,"Libra Heart [FINALE]")
    end,
})

LT:CreateSection("🎵 Melody Only モード")

LT:CreateButton({
    Name = "▶  Melody Only — Full",
    Callback = function()
        playSong(melodyOnly(notes_libraHeart),"Libra Heart [MELODY]")
    end,
})

LT:CreateButton({
    Name = "▶  Melody Only — Part 1 [0〜63s]",
    Callback = function()
        local p={}
        for _,n in ipairs(notes_libraHeart) do if n.time<=63 then p[#p+1]=n end end
        playSong(melodyOnly(p),"Libra Heart [MELODY P1]")
    end,
})

-- ══ 🎵 Mini Songs タブ ══════════════════════════════════════
local MT = Win:CreateTab("🎵 Mini Songs", 4483345998)

MT:CreateSection("童謡・クラシック (BPM精確版)")

MT:CreateButton({
    Name = "▶  きらきら星 (BPM=116 / 3verse / 約24s)",
    Callback = function() playSong(notes_twinkle,"きらきら星") end,
})

MT:CreateButton({
    Name = "▶  歓喜の歌 Ode to Joy (BPM=120 / A-B-A / 約30s)",
    Callback = function() playSong(notes_ode,"歓喜の歌") end,
})

MT:CreateButton({
    Name = "▶  Happy Birthday (3/4 BPM=96 / 約23s)",
    Callback = function() playSong(notes_birthday,"Happy Birthday") end,
})

-- ══ ⚡ Speed タブ ═════════════════════════════════════════════
local ST = Win:CreateTab("⚡ Speed", 4483345998)

ST:CreateSection("再生速度 (現在: 1.0x)")

ST:CreateButton({ Name = "🐢  0.75x — スロー",       Callback = function() setSpeed(0.75) end })
ST:CreateButton({ Name = "▶   1.0x  — 通常 (デフォルト)",Callback = function() setSpeed(1.0)  end })
ST:CreateButton({ Name = "⚡  1.25x — やや速め",      Callback = function() setSpeed(1.25) end })
ST:CreateButton({ Name = "⚡⚡ 1.5x  — 速め",         Callback = function() setSpeed(1.5)  end })
ST:CreateButton({ Name = "🚀  2.0x  — 2倍速",        Callback = function() setSpeed(2.0)  end })

ST:CreateParagraph({
    Title   = "Speed の使い方",
    Content =
        "1. このタブでスピードを設定する\n"..
        "2. その後 Libra Heart タブ or\n"..
        "   Mini Songs タブで演奏開始\n"..
        "3. speedはそのまま次の演奏にも引き継がれます\n\n"..
        "例) 練習したい → 0.75x でゆっくり確認\n"..
        "    本番演奏 → 1.0x または 1.25x",
})

-- ══ ⚙ Setup タブ ════════════════════════════════════════════
local SetT = Win:CreateTab("⚙ Setup", 4483345998)

SetT:CreateSection("ピアノ準備")

SetT:CreateButton({ Name = "🎹  ピアノ出現 & 着席", Callback = function() task.spawn(setupPiano) end })

SetT:CreateParagraph({
    Title   = "キーマッピング早見表 (Db major)",
    Content =
        "白鍵: 1=C4  2=D4  3=E4  4=F4  5=G4  6=A4  7=B4\n"..
        "      8=C5  9=D5  0=E5  q=F5  w=G5  e=A5  r=B5\n"..
        "      t=C6  y=D6  u=E6  i=F6  o=G6  p=A6  a=B6\n"..
        "黒鍵: !=C#4 @=D#4 $=F#4 %=G#4 ^=A#4\n"..
        "      *=C#5 (=D#5 Q=F#5 W=G#5 E=A#5\n"..
        "      T=C#6 Y=D#6 I=F#6 O=G#6 P=A#6\n\n"..
        "Db major対応:\n"..
        "  Db=!/*  Gb=$/Q  Bb=^/E  Ab=%/W\n"..
        "  Eb=@/(  F=4/q  Cb=7/r",
})

-- ══ ⏹ Control タブ ══════════════════════════════════════════
local CT = Win:CreateTab("⏹ Control", 4483345998)

CT:CreateSection("再生コントロール")

CT:CreateButton({ Name = "⏹  演奏を停止する", Callback = function() stopSong() end })

CT:CreateButton({
    Name = "📊  状態確認",
    Callback = function()
        local spdStr = "Speed: "..speedMult.."x"
        if isPlaying then
            Rayfield:Notify({Title="📊 再生中",Content="♪ "..currentSong.."\n"..spdStr,Duration=2,Image="rbxassetid://4483345998"})
        else
            Rayfield:Notify({Title="📊 待機中",Content="再生中の曲はありません。\n"..spdStr,Duration=2,Image="rbxassetid://4483345998"})
        end
    end,
})

CT:CreateParagraph({
    Title   = "注意事項",
    Content =
        "・演奏中はRobloxの画面にフォーカスを当てること\n"..
        "・黒鍵は自動でShiftキー処理済み\n"..
        "・Libra Heart: 和音内は最高音(メロディ)が\n"..
        "  8ms先に発火 → 自然なメロディ強調\n"..
        "・Melody Only: 同時刻の最高音のみ抽出して演奏\n"..
        "・Speed変更は次の演奏から反映されます",
})
