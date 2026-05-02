// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// app javascript

import "@hotwired/turbo-rails"

import "popper"
import "bootstrap"

import "controllers"
import "channels/notification_channel"


import { Turbo } from "@hotwired/turbo-rails"

const dialog = document.getElementById("turbo-confirm-dialog")
const messageElement = document.getElementById("turbo-confirm-message")
const confirmButton = dialog?.querySelector("button[value='confirm']")

Turbo.config.forms.confirm = (message, element, submitter) => {
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
