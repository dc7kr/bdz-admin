# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
# Boilerplate ends

pin "popper", to: "popper.js"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "sidebar", to: "sidebar.js"
pin "jquery" # @3.7.1
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

# DONT ADD FONT AWESOME HERE
