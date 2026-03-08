-- ==============================================================
--   🎸 Libra Heart Enhanced v4  [16曲収録 + MIDIインポート対応]
--   Virtual Piano Player  ―  Rayfield UI
--
--   Libra Heart 1 : ~720 notes / 0〜225s  ★大幅補完済み
--   Libra Heart 2 : 70 notes  ★左右同期修正済み
--   童謡クラシック5曲 (変更なし)
--   J-Pop/Anime 8曲 ★全曲修正・延長済み
--   MIDIファイル曲 : 自動変換ノーツ (805notes / ~149s)
--
--   ピアノ鍵盤レイアウト (画像準拠):
--   黒鍵: ! @ $ % ^ * ( Q W E T Y I O P S D G H J L Z C V B
--   白鍵: 1 2 3 4 5 6 7 8 9 0 q w e r t y u i o p a s d f g h j k l z x c v b n m
-- ==============================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local VIM      = game:GetService("VirtualInputManager")
local Players  = game:GetService("Players")

-- ══════════════════════════════════════════════════════════════
--  キーコードマップ (画像レイアウト準拠)
-- ══════════════════════════════════════════════════════════════
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
-- MIDIピッチ→キー変換テーブル (MIDI 60=C4="1")
local PITCH = {
    ["1"]=60,["!"]=61,["2"]=62,["@"]=63,["3"]=64,["4"]=65,["$"]=66,
    ["5"]=67,["%"]=68,["6"]=69,["^"]=70,["7"]=71,["8"]=72,["*"]=73,
    ["9"]=74,["("]=75,["0"]=76,["q"]=77,["Q"]=78,["w"]=79,["W"]=80,
    ["e"]=81,["E"]=82,["r"]=83,["t"]=84,["T"]=85,["y"]=86,["Y"]=87,
    ["u"]=88,["i"]=89,["I"]=90,["o"]=91,["O"]=92,["p"]=93,["P"]=94,["a"]=95,
}
-- 逆引き: MIDI pitch → key string
local MIDI_TO_KEY = {}
for k,v in pairs(PITCH) do MIDI_TO_KEY[v] = k end

-- ══════════════════════════════════════════════════════════════
--  ユーティリティ関数
-- ══════════════════════════════════════════════════════════════
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

-- MIDIピッチ(数値)→キー文字変換 (オクターブ自動調整)
local function midiPitchToKey(pitch)
    local p = pitch
    while p < 60 do p = p + 12 end
    while p > 95 do p = p - 12 end
    return MIDI_TO_KEY[p]
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
    if f then
        task.spawn(function() task.wait(0.3);sitAt(f) end)
        Rayfield:Notify({Title="🎹 Setup",Content="ピアノ発見！着席します",Duration=3,Image="rbxassetid://4483345998"})
    else
        Rayfield:Notify({Title="🎹 Setup",Content="手動でピアノに近づいてください",Duration=4,Image="rbxassetid://4483345998"})
    end
end

-- ══════════════════════════════════════════════════════════════
--  再生エンジン
-- ══════════════════════════════════════════════════════════════
local speedMult  = 1.0
local isPlaying  = false
local stopFlag   = false
local currentSong = ""

local function setSpeed(s)
    speedMult = s
    local lbl = {[0.5]="🐌 超スロー",[0.75]="🐢 スロー",[1.0]="▶ 通常",
                 [1.25]="⚡ 速め",[1.5]="⚡⚡ 速い",[2.0]="🚀 2倍"}
    Rayfield:Notify({Title="⚡ Speed: "..s.."x",Content=lbl[s] or ("x"..s),Duration=2,Image="rbxassetid://4483345998"})
end

local function melodyOnly(notes)
    local out={}; local i=1
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

local function playSong(notes,title)
    if isPlaying then
        Rayfield:Notify({Title="⚠ 再生中",Content=currentSong.." 演奏中",Duration=2,Image="rbxassetid://4483345998"})
        return
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
    if isPlaying then
        stopFlag=true; isPlaying=false
        Rayfield:Notify({Title="⏹ 停止",Content=currentSong,Duration=2,Image="rbxassetid://4483345998"})
        currentSong=""
    else
        Rayfield:Notify({Title="ℹ 待機中",Content="再生中の曲はありません",Duration=2,Image="rbxassetid://4483345998"})
    end
end


-- ═══════════════════════════════════════════════════════════════
--  ノーツデータ
-- ═══════════════════════════════════════════════════════════════

-- ══════════════════════════════════════════════════════════════
-- ★ Libra Heart 2  [完全修正版]
-- ══════════════════════════════════════════════════════════════
local notes_libra2 = {
    {time=0.000,key="Q"},{time=0.010,key="@"},
    {time=0.500,key="q"},{time=0.510,key="^"},
    {time=1.000,key="*"},{time=1.010,key="!"},
    {time=1.500,key="*"},{time=1.510,key="^"},
    {time=2.000,key="r"},{time=2.010,key="@"},
    {time=2.500,key="E"},{time=2.510,key="^"},
    {time=3.000,key="W"},{time=3.010,key="!"},
    {time=3.500,key="E"},{time=3.510,key="^"},
    {time=4.000,key="W"},{time=4.010,key="@"},
    {time=4.500,key="Q"},{time=4.510,key="^"},
    {time=5.000,key="Q"},{time=5.010,key="!"},
    {time=5.583,key="q"},{time=5.593,key="^"},
    {time=6.167,key="*"},{time=6.177,key="!"},
    {time=6.750,key="Q"},{time=6.760,key="7"},
    {time=7.333,key="W"},{time=7.343,key="$"},
    {time=7.917,key="Q"},{time=7.927,key="7"},
    {time=8.500,key="Q"},{time=8.510,key="$"},
    {time=9.000,key="q"},{time=9.010,key="7"},
    {time=9.500,key="*"},{time=9.510,key="$"},
    {time=10.000,key="*"},{time=10.010,key="7"},
    {time=10.500,key="r"},{time=10.510,key="$"},
    {time=11.000,key="E"},{time=11.010,key="7"},
    {time=11.500,key="W"},{time=11.510,key="$"},
    {time=12.000,key="E"},{time=12.010,key="7"},
    {time=12.500,key="W"},{time=12.510,key="$"},
    {time=13.000,key="Q"},{time=13.010,key="7"},
    {time=13.500,key="Q"},{time=13.510,key="$"},
    {time=14.083,key="q"},{time=14.093,key="!"},
    {time=14.667,key="*"},{time=14.677,key="%"},
    {time=15.250,key="Q"},{time=15.260,key="!"},
    {time=15.833,key="W"},{time=15.843,key="%"},
    {time=16.417,key="Q"},{time=16.427,key="!"},
    {time=17.000,key="Q"},{time=17.010,key="%"},
    {time=17.500,key="q"},{time=17.510,key="!"},
    {time=18.000,key="*"},{time=18.010,key="%"},
    {time=18.500,key="*"},{time=18.510,key="!"},
    {time=19.000,key="r"},{time=19.010,key="%"},
    {time=19.500,key="E"},{time=19.510,key="!"},
    {time=20.000,key="W"},{time=20.010,key="%"},
    {time=20.500,key="E"},{time=20.510,key="$"},
    {time=21.000,key="W"},{time=21.010,key="!"},
    {time=21.500,key="Q"},{time=21.510,key="4"},
    {time=22.000,key="Q"},{time=22.010,key="!"},
    {time=22.583,key="q"},{time=22.593,key="$"},
    {time=23.167,key="*"},{time=23.177,key="!"},
    {time=23.750,key="Q"},{time=23.760,key="4"},
    {time=24.333,key="W"},{time=24.343,key="!"},
    {time=24.917,key="Q"},{time=24.927,key="$"},
    {time=25.500,key="Q"},{time=25.510,key="!"},
    {time=26.000,key="*"},{time=26.010,key="^"},
    {time=26.500,key="W"},{time=26.510,key="%"},
    {time=27.000,key="Q"},{time=27.010,key="!"},
}


-- ── 夜に駆ける (YOASOBI / BPM=130 / ~32s) ───────────────────
local notes_yoru = {
    -- Intro/Verse A (0〜8s) Am→F→C→G進行
    {time=0.000,key="e"},{time=0.010,key="6"},
    {time=0.462,key="e"},{time=0.923,key="r"},
    {time=1.385,key="e"},{time=1.846,key="0"},
    {time=2.308,key="9"},{time=2.769,key="8"},
    {time=3.231,key="9"},{time=3.692,key="e"},
    {time=4.154,key="r"},{time=4.154,key="4"},
    {time=4.615,key="e"},{time=5.077,key="r"},
    {time=5.538,key="e"},{time=6.000,key="0"},
    {time=6.462,key="q"},{time=6.923,key="0"},
    {time=7.385,key="9"},{time=7.846,key="8"},
    -- Pre-chorus (8〜16s)
    {time=8.308,key="w"},{time=8.308,key="5"},
    {time=8.769,key="w"},{time=9.231,key="e"},
    {time=9.692,key="w"},{time=10.154,key="9"},
    {time=10.615,key="0"},{time=11.077,key="9"},
    {time=11.538,key="8"},{time=12.000,key="9"},
    {time=12.462,key="e"},{time=12.462,key="6"},
    {time=12.923,key="e"},{time=13.385,key="r"},
    {time=13.846,key="e"},{time=14.308,key="0"},
    {time=14.769,key="9"},{time=15.231,key="8"},
    {time=15.692,key="9"},{time=16.000,key="e"},
    -- Chorus (16〜24s) ★サビ
    {time=16.000,key="r"},{time=16.000,key="3"},
    {time=16.462,key="e"},{time=16.923,key="r"},
    {time=17.385,key="w"},{time=17.846,key="e"},
    {time=18.308,key="0"},{time=18.308,key="5"},
    {time=18.769,key="9"},{time=19.231,key="0"},
    {time=19.692,key="q"},{time=20.154,key="0"},
    {time=20.615,key="9"},{time=20.615,key="4"},
    {time=21.077,key="8"},{time=21.538,key="9"},
    {time=22.000,key="w"},{time=22.000,key="5"},
    {time=22.462,key="e"},{time=22.923,key="w"},
    {time=23.385,key="9"},{time=23.846,key="0"},
    -- Outro (24〜32s)
    {time=24.308,key="e"},{time=24.308,key="6"},
    {time=24.769,key="r"},{time=25.231,key="e"},
    {time=25.692,key="0"},{time=26.154,key="9"},
    {time=26.615,key="8"},{time=27.077,key="9"},
    {time=27.538,key="e"},{time=27.538,key="3"},
    {time=28.000,key="r"},{time=28.462,key="e"},
    {time=28.923,key="w"},{time=29.385,key="9"},
    {time=29.846,key="0"},{time=30.308,key="q"},
    {time=30.769,key="0"},{time=31.231,key="9"},
    {time=31.692,key="8"},{time=32.000,key="e"},
}

-- ── うっせぇわ (Ado / BPM=175 / ~28s) ───────────────────────
local notes_ussewa = {
    -- Intro (0〜4s)
    {time=0.000,key="3"},{time=0.343,key="3"},{time=0.686,key="4"},
    {time=1.029,key="5"},{time=1.371,key="6"},{time=1.714,key="5"},
    {time=2.057,key="4"},{time=2.400,key="3"},{time=2.743,key="2"},
    {time=3.086,key="3"},{time=3.429,key="3"},{time=3.771,key="4"},
    -- Verse (4〜12s)
    {time=4.114,key="5"},{time=4.114,key="2"},
    {time=4.457,key="6"},{time=4.800,key="5"},
    {time=5.143,key="4"},{time=5.486,key="5"},
    {time=5.829,key="6"},{time=6.171,key="7"},
    {time=6.514,key="6"},{time=6.514,key="3"},
    {time=6.857,key="5"},{time=7.200,key="4"},
    {time=7.543,key="3"},{time=7.886,key="2"},
    {time=8.229,key="3"},{time=8.229,key="2"},
    {time=8.571,key="4"},{time=8.914,key="5"},
    {time=9.257,key="6"},{time=9.600,key="5"},
    {time=9.943,key="4"},{time=10.286,key="3"},
    {time=10.629,key="2"},{time=10.971,key="1"},
    -- Pre-chorus (12〜20s)
    {time=11.314,key="3"},{time=11.314,key="5"},
    {time=11.657,key="4"},{time=12.000,key="5"},
    {time=12.343,key="6"},{time=12.686,key="7"},
    {time=13.029,key="8"},{time=13.029,key="5"},
    {time=13.371,key="7"},{time=13.714,key="6"},
    {time=14.057,key="5"},{time=14.400,key="4"},
    {time=14.743,key="3"},{time=15.086,key="4"},
    {time=15.429,key="5"},{time=15.771,key="6"},
    -- Chorus サビ (20〜28s)
    {time=16.114,key="8"},{time=16.114,key="5"},
    {time=16.457,key="9"},{time=16.800,key="8"},
    {time=17.143,key="7"},{time=17.486,key="6"},
    {time=17.829,key="5"},{time=18.171,key="6"},
    {time=18.514,key="7"},{time=18.514,key="4"},
    {time=18.857,key="8"},{time=19.200,key="9"},
    {time=19.543,key="8"},{time=19.886,key="7"},
    {time=20.229,key="6"},{time=20.571,key="5"},
    {time=20.914,key="4"},{time=21.257,key="3"},
    {time=21.600,key="4"},{time=21.600,key="5"},
    {time=21.943,key="5"},{time=22.286,key="6"},
    {time=22.629,key="7"},{time=22.971,key="8"},
    {time=23.314,key="9"},{time=23.657,key="8"},
    {time=24.000,key="7"},{time=24.343,key="6"},
    {time=24.686,key="5"},{time=25.029,key="4"},
    {time=25.371,key="3"},{time=25.714,key="2"},
    {time=26.057,key="1"},{time=26.400,key="2"},
    {time=26.743,key="3"},{time=27.086,key="4"},
    {time=27.429,key="3"},{time=27.771,key="2"},
    {time=28.000,key="1"},
}

-- ── 廻廻奇譚 (Eve / 呪術廻戦 / BPM=145 / ~30s) ─────────────
local notes_kaikai = {
    -- Intro (0〜6s)
    {time=0.000,key="9"},{time=0.414,key="9"},{time=0.828,key="0"},
    {time=1.241,key="q"},{time=1.655,key="0"},{time=2.069,key="9"},
    {time=2.483,key="8"},{time=2.897,key="9"},{time=3.310,key="0"},
    {time=3.724,key="q"},{time=4.138,key="w"},{time=4.552,key="q"},
    {time=4.966,key="0"},{time=5.379,key="9"},{time=5.793,key="8"},
    -- Verse (6〜14s)
    {time=6.207,key="9"},{time=6.207,key="5"},
    {time=6.621,key="0"},{time=7.034,key="q"},
    {time=7.448,key="0"},{time=7.862,key="9"},
    {time=8.276,key="8"},{time=8.276,key="4"},
    {time=8.690,key="7"},{time=9.103,key="8"},
    {time=9.517,key="9"},{time=9.931,key="8"},
    {time=10.345,key="7"},{time=10.345,key="3"},
    {time=10.759,key="6"},{time=11.172,key="7"},
    {time=11.586,key="8"},{time=12.000,key="9"},
    {time=12.414,key="0"},{time=12.414,key="5"},
    {time=12.828,key="q"},{time=13.241,key="0"},
    {time=13.655,key="9"},{time=14.069,key="8"},
    -- Chorus (14〜22s)
    {time=14.483,key="q"},{time=14.483,key="6"},
    {time=14.897,key="0"},{time=15.310,key="9"},
    {time=15.724,key="8"},{time=16.138,key="9"},
    {time=16.552,key="0"},{time=16.552,key="5"},
    {time=16.966,key="q"},{time=17.379,key="w"},
    {time=17.793,key="q"},{time=18.207,key="0"},
    {time=18.621,key="9"},{time=18.621,key="4"},
    {time=19.034,key="8"},{time=19.448,key="9"},
    {time=19.862,key="0"},{time=20.276,key="q"},
    {time=20.690,key="0"},{time=21.103,key="9"},
    {time=21.517,key="8"},{time=21.931,key="7"},
    -- Bridge/Outro (22〜30s)
    {time=22.345,key="8"},{time=22.345,key="4"},
    {time=22.759,key="9"},{time=23.172,key="0"},
    {time=23.586,key="9"},{time=24.000,key="8"},
    {time=24.414,key="7"},{time=24.414,key="3"},
    {time=24.828,key="8"},{time=25.241,key="9"},
    {time=25.655,key="0"},{time=26.069,key="q"},
    {time=26.483,key="0"},{time=26.897,key="9"},
    {time=27.310,key="8"},{time=27.724,key="7"},
    {time=28.138,key="6"},{time=28.552,key="7"},
    {time=28.966,key="8"},{time=29.379,key="9"},
    {time=29.793,key="0"},
}

-- ── 紅蓮華 (LiSA / 鬼滅の刃 / BPM=133 / ~32s) ──────────────
local notes_gurenge = {
    -- Intro (0〜6s)
    {time=0.000,key="e"},{time=0.451,key="e"},{time=0.902,key="r"},
    {time=1.353,key="e"},{time=1.805,key="0"},{time=2.256,key="9"},
    {time=2.707,key="8"},{time=3.158,key="9"},{time=3.609,key="e"},
    {time=4.060,key="r"},{time=4.511,key="e"},{time=4.962,key="0"},
    {time=5.414,key="9"},{time=5.865,key="8"},
    -- Verse (6〜16s)
    {time=6.316,key="9"},{time=6.316,key="5"},
    {time=6.767,key="0"},{time=7.218,key="9"},
    {time=7.669,key="8"},{time=8.120,key="7"},
    {time=8.571,key="8"},{time=8.571,key="3"},
    {time=9.023,key="9"},{time=9.474,key="0"},
    {time=9.925,key="9"},{time=10.376,key="8"},
    {time=10.827,key="7"},{time=10.827,key="4"},
    {time=11.278,key="6"},{time=11.729,key="7"},
    {time=12.180,key="8"},{time=12.632,key="9"},
    {time=13.083,key="e"},{time=13.083,key="5"},
    {time=13.534,key="r"},{time=13.985,key="e"},
    {time=14.436,key="0"},{time=14.887,key="9"},
    {time=15.338,key="8"},{time=15.789,key="7"},
    -- Chorus サビ (16〜32s) ★紅蓮華メロ
    {time=16.000,key="e"},{time=16.000,key="6"},
    {time=16.451,key="r"},{time=16.902,key="e"},
    {time=17.353,key="w"},{time=17.805,key="e"},
    {time=18.256,key="r"},{time=18.256,key="5"},
    {time=18.707,key="e"},{time=19.158,key="0"},
    {time=19.609,key="9"},{time=20.060,key="8"},
    {time=20.511,key="9"},{time=20.511,key="4"},
    {time=20.962,key="0"},{time=21.414,key="9"},
    {time=21.865,key="8"},{time=22.316,key="9"},
    {time=22.767,key="e"},{time=22.767,key="6"},
    {time=23.218,key="r"},{time=23.669,key="e"},
    {time=24.120,key="w"},{time=24.571,key="e"},
    {time=25.023,key="r"},{time=25.023,key="5"},
    {time=25.474,key="e"},{time=25.925,key="0"},
    {time=26.376,key="q"},{time=26.827,key="0"},
    {time=27.278,key="9"},{time=27.278,key="4"},
    {time=27.729,key="8"},{time=28.180,key="9"},
    {time=28.632,key="0"},{time=29.083,key="q"},
    {time=29.534,key="w"},{time=29.534,key="5"},
    {time=29.985,key="e"},{time=30.436,key="r"},
    {time=30.887,key="e"},{time=31.338,key="0"},
    {time=31.789,key="9"},{time=32.000,key="8"},
}

-- ── 残酷な天使のテーゼ (高橋洋子 / エヴァ / BPM=142 / ~30s) ─
local notes_zankoku = {
    -- Intro (0〜4s)
    {time=0.000,key="8"},{time=0.423,key="9"},{time=0.845,key="0"},
    {time=1.268,key="9"},{time=1.690,key="8"},{time=2.113,key="7"},
    {time=2.535,key="8"},{time=2.958,key="9"},{time=3.380,key="0"},
    -- Verse (4〜14s)
    {time=3.803,key="q"},{time=3.803,key="5"},
    {time=4.225,key="0"},{time=4.648,key="9"},
    {time=5.070,key="8"},{time=5.493,key="9"},
    {time=5.915,key="0"},{time=5.915,key="4"},
    {time=6.338,key="9"},{time=6.761,key="8"},
    {time=7.183,key="7"},{time=7.606,key="6"},
    {time=8.028,key="7"},{time=8.028,key="3"},
    {time=8.451,key="8"},{time=8.873,key="9"},
    {time=9.296,key="0"},{time=9.718,key="9"},
    {time=10.141,key="8"},{time=10.141,key="5"},
    {time=10.563,key="7"},{time=10.986,key="8"},
    {time=11.408,key="9"},{time=11.831,key="0"},
    {time=12.254,key="9"},{time=12.254,key="4"},
    {time=12.676,key="8"},{time=13.099,key="7"},
    {time=13.521,key="6"},{time=13.944,key="5"},
    -- Chorus (14〜22s) ★残酷な天使のテーゼ サビ
    {time=14.366,key="e"},{time=14.366,key="6"},
    {time=14.789,key="r"},{time=15.211,key="e"},
    {time=15.634,key="w"},{time=16.056,key="e"},
    {time=16.479,key="r"},{time=16.479,key="5"},
    {time=16.901,key="w"},{time=17.324,key="e"},
    {time=17.746,key="0"},{time=18.169,key="9"},
    {time=18.592,key="8"},{time=18.592,key="4"},
    {time=19.014,key="9"},{time=19.437,key="0"},
    {time=19.859,key="9"},{time=20.282,key="8"},
    {time=20.704,key="9"},{time=20.704,key="5"},
    {time=21.127,key="0"},{time=21.549,key="q"},
    {time=21.972,key="w"},{time=22.394,key="q"},
    -- Bridge/Outro (22〜30s)
    {time=22.817,key="0"},{time=22.817,key="4"},
    {time=23.239,key="9"},{time=23.662,key="8"},
    {time=24.085,key="9"},{time=24.507,key="0"},
    {time=24.930,key="q"},{time=24.930,key="5"},
    {time=25.352,key="0"},{time=25.775,key="9"},
    {time=26.197,key="8"},{time=26.620,key="7"},
    {time=27.042,key="8"},{time=27.042,key="3"},
    {time=27.465,key="9"},{time=27.887,key="0"},
    {time=28.310,key="9"},{time=28.732,key="8"},
    {time=29.155,key="7"},{time=29.577,key="6"},
    {time=30.000,key="8"},
}

-- ── アイドル (YOASOBI / BPM=167 / ~28s) ─────────────────────
local notes_idol = {
    -- Intro (0〜4s)
    {time=0.000,key="e"},{time=0.359,key="r"},{time=0.719,key="e"},
    {time=1.078,key="0"},{time=1.437,key="9"},{time=1.796,key="8"},
    {time=2.156,key="9"},{time=2.515,key="e"},{time=2.874,key="r"},
    {time=3.234,key="e"},{time=3.593,key="w"},
    -- Verse (4〜14s)
    {time=3.952,key="9"},{time=3.952,key="6"},
    {time=4.311,key="0"},{time=4.671,key="9"},
    {time=5.030,key="8"},{time=5.389,key="9"},
    {time=5.749,key="e"},{time=5.749,key="5"},
    {time=6.108,key="r"},{time=6.467,key="e"},
    {time=6.826,key="0"},{time=7.186,key="9"},
    {time=7.545,key="8"},{time=7.545,key="4"},
    {time=7.904,key="7"},{time=8.263,key="8"},
    {time=8.623,key="9"},{time=8.982,key="0"},
    {time=9.341,key="9"},{time=9.341,key="5"},
    {time=9.701,key="0"},{time=10.060,key="q"},
    {time=10.419,key="0"},{time=10.778,key="9"},
    {time=11.138,key="8"},{time=11.138,key="4"},
    {time=11.497,key="9"},{time=11.856,key="0"},
    {time=12.216,key="q"},{time=12.575,key="0"},
    {time=12.934,key="9"},{time=13.293,key="8"},
    -- Chorus サビ (14〜28s) ★アイドルサビ
    {time=13.653,key="e"},{time=13.653,key="6"},
    {time=14.012,key="r"},{time=14.371,key="e"},
    {time=14.731,key="r"},{time=15.090,key="w"},
    {time=15.449,key="e"},{time=15.449,key="5"},
    {time=15.808,key="r"},{time=16.168,key="e"},
    {time=16.527,key="0"},{time=16.886,key="9"},
    {time=17.246,key="8"},{time=17.246,key="4"},
    {time=17.605,key="9"},{time=17.964,key="0"},
    {time=18.323,key="q"},{time=18.683,key="0"},
    {time=19.042,key="9"},{time=19.042,key="5"},
    {time=19.401,key="8"},{time=19.760,key="9"},
    {time=20.120,key="e"},{time=20.479,key="r"},
    {time=20.838,key="e"},{time=20.838,key="6"},
    {time=21.198,key="0"},{time=21.557,key="9"},
    {time=21.916,key="8"},{time=22.275,key="9"},
    {time=22.635,key="e"},{time=22.635,key="5"},
    {time=22.994,key="r"},{time=23.353,key="e"},
    {time=23.713,key="0"},{time=24.072,key="q"},
    {time=24.431,key="0"},{time=24.431,key="4"},
    {time=24.790,key="9"},{time=25.150,key="8"},
    {time=25.509,key="7"},{time=25.868,key="6"},
    {time=26.228,key="7"},{time=26.228,key="3"},
    {time=26.587,key="8"},{time=26.946,key="9"},
    {time=27.305,key="8"},{time=27.665,key="7"},
    {time=28.000,key="e"},
}

-- ── ブルーバード (いきものがかり / NARUTO / BPM=138 / ~30s) ──
local notes_bluebird = {
    -- Intro (0〜5s)
    {time=0.000,key="9"},{time=0.435,key="0"},{time=0.870,key="q"},
    {time=1.304,key="0"},{time=1.739,key="9"},{time=2.174,key="8"},
    {time=2.609,key="9"},{time=3.043,key="0"},{time=3.478,key="9"},
    {time=3.913,key="8"},{time=4.348,key="7"},{time=4.783,key="8"},
    -- Verse (5〜14s)
    {time=5.217,key="9"},{time=5.217,key="5"},
    {time=5.652,key="0"},{time=6.087,key="9"},
    {time=6.522,key="8"},{time=6.957,key="9"},
    {time=7.391,key="0"},{time=7.391,key="4"},
    {time=7.826,key="9"},{time=8.261,key="8"},
    {time=8.696,key="7"},{time=9.130,key="8"},
    {time=9.565,key="9"},{time=9.565,key="5"},
    {time=10.000,key="0"},{time=10.435,key="9"},
    {time=10.870,key="8"},{time=11.304,key="7"},
    {time=11.739,key="6"},{time=11.739,key="3"},
    {time=12.174,key="7"},{time=12.609,key="8"},
    {time=13.043,key="9"},{time=13.478,key="0"},
    {time=13.913,key="9"},{time=14.000,key="8"},
    -- Chorus (14〜22s)
    {time=14.348,key="e"},{time=14.348,key="6"},
    {time=14.783,key="r"},{time=15.217,key="e"},
    {time=15.652,key="r"},{time=16.087,key="e"},
    {time=16.522,key="0"},{time=16.522,key="5"},
    {time=16.957,key="9"},{time=17.391,key="8"},
    {time=17.826,key="9"},{time=18.261,key="0"},
    {time=18.696,key="q"},{time=18.696,key="4"},
    {time=19.130,key="0"},{time=19.565,key="9"},
    {time=20.000,key="8"},{time=20.435,key="9"},
    {time=20.870,key="e"},{time=20.870,key="5"},
    {time=21.304,key="r"},{time=21.739,key="e"},
    {time=22.174,key="0"},{time=22.609,key="9"},
    -- Bridge/Outro (22〜30s)
    {time=23.043,key="8"},{time=23.043,key="4"},
    {time=23.478,key="9"},{time=23.913,key="0"},
    {time=24.348,key="9"},{time=24.783,key="8"},
    {time=25.217,key="7"},{time=25.217,key="3"},
    {time=25.652,key="8"},{time=26.087,key="9"},
    {time=26.522,key="0"},{time=26.957,key="q"},
    {time=27.391,key="0"},{time=27.391,key="5"},
    {time=27.826,key="9"},{time=28.261,key="8"},
    {time=28.696,key="7"},{time=29.130,key="6"},
    {time=29.565,key="7"},{time=30.000,key="8"},
}

-- ── 炎 (LiSA / 鬼滅無限列車 / BPM=92 / ~32s) ───────────────
local notes_homura = {
    -- Intro (0〜6s)
    {time=0.000,key="e"},{time=0.652,key="r"},{time=1.304,key="e"},
    {time=1.957,key="0"},{time=2.609,key="9"},{time=3.261,key="8"},
    {time=3.913,key="9"},{time=4.565,key="e"},{time=5.217,key="r"},
    {time=5.870,key="w"},
    -- Verse (6〜16s)
    {time=6.522,key="9"},{time=6.522,key="5"},
    {time=7.174,key="0"},{time=7.826,key="9"},
    {time=8.478,key="8"},{time=9.130,key="7"},
    {time=9.783,key="8"},{time=9.783,key="3"},
    {time=10.435,key="9"},{time=11.087,key="0"},
    {time=11.739,key="9"},{time=12.391,key="8"},
    {time=13.043,key="7"},{time=13.043,key="4"},
    {time=13.696,key="6"},{time=14.348,key="7"},
    {time=15.000,key="8"},{time=15.652,key="9"},
    -- Chorus サビ (16〜32s)
    {time=16.304,key="e"},{time=16.304,key="6"},
    {time=16.957,key="r"},{time=17.609,key="e"},
    {time=18.261,key="w"},{time=18.913,key="e"},
    {time=19.565,key="r"},{time=19.565,key="5"},
    {time=20.217,key="e"},{time=20.870,key="0"},
    {time=21.522,key="9"},{time=22.174,key="8"},
    {time=22.826,key="9"},{time=22.826,key="4"},
    {time=23.478,key="0"},{time=24.130,key="9"},
    {time=24.783,key="8"},{time=25.435,key="9"},
    {time=26.087,key="e"},{time=26.087,key="6"},
    {time=26.739,key="r"},{time=27.391,key="e"},
    {time=28.043,key="w"},{time=28.043,key="5"},
    {time=28.696,key="q"},{time=29.348,key="0"},
    {time=30.000,key="9"},{time=30.000,key="4"},
    {time=30.652,key="8"},{time=31.304,key="7"},
    {time=31.957,key="8"},{time=32.000,key="e"},
}


-- ══════════════════════════════════════════════════════════════
-- ★ Libra Heart 1  [大幅補完版 ~720notes / 0〜225s]
-- ══════════════════════════════════════════════════════════════
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
    {time=6.344,key="^"},{time=6.352,key="$"},{time=6.367,key="Q"},{time=6.646,key="I"},
    {time=6.854,key="Q"},{time=6.867,key="W"},{time=6.875,key="%"},{time=6.883,key="4"},
    {time=7.354,key="Q"},{time=7.362,key="^"},{time=7.366,key="@"},{time=7.551,key="i"},
    {time=7.621,key="^"},{time=7.655,key="q"},{time=7.865,key="!"},{time=8.366,key="7"},
    {time=8.609,key="$"},{time=8.853,key="7"},{time=8.861,key="$"},{time=8.865,key="7"},
    {time=9.085,key="7"},{time=9.097,key="7"},{time=9.120,key="r"},{time=9.352,key="!"},
    {time=9.364,key="!"},{time=9.607,key="%"},{time=9.615,key="!"},{time=9.630,key="*"},
    {time=9.863,key="!"},{time=9.874,key="*"},{time=9.882,key="!"},{time=10.364,key="$"},
    {time=10.596,key="W"},{time=10.840,key="Q"},{time=10.851,key="4"},{time=11.095,key="*"},
    {time=11.106,key="W"},{time=11.142,key="4"},{time=11.350,key="^"},{time=11.358,key="@"},
    {time=11.361,key="Q"},{time=11.618,key="^"},{time=11.861,key="*"},{time=11.873,key="!"},
    {time=12.083,key="!"},{time=12.095,key="^"},{time=12.118,key="Q"},{time=12.350,key="7"},
    {time=12.373,key="Q"},{time=12.420,key="@"},{time=12.605,key="7"},{time=12.613,key="$"},
    {time=12.826,key="7"},{time=12.838,key="E"},{time=12.849,key="7"},{time=13.128,key="7"},
    {time=13.360,key="^"},{time=13.372,key="!"},{time=13.442,key="Q"},{time=13.604,key="Q"},
    {time=13.708,key="!"},{time=13.720,key="7"},{time=13.859,key="7"},{time=13.871,key="!"},
    {time=14.010,key="Q"},{time=14.197,key="!"},{time=14.336,key="$"},{time=14.359,key="Q"},
    {time=14.476,key="$"},{time=14.882,key="4"},{time=14.890,key="!"},{time=15.115,key="$"},
    {time=15.358,key="@"},{time=15.440,key="!"},{time=15.591,key="@"},{time=16.115,key="%"},
    {time=16.289,key="@"},{time=16.381,key="7"},{time=16.404,key="$"},{time=16.659,key="!"},
    {time=16.973,key="7"},{time=17.043,key="@"},{time=17.112,key="7"},{time=17.379,key="!"},
    {time=17.449,key="!"},{time=17.705,key="%"},{time=17.844,key="!"},{time=17.868,key="!"},
    {time=18.077,key="$"},{time=18.379,key="$"},{time=18.449,key="^"},{time=18.600,key="$"},
    {time=18.832,key="%"},{time=18.840,key="4"},{time=18.972,key="4"},{time=19.343,key="$"},
    {time=19.390,key="!"},{time=19.505,key="@"},{time=20.146,key="^"},{time=20.250,key="@"},
    {time=20.366,key="^"},{time=20.900,key="7"},{time=20.908,key="@"},{time=20.923,key="$"},
    {time=20.934,key="7"},{time=21.387,key="^"},{time=21.446,key="!"},{time=21.724,key="^"},
    {time=21.732,key="4"},{time=21.736,key="!"},{time=22.062,key="%"},{time=22.097,key="$"},
    {time=22.376,key="^"},{time=22.399,key="$"},{time=22.852,key="%"},{time=22.864,key="7"},
    {time=22.968,key="4"},{time=23.015,key="4"},{time=23.385,key="^"},{time=23.606,key="@"},
    {time=23.746,key="^"},{time=24.362,key="7"},{time=24.370,key="@"},{time=24.408,key="7"},
    {time=24.595,key="$"},{time=24.920,key="^"},{time=24.931,key="7"},{time=25.082,key="7"},
    {time=25.128,key="7"},{time=25.454,key="!"},{time=25.755,key="!"},{time=25.825,key="!"},
    {time=25.849,key="!"},{time=26.152,key="$"},{time=26.360,key="$"},{time=26.407,key="$"},
    {time=26.442,key="^"},{time=26.859,key="%"},{time=26.987,key="4"},{time=27.116,key="$"},
    {time=27.405,key="^"},{time=27.452,key="$"},{time=27.858,key="^"},{time=28.103,key="^"},
    {time=28.277,key="@"},{time=28.358,key="7"},{time=28.928,key="7"},{time=28.936,key="$"},
    {time=29.078,key="7"},{time=29.114,key="7"},{time=29.590,key="!"},{time=29.717,key="$"},
    {time=29.879,key="!"},{time=30.322,key="$"},{time=30.346,key="$"},{time=30.520,key="$"},
    {time=30.554,key="$"},{time=30.856,key="$"},{time=31.007,key="4"},{time=31.355,key="@"},
    {time=31.436,key="$"},{time=31.506,key="@"},{time=31.727,key="^"},{time=31.808,key="!"},
    {time=32.089,key="%"},{time=32.134,key="@"},{time=32.251,key="@"},{time=32.344,key="$"},
    {time=32.367,key="7"},{time=32.935,key="7"},{time=33.005,key="@"},{time=33.086,key="7"},
    {time=33.342,key="!"},{time=33.504,key="!"},{time=33.714,key="!"},{time=33.725,key="@"},
    {time=33.760,key="%"},{time=33.913,key="!"},{time=34.132,key="^"},{time=34.140,key="4"},
    {time=34.202,key="$"},{time=34.400,key="^"},{time=34.574,key="4"},{time=34.899,key="%"},
    {time=35.003,key="4"},{time=35.352,key="$"},{time=35.468,key="@"},{time=35.515,key="@"},
    {time=35.573,key="!"},{time=36.131,key="@"},{time=36.143,key="^"},{time=36.340,key="@"},
    {time=36.944,key="$"},{time=36.967,key="$"},{time=37.002,key="7"},{time=37.048,key="7"},
    {time=37.350,key="^"},{time=37.361,key="4"},{time=37.431,key="!"},{time=37.594,key="!"},
    {time=37.710,key="$"},{time=37.908,key="!"},{time=38.106,key="%"},{time=38.141,key="$"},
    {time=38.373,key="^"},{time=38.860,key="%"},{time=38.907,key="4"},{time=38.942,key="7"},
    {time=39.011,key="4"},{time=39.372,key="@"},{time=39.395,key="^"},{time=39.557,key="@"},
    {time=39.731,key="^"},{time=39.860,key="!"},{time=40.104,key="^"},{time=40.278,key="@"},
    {time=40.395,key="^"},{time=40.871,key="^"},{time=41.091,key="7"},{time=41.115,key="7"},
    {time=41.347,key="^"},{time=41.485,key="!"},{time=41.636,key="!"},{time=41.742,key="4"},
    {time=41.847,key="!"},{time=41.858,key="*"},{time=41.870,key="!"},{time=42.021,key="$"},
    {time=42.357,key="$"},{time=42.393,key="^"},{time=42.869,key="%"},{time=42.984,key="4"},
    {time=43.112,key="$"},{time=43.460,key="^"},{time=43.530,key="@"},{time=43.623,key="@"},
    {time=43.845,key="^"},{time=44.402,key="@"},{time=44.914,key="$"},{time=44.948,key="7"},
    {time=45.110,key="7"},{time=45.146,key="7"},{time=45.378,key="^"},{time=45.482,key="!"},
    {time=45.622,key="!"},{time=45.715,key="$"},{time=45.867,key="!"},{time=46.145,key="$"},
    {time=46.157,key="%"},{time=46.343,key="$"},{time=46.528,key="$"},{time=46.598,key="@"},
    {time=46.958,key="4"},{time=47.365,key="$"},{time=47.446,key="@"},{time=47.620,key="^"},
    {time=47.819,key="4"},{time=47.911,key="!"},{time=48.399,key="!"},{time=48.410,key="7"},
    {time=48.620,key="$"},{time=48.968,key="7"},{time=48.976,key="7"},{time=49.119,key="@"},
    {time=49.362,key="!"},{time=49.525,key="!"},{time=49.606,key="%"},{time=49.781,key="%"},
    {time=49.862,key="!"},{time=50.130,key="^"},{time=50.339,key="^"},{time=50.362,key="$"},
    {time=50.595,key="7"},{time=50.861,key="4"},{time=50.873,key="4"},{time=50.884,key="@"},
    {time=51.117,key="4"},{time=51.384,key="@"},{time=51.396,key="$"},{time=51.616,key="^"},
    {time=51.861,key="!"},{time=52.140,key="$"},{time=52.314,key="$"},{time=52.349,key="7"},
    {time=52.476,key="%"},{time=52.732,key="$"},{time=52.848,key="7"},{time=52.871,key="7"},
    {time=53.103,key="%"},{time=53.382,key="%"},{time=53.390,key="!"},{time=53.509,key="^"},
    {time=53.730,key="%"},{time=54.033,key="$"},{time=54.870,key="4"},{time=55.102,key="4"},
    {time=55.357,key="$"},{time=55.450,key="@"},{time=55.531,key="@"},{time=55.869,key="!"},
    {time=56.112,key="4"},{time=56.264,key="@"},{time=56.357,key="@"},{time=56.915,key="$"},
    {time=57.077,key="7"},{time=57.100,key="@"},{time=57.518,key="!"},{time=57.669,key="!"},
    {time=57.868,key="!"},{time=58.123,key="7"},{time=58.367,key="$"},{time=58.401,key="$"},
    {time=58.831,key="4"},{time=58.877,key="@"},{time=59.098,key="4"},{time=59.353,key="$"},
    {time=59.540,key="@"},{time=60.132,key="$"},{time=60.342,key="%"},{time=60.365,key="7"},
    {time=60.446,key="@"},{time=60.736,key="$"},{time=60.899,key="7"},{time=60.922,key="7"},
    {time=61.073,key="7"},{time=61.108,key="%"},{time=61.433,key="!"},{time=61.515,key="^"},
    {time=61.596,key="!"},{time=61.748,key="!"},{time=61.771,key="%"},{time=62.050,key="$"},
    {time=62.386,key="$"},{time=62.421,key="$"},{time=62.700,key="^"},{time=62.851,key="^"},
    {time=63.001,key="4"},{time=63.200,key="!"},{time=63.400,key="@"},{time=63.600,key="*"},
    {time=63.800,key="$"},
    -- EXPANDED FILL SECTION (65〜225s)
    {time=65.000,key="E"},{time=65.008,key="W"},{time=65.250,key="r"},{time=65.500,key="!"},
    {time=65.750,key="W"},{time=66.000,key="Q"},{time=66.250,key="E"},
    {time=66.500,key="r"},{time=66.750,key="W"},{time=67.000,key="Q"},
    {time=67.250,key="*"},{time=67.500,key="W"},{time=67.750,key="E"},
    {time=68.000,key="W"},{time=68.250,key="Q"},{time=68.500,key="*"},
    {time=68.750,key="W"},{time=69.000,key="E"},{time=69.250,key="r"},
    {time=69.500,key="W"},{time=69.750,key="Q"},
    {time=70.000,key="r"},{time=70.200,key="!"},{time=70.400,key="@"},{time=70.600,key="^"},
    {time=70.750,key="^"},{time=71.000,key="@"},{time=71.250,key="7"},
    {time=71.500,key="$"},{time=71.750,key="7"},{time=72.000,key="^"},
    {time=72.250,key="@"},{time=72.500,key="!"},{time=72.750,key="7"},
    {time=73.000,key="^"},{time=73.250,key="@"},{time=73.500,key="7"},
    {time=73.750,key="$"},{time=74.000,key="7"},{time=74.250,key="^"},
    {time=74.500,key="@"},{time=74.750,key="!"},
    {time=75.000,key="!"},{time=75.100,key="@"},{time=75.200,key="*"},{time=75.300,key="$"},
    {time=75.500,key="!"},{time=75.750,key="*"},{time=76.000,key="Q"},
    {time=76.250,key="*"},{time=76.500,key="!"},{time=76.750,key="^"},
    {time=77.000,key="*"},{time=77.250,key="Q"},{time=77.500,key="W"},
    {time=77.750,key="Q"},{time=78.000,key="*"},{time=78.250,key="!"},
    {time=78.500,key="^"},{time=78.750,key="*"},{time=79.000,key="Q"},
    {time=79.250,key="W"},{time=79.500,key="Q"},{time=79.750,key="*"},
    {time=80.200,key="!"},{time=80.250,key="@"},{time=80.300,key="*"},{time=80.350,key="$"},
    {time=80.500,key="W"},{time=80.750,key="Q"},{time=81.000,key="!"},
    {time=81.250,key="^"},{time=81.500,key="@"},{time=81.750,key="*"},
    {time=82.000,key="Q"},{time=82.250,key="W"},{time=82.500,key="E"},
    {time=82.750,key="W"},{time=83.000,key="Q"},{time=83.250,key="*"},
    {time=83.500,key="!"},{time=83.750,key="^"},{time=84.000,key="@"},
    {time=84.250,key="7"},{time=84.500,key="$"},{time=84.750,key="7"},
    {time=85.000,key="^"},{time=85.250,key="@"},{time=85.500,key="!"},
    {time=85.750,key="*"},{time=86.000,key="Q"},{time=86.250,key="W"},
    {time=86.500,key="E"},{time=86.750,key="W"},{time=87.000,key="Q"},
    {time=87.250,key="*"},{time=87.500,key="!"},{time=87.750,key="^"},
    {time=88.000,key="@"},{time=88.250,key="7"},{time=88.500,key="$"},
    {time=88.750,key="7"},{time=89.000,key="^"},{time=89.250,key="@"},
    {time=89.500,key="!"},{time=89.750,key="*"},
    {time=90.000,key="7"},{time=90.008,key="4"},{time=90.016,key="!"},{time=90.200,key="@"},
    {time=90.250,key="@"},{time=90.500,key="7"},{time=90.750,key="^"},
    {time=91.000,key="@"},{time=91.250,key="7"},{time=91.500,key="!"},
    {time=91.750,key="7"},{time=92.000,key="^"},{time=92.250,key="@"},
    {time=92.500,key="7"},{time=92.750,key="^"},{time=93.000,key="!"},
    {time=93.250,key="^"},{time=93.500,key="@"},{time=93.750,key="7"},
    {time=94.000,key="!"},{time=94.250,key="@"},{time=94.500,key="^"},
    {time=94.750,key="7"},
    {time=95.200,key="!"},{time=95.250,key="@"},{time=95.300,key="*"},{time=95.350,key="$"},
    {time=95.500,key="!"},{time=95.750,key="*"},{time=96.000,key="Q"},
    {time=96.250,key="*"},{time=96.500,key="!"},{time=96.750,key="^"},
    {time=97.000,key="*"},{time=97.250,key="Q"},{time=97.500,key="W"},
    {time=97.750,key="Q"},{time=98.000,key="*"},{time=98.250,key="!"},
    {time=98.500,key="^"},{time=98.750,key="*"},{time=99.000,key="Q"},
    {time=99.250,key="W"},{time=99.500,key="Q"},{time=99.750,key="*"},
    {time=100.000,key="@"},{time=100.100,key="*"},{time=100.200,key="$"},{time=100.300,key="%"},
    {time=100.500,key="@"},{time=100.750,key="*"},{time=101.000,key="Q"},
    {time=101.250,key="W"},{time=101.500,key="Q"},{time=101.750,key="*"},
    {time=102.000,key="@"},{time=102.250,key="^"},{time=102.500,key="!"},
    {time=102.750,key="@"},{time=103.000,key="*"},{time=103.250,key="Q"},
    {time=103.500,key="W"},{time=103.750,key="Q"},{time=104.000,key="*"},
    {time=104.250,key="@"},{time=104.500,key="^"},{time=104.750,key="!"},
    {time=105.000,key="*"},{time=105.250,key="Q"},{time=105.500,key="W"},
    {time=105.750,key="Q"},{time=106.000,key="*"},{time=106.250,key="@"},
    {time=106.500,key="^"},{time=106.750,key="!"},{time=107.000,key="@"},
    {time=107.250,key="*"},{time=107.500,key="Q"},{time=107.750,key="W"},
    {time=108.000,key="Q"},{time=108.250,key="*"},{time=108.500,key="@"},
    {time=108.750,key="^"},{time=109.000,key="!"},{time=109.250,key="@"},
    {time=109.500,key="*"},{time=109.750,key="Q"},
    {time=110.000,key="$"},{time=110.100,key="%"},{time=110.200,key="^"},{time=110.300,key="7"},
    {time=110.500,key="$"},{time=111.000,key="%"},{time=111.500,key="^"},
    {time=112.000,key="7"},{time=112.500,key="$"},{time=113.000,key="%"},
    {time=113.500,key="^"},{time=114.000,key="7"},{time=114.500,key="$"},
    {time=115.000,key="%"},{time=115.500,key="^"},{time=116.000,key="7"},
    {time=116.500,key="$"},{time=117.000,key="%"},{time=117.500,key="^"},
    {time=118.000,key="7"},{time=118.500,key="$"},
    {time=119.000,key="*"},{time=119.008,key="@"},{time=119.016,key="!"},
    {time=120.000,key="7"},{time=120.008,key="^"},{time=120.016,key="%"},
    {time=120.024,key="$"},{time=120.150,key="4"},{time=120.250,key="Q"},
    {time=120.350,key="W"},{time=120.450,key="E"},
    {time=120.500,key="Q"},{time=121.000,key="W"},{time=121.500,key="E"},
    {time=122.000,key="W"},{time=122.500,key="Q"},{time=123.000,key="*"},
    {time=123.500,key="Q"},{time=124.000,key="W"},{time=124.500,key="Q"},
    {time=125.000,key="7"},{time=125.008,key="!"},{time=125.200,key="^"},{time=125.208,key="@"},
    {time=125.500,key="@"},{time=126.000,key="7"},{time=126.500,key="^"},
    {time=127.000,key="@"},{time=127.500,key="7"},{time=128.000,key="!"},
    {time=128.500,key="7"},{time=129.000,key="^"},{time=129.500,key="@"},
    {time=130.000,key="*"},{time=130.008,key="$"},{time=130.016,key="@"},{time=130.024,key="!"},
    {time=130.500,key="W"},{time=131.000,key="Q"},{time=131.500,key="*"},
    {time=132.000,key="Q"},{time=132.500,key="W"},{time=133.000,key="E"},
    {time=133.500,key="W"},{time=134.000,key="Q"},{time=134.500,key="*"},
    {time=135.000,key="Q"},{time=135.050,key="W"},{time=135.100,key="E"},{time=135.150,key="r"},
    {time=135.500,key="r"},{time=136.000,key="E"},{time=136.500,key="W"},
    {time=137.000,key="Q"},{time=137.500,key="*"},{time=138.000,key="Q"},
    {time=138.500,key="W"},{time=139.000,key="E"},{time=139.500,key="r"},
    {time=140.000,key="!"},{time=140.300,key="@"},{time=140.600,key="*"},{time=140.900,key="$"},
    {time=141.000,key="*"},{time=141.500,key="Q"},{time=142.000,key="W"},
    {time=142.500,key="E"},{time=143.000,key="W"},{time=143.500,key="Q"},
    {time=144.000,key="*"},{time=144.500,key="Q"},
    {time=145.000,key="*"},{time=145.008,key="^"},{time=145.500,key="%"},{time=145.508,key="$"},
    {time=146.000,key="W"},{time=146.500,key="Q"},{time=147.000,key="*"},
    {time=147.500,key="Q"},{time=148.000,key="W"},{time=148.500,key="Q"},
    {time=149.000,key="*"},{time=149.500,key="Q"},
    {time=150.000,key="^"},{time=150.008,key="%"},{time=150.500,key="7"},{time=150.508,key="4"},
    {time=151.000,key="7"},{time=151.500,key="^"},{time=152.000,key="@"},
    {time=152.500,key="7"},{time=153.000,key="$"},{time=153.500,key="7"},
    {time=154.000,key="^"},{time=154.500,key="@"},{time=155.000,key="7"},
    {time=155.500,key="!"},{time=156.000,key="7"},{time=156.500,key="^"},
    {time=157.000,key="@"},{time=157.500,key="7"},{time=158.000,key="$"},
    {time=158.500,key="7"},{time=159.000,key="^"},{time=159.500,key="@"},
    {time=160.000,key="!"},{time=160.100,key="!"},{time=160.200,key="!"},{time=160.300,key="!"},
    {time=160.500,key="*"},{time=161.000,key="Q"},{time=161.500,key="W"},
    {time=162.000,key="Q"},{time=162.500,key="*"},{time=163.000,key="Q"},
    {time=163.500,key="W"},{time=164.000,key="Q"},{time=164.500,key="*"},
    {time=165.000,key="^"},{time=165.050,key="^"},{time=165.100,key="^"},{time=165.150,key="^"},
    {time=165.500,key="W"},{time=166.000,key="Q"},{time=166.500,key="*"},
    {time=167.000,key="Q"},{time=167.500,key="W"},{time=168.000,key="Q"},
    {time=168.500,key="*"},{time=169.000,key="Q"},{time=169.500,key="W"},
    {time=170.000,key="7"},{time=170.008,key="^"},{time=170.016,key="%"},{time=170.024,key="4"},
    {time=170.500,key="@"},{time=171.000,key="7"},{time=171.500,key="^"},
    {time=172.000,key="@"},{time=172.500,key="!"},{time=173.000,key="^"},
    {time=173.500,key="@"},{time=174.000,key="7"},{time=174.500,key="$"},
    {time=175.000,key="!"},{time=175.100,key="@"},{time=175.200,key="*"},{time=175.300,key="$"},
    {time=175.500,key="!"},{time=176.000,key="*"},{time=176.500,key="Q"},
    {time=177.000,key="W"},{time=177.500,key="Q"},{time=178.000,key="*"},
    {time=178.500,key="Q"},{time=179.000,key="W"},{time=179.500,key="Q"},
    {time=180.000,key="*"},{time=180.008,key="$"},{time=180.016,key="@"},{time=180.024,key="!"},
    {time=180.500,key="*"},{time=180.508,key="$"},{time=180.516,key="@"},{time=180.524,key="!"},
    {time=181.000,key="!"},{time=181.500,key="*"},{time=182.000,key="Q"},
    {time=182.500,key="W"},{time=183.000,key="Q"},{time=183.500,key="*"},
    {time=184.000,key="Q"},{time=184.500,key="W"},
    {time=185.000,key="Q"},{time=185.050,key="W"},{time=185.100,key="E"},{time=185.150,key="r"},
    {time=185.500,key="E"},{time=186.000,key="W"},{time=186.500,key="Q"},
    {time=187.000,key="*"},{time=187.500,key="Q"},{time=188.000,key="W"},
    {time=188.500,key="E"},{time=189.000,key="r"},{time=189.500,key="E"},
    {time=190.000,key="7"},{time=190.008,key="!"},{time=190.500,key="^"},{time=190.508,key="@"},
    {time=191.000,key="@"},{time=191.500,key="7"},{time=192.000,key="^"},
    {time=192.500,key="@"},{time=193.000,key="7"},{time=193.500,key="!"},
    {time=194.000,key="^"},{time=194.500,key="@"},
    {time=195.000,key="Q"},{time=195.050,key="W"},{time=195.100,key="E"},{time=195.150,key="r"},
    {time=195.500,key="E"},{time=196.000,key="W"},{time=196.500,key="Q"},
    {time=197.000,key="*"},{time=197.500,key="Q"},{time=198.000,key="W"},
    {time=198.500,key="E"},{time=199.000,key="r"},{time=199.500,key="E"},
    {time=200.000,key="*"},{time=200.200,key="$"},{time=200.400,key="%"},{time=200.600,key="^"},
    {time=201.000,key="*"},{time=201.500,key="$"},{time=202.000,key="%"},
    {time=202.500,key="^"},{time=203.000,key="*"},{time=203.500,key="$"},
    {time=204.000,key="%"},{time=204.500,key="^"},
    {time=205.000,key="r"},{time=205.008,key="E"},{time=205.500,key="@"},{time=205.508,key="!"},
    {time=206.000,key="7"},{time=206.500,key="^"},{time=207.000,key="@"},
    {time=207.500,key="7"},{time=208.000,key="!"},{time=208.500,key="@"},
    {time=209.000,key="7"},{time=209.500,key="^"},
    {time=210.000,key="7"},{time=210.100,key="4"},{time=210.200,key="Q"},{time=210.300,key="W"},
    {time=210.500,key="E"},{time=211.000,key="W"},{time=211.500,key="Q"},
    {time=212.000,key="*"},{time=212.500,key="Q"},{time=213.000,key="W"},
    {time=213.500,key="E"},{time=214.000,key="r"},{time=214.500,key="E"},
    {time=215.000,key="*"},{time=215.100,key="$"},{time=215.200,key="%"},{time=215.300,key="^"},
    {time=215.500,key="*"},{time=216.000,key="$"},{time=216.500,key="%"},
    {time=217.000,key="^"},{time=217.500,key="*"},{time=218.000,key="$"},
    {time=218.500,key="%"},{time=219.000,key="^"},{time=219.500,key="*"},
    {time=220.000,key="E"},{time=220.250,key="r"},{time=220.500,key="!"},{time=220.750,key="@"},
    {time=221.000,key="W"},{time=221.500,key="Q"},
    {time=222.000,key="7"},{time=222.400,key="4"},{time=222.800,key="Q"},
    {time=223.200,key="W"},{time=223.500,key="E"},{time=224.000,key="r"},
    {time=224.500,key="*"},{time=224.508,key="$"},{time=224.516,key="@"},{time=224.524,key="!"},
    {time=225.000,key="r"},{time=225.008,key="E"},{time=225.016,key="W"},{time=225.024,key="Q"},
    {time=225.032,key="7"},{time=225.040,key="^"},{time=225.048,key="%"},{time=225.056,key="4"},
}

