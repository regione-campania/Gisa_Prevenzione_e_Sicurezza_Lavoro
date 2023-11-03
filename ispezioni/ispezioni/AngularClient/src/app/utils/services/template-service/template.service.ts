import { Injectable } from "@angular/core";

@Injectable({
  providedIn: 'root'
})

export class TemplateService {
  select(selector: string) {
    return document.querySelector(selector);
  }

  selectAll(selector: string) {
    return document.querySelectorAll(selector);
  }
}
