# Pin npm packages by running ./bin/importmap

pin "application"
# Turbo is only used by the admin pages (see layouts/application.html.erb), so
# the public pages never fetch it.
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: false
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Blog editor only (see app/javascript/rich_text.js). Not preloaded so the
# public pages never fetch them.
pin "rich_text", preload: false
pin "trix", preload: false
pin "@rails/actiontext", to: "actiontext.esm.js", preload: false
