#import "vendor/resume.typ": *

#let d = toml("data.toml")

#show: resume.with(
  author: d.personal.name,
  location: d.personal.location,
  email: d.personal.email,
  github: d.personal.github,
  linkedin: d.personal.linkedin,
  phone: d.personal.phone,
  personal-site: d.personal.personal-site,
  accent-color: "#26428b",
  font: "New Computer Modern",
  paper: "us-letter",
  author-position: left,
  personal-info-position: left,
)

== Summary

#d.personal.summary

== Education

#for e in d.education [
  #edu(
    institution: e.at("institution", default: ""),
    location: e.at("location", default: ""),
    degree: e.at("degree", default: ""),
    dates: dates-helper(start-date: e.at("start", default: ""), end-date: e.at("end", default: "")),
  )
]

== Work Experience

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

== Projects

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

== Skills

#for s in d.skills [
  - #s.at("text", default: "")
]
