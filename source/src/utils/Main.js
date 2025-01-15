export default {
  data() {
    return {
      showMessage: {
        available: false,
        bleedout: false,
      },
      messages: {
        availableMessage: '',
        bleedoutMessage: '',
      }
    };
  },
  mounted() {
    const self = this;
    window.addEventListener('message', function(event) {
        const nt = event.data;
        switch (nt.type) {
            case "showMessageAvailable":
              self.showMessage.available = true;
              break;
            case "showMessageBleedout":
              self.showMessage.bleedout = true;
              break;
            case "updateAvailableTime":
              self.messages.availableMessage = nt.availableMessage;
              break;
            case "updateBleedoutTime":
              self.messages.bleedoutMessage = nt.bleedoutMessage;
              break;
            case "closeAvailable":
              self.showMessage.available = false;
              break;
            case "closeBleedout":
              self.showMessage.bleedout = false;
              break;
            case "close":
              self.showMessage.bleedout = false;
              self.showMessage.available = false;
              break;
        }
    });
  },   
};