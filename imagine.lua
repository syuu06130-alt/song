-- ============================================================
-- Piano Player v5.1  [imagine if - MIDI Import]
-- ============================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local VIM      = game:GetService("VirtualInputManager")
local Players  = game:GetService("Players")
local RS       = game:GetService("RunService")

-- ============================================================
-- キーマップ
-- ============================================================
local BLACK = {
    ["!"] = Enum.KeyCode.One,   ["@"] = Enum.KeyCode.Two,
    ["$"] = Enum.KeyCode.Four,  ["%"] = Enum.KeyCode.Five,
    ["^"] = Enum.KeyCode.Six,   ["*"] = Enum.KeyCode.Eight,
    ["("] = Enum.KeyCode.Nine,
    ["Q"] = Enum.KeyCode.Q, ["W"] = Enum.KeyCode.W, ["E"] = Enum.KeyCode.E,
    ["T"] = Enum.KeyCode.T, ["Y"] = Enum.KeyCode.Y, ["I"] = Enum.KeyCode.I,
    ["O"] = Enum.KeyCode.O, ["P"] = Enum.KeyCode.P,
    ["S"] = Enum.KeyCode.S, ["D"] = Enum.KeyCode.D, ["G"] = Enum.KeyCode.G,
    ["H"] = Enum.KeyCode.H, ["J"] = Enum.KeyCode.J,
    ["L"] = Enum.KeyCode.L, ["Z"] = Enum.KeyCode.Z,
    ["C"] = Enum.KeyCode.C, ["V"] = Enum.KeyCode.V, ["B"] = Enum.KeyCode.B,
}
local WHITE = {
    ["1"] = Enum.KeyCode.One,   ["2"] = Enum.KeyCode.Two,
    ["3"] = Enum.KeyCode.Three, ["4"] = Enum.KeyCode.Four,
    ["5"] = Enum.KeyCode.Five,  ["6"] = Enum.KeyCode.Six,
    ["7"] = Enum.KeyCode.Seven, ["8"] = Enum.KeyCode.Eight,
    ["9"] = Enum.KeyCode.Nine,  ["0"] = Enum.KeyCode.Zero,
    ["q"] = Enum.KeyCode.Q, ["w"] = Enum.KeyCode.W, ["e"] = Enum.KeyCode.E,
    ["r"] = Enum.KeyCode.R, ["t"] = Enum.KeyCode.T, ["y"] = Enum.KeyCode.Y,
    ["u"] = Enum.KeyCode.U, ["i"] = Enum.KeyCode.I, ["o"] = Enum.KeyCode.O,
    ["p"] = Enum.KeyCode.P, ["a"] = Enum.KeyCode.A, ["s"] = Enum.KeyCode.S,
    ["d"] = Enum.KeyCode.D, ["f"] = Enum.KeyCode.F, ["g"] = Enum.KeyCode.G,
    ["h"] = Enum.KeyCode.H, ["j"] = Enum.KeyCode.J, ["k"] = Enum.KeyCode.K,
    ["l"] = Enum.KeyCode.L, ["z"] = Enum.KeyCode.Z, ["x"] = Enum.KeyCode.X,
    ["c"] = Enum.KeyCode.C, ["v"] = Enum.KeyCode.V, ["b"] = Enum.KeyCode.B,
    ["n"] = Enum.KeyCode.N, ["m"] = Enum.KeyCode.M,
}
local PITCH = {
    ["1"]=36, ["!"]=37, ["2"]=38, ["@"]=39, ["3"]=40, ["4"]=41, ["$"]=42,
    ["5"]=43, ["%"]=44, ["6"]=45, ["^"]=46, ["7"]=47,
    ["8"]=48, ["*"]=49, ["9"]=50, ["("]=51, ["0"]=52, ["q"]=53, ["Q"]=54,
    ["w"]=55, ["W"]=56, ["e"]=57, ["E"]=58, ["r"]=59,
    ["t"]=60, ["T"]=61, ["y"]=62, ["Y"]=63, ["u"]=64, ["i"]=65, ["I"]=66,
    ["o"]=67, ["O"]=68, ["p"]=69, ["P"]=70, ["a"]=71,
    ["s"]=72, ["S"]=73, ["d"]=74, ["D"]=75, ["f"]=76, ["g"]=77, ["G"]=78,
    ["h"]=79, ["H"]=80, ["j"]=81, ["J"]=82, ["k"]=83,
    ["l"]=84, ["L"]=85, ["z"]=86, ["Z"]=87, ["x"]=88, ["c"]=89, ["C"]=90,
    ["v"]=91, ["V"]=92, ["b"]=93, ["B"]=94, ["n"]=95, ["m"]=96,
}
local MIDI_TO_KEY = {}
for k, v in pairs(PITCH) do MIDI_TO_KEY[v] = k end

