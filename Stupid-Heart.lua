-- ============================================================
-- Piano Player v5.1  [My Stupid Heart - MIDI Import]
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
-- NOTE DATA: My Stupid Heart (MIDI Import)
-- ============================================================
local notes_mystupidhe = {
    {time=0.302,key="k"},
    {time=0.627,key="j"},
    {time=0.941,key="h"},
    {time=1.254,key="x"},
    {time=1.254,key="f"},
    {time=1.254,key="u"},
    {time=1.266,key="h"},
    {time=1.266,key="0"},
    {time=1.602,key="r"},
    {time=1.893,key="u"},
    {time=1.893,key="0"},
    {time=2.207,key="j"},
    {time=2.207,key="u"},
    {time=2.207,key="r"},
    {time=2.498,key="f"},
    {time=2.498,key="w"},
    {time=2.509,key="u"},
    {time=2.544,key="k"},
    {time=2.823,key="o"},
    {time=2.869,key="y"},
    {time=3.159,key="h"},
    {time=3.159,key="o"},
    {time=3.159,key="0"},
    {time=3.171,key="w"},
    {time=3.473,key="z"},
    {time=3.473,key="0"},
    {time=3.786,key="8"},
    {time=3.798,key="x"},
    {time=3.809,key="f"},
    {time=3.809,key="t"},
    {time=3.868,key="1"},
    {time=4.112,key="x"},
    {time=4.112,key="f"},
    {time=4.112,key="w"},
    {time=4.124,key="t"},
    {time=4.182,key="1"},
    {time=4.415,key="x"},
    {time=4.415,key="h"},
    {time=4.426,key="f"},
    {time=4.426,key="t"},
    {time=4.426,key="8"},
    {time=4.728,key="z"},
    {time=4.740,key="t"},
    {time=5.053,key="k"},
    {time=5.053,key="f"},
    {time=5.053,key="w"},
    {time=5.193,key="1"},
    {time=5.239,key="o"},
    {time=5.390,key="o"},
    {time=5.390,key="y"},
    {time=5.692,key="o"},
    {time=5.692,key="w"},
    {time=5.784,key="8"},
    {time=6.018,key="z"},
    {time=6.320,key="8"},
    {time=6.331,key="x"},
    {time=6.331,key="h"},
    {time=6.331,key="f"},
    {time=6.331,key="t"},
    {time=6.633,key="x"},
    {time=6.633,key="h"},
    {time=6.645,key="f"},
    {time=6.645,key="t"},
    {time=6.645,key="w"},
    {time=6.935,key="h"},
    {time=6.947,key="x"},
    {time=6.947,key="f"},
    {time=6.947,key="t"},
    {time=6.958,key="8"},
    {time=6.970,key="1"},
    {time=7.260,key="z"},
    {time=7.272,key="f"},
    {time=7.574,key="k"},
    {time=7.574,key="f"},
    {time=7.585,key="o"},
    {time=7.585,key="w"},
    {time=7.910,key="y"},
    {time=8.214,key="t"},
    {time=8.225,key="o"},
    {time=8.225,key="w"},
    {time=8.527,key="k"},
    {time=8.539,key="o"},
    {time=8.539,key="w"},
    {time=8.817,key="f"},
    {time=8.852,key="j"},
    {time=8.852,key="9"},
    {time=8.852,key="8"},
    {time=8.864,key="p"},
    {time=9.154,key="j"},
    {time=9.154,key="Q"},
    {time=9.166,key="G"},
    {time=9.189,key="8"},
    {time=9.468,key="j"},
    {time=9.468,key="e"},
    {time=9.479,key="y"},
    {time=9.781,key="h"},
    {time=9.781,key="d"},
    {time=9.793,key="e"},
    {time=9.816,key="t"},
    {time=9.920,key="9"},
    {time=10.084,key="Q"},
    {time=10.096,key="j"},
    {time=10.096,key="p"},
    {time=10.096,key="y"},
    {time=10.096,key="9"},
    {time=10.107,key="e"},
    {time=10.385,key="k"},
    {time=10.409,key="Q"},
    {time=10.723,key="j"},
    {time=10.723,key="f"},
    {time=10.723,key="e"},
    {time=10.734,key="y"},
    {time=11.035,key="h"},
    {time=11.035,key="d"},
    {time=11.048,key="e"},
    {time=11.094,key="t"},
    {time=11.338,key="v"},
    {time=11.338,key="x"},
    {time=11.361,key="h"},
    {time=11.361,key="f"},
    {time=11.361,key="Q"},
    {time=11.361,key="0"},
    {time=11.361,key="6"},
    {time=11.686,key="r"},
    {time=11.977,key="u"},
    {time=11.977,key="0"},
    {time=12.279,key="j"},
    {time=12.291,key="y"},
    {time=12.338,key="r"},
    {time=12.581,key="f"},
    {time=12.628,key="k"},
    {time=12.628,key="u"},
    {time=12.628,key="w"},
    {time=12.895,key="o"},
    {time=12.929,key="y"},
    {time=13.255,key="o"},
    {time=13.255,key="w"},
    {time=13.545,key="z"},
    {time=13.870,key="8"},
    {time=13.881,key="x"},
    {time=13.881,key="t"},
    {time=13.929,key="1"},
    {time=14.184,key="C"},
    {time=14.220,key="w"},
    {time=14.498,key="x"},
    {time=14.498,key="t"},
    {time=14.498,key="w"},
    {time=14.568,key="1"},
    {time=14.789,key="z"},
    {time=15.172,key="k"},
    {time=15.172,key="w"},
    {time=15.172,key="q"},
    {time=15.497,key="y"},
    {time=15.682,key="1"},
    {time=15.822,key="o"},
    {time=15.822,key="t"},
    {time=15.822,key="w"},
    {time=16.114,key="z"},
    {time=16.439,key="k"},
    {time=16.439,key="t"},
    {time=16.461,key="x"},
    {time=16.473,key="8"},
    {time=16.752,key="w"},
    {time=16.764,key="x"},
    {time=17.077,key="x"},
    {time=17.077,key="h"},
    {time=17.077,key="t"},
    {time=17.089,key="w"},
    {time=17.111,key="1"},
    {time=17.379,key="z"},
    {time=17.391,key="t"},
    {time=17.704,key="w"},
    {time=17.716,key="o"},
    {time=17.727,key="k"},
    {time=18.019,key="y"},
    {time=18.355,key="h"},
    {time=18.355,key="o"},
    {time=18.355,key="y"},
    {time=18.355,key="w"},
    {time=18.646,key="k"},
    {time=18.646,key="w"},
    {time=18.657,key="o"},
    {time=18.971,key="9"},
    {time=18.982,key="w"},
    {time=19.086,key="G"},
    {time=19.284,key="Q"},
    {time=19.296,key="j"},
    {time=19.609,key="j"},
    {time=19.609,key="e"},
    {time=19.632,key="y"},
    {time=19.655,key="9"},
    {time=19.913,key="h"},
    {time=19.913,key="o"},
    {time=20.215,key="G"},
    {time=20.226,key="j"},
    {time=20.226,key="p"},
    {time=20.226,key="9"},
    {time=20.528,key="k"},
    {time=20.540,key="Q"},
    {time=20.865,key="j"},
    {time=20.865,key="e"},
    {time=20.899,key="y"},
    {time=21.167,key="h"},
    {time=21.492,key="0"},
    {time=21.503,key="h"},
    {time=21.503,key="Q"},
    {time=21.793,key="r"},
    {time=22.108,key="h"},
    {time=22.108,key="u"},
    {time=22.108,key="0"},
    {time=22.723,key="h"},
    {time=22.723,key="u"},
    {time=22.734,key="o"},
    {time=22.734,key="w"},
    {time=22.734,key="0"},
    {time=23.025,key="y"},
    {time=23.339,key="h"},
    {time=23.350,key="o"},
    {time=23.932,key="h"},
    {time=23.932,key="8"},
    {time=24.257,key="0"},
    {time=24.571,key="4"}
}

-- ============================================================
-- RAYFIELD UI
-- ============================================================

local Window = Rayfield:CreateWindow({
    Name = "Piano Player - My Stupid Heart",
    LoadingTitle = "Piano Player",
    LoadingSubtitle = "My Stupid Heart - MIDI Import",
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

-- ── My Stupid Heart Tab ──────────────────────────────────────
local TabSong = Window:CreateTab("My Stupid Heart", 4483345998)

TabSong:CreateButton({
    Name = "▶ My Stupid Heart (Full)",
    Callback = function()
        playSong(notes_mystupidhe, "My Stupid Heart", nil)
    end,
})

TabSong:CreateButton({
    Name = "▶ My Stupid Heart (Melody Only)",
    Callback = function()
        playSong(melodyOnly(notes_mystupidhe), "My Stupid Heart [Melody]", false)
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
        Content = "My Stupid Heart | Lag=" .. ms .. "ms | 222 notes",
        Duration = 6,
        Image = "rbxassetid://4483345998"
    })
end)
