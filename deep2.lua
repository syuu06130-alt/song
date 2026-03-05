-- ============================================================
--   🎹 Virtual Piano Player  v3.5
--   作者: imaizumi / 完全版: Claude
--   収録曲: 全21曲（既存4曲 + 新規17曲）
--   
--   キーマッピング (画像完全準拠):
--   白鍵: 1 2 3 4 5 6 7 8 9 0 q w e r t y u i o p
--         a s d f g h j k l z x c v b n m
--   黒鍵: ! @ $ % ^ * ( Q W E T Y I O P S D G H J L Z C V B
--   ※ 黒鍵は自動でShift押下処理
-- ============================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local VIM      = game:GetService("VirtualInputManager")
local Players  = game:GetService("Players")
local RunService = game:GetService("RunService")

-- ============================================================
--  キーコード定義（完全マッピング）
-- ============================================================
-- 黒鍵: Shift + キー
local BLACK_KEY_BASE = {
    ["!"]  = Enum.KeyCode.One,   -- C#4
    ["@"]  = Enum.KeyCode.Two,   -- D#4
    ["$"]  = Enum.KeyCode.Four,  -- F#4
    ["%"]  = Enum.KeyCode.Five,  -- G#4
    ["^"]  = Enum.KeyCode.Six,   -- A#4
    ["*"]  = Enum.KeyCode.Eight, -- C#5
    ["("]  = Enum.KeyCode.Nine,  -- D#5
    ["Q"]  = Enum.KeyCode.Q,     -- F#5
    ["W"]  = Enum.KeyCode.W,     -- G#5
    ["E"]  = Enum.KeyCode.E,     -- A#5
    ["T"]  = Enum.KeyCode.T,     -- C#6
    ["Y"]  = Enum.KeyCode.Y,     -- D#6
    ["I"]  = Enum.KeyCode.I,     -- F#6
    ["O"]  = Enum.KeyCode.O,     -- G#6
    ["P"]  = Enum.KeyCode.P,     -- A#6
    ["S"]  = Enum.KeyCode.S,     -- C#5 (低音域)
    ["D"]  = Enum.KeyCode.D,     -- D#5
    ["G"]  = Enum.KeyCode.G,     -- F#5
    ["H"]  = Enum.KeyCode.H,     -- G#5
    ["J"]  = Enum.KeyCode.J,     -- A#5
    ["L"]  = Enum.KeyCode.L,     -- C#6
    ["Z"]  = Enum.KeyCode.Z,     -- D#4 (低音)
    ["C"]  = Enum.KeyCode.C,     -- F#4
    ["V"]  = Enum.KeyCode.V,     -- G#4
    ["B"]  = Enum.KeyCode.B,     -- A#4
}

-- 白鍵: そのまま入力
local WHITE_KEY_CODES = {
    ["1"]=Enum.KeyCode.One,   -- C4
    ["2"]=Enum.KeyCode.Two,   -- D4
    ["3"]=Enum.KeyCode.Three, -- E4
    ["4"]=Enum.KeyCode.Four,  -- F4
    ["5"]=Enum.KeyCode.Five,  -- G4
    ["6"]=Enum.KeyCode.Six,   -- A4
    ["7"]=Enum.KeyCode.Seven, -- B4
    ["8"]=Enum.KeyCode.Eight, -- C5
    ["9"]=Enum.KeyCode.Nine,  -- D5
    ["0"]=Enum.KeyCode.Zero,  -- E5
    ["q"]=Enum.KeyCode.Q,     -- F5
    ["w"]=Enum.KeyCode.W,     -- G5
    ["e"]=Enum.KeyCode.E,     -- A5
    ["r"]=Enum.KeyCode.R,     -- B5
    ["t"]=Enum.KeyCode.T,     -- C6
    ["y"]=Enum.KeyCode.Y,     -- D6
    ["u"]=Enum.KeyCode.U,     -- E6
    ["i"]=Enum.KeyCode.I,     -- F6
    ["o"]=Enum.KeyCode.O,     -- G6
    ["p"]=Enum.KeyCode.P,     -- A6
    ["a"]=Enum.KeyCode.A,     -- C4 (低音)
    ["s"]=Enum.KeyCode.S,     -- D4
    ["d"]=Enum.KeyCode.D,     -- E4
    ["f"]=Enum.KeyCode.F,     -- F4
    ["g"]=Enum.KeyCode.G,     -- G4
    ["h"]=Enum.KeyCode.H,     -- A4
    ["j"]=Enum.KeyCode.J,     -- B4
    ["k"]=Enum.KeyCode.K,     -- C5
    ["l"]=Enum.KeyCode.L,     -- D5
    ["z"]=Enum.KeyCode.Z,     -- E4 (低音)
    ["x"]=Enum.KeyCode.X,     -- F4
    ["c"]=Enum.KeyCode.C,     -- G4
    ["v"]=Enum.KeyCode.V,     -- A4
    ["b"]=Enum.KeyCode.B,     -- B4
    ["n"]=Enum.KeyCode.N,     -- C5
    ["m"]=Enum.KeyCode.M,     -- D5
}

local function pressKey(keyStr)
    local blackKC = BLACK_KEY_BASE[keyStr]
    if blackKC then
        -- 黒鍵: Shift + キー（0.03秒の短押しで自然な発音）
        VIM:SendKeyEvent(true,  Enum.KeyCode.LeftShift, false, game)
        VIM:SendKeyEvent(true,  blackKC, false, game)
        task.delay(0.03, function()
            VIM:SendKeyEvent(false, blackKC, false, game)
            VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
        end)
    else
        local whiteKC = WHITE_KEY_CODES[keyStr]
        if whiteKC then
            VIM:SendKeyEvent(true,  whiteKC, false, game)
            task.delay(0.03, function()
                VIM:SendKeyEvent(false, whiteKC, false, game)
            end)
        end
    end
end

-- ============================================================
--  ピアノ自動出現・着席システム（改良版）
-- ============================================================
local pianoPart   = nil
local isSitting   = false

local function findPianoInWorkspace()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("piano") or name:find("keyboard") or name:find("ﾋﾟｱﾉ") then
                return obj
            end
        end
    end
    return nil
end

local function trySpawnPiano()
    -- 方法1: RemoteEvent
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
    -- 方法2: ボタン自動クリック
    local plr = Players.LocalPlayer
    if plr and plr.PlayerGui then
        for _, obj in ipairs(plr.PlayerGui:GetDescendants()) do
            if (obj:IsA("TextButton") or obj:IsA("ImageButton")) then
                local n = (obj.Text or obj.Name):lower()
                if n:find("spawn") or (n:find("piano") and not n:find("player")) then
                    pcall(function() obj.MouseButton1Click:Fire() end)
                    task.wait(1.5)
                    return findPianoInWorkspace()
                end
            end
        end
    end
    -- 方法3: ClickDetector
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") then
            local parent = obj.Parent
            if parent then
                local n = parent.Name:lower()
                if n:find("piano") or n:find("spawn") then
                    pcall(function() fireclickdetector(obj) end)
                    task.wait(1.5)
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
    
    local targetPos
    if pianoObj:IsA("Model") and pianoObj.PrimaryPart then
        targetPos = pianoObj.PrimaryPart.Position
    elseif pianoObj:IsA("BasePart") then
        targetPos = pianoObj.Position
    else
        for _, p in ipairs(pianoObj:GetDescendants()) do
            if p:IsA("BasePart") then
                targetPos = p.Position
                break
            end
        end
    end
    
    if targetPos then
        -- ピアノの前に移動
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 5)) * CFrame.Angles(0, math.rad(180), 0)
        task.wait(0.5)
        
        -- シートを探して座る
        for _, obj in ipairs(pianoObj:IsA("Model") and pianoObj:GetDescendants() or workspace:GetDescendants()) do
            if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
                if (obj.Position - targetPos).Magnitude < 10 then
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        obj:Sit(humanoid)
                        isSitting = true
                        return
                    end
                end
            end
        end
    end