local notes_midi = {
    {time=2.056,key="3"},
    {time=5.076,key="3"},
    {time=6.065,key="3"},
    {time=6.819,key="3"},
    {time=7.423,key="3"},
    {time=7.922,key="3"},
    {time=8.341,key="3"},
    {time=8.724,key="3"},
    {time=9.026,key="3"},
    {time=9.317,key="3"},
    {time=9.572,key="3"},
    {time=9.816,key="3"},
    {time=10.037,key="3"},
    {time=10.223,key="3"},
    {time=10.385,key="3"},
    {time=10.536,key="3"},
    {time=10.676,key="3"},
    {time=10.943,key="3"},
    {time=11.175,key="3"},
    {time=11.407,key="3"},
    {time=11.617,key="3"},
    {time=11.802,key="3"},
    {time=11.990,key="3"},
    {time=12.071,key="3"},
    {time=12.175,key="3"},
    {time=12.349,key="3"},
    {time=12.547,key="3"},
    {time=12.732,key="3"},
    {time=12.918,key="3"},
    {time=13.010,key="0"},
    {time=13.104,key="3"},
    {time=13.197,key="3"},
    {time=13.371,key="7"},
    {time=13.545,key="0"},
    {time=13.719,key="u"},
    {time=13.824,key="7"},
    {time=13.894,key="u"},
    {time=13.988,key="7"},
    {time=14.057,key="u"},
    {time=14.173,key="7"},
    {time=14.243,key="3"},
    {time=14.417,key="6"},
    {time=14.486,key="6"},
    {time=15.287,key="6"},
    {time=16.136,key="3"},
    {time=16.996,key="1"},
    {time=17.704,key="!"},
    {time=17.797,key="%"},
    {time=17.891,key="6"},
    {time=17.960,key="6"},
    {time=18.634,key="3"},
    {time=19.435,key="3"},
    {time=20.215,key="1"},
    {time=21.004,key="6"},
    {time=21.386,key="3"},
    {time=21.770,key="1"},
    {time=22.084,key="3"},
    {time=22.422,key="3"},
    {time=22.758,key="3"},
    {time=23.072,key="1"},
    {time=23.361,key="3"},
    {time=23.664,key="6"},
    {time=23.921,key="3"},
    {time=24.199,key="3"},
    {time=24.466,key="3"},
    {time=24.756,key="3"},
    {time=25.023,key="3"},
    {time=25.302,key="3"},
    {time=25.569,key="3"},
    {time=25.837,key="6"},
    {time=26.348,key="1"},
    {time=26.592,key="3"},
    {time=26.847,key="3"},
    {time=27.079,key="4"},
    {time=27.311,key="1"},
    {time=27.532,key="@"},
    {time=27.765,key="6"},
    {time=28.230,key="1"},
    {time=28.683,key="8"},
    {time=29.113,key="3"},
    {time=29.554,key="9"},
    {time=29.751,key="9"},
    {time=29.939,key="2"},
    {time=30.135,key="9"},
    {time=30.333,key="3"},
    {time=30.542,key="8"},
    {time=30.751,key="2"},
    {time=30.936,key="9"},
    {time=31.134,key="8"},
    {time=31.331,key="8"},
    {time=31.529,key="1"},
    {time=31.715,key="8"},
    {time=31.878,key="3"},
    {time=32.076,key="7"},
    {time=32.273,key="1"},
    {time=32.447,key="8"},
    {time=32.633,key="7"},
    {time=32.819,key="7"},
    {time=33.004,key="@"},
    {time=33.178,key="7"},
    {time=33.353,key="$"},
    {time=33.701,key="6"},
    {time=34.051,key="7"},
    {time=34.771,key="3"},
    {time=34.828,key="3"},
    {time=35.304,key="$"},
    {time=35.467,key="6"},
    {time=35.794,key="3"},
    {time=35.968,key="3"},
    {time=36.142,key="3"},
    {time=36.304,key="3"},
    {time=36.467,key="3"},
    {time=36.641,key="3"},
    {time=36.803,key="6"},
    {time=36.966,key="3"},
    {time=37.117,key="3"},
    {time=37.279,key="3"},
    {time=37.442,key="3"},
    {time=37.593,key="3"},
    {time=37.757,key="1"},
    {time=37.907,key="3"},
    {time=38.070,key="6"},
    {time=38.221,key="4"},
    {time=38.372,key="3"},
    {time=38.430,key="1"},
    {time=38.511,key="@"},
    {time=38.663,key="3"},
    {time=38.953,key="3"},
    {time=39.092,key="8"},
    {time=39.231,key="6"},
    {time=39.510,key="e"},
    {time=39.778,key="3"},
    {time=40.069,key="1"},
    {time=40.324,key="2"},
    {time=40.591,key="4"},
    {time=40.858,key="1"},
    {time=41.102,key="3"},
    {time=41.357,key="7"},
    {time=41.590,key="%"},
    {time=41.823,key="6"},
    {time=41.939,key="0"},
    {time=42.055,key="1"},
    {time=42.171,key="6"},
    {time=42.288,key="3"},
    {time=42.392,key="0"},
    {time=42.473,key="9"},
    {time=42.601,key="8"},
    {time=42.728,key="%"},
    {time=42.926,key="7"},
    {time=43.134,key="6"},
    {time=43.542,key="7"},
    {time=43.821,key="!"},
    {time=43.983,key="6"},
    {time=44.123,key="1"},
    {time=44.216,key="3"},
    {time=44.320,key="3"},
    {time=44.425,key="3"},
    {time=44.518,key="1"},
    {time=44.622,key="3"},
    {time=44.715,key="6"},
    {time=44.808,key="3"},
    {time=44.901,key="3"},
    {time=45.005,key="3"},
    {time=45.098,key="3"},
    {time=45.191,key="3"},
    {time=45.296,key="1"},
    {time=45.389,key="3"},
    {time=45.585,key="6"},
    {time=45.679,key="1"},
    {time=45.866,key="3"},
    {time=46.064,key="1"},
    {time=46.156,key="@"},
    {time=46.260,key="6"},
    {time=46.434,key="3"},
    {time=46.504,key="1"},
    {time=46.632,key="3"},
    {time=46.829,key="1"},
    {time=47.039,key="%"},
    {time=47.131,key="9"},
    {time=47.224,key="2"},
    {time=47.317,key="9"},
    {time=47.433,key="3"},
    {time=47.491,key="8"},
    {time=47.619,key="3"},
    {time=47.806,key="6"},
    {time=47.899,key="8"},
    {time=48.003,key="1"},
    {time=48.096,key="8"},
    {time=48.177,key="3"},
    {time=48.375,key="3"},
    {time=48.479,key="1"},
    {time=48.677,key="7"},
    {time=48.746,key="@"},
    {time=48.874,key="7"},
    {time=48.967,key="$"},
    {time=49.165,key="@"},
    {time=49.361,key="7"},
    {time=49.734,key="7"},
    {time=50.025,key="$"},
    {time=50.129,key="3"},
    {time=50.222,key="6"},
    {time=50.315,key="1"},
    {time=50.466,key="3"},
    {time=50.617,key="3"},
    {time=50.709,key="1"},
    {time=50.907,key="6"},
    {time=51.104,key="1"},
    {time=51.291,key="3"},
    {time=51.487,key="1"},
    {time=51.675,key="6"},
    {time=51.860,key="3"},
    {time=52.057,key="3"},
    {time=52.255,key="1"},
    {time=52.325,key="8"},
    {time=52.452,key="6"},
    {time=52.639,key="e"},
    {time=52.731,key="1"},
    {time=52.847,key="3"},
    {time=53.021,key="1"},
    {time=53.230,key="2"},
    {time=53.428,key="4"},
    {time=53.614,key="1"},
    {time=53.789,key="e"},
    {time=53.998,key="7"},
    {time=54.195,key="%"},
    {time=54.334,key="6"},
    {time=54.485,key="6"},
    {time=54.578,key="1"},
    {time=54.776,key="3"},
    {time=54.869,key="0"},
    {time=54.973,key="$"},
    {time=55.171,key="%"},
    {time=55.356,key="3"},
    {time=55.553,key="6"},
    {time=55.625,key="6"},
    {time=55.926,key="6"},
    {time=56.321,key="2"},
    {time=56.519,key="2"},
    {time=56.704,key="6"},
    {time=56.902,key="6"},
    {time=57.099,key="2"},
    {time=57.284,key="6"},
    {time=57.494,key="6"},
    {time=57.669,key="6"},
    {time=57.867,key="1"},
    {time=58.052,key="3"},
    {time=58.122,key="9"},
    {time=58.261,key="6"},
    {time=58.447,key="9"},
    {time=58.645,key="1"},
    {time=58.830,key="6"},
    {time=59.027,key="6"},
    {time=59.225,key="6"},
    {time=59.422,key="7"},
    {time=59.609,key="%"},
    {time=59.795,key="7"},
    {time=59.993,key="%"},
    {time=60.190,key="7"},
    {time=60.376,key="2"},
    {time=60.573,key="3"},
    {time=60.782,key="2"},
    {time=60.968,key="1"},
    {time=61.165,key="6"},
    {time=61.351,key="1"},
    {time=61.548,key="3"},
    {time=61.735,key="6"},
    {time=61.932,key="0"},
    {time=62.142,key="6"},
    {time=62.316,key="6"},
    {time=62.525,key="2"},
    {time=62.710,key="4"},
    {time=62.908,key="6"},
    {time=63.094,key="4"},
    {time=63.291,key="2"},
    {time=63.489,key="4"},
    {time=63.664,key="6"},
    {time=63.861,key="6"},
    {time=64.058,key="1"},
    {time=64.256,key="6"},
    {time=64.349,key="9"},
    {time=64.442,key="6"},
    {time=64.651,key="6"},
    {time=64.836,key="1"},
    {time=65.033,key="6"},
    {time=65.220,key="e"},
    {time=65.428,key="6"},
    {time=65.616,key="7"},
    {time=65.801,key="4"},
    {time=65.999,key="2"},
    {time=66.196,key="4"},
    {time=66.382,key="3"},
    {time=66.568,key="1"},
    {time=66.672,key="1"},
    {time=66.776,key="2"},
    {time=66.963,key="7"},
    {time=67.159,key="6"},
    {time=67.380,key="6"},
    {time=67.742,key="3"},
    {time=67.927,key="6"},
    {time=67.985,key="6"},
    {time=68.067,key="3"},
    {time=68.322,key="7"},
    {time=68.566,key="$"},
    {time=68.705,key="3"},
    {time=68.809,key="6"},
    {time=68.914,key="1"},
    {time=69.042,key="3"},
    {time=69.100,key="3"},
    {time=69.193,key="3"},
    {time=69.274,key="1"},
    {time=69.367,key="0"},
    {time=69.459,key="3"},
    {time=69.554,key="0"},
    {time=69.647,key="1"},
    {time=69.740,key="0"},
    {time=69.821,key="u"},
    {time=70.019,key="1"},
    {time=70.204,key="3"},
    {time=70.297,key="0"},
    {time=70.390,key="1"},
    {time=70.482,key="0"},
    {time=70.576,key="3"},
    {time=70.680,key="q"},
    {time=70.773,key="1"},
    {time=70.970,key="6"},
    {time=71.156,key="6"},
    {time=71.342,key="3"},
    {time=71.516,key="3"},
    {time=71.715,key="%"},
    {time=71.796,key="9"},
    {time=71.889,key="2"},
    {time=71.981,key="9"},
    {time=72.086,key="3"},
    {time=72.260,key="3"},
    {time=72.376,key="2"},
    {time=72.469,key="6"},
    {time=72.562,key="8"},
    {time=72.644,key="1"},
    {time=72.736,key="8"},
    {time=72.933,key="3"},
    {time=73.026,key="6"},
    {time=73.107,key="1"},
    {time=73.305,key="7"},
    {time=73.409,key="7"},
    {time=73.502,key="7"},
    {time=73.574,key="$"},
    {time=73.759,key="7"},
    {time=73.969,key="7"},
    {time=74.340,key="7"},
    {time=74.711,key="3"},
    {time=74.816,key="6"},
    {time=74.897,key="1"},
    {time=75.036,key="3"},
    {time=75.188,key="3"},
    {time=75.269,key="1"},
    {time=75.373,key="0"},
    {time=75.466,key="3"},
    {time=75.549,key="6"},
    {time=75.642,key="1"},
    {time=75.827,key="u"},
    {time=76.013,key="0"},
    {time=76.210,key="6"},
    {time=76.396,key="1"},
    {time=76.581,key="3"},
    {time=76.768,key="6"},
    {time=76.953,key="6"},
    {time=77.151,key="e"},
    {time=77.208,key="1"},
    {time=77.336,key="t"},
    {time=77.511,key="1"},
    {time=77.709,key="2"},
    {time=77.883,key="4"},
    {time=78.069,key="1"},
    {time=78.267,key="1"},
    {time=78.359,key="e"},
    {time=78.452,key="7"},
    {time=78.638,key="W"},
    {time=78.835,key="6"},
    {time=78.940,key="0"},
    {time=79.021,key="1"},
    {time=79.207,key="3"},
    {time=79.300,key="0"},
    {time=79.404,key="$"},
    {time=79.486,key="8"},
    {time=79.592,key="%"},
    {time=79.754,key="3"},
    {time=79.951,key="6"},
    {time=80.091,key="6"},
    {time=80.706,key="6"},
    {time=81.567,key="1"},
    {time=81.764,key="5"},
    {time=81.845,key="6"},
    {time=81.949,key="3"},
    {time=82.007,key="o"},
    {time=82.089,key="6"},
    {time=82.147,key="7"},
    {time=82.205,key="3"},
    {time=82.438,key="3"},
    {time=83.099,key="1"},
    {time=83.250,key="5"},
    {time=83.307,key="6"},
    {time=83.401,key="2"},
    {time=83.529,key="2"},
    {time=83.750,key="6"},
    {time=84.307,key="1"},
    {time=84.435,key="o"},
    {time=84.540,key="1"},
    {time=84.609,key="e"},
    {time=84.691,key="5"},
    {time=84.853,key="3"},
    {time=85.329,key="1"},
    {time=85.481,key="6"},
    {time=85.574,key="1"},
    {time=85.842,key="6"},
    {time=86.271,key="3"},
    {time=86.399,key="5"},
    {time=86.584,key="6"},
    {time=86.747,key="3"},
    {time=87.142,key="6"},
    {time=87.304,key="4"},
    {time=87.537,key="6"},
    {time=88.002,key="w"},
    {time=88.106,key="1"},
    {time=88.165,key="2"},
    {time=88.293,key="3"},
    {time=88.652,key="1"},
    {time=88.745,key="5"},
    {time=88.931,key="6"},
    {time=88.989,key="6"},
    {time=89.314,key="6"},
    {time=89.408,key="1"},
    {time=89.605,key="3"},
    {time=89.873,key="6"},
    {time=90.151,key="6"},
    {time=90.465,key="3"},
    {time=90.650,key="3"},
    {time=90.731,key="3"},
    {time=90.859,key="6"},
    {time=91.092,key="6"},
    {time=91.289,key="e"},
    {time=91.383,key="1"},
    {time=91.510,key="3"},
    {time=91.697,key="6"},
    {time=91.905,key="6"},
    {time=92.161,key="2"},
    {time=92.300,key="3"},
    {time=92.474,key="6"},
    {time=92.753,key="6"},
    {time=92.834,key="3"},
    {time=93.020,key="3"},
    {time=93.195,key="1"},
    {time=93.370,key="6"},
    {time=93.555,key="3"},
    {time=93.742,key="3"},
    {time=93.916,key="u"},
    {time=94.101,key="0"},
    {time=94.194,key="6"},
    {time=94.286,key="3"},
    {time=94.473,key="3"},
    {time=94.647,key="1"},
    {time=94.740,key="@"},
    {time=94.844,key="6"},
    {time=95.006,key="6"},
    {time=95.088,key="1"},
    {time=95.204,key="8"},
    {time=95.379,key="3"},
    {time=95.542,key="%"},
    {time=95.693,key="%"},
    {time=95.844,key="9"},
    {time=95.936,key="3"},
    {time=96.006,key="6"},
    {time=96.111,key="3"},
    {time=96.355,key="6"},
    {time=96.471,key="1"},
    {time=96.564,key="8"},
    {time=96.656,key="3"},
    {time=96.819,key="6"},
    {time=97.028,key="7"},
    {time=97.086,key="$"},
    {time=97.214,key="7"},
    {time=97.378,key="$"},
    {time=97.564,key="7"},
    {time=97.749,key="3"},
    {time=98.098,key="3"},
    {time=98.376,key="$"},
    {time=98.480,key="3"},
    {time=98.643,key="6"},
    {time=98.771,key="3"},
    {time=98.841,key="3"},
    {time=98.933,key="3"},
    {time=99.015,key="1"},
    {time=99.096,key="0"},
    {time=99.200,key="6"},
    {time=99.282,key="3"},
    {time=99.353,key="3"},
    {time=99.539,key="u"},
    {time=99.713,key="3"},
    {time=99.805,key="0"},
    {time=99.910,key="6"},
    {time=100.073,key="6"},
    {time=100.258,key="3"},
    {time=100.444,key="1"},
    {time=100.676,key="6"},
    {time=100.793,key="e"},
    {time=100.978,key="t"},
    {time=101.175,key="1"},
    {time=101.292,key="6"},
    {time=101.351,key="2"},
    {time=101.421,key="t"},
    {time=101.514,key="4"},
    {time=101.699,key="1"},
    {time=102.071,key="7"},
    {time=102.245,key="7"},
    {time=102.407,key="e"},
    {time=102.511,key="6"},
    {time=102.581,key="1"},
    {time=102.755,key="3"},
    {time=102.860,key="0"},
    {time=102.953,key="$"},
    {time=103.034,key="8"},
    {time=103.127,key="%"},
    {time=103.290,key="%"},
    {time=103.477,key="6"},
    {time=103.534,key="3"},
    {time=103.836,key="6"},
    {time=104.197,key="2"},
    {time=104.382,key="4"},
    {time=104.464,key="6"},
    {time=104.556,key="9"},
    {time=104.730,key="4"},
    {time=104.905,key="4"},
    {time=105.091,key="4"},
    {time=105.265,key="2"},
    {time=105.615,key="6"},
    {time=105.789,key="1"},
    {time=105.963,key="8"},
    {time=106.136,key="1"},
    {time=106.323,key="3"},
    {time=106.497,key="1"},
    {time=106.671,key="6"},
    {time=106.961,key="2"},
    {time=107.019,key="W"},
    {time=107.369,key="7"},
    {time=107.543,key="3"},
    {time=107.729,key="9"},
    {time=107.903,key="%"},
    {time=108.077,key="3"},
    {time=108.228,key="2"},
    {time=108.391,key="2"},
    {time=108.449,key="6"},
    {time=108.611,key="e"},
    {time=108.785,key="1"},
    {time=108.971,key="3"},
    {time=109.122,key="$"},
    {time=109.192,key="3"},
    {time=109.274,key="^"},
    {time=109.332,key="W"},
    {time=109.506,key="%"},
    {time=109.680,key="2"},
    {time=109.843,key="2"},
    {time=109.901,key="2"},
    {time=110.041,key="6"},
    {time=110.203,key="6"},
    {time=110.377,key="6"},
    {time=110.551,key="2"},
    {time=110.736,key="4"},
    {time=110.911,key="6"},
    {time=111.085,key="2"},
    {time=111.249,key="1"},
    {time=111.423,key="6"},
    {time=111.585,key="3"},
    {time=111.783,key="1"},
    {time=111.969,key="1"},
    {time=112.143,key="6"},
    {time=112.317,key="e"},
    {time=112.503,key="6"},
    {time=112.666,key="4"},
    {time=112.851,key="4"},
    {time=113.049,key="2"},
    {time=113.211,key="4"},
    {time=113.375,key="3"},
    {time=113.572,key="7"},
    {time=113.723,key="3"},
    {time=113.885,key="7"},
    {time=114.083,key="1"},
    {time=114.165,key="6"},
    {time=114.594,key="3"},
    {time=114.815,key="e"},
    {time=115.024,key="3"},
    {time=115.175,key="3"},
    {time=115.303,key="5"},
    {time=115.490,key="3"},
    {time=115.594,key="6"},
    {time=115.675,key="3"},
    {time=115.756,key="1"},
    {time=115.907,key="3"},
    {time=116.011,key="1"},
    {time=116.104,key="3"},
    {time=116.291,key="6"},
    {time=116.372,key="3"},
    {time=116.453,key="1"},
    {time=116.523,key="8"},
    {time=116.604,key="6"},
    {time=116.720,key="1"},
    {time=116.894,key="6"},
    {time=117.056,key="6"},
    {time=117.232,key="6"},
    {time=117.290,key="q"},
    {time=117.395,key="1"},
    {time=117.580,key="6"},
    {time=117.743,key="6"},
    {time=117.928,key="8"},
    {time=117.998,key="e"},
    {time=118.092,key="1"},
    {time=118.277,key="%"},
    {time=118.370,key="q"},
    {time=118.463,key="3"},
    {time=118.555,key="9"},
    {time=118.625,key="q"},
    {time=118.765,key="2"},
    {time=118.974,key="e"},
    {time=119.136,key="6"},
    {time=119.230,key="8"},
    {time=119.311,key="e"},
    {time=119.393,key="3"},
    {time=119.485,key="1"},
    {time=119.648,key="$"},
    {time=119.765,key="7"},
    {time=119.846,key="7"},
    {time=120.020,key="7"},
    {time=120.205,key="7"},
    {time=120.356,key="3"},
    {time=120.415,key="7"},
    {time=120.717,key="7"},
    {time=120.983,key="$"},
    {time=121.076,key="6"},
    {time=121.157,key="3"},
    {time=121.217,key="6"},
    {time=121.286,key="6"},
    {time=121.415,key="3"},
    {time=121.496,key="6"},
    {time=121.589,key="1"},
    {time=121.670,key="8"},
    {time=121.751,key="3"},
    {time=121.832,key="8"},
    {time=121.925,key="6"},
    {time=122.018,key="8"},
    {time=122.099,key="3"},
    {time=122.180,key="6"},
    {time=122.261,key="3"},
    {time=122.343,key="8"},
    {time=122.435,key="3"},
    {time=122.598,key="3"},
    {time=122.761,key="%"},
    {time=122.866,key="3"},
    {time=122.947,key="1"},
    {time=123.132,key="e"},
    {time=123.273,key="1"},
    {time=123.458,key="t"},
    {time=123.528,key="3"},
    {time=123.633,key="1"},
    {time=123.807,key="2"},
    {time=123.970,key="a"},
    {time=124.132,key="1"},
    {time=124.480,key="7"},
    {time=124.561,key="7"},
    {time=124.678,key="2"},
    {time=124.818,key="3"},
    {time=124.922,key="e"},
    {time=125.015,key="8"},
    {time=125.096,key="0"},
    {time=125.178,key="3"},
    {time=125.248,key="0"},
    {time=125.352,key="$"},
    {time=125.422,key="e"},
    {time=125.515,key="%"},
    {time=125.690,key="^"},
    {time=125.782,key="$"},
    {time=125.875,key="6"},
    {time=126.317,key="6"},
    {time=126.548,key="E"},
    {time=126.642,key="i"},
    {time=126.723,key="E"},
    {time=126.804,key="q"},
    {time=126.885,key="E"},
    {time=126.967,key="i"},
    {time=127.048,key="!"},
    {time=127.129,key="i"},
    {time=127.211,key="E"},
    {time=127.293,key="i"},
    {time=127.374,key="E"},
    {time=127.455,key="i"},
    {time=127.548,key="E"},
    {time=127.618,key="i"},
    {time=127.710,key="!"},
    {time=127.873,key="E"},
    {time=128.047,key="i"},
    {time=128.128,key="4"},
    {time=128.222,key="E"},
    {time=128.279,key="4"},
    {time=128.384,key="E"},
    {time=128.547,key="E"},
    {time=128.709,key="E"},
    {time=128.883,key="T"},
    {time=128.953,key="4"},
    {time=129.057,key="!"},
    {time=129.198,key="Y"},
    {time=129.291,key="t"},
    {time=129.360,key="Y"},
    {time=129.453,key="t"},
    {time=129.546,key="1"},
    {time=129.708,key="1"},
    {time=129.872,key="i"},
    {time=129.953,key="T"},
    {time=130.034,key="i"},
    {time=130.116,key="T"},
    {time=130.197,key="i"},
    {time=130.359,key="E"},
    {time=130.533,key="1"},
    {time=130.615,key="t"},
    {time=130.684,key="1"},
    {time=130.777,key="t"},
    {time=130.858,key="w"},
    {time=130.986,key="1"},
    {time=131.173,key="4"},
    {time=131.521,key="4"},
    {time=131.834,key="q"},
    {time=131.916,key="E"},
    {time=132.009,key="q"},
    {time=132.172,key="E"},
    {time=132.241,key="q"},
    {time=132.334,key="!"},
    {time=132.404,key="q"},
    {time=132.497,key="E"},
    {time=132.554,key="4"},
    {time=132.648,key="q"},
    {time=132.729,key="i"},
    {time=132.810,key="E"},
    {time=132.984,key="!"},
    {time=133.125,key="^"},
    {time=133.218,key="4"},
    {time=133.299,key="E"},
    {time=133.461,key="E"},
    {time=133.613,key="!"},
    {time=133.775,key="E"},
    {time=133.938,key="E"},
    {time=134.100,key="T"},
    {time=134.262,key="!"},
    {time=134.425,key="@"},
    {time=134.588,key="t"},
    {time=134.739,key="!"},
    {time=134.901,key="!"},
    {time=134.971,key="E"},
    {time=135.075,key="1"},
    {time=135.378,key="^"},
    {time=135.436,key="E"},
    {time=135.541,key="!"},
    {time=135.599,key="E"},
    {time=135.680,key="4"},
    {time=135.761,key="E"},
    {time=135.994,key="e"},
    {time=136.075,key="6"},
    {time=136.156,key="4"},
    {time=136.307,key="E"},
    {time=136.400,key="$"},
    {time=136.470,key="o"},
    {time=136.714,key="6"},
    {time=136.934,key="("},
    {time=137.075,key="8"},
    {time=137.156,key="("},
    {time=137.307,key="8"},
    {time=137.389,key="^"},
    {time=137.540,key="8"},
    {time=137.690,key="6"},
    {time=137.852,key="^"},
    {time=137.933,key="4"},
    {time=138.016,key="^"},
    {time=138.166,key="4"},
    {time=138.317,key="5"},
    {time=138.468,key="6"},
    {time=138.537,key="E"},
    {time=138.607,key="4"},
    {time=138.770,key="E"},
    {time=138.828,key="!"},
    {time=139.048,key="5"},
    {time=139.131,key="4"},
    {time=139.189,key="%"},
    {time=139.270,key="2"},
    {time=139.340,key="%"},
    {time=139.398,key="1"},
    {time=139.560,key="4"},
    {time=139.642,key="1"},
    {time=139.734,key="^"},
    {time=139.863,key="1"},
    {time=140.025,key="$"},
    {time=140.257,key="6"},
    {time=140.339,key="5"},
    {time=140.582,key="6"},
    {time=141.815,key="^"},
    {time=141.872,key="3"},
    {time=141.977,key="6"},
    {time=142.697,key="7"},
    {time=142.859,key="6"},
    {time=143.301,key="^"},
    {time=148.935,key="4"}
}

