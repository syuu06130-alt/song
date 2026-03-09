-- ============================================================
-- Piano Player v5.1  [SugarCrash! - MIDI Import]
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
-- NOTE DATA: SugarCrash! (MIDI Import)
-- ============================================================
local notes_sugarcrash = {
    {time=0.929,key="y"},
    {time=0.929,key="q"},
    {time=0.929,key="9"},
    {time=0.929,key="^"},
    {time=0.941,key="p"},
    {time=1.092,key="s"},
    {time=1.103,key="q"},
    {time=1.115,key="^"},
    {time=1.266,key="g"},
    {time=1.428,key="z"},
    {time=1.440,key="d"},
    {time=1.544,key="s"},
    {time=1.602,key="z"},
    {time=1.602,key="g"},
    {time=1.602,key="d"},
    {time=1.614,key="E"},
    {time=1.765,key="g"},
    {time=1.823,key="d"},
    {time=1.950,key="s"},
    {time=1.950,key="i"},
    {time=2.103,key="J"},
    {time=2.266,key="i"},
    {time=2.266,key="8"},
    {time=2.277,key="p"},
    {time=2.277,key="q"},
    {time=2.323,key="e"},
    {time=2.428,key="p"},
    {time=2.927,key="j"},
    {time=2.939,key="p"},
    {time=3.101,key="J"},
    {time=3.112,key="q"},
    {time=3.112,key="8"},
    {time=3.275,key="j"},
    {time=3.449,key="g"},
    {time=3.449,key="i"},
    {time=3.600,key="w"},
    {time=3.600,key="0"},
    {time=3.600,key="8"},
    {time=3.762,key="s"},
    {time=3.832,key="h"},
    {time=3.879,key="5"},
    {time=3.938,key="f"},
    {time=4.101,key="s"},
    {time=4.426,key="J"},
    {time=4.426,key="0"},
    {time=4.484,key="s"},
    {time=4.589,key="j"},
    {time=4.751,key="t"},
    {time=4.763,key="h"},
    {time=4.936,key="p"},
    {time=4.948,key="y"},
    {time=4.948,key="e"},
    {time=4.948,key="q"},
    {time=4.948,key="9"},
    {time=5.227,key="i"},
    {time=5.750,key="i"},
    {time=6.250,key="9"},
    {time=6.250,key="^"},
    {time=6.261,key="p"},
    {time=6.261,key="y"},
    {time=6.261,key="q"},
    {time=6.424,key="s"},
    {time=6.435,key="y"},
    {time=6.435,key="^"},
    {time=6.598,key="g"},
    {time=6.622,key="q"},
    {time=6.773,key="z"},
    {time=6.773,key="d"},
    {time=6.889,key="s"},
    {time=6.935,key="d"},
    {time=6.935,key="E"},
    {time=6.947,key="z"},
    {time=6.947,key="g"},
    {time=7.086,key="g"},
    {time=7.272,key="s"},
    {time=7.272,key="i"},
    {time=7.457,key="J"},
    {time=7.608,key="p"},
    {time=7.608,key="e"},
    {time=7.608,key="q"},
    {time=7.608,key="8"},
    {time=7.771,key="i"},
    {time=8.259,key="j"},
    {time=8.272,key="p"},
    {time=8.306,key="e"},
    {time=8.434,key="J"},
    {time=8.446,key="q"},
    {time=8.446,key="8"},
    {time=8.608,key="j"},
    {time=8.771,key="g"},
    {time=8.771,key="i"},
    {time=8.933,key="h"},
    {time=8.933,key="w"},
    {time=8.933,key="0"},
    {time=8.933,key="8"},
    {time=9.096,key="s"},
    {time=9.189,key="5"},
    {time=9.258,key="f"},
    {time=9.444,key="h"},
    {time=9.502,key="s"},
    {time=9.560,key="t"},
    {time=9.734,key="0"},
    {time=9.757,key="j"},
    {time=9.757,key="f"},
    {time=9.769,key="8"},
    {time=9.816,key="5"},
    {time=9.933,key="l"},
    {time=9.933,key="s"},
    {time=10.270,key="y"},
    {time=10.270,key="q"},
    {time=10.281,key="e"},
    {time=10.281,key="9"},
    {time=10.444,key="i"},
    {time=10.467,key="p"},
    {time=10.990,key="p"},
    {time=11.082,key="i"},
    {time=11.605,key="s"},
    {time=11.605,key="y"},
    {time=11.605,key="^"},
    {time=11.617,key="q"},
    {time=11.628,key="^"},
    {time=11.919,key="i"},
    {time=11.931,key="s"},
    {time=12.094,key="p"},
    {time=12.105,key="s"},
    {time=12.105,key="q"},
    {time=12.128,key="9"},
    {time=12.268,key="o"},
    {time=12.419,key="o"},
    {time=12.604,key="s"},
    {time=12.929,key="p"},
    {time=12.929,key="4"},
    {time=12.942,key="s"},
    {time=12.942,key="q"},
    {time=13.278,key="p"},
    {time=13.405,key="4"},
    {time=13.441,key="P"},
    {time=13.441,key="t"},
    {time=13.441,key="e"},
    {time=13.441,key="q"},
    {time=13.615,key="p"},
    {time=13.777,key="o"},
    {time=13.929,key="4"},
    {time=13.941,key="s"},
    {time=13.941,key="p"},
    {time=13.941,key="t"},
    {time=13.941,key="q"},
    {time=14.243,key="1"},
    {time=14.254,key="o"},
    {time=14.254,key="8"},
    {time=14.428,key="o"},
    {time=14.603,key="i"},
    {time=14.754,key="8"},
    {time=14.766,key="1"},
    {time=14.777,key="i"},
    {time=14.789,key="w"},
    {time=14.789,key="0"},
    {time=14.928,key="p"},
    {time=15.102,key="p"},
    {time=15.265,key="8"},
    {time=15.265,key="1"},
    {time=15.276,key="p"},
    {time=15.276,key="i"},
    {time=15.612,key="p"},
    {time=15.659,key="2"},
    {time=15.775,key="p"},
    {time=15.940,key="p"},
    {time=16.090,key="q"},
    {time=16.102,key="P"},
    {time=16.136,key="2"},
    {time=16.172,key="e"},
    {time=16.253,key="p"},
    {time=16.253,key="9"},
    {time=16.369,key="i"},
    {time=16.439,key="o"},
    {time=16.613,key="d"},
    {time=16.613,key="i"},
    {time=16.624,key="2"},
    {time=16.926,key="s"},
    {time=16.996,key="^"},
    {time=17.066,key="^"},
    {time=17.100,key="s"},
    {time=17.449,key="s"},
    {time=17.449,key="q"},
    {time=17.472,key="p"},
    {time=17.483,key="9"},
    {time=17.611,key="o"},
    {time=17.750,key="o"},
    {time=18.007,key="p"},
    {time=18.274,key="s"},
    {time=18.274,key="p"},
    {time=18.274,key="4"},
    {time=18.285,key="q"},
    {time=18.610,key="p"},
    {time=18.727,key="4"},
    {time=18.761,key="P"},
    {time=18.761,key="q"},
    {time=18.773,key="t"},
    {time=18.773,key="e"},
    {time=18.935,key="p"},
    {time=19.098,key="o"},
    {time=19.273,key="s"},
    {time=19.273,key="p"},
    {time=19.273,key="q"},
    {time=19.273,key="4"},
    {time=19.284,key="o"},
    {time=19.284,key="t"},
    {time=19.493,key="1"},
    {time=19.598,key="o"},
    {time=19.598,key="8"},
    {time=19.691,key="1"},
    {time=19.772,key="o"},
    {time=19.935,key="i"},
    {time=20.098,key="8"},
    {time=20.109,key="i"},
    {time=20.109,key="w"},
    {time=20.109,key="1"},
    {time=20.121,key="0"},
    {time=20.260,key="p"},
    {time=20.423,key="p"},
    {time=20.597,key="p"},
    {time=20.597,key="i"},
    {time=20.597,key="8"},
    {time=20.597,key="1"},
    {time=20.772,key="i"},
    {time=20.923,key="q"},
    {time=20.934,key="e"},
    {time=20.946,key="y"},
    {time=20.946,key="9"},
    {time=21.143,key="i"},
    {time=21.143,key="p"},
    {time=21.607,key="i"},
    {time=21.666,key="o"},
    {time=21.933,key="o"},
    {time=21.946,key="i"},
    {time=22.258,key="s"},
    {time=22.258,key="y"},
    {time=22.258,key="^"},
    {time=22.271,key="q"},
    {time=22.282,key="^"},
    {time=22.433,key="s"},
    {time=22.607,key="s"},
    {time=22.607,key="q"},
    {time=22.770,key="g"},
    {time=22.770,key="s"},
    {time=22.770,key="p"},
    {time=22.770,key="y"},
    {time=22.770,key="q"},
    {time=22.770,key="9"},
    {time=22.770,key="^"},
    {time=22.932,key="o"},
    {time=22.955,key="^"},
    {time=23.095,key="o"},
    {time=23.443,key="i"},
    {time=23.605,key="p"},
    {time=23.618,key="s"},
    {time=23.618,key="q"},
    {time=23.618,key="4"},
    {time=23.780,key="p"},
    {time=23.932,key="p"},
    {time=24.095,key="t"},
    {time=24.095,key="e"},
    {time=24.095,key="q"},
    {time=24.095,key="4"},
    {time=24.106,key="P"},
    {time=24.269,key="p"},
    {time=24.431,key="o"},
    {time=24.605,key="s"},
    {time=24.605,key="p"},
    {time=24.605,key="q"},
    {time=24.605,key="4"},
    {time=24.617,key="t"},
    {time=24.826,key="1"},
    {time=24.930,key="o"},
    {time=24.930,key="8"},
    {time=25.011,key="1"},
    {time=25.093,key="o"},
    {time=25.279,key="o"},
    {time=25.442,key="d"},
    {time=25.442,key="i"},
    {time=25.442,key="w"},
    {time=25.442,key="8"},
    {time=25.442,key="1"},
    {time=25.453,key="0"},
    {time=25.592,key="t"},
    {time=25.767,key="i"},
    {time=25.907,key="8"},
    {time=25.907,key="1"},
    {time=25.919,key="p"},
    {time=25.919,key="t"},
    {time=26.278,key="i"},
    {time=26.278,key="2"},
    {time=26.383,key="p"},
    {time=26.441,key="i"},
    {time=26.453,key="g"},
    {time=26.616,key="i"},
    {time=26.754,key="e"},
    {time=26.754,key="q"},
    {time=26.766,key="p"},
    {time=26.766,key="o"},
    {time=26.824,key="2"},
    {time=26.928,key="p"},
    {time=26.928,key="e"},
    {time=26.941,key="9"},
    {time=27.103,key="o"},
    {time=27.115,key="i"},
    {time=27.289,key="i"},
    {time=27.289,key="2"},
    {time=27.591,key="s"},
    {time=27.602,key="p"},
    {time=27.602,key="^"},
    {time=27.625,key="^"},
    {time=27.765,key="s"},
    {time=28.115,key="s"},
    {time=28.115,key="q"},
    {time=28.126,key="p"},
    {time=28.137,key="9"},
    {time=28.277,key="o"},
    {time=28.416,key="o"},
    {time=28.602,key="i"},
    {time=28.939,key="p"},
    {time=28.939,key="4"},
    {time=28.950,key="q"},
    {time=29.101,key="p"},
    {time=29.286,key="p"},
    {time=29.426,key="e"},
    {time=29.426,key="q"},
    {time=29.426,key="4"},
    {time=29.438,key="P"},
    {time=29.438,key="t"},
    {time=29.611,key="p"},
    {time=29.774,key="o"},
    {time=29.939,key="p"},
    {time=29.939,key="t"},
    {time=29.939,key="q"},
    {time=29.939,key="4"},
    {time=30.113,key="i"},
    {time=30.113,key="q"},
    {time=30.158,key="1"},
    {time=30.264,key="8"},
    {time=30.333,key="1"},
    {time=30.600,key="p"},
    {time=30.774,key="d"},
    {time=30.774,key="8"},
    {time=30.785,key="w"},
    {time=30.785,key="0"},
    {time=30.936,key="i"},
    {time=31.261,key="p"},
    {time=31.261,key="8"},
    {time=31.261,key="1"},
    {time=31.610,key="g"},
    {time=31.610,key="i"},
    {time=31.610,key="2"},
    {time=31.760,key="p"},
    {time=31.948,key="i"},
    {time=32.087,key="i"},
    {time=32.087,key="q"},
    {time=32.099,key="p"},
    {time=32.146,key="2"},
    {time=32.215,key="e"},
    {time=32.261,key="o"},
    {time=32.296,key="9"},
    {time=32.435,key="o"},
    {time=32.435,key="i"},
    {time=32.609,key="g"},
    {time=32.609,key="i"},
    {time=32.609,key="2"},
    {time=32.784,key="s"},
    {time=32.923,key="^"},
    {time=32.934,key="s"},
    {time=32.934,key="q"},
    {time=32.970,key="^"},
    {time=33.109,key="s"},
    {time=33.236,key="i"},
    {time=33.446,key="g"},
    {time=33.446,key="s"},
    {time=33.446,key="q"},
    {time=33.457,key="p"},
    {time=33.469,key="9"},
    {time=33.608,key="o"},
    {time=33.759,key="o"},
    {time=33.923,key="i"},
    {time=34.097,key="i"},
    {time=34.271,key="s"},
    {time=34.271,key="p"},
    {time=34.271,key="q"},
    {time=34.271,key="4"},
    {time=34.573,key="i"},
    {time=34.620,key="g"},
    {time=34.747,key="4"},
    {time=34.771,key="p"},
    {time=34.771,key="i"},
    {time=34.771,key="t"},
    {time=34.771,key="e"},
    {time=34.771,key="q"},
    {time=34.933,key="o"},
    {time=34.945,key="i"},
    {time=34.956,key="s"},
    {time=35.281,key="t"},
    {time=35.281,key="q"},
    {time=35.281,key="4"},
    {time=35.502,key="1"},
    {time=35.583,key="p"},
    {time=35.595,key="8"},
    {time=35.595,key="4"},
    {time=35.688,key="1"},
    {time=35.921,key="i"},
    {time=36.049,key="p"},
    {time=36.107,key="g"},
    {time=36.107,key="i"},
    {time=36.107,key="8"},
    {time=36.107,key="1"},
    {time=36.119,key="w"},
    {time=36.119,key="0"},
    {time=36.421,key="o"},
    {time=36.421,key="a"},
    {time=36.432,key="w"},
    {time=36.595,key="8"},
    {time=36.595,key="1"},
    {time=36.606,key="i"},
    {time=36.769,key="i"},
    {time=36.943,key="p"},
    {time=36.943,key="2"},
    {time=37.071,key="i"},
    {time=37.105,key="p"},
    {time=37.279,key="g"},
    {time=37.279,key="i"},
    {time=37.419,key="i"},
    {time=37.419,key="e"},
    {time=37.419,key="q"},
    {time=37.430,key="p"},
    {time=37.558,key="e"},
    {time=37.604,key="o"},
    {time=37.769,key="o"},
    {time=37.780,key="i"},
    {time=37.943,key="i"},
    {time=37.943,key="2"},
    {time=38.105,key="i"},
    {time=38.245,key="q"},
    {time=38.256,key="s"},
    {time=38.279,key="^"},
    {time=38.279,key="^"},
    {time=38.430,key="s"},
    {time=38.489,key="p"},
    {time=38.767,key="q"},
    {time=38.778,key="s"},
    {time=38.791,key="9"},
    {time=38.941,key="o"},
    {time=39.092,key="o"},
    {time=39.429,key="p"},
    {time=39.615,key="p"},
    {time=39.615,key="q"},
    {time=39.615,key="4"},
    {time=39.767,key="p"},
    {time=39.941,key="i"},
    {time=40.080,key="4"},
    {time=40.092,key="p"},
    {time=40.092,key="t"},
    {time=40.092,key="e"},
    {time=40.092,key="q"},
    {time=40.254,key="p"},
    {time=40.266,key="o"},
    {time=40.266,key="i"},
    {time=40.277,key="s"},
    {time=40.428,key="o"},
    {time=40.602,key="q"},
    {time=40.602,key="4"},
    {time=40.615,key="t"},
    {time=40.800,key="1"},
    {time=40.916,key="p"},
    {time=40.928,key="8"},
    {time=41.009,key="1"},
    {time=41.102,key="p"},
    {time=41.276,key="i"},
    {time=41.288,key="p"},
    {time=41.450,key="g"},
    {time=41.450,key="d"},
    {time=41.450,key="i"},
    {time=41.450,key="8"},
    {time=41.450,key="1"},
    {time=41.461,key="w"},
    {time=41.461,key="0"},
    {time=41.601,key="i"},
    {time=41.753,key="o"},
    {time=41.753,key="w"},
    {time=41.765,key="a"},
    {time=41.776,key="i"},
    {time=41.927,key="i"},
    {time=41.927,key="8"},
    {time=41.927,key="1"},
    {time=42.101,key="i"},
    {time=42.136,key="w"},
    {time=42.264,key="y"},
    {time=42.264,key="2"},
    {time=42.427,key="y"},
    {time=42.590,key="i"},
    {time=42.612,key="y"},
    {time=42.764,key="d"},
    {time=42.764,key="y"},
    {time=42.775,key="9"},
    {time=42.938,key="i"},
    {time=42.996,key="h"},
    {time=42.996,key="o"},
    {time=43.274,key="i"},
    {time=43.274,key="y"},
    {time=43.599,key="s"},
    {time=43.599,key="y"},
    {time=43.599,key="^"},
    {time=43.623,key="^"},
    {time=43.902,key="i"},
    {time=43.938,key="s"},
    {time=43.938,key="q"},
    {time=44.100,key="9"},
    {time=44.111,key="s"},
    {time=44.111,key="y"},
    {time=44.111,key="q"},
    {time=44.111,key="^"},
    {time=44.123,key="p"},
    {time=44.274,key="o"},
    {time=44.274,key="^"},
    {time=44.425,key="o"},
    {time=44.599,key="s"},
    {time=44.935,key="p"},
    {time=44.935,key="4"},
    {time=44.947,key="s"},
    {time=44.947,key="q"},
    {time=45.272,key="p"},
    {time=45.411,key="4"},
    {time=45.434,key="P"},
    {time=45.434,key="t"},
    {time=45.434,key="e"},
    {time=45.434,key="q"},
    {time=45.609,key="p"},
    {time=45.761,key="o"},
    {time=45.935,key="p"},
    {time=45.935,key="q"},
    {time=45.935,key="4"},
    {time=45.947,key="s"},
    {time=45.947,key="t"},
    {time=46.168,key="1"},
    {time=46.260,key="o"},
    {time=46.260,key="8"},
    {time=46.342,key="1"},
    {time=46.423,key="o"},
    {time=46.608,key="i"},
    {time=46.771,key="i"},
    {time=46.771,key="8"},
    {time=46.771,key="1"},
    {time=46.783,key="g"},
    {time=46.783,key="a"},
    {time=46.783,key="w"},
    {time=46.795,key="0"},
    {time=46.933,key="p"},
    {time=47.097,key="p"},
    {time=47.259,key="8"},
    {time=47.259,key="1"},
    {time=47.271,key="p"},
    {time=47.271,key="i"},
    {time=47.619,key="p"},
    {time=47.619,key="2"},
    {time=47.771,key="p"},
    {time=47.945,key="p"},
    {time=48.096,key="q"},
    {time=48.107,key="p"},
    {time=48.177,key="e"},
    {time=48.258,key="9"},
    {time=48.270,key="p"},
    {time=48.305,key="i"},
    {time=48.432,key="o"},
    {time=48.607,key="i"},
    {time=48.619,key="2"},
    {time=48.921,key="s"},
    {time=49.014,key="^"},
    {time=49.072,key="^"},
    {time=49.095,key="s"},
    {time=49.454,key="s"},
    {time=49.454,key="q"},
    {time=49.478,key="p"},
    {time=49.490,key="9"},
    {time=49.617,key="o"},
    {time=49.746,key="o"},
    {time=50.269,key="s"},
    {time=50.269,key="p"},
    {time=50.269,key="4"},
    {time=50.280,key="q"},
    {time=50.605,key="p"},
    {time=50.733,key="4"},
    {time=50.768,key="P"},
    {time=50.768,key="t"},
    {time=50.768,key="e"},
    {time=50.768,key="q"},
    {time=50.942,key="p"},
    {time=51.104,key="o"},
    {time=51.278,key="p"},
    {time=51.278,key="t"},
    {time=51.278,key="q"},
    {time=51.278,key="4"},
    {time=51.592,key="1"},
    {time=51.603,key="o"},
    {time=51.603,key="8"},
    {time=51.756,key="o"},
    {time=51.930,key="i"},
    {time=52.093,key="8"},
    {time=52.093,key="1"},
    {time=52.104,key="g"},
    {time=52.104,key="i"},
    {time=52.116,key="w"},
    {time=52.116,key="0"},
    {time=52.267,key="p"},
    {time=52.603,key="i"},
    {time=52.627,key="1"},
    {time=52.627,key="8"},
    {time=52.882,key="4"},
    {time=53.184,key="4"}
}

-- ============================================================
-- RAYFIELD UI
-- ============================================================

local Window = Rayfield:CreateWindow({
    Name = "Piano Player - SugarCrash!",
    LoadingTitle = "Piano Player",
    LoadingSubtitle = "SugarCrash! - MIDI Import",
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

-- ── SugarCrash! Tab ──────────────────────────────────────────
local TabSong = Window:CreateTab("SugarCrash!", 4483345998)

TabSong:CreateButton({
    Name = "▶ SugarCrash! (Full)",
    Callback = function()
        playSong(notes_sugarcrash, "SugarCrash!", nil)
    end,
})

TabSong:CreateButton({
    Name = "▶ SugarCrash! (Melody Only)",
    Callback = function()
        playSong(melodyOnly(notes_sugarcrash), "SugarCrash! [Melody]", false)
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
        Content = "SugarCrash! | Lag=" .. ms .. "ms | 614 notes",
        Duration = 6,
        Image = "rbxassetid://4483345998"
    })
end)
