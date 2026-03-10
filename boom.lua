-- ============================================================
-- 🎵 Gold Boombox Hub - Complete Edition
-- 100 Songs + Hubs + GUIs | Rayfield UI
-- ============================================================

local Rayfield    = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players     = game:GetService("Players")
local TweenSvc    = game:GetService("TweenService")

local player = Players.LocalPlayer
local char   = player.Character or player.CharacterAdded:Wait()

-- ============================================================
-- State
-- ============================================================
local boomboxModel    = nil
local boomboxSound    = nil
local isPlaying       = false
local currentSongName = "None"
local currentVolume   = 1.0

-- ============================================================
-- 100 Songs
-- ============================================================
local songs = {
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
-- Hub Scripts
-- ============================================================
local boomboxHubs = {
    {n="Pineapple Hub",                url="https://raw.githubusercontent.com/vyks/vyks/main/AuxPineapple.lua"},
    {n="Fish Hub",                     url="https://pastebin.com/raw/6y5Tqvx7"},
    {n="Error-Log Visualizer (Crack)", url="https://raw.githubusercontent.com/Enviie/Errorlog-s-Boombox-Visualizer-Crack/main/Error%27s%20Boombox%20Vis%20Main.lua", arg="Enviie Soo Hot!"},
    {n="Salmon Hub",                   url="https://raw.githubusercontent.com/Salmon-B0T/SalmonHub/main/SalmonHub.lua"},
    {n="Space Hub",                    url="https://raw.githubusercontent.com/vyks/vyks/main/SpaceHub.lua"},
    {n="Free Lucious-Ware Hub",        url="https://raw.githubusercontent.com/vyks/vyks/main/NormalLucious.lua"},
    {n="Boombox Hub v2 [Leaked]",      url="https://pastebin.com/raw/icwWmeGB"},
}

local otherHubs = {
    {n="Giga Chad Hub",   url="https://raw.githubusercontent.com/OWJBWKQLAISH/GigaChad-Hub/main/GigaChad%20Hub%20V1.5"},
    {n="Sirius Hub",      url="https://scriptblox.com/raw/Universal-Script-Sirius-6661"},
    {n="Sean Hub",        url="https://raw.githubusercontent.com/dnaielne/Sean-Hub-Better/main/SeanHub.lua"},
    {n="Ghost Hub",       url="https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub"},
    {n="Ez Hub",          url="https://raw.githubusercontent.com/debug420/Ez-Industries-Launcher-Data/master/Launcher.lua"},
    {n="Chiezzy Hub",     url="https://raw.githubusercontent.com/chiepz/aslbnmnkhby7e/main/crqhryvjahdjwysrnegsf%5Csgd"},
    {n="British Hub",     url="https://raw.githubusercontent.com/RedCoat8102/Britishhub/main/Protected_5655320751526056.lua%20(1).txt"},
    {n="Games Hub",       url="https://raw.githubusercontent.com/TakeModzz/Games-Hub-Script/main/Games%20Hub%20(Always%20updated)"},
    {n="Scripter Hub",    url="https://raw.githubusercontent.com/GamerScripter/Multi-Scripter-X/main/loader"},
    {n="Shizzuru Hub",    url="https://raw.githubusercontent.com/ggshizuru/myScriptHub/main/ShizzuruHub.1.lua"},
}

local guiScripts = {
    {n="R15 Emotes GUI",    url="https://raw.githubusercontent.com/Gi7331/scripts/main/Emote.lua"},
    {n="Animation GUI",     url="https://pastebin.com/raw/0MLPL32f"},
    {n="Unacher Fe GUI",    url="https://pastebin.com/raw/WkZwcGjf"},
    {n="Keyboard GUI",      url="https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt"},
    {n="Chat Hax",          url="https://raw.githubusercontent.com/JPRKPRHARSG/man-/main/fakechater.lua"},
    {n="Chat Spy",          url="https://pastebin.com/raw/KKyRZuyv"},
}

-- ============================================================
-- Boombox Builder
-- ============================================================
local function destroyBoombox()
    if boomboxModel then boomboxModel:Destroy(); boomboxModel = nil; boomboxSound = nil end
end

local function makePart(name, size, color, mat, parent)
    local p = Instance.new("Part")
    p.Name = name; p.Size = size; p.Color = color
    p.Material = mat or Enum.Material.SmoothPlastic
    p.Anchored = false; p.CanCollide = false; p.CastShadow = false
    p.Parent = parent
    return p
end

local function weldTo(base, part, offset)
    part.CFrame = base.CFrame * offset
    local w = Instance.new("WeldConstraint")
    w.Part0 = base; w.Part1 = part; w.Parent = part
end

local function createBoombox()
    destroyBoombox()
    char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local model = Instance.new("Model")
    model.Name = "GoldBoombox"; model.Parent = char
    boomboxModel = model

    local GOLD  = Color3.fromRGB(212, 175, 55)
    local DGOLD = Color3.fromRGB(140, 110, 20)
    local BLACK = Color3.fromRGB(12, 12, 12)
    local NEON  = Color3.fromRGB(255, 210, 60)

    local body = makePart("Body", Vector3.new(3.4, 1.55, 0.9), GOLD, Enum.Material.Metal, model)
    model.PrimaryPart = body
    body.CFrame = hrp.CFrame * CFrame.new(0, 0.5, 1.4) * CFrame.Angles(0, math.pi, 0)

    local hw = Instance.new("WeldConstraint")
    hw.Part0 = hrp; hw.Part1 = body; hw.Parent = body

    -- Top bar
    local topBar = makePart("TopBar", Vector3.new(3.4, 0.28, 0.92), BLACK, Enum.Material.Metal, model)
    weldTo(body, topBar, CFrame.new(0, 0.915, 0))
    for i = -2, 2 do
        local dot = makePart("Dot", Vector3.new(0.18, 0.25, 0.18), NEON, Enum.Material.Neon, model)
        weldTo(body, dot, CFrame.new(i * 0.5, 0.92, -0.32))
    end

    -- Left speaker
    local lSpk = makePart("LSpk", Vector3.new(1.1, 1.1, 0.18), BLACK, Enum.Material.Metal, model)
    weldTo(body, lSpk, CFrame.new(-1.05, -0.05, 0.45))
    local lx1 = makePart("LX1", Vector3.new(0.95, 0.13, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, lx1, CFrame.new(-1.05, -0.05, 0.5) * CFrame.Angles(0,0,math.rad(45)))
    local lx2 = makePart("LX2", Vector3.new(0.95, 0.13, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, lx2, CFrame.new(-1.05, -0.05, 0.5) * CFrame.Angles(0,0,math.rad(-45)))
    local lRing = makePart("LRing", Vector3.new(1.2, 1.2, 0.08), DGOLD, Enum.Material.Metal, model)
    weldTo(body, lRing, CFrame.new(-1.05, -0.05, 0.38))

    -- Right speaker
    local rSpk = makePart("RSpk", Vector3.new(1.1, 1.1, 0.18), BLACK, Enum.Material.Metal, model)
    weldTo(body, rSpk, CFrame.new(1.05, -0.05, 0.45))
    local rx1 = makePart("RX1", Vector3.new(0.95, 0.13, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, rx1, CFrame.new(1.05, -0.05, 0.5) * CFrame.Angles(0,0,math.rad(45)))
    local rx2 = makePart("RX2", Vector3.new(0.95, 0.13, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, rx2, CFrame.new(1.05, -0.05, 0.5) * CFrame.Angles(0,0,math.rad(-45)))
    local rRing = makePart("RRing", Vector3.new(1.2, 1.2, 0.08), DGOLD, Enum.Material.Metal, model)
    weldTo(body, rRing, CFrame.new(1.05, -0.05, 0.38))

    -- Center panel + glow + knob
    local panel = makePart("Panel", Vector3.new(0.75, 1.15, 0.12), BLACK, Enum.Material.SmoothPlastic, model)
    weldTo(body, panel, CFrame.new(0, -0.05, 0.5))
    local glow = makePart("Glow", Vector3.new(0.6, 0.25, 0.13), NEON, Enum.Material.Neon, model)
    weldTo(body, glow, CFrame.new(0, 0.2, 0.5))
    local knob = makePart("Knob", Vector3.new(0.28, 0.28, 0.22), GOLD, Enum.Material.Metal, model)
    local km = Instance.new("SpecialMesh", knob); km.MeshType = Enum.MeshType.Sphere
    weldTo(body, knob, CFrame.new(0.5, 0.15, 0.5))

    -- Handle
    local hdl = makePart("Handle", Vector3.new(2.2, 0.2, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, hdl, CFrame.new(0, 1.1, 0))
    local hL = makePart("HandleL", Vector3.new(0.2, 0.55, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, hL, CFrame.new(-1.0, 0.82, 0))
    local hR = makePart("HandleR", Vector3.new(0.2, 0.55, 0.2), GOLD, Enum.Material.Metal, model)
    weldTo(body, hR, CFrame.new(1.0, 0.82, 0))

    -- Sound
    local snd = Instance.new("Sound")
    snd.Name = "BoomboxSound"; snd.Volume = currentVolume
    snd.Looped = true; snd.RollOffMode = Enum.RollOffMode.Linear
    snd.RollOffMinDistance = 1; snd.RollOffMaxDistance = 80
    snd.Parent = body; boomboxSound = snd
    return snd
end

-- ============================================================
-- Playback helpers
-- ============================================================
local function setGlow(state)
    if not boomboxModel then return end
    local glow = boomboxModel:FindFirstChild("Glow", true)
    if glow then
        TweenSvc:Create(glow, TweenInfo.new(0.4), {
            Color = state and Color3.fromRGB(120, 255, 180) or Color3.fromRGB(255, 210, 60)
        }):Play()
    end
end

local function playSong(song)
    if not boomboxSound then createBoombox() end
    boomboxSound:Stop()
    boomboxSound.SoundId = "rbxassetid://" .. song.id
    boomboxSound.Volume  = currentVolume
    task.wait(0.05); boomboxSound:Play()
    isPlaying = true; currentSongName = song.n
    setGlow(true)
    Rayfield:Notify({Title="♪ Now Playing", Content=song.n, Duration=5, Image="rbxassetid://4483345998"})
end

local function stopMusic()
    if boomboxSound then boomboxSound:Stop() end
    isPlaying = false; currentSongName = "None"; setGlow(false)
    Rayfield:Notify({Title="⏹ Stopped", Content="Music stopped", Duration=2, Image="rbxassetid://4483345998"})
end

local function execHub(url, arg)
    Rayfield:Notify({Title="⏳ Loading...", Content=url:match("([^/]+)$") or "Script", Duration=3, Image="rbxassetid://4483345998"})
    task.spawn(function()
        local ok, err = pcall(function()
            local fn = loadstring(game:HttpGet(url, true))
            if arg then fn(arg) else fn() end
        end)
        if not ok then
            Rayfield:Notify({Title="❌ Error", Content=tostring(err):sub(1,60), Duration=5, Image="rbxassetid://4483345998"})
        end
    end)
end

-- ============================================================
-- Rayfield Window
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name             = "🎵 Gold Boombox Hub",
    LoadingTitle     = "Gold Boombox Hub",
    LoadingSubtitle  = "100 Songs • Hubs • GUIs",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false,
})

-- ── 🎮 Controls ───────────────────────────────────────────────
local TabCtrl = Window:CreateTab("🎮 Controls", 4483345998)
TabCtrl:CreateSection("Boombox")
TabCtrl:CreateButton({Name="⏹  Stop Music",      Callback=function() stopMusic() end})
TabCtrl:CreateButton({
    Name="🔄  Rebuild Boombox",
    Callback=function()
        local was=isPlaying; local last=currentSongName
        createBoombox()
        if was then for _,s in ipairs(songs) do if s.n==last then playSong(s) break end end end
        Rayfield:Notify({Title="✅ Rebuilt",Content="Boombox recreated",Duration=2,Image="rbxassetid://4483345998"})
    end
})
TabCtrl:CreateSlider({
    Name="🔊 Volume", Range={0,100}, Increment=5, Suffix="%", CurrentValue=100, Flag="bbvol",
    Callback=function(v) currentVolume=v/100; if boomboxSound then boomboxSound.Volume=currentVolume end end,
})
TabCtrl:CreateSection("Info")
TabCtrl:CreateLabel("🎵 100 Songs  |  Boombox Hubs  |  GUIs")
TabCtrl:CreateLabel("Select a song from the Songs tabs below")

-- ── 🎵 Songs 1-25 ─────────────────────────────────────────────
local T1 = Window:CreateTab("🎵 1-25", 4483345998)
T1:CreateSection("Songs 1 - 25")
for i=1,25 do local s=songs[i]
    T1:CreateButton({Name=i..". "..s.n, Callback=function() playSong(s) end})
end

-- ── 🎵 Songs 26-50 ────────────────────────────────────────────
local T2 = Window:CreateTab("🎵 26-50", 4483345998)
T2:CreateSection("Songs 26 - 50")
for i=26,50 do local s=songs[i]
    T2:CreateButton({Name=i..". "..s.n, Callback=function() playSong(s) end})
end

-- ── 🎵 Songs 51-75 ────────────────────────────────────────────
local T3 = Window:CreateTab("🎵 51-75", 4483345998)
T3:CreateSection("Songs 51 - 75")
for i=51,75 do local s=songs[i]
    T3:CreateButton({Name=i..". "..s.n, Callback=function() playSong(s) end})
end

-- ── 🎵 Songs 76-100 ───────────────────────────────────────────
local T4 = Window:CreateTab("🎵 76-100", 4483345998)
T4:CreateSection("Songs 76 - 100")
for i=76,#songs do local s=songs[i]
    T4:CreateButton({Name=i..". "..s.n, Callback=function() playSong(s) end})
end

-- ── 📻 Boombox Hubs ───────────────────────────────────────────
local TabBB = Window:CreateTab("📻 Boombox Hubs", 4483345998)
TabBB:CreateSection("Boombox Script Hubs")
for _, h in ipairs(boomboxHubs) do
    local url, arg = h.url, h.arg
    TabBB:CreateButton({Name="▶ "..h.n, Callback=function() execHub(url, arg) end})
end

-- ── 🌐 Other Hubs ─────────────────────────────────────────────
local TabHubs = Window:CreateTab("🌐 Other Hubs", 4483345998)
TabHubs:CreateSection("Multi-Game Hubs")
for _, h in ipairs(otherHubs) do
    local url = h.url
    TabHubs:CreateButton({Name="▶ "..h.n, Callback=function() execHub(url) end})
end

-- ── 🖥 GUIs ───────────────────────────────────────────────────
local TabGUI = Window:CreateTab("🖥 GUIs", 4483345998)
TabGUI:CreateSection("GUI Scripts")
for _, g in ipairs(guiScripts) do
    local url = g.url
    TabGUI:CreateButton({Name="▶ "..g.n, Callback=function() execHub(url) end})
end

-- ── ⭐ Credits ────────────────────────────────────────────────
local TabCred = Window:CreateTab("⭐ Credits", 4483345998)
TabCred:CreateSection("Credits")
TabCred:CreateLabel("🎨 UI Design  - Rayfield Library")
TabCred:CreateLabel("🎵 Boombox   - Custom Gold Model")
TabCred:CreateLabel("📜 Hub Scripts - EternalScripts")
TabCred:CreateLabel("🔧 UI Library  - Lurkingg")
TabCred:CreateLabel("💾 Script Dev  - Gold Boombox Hub")
TabCred:CreateSection("Version")
TabCred:CreateLabel("v3.0 - Complete Edition")
TabCred:CreateLabel("100 Songs | 7 Boombox Hubs")
TabCred:CreateLabel("10 Other Hubs | 6 GUI Scripts")

-- ============================================================
-- Respawn handler
-- ============================================================
player.CharacterAdded:Connect(function(nc)
    char=nc; task.wait(1.5)
    local was=isPlaying; local last=currentSongName
    createBoombox()
    if was and last~="None" then
        for _,s in ipairs(songs) do if s.n==last then playSong(s) break end end
    end
end)

-- ============================================================
-- Init
-- ============================================================
createBoombox()

Rayfield:Notify({
    Title   = "🎵 Gold Boombox Hub Ready!",
    Content = "100 Songs + Hubs + GUIs loaded!",
    Duration = 6,
    Image   = "rbxassetid://4483345998"
})