-- ============================================================
-- Shiftキー競合解消
-- ============================================================
local _shiftLock = false
local _shiftQueue = {}

local function _flushShiftQueue()
    if _shiftLock or #_shiftQueue == 0 then return end
    _shiftLock = true
    task.spawn(function()
        while #_shiftQueue > 0 do
            local kc = table.remove(_shiftQueue, 1)
            VIM:SendKeyEvent(true,  Enum.KeyCode.LeftShift, false, game)
            task.wait(0.004)
            VIM:SendKeyEvent(true,  kc, false, game)
            task.wait(0.040)
            VIM:SendKeyEvent(false, kc, false, game)
            task.wait(0.006)
            VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
            task.wait(0.005)
        end
        _shiftLock = false
    end)
end

local function pressKey(k)
    if BLACK[k] then
        table.insert(_shiftQueue, BLACK[k])
        _flushShiftQueue()
    elseif WHITE[k] then
        local kc = WHITE[k]
        task.spawn(function()
            local waited = 0
            while _shiftLock and waited < 0.05 do
                RS.Heartbeat:Wait()
                waited = waited + 0.016
            end
            VIM:SendKeyEvent(true,  kc, false, game)
            task.delay(0.040, function()
                VIM:SendKeyEvent(false, kc, false, game)
            end)
        end)
    end
end

-- ============================================================
-- ラグ計測エンジン
-- ============================================================
local measuredLag   = 0.0
local lagSamples    = {}
local LAG_HISTORY   = 20
local isCalibrating = false

local function sampleLag()
    local t0 = tick()
    task.wait(0.01)
    return math.max(0, tick() - t0 - 0.01)
end

