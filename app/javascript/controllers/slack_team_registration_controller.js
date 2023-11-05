import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="slack-team-registration"
export default class extends Controller {
  // Connects to any DOM node, eg: <element data-slack-team-registration-target="message"></element>
  static targets = [ "message" ]

  // Called once when the controller is first created, typically when the
  // HTML element associated with the controller is first encountered in the DOM
  initialize() {
  }

  // Called each time the controller is connected to a new DOM element.
  connect() {
    console.log("=== SlackTeamRegistrationController connected")

    const code = new URLSearchParams(window.location.search).get("code")
    const state = new URLSearchParams(window.location.search).get("state")
    console.log(`=== SlackTeamRegistrationController code: ${code}`)

    if (code) {
      this.messageTarget.innerHTML = "Working, please wait ...";
      // this.messageTarget.style.display = "none";

      // This endpoint raises an error when team already registered, even if it did update
      // the team successfully.
      fetch("/api/teams", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code, state })
      })
        .then(response => response.json())
        .then(data => {
          this.messageTarget.innerHTML = `Team successfully registered!`;
          this.messageTarget.style.display = "block";
        })
        .catch(error => {
          this.messageTarget.innerHTML = "An error occurred while registering the team.";
          this.messageTarget.style.display = "block";
        });
    }
  }
}
