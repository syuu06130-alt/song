-- ============================================================
--   🎹 Virtual Piano Player  v2.0
--   作者: imaizumi  / 改修: Claude
--
--   収録曲:
--     1. Libra Heart        (imaizumi)
--     2. どんぐりころころ    (日本童謡)
--     3. トルコ行進曲        (Mozart K.331)
--     4. Last Christmas      (Wham!)
--
--   キーマッピング (画像準拠):
--   白鍵: 1 2 3 4 5 6 7 8 9 0 q w e r t y u i o p
--         a s d f g h j k l z x c v b n m
--   黒鍵: ! @ $ % ^ * ( Q W E T Y I O P S D G H J L Z C V B
--   ※黒鍵はShift押しながらの入力で対応
-- ============================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local VIM      = game:GetService("VirtualInputManager")
local Players  = game:GetService("Players")
local RunService = game:GetService("RunService")

-- ============================================================
--  キーコード定義（白鍵＋黒鍵のShift対応）
-- ============================================================
-- BLACK_KEYS: Shift+何かで入力するキー
local BLACK_KEY_BASE = {
    ["!"]  = Enum.KeyCode.One,
    ["@"]  = Enum.KeyCode.Two,
    ["$"]  = Enum.KeyCode.Four,
    ["%"]  = Enum.KeyCode.Five,
    ["^"]  = Enum.KeyCode.Six,
    ["*"]  = Enum.KeyCode.Eight,
    ["("]  = Enum.KeyCode.Nine,
    ["Q"]  = Enum.KeyCode.Q,
    ["W"]  = Enum.KeyCode.W,
    ["E"]  = Enum.KeyCode.E,
    ["T"]  = Enum.KeyCode.T,
    ["Y"]  = Enum.KeyCode.Y,
    ["I"]  = Enum.KeyCode.I,
    ["O"]  = Enum.KeyCode.O,
    ["P"]  = Enum.KeyCode.P,
    ["S"]  = Enum.KeyCode.S,
    ["D"]  = Enum.KeyCode.D,
    ["G"]  = Enum.KeyCode.G,
    ["H"]  = Enum.KeyCode.H,
    ["J"]  = Enum.KeyCode.J,
    ["L"]  = Enum.KeyCode.L,
    ["Z"]  = Enum.KeyCode.Z,
    ["C"]  = Enum.KeyCode.C,
    ["V"]  = Enum.KeyCode.V,
    ["B"]  = Enum.KeyCode.B,
}

-- WHITE_KEYS: そのまま入力
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
        -- 黒鍵: Shift+キー
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

-- ============================================================
--  Piano自動出現・着席システム
-- ============================================================
local pianoPart   = nil   -- 現在使用中のピアノパーツ
local isSitting   = false

local function findPianoInWorkspace()
    -- "Piano" または "VirtualPiano" という名前のモデルを探す
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("piano") or name:find("keyboard") then
                return obj
            end
        end
    end
    return nil
end

local function trySpawnPiano()
    -- 方法1: ReplicatedStorage の SpawnPiano RemoteEvent を探す
    for _, obj in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local n = obj.Name:lower()
            if n:find("spawn") or n:find("piano") or n:find("place") then
                pcall(function() obj:FireServer() end)
                task.wait(1.5)
                return findPianoInWorkspace()
            end
        end
    end
    -- 方法2: StarterGui や PlayerGui にあるボタンを探して押す
    local plr = Players.LocalPlayer
    if plr and plr.PlayerGui then
        for _, obj in ipairs(plr.PlayerGui:GetDescendants()) do
            if (obj:IsA("TextButton") or obj:IsA("ImageButton")) then
                local n = (obj.Text or obj.Name):lower()
                if n:find("spawn") or (n:find("piano") and not n:find("player")) then
                    pcall(function()
                        obj.MouseButton1Click:Fire()
                    end)
                    task.wait(1.5)
                    return findPianoInWorkspace()
                end
            end
        end
    end
    -- 方法3: Workspace の ClickDetector を探す
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") then
            local parent = obj.Parent
            if parent then
                local n = parent.Name:lower()
                if n:find("piano") or n:find("spawn") then
                    pcall(function()
                        fireclickdetector(obj)
                    end)
                    task.wait(1.5)
                    return findPianoInWorkspace()
                end
            end
        end
    end
    return nil
end

local function sitAtPiano(pianoObj)
    -- プレイヤーをピアノの前に移動して座らせる
    local plr = Players.LocalPlayer
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    -- ピアノの位置取得
    local targetPos
    if pianoObj:IsA("Model") and pianoObj.PrimaryPart then
        targetPos = pianoObj.PrimaryPart.Position
    elseif pianoObj:IsA("BasePart") then
        targetPos = pianoObj.Position
    else
        -- 子パーツから位置推定
        for _, p in ipairs(pianoObj:GetDescendants()) do
            if p:IsA("BasePart") then
                targetPos = p.Position
                break
            end
        end
    end
    if targetPos then
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 4))
        task.wait(0.5)
        -- Seat に座る試み
        for _, obj in ipairs(pianoObj:IsA("Model") and pianoObj:GetDescendants() or workspace:GetDescendants()) do
            if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
                local sp = obj.Position
                if (sp - targetPos).Magnitude < 10 then
                    obj:Sit(plr.Character:FindFirstChild("Humanoid"))
                    isSitting = true
                    return
                end
            end
        end
    end
