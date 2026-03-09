-- ============================================================
-- Piano Player v5.1  [Shape of You - MIDI Import]
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
-- NOTE DATA: Shape of You (MIDI Import)
-- ============================================================
local notes_shapeofyou = {
    {time=3.008,key="T"},
    {time=3.020,key="W"},
    {time=3.020,key="*"},
    {time=3.484,key="u"},
    {time=3.496,key="T"},
    {time=3.496,key="W"},
    {time=3.496,key="*"},
    {time=3.972,key="T"},
    {time=3.973,key="W"},
    {time=3.973,key="*"},
    {time=4.264,key="T"},
    {time=4.275,key="*"},
    {time=4.275,key="$"},
    {time=4.763,key="S"},
    {time=4.763,key="O"},
    {time=4.763,key="u"},
    {time=4.763,key="T"},
    {time=4.763,key="*"},
    {time=4.763,key="$"},
    {time=4.774,key="f"},
    {time=5.227,key="T"},
    {time=5.239,key="*"},
    {time=5.239,key="$"},
    {time=5.564,key="T"},
    {time=5.564,key="0"},
    {time=5.564,key="6"},
    {time=6.006,key="6"},
    {time=6.018,key="u"},
    {time=6.018,key="0"},
    {time=6.494,key="T"},
    {time=6.494,key="0"},
    {time=6.494,key="6"},
    {time=6.807,key="Y"},
    {time=6.807,key="Q"},
    {time=6.819,key="7"},
    {time=7.283,key="T"},
    {time=7.283,key="Q"},
    {time=7.283,key="7"},
    {time=7.748,key="r"},
    {time=7.748,key="Q"},
    {time=7.748,key="7"},
    {time=8.062,key="T"},
    {time=8.062,key="*"},
    {time=8.074,key="W"},
    {time=8.539,key="u"},
    {time=8.539,key="T"},
    {time=8.539,key="W"},
    {time=8.539,key="*"},
    {time=9.015,key="O"},
    {time=9.015,key="T"},
    {time=9.015,key="W"},
    {time=9.015,key="*"},
    {time=9.328,key="T"},
    {time=9.328,key="$"},
    {time=9.340,key="*"},
    {time=9.793,key="O"},
    {time=9.793,key="T"},
    {time=9.804,key="S"},
    {time=9.804,key="u"},
    {time=9.804,key="*"},
    {time=9.804,key="$"},
    {time=10.281,key="T"},
    {time=10.281,key="$"},
    {time=10.293,key="*"},
    {time=10.583,key="0"},
    {time=10.583,key="6"},
    {time=10.595,key="T"},
    {time=11.071,key="u"},
    {time=11.071,key="0"},
    {time=11.071,key="6"},
    {time=11.558,key="T"},
    {time=11.558,key="0"},
    {time=11.558,key="6"},
    {time=11.872,key="Y"},
    {time=11.872,key="Q"},
    {time=11.872,key="7"},
    {time=12.338,key="T"},
    {time=12.338,key="Q"},
    {time=12.338,key="7"},
    {time=12.791,key="7"},
    {time=12.802,key="I"},
    {time=12.802,key="r"},
    {time=12.802,key="Q"},
    {time=12.953,key="T"},
    {time=13.127,key="u"},
    {time=13.127,key="*"},
    {time=13.139,key="W"},
    {time=13.452,key="f"},
    {time=13.452,key="u"},
    {time=13.603,key="O"},
    {time=13.603,key="u"},
    {time=13.603,key="T"},
    {time=13.603,key="W"},
    {time=13.603,key="*"},
    {time=13.743,key="u"},
    {time=13.906,key="u"},
    {time=14.057,key="O"},
    {time=14.057,key="T"},
    {time=14.069,key="u"},
    {time=14.069,key="W"},
    {time=14.069,key="*"},
    {time=14.231,key="u"},
    {time=14.382,key="O"},
    {time=14.382,key="T"},
    {time=14.382,key="*"},
    {time=14.382,key="$"},
    {time=14.522,key="u"},
    {time=14.696,key="f"},
    {time=14.696,key="u"},
    {time=14.858,key="O"},
    {time=14.858,key="T"},
    {time=14.858,key="*"},
    {time=14.858,key="$"},
    {time=14.870,key="u"},
    {time=15.021,key="u"},
    {time=15.172,key="f"},
    {time=15.323,key="T"},
    {time=15.334,key="f"},
    {time=15.334,key="O"},
    {time=15.334,key="u"},
    {time=15.334,key="*"},
    {time=15.334,key="$"},
    {time=15.497,key="u"},
    {time=15.648,key="u"},
    {time=15.648,key="0"},
    {time=15.705,key="6"},
    {time=15.951,key="u"},
    {time=16.159,key="0"},
    {time=16.159,key="6"},
    {time=16.276,key="I"},
    {time=16.416,key="O"},
    {time=16.601,key="0"},
    {time=16.659,key="6"},
    {time=16.752,key="O"},
    {time=16.903,key="O"},
    {time=16.903,key="Q"},
    {time=16.903,key="7"},
    {time=17.391,key="Q"},
    {time=17.391,key="7"},
    {time=17.867,key="Q"},
    {time=17.867,key="7"},
    {time=18.170,key="a"},
    {time=18.193,key="W"},
    {time=18.193,key="*"},
    {time=18.321,key="I"},
    {time=18.472,key="O"},
    {time=18.646,key="O"},
    {time=18.657,key="W"},
    {time=18.657,key="*"},
    {time=18.971,key="O"},
    {time=19.122,key="O"},
    {time=19.122,key="W"},
    {time=19.122,key="*"},
    {time=19.260,key="O"},
    {time=19.435,key="I"},
    {time=19.447,key="*"},
    {time=19.493,key="$"},
    {time=19.586,key="I"},
    {time=19.772,key="I"},
    {time=19.901,key="O"},
    {time=19.901,key="$"},
    {time=19.913,key="*"},
    {time=20.052,key="I"},
    {time=20.377,key="*"},
    {time=20.377,key="$"},
    {time=20.540,key="u"},
    {time=20.702,key="I"},
    {time=20.702,key="0"},
    {time=20.748,key="6"},
    {time=21.016,key="I"},
    {time=21.167,key="I"},
    {time=21.167,key="0"},
    {time=21.167,key="6"},
    {time=21.341,key="I"},
    {time=21.492,key="u"},
    {time=21.492,key="6"},
    {time=21.689,key="6"},
    {time=21.700,key="0"},
    {time=21.817,key="T"},
    {time=21.946,key="Q"},
    {time=21.946,key="7"},
    {time=21.957,key="T"},
    {time=22.422,key="Q"},
    {time=22.422,key="7"},
    {time=22.433,key="T"},
    {time=22.909,key="Q"},
    {time=22.909,key="7"},
    {time=23.072,key="T"},
    {time=23.223,key="O"},
    {time=23.223,key="T"},
    {time=23.223,key="W"},
    {time=23.223,key="*"},
    {time=23.397,key="O"},
    {time=23.535,key="O"},
    {time=23.548,key="T"},
    {time=23.710,key="O"},
    {time=23.710,key="*"},
    {time=23.722,key="W"},
    {time=23.851,key="O"},
    {time=24.002,key="O"},
    {time=24.176,key="O"},
    {time=24.176,key="W"},
    {time=24.176,key="*"},
    {time=24.315,key="O"},
    {time=24.490,key="O"},
    {time=24.490,key="*"},
    {time=24.490,key="$"},
    {time=24.652,key="O"},
    {time=24.815,key="O"},
    {time=24.966,key="O"},
    {time=24.977,key="*"},
    {time=25.011,key="$"},
    {time=25.291,key="O"},
    {time=25.442,key="*"},
    {time=25.499,key="$"},
    {time=25.604,key="O"},
    {time=25.755,key="a"},
    {time=25.755,key="0"},
    {time=25.755,key="6"},
    {time=26.058,key="O"},
    {time=26.221,key="a"},
    {time=26.221,key="O"},
    {time=26.221,key="0"},
    {time=26.290,key="6"},
    {time=26.395,key="I"},
    {time=26.534,key="I"},
    {time=26.697,key="u"},
    {time=26.697,key="0"},
    {time=26.697,key="6"},
    {time=26.859,key="O"},
    {time=27.009,key="Q"},
    {time=27.009,key="7"},
    {time=27.474,key="Q"},
    {time=27.474,key="7"},
    {time=27.648,key="I"},
    {time=27.648,key="Q"},
    {time=27.799,key="u"},
    {time=27.975,key="u"},
    {time=27.975,key="Q"},
    {time=27.975,key="7"},
    {time=28.126,key="u"},
    {time=28.277,key="u"},
    {time=28.277,key="W"},
    {time=28.277,key="*"},
    {time=28.765,key="a"},
    {time=28.765,key="W"},
    {time=28.776,key="*"},
    {time=29.054,key="O"},
    {time=29.066,key="W"},
    {time=29.229,key="O"},
    {time=29.229,key="*"},
    {time=29.241,key="W"},
    {time=29.379,key="O"},
    {time=29.566,key="I"},
    {time=29.566,key="*"},
    {time=29.566,key="$"},
    {time=29.704,key="I"},
    {time=29.845,key="I"},
    {time=30.020,key="I"},
    {time=30.020,key="Q"},
    {time=30.020,key="*"},
    {time=30.020,key="$"},
    {time=30.333,key="I"},
    {time=30.483,key="*"},
    {time=30.483,key="$"},
    {time=30.634,key="I"},
    {time=30.809,key="I"},
    {time=30.809,key="0"},
    {time=30.867,key="6"},
    {time=31.122,key="I"},
    {time=31.273,key="6"},
    {time=31.285,key="0"},
    {time=31.424,key="I"},
    {time=31.749,key="u"},
    {time=31.749,key="0"},
    {time=31.808,key="6"},
    {time=31.914,key="T"},
    {time=32.065,key="Q"},
    {time=32.065,key="7"},
    {time=32.076,key="T"},
    {time=32.203,key="O"},
    {time=32.377,key="O"},
    {time=32.528,key="Q"},
    {time=32.540,key="O"},
    {time=32.540,key="7"},
    {time=32.703,key="a"},
    {time=32.866,key="S"},
    {time=33.004,key="7"},
    {time=33.016,key="S"},
    {time=33.016,key="Q"},
    {time=33.342,key="S"},
    {time=33.342,key="T"},
    {time=33.342,key="W"},
    {time=33.342,key="*"},
    {time=33.654,key="S"},
    {time=33.654,key="*"},
    {time=33.795,key="W"},
    {time=33.795,key="*"},
    {time=33.970,key="S"},
    {time=33.970,key="T"},
    {time=34.283,key="a"},
    {time=34.295,key="T"},
    {time=34.295,key="W"},
    {time=34.295,key="*"},
    {time=34.584,key="S"},
    {time=34.584,key="T"},
    {time=34.584,key="*"},
    {time=34.631,key="$"},
    {time=34.909,key="H"},
    {time=34.909,key="T"},
    {time=35.072,key="O"},
    {time=35.072,key="$"},
    {time=35.084,key="*"},
    {time=35.234,key="G"},
    {time=35.536,key="$"},
    {time=35.548,key="*"},
    {time=35.851,key="0"},
    {time=35.851,key="6"},
    {time=36.014,key="G"},
    {time=36.327,key="0"},
    {time=36.327,key="6"},
    {time=36.490,key="G"},
    {time=36.803,key="f"},
    {time=36.803,key="e"},
    {time=36.803,key="0"},
    {time=36.803,key="6"},
    {time=37.128,key="S"},
    {time=37.128,key="Q"},
    {time=37.128,key="7"},
    {time=37.442,key="f"},
    {time=37.593,key="S"},
    {time=37.593,key="Q"},
    {time=37.593,key="7"},
    {time=37.745,key="H"},
    {time=37.907,key="G"},
    {time=37.907,key="I"},
    {time=38.070,key="Q"},
    {time=38.070,key="7"},
    {time=38.383,key="I"},
    {time=38.383,key="T"},
    {time=38.396,key="S"},
    {time=38.396,key="W"},
    {time=38.396,key="*"},
    {time=38.848,key="T"},
    {time=38.848,key="*"},
    {time=38.859,key="W"},
    {time=39.034,key="k"},
    {time=39.173,key="G"},
    {time=39.184,key="W"},
    {time=39.324,key="H"},
    {time=39.324,key="T"},
    {time=39.324,key="W"},
    {time=39.324,key="*"},
    {time=39.638,key="$"},
    {time=39.649,key="*"},
    {time=39.801,key="f"},
    {time=39.952,key="f"},
    {time=39.976,key="T"},
    {time=40.115,key="*"},
    {time=40.184,key="$"},
    {time=40.277,key="S"},
    {time=40.277,key="T"},
    {time=40.591,key="$"},
    {time=40.602,key="*"},
    {time=40.893,key="f"},
    {time=40.893,key="e"},
    {time=40.893,key="0"},
    {time=40.893,key="6"},
    {time=40.904,key="S"},
    {time=40.904,key="$"},
    {time=41.078,key="G"},
    {time=41.392,key="0"},
    {time=41.450,key="6"},
    {time=41.543,key="G"},
    {time=41.846,key="f"},
    {time=41.857,key="e"},
    {time=41.857,key="0"},
    {time=41.857,key="6"},
    {time=42.171,key="Q"},
    {time=42.182,key="7"},
    {time=42.473,key="f"},
    {time=42.635,key="Q"},
    {time=42.635,key="7"},
    {time=42.647,key="S"},
    {time=42.798,key="f"},
    {time=42.809,key="S"},
    {time=42.809,key="Q"},
    {time=43.123,key="S"},
    {time=43.123,key="Q"},
    {time=43.123,key="7"},
    {time=43.448,key="S"},
    {time=43.448,key="T"},
    {time=43.448,key="*"},
    {time=43.459,key="W"},
    {time=43.902,key="T"},
    {time=43.902,key="*"},
    {time=43.949,key="W"},
    {time=44.053,key="S"},
    {time=44.053,key="T"},
    {time=44.378,key="a"},
    {time=44.390,key="T"},
    {time=44.390,key="W"},
    {time=44.390,key="*"},
    {time=44.692,key="$"},
    {time=44.703,key="S"},
    {time=44.703,key="T"},
    {time=44.703,key="*"},
    {time=45.028,key="H"},
    {time=45.028,key="T"},
    {time=45.156,key="O"},
    {time=45.168,key="T"},
    {time=45.168,key="*"},
    {time=45.226,key="$"},
    {time=45.342,key="G"},
    {time=45.632,key="$"},
    {time=45.644,key="O"},
    {time=45.644,key="*"},
    {time=45.947,key="f"},
    {time=45.958,key="0"},
    {time=45.958,key="6"},
    {time=46.132,key="G"},
    {time=46.470,key="6"},
    {time=46.481,key="0"},
    {time=46.597,key="G"},
    {time=46.910,key="f"},
    {time=46.910,key="0"},
    {time=46.910,key="6"},
    {time=46.922,key="e"},
    {time=47.212,key="S"},
    {time=47.212,key="Q"},
    {time=47.212,key="7"},
    {time=47.526,key="f"},
    {time=47.701,key="Q"},
    {time=47.701,key="7"},
    {time=47.852,key="H"},
    {time=48.003,key="G"},
    {time=48.003,key="I"},
    {time=48.177,key="Q"},
    {time=48.177,key="7"},
    {time=48.364,key="G"},
    {time=48.502,key="S"},
    {time=48.502,key="I"},
    {time=48.502,key="T"},
    {time=48.502,key="W"},
    {time=48.502,key="*"},
    {time=48.967,key="T"},
    {time=48.967,key="W"},
    {time=48.967,key="*"},
    {time=49.118,key="k"},
    {time=49.118,key="T"},
    {time=49.292,key="G"},
    {time=49.443,key="T"},
    {time=49.443,key="*"},
    {time=49.454,key="H"},
    {time=49.454,key="W"},
    {time=49.746,key="$"},
    {time=49.757,key="*"},
    {time=49.897,key="f"},
    {time=50.071,key="f"},
    {time=50.071,key="$"},
    {time=50.210,key="O"},
    {time=50.222,key="f"},
    {time=50.222,key="*"},
    {time=50.292,key="$"},
    {time=50.384,key="L"},
    {time=50.396,key="S"},
    {time=50.396,key="T"},
    {time=50.698,key="S"},
    {time=50.698,key="*"},
    {time=50.733,key="$"},
    {time=50.919,key="T"},
    {time=51.023,key="S"},
    {time=51.023,key="0"},
    {time=51.023,key="6"},
    {time=51.185,key="G"},
    {time=51.336,key="H"},
    {time=51.487,key="0"},
    {time=51.534,key="6"},
    {time=51.639,key="G"},
    {time=51.791,key="f"},
    {time=51.965,key="f"},
    {time=51.965,key="e"},
    {time=52.023,key="0"},
    {time=52.023,key="6"},
    {time=52.267,key="S"},
    {time=52.267,key="Q"},
    {time=52.267,key="7"},
    {time=52.592,key="O"},
    {time=52.917,key="a"},
    {time=53.230,key="S"},
    {time=53.555,key="W"},
    {time=53.555,key="*"},
    {time=53.567,key="T"},
    {time=54.021,key="T"},
    {time=54.021,key="W"},
    {time=54.021,key="*"},
    {time=54.474,key="f"},
    {time=54.497,key="W"},
    {time=54.497,key="*"},
    {time=54.636,key="G"},
    {time=54.810,key="T"},
    {time=54.810,key="$"},
    {time=54.822,key="H"},
    {time=54.822,key="*"},
    {time=55.135,key="G"},
    {time=55.275,key="f"},
    {time=55.275,key="$"},
    {time=55.286,key="*"},
    {time=55.426,key="f"},
    {time=55.741,key="$"},
    {time=55.764,key="f"},
    {time=55.764,key="O"},
    {time=55.764,key="*"},
    {time=56.066,key="0"},
    {time=56.077,key="G"},
    {time=56.077,key="6"},
    {time=56.077,key="$"},
    {time=56.530,key="6"},
    {time=56.542,key="0"},
    {time=56.855,key="S"},
    {time=57.006,key="0"},
    {time=57.006,key="6"},
    {time=57.320,key="Q"},
    {time=57.331,key="H"},
    {time=57.331,key="7"},
    {time=57.623,key="G"},
    {time=57.669,key="I"},
    {time=57.785,key="f"},
    {time=57.797,key="Q"},
    {time=57.797,key="7"},
    {time=57.959,key="f"},
    {time=58.284,key="Q"},
    {time=58.284,key="7"},
    {time=58.586,key="S"},
    {time=58.586,key="I"},
    {time=58.586,key="T"},
    {time=58.598,key="W"},
    {time=58.598,key="*"},
    {time=59.085,key="T"},
    {time=59.085,key="W"},
    {time=59.085,key="*"},
    {time=59.387,key="S"},
    {time=59.387,key="W"},
    {time=59.387,key="*"},
    {time=59.550,key="f"},
    {time=59.561,key="W"},
    {time=59.561,key="*"},
    {time=59.691,key="G"},
    {time=59.865,key="H"},
    {time=59.865,key="O"},
    {time=59.865,key="T"},
    {time=59.865,key="*"},
    {time=59.865,key="$"},
    {time=60.167,key="S"},
    {time=60.167,key="T"},
    {time=60.167,key="*"},
    {time=60.329,key="T"},
    {time=60.329,key="*"},
    {time=60.329,key="$"},
    {time=60.480,key="f"},
    {time=60.828,key="$"},
    {time=60.852,key="*"},
    {time=61.234,key="4"}
}

-- ============================================================
-- RAYFIELD UI
-- ============================================================

local Window = Rayfield:CreateWindow({
    Name = "Piano Player - Shape of You",
    LoadingTitle = "Piano Player",
    LoadingSubtitle = "Shape of You - MIDI Import",
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

-- ── Shape of You Tab ─────────────────────────────────────────
local TabSong = Window:CreateTab("Shape of You", 4483345998)

TabSong:CreateButton({
    Name = "▶ Shape of You (Full)",
    Callback = function()
        playSong(notes_shapeofyou, "Shape of You", nil)
    end,
})

TabSong:CreateButton({
    Name = "▶ Shape of You (Melody Only)",
    Callback = function()
        playSong(melodyOnly(notes_shapeofyou), "Shape of You [Melody]", false)
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
        Content = "Shape of You | Lag=" .. ms .. "ms | 563 notes",
        Duration = 6,
        Image = "rbxassetid://4483345998"
    })
end)