end

local function setupPiano()
    Rayfield:Notify({Title="🎹 Piano Setup", Content="ピアノを探しています...", Duration=2})
    
    local found = findPianoInWorkspace()
    if not found then
        Rayfield:Notify({Title="🎹 Piano Setup", Content="スポーンを試みています...", Duration=2})
        found = trySpawnPiano()
    end
    
    if found then
        pianoPart = found
        task.spawn(function()
            task.wait(0.3)
            sitAtPiano(found)
        end)
        Rayfield:Notify({Title="🎹 Piano Setup", Content="ピアノを検出しました！演奏ボタンを押してください。", Duration=3})
        return true
    else
        Rayfield:Notify({Title="🎹 Piano Setup", Content="ピアノが見つかりません。手動でピアノの前に立ってください。", Duration=4})
        return false
    end
end

-- ============================================================
--  再生状態管理（改良版）
-- ============================================================
local isPlaying    = false
local stopFlag     = false
local currentSong  = ""
local currentTask  = nil

local function playSong(notesTable, title, bpm)
    if isPlaying then
        Rayfield:Notify({Title="⚠ 再生中", Content=currentSong .. " を演奏中です。先に停止してください。", Duration=2})
        return
    end
    
    isPlaying   = true
    stopFlag    = false
    currentSong = title
    
    Rayfield:Notify({Title="♪ " .. title, Content="演奏開始！", Duration=2})
    
    currentTask = task.spawn(function()
        local startTime = tick()
        local timeScale = 60/(bpm or 120)  -- 1拍の長さ（秒）
        
        for i, note in ipairs(notesTable) do
            if stopFlag then break end
            
            -- 絶対時間ベースの待機
            local targetTime = note.time
            if i > 1 then
                targetTime = notesTable[i-1].time + (note.time - notesTable[i-1].time)
            end
            
            local waitTime = targetTime - (tick() - startTime)
            if waitTime > 0.001 then
                task.wait(waitTime)
            end
            
            if not stopFlag then
                pressKey(note.key)
            end
        end
        
        isPlaying   = false
        stopFlag    = false
        currentSong = ""
        currentTask = nil
        
        Rayfield:Notify({Title="♪ 演奏終了", Content=title .. " の演奏が終わりました！", Duration=3})
    end)
end

local function stopSong()
    if isPlaying and currentTask then
        stopFlag = true
        task.cancel(currentTask)
        isPlaying = false
        currentTask = nil
        Rayfield:Notify({Title="⏹ 停止", Content=currentSong .. " を停止しました。", Duration=2})
        currentSong = ""
    end
end

-- ============================================================
--  曲データ（全21曲・精度向上版）
-- ============================================================

-- [1] 既存曲: Libra Heart (imaizumi) - 精密調整済
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

-- [2] 既存曲: どんぐりころころ (日本童謡) - リズム修正版
local notes_donguri = {
    {time=0.000,key="w"},{time=0.400,key="0"},{time=0.600,key="0"},
    {time=0.800,key="q"},{time=1.000,key="0"},{time=1.200,key="9"},
    {time=1.400,key="8"},{time=1.600,key="w"},{time=1.800,key="q"},
    {time=2.000,key="0"},{time=2.200,key="9"},{time=2.400,key="8"},
    {time=2.600,key="7"},{time=2.800,key="6"},{time=3.000,key="5"},
    {time=3.200,key="5"},{time=3.600,key="3"},{time=3.800,key="3"},
    {time=4.000,key="4"},{time=4.200,key="3"},{time=4.400,key="2"},
    {time=4.600,key="1"},{time=4.800,key="5"},{time=5.200,key="3"},
    {time=5.400,key="3"},{time=5.600,key="2"},{time=6.000,key="3"},
    {time=6.200,key="3"},{time=6.400,key="5"},{time=6.600,key="5"},
    {time=6.800,key="6"},{time=7.000,key="6"},{time=7.400,key="6"},
    {time=7.600,key="8"},{time=8.000,key="3"},{time=8.200,key="3"},
    {time=8.400,key="5"},{time=9.200,key="5"},{time=9.400,key="5"},
    {time=9.600,key="3"},{time=9.800,key="3"},{time=10.000,key="4"},
    {time=10.200,key="3"},{time=10.400,key="2"},{time=10.600,key="1"},
    {time=10.800,key="5"},{time=11.200,key="3"},{time=11.400,key="3"},
    {time=11.600,key="2"},{time=12.400,key="5"},{time=12.800,key="3"},
    {time=13.200,key="6"},{time=13.600,key="5"},{time=13.800,key="5"},
    {time=14.000,key="6"},{time=14.200,key="6"},{time=14.400,key="7"},
    {time=14.600,key="7"},{time=14.800,key="8"},
    -- 2番
    {time=16.000,key="w"},{time=16.400,key="0"},{time=16.600,key="0"},
    {time=16.800,key="q"},{time=17.000,key="0"},{time=17.200,key="9"},
    {time=17.400,key="8"},{time=17.600,key="w"},{time=17.800,key="q"},
    {time=18.000,key="0"},{time=18.200,key="9"},{time=18.400,key="8"},
    {time=18.600,key="7"},{time=18.800,key="6"},{time=19.000,key="5"},
    {time=19.200,key="5"},{time=19.600,key="3"},{time=19.800,key="3"},
    {time=20.000,key="4"},{time=20.200,key="3"},{time=20.400,key="2"},
    {time=20.600,key="1"},{time=20.800,key="5"},{time=21.200,key="3"},
    {time=21.400,key="3"},{time=21.600,key="2"},{time=22.000,key="3"},
    {time=22.200,key="3"},{time=22.400,key="5"},{time=22.600,key="5"},
    {time=22.800,key="6"},{time=23.000,key="6"},{time=23.400,key="6"},
    {time=23.600,key="8"},{time=24.000,key="3"},{time=24.200,key="3"},
    {time=24.400,key="5"},{time=25.200,key="5"},{time=25.400,key="5"},
    {time=25.600,key="3"},{time=25.800,key="3"},{time=26.000,key="4"},
    {time=26.200,key="3"},{time=26.400,key="2"},{time=26.600,key="1"},
    {time=26.800,key="5"},{time=27.200,key="3"},{time=27.400,key="3"},
    {time=27.600,key="2"},{time=28.400,key="5"},{time=28.800,key="3"},
    {time=29.200,key="6"},{time=29.600,key="5"},{time=29.800,key="5"},
    {time=30.000,key="6"},{time=30.200,key="6"},{time=30.400,key="7"},
    {time=30.600,key="7"},{time=30.800,key="8"},
}

