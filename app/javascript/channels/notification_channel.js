import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected to notification channel")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log("Notification received.");
    // Called when there's incoming data on the websocket for this channel
    console.log(data)
    var toastRef = document.getElementById('remote_toast')

    document.getElementById('rt_title').textContent = data['title'];
    document.getElementById('rt_body').textContent = data['message'];

    const toastBootstrap = bootstrap.Toast.getOrCreateInstance(toastRef);
    toastBootstrap.show();

  }
});
