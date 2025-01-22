-- Serviços necessários
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Variáveis de controle
local panelVisible = false
local panelFrame
local isDragging = false
local dragStart = nil
local startPos = nil

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

    -- Função de envio dos dados para o Discord
    submitButton.MouseButton1Click:Connect(function()
        local playerName = textBox.Text
        local playerToFetch = Players:FindFirstChild(playerName)

        if playerToFetch then
            -- Coleta das informações
            local userId = playerToFetch.UserId
            local displayName = playerToFetch.DisplayName
            local userName = playerToFetch.Name
            local accountAge = playerToFetch.AccountAge
            local country = playerToFetch.Country
            local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"

            -- Defina o webhook
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
                            " **\nDisplay Name:** %s \n**Username:** %s \n**User Id:** %d" ..
                            "\n**Account Age:** %d\n**Country:** %s",
                            userId, displayName, userName, userId, accountAge, country
                        ),
                        ["type"] = "rich",
                        ["color"] = tonumber("0xFFD700"),
                        ["thumbnail"] = {
                            ["url"] = avatarUrl
                        },
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
        panelFrame:Destroy()
        panelVisible = false
    else
        createPanel()
        panelVisible = true
    end
end

-- Monitorando o botão Ctrl direito
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Verifica se a tecla control direito (MouseButton2) foi pressionada
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        togglePanel()
    end
end)

-- Função de arrasto do painel
local function makePanelDraggable()
    panelFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = panelFrame.Position
        end
    end)

    panelFrame.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            panelFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    panelFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
end

-- Inicialização
local function initialize()
    makePanelDraggable()
end

initialize()
