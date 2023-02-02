local secrets = require "secrets"
local repos = require "repos"
local GITHUB_API_PATH = "https://api.github.com"
local GITHUB_API_USER = "yaronschwimmer"
local GITHUB_API_TOKEN = secrets["gh_token"]
local GITHUB_REPOS = repos

local rate_limit_percentage
local logger = hs.logger.new('githubpr', 'debug')
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

-- Helper: get issues from Github
function get_issues(repo, callback)
    hs.http.doAsyncRequest(GITHUB_API_PATH .. "/repos/" .. repo .. "/issues?creator=" .. GITHUB_API_USER,
    "GET",
    "",
    {
        Authorization = "Basic " .. hs.base64.encode(GITHUB_API_USER .. ":" .. GITHUB_API_TOKEN)
    },
    function (code, body, headers)
        if code == 200 then
            local prs = {}
            local decoded_body = hs.json.decode(body)
            for k,v in pairs(decoded_body) do
                if v['pull_request'] then
                    c, b, h = hs.http.get(v['pull_request']['url'], 
                    {
                        Authorization = "Basic " .. hs.base64.encode(GITHUB_API_USER .. ":" .. GITHUB_API_TOKEN)
                    })
                    if c == 200 then
                        b = hs.json.decode(b)
                        table.insert(prs, b)
                    end
                end
            end
            callback(repo, prs)
        else
            print("Error: The code was", code)
            print(hs.inspect(headers))
            callback(repo, nil)
        end

        rate_limit_percentage = 100 - (( headers["X-RateLimit-Remaining"] / headers["X-RateLimit-Limit"] ) * 100)
        if rate_limit_percentage > 50 then
            print(tostring(rate_limit_percentage) .. "%", "rate limit used")
        end
    end
    )
end

-- Helper: get all pull requests from github
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
            callback(repo, decoded_body)
        else
            print("Error: The code was", code)
            print(hs.inspect(headers))
            callback(repo, nil)
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
        local is_busy = repo[2]
        repo = repo[1]
        if is_busy then
            get_issues(repo, req_cb)
        else 
            get_pull_requests(repo, req_cb) 
        end
    end

    buildMenuTimer = hs.timer.doAfter(menu_bar_refresh_time, function() build_menu() end)
end

function req_cb(repo, decoded_body)
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

    menu_bar:setTitle(tostring(get_table_length(menu_items) - 1))
    menu_bar:setMenu(menu_items)
end

-- Action: open url in default browser
function open_url_in_browser(url)
    hs.urlevent.openURLWithBundle(url, hs.urlevent.getDefaultHandler('http'))
end

build_menu()
