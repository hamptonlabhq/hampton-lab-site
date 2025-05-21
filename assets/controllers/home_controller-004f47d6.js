import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // Define values that can be passed from HTML data attributes
  static values = {
    color: String, // Color to apply when intersecting
    defaultColor: String // Default color when not intersecting
  };

  connect() {
    console.log('Home Stimulus controller connected, setting up Intersection Observer.');

    // Define the options for the Intersection Observer
    this.options = {
      root: null, // The viewport is the root (i.e., the browser window)
      rootMargin: '0px', // No margin around the root
      threshold: 0.2 // Trigger when 50% of the target element is visible
    };

    // Create a new Intersection Observer instance, binding `this.handleIntersection` to the controller instance.
    // This ensures that `this` inside `handleIntersection` refers to the Stimulus controller.
    this.observer = new IntersectionObserver(this.handleIntersection.bind(this), this.options);

    // Start observing the element this controller is attached to (which is the <section> in your HTML).
    this.observer.observe(this.element);
    // console.log('Observing element:', this.element);
  }

  /**
   * Callback function for the Intersection Observer.
   * This function is executed when the observed element's visibility changes.
   * @param {Array<IntersectionObserverEntry>} entries - An array of IntersectionObserverEntry objects.
   * @param {IntersectionObserver} observer - The Intersection Observer instance.
   */
  handleIntersection(entries, observer) {
    entries.forEach(entry => {
      const body = document.body;

      if (entry.isIntersecting) {
        body.style.backgroundColor = this.colorValue || "var(--color-beige)";
      } else {
        body.style.backgroundColor = this.defaultColorValue || "var(--color-white)";
      }
    });
  }

  disconnect() {
    if (this.observer) {
      this.observer.unobserve(this.element);
      console.log('Home Stimulus controller disconnected and unobserved element.');
    }
  }
}
