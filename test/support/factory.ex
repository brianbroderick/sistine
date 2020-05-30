defmodule Sistine.Factory do
  use ExMachina.Ecto, repo: Sistine.Repo
  alias Sistine.Art.Painting

  def painting_factory do
    %Painting{
      name:
        sequence(:name, [
          "Chapel Ceiling",
          "The Creation of the Sun, Moon, and Plants",
          "Punishment of the Sons of Korah",
          "Expulsion from the Garden of Eden",
          "Sacrifice of Noah",
          "The Deluge",
          "Youth of Moses",
          "Persian Sibyl",
          "Erythraean Sibyl",
          "The Brazen Serpent"
        ]),
      artist:
        sequence(:artist, [
          "Michelangelo",
          "Michelangelo",
          "Sandro Botticelli",
          "Masaccio",
          "Michelangelo",
          "Michelangelo",
          "Sandro Botticelli",
          "Michelangelo",
          "Michelangelo",
          "Michelangelo"
        ]),
      rating: sequence(:rating, &"#{&1}")
    }
  end
end