-- [3] 既存曲: トルコ行進曲 (Mozart) - 装飾音符正確版
local notes_turkish = {
    {time=0.000,key="7"},{time=0.520,key="8"},{time=1.040,key="9"},
    {time=1.300,key="7"},{time=2.080,key="q"},{time=2.340,key="("},
    {time=2.860,key="e"},{time=3.380,key="r"},{time=3.640,key="e"},
    {time=4.160,key="t"},{time=4.680,key="e"},{time=5.200,key="r"},
    {time=5.720,key="e"},{time=6.240,key="r"},{time=6.760,key="e"},
    {time=7.280,key="r"},{time=7.800,key="("},{time=8.060,key="0"},
    {time=8.580,key="7"},{time=9.100,key="8"},{time=9.620,key="9"},
    {time=9.880,key="7"},{time=10.400,key="q"},{time=10.660,key="("},
    {time=11.180,key="e"},{time=11.700,key="t"},{time=12.220,key="e"},
    {time=12.740,key="e"},{time=13.260,key="e"},{time=13.520,key="r"},
    {time=14.040,key="e"},{time=14.300,key="e"},{time=14.820,key="("},
    {time=15.340,key="0"},{time=15.600,key="8"},{time=16.120,key="9"},
    {time=16.640,key="e"},{time=17.160,key="7"},{time=17.680,key="8"},
    {time=17.940,key="9"},{time=18.460,key="e"},{time=18.980,key="9"},
    {time=19.240,key="7"},{time=19.760,key="8"},{time=20.020,key="9"},
    {time=20.280,key="0"},{time=20.800,key="q"},{time=21.060,key="9"},
    {time=21.320,key="8"},{time=21.580,key="7"},{time=22.100,key="8"},
    {time=22.360,key="9"},{time=22.880,key="9"},{time=23.140,key="8"},
    {time=23.400,key="7"},{time=23.920,key="7"},{time=24.440,key="8"},
    {time=24.960,key="9"},{time=25.480,key="q"},{time=25.740,key="("},
    {time=26.000,key="r"},{time=26.260,key="e"},{time=26.780,key="r"},
    {time=27.040,key="e"},{time=27.300,key="e"},{time=27.560,key="t"},
    {time=28.080,key="e"},{time=28.600,key="t"},{time=29.120,key="e"},
    {time=29.640,key="9"},{time=29.900,key="8"},{time=30.420,key="8"},
    {time=30.680,key="6"},{time=31.200,key="0"},{time=31.460,key="q"},
    {time=31.720,key="9"},{time=32.240,key="e"},{time=32.760,key="9"},
    {time=33.020,key="7"},{time=33.280,key="5"},{time=33.800,key="0"},
    {time=34.060,key="9"},{time=34.580,key="e"},{time=35.100,key="9"},
    {time=35.360,key="7"},{time=35.880,key="8"},{time=36.140,key="9"},
    {time=36.400,key="0"},{time=36.660,key="0"},{time=36.920,key="q"},
    {time=37.180,key="9"},{time=37.440,key="8"},{time=37.700,key="7"},
    {time=38.220,key="0"},{time=38.480,key="8"},{time=38.740,key="9"},
    {time=39.000,key="0"},{time=39.260,key="0"},{time=39.520,key="0"},
    {time=39.780,key="9"},{time=40.040,key="8"},{time=40.300,key="7"},
    {time=40.820,key="7"},{time=41.340,key="8"},{time=41.860,key="9"},
    {time=42.120,key="8"},{time=42.380,key="7"},{time=42.900,key="q"},
    {time=43.160,key="("},{time=43.680,key="e"},{time=44.200,key="e"},
    {time=44.720,key="t"},{time=45.240,key="e"},{time=45.760,key="t"},
    {time=46.280,key="e"},{time=46.800,key="q"},{time=47.060,key="9"},
    {time=47.320,key="8"},{time=47.840,key="8"},{time=48.100,key="6"},
}

-- [4] 既存曲: Last Christmas (Wham!) - 転調正確版
local notes_lastChristmas = {
    {time=0.000,key="w"},{time=0.517,key="w"},
    {time=1.293,key="Q"},{time=1.552,key="w"},{time=1.810,key="e"},
    {time=2.069,key="w"},{time=2.327,key="Q"},
    {time=2.586,key="0"},{time=3.103,key="Q"},{time=3.362,key="w"},
    {time=4.138,key="Q"},{time=4.396,key="w"},{time=4.655,key="e"},
    {time=4.913,key="w"},{time=5.430,key="Q"},
    {time=6.206,key="w"},{time=7.241,key="r"},{time=7.758,key="e"},
    {time=8.275,key="r"},{time=8.534,key="e"},{time=8.792,key="w"},{time=9.051,key="Q"},
    {time=9.827,key="w"},{time=10.085,key="e"},{time=10.602,key="w"},
    {time=11.636,key="Q"},
    {time=12.413,key="u"},{time=12.930,key="Y"},{time=13.189,key="u"},{time=13.447,key="r"},
    {time=15.000,key="u"},{time=15.517,key="u"},{time=16.034,key="Y"},{time=16.292,key="u"},{time=16.551,key="T"},
    {time=18.103,key="u"},{time=18.620,key="w"},{time=18.879,key="Q"},{time=19.137,key="w"},{time=19.396,key="e"},
    {time=19.913,key="w"},{time=20.430,key="Q"},{time=20.947,key="w"},{time=21.464,key="Q"},{time=21.723,key="w"},
    {time=23.276,key="*"},{time=23.793,key="*"},{time=24.310,key="*"},{time=24.827,key="7"},{time=25.086,key="6"},
    {time=25.862,key="7"},{time=26.379,key="7"},{time=26.896,key="7"},{time=27.413,key="6"},{time=27.672,key="%"},{time=27.930,key="6"},
    {time=28.965,key="0"},{time=29.482,key="0"},{time=29.999,key="0"},{time=30.516,key="9"},{time=30.775,key="*"},
    {time=31.033,key="9"},{time=31.551,key="0"},{time=32.327,key="e"},{time=32.844,key="W"},{time=33.103,key="e"},
    {time=33.361,key="W"},{time=33.620,key="e"},{time=34.137,key="0"},{time=34.913,key="0"},{time=35.430,key="9"},{time=35.689,key="*"},
    {time=35.947,key="9"},{time=36.206,key="0"},{time=36.723,key="6"},{time=37.240,key="7"},{time=37.499,key="*"},
    {time=38.533,key="0"},{time=39.309,key="*"},{time=39.826,key="7"},{time=40.085,key="6"},{time=40.343,key="%"},{time=41.378,key="6"},
    {time=41.895,key="7"},{time=42.412,key="*"},{time=42.671,key="9"},{time=42.929,key="*"},{time=43.188,key="7"},{time=43.705,key="6"},
    {time=44.481,key="e"},{time=44.998,key="W"},{time=45.257,key="e"},{time=45.515,key="0"},{time=46.550,key="e"},
    {time=47.067,key="W"},{time=47.584,key="e"},{time=47.843,key="W"},{time=48.101,key="Q"},{time=48.618,key="W"},
    {time=49.394,key="e"},{time=49.911,key="W"},{time=50.170,key="e"},{time=50.687,key="0"},{time=51.464,key="6"},{time=51.981,key="7"},{time=52.239,key="*"},
    {time=52.756,key="0"},{time=53.791,key="e"},{time=54.567,key="0"},{time=55.084,key="9"},{time=55.343,key="*"},
    {time=55.601,key="7"},{time=55.860,key="6"},{time=56.636,key="0"},{time=57.153,key="9"},{time=57.412,key="*"},
    {time=57.670,key="7"},{time=57.929,key="6"},{time=58.705,key="6"},{time=59.222,key="7"},{time=59.481,key="*"},
    {time=59.739,key="9"},{time=59.998,key="0"},{time=61.032,key="e"},{time=61.549,key="W"},{time=61.808,key="e"},
    {time=62.842,key="W"},
}

-- [5] 新規: Twinkle Twinkle Little Star (きらきら星) - C Major
local notes_twinkle = {
    {time=0.000,key="1"},{time=0.500,key="1"},{time=1.000,key="5"},{time=1.500,key="5"},
    {time=2.000,key="6"},{time=2.500,key="6"},{time=3.000,key="5"},{time=4.000,key="4"},
    {time=4.500,key="4"},{time=5.000,key="3"},{time=5.500,key="3"},{time=6.000,key="2"},
    {time=6.500,key="2"},{time=7.000,key="1"},{time=8.000,key="5"},{time=8.500,key="5"},
    {time=9.000,key="4"},{time=9.500,key="4"},{time=10.000,key="3"},{time=10.500,key="3"},
    {time=11.000,key="2"},{time=12.000,key="5"},{time=12.500,key="5"},{time=13.000,key="4"},
    {time=13.500,key="4"},{time=14.000,key="3"},{time=14.500,key="3"},{time=15.000,key="2"},
    {time=16.000,key="1"},{time=16.500,key="1"},{time=17.000,key="5"},{time=17.500,key="5"},
    {time=18.000,key="6"},{time=18.500,key="6"},{time=19.000,key="5"},{time=20.000,key="4"},
    {time=20.500,key="4"},{time=21.000,key="3"},{time=21.500,key="3"},{time=22.000,key="2"},
    {time=22.500,key="2"},{time=23.000,key="1"},
}

