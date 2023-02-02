local secrets = require "secrets"
local repos = require "repos"
local GITHUB_API_PATH = "https://api.github.com"
local GITHUB_API_USER = "yaronschwimmer"
local GITHUB_API_TOKEN = secrets["gh_token"]
local GITHUB_REPOS = repos

local rate_limit_percentage

local menu_bar_refresh_time = 300
local menu_bar = hs.menubar.new()
local menu_items = {}

menu_bar:setTitle("0")
menu_bar:setIcon("./GitHub.png")

-- Helper: get table length
function get_table_length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

-- Helper: do pull request from Github
function get_pull_requests(repo, callback)
    hs.http.doAsyncRequest(GITHUB_API_PATH .. "/repos/" .. repo .. "/pulls",
    "GET",
    "",
    {
        Authorization = "Basic " .. hs.base64.encode(GITHUB_API_USER .. ":" .. GITHUB_API_TOKEN)
    },
    function (code, body, headers)
        if code == 200 then
            local decoded_body = hs.json.decode(body)
            callback(decoded_body)
        else
            print("Error: The code was", code)
            print(hs.inspect(headers))
            callback(nil)
        end

        rate_limit_percentage = 100 - (( headers["X-RateLimit-Remaining"] / headers["X-RateLimit-Limit"] ) * 100)
        if rate_limit_percentage > 50 then
            print(tostring(rate_limit_percentage) .. "%", "rate limit used")
        end
    end
    )
end

-- Build menu over again
function build_menu()
    local pull_requests

    menu_items = {}
    table.insert(menu_items, {
        title = "Refresh",
        fn = function() build_menu() end
    })

    for repo_key,repo in pairs(GITHUB_REPOS) do
        local isBusy = repo[2]
        repo = repo[1]
        get_pull_requests(repo, function (decoded_body)

            if decoded_body == nil then
                print("There was an error trying to retrieve the pull requests!")
            end

            pull_requests = decoded_body

            for k,v in pairs(pull_requests) do
                local st = "off"
                if v.user.login == GITHUB_API_USER then
                    st = "on"
                end
                for i, rev in pairs(v.requested_reviewers) do
                    if rev.login == GITHUB_API_USER then
                        st = "mixed"
                        break
                    end
                end
                if not isBusy or not st == "off" then
                    table.insert(menu_items, {
                        title = repo .. ": ".. v.title .. " (#" .. v.number .. ")",
                        fn = function () 
                            open_url_in_browser(v.html_url)
                        end,
                        number = v.number,
                        html_url = v.html_url,
                        state = st,
                        onStateImage = hs.image.imageFromPath("./GitHub_green.png"),
                        mixedStateImage = hs.image.imageFromPath("./GitHub_yellow.png")
                    })
                end
            end

            menu_bar:setTitle(tostring(get_table_length(menu_items) - 1))
            menu_bar:setMenu(menu_items)
        end)
    end

    buildMenuTimer = hs.timer.doAfter(menu_bar_refresh_time, function() build_menu() end)
end

-- Action: open url in default browser
function open_url_in_browser(url)
    hs.urlevent.openURLWithBundle(url, hs.urlevent.getDefaultHandler('http'))
end

build_menu()
