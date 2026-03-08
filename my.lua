-- ==============================================================
--   🎸 Piano Player v3  [15曲収録]
--   Virtual Piano Player  ―  Rayfield UI
--   Libra Heart データ: basic_pitch_transcription__2_.mid より変換
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
--  ノーツデータ (Libra Heart: MIDIファイルより変換)
-- ═══════════════════════════════════════════════════════════════

-- ── Libra Heart 2 [181ノーツ / 0〜27s]
local notes_libra2 = {
    {time=0.000,key="^"},{time=0.011,key="@"},{time=0.045,key="Q"},{time=0.208,key="i"},
    {time=0.266,key="^"},{time=0.370,key="q"},{time=0.510,key="@"},{time=0.521,key="*"},
    {time=0.521,key="!"},{time=0.696,key="@"},{time=0.765,key="*"},{time=0.765,key="!"},
    {time=1.009,key="7"},{time=1.277,key="$"},{time=1.532,key="7"},{time=1.731,key="r"},
    {time=1.998,key="q"},{time=1.998,key="!"},{time=2.241,key="*"},{time=2.253,key="%"},
    {time=2.508,key="!"},{time=2.729,key="E"},{time=2.764,key="4"},{time=3.008,key="$"},
    {time=3.146,key="!"},{time=3.159,key="W"},{time=3.495,key="Q"},{time=3.495,key="*"},
    {time=3.507,key="4"},{time=3.518,key="4"},{time=3.995,key="@"},{time=4.077,key="Q"},
    {time=4.263,key="^"},{time=4.275,key="q"},{time=4.518,key="!"},{time=5.006,key="7"},
    {time=5.261,key="$"},{time=5.493,key="E"},{time=5.505,key="7"},{time=5.507,key="7"},
    {time=6.006,key="I"},{time=6.006,key="!"},{time=6.121,key="Q"},{time=6.261,key="%"},
    {time=6.354,key="W"},{time=6.516,key="*"},{time=6.516,key="!"},{time=6.760,key="4"},
    {time=6.981,key="^"},{time=6.992,key="$"},{time=7.004,key="$"},{time=7.015,key="Q"},
    {time=7.015,key="$"},{time=7.028,key="I"},{time=7.505,key="W"},{time=7.505,key="Q"},
    {time=7.505,key="4"},{time=7.516,key="4"},{time=8.004,key="Q"},{time=8.004,key="^"},
    {time=8.004,key="@"},{time=8.259,key="^"},{time=8.514,key="!"},{time=8.665,key="@"},
    {time=9.003,key="7"},{time=9.014,key="7"},{time=9.269,key="$"},{time=9.491,key="E"},
    {time=9.491,key="$"},{time=9.491,key="7"},{time=9.514,key="7"},{time=9.735,key="r"},
    {time=9.735,key="7"},{time=9.816,key="$"},{time=10.002,key="q"},{time=10.002,key="!"},
    {time=10.245,key="!"},{time=10.245,key="%"},{time=10.269,key="!"},{time=10.304,key="*"},
    {time=10.502,key="*"},{time=10.502,key="!"},{time=10.513,key="!"},{time=11.012,key="$"},
    {time=11.024,key="$"},{time=11.256,key="W"},{time=11.489,key="Q"},{time=11.501,key="4"},
    {time=11.512,key="4"},{time=11.744,key="*"},{time=11.768,key="W"},{time=11.780,key="4"},
    {time=11.977,key="@"},{time=11.988,key="^"},{time=12.001,key="Q"},{time=12.186,key="q"},
    {time=12.256,key="^"},{time=12.523,key="!"},{time=12.732,key="!"},{time=12.755,key="^"},
    {time=12.778,key="Q"},{time=13.010,key="7"},{time=13.068,key="@"},{time=13.254,key="7"},
    {time=13.265,key="$"},{time=13.476,key="7"},{time=13.487,key="E"},{time=13.500,key="Q"},
    {time=13.500,key="7"},{time=13.500,key="$"},{time=13.836,key="7"},{time=14.010,key="^"},
    {time=14.010,key="!"},{time=14.335,key="^"},{time=14.358,key="!"},{time=14.498,key="7"},
    {time=14.509,key="!"},{time=14.764,key="Q"},{time=14.764,key="7"},{time=14.858,key="!"},
    {time=14.996,key="$"},{time=15.009,key="$"},{time=15.020,key="Q"},{time=15.136,key="$"},
    {time=15.159,key="!"},{time=15.183,key="^"},{time=15.357,key="$"},{time=15.509,key="!"},
    {time=15.520,key="4"},{time=15.764,key="$"},{time=16.008,key="$"},{time=16.101,key="!"},
    {time=16.775,key="%"},{time=17.018,key="7"},{time=17.030,key="7"},{time=17.053,key="$"},
    {time=17.658,key="("},{time=17.716,key="@"},{time=18.030,key="!"},{time=18.100,key="!"},
    {time=18.343,key="%"},{time=18.470,key="!"},{time=18.506,key="!"},{time=19.039,key="$"},
    {time=19.109,key="^"},{time=19.260,key="$"},{time=19.470,key="%"},{time=19.726,key="4"},
    {time=19.993,key="$"},{time=20.039,key="!"},{time=20.794,key="^"},{time=21.027,key="^"},
    {time=21.027,key="7"},{time=21.538,key="@"},{time=21.538,key="7"},{time=21.562,key="$"},
    {time=22.026,key="^"},{time=22.084,key="!"},{time=22.235,key="!"},{time=22.375,key="4"},
    {time=22.375,key="!"},{time=22.375,key="^"},{time=22.723,key="%"},{time=23.025,key="^"},
    {time=23.094,key="$"},{time=23.490,key="%"},{time=23.502,key="7"},{time=23.583,key="4"},
    {time=24.025,key="^"},{time=24.395,key="^"},{time=25.011,key="7"},{time=25.045,key="7"},
    {time=25.266,key="$"},{time=25.558,key="^"},{time=25.779,key="7"},{time=26.104,key="!"},
    {time=26.336,key="$"},{time=26.406,key="!"},{time=26.440,key="!"},{time=26.487,key="!"},
    {time=26.998,key="^"}
}