end

local function setupPiano()
    Rayfield:Notify({
        Title = "🎹 Piano Setup",
        Content = "ピアノを探しています...",
        Duration = 2,
        Image = "rbxassetid://4483345998",
    })
    -- まず既存のピアノを探す
    local found = findPianoInWorkspace()
    if not found then
        Rayfield:Notify({
            Title = "🎹 Piano Setup",
            Content = "スポーンを試みています...",
            Duration = 2,
            Image = "rbxassetid://4483345998",
        })
        found = trySpawnPiano()
    end
    if found then
        pianoPart = found
        task.spawn(function()
            task.wait(0.3)
            sitAtPiano(found)
        end)
        Rayfield:Notify({
            Title = "🎹 Piano Setup",
            Content = "ピアノを検出しました！\n演奏ボタンを押してください。",
            Duration = 3,
            Image = "rbxassetid://4483345998",
        })
        return true
    else
        Rayfield:Notify({
            Title = "🎹 Piano Setup",
            Content = "ピアノが見つかりません。\n手動でピアノの前に立って\n演奏ボタンを押してください。",
            Duration = 4,
            Image = "rbxassetid://4483345998",
        })
        return false
    end
end

-- ============================================================
--  再生状態管理
-- ============================================================
local isPlaying    = false
local stopFlag     = false
local currentSong  = ""

local function playSong(notesTable, title)
    if isPlaying then
        Rayfield:Notify({
            Title = "⚠ 再生中",
            Content = currentSong .. " を演奏中です。\n先に⏹停止を押してください。",
            Duration = 2,
            Image = "rbxassetid://4483345998",
        })
        return
    end
    isPlaying   = true
    stopFlag    = false
    currentSong = title

    Rayfield:Notify({
        Title = "♪ " .. title,
        Content = "演奏開始！",
        Duration = 2,
        Image = "rbxassetid://4483345998",
    })

    task.spawn(function()
        local startTime = tick()
        for _, note in ipairs(notesTable) do
            if stopFlag then break end
            local waitTime = note.time - (tick() - startTime)
            if waitTime > 0 then
                task.wait(waitTime)
            end
            if not stopFlag then
                pressKey(note.key)
            end
        end
        isPlaying   = false
        stopFlag    = false
        currentSong = ""
        if not stopFlag then
            Rayfield:Notify({
                Title = "♪ 演奏終了",
                Content = title .. " の演奏が終わりました！",
                Duration = 3,
                Image = "rbxassetid://4483345998",
            })
        end
    end)
end

local function stopSong()
    if isPlaying then
        stopFlag    = true
        isPlaying   = false
        Rayfield:Notify({
            Title = "⏹ 停止",
            Content = currentSong .. " を停止しました。",
            Duration = 2,
            Image = "rbxassetid://4483345998",
        })
        currentSong = ""
    end
end