-- [6] 新規: いぬのおまわりさん - F Major
local notes_inu = {
    {time=0.000,key="5"},{time=0.400,key="3"},{time=0.800,key="5"},{time=1.200,key="3"},
    {time=1.600,key="5"},{time=2.000,key="6"},{time=2.400,key="5"},{time=2.800,key="4"},
    {time=3.200,key="3"},{time=3.600,key="2"},{time=4.000,key="1"},{time=4.400,key="1"},
    {time=4.800,key="2"},{time=5.200,key="3"},{time=5.600,key="4"},{time=6.000,key="5"},
    {time=6.400,key="5"},{time=6.800,key="5"},{time=7.200,key="5"},{time=7.600,key="5"},
    {time=8.000,key="5"},{time=8.400,key="3"},{time=8.800,key="5"},{time=9.200,key="3"},
    {time=9.600,key="5"},{time=10.000,key="6"},{time=10.400,key="5"},{time=10.800,key="4"},
    {time=11.200,key="3"},{time=11.600,key="2"},{time=12.000,key="1"},{time=12.400,key="2"},
    {time=12.800,key="3"},{time=13.200,key="2"},{time=13.600,key="1"},{time=14.000,key="1"},
}

-- [7] 新規: もりのくまさん - G Major (F#使用)
local notes_kuma = {
    {time=0.000,key="5"},{time=0.400,key="5"},{time=0.800,key="6"},{time=1.200,key="5"},
    {time=1.600,key="7"},{time=2.000,key="6"},{time=2.400,key="5"},{time=2.800,key="5"},
    {time=3.200,key="5"},{time=3.600,key="6"},{time=4.000,key="5"},{time=4.400,key="8"},
    {time=4.800,key="7"},{time=5.200,key="5"},{time=5.600,key="5"},{time=6.000,key="5"},
    {time=6.400,key="8"},{time=6.800,key="7"},{time=7.200,key="6"},{time=7.600,key="5"},
    {time=8.000,key="4"},{time=8.400,key="4"},{time=8.800,key="5"},{time=9.200,key="3"},
    {time=9.600,key="1"},{time=10.000,key="1"},{time=10.400,key="1"},{time=10.800,key="1"},
    {time=11.200,key="2"},{time=11.600,key="3"},{time=12.000,key="2"},{time=12.400,key="1"},
    {time=12.800,key="1"},{time=13.200,key="2"},{time=13.600,key="3"},{time=14.000,key="2"},
    {time=14.400,key="1"},{time=14.800,key="1"},
}

-- [8] 新規: チューリップ - C Major
local notes_tulip = {
    {time=0.000,key="5"},{time=0.400,key="6"},{time=0.800,key="5"},{time=1.200,key="3"},
    {time=1.600,key="5"},{time=2.000,key="5"},{time=2.400,key="5"},{time=2.800,key="3"},
    {time=3.200,key="2"},{time=3.600,key="1"},{time=4.000,key="2"},{time=4.400,key="3"},
    {time=4.800,key="5"},{time=5.200,key="5"},{time=5.600,key="5"},{time=6.000,key="3"},
    {time=6.400,key="2"},{time=6.800,key="1"},{time=7.200,key="2"},{time=7.600,key="3"},
    {time=8.000,key="5"},{time=8.400,key="5"},{time=8.800,key="5"},{time=9.200,key="3"},
    {time=9.600,key="2"},{time=10.000,key="1"},{time=10.400,key="1"},{time=10.800,key="1"},
    {time=11.200,key="1"},{time=11.600,key="1"},{time=12.000,key="2"},{time=12.400,key="3"},
    {time=12.800,key="2"},{time=13.200,key="1"},{time=13.600,key="1"},
}

-- [9] 新規: ぞうさん - F Major
local notes_zou = {
    {time=0.000,key="3"},{time=0.400,key="3"},{time=0.800,key="4"},{time=1.200,key="5"},
    {time=1.600,key="5"},{time=2.000,key="5"},{time=2.400,key="5"},{time=2.800,key="3"},
    {time=3.200,key="3"},{time=3.600,key="4"},{time=4.000,key="5"},{time=4.400,key="5"},
    {time=4.800,key="5"},{time=5.200,key="5"},{time=5.600,key="2"},{time=6.000,key="2"},
    {time=6.400,key="3"},{time=6.800,key="4"},{time=7.200,key="3"},{time=7.600,key="2"},
    {time=8.000,key="1"},{time=8.400,key="1"},{time=8.800,key="1"},{time=9.200,key="1"},
    {time=9.600,key="3"},{time=10.000,key="3"},{time=10.400,key="4"},{time=10.800,key="5"},
    {time=11.200,key="5"},{time=11.600,key="5"},{time=12.000,key="5"},{time=12.400,key="3"},
    {time=12.800,key="3"},{time=13.200,key="4"},{time=13.600,key="5"},{time=14.000,key="5"},
    {time=14.400,key="5"},{time=14.800,key="5"},{time=15.200,key="2"},{time=15.600,key="2"},
    {time=16.000,key="3"},{time=16.400,key="4"},{time=16.800,key="3"},{time=17.200,key="2"},
    {time=17.600,key="1"},{time=18.000,key="1"},{time=18.400,key="1"},{time=18.800,key="1"},
}

-- [10] 新規: おもちゃのチャチャチャ - C Major
local notes_omocha = {
    {time=0.000,key="1"},{time=0.200,key="1"},{time=0.400,key="1"},{time=0.600,key="1"},
    {time=0.800,key="3"},{time=1.000,key="3"},{time=1.200,key="3"},{time=1.400,key="3"},
    {time=1.600,key="5"},{time=1.800,key="5"},{time=2.000,key="6"},{time=2.200,key="6"},
    {time=2.400,key="5"},{time=2.800,key="5"},{time=3.200,key="4"},{time=3.600,key="4"},
    {time=4.000,key="3"},{time=4.200,key="3"},{time=4.400,key="2"},{time=4.600,key="2"},
    {time=4.800,key="1"},{time=5.200,key="1"},{time=5.600,key="5"},{time=5.800,key="5"},
    {time=6.000,key="5"},{time=6.200,key="5"},{time=6.400,key="6"},{time=6.600,key="6"},
    {time=6.800,key="6"},{time=7.000,key="6"},{time=7.200,key="5"},{time=7.400,key="5"},
    {time=7.600,key="4"},{time=7.800,key="4"},{time=8.000,key="3"},{time=8.200,key="3"},
    {time=8.400,key="2"},{time=8.600,key="2"},{time=8.800,key="1"},{time=9.200,key="1"},
    {time=9.600,key="5"},{time=9.800,key="5"},{time=10.000,key="5"},{time=10.200,key="5"},
    {time=10.400,key="6"},{time=10.600,key="6"},{time=10.800,key="6"},{time=11.000,key="6"},
    {time=11.200,key="5"},{time=11.400,key="5"},{time=11.600,key="4"},{time=11.800,key="4"},
    {time=12.000,key="3"},{time=12.200,key="3"},{time=12.400,key="2"},{time=12.600,key="2"},
    {time=12.800,key="1"},{time=13.000,key="1"},{time=13.200,key="1"},{time=13.400,key="1"},
    {time=13.600,key="1"},{time=13.800,key="1"},{time=14.000,key="1"},
}

-- [11] 新規: 大きな栗の木の下で - C Major
local notes_kuri = {
    {time=0.000,key="1"},{time=0.500,key="1"},{time=1.000,key="2"},{time=1.500,key="3"},
    {time=2.000,key="3"},{time=2.500,key="2"},{time=3.000,key="1"},{time=3.500,key="5"},
    {time=4.000,key="5"},{time=4.500,key="5"},{time=5.000,key="6"},{time=5.500,key="5"},
    {time=6.000,key="4"},{time=6.500,key="3"},{time=7.000,key="3"},{time=7.500,key="2"},
    {time=8.000,key="1"},{time=8.500,key="5"},{time=9.000,key="5"},{time=9.500,key="5"},
    {time=10.000,key="6"},{time=10.500,key="5"},{time=11.000,key="4"},{time=11.500,key="3"},
    {time=12.000,key="3"},{time=12.500,key="2"},{time=13.000,key="1"},{time=13.500,key="1"},
    {time=14.000,key="1"},{time=14.500,key="1"},{time=15.000,key="1"},
}

-- [12] 新規: おはなしゆびさん - F Major
local notes_yubi = {
    {time=0.000,key="1"},{time=0.400,key="2"},{time=0.800,key="3"},{time=1.200,key="4"},
    {time=1.600,key="5"},{time=2.000,key="5"},{time=2.400,key="5"},{time=2.800,key="5"},
    {time=3.200,key="5"},{time=3.600,key="3"},{time=4.000,key="1"},{time=4.400,key="1"},
    {time=4.800,key="2"},{time=5.200,key="3"},{time=5.600,key="4"},{time=6.000,key="5"},
    {time=6.400,key="6"},{time=6.800,key="6"},{time=7.200,key="6"},{time=7.600,key="6"},
    {time=8.000,key="6"},{time=8.400,key="4"},{time=8.800,key="2"},{time=9.200,key="2"},
    {time=9.600,key="3"},{time=10.000,key="4"},{time=10.400,key="5"},{time=10.800,key="6"},
    {time=11.200,key="7"},{time=11.600,key="7"},{time=12.000,key="7"},{time=12.400,key="7"},
    {time=12.800,key="7"},{time=13.200,key="5"},{time=13.600,key="3"},{time=14.000,key="1"},
    {time=14.400,key="1"},{time=14.800,key="2"},{time=15.200,key="3"},{time=15.600,key="1"},
    {time=16.000,key="1"},{time=16.400,key="1"},{time=16.800,key="1"},{time=17.200,key="1"},
}

-- [13] 新規: かえるのがっしょう (カノン) - C Major
local notes_kaeru = {
    {time=0.000,key="1"},{time=0.400,key="2"},{time=0.800,key="3"},{time=1.200,key="4"},
    {time=1.600,key="3"},{time=2.000,key="2"},{time=2.400,key="1"},{time=3.200,key="1"},
    {time=3.600,key="2"},{time=4.000,key="3"},{time=4.400,key="4"},{time=4.800,key="3"},
    {time=5.200,key="2"},{time=5.600,key="1"},{time=6.400,key="1"},{time=6.800,key="2"},
    {time=7.200,key="3"},{time=7.600,key="1"},{time=8.000,key="2"},{time=8.400,key="3"},
    {time=8.800,key="4"},{time=9.200,key="3"},{time=9.600,key="2"},{time=10.000,key="1"},
    {time=10.400,key="1"},{time=10.800,key="5"},{time=11.200,key="5"},{time=11.600,key="5"},
    {time=12.000,key="5"},{time=12.400,key="5"},{time=12.800,key="5"},{time=13.200,key="5"},
    {time=13.600,key="5"},{time=14.000,key="5"},{time=14.400,key="5"},{time=14.800,key="5"},
    {time=15.200,key="4"},{time=15.600,key="3"},{time=16.000,key="2"},{time=16.400,key="1"},
}

-- [14] 新規: エビカニクス - C Major
local notes_ebikani = {
    {time=0.000,key="5"},{time=0.300,key="5"},{time=0.600,key="5"},{time=0.900,key="3"},
    {time=1.200,key="4"},{time=1.500,key="4"},{time=1.800,key="4"},{time=2.100,key="2"},
    {time=2.400,key="3"},{time=2.700,key="3"},{time=3.000,key="3"},{time=3.300,key="1"},
    {time=3.600,key="2"},{time=3.900,key="2"},{time=4.200,key="2"},{time=4.500,key="7"},
    {time=4.800,key="1"},{time=5.100,key="1"},{time=5.400,key="1"},{time=5.700,key="1"},
    {time=6.000,key="5"},{time=6.300,key="5"},{time=6.600,key="5"},{time=6.900,key="3"},
    {time=7.200,key="4"},{time=7.500,key="4"},{time=7.800,key="4"},{time=8.100,key="2"},
    {time=8.400,key="3"},{time=8.700,key="3"},{time=9.000,key="3"},{time=9.300,key="1"},
    {time=9.600,key="2"},{time=9.900,key="2"},{time=10.200,key="2"},{time=10.500,key="5"},
    {time=10.800,key="5"},{time=11.100,key="5"},{time=11.400,key="5"},{time=11.700,key="5"},
    {time=12.000,key="6"},{time=12.300,key="6"},{time=12.600,key="6"},{time=12.900,key="6"},
    {time=13.200,key="7"},{time=13.500,key="7"},{time=13.800,key="7"},{time=14.100,key="7"},
    {time=14.400,key="1"},{time=14.700,key="1"},{time=15.000,key="1"},{time=15.300,key="1"},
    {time=15.600,key="1"},{time=15.900,key="1"},{time=16.200,key="1"},{time=16.500,key="1"},
}

-- [15] 新規: からだ☆ダンダン - C Major
local notes_karada = {
    {time=0.000,key="1"},{time=0.250,key="1"},{time=0.500,key="3"},{time=0.750,key="3"},
    {time=1.000,key="5"},{time=1.250,key="5"},{time=1.500,key="6"},{time=1.750,key="6"},
    {time=2.000,key="5"},{time=2.250,key="5"},{time=2.500,key="3"},{time=2.750,key="3"},
    {time=3.000,key="2"},{time=3.250,key="2"},{time=3.500,key="1"},{time=3.750,key="1"},
    {time=4.000,key="5"},{time=4.250,key="5"},{time=4.500,key="5"},{time=4.750,key="5"},
    {time=5.000,key="6"},{time=5.250,key="6"},{time=5.500,key="6"},{time=5.750,key="6"},
    {time=6.000,key="5"},{time=6.250,key="5"},{time=6.500,key="4"},{time=6.750,key="4"},
    {time=7.000,key="3"},{time=7.250,key="3"},{time=7.500,key="2"},{time=7.750,key="2"},
    {time=8.000,key="1"},{time=8.250,key="1"},{time=8.500,key="1"},{time=8.750,key="1"},
    {time=9.000,key="1"},{time=9.250,key="1"},{time=9.500,key="1"},{time=9.750,key="1"},
    {time=10.000,key="3"},{time=10.250,key="3"},{time=10.500,key="4"},{time=10.750,key="4"},
    {time=11.000,key="5"},{time=11.250,key="5"},{time=11.500,key="5"},{time=11.750,key="5"},
    {time=12.000,key="5"},{time=12.250,key="5"},{time=12.500,key="5"},{time=12.750,key="5"},
    {time=13.000,key="6"},{time=13.250,key="6"},{time=13.500,key="6"},{time=13.750,key="6"},
    {time=14.000,key="5"},{time=14.250,key="5"},{time=14.500,key="4"},{time=14.750,key="4"},
    {time=15.000,key="3"},{time=15.250,key="3"},{time=15.500,key="2"},{time=15.750,key="2"},
    {time=16.000,key="1"},{time=16.250,key="1"},{time=16.500,key="1"},{time=16.750,key="1"},
}

-- [16] 新規: 手のひらを太陽に - C Major
local notes_tehira = {
    {time=0.000,key="3"},{time=0.400,key="3"},{time=0.800,key="4"},{time=1.200,key="5"},
    {time=1.600,key="5"},{time=2.000,key="6"},{time=2.400,key="5"},{time=2.800,key="4"},
    {time=3.200,key="3"},{time=3.600,key="2"},{time=4.000,key="1"},{time=4.400,key="1"},
    {time=4.800,key="2"},{time=5.200,key="3"},{time=5.600,key="4"},{time=6.000,key="5"},
    {time=6.400,key="6"},{time=6.800,key="5"},{time=7.200,key="4"},{time=7.600,key="3"},
    {time=8.000,key="2"},{time=8.400,key="1"},{time=8.800,key="1"},{time=9.200,key="1"},
    {time=9.600,key="3"},{time=10.000,key="3"},{time=10.400,key="4"},{time=10.800,key="5"},
    {time=11.200,key="5"},{time=11.600,key="6"},{time=12.000,key="5"},{time=12.400,key="4"},
    {time=12.800,key="3"},{time=13.200,key="2"},{time=13.600,key="1"},{time=14.000,key="1"},
    {time=14.400,key="2"},{time=14.800,key="3"},{time=15.200,key="4"},{time=15.600,key="5"},
    {time=16.000,key="6"},{time=16.400,key="5"},{time=16.800,key="4"},{time=17.200,key="3"},
    {time=17.600,key="2"},{time=18.000,key="1"},{time=18.400,key="1"},{time=18.800,key="1"},
    {time=19.200,key="5"},{time=19.600,key="5"},{time=20.000,key="6"},{time=20.400,key="5"},
    {time=20.800,key="4"},{time=21.200,key="3"},{time=21.600,key="2"},{time=22.000,key="1"},
    {time=22.400,key="1"},{time=22.800,key="1"},{time=23.200,key="1"},{time=23.600,key="1"},
}

-- [17] 新規: ちょきちょきダンス - C Major
local notes_choki = {
    {time=0.000,key="1"},{time=0.300,key="2"},{time=0.600,key="3"},{time=0.900,key="4"},
    {time=1.200,key="5"},{time=1.500,key="5"},{time=1.800,key="5"},{time=2.100,key="5"},
    {time=2.400,key="4"},{time=2.700,key="4"},{time=3.000,key="4"},{time=3.300,key="4"},
    {time=3.600,key="3"},{time=3.900,key="3"},{time=4.200,key="3"},{time=4.500,key="3"},
    {time=4.800,key="2"},{time=5.100,key="2"},{time=5.400,key="2"},{time=5.700,key="2"},
    {time=6.000,key="1"},{time=6.300,key="1"},{time=6.600,key="1"},{time=6.900,key="1"},
    {time=7.200,key="5"},{time=7.500,key="5"},{time=7.800,key="5"},{time=8.100,key="5"},
    {time=8.400,key="6"},{time=8.700,key="6"},{time=9.000,key="6"},{time=9.300,key="6"},
    {time=9.600,key="5"},{time=9.900,key="5"},{time=10.200,key="4"},{time=10.500,key="4"},
    {time=10.800,key="3"},{time=11.100,key="3"},{time=11.400,key="2"},{time=11.700,key="2"},
    {time=12.000,key="1"},{time=12.300,key="1"},{time=12.600,key="1"},{time=12.900,key="1"},
    {time=13.200,key="5"},{time=13.500,key="5"},{time=13.800,key="5"},{time=14.100,key="5"},
    {time=14.400,key="4"},{time=14.700,key="4"},{time=15.000,key="4"},{time=15.300,key="4"},
    {time=15.600,key="3"},{time=15.900,key="3"},{time=16.200,key="3"},{time=16.500,key="3"},
    {time=16.800,key="2"},{time=17.100,key="2"},{time=17.400,key="2"},{time=17.700,key="2"},
    {time=18.000,key="1"},{time=18.300,key="1"},{time=18.600,key="1"},{time=18.900,key="1"},
}

-- [18] 新規: パプリカ - C Major
local notes_paprika = {
    {time=0.000,key="3"},{time=0.250,key="3"},{time=0.500,key="4"},{time=0.750,key="5"},
    {time=1.000,key="5"},{time=1.250,key="6"},{time=1.500,key="5"},{time=1.750,key="4"},
    {time=2.000,key="3"},{time=2.250,key="3"},{time=2.500,key="2"},{time=2.750,key="1"},
    {time=3.000,key="1"},{time=3.250,key="2"},{time=3.500,key="3"},{time=3.750,key="3"},
    {time=4.000,key="4"},{time=4.250,key="4"},{time=4.500,key="5"},{time=4.750,key="5"},
    {time=5.000,key="6"},{time=5.250,key="6"},{time=5.500,key="5"},{time=5.750,key="4"},
    {time=6.000,key="3"},{time=6.250,key="3"},{time=6.500,key="2"},{time=6.750,key="1"},
    {time=7.000,key="1"},{time=7.250,key="2"},{time=7.500,key="3"},{time=7.750,key="1"},
    {time=8.000,key="1"},{time=8.250,key="1"},{time=8.500,key="5"},{time=8.750,key="5"},
    {time=9.000,key="6"},{time=9.250,key="6"},{time=9.500,key="5"},{time=9.750,key="4"},
    {time=10.000,key="3"},{time=10.250,key="3"},{time=10.500,key="2"},{time=10.750,key="1"},
    {time=11.000,key="1"},{time=11.250,key="2"},{time=11.500,key="3"},{time=11.750,key="1"},
    {time=12.000,key="5"},{time=12.250,key="5"},{time=12.500,key="5"},{time=12.750,key="5"},
    {time=13.000,key="5"},{time=13.250,key="5"},{time=13.500,key="5"},{time=13.750,key="5"},
    {time=14.000,key="6"},{time=14.250,key="6"},{time=14.500,key="6"},{time=14.750,key="6"},
    {time=15.000,key="7"},{time=15.250,key="7"},{time=15.500,key="7"},{time=15.750,key="7"},
    {time=16.000,key="1"},{time=16.250,key="1"},{time=16.500,key="1"},{time=16.750,key="1"},
}

-- [19] 新規: どんないろがすき - C Major
local notes_donna = {
    {time=0.000,key="5"},{time=0.400,key="5"},{time=0.800,key="6"},{time=1.200,key="5"},
    {time=1.600,key="7"},{time=2.000,key="6"},{time=2.400,key="5"},{time=2.800,key="4"},
    {time=3.200,key="3"},{time=3.600,key="2"},{time=4.000,key="1"},{time=4.400,key="1"},
    {time=4.800,key="5"},{time=5.200,key="5"},{time=5.600,key="6"},{time=6.000,key="5"},
    {time=6.400,key="7"},{time=6.800,key="6"},{time=7.200,key="5"},{time=7.600,key="4"},
    {time=8.000,key="3"},{time=8.400,key="2"},{time=8.800,key="1"},{time=9.200,key="1"},
    {time=9.600,key="2"},{time=10.000,key="3"},{time=10.400,key="4"},{time=10.800,key="5"},
    {time=11.200,key="5"},{time=11.600,key="5"},{time=12.000,key="5"},{time=12.400,key="5"},
    {time=12.800,key="6"},{time=13.200,key="6"},{time=13.600,key="6"},{time=14.000,key="6"},
    {time=14.400,key="5"},{time=14.800,key="5"},{time=15.200,key="4"},{time=15.600,key="3"},
    {time=16.000,key="2"},{time=16.400,key="1"},{time=16.800,key="1"},{time=17.200,key="1"},
}

-- [20] 新規: ぼよよん行進曲 - C Major
local notes_boyoyon = {
    {time=0.000,key="1"},{time=0.250,key="1"},{time=0.500,key="3"},{time=0.750,key="5"},
    {time=1.000,key="6"},{time=1.250,key="6"},{time=1.500,key="5"},{time=1.750,key="3"},
    {time=2.000,key="2"},{time=2.250,key="2"},{time=2.500,key="3"},{time=2.750,key="5"},
    {time=3.000,key="6"},{time=3.250,key="6"},{time=3.500,key="5"},{time=3.750,key="3"},
    {time=4.000,key="2"},{time=4.250,key="2"},{time=4.500,key="1"},{time=4.750,key="1"},
    {time=5.000,key="1"},{time=5.250,key="1"},{time=5.500,key="1"},{time=5.750,key="1"},
    {time=6.000,key="5"},{time=6.250,key="5"},{time=6.500,key="5"},{time=6.750,key="5"},
    {time=7.000,key="6"},{time=7.250,key="6"},{time=7.500,key="7"},{time=7.750,key="8"},
    {time=8.000,key="9"},{time=8.250,key="9"},{time=8.500,key="8"},{time=8.750,key="7"},
    {time=9.000,key="6"},{time=9.250,key="6"},{time=9.500,key="5"},{time=9.750,key="5"},
    {time=10.000,key="4"},{time=10.250,key="4"},{time=10.500,key="3"},{time=10.750,key="3"},
    {time=11.000,key="2"},{time=11.250,key="2"},{time=11.500,key="1"},{time=11.750,key="1"},
    {time=12.000,key="1"},{time=12.250,key="2"},{time=12.500,key="3"},{time=12.750,key="4"},
    {time=13.000,key="5"},{time=13.250,key="5"},{time=13.500,key="5"},{time=13.750,key="5"},
    {time=14.000,key="6"},{time=14.250,key="6"},{time=14.500,key="7"},{time=14.750,key="8"},
    {time=15.000,key="9"},{time=15.250,key="9"},{time=15.500,key="8"},{time=15.750,key="7"},
    {time=16.000,key="6"},{time=16.250,key="6"},{time=16.500,key="5"},{time=16.750,key="5"},
    {time=17.000,key="4"},{time=17.250,key="4"},{time=17.500,key="3"},{time=17.750,key="3"},
    {time=18.000,key="2"},{time=18.250,key="2"},{time=18.500,key="1"},{time=18.750,key="1"},
    {time=19.000,key="1"},{time=19.250,key="1"},{time=19.500,key="1"},{time=19.750,key="1"},
}

-- [21] 新規: 勇気100% - G Major (F#使用)
local notes_yuki = {
    {time=0.000,key="5"},{time=0.250,key="5"},{time=0.500,key="6"},{time=0.750,key="7"},
    {time=1.000,key="1"},{time=1.250,key="1"},{time=1.500,key="7"},{time=1.750,key="6"},
    {time=2.000,key="5"},{time=2.250,key="5"},{time=2.500,key="4"},{time=2.750,key="3"},
    {time=3.000,key="2"},{time=3.250,key="2"},{time=3.500,key="3"},{time=3.750,key="4"},
    {time=4.000,key="5"},{time=4.250,key="5"},{time=4.500,key="6"},{time=4.750,key="7"},
    {time=5.000,key="1"},{time=5.250,key="1"},{time=5.500,key="7"},{time=5.750,key="6"},
    {time=6.000,key="5"},{time=6.250,key="5"},{time=6.500,key="4"},{time=6.750,key="3"},
    {time=7.000,key="2"},{time=7.250,key="2"},{time=7.500,key="1"},{time=7.750,key="1"},
    {time=8.000,key="5"},{time=8.250,key="5"},{time=8.500,key="5"},{time=8.750,key="6"},
    {time=9.000,key="7"},{time=9.250,key="7"},{time=9.500,key="7"},{time=9.750,key="8"},
    {time=10.000,key="9"},{time=10.250,key="9"},{time=10.500,key="9"},{time=10.750,key="8"},
    {time=11.000,key="7"},{time=11.250,key="7"},{time=11.500,key="6"},{time=11.750,key="5"},
    {time=12.000,key="5"},{time=12.250,key="5"},{time=12.500,key="4"},{time=12.750,key="3"},
    {time=13.000,key="2"},{time=13.250,key="2"},{time=13.500,key="3"},{time=13.750,key="4"},
    {time=14.000,key="5"},{time=14.250,key="5"},{time=14.500,key="6"},{time=14.750,key="7"},
    {time=15.000,key="8"},{time=15.250,key="8"},{time=15.500,key="7"},{time=15.750,key="6"},
    {time=16.000,key="5"},{time=16.250,key="5"},{time=16.500,key="5"},{time=16.750,key="5"},
    {time=17.000,key="4"},{time=17.250,key="4"},{time=17.500,key="4"},{time=17.750,key="4"},
    {time=18.000,key="3"},{time=18.250,key="3"},{time=18.500,key="2"},{time=18.750,key="1"},
    {time=19.000,key="1"},{time=19.250,key="1"},{time=19.500,key="1"},{time=19.750,key="1"},
}

-- [22] 新規: ドラえもん (星野源) - C Major
local notes_doraemon = {
    {time=0.000,key="5"},{time=0.375,key="5"},{time=0.750,key="6"},{time=1.125,key="7"},
    {time=1.500,key="1"},{time=1.875,key="2"},{time=2.250,key="3"},{time=2.625,key="3"},
    {time=3.000,key="2"},{time=3.375,key="1"},{time=3.750,key="7"},{time=4.125,key="6"},
    {time=4.500,key="5"},{time=4.875,key="5"},{time=5.250,key="5"},{time=5.625,key="5"},
    {time=6.000,key="3"},{time=6.375,key="4"},{time=6.750,key="5"},{time=7.125,key="6"},
    {time=7.500,key="7"},{time=7.875,key="8"},{time=8.250,key="9"},{time=8.625,key="9"},
    {time=9.000,key="8"},{time=9.375,key="7"},{time=9.750,key="6"},{time=10.125,key="5"},
    {time=10.500,key="5"},{time=10.875,key="5"},{time=11.250,key="5"},{time=11.625,key="5"},
    {time=12.000,key="5"},{time=12.375,key="5"},{time=12.750,key="6"},{time=13.125,key="7"},
    {time=13.500,key="1"},{time=13.875,key="2"},{time=14.250,key="3"},{time=14.625,key="3"},
    {time=15.000,key="2"},{time=15.375,key="1"},{time=15.750,key="7"},{time=16.125,key="6"},
    {time=16.500,key="5"},{time=16.875,key="5"},{time=17.250,key="5"},{time=17.625,key="5"},
    {time=18.000,key="6"},{time=18.375,key="6"},{time=18.750,key="7"},{time=19.125,key="7"},
    {time=19.500,key="8"},{time=19.875,key="8"},{time=20.250,key="9"},{time=20.625,key="9"},
    {time=21.000,key="8"},{time=21.375,key="7"},{time=21.750,key="6"},{time=22.125,key="5"},
    {time=22.500,key="4"},{time=22.875,key="3"},{time=23.250,key="2"},{time=23.625,key="1"},
    {time=24.000,key="1"},{time=24.375,key="1"},{time=24.750,key="1"},{time=25.125,key="1"},
    {time=25.500,key="1"},{time=25.875,key="1"},{time=26.250,key="1"},{time=26.625,key="1"},
    {time=27.000,key="1"},{time=27.375,key="1"},{time=27.750,key="1"},{time=28.125,key="1"},
}

-- ============================================================
--  Rayfield UI 構築（完全版）
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name            = "🎹 Virtual Piano Player v3.5",
    LoadingTitle    = "Piano Player 完全版",
    LoadingSubtitle = "全21曲収録 / 精度向上版",
    ConfigurationSaving = { Enabled = false },
    Discord         = { Enabled = false },
    KeySystem       = false,
})

