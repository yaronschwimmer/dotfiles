local secrets = require "secrets"
function bind_keys()
    hs.hotkey.bind("ctrl,shift", "a", nil, run_authy, nil, nil)
    hs.hotkey.bind("ctrl,shift", "s", nil, shrug, nil, nil)
    hs.hotkey.bind("ctrl,shift", "e", nil, private_email, nil, nil)
    hs.hotkey.bind("ctrl,shift", "w", nil, snyk_email, nil, nil)
    hs.hotkey.bind("ctrl,shift", "g", nil, gpg, nil, nil)
    hs.hotkey.bind("ctrl,shift", "c", nil, capitalize, nil, nil)
    hs.hotkey.bind("ctrl,shift", "z", nil, get_zip_code, nil, nil)
end

function run_authy()
    hs.application.launchOrFocus("Authy Desktop.app")
end

function shrug()
    hs.eventtap.keyStrokes("¯\\_(ツ)_/¯")
end

function private_email()
    hs.eventtap.keyStrokes("yaronschwimmer@gmail.com")
end

function snyk_email()
    hs.eventtap.keyStrokes("yaron.schwimmer@snyk.io")
end

function gpg()
    hs.eventtap.keyStrokes(secrets["gpg_key"])
end

function capitalize()
    hs.execute("pbpaste | awk '{for(i=1;i<=NF;i++){ if (i == 1 || substr($(i-1), length($(i-1)),1) ~ /[.!?;]/) $i=toupper(substr($i,1,1)) substr($i,2) }}1' | pbcopy")
end

function get_zip_code()
    hs.eventtap.keyStrokes("5331904")
end

bind_keys()
