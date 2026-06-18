function Code(elem)
  if FORMAT:match('latex') or FORMAT:match('beamer') then
    -- Wraps the code element in your defined LaTeX color
    return {
      pandoc.RawInline('latex', '{\\color{myttgreen}'),
      elem,
      pandoc.RawInline('latex', '}')
    }
  elseif FORMAT:match('html') then
    -- Adds the inline CSS style for HTML output
    elem.attributes['style'] = 'color:green'
    return elem
  end
end