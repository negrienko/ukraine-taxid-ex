IEx.configure(
  colors: [
    enabled: true,
    eval_result: [:cyan, :bright],
    eval_error: [:light_magenta]
  ],
  default_prompt:
    [
      "%prefix",
      :white,
      "(",
      :blue,
      "%counter",
      :white,
      ")",
      # plain string
      "›",
      :reset
    ]
    |> IO.ANSI.format()
    |> IO.chardata_to_string()
)

alias UkraineTaxidEx.{Commons, Edrpou, Itin}