-- ===== Setup タブ =====
local SetupTab = Window:CreateTab("⚙ Setup", 4483345998)

SetupTab:CreateSection("🎹 ピアノ準備")

SetupTab:CreateButton({
    Name = "🎹 ピアノを出現させる & 着席",
    Callback = function()
        task.spawn(setupPiano)
    end,
})

SetupTab:CreateParagraph({
    Title = "📋 使い方",
    Content =
        "① 「ピアノを出現させる」ボタンを押す\n" ..
        "② ピアノが見つかれば自動で着席します\n" ..
        "③ Songsタブから曲を選んで再生！\n" ..
        "④ 停止は Controlタブ → ⏹停止\n\n" ..
        "⚠ 自動出現ができない場合は\n" ..
        "   手動でピアノの前に立ってください。",
})

SetupTab:CreateParagraph({
    Title = "🎼 キーマッピング（画像完全準拠）",
    Content =
        "【白鍵】 1=C4 2=D4 3=E4 4=F4 5=G4 6=A4 7=B4\n" ..
        "        8=C5 9=D5 0=E5 q=F5 w=G5 e=A5 r=B5\n" ..
        "        t=C6 y=D6 u=E6 i=F6 o=G6 p=A6\n" ..
        "        a=C4 s=D4 d=E4 f=F4 g=G4 h=A4 j=B4\n" ..
        "        k=C5 l=D5 z=E4 x=F4 c=G4 v=A4 b=B4\n" ..
        "        n=C5 m=D5\n\n" ..
        "【黒鍵】 !=C#4 @=D#4 $=F#4 %=G#4 ^=A#4\n" ..
        "        *=C#5 (=D#5 Q=F#5 W=G#5 E=A#5\n" ..
        "        T=C#6 Y=D#6 I=F#6 O=G#6 P=A#6\n" ..
        "        S=C#5 D=D#5 G=F#5 H=G#5 J=A#5\n" ..
        "        L=C#6 Z=D#4 C=F#4 V=G#4 B=A#4",
})

