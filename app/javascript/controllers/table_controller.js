import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.querySelectorAll("tr[data-href]").forEach(row => {
      row.addEventListener("click", this.navigate);
    });
  }

  navigate(event) {
    const url = event.currentTarget.dataset.href;
    Turbo.visit(url, { action: "replace" });
  }
}
