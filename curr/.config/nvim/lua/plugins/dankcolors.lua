return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#191112',
				base01 = '#191112',
				base02 = '#97838a',
				base03 = '#97838a',
				base04 = '#f4dbe3',
				base05 = '#fff3f7',
				base06 = '#fff3f7',
				base07 = '#fff3f7',
				base08 = '#ff585f',
				base09 = '#ff585f',
				base0A = '#ff4282',
				base0B = '#8aff63',
				base0C = '#ff9bbd',
				base0D = '#ff4282',
				base0E = '#ff6398',
				base0F = '#ff6398',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#97838a',
				fg = '#fff3f7',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#ff4282',
				fg = '#191112',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#97838a' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ff9bbd', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#ff6398',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#ff4282',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#ff4282',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#ff9bbd',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#8aff63',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#f4dbe3' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#f4dbe3' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#97838a',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
