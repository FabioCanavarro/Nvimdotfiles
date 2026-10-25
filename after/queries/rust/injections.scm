;; extends
((line_comment) @injection.content
 (#match? @injection.content "LATEX:")
 (#set! injection.language "latex"))

((block_comment) @injection.content
 (#match? @injection.content "LATEX:")
 (#set! injection.language "latex"))
