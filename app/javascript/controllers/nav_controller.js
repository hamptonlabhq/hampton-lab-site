import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    this.menuTarget.setAttribute("active", "false");
  }

  toggle() {
    this.menuTarget.classList.toggle("active");
    this.element.classList.toggle("active");
    this.element.querySelector(".nav__toggle").classList.toggle("active");
  }
}
