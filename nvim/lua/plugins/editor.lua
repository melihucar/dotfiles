return {
    {
        'nvim-neo-tree/neo-tree.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim'
        },
        cmd = 'Neotree',
        keys = {{
            '\\',
            ':Neotree reveal<CR>',
            desc = 'NeoTree reveal',
            silent = true
        }},
        opts = {
            filesystem = {
                window = {
                    mappings = {
                        ['\\'] = 'close_window'
                    }
                }
            },
            default_component_configs = {
                indent = {
                    with_expanders = true,
                    expander_collapsed ='',
                    -- right icon
                    expander_expanded =  '',
                    expander_highlight = 'NeoTreeExpander',
                },
                git_status = {
                    symbols = {
                        added     = "",
                        modified  = "",
                        deleted   = "",
                        renamed   = "",
                        untracked = "",
                        -- ignored   = "",
                        -- unstaged  = "",
                        staged    = "",
                        conflict  = "",
                    },
                }
            }
        },
    }
}