-- ============================================================
--  曲1: Libra Heart  (imaizumi)
--  旧キーマッピングから新マッピングへ変換済
-- ============================================================
local notes_libraHeart = {
    {time=0.000,key="^"},{time=0.011,key="!"},{time=0.011,key="@"},
    {time=0.117,key="*"},{time=0.360,key="7"},{time=0.360,key="7"},
    {time=0.617,key="$"},{time=0.918,key="7"},{time=1.093,key="r"},
    {time=1.348,key="E"},{time=1.348,key="q"},{time=1.348,key="!"},
    {time=1.359,key="!"},{time=1.603,key="*"},{time=1.615,key="%"},
    {time=1.858,key="!"},{time=1.870,key="!"},{time=2.079,key="E"},
    {time=2.116,key="4"},{time=2.347,key="$"},{time=2.359,key="$"},
    {time=2.486,key="!"},{time=2.498,key="W"},{time=2.835,key="Q"},
    {time=2.847,key="*"},{time=2.858,key="4"},{time=2.870,key="4"},
    {time=3.357,key="@"},{time=3.439,key="Q"},{time=3.624,key="q"},
    {time=3.624,key="^"},{time=3.880,key="!"},{time=4.346,key="7"},
    {time=4.346,key="7"},{time=4.613,key="$"},{time=4.845,key="E"},
    {time=4.856,key="7"},{time=4.868,key="7"},{time=5.355,key="I"},
    {time=5.355,key="!"},{time=5.368,key="Q"},{time=5.368,key="!"},
    {time=5.623,key="%"},{time=5.704,key="W"},{time=5.867,key="*"},
    {time=5.867,key="!"},{time=5.867,key="!"},{time=6.100,key="4"},
    {time=6.344,key="^"},{time=6.344,key="$"},{time=6.355,key="$"},
    {time=6.367,key="Q"},{time=6.367,key="$"},{time=6.646,key="I"},
    {time=6.854,key="Q"},{time=6.867,key="W"},{time=6.867,key="%"},
    {time=6.867,key="4"},{time=6.867,key="4"},{time=7.354,key="Q"},
    {time=7.354,key="^"},{time=7.366,key="@"},{time=7.366,key="@"},
    {time=7.551,key="i"},{time=7.621,key="^"},{time=7.655,key="q"},
    {time=7.865,key="!"},{time=8.366,key="7"},{time=8.366,key="7"},
    {time=8.609,key="$"},{time=8.853,key="$"},{time=8.853,key="7"},
    {time=8.865,key="7"},{time=9.085,key="7"},{time=9.097,key="7"},
    {time=9.120,key="r"},{time=9.352,key="!"},{time=9.364,key="!"},
    {time=9.607,key="!"},{time=9.607,key="%"},{time=9.619,key="!"},
    {time=9.630,key="*"},{time=9.863,key="!"},{time=9.874,key="*"},
    {time=9.874,key="!"},{time=10.364,key="$"},{time=10.364,key="$"},
    {time=10.596,key="W"},{time=10.840,key="Q"},{time=10.851,key="4"},
    {time=10.979,key="4"},{time=11.095,key="*"},{time=11.106,key="W"},
    {time=11.142,key="4"},{time=11.350,key="^"},{time=11.350,key="@"},
    {time=11.361,key="Q"},{time=11.618,key="^"},{time=11.861,key="*"},
    {time=11.873,key="!"},{time=11.954,key="^"},{time=12.083,key="!"},
    {time=12.095,key="^"},{time=12.118,key="Q"},{time=12.350,key="7"},
    {time=12.361,key="7"},{time=12.373,key="Q"},{time=12.420,key="@"},
    {time=12.605,key="$"},{time=12.605,key="7"},{time=12.826,key="7"},
    {time=12.838,key="E"},{time=12.849,key="7"},{time=13.128,key="7"},
    {time=13.128,key="7"},{time=13.360,key="^"},{time=13.372,key="!"},
    {time=13.442,key="Q"},{time=13.604,key="Q"},{time=13.708,key="!"},
    {time=13.720,key="7"},{time=13.859,key="7"},{time=13.871,key="!"},
    {time=14.010,key="Q"},{time=14.197,key="!"},{time=14.336,key="$"},
    {time=14.336,key="$"},{time=14.359,key="Q"},{time=14.476,key="$"},
    {time=14.882,key="4"},{time=14.882,key="!"},{time=15.115,key="$"},
    {time=15.358,key="@"},{time=15.440,key="!"},{time=15.591,key="@"},
    {time=16.115,key="%"},{time=16.289,key="@"},{time=16.381,key="7"},
    {time=16.404,key="$"},{time=16.659,key="!"},{time=16.973,key="7"},
    {time=17.043,key="@"},{time=17.112,key="7"},{time=17.379,key="!"},
    {time=17.449,key="!"},{time=17.705,key="%"},{time=17.844,key="!"},
    {time=17.868,key="!"},{time=18.077,key="$"},{time=18.379,key="$"},
    {time=18.449,key="^"},{time=18.600,key="$"},{time=18.832,key="%"},
    {time=18.832,key="4"},{time=18.972,key="4"},{time=19.343,key="$"},
    {time=19.390,key="!"},{time=19.505,key="@"},{time=20.146,key="^"},
    {time=20.250,key="@"},{time=20.366,key="^"},{time=20.900,key="@"},
    {time=20.900,key="7"},{time=20.923,key="$"},{time=20.934,key="7"},
    {time=21.387,key="^"},{time=21.446,key="!"},{time=21.724,key="4"},
    {time=21.724,key="^"},{time=21.736,key="!"},{time=22.062,key="%"},
    {time=22.097,key="$"},{time=22.376,key="^"},{time=22.399,key="$"},
    {time=22.852,key="%"},{time=22.864,key="7"},{time=22.968,key="4"},
    {time=23.015,key="4"},{time=23.385,key="^"},{time=23.606,key="@"},
    {time=23.746,key="^"},{time=24.362,key="7"},{time=24.362,key="@"},
    {time=24.408,key="7"},{time=24.595,key="$"},{time=24.920,key="^"},
    {time=24.931,key="7"},{time=25.082,key="7"},{time=25.128,key="7"},
    {time=25.454,key="!"},{time=25.755,key="!"},{time=25.825,key="!"},
    {time=25.849,key="!"},{time=26.152,key="$"},{time=26.360,key="$"},
    {time=26.407,key="$"},{time=26.442,key="^"},{time=26.859,key="%"},
    {time=26.987,key="4"},{time=27.116,key="$"},{time=27.405,key="^"},
    {time=27.452,key="$"},{time=27.858,key="^"},{time=28.103,key="^"},
    {time=28.277,key="@"},{time=28.358,key="7"},{time=28.928,key="7"},
    {time=28.928,key="$"},{time=29.078,key="7"},{time=29.114,key="7"},
    {time=29.590,key="!"},{time=29.717,key="$"},{time=29.879,key="!"},
    {time=30.322,key="$"},{time=30.346,key="$"},{time=30.520,key="$"},
    {time=30.554,key="$"},{time=30.856,key="$"},{time=31.007,key="4"},
    {time=31.355,key="@"},{time=31.436,key="$"},{time=31.506,key="@"},
    {time=31.727,key="^"},{time=31.808,key="!"},{time=32.089,key="%"},
    {time=32.134,key="@"},{time=32.251,key="@"},{time=32.344,key="$"},
    {time=32.367,key="7"},{time=32.935,key="7"},{time=33.005,key="@"},
    {time=33.086,key="7"},{time=33.342,key="!"},{time=33.504,key="!"},
    {time=33.714,key="!"},{time=33.725,key="@"},{time=33.760,key="%"},
    {time=33.913,key="!"},{time=34.132,key="^"},{time=34.132,key="4"},
    {time=34.202,key="$"},{time=34.400,key="^"},{time=34.574,key="4"},
    {time=34.899,key="%"},{time=35.003,key="4"},{time=35.352,key="$"},
    {time=35.468,key="@"},{time=35.515,key="@"},{time=35.573,key="!"},
    {time=36.131,key="@"},{time=36.143,key="^"},{time=36.340,key="@"},
    {time=36.944,key="$"},{time=36.967,key="$"},{time=37.002,key="7"},
    {time=37.048,key="7"},{time=37.350,key="^"},{time=37.361,key="4"},
    {time=37.431,key="!"},{time=37.594,key="!"},{time=37.710,key="$"},
    {time=37.908,key="!"},{time=38.106,key="%"},{time=38.141,key="$"},
    {time=38.373,key="^"},{time=38.860,key="%"},{time=38.907,key="4"},
    {time=38.942,key="7"},{time=39.011,key="4"},{time=39.372,key="@"},
    {time=39.395,key="^"},{time=39.557,key="@"},{time=39.731,key="^"},
    {time=39.860,key="!"},{time=40.104,key="^"},{time=40.278,key="@"},
    {time=40.395,key="^"},{time=40.871,key="^"},{time=41.091,key="7"},
    {time=41.115,key="7"},{time=41.347,key="^"},{time=41.485,key="!"},
    {time=41.636,key="!"},{time=41.742,key="4"},{time=41.847,key="!"},
    {time=41.858,key="*"},{time=41.870,key="!"},{time=42.021,key="$"},
    {time=42.357,key="$"},{time=42.393,key="^"},{time=42.869,key="%"},
    {time=42.984,key="4"},{time=43.112,key="$"},{time=43.460,key="^"},
    {time=43.530,key="@"},{time=43.623,key="@"},{time=43.845,key="^"},
    {time=44.402,key="@"},{time=44.914,key="$"},{time=44.948,key="7"},
    {time=45.110,key="7"},{time=45.146,key="7"},{time=45.378,key="^"},
    {time=45.482,key="!"},{time=45.622,key="!"},{time=45.715,key="$"},
    {time=45.867,key="!"},{time=46.145,key="$"},{time=46.157,key="%"},
    {time=46.343,key="$"},{time=46.528,key="$"},{time=46.598,key="@"},
    {time=46.958,key="4"},{time=46.958,key="4"},{time=47.365,key="$"},
    {time=47.446,key="@"},{time=47.620,key="^"},{time=47.819,key="4"},
    {time=47.911,key="!"},{time=48.399,key="!"},{time=48.410,key="7"},
    {time=48.620,key="$"},{time=48.968,key="7"},{time=48.968,key="7"},
    {time=49.119,key="@"},{time=49.362,key="!"},{time=49.525,key="!"},
    {time=49.606,key="%"},{time=49.781,key="%"},{time=49.794,key="%"},
    {time=49.862,key="!"},{time=50.130,key="^"},{time=50.339,key="^"},
    {time=50.362,key="$"},{time=50.362,key="$"},{time=50.595,key="7"},
    {time=50.861,key="4"},{time=50.873,key="4"},{time=50.884,key="@"},
    {time=51.117,key="4"},{time=51.384,key="@"},{time=51.396,key="$"},
    {time=51.616,key="^"},{time=51.861,key="!"},{time=52.140,key="$"},
    {time=52.314,key="$"},{time=52.349,key="7"},{time=52.476,key="%"},
    {time=52.732,key="$"},{time=52.848,key="7"},{time=52.871,key="7"},
    {time=53.103,key="%"},{time=53.382,key="%"},{time=53.382,key="!"},
    {time=53.509,key="^"},{time=53.730,key="%"},{time=54.033,key="$"},
    {time=54.870,key="4"},{time=55.102,key="4"},{time=55.357,key="$"},
    {time=55.450,key="@"},{time=55.531,key="@"},{time=55.869,key="!"},
    {time=56.112,key="4"},{time=56.264,key="@"},{time=56.357,key="@"},
    {time=56.915,key="$"},{time=57.077,key="7"},{time=57.100,key="@"},
    {time=57.518,key="!"},{time=57.669,key="!"},{time=57.868,key="!"},
    {time=58.123,key="7"},{time=58.367,key="$"},{time=58.367,key="$"},
    {time=58.401,key="$"},{time=58.831,key="4"},{time=58.877,key="@"},
    {time=59.098,key="4"},{time=59.353,key="$"},{time=59.540,key="@"},
    {time=60.132,key="$"},{time=60.342,key="%"},{time=60.365,key="7"},
    {time=60.446,key="@"},{time=60.736,key="$"},{time=60.899,key="7"},
    {time=60.922,key="7"},{time=61.073,key="7"},{time=61.108,key="%"},
    {time=61.433,key="!"},{time=61.515,key="^"},{time=61.596,key="!"},
    {time=61.748,key="!"},{time=61.771,key="%"},{time=62.050,key="$"},
    {time=62.386,key="$"},{time=62.421,key="$"},{time=62.700,key="^"},
    {time=62.851,key="^"},{time=63.001,key="4"},
}