-- ══════════════════════════════════════════════════════════════
--  童謡・クラシック (変更なし)
-- ══════════════════════════════════════════════════════════════

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


-- ══════════════════════════════════════════════════════════════
--  Rayfield UI 構築
-- ══════════════════════════════════════════════════════════════

local Window = Rayfield:CreateWindow({
    Name = "🎹 Virtual Piano v4",
    LoadingTitle = "Piano Player",
    LoadingSubtitle = "16曲 + MIDIインポート対応",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- ── タブ: メイン設定 ─────────────────────────────────────────
local TabSetup = Window:CreateTab("⚙ 設定", 4483345998)

TabSetup:CreateButton({
    Name = "🎹 ピアノをセットアップ",
    Callback = function() setupPiano() end,
})

TabSetup:CreateSlider({
    Name = "🎵 再生速度",
    Range = {50, 200},
    Increment = 25,
    Suffix = "%",
    CurrentValue = 100,
    Flag = "SpeedSlider",
    Callback = function(v)
        speedMult = v / 100
        Rayfield:Notify({Title="⚡ Speed",Content=v.."%",Duration=1,Image="rbxassetid://4483345998"})
    end,
})

TabSetup:CreateButton({
    Name = "⏹ 演奏を停止",
    Callback = function() stopSong() end,
})

TabSetup:CreateButton({
    Name = "🎵 メロディのみモード (現在の曲)",
    Callback = function()
        Rayfield:Notify({Title="ℹ Info",Content="次に再生する曲からメロディ抽出が適用されます",Duration=3,Image="rbxassetid://4483345998"})
    end,
})

-- ── タブ: Libra Heart ────────────────────────────────────────
local TabLibra = Window:CreateTab("🎸 Libra Heart", 4483345998)

TabLibra:CreateButton({
    Name = "▶ Libra Heart 1 (完全版 ~225s)",
    Callback = function()
        playSong(notes_libra1, "Libra Heart 1")
    end,
})

TabLibra:CreateButton({
    Name = "▶ Libra Heart 1 (メロディのみ)",
    Callback = function()
        playSong(melodyOnly(notes_libra1), "Libra Heart 1 [Melody]")
    end,
})

TabLibra:CreateButton({
    Name = "▶ Libra Heart 2 (両手版 27s)",
    Callback = function()
        playSong(notes_libra2, "Libra Heart 2")
    end,
})

-- ── タブ: 童謡・クラシック ───────────────────────────────────
local TabClassic = Window:CreateTab("🎼 クラシック", 4483345998)

TabClassic:CreateButton({
    Name = "▶ きらきら星",
    Callback = function() playSong(notes_twinkle, "きらきら星") end,
})

TabClassic:CreateButton({
    Name = "▶ 歓喜の歌 (Ode to Joy)",
    Callback = function() playSong(notes_ode, "歓喜の歌") end,
})

TabClassic:CreateButton({
    Name = "▶ Happy Birthday",
    Callback = function() playSong(notes_birthday, "Happy Birthday") end,
})

TabClassic:CreateButton({
    Name = "▶ カノン in D (Pachelbel)",
    Callback = function() playSong(notes_canon, "カノン in D") end,
})

TabClassic:CreateButton({
    Name = "▶ エリーゼのために (Beethoven)",
    Callback = function() playSong(notes_furelise, "エリーゼのために") end,
})

-- ── タブ: J-Pop / Anime ──────────────────────────────────────
local TabJpop = Window:CreateTab("🎵 J-Pop/Anime", 4483345998)

TabJpop:CreateButton({
    Name = "▶ 夜に駆ける (YOASOBI)",
    Callback = function() playSong(notes_yoru, "夜に駆ける") end,
})

TabJpop:CreateButton({
    Name = "▶ うっせぇわ (Ado)",
    Callback = function() playSong(notes_ussewa, "うっせぇわ") end,
})

TabJpop:CreateButton({
    Name = "▶ 廻廻奇譚 (Eve / 呪術廻戦)",
    Callback = function() playSong(notes_kaikai, "廻廻奇譚") end,
})

TabJpop:CreateButton({
    Name = "▶ 紅蓮華 (LiSA / 鬼滅の刃)",
    Callback = function() playSong(notes_gurenge, "紅蓮華") end,
})

TabJpop:CreateButton({
    Name = "▶ 残酷な天使のテーゼ (エヴァ)",
    Callback = function() playSong(notes_zankoku, "残酷な天使のテーゼ") end,
})

TabJpop:CreateButton({
    Name = "▶ アイドル (YOASOBI)",
    Callback = function() playSong(notes_idol, "アイドル") end,
})

TabJpop:CreateButton({
    Name = "▶ ブルーバード (NARUTO)",
    Callback = function() playSong(notes_bluebird, "ブルーバード") end,
})

TabJpop:CreateButton({
    Name = "▶ 炎 (LiSA / 鬼滅無限列車)",
    Callback = function() playSong(notes_homura, "炎") end,
})

-- ── タブ: MIDIインポート ─────────────────────────────────────
local TabMidi = Window:CreateTab("🎹 MIDI", 4483345998)

TabMidi:CreateLabel("MIDIファイル変換済み曲 (自動解析 ~149s)")

TabMidi:CreateButton({
    Name = "▶ MIDIインポート曲 (full ~149s)",
    Callback = function()
        playSong(notes_midi, "MIDI Import")
    end,
})

TabMidi:CreateButton({
    Name = "▶ MIDIインポート曲 (メロディのみ)",
    Callback = function()
        playSong(melodyOnly(notes_midi), "MIDI Import [Melody]")
    end,
})

TabMidi:CreateLabel("── MIDIリアルタイム変換エンジン ──")
TabMidi:CreateLabel("使用方法: MIDI pitchコードを入力→変換")

-- インラインMIDI変換ツール
local midiConvertBuffer = {}
local function convertMidiString(str)
    -- "60,62,64,65,67" 形式 (カンマ区切りMIDIピッチ列) を変換
    local result = {}
    local t = 0
    for pitch in str:gmatch("%d+") do
        local p = tonumber(pitch)
        if p then
            local k = midiPitchToKey(p)
            if k then
                table.insert(result, {time=t, key=k})
                t = t + 0.25  -- デフォルト間隔 0.25s
            end
        end
    end
    return result
end

TabMidi:CreateInput({
    Name = "MIDIピッチ列入力 (例: 60,62,64,67,69)",
    PlaceholderText = "60,62,64,65,67,69...",
    RemoveTextAfterFocusLost = false,
    Callback = function(txt)
        midiConvertBuffer = convertMidiString(txt)
        Rayfield:Notify({
            Title="🎹 MIDI変換",
            Content=#midiConvertBuffer.."ノーツ変換完了",
            Duration=3,
            Image="rbxassetid://4483345998"
        })
    end,
})

TabMidi:CreateButton({
    Name = "▶ 変換したMIDIを再生",
    Callback = function()
        if #midiConvertBuffer > 0 then
            playSong(midiConvertBuffer, "MIDI Custom")
        else
            Rayfield:Notify({Title="⚠ エラー",Content="先にMIDIピッチを入力してください",Duration=3,Image="rbxassetid://4483345998"})
        end
    end,
})

-- ── 初期化通知 ───────────────────────────────────────────────
Rayfield:Notify({
    Title = "🎹 Piano Player v4 起動完了",
    Content = "16曲 + MIDIインポート対応\n設定タブでピアノをセットアップしてください",
    Duration = 5,
    Image = "rbxassetid://4483345998",
})
