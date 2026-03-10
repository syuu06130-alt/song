-- ============================================================
-- 🎵 Gold Boombox Music Player
-- 100 Songs | Rayfield UI | Roblox Sound Direct
-- ============================================================

local Rayfield    = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players     = game:GetService("Players")
local TweenSvc    = game:GetService("TweenService")
local RS          = game:GetService("RunService")

local player = Players.LocalPlayer
local char   = player.Character or player.CharacterAdded:Wait()

-- ============================================================
-- State
-- ============================================================
local boomboxModel   = nil
local boomboxSound   = nil
local isPlaying      = false
local currentSongName = "None"
local currentVolume  = 1.0

-- ============================================================
-- 100 Songs Database
-- ============================================================
local songs = {
    -- ── User Collection (1-51) ───────────────────────────────
    {n="Classic Easter",                    id="1836009208"},
    {n="Morning Mood (Peer Gynt Suite)",    id="1846088038"},
    {n="The Four Seasons - Spring",         id="9045766074"},
    {n="Horror",                            id="9039981149"},
    {n="Paradise Falls",                    id="1837879082"},
    {n="Gymnopedie No.1",                   id="9045766377"},
    {n="Life in an Elevator",               id="1841647093"},
    {n="Into The Forest",                   id="1845497774"},
    {n="Dion Timmer - Shiawase",            id="5409360995"},
    {n="Song for a Western",                id="9039661312"},
    {n="Cool Vibes",                        id="1840684529"},
    {n="Until Sunrise",                     id="1836798379"},
    {n="Lo-fi Chill A",                     id="9043887091"},
    {n="Trumpet Concerto Allegro",          id="1843536434"},
    {n="Water Music Suite No.1",            id="1837474677"},
    {n="Bossa Me",                          id="1837768517"},
    {n="Atlantis",                          id="1843642608"},
    {n="Happy Song",                        id="1843404009"},
    {n="Sneeky 30",                         id="1846531998"},
    {n="Industry A",                        id="1840287757"},
    {n="Chill Jazz",                        id="1845341094"},
    {n="Clair de Lune",                     id="1846315693"},
    {n="Horror Pantomime",                  id="1836272467"},
    {n="Uptown",                            id="1845554017"},
    {n="Poolside",                          id="9046863253"},
    {n="Diamonds",                          id="1846575559"},
    {n="Sunrise Workout",                   id="1837324500"},
    {n="MESMERIZER (Clown Remix)",          id="71934965392436"},
    {n="No Smoking",                        id="9047105533"},
    {n="Sunset Chill",                      id="9046862738"},
    {n="No More",                           id="1846458016"},
    {n="Up With The Lark C",               id="1848159211"},
    {n="Step To My Dub",                    id="1842616211"},
    {n="Cartoon Scene",                     id="1838674668"},
    {n="HR - EEYUH!",                       id="16190782181"},
    {n="Natural Innovation",                id="1836822226"},
    {n="Noisestorm - Crab Rave",            id="5410086218"},
    {n="In the Dark",                       id="75940515128169"},
    {n="The Woodlands",                     id="1841422324"},
    {n="Come Out Proud",                    id="9043134016"},
    {n="Horror Kit Hits 10",               id="1841093287"},
    {n="All Dropping 8 Bit Beats",          id="9048375035"},
    {n="Western Spaghetti",                 id="1838998447"},
    {n="Happy-Go-Lively",                   id="1841476350"},
    {n="The Natural Kingdom",               id="1845536775"},
    {n="Acoustic Traveller",                id="1841722030"},
    {n="Intensity",                         id="1843943122"},
    {n="Playful Panda C",                   id="9043053143"},
    {n="Town Talk",                         id="1845756489"},
    {n="Soft And Mellow",                   id="1839624545"},
    {n="FNAF 2 - The Puppet",               id="567335338"},
    -- ── Popular Additions (52-100) ───────────────────────────
    {n="Megalovania - Undertale",           id="614032233"},
    {n="Never Gonna Give You Up",           id="1015395511"},
    {n="Coffin Dance (Astronomia)",         id="5904610002"},
    {n="Baby Shark",                        id="4462286812"},
    {n="Among Us Theme",                    id="5981416839"},
    {n="Minecraft - Sweden",                id="1843505070"},
    {n="Fuer Elise - Beethoven",            id="1843542737"},
    {n="Canon in D - Pachelbel",            id="1836383249"},
    {n="Moonlight Sonata",                  id="1837731559"},
    {n="Ode to Joy - Beethoven",            id="1843406635"},
    {n="The Entertainer - Joplin",          id="1843644571"},
    {n="Eye of the Tiger",                  id="141679002"},
    {n="Sweet Victory",                     id="159272335"},
    {n="We Will Rock You",                  id="162065219"},
    {n="All Star - Smash Mouth",            id="232444856"},
    {n="Africa - Toto",                     id="2812167271"},
    {n="Sandstorm - Darude",                id="1288473417"},
    {n="Old Town Road - Lil Nas X",         id="3026765302"},
    {n="Blinding Lights - The Weeknd",      id="4881357979"},
    {n="Bad Guy - Billie Eilish",           id="3830195892"},
    {n="Happier - Marshmello",              id="2390157159"},
    {n="Believer - Imagine Dragons",        id="1845654321"},
    {n="Radioactive - Imagine Dragons",     id="1840657890"},
    {n="Levitating - Dua Lipa",             id="6289046143"},
    {n="Stay - Kid LAROI",                  id="7145793745"},
    {n="Peaches - Justin Bieber",           id="6706705944"},
    {n="Good 4 U - Olivia Rodrigo",         id="7112826328"},
    {n="Montero - Lil Nas X",               id="7005786718"},
    {n="Butter - BTS",                      id="6964432873"},
    {n="Dynamite - BTS",                    id="5924166577"},
    {n="Sunflower - Post Malone",           id="2812167900"},
    {n="Circles - Post Malone",             id="3827463901"},
    {n="Rockstar - Post Malone",            id="2090784840"},
    {n="God's Plan - Drake",               id="2812168400"},
    {n="Hotline Bling - Drake",             id="475682830"},
    {n="SICKO MODE - Travis Scott",         id="2812168300"},
    {n="Uptown Funk - Bruno Mars",          id="238680961"},
    {n="Despacito - Luis Fonsi",            id="1137602748"},
    {n="Shape of You - Ed Sheeran",         id="1000887412"},
    {n="Perfect - Ed Sheeran",              id="1052553465"},
    {n="Hello - Adele",                     id="407779423"},
    {n="Rolling in the Deep - Adele",       id="159151533"},
    {n="Cheap Thrills - Sia",               id="488472970"},
    {n="Titanium - David Guetta",           id="1843765432"},
    {n="Wake Me Up - Avicii",               id="6785005792"},
    {n="Levels - Avicii",                   id="131532208"},
    {n="Animals - Martin Garrix",           id="211756921"},
    {n="Lean On - Major Lazer",             id="237817636"},
    {n="Roses - SAINt JHN",                 id="5354031726"},
    {n="Watermelon Sugar - Harry Styles",   id="5920294212"},
}