-- ── Libra Heart 1 [1240ノーツ / 0〜222.8s]
local notes_libra1 = {
    {time=0.000,key="^"},{time=0.011,key="@"},{time=0.045,key="Q"},{time=0.208,key="i"},
    {time=0.266,key="^"},{time=0.370,key="q"},{time=0.510,key="@"},{time=0.521,key="*"},
    {time=0.521,key="!"},{time=0.696,key="@"},{time=0.765,key="*"},{time=0.765,key="!"},
    {time=1.009,key="7"},{time=1.277,key="$"},{time=1.532,key="7"},{time=1.731,key="r"},
    {time=1.998,key="q"},{time=1.998,key="!"},{time=2.241,key="*"},{time=2.253,key="%"},
    {time=2.508,key="!"},{time=2.729,key="E"},{time=2.764,key="4"},{time=3.008,key="$"},
    {time=3.146,key="!"},{time=3.159,key="W"},{time=3.495,key="Q"},{time=3.495,key="*"},
    {time=3.507,key="4"},{time=3.518,key="4"},{time=3.995,key="@"},{time=4.077,key="Q"},
    {time=4.263,key="^"},{time=4.275,key="q"},{time=4.518,key="!"},{time=5.006,key="7"},
    {time=5.261,key="$"},{time=5.493,key="E"},{time=5.505,key="7"},{time=5.507,key="7"},
    {time=6.006,key="I"},{time=6.006,key="!"},{time=6.121,key="Q"},{time=6.261,key="%"},
    {time=6.354,key="W"},{time=6.516,key="*"},{time=6.516,key="!"},{time=6.760,key="4"},
    {time=6.981,key="^"},{time=6.992,key="$"},{time=7.004,key="$"},{time=7.015,key="Q"},
    {time=7.015,key="$"},{time=7.028,key="I"},{time=7.505,key="W"},{time=7.505,key="Q"},
    {time=7.505,key="4"},{time=7.516,key="4"},{time=8.004,key="Q"},{time=8.004,key="^"},
    {time=8.004,key="@"},{time=8.259,key="^"},{time=8.514,key="!"},{time=8.665,key="@"},
    {time=9.003,key="7"},{time=9.014,key="7"},{time=9.269,key="$"},{time=9.491,key="E"},
    {time=9.491,key="$"},{time=9.491,key="7"},{time=9.514,key="7"},{time=9.735,key="r"},
    {time=9.735,key="7"},{time=9.816,key="$"},{time=10.002,key="q"},{time=10.002,key="!"},
    {time=10.245,key="!"},{time=10.245,key="%"},{time=10.269,key="!"},{time=10.304,key="*"},
    {time=10.502,key="*"},{time=10.502,key="!"},{time=10.513,key="!"},{time=11.012,key="$"},
    {time=11.024,key="$"},{time=11.256,key="W"},{time=11.489,key="Q"},{time=11.501,key="4"},
    {time=11.512,key="4"},{time=11.744,key="*"},{time=11.768,key="W"},{time=11.780,key="4"},
    {time=11.977,key="@"},{time=11.988,key="^"},{time=12.001,key="Q"},{time=12.186,key="q"},
    {time=12.256,key="^"},{time=12.523,key="!"},{time=12.732,key="!"},{time=12.755,key="^"},
    {time=12.778,key="Q"},{time=13.010,key="7"},{time=13.068,key="@"},{time=13.254,key="7"},
    {time=13.265,key="$"},{time=13.476,key="7"},{time=13.487,key="E"},{time=13.500,key="Q"},
    {time=13.500,key="7"},{time=13.500,key="$"},{time=13.836,key="7"},{time=14.010,key="^"},
    {time=14.010,key="!"},{time=14.335,key="^"},{time=14.358,key="!"},{time=14.498,key="7"},
    {time=14.509,key="!"},{time=14.764,key="Q"},{time=14.764,key="7"},{time=14.858,key="!"},
    {time=14.996,key="$"},{time=15.009,key="$"},{time=15.020,key="Q"},{time=15.136,key="$"},
    {time=15.159,key="!"},{time=15.183,key="^"},{time=15.357,key="$"},{time=15.509,key="!"},
    {time=15.520,key="4"},{time=15.764,key="$"},{time=16.008,key="$"},{time=16.101,key="!"},
    {time=16.775,key="%"},{time=17.018,key="7"},{time=17.030,key="7"},{time=17.053,key="$"},
    {time=17.658,key="("},{time=17.716,key="@"},{time=18.030,key="!"},{time=18.100,key="!"},
    {time=18.343,key="%"},{time=18.470,key="!"},{time=18.506,key="!"},{time=19.039,key="$"},
    {time=19.109,key="^"},{time=19.260,key="$"},{time=19.470,key="%"},{time=19.726,key="4"},
    {time=19.993,key="$"},{time=20.039,key="!"},{time=20.794,key="^"},{time=21.027,key="^"},
    {time=21.027,key="7"},{time=21.538,key="@"},{time=21.538,key="7"},{time=21.562,key="$"},
    {time=22.026,key="^"},{time=22.084,key="!"},{time=22.235,key="!"},{time=22.375,key="4"},
    {time=22.375,key="!"},{time=22.375,key="^"},{time=22.723,key="%"},{time=23.025,key="^"},
    {time=23.094,key="$"},{time=23.490,key="%"},{time=23.502,key="7"},{time=23.583,key="4"},
    {time=24.025,key="^"},{time=24.395,key="^"},{time=25.011,key="7"},{time=25.045,key="7"},
    {time=25.266,key="$"},{time=25.558,key="^"},{time=25.779,key="7"},{time=26.104,key="!"},
    {time=26.336,key="$"},{time=26.406,key="!"},{time=26.440,key="!"},{time=26.487,key="!"},
    {time=26.998,key="^"},{time=27.009,key="$"},{time=27.044,key="$"},{time=27.499,key="%"},
    {time=27.765,key="$"},{time=28.056,key="^"},{time=28.090,key="$"},{time=28.496,key="^"},
    {time=28.764,key="^"},{time=29.019,key="7"},{time=29.566,key="$"},{time=29.752,key="7"},
    {time=30.228,key="!"},{time=30.344,key="$"},{time=30.507,key="!"},{time=31.006,key="$"},
    {time=31.993,key="@"},{time=32.087,key="$"},{time=32.377,key="^"},{time=32.435,key="!"},
    {time=32.771,key="%"},{time=32.794,key="@"},{time=33.004,key="$"},{time=33.015,key="7"},
    {time=33.655,key="@"},{time=33.981,key="!"},{time=34.096,key="!"},{time=34.236,key="!"},
    {time=34.363,key="@"},{time=34.376,key="!"},{time=34.410,key="%"},{time=34.769,key="^"},
    {time=34.793,key="4"},{time=35.049,key="^"},{time=35.223,key="4"},{time=35.573,key="%"},
    {time=35.990,key="$"},{time=36.780,key="@"},{time=36.791,key="^"},{time=37.012,key="^"},
    {time=37.582,key="$"},{time=37.652,key="7"},{time=38.000,key="4"},{time=38.000,key="^"},
    {time=38.058,key="!"},{time=38.232,key="!"},{time=38.349,key="$"},{time=38.755,key="%"},
    {time=39.033,key="^"},{time=39.511,key="%"},{time=39.580,key="4"},{time=39.592,key="7"},
    {time=40.021,key="@"},{time=40.033,key="^"},{time=40.381,key="^"},{time=40.520,key="!"},
    {time=40.764,key="^"},{time=41.055,key="^"},{time=41.509,key="^"},{time=41.741,key="7"},
    {time=41.996,key="^"},{time=42.066,key="!"},{time=42.275,key="!"},{time=42.380,key="4"},
    {time=42.531,key="!"},{time=42.542,key="!"},{time=43.018,key="$"},{time=43.053,key="^"},
    {time=43.286,key="$"},{time=43.495,key="%"},{time=43.762,key="$"},{time=44.100,key="^"},
    {time=44.250,key="@"},{time=44.493,key="^"},{time=45.575,key="$"},{time=45.772,key="7"},
    {time=46.062,key="!"},{time=46.260,key="!"},{time=46.353,key="$"},{time=46.515,key="!"},
    {time=46.806,key="%"},{time=46.991,key="$"},{time=47.236,key="@"},{time=47.596,key="4"},
    {time=48.014,key="$"},{time=48.049,key="@"},{time=48.258,key="^"},{time=48.409,key="^"},
    {time=48.513,key="4"},{time=48.525,key="!"},{time=48.653,key="@"},{time=48.804,key="@"},
    {time=49.047,key="!"},{time=49.106,key="7"},{time=49.258,key="$"},{time=49.397,key="!"},
    {time=49.502,key="7"},{time=49.757,key="@"},{time=50.001,key="!"},{time=50.175,key="!"},
    {time=50.256,key="%"},{time=50.431,key="%"},{time=50.454,key="%"},{time=50.524,key="!"},
    {time=50.790,key="^"},{time=50.988,key="^"},{time=51.011,key="$"},{time=51.314,key="7"},
    {time=51.500,key="4"},{time=51.511,key="4"},{time=51.522,key="@"},{time=51.767,key="4"},
    {time=52.022,key="@"},{time=52.034,key="$"},{time=52.266,key="^"},{time=52.499,key="!"},
    {time=52.788,key="$"},{time=52.951,key="$"},{time=52.986,key="7"},{time=53.126,key="%"},
    {time=53.382,key="$"},{time=53.486,key="7"},{time=53.510,key="7"},{time=53.754,key="%"},
    {time=54.020,key="!"},{time=54.032,key="%"},{time=54.160,key="^"},{time=54.368,key="%"},
    {time=54.519,key="!"},{time=54.578,key="%"},{time=54.763,key="$"},{time=55.519,key="4"},
    {time=55.752,key="4"},{time=56.007,key="$"},{time=56.135,key="@"},{time=56.518,key="!"},
    {time=56.774,key="4"},{time=57.017,key="@"},{time=57.040,key="7"},{time=57.564,key="$"},
    {time=57.750,key="@"},{time=58.156,key="!"},{time=58.318,key="!"},{time=58.516,key="!"},
    {time=58.771,key="7"},{time=59.027,key="$"},{time=59.051,key="$"},{time=59.504,key="@"},
    {time=59.736,key="4"},{time=60.004,key="$"},{time=60.781,key="$"},{time=60.990,key="%"},
    {time=61.013,key="7"},{time=61.375,key="$"},{time=61.549,key="7"},{time=61.746,key="%"},
    {time=62.083,key="!"},{time=62.164,key="^"},{time=62.245,key="!"},{time=62.396,key="!"},
    {time=62.419,key="%"},{time=62.710,key="$"},{time=63.069,key="$"},{time=63.338,key="^"},
    {time=63.501,key="^"},{time=63.756,key="7"},{time=64.000,key="@"},{time=64.011,key="^"},
    {time=64.302,key="^"},{time=64.511,key="!"},{time=64.523,key="^"},{time=65.010,key="7"},
    {time=65.044,key="7"},{time=65.290,key="$"},{time=65.568,key="^"},{time=65.999,key="!"},
    {time=66.091,key="!"},{time=66.242,key="!"},{time=66.369,key="$"},{time=66.381,key="!"},
    {time=66.520,key="!"},{time=66.753,key="%"},{time=67.043,key="^"},{time=67.241,key="$"},
    {time=67.392,key="^"},{time=67.543,key="4"},{time=68.042,key="^"},{time=68.310,key="$"},
    {time=68.809,key="$"},{time=68.994,key="7"},{time=69.530,key="^"},{time=70.076,key="^"},
    {time=70.076,key="!"},{time=70.342,key="!"},{time=70.389,key="!"},{time=70.667,key="$"},
    {time=70.854,key="%"},{time=71.039,key="$"},{time=71.516,key="^"},{time=71.760,key="7"},
    {time=72.051,key="@"},{time=72.353,key="^"},{time=72.642,key="^"},{time=73.014,key="7"},
    {time=73.259,key="$"},{time=73.503,key="^"},{time=73.759,key="7"},{time=73.816,key="@"},
    {time=74.014,key="!"},{time=74.049,key="!"},{time=74.224,key="!"},{time=74.351,key="^"},
    {time=74.374,key="4"},{time=74.513,key="!"},{time=75.012,key="$"},{time=75.025,key="^"},
    {time=75.025,key="$"},{time=75.571,key="^"},{time=75.745,key="7"},{time=75.768,key="4"},
    {time=76.221,key="$"},{time=76.303,key="^"},{time=76.500,key="$"},{time=76.732,key="7"},
    {time=77.011,key="7"},{time=77.233,key="7"},{time=77.523,key="^"},{time=77.558,key="$"},
    {time=77.592,key="@"},{time=77.755,key="7"},{time=77.999,key="!"},{time=78.068,key="!"},
    {time=78.254,key="!"},{time=78.301,key="%"},{time=78.429,key="!"},{time=78.580,key="!"},
    {time=78.591,key="%"},{time=78.846,key="$"},{time=78.881,key="^"},{time=79.486,key="4"},
    {time=79.707,key="%"},{time=80.009,key="$"},{time=80.020,key="^"},{time=80.020,key="@"},
    {time=80.264,key="^"},{time=80.508,key="!"},{time=80.984,key="7"},{time=81.043,key="7"},
    {time=81.113,key="E"},{time=81.125,key="@"},{time=81.264,key="$"},{time=81.508,key="7"},
    {time=81.740,key="r"},{time=81.995,key="E"},{time=82.007,key="!"},{time=82.239,key="*"},
    {time=82.251,key="%"},{time=82.494,key="!"},{time=82.506,key="*"},{time=82.506,key="!"},
    {time=82.750,key="E"},{time=82.774,key="4"},{time=83.007,key="$"},{time=83.018,key="$"},
    {time=83.134,key="!"},{time=83.158,key="W"},{time=83.517,key="4"},{time=83.529,key="4"},
    {time=83.784,key="4"},{time=83.982,key="^"},{time=84.005,key="@"},{time=84.075,key="Q"},
    {time=84.203,key="i"},{time=84.273,key="q"},{time=84.273,key="^"},{time=84.516,key="!"},
    {time=84.771,key="Q"},{time=84.993,key="@"},{time=84.993,key="7"},{time=85.005,key="7"},
    {time=85.016,key="Q"},{time=85.075,key="T"},{time=85.260,key="$"},{time=85.458,key="*"},
    {time=85.492,key="E"},{time=85.492,key="7"},{time=85.539,key="7"},{time=86.004,key="I"},
    {time=86.004,key="Q"},{time=86.004,key="!"},{time=86.259,key="%"},{time=86.352,key="!"},
    {time=86.514,key="*"},{time=86.514,key="!"},{time=86.769,key="4"},{time=86.980,key="*"},
    {time=86.991,key="^"},{time=87.003,key="$"},{time=87.038,key="Q"},{time=87.235,key="$"},
    {time=87.490,key="4"},{time=87.503,key="%"},{time=87.537,key="T"},{time=87.792,key="*"},
    {time=88.013,key="^"},{time=88.013,key="@"},{time=88.036,key="E"},{time=88.268,key="^"},
    {time=88.304,key="q"},{time=88.512,key="*"},{time=88.524,key="!"},{time=88.663,key="@"},
    {time=88.675,key="@"},{time=88.744,key="*"},{time=89.002,key="E"},{time=89.002,key="@"},
    {time=89.002,key="7"},{time=89.257,key="$"},{time=89.501,key="7"},{time=89.512,key="7"},
    {time=89.605,key="*"},{time=89.767,key="r"},{time=90.000,key="E"},{time=90.011,key="*"},
    {time=90.011,key="!"},{time=90.243,key="*"},{time=90.255,key="!"},{time=90.266,key="%"},
    {time=90.290,key="T"},{time=90.510,key="!"},{time=90.523,key="!"},{time=90.742,key="E"},
    {time=90.755,key="!"},{time=91.000,key="$"},{time=91.011,key="$"},{time=91.127,key="!"},
    {time=91.255,key="W"},{time=91.510,key="4"},{time=91.521,key="4"},{time=91.986,key="^"},
    {time=91.998,key="@"},{time=92.044,key="Q"},{time=92.090,key="E"},{time=92.195,key="q"},
    {time=92.265,key="^"},{time=92.311,key="i"},{time=92.474,key="!"},{time=92.613,key="^"},
    {time=92.625,key="!"},{time=92.764,key="^"},{time=92.776,key="Q"},{time=92.986,key="7"},
    {time=92.998,key="7"},{time=93.009,key="@"},{time=93.241,key="7"},{time=93.253,key="*"},
    {time=93.253,key="$"},{time=93.404,key="7"},{time=93.485,key="7"},{time=93.625,key="7"},
    {time=93.764,key="7"},{time=93.857,key="$"},{time=93.996,key="Q"},{time=93.996,key="^"},
    {time=94.008,key="!"},{time=94.252,key="%"},{time=94.252,key="!"},{time=94.367,key="7"},
    {time=94.530,key="7"},{time=94.669,key="Q"},{time=95.008,key="$"},{time=95.019,key="7"},
    {time=95.077,key="Q"},{time=95.297,key="4"},{time=95.495,key="!"},{time=95.530,key="$"},
    {time=95.704,key="$"},{time=95.728,key="!"},{time=95.855,key="$"},{time=96.017,key="@"},
    {time=96.145,key="!"},{time=96.760,key="%"},{time=96.994,key="$"},{time=97.006,key="7"},
    {time=97.575,key="*"},{time=97.749,key="@"},{time=97.784,key="^"},{time=97.992,key="!"},
    {time=98.109,key="!"},{time=98.341,key="!"},{time=98.376,key="%"},{time=98.399,key="@"},
    {time=98.770,key="4"},{time=98.770,key="^"},{time=99.294,key="4"},{time=99.561,key="$"},
    {time=99.584,key="%"},{time=99.990,key="$"},{time=100.003,key="^"},{time=100.258,key="!"},
    {time=100.757,key="^"},{time=100.827,key="@"},{time=101.002,key="^"},{time=101.489,key="$"},
    {time=101.570,key="7"},{time=102.024,key="^"},{time=102.046,key="!"},{time=102.070,key="4"},
    {time=102.360,key="$"},{time=102.407,key="!"},{time=102.698,key="$"},{time=102.847,key="%"},
    {time=102.988,key="$"},{time=103.046,key="^"},{time=103.500,key="%"},{time=103.581,key="7"},
    {time=104.010,key="^"},{time=104.010,key="@"},{time=104.405,key="^"},{time=104.754,key="^"},
    {time=105.021,key="7"},{time=105.346,key="^"},{time=105.509,key="^"},{time=105.788,key="7"},
    {time=106.009,key="^"},{time=106.240,key="!"},{time=106.321,key="$"},{time=106.391,key="!"},
    {time=106.496,key="!"},{time=107.008,key="^"},{time=107.032,key="$"},{time=107.519,key="%"},
    {time=107.739,key="$"},{time=108.041,key="^"},{time=108.413,key="^"},{time=108.750,key="^"},
    {time=108.983,key="^"},{time=109.007,key="7"},{time=109.599,key="$"},{time=109.727,key="7"},
    {time=110.133,key="!"},{time=110.330,key="!"},{time=110.400,key="$"},{time=110.515,key="!"},
    {time=110.818,key="%"},{time=111.039,key="$"},{time=111.318,key="!"},{time=111.318,key="$"},
    {time=111.980,key="$"},{time=112.003,key="$"},{time=112.014,key="@"},{time=112.758,key="%"},
    {time=112.991,key="$"},{time=113.003,key="7"},{time=113.050,key="!"},{time=113.050,key="7"},
    {time=113.653,key="@"},{time=113.781,key="^"},{time=114.002,key="!"},{time=114.083,key="!"},
    {time=114.234,key="!"},{time=114.408,key="%"},{time=114.419,key="@"},{time=114.442,key="%"},
    {time=114.792,key="4"},{time=114.804,key="^"},{time=115.082,key="4"},{time=115.535,key="$"},
    {time=115.616,key="%"},{time=115.767,key="$"},{time=115.779,key="!"},{time=116.000,key="^"},
    {time=116.069,key="^"},{time=116.754,key="^"},{time=116.849,key="4"},{time=117.568,key="7"},
    {time=117.998,key="4"},{time=118.056,key="^"},{time=118.079,key="!"},{time=118.369,key="!"},
    {time=118.754,key="%"},{time=119.032,key="^"},{time=119.555,key="7"},{time=119.566,key="%"},
    {time=119.752,key="%"},{time=119.995,key="@"},{time=120.008,key="^"},{time=120.518,key="!"},
    {time=120.763,key="^"},{time=121.007,key="7"},{time=121.018,key="7"},{time=121.494,key="^"},
    {time=121.785,key="7"},{time=122.006,key="^"},{time=122.145,key="!"},{time=122.342,key="$"},
    {time=122.505,key="!"},{time=123.075,key="$"},{time=123.737,key="$"},{time=124.051,key="^"},
    {time=124.387,key="^"},{time=124.771,key="^"},{time=125.004,key="7"},{time=125.248,key="^"},
    {time=125.514,key="^"},{time=125.584,key="$"},{time=125.758,key="7"},{time=126.153,key="!"},
    {time=126.292,key="!"},{time=126.374,key="$"},{time=126.513,key="!"},{time=126.746,key="%"},
    {time=126.920,key="$"},{time=126.990,key="$"},{time=127.501,key="$"},{time=127.757,key="$"},
    {time=128.024,key="$"},{time=128.290,key="^"},{time=128.371,key="@"},{time=128.768,key="!"},
    {time=128.988,key="7"},{time=129.093,key="@"},{time=129.256,key="$"},{time=129.267,key="$"},
    {time=129.511,key="7"},{time=129.534,key="!"},{time=129.766,key="7"},{time=130.033,key="!"},
    {time=130.254,key="%"},{time=130.520,key="!"},{time=130.755,key="q"},{time=130.755,key="4"},
    {time=131.010,key="$"},{time=131.056,key="!"},{time=131.277,key="$"},{time=131.509,key="4"},
    {time=131.556,key="$"},{time=131.753,key="$"},{time=132.008,key="@"},{time=132.032,key="$"},
    {time=132.276,key="^"},{time=132.438,key="@"},{time=132.519,key="!"},{time=132.776,key="!"},
    {time=132.985,key="7"},{time=133.031,key="@"},{time=133.252,key="$"},{time=133.380,key="!"},
    {time=133.472,key="7"},{time=133.495,key="7"},{time=133.775,key="7"},{time=133.983,key="!"},
    {time=134.274,key="%"},{time=134.517,key="!"},{time=134.762,key="4"},{time=134.983,key="!"},
    {time=135.006,key="$"},{time=135.308,key="$"},{time=135.517,key="$"},{time=136.028,key="4"},
    {time=137.062,key="7"},{time=137.260,key="$"},{time=137.271,key="!"},{time=137.596,key="$"},
    {time=137.794,key="7"},{time=138.095,key="!"},{time=138.235,key="!"},{time=138.339,key="!"},
    {time=138.502,key="!"},{time=138.736,key="@"},{time=138.770,key="4"},{time=139.026,key="$"},
    {time=139.246,key="$"},{time=139.781,key="$"},{time=140.501,key="@"},{time=140.535,key="!"},
    {time=141.048,key="%"},{time=141.048,key="7"},{time=141.395,key="$"},{time=141.558,key="7"},
    {time=142.069,key="!"},{time=142.243,key="$"},{time=142.243,key="!"},{time=142.406,key="!"},
    {time=142.499,key="$"},{time=142.755,key="%"},{time=142.779,key="4"},{time=143.034,key="$"},
    {time=143.289,key="$"},{time=143.556,key="%"},{time=144.207,key="$"},{time=144.218,key="^"},
    {time=144.381,key="@"},{time=144.520,key="$"},{time=144.742,key="$"},{time=144.986,key="7"},
    {time=145.032,key="7"},{time=145.496,key="$"},{time=145.995,key="%"},{time=146.054,key="!"},
    {time=146.251,key="%"},{time=146.390,key="$"},{time=146.390,key="!"},{time=146.530,key="!"},
    {time=146.833,key="4"},{time=147.007,key="$"},{time=147.205,key="^"},{time=147.506,key="$"},
    {time=147.576,key="7"},{time=147.738,key="4"},{time=148.052,key="^"},{time=148.121,key="$"},
    {time=148.388,key="$"},{time=148.505,key="^"},{time=149.005,key="$"},{time=149.005,key="7"},
    {time=149.029,key="7"},{time=149.237,key="$"},{time=149.667,key="^"},{time=150.108,key="!"},
    {time=150.259,key="%"},{time=150.340,key="!"},{time=150.363,key="$"},{time=150.527,key="!"},
    {time=150.771,key="4"},{time=151.027,key="^"},{time=151.050,key="$"},{time=151.607,key="%"},
    {time=151.631,key="7"},{time=151.781,key="4"},{time=152.002,key="@"},{time=152.060,key="^"},
    {time=152.060,key="$"},{time=152.269,key="^"},{time=152.281,key="%"},{time=152.665,key="$"},
    {time=152.990,key="7"},{time=153.002,key="7"},{time=153.257,key="%"},{time=153.756,key="$"},
    {time=154.151,key="!"},{time=154.244,key="%"},{time=154.337,key="!"},{time=154.394,key="$"},
    {time=154.512,key="!"},{time=154.767,key="%"},{time=154.895,key="^"},{time=155.000,key="$"},
    {time=155.557,key="^"},{time=155.627,key="4"},{time=155.696,key="7"},{time=155.731,key="%"},
    {time=156.010,key="^"},{time=156.254,key="%"},{time=156.580,key="$"},{time=156.999,key="7"},
    {time=157.230,key="%"},{time=157.498,key="$"},{time=157.649,key="7"},{time=158.043,key="!"},
    {time=158.078,key="!"},{time=158.078,key="^"},{time=158.240,key="!"},{time=158.391,key="$"},
    {time=158.509,key="!"},{time=158.671,key="$"},{time=158.822,key="%"},{time=159.042,key="$"},
    {time=159.530,key="4"},{time=160.018,key="@"},{time=160.030,key="$"},{time=160.401,key="^"},
    {time=161.017,key="7"},{time=161.261,key="$"},{time=161.575,key="7"},{time=161.750,key="r"},
    {time=162.005,key="E"},{time=162.005,key="q"},{time=162.005,key="$"},{time=162.005,key="!"},
    {time=162.016,key="*"},{time=162.249,key="*"},{time=162.249,key="!"},{time=162.271,key="%"},
    {time=162.294,key="T"},{time=162.482,key="W"},{time=162.493,key="!"},{time=162.610,key="E"},
    {time=162.633,key="*"},{time=162.760,key="4"},{time=163.004,key="$"},{time=163.062,key="W"},
    {time=163.236,key="!"},{time=163.260,key="W"},{time=163.492,key="*"},{time=163.515,key="4"},
    {time=163.527,key="4"},{time=163.793,key="4"},{time=163.991,key="^"},{time=164.003,key="@"},
    {time=164.072,key="Q"},{time=164.269,key="q"},{time=164.269,key="^"},{time=164.515,key="!"},
    {time=164.724,key="*"},{time=164.759,key="Q"},{time=164.840,key="@"},{time=165.003,key="7"},
    {time=165.037,key="@"},{time=165.060,key="T"},{time=165.258,key="*"},{time=165.258,key="$"},
    {time=165.502,key="*"},{time=165.502,key="$"},{time=165.513,key="Q"},{time=165.513,key="7"},
    {time=166.001,key="I"},{time=166.001,key="Q"},{time=166.012,key="!"},{time=166.256,key="%"},
    {time=166.337,key="T"},{time=166.513,key="!"},{time=166.757,key="4"},{time=166.768,key="Q"},
    {time=166.768,key="!"},{time=167.001,key="^"},{time=167.001,key="$"},{time=167.012,key="$"},
    {time=167.024,key="I"},{time=167.024,key="Q"},{time=167.233,key="$"},{time=167.500,key="4"},
    {time=167.511,key="Q"},{time=167.511,key="%"},{time=167.511,key="!"},{time=167.546,key="T"},
    {time=167.790,key="*"},{time=168.000,key="^"},{time=168.000,key="@"},{time=168.011,key="@"},
    {time=168.023,key="E"},{time=168.092,key="Q"},{time=168.266,key="^"},{time=168.312,key="q"},
    {time=168.511,key="*"},{time=168.511,key="!"},{time=168.709,key="@"},{time=168.743,key="*"},
    {time=168.999,key="@"},{time=169.010,key="E"},{time=169.010,key="7"},{time=169.254,key="$"},
    {time=169.463,key="7"},{time=169.475,key="$"},{time=169.486,key="$"},{time=169.742,key="r"},
    {time=169.951,key="$"},{time=170.009,key="E"},{time=170.009,key="!"},{time=170.020,key="*"},
    {time=170.125,key="T"},{time=170.241,key="!"},{time=170.264,key="%"},{time=170.486,key="!"},
    {time=170.498,key="*"},{time=170.498,key="!"},{time=170.730,key="E"},{time=170.985,key="!"},
    {time=171.009,key="$"},{time=171.160,key="!"},{time=171.241,key="W"},{time=171.519,key="4"},
    {time=171.531,key="4"},{time=171.786,key="4"},{time=171.984,key="^"},{time=171.995,key="^"},
    {time=172.007,key="@"},{time=172.042,key="Q"},{time=172.275,key="q"},{time=172.275,key="^"},
    {time=172.380,key="i"},{time=172.472,key="!"},{time=172.624,key="!"},{time=172.716,key="*"},
    {time=172.740,key="^"},{time=172.763,key="Q"},{time=172.995,key="@"},{time=172.995,key="7"},
    {time=173.007,key="Q"},{time=173.018,key="7"},{time=173.251,key="$"},{time=173.425,key="7"},
    {time=173.634,key="7"},{time=173.785,key="7"},{time=173.901,key="$"},{time=174.006,key="Q"},
    {time=174.006,key="!"},{time=174.110,key="^"},{time=174.261,key="%"},{time=174.365,key="!"},
    {time=174.483,key="7"},{time=174.599,key="Q"},{time=175.016,key="$"},{time=175.086,key="Q"},
    {time=175.249,key="4"},{time=175.539,key="!"},{time=175.586,key="$"},{time=175.736,key="$"},
    {time=175.749,key="!"},{time=176.248,key="4"},{time=176.400,key="!"},{time=176.400,key="$"},
    {time=176.783,key="%"},{time=176.806,key="@"},{time=177.015,key="$"},{time=177.027,key="7"},
    {time=177.050,key="!"},{time=177.584,key="@"},{time=177.607,key="^"},{time=177.711,key="("},
    {time=178.013,key="!"},{time=178.094,key="!"},{time=178.234,key="!"},{time=178.386,key="!"},
    {time=178.386,key="$"},{time=178.537,key="%"},{time=178.758,key="4"},{time=178.769,key="^"},
    {time=179.268,key="$"},{time=179.593,key="%"},{time=180.000,key="$"},{time=180.046,key="^"},
    {time=180.350,key="!"},{time=180.779,key="^"},{time=180.803,key="4"},{time=181.534,key="7"},
    {time=182.044,key="^"},{time=182.080,key="!"},{time=182.347,key="$"},{time=182.359,key="!"},
    {time=182.859,key="%"},{time=183.021,key="^"},{time=183.056,key="$"},{time=183.509,key="%"},
    {time=183.520,key="7"},{time=183.753,key="%"},{time=184.031,key="^"},{time=184.381,key="^"},
    {time=184.509,key="!"},{time=184.764,key="^"},{time=185.042,key="^"},{time=185.263,key="7"},
    {time=185.426,key="^"},{time=185.774,key="7"},{time=186.006,key="^"},{time=186.099,key="!"},
    {time=186.285,key="!"},{time=186.367,key="$"},{time=186.994,key="^"},{time=187.053,key="$"},
    {time=187.529,key="4"},{time=187.749,key="$"},{time=188.051,key="^"},{time=188.074,key="@"},
    {time=188.377,key="^"},{time=188.760,key="^"},{time=189.748,key="7"},{time=190.177,key="!"},
    {time=190.317,key="!"},{time=190.376,key="$"},{time=190.735,key="%"},{time=190.759,key="4"},
    {time=190.990,key="$"},{time=191.502,key="$"},{time=191.629,key="!"},{time=191.768,key="$"},
    {time=192.059,key="@"},{time=192.129,key="$"},{time=192.269,key="^"},{time=192.757,key="%"},
    {time=192.989,key="!"},{time=193.012,key="7"},{time=193.035,key="$"},{time=193.674,key="@"},
    {time=193.766,key="^"},{time=193.987,key="!"},{time=194.115,key="!"},{time=194.349,key="%"},
    {time=194.349,key="!"},{time=194.534,key="!"},{time=194.651,key="!"},{time=194.802,key="4"},
    {time=195.021,key="^"},{time=195.254,key="$"},{time=195.312,key="4"},{time=195.556,key="%"},
    {time=195.998,key="$"},{time=196.055,key="!"},{time=196.055,key="@"},{time=196.079,key="^"},
    {time=196.753,key="^"},{time=196.996,key="^"},{time=197.090,key="4"},{time=197.682,key="7"},
    {time=197.752,key="4"},{time=198.030,key="^"},{time=198.065,key="!"},{time=198.158,key="Q"},
    {time=198.229,key="!"},{time=198.357,key="$"},{time=198.809,key="%"},{time=198.984,key="$"},
    {time=198.995,key="$"},{time=199.053,key="^"},{time=199.541,key="%"},{time=199.599,key="7"},
    {time=200.156,key="^"},{time=200.262,key="!"},{time=200.402,key="^"},{time=200.750,key="^"},
    {time=201.016,key="7"},{time=201.271,key="$"},{time=201.504,key="^"},{time=201.562,key="$"},
    {time=201.760,key="7"},{time=201.923,key="^"},{time=202.108,key="!"},{time=202.271,key="!"},
    {time=202.376,key="$"},{time=202.469,key="!"},{time=203.027,key="$"},{time=203.758,key="$"},
    {time=204.094,key="^"},{time=204.235,key="@"},{time=205.013,key="7"},{time=205.582,key="$"},
    {time=205.756,key="7"},{time=206.104,key="!"},{time=206.314,key="!"},{time=206.384,key="$"},
    {time=206.826,key="%"},{time=206.988,key="$"},{time=208.010,key="^"},{time=208.010,key="@"},
    {time=208.010,key="Q"},{time=208.255,key="^"},{time=208.510,key="!"},{time=208.754,key="E"},
    {time=208.998,key="7"},{time=209.137,key="@"},{time=209.137,key="7"},{time=209.265,key="$"},
    {time=209.496,key="E"},{time=209.496,key="7"},{time=209.509,key="$"},{time=209.532,key="7"},
    {time=209.753,key="*"},{time=210.008,key="q"},{time=210.008,key="*"},{time=210.008,key="!"},
    {time=210.019,key="!"},{time=210.241,key="*"},{time=210.241,key="!"},{time=210.264,key="%"},
    {time=210.508,key="!"},{time=210.752,key="4"},{time=211.008,key="$"},{time=211.019,key="$"},
    {time=211.240,key="!"},{time=211.263,key="W"},{time=211.507,key="*"},{time=211.507,key="4"},
    {time=211.994,key="^"},{time=212.006,key="Q"},{time=212.006,key="@"},{time=212.182,key="@"},
    {time=212.263,key="^"},{time=212.518,key="!"},{time=212.751,key="Q"},{time=212.762,key="T"},
    {time=212.994,key="7"},{time=213.006,key="Q"},{time=213.006,key="7"},{time=213.006,key="@"},
    {time=213.261,key="$"},{time=213.493,key="E"},{time=213.493,key="$"},{time=213.505,key="Q"},
    {time=213.516,key="7"},{time=213.656,key="T"},{time=213.992,key="!"},{time=214.004,key="q"},
    {time=214.004,key="!"},{time=214.168,key="Q"},{time=214.273,key="%"},{time=214.505,key="*"},
    {time=214.516,key="!"},{time=214.737,key="!"},{time=214.760,key="4"},{time=214.992,key="^"},
    {time=215.004,key="$"},{time=215.120,key="T"},{time=215.503,key="Q"},{time=215.503,key="4"},
    {time=215.515,key="%"},{time=215.572,key="4"},{time=216.003,key="Q"},{time=216.003,key="^"},
    {time=216.014,key="@"},{time=216.259,key="^"},{time=216.514,key="!"},{time=216.712,key="*"},
    {time=216.735,key="E"},{time=216.990,key="7"},{time=217.014,key="7"},{time=217.258,key="$"},
    {time=217.502,key="E"},{time=217.513,key="7"},{time=217.513,key="$"},{time=217.536,key="$"},
    {time=217.699,key="*"},{time=218.012,key="*"},{time=218.012,key="!"},{time=218.245,key="*"},
    {time=218.513,key="!"},{time=218.699,key="T"},{time=218.768,key="4"},{time=219.012,key="$"},
    {time=219.175,key="!"},{time=219.197,key="W"},{time=219.256,key="$"},{time=219.500,key="*"},
    {time=219.511,key="4"},{time=219.523,key="4"},{time=219.674,key="!"},{time=219.976,key="@"},
    {time=219.987,key="^"},{time=219.999,key="Q"},{time=220.010,key="@"},{time=220.267,key="^"},
    {time=220.511,key="*"},{time=220.511,key="!"},{time=220.732,key="Q"},{time=220.999,key="Q"},
    {time=220.999,key="7"},{time=221.010,key="@"},{time=221.265,key="$"},{time=221.312,key="Q"},
    {time=221.498,key="E"},{time=221.498,key="7"},{time=221.521,key="7"},{time=221.741,key="T"},
    {time=221.996,key="!"},{time=222.009,key="q"},{time=222.009,key="!"},{time=222.150,key="Q"},
    {time=222.254,key="%"},{time=222.520,key="*"},{time=222.520,key="!"},{time=222.764,key="4"}
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

-- ── 歓喜の歌 Ode to Joy (BPM=116 / A-B-A full / ~45s) ─────────
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
}

