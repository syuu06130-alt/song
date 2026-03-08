-- ==============================================================
--   🎸 Piano Player v3  [15曲収録]
--   Virtual Piano Player  ―  Rayfield UI
--   Libra Heart データ: MIDIファイルより正確に変換済み
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

-- ── Libra Heart 2 [246ノーツ / 0〜27s]
local notes_libra2 = {
    {time=0.000,key="^"},{time=0.011,key="@"},{time=0.011,key="q"},{time=0.093,key="Q"},
    {time=0.268,key="^"},{time=0.325,key="t"},{time=0.350,key="q"},{time=0.511,key="@"},
    {time=0.522,key="!"},{time=0.522,key="*"},{time=0.766,key="!"},{time=0.766,key="*"},
    {time=0.847,key="@"},{time=1.011,key="7"},{time=1.277,key="$"},{time=1.534,key="7"},
    {time=1.731,key="r"},{time=2.000,key="!"},{time=2.000,key="q"},{time=2.243,key="*"},
    {time=2.254,key="%"},{time=2.509,key="!"},{time=2.741,key="E"},{time=2.766,key="4"},
    {time=3.009,key="$"},{time=3.009,key="Q"},{time=3.147,key="!"},{time=3.159,key="W"},
    {time=3.497,key="*"},{time=3.497,key="Q"},{time=3.509,key="4"},{time=3.520,key="4"},
    {time=3.986,key="^"},{time=3.986,key="Q"},{time=3.997,key="@"},{time=4.079,key="Q"},
    {time=4.263,key="^"},{time=4.275,key="q"},{time=4.404,key="i"},{time=4.520,key="!"},
    {time=5.006,key="7"},{time=5.263,key="$"},{time=5.495,key="E"},{time=5.506,key="7"},
    {time=6.006,key="!"},{time=6.006,key="Q"},{time=6.006,key="I"},{time=6.122,key="Q"},
    {time=6.261,key="%"},{time=6.343,key="W"},{time=6.518,key="!"},{time=6.518,key="*"},
    {time=6.761,key="4"},{time=6.772,key="!"},{time=6.981,key="^"},{time=6.993,key="$"},
    {time=7.004,key="$"},{time=7.016,key="$"},{time=7.016,key="Q"},{time=7.329,key="I"},
    {time=7.506,key="4"},{time=7.506,key="Q"},{time=7.506,key="W"},{time=7.518,key="4"},
    {time=7.645,key="%"},{time=8.004,key="@"},{time=8.004,key="^"},{time=8.004,key="Q"},
    {time=8.016,key="q"},{time=8.097,key="Q"},{time=8.261,key="^"},{time=8.318,key="i"},
    {time=8.329,key="q"},{time=8.516,key="!"},{time=8.666,key="@"},{time=8.747,key="*"},
    {time=8.795,key="@"},{time=9.004,key="@"},{time=9.004,key="E"},{time=9.016,key="7"},
    {time=9.270,key="$"},{time=9.493,key="7"},{time=9.493,key="E"},{time=9.504,key="$"},
    {time=9.516,key="7"},{time=9.597,key="T"},{time=9.736,key="7"},{time=9.747,key="7"},
    {time=9.770,key="r"},{time=9.806,key="$"},{time=9.991,key="E"},{time=10.002,key="!"},
    {time=10.002,key="q"},{time=10.247,key="%"},{time=10.247,key="!"},{time=10.270,key="!"},
    {time=10.304,key="*"},{time=10.479,key="W"},{time=10.502,key="!"},{time=10.502,key="*"},
    {time=10.513,key="!"},{time=10.745,key="E"},{time=11.013,key="$"},{time=11.013,key="E"},
    {time=11.025,key="$"},{time=11.163,key="W"},{time=11.256,key="W"},{time=11.502,key="4"},
    {time=11.513,key="4"},{time=11.666,key="Q"},{time=11.745,key="*"},{time=11.770,key="W"},
    {time=11.781,key="4"},{time=11.897,key="W"},{time=11.977,key="@"},{time=11.991,key="^"},
    {time=12.002,key="("},{time=12.002,key="Q"},{time=12.081,key="Q"},{time=12.256,key="^"},
    {time=12.268,key="q"},{time=12.511,key="q"},{time=12.525,key="!"},{time=12.734,key="!"},
    {time=12.756,key="^"},{time=12.779,key="Q"},{time=12.929,key="7"},{time=13.011,key="7"},
    {time=13.034,key="Q"},{time=13.070,key="@"},{time=13.254,key="7"},{time=13.266,key="$"},
    {time=13.384,key="7"},{time=13.477,key="7"},{time=13.488,key="E"},{time=13.500,key="$"},
    {time=13.500,key="7"},{time=13.500,key="Q"},{time=13.756,key="7"},{time=13.768,key="7"},
    {time=13.884,key="7"},{time=14.011,key="!"},{time=14.011,key="^"},{time=14.243,key="^"},
    {time=14.254,key="Q"},{time=14.359,key="!"},{time=14.370,key="7"},{time=14.406,key="^"},
    {time=14.511,key="!"},{time=14.545,key="7"},{time=14.672,key="!"},{time=14.766,key="7"},
    {time=14.766,key="Q"},{time=14.847,key="!"},{time=14.859,key="7"},{time=14.952,key="!"},
    {time=14.997,key="$"},{time=15.009,key="$"},{time=15.034,key="1"},{time=15.034,key="Q"},
    {time=15.138,key="$"},{time=15.150,key="!"},{time=15.184,key="^"},{time=15.254,key="4"},
    {time=15.277,key="^"},{time=15.345,key="7"},{time=15.359,key="$"},{time=15.370,key="$"},
    {time=15.511,key="!"},{time=15.522,key="4"},{time=15.650,key="$"},{time=15.766,key="$"},
    {time=16.009,key="@"},{time=16.009,key="$"},{time=16.102,key="!"},{time=16.427,key="@"},
    {time=16.531,key="^"},{time=16.775,key="%"},{time=16.800,key="@"},{time=17.020,key="7"},
    {time=17.031,key="7"},{time=17.066,key="$"},{time=17.497,key="!"},{time=17.659,key="("},
    {time=17.729,key="@"},{time=17.775,key="7"},{time=17.786,key="^"},{time=17.938,key="!"},
    {time=18.020,key="!"},{time=18.100,key="!"},{time=18.345,key="%"},{time=18.472,key="!"},
    {time=18.495,key="!"},{time=18.891,key="7"},{time=19.029,key="^"},{time=19.041,key="$"},
    {time=19.261,key="$"},{time=19.295,key="!"},{time=19.331,key="4"},{time=19.472,key="%"},
    {time=19.727,key="4"},{time=19.995,key="$"},{time=20.041,key="!"},{time=20.097,key="$"},
    {time=20.795,key="^"},{time=21.027,key="7"},{time=21.027,key="^"},{time=21.538,key="7"},
    {time=21.538,key="@"},{time=21.563,key="$"},{time=22.027,key="^"},{time=22.038,key="!"},
    {time=22.086,key="!"},{time=22.236,key="!"},{time=22.352,key="^"},{time=22.375,key="4"},
    {time=22.386,key="!"},{time=22.725,key="%"},{time=22.816,key="%"},{time=22.816,key="7"},
    {time=23.036,key="^"},{time=23.095,key="$"},{time=23.491,key="%"},{time=23.502,key="7"},
    {time=23.584,key="4"},{time=24.025,key="^"},{time=24.397,key="^"},{time=24.502,key="@"},
    {time=24.756,key="^"},{time=25.011,key="7"},{time=25.047,key="7"},{time=25.268,key="$"},
    {time=25.559,key="^"},{time=25.581,key="$"},{time=25.779,key="7"},{time=26.000,key="^"},
    {time=26.104,key="!"},{time=26.245,key="$"},{time=26.279,key="!"},{time=26.384,key="$"},
    {time=26.406,key="!"},{time=26.441,key="!"},{time=26.488,key="!"},{time=26.754,key="%"},
    {time=26.791,key="!"},{time=27.000,key="^"}
}

