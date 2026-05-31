// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// app javascript

import "@hotwired/turbo-rails"

import "popper"
import "bootstrap"

import "controllers"
import "channels/notification_channel"


import { Turbo } from "@hotwired/turbo-rails"

Turbo.StreamActions.console_log = function() {
  const message = this.getAttribute("message")
  console.log(message)
}

Turbo.StreamActions.show_toast = function() {
  const id = this.getAttribute("id")
  var toastEL = document.getElementById(id)
  bootstrap.Toast.getOrCreateInstance(toastEL).show()
}


Turbo.config.forms.confirm = (message, element, submitter) => {

  let dialog = document.getElementById("turbo-confirm-dialog")
  let messageElement = document.getElementById("turbo-confirm-message")
  let confirmButton = dialog?.querySelector("button[value='confirm']")

  // Fall back to native confirm if dialog isn't in the DOM
  if (!dialog) return Promise.resolve(confirm(message))

  messageElement.textContent = message

  // Allow custom button text via data-turbo-confirm-button
  const buttonText = submitter?.dataset.turboConfirmButton || "Confirm"
  confirmButton.textContent = buttonText

  dialog.showModal()

  return new Promise((resolve) => {
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue === "confirm")
    }, { once: true })
  })
}
