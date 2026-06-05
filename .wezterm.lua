-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = 'Solarized (dark) (terminal.sexy)'
config.font = wezterm.font 'MesloLGS NF'
config.font_size = 14

-- hyperlinks
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- shop manual links
-- ![code payment-service L19-36](./Payments.Domain/Entities/Fees/GoGreenFee.cs)
-- to
-- https://github.com/acv-auctions/payment-service/blob/main/Payments.Domain/Entities/Fees/GoGreenFee.cs#L19-L36
-- non-main branches
table.insert(config.hyperlink_rules, {
	regex = [[!\[code ([^\/]+)\/([^ ]+) L(\d+)-(\d+)\]\(\.([^)]+)\)]],
	format = 'https://github.com/acv-auctions/$1/blob/$2/$5#L$3-L$4',
})
table.insert(config.hyperlink_rules, {
	regex = [[!\[code ([^\/]+)\/([^ ]+) L(\d+)\]\(\.([^)]+)\)]],
	format = 'https://github.com/acv-auctions/$1/blob/$2/$4#L$3',
})


-- multiple lines, main
table.insert(config.hyperlink_rules, {
	regex = [[!\[code ([^ ]+) L(\d+)-(\d+)\]\(\.([^)]+)\)]],
	format = 'https://github.com/acv-auctions/$1/blob/main/$4#L$2-L$3',
})

-- only one line
table.insert(config.hyperlink_rules, {
	regex = [[!\[code ([^ ]+) L(\d+)\]\(\.([^)]+)\)]],
	format = 'https://github.com/acv-auctions/$1/blob/main/$3#L$2',
})

-- make task numbers clickable
-- the first matched regex group is captured in $1.
table.insert(config.hyperlink_rules, {
  regex = [[\b(\w{2,}-\d+)\b]],
  format = 'https://acvauctions.atlassian.net/browse/$1',
})

-- and finally, return the configuration to wezterm
return config
