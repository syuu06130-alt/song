-- ============================================================
--   🎹 Virtual Piano Player  v3.0
--   作者: imaizumi  / 改修: Claude
--
--   収録曲 (22曲):
--     1. Libra Heart              (imaizumi)
--     2. どんぐりころころ          (日本童謡)
--     3. トルコ行進曲              (Mozart K.331)
--     4. Last Christmas           (Wham!)
--     5. きらきら星                (MIDIより / 英・仏童謡)
--     6. いぬのおまわりさん        (日本童謡)
--     7. もりのくまさん            (日本童謡)
--     8. チューリップ              (日本童謡)
--     9. ぞうさん                  (日本童謡)
--    10. おもちゃのチャチャチャ    (日本童謡)
--    11. 大きな栗の木の下で        (日本童謡)
--    12. おはなしゆびさん          (日本童謡)
--    13. かえるのがっしょう        (日本童謡)
--    14. エビカニクス
--    15. からだ☆ダンダン
--    16. 手のひらを太陽に
--    17. ちょきちょきダンス
--    18. パプリカ
--    19. どんないろがすき
--    20. ぼよよん行進曲
--    21. 勇気100%
--    22. ドラえもん               (星野源)
--
--   キーマッピング (画像準拠):
--   白鍵: 1(C4) 2(D4) 3(E4) 4(F4) 5(G4) 6(A4) 7(B4)
--         8(C5) 9(D5) 0(E5) q(F5) w(G5) e(A5) r(B5)
--         t(C6) y(D6) u(E6) i(F6) o(G6) p(A6) a(B6)
--   黒鍵: !(C#4) @(D#4) $(F#4) %(G#4) ^(A#4)
--         *(C#5) ((D#5) Q(F#5) W(G#5) E(A#5)
--         T(C#6) Y(D#6) I(F#6) O(G#6) P(A#6)
-- ============================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local VIM      = game:GetService("VirtualInputManager")
local Players  = game:GetService("Players")

-- ============================================================
--  キーコード定義
-- ============================================================
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

-- ============================================================
--  Piano 自動出現・着席
-- ============================================================
local pianoPart = nil
local isSitting = false

local function findPianoInWorkspace()
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
    local plr = Players.LocalPlayer
    if plr and plr.PlayerGui then
        for _, obj in ipairs(plr.PlayerGui:GetDescendants()) do
            if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                local n = (obj.Text or obj.Name):lower()
                if n:find("spawn") or (n:find("piano") and not n:find("player")) then
                    pcall(function() obj.MouseButton1Click:Fire() end)
                    task.wait(1.5)
                    return findPianoInWorkspace()
                end
            end
        end
    end
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
            if p:IsA("BasePart") then targetPos = p.Position; break end
        end
    end
    if targetPos then
        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 4))
        task.wait(0.5)
        for _, obj in ipairs(pianoObj:IsA("Model") and pianoObj:GetDescendants() or workspace:GetDescendants()) do
            if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
                if (obj.Position - targetPos).Magnitude < 10 then
                    obj:Sit(plr.Character:FindFirstChild("Humanoid"))
                    isSitting = true
                    return
                end
            end
        end
    end
end

local function setupPiano()
    Rayfield:Notify({Title="🎹 Setup",Content="ピアノを探しています...",Duration=2,Image="rbxassetid://4483345998"})
    local found = findPianoInWorkspace()
    if not found then
        Rayfield:Notify({Title="🎹 Setup",Content="スポーン試行中...",Duration=2,Image="rbxassetid://4483345998"})
        found = trySpawnPiano()
    end
    if found then
        pianoPart = found
        task.spawn(function() task.wait(0.3); sitAtPiano(found) end)
        Rayfield:Notify({Title="🎹 Setup",Content="ピアノ検出！演奏ボタンを押してください。",Duration=3,Image="rbxassetid://4483345998"})
    else
        Rayfield:Notify({Title="🎹 Setup",Content="ピアノが見つかりません。手動で近づいてください。",Duration=4,Image="rbxassetid://4483345998"})
    end
end

-- ============================================================
--  再生管理
-- ============================================================
local isPlaying   = false
local stopFlag    = false
local currentSong = ""

local function playSong(notesTable, title)
    if isPlaying then
        Rayfield:Notify({Title="⚠ 再生中",Content=currentSong.."を演奏中です。先に⏹停止を押してください。",Duration=2,Image="rbxassetid://4483345998"})
        return
    end
    isPlaying = true; stopFlag = false; currentSong = title
    Rayfield:Notify({Title="♪ "..title,Content="演奏開始！",Duration=2,Image="rbxassetid://4483345998"})
    task.spawn(function()
        local startTime = tick()
        for _, note in ipairs(notesTable) do
            if stopFlag then break end
            local waitTime = note.time - (tick() - startTime)
            if waitTime > 0 then task.wait(waitTime) end
            if not stopFlag then pressKey(note.key) end
        end
        isPlaying = false; stopFlag = false
        if not stopFlag then
            Rayfield:Notify({Title="♪ 演奏終了",Content=title.."の演奏が終わりました！",Duration=3,Image="rbxassetid://4483345998"})
        end
        currentSong = ""
    end)
end

local function stopSong()
    if isPlaying then
        stopFlag = true; isPlaying = false
        Rayfield:Notify({Title="⏹ 停止",Content=currentSong.."を停止しました。",Duration=2,Image="rbxassetid://4483345998"})
        currentSong = ""
    end
end


-- ==========================================================
--  曲1: Libra Heart (imaizumi)
-- ==========================================================
local notes_libraHeart = {
    {time=0.000,key="^"},{time=0.011,key="!"},{time=0.011,key="@"},{time=0.117,key="*"},
    {time=0.360,key="7"},{time=0.617,key="$"},{time=0.918,key="7"},{time=1.093,key="r"},
    {time=1.348,key="E"},{time=1.348,key="q"},{time=1.348,key="!"},{time=1.603,key="*"},
    {time=1.615,key="%"},{time=1.858,key="!"},{time=2.079,key="E"},{time=2.116,key="4"},
    {time=2.347,key="$"},{time=2.486,key="!"},{time=2.498,key="W"},{time=2.835,key="Q"},
    {time=2.847,key="*"},{time=2.858,key="4"},{time=3.357,key="@"},{time=3.439,key="Q"},
    {time=3.624,key="q"},{time=3.624,key="^"},{time=3.880,key="!"},{time=4.346,key="7"},
    {time=4.613,key="$"},{time=4.845,key="E"},{time=4.856,key="7"},{time=5.355,key="I"},
    {time=5.355,key="!"},{time=5.368,key="Q"},{time=5.368,key="!"},{time=5.623,key="%"},
    {time=5.704,key="W"},{time=5.867,key="*"},{time=5.867,key="!"},{time=6.100,key="4"},
    {time=6.344,key="^"},{time=6.344,key="$"},{time=6.355,key="$"},{time=6.367,key="Q"},
    {time=6.367,key="$"},{time=6.646,key="I"},{time=6.854,key="Q"},{time=6.867,key="W"},
    {time=6.867,key="%"},{time=6.867,key="4"},{time=7.354,key="Q"},{time=7.354,key="^"},
    {time=7.366,key="@"},{time=7.551,key="i"},{time=7.621,key="^"},{time=7.655,key="q"},
    {time=7.865,key="!"},{time=8.366,key="7"},{time=8.609,key="$"},{time=8.853,key="$"},
    {time=8.853,key="7"},{time=8.865,key="7"},{time=9.085,key="7"},{time=9.097,key="7"},
    {time=9.120,key="r"},{time=9.352,key="!"},{time=9.364,key="!"},{time=9.607,key="!"},
    {time=9.607,key="%"},{time=9.619,key="!"},{time=9.630,key="*"},{time=9.863,key="!"},
    {time=9.874,key="*"},{time=9.874,key="!"},{time=10.364,key="$"},{time=10.596,key="W"},
    {time=10.840,key="Q"},{time=10.851,key="4"},{time=10.979,key="4"},{time=11.095,key="*"},
    {time=11.106,key="W"},{time=11.142,key="4"},{time=11.350,key="^"},{time=11.350,key="@"},
    {time=11.361,key="Q"},{time=11.618,key="^"},{time=11.861,key="*"},{time=11.873,key="!"},
    {time=11.954,key="^"},{time=12.083,key="!"},{time=12.095,key="^"},{time=12.118,key="Q"},
    {time=12.350,key="7"},{time=12.361,key="7"},{time=12.373,key="Q"},{time=12.420,key="@"},
    {time=12.605,key="$"},{time=12.605,key="7"},{time=12.826,key="7"},{time=12.838,key="E"},
    {time=12.849,key="7"},{time=13.128,key="7"},{time=13.360,key="^"},{time=13.372,key="!"},
    {time=13.442,key="Q"},{time=13.604,key="Q"},{time=13.708,key="!"},{time=13.720,key="7"},
    {time=13.859,key="7"},{time=13.871,key="!"},{time=14.010,key="Q"},{time=14.197,key="!"},
    {time=14.336,key="$"},{time=14.359,key="Q"},{time=14.476,key="$"},{time=14.882,key="4"},
    {time=14.882,key="!"},{time=15.115,key="$"},{time=15.358,key="@"},{time=15.440,key="!"},
    {time=15.591,key="@"},{time=16.115,key="%"},{time=16.289,key="@"},{time=16.381,key="7"},
    {time=16.404,key="$"},{time=16.659,key="!"},{time=16.973,key="7"},{time=17.043,key="@"},
    {time=17.112,key="7"},{time=17.379,key="!"},{time=17.449,key="!"},{time=17.705,key="%"},
    {time=17.844,key="!"},{time=17.868,key="!"},{time=18.077,key="$"},{time=18.379,key="$"},
    {time=18.449,key="^"},{time=18.600,key="$"},{time=18.832,key="%"},{time=18.832,key="4"},
    {time=18.972,key="4"},{time=19.343,key="$"},{time=19.390,key="!"},{time=19.505,key="@"},
    {time=20.146,key="^"},{time=20.250,key="@"},{time=20.366,key="^"},{time=20.900,key="@"},
    {time=20.900,key="7"},{time=20.923,key="$"},{time=20.934,key="7"},{time=21.387,key="^"},
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
    {time=28.928,key="7"},{time=28.928,key="$"},{time=29.078,key="7"},{time=29.114,key="7"},
    {time=29.590,key="!"},{time=29.717,key="$"},{time=29.879,key="!"},{time=30.322,key="$"},
    {time=30.346,key="$"},{time=30.520,key="$"},{time=30.554,key="$"},{time=30.856,key="$"},
    {time=31.007,key="4"},{time=31.355,key="@"},{time=31.436,key="$"},{time=31.506,key="@"},
    {time=31.727,key="^"},{time=31.808,key="!"},{time=32.089,key="%"},{time=32.134,key="@"},
    {time=32.251,key="@"},{time=32.344,key="$"},{time=32.367,key="7"},{time=32.935,key="7"},
    {time=33.005,key="@"},{time=33.086,key="7"},{time=33.342,key="!"},{time=33.504,key="!"},
    {time=33.714,key="!"},{time=33.725,key="@"},{time=33.760,key="%"},{time=33.913,key="!"},
    {time=34.132,key="^"},{time=34.132,key="4"},{time=34.202,key="$"},{time=34.400,key="^"},
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
    {time=52.848,key="7"},{time=52.871,key="7"},{time=53.103,key="%"},{time=53.382,key="%"},
    {time=53.382,key="!"},{time=53.509,key="^"},{time=53.730,key="%"},{time=54.033,key="$"},
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
    {time=62.700,key="^"},{time=62.851,key="^"},{time=63.001,key="4"},
}

-- ==========================================================
--  曲2: どんぐりころころ
-- ==========================================================
local notes_donguri = {
    {time=0.000,key="w"},{time=0.625,key="0"},{time=0.938,key="9"},{time=1.250,key="8"},
    {time=1.562,key="9"},{time=1.875,key="8"},{time=2.500,key="8"},{time=2.812,key="9"},
    {time=3.125,key="8"},{time=3.438,key="9"},{time=3.750,key="0"},{time=4.062,key="9"},
    {time=4.375,key="8"},{time=5.000,key="w"},{time=5.625,key="0"},{time=5.938,key="9"},
    {time=6.250,key="8"},{time=6.562,key="9"},{time=6.875,key="8"},{time=7.500,key="8"},
    {time=7.812,key="9"},{time=8.125,key="0"},{time=8.438,key="9"},{time=8.750,key="8"},
    {time=9.062,key="9"},{time=9.375,key="8"},{time=10.625,key="w"},{time=11.250,key="0"},
    {time=11.562,key="9"},{time=11.875,key="8"},{time=12.188,key="9"},{time=12.500,key="8"},
    {time=13.125,key="8"},{time=13.438,key="9"},{time=13.750,key="8"},{time=14.062,key="9"},
    {time=14.375,key="0"},{time=14.688,key="9"},{time=15.000,key="8"},{time=15.625,key="w"},
    {time=16.250,key="0"},{time=16.562,key="9"},{time=16.875,key="8"},{time=17.188,key="9"},
    {time=17.500,key="8"},{time=18.125,key="8"},{time=18.438,key="9"},{time=18.750,key="0"},
    {time=19.062,key="9"},{time=19.375,key="8"},{time=19.688,key="0"},{time=20.000,key="w"},
}

-- ==========================================================
--  曲3: トルコ行進曲 (Mozart K.331)
-- ==========================================================
local notes_turkish = {
    {time=0.000,key="9"},{time=0.227,key="8"},{time=0.455,key="9"},{time=1.136,key="9"},
    {time=1.364,key="8"},{time=1.591,key="7"},{time=1.818,key="8"},{time=2.500,key="8"},
    {time=2.727,key="9"},{time=2.955,key="*"},{time=3.182,key="9"},{time=3.636,key="*"},
    {time=3.864,key="9"},{time=4.091,key="0"},{time=4.318,key="9"},{time=4.545,key="8"},
    {time=5.455,key="9"},{time=5.682,key="8"},{time=5.909,key="9"},{time=6.591,key="9"},
    {time=6.818,key="8"},{time=7.045,key="7"},{time=7.273,key="8"},{time=7.955,key="8"},
    {time=8.182,key="9"},{time=8.409,key="*"},{time=8.636,key="9"},{time=9.091,key="*"},
    {time=9.318,key="9"},{time=9.545,key="0"},{time=10.000,key="8"},{time=10.909,key="0"},
    {time=11.136,key="9"},{time=11.364,key="0"},{time=11.818,key="0"},{time=12.045,key="9"},
    {time=12.273,key="0"},{time=12.500,key="q"},{time=12.727,key="0"},{time=13.409,key="0"},
    {time=13.636,key="9"},{time=13.864,key="8"},{time=14.091,key="9"},{time=14.545,key="9"},
    {time=14.773,key="8"},{time=15.000,key="9"},{time=15.227,key="0"},{time=15.455,key="9"},
    {time=16.364,key="8"},{time=16.591,key="9"},{time=16.818,key="0"},{time=17.273,key="0"},
    {time=17.500,key="9"},{time=17.727,key="8"},{time=18.182,key="8"},{time=18.409,key="9"},
    {time=18.636,key="0"},{time=19.091,key="0"},{time=19.318,key="9"},{time=19.545,key="8"},
    {time=20.000,key="8"},{time=20.227,key="7"},{time=20.455,key="8"},{time=20.909,key="8"},
    {time=21.136,key="9"},{time=21.364,key="8"},{time=22.273,key="0"},{time=22.500,key="9"},
    {time=22.727,key="8"},{time=22.955,key="0"},{time=23.182,key="9"},{time=23.409,key="8"},
    {time=23.636,key="7"},{time=23.864,key="5"},{time=24.091,key="7"},{time=24.318,key="8"},
}

-- ==========================================================
--  曲4: Last Christmas (Wham!)
-- ==========================================================
local notes_lastChristmas = {
    {time=0.000,key="w"},{time=0.517,key="w"},{time=1.293,key="Q"},{time=1.552,key="w"},
    {time=1.810,key="0"},{time=2.069,key="w"},{time=2.327,key="Q"},{time=2.586,key="0"},
    {time=3.103,key="Q"},{time=3.362,key="w"},{time=4.138,key="Q"},{time=4.396,key="w"},
    {time=4.655,key="0"},{time=4.913,key="w"},{time=5.430,key="Q"},{time=6.206,key="w"},
    {time=7.241,key="r"},{time=7.758,key="0"},{time=8.275,key="r"},{time=8.534,key="0"},
    {time=8.792,key="w"},{time=9.051,key="Q"},{time=9.827,key="w"},{time=10.085,key="0"},
    {time=10.602,key="w"},{time=11.636,key="Q"},{time=12.413,key="u"},{time=12.930,key="Y"},
    {time=13.189,key="u"},{time=13.447,key="r"},{time=15.000,key="u"},{time=15.517,key="u"},
    {time=16.034,key="Y"},{time=16.292,key="u"},{time=16.551,key="T"},{time=18.103,key="u"},
    {time=18.620,key="w"},{time=18.879,key="Q"},{time=19.137,key="w"},{time=19.396,key="0"},
    {time=19.913,key="w"},{time=20.430,key="Q"},{time=20.947,key="w"},{time=21.464,key="Q"},
    {time=21.723,key="w"},{time=23.276,key="*"},{time=23.793,key="*"},{time=24.310,key="*"},
    {time=24.827,key="7"},{time=25.086,key="6"},{time=25.862,key="7"},{time=26.379,key="7"},
    {time=26.896,key="7"},{time=27.413,key="6"},{time=27.672,key="%"},{time=27.930,key="6"},
    {time=28.965,key="0"},{time=29.482,key="0"},{time=29.999,key="0"},{time=30.516,key="9"},
    {time=30.775,key="*"},{time=31.033,key="9"},{time=31.551,key="0"},{time=32.327,key="0"},
    {time=32.844,key="W"},{time=33.103,key="0"},{time=33.361,key="W"},{time=33.620,key="0"},
    {time=34.137,key="0"},{time=34.913,key="0"},{time=35.430,key="9"},{time=35.689,key="*"},
    {time=35.947,key="9"},{time=36.206,key="0"},{time=36.723,key="6"},{time=37.240,key="7"},
    {time=37.499,key="*"},{time=38.533,key="0"},{time=39.309,key="*"},{time=39.826,key="7"},
    {time=40.085,key="6"},{time=40.343,key="%"},{time=41.378,key="6"},{time=41.895,key="7"},
    {time=42.412,key="*"},{time=42.671,key="9"},{time=42.929,key="*"},{time=43.188,key="7"},
    {time=43.705,key="6"},{time=44.481,key="0"},{time=44.998,key="W"},{time=45.257,key="0"},
    {time=45.515,key="0"},{time=46.550,key="0"},{time=47.067,key="W"},{time=47.584,key="0"},
    {time=47.843,key="W"},{time=48.101,key="Q"},{time=48.618,key="W"},{time=49.394,key="0"},
    {time=49.911,key="W"},{time=50.170,key="0"},{time=50.687,key="0"},{time=51.464,key="6"},
    {time=51.981,key="7"},{time=52.239,key="*"},{time=52.756,key="0"},{time=53.791,key="0"},
    {time=54.567,key="0"},{time=55.084,key="9"},{time=55.343,key="*"},{time=55.601,key="7"},
    {time=55.860,key="6"},{time=56.636,key="0"},{time=57.153,key="9"},{time=57.412,key="*"},
    {time=57.670,key="7"},{time=57.929,key="6"},{time=58.705,key="6"},{time=59.222,key="7"},
    {time=59.481,key="*"},{time=59.739,key="9"},{time=59.998,key="0"},{time=61.032,key="0"},
    {time=61.549,key="W"},{time=61.808,key="0"},{time=62.842,key="W"},
}

-- ==========================================================
--  曲5: きらきら星 (MIDIより)
-- ==========================================================
local notes_twinkle = {
    {time=0.000,key="8"},{time=0.719,key="w"},{time=1.411,key="e"},{time=2.117,key="w"},
    {time=2.810,key="q"},{time=3.500,key="0"},{time=4.201,key="9"},{time=4.841,key="0"},
    {time=4.938,key="8"},{time=5.651,key="8"},{time=6.344,key="w"},{time=7.036,key="e"},
    {time=7.742,key="w"},{time=8.438,key="q"},{time=9.148,key="0"},{time=9.875,key="9"},
    {time=10.510,key="0"},{time=10.625,key="8"},{time=11.292,key="w"},{time=11.961,key="q"},
    {time=12.630,key="0"},{time=13.302,key="9"},{time=13.982,key="w"},{time=14.667,key="q"},
    {time=15.333,key="0"},{time=15.505,key="q"},{time=15.635,key="9"},{time=16.117,key="0"},
    {time=16.521,key="9"},{time=16.872,key="8"},{time=17.578,key="w"},{time=18.268,key="e"},
    {time=18.969,key="w"},{time=19.664,key="q"},{time=20.357,key="0"},{time=21.042,key="9"},
    {time=21.250,key="0"},{time=21.362,key="8"},{time=22.510,key="w"},{time=23.195,key="q"},
    {time=23.883,key="0"},{time=24.562,key="9"},{time=25.260,key="w"},{time=25.948,key="q"},
    {time=26.612,key="0"},{time=26.805,key="q"},{time=26.919,key="9"},{time=27.409,key="0"},
    {time=27.792,key="9"},{time=28.112,key="8"},{time=28.812,key="w"},{time=29.510,key="e"},
    {time=30.214,key="w"},{time=30.922,key="q"},
}

-- ==========================================================
--  曲6: いぬのおまわりさん
-- ==========================================================
local notes_inu = {
    {time=0.000,key="w"},{time=0.667,key="e"},{time=1.333,key="w"},{time=2.000,key="e"},
    {time=2.667,key="w"},{time=3.000,key="0"},{time=3.333,key="8"},{time=4.667,key="9"},
    {time=5.000,key="9"},{time=5.333,key="9"},{time=6.000,key="8"},{time=6.333,key="9"},
    {time=6.667,key="0"},{time=7.000,key="q"},{time=7.333,key="w"},{time=8.667,key="w"},
    {time=9.000,key="w"},{time=9.333,key="q"},{time=9.667,key="0"},{time=10.000,key="9"},
    {time=10.333,key="0"},{time=10.667,key="8"},{time=11.333,key="9"},{time=11.667,key="8"},
    {time=12.667,key="0"},{time=13.000,key="0"},{time=13.333,key="0"},{time=13.667,key="0"},
    {time=14.000,key="0"},{time=14.333,key="0"},{time=14.667,key="0"},{time=16.667,key="8"},
    {time=17.000,key="8"},{time=17.333,key="8"},{time=18.000,key="8"},{time=18.333,key="w"},
    {time=18.667,key="w"},{time=20.000,key="w"},{time=20.333,key="w"},{time=20.667,key="w"},
    {time=21.000,key="w"},{time=21.333,key="w"},{time=21.667,key="w"},{time=22.000,key="w"},
}

-- ==========================================================
--  曲7: もりのくまさん
-- ==========================================================
local notes_mori = {
    {time=0.000,key="e"},{time=0.682,key="q"},{time=1.023,key="q"},{time=1.364,key="e"},
    {time=2.045,key="w"},{time=2.386,key="q"},{time=2.727,key="w"},{time=3.068,key="q"},
    {time=3.409,key="e"},{time=3.750,key="t"},{time=4.091,key="0"},{time=4.432,key="q"},
    {time=5.795,key="e"},{time=6.477,key="q"},{time=6.818,key="q"},{time=7.159,key="e"},
    {time=7.841,key="w"},{time=8.182,key="q"},{time=8.523,key="w"},{time=8.864,key="q"},
    {time=9.205,key="e"},{time=9.545,key="r"},{time=9.886,key="t"},{time=11.250,key="t"},
    {time=11.591,key="r"},{time=11.932,key="t"},{time=12.273,key="r"},{time=12.614,key="0"},
    {time=12.955,key="w"},{time=13.295,key="0"},{time=13.977,key="e"},{time=14.318,key="w"},
    {time=14.659,key="0"},{time=15.341,key="w"},{time=15.682,key="q"},{time=16.023,key="8"},
    {time=17.386,key="e"},{time=17.727,key="w"},{time=18.068,key="0"},{time=18.750,key="w"},
    {time=19.091,key="0"},{time=19.432,key="9"},{time=19.773,key="8"},
}

-- ==========================================================
--  曲8: チューリップ
-- ==========================================================
local notes_tulip = {
    {time=0.000,key="0"},{time=0.600,key="0"},{time=1.200,key="w"},{time=1.800,key="0"},
    {time=2.400,key="9"},{time=2.700,key="8"},{time=3.000,key="8"},{time=4.200,key="9"},
    {time=4.500,key="0"},{time=4.800,key="w"},{time=6.000,key="w"},{time=6.600,key="w"},
    {time=7.200,key="0"},{time=7.800,key="w"},{time=8.400,key="e"},{time=8.700,key="r"},
    {time=9.000,key="e"},{time=9.300,key="w"},{time=9.600,key="w"},{time=10.800,key="e"},
    {time=11.400,key="e"},{time=11.700,key="w"},{time=12.000,key="0"},{time=12.300,key="w"},
    {time=12.600,key="e"},{time=13.200,key="e"},{time=13.500,key="w"},{time=13.800,key="9"},
    {time=14.100,key="8"},
}

-- ==========================================================
--  曲9: ぞうさん
-- ==========================================================
local notes_zou = {
    {time=0.000,key="w"},{time=0.667,key="0"},{time=1.333,key="w"},{time=2.000,key="0"},
    {time=2.667,key="8"},{time=3.000,key="9"},{time=3.333,key="0"},{time=4.000,key="w"},
    {time=4.333,key="e"},{time=4.667,key="w"},{time=5.000,key="0"},{time=5.333,key="9"},
    {time=5.667,key="8"},{time=6.667,key="0"},{time=7.333,key="w"},{time=8.000,key="0"},
    {time=8.333,key="w"},{time=8.667,key="e"},{time=9.333,key="r"},{time=9.667,key="e"},
    {time=10.000,key="w"},{time=10.667,key="0"},
}

-- ==========================================================
--  曲10: おもちゃのチャチャチャ
-- ==========================================================
local notes_omocha = {
    {time=0.000,key="8"},{time=0.273,key="0"},{time=0.545,key="w"},{time=0.818,key="w"},
    {time=1.091,key="w"},{time=1.364,key="w"},{time=1.636,key="w"},{time=2.182,key="8"},
    {time=2.455,key="0"},{time=2.727,key="w"},{time=3.000,key="w"},{time=3.273,key="w"},
    {time=3.545,key="w"},{time=3.818,key="w"},{time=4.364,key="8"},{time=4.636,key="0"},
    {time=4.909,key="w"},{time=5.182,key="w"},{time=5.455,key="e"},{time=5.727,key="w"},
    {time=6.000,key="0"},{time=6.273,key="9"},{time=6.545,key="8"},{time=7.364,key="w"},
    {time=7.544,key="0"},{time=7.724,key="8"},{time=7.909,key="w"},{time=8.089,key="0"},
    {time=8.269,key="8"},{time=8.455,key="w"},{time=9.000,key="0"},{time=9.545,key="8"},
}

-- ==========================================================
--  曲11: 大きな栗の木の下で
-- ==========================================================
local notes_kurino = {
    {time=0.000,key="0"},{time=0.556,key="9"},{time=1.111,key="8"},{time=1.667,key="9"},
    {time=2.222,key="0"},{time=2.778,key="0"},{time=3.333,key="0"},{time=4.444,key="9"},
    {time=5.000,key="9"},{time=5.556,key="9"},{time=6.667,key="0"},{time=7.222,key="w"},
    {time=7.778,key="w"},{time=8.889,key="0"},{time=9.444,key="9"},{time=10.000,key="8"},
    {time=10.556,key="9"},{time=11.111,key="0"},{time=11.667,key="0"},{time=12.222,key="0"},
    {time=12.778,key="0"},{time=13.333,key="9"},{time=13.889,key="9"},{time=14.444,key="0"},
    {time=15.000,key="9"},{time=15.556,key="8"},
}

-- ==========================================================
--  曲12: おはなしゆびさん
-- ==========================================================
local notes_oyubi = {
    {time=0.000,key="8"},{time=0.278,key="8"},{time=0.556,key="0"},{time=0.833,key="w"},
    {time=1.111,key="0"},{time=1.389,key="8"},{time=1.944,key="w"},{time=2.222,key="0"},
    {time=2.500,key="8"},{time=3.056,key="9"},{time=3.333,key="0"},{time=3.889,key="9"},
    {time=4.167,key="0"},{time=4.722,key="9"},{time=5.000,key="0"},{time=5.556,key="8"},
    {time=5.833,key="9"},{time=6.111,key="0"},{time=6.389,key="w"},{time=6.667,key="0"},
    {time=6.944,key="0"},{time=7.222,key="9"},{time=7.500,key="0"},{time=7.778,key="8"},
    {time=8.889,key="8"},{time=9.167,key="8"},{time=9.444,key="0"},{time=9.722,key="w"},
    {time=10.000,key="0"},{time=10.278,key="8"},{time=10.833,key="w"},{time=11.111,key="0"},
    {time=11.389,key="8"},{time=11.944,key="9"},{time=12.222,key="0"},{time=12.778,key="9"},
    {time=13.056,key="0"},{time=13.611,key="9"},{time=13.889,key="0"},{time=14.444,key="8"},
    {time=14.722,key="9"},{time=15.000,key="0"},{time=15.278,key="w"},{time=15.556,key="e"},
    {time=15.833,key="e"},{time=16.111,key="w"},{time=16.389,key="0"},{time=16.667,key="9"},
}

-- ==========================================================
--  曲13: かえるのがっしょう
-- ==========================================================
local notes_kaeru = {
    {time=0.000,key="8"},{time=0.600,key="9"},{time=1.200,key="0"},{time=1.800,key="q"},
    {time=2.400,key="0"},{time=3.000,key="9"},{time=3.600,key="8"},{time=4.800,key="0"},
    {time=5.400,key="q"},{time=6.000,key="w"},{time=6.600,key="e"},{time=7.200,key="w"},
    {time=7.800,key="q"},{time=8.400,key="0"},{time=9.600,key="8"},{time=9.900,key="8"},
    {time=10.200,key="8"},{time=10.500,key="8"},{time=10.800,key="9"},{time=11.100,key="9"},
    {time=11.400,key="9"},{time=11.700,key="9"},{time=12.000,key="0"},{time=12.600,key="0"},
    {time=13.200,key="8"},{time=13.500,key="8"},{time=13.800,key="8"},{time=14.100,key="8"},
    {time=14.400,key="9"},{time=14.700,key="9"},{time=15.000,key="9"},{time=15.300,key="9"},
    {time=15.600,key="0"},
}

-- ==========================================================
--  曲14: エビカニクス
-- ==========================================================
local notes_ebikani = {
    {time=0.000,key="w"},{time=0.250,key="w"},{time=0.500,key="e"},{time=0.750,key="w"},
    {time=1.000,key="0"},{time=1.500,key="0"},{time=2.000,key="w"},{time=2.250,key="e"},
    {time=2.500,key="w"},{time=3.000,key="w"},{time=3.500,key="w"},{time=3.750,key="w"},
    {time=4.000,key="e"},{time=4.250,key="w"},{time=4.500,key="0"},{time=5.000,key="0"},
    {time=5.500,key="9"},{time=5.750,key="8"},{time=6.000,key="9"},{time=6.500,key="8"},
    {time=7.000,key="8"},{time=7.250,key="0"},{time=7.500,key="w"},{time=7.750,key="e"},
    {time=8.000,key="w"},{time=8.250,key="0"},{time=8.500,key="w"},{time=8.750,key="e"},
    {time=9.000,key="w"},{time=9.250,key="q"},{time=9.500,key="w"},{time=9.750,key="0"},
    {time=10.000,key="9"},{time=10.250,key="8"},{time=11.000,key="w"},{time=11.250,key="w"},
    {time=11.500,key="e"},{time=11.750,key="w"},{time=12.000,key="0"},{time=12.500,key="0"},
    {time=13.000,key="w"},{time=13.250,key="e"},{time=13.500,key="w"},{time=14.000,key="w"},
    {time=14.500,key="8"},{time=14.750,key="0"},{time=15.000,key="w"},{time=15.250,key="e"},
    {time=15.500,key="r"},{time=16.000,key="e"},{time=16.250,key="w"},{time=16.500,key="0"},
}

-- ==========================================================
--  曲15: からだ☆ダンダン
-- ==========================================================
local notes_dandandan = {
    {time=0.000,key="8"},{time=0.261,key="0"},{time=0.522,key="w"},{time=1.043,key="t"},
    {time=1.304,key="r"},{time=1.565,key="e"},{time=1.826,key="w"},{time=2.087,key="q"},
    {time=2.348,key="w"},{time=2.609,key="0"},{time=3.130,key="0"},{time=3.652,key="9"},
    {time=3.913,key="9"},{time=4.174,key="8"},{time=4.696,key="9"},{time=4.957,key="9"},
    {time=5.217,key="8"},{time=5.739,key="8"},{time=6.000,key="0"},{time=6.261,key="w"},
    {time=6.783,key="t"},{time=7.043,key="r"},{time=7.304,key="e"},{time=7.565,key="w"},
    {time=7.826,key="0"},{time=8.087,key="9"},{time=8.348,key="8"},{time=8.870,key="8"},
    {time=9.391,key="w"},{time=9.652,key="w"},{time=9.913,key="e"},{time=10.174,key="e"},
    {time=10.435,key="w"},{time=10.696,key="0"},{time=10.957,key="9"},{time=11.217,key="8"},
    {time=11.478,key="9"},{time=11.739,key="9"},{time=12.000,key="0"},{time=12.261,key="0"},
    {time=12.522,key="9"},{time=12.783,key="8"},{time=13.565,key="w"},{time=13.826,key="w"},
    {time=14.087,key="e"},{time=14.348,key="e"},{time=14.609,key="w"},{time=14.870,key="e"},
    {time=15.130,key="w"},{time=15.391,key="0"},{time=15.652,key="9"},{time=15.913,key="8"},
}

-- ==========================================================
--  曲16: 手のひらを太陽に
-- ==========================================================
local notes_teno = {
    {time=0.000,key="w"},{time=0.300,key="w"},{time=0.600,key="e"},{time=0.900,key="w"},
    {time=1.200,key="0"},{time=1.500,key="8"},{time=2.100,key="8"},{time=2.400,key="9"},
    {time=2.700,key="0"},{time=3.000,key="w"},{time=3.300,key="w"},{time=3.900,key="w"},
    {time=4.200,key="w"},{time=4.500,key="q"},{time=4.800,key="0"},{time=5.100,key="9"},
    {time=5.400,key="0"},{time=5.700,key="9"},{time=6.300,key="8"},{time=6.900,key="0"},
    {time=7.200,key="0"},{time=7.500,key="0"},{time=7.800,key="0"},{time=8.100,key="w"},
    {time=8.400,key="w"},{time=8.700,key="w"},{time=9.300,key="w"},{time=9.600,key="e"},
    {time=9.900,key="w"},{time=10.200,key="0"},{time=10.500,key="9"},{time=10.800,key="8"},
    {time=11.700,key="0"},{time=12.000,key="0"},{time=12.300,key="9"},{time=12.600,key="0"},
    {time=12.900,key="w"},{time=13.200,key="q"},{time=13.500,key="w"},{time=14.100,key="0"},
    {time=14.400,key="9"},{time=14.700,key="8"},
}

-- ==========================================================
--  曲17: ちょきちょきダンス
-- ==========================================================
local notes_choki = {
    {time=0.000,key="0"},{time=0.250,key="w"},{time=0.500,key="0"},{time=0.750,key="w"},
    {time=1.000,key="0"},{time=1.250,key="w"},{time=1.500,key="0"},{time=1.750,key="8"},
    {time=2.000,key="0"},{time=2.250,key="w"},{time=2.500,key="0"},{time=2.750,key="w"},
    {time=3.000,key="0"},{time=3.250,key="w"},{time=3.500,key="9"},{time=3.750,key="8"},
    {time=4.000,key="8"},{time=4.250,key="9"},{time=4.500,key="0"},{time=4.750,key="w"},
    {time=5.000,key="e"},{time=5.250,key="w"},{time=5.500,key="0"},{time=6.000,key="w"},
    {time=6.250,key="0"},{time=6.500,key="9"},{time=6.750,key="8"},{time=7.000,key="9"},
    {time=7.250,key="0"},{time=7.500,key="w"},{time=8.250,key="0"},{time=8.500,key="w"},
    {time=8.750,key="0"},{time=9.000,key="w"},{time=9.250,key="0"},{time=9.500,key="w"},
    {time=9.750,key="0"},{time=10.000,key="8"},{time=10.250,key="0"},{time=10.500,key="w"},
    {time=10.750,key="0"},{time=11.000,key="w"},{time=11.250,key="0"},{time=11.500,key="w"},
    {time=11.750,key="9"},{time=12.000,key="8"},{time=12.250,key="8"},{time=12.500,key="9"},
    {time=12.750,key="0"},{time=13.000,key="w"},{time=13.250,key="e"},{time=13.500,key="w"},
    {time=13.750,key="0"},{time=14.250,key="0"},{time=14.500,key="9"},{time=14.750,key="8"},
}

-- ==========================================================
--  曲18: パプリカ
-- ==========================================================
local notes_paprika = {
    {time=0.000,key="w"},{time=0.517,key="e"},{time=1.034,key="r"},{time=1.552,key="e"},
    {time=2.069,key="w"},{time=2.586,key="0"},{time=2.845,key="9"},{time=3.103,key="8"},
    {time=4.138,key="r"},{time=4.397,key="e"},{time=4.655,key="w"},{time=5.172,key="0"},
    {time=5.431,key="w"},{time=5.690,key="e"},{time=6.207,key="w"},{time=6.724,key="0"},
    {time=6.983,key="0"},{time=7.241,key="w"},{time=7.500,key="w"},{time=7.759,key="e"},
    {time=8.017,key="w"},{time=8.276,key="0"},{time=8.793,key="9"},{time=9.052,key="0"},
    {time=9.310,key="w"},{time=9.569,key="e"},{time=9.828,key="w"},{time=10.345,key="e"},
    {time=10.603,key="e"},{time=10.862,key="w"},{time=11.121,key="0"},{time=11.379,key="w"},
    {time=11.638,key="0"},{time=11.897,key="9"},{time=12.414,key="8"},{time=12.931,key="w"},
    {time=13.448,key="e"},{time=13.966,key="r"},{time=14.483,key="e"},{time=15.000,key="w"},
    {time=15.259,key="e"},{time=15.517,key="w"},{time=15.776,key="0"},{time=16.034,key="9"},
    {time=16.293,key="8"},{time=17.069,key="r"},{time=17.328,key="e"},{time=17.586,key="w"},
    {time=18.103,key="0"},{time=18.362,key="w"},{time=18.621,key="e"},{time=19.138,key="w"},
}

-- ==========================================================
--  曲19: どんないろがすき
-- ==========================================================
local notes_donnani = {
    {time=0.000,key="8"},{time=0.500,key="8"},{time=1.000,key="w"},{time=1.500,key="w"},
    {time=2.000,key="e"},{time=2.500,key="e"},{time=3.000,key="w"},{time=4.000,key="0"},
    {time=4.500,key="0"},{time=5.000,key="w"},{time=5.500,key="w"},{time=6.000,key="e"},
    {time=6.500,key="e"},{time=7.000,key="w"},{time=8.000,key="r"},{time=8.500,key="r"},
    {time=9.000,key="w"},{time=9.500,key="w"},{time=10.000,key="e"},{time=10.500,key="e"},
    {time=11.000,key="w"},{time=12.000,key="9"},{time=12.500,key="9"},{time=13.000,key="w"},
    {time=13.500,key="w"},{time=14.000,key="e"},{time=14.500,key="e"},{time=15.000,key="w"},
    {time=16.000,key="w"},{time=16.500,key="w"},{time=16.750,key="e"},{time=17.000,key="w"},
    {time=17.250,key="0"},{time=17.500,key="9"},{time=18.000,key="8"},
}

-- ==========================================================
--  曲20: ぼよよん行進曲
-- ==========================================================
local notes_boyoyon = {
    {time=0.000,key="8"},{time=0.250,key="0"},{time=0.500,key="w"},{time=0.750,key="t"},
    {time=1.000,key="r"},{time=1.250,key="e"},{time=1.500,key="w"},{time=2.250,key="w"},
    {time=2.500,key="0"},{time=2.750,key="w"},{time=3.000,key="e"},{time=3.250,key="w"},
    {time=3.500,key="q"},{time=3.750,key="8"},{time=4.500,key="0"},{time=4.750,key="0"},
    {time=5.000,key="0"},{time=5.250,key="w"},{time=5.500,key="0"},{time=5.750,key="0"},
    {time=6.250,key="9"},{time=6.500,key="9"},{time=6.750,key="0"},{time=7.000,key="w"},
    {time=7.250,key="9"},{time=7.500,key="8"},{time=8.000,key="8"},{time=8.250,key="0"},
    {time=8.500,key="w"},{time=8.750,key="t"},{time=9.000,key="r"},{time=9.250,key="e"},
    {time=9.500,key="w"},{time=10.250,key="t"},{time=10.500,key="r"},{time=10.750,key="e"},
    {time=11.250,key="0"},{time=11.500,key="w"},{time=11.750,key="e"},{time=12.250,key="r"},
    {time=12.500,key="e"},{time=12.750,key="w"},{time=13.000,key="0"},{time=13.250,key="9"},
    {time=13.500,key="8"},
}

-- ==========================================================
--  曲21: 勇気100%
-- ==========================================================
local notes_yuuki = {
    {time=0.000,key="w"},{time=0.231,key="e"},{time=0.462,key="w"},{time=0.692,key="0"},
    {time=0.923,key="8"},{time=1.154,key="9"},{time=1.385,key="0"},{time=1.846,key="w"},
    {time=2.308,key="w"},{time=2.538,key="q"},{time=2.769,key="0"},{time=3.000,key="9"},
    {time=3.231,key="8"},{time=3.462,key="8"},{time=3.692,key="9"},{time=3.923,key="0"},
    {time=4.154,key="w"},{time=5.077,key="w"},{time=5.308,key="e"},{time=5.538,key="w"},
    {time=6.000,key="w"},{time=6.231,key="0"},{time=6.462,key="w"},{time=6.923,key="w"},
    {time=7.154,key="w"},{time=7.385,key="e"},{time=7.615,key="w"},{time=7.846,key="0"},
    {time=8.077,key="w"},{time=8.308,key="e"},{time=8.538,key="w"},{time=8.769,key="0"},
    {time=9.000,key="9"},{time=9.231,key="8"},{time=9.923,key="0"},{time=10.154,key="w"},
    {time=10.385,key="e"},{time=10.615,key="r"},{time=10.846,key="e"},{time=11.077,key="r"},
    {time=11.308,key="e"},{time=11.769,key="w"},{time=12.000,key="0"},{time=12.231,key="9"},
    {time=12.462,key="8"},{time=13.154,key="0"},{time=13.385,key="w"},{time=13.615,key="e"},
    {time=13.846,key="r"},{time=14.077,key="e"},{time=14.308,key="w"},{time=14.538,key="0"},
    {time=15.000,key="w"},{time=15.231,key="0"},{time=15.462,key="9"},{time=15.692,key="8"},
}

-- ==========================================================
--  曲22: ドラえもん (星野源)
-- ==========================================================
local notes_doraemon = {
    {time=0.000,key="w"},{time=0.278,key="e"},{time=0.556,key="w"},{time=0.833,key="0"},
    {time=1.111,key="Q"},{time=1.389,key="w"},{time=1.667,key="e"},{time=2.222,key="w"},
    {time=2.778,key="0"},{time=3.056,key="Q"},{time=3.333,key="w"},{time=3.611,key="e"},
    {time=3.889,key="r"},{time=4.167,key="e"},{time=4.444,key="w"},{time=5.278,key="e"},
    {time=5.556,key="e"},{time=5.833,key="e"},{time=6.111,key="r"},{time=6.389,key="e"},
    {time=6.667,key="w"},{time=6.944,key="0"},{time=7.500,key="9"},{time=7.778,key="0"},
    {time=8.056,key="w"},{time=8.611,key="w"},{time=8.889,key="0"},{time=9.167,key="9"},
    {time=9.444,key="8"},{time=9.722,key="w"},{time=10.000,key="e"},{time=10.278,key="w"},
    {time=10.556,key="e"},{time=10.833,key="w"},{time=11.111,key="0"},{time=11.389,key="Q"},
    {time=11.667,key="w"},{time=11.944,key="e"},{time=12.500,key="r"},{time=12.778,key="e"},
    {time=13.056,key="w"},{time=13.333,key="e"},{time=13.611,key="w"},{time=14.167,key="0"},
    {time=14.444,key="0"},{time=14.722,key="Q"},{time=15.000,key="w"},{time=15.278,key="e"},
    {time=15.556,key="w"},{time=15.833,key="0"},{time=16.389,key="Q"},{time=16.667,key="w"},
    {time=16.944,key="e"},{time=17.222,key="r"},{time=17.500,key="e"},{time=17.778,key="w"},
    {time=18.056,key="0"},{time=18.889,key="w"},{time=19.167,key="e"},{time=19.444,key="w"},
    {time=19.722,key="0"},{time=20.000,key="Q"},{time=20.278,key="w"},{time=20.556,key="9"},
    {time=20.833,key="8"},
}


-- ============================================================
--  Rayfield UI
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name            = "🎹 Virtual Piano Player v3",
    LoadingTitle    = "Piano Player v3.0",
    LoadingSubtitle = "22曲収録 / MIDI & 手打ち対応",
    ConfigurationSaving = { Enabled = false },
    Discord         = { Enabled = false },
    KeySystem       = false,
})