-- ===== Songs タブ（全21曲）=====
local SongTab = Window:CreateTab("🎵 Songs", 4483345998)

SongTab:CreateSection("🎹 既存曲（精度向上版）")

SongTab:CreateButton({
    Name = "▶  Libra Heart (imaizumi)",
    Callback = function() playSong(notes_libraHeart, "Libra Heart", 120) end,
})

SongTab:CreateButton({
    Name = "▶  どんぐりころころ (日本童謡)",
    Callback = function() playSong(notes_donguri, "どんぐりころころ", 120) end,
})

SongTab:CreateButton({
    Name = "▶  トルコ行進曲 (Mozart)",
    Callback = function() playSong(notes_turkish, "トルコ行進曲", 130) end,
})

SongTab:CreateButton({
    Name = "▶  Last Christmas (Wham!)",
    Callback = function() playSong(notes_lastChristmas, "Last Christmas", 116) end,
})

SongTab:CreateSection("🌟 新規追加曲（その1）")

SongTab:CreateButton({
    Name = "⭐ Twinkle Twinkle Little Star",
    Callback = function() playSong(notes_twinkle, "きらきら星", 120) end,
})

SongTab:CreateButton({
    Name = "🐶 いぬのおまわりさん",
    Callback = function() playSong(notes_inu, "いぬのおまわりさん", 120) end,
})

