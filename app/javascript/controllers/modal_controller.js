import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [ "modal" ]
  connect() {
	console.log('Connect modal')
	this.modalTarget.classList.add('modal-open')
    	this.modalTarget.classList.add('show')
    	this.modalTarget.style.display = 'block'
    	this.modalTarget.removeAttribute('aria-hidden')
    	this.modalTarget.setAttribute('aria-modal', true)
    	this.modalTarget.setAttribute('role', 'dialog')
  }

  disconnect() {
	this.modalTarget.remove()
  }
  close() {
	this.modalTarget.remove()
  }
}
