-- ==============================================================
--   🎸 Libra Heart Enhanced v2  [15曲収録]
--   Virtual Piano Player  ―  Rayfield UI
--
--   Libra Heart 1 : 528 notes / 0〜225s  (imaizumi)
--   Libra Heart 2 : 64 notes / 0〜27s   (imaizumi)
--   + Sub-songs 3曲 (15秒以上) + 新曲10曲
-- ==============================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local VIM      = game:GetService("VirtualInputManager")
local Players  = game:GetService("Players")

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
            task.delay(0.05, function() VIM:SendKeyEvent(false, wk, false, game) end)
        end
    end
end

local function findPiano()
    for _,o in ipairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") or o:IsA("Model") then
            local n=o.Name:lower()
            if n:find("piano") or n:find("keyboard") then return o end
        end
    end
end
local function trySpawn()
    for _,o in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if o:IsA("RemoteEvent") then
            local n=o.Name:lower()
            if n:find("spawn") or n:find("piano") or n:find("place") then
                pcall(function() o:FireServer() end); task.wait(1.5); return findPiano()
            end
        end
    end
    local pg=Players.LocalPlayer and Players.LocalPlayer.PlayerGui
    if pg then
        for _,o in ipairs(pg:GetDescendants()) do
            if o:IsA("TextButton") or o:IsA("ImageButton") then
                local n=(o.Text or o.Name):lower()
                if n:find("spawn") or n:find("piano") then
                    pcall(function() o.MouseButton1Click:Fire() end); task.wait(1.5); return findPiano()
                end
            end
        end
    end
end
local function sitAt(obj)
    local p=Players.LocalPlayer
    if not p or not p.Character then return end
    local hrp=p.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local pos
    if obj:IsA("Model") and obj.PrimaryPart then pos=obj.PrimaryPart.Position
    elseif obj:IsA("BasePart") then pos=obj.Position
    else for _,c in ipairs(obj:GetDescendants()) do if c:IsA("BasePart") then pos=c.Position;break end end end
    if not pos then return end
    hrp.CFrame=CFrame.new(pos+Vector3.new(0,3,4)); task.wait(0.5)
    for _,o in ipairs(workspace:GetDescendants()) do
        if (o:IsA("Seat") or o:IsA("VehicleSeat")) and (o.Position-pos).Magnitude<10 then
            o:Sit(p.Character:FindFirstChild("Humanoid")); return
        end
    end
end
local function setupPiano()
    Rayfield:Notify({Title="🎹 Setup",Content="ピアノを検索中...",Duration=2,Image="rbxassetid://4483345998"})
    local f=findPiano() or trySpawn()
    if f then task.spawn(function() task.wait(0.3);sitAt(f) end)
        Rayfield:Notify({Title="🎹 Setup",Content="ピアノ発見！",Duration=3,Image="rbxassetid://4483345998"})
    else
        Rayfield:Notify({Title="🎹 Setup",Content="手動で近づいてください",Duration=4,Image="rbxassetid://4483345998"})
    end
end

local speedMult=1.0
local function setSpeed(s)
    speedMult=s
    local lbl={[0.75]="🐢 スロー",[1.0]="▶ 通常",[1.25]="⚡ 速め",[1.5]="⚡⚡ 速い",[2.0]="🚀 2倍"}
    Rayfield:Notify({Title="⚡ Speed: "..s.."x",Content=lbl[s] or "",Duration=2,Image="rbxassetid://4483345998"})
end

local function melodyOnly(notes)
    local out,i={}; i=1
    while i<=#notes do
        local bt=notes[i].time; local best=notes[i]; local j=i+1
        while j<=#notes and notes[j].time-bt<0.025 do
            if (PITCH[notes[j].key] or 0)>(PITCH[best.key] or 0) then best=notes[j] end
            j=j+1
        end
        table.insert(out,{time=bt,key=best.key}); i=j
    end
    return out
end

