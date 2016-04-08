ExUnit.start
Code.require_file("translator.exs", __DIR__)

defmodule TranslatorTest do
  use ExUnit.Case

  defmodule I18n do
    use Translator

    locale "en", [
      foo: "bar",
      flash: [
        notice: [
          alert: "Alert!",
          hello: "hello %{first} %{last}!"
        ]
      ],
      users: [
        title: "Users",
        profile: [
          title: "Profiles"
        ]
      ]
    ]

    locale "fr", [
      flash: [
        notice: [
          hello: "salut %{first} %{last}!"
        ]
      ]
    ]
  end

  test "it recursively wals translations tree" do
    assert I18n.t("en", "users.title") == "Users"
    assert I18n.t("en", "users.profile.title") == "Profiles"
  end

  test "it handles translations at root level" do
     assert I18n.t("en", "foo") == "bar"
  end

  test "multiple locales" do
    assert I18n.t("fr", "flash.notice.hello", first: "Bah", last: "Smeh") == "salut Bah Smeh!"
  end

  test "it interpolates" do
    assert I18n.t("en", "flash.notice.hello", first: "Bah", last: "Smeh") == "hello Bah Smeh!"
  end

  test "t/3 raises KeyError when bindings not provided" do
    assert_raise KeyError, fn -> I18n.t("en", "flash.notice.hello") end
  end

  test "t/3 returns {:error, :no_translation} when translation missing" do
    assert I18n.t("en", "flash.non_existent") == {:error, :no_translation}
  end

  test "converts interpolated values to strings" do
    assert I18n.t("fr", "flash.notice.hello", first: 123, last: 456) == "salut 123 456!"
  end

  test "compile/1 generates catch-all t/3 functions" do assert Translator.compile([]) |> Macro.to_string == String.strip ~S"""
    (
      def(t(locale, path, bindings \\ []))
      []
      def(t(_locale, _path, _bindings)) do
        {:error, :no_translation}
      end
    )
    """
  end

  test "compile/2 generates t/3 functions from each locale" do
    locales = [{"en", [foo: "bar"]}]
    assert Translator.compile(locales) |> Macro.to_string == String.strip ~S"""
    (
      def(t(locale, path, bindings \\ []))
      [[def(t("en", "foo", bindings)) do
        "" <> "bar"
      end]]
      def(t(_locale, _path, _bindings)) do
        {:error, :no_translation}
      end
    )
    """
  end

end
