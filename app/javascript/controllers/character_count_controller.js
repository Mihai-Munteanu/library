import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["input", "display"];
	static values = { max: Number };

	connect() {
		this.update();
	}

	update() {
		const length = this.inputTarget.value?.length || 0;
		const max = this.hasMaxValue ? this.maxValue : null;

		if (max) {
			this.displayTarget.textContent = `${length} / ${max} characters`;
			this.displayTarget.classList.toggle("text-red-600", length > max);
			this.displayTarget.classList.toggle("text-gray-500", length <= max);
		} else {
			this.displayTarget.textContent = `${length} characters`;
		}
	}
}