-- ── Happy Birthday (3/4 BPM=90 / ~31s) ────────────────────────
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

-- ── 夜に駆ける (YOASOBI BPM=130 / ~22s) ──────────────────────
local notes_yoru = {
    {time=0.000,key="W"},{time=0.231,key="e"},{time=0.462,key="W"},{time=0.692,key="e"},
    {time=0.923,key="0"},{time=1.154,key="e"},{time=1.385,key="W"},{time=1.615,key="e"},
    {time=1.846,key="0"},{time=2.308,key="W"},{time=2.538,key="e"},{time=2.769,key="W"},
    {time=3.000,key="e"},{time=3.231,key="0"},{time=3.692,key="e"},{time=3.923,key="W"},
    {time=4.154,key="e"},{time=4.385,key="W"},{time=4.615,key="0"},{time=5.077,key="9"},
    {time=5.308,key="0"},{time=5.538,key="9"},{time=5.769,key="8"},{time=6.000,key="9"},
    {time=6.231,key="*"},{time=6.462,key="9"},{time=6.923,key="0"},{time=7.154,key="W"},
    {time=7.385,key="e"},{time=7.615,key="W"},{time=7.846,key="e"},{time=8.077,key="0"},
    {time=8.538,key="W"},{time=8.769,key="e"},{time=9.000,key="W"},{time=9.231,key="e"},
    {time=9.462,key="r"},{time=9.692,key="e"},{time=9.923,key="W"},{time=10.154,key="0"},
    {time=10.615,key="9"},{time=10.846,key="0"},{time=11.077,key="W"},{time=11.308,key="e"},
    {time=11.538,key="W"},{time=11.769,key="q"},{time=12.231,key="W"},{time=12.462,key="0"},
    {time=12.692,key="9"},{time=12.923,key="8"},{time=13.154,key="9"},{time=13.385,key="0"},
    {time=13.615,key="9"},{time=14.538,key="e"},{time=14.769,key="r"},{time=15.000,key="e"},
    {time=15.231,key="r"},{time=15.923,key="e"},{time=16.154,key="r"},{time=16.385,key="t"},
    {time=16.615,key="r"},{time=16.846,key="e"},{time=17.077,key="r"},{time=17.538,key="e"},
}

