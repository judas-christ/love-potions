defmodule I18n do
  use Translator

  locale "en",
    flash: [
      hello: "Hello %{first} %{last}!",
      bye: "Bye, %{name}!"
    ],
    users: [
      title: "Users"
    ]

  locale "sv",
    flash: [
      hello: "Hallå %{first} %{last}!",
      bye: "Tjing, %{name}"
    ],
    users: [
      title: "Användare"
    ]
end
