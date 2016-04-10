defmodule Template do
  import Html

  def render do
    markup do
      tag :table do
        tag :tr do
          for i <- 0..5 do
            tag :td, do: text("Cell #{i}")
          end
        end
      end
      tag :div do
        text "Some more content"
      end
    end
  end

  def render2 do
    markup do
      table do
        tr do
          for i <- 0..5 do
            td do: text("Cell #{i}")
          end
        end
      end
      div do
        text "Some more content"
      end
    end
  end

  def render3 do
    markup do
      div id: "main" do
        h1 class: "title" do
          text("Welcome!")
        end
        div class: "row" do
          div class: "column" do
            p do: text "Hello!"
          end
        end
        button onclick: "javascript: history.go(-1);" do
          text "Back"
        end
      end
    end
  end
end