-- ============================================================
--  曲2: どんぐりころころ (MIDIより変換 / 新マッピング)
-- ============================================================
local notes_donguri = {
    {time=0.000,key="w"},{time=0.413,key="0"},{time=0.619,key="0"},
    {time=0.826,key="q"},{time=1.032,key="0"},{time=1.239,key="9"},
    {time=1.445,key="8"},{time=1.652,key="w"},{time=1.858,key="q"},
    {time=2.064,key="0"},{time=2.271,key="9"},{time=2.477,key="8"},
    {time=2.684,key="7"},{time=2.890,key="6"},{time=3.097,key="5"},
    {time=3.303,key="5"},{time=3.716,key="3"},{time=3.922,key="3"},
    {time=4.129,key="4"},{time=4.335,key="3"},{time=4.542,key="2"},
    {time=4.748,key="1"},{time=4.955,key="5"},{time=5.367,key="3"},
    {time=5.574,key="3"},{time=5.780,key="2"},{time=6.193,key="3"},
    {time=6.400,key="3"},{time=6.606,key="5"},{time=6.813,key="5"},
    {time=7.019,key="6"},{time=7.225,key="6"},{time=7.638,key="6"},
    {time=7.845,key="8"},{time=8.258,key="3"},{time=8.464,key="3"},
    {time=8.670,key="5"},{time=9.496,key="5"},{time=9.703,key="5"},
    {time=9.909,key="3"},{time=10.116,key="3"},{time=10.322,key="4"},
    {time=10.528,key="3"},{time=10.735,key="2"},{time=10.941,key="1"},
    {time=11.148,key="5"},{time=11.561,key="3"},{time=11.767,key="3"},
    {time=11.973,key="2"},{time=12.799,key="5"},{time=13.212,key="3"},
    {time=13.625,key="6"},{time=14.038,key="5"},{time=14.244,key="5"},
    {time=14.451,key="6"},{time=14.657,key="6"},{time=14.863,key="7"},
    {time=15.070,key="7"},{time=15.276,key="8"},
    -- 2番 (repeat)
    {time=16.515,key="w"},{time=16.928,key="0"},{time=17.135,key="0"},
    {time=17.341,key="q"},{time=17.548,key="0"},{time=17.754,key="9"},
    {time=17.961,key="8"},{time=18.167,key="w"},{time=18.374,key="q"},
    {time=18.580,key="0"},{time=18.786,key="9"},{time=18.993,key="8"},
    {time=19.199,key="7"},{time=19.406,key="6"},{time=19.612,key="5"},
    {time=19.818,key="5"},{time=20.231,key="3"},{time=20.438,key="3"},
    {time=20.644,key="4"},{time=20.851,key="3"},{time=21.057,key="2"},
    {time=21.263,key="1"},{time=21.470,key="5"},{time=21.882,key="3"},
    {time=22.089,key="3"},{time=22.295,key="2"},{time=22.708,key="3"},
    {time=22.915,key="3"},{time=23.121,key="5"},{time=23.328,key="5"},
    {time=23.534,key="6"},{time=23.740,key="6"},{time=24.153,key="6"},
    {time=24.360,key="8"},{time=24.773,key="3"},{time=24.979,key="3"},
    {time=25.185,key="5"},{time=26.011,key="5"},{time=26.218,key="5"},
    {time=26.424,key="3"},{time=26.631,key="3"},{time=26.837,key="4"},
    {time=27.043,key="3"},{time=27.250,key="2"},{time=27.456,key="1"},
    {time=27.663,key="5"},{time=28.076,key="3"},{time=28.282,key="3"},
    {time=28.489,key="2"},{time=29.314,key="5"},{time=29.727,key="3"},
    {time=30.140,key="6"},{time=30.553,key="5"},{time=30.760,key="5"},
    {time=30.966,key="6"},{time=31.172,key="6"},{time=31.379,key="7"},
    {time=31.585,key="7"},{time=31.791,key="8"},
}

