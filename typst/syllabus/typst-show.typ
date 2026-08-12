// (header layout handled in holliday-syllabus template)
#show: holliday-syllabus.with(
  title: [$title$],
$if(coursenum)$
  coursenum: [$coursenum$],
$endif$
$if(semester)$
  semester: [$semester$],
$endif$
$if(meets)$
  meets: [$meets$],
$endif$
$if(contact)$
  contact: (
$for(contact)$
    (text: "$contact.text$"$if(contact.href)$, href: "$contact.href$"$endif$),
$endfor$
  ),
$endif$
)
