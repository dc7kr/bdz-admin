# Pin npm packages by running ./bin/importmap

pin "application", preload: true

# don't put the actual URLs here - use bin/importmap update / outdated

pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "@rails/actiontext", to: "actiontext.esm.js"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/channels", under: "channels"

# Boilerplate ends

# we explicitly use bootstrap from the gem for consistency
pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true


pin "sidebar", to: "sidebar.js", preload: true

pin "jquery" # @3.7.1
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3

# DONT ADD FONT AWESOME HERE
