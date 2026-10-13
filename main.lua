local httpService = game:GetService("HttpService")

-- Base raw GitHub URL pointing to your repository
local baseUrl = "https://raw.githubusercontent.com/Zeus-newui/config/main/"

-- List of all configuration files from the repository
local filesToDownload = {
    "ChilliLibrary/configs/Default.json",
    "ChilliLibrary/configs/Default.json.bak",
    "ChilliLibrary/config_state.json",
    "ChilliLibrary/Games/10563114921/configs/Default.json",
    "ChilliLibrary/Games/10563114921/configs/Default.json.bak",
    "ChilliLibrary/Games/10563114921/configs/new.json",
    "ChilliLibrary/Games/10563114921/configs/new.json.bak",
    "ChilliLibrary/Games/10563114921/config_state.json",
    "ChilliLibrary/SAE_HudEvents.txt",
    "ChilliLibrary/SAE_HudSamples.txt",
    "ChilliLibrary/SAE_LabEggs.json",
    "ChilliLibrary/SAE_LoadProgress.txt",
    "ChilliLibrary/SAE_Priority.json",
    "ChilliLibrary/SAE_Webhook.txt"
}

-- Helper function to ensure subdirectories exist before writing
local function createDirectoriesForFile(filePath)
    local pathSegments = {}
    for segment in filePath:gmatch("[^/]+") do
        table.insert(pathSegments, segment)
    end
    
    table.remove(pathSegments)
    
    local currentPath = ""
    for _, folder in ipairs(pathSegments) do
        currentPath = (currentPath == "" and folder) or (currentPath .. "/" .. folder)
        if not isfolder(currentPath) then
            makefolder(currentPath)
        end
    end
end

-- Sync configuration files to local workspace
print("Synchronizing configuration files...")
for _, relativePath in ipairs(filesToDownload) do
    local fileUrl = baseUrl .. relativePath
    local success, content = pcall(function()
        return game:HttpGet(fileUrl)
    end)
    
    if success and content and #content > 0 then
        createDirectoriesForFile(relativePath)
        writefile(relativePath, content)
        print("[SUCCESS] Saved: " .. relativePath)
    else
        warn("[FAILED] Could not download: " .. relativePath)
    end
end

print("Configuration sync complete! Launching script...")

-- Execute the FlowAuth loader script
local loadSuccess, loadErr = pcall(function()
    loadstring(game:HttpGet("loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()"))()
end)

if not loadSuccess then
    warn("Failed to execute loader: " .. tostring(loadErr))
end
