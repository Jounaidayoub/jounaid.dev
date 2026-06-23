#import "vendor/resume.typ": *

#let data-file = sys.inputs.at("data", default: "data.toml")
#let d = toml(data-file)
#let theme = d.at("theme", default: (:))
#let labels = d.at("labels", default: (:))

#show: resume.with(
  author: d.personal.name,
  location: d.personal.location,
  email: d.personal.email,
  github: d.personal.github,
  linkedin: d.personal.linkedin,
  phone: d.personal.phone,
  personal-site: d.personal.personal-site,
  accent-color: theme.at("accent-color", default: "#26428b"),
  font: theme.at("font", default: "New Computer Modern"),
  paper: theme.at("paper", default: "a4"),
  lang: theme.at("lang", default: "en"),
  author-position: left,
  personal-info-position: left,
)

== #labels.at("summary", default: "Summary")

#d.personal.summary

== #labels.at("education", default: "Education")

#for e in d.education [
  #edu(
    institution: e.at("institution", default: ""),
    location: e.at("location", default: ""),
    degree: e.at("degree", default: ""),
    dates: dates-helper(start-date: e.at("start", default: ""), end-date: e.at("end", default: "")),
  )
]

== #labels.at("work", default: "Work Experience")

#for w in d.work [
  #work(
    title: w.at("title", default: ""),
    company: w.at("company", default: ""),
    location: w.at("location", default: ""),
    dates: dates-helper(start-date: w.at("start", default: ""), end-date: w.at("end", default: "")),
  )
  #for b in w.bullets [
    - #eval(b, mode: "markup")
  ]
]

== #labels.at("projects", default: "Projects")

#for p in d.projects [
  #project(
    name: p.at("name", default: ""),
    role: p.at("role", default: ""),
    url: p.at("url", default: ""),
  )
  #for b in p.bullets [
    - #eval(b, mode: "markup")
  ]
]

== #labels.at("skills", default: "Skills")

#for s in d.skills [
  - #s.at("text", default: "")
]
