function GetVerticalStartPosition(margin, start, height)
  return margin + start + height
end

function GetHorizontalStartPosition(margin, start, width)
  return margin + start + width
end

function GeneratePageMainControlLayout()
end

function GetControlLayout(props)
  local layout = {}
  local graphics = {}

  local CurrentPage = PageNames[props["page_index"].Value]

  if CurrentPage == "Main" then
    layout, graphics = GeneratePageMainControlLayout()
  end
  
  return layout, graphics
end