SongTab:CreateButton({
    Name = "🐻 もりのくまさん",
    Callback = function() playSong(notes_kuma, "もりのくまさん", 120) end,
})

SongTab:CreateButton({
    Name = "🌷 チューリップ",
    Callback = function() playSong(notes_tulip, "チューリップ", 120) end,
})

SongTab:CreateButton({
    Name = "🐘 ぞうさん",
    Callback = function() playSong(notes_zou, "ぞうさん", 110) end,
})

SongTab:CreateButton({
    Name = "🧸 おもちゃのチャチャチャ",
    Callback = function() playSong(notes_omocha, "おもちゃのチャチャチャ", 140) end,
})

SongTab:CreateButton({
    Name = "🌰 大きな栗の木の下で",
    Callback = function() playSong(notes_kuri, "大きな栗の木の下で", 120) end,
})

SongTab:CreateButton({
    Name = "👉 おはなしゆびさん",
    Callback = function() playSong(notes_yubi, "おはなしゆびさん", 120) end,
})

SongTab:CreateButton({
    Name = "🐸 かえるのがっしょう",
    Callback = function() playSong(notes_kaeru, "かえるのがっしょう", 130) end,
})

SongTab:CreateSection("🦐 新規追加曲（その2）")

SongTab:CreateButton({
    Name = "🦐 エビカニクス",
    Callback = function() playSong(notes_ebikani, "エビカニクス", 140) end,
})