-- ===== Setup タブ =====
local SetupTab = Window:CreateTab("⚙ Setup", 4483345998)
SetupTab:CreateSection("ピアノ準備")
SetupTab:CreateButton({ Name = "🎹  ピアノ出現 & 着席", Callback = function() task.spawn(setupPiano) end })
SetupTab:CreateParagraph({
    Title = "キーマッピング早見表",
    Content =
        "白鍵: 1=C4  2=D4  3=E4  4=F4  5=G4  6=A4  7=B4\n"..
        "      8=C5  9=D5  0=E5  q=F5  w=G5  e=A5  r=B5\n"..
        "      t=C6  y=D6  u=E6  i=F6  o=G6  p=A6  a=B6\n"..
        "黒鍵: !=C#4 @=D#4 $=F#4 %=G#4 ^=A#4\n"..
        "      *=C#5 (=D#5 Q=F#5 W=G#5 E=A#5\n"..
        "      T=C#6 Y=D#6 I=F#6 O=G#6 P=A#6",
})

-- ===== 童謡タブ =====
local KidsTab = Window:CreateTab("🎵 童謡", 4483345998)
KidsTab:CreateSection("日本の童謡・子どもの歌")
KidsTab:CreateButton({ Name = "▶ きらきら星", Callback = function() playSong(notes_twinkle,"きらきら星") end })
KidsTab:CreateButton({ Name = "▶ どんぐりころころ", Callback = function() playSong(notes_donguri,"どんぐりころころ") end })
KidsTab:CreateButton({ Name = "▶ いぬのおまわりさん", Callback = function() playSong(notes_inu,"いぬのおまわりさん") end })
KidsTab:CreateButton({ Name = "▶ もりのくまさん", Callback = function() playSong(notes_mori,"もりのくまさん") end })
KidsTab:CreateButton({ Name = "▶ チューリップ", Callback = function() playSong(notes_tulip,"チューリップ") end })
KidsTab:CreateButton({ Name = "▶ ぞうさん", Callback = function() playSong(notes_zou,"ぞうさん") end })
KidsTab:CreateButton({ Name = "▶ おもちゃのチャチャチャ", Callback = function() playSong(notes_omocha,"おもちゃのチャチャチャ") end })
KidsTab:CreateButton({ Name = "▶ 大きな栗の木の下で", Callback = function() playSong(notes_kurino,"大きな栗の木の下で") end })
KidsTab:CreateButton({ Name = "▶ おはなしゆびさん", Callback = function() playSong(notes_oyubi,"おはなしゆびさん") end })
KidsTab:CreateButton({ Name = "▶ かえるのがっしょう", Callback = function() playSong(notes_kaeru,"かえるのがっしょう") end })
KidsTab:CreateButton({ Name = "▶ どんないろがすき", Callback = function() playSong(notes_donnani,"どんないろがすき") end })
KidsTab:CreateButton({ Name = "▶ 手のひらを太陽に", Callback = function() playSong(notes_teno,"手のひらを太陽に") end })

