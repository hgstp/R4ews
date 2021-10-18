## seeded with content from same in adv-r
## deleted bits that seem irrelevant
## commented out bits that look like they may become relevant

knitr::opts_chunk$set(
  comment = "##",
  prompt = TRUE,
  collapse = TRUE,
  # cache = TRUE,
  # fig.retina = 0.8, # figures are either vectors or 300 dpi diagrams
  # dpi = 300,
   out.width = "80%",
   fig.align = 'center',
   fig.width = 6,
   fig.asp = 0.618  # 1 / phi
  # fig.show = "hold"
)

options(
  rlang_trace_top_env = rlang::current_env(),
  rlang__backtrace_on_error = "none"
)

options(
  digits = 3,
  str = strOptions(strict.width = "cut")
)
