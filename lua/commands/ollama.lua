-- Create command for starting ollama
vim.api.nvim_create_user_command("OllamaStart", function()
  local job = vim.fn.jobstart({ "systemctl", "--user", "start", "ollama.service" }, {
    on_exit = function(job_id, exit_code)
      if exit_code == 0 then
        vim.notify("Ollama service started successfully", vim.log.levels.INFO)
      end
    end,
    stderr_buffered = true,
    on_stderr = function(chan_id, data, name)
      vim.notify(tostring(#data))
      if #data > 1 then
        vim.notify(table.concat(data, " "), vim.log.levels.ERROR)
      end
    end,
  })
end, {})

-- Create command for stopping ollama
vim.api.nvim_create_user_command("OllamaStop", function()
  local job = vim.fn.jobstart({ "systemctl", "--user", "start", "ollama.service" }, {
    on_exit = function(job_id, exit_code)
      if exit_code == 0 then
        vim.notify("Ollama service stopped successfully", vim.log.levels.INFO)
      end
    end,
    stderr_buffered = true,
    on_stderr = function(chan_id, data, name)
      if #data > 1 then
        vim.notify(table.concat(data, " "), vim.log.levels.ERROR)
      end
    end,
  })
end, {})