-- ===== NHK/アニメタブ =====
local AnimeTab = Window:CreateTab("📺 NHK/アニメ", 4483345998)
AnimeTab:CreateSection("テレビ・アニメ・ゲーム")
AnimeTab:CreateButton({ Name = "▶ エビカニクス", Callback = function() playSong(notes_ebikani,"エビカニクス") end })
AnimeTab:CreateButton({ Name = "▶ からだ☆ダンダン", Callback = function() playSong(notes_dandandan,"からだ☆ダンダン") end })
AnimeTab:CreateButton({ Name = "▶ ちょきちょきダンス", Callback = function() playSong(notes_choki,"ちょきちょきダンス") end })
AnimeTab:CreateButton({ Name = "▶ ぼよよん行進曲", Callback = function() playSong(notes_boyoyon,"ぼよよん行進曲") end })
AnimeTab:CreateButton({ Name = "▶ 勇気100%", Callback = function() playSong(notes_yuuki,"勇気100%") end })
AnimeTab:CreateButton({ Name = "▶ パプリカ", Callback = function() playSong(notes_paprika,"パプリカ") end })
AnimeTab:CreateButton({ Name = "▶ ドラえもん (星野源)", Callback = function() playSong(notes_doraemon,"ドラえもん") end })

-- ===== クラシック/POPSタブ =====
local ClassicTab = Window:CreateTab("🎼 Classic/POPS", 4483345998)
ClassicTab:CreateSection("クラシック・洋楽")
ClassicTab:CreateButton({ Name = "▶ トルコ行進曲 (Mozart)", Callback = function() playSong(notes_turkish,"トルコ行進曲") end })
ClassicTab:CreateButton({ Name = "▶ Last Christmas (Wham!)", Callback = function() playSong(notes_lastChristmas,"Last Christmas") end })
ClassicTab:CreateSection("オリジナル")
ClassicTab:CreateButton({ Name = "▶ Libra Heart (imaizumi)", Callback = function() playSong(notes_libraHeart,"Libra Heart") end })

-- ===== Control タブ =====
local CtrlTab = Window:CreateTab("⏹ Control", 4483345998)
CtrlTab:CreateSection("再生コントロール")
CtrlTab:CreateButton({
    Name = "⏹  演奏を停止する",
    Callback = function() stopSong() end,
})
CtrlTab:CreateButton({
    Name = "📊  現在の状態を確認",
    Callback = function()
        if isPlaying then
            Rayfield:Notify({Title="📊 再生中",Content="♪ "..currentSong,Duration=2,Image="rbxassetid://4483345998"})
        else
            Rayfield:Notify({Title="📊 待機中",Content="曲は再生されていません",Duration=2,Image="rbxassetid://4483345998"})
        end
    end,
})
CtrlTab:CreateParagraph({
    Title = "注意事項",
    Content =
        "・演奏中はRobloxの画面にフォーカスを当ててください\n"..
        "・黒鍵は自動でShiftキーを処理します\n"..
        "・ラグが激しい場合はタイミングがずれることがあります\n"..
        "・きらきら星はMIDIファイルから生成した正確版です",
})
