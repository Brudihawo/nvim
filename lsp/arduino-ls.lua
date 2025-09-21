return {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  on_attach = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end,
  cmd = {
    "/opt/arduino-language-server/bin/arduino-language-server",
    "-cli-config", "/home/hawo/.arduino15/arduino-cli.yaml",
    "-cli", "/opt/arduino-cli/bin/arduino-cli",
    "-clangd", "/usr/bin/clangd",
    "-fqbn", "esp32:esp32:lolin32-lite",
  }
}