-- ── Lemon (米津玄師 BPM=78 / ~30s) ────────────────────────────
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

-- ── 紅蓮華 (LiSA / 鬼滅の刃 BPM=152 / ~21s) ──────────────────
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

-- ── 炎 (LiSA / 鬼滅の刃 BPM=95 / ~24s) ──────────────────────
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

-- ── 残酷な天使のテーゼ (エヴァ BPM=128 / ~20s) ────────────────
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

-- ── ミックスナッツ (SPY×FAMILY BPM=118 / ~17s) ─────────────────
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

-- ── 廻廻奇譚 (Eve / 呪術廻戦 BPM=138 / ~16s) ─────────────────
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
    Name            = "🎸 Piano Player v3 — 15曲収録",
    LoadingTitle    = "Piano Player v3",
    LoadingSubtitle = "Libra Heart MIDIデータ使用",
    ConfigurationSaving = { Enabled = false },
    Discord         = { Enabled = false },
    KeySystem       = false,
})

-- ── 🎸 Libra Heart タブ ──────────────────────────────────────
local LT = Win:CreateTab("🎸 Libra Heart", 4483345998)

LT:CreateSection("Libra Heart 2")

LT:CreateButton({
    Name="▶  Libra Heart 2 — Full (~27s)",
    Callback=function() playSong(notes_libra2,"Libra Heart 2") end,
})
LT:CreateButton({
    Name="▶  Libra Heart 2 — Melody Only",
    Callback=function() playSong(melodyOnly(notes_libra2),"Libra Heart 2 [MELODY]") end,
})