-- ============================================================
--  曲3: トルコ行進曲 (MIDIより変換 / 新マッピング / メロディライン)
-- ============================================================
local notes_turkish = {
    {time=1.950,key="7"},{time=2.498,key="8"},{time=3.067,key="9"},
    {time=3.322,key="7"},{time=4.147,key="q"},{time=4.403,key="("},
    {time=4.763,key="e"},{time=5.193,key="r"},{time=5.343,key="e"},
    {time=5.750,key="t"},{time=6.308,key="e"},{time=6.877,key="r"},
    {time=7.725,key="e"},{time=8.004,key="r"},{time=8.829,key="e"},
    {time=9.119,key="r"},{time=9.933,key="("},{time=10.247,key="0"},
    {time=10.827,key="7"},{time=11.361,key="8"},{time=11.931,key="9"},
    {time=12.175,key="7"},{time=13.023,key="q"},{time=13.290,key="("},
    {time=14.208,key="e"},{time=14.626,key="t"},{time=15.195,key="e"},
    {time=15.718,key="e"},{time=16.601,key="e"},{time=16.915,key="r"},
    {time=17.716,key="e"},{time=17.996,key="e"},{time=18.854,key="("},
    {time=19.725,key="0"},{time=19.736,key="8"},{time=20.005,key="9"},
    {time=20.806,key="e"},{time=21.386,key="7"},{time=21.933,key="8"},
    {time=22.212,key="9"},{time=23.036,key="e"},{time=23.582,key="9"},
    {time=23.594,key="7"},{time=24.165,key="8"},{time=24.431,key="9"},
    {time=24.722,key="0"},{time=25.267,key="q"},{time=25.510,key="9"},
    {time=25.627,key="8"},{time=25.801,key="7"},{time=26.371,key="8"},
    {time=26.650,key="9"},{time=27.730,key="9"},{time=27.835,key="8"},
    {time=28.009,key="7"},{time=28.614,key="7"},{time=29.148,key="8"},
    {time=29.704,key="9"},{time=30.785,key="q"},{time=31.053,key="("},
    {time=31.343,key="r"},{time=31.435,key="e"},{time=31.878,key="r"},
    {time=31.995,key="e"},{time=32.261,key="e"},{time=32.435,key="t"},
    {time=32.981,key="e"},{time=33.573,key="t"},{time=34.690,key="e"},
    {time=35.502,key="9"},{time=35.770,key="8"},{time=36.385,key="8"},
    {time=36.722,key="6"},{time=37.430,key="0"},{time=37.709,key="q"},
    {time=37.721,key="9"},{time=38.511,key="e"},{time=39.057,key="9"},
    {time=39.080,key="7"},{time=39.301,key="5"},{time=39.626,key="0"},
    {time=39.906,key="9"},{time=40.719,key="e"},{time=41.276,key="9"},
    {time=41.299,key="7"},{time=41.846,key="8"},{time=42.125,key="9"},
    {time=42.403,key="0"},{time=42.694,key="0"},{time=42.949,key="q"},
    {time=43.240,key="9"},{time=43.355,key="8"},{time=43.506,key="7"},
    {time=43.798,key="0"},{time=44.089,key="8"},{time=44.367,key="9"},
    {time=44.646,key="0"},{time=44.924,key="0"},{time=45.330,key="0"},
    {time=45.470,key="9"},{time=45.585,key="8"},{time=45.750,key="7"},
    {time=46.400,key="7"},{time=46.946,key="8"},{time=47.503,key="9"},
    {time=47.619,key="8"},{time=47.759,key="7"},{time=48.596,key="q"},
    {time=48.851,key="("},{time=49.280,key="e"},{time=49.827,key="e"},
    {time=50.233,key="t"},{time=50.826,key="e"},{time=51.406,key="t"},
    {time=52.487,key="e"},{time=53.045,key="q"},{time=53.300,key="9"},
    {time=53.602,key="8"},{time=54.207,key="8"},{time=54.497,key="6"},
}

