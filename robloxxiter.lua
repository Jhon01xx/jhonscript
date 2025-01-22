-- Obtendo serviços do Roblox
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

-- Variáveis de controle
local LocalPlayer = Players.LocalPlayer
local panelVisible = false
local panelFrame

-- Função para criar o painel
local function createPanel()
    panelFrame = Instance.new("Frame")
    panelFrame.Size = UDim2.new(0, 300, 0, 150)
    panelFrame.Position = UDim2.new(0.5, -150, 0.5, -75)  -- Centraliza o painel na tela
    panelFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    panelFrame.BackgroundTransparency = 0.5
    panelFrame.Parent = game.Players.LocalPlayer.PlayerGui.ScreenGui

    -- Caixa de texto para digitar o nome
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 200, 0, 30)
    textBox.Position = UDim2.new(0, 50, 0, 40)
    textBox.Text = "Digite o nome do jogador"
    textBox.Parent = panelFrame

    -- Botão para enviar
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0, 100, 0, 30)
    submitButton.Position = UDim2.new(0, 100, 0, 80)
    submitButton.Text = "Enviar"
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    submitButton.Parent = panelFrame

    -- Função para enviar dados para o Discord
    submitButton.MouseButton1Click:Connect(function()
        local playerName = textBox.Text
        -- Substitua o nome do jogador abaixo para realizar a coleta real dos dados
        local player = Players:FindFirstChild(playerName)
        if player then
            local userId = player.UserId
            local displayName = player.DisplayName
            local userName = player.Name
            local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"
            local webhookUrl = "https://discord.com/api/webhooks/1331661006677737564/_vQxIjy8Yh8JwKdBXEWwlIS3JsUFyEb3-_CSi92wWDiDpH6NNjpERGdXoMiSWZQJ62aN"
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
                            " **\nDisplay Name:** %s \n**Username:** %s \n**User Id:** %d",
                            userId, displayName, userName, userId
                        ),
                        ["type"] = "rich",
                        ["color"] = tonumber("0xFFD700"),
                        ["thumbnail"] = {
                            ["url"] = avatarUrl
                        },
                    }
                }
            }
            -- Enviando os dados para o Discord
            local data = HttpService:JSONEncode(webhookData)
            local headers = {
                ["content-type"] = "application/json"
            }
            local request = http_request or request or HttpPost or syn.request
            local abcdef = {Url = webhookUrl, Body = data, Method = "POST", Headers = headers}
            request(abcdef)
        end
    end)
end

-- Função para esconder ou mostrar o painel
local function togglePanel()
    if panelVisible then
        panelFrame:Destroy()
        panelVisible = false
    else
        createPanel()
        panelVisible = true
    end
end

-- Monitorando a tecla Ctrl direito
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then -- Botão direito do mouse (Ctrl direito)
        togglePanel()
    end
end)

-- Função para mover o painel
local function makePanelDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    panelFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = panelFrame.Position
        end
    end)

    panelFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            panelFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    panelFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Função para inicializar o painel
local function initialize()
    createPanel()
    makePanelDraggable()
end

initialize()