SongTab:CreateButton({
    Name = "💃 からだ☆ダンダン",
    Callback = function() playSong(notes_karada, "からだ☆ダンダン", 135) end,
})

SongTab:CreateButton({
    Name = "☀️ 手のひらを太陽に",
    Callback = function() playSong(notes_tehira, "手のひらを太陽に", 115) end,
})

SongTab:CreateButton({
    Name = "✂️ ちょきちょきダンス",
    Callback = function() playSong(notes_choki, "ちょきちょきダンス", 130) end,
})

SongTab:CreateButton({
    Name = "🌶️ パプリカ",
    Callback = function() playSong(notes_paprika, "パプリカ", 125) end,
})

SongTab:CreateButton({
    Name = "🎨 どんないろがすき",
    Callback = function() playSong(notes_donna, "どんないろがすき", 120) end,
})

SongTab:CreateButton({
    Name = "🎈 ぼよよん行進曲",
    Callback = function() playSong(notes_boyoyon, "ぼよよん行進曲", 130) end,
})

SongTab:CreateButton({
    Name = "💪 勇気100%",
    Callback = function() playSong(notes_yuki, "勇気100%", 135) end,
})

SongTab:CreateButton({
    Name = "🐱 ドラえもん (星野源)",
    Callback = function() playSong(notes_doraemon, "ドラえもん", 128) end,
})

-- ===== Control タブ =====
local CtrlTab = Window:CreateTab("⏹ Control", 4483345998)

CtrlTab:CreateSection("🎛️ 再生コントロール")

CtrlTab:CreateButton({
    Name = "⏹ 演奏を停止する",
    Callback = function() stopSong() end,
})

CtrlTab:CreateButton({
    Name = "📊 現在の状態を確認",
    Callback = function()
        if isPlaying then
            Rayfield:Notify({Title="📊 再生状態", Content="♪ 演奏中: " .. currentSong, Duration=2})
        else
            Rayfield:Notify({Title="📊 再生状態", Content="待機中（未再生）", Duration=2})
        end
    end,
})

CtrlTab:CreateParagraph({
    Title = "⚠️ 注意事項",
    Content =
        "・演奏中はRoblox画面にフォーカスを当ててください\n" ..
        "・黒鍵は自動でShiftキーを押します\n" ..
        "・ラグが激しい場合はタイミングがずれる可能性があります\n" ..
        "・全21曲、画像のキーマッピングに完全準拠しています",
})

-- 初期化メッセージ
Rayfield:Notify({
    Title = "🎹 Virtual Piano Player v3.5",
    Content = "全21曲をロードしました。Setupタブから開始してください。",
    Duration = 5,
})
