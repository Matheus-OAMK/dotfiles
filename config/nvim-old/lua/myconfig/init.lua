require("myconfig.core.keymap")
require("myconfig.core.options")
require("myconfig.core.autocmds")
MyConfig = MyConfig or {}
MyConfig = require("myconfig.core.icons")
MyConfig = vim.tbl_extend("force", MyConfig, require("myconfig.core.fold"))
require("myconfig.lazy")