-- ============================================================
--  曲4: Last Christmas  (Wham! / Gメジャー / BPM116)
--  G5=w F#5=Q A5=e E5=0 B5=r E6=u D#6=Y C#6=T G#5=W C#5=* D5=9
-- ============================================================
local notes_lastChristmas = {
    -- Verse 1 "Last Christmas I gave you my heart"
    {time=0.000,key="w"},{time=0.517,key="w"},
    {time=1.293,key="Q"},{time=1.552,key="w"},{time=1.810,key="e"},
    {time=2.069,key="w"},{time=2.327,key="Q"},
    {time=2.586,key="0"},{time=3.103,key="Q"},{time=3.362,key="w"},
    {time=4.138,key="Q"},{time=4.396,key="w"},{time=4.655,key="e"},
    {time=4.913,key="w"},{time=5.430,key="Q"},
    -- "but the very next day"
    {time=6.206,key="w"},
    {time=7.241,key="r"},{time=7.758,key="e"},
    {time=8.275,key="r"},{time=8.534,key="e"},{time=8.792,key="w"},{time=9.051,key="Q"},
    -- "you gave it away"
    {time=9.827,key="w"},{time=10.085,key="e"},{time=10.602,key="w"},
    {time=11.636,key="Q"},
    -- "This year to save me from tears"
    {time=12.413,key="u"},{time=12.930,key="Y"},{time=13.189,key="u"},{time=13.447,key="r"},
    {time=15.000,key="u"},
    {time=15.517,key="u"},{time=16.034,key="Y"},{time=16.292,key="u"},{time=16.551,key="T"},
    {time=18.103,key="u"},
    -- "I'll give it to someone special"
    {time=18.620,key="w"},{time=18.879,key="Q"},{time=19.137,key="w"},{time=19.396,key="e"},
    {time=19.913,key="w"},{time=20.430,key="Q"},
    {time=20.947,key="w"},{time=21.464,key="Q"},{time=21.723,key="w"},
    -- Chorus "Once bitten and twice shy"
    {time=23.276,key="*"},{time=23.793,key="*"},
    {time=24.310,key="*"},{time=24.827,key="7"},{time=25.086,key="6"},
    {time=25.862,key="7"},{time=26.379,key="7"},
    {time=26.896,key="7"},{time=27.413,key="6"},{time=27.672,key="%"},{time=27.930,key="6"},
    -- "I keep my distance but"
    {time=28.965,key="0"},{time=29.482,key="0"},
    {time=29.999,key="0"},{time=30.516,key="9"},{time=30.775,key="*"},
    {time=31.033,key="9"},{time=31.551,key="0"},
    -- "tears still catch my eye"
    {time=32.327,key="e"},{time=32.844,key="W"},{time=33.103,key="e"},
    {time=33.361,key="W"},{time=33.620,key="e"},{time=34.137,key="0"},
    -- "Tell me baby do you recognize me?"
    {time=34.913,key="0"},{time=35.430,key="9"},{time=35.689,key="*"},
    {time=35.947,key="9"},{time=36.206,key="0"},
    {time=36.723,key="6"},{time=37.240,key="7"},{time=37.499,key="*"},
    {time=38.533,key="0"},
    -- "Well it's been a year"
    {time=39.309,key="*"},{time=39.826,key="7"},{time=40.085,key="6"},
    {time=40.343,key="%"},{time=41.378,key="6"},
    -- "it doesn't surprise me"
    {time=41.895,key="7"},{time=42.412,key="*"},{time=42.671,key="9"},
    {time=42.929,key="*"},{time=43.188,key="7"},{time=43.705,key="6"},
    -- "Merry Christmas I wrapped it up and sent it"
    {time=44.481,key="e"},{time=44.998,key="W"},{time=45.257,key="e"},
    {time=45.515,key="0"},{time=46.550,key="e"},
    {time=47.067,key="W"},{time=47.584,key="e"},{time=47.843,key="W"},
    {time=48.101,key="Q"},{time=48.618,key="W"},
    -- "with a note saying I love you I meant it"
    {time=49.394,key="e"},{time=49.911,key="W"},{time=50.170,key="e"},
    {time=50.687,key="0"},
    {time=51.464,key="6"},{time=51.981,key="7"},{time=52.239,key="*"},
    {time=52.756,key="0"},{time=53.791,key="e"},
    -- "Now I know what a fool I've been"
    {time=54.567,key="0"},{time=55.084,key="9"},{time=55.343,key="*"},
    {time=55.601,key="7"},{time=55.860,key="6"},
    {time=56.636,key="0"},{time=57.153,key="9"},{time=57.412,key="*"},
    {time=57.670,key="7"},{time=57.929,key="6"},
    -- "but if you kissed me now I know you'd fool me again"
    {time=58.705,key="6"},{time=59.222,key="7"},{time=59.481,key="*"},
    {time=59.739,key="9"},{time=59.998,key="0"},
    {time=61.032,key="e"},{time=61.549,key="W"},{time=61.808,key="e"},
    {time=62.842,key="W"},
}

