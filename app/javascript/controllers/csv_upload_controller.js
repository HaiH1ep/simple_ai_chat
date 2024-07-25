import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="csv-upload"
export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.formTarget.action = "/import_csv/import_connections"
    this.formTarget.method = "post"
    this.formTarget.enctype = "multipart/form-data"
  }

  upload(event) {
    const file = event.target.files[0]
    if (file) {
      const fileNameElement = document.getElementById("file-name")
      fileNameElement.textContent = file.name
      document.getElementById("csv-preview").classList.remove("hidden")
    }
  }
}