local function calibrateLag(callback)
    if isCalibrating then return end
    isCalibrating = true
    task.spawn(function()
        lagSamples = {}
        for i = 1, LAG_HISTORY do
            table.insert(lagSamples, sampleLag())
            task.wait(0.005)
        end
        table.sort(lagSamples)
        measuredLag = lagSamples[math.floor(#lagSamples / 2)]
        isCalibrating = false
        if callback then callback(measuredLag) end
    end)
end

local function startLagMonitor()
    task.spawn(function()
        while true do
            task.wait(2.0)
            local s = sampleLag()
            table.insert(lagSamples, s)
            if #lagSamples > LAG_HISTORY then
                table.remove(lagSamples, 1)
            end
            local sorted = {}
            for _, v in ipairs(lagSamples) do table.insert(sorted, v) end
            table.sort(sorted)
            measuredLag = sorted[math.floor(#sorted / 2)]
        end
    end)
end

-- ============================================================
-- 精密タイミングエンジン
-- ============================================================
local BUSY_WAIT_THRESHOLD = 0.006

local function deconflictNotes(notes, maxPerWindow, windowMs)
    maxPerWindow = maxPerWindow or 3
    windowMs = windowMs or 18
    local windowSec = windowMs / 1000
    local out = {}
    local i = 1
    while i <= #notes do
        local bt = notes[i].time
        local group = {}
        local j = i
        while j <= #notes and (notes[j].time - bt) < windowSec do
            table.insert(group, notes[j])
            j = j + 1
        end
        table.sort(group, function(a, b)
            return (PITCH[a.key] or 0) > (PITCH[b.key] or 0)
        end)
        local selected = {}
        if #group <= maxPerWindow then
            selected = group
        else
            table.insert(selected, group[1])
            if maxPerWindow >= 2 then table.insert(selected, group[#group]) end
            if maxPerWindow >= 3 and #group >= 3 then table.insert(selected, group[math.ceil(#group/2)]) end
        end
        local whites, blacks = {}, {}
        for _, n in ipairs(selected) do
            if BLACK[n.key] then table.insert(blacks, n)
            else table.insert(whites, n) end
        end
        local reordered = {}
        local wi, bi = 1, 1
        local toggle = true
        while wi <= #whites or bi <= #blacks do
            if toggle and wi <= #whites then
                table.insert(reordered, whites[wi]); wi = wi + 1
            elseif bi <= #blacks then
                table.insert(reordered, blacks[bi]); bi = bi + 1
            elseif wi <= #whites then
                table.insert(reordered, whites[wi]); wi = wi + 1
            end
            toggle = not toggle
        end
        for k, n in ipairs(reordered) do
            table.insert(out, {time = bt + (k-1)*0.005, key = n.key})
        end
        i = j
    end
    table.sort(out, function(a, b) return a.time < b.time end)
    return out
end

local function scheduleAllNotes(notes, startTime, speedMult, stopFlagRef)
    for _, n in ipairs(notes) do
        local delay = (n.time / speedMult) - measuredLag * 0.5
        if delay < 0 then delay = 0 end
        task.delay(delay, function()
            if not stopFlagRef[1] then pressKey(n.key) end
        end)
    end
end

local function preciseLoop(notes, startTime, speedMult, stopFlagRef)
    local t0 = startTime
    local driftCorrection = 0.0
    for idx, n in ipairs(notes) do
        if stopFlagRef[1] then break end
        local targetTime = t0 + (n.time / speedMult) - driftCorrection
        local remaining = targetTime - tick()
        if remaining > BUSY_WAIT_THRESHOLD then
            local sleepTime = remaining - BUSY_WAIT_THRESHOLD - measuredLag * 0.3
            if sleepTime > 0.001 then task.wait(sleepTime) end
        end
        while tick() < targetTime and not stopFlagRef[1] do
            if targetTime - tick() > 0.003 then RS.Heartbeat:Wait() end
        end
        if not stopFlagRef[1] then
            local actualTime = tick() - t0
            local expectedTime = n.time / speedMult
            local drift = actualTime - expectedTime
            driftCorrection = driftCorrection + drift * 0.05
            pressKey(n.key)
        end
    end
end

-- ============================================================
-- ピアノ検出 / 着席
-- ============================================================
local function findPiano()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n = obj.Name:lower()
            if n:find("piano") or n:find("keyboard") then return obj end
        end
    end
    return nil
end

local function sitAt(obj)
    local plr = Players.LocalPlayer
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos = nil
    if obj:IsA("Model") and obj.PrimaryPart then
        pos = obj.PrimaryPart.Position
    elseif obj:IsA("BasePart") then
        pos = obj.Position
    else
        for _, c in ipairs(obj:GetDescendants()) do
            if c:IsA("BasePart") then pos = c.Position; break end
        end
    end
    if not pos then return end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 4))
    task.wait(0.5)
    for _, o in ipairs(workspace:GetDescendants()) do
        if (o:IsA("Seat") or o:IsA("VehicleSeat")) and (o.Position - pos).Magnitude < 10 then
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum then o:Sit(hum) end
            return
        end
    end
end

local function setupPiano()
    Rayfield:Notify({Title="Piano Setup", Content="Searching...", Duration=2, Image="rbxassetid://4483345998"})
    local piano = findPiano()
    if piano then
        task.spawn(function() task.wait(0.3); sitAt(piano) end)
        Rayfield:Notify({Title="Piano Setup", Content="Found! Sitting down.", Duration=3, Image="rbxassetid://4483345998"})
    else
        Rayfield:Notify({Title="Piano Setup", Content="Walk to piano manually.", Duration=4, Image="rbxassetid://4483345998"})
    end
end

-- ============================================================
-- 再生コントロール
-- ============================================================
local speedMult   = 1.0
local isPlaying   = false
local stopFlagRef = {false}
local currentSong = ""

local RUSH_THRESHOLD = 12
local function isHighDensity(notes)
    local max_density = 0
    for i = 1, #notes do
        local count = 0
        for j = i, #notes do
            if notes[j].time - notes[i].time > 1.0 then break end
            count = count + 1
        end
        if count > max_density then max_density = count end
    end
    return max_density >= RUSH_THRESHOLD, max_density
end

local function melodyOnly(notes)
    local out = {}
    local i = 1
    while i <= #notes do
        local bt = notes[i].time
        local best = notes[i]
        local j = i + 1
        while j <= #notes and notes[j].time - bt < 0.025 do
            if (PITCH[notes[j].key] or 0) > (PITCH[best.key] or 0) then best = notes[j] end
            j = j + 1
        end
        table.insert(out, {time = bt, key = best.key})
        i = j
    end
    return out
end

local function playSong(notes, title, forceRush)
    if isPlaying then
        Rayfield:Notify({Title="Already playing!", Content=currentSong, Duration=2, Image="rbxassetid://4483345998"})
        return
    end
    isPlaying   = true
    stopFlagRef = {false}
    currentSong = title
    local spd   = speedMult
    local lag   = measuredLag
    local highDensity, maxDensity = isHighDensity(notes)
    local useRushMode = forceRush or highDensity
    local modeStr = useRushMode and ("RUSH mode [" .. maxDensity .. "n/s]") or "Standard mode"
    Rayfield:Notify({
        Title = "♪ " .. title,
        Content = #notes .. " notes | x" .. spd .. " | lag=" .. math.floor(lag*1000) .. "ms | " .. modeStr,
        Duration = 4,
        Image = "rbxassetid://4483345998"
    })
    local localStop = stopFlagRef
    task.spawn(function()
        local startTime = tick()
        if useRushMode then
            local processed = deconflictNotes(notes, 3, 18)
            scheduleAllNotes(processed, startTime, spd, localStop)
            local totalDuration = notes[#notes].time / spd + 1.5
            local elapsed = 0
            while elapsed < totalDuration and not localStop[1] do
                task.wait(0.5)
                elapsed = tick() - startTime
            end
        else
            preciseLoop(notes, startTime, spd, localStop)
        end
        if not localStop[1] then
            Rayfield:Notify({Title="Finished!", Content=title, Duration=3, Image="rbxassetid://4483345998"})
        end
        isPlaying = false
        stopFlagRef = {false}
        currentSong = ""
    end)
end

local function stopSong()
    if isPlaying then
        stopFlagRef[1] = true
        _shiftQueue = {}
        _shiftLock = false
        VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
        isPlaying = false
        Rayfield:Notify({Title="Stopped", Content=currentSong, Duration=2, Image="rbxassetid://4483345998"})
        currentSong = ""
    else
        Rayfield:Notify({Title="Nothing playing", Content="", Duration=2, Image="rbxassetid://4483345998"})
    end
end

-- ============================================================
-- NOTE DATA: imagine if (MIDI Import)
-- ============================================================
local notes_imagineif = {
    {time=0.081,key="i"},
    {time=0.081,key="Y"},
    {time=0.081,key="!"},
    {time=1.137,key="T"},
    {time=1.137,key="$"},
    {time=1.207,key="*"},
    {time=2.045,key="("},
    {time=2.765,key="*"},
    {time=2.997,key="Y"},
    {time=2.997,key="4"},
    {time=3.008,key="e"},
    {time=3.171,key="t"},
    {time=3.392,key="4"},
    {time=3.554,key="t"},
    {time=3.566,key="Y"},
    {time=3.566,key="e"},
    {time=3.566,key="4"},
    {time=4.112,key="T"},
    {time=4.112,key="^"},
    {time=5.796,key="W"},
    {time=5.958,key="$"},
    {time=7.086,key="q"},
    {time=7.144,key="!"},
    {time=8.945,key="$"},
    {time=10.060,key="T"},
    {time=10.096,key="!"},
    {time=11.920,key="!"},
    {time=12.047,key="i"},
    {time=12.152,key="!"},
    {time=12.338,key="W"},
    {time=12.814,key="E"},
    {time=13.161,key="$"},
    {time=15.044,key="4"},
    {time=15.195,key="("},
    {time=15.474,key="4"},
    {time=16.276,key="q"},
    {time=18.797,key="("},
    {time=19.005,key="1"},
    {time=20.574,key="*"},
    {time=20.887,key="4"},
    {time=21.445,key="9"},
    {time=21.666,key="9"},
    {time=22.039,key="1"},
    {time=22.921,key="i"},
    {time=23.454,key="u"},
    {time=23.571,key="f"},
    {time=24.002,key="1"},
    {time=24.152,key="1"},
    {time=24.350,key="W"},
    {time=24.779,key="E"},
    {time=25.047,key="8"},
    {time=25.104,key="4"},
    {time=25.244,key="t"},
    {time=26.673,key="("},
    {time=26.941,key="W"},
    {time=26.975,key="y"},
    {time=27.009,key="3"},
    {time=27.009,key="r"},
    {time=27.149,key="y"},
    {time=27.311,key="3"},
    {time=27.393,key="y"},
    {time=27.498,key="3"},
    {time=27.509,key="W"},
    {time=27.521,key="r"},
    {time=27.602,key="y"},
    {time=27.614,key="m"},
    {time=27.882,key="y"},
    {time=28.079,key="t"},
    {time=28.079,key="6"},
    {time=28.521,key="e"},
    {time=29.623,key="w"},
    {time=29.774,key="w"},
    {time=29.926,key="4"},
    {time=29.961,key="8"},
    {time=30.008,key="e"},
    {time=31.157,key="0"},
    {time=31.169,key="1"},
    {time=31.390,key="0"},
    {time=31.552,key="6"},
    {time=32.261,key="6"},
    {time=32.586,key="8"},
    {time=33.016,key="e"},
    {time=33.097,key="4"},
    {time=33.236,key="4"},
    {time=34.155,key="8"},
    {time=34.841,key="4"}
}

-- ============================================================
-- RAYFIELD UI
-- ============================================================

local Window = Rayfield:CreateWindow({
    Name = "Piano Player - imagine if",
    LoadingTitle = "Piano Player",
    LoadingSubtitle = "imagine if - MIDI Import",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false,
})

-- ── Setup Tab ────────────────────────────────────────────────
local TabSetup = Window:CreateTab("Setup", 4483345998)

TabSetup:CreateButton({
    Name = "Piano Setup (座席を探す)",
    Callback = function() setupPiano() end,
})

TabSetup:CreateButton({
    Name = "STOP 停止",
    Callback = function() stopSong() end,
})

TabSetup:CreateSlider({
    Name = "Speed / 速度 (%)",
    Range = {30, 200},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 100,
    Flag = "spd",
    Callback = function(v)
        speedMult = v / 100
        Rayfield:Notify({Title="Speed", Content=v.."%", Duration=1, Image="rbxassetid://4483345998"})
    end,
})

TabSetup:CreateButton({
    Name = "Calibrate Lag (ラグ計測)",
    Callback = function()
        Rayfield:Notify({Title="Calibrating...", Content="Measuring system lag...", Duration=2, Image="rbxassetid://4483345998"})
        calibrateLag(function(lag)
            local ms = math.floor(lag * 1000)
            local quality = ms < 5 and "Excellent!" or ms < 15 and "Good" or ms < 30 and "Fair" or "Poor"
            Rayfield:Notify({
                Title = "Lag = " .. ms .. "ms",
                Content = quality .. " | 補正自動適用",
                Duration = 5,
                Image = "rbxassetid://4483345998"
            })
        end)
    end,
})

-- ── imagine if Tab ───────────────────────────────────────────
local TabSong = Window:CreateTab("imagine if", 4483345998)

TabSong:CreateButton({
    Name = "▶ imagine if (Full)",
    Callback = function()
        playSong(notes_imagineif, "imagine if", nil)
    end,
})

TabSong:CreateButton({
    Name = "▶ imagine if (Melody Only)",
    Callback = function()
        playSong(melodyOnly(notes_imagineif), "imagine if [Melody]", false)
    end,
})

TabSong:CreateButton({
    Name = "■ STOP",
    Callback = function() stopSong() end,
})

-- ── 起動 ─────────────────────────────────────────────────────
startLagMonitor()

calibrateLag(function(lag)
    local ms = math.floor(lag * 1000)
    Rayfield:Notify({
        Title = "Piano Player Ready!",
        Content = "imagine if | Lag=" .. ms .. "ms | 86 notes",
        Duration = 6,
        Image = "rbxassetid://4483345998"
    })
end)