local isPlaying=false; local stopFlag=false; local currentSong=""
local function playSong(notes,title)
    if isPlaying then
        Rayfield:Notify({Title="⚠ 再生中",Content=currentSong.." 演奏中",Duration=2,Image="rbxassetid://4483345998"}); return
    end
    isPlaying=true; stopFlag=false; currentSong=title
    local spd=speedMult
    Rayfield:Notify({Title="♪ "..title,Content="演奏開始 ("..#notes.."ノーツ) x"..spd,Duration=3,Image="rbxassetid://4483345998"})
    task.spawn(function()
        local t0=tick()
        for _,n in ipairs(notes) do
            if stopFlag then break end
            local w=(n.time/spd)-(tick()-t0)
            if w>0 then task.wait(w) end
            if not stopFlag then pressKey(n.key) end
        end
        isPlaying=false; stopFlag=false; currentSong=""
        Rayfield:Notify({Title="🎸 終了",Content=title.." 演奏終了！",Duration=3,Image="rbxassetid://4483345998"})
    end)
end
local function stopSong()
    if isPlaying then stopFlag=true;isPlaying=false
        Rayfield:Notify({Title="⏹ 停止",Content=currentSong,Duration=2,Image="rbxassetid://4483345998"}); currentSong=""
    else
        Rayfield:Notify({Title="ℹ 待機中",Content="再生中の曲はありません",Duration=2,Image="rbxassetid://4483345998"})
    end
end

-- ═══════════════════════════════════════════════════════════════
--  ノーツデータ
-- ═══════════════════════════════════════════════════════════════

-- ── Libra Heart 2 (imaizumi) [64 notes / ~27s] ──────────
-- 右手: F#5(Q) F5(q) C#5(*) B5(r) A#5/Bb5(E) G#5(W) × 3サイクル
-- 左手: Eb4(@) Bb4(^) C#4(!) B4(7) F#4($) G#4(%) F4(4) × 4パターン
-- 和音内は最高音→低音の順に10msオフセット発火済み
local notes_libra2 = {
    {time=0.000,key="Q"},{time=0.010,key="@"},{time=0.500,key="q"},{time=1.000,key="*"},
    {time=1.500,key="*"},{time=1.688,key="^"},{time=2.000,key="r"},{time=2.500,key="E"},
    {time=3.000,key="W"},{time=3.375,key="!"},{time=3.500,key="E"},{time=4.000,key="W"},
    {time=4.500,key="Q"},{time=5.000,key="Q"},{time=5.062,key="^"},{time=5.500,key="q"},
    {time=6.000,key="*"},{time=6.700,key="Q"},{time=6.750,key="7"},{time=7.400,key="W"},
    {time=8.100,key="Q"},{time=8.438,key="$"},{time=9.000,key="Q"},{time=9.500,key="q"},
    {time=10.000,key="*"},{time=10.125,key="7"},{time=10.500,key="*"},{time=11.000,key="r"},
    {time=11.500,key="E"},{time=11.812,key="$"},{time=12.000,key="W"},{time=12.500,key="E"},
    {time=13.000,key="W"},{time=13.500,key="Q"},{time=13.510,key="!"},{time=14.000,key="Q"},
    {time=14.500,key="q"},{time=15.000,key="*"},{time=15.188,key="%"},{time=15.700,key="Q"},
    {time=16.400,key="W"},{time=16.875,key="!"},{time=17.100,key="Q"},{time=18.000,key="Q"},
    {time=18.500,key="q"},{time=18.562,key="%"},{time=19.000,key="*"},{time=19.500,key="*"},
    {time=20.000,key="r"},{time=20.250,key="$"},{time=20.500,key="E"},{time=21.000,key="W"},
    {time=21.500,key="E"},{time=21.938,key="!"},{time=22.000,key="W"},{time=22.500,key="Q"},
    {time=23.000,key="Q"},{time=23.500,key="q"},{time=23.625,key="4"},{time=24.000,key="*"},
    {time=24.700,key="Q"},{time=25.312,key="!"},{time=25.400,key="W"},{time=26.100,key="Q"},
}

-- ── Libra Heart 1 (imaizumi) [528 notes / 0〜225s] ───────
-- 和音内は最高音→低音の順に8msオフセット発火済み
local notes_libra1 = {
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

-- ── きらきら星 (BPM=116 / 4verse+middle / ~46s) ───────────────
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
    {time=23.276,key="9"},{time=23.793,key="8"},{time=24.828,key="t"},{time=25.345,key="t"},
    {time=25.862,key="o"},{time=26.379,key="o"},{time=26.897,key="p"},{time=27.414,key="p"},
    {time=27.931,key="o"},{time=28.966,key="i"},{time=29.483,key="i"},{time=30.000,key="u"},
    {time=30.517,key="u"},{time=31.034,key="y"},{time=31.552,key="y"},{time=32.069,key="t"},
}

-- ── 歓喜の歌 Ode to Joy (BPM=116 / A-B-A full / ~38s) ─────────
local notes_ode = {
    {time=0.000,key="3"},{time=0.517,key="3"},{time=1.034,key="4"},{time=1.552,key="5"},
    {time=2.069,key="5"},{time=2.586,key="4"},{time=3.103,key="3"},{time=3.621,key="2"},
    {time=4.138,key="1"},{time=4.655,key="1"},{time=5.172,key="2"},{time=5.690,key="3"},
    {time=6.207,key="3"},{time=6.983,key="2"},{time=7.241,key="2"},{time=8.276,key="3"},
    {time=8.793,key="3"},{time=9.310,key="4"},{time=9.828,key="5"},{time=10.345,key="5"},
    {time=10.862,key="4"},{time=11.379,key="3"},{time=11.897,key="2"},{time=12.414,key="1"},
    {time=12.931,key="1"},{time=13.448,key="2"},{time=13.966,key="3"},{time=14.483,key="2"},
    {time=15.259,key="1"},{time=15.517,key="1"},{time=16.552,key="2"},{time=17.069,key="2"},
    {time=17.586,key="3"},{time=18.103,key="1"},{time=18.621,key="2"},{time=18.879,key="4"},
    {time=19.138,key="3"},{time=19.397,key="1"},{time=19.655,key="2"},{time=19.914,key="3"},
    {time=20.172,key="4"},{time=20.431,key="3"},{time=20.690,key="2"},{time=21.207,key="1"},
    {time=21.724,key="2"},{time=22.241,key="5"},{time=23.793,key="5"},{time=24.310,key="5"},
    {time=24.828,key="6"},{time=25.345,key="4"},{time=25.862,key="5"},{time=26.121,key="w"},
    {time=26.379,key="e"},{time=26.897,key="0"},{time=27.414,key="9"},{time=27.931,key="8"},
    {time=28.448,key="9"},{time=28.966,key="0"},{time=29.483,key="w"},{time=30.000,key="3"},
    {time=30.517,key="3"},{time=31.034,key="4"},{time=31.552,key="5"},{time=32.069,key="5"},
    {time=32.586,key="4"},{time=33.103,key="3"},{time=33.621,key="2"},{time=34.138,key="1"},
    {time=34.655,key="1"},{time=35.172,key="2"},{time=35.690,key="3"},{time=36.207,key="3"},
    {time=36.983,key="2"},{time=37.241,key="2"},{time=38.276,key="3"},{time=38.793,key="3"},
    {time=39.310,key="4"},{time=39.828,key="5"},{time=40.345,key="5"},{time=40.862,key="4"},
    {time=41.379,key="3"},{time=41.897,key="2"},{time=42.414,key="1"},{time=42.931,key="1"},
    {time=43.448,key="2"},{time=43.966,key="3"},{time=44.483,key="2"},{time=45.259,key="1"},
    {time=45.517,key="1"},
}

-- ── Happy Birthday (3/4 BPM=90 / 2verse high-range / ~26s) ────
local notes_birthday = {
    {time=0.000,key="8"},{time=0.333,key="8"},{time=0.667,key="9"},{time=1.333,key="8"},
    {time=2.000,key="q"},{time=2.667,key="0"},{time=4.000,key="8"},{time=4.333,key="8"},
    {time=4.667,key="9"},{time=5.333,key="8"},{time=6.000,key="w"},{time=6.667,key="q"},
    {time=8.000,key="8"},{time=8.333,key="8"},{time=8.667,key="t"},{time=9.333,key="e"},
    {time=10.000,key="q"},{time=10.667,key="0"},{time=11.333,key="9"},{time=12.000,key="^"},
    {time=12.333,key="^"},{time=12.667,key="e"},{time=13.333,key="q"},{time=14.000,key="w"},
    {time=14.667,key="q"},{time=16.000,key="8"},{time=16.333,key="8"},{time=16.667,key="9"},
    {time=17.333,key="8"},{time=18.000,key="q"},{time=18.667,key="0"},{time=20.000,key="8"},
    {time=20.333,key="8"},{time=20.667,key="9"},{time=21.333,key="8"},{time=22.000,key="w"},
    {time=22.667,key="q"},{time=24.000,key="t"},{time=24.333,key="t"},{time=24.667,key="u"},
    {time=25.333,key="p"},{time=26.000,key="i"},{time=26.667,key="u"},{time=27.333,key="y"},
    {time=28.000,key="E"},{time=28.333,key="E"},{time=28.667,key="p"},{time=29.333,key="i"},
    {time=30.000,key="o"},{time=30.667,key="i"},
}

-- ── カノン in D (Pachelbel BPM=72 / ~32s) ─────────────────────
local notes_canon = {
    {time=0.000,key="Q"},{time=0.006,key="2"},{time=0.833,key="0"},{time=1.667,key="9"},
    {time=1.673,key="6"},{time=2.500,key="*"},{time=3.333,key="7"},{time=3.339,key="7"},
    {time=4.167,key="6"},{time=5.000,key="7"},{time=5.006,key="$"},{time=5.833,key="*"},
    {time=6.667,key="9"},{time=6.673,key="5"},{time=7.500,key="*"},{time=8.333,key="7"},
    {time=8.339,key="2"},{time=9.167,key="6"},{time=10.000,key="5"},{time=10.006,key="5"},
    {time=10.833,key="6"},{time=11.667,key="6"},{time=11.673,key="5"},{time=12.500,key="4"},
    {time=13.333,key="3"},{time=13.339,key="2"},{time=13.750,key="4"},{time=14.167,key="5"},
    {time=14.583,key="4"},{time=15.000,key="6"},{time=15.006,key="3"},{time=15.417,key="2"},
    {time=15.833,key="3"},{time=16.250,key="4"},{time=16.667,key="7"},{time=16.673,key="5"},
    {time=17.083,key="3"},{time=17.500,key="4"},{time=17.917,key="5"},{time=18.333,key="6"},
    {time=18.339,key="$"},{time=18.750,key="4"},{time=19.167,key="5"},{time=19.583,key="6"},
    {time=20.000,key="7"},{time=20.006,key="5"},{time=20.417,key="6"},{time=20.833,key="7"},
    {time=21.250,key="r"},{time=21.667,key="e"},{time=21.673,key="2"},{time=22.083,key="r"},
    {time=22.500,key="7"},{time=22.917,key="e"},{time=23.333,key="w"},{time=23.339,key="5"},
    {time=23.750,key="e"},{time=24.167,key="w"},{time=24.583,key="0"},{time=25.000,key="9"},
    {time=25.006,key="6"},{time=25.417,key="0"},{time=25.833,key="9"},{time=26.250,key="*"},
}

-- ── エリーゼのために (Beethoven BPM=60 / ~30s) ─────────────────
local notes_furelise = {
    {time=0.000,key="0"},{time=0.500,key="("},{time=1.000,key="0"},{time=1.500,key="("},
    {time=2.000,key="0"},{time=2.500,key="7"},{time=3.000,key="9"},{time=3.500,key="8"},
    {time=4.000,key="6"},{time=6.000,key="1"},{time=6.500,key="3"},{time=7.000,key="6"},
    {time=8.000,key="5"},{time=8.500,key="3"},{time=9.000,key="6"},{time=9.500,key="0"},
    {time=10.000,key="0"},{time=12.000,key="0"},{time=12.500,key="("},{time=13.000,key="0"},
    {time=13.500,key="("},{time=14.000,key="0"},{time=14.500,key="7"},{time=15.000,key="9"},
    {time=15.500,key="8"},{time=16.000,key="6"},{time=18.000,key="1"},{time=18.500,key="3"},
    {time=19.000,key="6"},{time=20.000,key="5"},{time=20.500,key="3"},{time=21.000,key="4"},
    {time=21.500,key="3"},{time=22.000,key="2"},{time=24.000,key="3"},{time=25.000,key="$"},
    {time=26.000,key="6"},{time=26.500,key="7"},{time=27.000,key="8"},{time=28.000,key="5"},
    {time=29.000,key="Q"},{time=30.000,key="5"},{time=30.500,key="6"},{time=31.000,key="7"},
    {time=32.000,key="0"},{time=32.500,key="("},{time=33.000,key="0"},{time=33.500,key="("},
    {time=34.000,key="0"},{time=34.500,key="7"},{time=35.000,key="9"},{time=35.500,key="8"},
    {time=36.000,key="6"},{time=38.000,key="1"},{time=38.500,key="3"},{time=39.000,key="6"},
    {time=40.000,key="5"},{time=40.500,key="3"},{time=41.000,key="6"},{time=41.500,key="0"},
    {time=42.000,key="0"},
}

-- ── 夜に駆ける (YOASOBI BPM=130 / ~21s) ──────────────────────
local notes_yoru = {
    {time=0.000,key="e"},{time=0.231,key="e"},{time=0.462,key="r"},{time=0.692,key="e"},
    {time=0.923,key="w"},{time=1.615,key="e"},{time=1.846,key="w"},{time=2.077,key="0"},
    {time=2.308,key="w"},{time=2.538,key="0"},{time=2.769,key="w"},{time=3.692,key="e"},
    {time=3.923,key="e"},{time=4.154,key="r"},{time=4.385,key="e"},{time=4.615,key="0"},
    {time=5.308,key="9"},{time=5.538,key="0"},{time=5.769,key="9"},{time=6.000,key="8"},
    {time=6.231,key="9"},{time=6.462,key="8"},{time=7.385,key="0"},{time=7.615,key="w"},
    {time=7.846,key="e"},{time=8.077,key="w"},{time=8.308,key="e"},{time=8.769,key="0"},
    {time=9.000,key="w"},{time=9.231,key="e"},{time=9.462,key="r"},{time=9.692,key="e"},
    {time=9.923,key="w"},{time=10.154,key="0"},{time=10.846,key="9"},{time=11.077,key="0"},
    {time=11.308,key="w"},{time=11.538,key="e"},{time=11.769,key="w"},{time=12.000,key="q"},
    {time=12.462,key="w"},{time=12.692,key="0"},{time=12.923,key="9"},{time=13.154,key="8"},
    {time=13.385,key="9"},{time=13.615,key="0"},{time=13.846,key="9"},{time=14.769,key="e"},
    {time=15.000,key="r"},{time=15.231,key="e"},{time=15.462,key="r"},{time=16.154,key="e"},
    {time=16.385,key="r"},{time=16.615,key="t"},{time=16.846,key="r"},{time=17.077,key="e"},
    {time=17.308,key="r"},{time=17.538,key="e"},
}

-- ── Lemon (米津玄師 BPM=78 / ~22s) ────────────────────────────
local notes_lemon = {
    {time=0.000,key="*"},{time=0.769,key="7"},{time=1.154,key="6"},{time=1.538,key="$"},
    {time=2.692,key="6"},{time=3.077,key="$"},{time=3.462,key="%"},{time=3.846,key="$"},
    {time=4.231,key="*"},{time=4.615,key="*"},{time=6.154,key="0"},{time=6.538,key="*"},
    {time=6.923,key="7"},{time=7.308,key="6"},{time=7.692,key="$"},{time=8.846,key="6"},
    {time=9.231,key="$"},{time=9.615,key="%"},{time=10.000,key="W"},{time=10.385,key="%"},
    {time=10.769,key="$"},{time=12.308,key="Q"},{time=13.077,key="*"},{time=13.462,key="7"},
    {time=13.846,key="Q"},{time=14.615,key="W"},{time=15.000,key="Q"},{time=15.385,key="0"},
    {time=15.769,key="Q"},{time=16.154,key="*"},{time=16.538,key="7"},{time=16.923,key="$"},
    {time=18.462,key="Q"},{time=19.231,key="*"},{time=19.615,key="7"},{time=20.000,key="*"},
    {time=20.769,key="W"},{time=21.154,key="Q"},{time=21.538,key="*"},{time=21.923,key="7"},
    {time=22.308,key="6"},{time=22.692,key="7"},{time=23.077,key="$"},{time=24.615,key="W"},
    {time=25.000,key="Q"},{time=25.385,key="0"},{time=25.769,key="*"},{time=26.154,key="7"},
    {time=26.923,key="6"},{time=27.308,key="$"},{time=27.692,key="%"},{time=28.077,key="$"},
    {time=28.462,key="*"},{time=28.846,key="7"},{time=29.231,key="6"},{time=29.615,key="$"},
}

-- ── 紅蓮華 (LiSA / 鬼滅の刃 BPM=152 / ~20s) ──────────────────
local notes_red = {
    {time=0.000,key="9"},{time=0.197,key="9"},{time=0.395,key="0"},{time=0.592,key="Q"},
    {time=0.789,key="e"},{time=0.987,key="e"},{time=1.184,key="W"},{time=1.382,key="Q"},
    {time=1.579,key="0"},{time=1.776,key="9"},{time=1.974,key="*"},{time=2.171,key="7"},
    {time=2.368,key="6"},{time=3.158,key="9"},{time=3.355,key="9"},{time=3.553,key="0"},
    {time=3.750,key="Q"},{time=3.947,key="e"},{time=4.145,key="e"},{time=4.342,key="W"},
    {time=4.539,key="Q"},{time=4.737,key="0"},{time=4.934,key="9"},{time=5.132,key="7"},
    {time=5.329,key="6"},{time=5.526,key="$"},{time=6.316,key="e"},{time=6.513,key="W"},
    {time=6.711,key="Q"},{time=6.908,key="0"},{time=7.105,key="("},{time=7.303,key="0"},
    {time=7.500,key="Q"},{time=7.697,key="W"},{time=7.895,key="e"},{time=8.289,key="r"},
    {time=8.487,key="e"},{time=8.684,key="W"},{time=9.079,key="e"},{time=9.276,key="W"},
    {time=9.474,key="Q"},{time=9.671,key="0"},{time=9.868,key="("},{time=10.066,key="0"},
    {time=10.263,key="Q"},{time=10.461,key="W"},{time=10.658,key="e"},{time=10.855,key="W"},
    {time=11.053,key="Q"},{time=11.250,key="0"},{time=11.447,key="9"},{time=12.237,key="0"},
    {time=12.434,key="Q"},{time=12.632,key="e"},{time=12.829,key="W"},{time=13.026,key="e"},
    {time=13.224,key="Q"},{time=13.421,key="0"},{time=13.618,key="9"},{time=13.816,key="*"},
    {time=14.013,key="9"},{time=14.211,key="0"},{time=14.408,key="Q"},{time=14.605,key="e"},
    {time=15.197,key="9"},{time=15.395,key="9"},{time=15.592,key="0"},{time=15.789,key="Q"},
    {time=15.987,key="e"},{time=16.184,key="e"},{time=16.382,key="W"},{time=16.579,key="Q"},
    {time=16.776,key="0"},{time=16.974,key="9"},{time=17.171,key="*"},{time=17.368,key="7"},
    {time=17.566,key="6"},{time=18.355,key="Q"},{time=18.553,key="W"},{time=18.750,key="e"},
    {time=18.947,key="r"},{time=19.145,key="e"},{time=19.342,key="W"},{time=19.539,key="Q"},
    {time=19.737,key="0"},{time=19.934,key="9"},
}

-- ── 炎 (LiSA / 鬼滅の刃 BPM=95 / ~23s) ──────────────────────
local notes_homura = {
    {time=0.000,key="r"},{time=0.632,key="r"},{time=0.947,key="W"},{time=1.263,key="r"},
    {time=1.579,key="e"},{time=1.895,key="W"},{time=2.211,key="Q"},{time=2.526,key="0"},
    {time=2.842,key="Q"},{time=3.158,key="W"},{time=3.474,key="e"},{time=3.789,key="r"},
    {time=5.053,key="r"},{time=5.368,key="e"},{time=5.684,key="W"},{time=6.000,key="Q"},
    {time=6.316,key="0"},{time=6.632,key="("},{time=6.947,key="*"},{time=7.263,key="7"},
    {time=7.579,key="6"},{time=7.895,key="W"},{time=8.211,key="Q"},{time=8.526,key="0"},
    {time=8.842,key="Q"},{time=10.105,key="0"},{time=10.421,key="Q"},{time=10.737,key="W"},
    {time=11.053,key="e"},{time=11.368,key="r"},{time=11.684,key="e"},{time=12.000,key="W"},
    {time=12.316,key="Q"},{time=12.632,key="0"},{time=13.263,key="W"},{time=13.579,key="0"},
    {time=13.895,key="9"},{time=14.211,key="8"},{time=14.526,key="9"},{time=15.158,key="0"},
    {time=15.474,key="Q"},{time=15.789,key="W"},{time=16.105,key="e"},{time=16.421,key="r"},
    {time=16.737,key="e"},{time=17.053,key="W"},{time=17.368,key="Q"},{time=17.684,key="W"},
    {time=18.000,key="Q"},{time=18.316,key="0"},{time=18.632,key="("},{time=18.947,key="*"},
    {time=19.263,key="7"},{time=19.579,key="6"},{time=19.895,key="$"},{time=20.211,key="5"},
    {time=21.474,key="r"},{time=21.789,key="e"},{time=22.105,key="W"},{time=22.421,key="Q"},
    {time=22.737,key="0"},{time=23.053,key="Q"},{time=23.368,key="W"},{time=23.684,key="e"},
    {time=24.000,key="r"},
}

-- ── 残酷な天使のテーゼ (エヴァ BPM=128 / ~18s) ────────────────
local notes_eva = {
    {time=0.000,key="%"},{time=0.234,key="6"},{time=0.469,key="7"},{time=0.703,key="8"},
    {time=0.938,key="9"},{time=1.172,key="8"},{time=1.406,key="7"},{time=1.641,key="6"},
    {time=1.875,key="%"},{time=2.109,key="6"},{time=2.344,key="7"},{time=2.578,key="8"},
    {time=2.812,key="E"},{time=3.047,key="e"},{time=3.281,key="7"},{time=3.750,key="0"},
    {time=3.984,key="0"},{time=4.219,key="w"},{time=4.453,key="e"},{time=4.688,key="w"},
    {time=4.922,key="0"},{time=5.156,key="e"},{time=5.391,key="q"},{time=5.625,key="0"},
    {time=5.859,key="0"},{time=6.094,key="w"},{time=6.328,key="e"},{time=6.562,key="E"},
    {time=6.797,key="e"},{time=7.031,key="w"},{time=7.266,key="q"},{time=7.500,key="0"},
    {time=7.734,key="9"},{time=7.969,key="8"},{time=8.203,key="7"},{time=8.438,key="6"},
    {time=8.906,key="%"},{time=9.141,key="6"},{time=9.375,key="7"},{time=9.609,key="8"},
    {time=9.844,key="9"},{time=10.078,key="0"},{time=10.312,key="q"},{time=10.781,key="0"},
    {time=11.016,key="q"},{time=11.250,key="w"},{time=11.484,key="e"},{time=11.719,key="r"},
    {time=11.953,key="e"},{time=12.188,key="w"},{time=12.422,key="0"},{time=12.656,key="e"},
    {time=13.125,key="w"},{time=13.359,key="e"},{time=13.594,key="w"},{time=13.828,key="0"},
    {time=14.062,key="9"},{time=14.766,key="9"},{time=15.000,key="0"},{time=15.234,key="q"},
    {time=15.469,key="w"},{time=15.703,key="e"},{time=15.938,key="w"},{time=16.172,key="q"},
    {time=16.406,key="0"},{time=16.641,key="9"},{time=16.875,key="8"},{time=17.109,key="9"},
    {time=17.344,key="0"},{time=17.578,key="q"},{time=18.281,key="q"},{time=18.516,key="w"},
    {time=18.750,key="e"},{time=18.984,key="r"},{time=19.219,key="e"},{time=19.453,key="w"},
    {time=19.688,key="e"},{time=19.922,key="w"},{time=20.156,key="q"},{time=20.391,key="0"},
}

-- ── ミックスナッツ (SPY×FAMILY BPM=118 / ~19s) ─────────────────
local notes_mix = {
    {time=0.000,key="q"},{time=0.254,key="w"},{time=0.508,key="E"},{time=0.763,key="e"},
    {time=1.017,key="w"},{time=1.271,key="q"},{time=1.525,key="0"},{time=1.780,key="9"},
    {time=2.034,key="8"},{time=2.288,key="9"},{time=2.542,key="0"},{time=2.797,key="q"},
    {time=3.051,key="w"},{time=4.068,key="q"},{time=4.322,key="w"},{time=4.576,key="E"},
    {time=4.831,key="e"},{time=5.085,key="r"},{time=5.339,key="e"},{time=5.593,key="w"},
    {time=5.847,key="q"},{time=6.102,key="0"},{time=6.356,key="9"},{time=6.610,key="8"},
    {time=6.864,key="9"},{time=7.119,key="0"},{time=8.136,key="0"},{time=8.390,key="q"},
    {time=8.644,key="w"},{time=8.898,key="e"},{time=9.153,key="w"},{time=9.407,key="0"},
    {time=9.661,key="q"},{time=9.915,key="w"},{time=10.169,key="e"},{time=10.424,key="r"},
    {time=10.678,key="e"},{time=10.932,key="w"},{time=11.186,key="e"},{time=12.203,key="e"},
    {time=12.458,key="w"},{time=12.712,key="q"},{time=12.966,key="0"},{time=13.220,key="w"},
    {time=13.475,key="e"},{time=13.729,key="r"},{time=13.983,key="e"},{time=14.237,key="w"},
    {time=14.492,key="e"},{time=14.746,key="w"},{time=15.000,key="q"},{time=15.254,key="0"},
    {time=15.763,key="9"},{time=16.017,key="8"},{time=16.271,key="9"},{time=16.525,key="0"},
    {time=16.780,key="q"},{time=17.034,key="w"},{time=17.288,key="e"},
}

-- ── 青と夏 (Mrs. GREEN APPLE BPM=152 / ~18s) ──────────────────
local notes_ao = {
    {time=0.000,key="e"},{time=0.197,key="r"},{time=0.395,key="*"},{time=0.592,key="e"},
    {time=0.789,key="0"},{time=1.382,key="e"},{time=1.579,key="0"},{time=1.776,key="*"},
    {time=1.974,key="7"},{time=2.171,key="6"},{time=2.368,key="%"},{time=3.158,key="e"},
    {time=3.355,key="r"},{time=3.553,key="e"},{time=3.750,key="0"},{time=3.947,key="*"},
    {time=4.539,key="7"},{time=4.737,key="*"},{time=4.934,key="7"},{time=5.132,key="6"},
    {time=5.329,key="$"},{time=5.526,key="%"},{time=6.316,key="e"},{time=6.513,key="e"},
    {time=6.711,key="r"},{time=6.908,key="e"},{time=7.105,key="0"},{time=7.303,key="*"},
    {time=7.500,key="0"},{time=7.697,key="e"},{time=7.895,key="W"},{time=8.092,key="e"},
    {time=8.289,key="0"},{time=8.487,key="*"},{time=8.684,key="7"},{time=8.882,key="6"},
    {time=9.079,key="$"},{time=9.276,key="%"},{time=9.474,key="e"},{time=9.671,key="e"},
    {time=9.868,key="r"},{time=10.066,key="e"},{time=10.263,key="0"},{time=10.461,key="*"},
    {time=10.658,key="r"},{time=10.855,key="e"},{time=11.053,key="0"},{time=11.250,key="*"},
    {time=11.447,key="7"},{time=11.645,key="6"},{time=11.842,key="%"},{time=12.632,key="*"},
    {time=12.829,key="7"},{time=13.026,key="6"},{time=13.224,key="$"},{time=13.421,key="6"},
    {time=13.618,key="$"},{time=13.816,key="%"},{time=14.013,key="6"},{time=14.211,key="e"},
    {time=15.000,key="e"},{time=15.197,key="r"},{time=15.395,key="*"},{time=15.592,key="e"},
    {time=15.789,key="r"},{time=15.987,key="e"},{time=16.184,key="0"},{time=16.382,key="*"},
    {time=16.579,key="7"},{time=16.776,key="6"},{time=16.974,key="$"},{time=17.171,key="%"},
    {time=17.368,key="e"},
}

-- ── 廻廻奇譚 (Eve / 呪術廻戦 BPM=138 / ~19s) ─────────────────
local notes_kai = {
    {time=0.000,key="0"},{time=0.217,key="q"},{time=0.435,key="w"},{time=0.652,key="e"},
    {time=0.870,key="w"},{time=1.087,key="q"},{time=1.304,key="0"},{time=1.522,key="9"},
    {time=1.739,key="8"},{time=1.957,key="9"},{time=2.174,key="0"},{time=2.391,key="q"},
    {time=2.609,key="w"},{time=3.478,key="0"},{time=3.696,key="q"},{time=3.913,key="w"},
    {time=4.130,key="e"},{time=4.348,key="r"},{time=4.565,key="e"},{time=4.783,key="w"},
    {time=5.000,key="q"},{time=5.217,key="Q"},{time=5.435,key="q"},{time=5.652,key="0"},
    {time=5.870,key="9"},{time=6.087,key="0"},{time=6.957,key="e"},{time=7.174,key="e"},
    {time=7.391,key="r"},{time=7.609,key="e"},{time=7.826,key="w"},{time=8.043,key="e"},
    {time=8.261,key="r"},{time=8.478,key="e"},{time=8.696,key="w"},{time=9.130,key="q"},
    {time=9.348,key="0"},{time=9.565,key="9"},{time=9.783,key="0"},{time=10.000,key="q"},
    {time=10.435,key="e"},{time=10.652,key="e"},{time=10.870,key="r"},{time=11.087,key="e"},
    {time=11.304,key="t"},{time=11.522,key="r"},{time=11.739,key="e"},{time=11.957,key="w"},
    {time=12.174,key="q"},{time=12.391,key="0"},{time=12.609,key="9"},{time=12.826,key="8"},
    {time=13.043,key="9"},{time=13.261,key="0"},{time=13.478,key="e"},{time=13.913,key="r"},
    {time=14.130,key="e"},{time=14.348,key="w"},{time=14.565,key="0"},{time=14.783,key="9"},
    {time=15.000,key="8"},{time=15.217,key="9"},{time=15.435,key="0"},{time=15.652,key="e"},
}

-- ═══════════════════════════════════════════════════════════════
--  Rayfield UI
-- ═══════════════════════════════════════════════════════════════
local Win = Rayfield:CreateWindow({
    Name            = "🎸 Piano Player v2 — 15曲収録",
    LoadingTitle    = "Piano Player v2",
    LoadingSubtitle = "Libra Heart 1&2 + 13曲",
    ConfigurationSaving = { Enabled = false },
    Discord         = { Enabled = false },
    KeySystem       = false,
})

-- ── 🎸 Libra Heart タブ ──────────────────────────────────────
local LT = Win:CreateTab("🎸 Libra Heart", 4483345998)

LT:CreateSection("Libra Heart 2 (NEW!)")

LT:CreateButton({
    Name="▶  Libra Heart 2 — Full (~27s)",
    Callback=function() playSong(notes_libra2,"Libra Heart 2") end,
})
LT:CreateButton({
    Name="▶  Libra Heart 2 — Melody Only",
    Callback=function() playSong(melodyOnly(notes_libra2),"Libra Heart 2 [MELODY]") end,
})

LT:CreateParagraph({
    Title="🎸 Libra Heart 2 — 構成",
    Content=
        "右手 (3サイクル × 9秒 = 27秒)\n"..
        "  Pattern1 (5s): F#5 F5 C#5 C#5 B5 Bb5 G#5 Bb5 G#5 F#5\n"..
        "  Pattern2 (3.5s): F#5 F5 C#5 F#5 G#5 F#5\n\n"..
        "左手 (4パターン × 6.75秒 = 27秒)\n"..
        "  ① Eb4 Bb4 C#4 Bb4\n"..
        "  ② B4 F#4 B4 F#4\n"..
        "  ③ C#4 G#4 C#4 G#4\n"..
        "  ④ F#4 C#4 F4 C#4",
})

LT:CreateSection("Libra Heart 1 (オリジナル)")

LT:CreateButton({ Name="▶  Full Play (~225s)",        Callback=function() playSong(notes_libra1,"Libra Heart") end })
LT:CreateButton({ Name="▶  Part 1 [0-63s]",           Callback=function()
    local p={} for _,n in ipairs(notes_libra1) do if n.time<=63 then p[#p+1]=n end end
    playSong(p,"Libra Heart [P1]") end })
LT:CreateButton({ Name="▶  Part 2 [63-120s]",         Callback=function()
    local p={} for _,n in ipairs(notes_libra1) do if n.time>=63 and n.time<=120 then p[#p+1]={time=n.time-63,key=n.key} end end
    playSong(p,"Libra Heart [P2]") end })
LT:CreateButton({ Name="▶  FINALE [180-225s]",        Callback=function()
    local p={} for _,n in ipairs(notes_libra1) do if n.time>=180 then p[#p+1]={time=n.time-180,key=n.key} end end
    playSong(p,"Libra Heart [FINALE]") end })
LT:CreateButton({ Name="▶  Melody Only — Full",       Callback=function() playSong(melodyOnly(notes_libra1),"LH1 [MELODY]") end })

-- ── 🎵 童謡・クラシック タブ ─────────────────────────────────
local KT = Win:CreateTab("🎵 童謡/Classic", 4483345998)

KT:CreateSection("童謡 (15秒以上)")
KT:CreateButton({ Name="▶  きらきら星 (~46s / 4verse)",  Callback=function() playSong(notes_twinkle,"きらきら星") end })
KT:CreateButton({ Name="▶  歓喜の歌 Ode to Joy (~38s)",  Callback=function() playSong(notes_ode,"歓喜の歌") end })
KT:CreateButton({ Name="▶  Happy Birthday (~26s)",        Callback=function() playSong(notes_birthday,"Happy Birthday") end })

KT:CreateSection("クラシック")
KT:CreateButton({ Name="▶  カノン in D — Pachelbel (~32s)",    Callback=function() playSong(notes_canon,"カノン in D") end })
KT:CreateButton({ Name="▶  エリーゼのために — Beethoven (~30s)", Callback=function() playSong(notes_furelise,"エリーゼのために") end })

-- ── 🎤 J-Pop/アニメ タブ ─────────────────────────────────────
local JT = Win:CreateTab("🎤 J-Pop/Anime", 4483345998)

JT:CreateSection("J-Pop")
JT:CreateButton({ Name="▶  夜に駆ける — YOASOBI (~21s)",        Callback=function() playSong(notes_yoru,"夜に駆ける") end })
JT:CreateButton({ Name="▶  Lemon — 米津玄師 (~22s)",            Callback=function() playSong(notes_lemon,"Lemon") end })
JT:CreateButton({ Name="▶  青と夏 — Mrs.GREEN APPLE (~18s)",    Callback=function() playSong(notes_ao,"青と夏") end })

JT:CreateSection("アニメ")
JT:CreateButton({ Name="▶  紅蓮華 — LiSA / 鬼滅の刃 (~20s)",   Callback=function() playSong(notes_red,"紅蓮華") end })
JT:CreateButton({ Name="▶  炎 — LiSA / 鬼滅の刃 (~23s)",       Callback=function() playSong(notes_homura,"炎") end })
JT:CreateButton({ Name="▶  残酷な天使のテーゼ — EVA (~18s)",    Callback=function() playSong(notes_eva,"残酷な天使のテーゼ") end })
JT:CreateButton({ Name="▶  ミックスナッツ — SPY×FAMILY (~19s)",  Callback=function() playSong(notes_mix,"ミックスナッツ") end })
JT:CreateButton({ Name="▶  廻廻奇譚 — Eve / 呪術廻戦 (~19s)",   Callback=function() playSong(notes_kai,"廻廻奇譚") end })

-- ── ⚡ Speed タブ ─────────────────────────────────────────────
local ST = Win:CreateTab("⚡ Speed", 4483345998)
ST:CreateSection("再生速度")
ST:CreateButton({ Name="🐢  0.75x スロー",          Callback=function() setSpeed(0.75) end })
ST:CreateButton({ Name="▶   1.0x  通常 (デフォルト)",Callback=function() setSpeed(1.0)  end })
ST:CreateButton({ Name="⚡  1.25x やや速め",         Callback=function() setSpeed(1.25) end })
ST:CreateButton({ Name="⚡⚡ 1.5x  速め",            Callback=function() setSpeed(1.5)  end })
ST:CreateButton({ Name="🚀  2.0x  2倍速",           Callback=function() setSpeed(2.0)  end })
ST:CreateParagraph({
    Title="Speed の使い方",
    Content=
        "先にSpeedを設定してから演奏ボタンを押す\n"..
        "🐢 0.75x = 練習・確認用\n"..
        "▶  1.0x  = 通常 (デフォルト)\n"..
        "🚀 2.0x  = 早回しで確認",
})

-- ── ⚙ Setup タブ ─────────────────────────────────────────────
local SetT = Win:CreateTab("⚙ Setup", 4483345998)
SetT:CreateSection("ピアノ準備")
SetT:CreateButton({ Name="🎹  ピアノ出現 & 着席", Callback=function() task.spawn(setupPiano) end })
SetT:CreateParagraph({
    Title="キーマッピング早見表",
    Content=
        "白鍵: 1=C4 2=D4 3=E4 4=F4 5=G4 6=A4 7=B4\n"..
        "      8=C5 9=D5 0=E5 q=F5 w=G5 e=A5 r=B5\n"..
        "      t=C6 y=D6 u=E6 i=F6 o=G6 p=A6 a=B6\n"..
        "黒鍵: !=C#4 @=D#4 $=F#4 %=G#4 ^=A#4\n"..
        "      *=C#5 (=D#5 Q=F#5 W=G#5 E=A#5\n"..
        "      T=C#6 Y=D#6 I=F#6 O=G#6 P=A#6",
})

-- ── ⏹ Control タブ ───────────────────────────────────────────
local CT = Win:CreateTab("⏹ Control", 4483345998)
CT:CreateSection("再生コントロール")
CT:CreateButton({ Name="⏹  演奏を停止する", Callback=function() stopSong() end })
CT:CreateButton({
    Name="📊  状態確認",
    Callback=function()
        if isPlaying then
            Rayfield:Notify({Title="📊 再生中",Content="♪ "..currentSong.."\nSpeed: "..speedMult.."x",Duration=2,Image="rbxassetid://4483345998"})
        else
            Rayfield:Notify({Title="📊 待機中",Content="Speed: "..speedMult.."x",Duration=2,Image="rbxassetid://4483345998"})
        end
    end,
})
CT:CreateParagraph({
    Title="注意事項",
    Content=
        "・演奏中はRobloxの画面にフォーカスを当てること\n"..
        "・黒鍵は自動でShiftキー処理\n"..
        "・和音は最高音(メロディ)が先に発火\n"..
        "・Melody Only: 同時刻の最高音のみ演奏\n"..
        "・Speed変更は次の演奏から反映",
})
