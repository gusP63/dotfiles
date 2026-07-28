local opt = vim.opt
local map = vim.keymap.set
local set_hl = vim.api.nvim_set_hl

-- variables
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- vim.g.zig_fmt_parse_errors = 0
-- vim.g.zig_fmt_autosave = 0

-- this is actually the culprit most likely,
-- does risk some data loss, but worth it for immediate writes
vim.opt.fsync = false

-- options
--opt.netrw = false
vim.opt.statuscolumn = "%=%{v:relnum == 0 ? v:lnum : v:relnum} "
--vim.opt.statuscolumn = ""
opt.encoding = "utf-8"
opt.background = "dark"
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
--opt.signcolumn = "no"
-- opt.showtabline = 2
opt.cursorline = false
opt.showmode = false
opt.splitright = true
opt.splitbelow = true
opt.wrap = false
opt.mouse = "a"
opt.hidden = true
opt.updatetime = 300
opt.tabstop = 8
opt.shiftwidth = 8
opt.expandtab = true
opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 0
opt.sidescrolloff = 0
opt.laststatus = 2
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = false
-- vim.opt.shadafile = "NONE"
--opt.guicursor = "n-v-c:block,i-ci:ver25,r-cr:hor20,t:ver25"

vim.opt.makeprg = "odin build ."

-- zen mode
local zen = false

local function toggle_zen()
        zen = not zen

        if zen then
                vim.opt.statuscolumn = ""
                vim.opt.number = false
                vim.opt.relativenumber = false
                vim.opt.laststatus = 0
        else
                vim.opt.statuscolumn = "%=%{v:relnum == 0 ? v:lnum : v:relnum} "
                vim.opt.number = true
                vim.opt.relativenumber = true
                vim.opt.laststatus = 2
        end
end

vim.api.nvim_create_user_command("Zen", toggle_zen, {})
vim.cmd("cabbrev zen Zen")

-- variables
vim.diagnostic.config({
        virtual_text = false,
        signs = false,
        underline = false,
        update_in_insert = false,
})

-- keybinds
vim.cmd("tnoremap <C-q> <C-\\><C-n>")
map("n", "<C-f>", function()
        vim.lsp.buf.format({ async = false })
        vim.cmd('wa')
end, { silent = true })

map("n", "<C-s>", ":noa wa<CR>", { silent = true })
map("n", "<C-b>", ":Odin <CR>", { silent = true })
map("n", "<C-n>", ":!odin run . <CR>", { silent = true })
map("n", "<C-s-b>", ":make run<CR>", { silent = true })
map("v", "<C-y>", '"+y', { silent = true })
map("n", "<C-p>", '"+p', { silent = true })
map("v", "<C-p>", '"_dP', { silent = true })
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-x>", ":vsplit<CR>")
map("n", "<leader>swap", "<C-w><C-x>")
map("n", "J", ":bprevious<CR>")
map("n", "K", ":bnext<CR>")
map("n", "H", ":tabprev<CR>")
map("n", "L", ":tabnext<CR>")
map("n", "<C-t>", ":term<CR>")
map("n", "<A-n>", ":cnext<CR>")
map("n", "<A-p>", ":cprev<CR>")
map("n", "gz", ":!zeal \"<cword>\"&<CR><CR>")
-- Commands

-- Grep
vim.cmd("cabbrev grep Grep")
vim.o.grepprg = "rg --vimgrep --hidden -g '!.git/*'"
vim.api.nvim_create_user_command('Grep', function(opts)
        local pattern = vim.trim(opts.args)

        if pattern == '' then
                return
        end

        local grep_cmd = vim.o.grepprg .. ' ' .. vim.fn.shellescape(pattern)
        local grep_output = vim.fn.systemlist(grep_cmd)

        if #grep_output == 0 then
                print('No matches found for: ' .. pattern)
                return
        end

        -- Set and open quickfix list
        vim.fn.setqflist({}, ' ', {
                title = 'Grep results for: ' .. pattern,
                lines = grep_output
        })
        vim.cmd('copen')
end, { nargs = 1 })

local user_cmd = vim.api.nvim_create_user_command
user_cmd("Odin", function() require("user.odin").build(opts) end, {})
user_cmd("Note", function(opts) require("user.commands").makeNote(opts) end, { nargs = "?" })
user_cmd("Mdone", function() require("user.commands").toggleStrikeThrough() end, {})
user_cmd("Mtmp", function() require("user.commands").mktemp() end, {})
user_cmd("Mput", function(opts) require("user.commands").echoOutput(opts) end, { nargs = "+" })
user_cmd("Mview", function(opts) require("user.commands").viewOutput(opts) end, { nargs = "+" })