-- ============================================================
--  Rayfield UI 構築
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name            = "🎹 Virtual Piano Player v2",
    LoadingTitle    = "Piano Player",
    LoadingSubtitle = "4曲収録 / 画像マッピング対応",
    ConfigurationSaving = { Enabled = false },
    Discord         = { Enabled = false },
    KeySystem       = false,
})

-- ===== Setup タブ =====
local SetupTab = Window:CreateTab("⚙ Setup", 4483345998)

SetupTab:CreateSection("ピアノ準備")

SetupTab:CreateButton({
    Name = "🎹  ピアノを出現させる & 着席",
    Callback = function()
        task.spawn(setupPiano)
    end,
})

SetupTab:CreateParagraph({
    Title = "使い方",
    Content =
        "① 「ピアノを出現させる」ボタンを押す\n" ..
        "② ピアノが見つかれば自動で近づきます\n" ..
        "③ Songsタブから曲を選んで再生！\n" ..
        "④ 停止したい時は Controlタブ → ⏹停止\n\n" ..
        "⚠ ゲームによってはピアノ自動出現が\n" ..
        "  できない場合があります。その際は\n" ..
        "  手動でピアノの前に立ってください。",
})

SetupTab:CreateParagraph({
    Title = "キーマッピング",
    Content =
        "白鍵: 1=C4 2=D4 3=E4 4=F4 5=G4 6=A4 7=B4\n" ..
        "      8=C5 9=D5 0=E5 q=F5 w=G5 e=A5...\n" ..
        "黒鍵: !=C#4 @=D#4 $=F#4 %=G#4 ^=A#4\n" ..
        "      *=C#5 (=D#5 Q=F#5 W=G#5 E=A#5...",
})

