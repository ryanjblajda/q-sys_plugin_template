PageNames = { "Main" }  --List the pages within the plugin

function GetPages(props)
  local pages = {}

  for ix,name in ipairs(PageNames) do
    table.insert(pages, {name = PageNames[ix]})
  end

  return pages
end
