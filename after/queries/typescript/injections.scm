;; extends
((comment) @injection.content
 (#match? @injection.content "LATEX:")
 (#set! injection.language "latex"))

((line_comment) @injection.content
 (#match? @injection.content "LATEX:")
 (#set! injection.language "latex"))
