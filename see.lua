-- ============================================================
-- Piano Player v5.1  [See You Again - MIDI Import]
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
-- Shiftキー競合を解消した pressKey
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

local function preciseWait(seconds)
    if seconds <= 0 then return end
    local deadline = tick() + seconds
    local coarse = seconds - BUSY_WAIT_THRESHOLD
    if coarse > 0.001 then
        task.wait(coarse)
    end
    while tick() < deadline do
        if deadline - tick() > 0.002 then
            RS.Heartbeat:Wait()
        end
    end
end

-- ============================================================
-- ノート前処理：Shift競合解消
-- ============================================================
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
            if maxPerWindow >= 2 then
                table.insert(selected, group[#group])
            end
            if maxPerWindow >= 3 and #group >= 3 then
                table.insert(selected, group[math.ceil(#group/2)])
            end
        end
        local whites, blacks = {}, {}
        for _, n in ipairs(selected) do
            if BLACK[n.key] then
                table.insert(blacks, n)
            else
                table.insert(whites, n)
            end
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

-- ============================================================
-- スケジューラ
-- ============================================================
local function scheduleAllNotes(notes, startTime, speedMult, stopFlagRef)
    for _, n in ipairs(notes) do
        local delay = (n.time / speedMult) - measuredLag * 0.5
        if delay < 0 then delay = 0 end
        task.delay(delay, function()
            if not stopFlagRef[1] then
                pressKey(n.key)
            end
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
            if sleepTime > 0.001 then
                task.wait(sleepTime)
            end
        end
        while tick() < targetTime and not stopFlagRef[1] do
            if targetTime - tick() > 0.003 then
                RS.Heartbeat:Wait()
            end
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
            if n:find("piano") or n:find("keyboard") then
                return obj
            end
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
            if (PITCH[notes[j].key] or 0) > (PITCH[best.key] or 0) then
                best = notes[j]
            end
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
-- NOTE DATA: See You Again (MIDI Import)
-- ============================================================
local notes_seeyouagain = {
    {time=1.219,key="g"},
    {time=1.219,key="w"},
    {time=1.614,key="l"},
    {time=2.022,key="J"},
    {time=2.022,key="w"},
    {time=2.393,key="d"},
    {time=2.393,key="i"},
    {time=2.393,key="E"},
    {time=2.404,key="^"},
    {time=2.660,key="g"},
    {time=2.742,key="P"},
    {time=3.182,key="J"},
    {time=3.194,key="E"},
    {time=3.392,key="l"},
    {time=3.403,key="i"},
    {time=3.566,key="z"},
    {time=3.762,key="i"},
    {time=3.775,key="l"},
    {time=3.973,key="J"},
    {time=3.984,key="E"},
    {time=4.159,key="l"},
    {time=4.159,key="i"},
    {time=4.345,key="g"},
    {time=4.356,key="P"},
    {time=4.356,key="Y"},
    {time=4.704,key="D"},
    {time=4.740,key="l"},
    {time=4.740,key="P"},
    {time=5.006,key="g"},
    {time=5.157,key="J"},
    {time=5.157,key="P"},
    {time=5.157,key="Y"},
    {time=5.518,key="g"},
    {time=5.518,key="E"},
    {time=5.518,key="^"},
    {time=5.529,key="d"},
    {time=5.529,key="i"},
    {time=5.912,key="P"},
    {time=6.297,key="J"},
    {time=6.297,key="E"},
    {time=6.494,key="l"},
    {time=6.505,key="i"},
    {time=6.692,key="t"},
    {time=6.692,key="q"},
    {time=6.889,key="l"},
    {time=6.889,key="i"},
    {time=6.889,key="t"},
    {time=6.900,key="q"},
    {time=6.911,key="4"},
    {time=7.086,key="J"},
    {time=7.086,key="t"},
    {time=7.283,key="l"},
    {time=7.283,key="i"},
    {time=7.283,key="q"},
    {time=7.295,key="t"},
    {time=7.480,key="g"},
    {time=7.480,key="w"},
    {time=7.493,key="y"},
    {time=7.493,key="5"},
    {time=7.875,key="l"},
    {time=7.875,key="y"},
    {time=8.259,key="J"},
    {time=8.259,key="w"},
    {time=8.654,key="d"},
    {time=8.654,key="i"},
    {time=8.654,key="E"},
    {time=8.992,key="P"},
    {time=9.432,key="J"},
    {time=9.432,key="E"},
    {time=9.618,key="l"},
    {time=9.618,key="i"},
    {time=9.816,key="z"},
    {time=9.816,key="E"},
    {time=9.827,key="i"},
    {time=10.015,key="l"},
    {time=10.015,key="i"},
    {time=10.015,key="E"},
    {time=10.200,key="J"},
    {time=10.200,key="P"},
    {time=10.211,key="E"},
    {time=10.397,key="l"},
    {time=10.572,key="E"},
    {time=10.595,key="("},
    {time=10.978,key="l"},
    {time=11.001,key="("},
    {time=11.373,key="J"},
    {time=11.373,key="P"},
    {time=11.373,key="E"},
    {time=11.373,key="("},
    {time=11.755,key="z"},
    {time=11.768,key="g"},
    {time=11.768,key="d"},
    {time=11.768,key="i"},
    {time=11.768,key="E"},
    {time=12.059,key="g"},
    {time=12.128,key="P"},
    {time=12.523,key="i"},
    {time=12.523,key="E"},
    {time=12.918,key="y"},
    {time=13.324,key="i"},
    {time=13.707,key="o"},
    {time=13.707,key="E"},
    {time=13.707,key="w"},
    {time=13.707,key="5"},
    {time=13.719,key="9"},
    {time=14.335,key="w"},
    {time=14.660,key="y"},
    {time=14.870,key="^"},
    {time=14.881,key="E"},
    {time=14.881,key="q"},
    {time=16.822,key="t"},
    {time=16.822,key="w"},
    {time=16.822,key="("},
    {time=17.204,key="P"},
    {time=17.217,key="t"},
    {time=17.599,key="E"},
    {time=17.599,key="w"},
    {time=17.983,key="q"},
    {time=17.983,key="^"},
    {time=17.996,key="y"},
    {time=17.996,key="E"},
    {time=19.540,key="y"},
    {time=19.551,key="i"},
    {time=19.736,key="i"},
    {time=19.736,key="q"},
    {time=19.924,key="E"},
    {time=19.935,key="o"},
    {time=19.935,key="9"},
    {time=19.935,key="5"},
    {time=20.307,key="p"},
    {time=20.725,key="o"},
    {time=20.725,key="w"},
    {time=21.108,key="q"},
    {time=21.108,key="^"},
    {time=21.120,key="E"},
    {time=21.492,key="y"},
    {time=21.887,key="t"},
    {time=22.235,key="P"},
    {time=22.271,key="t"},
    {time=22.456,key="E"},
    {time=23.060,key="t"},
    {time=23.060,key="("},
    {time=23.454,key="t"},
    {time=23.605,key="P"},
    {time=23.826,key="y"},
    {time=24.210,key="E"},
    {time=24.210,key="q"},
    {time=24.269,key="^"},
    {time=24.605,key="w"},
    {time=25.325,key="4"},
    {time=25.383,key="q"},
    {time=25.395,key="8"},
    {time=25.476,key="4"},
    {time=25.580,key="E"},
    {time=25.778,key="y"},
    {time=25.953,key="i"},
    {time=25.965,key="q"},
    {time=26.174,key="o"},
    {time=26.174,key="E"},
    {time=26.174,key="5"},
    {time=26.185,key="9"},
    {time=26.882,key="w"},
    {time=27.323,key="^"},
    {time=27.335,key="E"},
    {time=27.335,key="q"},
    {time=27.917,key="o"},
    {time=27.928,key="E"},
    {time=29.275,key="t"},
    {time=29.275,key="w"},
    {time=29.275,key="("},
    {time=29.275,key="8"},
    {time=29.681,key="t"},
    {time=29.693,key="P"},
    {time=30.066,key="E"},
    {time=30.077,key="w"},
    {time=30.077,key="5"},
    {time=30.321,key="^"},
    {time=30.449,key="q"},
    {time=30.460,key="y"},
    {time=30.460,key="E"},
    {time=30.460,key="^"},
    {time=30.844,key="t"},
    {time=31.448,key="4"},
    {time=31.633,key="s"},
    {time=31.633,key="y"},
    {time=31.633,key="q"},
    {time=31.633,key="8"},
    {time=31.633,key="4"},
    {time=32.133,key="i"},
    {time=32.377,key="w"},
    {time=32.390,key="o"},
    {time=32.390,key="E"},
    {time=32.390,key="5"},
    {time=32.401,key="9"},
    {time=32.796,key="P"},
    {time=32.796,key="E"},
    {time=33.191,key="s"},
    {time=33.561,key="E"},
    {time=33.561,key="q"},
    {time=33.573,key="d"},
    {time=33.573,key="^"},
    {time=33.946,key="s"},
    {time=33.957,key="q"},
    {time=34.329,key="P"},
    {time=34.341,key="E"},
    {time=34.747,key="o"},
    {time=34.759,key="E"},
    {time=35.130,key="P"},
    {time=35.130,key="E"},
    {time=35.502,key="@"},
    {time=35.514,key="Y"},
    {time=35.514,key="E"},
    {time=35.525,key="s"},
    {time=35.618,key="("},
    {time=35.909,key="s"},
    {time=36.293,key="P"},
    {time=36.293,key="E"},
    {time=36.293,key="("},
    {time=36.676,key="P"},
    {time=36.676,key="E"},
    {time=36.676,key="^"},
    {time=36.688,key="q"},
    {time=37.071,key="o"},
    {time=37.850,key="o"},
    {time=37.861,key="E"},
    {time=38.256,key="P"},
    {time=38.256,key="E"},
    {time=38.616,key="@"},
    {time=38.627,key="Y"},
    {time=38.627,key="E"},
    {time=38.627,key="("},
    {time=38.640,key="s"},
    {time=39.034,key="s"},
    {time=39.429,key="P"},
    {time=39.429,key="E"},
    {time=39.441,key="("},
    {time=39.790,key="^"},
    {time=39.801,key="P"},
    {time=39.801,key="E"},
    {time=39.801,key="q"},
    {time=41.742,key="E"},
    {time=41.753,key="9"},
    {time=41.753,key="5"},
    {time=42.484,key="P"},
    {time=42.484,key="E"},
    {time=42.694,key="s"},
    {time=42.891,key="E"},
    {time=42.891,key="q"},
    {time=42.891,key="^"},
    {time=42.903,key="s"},
    {time=43.066,key="s"},
    {time=43.263,key="s"},
    {time=43.669,key="P"},
    {time=43.669,key="E"},
    {time=44.030,key="4"},
    {time=44.042,key="e"},
    {time=44.042,key="q"},
    {time=44.042,key="8"},
    {time=44.134,key="P"},
    {time=44.425,key="o"},
    {time=44.843,key="E"},
    {time=44.843,key="("},
    {time=44.866,key="@"},
    {time=45.621,key="P"},
    {time=45.621,key="E"},
    {time=45.621,key="("},
    {time=45.784,key="s"},
    {time=45.982,key="E"},
    {time=45.982,key="^"},
    {time=45.994,key="s"},
    {time=45.994,key="q"},
    {time=46.179,key="P"},
    {time=46.191,key="E"},
    {time=46.400,key="d"},
    {time=46.771,key="s"},
    {time=46.783,key="q"},
    {time=47.154,key="8"},
    {time=47.154,key="4"},
    {time=47.166,key="e"},
    {time=47.166,key="q"},
    {time=47.933,key="E"},
    {time=47.933,key="5"},
    {time=47.945,key="9"},
    {time=48.711,key="g"},
    {time=48.897,key="z"},
    {time=48.908,key="d"},
    {time=48.908,key="y"},
    {time=49.129,key="d"},
    {time=49.129,key="E"},
    {time=49.129,key="q"},
    {time=49.129,key="^"},
    {time=49.327,key="d"},
    {time=49.339,key="E"},
    {time=49.501,key="d"},
    {time=49.874,key="s"},
    {time=50.280,key="8"},
    {time=50.280,key="4"},
    {time=50.292,key="P"},
    {time=50.292,key="e"},
    {time=50.292,key="q"},
    {time=50.664,key="s"},
    {time=50.675,key="8"},
    {time=50.709,key="q"},
    {time=51.058,key="d"},
    {time=51.058,key="E"},
    {time=51.058,key="("},
    {time=51.093,key="@"},
    {time=51.453,key="D"},
    {time=51.650,key="d"},
    {time=51.650,key="E"},
    {time=52.023,key="s"},
    {time=52.220,key="E"},
    {time=52.220,key="q"},
    {time=52.220,key="^"},
    {time=53.393,key="4"},
    {time=53.404,key="t"},
    {time=53.404,key="e"},
    {time=53.404,key="8"},
    {time=53.602,key="q"},
    {time=53.777,key="i"},
    {time=53.777,key="q"},
    {time=54.172,key="E"},
    {time=54.172,key="5"},
    {time=54.183,key="i"},
    {time=54.183,key="9"},
    {time=54.961,key="P"},
    {time=54.961,key="E"},
    {time=55.147,key="s"},
    {time=55.345,key="s"},
    {time=55.345,key="E"},
    {time=55.345,key="q"},
    {time=55.345,key="^"},
    {time=55.542,key="s"},
    {time=55.542,key="q"},
    {time=55.553,key="E"},
    {time=55.718,key="s"},
    {time=56.101,key="P"},
    {time=56.112,key="E"},
    {time=56.379,key="4"},
    {time=56.519,key="8"},
    {time=56.519,key="4"},
    {time=56.530,key="e"},
    {time=56.589,key="P"},
    {time=56.681,key="o"},
    {time=56.902,key="o"},
    {time=56.902,key="8"},
    {time=57.284,key="o"},
    {time=57.284,key="E"},
    {time=57.284,key="@"},
    {time=57.297,key="("},
    {time=57.693,key="P"},
    {time=57.693,key="E"},
    {time=57.693,key="("},
    {time=58.064,key="P"},
    {time=58.064,key="E"},
    {time=58.273,key="s"},
    {time=58.458,key="^"},
    {time=58.470,key="E"},
    {time=58.470,key="q"},
    {time=58.842,key="d"},
    {time=59.248,key="s"},
    {time=59.609,key="4"},
    {time=59.621,key="t"},
    {time=59.621,key="8"},
    {time=59.632,key="e"},
    {time=60.004,key="i"},
    {time=60.004,key="q"},
    {time=60.410,key="E"},
    {time=60.410,key="5"},
    {time=60.422,key="9"},
    {time=60.991,key="P"},
    {time=61.002,key="E"},
    {time=61.200,key="P"},
    {time=61.351,key="9"},
    {time=61.385,key="p"},
    {time=61.572,key="o"},
    {time=61.572,key="E"},
    {time=61.572,key="^"},
    {time=61.583,key="q"},
    {time=61.758,key="p"},
    {time=61.770,key="E"},
    {time=61.932,key="s"},
    {time=61.968,key="o"},
    {time=62.351,key="i"},
    {time=62.351,key="E"},
    {time=62.351,key="q"},
    {time=62.595,key="4"},
    {time=62.757,key="y"},
    {time=62.757,key="q"},
    {time=62.757,key="8"},
    {time=62.757,key="4"},
    {time=62.839,key="e"},
    {time=63.128,key="t"},
    {time=63.128,key="8"},
    {time=63.534,key="y"},
    {time=63.534,key="E"},
    {time=63.534,key="("},
    {time=63.534,key="5"},
    {time=63.570,key="@"},
    {time=64.117,key="y"},
    {time=64.349,key="P"},
    {time=64.489,key="t"},
    {time=64.697,key="E"},
    {time=64.697,key="q"},
    {time=64.697,key="^"},
    {time=65.859,key="y"},
    {time=65.871,key="d"},
    {time=65.871,key="i"},
    {time=66.056,key="g"},
    {time=66.056,key="i"},
    {time=66.056,key="E"},
    {time=66.069,key="q"},
    {time=66.254,key="g"},
    {time=66.254,key="i"},
    {time=66.254,key="E"},
    {time=66.266,key="q"},
    {time=66.475,key="4"},
    {time=66.626,key="q"},
    {time=66.683,key="4"},
    {time=67.021,key="8"},
    {time=67.078,key="i"},
    {time=67.427,key="q"},
    {time=67.427,key="8"},
    {time=67.811,key="5"},
    {time=68.589,key="9"},
    {time=68.983,key="E"},
    {time=69.367,key="y"},
    {time=69.367,key="9"},
    {time=69.566,key="i"},
    {time=69.751,key="o"},
    {time=69.751,key="@"},
    {time=70.134,key="^"},
    {time=70.146,key="i"},
    {time=70.355,key="E"},
    {time=70.541,key="P"},
    {time=70.552,key="("},
    {time=70.726,key="o"},
    {time=70.935,key="^"},
    {time=70.947,key="o"},
    {time=71.121,key="y"},
    {time=71.516,key="t"},
    {time=71.692,key="q"},
    {time=71.703,key="t"},
    {time=71.900,key="i"},
    {time=71.900,key="E"},
    {time=72.086,key="E"},
    {time=72.098,key="i"},
    {time=72.098,key="y"},
    {time=72.306,key="i"},
    {time=72.306,key="E"},
    {time=72.481,key="o"},
    {time=72.481,key="q"},
    {time=72.876,key="q"},
    {time=72.876,key="4"},
    {time=73.258,key="i"},
    {time=73.258,key="8"},
    {time=73.643,key="q"},
    {time=74.037,key="s"},
    {time=74.037,key="q"},
    {time=74.037,key="5"},
    {time=74.816,key="9"},
    {time=75.222,key="g"},
    {time=75.222,key="d"},
    {time=75.222,key="E"},
    {time=75.606,key="d"},
    {time=75.606,key="E"},
    {time=75.618,key="9"},
    {time=75.699,key="P"},
    {time=75.978,key="@"},
    {time=75.990,key="d"},
    {time=76.373,key="^"},
    {time=76.768,key="("},
    {time=76.989,key="d"},
    {time=77.116,key="P"},
    {time=77.418,key="^"},
    {time=77.942,key="E"},
    {time=78.325,key="y"},
    {time=78.743,key="i"},
    {time=79.021,key="5"},
    {time=79.102,key="o"},
    {time=79.172,key="5"},
    {time=79.498,key="9"},
    {time=79.893,key="E"},
    {time=79.928,key="o"},
    {time=80.230,key="i"},
    {time=80.276,key="^"},
    {time=80.869,key="o"},
    {time=81.054,key="o"},
    {time=81.054,key="q"},
    {time=81.450,key="i"},
    {time=81.450,key="E"},
    {time=81.833,key="q"},
    {time=82.019,key="i"},
    {time=82.030,key="E"},
    {time=82.228,key="t"},
    {time=82.321,key="@"},
    {time=82.600,key="^"},
    {time=82.611,key="t"},
    {time=82.995,key="@"},
    {time=83.006,key="E"},
    {time=83.006,key="("},
    {time=83.401,key="i"},
    {time=83.412,key="t"},
    {time=83.448,key="y"},
    {time=83.448,key="^"},
    {time=83.785,key="t"},
    {time=84.156,key="q"},
    {time=84.168,key="t"},
    {time=84.562,key="i"},
    {time=84.562,key="E"},
    {time=84.946,key="q"},
    {time=84.957,key="y"},
    {time=85.144,key="q"},
    {time=85.352,key="o"},
    {time=85.352,key="w"},
    {time=85.352,key="5"},
    {time=85.644,key="p"},
    {time=85.644,key="9"},
    {time=86.039,key="o"},
    {time=86.039,key="E"},
    {time=86.422,key="^"},
    {time=86.805,key="y"},
    {time=87.211,key="t"},
    {time=87.211,key="q"},
    {time=87.445,key="i"},
    {time=87.596,key="t"},
    {time=87.991,key="i"},
    {time=87.991,key="E"},
    {time=87.991,key="q"},
    {time=88.350,key="@"},
    {time=88.361,key="t"},
    {time=88.756,key="^"},
    {time=88.769,key="t"},
    {time=89.164,key="y"},
    {time=89.164,key="("},
    {time=89.548,key="E"},
    {time=89.548,key="^"},
    {time=89.930,key="w"},
    {time=90.708,key="q"},
    {time=90.708,key="^"},
    {time=90.894,key="E"},
    {time=90.906,key="q"},
    {time=91.115,key="i"},
    {time=91.115,key="y"},
    {time=91.301,key="i"},
    {time=91.301,key="E"},
    {time=91.476,key="o"},
    {time=91.476,key="w"},
    {time=91.476,key="5"},
    {time=91.882,key="9"},
    {time=92.266,key="E"},
    {time=92.300,key="o"},
    {time=92.625,key="i"},
    {time=92.683,key="^"},
    {time=93.252,key="o"},
    {time=93.417,key="q"},
    {time=93.428,key="o"},
    {time=93.823,key="E"},
    {time=94.218,key="q"},
    {time=94.403,key="E"},
    {time=94.415,key="i"},
    {time=94.415,key="q"},
    {time=94.589,key="t"},
    {time=94.694,key="@"},
    {time=94.995,key="t"},
    {time=95.076,key="^"},
    {time=95.379,key="E"},
    {time=95.392,key="("},
    {time=95.392,key="^"},
    {time=95.473,key="@"},
    {time=95.774,key="i"},
    {time=95.774,key="t"},
    {time=95.844,key="y"},
    {time=95.844,key="^"},
    {time=96.169,key="t"},
    {time=96.541,key="q"},
    {time=96.552,key="t"},
    {time=96.947,key="y"},
    {time=96.947,key="E"},
    {time=96.958,key="i"},
    {time=97.307,key="i"},
    {time=97.342,key="q"},
    {time=97.726,key="o"},
    {time=97.726,key="5"},
    {time=98.098,key="i"},
    {time=98.109,key="P"},
    {time=98.109,key="9"},
    {time=98.306,key="E"},
    {time=98.504,key="s"},
    {time=98.504,key="E"},
    {time=98.888,key="z"},
    {time=98.899,key="d"},
    {time=98.899,key="^"},
    {time=99.294,key="s"},
    {time=99.654,key="P"},
    {time=99.654,key="q"},
    {time=100.060,key="o"},
    {time=100.060,key="E"},
    {time=100.455,key="P"},
    {time=100.455,key="q"},
    {time=100.850,key="s"},
    {time=100.862,key="q"},
    {time=100.931,key="@"},
    {time=101.245,key="s"},
    {time=101.245,key="^"},
    {time=101.606,key="P"},
    {time=101.618,key="("},
    {time=101.861,key="^"},
    {time=102.013,key="P"},
    {time=102.013,key="^"},
    {time=102.407,key="o"},
    {time=102.791,key="q"},
    {time=102.814,key="o"},
    {time=103.197,key="o"},
    {time=103.197,key="E"},
    {time=103.570,key="P"},
    {time=103.570,key="E"},
    {time=103.860,key="@"},
    {time=103.965,key="s"},
    {time=104.046,key="@"},
    {time=104.348,key="^"},
    {time=104.441,key="s"},
    {time=104.743,key="P"},
    {time=104.743,key="("},
    {time=105.138,key="P"},
    {time=105.138,key="^"},
    {time=105.498,key="q"},
    {time=105.707,key="P"},
    {time=105.893,key="E"},
    {time=105.904,key="i"},
    {time=106.287,key="4"},
    {time=106.299,key="8"},
    {time=106.369,key="P"},
    {time=106.404,key="4"},
    {time=106.682,key="j"},
    {time=106.682,key="p"},
    {time=107.089,key="o"},
    {time=107.158,key="5"},
    {time=107.158,key="5"},
    {time=107.845,key="w"},
    {time=107.845,key="5"},
    {time=107.856,key="9"},
    {time=108.240,key="g"},
    {time=108.240,key="5"},
    {time=108.251,key="i"},
    {time=108.251,key="^"},
    {time=108.263,key="^"},
    {time=109.006,key="E"},
    {time=109.402,key="P"},
    {time=109.402,key="E"},
    {time=109.402,key="q"},
    {time=109.448,key="^"},
    {time=109.808,key="p"},
    {time=109.971,key="E"},
    {time=110.203,key="o"},
    {time=110.203,key="@"},
    {time=110.377,key="@"},
    {time=110.760,key="g"},
    {time=110.772,key="i"},
    {time=110.980,key="o"},
    {time=110.980,key="^"},
    {time=111.074,key="@"},
    {time=111.366,key="g"},
    {time=111.366,key="i"},
    {time=111.366,key="y"},
    {time=111.423,key="^"},
    {time=111.655,key="^"},
    {time=111.759,key="y"},
    {time=112.143,key="d"},
    {time=112.526,key="E"},
    {time=112.526,key="q"},
    {time=112.526,key="^"},
    {time=112.724,key="o"},
    {time=112.909,key="4"},
    {time=112.921,key="p"},
    {time=113.106,key="s"},
    {time=113.119,key="q"},
    {time=113.294,key="g"},
    {time=113.305,key="z"},
    {time=113.305,key="d"},
    {time=113.305,key="w"},
    {time=113.328,key="5"},
    {time=113.386,key="5"},
    {time=113.885,key="s"},
    {time=114.083,key="d"},
    {time=114.083,key="w"},
    {time=114.083,key="5"},
    {time=114.095,key="9"},
    {time=114.478,key="^"},
    {time=114.490,key="^"},
    {time=114.501,key="d"},
    {time=114.675,key="s"},
    {time=114.675,key="y"},
    {time=114.849,key="^"},
    {time=114.873,key="d"},
    {time=115.443,key="s"},
    {time=115.443,key="q"},
    {time=115.641,key="d"},
    {time=115.641,key="E"},
    {time=115.641,key="q"},
    {time=115.641,key="^"},
    {time=115.849,key="g"},
    {time=115.860,key="E"},
    {time=116.035,key="d"},
    {time=116.232,key="s"},
    {time=116.418,key="P"},
    {time=116.418,key="w"},
    {time=116.418,key="("},
    {time=116.418,key="@"},
    {time=116.616,key="@"},
    {time=117.022,key="o"},
    {time=117.208,key="P"},
    {time=117.208,key="^"},
    {time=117.314,key="@"},
    {time=117.569,key="^"},
    {time=117.592,key="s"},
    {time=117.790,key="P"},
    {time=117.835,key="^"},
    {time=118.370,key="$"},
    {time=118.823,key="4"}
}

-- ============================================================
-- RAYFIELD UI
-- ============================================================

local Window = Rayfield:CreateWindow({
    Name = "Piano Player - See You Again",
    LoadingTitle = "Piano Player",
    LoadingSubtitle = "See You Again - MIDI Import",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false,
})

-- ── Setup Tab ───────────────────────────────────────────────
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

-- ── See You Again Tab ────────────────────────────────────────
local TabSong = Window:CreateTab("See You Again", 4483345998)

TabSong:CreateButton({
    Name = "▶ See You Again (Full)",
    Callback = function()
        playSong(notes_seeyouagain, "See You Again", nil)
    end,
})

TabSong:CreateButton({
    Name = "▶ See You Again (Melody Only)",
    Callback = function()
        playSong(melodyOnly(notes_seeyouagain), "See You Again [Melody]", false)
    end,
})

TabSong:CreateButton({
    Name = "■ STOP",
    Callback = function() stopSong() end,
})

-- ── 起動 ────────────────────────────────────────────────────
startLagMonitor()

calibrateLag(function(lag)
    local ms = math.floor(lag * 1000)
    Rayfield:Notify({
        Title = "Piano Player Ready!",
        Content = "See You Again | Lag=" .. ms .. "ms | 720 notes",
        Duration = 6,
        Image = "rbxassetid://4483345998"
    })
end)
