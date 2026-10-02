require "test_helper"
require "webauthn/fake_client"

class PasskeyTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin)
    @user.update!(password: "secret-password", password_confirmation: "secret-password")
    @client = WebAuthn::FakeClient.new("http://www.example.com", encoding: :base64url)
  end

  test "register a passkey, then sign in with it" do
    post user_session_path, params: { user: { login: "admin", password: "secret-password" } }
    assert_response :redirect

    post new_create_challenge_users_passkeys_path, params: { passkey: { label: "Laptop", current_password: "secret-password" } }, as: :json
    assert_response :success
    options = response.parsed_body
    assert_equal @user.reload.webauthn_id, options.dig("user", "id")

    credential = @client.create(challenge: options["challenge"], user_verified: true)
    post users_passkeys_path, params: { passkey: { label: "Laptop", credential: credential.to_json } }, as: :json
    assert_response :success
    assert_equal users_passkeys_path, response.parsed_body["redirect_to"]
    assert_equal [ "Laptop" ], @user.passkeys.pluck(:label)

    delete destroy_user_session_path
    post new_user_session_challenge_path, as: :json
    assert_response :success
    challenge = response.parsed_body["challenge"]

    assertion = @client.get(challenge: challenge, user_verified: true)
    post user_session_path, params: { user: { passkey_credential: assertion.to_json } }
    assert_redirected_to root_path
    assert_not_nil @user.passkeys.first.last_used_at
  end

  test "adding a passkey requires the current password" do
    post user_session_path, params: { user: { login: "admin", password: "secret-password" } }

    post new_create_challenge_users_passkeys_path, params: { passkey: { label: "Laptop", current_password: "wrong" } }, as: :json
    assert_response :unprocessable_entity
  end

  test "sign in with an unknown passkey fails" do
    @client.create(user_verified: true) # credential that was never registered

    post new_user_session_challenge_path, as: :json
    assertion = @client.get(challenge: response.parsed_body["challenge"], user_verified: true)

    post user_session_path, params: { user: { passkey_credential: assertion.to_json } }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
end
