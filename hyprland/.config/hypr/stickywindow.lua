
hl.bind(mainMod .. " + o", function()
  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  hl.dispatch(hl.dsp.window.pin({ action = "toggle" }))
end)

hl.window_rule({
  match = { class = "my-window" },
  float = true,
  pin = true,
})