-- ===== Songs タブ =====
local SongTab = Window:CreateTab("🎵 Songs", 4483345998)

SongTab:CreateSection("演奏する曲を選択")

SongTab:CreateButton({
    Name = "▶  Libra Heart  (imaizumi)",
    Callback = function()
        playSong(notes_libraHeart, "Libra Heart")
    end,
})

SongTab:CreateButton({
    Name = "▶  どんぐりころころ  (日本童謡)",
    Callback = function()
        playSong(notes_donguri, "どんぐりころころ")
    end,
})

SongTab:CreateButton({
    Name = "▶  トルコ行進曲  (Mozart K.331)",
    Callback = function()
        playSong(notes_turkish, "トルコ行進曲")
    end,
})

SongTab:CreateButton({
    Name = "▶  Last Christmas  (Wham!)",
    Callback = function()
        playSong(notes_lastChristmas, "Last Christmas")
    end,
})

-- ===== Control タブ =====
local CtrlTab = Window:CreateTab("⏹ Control", 4483345998)

CtrlTab:CreateSection("再生コントロール")

CtrlTab:CreateButton({
    Name = "⏹  演奏を停止する",
    Callback = function()
        stopSong()
    end,
})

CtrlTab:CreateSection("再生状態")

-- 現在の再生状態を表示するラベル風ボタン
CtrlTab:CreateButton({
    Name = "📊  現在の状態を確認",
    Callback = function()
        if isPlaying then
            Rayfield:Notify({
                Title = "📊 再生状態",
                Content = "♪ 演奏中: " .. currentSong,
                Duration = 2,
                Image = "rbxassetid://4483345998",
            })
        else
            Rayfield:Notify({
                Title = "📊 再生状態",
                Content = "待機中（未再生）",
                Duration = 2,
                Image = "rbxassetid://4483345998",
            })
        end
    end,
})

CtrlTab:CreateParagraph({
    Title = "注意事項",
    Content =
        "・演奏中はRobloxの画面に\n  フォーカスを当ててください\n" ..
        "・黒鍵（#記号など）は自動で\n  Shiftキーを押します\n" ..
        "・ラグが激しい場合はタイミングが\n  ずれることがあります",
})
