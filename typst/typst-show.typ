// (name/rule gap handled in holliday-cv template)
#show: holliday-cv.with(
  title: [$title$],
$if(contact)$
  contact: (
$for(contact)$
    (text: "$contact.text$"$if(contact.href)$, href: "$contact.href$"$endif$),
$endfor$
  ),
$endif$
$if(updated)$
  updated: "$updated$",
$endif$
)
