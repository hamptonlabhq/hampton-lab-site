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
    this.element.querySelector(".nav__toggle").classList.toggle("active");
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const body = document.getElementById('page-body');
  const sectionsToObserve = document.querySelectorAll('[data-bg-class]');

  // Keep track of all sections currently intersecting the viewport
  const currentlyIntersectingSections = new Set();

  const observerOptions = {
    root: null, // null means it observes intersections relative to the viewport
    rootMargin: '0px', // No margin
    threshold: 0.4 // Trigger when 40% of the section is visible. Adjust as needed.
    // A lower value (e.g., 0.1) triggers sooner.
    // An array like [0, 0.25, 0.5] can trigger at multiple points.
  };

  const observerCallback = (entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        currentlyIntersectingSections.add(entry.target);
      } else {
        currentlyIntersectingSections.delete(entry.target);
      }
    });

    // Remove all potential background classes first
    sectionsToObserve.forEach(section => {
      body.classList.remove(section.dataset.bgClass);
    });

    // If there are any intersecting sections, apply the class of the topmost one
    if (currentlyIntersectingSections.size > 0) {
      let topmostIntersectingSection = null;

      // Convert Set to Array and sort by offsetTop to find the one highest on the page
      const sortedIntersectingSections = Array.from(currentlyIntersectingSections).sort((a, b) => {
        return a.getBoundingClientRect().top - b.getBoundingClientRect().top;
      });

      if (sortedIntersectingSections.length > 0) {
        topmostIntersectingSection = sortedIntersectingSections[0];
      }

      if (topmostIntersectingSection) {
        body.classList.add(topmostIntersectingSection.dataset.bgClass);
      }
    }
    // If currentlyIntersectingSections is empty, all specific classes are removed,
    // and the body reverts to its default background defined in CSS.
  };

  // Create the observer
  const observer = new IntersectionObserver(observerCallback, observerOptions);

  // Observe each target section
  sectionsToObserve.forEach(section => {
    observer.observe(section);
  });
});
