class MyTheme < Slidize::Theme
  haml "template.haml"

  stylesheet "style.scss"

  javascript :jquery
  javascript "slide.js"

  set :one, :two

  #before do
    # preprocessing
  #end
end
