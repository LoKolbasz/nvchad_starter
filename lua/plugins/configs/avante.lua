-- Ollama API Documentation https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion
local role_map = {
  user = "user",
  assistant = "assistant",
  system = "system",
  tool = "tool",
}

---@param opts AvantePromptOptions
local parse_messages = function(self, opts)
  local messages = {}
  local has_images = opts.image_paths and #opts.image_paths > 0
  -- Ensure opts.messages is always a table
  local msg_list = opts.messages or {}
  -- Convert Avante messages to Ollama format
  for _, msg in ipairs(msg_list) do
    local role = role_map[msg.role] or "assistant"
    local content = msg.content or "" -- Default content to empty string
    -- Handle multimodal content if images are present
    -- *Experimental* not tested
    if has_images and role == "user" then
      local message_content = {
        role = role,
        content = content,
        images = {},
      }
      for _, image_path in ipairs(opts.image_paths) do
        local base64_content = vim.fn.system(string.format("base64 -w 0 %s", image_path)):gsub("\n", "")
        table.insert(message_content.images, "data:image/png;base64," .. base64_content)
      end
      table.insert(messages, message_content)
    else
      table.insert(messages, {
        role = role,
        content = content,
      })
    end
  end
  return messages
end

local function parse_curl_args(self, code_opts)
  -- Create the messages array starting with the system message
  local messages = {
    { role = "system", content = code_opts.system_prompt },
  }
  -- Extend messages with the parsed conversation messages
  vim.list_extend(messages, self:parse_messages(code_opts))
  -- Construct options separately for clarity
  local options = {
    num_ctx = (self.options and self.options.num_ctx) or 4096,
    temperature = code_opts.temperature or (self.options and self.options.temperature) or 0,
  }
  -- Check if tools table is empty
  local tools = (code_opts.tools and next(code_opts.tools)) and code_opts.tools or nil
  -- Return the final request table
  return {
    url = self.endpoint .. "/api/chat",
    headers = {
      Accept = "application/json",
      ["Content-Type"] = "application/json",
    },
    body = {
      model = self.model,
      messages = messages,
      options = options,
      tools = tools, -- Optional tool support
      stream = true, -- Keep streaming enabled
    },
  }
end

local function parse_stream_data(data, handler_opts)
  local json_data = vim.fn.json_decode(data)
  if json_data then
    if json_data.done then
      handler_opts.on_stop { reason = json_data.done_reason or "stop" }
      return
    end
    if json_data.message then
      local content = json_data.message.content
      if content and content ~= "" then
        handler_opts.on_chunk(content)
      end
    end
    -- Handle tool calls if present
    if json_data.tool_calls then
      for _, tool in ipairs(json_data.tool_calls) do
        handler_opts.on_tool(tool)
      end
    end
  end
end

local function openai_parse_curl_args(opts, code_opts)
  local ret = {
    url = opts.endpoint .. "/chat/completions",
    headers = {
      ["Accept"] = "application/json",
      ["Content-Type"] = "application/json",
      ["x-api-key"] = "ollama",
    },
    body = {
      model = opts.model,
      messages = require("avante.providers").copilot.parse_messages(code_opts), -- you can make your own message, but this is very advanced
      timeout = 30000,
      max_tokens = 4096,
      stream = true,
    },
  }
  return ret
end

local function openai_parse_response_data(data_stream, event_state, _, opts)
        require("avante.providers").openai.parse_response(data_stream, event_state, _, opts)
end

---@type AvanteProvider
local ollama = {
  api_key_name = "",
  endpoint = "http://127.0.0.1:11434",
  model = "qwen2.5-coder:14b", -- Specify your model here
  parse_messages = parse_messages,
  parse_curl_args = parse_curl_args,
  parse_stream_data = parse_stream_data,
}

---@type AvanteProvider
local deepseek_coder_instruct = {
  api_key_name = "",
  endpoint = "http://localhost:11434/v1",
  model = "deepseek-coder-v2:16b",
  -- parse_messages = parse_messages,
  parse_response_data = openai_parse_response_data,
  parse_curl_args = openai_parse_curl_args,
  -- parse_stream_data = parse_stream_data,
}

---@type AvanteProvider
local deepseek_r1_b8 = {
  api_key_name = "",
  endpoint = "http://localhost:11434",
  model = "deepseek-r1:8b",
  parse_messages = parse_messages,
  parse_curl_args = parse_curl_args,
  parse_stream_data = parse_stream_data,
}

local codellama_7b_instruct = {
  api_key_name = "",
  endpoint = "http://localhost:11434",
  model = "codellama:7b-instruct",
  parse_messages = parse_messages,
  parse_curl_args = parse_curl_args,
  parse_stream_data = parse_stream_data,
}

return {
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "vertex" | "cohere" | "copilot" | "deepseek_coder_instruct" | "deepseek_r1_b8" | "codellama_7b_instruct" | string
  provider = "deepseek_coder_instruct",
  auto_suggestions_provider = "deepseek_coder_instruct",
  use_absolute_path = true,
  vendors = {
    deepseek_r1_b8 = deepseek_r1_b8,
    deepseek_coder_instruct = deepseek_coder_instruct,
    codellama_7b_instruct = codellama_7b_instruct,
  },
  behaviour = {
    auto_suggestions = true, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = true,
    minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
    enable_token_counting = false, -- Whether to enable token counting. Default to true.
  },
  mappings = {
    --- @class AvanteConflictMappings
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
  },
  hints = { enabled = true },
  windows = {
    ---@type "right" | "left" | "top" | "bottom"
    position = "right", -- the position of the sidebar
    wrap = true, -- similar to vim.o.wrap
    width = 30, -- default % based on available width
    sidebar_header = {
      enabled = true, -- true, false to enable/disable the header
      align = "center", -- left, center, right for title
      rounded = true,
    },
    input = {
      prefix = "> ",
      height = 8, -- Height of the input window in vertical layout
    },
    edit = {
      border = "rounded",
      start_insert = true, -- Start insert mode when opening the edit window
    },
    ask = {
      floating = false, -- Open the 'AvanteAsk' prompt in a floating window
      start_insert = true, -- Start insert mode when opening the ask window
      border = "rounded",
      ---@type "ours" | "theirs"
      focus_on_apply = "ours", -- which diff to focus after applying
    },
  },
  highlights = {
    ---@type AvanteConflictHighlights
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },
  --- @class AvanteConflictUserConfig
  diff = {
    autojump = true,
    ---@type string | fun(): any
    list_opener = "copen",
  },
  suggestion = {
    debounce = 0,
    throttle = 0,
  },
}