-- ============================================================
-- Boombox Builder
-- ============================================================
local function destroyBoombox()
    if boomboxModel then
        boomboxModel:Destroy()
        boomboxModel = nil
        boomboxSound = nil
    end
end

local function makePart(name, size, color, material, parent)
    local p = Instance.new("Part")
    p.Name         = name
    p.Size         = size
    p.Color        = color
    p.Material     = material or Enum.Material.SmoothPlastic
    p.Anchored     = false
    p.CanCollide   = false
    p.CastShadow   = false
    p.Parent       = parent
    return p
end

local function weldTo(base, part, offset)
    part.CFrame = base.CFrame * offset
    local w     = Instance.new("WeldConstraint")
    w.Part0     = base
    w.Part1     = part
    w.Parent    = part
end

local function createBoombox()
    destroyBoombox()

    char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local model   = Instance.new("Model")
    model.Name    = "GoldBoombox"
    model.Parent  = char
    boomboxModel  = model

    local GOLD  = Color3.fromRGB(212, 175, 55)
    local DGOLD = Color3.fromRGB(140, 110, 20)
    local BLACK = Color3.fromRGB(12,  12,  12)
    local NEON  = Color3.fromRGB(255, 210, 60)

    -- ── Main Body ───────────────────────────────────────────
    local body = makePart("Body", Vector3.new(3.4, 1.55, 0.9), GOLD, Enum.Material.Metal, model)
    model.PrimaryPart = body

    -- Position: on character back, slightly raised
    body.CFrame = hrp.CFrame * CFrame.new(0, 0.5, 1.4) * CFrame.Angles(0, math.pi, 0)

    -- Lock to HRP
    local hw = Instance.new("WeldConstraint")
    hw.Part0 = hrp
    hw.Part1 = body
    hw.Parent = body

    -- ── Top Bar (button strip) ───────────────────────────────
    local topBar = makePart("TopBar", Vector3.new(3.4, 0.28, 0.92), BLACK, Enum.Material.Metal, model)
    weldTo(body, topBar, CFrame.new(0, 0.915, 0))

    -- Dots on top bar (decorative neon buttons)
    for i = -2, 2 do
        local dot = makePart("Dot", Vector3.new(0.18, 0.25, 0.18), NEON, Enum.Material.Neon, model)
        weldTo(body, dot, CFrame.new(i * 0.5, 0.92, -0.32))
    end

    -- ── Left Speaker ────────────────────────────────────────
    local lSpk = makePart("LSpk", Vector3.new(1.1, 1.1, 0.18), BLACK, Enum.Material.Metal, model)
    weldTo(body, lSpk, CFrame.new(-1.05, -0.05, 0.45))

    -- X cross on left speaker (gold detail)
    local lx1 = makePart("LX1", Vector3.new(0.95, 0.13, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, lx1, CFrame.new(-1.05, -0.05, 0.5) * CFrame.Angles(0, 0, math.rad(45)))
    local lx2 = makePart("LX2", Vector3.new(0.95, 0.13, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, lx2, CFrame.new(-1.05, -0.05, 0.5) * CFrame.Angles(0, 0, math.rad(-45)))

    -- Left speaker outer gold ring
    local lRing = makePart("LRing", Vector3.new(1.2, 1.2, 0.08), DGOLD, Enum.Material.Metal, model)
    weldTo(body, lRing, CFrame.new(-1.05, -0.05, 0.38))

    -- ── Right Speaker ────────────────────────────────────────
    local rSpk = makePart("RSpk", Vector3.new(1.1, 1.1, 0.18), BLACK, Enum.Material.Metal, model)
    weldTo(body, rSpk, CFrame.new(1.05, -0.05, 0.45))

    local rx1 = makePart("RX1", Vector3.new(0.95, 0.13, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, rx1, CFrame.new(1.05, -0.05, 0.5) * CFrame.Angles(0, 0, math.rad(45)))
    local rx2 = makePart("RX2", Vector3.new(0.95, 0.13, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, rx2, CFrame.new(1.05, -0.05, 0.5) * CFrame.Angles(0, 0, math.rad(-45)))

    local rRing = makePart("RRing", Vector3.new(1.2, 1.2, 0.08), DGOLD, Enum.Material.Metal, model)
    weldTo(body, rRing, CFrame.new(1.05, -0.05, 0.38))

    -- ── Center Display Panel ─────────────────────────────────
    local panel = makePart("Panel", Vector3.new(0.75, 1.15, 0.12), BLACK, Enum.Material.SmoothPlastic, model)
    weldTo(body, panel, CFrame.new(0, -0.05, 0.5))

    -- Neon display glow (thin strip inside panel)
    local glow = makePart("Glow", Vector3.new(0.6, 0.25, 0.13), NEON, Enum.Material.Neon, model)
    weldTo(body, glow, CFrame.new(0, 0.2, 0.5))

    -- Knob (right side of panel)
    local knob = makePart("Knob", Vector3.new(0.28, 0.28, 0.22), GOLD, Enum.Material.Metal, model)
    local knobMesh = Instance.new("SpecialMesh", knob)
    knobMesh.MeshType = Enum.MeshType.Sphere
    weldTo(body, knob, CFrame.new(0.5, 0.15, 0.5))

    -- ── Handle (top arch) ────────────────────────────────────
    local hdl = makePart("Handle", Vector3.new(2.2, 0.2, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, hdl, CFrame.new(0, 1.1, 0))

    -- Handle left post
    local hL = makePart("HandleL", Vector3.new(0.2, 0.55, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, hL, CFrame.new(-1.0, 0.82, 0))
    -- Handle right post
    local hR = makePart("HandleR", Vector3.new(0.2, 0.55, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, hR, CFrame.new(1.0, 0.82, 0))

    -- ── Sound Object ─────────────────────────────────────────
    local snd = Instance.new("Sound")
    snd.Name                = "BoomboxSound"
    snd.Volume              = currentVolume
    snd.Looped              = true
    snd.RollOffMode         = Enum.RollOffMode.Linear
    snd.RollOffMinDistance  = 1
    snd.RollOffMaxDistance  = 80
    snd.Parent              = body
    boomboxSound            = snd

    return snd
end

-- ============================================================
-- Playback
-- ============================================================
local function setGlow(state)
    if not boomboxModel then return end
    local glow = boomboxModel:FindFirstChild("Glow", true)
    local body  = boomboxModel:FindFirstChild("Body",  true)
    if glow then
        TweenSvc:Create(glow, TweenInfo.new(0.4), {
            Color = state and Color3.fromRGB(120, 255, 180) or Color3.fromRGB(255, 210, 60)
        }):Play()
    end
    if body then
        TweenSvc:Create(body, TweenInfo.new(0.4), {
            Color = state and Color3.fromRGB(230, 190, 60) or Color3.fromRGB(212, 175, 55)
        }):Play()
    end
end

local function playSong(song)
    if not boomboxSound then createBoombox() end

    boomboxSound:Stop()
    boomboxSound.SoundId = "rbxassetid://" .. song.id
    boomboxSound.Volume  = currentVolume
    task.wait(0.05)
    boomboxSound:Play()

    isPlaying       = true
    currentSongName = song.n

    setGlow(true)

    Rayfield:Notify({
        Title   = "♪ Now Playing",
        Content = song.n,
        Duration = 5,
        Image   = "rbxassetid://4483345998"
    })
end

local function stopMusic()
    if boomboxSound then boomboxSound:Stop() end
    isPlaying       = false
    currentSongName = "None"
    setGlow(false)
    Rayfield:Notify({
        Title   = "⏹ Stopped",
        Content = "Music stopped",
        Duration = 2,
        Image   = "rbxassetid://4483345998"
    })
end

-- ============================================================
-- Rayfield UI
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name             = "🎵 Gold Boombox",
    LoadingTitle     = "Gold Boombox",
    LoadingSubtitle  = "100 Songs Ready!",
    ConfigurationSaving = {Enabled = false},
    Discord          = {Enabled = false},
    KeySystem        = false,
})

-- ── Controls Tab ─────────────────────────────────────────────
local TabCtrl = Window:CreateTab("Controls", 4483345998)
TabCtrl:CreateSection("Boombox Controls")

TabCtrl:CreateButton({
    Name = "⏹  Stop Music",
    Callback = function() stopMusic() end,
})

TabCtrl:CreateButton({
    Name = "🔄  Rebuild Boombox",
    Callback = function()
        local wasPlaying = isPlaying
        local lastName   = currentSongName
        createBoombox()
        if wasPlaying then
            for _, s in ipairs(songs) do
                if s.n == lastName then playSong(s); break end
            end
        end
        Rayfield:Notify({Title="✅ Rebuilt!", Content="Boombox recreated", Duration=2, Image="rbxassetid://4483345998"})
    end,
})

TabCtrl:CreateSlider({
    Name         = "Volume / 音量",
    Range        = {0, 100},
    Increment    = 5,
    Suffix       = "%",
    CurrentValue = 100,
    Flag         = "bbvol",
    Callback     = function(v)
        currentVolume = v / 100
        if boomboxSound then boomboxSound.Volume = currentVolume end
    end,
})

TabCtrl:CreateSection("Now Playing")
TabCtrl:CreateLabel("♪ Use song tabs to start music")
TabCtrl:CreateLabel("100 songs | Auto-loop | Gold Boombox")

-- ── Song Tabs (25 songs each) ─────────────────────────────────
local tabRanges = {
    {"Songs 1-25",   1,  25},
    {"Songs 26-50",  26, 50},
    {"Songs 51-75",  51, 75},
    {"Songs 76-100", 76, 100},
}

for _, range in ipairs(tabRanges) do
    local tabName, fromIdx, toIdx = range[1], range[2], range[3]
    local tab = Window:CreateTab(tabName, 4483345998)
    tab:CreateSection(tabName)

    for i = fromIdx, math.min(toIdx, #songs) do
        local song = songs[i]
        tab:CreateButton({
            Name     = string.format("%d. %s", i, song.n),
            Callback = function() playSong(song) end,
        })
    end
end

-- ============================================================
-- Character Respawn Handler
-- ============================================================
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    task.wait(1.5)
    local wasPlaying = isPlaying
    local lastName   = currentSongName
    createBoombox()
    if wasPlaying and lastName ~= "None" then
        for _, s in ipairs(songs) do
            if s.n == lastName then playSong(s); break end
        end
    end
end)

-- ============================================================
-- Initialize
-- ============================================================
createBoombox()

Rayfield:Notify({
    Title   = "🎵 Gold Boombox Ready!",
    Content = "100 songs loaded! Choose a song from the tabs.",
    Duration = 6,
    Image   = "rbxassetid://4483345998"
})
