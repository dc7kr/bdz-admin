import { Controller } from "@hotwired/stimulus"

// WebAuthn ceremonies for devise-passkeys.
//
// login:    fetches an authentication challenge, asks the authenticator for a
//           passkey and submits the signed credential with the sign in form.
// register: fetches a registration challenge (label + current password are
//           checked server side), creates a passkey and posts it to the server.
export default class extends Controller {
  static targets = ["credential", "label", "password", "error"]
  static values = { challengeUrl: String, createUrl: String }

  connect() {
    if (!window.PublicKeyCredential) {
      this.element.hidden = true
    }
  }

  async login(event) {
    event.preventDefault()
    this.clearError()

    try {
      const options = await this.post(this.challengeUrlValue, {})
      const credential = await navigator.credentials.get({
        publicKey: this.requestOptions(options)
      })

      this.credentialTarget.value = JSON.stringify(this.serializeAssertion(credential))
      this.element.requestSubmit()
    } catch (error) {
      this.showError(error)
    }
  }

  async register(event) {
    event.preventDefault()
    this.clearError()

    const passkey = {
      label: this.labelTarget.value,
      current_password: this.passwordTarget.value
    }

    try {
      const options = await this.post(this.challengeUrlValue, { passkey })
      const credential = await navigator.credentials.create({
        publicKey: this.creationOptions(options)
      })

      const result = await this.post(this.createUrlValue, {
        passkey: {
          label: passkey.label,
          credential: JSON.stringify(this.serializeAttestation(credential))
        }
      })
      window.location.href = result.redirect_to
    } catch (error) {
      this.showError(error)
    }
  }

  // --- server communication

  async post(url, body) {
    const response = await fetch(url, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content
      },
      body: JSON.stringify(body)
    })

    const json = await response.json().catch(() => ({}))
    if (!response.ok) {
      throw new Error(json.message || json.error || response.statusText)
    }
    return json
  }

  // --- JSON <-> WebAuthn conversion

  requestOptions(options) {
    return {
      ...options,
      challenge: this.decode(options.challenge),
      allowCredentials: (options.allowCredentials || []).map((c) => ({ ...c, id: this.decode(c.id) }))
    }
  }

  creationOptions(options) {
    return {
      ...options,
      challenge: this.decode(options.challenge),
      user: { ...options.user, id: this.decode(options.user.id) },
      excludeCredentials: (options.excludeCredentials || []).map((c) => ({ ...c, id: this.decode(c.id) }))
    }
  }

  serializeAssertion(credential) {
    return {
      type: credential.type,
      id: credential.id,
      rawId: this.encode(credential.rawId),
      authenticatorAttachment: credential.authenticatorAttachment,
      clientExtensionResults: credential.getClientExtensionResults(),
      response: {
        clientDataJSON: this.encode(credential.response.clientDataJSON),
        authenticatorData: this.encode(credential.response.authenticatorData),
        signature: this.encode(credential.response.signature),
        userHandle: credential.response.userHandle ? this.encode(credential.response.userHandle) : null
      }
    }
  }

  serializeAttestation(credential) {
    return {
      type: credential.type,
      id: credential.id,
      rawId: this.encode(credential.rawId),
      authenticatorAttachment: credential.authenticatorAttachment,
      clientExtensionResults: credential.getClientExtensionResults(),
      response: {
        clientDataJSON: this.encode(credential.response.clientDataJSON),
        attestationObject: this.encode(credential.response.attestationObject),
        transports: credential.response.getTransports ? credential.response.getTransports() : []
      }
    }
  }

  // base64url without padding; decode also accepts standard base64,
  // since devise-passkeys stores credential ids that way
  encode(buffer) {
    const bytes = new Uint8Array(buffer)
    let binary = ""
    bytes.forEach((b) => { binary += String.fromCharCode(b) })
    return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "")
  }

  decode(value) {
    const base64 = value.replace(/-/g, "+").replace(/_/g, "/")
    const padded = base64 + "=".repeat((4 - (base64.length % 4)) % 4)
    return Uint8Array.from(atob(padded), (c) => c.charCodeAt(0)).buffer
  }

  // --- error display

  clearError() {
    if (this.hasErrorTarget) {
      this.errorTarget.textContent = ""
      this.errorTarget.hidden = true
    }
  }

  showError(error) {
    // user dismissed the browser dialog
    if (error.name === "NotAllowedError" || error.name === "AbortError") return

    console.error(error)
    if (this.hasErrorTarget) {
      this.errorTarget.textContent = error.message
      this.errorTarget.hidden = false
    }
  }
}
