import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu", "overlay"];

  connect() {
    this.menuTarget.setAttribute("active", "false");
    this.overlayTarget.setAttribute("active", "false");
  }

  toggle() {
    this.menuTarget.classList.toggle("active");
    this.overlayTarget.classList.toggle("active");
    this.element.classList.toggle("active");
    const toggle = this.element.querySelector(".nav__toggle");
    const open = toggle.classList.toggle("active");
    toggle.setAttribute("aria-expanded", open);
    toggle.setAttribute("aria-label", open ? "Close menu" : "Open menu");
  }
}