LT:CreateSection("Libra Heart 1")

LT:CreateButton({ Name="▶  Full Play (~116s)",         Callback=function() playSong(notes_libra1,"Libra Heart") end })
LT:CreateButton({ Name="▶  Part 1 [0-30s]",            Callback=function()
    local p={} for _,n in ipairs(notes_libra1) do if n.time<=30 then p[#p+1]=n end end
    playSong(p,"Libra Heart [P1]") end })
LT:CreateButton({ Name="▶  Part 2 [30-60s]",           Callback=function()
    local p={} for _,n in ipairs(notes_libra1) do if n.time>=30 and n.time<=60 then p[#p+1]={time=n.time-30,key=n.key} end end
    playSong(p,"Libra Heart [P2]") end })
LT:CreateButton({ Name="▶  Part 3 [60-120s]",           Callback=function()
    local p={} for _,n in ipairs(notes_libra1) do if n.time>=60 and n.time<=120 then p[#p+1]={time=n.time-60,key=n.key} end end
    playSong(p,"Libra Heart [P3]") end })
LT:CreateButton({ Name="▶  FINALE [180-225s]",          Callback=function()
    local p={} for _,n in ipairs(notes_libra1) do if n.time>=180 then p[#p+1]={time=n.time-180,key=n.key} end end
    playSong(p,"Libra Heart [FINALE]") end })
LT:CreateButton({ Name="▶  Melody Only — Full",        Callback=function() playSong(melodyOnly(notes_libra1),"LH1 [MELODY]") end })

-- ── 🎵 童謡・クラシック タブ ─────────────────────────────────
local KT = Win:CreateTab("🎵 童謡/Classic", 4483345998)

KT:CreateSection("童謡 (15秒以上)")
KT:CreateButton({ Name="▶  きらきら星 (~46s / 4verse)",  Callback=function() playSong(notes_twinkle,"きらきら星") end })
KT:CreateButton({ Name="▶  歓喜の歌 Ode to Joy (~45s)",  Callback=function() playSong(notes_ode,"歓喜の歌") end })
KT:CreateButton({ Name="▶  Happy Birthday (~31s)",        Callback=function() playSong(notes_birthday,"Happy Birthday") end })

KT:CreateSection("クラシック")
KT:CreateButton({ Name="▶  カノン in D — Pachelbel (~32s)",    Callback=function() playSong(notes_canon,"カノン in D") end })
KT:CreateButton({ Name="▶  エリーゼのために — Beethoven (~42s)", Callback=function() playSong(notes_furelise,"エリーゼのために") end })

-- ── 🎤 J-Pop/アニメ タブ ─────────────────────────────────────
local JT = Win:CreateTab("🎤 J-Pop/Anime", 4483345998)

JT:CreateSection("J-Pop")
JT:CreateButton({ Name="▶  夜に駆ける — YOASOBI (~22s)",        Callback=function() playSong(notes_yoru,"夜に駆ける") end })
JT:CreateButton({ Name="▶  Lemon — 米津玄師 (~30s)",            Callback=function() playSong(notes_lemon,"Lemon") end })
JT:CreateButton({ Name="▶  青と夏 — Mrs.GREEN APPLE (~18s)",    Callback=function() playSong(notes_ao,"青と夏") end })

JT:CreateSection("アニメ")
JT:CreateButton({ Name="▶  紅蓮華 — LiSA / 鬼滅の刃 (~21s)",   Callback=function() playSong(notes_red,"紅蓮華") end })
JT:CreateButton({ Name="▶  炎 — LiSA / 鬼滅の刃 (~24s)",       Callback=function() playSong(notes_homura,"炎") end })
JT:CreateButton({ Name="▶  残酷な天使のテーゼ — EVA (~20s)",    Callback=function() playSong(notes_eva,"残酷な天使のテーゼ") end })
JT:CreateButton({ Name="▶  ミックスナッツ — SPY×FAMILY (~17s)",  Callback=function() playSong(notes_mix,"ミックスナッツ") end })
JT:CreateButton({ Name="▶  廻廻奇譚 — Eve / 呪術廻戦 (~16s)",   Callback=function() playSong(notes_kai,"廻廻奇譚") end })

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
        "・Speed変更は次の演奏から反映\n"..
        "・Libra Heart: MIDIファイルより正確変換済み",
})
