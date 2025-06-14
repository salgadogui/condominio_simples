import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["building", "apartment"]

  connect() {
    console.log("Apartments Stimulus Controller Connected")
  }

  async loadApartments() {
    const buildingId = this.buildingTarget.value;
    console.log(`Building selected: ${buildingId}`);

    if (!buildingId) {
      console.log("No building selected. Clearing apartments.");
      this.apartmentTarget.innerHTML = '<option value="">Selecione um apartamento/sala</option>';
      return;
    }

    try {
      const response = await fetch(`/contracts/apartments?building_id=${buildingId}`);
      if (!response.ok) throw new Error("Failed to fetch apartments");

      const apartments = await response.json();
      console.log("Fetched Apartments:", apartments);

      if (!this.apartmentTarget) {
        console.error("Apartment target not found!");
        return;
      }

      this.apartmentTarget.innerHTML = `<option value="">Selecione um apartamento/sala</option>` +
        apartments.map(apartment => 
          `<option value="${apartment.id}">${apartment.number}</option>`
        ).join('');
    } catch (error) {
      console.error("Error loading apartments:", error);
    }
  }
}