-- ── Libra Heart 1 [911ノーツ / 0〜116s]
local notes_libra1 = {
    {time=0.000,key="^"},{time=0.011,key="@"},{time=0.011,key="q"},{time=0.093,key="Q"},
    {time=0.268,key="^"},{time=0.325,key="t"},{time=0.350,key="q"},{time=0.511,key="@"},
    {time=0.522,key="!"},{time=0.522,key="*"},{time=0.766,key="!"},{time=0.766,key="*"},
    {time=0.847,key="@"},{time=1.011,key="7"},{time=1.277,key="$"},{time=1.534,key="7"},
    {time=1.731,key="r"},{time=2.000,key="!"},{time=2.000,key="q"},{time=2.243,key="*"},
    {time=2.254,key="%"},{time=2.509,key="!"},{time=2.741,key="E"},{time=2.766,key="4"},
    {time=3.009,key="$"},{time=3.009,key="Q"},{time=3.147,key="!"},{time=3.159,key="W"},
    {time=3.497,key="*"},{time=3.497,key="Q"},{time=3.509,key="4"},{time=3.520,key="4"},
    {time=3.986,key="^"},{time=3.986,key="Q"},{time=3.997,key="@"},{time=4.079,key="Q"},
    {time=4.263,key="^"},{time=4.275,key="q"},{time=4.404,key="i"},{time=4.520,key="!"},
    {time=5.006,key="7"},{time=5.263,key="$"},{time=5.495,key="E"},{time=5.506,key="7"},
    {time=6.006,key="!"},{time=6.006,key="Q"},{time=6.006,key="I"},{time=6.122,key="Q"},
    {time=6.261,key="%"},{time=6.343,key="W"},{time=6.518,key="!"},{time=6.518,key="*"},
    {time=6.761,key="4"},{time=6.772,key="!"},{time=6.981,key="^"},{time=6.993,key="$"},
    {time=7.004,key="$"},{time=7.016,key="$"},{time=7.016,key="Q"},{time=7.329,key="I"},
    {time=7.506,key="4"},{time=7.506,key="Q"},{time=7.506,key="W"},{time=7.518,key="4"},
    {time=7.645,key="%"},{time=8.004,key="@"},{time=8.004,key="^"},{time=8.004,key="Q"},
    {time=8.016,key="q"},{time=8.097,key="Q"},{time=8.261,key="^"},{time=8.318,key="i"},
    {time=8.329,key="q"},{time=8.516,key="!"},{time=8.666,key="@"},{time=8.747,key="*"},
    {time=8.795,key="@"},{time=9.004,key="@"},{time=9.004,key="E"},{time=9.016,key="7"},
    {time=9.270,key="$"},{time=9.493,key="7"},{time=9.493,key="E"},{time=9.504,key="$"},
    {time=9.516,key="7"},{time=9.597,key="T"},{time=9.736,key="7"},{time=9.747,key="7"},
    {time=9.770,key="r"},{time=9.806,key="$"},{time=9.991,key="E"},{time=10.002,key="!"},
    {time=10.002,key="q"},{time=10.247,key="%"},{time=10.247,key="!"},{time=10.270,key="!"},
    {time=10.304,key="*"},{time=10.479,key="W"},{time=10.502,key="!"},{time=10.502,key="*"},
    {time=10.513,key="!"},{time=10.745,key="E"},{time=11.013,key="$"},{time=11.013,key="E"},
    {time=11.025,key="$"},{time=11.163,key="W"},{time=11.256,key="W"},{time=11.502,key="4"},
    {time=11.513,key="4"},{time=11.666,key="Q"},{time=11.745,key="*"},{time=11.770,key="W"},
    {time=11.781,key="4"},{time=11.897,key="W"},{time=11.977,key="@"},{time=11.991,key="^"},
    {time=12.002,key="("},{time=12.002,key="Q"},{time=12.081,key="Q"},{time=12.256,key="^"},
    {time=12.268,key="q"},{time=12.511,key="q"},{time=12.525,key="!"},{time=12.734,key="!"},
    {time=12.756,key="^"},{time=12.779,key="Q"},{time=12.929,key="7"},{time=13.011,key="7"},
    {time=13.034,key="Q"},{time=13.070,key="@"},{time=13.254,key="7"},{time=13.266,key="$"},
    {time=13.384,key="7"},{time=13.477,key="7"},{time=13.488,key="E"},{time=13.500,key="$"},
    {time=13.500,key="7"},{time=13.500,key="Q"},{time=13.756,key="7"},{time=13.768,key="7"},
    {time=13.884,key="7"},{time=14.011,key="!"},{time=14.011,key="^"},{time=14.243,key="^"},
    {time=14.254,key="Q"},{time=14.359,key="!"},{time=14.370,key="7"},{time=14.406,key="^"},
    {time=14.511,key="!"},{time=14.545,key="7"},{time=14.672,key="!"},{time=14.766,key="7"},
    {time=14.766,key="Q"},{time=14.847,key="!"},{time=14.859,key="7"},{time=14.952,key="!"},
    {time=14.997,key="$"},{time=15.009,key="$"},{time=15.034,key="1"},{time=15.034,key="Q"},
    {time=15.138,key="$"},{time=15.150,key="!"},{time=15.184,key="^"},{time=15.254,key="4"},
    {time=15.277,key="^"},{time=15.345,key="7"},{time=15.359,key="$"},{time=15.370,key="$"},
    {time=15.511,key="!"},{time=15.522,key="4"},{time=15.650,key="$"},{time=15.766,key="$"},
    {time=16.009,key="@"},{time=16.009,key="$"},{time=16.102,key="!"},{time=16.427,key="@"},
    {time=16.531,key="^"},{time=16.775,key="%"},{time=16.800,key="@"},{time=17.020,key="7"},
    {time=17.031,key="7"},{time=17.066,key="$"},{time=17.497,key="!"},{time=17.659,key="("},
    {time=17.729,key="@"},{time=17.775,key="7"},{time=17.786,key="^"},{time=17.938,key="!"},
    {time=18.020,key="!"},{time=18.100,key="!"},{time=18.345,key="%"},{time=18.472,key="!"},
    {time=18.495,key="!"},{time=18.891,key="7"},{time=19.029,key="^"},{time=19.041,key="$"},
    {time=19.261,key="$"},{time=19.295,key="!"},{time=19.331,key="4"},{time=19.472,key="%"},
    {time=19.727,key="4"},{time=19.995,key="$"},{time=20.041,key="!"},{time=20.097,key="$"},
    {time=20.795,key="^"},{time=21.027,key="7"},{time=21.027,key="^"},{time=21.538,key="7"},
    {time=21.538,key="@"},{time=21.563,key="$"},{time=22.027,key="^"},{time=22.038,key="!"},
    {time=22.086,key="!"},{time=22.236,key="!"},{time=22.352,key="^"},{time=22.375,key="4"},
    {time=22.386,key="!"},{time=22.725,key="%"},{time=22.816,key="%"},{time=22.816,key="7"},
    {time=23.036,key="^"},{time=23.095,key="$"},{time=23.491,key="%"},{time=23.502,key="7"},
    {time=23.584,key="4"},{time=24.025,key="^"},{time=24.397,key="^"},{time=24.502,key="@"},
    {time=24.756,key="^"},{time=25.011,key="7"},{time=25.047,key="7"},{time=25.268,key="$"},
    {time=25.559,key="^"},{time=25.581,key="$"},{time=25.779,key="7"},{time=26.000,key="^"},
    {time=26.104,key="!"},{time=26.245,key="$"},{time=26.279,key="!"},{time=26.384,key="$"},
    {time=26.406,key="!"},{time=26.441,key="!"},{time=26.488,key="!"},{time=26.754,key="%"},
    {time=26.791,key="!"},{time=27.000,key="^"},{time=27.011,key="$"},{time=27.045,key="$"},
    {time=27.511,key="%"},{time=27.766,key="$"},{time=28.056,key="^"},{time=28.091,key="$"},
    {time=28.393,key="^"},{time=28.497,key="^"},{time=28.766,key="^"},{time=29.020,key="7"},
    {time=29.509,key="^"},{time=29.568,key="$"},{time=29.661,key="7"},{time=29.752,key="7"},
    {time=30.043,key="^"},{time=30.043,key="!"},{time=30.159,key="!"},{time=30.229,key="!"},
    {time=30.345,key="$"},{time=30.506,key="!"},{time=30.763,key="$"},{time=30.868,key="%"},
    {time=31.006,key="$"},{time=31.216,key="$"},{time=31.763,key="!"},{time=31.995,key="@"},
    {time=32.077,key="$"},{time=32.088,key="$"},{time=32.193,key="!"},{time=32.377,key="^"},
    {time=32.436,key="!"},{time=32.772,key="%"},{time=32.795,key="@"},{time=33.004,key="$"},
    {time=33.016,key="7"},{time=33.493,key="!"},{time=33.656,key="@"},{time=33.843,key="^"},
    {time=33.981,key="!"},{time=34.086,key="!"},{time=34.377,key="!"},{time=34.388,key="%"},
    {time=34.456,key="@"},{time=34.572,key="!"},{time=34.631,key="!"},{time=34.770,key="^"},
    {time=34.795,key="4"},{time=35.038,key="^"},{time=35.236,key="4"},{time=35.584,key="%"},
    {time=35.991,key="$"},{time=36.095,key="$"},{time=36.781,key="@"},{time=36.793,key="@"},
    {time=36.793,key="^"},{time=37.141,key="!"},{time=37.584,key="$"},{time=37.606,key="$"},
    {time=37.652,key="7"},{time=38.002,key="^"},{time=38.002,key="4"},{time=38.106,key="!"},
    {time=38.141,key="Q"},{time=38.234,key="!"},{time=38.350,key="$"},{time=38.720,key="$"},
    {time=38.756,key="%"},{time=38.825,key="%"},{time=38.872,key="@"},{time=39.034,key="$"},
    {time=39.034,key="^"},{time=39.056,key="$"},{time=39.511,key="%"},{time=39.593,key="7"},
    {time=39.638,key="4"},{time=40.000,key="@"},{time=40.034,key="^"},{time=40.381,key="^"},
    {time=40.522,key="!"},{time=40.766,key="^"},{time=41.056,key="^"},{time=41.266,key="$"},
    {time=41.266,key="7"},{time=41.497,key="^"},{time=41.591,key="$"},{time=41.754,key="7"},
    {time=41.997,key="^"},{time=42.068,key="!"},{time=42.147,key="!"},{time=42.277,key="!"},
    {time=42.381,key="4"},{time=42.531,key="!"},{time=42.763,key="4"},{time=43.020,key="$"},
    {time=43.043,key="$"},{time=43.054,key="^"},{time=43.497,key="%"},{time=43.763,key="$"},
    {time=44.100,key="^"},{time=44.275,key="@"},{time=44.391,key="^"},{time=44.495,key="^"},
    {time=45.577,key="$"},{time=45.772,key="7"},{time=46.052,key="!"},{time=46.063,key="!"},
    {time=46.086,key="Q"},{time=46.134,key="^"},{time=46.250,key="%"},{time=46.261,key="!"},
    {time=46.354,key="$"},{time=46.527,key="!"},{time=46.806,key="%"},{time=46.888,key="%"},
    {time=46.993,key="$"},{time=47.097,key="$"},{time=47.238,key="@"},{time=47.597,key="4"},
    {time=48.016,key="$"},{time=48.050,key="@"},{time=48.259,key="^"},{time=48.411,key="$"},
    {time=48.411,key="^"},{time=48.527,key="4"},{time=48.527,key="!"},{time=48.700,key="@"},
    {time=48.804,key="@"},{time=49.002,key="7"},{time=49.050,key="!"},{time=49.106,key="7"},
    {time=49.259,key="7"},{time=49.259,key="!"},{time=49.259,key="$"},{time=49.397,key="!"},
    {time=49.434,key="$"},{time=49.502,key="7"},{time=49.759,key="7"},{time=49.759,key="@"},
    {time=50.002,key="!"},{time=50.177,key="!"},{time=50.256,key="%"},{time=50.281,key="^"},
    {time=50.431,key="%"},{time=50.454,key="%"},{time=50.525,key="!"},{time=50.791,key="^"},
    {time=50.906,key="^"},{time=50.988,key="^"},{time=51.011,key="$"},{time=51.316,key="7"},
    {time=51.502,key="4"},{time=51.513,key="4"},{time=51.525,key="@"},{time=51.768,key="4"},
    {time=52.022,key="@"},{time=52.047,key="$"},{time=52.268,key="^"},{time=52.522,key="!"},
    {time=52.836,key="4"},{time=52.952,key="$"},{time=52.986,key="7"},{time=53.127,key="%"},
    {time=53.254,key="$"},{time=53.384,key="$"},{time=53.488,key="7"},{time=53.511,key="7"},
    {time=53.754,key="%"},{time=54.022,key="!"},{time=54.034,key="%"},{time=54.161,key="^"},
    {time=54.370,key="%"},{time=54.520,key="!"},{time=54.579,key="%"},{time=54.684,key="$"},
    {time=54.766,key="$"},{time=55.520,key="4"},{time=55.752,key="4"},{time=56.009,key="$"},
    {time=56.136,key="@"},{time=56.518,key="!"},{time=56.775,key="4"},{time=57.018,key="@"},
    {time=57.041,key="7"},{time=57.275,key="$"},{time=57.368,key="!"},{time=57.566,key="$"},
    {time=57.566,key="7"},{time=57.752,key="@"},{time=58.063,key="!"},{time=58.156,key="!"},
    {time=58.250,key="!"},{time=58.320,key="!"},{time=58.425,key="%"},{time=58.506,key="!"},
    {time=58.518,key="!"},{time=58.772,key="7"},{time=59.027,key="$"},{time=59.063,key="$"},
    {time=59.097,key="^"},{time=59.518,key="@"},{time=59.738,key="4"},{time=60.004,key="$"},
    {time=60.284,key="^"},{time=60.352,key="@"},{time=60.781,key="$"},{time=60.991,key="%"},
    {time=61.016,key="7"},{time=61.259,key="$"},{time=61.375,key="$"},{time=61.493,key="$"},
    {time=61.550,key="7"},{time=61.747,key="%"},{time=62.084,key="!"},{time=62.166,key="^"},
    {time=62.234,key="!"},{time=62.397,key="!"},{time=62.420,key="%"},{time=62.711,key="$"},
    {time=62.816,key="!"},{time=62.838,key="4"},{time=63.070,key="$"},{time=63.338,key="^"},
    {time=63.502,key="^"},{time=63.756,key="7"},{time=64.002,key="@"},{time=64.025,key="^"},
    {time=64.291,key="^"},{time=64.511,key="^"},{time=64.511,key="!"},{time=64.836,key="$"},
    {time=65.034,key="7"},{time=65.045,key="7"},{time=65.302,key="$"},{time=65.570,key="^"},
    {time=65.731,key="%"},{time=65.859,key="$"},{time=66.000,key="!"},{time=66.079,key="^"},
    {time=66.093,key="!"},{time=66.243,key="!"},{time=66.254,key="%"},{time=66.370,key="$"},
    {time=66.381,key="!"},{time=66.441,key="4"},{time=66.522,key="!"},{time=66.627,key="!"},
    {time=66.754,key="%"},{time=66.893,key="%"},{time=67.043,key="^"},{time=67.172,key="$"},
    {time=67.243,key="$"},{time=67.393,key="^"},{time=67.520,key="^"},{time=67.534,key="4"},
    {time=67.822,key="$"},{time=68.043,key="^"},{time=68.311,key="$"},{time=68.566,key="^"},
    {time=68.811,key="$"},{time=68.995,key="7"},{time=69.054,key="^"},{time=69.159,key="7"},
    {time=69.170,key="%"},{time=69.531,key="^"},{time=70.077,key="!"},{time=70.077,key="^"},
    {time=70.238,key="%"},{time=70.252,key="!"},{time=70.343,key="!"},{time=70.391,key="!"},
    {time=70.668,key="$"},{time=70.750,key="$"},{time=70.854,key="%"},{time=71.041,key="$"},
    {time=71.518,key="^"},{time=71.761,key="7"},{time=72.018,key="7"},{time=72.041,key="@"},
    {time=72.238,key="7"},{time=72.354,key="^"},{time=72.643,key="^"},{time=72.806,key="7"},
    {time=73.016,key="7"},{time=73.075,key="^"},{time=73.261,key="$"},{time=73.504,key="^"},
    {time=73.759,key="7"},{time=73.829,key="@"},{time=74.016,key="!"},{time=74.050,key="!"},
    {time=74.166,key="!"},{time=74.236,key="!"},{time=74.236,key="7"},{time=74.352,key="^"},
    {time=74.375,key="4"},{time=74.513,key="!"},{time=74.561,key="!"},{time=74.897,key="7"},
    {time=75.013,key="$"},{time=75.025,key="$"},{time=75.025,key="^"},{time=75.572,key="^"},
    {time=75.584,key="@"},{time=75.745,key="7"},{time=75.770,key="4"},{time=75.991,key="@"},
    {time=76.002,key="7"},{time=76.129,key="!"},{time=76.234,key="$"},{time=76.350,key="^"},
    {time=76.502,key="$"},{time=76.606,key="^"},{time=76.734,key="7"},{time=76.756,key="$"},
    {time=77.011,key="7"},{time=77.022,key="!"},{time=77.234,key="7"},{time=77.536,key="^"},
    {time=77.570,key="$"},{time=77.756,key="7"},{time=77.779,key="7"},{time=77.779,key="@"},
    {time=78.000,key="!"},{time=78.034,key="!"},{time=78.070,key="!"},{time=78.254,key="!"},
    {time=78.302,key="4"},{time=78.302,key="%"},{time=78.325,key="!"},{time=78.441,key="!"},
    {time=78.511,key="%"},{time=78.593,key="%"},{time=78.593,key="!"},{time=78.743,key="%"},
    {time=78.847,key="$"},{time=78.881,key="^"},{time=79.011,key="$"},{time=79.011,key="^"},
    {time=79.488,key="4"},{time=79.709,key="%"},{time=80.009,key="$"},{time=80.009,key="^"},
    {time=80.022,key="@"},{time=80.102,key="Q"},{time=80.266,key="^"},{time=80.520,key="!"},
    {time=80.520,key="q"},{time=80.986,key="7"},{time=81.045,key="7"},{time=81.102,key="E"},
    {time=81.125,key="@"},{time=81.266,key="$"},{time=81.509,key="7"},{time=81.591,key="$"},
    {time=81.591,key="*"},{time=81.602,key="T"},{time=81.741,key="r"},{time=81.856,key="$"},
    {time=81.997,key="$"},{time=81.997,key="E"},{time=82.009,key="!"},{time=82.009,key="*"},
    {time=82.009,key="q"},{time=82.100,key="T"},{time=82.241,key="*"},{time=82.263,key="%"},
    {time=82.322,key="T"},{time=82.484,key="W"},{time=82.495,key="!"},{time=82.506,key="!"},
    {time=82.506,key="*"},{time=82.659,key="%"},{time=82.752,key="E"},{time=82.775,key="4"},
    {time=83.009,key="$"},{time=83.020,key="$"},{time=83.054,key="W"},{time=83.136,key="!"},
    {time=83.159,key="W"},{time=83.241,key="*"},{time=83.518,key="4"},{time=83.529,key="4"},
    {time=83.786,key="4"},{time=83.984,key="4"},{time=83.984,key="^"},{time=83.995,key="@"},
    {time=84.006,key="@"},{time=84.075,key="Q"},{time=84.204,key="i"},{time=84.272,key="^"},
    {time=84.272,key="q"},{time=84.320,key="t"},{time=84.518,key="!"},{time=84.518,key="q"},
    {time=84.738,key="*"},{time=84.772,key="Q"},{time=84.854,key="@"},{time=84.995,key="7"},
    {time=84.995,key="@"},{time=85.006,key="7"},{time=85.018,key="Q"},{time=85.075,key="T"},
    {time=85.250,key="*"},{time=85.261,key="$"},{time=85.459,key="*"},{time=85.493,key="7"},
    {time=85.541,key="7"},{time=86.004,key="!"},{time=86.004,key="*"},{time=86.004,key="Q"},
    {time=86.004,key="I"},{time=86.259,key="%"},{time=86.352,key="!"},{time=86.516,key="!"},
    {time=86.516,key="*"},{time=86.527,key="!"},{time=86.770,key="4"},{time=86.793,key="E"},
    {time=86.829,key="P"},{time=86.852,key="!"},{time=86.981,key="*"},{time=86.993,key="^"},
    {time=87.004,key="$"},{time=87.038,key="Q"},{time=87.050,key="I"},{time=87.225,key="$"},
    {time=87.491,key="4"},{time=87.504,key="4"},{time=87.504,key="%"},{time=87.527,key="T"},
    {time=87.759,key="*"},{time=88.013,key="@"},{time=88.013,key="^"},{time=88.013,key="q"},
    {time=88.025,key="E"},{time=88.106,key="Q"},{time=88.211,key="q"},{time=88.270,key="^"},
    {time=88.304,key="q"},{time=88.513,key="*"},{time=88.525,key="!"},{time=88.663,key="@"},
    {time=88.745,key="*"},{time=89.002,key="7"},{time=89.002,key="@"},{time=89.002,key="E"},
    {time=89.084,key="i"},{time=89.259,key="$"},{time=89.375,key="*"},{time=89.513,key="7"},
    {time=89.595,key="Q"},{time=89.595,key="T"},{time=89.606,key="*"},{time=89.768,key="r"},
    {time=89.827,key="7"},{time=89.943,key="!"},{time=90.000,key="!"},{time=90.000,key="E"},
    {time=90.013,key="!"},{time=90.013,key="*"},{time=90.104,key="T"},{time=90.245,key="*"},
    {time=90.256,key="!"},{time=90.268,key="%"},{time=90.488,key="W"},{time=90.511,key="!"},
    {time=90.559,key="E"},{time=90.754,key="4"},{time=91.000,key="$"},{time=91.000,key="Q"},
    {time=91.011,key="$"},{time=91.129,key="!"},{time=91.152,key="W"},{time=91.256,key="W"},
    {time=91.511,key="4"},{time=91.522,key="4"},{time=91.825,key="O"},{time=91.988,key="^"},
    {time=92.000,key="@"},{time=92.000,key="q"},{time=92.056,key="E"},{time=92.079,key="Q"},
    {time=92.195,key="^"},{time=92.195,key="q"},{time=92.266,key="^"},{time=92.277,key="q"},
    {time=92.313,key="i"},{time=92.497,key="q"},{time=92.509,key="^"},{time=92.509,key="!"},
    {time=92.509,key="*"},{time=92.613,key="^"},{time=92.729,key="*"},{time=92.766,key="^"},
    {time=92.766,key="Q"},{time=92.986,key="7"},{time=93.000,key="7"},{time=93.011,key="@"},
    {time=93.243,key="7"},{time=93.254,key="$"},{time=93.254,key="*"},{time=93.336,key="T"},
    {time=93.404,key="7"},{time=93.486,key="7"},{time=93.497,key="7"},{time=93.672,key="7"},
    {time=93.766,key="7"},{time=93.777,key="*"},{time=93.870,key="$"},{time=93.997,key="^"},
    {time=93.997,key="!"},{time=93.997,key="Q"},{time=94.009,key="!"},{time=94.195,key="7"},
    {time=94.252,key="!"},{time=94.252,key="%"},{time=94.368,key="7"},{time=94.416,key="^"},
    {time=94.531,key="7"},{time=94.659,key="Q"},{time=94.938,key="!"},{time=95.009,key="$"},
    {time=95.020,key="7"},{time=95.091,key="Q"},{time=95.206,key="7"},{time=95.263,key="4"},
    {time=95.356,key="4"},{time=95.450,key="$"},{time=95.495,key="!"},{time=95.531,key="$"},
    {time=95.611,key="!"},{time=95.704,key="$"},{time=95.729,key="!"},{time=95.845,key="$"},
    {time=96.018,key="@"},{time=96.145,key="!"},{time=96.761,key="%"},{time=96.866,key="@"},
    {time=96.995,key="$"},{time=97.006,key="7"},{time=97.077,key="7"},{time=97.145,key="!"},
    {time=97.611,key="*"},{time=97.668,key="@"},{time=97.750,key="@"},{time=97.784,key="^"},
    {time=97.993,key="!"},{time=98.052,key="!"},{time=98.109,key="!"},{time=98.225,key="!"},
    {time=98.343,key="!"},{time=98.377,key="%"},{time=98.400,key="@"},{time=98.609,key="%"},
    {time=98.772,key="^"},{time=98.772,key="4"},{time=99.027,key="$"},{time=99.041,key="^"},
    {time=99.261,key="$"},{time=99.284,key="4"},{time=99.516,key="@"},{time=99.561,key="$"},
    {time=99.586,key="%"},{time=99.991,key="$"},{time=100.004,key="^"},{time=100.236,key="!"},
    {time=100.479,key="4"},{time=100.770,key="^"},{time=100.827,key="@"},{time=101.002,key="^"},
    {time=101.154,key="!"},{time=101.491,key="$"},{time=101.572,key="7"},{time=101.759,key="$"},
    {time=102.025,key="^"},{time=102.059,key="!"},{time=102.070,key="4"},{time=102.372,key="$"},
    {time=102.409,key="!"},{time=102.525,key="!"},{time=102.559,key="!"},{time=102.734,key="$"},
    {time=102.850,key="%"},{time=102.991,key="$"},{time=103.047,key="^"},{time=103.500,key="%"},
    {time=103.581,key="7"},{time=104.011,key="@"},{time=104.011,key="^"},{time=104.406,key="^"},
    {time=104.754,key="^"},{time=105.022,key="7"},{time=105.418,key="^"},{time=105.511,key="^"},
    {time=105.556,key="$"},{time=105.788,key="7"},{time=105.941,key="^"},{time=106.009,key="^"},
    {time=106.161,key="!"},{time=106.288,key="!"},{time=106.393,key="!"},{time=106.393,key="$"},
    {time=106.486,key="!"},{time=106.497,key="!"},{time=106.741,key="%"},{time=107.009,key="^"},
    {time=107.031,key="$"},{time=107.056,key="$"},{time=107.520,key="%"},{time=107.741,key="$"},
    {time=108.043,key="^"},{time=108.413,key="^"},{time=108.750,key="^"},{time=108.984,key="^"},
    {time=109.006,key="7"},{time=109.600,key="$"},{time=109.611,key="7"},{time=109.727,key="7"},
    {time=110.063,key="^"},{time=110.122,key="!"},{time=110.238,key="!"},{time=110.331,key="!"},
    {time=110.400,key="$"},{time=110.518,key="!"},{time=110.772,key="$"},{time=110.843,key="%"},
    {time=111.041,key="$"},{time=111.063,key="$"},{time=111.320,key="$"},{time=111.320,key="!"},
    {time=111.841,key="$"},{time=111.981,key="$"},{time=112.004,key="$"},{time=112.016,key="@"},
    {time=112.759,key="%"},{time=112.784,key="@"},{time=112.993,key="$"},{time=113.004,key="7"},
    {time=113.038,key="7"},{time=113.038,key="!"},{time=113.527,key="!"},{time=113.654,key="@"},
    {time=113.781,key="^"},{time=113.841,key="@"},{time=113.979,key="!"},{time=114.072,key="%"},
    {time=114.106,key="!"},{time=114.234,key="!"},{time=114.409,key="@"},{time=114.409,key="%"},
    {time=114.502,key="!"},{time=114.629,key="%"},{time=114.663,key="!"},{time=114.781,key="4"},
    {time=114.804,key="^"},{time=114.979,key="^"},{time=115.245,key="4"},{time=115.256,key="!"},
    {time=115.491,key="$"},{time=115.641,key="%"},{time=115.686,key="@"},{time=115.768,key="$"},
    {time=115.779,key="!"},{time=116.000,key="^"},{time=116.070,key="^"}
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
LT:CreateButton({ Name="▶  Part 3 [60-90s]",           Callback=function()
    local p={} for _,n in ipairs(notes_libra1) do if n.time>=60 and n.time<=90 then p[#p+1]={time=n.time-60,key=n.key} end end
    playSong(p,"Libra Heart [P3]") end })
LT:CreateButton({ Name="▶  FINALE [90-116s]",          Callback=function()
    local p={} for _,n in ipairs(notes_libra1) do if n.time>=90 then p[#p+1]={time=n.time-90,key=n.key} end end
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