local auto_cmd = vim.api.nvim_create_autocmd
auto_cmd("VimLeavePre", {
        callback = function()
                local cwd = vim.fn.getcwd()
                if vim.fn.isdirectory(cwd .. "/.git") == 1 then
                        vim.cmd("mks! .sess.vim")
                end
        end,
})

local function goto_definition_vsplit()
        local current = vim.api.nvim_get_current_win()
        vim.cmd("wincmd l")
        local right = vim.api.nvim_get_current_win()

        if right ~= current then
                vim.cmd("q")
        end

        vim.cmd("vsplit")
        vim.lsp.buf.definition()
end

auto_cmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
                local opts = { buffer = ev.buf }
                map("n", "gd", vim.lsp.buf.definition, opts)
                map("n", "gs", goto_definition_vsplit)
                map("n", "gr", vim.lsp.buf.references, opts)
                map("n", "gh", vim.lsp.buf.hover, opts)
                map("n", "<leader>ih", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end, opts)
        end,
})

auto_cmd("CursorMoved", {
        group = vim.api.nvim_create_augroup("auto-hlsearch", { clear = true }),
        callback = function()
                if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
                        vim.schedule(function()
                                vim.cmd.nohlsearch()
                        end)
                end
        end,
})

vim.lsp.config('*', {
        root_markers = { '.git' },
})

-- lsp
vim.lsp.enable({
        "ols",
        "lua_ls",
        "zigscient",
        "clangd",
})

-- plugins
vim.pack.add({
        "https://github.com/stevearc/oil.nvim",
        "https://github.com/kylechui/nvim-surround",
        "https://github.com/3rd/image.nvim",
        "https://github.com/christoomey/vim-tmux-navigator",
})

require("image").setup({
        backend = "sixel",
        processor = "magick_cli",
})

require("oil").setup({
        default_file_explorer = true,
        use_default_keymaps = false,
        view_options = {
                show_hidden = false,
        },
        keymaps = {
                ["g?"] = { "actions.show_help", mode = "n" },
                ["<C-e>"] = { "actions.close", mode = "n" },                 -- toggle
                ["<CR>"] = { "actions.select", opts = { vertical = true } }, -- open in new window
                ["<Tab>"] = { "actions.preview", mode = "n" },               -- preview
                ["R"] = { "actions.refresh", mode = "n" },
                ["."] = "actions.select",                                    -- go into
                ["-"] = { "actions.parent", mode = "n" },                    -- go out of
                ["_"] = { "actions.open_cwd", mode = "n" },
                ["`"] = { "actions.cd", mode = "n" },
                ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                ["gs"] = { "actions.change_sort", mode = "n" },
                ["gx"] = "actions.open_external",
                ["g."] = { "actions.toggle_hidden", mode = "n" },
                ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
})
vim.keymap.set("n", "<C-e>", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- native fuzzy finder with :find
-- https://cherryramatis.xyz/posts/native-fuzzy-finder-in-neovim-with-lua-and-cool-bindings/
if vim.fn.executable "rg" == 1 then
        function _G.RgFindFiles(cmdarg, _cmdcomplete)
                local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
                if #cmdarg == 0 then
                        return fnames
                else
                        return vim.fn.matchfuzzy(fnames, cmdarg)
                end
        end

        vim.o.findfunc = 'v:lua.RgFindFiles'
end
local function is_cmdline_type_find()
        local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
        return cmdline_cmd == 'find' or cmdline_cmd == 'fin'
end
auto_cmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
        pattern = { '*' },
        group = vim.api.nvim_create_augroup('CmdlineAutocompletion', { clear = true }),
        callback = function(ev)
                local function should_enable_autocomplete()
                        local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
                        return is_cmdline_type_find()
                end
                if ev.event == 'CmdlineChanged' and should_enable_autocomplete() then
                        vim.opt.wildmode = 'noselect:lastused,full'
                        vim.fn.wildtrigger()
                end
                if ev.event == 'CmdlineLeave' then
                        vim.opt.wildmode = 'full'
                end
        end
})

vim.cmd("colorscheme silentium")
